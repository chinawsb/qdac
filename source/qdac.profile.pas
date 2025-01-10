﻿unit qdac.profile;

interface

{ QDAC 4.0 性能测量工具库
  1. 使用方式
  - 在函数的开始部分，增加 TQProfile.Calc('函数名称'); 调用
  - 对于 C++ Builder，可以直接简化为 CalcPerformance();
  2. 默认情况下，如果是 Debug 编译，会自动启用性能跟踪，Release 默认不启用
  3. 可以设置 TQProfile.Enabled 为 true 强制启用
  4. IDE 集成需要将来添加插件来支持，当前未实现
  5. 在启用性能测量模式下，程序退出前会保存测试结果到 profiles.json 文件中，也可以指定 TQProfile.FileName 来指定具体的文件路径
  6. 本工具库会为每个线程建立独立的管理对象，并且仅在程序退了时才会释放，所以不建议在发布给用户的版本中，长时间运行性能跟踪库。

}
uses Classes, Sysutils, System.Diagnostics, System.Generics.Defaults,
  System.Generics.Collections{$IFDEF MSWINDOWS},
  winapi.Windows, winapi.ActiveX, winapi.TlHelp32{$ENDIF};

type

  // 这个只是用来增加和减小引用计数使用，用户层调用 TQProfile.Calc 即可
  IQProfileHelper = interface
    ['{177F55CA-2B59-440B-AA81-54AFF6AC5581}']
  end;

  PQProfileStack = ^TQProfileStack;
  PQProfileReference = ^TQProfileReference;

  TQProfileReference = record
    Ref: PQProfileStack;
    Times: Cardinal;
    Prior, Next: PQProfileReference;
  end;

  TQProfileStack = record
    // 函数名称
    Name: String;
    // 上一级、前一个、下一个
    Parent, Prior, Next: PQProfileStack;
    // 嵌套级别，最大嵌套级别
    NestLevel, MaxNestLevel: Cardinal;
    //
    AddedRefCount: Integer;
    // 统计信息
    // 运行次数
    Runs: Cardinal;
    // 单个函数的最小时间、最大时间、总用时，平均时间为TotalTime/Runs的结果
    MinTime, MaxTime, TotalTime: UInt64;
    // 最后一次的开始和结束时间
    LastStartTime, LastStopTime: Int64;
    // 使用链表来管理子函数
    // 第一个子函数
    FirstChild: PQProfileStack;
    // 最后一个子函数
    LastChild: PQProfileStack;
    // 异步调用的引用管理
    FirstRef, LastRef: PQProfileReference;
  end;

  TQProfileCalcResult = record
    Counter: IQProfileHelper;
    Stack: PQProfileStack;
  end;

  TQProfileFunctionStatics = record
    Name: String;
    Threads: TArray<TThreadId>;
    MaxNestLevel: Cardinal;
    Runs: Cardinal;
    MinTime, MaxTime, TotalTime: UInt64;
  end;

  TQProfileThreadStatics = record
    ThreadId: TThreadId;
    FirstTime, LatestTime: UInt64;
    Functions: TArray<String>;
  end;

  TQProfileStatics = record
    Threads: TArray<TQProfileThreadStatics>;
    Functions: TArray<TQProfileFunctionStatics>;
  end;

  // 全局类，用于提供性能接口
  TQProfile = class sealed
  private
  class var
    FEnabled: Boolean;
    FFileName: String;
    FStartupTime: UInt64;

  type
    TQThreadProfileHelper = class(TInterfacedObject, IUnknown, IQProfileHelper)
    protected
      FRoot: TQProfileStack;
      FCurrent: PQProfileStack;
      FThreadId: TThreadId;
      FFirstTime, FLatestTime: UInt64;
      FThreadName: String;
    private
    public
      constructor Create; overload;
      destructor Destroy; override;
      function Push(const AName: String; AStackRef: PQProfileStack)
        : PQProfileStack; inline;
      function _Release: Integer; overload; stdcall;
      property ThreadId: TThreadId read FThreadId;
      property ThreadName: String read FThreadName;
      property FirstTime: UInt64 read FFirstTime;
      property LatestTime: UInt64 read FLatestTime;
    end;

    TQThreadHelperSet = class sealed
    protected
    class var
      FHelpers: TArray<TQThreadProfileHelper>;
      FCount: Integer;
    public
      class constructor Create;
      class procedure NeedHelper(const AThreadId: TThreadId;
        const AName: String; AStackRef: PQProfileStack;
        var AResult: TQProfileCalcResult);
    end;

    TQProfileStackHelper = record helper for TQProfileStack
      function Push(const AName: String; AStackRef: PQProfileStack)
        : PQProfileStack;
      function Pop: PQProfileStack;
      function ThreadHelper: TQProfile.TQThreadProfileHelper;
    end;

  protected
    class procedure SaveProfiles;
    class procedure Cleanup;
  public
    class constructor Create;
    class function AsString: String;
    class function AsDiagrams: String;
    class function GetStatics: TQProfileStatics;
    class procedure SaveDiagrams(const AFileName: String);
    class function Calc(const AName: String; AStackRef: PQProfileStack = nil)
      : TQProfileCalcResult;
    class property Enabled: Boolean read FEnabled write FEnabled;
    class property FileName: String read FFileName write FFileName;
  end;

  TQProfileTranslation = record
    Start, Thread: String;
  end;
{$HPPEMIT '#define CalcPerformance() TQProfile::Calc(__FUNC__)' }

var
  DiagramTranslation: TQProfileTranslation;

implementation

{$IFDEF MSWINDOWS}

type
  TGetThreadDescription = function(hThread: THandle;
    var ppszThreadDescription: PWideChar): HRESULT;

var
  GetThreadDescription: TGetThreadDescription;
function OpenThread(dwDesiredAccess: DWORD; bInheritHandle: BOOL;
  dwProcessId: DWORD): THandle; external kernel32 name 'OpenThread';
{$ENDIF}
{ TQProfile }

class function TQProfile.Calc(const AName: String; AStackRef: PQProfileStack)
  : TQProfileCalcResult;
begin
  if Enabled then
    TQThreadHelperSet.NeedHelper(TThread.Current.ThreadId, AName,
      AStackRef, Result)
  else
  begin
    Result.Counter := nil;
    Result.Stack := nil;
  end;
end;

class procedure TQProfile.Cleanup;
  procedure DoCleanup(AStack: PQProfileStack);
  var
    AChild, ANext: PQProfileStack;
    ARef, ANextRef: PQProfileReference;
  begin
    AChild := AStack.FirstChild;
    while Assigned(AChild) do
    begin
      ANext := AChild.Next;
      // 清空引用
      ARef := AChild.FirstRef;
      while Assigned(ARef) do
      begin
        ANextRef := ARef.Next;
        Dispose(ARef);
        ARef := ANextRef;
      end;
      if Assigned(AChild.FirstChild) then
        DoCleanup(AChild);
      if Assigned(AChild.Parent) then
        Dispose(AChild);
      AChild := ANext;
    end;
  end;

var
  I: Integer;
begin
  for I := 0 to High(TQThreadHelperSet.FHelpers) do
  begin
    if Assigned(TQThreadHelperSet.FHelpers[I]) then
    begin
      DoCleanup(@TQThreadHelperSet.FHelpers[I].FRoot);
      TQThreadHelperSet.FHelpers[I]._Release;
    end;
  end;
  SetLength(TQThreadHelperSet.FHelpers, 0);
end;

class constructor TQProfile.Create;
begin
  FEnabled := {$IFDEF DEBUG}true{$ELSE}false{$ENDIF};
  FFileName := ExtractFilePath(ParamStr(0)) + 'profiles.json';
  FStartupTime := TStopWatch.GetTimeStamp;
end;

class function TQProfile.GetStatics: TQProfileStatics;
var
  I, ACount: Integer;
  AComparer: IComparer<TQProfileFunctionStatics>;

  procedure DoBuild(AThreadId: TThreadId; AStack: PQProfileStack);
  var
    AItem: PQProfileStack;
    ANameArray: TArray<String>;
    ATemp: TQProfileFunctionStatics;
    I, J: Integer;
  begin
    AItem := AStack.FirstChild;
    while Assigned(AItem) do
    begin
      ANameArray := AItem.Name.Split(['#']);
      for I := 0 to High(ANameArray) do
      begin
        ATemp.Name := ANameArray[I];
        if not TArray.BinarySearch<TQProfileFunctionStatics>(Result.Functions,
          ATemp, J, AComparer) then
        begin
          ATemp.Threads := [AThreadId];
          ATemp.MaxNestLevel := AItem.MaxNestLevel;
          ATemp.Runs := AItem.Runs;
          ATemp.MinTime := AItem.MinTime;
          ATemp.MaxTime := AItem.MaxTime;
          ATemp.TotalTime := AItem.TotalTime;
          Insert(ATemp, Result.Functions, J);
        end
        else
        begin
          with Result.Functions[J] do
          begin
            if MaxNestLevel < AItem.MaxNestLevel then
              MaxNestLevel := AItem.MaxNestLevel;
            if MinTime > AItem.MinTime then
              MinTime := AItem.MinTime;
            if MaxTime < AItem.MaxTime then
              MaxTime := AItem.MaxTime;
            Inc(Runs, AItem.Runs);
            Inc(TotalTime, AItem.TotalTime);
            if not TArray.BinarySearch<TThreadId>(Threads, AThreadId, J) then
              Insert(AThreadId, Threads, J);
          end;
        end;
        // 查找线程的函数列表
        if not TArray.BinarySearch<String>(Result.Threads[ACount].Functions,
          ATemp.Name, J) then
          Insert(ATemp.Name, Result.Threads[ACount].Functions, J);
      end;
      DoBuild(AThreadId, AItem);
      AItem := AItem.Next;
    end;
  end;

begin
  SetLength(Result.Functions, 0);
  SetLength(Result.Threads, Length(TQThreadHelperSet.FHelpers));
  ACount := 0;
  AComparer := TComparer<TQProfileFunctionStatics>.Construct(
    function(const L, R: TQProfileFunctionStatics): Integer
    begin
      Result := CompareText(L.Name, R.Name);
    end);
  for I := 0 to High(TQThreadHelperSet.FHelpers) do
  begin
    if Assigned(TQThreadHelperSet.FHelpers[I]) then
    begin
      Result.Threads[ACount].ThreadId := TQThreadHelperSet.FHelpers[I].ThreadId;
      Result.Threads[ACount].FirstTime := TQThreadHelperSet.FHelpers[I]
        .FirstTime;
      Result.Threads[ACount].LatestTime := TQThreadHelperSet.FHelpers[I]
        .LatestTime;
      DoBuild(TQThreadHelperSet.FHelpers[I].ThreadId,
        @TQThreadHelperSet.FHelpers[I].FRoot);
      Inc(ACount);
    end;
  end;
  SetLength(Result.Threads, ACount);
end;

class procedure TQProfile.SaveDiagrams(const AFileName: String);
var
  AStream: TStringStream;
begin
  AStream := TStringStream.Create(AsDiagrams, TEncoding.UTF8);
  try
    AStream.SaveToFile(AFileName);
  finally
    FreeAndNil(AStream);
  end;
end;

class procedure TQProfile.SaveProfiles;
var
  AStream: TStringStream;
begin
  if Enabled then
  begin
    AStream := TStringStream.Create(AsString, TEncoding.UTF8);
    try
      AStream.SaveToFile(FileName);
    finally
      FreeAndNil(AStream);
    end;
  end;
end;

class function TQProfile.AsDiagrams: String;
var
  ABuilder: TStringBuilder;
  I: Integer;
  AStatics: TQProfileStatics;
  AComparer: IComparer<TQProfileFunctionStatics>;
  procedure AppendDiagram(AStack: PQProfileStack; AParentName: String);
  var
    ANameArray: TArray<String>;
    ARef: PQProfileReference;
    AItem: PQProfileStack;
    AFunctionEntry: TQProfileFunctionStatics;
    ASourceIdx, ATargetIdx, I: Integer;
    AFound: Boolean;
  begin
    ATargetIdx := 0;
    if Assigned(AStack.Parent) then
    begin
      // 我们以JSON格式来保存
      ANameArray := AStack.Name.Split(['#']);
      AFunctionEntry.Name := ANameArray[0];
      if TArray.BinarySearch<TQProfileFunctionStatics>(AStatics.Functions,
        AFunctionEntry, ATargetIdx, AComparer) then
      begin
        ABuilder.Append(AParentName).Append('-->fn').Append(ATargetIdx)
          .Append(SLineBreak);
        for I := 1 to High(ANameArray) do
        begin
          AFunctionEntry.Name := ANameArray[I];
          if TArray.BinarySearch<TQProfileFunctionStatics>(AStatics.Functions,
            AFunctionEntry, ASourceIdx, AComparer) then
            ABuilder.Append('fn').Append(ASourceIdx).Append('-.->fn')
              .Append(ATargetIdx).Append(SLineBreak);
        end;
      end;
      ARef := AStack.FirstRef;
      while Assigned(ARef) do
      begin
        if Length(ANameArray) > 1 then
        begin
          AFound := false;
          for I := 1 to High(ANameArray) do
          begin
            if ANameArray[I] = ARef.Ref.Name then
            begin
              AFound := true;
              break;
            end;
          end;
          if AFound then
            continue;
        end;
        AFunctionEntry.Name := ARef.Ref.Name;
        if TArray.BinarySearch<TQProfileFunctionStatics>(AStatics.Functions,
          AFunctionEntry, ASourceIdx, AComparer) then
          ABuilder.Append('fn').Append(ASourceIdx).Append('-.->fn')
            .Append(ATargetIdx).Append(SLineBreak);
        ARef := ARef.Next;
      end;
      AParentName := 'fn' + IntToStr(ATargetIdx)
    end;
    AItem := AStack.FirstChild;
    while Assigned(AItem) do
    begin
      AppendDiagram(AItem, AParentName);
      AItem := AItem.Next;
    end;
  end;

begin
  ABuilder := TStringBuilder.Create;
  try
    AStatics := GetStatics;
    AComparer := TComparer<TQProfileFunctionStatics>.Construct(
      function(const L, R: TQProfileFunctionStatics): Integer
      begin
        Result := CompareText(L.Name, R.Name);
      end);
    ABuilder.Append('flowchart TB').Append(SLineBreak);
    ABuilder.Append('start(("').Append(DiagramTranslation.Start).Append('"))')
      .Append(SLineBreak);
    // 插入线程结点
    for I := 0 to High(AStatics.Threads) do
    begin
      ABuilder.Append('thread').Append(AStatics.Threads[I].ThreadId)
        .Append('[["`').Append(DiagramTranslation.Thread).Append(' ')
        .Append(AStatics.Threads[I].ThreadId).Append(SLineBreak)
        .Append(AStatics.Threads[I].FirstTime - FStartupTime).Append('->')
        .Append(AStatics.Threads[I].LatestTime - FStartupTime).Append('`"]]')
        .Append(SLineBreak);
      ABuilder.Append('start-->thread').Append(AStatics.Threads[I].ThreadId)
        .Append(SLineBreak);
    end;
    // 插入函数名结点
    for I := 0 to High(AStatics.Functions) do
    begin
      ABuilder.Append('fn').Append(I).Append('(')
        .Append(AnsiQuotedStr(AStatics.Functions[I].Name, '"')).Append(')')
        .Append(SLineBreak);
    end;
    for I := 0 to High(TQThreadHelperSet.FHelpers) do
    begin
      if Assigned(TQThreadHelperSet.FHelpers[I]) then
      begin
        with TQThreadHelperSet.FHelpers[I] do
          AppendDiagram(@FRoot, 'thread' + IntToStr(ThreadId));
      end;
    end;
    Result := ABuilder.ToString;
  finally
    FreeAndNil(ABuilder);
  end;

end;

class function TQProfile.AsString: String;
var
  ABuilder: TStringBuilder;

  procedure AppendProfile(AIndent: String; AStack: PQProfileStack);
  var
    ANextIndent, AChildIndent: String;
    AItem: PQProfileStack;
    ARef: PQProfileReference;
    ANameArray: TArray<String>;
    I: Integer;
  begin
    ANextIndent := AIndent + '  ';
    if Assigned(AStack.Parent) then
    begin
      // 我们以JSON格式来保存
      ABuilder.Append(AIndent).Append('{').Append(SLineBreak);
      ANameArray := AStack.Name.Split(['#']);
      ABuilder.Append(ANextIndent).Append('"name":').Append('"')
        .Append(ANameArray[0]).Append('",').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"maxNestLevel":')
        .Append(AStack.MaxNestLevel).Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"runs":').Append(AStack.Runs)
        .Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"minTime":').Append(AStack.MinTime)
        .Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"maxTime":').Append(AStack.MaxTime)
        .Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"totalTime":')
        .Append(AStack.TotalTime).Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"avgTime":')
        .Append(FormatFloat('0.##', AStack.TotalTime / AStack.Runs));
      if Assigned(AStack.FirstChild) then
      begin
        ABuilder.Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"children":[').Append(SLineBreak);
        AChildIndent := ANextIndent + '  ';
        AItem := AStack.FirstChild;
        while Assigned(AItem) do
        begin
          AppendProfile(AChildIndent, AItem);
          AItem := AItem.Next;
          if Assigned(AItem) then
            ABuilder.Append(',').Append(SLineBreak)
          else
            ABuilder.Append(SLineBreak)
        end;
        ABuilder.Append(ANextIndent).Append(']');
      end;
      // 关联引用
      if Assigned(AStack.FirstRef) or (Length(ANameArray) > 1) then
      begin
        ABuilder.Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"refs":[').Append(SLineBreak);
        AChildIndent := ANextIndent + '  ';
        for I := 1 to High(ANameArray) do
        begin
          ABuilder.Append(AChildIndent).Append('"').Append(ANameArray[I])
            .Append('"');
          if (I < High(ANameArray)) or Assigned(AStack.FirstRef) then
            ABuilder.Append(',').Append(SLineBreak)
          else
            ABuilder.Append(SLineBreak);
        end;
        ARef := AStack.FirstRef;
        while Assigned(ARef) do
        begin
          ABuilder.Append(AChildIndent).Append('"').Append(ARef.Ref.Name)
            .Append('"');
          ARef := ARef.Next;
          if Assigned(ARef) then
            ABuilder.Append(',').Append(SLineBreak)
          else
            ABuilder.Append(SLineBreak)
        end;
        ABuilder.Append(ANextIndent).Append(']').Append(SLineBreak);
      end
      else
        ABuilder.Append(SLineBreak);
      ABuilder.Append(AIndent).Append('}');
    end
    else
    begin
      ABuilder.Append(AIndent).Append('{').Append(SLineBreak);
      with AStack.ThreadHelper do
      begin
        ABuilder.Append(ANextIndent).Append('"threadId":').Append(FThreadId)
          .Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"startTime":')
          .Append(FirstTime - FStartupTime).Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"latestTime":')
          .Append(LatestTime - FStartupTime).Append(',').Append(SLineBreak);
      end;
      ABuilder.Append(ANextIndent).Append('"chains":[').Append(SLineBreak);
      AChildIndent := ANextIndent + '  ';
      AItem := AStack.FirstChild;
      while Assigned(AItem) do
      begin
        AppendProfile(AChildIndent, AItem);
        AItem := AItem.Next;
        if Assigned(AItem) then
          ABuilder.Append(',').Append(SLineBreak)
        else
          ABuilder.Append(SLineBreak);
      end;
      ABuilder.Append(ANextIndent).Append(']').Append(SLineBreak);
      ABuilder.Append(AIndent).Append('}');
    end;
  end;

var
  I, ACount: Integer;
begin
  ACount := 0;
  ABuilder := TStringBuilder.Create;
  try
    ABuilder.Append('{').Append(SLineBreak);
    ABuilder.Append('"mainThreadId":').Append(MainThreadId).Append(',')
      .Append(SLineBreak);
    ABuilder.Append('"freq":').Append(TStopWatch.Frequency).Append(',')
      .Append(SLineBreak);
    ABuilder.Append('"threads":[').Append(SLineBreak);
    for I := 0 to High(TQThreadHelperSet.FHelpers) do
    begin
      if Assigned(TQThreadHelperSet.FHelpers[I]) then
      begin
        AppendProfile('  ', @TQThreadHelperSet.FHelpers[I].FRoot);
        Inc(ACount);
        if ACount < TQThreadHelperSet.FCount then
          ABuilder.Append(',').Append(SLineBreak)
        else
          ABuilder.Append(SLineBreak);
      end;
    end;
    ABuilder.Append('  ]').Append(SLineBreak);
    ABuilder.Append('}');
    Result := ABuilder.ToString;
  finally
    FreeAndNil(ABuilder);
  end;
end;

{ TQThreadProfileHelper }

constructor TQProfile.TQThreadProfileHelper.Create;
var
  pName: PWideChar;
{$IFDEF MSWINDOWS}
  AHandle: THandle;
const
  THREAD_QUERY_INFORMATION = $0040;
  function EnableDebugPrivilege: Boolean;
  var
    ATokenHandle: THandle;
    APrivileges: TTokenPrivileges;
    ADummy: DWORD;
  begin
    Result := false;
    if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or
      TOKEN_QUERY, ATokenHandle) then
    begin
      if LookupPrivilegeValue(nil, 'SeDebugPrivilege',
        APrivileges.Privileges[0].Luid) then
      begin
        APrivileges.PrivilegeCount := 1;
        APrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        if AdjustTokenPrivileges(ATokenHandle, false, APrivileges,
          SizeOf(APrivileges), nil, ADummy) then
          Result := GetLastError = ERROR_SUCCESS;
      end;
    end;
  end;
{$ENDIF}

begin
  FThreadId := TThread.CurrentThread.ThreadId;
{$IFDEF MSWINDOWS}
  pName := nil;
  if Assigned(GetThreadDescription) and EnableDebugPrivilege then
  begin
    AHandle := OpenThread(THREAD_QUERY_INFORMATION, false, FThreadId);
    if (AHandle <> 0) then
    begin
      if Succeeded(GetThreadDescription(AHandle, pName)) then
      begin
        FThreadName := pName;
        LocalFree(pName);
      end;
      CloseHandle(AHandle);
    end;
  end;
{$ENDIF}
  FCurrent := @FRoot;
  FCurrent.LastStartTime := TStopWatch.GetTimeStamp;
  FCurrent.NestLevel := 1;
  FFirstTime := FCurrent.LastStartTime;
end;

destructor TQProfile.TQThreadProfileHelper.Destroy;
begin

  inherited;
end;

function TQProfile.TQThreadProfileHelper.Push(const AName: String;
AStackRef: PQProfileStack): PQProfileStack;
begin
  FCurrent := FCurrent.Push(AName, AStackRef);
  Result := FCurrent;
end;

function TQProfile.TQThreadProfileHelper._Release: Integer;
begin
  Result := inherited _Release;
  if Result > 0 then
  begin
    // 如果是包含了额外的引用，则需要减少对应的计数后才真正移除
    if FCurrent.AddedRefCount > 0 then
      Dec(FCurrent.AddedRefCount)
    else
    begin
      Dec(FCurrent.NestLevel);
      if FCurrent.NestLevel = 0 then
      begin
        FCurrent := FCurrent.Pop;
        FLatestTime := TStopWatch.GetTimeStamp;
      end;
    end;
  end;
end;

{ TQProfileStackHelper }

function TQProfile.TQProfileStackHelper.Pop: PQProfileStack;
var
  ADelta: Int64;
begin
  if Assigned(Parent) then
    Result := Parent
  else
    // 匿名函数引用会增加额外的计数，造成统计不准，后面研究处理
    Result := @Self;
  LastStopTime := TStopWatch.GetTimeStamp;
  ADelta := LastStopTime - LastStartTime;
  if ADelta < 0 then
    ADelta := Int64($7FFFFFFFFFFFFFFF) - LastStartTime + LastStopTime;
  if ADelta > MaxTime then
    MaxTime := ADelta;
  if ADelta < MinTime then
    MinTime := ADelta;
  Inc(TotalTime, ADelta);
  Inc(Runs);
end;

function TQProfile.TQProfileStackHelper.Push(const AName: String;
AStackRef: PQProfileStack): PQProfileStack;
var
  AChild: PQProfileStack;
  procedure AddStackRef;
  var
    ARef: PQProfileReference;
  begin
    Inc(AChild.AddedRefCount);
    ARef := AChild.FirstRef;
    while Assigned(ARef) do
    begin
      if ARef.Ref = AStackRef then
      begin
        Inc(ARef.Times);
        Exit;
      end;
      ARef := ARef.Next;
    end;
    New(ARef);
    ARef.Prior := AChild.LastRef;
    ARef.Ref := AStackRef;
    ARef.Next := nil;
    ARef.Times := 1;
    if Assigned(AChild.LastRef) then
      AChild.LastRef.Next := ARef
    else
      AChild.FirstRef := ARef;
    AChild.LastRef := ARef;
  end;

begin
  if CompareText(Name, AName) = 0 then
  begin
    Inc(NestLevel);
    if NestLevel > MaxNestLevel then
      MaxNestLevel := NestLevel;
    Result := @Self;
  end
  else
  begin
    AChild := FirstChild;
    while Assigned(AChild) do
    begin
      if CompareText(AChild.Name, AName) = 0 then
      begin
        Inc(AChild.NestLevel);
        AChild.LastStartTime := TStopWatch.GetTimeStamp;
        AChild.LastStopTime := 0;
        if Assigned(AStackRef) then
          AddStackRef;
        Exit(AChild);
      end;
      AChild := AChild.Next;
    end;
    New(AChild);
    AChild.Name := AName;
    UniqueString(AChild.Name);
    AChild.Parent := @Self;
    AChild.Prior := LastChild;
    if Assigned(LastChild) then
      LastChild.Next := AChild
    else
      FirstChild := AChild;
    LastChild := AChild;
    AChild.Next := nil;
    AChild.NestLevel := 1;
    AChild.MaxNestLevel := 0;
    AChild.Runs := 0;
    AChild.MinTime := 0;
    AChild.MaxTime := 0;
    AChild.TotalTime := 0;
    AChild.LastStartTime := TStopWatch.GetTimeStamp;
    AChild.LastStopTime := 0;
    AChild.FirstChild := nil;
    AChild.LastChild := nil;
    AChild.AddedRefCount := 0;
    if Assigned(AStackRef) then
      AddStackRef
    else
    begin
      AChild.FirstRef := nil;
      AChild.LastRef := nil;
    end;
    Result := AChild;
  end;
end;

function TQProfile.TQProfileStackHelper.ThreadHelper
  : TQProfile.TQThreadProfileHelper;
var
  ARoot: PQProfileStack;
begin
  ARoot := @Self;
  Result := nil;
  while Assigned(ARoot.Parent) do
    ARoot := ARoot.Parent;
  Result := TQProfile.TQThreadProfileHelper
    (IntPtr(ARoot) - (IntPtr(@Result.FRoot) - IntPtr(Result)));
end;

{ TQThreadHelperSet }

class constructor TQProfile.TQThreadHelperSet.Create;
begin
  FCount := 0;
  FHelpers := [];
end;

class procedure TQProfile.TQThreadHelperSet.NeedHelper(const AThreadId
  : TThreadId; const AName: String; AStackRef: PQProfileStack;
var AResult: TQProfileCalcResult);
const
  BUCKET_MASK = Integer($80000000);
  BUCKET_INDEX_MASK = Integer($7FFFFFFF);
  function FindBucketIndex(AThreadId: TThreadId): Integer;
  var
    I, AHash: Integer;
    AItem: TQThreadProfileHelper;
  begin
    if Length(FHelpers) = 0 then
      Exit(BUCKET_MASK);
    AHash := Integer(AThreadId) mod Length(FHelpers);
    I := AHash;
    while I < Length(FHelpers) do
    begin
      AItem := FHelpers[I];
      if Assigned(AItem) then
      begin
        if AItem.ThreadId = AThreadId then
          Exit(I)
        else
          Inc(I);
      end
      else
        Exit(I or BUCKET_MASK);
    end;
    I := 0;
    while I < AHash do
    begin
      AItem := FHelpers[I];
      if Assigned(AItem) then
      begin
        if AItem.ThreadId = AThreadId then
          Exit(I)
        else
          Inc(I);
      end
      else
        break;
    end;
    Result := I or BUCKET_MASK;
  end;

  procedure Insert(var AHelpers: TArray<TQThreadProfileHelper>;
  AHelper: TQThreadProfileHelper);
  var
    ABucketIndex: Integer;
  begin
    ABucketIndex := FindBucketIndex(AHelper.ThreadId);
    if ABucketIndex < 0 then
      AHelpers[ABucketIndex and BUCKET_INDEX_MASK] := AHelper;
  end;

  procedure ReallocArray;
  var
    ANew: TArray<TQThreadProfileHelper>;
    I: Integer;
  begin
    case Length(FHelpers) of
      0:
        SetLength(ANew, 19);
      19:
        SetLength(ANew, 67);
      67:
        SetLength(ANew, 131);
      131:
        SetLength(ANew, 509);
      509:
        SetLength(ANew, 1021);
      1021:
        SetLength(ANew, 2039)
    else // 尽量质数，超过2039个线程就不管了，直接*2
      SetLength(ANew, Length(ANew) shl 1);
    end;
    for I := 0 to High(FHelpers) do
      Insert(ANew, FHelpers[I]);
    FHelpers := ANew;
  end;

  function FindExists: TQThreadProfileHelper;
  var
    ABucketIndex: Integer;
  begin
    Result := nil;
    GlobalNameSpace.BeginRead;
    ABucketIndex := FindBucketIndex(AThreadId);
    if ABucketIndex >= 0 then
      Result := FHelpers[ABucketIndex];
    GlobalNameSpace.EndRead;
  end;

  function InsertHelper: TQThreadProfileHelper;
  var
    ABucketIndex: Integer;
  begin
    GlobalNameSpace.BeginWrite;
    try
      if FCount = Length(FHelpers) then
        ReallocArray;
      ABucketIndex := FindBucketIndex(AThreadId);
      if ABucketIndex >= 0 then
        Result := FHelpers[ABucketIndex]
      else
      begin
        Result := TQThreadProfileHelper.Create;
        FHelpers[ABucketIndex and BUCKET_INDEX_MASK] := Result;
        Result._AddRef;
        Inc(FCount);
      end;
    finally
      GlobalNameSpace.EndWrite;
    end;
  end;

var
  AHelper: TQThreadProfileHelper;
begin
  AHelper := FindExists;
  if not Assigned(AHelper) then
    AHelper := InsertHelper;
  AResult.Counter := AHelper;
  AResult.Stack := AHelper.Push(AName, AStackRef);
end;

initialization

{$IFNDEF DEBUG}
  TQProfile.Enabled := FindCmdlineSwitch('EnableProfile');
{$ENDIF}
GetThreadDescription := GetProcAddress(GetModuleHandle(kernel32),
  'GetThreadDescription');
DiagramTranslation.Start := 'Start';
DiagramTranslation.Thread := 'Thread';

finalization

TQProfile.SaveProfiles;
TQProfile.Cleanup;

end.

unit qdac.profile;

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
uses Classes, Sysutils, System.Diagnostics{$IFDEF MSWINDOWS},
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

  // 全局类，用于提供性能接口
  TQProfile = class sealed
  private
  class var
    FEnabled: Boolean;
    FFileName: String;
  protected
    class procedure SaveProfiles;
  public
    class constructor Create;
    class destructor Destroy;
    class function AsString: String;
    class procedure SaveDegrams(const AFileName: String);
    class function Calc(const AName: String; AStackRef: PQProfileStack = nil)
      : TQProfileCalcResult;
    class property Enabled: Boolean read FEnabled write FEnabled;
    class property FileName: String read FFileName write FFileName;
  end;

{$HPPEMIT '#define CalcPerformance() TQProfile::Calc(__FUNC__)' }

implementation

type

  TQThreadProfileHelper = class(TInterfacedObject, IUnknown, IQProfileHelper)
  protected
    FRoot: TQProfileStack;
    FCurrent: PQProfileStack;
    FThreadId: TThreadId;
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
  end;

  TQThreadHelperSet = class sealed
  protected
  class var
    FHelpers: TArray<TQThreadProfileHelper>;
    FCount: Integer;
  public
    class constructor Create;
    class function NeedHelper(const AThreadId: TThreadId)
      : TQThreadProfileHelper;
  end;

  TQProfileStackHelper = record helper for TQProfileStack
    function Push(const AName: String; AStackRef: PQProfileStack)
      : PQProfileStack;
    function Pop: PQProfileStack;
    function ThreadHelper: TQThreadProfileHelper;
  end;

{$IFDEF MSWINDOWS}

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
const
  FLAG_HELPER_INITED: Int64 = $5555555555555555;
begin
  if Enabled then
  begin
    var
    AHelper := TQThreadHelperSet.NeedHelper(TThread.Current.ThreadId);
    Result.Counter := AHelper;
    Result.Stack := AHelper.Push(AName, AStackRef);
  end
  else
  begin
    Result.Counter := nil;
    Result.Stack := nil;
  end;
end;

class constructor TQProfile.Create;
begin
  FEnabled := {$IFDEF DEBUG}true{$ELSE}false{$ENDIF};
  FFileName := ExtractFilePath(ParamStr(0)) + 'profiles.json';
end;

class destructor TQProfile.Destroy;
  procedure Cleanup(AStack: PQProfileStack);
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
        Cleanup(AChild);
      if Assigned(AChild.Parent) then
        Dispose(AChild)
      else // Release on Calc create addref
        AChild.ThreadHelper._Release;
      AChild := ANext;
    end;
  end;

var
  I: Integer;
begin
  for I := 0 to High(TQThreadHelperSet.FHelpers) do
  begin
    if Assigned(TQThreadHelperSet.FHelpers[I]) then
      Cleanup(@TQThreadHelperSet.FHelpers[I].FRoot);
  end;
  SetLength(TQThreadHelperSet.FHelpers, 0);
end;

class procedure TQProfile.SaveDegrams(const AFileName: String);
begin
  //Todo:生成 mermaid 兼容格式的流程图
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


class function TQProfile.AsString: String;
var
  ABuilder: TStringBuilder;

  procedure AppendProfile(AIndent: String; AStack: PQProfileStack);
  var
    ANextIndent, AChildIndent: String;
    AItem: PQProfileStack;
    ARef: PQProfileReference;
  begin
    ANextIndent := AIndent + '  ';
    if Assigned(AStack.Parent) then
    begin
      // 我们以JSON格式来保存
      ABuilder.Append(AIndent).Append('{').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"name":').Append('"')
        .Append(AStack.Name).Append('",').Append(SLineBreak);
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
      if Assigned(AStack.FirstRef) then
      begin
        ABuilder.Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"refs":[').Append(SLineBreak);
        AChildIndent := ANextIndent + '  ';
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
        if FThreadId = MainThreadId then
        begin
          ABuilder.Append(ANextIndent).Append('"freq":')
            .Append(TStopWatch.Frequency).Append(',').Append(SLineBreak);
          ABuilder.Append(ANextIndent).Append('"mainThread":true,')
            .Append(SLineBreak);
        end;
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
    ABuilder.Append('[').Append(SLineBreak);
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
    ABuilder.Append(']');
    Result := ABuilder.ToString;
  finally
    FreeAndNil(ABuilder);
  end;
end;

{ TQThreadProfileHelper }

constructor TQThreadProfileHelper.Create;
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
end;

destructor TQThreadProfileHelper.Destroy;
begin

  inherited;
end;

function TQThreadProfileHelper.Push(const AName: String;
  AStackRef: PQProfileStack): PQProfileStack;
begin
  FCurrent := FCurrent.Push(AName, AStackRef);
  Result := FCurrent;
end;

function TQThreadProfileHelper._Release: Integer;
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
        FCurrent := FCurrent.Pop;
    end;
  end;
end;

{ TQProfileStackHelper }

function TQProfileStackHelper.Pop: PQProfileStack;
var
  ADelta: Int64;
begin
  if Assigned(Parent) then
    Result := Parent
  else // 匿名函数引用会增加额外的计数，造成统计不准，后面研究处理
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

function TQProfileStackHelper.Push(const AName: String;
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

function TQProfileStackHelper.ThreadHelper: TQThreadProfileHelper;
var
  ARoot: PQProfileStack;
begin
  ARoot := @Self;
  Result := nil;
  while Assigned(ARoot.Parent) do
    ARoot := ARoot.Parent;
  Result := TQThreadProfileHelper(IntPtr(ARoot) -
    (IntPtr(@Result.FRoot) - IntPtr(Result)));
end;

{ TQThreadHelperSet }

class constructor TQThreadHelperSet.Create;
begin
  FCount := 0;
  FHelpers := [];
end;

class function TQThreadHelperSet.NeedHelper(const AThreadId: TThreadId)
  : TQThreadProfileHelper;
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

begin
  Result := FindExists;
  if not Assigned(Result) then
    Result := InsertHelper;
end;

initialization
{$IFNDEF DEBUG}
TQProfile.Enabled:=FindCmdlineSwitch('EnableProfile');
{$ENDIF}
GetThreadDescription := GetProcAddress(GetModuleHandle(kernel32),
  'GetThreadDescription');

finalization

TQProfile.SaveProfiles;

end.

unit qdac.profile;

interface

// 使用中文回复
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
uses Classes, Sysutils, TimeSpan, Diagnostics, SyncObjs, Generics.Defaults,
  Generics.Collections;

type
  // 当退出函数时的计时回调，参数为函数执行所使用的毫秒数
  TQProfileTimeEscapeCallback = reference to procedure(const ATimeEscapedMs: Double);

  // 这个只是用来增加和减小引用计数使用，用户层调用 TQProfile.Calc 即可
  IQProfileHelper = interface
    ['{177F55CA-2B59-440B-AA81-54AFF6AC5581}']
    function CurrentStack: Pointer;
  end;

  PQProfileStack = ^TQProfileStack;
  PQProfileReference = ^TQProfileReference;

  // 引用信息记录
  TQProfileReference = record
    // 来源引用
    Ref: PQProfileStack;
    // 前一个，下一个
    Prior, Next: PQProfileReference;
  end;

  // 调用记录
  TQProfileStack = record
    // 函数名称
    Name: String;
    // 调用地址
    InvokeSource: Pointer;
    // 上一级、前一个、下一个
    Parent, Prior, Next: PQProfileStack;
    // 嵌套级别，最大嵌套级别
    NestLevel, MaxNestLevel: Cardinal;
    //
    AddedRefCount: Integer;
    // 回调
    AfterDone: TQProfileTimeEscapeCallback;
    // 统计信息
    // 运行次数
    Runs: Cardinal;
    // 单个函数的最小时间、最大时间、总用时，平均时间为TotalTime/Runs的结果
    MinTime, MaxTime, TotalTime: UInt64;
    // 首次开始时间，末次开始时间，末次结束时间
    FirstStartTime, LastStartTime, LastStopTime: Int64;
    // 使用链表来管理子函数
    // 第一个子函数
    FirstChild: PQProfileStack;
    // 最后一个子函数
    LastChild: PQProfileStack;
    // 异步调用的引用管理
    FirstRef, LastRef: PQProfileReference;
  end;

  PQProfileThreadStatics = ^TQProfileThreadStatics;

  // TQProfile.GetStatics 函数返回的线程统计信息
  TQProfileThreadStatics = record
    // 线程ID
    ThreadId: TThreadId;
    // 首次进入时间，末次结束时间
    FirstTime, LatestTime: UInt64;
    // 线程关联的函数列表
    Functions: TArray<String>;
  end;

  // TQProfile.GetStatics 函数返回的函数统计信息
  TQProfileFunctionStatics = record
    // 函数名称
    Name: String;
    // 函数调用来源线程列表
    Threads: TArray<PQProfileThreadStatics>;
    // 最大递归调用嵌套层数
    MaxNestLevel: Cardinal;
    // 函数运行次数
    Runs: Cardinal;
    // 函数运行的最小时长、最大时长和总时长
    MinTime, MaxTime, TotalTime: UInt64;
  end;

  // TQProfile.GetStatics的返回值
  TQProfileStatics = record
    // 线程统计信息
    Threads: TArray<TQProfileThreadStatics>;
    // 函数统计信息
    Functions: TArray<TQProfileFunctionStatics>;
  end;

  // 导出图表时的翻译字符串
  TQProfileTranslation = record
    Start, Thread: String;
  end;

  TAddressNameProc = function(const Addr: Pointer): String;

  TQProfileTimeUnit = (tuDefault, tuMilliSecond);

  // 全局类，用于提供性能接口
  TQProfile = class sealed
  private
  class var
    // 是否启用
    FEnabled: Boolean;
    // 退出时保存的跟踪记录信息JSON文件名
    FFileName: String;
    // 程序启动时间戳，用来和各个时间进行运算，以获取相对时间
    FStartupTime: UInt64;
    // 多线程同步锁
    FLocker: IReadWriteSync;
    // 耗时统计单位
    FTimeUnit: TQProfileTimeUnit;

  type
    TQThreadProfileHelper = class(TInterfacedObject, IInterface, IQProfileHelper)
    protected
      FRoot: TQProfileStack;
      FCurrent: PQProfileStack;
      FThreadId: TThreadId;
      FFirstTime, FLatestTime: UInt64;
      FThreadName: String;
    private
      function CurrentStack: Pointer;
    public
      constructor Create; overload;
      procedure Push(const AName: String; AStackRef: PQProfileStack; const Addr: Pointer); inline;
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
      class function NeedHelper(const AThreadId: TThreadId; const AName: String; AStackRef: PQProfileStack;
        const Addr: Pointer): IQProfileHelper;
    end;

    TQProfileStackHelper = record helper for TQProfileStack
      function Push(const AName: String; AStackRef: PQProfileStack; const Addr: Pointer): PQProfileStack;
      function Pop: PQProfileStack;
      function ThreadHelper: TQProfile.TQThreadProfileHelper;
    end;

  protected
    class procedure SaveProfiles; static;
    class procedure Cleanup;
    class function StackItemName(AStack: PQProfileStack): String; inline;
    class function EscapedText(const ADuration: UInt64): String;
    class function EscapedTimeMs(const ADuration: UInt64): Double;
    class function TickDiff(const AStart, AStop: UInt64): UInt64; inline;
  public
    class constructor Create;
    // 将跟踪记录转换为 JSON 字符串格式
    class function AsString: String;
    // 将跟踪记录转换为 mermaid 流程图格式
    class function AsDiagrams: String;
    // 对跟踪记录进行统计
    class function GetStatics: TQProfileStatics;
    // 保存跟踪记录为 mermaid 格式文件
    class procedure SaveDiagrams(const AFileName: String);
    /// <summary>记录一个锚点</summary>
    /// <param name="AName">锚点名称参数，一般为函数名</param>
    /// <param name="AStackRef">参考来源锚点，一般用于异步调用时，指向原始栈记录</param>
    /// <param name="ACallback">当函数执行完成时的回调，仅当次有效</param>
    /// <returns>如果 TQProfile.Enabled 为 true，返回当前线程的 IQProfileHelper 接口实例，否则返回空指针</returns>
    class function Calc(const AName: String; AStackRef: PQProfileStack = nil;
      ACallback: TQProfileTimeEscapeCallback = nil): IQProfileHelper; overload;
    /// <summary>记录一个锚点</summary>
    /// <param name="AStackRef">参考来源锚点，一般用于异步调用时，指向原始栈记录</param>
    /// <param name="ACallback">当函数执行完成时的回调，仅当次有效</param>
    /// <returns>如果 TQProfile.Enabled 为 true，返回当前线程的 IQProfileHelper 接口实例，否则返回空指针</returns>
    /// <remarks>
    /// 1.此函数只记录了地址，用户需要关联 AddressName 函数来解决地址与名称的映射问题
    /// 2.AddressName 可以使用 JclDebug 中的 GetLocationInfo 函数来做简单封装，具体参考示例
    /// </remarks>
    class function Calc(AStackRef: PQProfileStack = nil; ACallback: TQProfileTimeEscapeCallback = nil)
      : IQProfileHelper; overload;
    /// <summary>记录一个锚点</summary>
    /// <param name="ACallback">当函数执行完成时的回调，仅当次有效</param>
    /// <returns>如果 TQProfile.Enabled 为 true，返回当前线程的 IQProfileHelper 接口实例，否则返回空指针</returns>
    /// <remarks>
    /// 1.此函数只记录了地址，用户需要关联 AddressName 函数来解决地址与名称的映射问题
    /// 2.AddressName 可以使用 JclDebug 中的 GetLocationInfo 函数来做简单封装，具体参考示例
    /// </remarks>
    class function Calc(ACallback: TQProfileTimeEscapeCallback): IQProfileHelper; overload; inline;
    /// 当前是否启用了跟踪，只读，只能通过命令行开关 EnableProfile 修改或者使用默认值
    class property Enabled: Boolean read FEnabled;
    /// 要保存的跟踪记录文件名，默认为 profiles.json
    class property FileName: String read FFileName write FFileName;
    // 导出时，函数耗时的计时单位，默认不转换
    class property TimeUnit: TQProfileTimeUnit read FTimeUnit write FTimeUnit;
  public
  class var
    // 流程图中使用的字符串翻译
    Translation: TQProfileTranslation;
    AddressName: TAddressNameProc;
  end;

{$HPPEMIT '#define CalcPerformance() TQProfile::Calc(__FUNC__)' }

resourcestring
  SProfileDiagramStart = 'Start';
  SProfileDiagramThread = 'Thread';

implementation

{$IFDEF MSWINDOWS}

uses Windows;
function RtlCaptureStackBackTrace(FramesToSkip, FramesToCapture: DWORD; BackTrace: Pointer; BackTraceHash: PDWORD)
  : Word; stdcall; external kernel32;

{$ENDIF}
{$IFDEF POSIX}
{$I 'unwind.inc'}

// Posix 系统使用 _Unwind_Backtrace 来获取当前代码的地址
type
  TPosixStackItems = record
    MaxLevel, Skip, Count: Integer;
    Items: array [0 .. 63] of Pointer;
  end;

  PPosixStackItems = ^TPosixStackItems;

const
  _URC_NO_REASON = 1;
  _URC_NORMAL_STOP = 4;

function PosixTraceCallback(context: PUnwind_Context; p: Pointer): _Unwind_Reason_Code; cdecl;
var
  AStacks: PPosixStackItems;
begin
  AStacks := PPosixStackItems(p);
  if AStacks.MaxLevel > 0 then
  begin
    Dec(AStacks.MaxLevel);
    if AStacks.Skip <= AStacks.Count then
      AStacks.Items[AStacks.Count - AStacks.Skip] := _Unwind_GetIP(context);
    Inc(AStacks.Count);
  end;
  if AStacks.MaxLevel > 0 then
    Result := _URC_NO_REASON
  else
    Result := _URC_NORMAL_STOP;
end;

// 兼容实现
function RtlCaptureStackBackTrace(FramesToSkip, FramesToCapture: DWORD; BackTrace: Pointer;
  BackTraceHash: PDWORD): Word;
var
  AItems: TPosixStackItems;
begin
  AItems.MaxLevel := FramesToCapture + FramesToSkip;
  AItems.Skip := FramesToSkip;
  AItems.Count := 0;
  FillChar(AItems.Items, sizeof(AItems.Items), 0);
  _Unwind_Backtrace(PosixTraceCallback, @AItems);
  Result := AItem.Count;
end;
{$ENDIF}
{ TQProfile }

class function TQProfile.Calc(const AName: String; AStackRef: PQProfileStack; ACallback: TQProfileTimeEscapeCallback)
  : IQProfileHelper;
begin
  if Enabled then
  begin
    Result := TQThreadHelperSet.NeedHelper(TThread.Current.ThreadId, AName, AStackRef, nil);
    if Assigned(ACallback) then
      PQProfileStack(Result.CurrentStack).AfterDone := ACallback;
  end
  else
    Result := nil;
end;

class function TQProfile.Calc(AStackRef: PQProfileStack; ACallback: TQProfileTimeEscapeCallback): IQProfileHelper;
var
  Addr: Pointer;
begin
  Addr := nil;
  RtlCaptureStackBackTrace(1, 1, @Addr, nil);
  if Enabled then
  begin
    Result := TQThreadHelperSet.NeedHelper(TThread.Current.ThreadId, '', AStackRef, Addr);
    if Assigned(ACallback) then
      PQProfileStack(Result.CurrentStack).AfterDone := ACallback;
  end
  else
    Result := nil;
end;

class function TQProfile.Calc(ACallback: TQProfileTimeEscapeCallback): IQProfileHelper;
begin
  Result := Calc(nil, ACallback);
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
  FEnabled :=
{$IFDEF DEBUG}true{$ELSE}FindCmdlineSwitch('EnableProfile'){$ENDIF};
  Translation.Start := SProfileDiagramStart;
  Translation.Thread := SProfileDiagramThread;
  AddressName := nil;
  FFileName := ExtractFilePath(ParamStr(0)) + 'profiles.json';
  FStartupTime := TStopWatch.GetTimeStamp;
  FLocker := TMREWSync.Create;
end;

class function TQProfile.EscapedText(const ADuration: UInt64): String;
begin
  case TimeUnit of
    tuDefault:
      Result := IntToStr(ADuration);
    tuMilliSecond:
      Result := FormatFloat('0.######', EscapedTimeMs(ADuration))
  end;
end;

class function TQProfile.EscapedTimeMs(const ADuration: UInt64): Double;
begin
  if TStopWatch.IsHighResolution then
    Result := ADuration * (10000000.0 / TStopWatch.Frequency) / TTimeSpan.TicksPerMillisecond
  else
    Result := ADuration / TTimeSpan.TicksPerMillisecond;
end;

class function TQProfile.GetStatics: TQProfileStatics;
var
  I, ACount: Integer;
  AComparer: IComparer<TQProfileFunctionStatics>;

  procedure DoBuild(AThread: PQProfileThreadStatics; AStack: PQProfileStack);
  var
    AItem: PQProfileStack;
    ANameArray: TArray<String>;
    ATemp: TQProfileFunctionStatics;
    I, J: Integer;
  begin
    AItem := AStack.FirstChild;
    while Assigned(AItem) do
    begin
      ANameArray := StackItemName(AItem).Split(['#']);
      for I := 0 to High(ANameArray) do
      begin
        ATemp.Name := ANameArray[I];
        if not TArray.BinarySearch<TQProfileFunctionStatics>(Result.Functions, ATemp, J, AComparer) then
        begin
          ATemp.Threads := [AThread];
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
            if not TArray.BinarySearch<PQProfileThreadStatics>(Threads, AThread, J) then
              Insert(AThread, Threads, J);
          end;
        end;
        // 查找线程的函数列表
        if not TArray.BinarySearch<String>(Result.Threads[ACount].Functions, ATemp.Name, J) then
          Insert(ATemp.Name, Result.Threads[ACount].Functions, J);
      end;
      DoBuild(AThread, AItem);
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
      Result := CompareStr(L.Name, R.Name);
    end);
  for I := 0 to High(TQThreadHelperSet.FHelpers) do
  begin
    if Assigned(TQThreadHelperSet.FHelpers[I]) then
    begin
      Result.Threads[ACount].ThreadId := TQThreadHelperSet.FHelpers[I].ThreadId;
      Result.Threads[ACount].FirstTime := TQThreadHelperSet.FHelpers[I].FirstTime;
      Result.Threads[ACount].LatestTime := TQThreadHelperSet.FHelpers[I].LatestTime;
      DoBuild(@Result.Threads[ACount], @TQThreadHelperSet.FHelpers[I].FRoot);
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

class function TQProfile.StackItemName(AStack: PQProfileStack): String;
begin
  if (Length(AStack.Name) = 0) and Assigned(AStack.InvokeSource) then
  begin
    if Assigned(AddressName) then
      AStack.Name := AddressName(AStack.InvokeSource)
    else
      AStack.Name := IntToHex(IntPtr(AStack.InvokeSource));
  end;
  Result := AStack.Name;
end;

class function TQProfile.TickDiff(const AStart, AStop: UInt64): UInt64;
begin
  if AStop < AStart then
    Result := UInt64($7FFFFFFFFFFFFFFF) - AStop + AStart
  else
    Result := AStop - AStart;
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
      ANameArray := StackItemName(AStack).Split(['#']);
      AFunctionEntry.Name := ANameArray[0];
      if TArray.BinarySearch<TQProfileFunctionStatics>(AStatics.Functions, AFunctionEntry, ATargetIdx, AComparer) then
      begin
        ABuilder.Append(AParentName).Append('-->fn').Append(ATargetIdx).Append(SLineBreak);
        for I := 1 to High(ANameArray) do
        begin
          AFunctionEntry.Name := ANameArray[I];
          if TArray.BinarySearch<TQProfileFunctionStatics>(AStatics.Functions, AFunctionEntry, ASourceIdx, AComparer)
          then
            ABuilder.Append('fn').Append(ASourceIdx).Append('-.->fn').Append(ATargetIdx).Append(SLineBreak);
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
        if TArray.BinarySearch<TQProfileFunctionStatics>(AStatics.Functions, AFunctionEntry, ASourceIdx, AComparer) then
          ABuilder.Append('fn').Append(ASourceIdx).Append('-.->fn').Append(ATargetIdx).Append(SLineBreak);
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
    ABuilder.Append('start(("').Append(Translation.Start).Append('"))').Append(SLineBreak);
    // 插入线程结点
    for I := 0 to High(AStatics.Threads) do
    begin
      ABuilder.Append('thread').Append(AStatics.Threads[I].ThreadId).Append('[["`').Append(Translation.Thread)
        .Append(' ').Append(AStatics.Threads[I].ThreadId).Append(SLineBreak)
        .Append(EscapedText(TickDiff(FStartupTime, AStatics.Threads[I].FirstTime))).Append('->')
        .Append(EscapedText(TickDiff(FStartupTime, AStatics.Threads[I].LatestTime))).Append('`"]]').Append(SLineBreak);
      ABuilder.Append('start-->thread').Append(AStatics.Threads[I].ThreadId).Append(SLineBreak);
    end;
    // 插入函数名结点
    for I := 0 to High(AStatics.Functions) do
    begin
      ABuilder.Append('fn').Append(I).Append('(').Append(AnsiQuotedStr(AStatics.Functions[I].Name, '"')).Append(')')
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
      ANameArray := StackItemName(AStack).Split(['#']);
      ABuilder.Append(ANextIndent).Append('"name":').Append('"').Append(ANameArray[0]).Append('",').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"maxNestLevel":').Append(AStack.MaxNestLevel).Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"runs":').Append(AStack.Runs).Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"minTime":').Append(EscapedText(AStack.MinTime)).Append(',')
        .Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"maxTime":').Append(EscapedText(AStack.MaxTime)).Append(',')
        .Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"totalTime":').Append(EscapedText(AStack.TotalTime)).Append(',')
        .Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"avgTime":').Append(EscapedText(Trunc(AStack.TotalTime / AStack.Runs)))
        .Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"firstTime":')
        .Append(EscapedText(TickDiff(FStartupTime, AStack.FirstStartTime))).Append(',').Append(SLineBreak);
      ABuilder.Append(ANextIndent).Append('"lastStartTime":')
        .Append(EscapedText(TickDiff(FStartupTime, AStack.LastStartTime)));
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
          ABuilder.Append(AChildIndent).Append('"').Append(ANameArray[I]).Append('"');
          if (I < High(ANameArray)) or Assigned(AStack.FirstRef) then
            ABuilder.Append(',').Append(SLineBreak)
          else
            ABuilder.Append(SLineBreak);
        end;
        ARef := AStack.FirstRef;
        while Assigned(ARef) do
        begin
          ABuilder.Append(AChildIndent).Append('"').Append(ARef.Ref.Name).Append('"');
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
        ABuilder.Append(ANextIndent).Append('"threadId":').Append(FThreadId).Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"startTime":').Append(EscapedText(TickDiff(FStartupTime, FirstTime)))
          .Append(',').Append(SLineBreak);
        ABuilder.Append(ANextIndent).Append('"latestTime":').Append(EscapedText(TickDiff(FStartupTime, LatestTime)))
          .Append(',').Append(SLineBreak);
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
    ABuilder.Append('"mainThreadId":').Append(MainThreadId).Append(',').Append(SLineBreak);
    ABuilder.Append('"freq":').Append(TStopWatch.Frequency).Append(',').Append(SLineBreak);
    case TimeUnit of
      tuDefault:
        ABuilder.Append('"timeUnit":"default",').Append(SLineBreak);
      tuMilliSecond:
        ABuilder.Append('"timeUnit":"ms",').Append(SLineBreak);
    end;
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
begin
  FThreadId := TThread.CurrentThread.ThreadId;
  FCurrent := @FRoot;
  FCurrent.LastStartTime := TStopWatch.GetTimeStamp;
  FCurrent.NestLevel := 1;
  FFirstTime := FCurrent.LastStartTime;
end;

function TQProfile.TQThreadProfileHelper.CurrentStack: Pointer;
begin
  Result := FCurrent;
end;

procedure TQProfile.TQThreadProfileHelper.Push(const AName: String; AStackRef: PQProfileStack; const Addr: Pointer);
begin
  FCurrent := FCurrent.Push(AName, AStackRef, Addr);
end;

function TQProfile.TQThreadProfileHelper._Release: Integer;
begin
  Result := inherited _Release;
  if Result > 0 then
  begin
    // 如果是包含了额外的引用，则需要减少对应的计数后才真正移除
    if FCurrent.AddedRefCount > 0 then
      Dec(FCurrent.AddedRefCount);
    if FCurrent.AddedRefCount = 0 then
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
  ADelta := TickDiff(LastStartTime, LastStopTime);
  if Runs = 0 then
  begin
    MinTime := ADelta;
    MaxTime := ADelta;
  end
  else
  begin
    if ADelta > MaxTime then
      MaxTime := ADelta;
    if ADelta < MinTime then
      MinTime := ADelta;
  end;
  Inc(TotalTime, ADelta);
  Inc(Runs);
  if Assigned(AfterDone) then
  begin
    AfterDone(EscapedTimeMs(ADelta));
    AfterDone := nil;
  end;
end;

function TQProfile.TQProfileStackHelper.Push(const AName: String; AStackRef: PQProfileStack; const Addr: Pointer)
  : PQProfileStack;
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
        Exit;
      ARef := ARef.Next;
    end;
    New(ARef);
    ARef.Prior := AChild.LastRef;
    ARef.Ref := AStackRef;
    ARef.Next := nil;
    if Assigned(AChild.LastRef) then
      AChild.LastRef.Next := ARef
    else
      AChild.FirstRef := ARef;
    AChild.LastRef := ARef;
  end;

  function IsNest: Boolean;
  begin
    if Assigned(Addr) and (Addr = InvokeSource) then
      Exit(true)
    else if Length(AName) > 0 then
      Result := CompareStr(Name, AName) = 0
    else
      Result := false;
  end;

begin
  if IsNest then
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
      if AChild.InvokeSource = Addr then
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
    AChild.InvokeSource := Addr;
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
    AChild.FirstStartTime := TStopWatch.GetTimeStamp;
    AChild.LastStartTime := AChild.FirstStartTime;
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

function TQProfile.TQProfileStackHelper.ThreadHelper: TQProfile.TQThreadProfileHelper;
var
  ARoot: PQProfileStack;
begin
  ARoot := @Self;
  Result := nil;
  while Assigned(ARoot.Parent) do
    ARoot := ARoot.Parent;
  Result := TQProfile.TQThreadProfileHelper(IntPtr(ARoot) - (IntPtr(@Result.FRoot) - IntPtr(Result)));
end;

{ TQThreadHelperSet }

class constructor TQProfile.TQThreadHelperSet.Create;
begin
  FCount := 0;
  FHelpers := [];
end;

class function TQProfile.TQThreadHelperSet.NeedHelper(const AThreadId: TThreadId; const AName: String;
AStackRef: PQProfileStack; const Addr: Pointer): IQProfileHelper;
const
  BUCKET_MASK = Integer($80000000);
  BUCKET_INDEX_MASK = Integer($7FFFFFFF);
  function FindBucketIndex(const AHelpers: TArray<TQThreadProfileHelper>; AThreadId: TThreadId): Integer;
  var
    I, AHash: Integer;
    AItem: TQThreadProfileHelper;
  begin
    if Length(AHelpers) = 0 then
      Exit(BUCKET_MASK);
    AHash := Integer(AThreadId) mod Length(AHelpers);
    I := AHash;
    while I < Length(AHelpers) do
    begin
      AItem := AHelpers[I];
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
      AItem := AHelpers[I];
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

  function IsPrime(V: Integer): Boolean;
  var
    I, J: Integer;
  begin
    { 判断整数V是否为素数 }
    if V > 4 then
    begin
      { 初步筛选：排除2和3的倍数 }
      { 所有素数（除2、3外）均可表示为6k±1形式，因此非素数必被2或3整除 }
      Result := (V mod 2 <> 0) and (V mod 3 <> 0);

      if Result then
      begin
        { 计算最大需检查的因子范围：sqrt(V) }
        J := Trunc(sqrt(V));
        I := 5; { 从5开始检查6k±1形式的因子 }

        { 循环检查所有可能的6k±1因子 }
        { 例如：5(6*1-1)、7(6*1+1)、11(6*2-1)、13(6*2+1)... }
        while I <= J do
        begin
          { 同时检查I和I+2，对应6k-1和6k+1 }
          if (V mod I = 0) or (V mod (I + 2) = 0) then
            Exit(false); { 发现因子，直接返回非素数 }
          Inc(I, 6); { 步长6，跳转到下一组6k±1 }
        end;
      end;
    end
    else
    begin
      { 处理特殊情况：V ≤ 4 }
      { 仅有2和3是素数，其余（如4、1、0、负数）均非素数 }
      Result := V in [2, 3];
    end;
  end;
{
  2. **线程安全问题**

  **问题位置**：`TQThreadHelperSet.NeedHelper`中的`ReallocArray`。
  **问题描述**：重新分配`FHelpers`数组时，其他线程可能正在读取旧数组，导致访问越界或无效指针。

  **修复建议**：在`ReallocArray`过程中使用写锁（`FLocker.BeginWrite`）确保独占访问，防止并发修改。

}
  procedure ReallocArray;
  var
    ANew: TArray<TQThreadProfileHelper>;
    I, L: Integer;
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
    else
      // 尽量质数，超过2039个线程的话,我们每次最多只增加 4096 项
      begin
        I := Length(FHelpers) + 1;
        L := Length(FHelpers) + 4096;
        while (L >= I) and (not IsPrime(L)) do
          Dec(L);
        if I >= L then
        begin
          L := (Length(FHelpers) shl 1) + 1;
          while not IsPrime(L) do
            Inc(L);
        end;
        SetLength(ANew, L);
      end;
    end;
    for I := 0 to High(FHelpers) do
      ANew[FindBucketIndex(ANew, FHelpers[I].ThreadId) and BUCKET_INDEX_MASK] := FHelpers[I];
    FHelpers := ANew;
  end;

  function FindExists: TQThreadProfileHelper;
  var
    ABucketIndex: Integer;
  begin
    Result := nil;
    FLocker.BeginRead;
    ABucketIndex := FindBucketIndex(FHelpers, AThreadId);
    if ABucketIndex >= 0 then
      Result := FHelpers[ABucketIndex];
    FLocker.EndRead;
  end;

  function InsertHelper: TQThreadProfileHelper;
  var
    ABucketIndex: Integer;
  begin
    FLocker.BeginWrite;
    try
      if FCount = Length(FHelpers) then
        ReallocArray;
      ABucketIndex := FindBucketIndex(FHelpers, AThreadId);
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
      FLocker.EndWrite;
    end;
  end;

var
  AHelper: TQThreadProfileHelper;
begin
  AHelper := FindExists;
  if not Assigned(AHelper) then
    AHelper := InsertHelper;
  AHelper.Push(AName, AStackRef, Addr);
  Result := AHelper;
end;

initialization

AddExitProc(TQProfile.SaveProfiles);

finalization

TQProfile.Cleanup;

end.

(* ************ Find Bugs ***************
  以下是代码中可能存在的bug及其解释：

  3. **POSIX堆栈追踪错误**

  **问题位置**：`RtlCaptureStackBackTrace`的POSIX实现。

  **问题描述**：`PosixTraceCallback`中`AStacks.MaxLevel`递减逻辑错误，导致获取的堆栈层级不正确。此外，`Result := AItem.Count`应为`Result :=
  AItems.Count`，存在变量名拼写错误。
  **修复建议**：修正变量名，并调整层级计数逻辑，确保正确捕获堆栈地址。

  4. **递归调用判断错误**

  **问题位置**：`TQProfileStackHelper.Push`中的`IsNest`函数。
  **问题描述**：当`AName`为空时，仅通过地址判断递归可能导致误判，尤其是在动态生成代码或不同函数共享地址的情况下。

  **修复建议**：同时检查函数名和地址的匹配，确保递归判断更准确。

  5. **引用计数管理错误**
  **问题位置**：`TQThreadProfileHelper._Release`方法。

  **问题描述**：在减少`AddedRefCount`后未正确处理所有引用情况，可能导致嵌套层级过早减少，影响统计结果。
  **修复建议**：确保仅在所有引用释放后才减少`NestLevel`，并正确更新父栈。

  6.
  **数组处理错误**
  **问题位置**：`TQProfile.GetStatics`中的`TArray.BinarySearch`使用。
  **问题描述**：函数统计数组可能未正确排序，导致二分查找失败，插入位置错误。

  **修复建议**：在插入前确保数组已按名称排序，或改用字典结构提高查找效率。

  7. **时间差计算错误**
  **问题位置**：`TQProfile.TickDiff`函数。

  **问题描述**：当时间戳回绕时，计算逻辑可能返回错误差值。假设时间戳为64位，实际无需处理回绕，直接相减即可。
  **修复建议**：简化计算为`Result := AStop -
  AStart`，因为`UInt64`差值天然处理回绕。

  **其他潜在问题**：
  - **字符串分割问题**：`StackItemName`使用`Split(['#'])`，若函数名包含`#`可能导致统计分组错误。
  -
  **回调函数安全**：`AfterDone`回调可能被覆盖，尤其在异步调用中，导致部分回调未触发。建议使用列表管理多个回调。
  -
  **线程ID哈希冲突**：使用`Integer(AThreadId)`可能导致哈希冲突，建议改用更大的类型（如`NativeInt`）计算哈希值。

  **总结**：这段代码在内存管理、线程安全、递归判断和平台兼容性方面存在较多潜在问题，需逐一验证并修正，以确保性能分析工具的准确性和稳定性。
*)

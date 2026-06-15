unit qdac.profile.sampling;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults, System.Math, System.SyncObjs, System.Diagnostics, Winapi.Windows, Winapi.TlHelp32,
  qdac.profile.base;

type
  TQSampleFunctionStat = record
    Address: Pointer;
    HitCount: Int64;
    Name: string;
  end;

  TQSamplingProfiler = class(TQProfileBase)
  private
    class var
      FEnabled: Boolean;
      FAutoStart: Boolean;
      FAutoSave: Boolean;
      FSampleInterval: Cardinal;
      FMaxFrames: Integer;
      FFileName: string;
      FSamplerThread: TThread;
      FLock: TCriticalSection;
      FAddressCounts: TDictionary<Pointer, Int64>;
      FTotalSamples: Int64;
      FSymReady: Boolean;
      FProcessHandle: THandle;
      FMainModuleBase: ULONG64;
      FMainModuleSize: DWORD;
      FFilterModules: Boolean;

    class procedure EnsureSymInit; static;
    class procedure SamplerExecute; static;
  public
  private
    class procedure SetEnabledProc(const Value: Boolean); static;
    class procedure SetFileNameProc(const Value: string); static;
  private
    class function IsInMainModule(Addr: Pointer): Boolean; static;
  public
    // TQProfileBase — 公共状态（虚方法，供基类 SaveToFile 调用）
    class function GetEnabled: Boolean; override;
    class function GetFileName: string; override;
    // 供 Users 直接调用的属性（读写 class var + 静态访问器）
    class property Enabled: Boolean read FEnabled write SetEnabledProc;
    class property FileName: string read FFileName write SetFileNameProc;
    class property AutoStart: Boolean read FAutoStart write FAutoStart;
    class property AutoSave: Boolean read FAutoSave write FAutoSave;
    class property SampleIntervalMs: Cardinal read FSampleInterval write FSampleInterval;
    class property MaxFrames: Integer read FMaxFrames write FMaxFrames;
    /// <summary>
    ///   是否只统计主模块（EXE）地址，过滤系统 DLL。
    ///   默认 True：只统计自己的代码，不统计 ntdll/kernel32 等系统模块。
    /// </summary>
    class property FilterSystemModules: Boolean read FFilterModules write FFilterModules;
    class function Report: string; override;
    class function ReportJson: string; override;
    class procedure SaveOnExit;
    class procedure Reset; override;
    class constructor Create;
    class destructor Destroy;
  end;

implementation

procedure SamplingExitProc; forward;

const
  MAX_TOTAL_SAMPLES = 500000;
  GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS = $00000004;
  IMAGE_FILE_MACHINE_I386 = $014C;
  IMAGE_FILE_MACHINE_AMD64 = $8664;
  THREAD_SUSPEND_RESUME = $0002;
  THREAD_GET_CONTEXT = $0008;
  THREAD_QUERY_INFORMATION = $0040;
  AddrModeFlat = 3;

type
  TAddress64 = record
    Offset: DWORD64;
    Segment: Word;
    Mode: Word;
  end;

  TKdHelp64 = record
    Thread: DWORD64;
    ThCallbackStack: DWORD;
    ThCallbackBStore: DWORD;
    NextCallback: DWORD;
    FramePointerOwner: DWORD;
  end;

  PStackFrame64 = ^TStackFrame64;
  TStackFrame64 = record
    AddrPC: TAddress64;
    AddrReturn: TAddress64;
    AddrFrame: TAddress64;
    AddrStack: TAddress64;
    AddrBStore: TAddress64;
    FuncTableEntry: Pointer;
    Params: array[0..3] of DWORD64;
    Far: BOOL;
    Virtual: BOOL;
    Reserved: array[0..2] of DWORD64;
    KdHelp: TKdHelp64;
  end;

  TSymbolInfoBuf = packed record
    SizeOfStruct: ULONG;
    TypeIndex: ULONG;
    Reserved: array[0..1] of ULONG64;
    Index: ULONG;
    Size: ULONG;
    ModBase: ULONG64;
    Flags: ULONG;
    Value: ULONG64;
    Address: ULONG64;
    Register_: ULONG;
    Scope: ULONG;
    Tag: ULONG;
    NameLen: ULONG;
    MaxNameLen: ULONG;
    Name: array[0..0] of AnsiChar;
  end;
  PSymbolInfoBuf = ^TSymbolInfoBuf;

  TSymbolInfoAlloc = record
    Info: TSymbolInfoBuf;
    NameExtra: array[0..1024] of AnsiChar;
  end;

// ---- dbghelp.dll ----

function SymInitialize(
    hProcess: THandle;
    UserSearchPath: PWideChar;
    fInvadeProcess: BOOL
): BOOL; stdcall; external 'dbghelp.dll';
function SymFromAddr(
    hProcess: THandle;
    Address: UInt64;
    Displacement: PDWORD;
    Symbol: PSymbolInfoBuf
): BOOL; stdcall; external 'dbghelp.dll' name 'SymFromAddr';
function StackWalk64(
    MachineType: DWORD;
    hProcess: THandle;
    hThread: THandle;
    StackFrame: PStackFrame64;
    ContextRecord: Pointer;
    ReadMemoryRoutine: Pointer;
    FunctionTableAccessRoutine: Pointer;
    GetModuleBaseRoutine: Pointer;
    TranslateAddress: Pointer
): BOOL; stdcall; external 'dbghelp.dll' name 'StackWalk64';
function SymFunctionTableAccess64(
    hProcess: THandle;
    AddrBase: DWORD64
): Pointer; stdcall; external 'dbghelp.dll' name 'SymFunctionTableAccess64';
function SymGetModuleBase64(
    hProcess: THandle;
    AddrBase: DWORD64
): DWORD64; stdcall; external 'dbghelp.dll' name 'SymGetModuleBase64';

// ---- kernel32.dll ----

function GetModuleHandleExW(
    dwFlags: DWORD;
    lpModuleName: PWideChar;
    phModule: PHMODULE
): BOOL; stdcall; external 'kernel32.dll';
function GetModuleFileNameW(
    hModule: HMODULE;
    lpFilename: PWideChar;
    nSize: DWORD
): DWORD; stdcall; external 'kernel32.dll';
function OpenThread(
    dwDesiredAccess: DWORD;
    bInheritHandle: BOOL;
    dwThreadId: DWORD
): THandle; stdcall; external 'kernel32.dll';

// ---- 工具函数（必须在使用前声明） ----

function ResolveName(Addr: Pointer; AProcessHandle: THandle; ASymReady: Boolean): string;
var
  Buf: TSymbolInfoAlloc;
  Displacement: DWORD;
  ModName: array[0..MAX_PATH] of Char;
  hMod: HMODULE;
  P: Integer;
begin
  if not ASymReady then
    Exit(IntToHex(NativeUInt(Addr)));

  FillChar(Buf, SizeOf(Buf), 0);
  Buf.Info.SizeOfStruct := SizeOf(TSymbolInfoBuf);
  Buf.Info.MaxNameLen := 1025;
  Displacement := 0;

  if SymFromAddr(AProcessHandle, NativeUInt(Addr), @Displacement, @Buf) then begin
    Result := string(AnsiString(PAnsiChar(@Buf.Info.Name)));
    P := Pos('.', Result);
    if P > 0 then
      Delete(Result, 1, P);
    Exit;
  end;

  if GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS, PWideChar(Addr), @hMod) and (hMod <> 0) then begin
    if GetModuleFileNameW(hMod, ModName, MAX_PATH) > 0 then
      Result := Format('%s+$%x', [ExtractFileName(string(ModName)), NativeUInt(Addr)])
    else
      Result := IntToHex(NativeUInt(Addr));
  end
  else
    Result := IntToHex(NativeUInt(Addr));
end;

procedure CaptureStackByThread(
    AThreadId: DWORD;
    AProcessHandle: THandle;
    AMaxFrames: Integer;
    var Frames: TArray<Pointer>;
    out FrameCount: Integer
);
var
  hThread: THandle;
  Ctx: TContext;
  Frame: TStackFrame64;
  MachineType: DWORD;
begin
  FrameCount := 0;
  SetLength(Frames, AMaxFrames);

  hThread := OpenThread(THREAD_SUSPEND_RESUME or THREAD_GET_CONTEXT or THREAD_QUERY_INFORMATION, False, AThreadId);
  if hThread = 0 then
    Exit;

  if SuspendThread(hThread) = DWORD(-1) then begin
    CloseHandle(hThread);
    Exit;
  end;

  FillChar(Ctx, SizeOf(Ctx), 0);
  Ctx.ContextFlags := CONTEXT_FULL;
  if not GetThreadContext(hThread, Ctx) then begin
    ResumeThread(hThread);
    CloseHandle(hThread);
    Exit;
  end;

  FillChar(Frame, SizeOf(Frame), 0);
{$IFDEF WIN32}
  MachineType := IMAGE_FILE_MACHINE_I386;
  Frame.AddrPC.Offset := Ctx.Eip;
  Frame.AddrFrame.Offset := Ctx.Ebp;
  Frame.AddrStack.Offset := Ctx.Esp;
{$ELSE}
  MachineType := IMAGE_FILE_MACHINE_AMD64;
  Frame.AddrPC.Offset := Ctx.Rip;
  Frame.AddrFrame.Offset := Ctx.Rbp;
  Frame.AddrStack.Offset := Ctx.Rsp;
{$ENDIF}
  Frame.AddrPC.Mode := AddrModeFlat;
  Frame.AddrFrame.Mode := AddrModeFlat;
  Frame.AddrStack.Mode := AddrModeFlat;

  while FrameCount < AMaxFrames do begin
    if not StackWalk64(
        MachineType,
        AProcessHandle,
        hThread,
        @Frame,
        @Ctx,
        nil,
        @SymFunctionTableAccess64,
        @SymGetModuleBase64,
        nil) then
      Break;
    if Frame.AddrPC.Offset = 0 then
      Break;
    Frames[FrameCount] := Pointer(Frame.AddrPC.Offset);
    Inc(FrameCount);
  end;

  ResumeThread(hThread);
  CloseHandle(hThread);
end;

{ TQSamplingProfiler }

class constructor TQSamplingProfiler.Create;
var
  DosHdr: PImageDosHeader;
  NtHdrs: PImageNtHeaders;
begin
  FAutoStart := False;
  FAutoSave := False;
  FEnabled := False;
  FSampleInterval := 10;
  FMaxFrames := 32;
  FFileName := ExtractFilePath(ParamStr(0)) + 'samples.json';
  FLock := TCriticalSection.Create;
  FAddressCounts := TDictionary<Pointer, Int64>.Create;
  FTotalSamples := 0;
  FProcessHandle := GetCurrentProcess;
  FSymReady := False;
  FSamplerThread := nil;
  FFilterModules := True;
  // 获取主模块基址和大小（用于报告时过滤系统模块）
  // 从 PE 头读取 SizeOfImage
  FMainModuleBase := ULONG64(GetModuleHandle(nil));
  if FMainModuleBase <> 0 then begin
    DosHdr := PImageDosHeader(FMainModuleBase);
    if (DosHdr.e_magic = IMAGE_DOS_SIGNATURE) and (DosHdr._lfanew <> 0) then begin
      NtHdrs := PImageNtHeaders(FMainModuleBase + DosHdr._lfanew);
      if NtHdrs.Signature = IMAGE_NT_SIGNATURE then begin
        FMainModuleSize := NtHdrs.OptionalHeader.SizeOfImage;
        if FMainModuleSize = 0 then
          FMainModuleSize := $10000000; // fallback
      end;
    end;
  end;
end;

class destructor TQSamplingProfiler.Destroy;
begin
  SetEnabledProc(False);
  FreeAndNil(FAddressCounts);
  FreeAndNil(FLock);
end;

class function TQSamplingProfiler.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

class procedure TQSamplingProfiler.SetEnabledProc(const Value: Boolean);
begin
  if FEnabled = Value then
    Exit;
  FEnabled := Value;
  if FEnabled then begin
    EnsureSymInit;
    FSamplerThread := TThread.CreateAnonymousThread(SamplerExecute);
    FSamplerThread.FreeOnTerminate := False;
    FSamplerThread.Start;
  end
  else if Assigned(FSamplerThread) then begin
    FSamplerThread.Terminate;
    FSamplerThread.WaitFor;
    FreeAndNil(FSamplerThread);
  end;
end;

class procedure TQSamplingProfiler.EnsureSymInit;
begin
  if not FSymReady then begin
    FSymReady := SymInitialize(FProcessHandle, nil, True);
    if not FSymReady then
      FSymReady := GetLastError <> ERROR_INVALID_PARAMETER;
  end;
end;

class function TQSamplingProfiler.IsInMainModule(Addr: Pointer): Boolean;
var
  V: ULONG64;
begin
  V := ULONG64(Addr);
  Result := (V >= FMainModuleBase) and (V < FMainModuleBase + FMainModuleSize);
end;

class function TQSamplingProfiler.Report: string;
var
  SB: TStringBuilder;
  List: TList<TQSampleFunctionStat>;
  Item: TQSampleFunctionStat;
  Pair: TPair<Pointer, Int64>;
  I: Integer;
  TotalHits: Int64;
  Pct: Double;
begin
  SB := TStringBuilder.Create;
  try
    SB.AppendLine('=== TQSamplingProfiler Report ===');
    SB
        .Append('Total unique addresses: ')
        .Append(FAddressCounts.Count)
        .Append(', total samples: ')
        .Append(FTotalSamples)
        .AppendLine;

    TotalHits := 0;
    for Pair in FAddressCounts do begin
      if not FFilterModules or IsInMainModule(Pair.Key) then
        Inc(TotalHits, Pair.Value);
    end;

    if TotalHits = 0 then
      Exit('(no samples collected)');

    List := TList<TQSampleFunctionStat>.Create;
    try
      for Pair in FAddressCounts do begin
        if FFilterModules and not IsInMainModule(Pair.Key) then
          Continue;
        Item.Address := Pair.Key;
        Item.HitCount := Pair.Value;
        Item.Name := ResolveName(Pair.Key, FProcessHandle, FSymReady);
        List.Add(Item);
      end;
      if List.Count = 0 then
        Exit('(no samples collected)');
      List.Sort(
          TComparer<TQSampleFunctionStat>.Construct(
              function(const L, R: TQSampleFunctionStat): Integer
              begin
                Result := -CompareValue(L.HitCount, R.HitCount);
              end
          )
      );

      SB.AppendLine;
      SB.AppendLine('Top functions by hit count:');
      SB.AppendLine('  Hits   %     Function');
      SB.AppendLine('  ' + StringOfChar('-', 60));

      for I := 0 to Min(List.Count - 1, 50) do begin
        Item := List[I];
        Pct := Item.HitCount / TotalHits * 100;
        SB.AppendFormat('  %5d  %5.1f%%  %s', [Item.HitCount, Pct, Item.Name]);
        SB.AppendLine;
      end;
    finally
      List.Free;
    end;

    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TQSamplingProfiler.ReportJson: string;
var
  SB: TStringBuilder;
  List: TList<TQSampleFunctionStat>;
  Item: TQSampleFunctionStat;
  Pair: TPair<Pointer, Int64>;
  I: Integer;
  TotalHits: Int64;
begin
  SB := TStringBuilder.Create;
  try
    TotalHits := 0;
    for Pair in FAddressCounts do begin
      if not FFilterModules or IsInMainModule(Pair.Key) then
        Inc(TotalHits, Pair.Value);
    end;

    List := TList<TQSampleFunctionStat>.Create;
    try
      for Pair in FAddressCounts do begin
        if FFilterModules and not IsInMainModule(Pair.Key) then
          Continue;
        Item.Address := Pair.Key;
        Item.HitCount := Pair.Value;
        Item.Name := ResolveName(Pair.Key, FProcessHandle, FSymReady);
        List.Add(Item);
      end;
      List.Sort(
          TComparer<TQSampleFunctionStat>.Construct(
              function(const L, R: TQSampleFunctionStat): Integer
              begin
                Result := -CompareValue(L.HitCount, R.HitCount);
              end
          )
      );

      SB.AppendLine('{');
      SB.Append('  "filterSystemModules": ').Append(FFilterModules.ToString).Append(',').AppendLine;
      SB.Append('  "mainModuleBase": "').Append(IntToHex(FMainModuleBase, 8)).Append('",').AppendLine;
      SB.Append('  "mainModuleSize": ').Append(FMainModuleSize).Append(',').AppendLine;
      SB.Append('  "sampleIntervalMs": ').Append(FSampleInterval).Append(',').AppendLine;
      SB.Append('  "totalSamples": ').Append(FTotalSamples).Append(',').AppendLine;
      SB.Append('  "totalFunctions": ').Append(List.Count).Append(',').AppendLine;
      SB.Append('  "totalHits": ').Append(TotalHits).Append(',').AppendLine;
      SB.AppendLine('  "functions": [');
      for I := 0 to List.Count - 1 do begin
        Item := List[I];
        SB
            .Append('    {"addr":"')
            .Append(IntToHex(NativeUInt(Item.Address)))
            .Append('","name":"')
            .Append(Item.Name)
            .Append('","hits":')
            .Append(Item.HitCount)
            .Append(',"pct":')
            .Append(FormatFloat('0.00', Item.HitCount / TotalHits * 100))
            .Append('"}');
        if I < List.Count - 1 then
          SB.Append(',');
        SB.AppendLine;
      end;
      SB.AppendLine('  ]');
      SB.AppendLine('}');
    finally
      List.Free;
    end;

    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class procedure TQSamplingProfiler.Reset;
begin
  FLock.Enter;
  try
    FAddressCounts.Clear;
    FTotalSamples := 0;
  finally
    FLock.Leave;
  end;
end;

class function TQSamplingProfiler.GetFileName: string;
begin
  Result := FFileName;
end;

class procedure TQSamplingProfiler.SetFileNameProc(const Value: string);
begin
  FFileName := Value;
end;

class procedure TQSamplingProfiler.SaveOnExit;
begin
  if FAutoSave and (FTotalSamples > 0) then
    SaveToFile;
end;

class procedure TQSamplingProfiler.SamplerExecute;
var
  Snap: THandle;
  TE: TThreadEntry32;
  TIDs: TArray<DWORD>;
  Count, I, J, FrameCount: Integer;
  Frames: TArray<Pointer>;
  Value: Int64;
begin
  while FEnabled and (FTotalSamples < MAX_TOTAL_SAMPLES) do begin
    Sleep(FSampleInterval);

    Snap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if Snap = INVALID_HANDLE_VALUE then
      Continue;

    TE.dwSize := SizeOf(TE);
    Count := 0;
    SetLength(TIDs, 64);

    if Thread32First(Snap, TE) then begin
      repeat
        if TE.th32OwnerProcessID = GetCurrentProcessId then begin
          if Count >= Length(TIDs) then
            SetLength(TIDs, Length(TIDs) * 2);
          TIDs[Count] := TE.th32ThreadID;
          Inc(Count);
        end;
      until not Thread32Next(Snap, TE);
    end;
    CloseHandle(Snap);
    SetLength(TIDs, Count);

    for I := 0 to High(TIDs) do begin
      if TIDs[I] = GetCurrentThreadId then
        Continue;

      CaptureStackByThread(TIDs[I], FProcessHandle, FMaxFrames, Frames, FrameCount);
      if FrameCount = 0 then
        Continue;

      FLock.Enter;
      try
        for J := 0 to FrameCount - 1 do begin
          if FAddressCounts.TryGetValue(Frames[J], Value) then
            FAddressCounts[Frames[J]] := Value + 1
          else
            FAddressCounts.Add(Frames[J], 1);
        end;
        Inc(FTotalSamples);
      finally
        FLock.Leave;
      end;
    end;
  end;
  if FEnabled and (FTotalSamples >= MAX_TOTAL_SAMPLES) then
    FEnabled := False;
end;

procedure SamplingExitProc;
begin
  TQSamplingProfiler.SaveOnExit;
end;

initialization

  if TQSamplingProfiler.AutoStart then
    TQSamplingProfiler.Enabled := True;
  AddExitProc(SamplingExitProc);

finalization

  if TQSamplingProfiler.Enabled then
    TQSamplingProfiler.Enabled := False;

end.

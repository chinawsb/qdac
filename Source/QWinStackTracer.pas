unit QWinStackTracer;

{ ʹ��Windows��DbgHelp.DLL����ȡ��ջ��Ϣ��Ŀǰֻʵ����32λ�汾����ʱ�����ṩ64λ
  �汾�������Ҫ�������вο�MSDNʵ�֡�
}
{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}
interface

{$HPPEMIT '#pragma link "qwinstacktracer"'}

uses classes, windows, sysutils, qstring;

type
{$A4}
  PIMAGEHLP_SYMBOL = ^IMAGEHLP_SYMBOL;

  ULONG = Cardinal;
  ULONG64 = Int64;

  IMAGEHLP_SYMBOL = record
    SizeOfStruct: ULONG;
    TypeIndex: ULONG;
    Reserved: array [0 .. 1] of ULONG64;
    Index: ULONG;
    Size: ULONG;
    ModBase: ULONG64;
    Flags: ULONG;
    Value: ULONG64;
    Address: ULONG64;
    Registers: ULONG;
    Scope: ULONG;
    Tag: ULONG;
    NameLen: ULONG;
    MaxNameLen: ULONG;
    Name: array [0 .. 1] of Char;
  end;

  PKDHELP = ^KDHELP;

  KDHELP = record
    Thread: DWORD;
    ThCallbackStack: DWORD;
    NextCallback: DWORD;
    FramePointer: DWORD;
    KiCallUserMode: DWORD;
    KeUserCallbackDispatcher: DWORD;
    SystemRangeStart: DWORD;
    ThCallbackBStore: DWORD;
    Reserved: array [0 .. 7] of DWORD;
  end;

  ADDRESS_MODE = (AddrMode1616, AddrMode1632, AddrModeReal, AddrModeFlat);

  LPADDRESS = ^Address;

  Address = record
    Offset: DWORD;
    Segment: WORD;
    Mode: DWORD;
  end;

  LPSTACKFRAME = ^STACKFRAME;

  STACKFRAME = record
    AddrPC: Address; // program counter
    AddrReturn: Address; // return address
    AddrFrame: Address; // frame pointer
    AddrStack: Address; // stack pointer
    FuncTableEntry: Pointer; // pointer to pdata/fpo or NULL
    Params: array [0 .. 3] of DWORD; // possible arguments to the function
    bFar: LONGBOOL; // WOW far call
    bVirtual: LONGBOOL; // is this a virtual frame?
    Reserved: array [0 .. 2] of DWORD;
    KDHELP: KDHELP;
    AddrBStore: Address; // backing store pointer
  end;

  PIMAGEHLP_LINE = ^IMAGEHLP_LINE;

  IMAGEHLP_LINE = record
    SizeOfStruct: DWORD; // set to sizeof(IMAGEHLP_LINE)
    Key: Pointer; // internal
    LineNumber: DWORD; // line number in file
    FileName: PChar; // full filename
    Address: DWORD; // first instruction of line
  end;

{$A-}

  PREAD_PROCESS_MEMORY_ROUTINE = function(hProcess: THandle; lpBaseAddress: DWORD; lpBuffer: Pointer; nSize: DWORD;
    var lpNumberOfBytesRead: DWORD): Boolean; stdcall;

  PFUNCTION_TABLE_ACCESS_ROUTINE = function(hProcess: THandle; AddrBase: DWORD): Pointer; stdcall;

  PGET_MODULE_BASE_ROUTINE = function(hProcess: THandle; Address: DWORD): DWORD; stdcall;

  PTRANSLATE_ADDRESS_ROUTINE = function(hProcess, hThread: THandle; lpaddr: LPADDRESS): DWORD; stdcall;

  TSymLoadModule = function(hProcess, hFile: THandle; ImageName, ModuleName: PChar; BaseOfDll, SizeOfDll: DWORD)
    : DWORD; stdcall;
  TSymGetSymFromAddr = function(hProcess: THandle; dwAddr: DWORD; var dwDisplacement: DWORD; pSymbol: PIMAGEHLP_SYMBOL)
    : Boolean; stdcall;
  TSymSetOptions = function(SymOptions: DWORD): DWORD; stdcall;
  TSymInitialize = function(hProcess: THandle; UserSearchPath: PChar; fInvadeProcess: Boolean): Boolean; stdcall;
  TSymCleanup = function(hProcess: THandle): Boolean; stdcall;
  TStackWalk = function(MachineType: DWORD; hProcess, hThread: THandle; STACKFRAME: LPSTACKFRAME; ContextRecord: Pointer;
    ReadMemoryRoutine: PREAD_PROCESS_MEMORY_ROUTINE; FunctionTableAccessRoutine: PFUNCTION_TABLE_ACCESS_ROUTINE;
    GetModuleBaseRoutine: PGET_MODULE_BASE_ROUTINE; TranslateAddress: PTRANSLATE_ADDRESS_ROUTINE): Integer; stdcall;
  TSymFunctionTableAccess = function(hProcess: THandle; AddrBase: DWORD): Pointer; stdcall;
  TSymGetModuleBase = function(hProcess: THandle; Address: DWORD): DWORD; stdcall;
  TSymGetLineFromAddr = function(hProcess: THandle; dwAddr: DWORD; var dwDisplacement: DWORD; Line: PIMAGEHLP_LINE)
    : Boolean; stdcall;
  TStackFrames = array of STACKFRAME;
function DebugHelperExists: Boolean;
function GetThreadStacks(AThreadHandle: THandle): TStackFrames;
function GetFunctionInfo(Addr: Pointer; var AFileName: String; var ALineNo: Cardinal): String;

const
  //
  // options that are set/returned by SymSetOptions() & SymGetOptions()
  // these are used as a mask
  //
  SYMOPT_CASE_INSENSITIVE = $00000001;
  SYMOPT_UNDNAME = $00000002;
  SYMOPT_DEFERRED_LOADS = $00000004;
  SYMOPT_NO_CPP = $00000008;
  SYMOPT_LOAD_LINES = $00000010;
  SYMOPT_OMAP_FIND_NEAREST = $00000020;
  SYMOPT_DEBUG = $80000000;
  MAX_SYMNAME_SIZE = 1024;

var
  WinSymLoadModule: TSymLoadModule;
  WinSymGetSymFromAddr: TSymGetSymFromAddr;
  WinSymSetOptions: TSymSetOptions;
  WinSymInitialize: TSymInitialize;
  WinSymCleanup: TSymCleanup;
  WinStackWalk: TStackWalk;
  WinSymFunctionTableAccess: TSymFunctionTableAccess;
  WinSymGetModuleBase: TSymGetModuleBase;
  WinSymGetLineFromAddr: TSymGetLineFromAddr;

implementation

var
  hDLL: HModule;

function DebugHelperExists: Boolean;
begin
  Result := hDLL <> 0;
end;

function LoadProc(AName: String): FARPROC;
var
  ARealName: String;
begin
{$IFDEF UNICODE}
  ARealName := AName + 'W';
{$ELSE}
  ARealName := AName + 'A';
{$ENDIF}
  Result := GetProcAddress(hDLL, PChar(ARealName));
  if not Assigned(Result) then
    Result := GetProcAddress(hDLL, PChar(AName));
  if not Assigned(Result) then
  begin
{$IFDEF UNICODE}
    ARealName := AName + 'W64';
{$ELSE}
    ARealName := AName + '64';
{$ENDIF}
    Result := GetProcAddress(hDLL, PChar(ARealName));
  end;
end;

function GetThreadStacks(AThreadHandle: THandle): TStackFrames;
{$IFDEF WIN64}
begin
  SetLength(Result, 0);
end;
{$ELSE}

var
  AFrame: STACKFRAME;
  AContext: PContext;
  pMem: Pointer;

  I: Integer;
  function GetNextStackFrame(var ANextFrame: STACKFRAME): Boolean;
  begin
    Result := WinStackWalk(IMAGE_FILE_MACHINE_I386, GetCurrentProcess(), AThreadHandle, @AFrame, AContext, nil,
      WinSymFunctionTableAccess, WinSymGetModuleBase, nil) <> 0;
    if Result then
      ANextFrame := AFrame;
  end;

begin
  if not DebugHelperExists then
  begin
    SetLength(Result, 0);
    Exit;
  end;
  GetMem(pMem, SizeOf(TContext) + 15);
  if (IntPtr(pMem) and $F) <> 0 then
    AContext := Pointer(((IntPtr(pMem) shr 4) + 1) shl 4)
  else
    AContext := pMem;
  SetLength(Result, 0);
  SuspendThread(AThreadHandle);
  try
    AContext.ContextFlags := CONTEXT_CONTROL;
    if GetThreadContext(AThreadHandle, AContext^) then
    begin
      FillChar(AFrame, SizeOf(AFrame), 0);
      AFrame.AddrPC.Offset := AContext.Eip;
      AFrame.AddrPC.Mode := DWORD(AddrModeFlat);
      AFrame.AddrStack.Offset := AContext.Esp;
      AFrame.AddrStack.Mode := DWORD(AddrModeFlat);
      AFrame.AddrFrame.Offset := AContext.Ebp;
      AFrame.AddrFrame.Mode := DWORD(AddrModeFlat);
      SetLength(Result, MAX_SYMNAME_SIZE);
      I := 0;
      while (I < MAX_SYMNAME_SIZE) and GetNextStackFrame(Result[I]) do
        Inc(I);
      SetLength(Result, I);
    end;
  finally
    ResumeThread(AThreadHandle);
    FreeMem(pMem);
  end;
end;
{$ENDIF}

function GetFunctionInfo(Addr: Pointer; var AFileName: String; var ALineNo: Cardinal): String;
var
  sName: array [0 .. MAX_PATH] of Char;
  mbi: MEMORY_BASIC_INFORMATION;
  AProcess: THandle;
  procedure LoadSym(Addr: Pointer);
  var
    mbi: MEMORY_BASIC_INFORMATION;
  begin
    FillChar(mbi, SizeOf(MEMORY_BASIC_INFORMATION), 0);
    VirtualQuery(Addr, mbi, SizeOf(mbi));
    WinSymLoadModule(AProcess, 0, @sName[0], nil, DWORD(mbi.AllocationBase), 0);
  end;

  function GetFunctionName: String;
  var
    dwDisplacement: DWORD;
    buffer: array [0 .. 4095] of BYTE;
    pSymbol: PIMAGEHLP_SYMBOL;
    ALine:IMAGEHLP_LINE;
  begin
    Result := '';
    FillChar(buffer, 4096, 0);
    pSymbol := PIMAGEHLP_SYMBOL(@buffer);
    pSymbol.SizeOfStruct := SizeOf(IMAGEHLP_SYMBOL);
    pSymbol.MaxNameLen := SizeOf(buffer) - SizeOf(IMAGEHLP_SYMBOL) + 1;
    LoadSym(Addr);
    if (WinSymGetSymFromAddr(AProcess, DWORD(Addr), dwDisplacement, pSymbol)) then
    begin
      if (pSymbol.Flags and $00000800) <> 0 then
        Result := PChar(@pSymbol.Name);
    end;
    FillChar(ALine,SizeOf(ALine),0);
    ALine.SizeOfStruct:=Sizeof(ALine);
    if WinSymGetLineFromAddr(AProcess,DWORD(Addr),dwDisplacement,@ALine) then
      ALineNo:=ALine.LineNumber;
  end;

begin
  Result := '';
  if (VirtualQuery(Addr, mbi, SizeOf(mbi)) = 0) or (mbi.State <> MEM_COMMIT) then
    Exit;
  if (GetModuleFileName(HModule(mbi.AllocationBase), @sName, MAX_PATH) = 0) then
    Exit;
  AFileName := sName;
  AProcess := GetCurrentProcess;
  Result := GetFunctionName;
  if Length(Result) > 0 then
    Result := ExtractFileName(sName) + '.' + Result
  else
    Result := ExtractFileName(sName) + '.' + IntToHex(IntPtr(Addr), SizeOf(Pointer) shl 1);
end;

initialization

hDLL := LoadLibrary('dbghelp.dll');
if hDLL <> 0 then
begin
  WinSymLoadModule := LoadProc('SymLoadModule');
  WinSymGetSymFromAddr := LoadProc('SymGetSymFromAddr');
  WinSymSetOptions := LoadProc('SymSetOptions');
  WinSymInitialize := LoadProc('SymInitialize');
  WinSymCleanup := LoadProc('SymCleanup');
  WinStackWalk := LoadProc('StackWalk');
  WinSymFunctionTableAccess := LoadProc('SymFunctionTableAccess');
  WinSymGetModuleBase := LoadProc('SymGetModuleBase');
  WinSymGetLineFromAddr := LoadProc('SymGetLineFromAddr');
  WinSymSetOptions(SYMOPT_UNDNAME or SYMOPT_DEFERRED_LOADS or SYMOPT_LOAD_LINES);
  WinSymInitialize(GetCurrentProcess(), nil, True);
  WinSymSetOptions(SYMOPT_UNDNAME or SYMOPT_LOAD_LINES);
end
else
begin
  WinSymLoadModule := nil;
  WinSymGetSymFromAddr := nil;
  WinSymSetOptions := nil;
  WinSymInitialize := nil;
  WinSymCleanup := nil;
  WinStackWalk := nil;
  WinSymFunctionTableAccess := nil;
  WinSymGetModuleBase := nil;
  WinSymGetLineFromAddr := nil;
end;

finalization

WinSymCleanup(GetCurrentProcess());
FreeLibrary(hDLL);

end.

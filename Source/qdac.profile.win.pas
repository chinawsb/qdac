unit qdac.profile.win;

interface

uses System.Classes, System.SysUtils, Winapi.Windows, qdac.profile;

implementation

const
  GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS = $00000004;

type
  TSymbolInfo = record
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

  PSymbolInfo = ^TSymbolInfo;

  TSymbolInfoBuf = record
    Info: TSymbolInfo;
    NameBuffer: array[0..1024] of AnsiChar;
  end;

  PImageHlpLine64 = ^TImageHlpLine64;

  TImageHlpLine64 = record
    SizeOfStruct: DWORD;
    Key: Pointer;
    LineNumber: DWORD;
    FileName: PAnsiChar;
    Address: UInt64;
  end;

function SymInitialize(
    hProcess: THandle;
    UserSearchPath: PWideChar;
    fInvadeProcess: BOOL
): BOOL; stdcall; external 'dbghelp.dll';
function SymFromAddr(
    hProcess: THandle;
    Address: UInt64;
    Displacement: PDWORD;
    Symbol: PSymbolInfo
): BOOL; stdcall; external 'dbghelp.dll' name 'SymFromAddr';
function SymGetLineFromAddr64(
    hProcess: THandle;
    dwAddr: UInt64;
    pdwDisplacement: PDWORD;
    Line: PImageHlpLine64
): BOOL; stdcall; external 'dbghelp.dll';
function SymCleanup(hProcess: THandle): BOOL; stdcall; external 'dbghelp.dll';
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

// Windows平台上使用 dbghelp.dll 将地址解析为函数名称
function DbgHelpAddressName(const Addr: Pointer): string;
var
  SymbolBuf: TSymbolInfoBuf;
  LineInfo: TImageHlpLine64;
  Displacement: DWORD;
  ProcName, UnitName: string;
  hMod: HMODULE;
  ModuleName: array[0..MAX_PATH] of Char;
  LLineNo: Cardinal;
  LInitialized: BOOL;
  LProcess: THandle;
begin
  LProcess := GetCurrentProcess;
  // 延迟初始化，首次调用时加载符号
  LInitialized := SymInitialize(LProcess, nil, True);
  if not LInitialized then begin
    // 可能已经初始化过了，忽略 ERROR_INVALID_PARAMETER
    LInitialized := GetLastError <> ERROR_INVALID_PARAMETER;
  end;

  if LInitialized then begin
    FillChar(SymbolBuf, SizeOf(SymbolBuf), 0);
    SymbolBuf.Info.SizeOfStruct := SizeOf(TSymbolInfo);
    SymbolBuf.Info.MaxNameLen := 1025;
    Displacement := 0;

    if SymFromAddr(LProcess, NativeUInt(Addr), @Displacement, @SymbolBuf.Info) then begin
      ProcName := string(AnsiString(PAnsiChar(@SymbolBuf.Info.Name)));

      FillChar(LineInfo, SizeOf(LineInfo), 0);
      LineInfo.SizeOfStruct := SizeOf(LineInfo);
      if SymGetLineFromAddr64(LProcess, NativeUInt(Addr), @Displacement, @LineInfo) then begin
        if LineInfo.FileName <> nil then
          UnitName := ExtractFileName(string(AnsiString(LineInfo.FileName)));
        LLineNo := LineInfo.LineNumber;
      end
      else
        LLineNo := 0;

      // 去掉单元名前缀 (如 UnitName.ProcedureName 去掉 UnitName.)
      if (UnitName <> '') and (Pos(UnitName + '.', ProcName) = 1) then
        Delete(ProcName, 1, Length(UnitName) + 1);

      if LLineNo > 0 then
        Result := Format('%s.%s+L%u', [UnitName, ProcName, LLineNo])
      else if UnitName <> '' then
        Result := Format('%s.%s', [UnitName, ProcName])
      else
        Result := ProcName;
      Exit;
    end;
  end;

  // 回退方案：从地址获取模块名
  if GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS, PWideChar(Addr), @hMod) and (hMod <> 0) then begin
    if GetModuleFileNameW(hMod, ModuleName, MAX_PATH) > 0 then
      Result := Format('%s.%p', [ExtractFileName(string(ModuleName)), Addr])
    else
      Result := Format('%p', [Addr]);
  end
  else
    Result := Format('%p', [Addr]);
end;

initialization

  TQProfile.AddressName := DbgHelpAddressName;

end.

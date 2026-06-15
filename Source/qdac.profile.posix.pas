unit qdac.profile.posix;

interface

{ ���Ž�����POSIXϵͳ֧�֣���ʱδ�����κβ��ԣ����ܻ�������
}
uses System.Classes, System.Generics.Collections, System.SysUtils, qdac.profile;

implementation

{$IFDEF LINUX}
  {$LINKLIB execinfo}

function backtrace_symbols(buffer: PPointer; size: Integer): PPAnsiChar; cdecl;
  procedure free(P: Pointer); cdecl; external 'c' name 'free';
{$ENDIF}
{$IFDEF POSIX}
type
  TDebugSymbols = class(TDictionary<Pointer, string>)
  private
    class var
      FCurrent: TDebugSymbols;
    class function GetCurrent: TDebugSymbols; static;
  public
    function Lookup(const Addr: Pointer): string;
    class property Current: TDebugSymbols read GetCurrent;
  end;

  // Posix����ƽ̨�����ǿ����� backtrace_symbols ����ȡλ��
  function PosixAddressName(const Addr: Pointer): string;
  begin
    Result := TDebugSymbols.Current.Lookup(Addr);
  end;

  { TDebugSymbols }

  class function TDebugSymbols.GetCurrent: TDebugSymbols;
  var
    ATemp: TDebugSymbols;
  begin
    if not Assigned(FCurrent) then begin
      ATemp := TDebugSymbols.Create;
      if AtomicCmpExchange(Pointer(FCurrent), Pointer(ATemp), nil) <> nil then
        FreeAndNil(ATemp);
    end;
    Result := FCurrent;
  end;

  function TDebugSymbols.Lookup(const Addr: Pointer): string;
  var
    ASymbols: PPAnsiChar;
  begin
    TMonitor.Enter(Self);
    try
      if TryGetValue(Addr, Result) then
        Exit;
      ASymbols := backtrace_symbols(@Addr, 1);
      if ASymbols <> nil then begin
        Add(Addr, string(ASymbols^));
        free(ASymbols);
      end;
    finally
      TMonitor.Exit(Self);
    end;
    // �Ҳ���
    Result := IntToHex(IntPtr(Addr));
  end;

  initialization

    TQProfile.AddressName := PosixAddressName;
    TDebugSymbols.FCurrent := nil;

  finalization

    if Assigned(TDebugSymbols.FCurrent) then
      FreeAndNil(TDebugSymbols.FCurrent);
{$ENDIF}

  end.

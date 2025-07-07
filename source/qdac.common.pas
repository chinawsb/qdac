unit qdac.common;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, System.NetEncoding;

{$I qdac.inc}

type
  SizeInt = NativeUInt;
  TUnicodeStringArray = TArray<UnicodeString>;
  TStringArray = TUnicodeStringArray;
  TStringPair = TPair<String, String>;

  IQTextCodec = interface
    ['{87FCBDD7-3678-4FD6-B0FA-3D8596D36CDD}']
    function Encode: UnicodeString;
    procedure Decode(const AValue: UnicodeString);
  end;

  IQStreamCodec = interface
    ['{8D7435A8-BF6F-4D5C-918D-9CB880B559A5}']
    procedure LoadFromBuffer(const p: PByte; ACount: UInt64); overload;
    procedure LoadFromBuffer(const ABytes: TBytes; const AOffset, ACount: UInt64); overload;
    procedure LoadFromFile(const AFileName: UnicodeString; AMode: Word);
    function GetAsStream: TStream;
    property AsStream: TStream read GetAsStream;
  end;

  TStreamCodecClass = class of TBaseStreamCodec;

  TBaseStreamCodec = class(TInterfacedObject, IQStreamCodec)
  private
    FStream: TStream;
    procedure LoadFromBuffer(const p: PByte; ACount: UInt64); overload;
    procedure LoadFromBuffer(const ABytes: TBytes; const AOffset, ACount: UInt64); overload;
    procedure LoadFromFile(const AFileName: UnicodeString; AMode: Word);
    function GetAsStream: TStream;
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

  TBaseStreamTextCodec = class(TBaseStreamCodec, IQTextCodec)
  protected
    function Encode: UnicodeString; virtual; abstract;
    procedure Decode(const AValue: UnicodeString); virtual; abstract;
  end;

  TBase64StreamCodec = class(TBaseStreamTextCodec)
  protected
    function Encode: UnicodeString; override;
    procedure Decode(const AValue: UnicodeString); override;
  end;

const
  // NEXTGEN是XE3加入的编译器选项，10.4Sydney开始NEXTGEN已被移除
{$IFDEF NEXTGEN}
  STRING_FIRST_INDEX = 0;
{$ELSE}
  STRING_FIRST_INDEX = 1;
{$ENDIF}

resourcestring
  SSerializeFormatNotSupport = '不支持序列化为 %s 格式';

implementation

{ TBaseStreamCodec }

constructor TBaseStreamCodec.Create;
begin
  inherited Create;
end;

destructor TBaseStreamCodec.Destroy;
begin
  if Assigned(FStream) then
    FreeAndNil(FStream);
  inherited;
end;

function TBaseStreamCodec.GetAsStream: TStream;
begin
  if not Assigned(FStream) then
    FStream := TMemoryStream.Create;
  Result := FStream;
end;

procedure TBaseStreamCodec.LoadFromBuffer(const ABytes: TBytes; const AOffset, ACount: UInt64);
begin
  GetAsStream.WriteBuffer(ABytes, AOffset, ACount);
end;

procedure TBaseStreamCodec.LoadFromBuffer(const p: PByte; ACount: UInt64);
begin
  GetAsStream.WriteBuffer(p^, ACount);
end;

procedure TBaseStreamCodec.LoadFromFile(const AFileName: UnicodeString; AMode: Word);
begin
  if Assigned(FStream) then
    FreeAndNil(FStream);
  FStream := TFileStream.Create(AFileName, AMode)
end;

{ TBase64StreamCodec }

procedure TBase64StreamCodec.Decode(const AValue: UnicodeString);
var
  ABytes: TBytes;
begin
  ABytes := TNetEncoding.Base64.DecodeStringToBytes(AValue);
  with GetAsStream do
  begin
    Size := Length(ABytes);
    Position := 0;
    WriteBuffer(ABytes[0], Length(ABytes));
  end;
end;

function TBase64StreamCodec.Encode: UnicodeString;
var
  ABytes: TBytes;
begin
  with GetAsStream do
  begin
    SetLength(ABytes, Size);
    Position := 0;
    ReadBuffer(ABytes, Length(ABytes));
    Result := TNetEncoding.Base64.EncodeBytesToString(ABytes);
  end;
end;

end.

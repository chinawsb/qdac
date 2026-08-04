unit qdac.msgpack.core;

{ QDAC 4.0 MessagePack 鏍稿績鍗曞厓
  缁撶偣绫诲瀷 TQMsgPackNode 浣跨敤 TQNodeBase 浣滀负棣栦釜瀛楁锛?
  鍏变韩 DOM 閬嶅巻閫昏緫锛團orEach/Find/ItemByPath/XPath锛夊湪 qdac.serialize.core 涓疄鐜般€?
}

interface

uses System.Classes, System.SysUtils, System.Math, System.DateUtils, System.NetEncoding, FmtBcd, qdac.serialize.core;

const
  MP_NIL = $C0;
  MP_FALSE = $C2;
  MP_TRUE = $C3;
  MP_BIN8 = $C4;
  MP_BIN16 = $C5;
  MP_BIN32 = $C6;
  MP_FLOAT32 = $CA;
  MP_FLOAT64 = $CB;
  MP_UINT8 = $CC;
  MP_UINT16 = $CD;
  MP_UINT32 = $CE;
  MP_UINT64 = $CF;
  MP_INT8 = $D0;
  MP_INT16 = $D1;
  MP_INT32 = $D2;
  MP_INT64 = $D3;
  MP_STR8 = $D9;
  MP_STR16 = $DA;
  MP_STR32 = $DB;
  MP_ARRAY16 = $DC;
  MP_ARRAY32 = $DD;
  MP_MAP16 = $DE;
  MP_MAP32 = $DF;

type
  TQMsgPackDataType = (mptNil, mptBoolean, mptInt, mptUInt, mptFloat, mptString, mptBinary, mptArray, mptMap, mptExt);

  TQMsgPackEncodeSetting = (mesUseRawString, mesSortMapKeys, mesWriteTimestamp);
  TQMsgPackEncodeSettings = set of TQMsgPackEncodeSetting;
  TQMsgPackFormatSettings = record
    Settings: TQMsgPackEncodeSettings;
  end;

  // 鎵╁睍绫诲瀷
  TQMsgPackExt = record
    TypeCode: ShortInt;
    Data: TBytes;
  end;

  PQMsgPackNode = ^TQMsgPackNode;
  TQMsgPackNode = record
  public
    Base: TQNodeBase; // 鍏叡缁撶偣澶?鈥?蹇呴』涓虹涓€涓瓧娈?
    FDataType: TQMsgPackDataType;
    FExt: TQMsgPackExt;
    procedure SetStr(const V: UnicodeString);
    function GetStr: UnicodeString;
  public
    constructor Create(ADataType: TQMsgPackDataType);
    class function New(ADataType: TQMsgPackDataType): PQMsgPackNode; static;
    procedure Free;
    function GetIsNil: Boolean;
    function GetIsArray: Boolean;
    function GetIsMap: Boolean;
    function GetParent: PQMsgPackNode;
    property DataType: TQMsgPackDataType read FDataType;
    property IsNil: Boolean read GetIsNil;
    property IsArray: Boolean read GetIsArray;
    property IsMap: Boolean read GetIsMap;
    property Name: UnicodeString read Base.Name write Base.Name;
    property Parent: PQMsgPackNode read GetParent;
    // 瀛愮粨鐐癸紙濮旀墭鍒板叡浜?Node* 鍑芥暟锛?
    property Count: Integer read Base.ChildCount;
    function GetChild(AIndex: Integer): PQMsgPackNode;
    function Add(ADataType: TQMsgPackDataType): PQMsgPackNode;
    function AddChild(const AName: UnicodeString; ADataType: TQMsgPackDataType): PQMsgPackNode;
    procedure Delete(AIndex: Integer); overload;
    procedure Delete(ANode: PQMsgPackNode); overload;
    procedure Clear;
    // 鍊艰闂紙getter 渚?AsXX 灞炴€т娇鐢級
    function GetAsBoolean: Boolean;
    function GetAsInt64: Int64;
    function GetAsUInt64: UInt64;
    function GetAsDouble: Double;
    function GetAsString: UnicodeString;
    function GetAsBytes: TBytes;
    procedure SetAsBoolean(const V: Boolean);
    procedure SetAsInt64(const V: Int64);
    procedure SetAsUInt64(const V: UInt64);
    procedure SetAsDouble(const V: Double);
    procedure SetAsString(const V: UnicodeString);
    procedure SetAsBytes(const V: TBytes);
    // 缁熶竴 AsXX 鎺ュ彛锛堜笌 JSON/XML 鍚屽寲锛?
    function GetAsFloat: Extended;
    function GetAsDateTime: TDateTime;
    function GetAsBcd: TBcd;
    function GetAsBase64Bytes: TBytes;
    procedure SetAsFloat(const V: Extended);
    procedure SetAsDateTime(const V: TDateTime);
    procedure SetAsBcd(const V: TBcd);
    procedure SetAsBase64Bytes(const V: TBytes);
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsInt: Int64 read GetAsInt64 write SetAsInt64;
    property AsUInt: UInt64 read GetAsUInt64 write SetAsUInt64;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsString: UnicodeString read GetAsString write SetAsString;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsBcd: TBcd read GetAsBcd write SetAsBcd;
    property AsBase64: TBytes read GetAsBase64Bytes write SetAsBase64Bytes;
    property AsBytes: TBytes read GetAsBytes write SetAsBytes;
    property Value: UnicodeString read GetStr write SetStr;
  case Integer of
    0: (FBool: Boolean);
    1: (FInt: Int64);
    2: (FUInt: UInt64);
    3: (FFloat: Double);
    4: (FStr: PUnicodeString);
    5: (FBin: PUnicodeString);
  end;

  TQMsgPackEncoder = class sealed(TInterfacedObject, IQSerializeWriter, IQBinarySerializeWriter)
  private
    FStream: TStream;
    procedure WriteByte(b: Byte); inline;
    procedure WriteRaw(const buf; Count: Integer);
  public
    constructor Create(AStream: TStream); overload;
    constructor Create(AStream: TStream; const ASettings: TQMsgPackFormatSettings); overload;
    procedure StartObject;
    procedure EndObject;
    procedure StartArray;
    procedure EndArray;
    procedure WriteObject(const AName: UnicodeString; const ACallback: TQSerializeChildrenCallback);
    procedure WriteArray(const AName: UnicodeString; const ACallback: TQSerializeChildrenCallback);
    procedure WriteValue(const V: Int64; AIsSign: Boolean = True); overload;
    procedure WriteValue(const V: UInt64); overload;
    procedure WriteValue(const V: Extended; const AFormat: string = ''); overload;
    procedure WriteValue(const V: UnicodeString); overload;
    procedure WriteNull;
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency; const AFormat: string = ''); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteRawValue(const ABytes: TBytes);
    procedure StartObjectPair(const AName: UnicodeString);
    procedure StartArrayPair(const AName: UnicodeString);
    procedure StartPair(const AName: UnicodeString);
    procedure WritePair(const AName: UnicodeString; const V: UnicodeString); overload;
    procedure WritePair(const AName: UnicodeString; const V: Int64; AIsSign: Boolean = True); overload;
    procedure WritePair(const AName: UnicodeString; const V: UInt64); overload;
    procedure WritePair(const AName: UnicodeString; const V: Extended; const AFormat: string = ''); overload;
    procedure WritePair(const AName: UnicodeString; const V: TBcd); overload;
    procedure WritePair(const AName: UnicodeString; const V: Boolean); overload;
    procedure WritePair(const AName: UnicodeString; const V: TDateTime); overload;
    procedure WritePair(const AName: UnicodeString; const V: Currency; const AFormat: string = ''); overload;
    procedure WritePair(const AName: UnicodeString; const V: TBytes); overload;
    procedure WriteRawPair(const AName: UnicodeString; const ABytes: TBytes);
    procedure WritePair(const AName: UnicodeString); overload;
    procedure WriteName(const AName: UnicodeString);
    procedure Flush;
  end;

  TQMsgPackDecoder = class sealed(TQBaseReader, IQBinarySerializeReader)
  private
    FStream: TStream;
    FPeekByte: Integer;
    FRawPairCount: Integer;
    FRawPairIndex: Integer;
    function ReadByte: Byte;
    function ReadUInt(ABits: Integer): UInt64;
    function ReadInt(ABits: Integer): Int64;
    function ReadStr: UnicodeString;
    function ReadDouble: Double;
    function CopyRawLength(AOutput: TStream; AByteCount: Integer): UInt64;
    procedure CopyRawBytes(AOutput: TStream; ACount: NativeInt);
    procedure CopyRawValue(AOutput: TStream);
    procedure SkipValue;
    procedure ParseItem(AName: UnicodeString);
  public
    procedure DoParse; override;
    constructor Create(AStream: TStream); overload;
    constructor Create(const AText: UnicodeString); overload;
    procedure ReadRawValue(out ABytes: TBytes);
    function ReadRawPair(out AName: UnicodeString; out ABytes: TBytes): Boolean;
  end;

implementation

constructor TQMsgPackNode.Create(ADataType: TQMsgPackDataType);
begin
  FillChar(Self, SizeOf(Self), 0);
  FDataType := ADataType;
end;

class function TQMsgPackNode.New(ADataType: TQMsgPackDataType): PQMsgPackNode;
begin
  System.New(Result);
  Result.Create(ADataType);
end;

procedure TQMsgPackNode.Free;
begin
  Clear;
  if FDataType = mptString then
    Dispose(FStr);
  if FDataType = mptBinary then
    Dispose(FBin);
  Dispose(@Self);
end;

procedure TQMsgPackNode.SetStr(const V: UnicodeString);
begin
  if FDataType = mptString then
    FStr^ := V
  else begin
    if FStr = nil then
      System.New(FStr);
    FStr^ := V;
    FDataType := mptString;
  end;
end;

function TQMsgPackNode.GetIsNil: Boolean;
begin
  Result := FDataType = mptNil;
end;

function TQMsgPackNode.GetIsArray: Boolean;
begin
  Result := FDataType = mptArray;
end;

function TQMsgPackNode.GetIsMap: Boolean;
begin
  Result := FDataType = mptMap;
end;

function TQMsgPackNode.GetParent: PQMsgPackNode;
begin
  Result := PQMsgPackNode(Base.Prior);
end;

function TQMsgPackNode.GetStr: UnicodeString;
begin
  if (FDataType = mptString) and (FStr <> nil) then
    Result := FStr^
  else
    Result := '';
end;

function TQMsgPackNode.GetChild(AIndex: Integer): PQMsgPackNode;
var
  I: Integer;
  N: PQNodeBase;
begin
  N := Base.FirstChild;
  I := 0;
  while (N <> nil) and (I < AIndex) do begin
    N := N.Next;
    Inc(I);
  end;
  Result := PQMsgPackNode(N);
end;

function TQMsgPackNode.Add(ADataType: TQMsgPackDataType): PQMsgPackNode;
begin
  System.New(Result);
  Result.Create(ADataType);
  NodeAddChild(@Base, @Result.Base);
end;

function TQMsgPackNode.AddChild(const AName: UnicodeString; ADataType: TQMsgPackDataType): PQMsgPackNode;
begin
  Result := Add(ADataType);
  Result.Name := AName;
end;

procedure TQMsgPackNode.Delete(AIndex: Integer);
begin
  NodeDeleteChild(@Base, AIndex);
end;

procedure TQMsgPackNode.Delete(ANode: PQMsgPackNode);
var
  N: PQNodeBase;
  I: Integer;
begin
  N := Base.FirstChild;
  I := 0;
  while N <> nil do begin
    if N = @ANode.Base then begin
      NodeDeleteChild(@Base, I);
      Exit;
    end;
    N := N.Next;
    Inc(I);
  end;
end;

procedure TQMsgPackNode.Clear;
var
  N, Next: PQNodeBase;
begin
  N := Base.FirstChild;
  while N <> nil do begin
    Next := N.Next;
    PQMsgPackNode(N).Free;
    N := Next;
  end;
  Base.FirstChild := nil;
  Base.LastChild := nil;
  Base.ChildCount := 0;
end;

function TQMsgPackNode.GetAsBoolean: Boolean;
begin
  case FDataType of
    mptBoolean: Result := FBool;
    mptInt: Result := FInt <> 0;
  else
    Result := False;
  end;
end;
function TQMsgPackNode.GetAsInt64: Int64;
begin
  case FDataType of
    mptInt: Result := FInt;
    mptUInt: Result := Int64(FUInt);
    mptFloat: Result := Trunc(FFloat);
  else
    Result := 0;
  end;
end;
function TQMsgPackNode.GetAsUInt64: UInt64;
begin
  case FDataType of
    mptUInt: Result := FUInt;
    mptInt: Result := UInt64(FInt);
    mptFloat: Result := Trunc(FFloat);
  else
    Result := 0;
  end;
end;
function TQMsgPackNode.GetAsDouble: Double;
begin
  case FDataType of
    mptFloat: Result := FFloat;
    mptInt: Result := FInt;
    mptUInt: Result := FUInt;
  else
    Result := 0;
  end;
end;
function TQMsgPackNode.GetAsString: UnicodeString;
begin
  case FDataType of
    mptString: Result := GetStr;
    mptInt: Result := IntToStr(FInt);
    mptUInt: Result := UIntToStr(FUInt);
    mptFloat: Result := FloatToStr(FFloat);
    mptBoolean:
      if FBool then
        Result := 'true'
      else
        Result := 'false';
    mptNil: Result := 'null';
  else
    Result := '';
  end;
end;
function TQMsgPackNode.GetAsBytes: TBytes;
begin
  Result := TEncoding.UTF8.GetBytes(AsString);
end;
procedure TQMsgPackNode.SetAsBoolean(const V: Boolean);
begin
  FDataType := mptBoolean;
  FBool := V;
end;
procedure TQMsgPackNode.SetAsInt64(const V: Int64);
begin
  FDataType := mptInt;
  FInt := V;
end;
procedure TQMsgPackNode.SetAsUInt64(const V: UInt64);
begin
  FDataType := mptUInt;
  FUInt := V;
end;
procedure TQMsgPackNode.SetAsDouble(const V: Double);
begin
  FDataType := mptFloat;
  FFloat := V;
end;
procedure TQMsgPackNode.SetAsString(const V: UnicodeString);
begin
  SetStr(V);
end;
procedure TQMsgPackNode.SetAsBytes(const V: TBytes);
begin
  SetStr(TEncoding.UTF8.GetString(V));
  FDataType := mptBinary;
end;

function TQMsgPackNode.GetAsFloat: Extended;
begin
  Result := GetAsDouble;
end;

procedure TQMsgPackNode.SetAsFloat(const V: Extended);
begin
  SetAsDouble(V);
end;

function TQMsgPackNode.GetAsDateTime: TDateTime;
begin
  case FDataType of
    mptFloat: Result := TDateTime(FFloat);
    mptInt: Result := FInt / SecsPerDay;
    mptUInt: Result := FUInt / SecsPerDay;
    mptString: Result := StrToDateTimeDef(GetStr, 0);
  else
    Result := 0;
  end;
end;

procedure TQMsgPackNode.SetAsDateTime(const V: TDateTime);
begin
  FDataType := mptFloat;
  FFloat := V;
end;

function TQMsgPackNode.GetAsBcd: TBcd;
begin
  TryStrToBcd(AsString, Result);
end;

procedure TQMsgPackNode.SetAsBcd(const V: TBcd);
begin
  SetStr(BcdToStr(V));
  FDataType := mptString;
end;

function TQMsgPackNode.GetAsBase64Bytes: TBytes;
begin
  if FDataType = mptString then
    Result := TNetEncoding.Base64.DecodeStringToBytes(AsString)
  else
    Result := nil;
end;

procedure TQMsgPackNode.SetAsBase64Bytes(const V: TBytes);
begin
  SetStr(TNetEncoding.Base64.EncodeBytesToString(V));
  FDataType := mptString;
end;

{ TQMsgPackEncoder }

procedure TQMsgPackEncoder.WriteByte(b: Byte);
begin
  FStream.WriteBuffer(b, 1);
end;
procedure TQMsgPackEncoder.WriteRaw(const buf; Count: Integer);
begin
  if Count > 0 then
    FStream.WriteBuffer(buf, Count);
end;
constructor TQMsgPackEncoder.Create(AStream: TStream);
begin
  FStream := AStream;
end;
constructor TQMsgPackEncoder.Create(AStream: TStream; const ASettings: TQMsgPackFormatSettings);
begin
  FStream := AStream;
end;
procedure TQMsgPackEncoder.StartObject;
var
  W: Word;
begin
  WriteByte($DE);
  W := 0;
  WriteRaw(W, 2);
end;
procedure TQMsgPackEncoder.EndObject;
begin
end;
procedure TQMsgPackEncoder.StartArray;
var
  W: Word;
begin
  WriteByte($DC);
  W := 0;
  WriteRaw(W, 2);
end;
procedure TQMsgPackEncoder.EndArray;
begin
end;
procedure TQMsgPackEncoder.WriteValue(const V: Int64; AIsSign: Boolean);
var
  SI: SmallInt;
  I: Integer;
begin
  if (V >= 0) and (V <= $7F) then
    WriteByte(Byte(V))
  else if (V >= -32) and (V < 0) then
    WriteByte(Byte(V))
  else if V >= -128 then begin
    WriteByte(MP_INT8);
    WriteRaw(V, 1);
  end
  else if V >= -32768 then begin
    WriteByte(MP_INT16);
    SI := SmallInt(V);
    WriteRaw(SI, 2);
  end
  else if V >= -2147483648 then begin
    WriteByte(MP_INT32);
    I := Integer(V);
    WriteRaw(I, 4);
  end
  else begin
    WriteByte(MP_INT64);
    WriteRaw(V, 8);
  end;
end;
procedure TQMsgPackEncoder.WriteValue(const V: UInt64);
var
  W: Word;
  C: Cardinal;
begin
  if V <= $7F then
    WriteByte(Byte(V))
  else if V <= $FF then begin
    WriteByte(MP_UINT8);
    WriteRaw(V, 1);
  end
  else if V <= $FFFF then begin
    WriteByte(MP_UINT16);
    W := Word(V);
    WriteRaw(W, 2);
  end
  else if V <= $FFFFFFFF then begin
    WriteByte(MP_UINT32);
    C := Cardinal(V);
    WriteRaw(C, 4);
  end
  else begin
    WriteByte(MP_UINT64);
    WriteRaw(V, 8);
  end;
end;
procedure TQMsgPackEncoder.WriteValue(const V: Extended; const AFormat: string);
var
  D: Double;
begin
  WriteByte(MP_FLOAT64);
  D := V;
  WriteRaw(D, 8);
end;
procedure TQMsgPackEncoder.WriteValue(const V: UnicodeString);
var
  U: TBytes;
  L: Integer;
  B: Byte;
  W: Word;
  C: Cardinal;
begin
  U := TEncoding.UTF8.GetBytes(V);
  L := Length(U);
  if L <= 31 then
    WriteByte($A0 or Byte(L))
  else if L <= $FF then begin
    WriteByte(MP_STR8);
    B := Byte(L);
    WriteRaw(B, 1);
  end
  else if L <= $FFFF then begin
    WriteByte(MP_STR16);
    W := Word(L);
    WriteRaw(W, 2);
  end
  else begin
    WriteByte(MP_STR32);
    C := Cardinal(L);
    WriteRaw(C, 4);
  end;
  if L > 0 then
    WriteRaw(U[0], L);
end;
procedure TQMsgPackEncoder.WriteNull;
begin
  WriteByte(MP_NIL);
end;
procedure TQMsgPackEncoder.WriteName(const AName: UnicodeString);
begin
  WriteValue(AName);
end;
procedure TQMsgPackEncoder.Flush;
begin
end;

procedure TQMsgPackEncoder.WriteObject(const AName: UnicodeString;
  const ACallback: TQSerializeChildrenCallback);
begin
  if AName <> '' then
    StartObjectPair(AName)
  else
    StartObject;
  try
    ACallback;
  finally
    EndObject;
  end;
end;

procedure TQMsgPackEncoder.WriteArray(const AName: UnicodeString;
  const ACallback: TQSerializeChildrenCallback);
begin
  if AName <> '' then
    StartArrayPair(AName)
  else
    StartArray;
  try
    ACallback;
  finally
    EndArray;
  end;
end;

procedure TQMsgPackEncoder.WriteValue(const V: Boolean);
begin
  if V then
    WriteByte(MP_TRUE)
  else
    WriteByte(MP_FALSE);
end;

procedure TQMsgPackEncoder.WriteValue(const V: TBcd);
begin
  WriteValue(UnicodeString(BcdToStr(V)));
end;

procedure TQMsgPackEncoder.WriteValue(const V: TDateTime);
begin
  WriteValue(DateToISO8601(V));
end;

procedure TQMsgPackEncoder.WriteValue(const V: Currency; const AFormat: string);
begin
  if AFormat = '' then
    WriteValue(UnicodeString(CurrToStr(V)))
  else
    WriteValue(UnicodeString(FormatFloat(AFormat, V)));
end;

procedure TQMsgPackEncoder.WriteValue(const V: TBytes);
var
  L: Integer;
  W: Word;
begin
  L := Length(V);
  if L < $100 then begin
    WriteByte(MP_BIN8);
    WriteByte(L);
  end else if L < $10000 then begin
    WriteByte(MP_BIN16);
    W := Word(L);
    WriteRaw(W, 2);
  end else begin
    WriteByte(MP_BIN32);
    WriteRaw(L, 4);
  end;
  if L > 0 then
    WriteRaw(V[0], L);
end;

procedure TQMsgPackEncoder.WriteRawValue(const ABytes: TBytes);
begin
  if Length(ABytes) > 0 then
    WriteRaw(ABytes[0], Length(ABytes));
end;

procedure TQMsgPackEncoder.StartObjectPair(const AName: UnicodeString);
begin
  WriteName(AName);
  StartObject;
end;

procedure TQMsgPackEncoder.StartArrayPair(const AName: UnicodeString);
begin
  WriteName(AName);
  StartArray;
end;

procedure TQMsgPackEncoder.StartPair(const AName: UnicodeString);
begin
  WriteName(AName);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: UnicodeString);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: Int64; AIsSign: Boolean);
begin
  WriteName(AName);
  WriteValue(V, AIsSign);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: UInt64);
begin
  WriteName(AName);
  WriteValue(V);
end;
procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: Extended; const AFormat: string);
begin
  WriteName(AName);
  WriteValue(V, AFormat);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: TBcd);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: Boolean);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: TDateTime);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: Currency; const AFormat: string);
begin
  WriteName(AName);
  WriteValue(V, AFormat);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString; const V: TBytes);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQMsgPackEncoder.WriteRawPair(const AName: UnicodeString; const ABytes: TBytes);
begin
  WriteName(AName);
  WriteRawValue(ABytes);
end;

procedure TQMsgPackEncoder.WritePair(const AName: UnicodeString);
begin
  WriteName(AName);
end;

{ TQMsgPackDecoder }
constructor TQMsgPackDecoder.Create(AStream: TStream);
begin
  FStream := AStream;
  FPeekByte := -1;
  FRawPairCount := -1;
end;
constructor TQMsgPackDecoder.Create(const AText: UnicodeString);
var
  S: TStream;
begin
  S := TMemoryStream.Create;
  S.WriteBuffer(Pointer(AText)^, Length(AText) * SizeOf(Char));
  S.Position := 0;
  Create(S);
end;
function TQMsgPackDecoder.CopyRawLength(AOutput: TStream; AByteCount: Integer): UInt64;
begin
  Result := 0;
  FStream.ReadBuffer(Result, AByteCount);
  AOutput.WriteBuffer(Result, AByteCount);
end;

procedure TQMsgPackDecoder.CopyRawBytes(AOutput: TStream; ACount: NativeInt);
var
  ABuffer: array[0..4095] of Byte;
  AChunk: Integer;
begin
  while ACount > 0 do begin
    AChunk := ACount;
    if AChunk > SizeOf(ABuffer) then
      AChunk := SizeOf(ABuffer);
    FStream.ReadBuffer(ABuffer[0], AChunk);
    AOutput.WriteBuffer(ABuffer[0], AChunk);
    Dec(ACount, AChunk);
  end;
end;

procedure TQMsgPackDecoder.CopyRawValue(AOutput: TStream);
var
  B: Byte;
  ACount, I: NativeInt;
  ALength: UInt64;
begin
  B := ReadByte;
  AOutput.WriteBuffer(B, 1);
  if (B <= $7F) or (B >= $E0) then
    Exit;
  if B <= $8F then begin
    ACount := B and $0F;
    for I := 1 to ACount do begin
      CopyRawValue(AOutput);
      CopyRawValue(AOutput);
    end;
    Exit;
  end;
  if B <= $9F then begin
    ACount := B and $0F;
    for I := 1 to ACount do
      CopyRawValue(AOutput);
    Exit;
  end;
  if B <= $BF then begin
    CopyRawBytes(AOutput, B and $1F);
    Exit;
  end;
  case B of
    $C0, $C2, $C3:;
    $C4, $D9: begin
      ALength := CopyRawLength(AOutput, 1);
      CopyRawBytes(AOutput, ALength);
    end;
    $C5, $DA: begin
      ALength := CopyRawLength(AOutput, 2);
      CopyRawBytes(AOutput, ALength);
    end;
    $C6, $DB: begin
      ALength := CopyRawLength(AOutput, 4);
      if ALength > UInt64(High(NativeInt)) then
        raise EReadError.Create('MessagePack value is too large');
      CopyRawBytes(AOutput, NativeInt(ALength));
    end;
    $C7: begin
      ALength := CopyRawLength(AOutput, 1);
      CopyRawBytes(AOutput, ALength + 1);
    end;
    $C8: begin
      ALength := CopyRawLength(AOutput, 2);
      CopyRawBytes(AOutput, ALength + 1);
    end;
    $C9: begin
      ALength := CopyRawLength(AOutput, 4);
      if ALength >= UInt64(High(NativeInt)) then
        raise EReadError.Create('MessagePack extension is too large');
      CopyRawBytes(AOutput, NativeInt(ALength) + 1);
    end;
    $CA, $CE, $D2: CopyRawBytes(AOutput, 4);
    $CB, $CF, $D3: CopyRawBytes(AOutput, 8);
    $CC, $D0: CopyRawBytes(AOutput, 1);
    $CD, $D1: CopyRawBytes(AOutput, 2);
    $D4: CopyRawBytes(AOutput, 2);
    $D5: CopyRawBytes(AOutput, 3);
    $D6: CopyRawBytes(AOutput, 5);
    $D7: CopyRawBytes(AOutput, 9);
    $D8: CopyRawBytes(AOutput, 17);
    $DC, $DD: begin
      if B = $DC then
        ALength := CopyRawLength(AOutput, 2)
      else
        ALength := CopyRawLength(AOutput, 4);
      if ALength > UInt64(High(NativeInt)) then
        raise EReadError.Create('MessagePack array is too large');
      ACount := NativeInt(ALength);
      for I := 1 to ACount do
        CopyRawValue(AOutput);
    end;
    $DE, $DF: begin
      if B = $DE then
        ALength := CopyRawLength(AOutput, 2)
      else
        ALength := CopyRawLength(AOutput, 4);
      if ALength > UInt64(High(NativeInt)) then
        raise EReadError.Create('MessagePack map is too large');
      ACount := NativeInt(ALength);
      for I := 1 to ACount do begin
        CopyRawValue(AOutput);
        CopyRawValue(AOutput);
      end;
    end;
  else
    raise EReadError.CreateFmt('Unsupported MessagePack marker: %.2x', [B]);
  end;
end;

function TQMsgPackDecoder.ReadRawPair(
    out AName: UnicodeString;
    out ABytes: TBytes
): Boolean;
var
  B: Byte;
begin
  if FRawPairCount < 0 then begin
    B := ReadByte;
    if (B >= $80) and (B <= $8F) then
      FRawPairCount := B and $0F
    else if B = $DE then
      FRawPairCount := Word(ReadUInt(16))
    else if B = $DF then
      FRawPairCount := Integer(ReadUInt(32))
    else
      raise EReadError.Create('MessagePack raw pair reader requires a map value');
    FRawPairIndex := 0;
  end;
  Result := FRawPairIndex < FRawPairCount;
  if not Result then begin
    AName := '';
    ABytes := nil;
    Exit;
  end;
  AName := ReadStr;
  if FPeekByte >= 0 then
    raise EReadError.Create('MessagePack map key is not a string');
  ReadRawValue(ABytes);
  Inc(FRawPairIndex);
end;

procedure TQMsgPackDecoder.ReadRawValue(out ABytes: TBytes);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    CopyRawValue(AStream);
    SetLength(ABytes, AStream.Size);
    if AStream.Size > 0 then begin
      AStream.Position := 0;
      AStream.ReadBuffer(ABytes[0], Length(ABytes));
    end;
  finally
    FreeAndNil(AStream);
  end;
end;

function TQMsgPackDecoder.ReadByte: Byte;
begin
  if FPeekByte >= 0 then begin
    Result := Byte(FPeekByte);
    FPeekByte := -1;
  end
  else
    FStream.ReadBuffer(Result, 1);
end;
function TQMsgPackDecoder.ReadUInt(ABits: Integer): UInt64;
begin
  Result := 0;
  case ABits of
    8: FStream.ReadBuffer(Result, 1);
    16: FStream.ReadBuffer(Result, 2);
    32: FStream.ReadBuffer(Result, 4);
    64: FStream.ReadBuffer(Result, 8);
  end;
end;
function TQMsgPackDecoder.ReadInt(ABits: Integer): Int64;
begin
  Result := ReadUInt(ABits);
  if (ABits = 8) and (Byte(Result) > $7F) then
    Result := Result or Int64($FFFFFFFFFFFFFF00);
  if (ABits = 16) and (SmallInt(Result) < 0) then
    Result := Result or Int64($FFFFFFFFFFFF0000);
end;
function TQMsgPackDecoder.ReadStr: UnicodeString;
var
  B: Byte;
  Len: Integer;
  Buf: TBytes;
begin
  B := ReadByte;
  if B <= $BF then begin
    if B < $A0 then begin
      FPeekByte := B;
      Exit('');
    end;
    Len := B and $1F;
  end
  else
    case B of
      $D9: Len := ReadByte;
      $DA: Len := Word(ReadUInt(16));
      $DB: Len := Integer(ReadUInt(32));
    else
      begin
        FPeekByte := B;
        Exit('');
      end;
    end;
  SetLength(Buf, Len);
  if Len > 0 then
    FStream.ReadBuffer(Buf[0], Len);
  Result := TEncoding.UTF8.GetString(Buf);
end;
function TQMsgPackDecoder.ReadDouble: Double;
begin
  FStream.ReadBuffer(Result, 8);
end;
procedure TQMsgPackDecoder.SkipValue;
var
  B: Byte;
  Cnt, Len: Integer;
begin
  B := ReadByte;
  if B <= $7F then
    Exit;
  if B <= $8F then begin
    Cnt := B and $0F;
    for Len := 1 to Cnt do begin
      SkipValue;
      SkipValue;
    end;
    Exit;
  end;
  if B <= $9F then begin
    Cnt := B and $0F;
    for Len := 1 to Cnt do
      SkipValue;
    Exit;
  end;
  if B <= $BF then begin
    FStream.Seek(B and $1F, soCurrent);
    Exit;
  end;
  if B >= $E0 then
    Exit;
  case B of
    $C0, $C2, $C3:;
    $C4: begin
      Len := ReadByte;
      FStream.Seek(Len, soCurrent);
    end;
    $C5: begin
      Len := Word(ReadUInt(16));
      FStream.Seek(Len, soCurrent);
    end;
    $C6: begin
      Len := Integer(ReadUInt(32));
      FStream.Seek(Len, soCurrent);
    end;
    $CA: FStream.Seek(4, soCurrent);
    $CB: FStream.Seek(8, soCurrent);
    $CC: FStream.Seek(1, soCurrent);
    $CD: FStream.Seek(2, soCurrent);
    $CE: FStream.Seek(4, soCurrent);
    $CF: FStream.Seek(8, soCurrent);
    $D0: FStream.Seek(1, soCurrent);
    $D1: FStream.Seek(2, soCurrent);
    $D2: FStream.Seek(4, soCurrent);
    $D3: FStream.Seek(8, soCurrent);
    $D9: begin
      Len := ReadByte;
      FStream.Seek(Len, soCurrent);
    end;
    $DA: begin
      Len := Word(ReadUInt(16));
      FStream.Seek(Len, soCurrent);
    end;
    $DB: begin
      Len := Integer(ReadUInt(32));
      FStream.Seek(Len, soCurrent);
    end;
    $DC: begin
      Cnt := Word(ReadUInt(16));
      for Len := 1 to Cnt do
        SkipValue;
    end;
    $DD: begin
      Cnt := Integer(ReadUInt(32));
      for Len := 1 to Cnt do
        SkipValue;
    end;
    $DE: begin
      Cnt := Word(ReadUInt(16));
      for Len := 1 to Cnt do begin
        SkipValue;
        SkipValue;
      end;
    end;
    $DF: begin
      Cnt := Integer(ReadUInt(32));
      for Len := 1 to Cnt do begin
        SkipValue;
        SkipValue;
      end;
    end;
  end;
end;
procedure TQMsgPackDecoder.ParseItem(AName: UnicodeString);
var
  B: Byte;
  Cnt, I: Integer;
  Key: UnicodeString;
  AReader: IQSerializeReader;
begin
  if AName <> '' then begin
    if not TryRead(AName) then begin
      SkipValue;
      Exit;
    end;
  end;
  if Assigned(FCurrent) and Assigned(FCurrent.Fields)
      and Assigned(FCurrent.Fields.CustomSerializer) then begin
    AReader := Self as IQSerializeReader;
    FRawPairCount := -1;
    FRawPairIndex := 0;
    try
      FCurrent.Fields.CustomSerializer.Read(AReader, FCurrent, FCurrent.Field);
    finally
      AReader := nil;
      if AName <> '' then
        EndRead;
    end;
    Exit;
  end;
  B := ReadByte;
  if (B <= $7F) or (B >= $E0) then begin
    if AName <> '' then
      EndRead;
    Exit;
  end;
  if (B >= $A0) and (B <= $BF) then begin
    FPeekByte := B;
    ReadStr;
    if AName <> '' then
      EndRead;
    Exit;
  end;
  if (B >= $80) and (B <= $8F) then begin
    Cnt := B and $0F;
    for I := 1 to Cnt do begin
      Key := ReadStr;
      ParseItem(Key);
    end;
    if AName <> '' then
      EndRead;
    Exit;
  end;
  if (B >= $90) and (B <= $9F) then begin
    Cnt := B and $0F;
    for I := 0 to Cnt - 1 do
      ParseItem(IntToStr(I));
    if AName <> '' then
      EndRead;
    Exit;
  end;
  case B of
    $C0, $C2, $C3:;
    $CA: ReadUInt(32);
    $CB: ReadDouble;
    $CC: ReadUInt(8);
    $CD: ReadUInt(16);
    $CE: ReadUInt(32);
    $CF: ReadUInt(64);
    $D0: ReadInt(8);
    $D1: ReadInt(16);
    $D2: ReadInt(32);
    $D3: ReadInt(64);
    $D9, $DA, $DB: begin
      FPeekByte := B;
      ReadStr;
    end;
    $DC: begin
      Cnt := Word(ReadUInt(16));
      for I := 0 to Cnt - 1 do
        ParseItem(IntToStr(I));
    end;
    $DD: begin
      Cnt := Integer(ReadUInt(32));
      for I := 0 to Cnt - 1 do
        ParseItem(IntToStr(I));
    end;
    $DE: begin
      Cnt := Word(ReadUInt(16));
      for I := 1 to Cnt do begin
        Key := ReadStr;
        ParseItem(Key);
      end;
    end;
    $DF: begin
      Cnt := Integer(ReadUInt(32));
      for I := 1 to Cnt do begin
        Key := ReadStr;
        ParseItem(Key);
      end;
    end;
  end;
  if AName <> '' then
    EndRead;
end;
procedure TQMsgPackDecoder.DoParse;
begin
  ParseItem('');
end;

procedure MsgPackReaderProc(AStream: TStream; const AText: UnicodeString; var AReader: IQSerializeReader);
begin
  AReader := TQMsgPackDecoder.Create(AStream);
end;

procedure MsgPackWriterProc(AStream: TStream; var AWriter: IQSerializeWriter);
begin
  AWriter := TQMsgPackEncoder.Create(AStream);
end;

procedure RegisterMsgPackCodec;
begin
  TQSerializer.Current.RegisterCodec('msgpack', MsgPackReaderProc, MsgPackWriterProc);
end;
end.

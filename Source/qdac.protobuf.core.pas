unit qdac.protobuf.core;

interface

procedure RegisterProtoBufCodec;

implementation

uses
  System.Classes,
  System.DateUtils,
  System.Generics.Collections,
  System.SysUtils,
  FmtBcd,
  qdac.serialize.core;

type
  TProtoWriterFrame = class
  public
    ParentStream: TStream;
    Buffer: TMemoryStream;
    FieldNumber: Integer;
    NextField: Integer;
    constructor Create(AParent: TStream; AFieldNumber, ANextField: Integer);
    destructor Destroy; override;
  end;

  TQProtoBufWriter = class(TInterfacedObject, IQSerializeWriter,
    IQBinarySerializeWriter)
  private
    FArrayField: Integer;
    FFrames: TObjectList<TProtoWriterFrame>;
    FNextField: Integer;
    FPendingField: Integer;
    FStream: TStream;
    function AcquireField: Integer;
    function ValueField: Integer;
    procedure BeginEmbedded(AFieldNumber: Integer);
    procedure EndEmbedded;
    procedure WriteByte(AValue: Byte);
    procedure WriteBytes(const AValue: TBytes);
    procedure WriteKey(AFieldNumber, AWireType: Integer);
    procedure WriteLengthDelimited(AFieldNumber: Integer;
      const AValue: TBytes);
    procedure WriteVarInt(AValue: UInt64);
  public
    constructor Create(AStream: TStream);
    destructor Destroy; override;
    procedure StartObject;
    procedure EndObject;
    procedure WriteObject(const AName: UnicodeString;
      const ACallback: TQSerializeChildrenCallback);
    procedure StartArray;
    procedure EndArray;
    procedure WriteArray(const AName: UnicodeString;
      const ACallback: TQSerializeChildrenCallback);
    procedure WriteValue(const V: UnicodeString); overload;
    procedure WriteValue(const V: Int64; AIsSign: Boolean = True); overload;
    procedure WriteValue(const V: UInt64); overload;
    procedure WriteValue(const V: Extended;
      const AFormat: string = ''); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency;
      const AFormat: string = ''); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteNull;
    procedure StartObjectPair(const AName: UnicodeString);
    procedure StartArrayPair(const AName: UnicodeString);
    procedure StartPair(const AName: UnicodeString);
    procedure WritePair(const AName: UnicodeString;
      const V: UnicodeString); overload;
    procedure WritePair(const AName: UnicodeString; const V: Int64;
      AIsSign: Boolean = True); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: UInt64); overload;
    procedure WritePair(const AName: UnicodeString; const V: Extended;
      const AFormat: string = ''); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: TBcd); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: Boolean); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: TDateTime); overload;
    procedure WritePair(const AName: UnicodeString; const V: Currency;
      const AFormat: string = ''); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: TBytes); overload;
    procedure WritePair(const AName: UnicodeString); overload;
    procedure WriteRawValue(const ABytes: TBytes);
    procedure WriteRawPair(const AName: UnicodeString;
      const ABytes: TBytes);
    procedure Flush;
  end;

  TQProtoBufReader = class(TQBaseReader, IQBinarySerializeReader)
  private
    FBytes: TBytes;
    FOffset: Integer;
    FRawValue: TBytes;
    function ReadVarInt: UInt64;
    procedure SkipField(AWireType: Integer);
  public
    constructor Create(AStream: TStream);
    procedure DoParse; override;
    procedure ReadRawValue(out ABytes: TBytes);
    function ReadRawPair(out AName: UnicodeString;
      out ABytes: TBytes): Boolean;
  end;

constructor TProtoWriterFrame.Create(AParent: TStream;
  AFieldNumber, ANextField: Integer);
begin
  inherited Create;
  ParentStream := AParent;
  Buffer := TMemoryStream.Create;
  FieldNumber := AFieldNumber;
  NextField := ANextField;
end;

destructor TProtoWriterFrame.Destroy;
begin
  Buffer.Free;
  inherited;
end;

constructor TQProtoBufWriter.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
  FFrames := TObjectList<TProtoWriterFrame>.Create(True);
  FNextField := 1;
end;

destructor TQProtoBufWriter.Destroy;
begin
  FFrames.Free;
  inherited;
end;

function TQProtoBufWriter.AcquireField: Integer;
begin
  Result := FNextField;
  Inc(FNextField);
end;

function TQProtoBufWriter.ValueField: Integer;
begin
  if FPendingField > 0 then
  begin
    Result := FPendingField;
    FPendingField := 0;
  end
  else if FArrayField > 0 then
    Result := FArrayField
  else
    Result := AcquireField;
end;

procedure TQProtoBufWriter.WriteByte(AValue: Byte);
begin
  FStream.WriteBuffer(AValue, SizeOf(AValue));
end;

procedure TQProtoBufWriter.WriteBytes(const AValue: TBytes);
begin
  if Length(AValue) > 0 then
    FStream.WriteBuffer(AValue[0], Length(AValue));
end;

procedure TQProtoBufWriter.WriteVarInt(AValue: UInt64);
var
  B: Byte;
begin
  repeat
    B := AValue and $7F;
    AValue := AValue shr 7;
    if AValue <> 0 then
      B := B or $80;
    WriteByte(B);
  until AValue = 0;
end;

procedure TQProtoBufWriter.WriteKey(AFieldNumber, AWireType: Integer);
begin
  WriteVarInt((UInt64(AFieldNumber) shl 3) or UInt64(AWireType));
end;

procedure TQProtoBufWriter.WriteLengthDelimited(AFieldNumber: Integer;
  const AValue: TBytes);
begin
  WriteKey(AFieldNumber, 2);
  WriteVarInt(Length(AValue));
  WriteBytes(AValue);
end;

procedure TQProtoBufWriter.BeginEmbedded(AFieldNumber: Integer);
var
  Frame: TProtoWriterFrame;
begin
  Frame := TProtoWriterFrame.Create(FStream, AFieldNumber, FNextField);
  FFrames.Add(Frame);
  FStream := Frame.Buffer;
  FNextField := 1;
  FPendingField := 0;
  FArrayField := 0;
end;

procedure TQProtoBufWriter.EndEmbedded;
var
  Bytes: TBytes;
  Frame: TProtoWriterFrame;
begin
  if FFrames.Count = 0 then
    Exit;
  Frame := FFrames.Last;
  SetLength(Bytes, Frame.Buffer.Size);
  Frame.Buffer.Position := 0;
  if Length(Bytes) > 0 then
    Frame.Buffer.ReadBuffer(Bytes[0], Length(Bytes));
  FStream := Frame.ParentStream;
  FNextField := Frame.NextField;
  WriteLengthDelimited(Frame.FieldNumber, Bytes);
  FFrames.Delete(FFrames.Count - 1);
end;

procedure TQProtoBufWriter.StartObject;
begin
  if FArrayField > 0 then
    BeginEmbedded(FArrayField);
end;

procedure TQProtoBufWriter.EndObject;
begin
  EndEmbedded;
end;

procedure TQProtoBufWriter.WriteObject(const AName: UnicodeString;
  const ACallback: TQSerializeChildrenCallback);
begin
  StartObjectPair(AName);
  try
    ACallback;
  finally
    EndObject;
  end;
end;

procedure TQProtoBufWriter.StartArray;
begin
  if FArrayField = 0 then
    FArrayField := AcquireField;
end;

procedure TQProtoBufWriter.EndArray;
begin
  FArrayField := 0;
end;

procedure TQProtoBufWriter.WriteArray(const AName: UnicodeString;
  const ACallback: TQSerializeChildrenCallback);
begin
  StartArrayPair(AName);
  try
    ACallback;
  finally
    EndArray;
  end;
end;

procedure TQProtoBufWriter.WriteValue(const V: UnicodeString);
begin
  WriteLengthDelimited(ValueField, TEncoding.UTF8.GetBytes(V));
end;

procedure TQProtoBufWriter.WriteValue(const V: Int64; AIsSign: Boolean);
begin
  WriteKey(ValueField, 0);
  WriteVarInt(UInt64(V));
end;

procedure TQProtoBufWriter.WriteValue(const V: UInt64);
begin
  WriteKey(ValueField, 0);
  WriteVarInt(V);
end;

procedure TQProtoBufWriter.WriteValue(const V: Extended;
  const AFormat: string);
var
  D: Double;
  Bytes: TBytes;
begin
  D := V;
  SetLength(Bytes, SizeOf(D));
  Move(D, Bytes[0], SizeOf(D));
  WriteKey(ValueField, 1);
  WriteBytes(Bytes);
end;

procedure TQProtoBufWriter.WriteValue(const V: TBcd);
begin
  WriteValue(BcdToDouble(V));
end;

procedure TQProtoBufWriter.WriteValue(const V: Boolean);
begin
  WriteKey(ValueField, 0);
  WriteVarInt(Ord(V));
end;

procedure TQProtoBufWriter.WriteValue(const V: TDateTime);
begin
  WriteValue(DateTimeToUnix(V));
end;

procedure TQProtoBufWriter.WriteValue(const V: Currency;
  const AFormat: string);
begin
  WriteValue(Extended(V), AFormat);
end;

procedure TQProtoBufWriter.WriteValue(const V: TBytes);
begin
  WriteLengthDelimited(ValueField, V);
end;

procedure TQProtoBufWriter.WriteNull;
begin
end;

procedure TQProtoBufWriter.StartObjectPair(const AName: UnicodeString);
begin
  BeginEmbedded(AcquireField);
end;

procedure TQProtoBufWriter.StartArrayPair(const AName: UnicodeString);
begin
  FArrayField := AcquireField;
end;

procedure TQProtoBufWriter.StartPair(const AName: UnicodeString);
begin
  FPendingField := AcquireField;
end;

procedure TQProtoBufWriter.WritePair(const AName, V: UnicodeString);
begin
  FPendingField := AcquireField;
  WriteValue(V);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: Int64; AIsSign: Boolean);
begin
  FPendingField := AcquireField;
  WriteValue(V, AIsSign);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: UInt64);
begin
  FPendingField := AcquireField;
  WriteValue(V);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: Extended; const AFormat: string);
begin
  FPendingField := AcquireField;
  WriteValue(V, AFormat);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: TBcd);
begin
  FPendingField := AcquireField;
  WriteValue(V);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: Boolean);
begin
  FPendingField := AcquireField;
  WriteValue(V);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: TDateTime);
begin
  FPendingField := AcquireField;
  WriteValue(V);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: Currency; const AFormat: string);
begin
  FPendingField := AcquireField;
  WriteValue(V, AFormat);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString;
  const V: TBytes);
begin
  FPendingField := AcquireField;
  WriteValue(V);
end;

procedure TQProtoBufWriter.WritePair(const AName: UnicodeString);
begin
  FPendingField := AcquireField;
  WriteNull;
end;

procedure TQProtoBufWriter.WriteRawValue(const ABytes: TBytes);
begin
  WriteLengthDelimited(ValueField, ABytes);
end;

procedure TQProtoBufWriter.WriteRawPair(const AName: UnicodeString;
  const ABytes: TBytes);
begin
  FPendingField := AcquireField;
  WriteRawValue(ABytes);
end;

procedure TQProtoBufWriter.Flush;
begin
end;

constructor TQProtoBufReader.Create(AStream: TStream);
begin
  inherited Create;
  SetLength(FBytes, AStream.Size - AStream.Position);
  if Length(FBytes) > 0 then
    AStream.ReadBuffer(FBytes[0], Length(FBytes));
end;

function TQProtoBufReader.ReadVarInt: UInt64;
var
  B, Shift: Integer;
begin
  Result := 0;
  Shift := 0;
  repeat
    if FOffset >= Length(FBytes) then
      raise EStreamError.Create('truncated protobuf varint');
    B := FBytes[FOffset];
    Inc(FOffset);
    Result := Result or (UInt64(B and $7F) shl Shift);
    if (B and $80) = 0 then
      Exit;
    Inc(Shift, 7);
  until Shift >= 64;
  raise EStreamError.Create('protobuf varint exceeds 64 bits');
end;

procedure TQProtoBufReader.SkipField(AWireType: Integer);
var
  Count, Start: Integer;
begin
  Start := FOffset;
  case AWireType of
    0: ReadVarInt;
    1: Inc(FOffset, 8);
    2:
      begin
        Count := ReadVarInt;
        Inc(FOffset, Count);
      end;
    5: Inc(FOffset, 4);
  else
    raise EStreamError.CreateFmt('unsupported protobuf wire type: %d',
      [AWireType]);
  end;
  if FOffset > Length(FBytes) then
    raise EStreamError.Create('truncated protobuf field');
  FRawValue := Copy(FBytes, Start, FOffset - Start);
end;

procedure TQProtoBufReader.DoParse;
var
  FieldNumber, WireType: Integer;
  Key: UInt64;
  Name: string;
begin
  while FOffset < Length(FBytes) do
  begin
    Key := ReadVarInt;
    FieldNumber := Key shr 3;
    WireType := Key and 7;
    Name := IntToStr(FieldNumber);
    if Assigned(FCurrent) and Assigned(FCurrent.Fields) and
      (FieldNumber > 0) and
      (FieldNumber <= Length(FCurrent.Fields.Fields)) and
      (Length(FCurrent.Fields.Fields[FieldNumber - 1].Names) > 0) then
      Name := FCurrent.Fields.Fields[FieldNumber - 1].Names[0];
    if TryRead(Name) then
    begin
      SkipField(WireType);
      EndRead;
    end
    else
      SkipField(WireType);
  end;
end;

procedure TQProtoBufReader.ReadRawValue(out ABytes: TBytes);
begin
  ABytes := Copy(FRawValue);
end;

function TQProtoBufReader.ReadRawPair(out AName: UnicodeString;
  out ABytes: TBytes): Boolean;
begin
  AName := '';
  ABytes := nil;
  Result := False;
end;

procedure ProtoBufReaderProc(AStream: TStream; const AText: UnicodeString;
  var AReader: IQSerializeReader);
begin
  AReader := TQProtoBufReader.Create(AStream);
end;

procedure ProtoBufWriterProc(AStream: TStream;
  var AWriter: IQSerializeWriter);
begin
  AWriter := TQProtoBufWriter.Create(AStream);
end;

procedure RegisterProtoBufCodec;
begin
  TQSerializer.Current.RegisterCodec('protobuf',
    ProtoBufReaderProc, ProtoBufWriterProc);
  TQSerializer.Current.RegisterCodec('proto',
    ProtoBufReaderProc, ProtoBufWriterProc);
end;

initialization
  RegisterProtoBufCodec;

end.

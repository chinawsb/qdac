unit qdac.xml.core;

{ QDAC 4.0 XML 鏍稿績鍗曞厓
  缁撶偣绫诲瀷 TQXmlNode 浣跨敤 TQNodeBase 浣滀负棣栦釜瀛楁锛?
  鍏变韩 DOM 閬嶅巻閫昏緫鍦?qdac.serialize.core 涓€?
}

interface

uses System.Classes, System.SysUtils, System.Math, System.NetEncoding, FmtBcd, qdac.serialize.core;
type
  TQXmlNodeType = (xntElement, xntAttribute, xntText, xntComment, xntCDATA, xntProcessingInstruction, xntDocument);

  TQXmlEncodeSetting = (xesDoFormat, xesIgnoreHeader, xesWriteHeader);
  TQXmlEncodeSettings = set of TQXmlEncodeSetting;
  TQXmlFormatSettings = record
    Settings: TQXmlEncodeSettings;
  end;

  PQXmlNode = ^TQXmlNode;
  TQXmlNode = record
  public
    Base: TQNodeBase;
    FNodeType: TQXmlNodeType;
    FValue: UnicodeString;
    FAttrFirst, FAttrLast: PQXmlNode;
    FAttrCount: Integer;
    constructor Create(ANodeType: TQXmlNodeType);
    class function New(ANodeType: TQXmlNodeType): PQXmlNode; static;
    procedure Free;
    function GetParent: PQXmlNode;
    property NodeType: TQXmlNodeType read FNodeType;
    property Name: UnicodeString read Base.Name write Base.Name;
    property Value: UnicodeString read FValue write FValue;
    property Parent: PQXmlNode read GetParent;
    property Count: Integer read Base.ChildCount;
    function GetChild(AIndex: Integer): PQXmlNode;
    function AddChild(ANodeType: TQXmlNodeType): PQXmlNode;
    function AddElement(const AName: UnicodeString): PQXmlNode;
    function ElementByName(const AName: UnicodeString): PQXmlNode;
    function ElementsByTag(const ATag: UnicodeString): TArray<PQXmlNode>;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    function ItemByPath(const APath: UnicodeString; ADelimiter: WideChar = '.'): PQXmlNode;
    function ForcePath(const APath: UnicodeString; ADelimiter: WideChar = '.'): PQXmlNode;
    function ForceName(const AName: UnicodeString): PQXmlNode;
    function Find(const AName: UnicodeString): TArray<PQXmlNode>;
    procedure ForEach(ACallback: TQNodeForEachCallback);
    procedure Sort(ASC: Boolean = True);
    function XPath(const AExpr: UnicodeString): TArray<PQXmlNode>;
    property AttrCount: Integer read FAttrCount;
    function AttrByName(const AName: UnicodeString): UnicodeString;
    procedure SetAttribute(const AName, AValue: UnicodeString);
    function Text: UnicodeString;
    procedure SetText(const V: UnicodeString);
    property InnerText: UnicodeString read Text write SetText;
    // 缁熶竴 AsXX 鎺ュ彛锛堜笌 JSON/MsgPack 鍚屽寲锛?
    function GetAsBoolean: Boolean;
    function GetAsInt64: Int64;
    function GetAsDouble: Double;
    function GetAsString: UnicodeString;
    function GetAsFloat: Extended;
    function GetAsDateTime: TDateTime;
    function GetAsBcd: TBcd;
    function GetAsBase64Bytes: TBytes;
    procedure SetAsBoolean(const V: Boolean);
    procedure SetAsInt64(const V: Int64);
    procedure SetAsDouble(const V: Double);
    procedure SetAsString(const V: UnicodeString);
    procedure SetAsFloat(const V: Extended);
    procedure SetAsDateTime(const V: TDateTime);
    procedure SetAsBcd(const V: TBcd);
    procedure SetAsBase64Bytes(const V: TBytes);
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsInt: Int64 read GetAsInt64 write SetAsInt64;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsString: UnicodeString read GetAsString write SetAsString;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsBcd: TBcd read GetAsBcd write SetAsBcd;
    property AsBase64: TBytes read GetAsBase64Bytes write SetAsBase64Bytes;
  end;

  TQXmlEncoder = class sealed(TInterfacedObject, IQSerializeWriter)
  private
    FStream: TStream;
    FDepth: Integer;
    function EncodeText(const S: UnicodeString): TBytes;
    procedure WriteRaw(const S: UnicodeString);
  public
    constructor Create(AStream: TStream); overload;
    constructor Create(AStream: TStream; const ASettings: TQXmlFormatSettings); overload;
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
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency; const AFormat: string = ''); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteNull;
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
    procedure WritePair(const AName: UnicodeString); overload;
    procedure WriteName(const AName: UnicodeString);
    procedure Flush;
  end;

  TQXmlDecoder = class sealed(TQBaseReader)
  private
    FBuffer: TBytes;
    FPos: Integer;
    FSize: Integer;
    function Peek: Integer;
    function ReadByte: Byte;
    procedure SkipWhitespace;
    function ReadName: UnicodeString;
    function ReadQuotedString: UnicodeString;
    procedure ParseElement;
  public
    procedure DoParse; override;
    constructor Create(AStream: TStream); overload;
    constructor Create(const AText: UnicodeString); overload;
  end;

procedure RegisterXmlCodec;

implementation

{ TQXmlNode }

constructor TQXmlNode.Create(ANodeType: TQXmlNodeType);
begin
  FillChar(Self, SizeOf(Self), 0);
  FNodeType := ANodeType;
end;

class function TQXmlNode.New(ANodeType: TQXmlNodeType): PQXmlNode;
begin
  System.New(Result);
  Result.Create(ANodeType);
end;

procedure TQXmlNode.Free;
begin
  Clear;
  Dispose(@Self);
end;

function TQXmlNode.GetParent: PQXmlNode;
begin
  Result := PQXmlNode(Base.Prior);
end;

function TQXmlNode.GetChild(AIndex: Integer): PQXmlNode;
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
  Result := PQXmlNode(N);
end;

function TQXmlNode.AddChild(ANodeType: TQXmlNodeType): PQXmlNode;
begin
  System.New(Result);
  Result.Create(ANodeType);
  NodeAddChild(@Base, @Result.Base);
end;

function TQXmlNode.AddElement(const AName: UnicodeString): PQXmlNode;
begin
  Result := AddChild(xntElement);
  Result.Name := AName;
end;

function TQXmlNode.ElementByName(const AName: UnicodeString): PQXmlNode;
begin
  Result := PQXmlNode(NodeFindByName(@Base, AName));
end;

function TQXmlNode.ElementsByTag(const ATag: UnicodeString): TArray<PQXmlNode>;
var
  N: PQNodeBase;
  C: Integer;
begin
  C := 0;
  SetLength(Result, 16);
  N := Base.FirstChild;
  while N <> nil do begin
    if (PQXmlNode(N).FNodeType = xntElement) and (N.Name = ATag) then begin
      if C >= Length(Result) then
        SetLength(Result, C * 2);
      Result[C] := PQXmlNode(N);
      Inc(C);
    end;
    N := N.Next;
  end;
  SetLength(Result, C);
end;

procedure TQXmlNode.Delete(AIndex: Integer);
begin
  NodeDeleteChild(@Base, AIndex);
end;

procedure TQXmlNode.Clear;
var
  N, Next: PQNodeBase;
begin
  N := Base.FirstChild;
  while N <> nil do begin
    Next := N.Next;
    PQXmlNode(N).Free;
    N := Next;
  end;
  Base.FirstChild := nil;
  Base.LastChild := nil;
  Base.ChildCount := 0;
end;

function TQXmlNode.ItemByPath(const APath: UnicodeString; ADelimiter: WideChar = '.'): PQXmlNode;
begin
  Result := PQXmlNode(NodeByPath(@Base, APath, ADelimiter));
end;

function TQXmlNode.ForcePath(const APath: UnicodeString; ADelimiter: WideChar = '.'): PQXmlNode;
begin
  Result := PQXmlNode(NodeForcePath(@Base, APath, ADelimiter));
end;

function TQXmlNode.ForceName(const AName: UnicodeString): PQXmlNode;
begin
  Result := PQXmlNode(NodeForceName(@Base, AName));
end;

function TQXmlNode.Find(const AName: UnicodeString): TArray<PQXmlNode>;
var
  A: TArray<PQNodeBase>;
  I: Integer;
begin
  A := NodeFindAll(@Base, AName);
  SetLength(Result, Length(A));
  for I := 0 to High(A) do
    Result[I] := PQXmlNode(A[I]);
end;

procedure TQXmlNode.ForEach(ACallback: TQNodeForEachCallback);
begin
  NodeForEach(@Base, ACallback);
end;

procedure TQXmlNode.Sort(ASC: Boolean = True);
begin
  NodeSort(@Base, ASC);
end;

function TQXmlNode.XPath(const AExpr: UnicodeString): TArray<PQXmlNode>;
var
  A: TArray<PQNodeBase>;
  I: Integer;
begin
  A := NodeXPath(@Base, AExpr);
  SetLength(Result, Length(A));
  for I := 0 to High(A) do
    Result[I] := PQXmlNode(A[I]);
end;

function TQXmlNode.AttrByName(const AName: UnicodeString): UnicodeString;
var
  N: PQXmlNode;
begin
  N := FAttrFirst;
  while N <> nil do begin
    if N.Base.Name = AName then
      Exit(N.FValue);
    N := PQXmlNode(N.Base.Next);
  end;
  Result := '';
end;

procedure TQXmlNode.SetAttribute(const AName, AValue: UnicodeString);
var
  N: PQXmlNode;
begin
  N := FAttrFirst;
  while N <> nil do begin
    if N.Base.Name = AName then begin
      N.FValue := AValue;
      Exit;
    end;
    N := PQXmlNode(N.Base.Next);
  end;
  System.New(N);
  N.Create(xntAttribute);
  N.Base.Name := AName;
  N.FValue := AValue;
  N.Base.Next := nil;
  N.Base.Prior := nil;
  if FAttrLast = nil then begin
    FAttrFirst := N;
    FAttrLast := N;
  end
  else begin
    FAttrLast.Base.Next := @N.Base;
    N.Base.Prior := @FAttrLast.Base;
    FAttrLast := N;
  end;
  Inc(FAttrCount);
end;

function TQXmlNode.Text: UnicodeString;
var
  N: PQNodeBase;
begin
  Result := '';
  N := Base.FirstChild;
  while N <> nil do begin
    if PQXmlNode(N).FNodeType = xntText then
      Result := Result + PQXmlNode(N).FValue;
    N := N.Next;
  end;
end;

procedure TQXmlNode.SetText(const V: UnicodeString);
var
  N, Next: PQNodeBase;
  Added: Boolean;
  procedure RemoveChild(ANode: PQNodeBase);
  begin
    // Unlink ANode from parent's child list, then free it
    if ANode.Prior <> nil then
      ANode.Prior.Next := ANode.Next
    else
      Base.FirstChild := ANode.Next;
    if ANode.Next <> nil then
      ANode.Next.Prior := ANode.Prior
    else
      Base.LastChild := ANode.Prior;
    Dec(Base.ChildCount);
    PQXmlNode(ANode).Free;
  end;
begin
  Added := False;
  N := Base.FirstChild;
  while N <> nil do begin
    Next := N.Next;
    if PQXmlNode(N).FNodeType = xntText then begin
      if not Added then begin
        PQXmlNode(N).FValue := V;
        Added := True;
      end
      else begin
        RemoveChild(N);
      end;
    end;
    N := Next;
  end;
  if not Added then begin
    var C := AddChild(xntText);
    C.FValue := V;
  end;
end;

function TQXmlNode.GetAsString: UnicodeString;
begin
  case FNodeType of
    xntElement: Result := Base.Name;
    xntText, xntComment, xntCDATA: Result := FValue;
    xntAttribute: Result := FValue;
  else
    Result := '';
  end;
end;
function TQXmlNode.GetAsInt64: Int64;
begin
  Result := StrToInt64Def(Trim(Text), 0);
end;
function TQXmlNode.GetAsDouble: Double;
begin
  Result := StrToFloatDef(Trim(Text), 0);
end;
function TQXmlNode.GetAsBoolean: Boolean;
var
  T: string;
begin
  T := Trim(Text);
  Result := (T = 'true') or (T = '1') or (T = 'yes');
end;

procedure TQXmlNode.SetAsString(const V: UnicodeString);
begin
  SetText(V);
end;

procedure TQXmlNode.SetAsInt64(const V: Int64);
begin
  SetText(IntToStr(V));
end;

procedure TQXmlNode.SetAsDouble(const V: Double);
begin
  SetText(FloatToStr(V));
end;

procedure TQXmlNode.SetAsBoolean(const V: Boolean);
begin
  if V then
    SetText('true')
  else
    SetText('false');
end;

function TQXmlNode.GetAsFloat: Extended;
begin
  Result := StrToFloatDef(Trim(Text), 0);
end;

procedure TQXmlNode.SetAsFloat(const V: Extended);
begin
  SetText(FloatToStr(V));
end;

function TQXmlNode.GetAsDateTime: TDateTime;
begin
  Result := StrToDateTimeDef(Trim(Text), 0);
end;

procedure TQXmlNode.SetAsDateTime(const V: TDateTime);
begin
  SetText(DateTimeToStr(V));
end;

function TQXmlNode.GetAsBcd: TBcd;
begin
  TryStrToBcd(Trim(Text), Result);
end;

procedure TQXmlNode.SetAsBcd(const V: TBcd);
begin
  SetText(BcdToStr(V));
end;

function TQXmlNode.GetAsBase64Bytes: TBytes;
begin
  Result := TNetEncoding.Base64.DecodeStringToBytes(Trim(Text));
end;

procedure TQXmlNode.SetAsBase64Bytes(const V: TBytes);
begin
  SetText(TNetEncoding.Base64.EncodeBytesToString(V));
end;

{ TQXmlEncoder }

function TQXmlEncoder.EncodeText(const S: UnicodeString): TBytes;
var
  T: string;
begin
  T := S;
  T := StringReplace(T, '&', '&amp;', [rfReplaceAll]);
  T := StringReplace(T, '<', '&lt;', [rfReplaceAll]);
  T := StringReplace(T, '>', '&gt;', [rfReplaceAll]);
  T := StringReplace(T, '"', '&quot;', [rfReplaceAll]);
  Result := TEncoding.UTF8.GetBytes(T);
end;
procedure TQXmlEncoder.WriteRaw(const S: UnicodeString);
var
  B: TBytes;
begin
  B := TEncoding.UTF8.GetBytes(S);
  if Length(B) > 0 then
    FStream.WriteBuffer(B[0], Length(B));
end;
constructor TQXmlEncoder.Create(AStream: TStream);
begin
  FStream := AStream;
  FDepth := 0;
end;
constructor TQXmlEncoder.Create(AStream: TStream; const ASettings: TQXmlFormatSettings);
begin
  Create(AStream);
end;
procedure TQXmlEncoder.StartObject;
begin
  if FDepth = 0 then
    WriteRaw('<?xml version="1.0" encoding="utf-8"?>'#10);
  WriteRaw('<object>');
  Inc(FDepth);
end;
procedure TQXmlEncoder.EndObject;
begin
  Dec(FDepth);
  WriteRaw('</object>');
  if FDepth = 0 then
    WriteRaw(#10);
end;
procedure TQXmlEncoder.StartArray;
begin
  WriteRaw('<array>');
  Inc(FDepth);
end;
procedure TQXmlEncoder.EndArray;
begin
  Dec(FDepth);
  WriteRaw('</array>');
end;
procedure TQXmlEncoder.WriteValue(const V: Int64; AIsSign: Boolean);
begin
  WriteRaw('<value>' + IntToStr(V) + '</value>');
end;
procedure TQXmlEncoder.WriteValue(const V: UInt64);
begin
  WriteRaw('<value>' + UIntToStr(V) + '</value>');
end;
procedure TQXmlEncoder.WriteValue(const V: Extended; const AFormat: string);
begin
  WriteRaw('<value>' + FloatToStr(V) + '</value>');
end;
procedure TQXmlEncoder.WriteValue(const V: UnicodeString);
begin
  WriteRaw('<value>');
  FStream.WriteBuffer(EncodeText(V)[0], Length(EncodeText(V)));
  WriteRaw('</value>');
end;
procedure TQXmlEncoder.WriteNull;
begin
  WriteRaw('<value/>');
end;
procedure TQXmlEncoder.WriteName(const AName: UnicodeString);
begin
  WriteRaw('<' + AName + '>');
end;

procedure TQXmlEncoder.WriteObject(const AName: UnicodeString; const ACallback: TQSerializeChildrenCallback);
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

procedure TQXmlEncoder.WriteArray(const AName: UnicodeString; const ACallback: TQSerializeChildrenCallback);
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

procedure TQXmlEncoder.WriteValue(const V: Boolean);
begin
  WriteValue(Int64(Ord(V)));
end;

procedure TQXmlEncoder.WriteValue(const V: TDateTime);
var
  S: UnicodeString;
begin
  DateTimeToString(S, 'c', V);
  WriteRaw('<value>' + S + '</value>');
end;

procedure TQXmlEncoder.WriteValue(const V: Currency; const AFormat: string);
begin
  WriteRaw('<value>' + CurrToStr(V) + '</value>');
end;

procedure TQXmlEncoder.WriteValue(const V: TBytes);
begin
  WriteRaw('<value>');
  if Length(V) > 0 then
    FStream.WriteBuffer(V[0], Length(V));
  WriteRaw('</value>');
end;

procedure TQXmlEncoder.WriteValue(const V: TBcd);
begin
  WriteValue(BcdToStr(V));
end;

procedure TQXmlEncoder.StartObjectPair(const AName: UnicodeString);
begin
  WriteName(AName);
  StartObject;
end;

procedure TQXmlEncoder.StartArrayPair(const AName: UnicodeString);
begin
  WriteName(AName);
  StartArray;
end;

procedure TQXmlEncoder.StartPair(const AName: UnicodeString);
begin
  WriteName(AName);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: UnicodeString);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: Int64; AIsSign: Boolean);
begin
  WriteName(AName);
  WriteValue(V, AIsSign);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: UInt64);
begin
  WriteName(AName);
  WriteValue(V);
end;
procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: Extended; const AFormat: string);
begin
  WriteName(AName);
  WriteValue(V, AFormat);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: TBcd);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: Boolean);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: TDateTime);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: Currency; const AFormat: string);
begin
  WriteName(AName);
  WriteValue(V, AFormat);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString; const V: TBytes);
begin
  WriteName(AName);
  WriteValue(V);
end;

procedure TQXmlEncoder.WritePair(const AName: UnicodeString);
begin
  WriteRaw('<' + AName + ' />');
end;

procedure TQXmlEncoder.Flush;
begin
  // TQXmlEncoder does not buffer; write is direct to FStream
end;

{ TQXmlDecoder }
constructor TQXmlDecoder.Create(AStream: TStream);
var
  Sz: Integer;
begin
  Sz := AStream.Size - AStream.Position;
  SetLength(FBuffer, Sz);
  if Sz > 0 then
    AStream.ReadBuffer(FBuffer[0], Sz);
  FPos := 0;
  FSize := Sz;
end;
constructor TQXmlDecoder.Create(const AText: UnicodeString);
var
  S: TStream;
begin
  S := TMemoryStream.Create;
  S.WriteBuffer(Pointer(AText)^, Length(AText) * SizeOf(Char));
  S.Position := 0;
  Create(S);
end;
function TQXmlDecoder.Peek: Integer;
begin
  if FPos < FSize then
    Result := FBuffer[FPos]
  else
    Result := -1;
end;
function TQXmlDecoder.ReadByte: Byte;
begin
  if FPos < FSize then begin
    Result := FBuffer[FPos];
    Inc(FPos);
  end
  else
    Result := 0;
end;
procedure TQXmlDecoder.SkipWhitespace;
begin
  while (FPos < FSize) and (FBuffer[FPos] in [$09, $0A, $0D, $20]) do
    Inc(FPos);
end;
function TQXmlDecoder.ReadName: UnicodeString;
var
  Start: Integer;
begin
  SkipWhitespace;
  Start := FPos;
  while (FPos < FSize) and not (FBuffer[FPos] in [$09, $0A, $0D, $20, $3E, $2F, $3D]) do
    Inc(FPos);
  Result := TEncoding.UTF8.GetString(Copy(FBuffer, Start, FPos - Start));
end;
function TQXmlDecoder.ReadQuotedString: UnicodeString;
var
  Q: Byte;
  Start: Integer;
begin
  Q := ReadByte;
  Start := FPos;
  while (FPos < FSize) and (FBuffer[FPos] <> Q) do
    Inc(FPos);
  Result := TEncoding.UTF8.GetString(Copy(FBuffer, Start, FPos - Start));
  if FPos < FSize then
    Inc(FPos);
end;
procedure TQXmlDecoder.ParseElement;
var
  Name, AttrName, AttrVal: UnicodeString;
  IsEmpty: Boolean;
  AReader: IQSerializeReader;
begin
  SkipWhitespace;
  if Peek <> Ord('<') then begin
    while (FPos < FSize) and (FBuffer[FPos] <> Ord('<')) do
      ReadByte;
    Exit;
  end;
  ReadByte;
  if Peek = Ord('/') then begin
    ReadByte;
    Exit;
  end;
  Name := ReadName;
  if (Name = '') or (Name[1] = '?') or (Name[1] = '!') then begin
    if (Name = '?') or (Name[1] = '?') then begin
      while (FPos + 1 < FSize) and not ((FBuffer[FPos] = Ord('?')) and (FBuffer[FPos + 1] = Ord('>'))) do
        Inc(FPos);
      if FPos + 1 < FSize then
        Inc(FPos, 2);
    end
    else if Pos('!--', Name) = 1 then begin
      while (FPos + 2 < FSize)
          and not ((FBuffer[FPos] = Ord('-')) and (FBuffer[FPos + 1] = Ord('-')) and (FBuffer[FPos + 2] = Ord('>'))) do
        Inc(FPos);
      if FPos + 2 < FSize then
        Inc(FPos, 3);
    end
    else
      while (FPos < FSize) and (FBuffer[FPos] <> Ord('>')) do
        Inc(FPos);
    if FPos < FSize then
      Inc(FPos);
    ParseElement;
    Exit;
  end;
  while (FPos < FSize) and (Peek in [$09, $0A, $0D, $20]) do begin
    SkipWhitespace;
    if Peek in [Ord('>'), Ord('/')] then
      Break;
    AttrName := ReadName;
    if Peek = Ord('=') then begin
      ReadByte;
      AttrVal := ReadQuotedString;
    end;
  end;
  IsEmpty := Peek = Ord('/');
  if IsEmpty then begin
    ReadByte;
    ReadByte;
  end;
  if Peek = Ord('>') then
    ReadByte;
  if not IsEmpty then begin
    if TryRead(Name) then begin
      if Assigned(FCurrent.Fields) and Assigned(FCurrent.Fields.CustomSerializer) then begin
        AReader := Self as IQSerializeReader;
        try
          FCurrent.Fields.CustomSerializer.Read(AReader, FCurrent, FCurrent.Field);
        finally
          AReader := nil;
          EndRead;
        end;
      end
      else begin
        ParseElement;
        EndRead;
      end;
    end
    else begin
      var D := 1;
      while (D > 0) and (FPos < FSize) do begin
        if Peek = Ord('<') then begin
          ReadByte;
          if Peek = Ord('/') then begin
            Dec(D);
            ReadByte;
            ReadName;
            if Peek = Ord('>') then
              ReadByte;
          end
          else if (FPos + 1 < FSize) and (FBuffer[FPos] = Ord('/')) and (FBuffer[FPos + 1] = Ord('>')) then
            Inc(FPos, 2)
          else begin
            if Peek = Ord('!') then begin
              while (FPos < FSize) and (FBuffer[FPos] <> Ord('>')) do
                Inc(FPos);
              if FPos < FSize then
                Inc(FPos);
            end
            else
              Inc(D);
          end;
        end
        else
          ReadByte;
      end;
    end;
  end;
  ParseElement;
end;
procedure TQXmlDecoder.DoParse;
begin
  while (FPos < FSize) and (Peek = Ord('<')) do
    ParseElement;
end;

procedure XmlReaderProc(AStream: TStream; const AText: UnicodeString; var AReader: IQSerializeReader);
begin
  AReader := TQXmlDecoder.Create(AStream);
end;

procedure XmlWriterProc(AStream: TStream; var AWriter: IQSerializeWriter);
begin
  AWriter := TQXmlEncoder.Create(AStream);
end;

procedure RegisterXmlCodec;
begin
  TQSerializer.Current.RegisterCodec('xml', XmlReaderProc, XmlWriterProc);
end;
end.

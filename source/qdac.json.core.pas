unit qdac.json.core;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults, System.Hash;

const
  JSON_STREAM_BUFFER_SIZE = 4096;

type
  EJsonError = class(Exception);

  PQJsonElements = ^TQJsonElements;
  // JSON 数据类型
  TQJsonDataType = (jdtUnknown, jdtNull, jdtBoolean, jdtInteger, jdtFloat, jdtString, jdtArray, jdtObject,
    jdtLineComment, jdtBlockComment);
  // 解析阶段
  TQJsonParseStage = (jpsStartItem, jpsStartEndItem, jpsStartArray, jpsEndArray, jpsStartObject, jpsEndObject);
  // 解析动作：继承/跳过后续/停止解析
  TQJsonParseAction = (jpaContinue, jpaSkipSiblings, jpaStop);
  // 存贮模式：正常，缓存重复字符串值以节省内存
  TQJsonStoreMode = (jsmNormal, jsmCacheStrings);
  TQJsonTokenKind = (jtkUnknown, jtkEof, jtkNull, jtkTrue, jtkFalse, jtkInteger, jtkFloat, jtkString, jtkArrayStart,
    jtkArrayEnd, jtkItemDelimiter, jtkObjectStart, jtkObjectEnd);

  TQJsonValue = record
    case Integer of
      0:
        (AsBoolean: Boolean);
      1:
        (AsInt64: Int64);
      2:
        (AsFloat: Extended);
      3:
        (AsCurrency: Currency);
      4:
        (AsString: PString);
      5:
        (AsArray: PQJsonElements);
      6:
        (AsObject: PQJsonElements);
      7:
        (AsPointer: Pointer);
  end;

  PQJsonNode = ^TQJsonNode;

  TQJsonNode = record
    Name: PString;
    // 父子关联
    Parent, FirstChild, LastChild: PQJsonNode;
    // 前后关联
    Prior, Next: PQJsonNode;
    // 子元素个数
    Count: Integer;
    // 数据类型
    DataType: TQJsonDataType;
    // 值
    Value: TQJsonValue;
    // 用户数据，具体用途取决于上层，在使用内部的RTTI解析时，会将其做为关联的实例的地址信息
    UserData: Pointer;
    // Todo:兼容下老版本的接口函数
    procedure Clear;
  end;

  TQJsonParser = class;

  TQJsonReadBuffer = function(AParser: TQJsonParser): Cardinal of object;
  TQJsonParseCallback = procedure(AParser: TQJsonParser; AItem: PQJsonNode; AStage: TQJsonParseStage;
    var AParseAction: TQJsonParseAction) of object;

  // JSON 解析器
  TQJsonParser = class sealed
  private type
    TTokenReader = function: TQJsonTokenKind of Object;
  private
    FRoot: TQJsonNode;
    FBufferReader: TQJsonReadBuffer;
    FTokenReader: TTokenReader;
    FOnParseStage: TQJsonParseCallback;
    FNameIndexes: THashSet<PString>;
    FStoreMode: TQJsonStoreMode;
    FErrorCode, FErrorLine, FErrorColumn: Cardinal;
    FLineNo, FColNo, FBufferSize: Cardinal;
    FErrorMsg: String;
    FStringBuilder: TStringBuilder;
    FBuffer, FCurrent: PByte;
    function GetCount: Integer;
    function GetFirstChild: PQJsonNode;
    function GetLastChild: PQJsonNode;
    function GetUserData: Pointer;
    function GetDataType: TQJsonDataType;
    procedure ClearStrings;
    procedure Reset;
    procedure DoStringNotify(Sender: TObject; const Item: PString; Action: TCollectionNotification);
    function ReadStreamBuffer(AParser: TQJsonParser): Cardinal;
    function AnsiReadToken: TQJsonTokenKind;
    function Utf8ReadToken: TQJsonTokenKind;
    function Utf16LeReadToken: TQJsonTokenKind;
    function Utf16BeReadToken: TQJsonTokenKind;
    function NeedBytes(ACount: Cardinal): Boolean;
    procedure InternalParse(AParent: PQJsonNode);
    function InternalTryParseText(const p: PByte; AReader: TTokenReader; ACallback: TQJsonParseCallback): Boolean;
  public
    constructor Create(const AMode: TQJsonStoreMode = jsmNormal); overload;
    destructor Destroy; override;
    function TryParseText(const AText: String; ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParseText(const AText: Utf8String; ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParseText(const AText: AnsiString; ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParseText(const p: PChar; len: Integer; ACallback: TQJsonParseCallback = nil): Boolean; overload;

    function TryParseFile(const AFileName: String; ACallback: TQJsonParseCallback = nil): Boolean;
    function TryParseStream(const AStream: TStream; AEncoding: TEncoding; ACallback: TQJsonParseCallback = nil)
      : Boolean;
    procedure ParseText(const AText: String; ACallback: TQJsonParseCallback = nil);
    procedure ParseFile(const AFileName: String; ACallback: TQJsonParseCallback = nil);
    procedure ParseStream(const AStream: TStream; AEncoding: TEncoding; ACallback: TQJsonParseCallback = nil);
    property Count: Integer read GetCount;
    property FirstChild: PQJsonNode read GetFirstChild;
    property LastChild: PQJsonNode read GetLastChild;
    property UserData: Pointer read GetUserData;
    property DataType: TQJsonDataType read GetDataType;
  end;

  // JSON 编码器
  TQJsonEncoder = class sealed

  end;

resourcestring
  SJsonParseError = 'JSON 解析第 %d 行第 %d 列时出错:%s';
  SUnknownJsonToken = '无法识别的关键词 %s';

implementation

var
  JsonStringEqualityComparer: IEqualityComparer<PString>;

type
  TQJsonStringEqualityComparer = class(TCustomComparer<PString>)
  protected
    function Compare(const Left, Right: PString): Integer; override;
    function Equals(const Left, Right: PString): Boolean; override;
    function GetHashCode(const Value: PString): Integer; override;
  end;

  { TQJsonParser }
function IsReference(p: Pointer; var ATarget: Pointer): Boolean;
const
  POINTER_MASK: IntPtr = not IntPtr(3);
begin
  if (IntPtr(p) and $1) <> 0 then
  begin
    Result := true;
    ATarget := Pointer(IntPtr(p) and POINTER_MASK);
  end
  else
    ATarget := p;
end;

function TQJsonParser.AnsiReadToken: TQJsonTokenKind;
begin
  // todo:读取一个JSON Token 到时 FStringBuilder
end;

procedure TQJsonParser.ClearStrings;
begin
  if Assigned(FNameIndexes) then
    FNameIndexes.Clear;
end;

constructor TQJsonParser.Create(const AMode: TQJsonStoreMode);
begin
  inherited Create;
  FStoreMode := AMode;
  if AMode = TQJsonStoreMode.jsmCacheStrings then
  begin
    FNameIndexes := THashSet<PString>.Create(JsonStringEqualityComparer);
    FNameIndexes.OnNotify := DoStringNotify;
  end;
end;

destructor TQJsonParser.Destroy;
begin
  if Assigned(FNameIndexes) then
  begin
    FNameIndexes.Clear;
    FreeAndNil(FNameIndexes);
  end;
  inherited;
end;

procedure TQJsonParser.DoStringNotify(Sender: TObject; const Item: PString; Action: TCollectionNotification);
begin
  if Action in [TCollectionNotification.cnRemoved, TCollectionNotification.cnExtracted] then
    Dispose(Item);
end;

function TQJsonParser.GetCount: Integer;
begin
  Result := FRoot.Count;
end;

function TQJsonParser.GetDataType: TQJsonDataType;
begin
  Result := FRoot.DataType;
end;

function TQJsonParser.GetFirstChild: PQJsonNode;
begin
  Result := FRoot.FirstChild;
end;

function TQJsonParser.GetLastChild: PQJsonNode;
begin
  Result := FRoot.LastChild;
end;

function TQJsonParser.GetUserData: Pointer;
begin
  Result := FRoot.UserData;
end;

procedure TQJsonParser.InternalParse(AParent: PQJsonNode);
begin

end;

function TQJsonParser.InternalTryParseText(const p: PByte; AReader: TTokenReader;
  ACallback: TQJsonParseCallback): Boolean;
begin
  Reset;
  FTokenReader := AReader;
  FBuffer := p;
  FCurrent := p;
  InternalParse(@FRoot);
  Result := FErrorCode = 0;
end;

function TQJsonParser.NeedBytes(ACount: Cardinal): Boolean;
begin
  Assert(ACount <= JSON_STREAM_BUFFER_SIZE);
  if FBufferSize - (FCurrent - FBuffer) < ACount then
  begin
    if Assigned(FBufferReader) then
    begin
      FBufferReader(Self);
      Result := FBufferSize - (FCurrent - FBuffer) = ACount;
    end
    else
      Result := false;
  end
  else
    Result := true;
end;

procedure TQJsonParser.ParseFile(const AFileName: String; ACallback: TQJsonParseCallback);
begin
  if not TryParseFile(AFileName, ACallback) then
    raise EJsonError.CreateFmt(SJsonParseError, [FErrorLine, FErrorColumn, FErrorMsg]);
end;

procedure TQJsonParser.ParseStream(const AStream: TStream; AEncoding: TEncoding; ACallback: TQJsonParseCallback);
begin
  if not TryParseStream(AStream, AEncoding, ACallback) then
    raise EJsonError.CreateFmt(SJsonParseError, [FErrorLine, FErrorColumn, FErrorMsg]);
end;

procedure TQJsonParser.ParseText(const AText: String; ACallback: TQJsonParseCallback);
begin
  if not TryParseText(AText, ACallback) then
    raise EJsonError.CreateFmt(SJsonParseError, [FErrorLine, FErrorColumn, FErrorMsg]);
end;

function TQJsonParser.ReadStreamBuffer(AParser: TQJsonParser): Cardinal;
var
  AStream: TStream;
  ARemainBytes: Cardinal;
begin
  AStream := TStream(AParser.FRoot.UserData);
  ARemainBytes := JSON_STREAM_BUFFER_SIZE - (FCurrent - FBuffer);
  if ARemainBytes > 0 then
    Move(FCurrent^, FBuffer^, ARemainBytes);
  FBufferSize := AStream.Read(FBuffer[ARemainBytes], JSON_STREAM_BUFFER_SIZE - ARemainBytes) + ARemainBytes;
  FCurrent := FBuffer;
end;

procedure TQJsonParser.Reset;
begin
  FErrorLine := 0;
  FErrorColumn := 0;
  FLineNo := 0;
  FColNo := 0;
  SetLength(FErrorMsg, 0);
  FTokenReader := nil;
  FBufferReader := nil;
  FRoot.Clear;
end;

function TQJsonParser.TryParseFile(const AFileName: String; ACallback: TQJsonParseCallback): Boolean;
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := TryParseStream(AStream, nil, ACallback);
  finally
    FreeAndNil(AStream);
  end;
end;

function TQJsonParser.TryParseStream(const AStream: TStream; AEncoding: TEncoding;
  ACallback: TQJsonParseCallback): Boolean;
  procedure DetectEncoding;
  var
    I: Integer;
  begin
    // 检测 BOM
    if FBufferSize >= 2 then
    begin
      if (FBuffer[0] = $FF) and (FBuffer[1] = $FE) then
      begin
        AEncoding := TEncoding.Unicode;
        FCurrent := FBuffer + 2;
      end
      else if (FBuffer[0] = $FE) and (FBuffer[1] = $FF) then
      begin
        AEncoding := TEncoding.BigEndianUnicode;
        FCurrent := FBuffer + 2;
      end
      else if (FBufferSize >= 3) then
      begin
        if (FBuffer[0] = $EF) and (FBuffer[1] = $BB) and (FBuffer[2] = $BF) then // BOM
        begin
          AEncoding := TEncoding.UTF8;
          FCurrent := FBuffer + 3;
        end;
      end;
      if not Assigned(AEncoding) then
      begin
        if (FBuffer[0] > 0) and (FBuffer[1] = 0) then
          AEncoding := TEncoding.Unicode
        else if (FBuffer[0] = 0) and (FBuffer[1] > 0) then
          AEncoding := TEncoding.BigEndianUnicode;
      end;
    end;
  end;

begin
  GetMem(FBuffer, JSON_STREAM_BUFFER_SIZE);
  try
    FBufferSize := JSON_STREAM_BUFFER_SIZE;
    FCurrent := FBuffer;
    if not Assigned(AEncoding) then
    begin
      FBufferSize := AStream.Read(FBuffer[0], JSON_STREAM_BUFFER_SIZE);
      DetectEncoding;
      if not Assigned(AEncoding) then
        AEncoding := TEncoding.ANSI;
    end
    else
      FBufferSize := AStream.Read(FBuffer[0], JSON_STREAM_BUFFER_SIZE);
    FBufferReader := ReadStreamBuffer;
    FRoot.UserData := AStream;
    InternalParse(@FRoot);
  finally
    FreeMem(FBuffer);
    FBuffer := nil;
    FCurrent := nil;
    FRoot.UserData := nil;
  end;
end;

function TQJsonParser.TryParseText(const p: PChar; len: Integer; ACallback: TQJsonParseCallback): Boolean;
begin
  Result := InternalTryParseText(PByte(p), Utf16LeReadToken, ACallback);
end;

function TQJsonParser.Utf16BeReadToken: TQJsonTokenKind;
begin
  // todo:读取一个JSON Token 到时 FStringBuilder
end;

function TQJsonParser.Utf16LeReadToken: TQJsonTokenKind;
  function IsSimpleToken(const AExpect: String): Boolean;
  var
    AToken: String;
  begin
    FStringBuilder.Length := 0;
    while FBufferSize - (FCurrent - FBuffer) > 0 do
    begin
      FStringBuilder.Append(PWideChar(FCurrent)^);
      Inc(FCurrent, 2);
      Inc(FColNo);
      if CharInSet(PWideChar(FCurrent)^, [',', ' ', #9, #10, #13]) then
        break;
      if (FCurrent - FBuffer) = FBufferSize then
      begin
        if Assigned(FBufferReader) then
          FBufferReader(Self);
      end;
    end;
    AToken := FStringBuilder.ToString;
    if CompareText(AToken, 'TRUE') = 0 then
      Result := true
    else
    begin
      FErrorLine := FLineNo;
      FErrorColumn := FColNo - FStringBuilder.Length;
      FErrorMsg := Format(SUnknownJsonToken, [AToken]);
      Result := false;
    end;
  end;

begin
  // todo:读取一个JSON Token 到时 FStringBuilder
  while (FCurrent - FBuffer) < FBufferSize do
  begin
    case PWideChar(FCurrent)^ of
      ' ', #9, #13:
        begin
          Inc(FCurrent, 2);
          Inc(FColNo);
        end;
      #10:
        begin
          Inc(FLineNo);
          FColNo := 0;
        end
    else
      break;
    end;
    if (FCurrent - FBuffer) = FBufferSize then
    begin
      if Assigned(FBufferReader) then
        FBufferReader(Self);
    end;
  end;
  if FBufferSize = 0 then // 结束了
    Exit(TQJsonTokenKind.jtkEof);
  case PWideChar(FCurrent)^ of
    '{':
      begin
        Inc(FCurrent, 2);
        Inc(FColNo);
        Exit(TQJsonTokenKind.jtkObjectStart);
      end;
    '}':
      begin
        Inc(FCurrent, 2);
        Inc(FColNo);
        Exit(TQJsonTokenKind.jtkObjectEnd);
      end;
    '[':
      begin
        Inc(FCurrent, 2);
        Inc(FColNo);
        Exit(TQJsonTokenKind.jtkArrayStart);
      end;
    ']':
      begin
        Inc(FCurrent, 2);
        Inc(FColNo);
        Exit(TQJsonTokenKind.jtkArrayEnd);
      end;
    ',':
      begin
        Inc(FCurrent, 2);
        Inc(FColNo);
        Exit(TQJsonTokenKind.jtkItemDelimiter);
      end;
    't', 'T':
      begin
        if IsSimpleToken('TRUE') then
          Exit(TQJsonTokenKind.jtkTrue)
        else
          Exit(TQJsonTokenKind.jtkUnknown);
      end;
    'f', 'F':
      begin
        if IsSimpleToken('FALSE') then
          Exit(TQJsonTokenKind.jtkFalse)
        else
          Exit(TQJsonTokenKind.jtkUnknown);
      end;
    'n':
      begin
        if IsSimpleToken('NULL') then
          Exit(TQJsonTokenKind.jtkNull)
        else
          Exit(TQJsonTokenKind.jtkUnknown);
      end;
    '0' .. '9', '.':
      begin
        // 读取数值
      end;
    '"':
      begin
        Inc(FCurrent, 2);
        Inc(FColNo);
        FStringBuilder.Length := 0;
        // Todo:解析字符串
        Exit(TQJsonTokenKind.jtkString);
      end;
  end;
end;

function TQJsonParser.Utf8ReadToken: TQJsonTokenKind;
begin
  // todo:读取一个JSON Token 到时 FStringBuilder
end;

function TQJsonParser.TryParseText(const AText: AnsiString; ACallback: TQJsonParseCallback): Boolean;
begin
  Result := InternalTryParseText(PByte(AText), AnsiReadToken, ACallback);
end;

function TQJsonParser.TryParseText(const AText: Utf8String; ACallback: TQJsonParseCallback): Boolean;
begin
  Result := InternalTryParseText(PByte(AText), Utf8ReadToken, ACallback);
end;

function TQJsonParser.TryParseText(const AText: String; ACallback: TQJsonParseCallback): Boolean;
begin
  Result := InternalTryParseText(PByte(AText), Utf16LeReadToken, ACallback);
end;

{ TQJsonStringEqualityComparer }

function TQJsonStringEqualityComparer.Compare(const Left, Right: PString): Integer;
begin
  Result := CompareStr(Left^, Right^);
end;

function TQJsonStringEqualityComparer.Equals(const Left, Right: PString): Boolean;
begin
  Result := CompareStr(Left^, Right^) = 0;
end;

function TQJsonStringEqualityComparer.GetHashCode(const Value: PString): Integer;
begin
  Result := THashFNV1a32.GetHashValue(PChar(Value^)^, SizeOf(Char) * Length(Value^));
end;

{ TQJsonNode }

procedure TQJsonNode.Clear;
var
  ANode: PQJsonNode;
begin
  while Assigned(FirstChild) do
  begin
    ANode := FirstChild.Next;
    FirstChild.Clear;
    Dispose(FirstChild);
    FirstChild := ANode;
  end;
  Count := 0;
  LastChild := nil;
  if DataType in [jdtString, jdtLineComment, jdtBlockComment] then
  begin
    var
      V: PString;
    if not IsReference(Value.AsPointer, Pointer(V)) then
      Dispose(V);
  end;
end;

end.

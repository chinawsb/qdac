unit qdac.json.core;

interface

// Todo:support json schema :https://json-schema.org/understanding-json-schema/keywords
// FPC 暂时未提供 Hash 单元，所以在使用 FPC 时，使用 FAST_HASH_CODE 宏
uses Classes, SysUtils, SysConst, Timespan, Generics.Collections, NetEncoding,
  FmtBcd,
  DateUtils, Math, qdac.serialize.core,
  Generics.Defaults{$IFNDEF FPC}, Hash{$ENDIF};
{$I 'qdac.inc'}
{$UNDEF FAST_HASH_CODE}

const
  // 默认从流中加载 JSON 时的缓冲区大小，更大的缓存区有助于提高IO速度，默认 8KB
  JSON_STREAM_BUFFER_SIZE = 8192;
  EJSON_HEX_CHAR_NEEDED = 1;
  EJSON_BAD_CHAR = 2;
  EJSON_BAD_TOKEN = 3;
  EJSON_BAD_NUMBER = 4;
  EJSON_BAD_UTF8CHAR = 5;

type
  EJsonError = class(Exception);
  TQJsonParser = class;
  PQJsonNode = ^TQJsonNode;

  PQJsonChildren = ^TQJsonChildren;
  // JSON 数据类型，这里的顺序不要随便调整
  TQJsonDataType = (jdtUnknown, jdtLineComment, jdtBlockComment, jdtNull,
    jdtBoolean, jdtInteger, jdtDateTime, jdtFloat, jdtBcd, jdtString, jdtArray,
    jdtObject);
  // 解析阶段
  TQJsonParseStage = (jpsStartItem, jpsParseValue, jpsEndItem, jpsStartArray,
    jpsEndArray, jpsStartObject, jpsEndObject);
  // 解析动作：继承/跳过后续/停止解析
  TQJsonParseAction = (jpaContinue, jpaSkipCurrent, jpaSkipSiblings, jpaStop);
  // 存贮模式：正常，缓存重复字符串值以节省内存,快速只进
  TQJsonStoreMode = (jsmNormal, jsmCacheNames, jsmCacheStrings, jsmForwardOnly);
  // 关键词类型
  TQJsonTokenKind = (jtkUnknown, jtkEof, jtkNull, jtkTrue, jtkFalse, jtkInteger,
    jtkFloat, jtkString, jtkKVDelimiter, jtkArrayStart, jtkArrayEnd,
    jtkItemDelimiter, jtkObjectStart, jtkObjectEnd, jtkLineComment,
    jtkBlockComment);
  /// <summary>
  /// JSON 编码成字符串时的控制选项
  /// </summary>
  /// <list>
  /// <item>
  /// <term>jesIgnoreNull</term><description>忽略jdtNull/jdtUnknown类型成员</description>
  /// </item>
  /// <item>
  /// <term>jdtIgnoreDefault</term><description>忽略掉jdtNull/jdtUnknown类型及其它类型的默认值：空字符串/0/false</description>
  /// </item>
  /// <item>
  /// <term>jesDoFormat</term><description>格式化 JSON 字符串</description>
  /// </item>
  /// <item>
  /// <term>jesDoEscape</term><description>转义Unicode字符</description>
  /// </item>
  /// <item>
  /// <term>jesNullAsString</term><description>将 jdtNull/jdtUnknown 转换为空字符串</description>
  /// </item>
  /// <item>
  /// <item>
  /// <term>jesUnixUTCDateTime</term><description>日期时间类型转换为 Unix UTC时间戳</description>
  /// </item>
  /// <item>
  /// <term>jesWithComment</term><description>编码时包含注释</description>
  /// </item>
  /// <term>jesForceAsString</term><description>输出时，数字、布尔、null全部输出为字符串</description>
  /// </item>
  /// </list>
  TQJsonEncodeSetting = (jesIgnoreNull, jesIgnoreDefault, jesDoFormat,
    jesDoEscape, jesEscapeQuoterOnly, jesNullAsString, jesWithComment,
    jesForceAsString);
  TQJsonEncodeSettings = set of TQJsonEncodeSetting;
  TQJsonDateTimeKind = (tkFormatedText, tkUnixTimeStamp);

  TQJsonFormatSettings = record
    DateFormat, TimeFormat, DateTimeFormat, IndentText: UnicodeString;
    TimeKind: TQJsonDateTimeKind;
    Settings: TQJsonEncodeSettings;
  end;

  TQJsonStringCaches = class sealed(TQValueCaches<UnicodeString>)
  private
    class var FCurrent: TQJsonStringCaches;
    class function GetCurrent: TQJsonStringCaches; static;
  public
    class property Current: TQJsonStringCaches read GetCurrent;
  end;

  TQPointerCaches = record
    Capacity, FirstDirty: Integer;
    Items: Pointer;
  end;

  // 对象或数组值
  TQJsonChildren = record
    // 结点关联
    First, Last: PQJsonNode;
    // 子结点数
    Count: Integer;
    // 缓存索引
    Caches: TQPointerCaches;
  end;

  TQJsonValue = record
    case Integer of
      0:
        (AsBoolean: Boolean);
      1:
        (AsInt64: Int64);
      2:
        (AsFloat: Extended);
      3:
        (AsDateTime: TDateTime);
      4:
        (AsString: PUnicodeString);
      5:
        (Items: TQJsonChildren);
      6:
        (AsPointer: Pointer);
      7:
        (AsBcd: PBcd);
  end;

  TQJsonReadBuffer = function(AParser: TQJsonParser): Cardinal of object;
  TQJsonParseCallback = reference to procedure(AParser: TQJsonParser;
    AItem: PQJsonNode; AStage: TQJsonParseStage;
    var AParseAction: TQJsonParseAction);
  TQJsonNodeEnumCallback = reference to procedure(ANode: PQJsonNode;
    var AContinue: Boolean);

  TQJsonNode = record
  public
    // 名称,引用自缓存
    FName: PUnicodeString;
    // 父子关联
    FParent: PQJsonNode;
    // 邻居，注意在只进解析模式下，其值无意义
    FPrior, FNext: PQJsonNode;
    // 索引
    FIndex: Integer;
    // 数据类型
    FDataType: TQJsonDataType;
    // 值
    FValue: TQJsonValue;
    // 用户数据，具体用途取决于上层，在使用内部的RTTI解析时，会将其做为关联的实例的地址信息
    FUserData: Pointer;
  private
    function GetCount: Integer;
    function GetLevel: Integer;
    function GetFirstChild: PQJsonNode;
    function GetLastChild: PQJsonNode;
    procedure SetDataType(const Value: TQJsonDataType);
    function GetAsBoolean: Boolean;
    procedure SetAsBoolean(const Value: Boolean);
    function GetPath: UnicodeString;
    function GetAsString: UnicodeString;
    procedure SetAsString(const Value: UnicodeString);
    procedure InternalEncode(ABuilder: PQPageBuffers;
      const AIndent: UnicodeString; const AFormat: TQJsonFormatSettings);
    function GetAsJson: UnicodeString;
    procedure SetAsJson(const Value: UnicodeString);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function GetAsInt64: Int64;
    procedure SetAsInt64(const Value: Int64);
    procedure ConvertTypeError(ASourceType, ATargetType: TQJsonDataType);
    function GetAsFloat: Extended;
    procedure SetAsFloat(const Value: Extended);
    function GetAsBcd: TBcd;
    procedure SetAsBcd(const Value: TBcd);
    procedure SetCache(AIndex: NativeInt; ANode: PQJsonNode);
    function GetCache(AIndex: NativeInt): PQJsonNode;
    procedure Dirty(const AIndex: Integer);
    function InternalAdd: PQJsonNode;
    procedure SetAsStringRef(const Value: UnicodeString);
    function GetName: UnicodeString;
    function GetAsBase64Bytes: TBytes;
    procedure SetAsBase64Bytes(const Value: TBytes);
    procedure Initialize(AParent: PQJsonNode; AType: TQJsonDataType); inline;
  public
    class function Create: TQJsonNode; static; // 仅为好看
    class function CreateAsArray: TQJsonNode; static; // 明确下
    class function CreateAsObject: TQJsonNode; static;
    procedure Free; inline; // 仅为仿类
    procedure DisposeOf; inline; // 仅为仿类
    procedure Reset;
    // 编解码
    function Encode(AFormat: TQJsonFormatSettings): UnicodeString;
    function TryParse(const S: UnicodeString;
      AMode: TQJsonStoreMode = jsmNormal; ACallback: TQJsonParseCallback = nil)
      : Boolean; overload;
    function TryParse(const S: AnsiString; AMode: TQJsonStoreMode = jsmNormal;
      ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParse(const S: Utf8String; AMode: TQJsonStoreMode = jsmNormal;
      ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryLoadFromStream(AStream: TStream; AMode: TQJsonStoreMode;
      AEncoding: TEncoding = nil; ACallback: TQJsonParseCallback = nil)
      : Boolean;
    procedure LoadFromStream(AStream: TStream; AMode: TQJsonStoreMode;
      AEncoding: TEncoding = nil; ACallback: TQJsonParseCallback = nil);
    function TryLoadFromFile(const AFileName: UnicodeString;
      AMode: TQJsonStoreMode; AEncoding: TEncoding;
      ACallback: TQJsonParseCallback = nil): Boolean;
    procedure LoadFromFile(const AFileName: UnicodeString;
      AMode: TQJsonStoreMode; AEncoding: TEncoding = nil;
      ACallback: TQJsonParseCallback = nil);
    procedure SaveToStream(AStream: TStream; AEncoding: TEncoding;
      const AFormat: TQJsonFormatSettings; AWriteBom: Boolean);
    procedure SaveToFile(const AFileName: UnicodeString; AEncoding: TEncoding;
      const AFormat: TQJsonFormatSettings; AWriteBom: Boolean);
    // 添加数组元素子结点
    function Add: PQJsonNode; overload;
    function Add(const AValue: Int64): PQJsonNode; overload;
    function Add(const AValue: Extended): PQJsonNode; overload;
    function Add(const AValue: TBcd): PQJsonNode; overload;
    function Add(const AValue: TDateTime): PQJsonNode; overload;
    function Add(const AValue: UnicodeString): PQJsonNode; overload;
    function Add(const AValue: Boolean): PQJsonNode; overload;
    function AddArray: PQJsonNode; overload;
    function AddObject: PQJsonNode; overload;
    // 添加对象元素改成用 AddKey/AddPair 替换 3.0 的接口，避免原来的歧义,原来3.0 Add 对应的重载废弃
    function AddKey(const AName: UnicodeString): PQJsonNode;
    function AddPair(const AName: UnicodeString; AValue: Boolean)
      : PQJsonNode; overload;
    function AddPair(const AName: UnicodeString; const AValue: Int64)
      : PQJsonNode; overload;
    function AddPair(const AName: UnicodeString; const AValue: Extended)
      : PQJsonNode; overload;
    function AddPair(const AName: UnicodeString; const AValue: TBcd)
      : PQJsonNode; overload;
    function AddPair(const AName: UnicodeString; const AValue: TDateTime)
      : PQJsonNode; overload;
    function AddPair(const AName, AValue: UnicodeString): PQJsonNode; overload;
    function AddPairArray(const AName: UnicodeString): PQJsonNode;
    function AddPairObject(const AName: UnicodeString): PQJsonNode;
    // 元素维护
    procedure Delete(const AIndex: Integer);
    procedure Clear;
    function ItemByPath(const APath: UnicodeString;
      const ADelimiter: WideChar = '.'): PQJsonNode;
    function ItemByName(const AName: UnicodeString): PQJsonNode;
    function HasChild(const APath: UnicodeString;
      var ANode: PQJsonNode): Boolean;
    function Exists(const APath: UnicodeString): Boolean;
    procedure Detach;
    procedure Attach(ANewParent: PQJsonNode);
    procedure SortByNames(AComparer: IComparer<UnicodeString>;
      ADesc, AIsNest: Boolean);
    procedure SortByValues(AComparer: IComparer<PQJsonNode>;
      ADesc, AIsNest: Boolean);
    function ToArray: TArray<PQJsonNode>;
    procedure CopyTo(ANode: PQJsonNode);
    // 合并 ASource 中的项目，重复的会被忽略，返回合并的数量
    function Merge(ASource: PQJsonNode): Integer;
    // 替换与 ASource 中重名的项目的值，返回替换的数量
    function Replace(ASource: PQJsonNode): Integer;
    procedure ForEach(ACallback: TQJsonNodeEnumCallback);
    // 成员访问
    // 布尔
    function BoolByName(const AName: UnicodeString;
      const ADefVal: Boolean = false): Boolean;
    function BoolByPath(const APath: UnicodeString;
      const ADefVal: Boolean = false): Boolean;
    function TryToBool(var AValue: Boolean): Boolean;

    // 整数
    function IntByName(const AName: UnicodeString;
      const ADefVal: Int64 = 0): Int64;
    function IntByPath(const APath: UnicodeString;
      const ADefVal: Int64 = 0): Int64;
    function TryToInt(var AValue: Int64): Boolean;
    // 浮点
    function FloatByName(const AName: UnicodeString;
      const ADefVal: Extended = 0): Extended;
    function FloatByPath(const APath: UnicodeString;
      const ADefVal: Extended = 0): Extended;
    function TryToFloat(var AValue: Extended): Boolean;
    // Bcd
    function BcdByName(const AName: UnicodeString; const ADefVal: TBcd): TBcd;
    function BcdByPath(const APath: UnicodeString; const ADefVal: TBcd): TBcd;
    function TryToBcd(var AValue: TBcd): Boolean;

    // 日期时间
    function DateTimeByName(const AName: UnicodeString;
      const ADefVal: TDateTime = 0): TDateTime;
    function DateTimeByPath(const APath: UnicodeString;
      const ADefVal: TDateTime = 0): TDateTime;
    function TryToDateTime(var AValue: TDateTime): Boolean;

    // 字符串
    function ValueByName(const AName: UnicodeString;
      ADefVal: UnicodeString = ''): String;
    function ValueByPath(const AName: UnicodeString;
      ADefVal: UnicodeString = ''): String;

    property Name: UnicodeString read GetName;
    property Path: UnicodeString read GetPath;
    property Level: Integer read GetLevel;
    property FirstChild: PQJsonNode read GetFirstChild;
    property LastChild: PQJsonNode read GetLastChild;
    property Count: Integer read GetCount;
    property Items[AIndex: NativeInt]: PQJsonNode read GetCache;
    property DataType: TQJsonDataType read FDataType write SetDataType;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsString: UnicodeString read GetAsString write SetAsString;
    property AsStringRef: UnicodeString read GetAsString write SetAsStringRef;
    property AsBase64: TBytes read GetAsBase64Bytes write SetAsBase64Bytes;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsInt: Int64 read GetAsInt64 write SetAsInt64;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsBcd: TBcd read GetAsBcd write SetAsBcd;
    property AsJson: UnicodeString read GetAsJson write SetAsJson;
  end;

  // JSON 解析器
  // 名称缓存模式下，需要考虑将 FNameIndexes 设置为全局，这样就可以尽量少占用内存，字符串值一般不缓存，但枚举类型就几个值，可以缓存重复使用
  TQJsonParser = class sealed(TInterfacedObject)
  private type
    TCharReader = procedure of object;

    TLastUtf8Char = record
      Chars: array [0 .. 1] of WideChar;
      Index: Word;
    end;
  private
    FEncoding: TEncoding;
    FRoot: PQJsonNode;
    FBufferReader: TQJsonReadBuffer;
    FCharReader: TCharReader;
    FOnParseStage: TQJsonParseCallback;
    FStoreMode: TQJsonStoreMode;
    FParseAction: TQJsonParseAction;
    FActiveTokenKind: TQJsonTokenKind;
    FErrorCode, FErrorLine, FErrorColumn: Cardinal;
    FLineNo, FColNo, FBufferSize, FLastCharSize: Cardinal;
    // FStringBuilder 要避免重新分配内存和创建实例
    FStringBuilder: TQPageBuffers;
    FErrorMsg: UnicodeString;
    // 最后一次的 UTF16LE 字符编码
    FLastChar: Cardinal;
    // 如果是UTF8，由于可能对应的UTF6LE编码需要占4个字节，所以这儿要进一步处理
    FBuffer, FCurrent, FEof: PByte;
    FStrict: Boolean;
    procedure Reset;
    function ReadStreamBuffer(AParser: TQJsonParser): Cardinal;
    function NeedCharBytes(const ACharSize: Cardinal): Boolean;
    procedure PeekCharU16LE;
    procedure PeekCharAnsi;
    procedure PeekCharU16BE;
    procedure PeekCharUTF8;
    procedure PeekNextChar;
    procedure AppendAndPeekNextChar;
    procedure AppendLastChar; inline;
    function PeekAndRemoveHexValue(var AValue: Cardinal): Boolean;
    function LastCharIn(const cmin, cmax: WideChar; delims: PWideChar)
      : Boolean; inline;
    procedure SkipSpace;
    function IsFixedToken(AExpect: PWideChar): Boolean;
    function ReadNumber(var ANode: TQJsonNode; ABcd: PBcd): Boolean;
    function ReadString: Boolean;
    procedure SkipString;
    procedure SetLastError(const ACode: Cardinal; const AMsg: UnicodeString);
    function ReadToken: Boolean;
    function InternalTryParseText(const p: PByte; AReader: TCharReader;
      ACallback: TQJsonParseCallback): Boolean;
    procedure DoParseStage(ANode: PQJsonNode; AStage: TQJsonParseStage); inline;
    function ParseChildren(AParent: PQJsonNode): Boolean;
    function ParseValue(var AChild: TQJsonNode; ABcd: PBcd): Boolean;
    procedure DoParse;
    function LastChars: UnicodeString;
  public
    constructor Create(const AMode: TQJsonStoreMode = jsmNormal;
      AStrict: Boolean = false); overload;
    destructor Destroy; override;
    function TryParseText(ARoot: PQJsonNode; const AText: UnicodeString;
      ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParseText(ARoot: PQJsonNode; const AText: Utf8String;
      ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParseText(ARoot: PQJsonNode; const AText: AnsiString;
      ACallback: TQJsonParseCallback = nil): Boolean; overload;
    function TryParseText(ARoot: PQJsonNode; const p: PWideChar; len: Integer;
      ACallback: TQJsonParseCallback = nil): Boolean; overload;

    function TryParseFile(ARoot: PQJsonNode; const AFileName: UnicodeString;
      AEncoding: TEncoding; ACallback: TQJsonParseCallback = nil): Boolean;
    function TryParseStream(ARoot: PQJsonNode; const AStream: TStream;
      AEncoding: TEncoding; ACallback: TQJsonParseCallback = nil): Boolean;
    procedure ParseText(ARoot: PQJsonNode; const AText: UnicodeString;
      ACallback: TQJsonParseCallback = nil);
    procedure ParseFile(ARoot: PQJsonNode; const AFileName: UnicodeString;
      AEncoding: TEncoding; ACallback: TQJsonParseCallback = nil);
    procedure ParseStream(ARoot: PQJsonNode; const AStream: TStream;
      AEncoding: TEncoding; ACallback: TQJsonParseCallback = nil);
  end;

  TQJsonDecoder = class sealed(TQBaseReader)
  protected
    FRootNode: TQJsonNode;
    FText: UnicodeString;
    FStream: TStream;
    procedure DoParse; override;
    procedure HandleStage(AParser: TQJsonParser; AItem: PQJsonNode;
      AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction);
  public
    constructor Create(AStream: TStream); overload;
    constructor Create(const AText: UnicodeString); overload;
  end;

  // JSON 编码器
  TQJsonEncoder = class sealed(TInterfacedObject, IQSerializeWriter)
  private type
    PQJsonStackItem = ^TQJsonStackItem;
    TWriteStage = (wsValue, wsName);

    TQJsonStackItem = record
      Prior, Next: PQJsonStackItem;
      Indent: UnicodeString;
      Stage: TWriteStage;
      Count: Integer;
      DataType: TQJsonDataType;
    end;

    class var FDefaultFormat: TQJsonFormatSettings;

  var
    FRoot: TQJsonStackItem;
    FStream: TStream;
    FCurrent: PQJsonStackItem;
    FEncoding: TEncoding;
    FBuffer: TBytes;
    FBuffered: Integer;
    FStartOffset: Int64;
    FFormat: TQJsonFormatSettings;
  protected
    class procedure DoJsonEscape(ABuilder: PQPageBuffers;
      const S: UnicodeString; ADoEscape: Boolean);
    procedure NextType(AType: TQJsonDataType);
    procedure WriteString(const AValue: UnicodeString; ADoQuote: Boolean);
    procedure WritePrefix(AIsLast: Boolean = false);
    procedure InternalWritePair(const AName, AValue: UnicodeString;
      ADoQuote: Boolean);
    procedure InternalWriteValue(const AValue: UnicodeString;
      ADoQuote: Boolean);
  public
    class constructor Create;
    class function JavaEscape(const S: UnicodeString; ADoEscape: Boolean)
      : UnicodeString;
    constructor Create(AStream: TStream; AWriteBom: Boolean;
      const AFormat: TQJsonFormatSettings; AEncoding: TEncoding;
      ABufSize: Integer); overload;
    constructor Create; overload;
    destructor Destroy; override;
    procedure StartObject;
    procedure EndObject;
    procedure StartArray;
    procedure EndArray;
    procedure WriteValue(const V: UnicodeString); overload;
    procedure WriteValue(const V: Int64; AIsSign: Boolean = true); overload;
    procedure WriteValue(const V: UInt64); overload;
    procedure WriteValue(const V: Extended;
      const AFormat: String = ''); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency;
      const AFormat: String = ''); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteNull; overload;
    //
    procedure StartObjectPair(const AName: UnicodeString);
    procedure StartArrayPair(const AName: UnicodeString);
    procedure StartPair(const AName: UnicodeString);
    procedure WritePair(const AName: UnicodeString;
      const V: UnicodeString); overload;
    procedure WritePair(const AName: UnicodeString; const V: Int64;
      AIsSign: Boolean = true); overload;
    procedure WritePair(const AName: UnicodeString; const V: Extended;
      const AFormat: UnicodeString = ''); overload;
    procedure WritePair(const AName: UnicodeString; const V: TBcd); overload;
    procedure WritePair(const AName: UnicodeString; const V: Boolean); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: TDateTime); overload;
    procedure WritePair(const AName: UnicodeString; const V: Currency;
      const AFormat: UnicodeString = ''); overload;
    procedure WritePair(const AName: UnicodeString; const V: TBytes); overload;
    procedure WritePair(const AName: UnicodeString); overload;
    //
    procedure WriteComment(const AComment: UnicodeString);
    procedure Flush;
    function ToString: String; override;
    class property DefaultFormat: TQJsonFormatSettings read FDefaultFormat
      write FDefaultFormat;
  end;

resourcestring
  SJsonParseError = 'JSON 解析第 %d 行第 %d 列时出错:%s';
  SUnknownJsonToken = '无法识别的 JSON 字符 %s';
  SCharNeeded = '字符 %c 不在 %s 之中';
  SUnexpectToken = '非预期的字符串 %s';
  SValueNotNumber = '%s 不是一个有效的数值类型';
  SExpectCharNotFound = '未找到期望的字符 %s ';
  SBadUtf8CharFound = '无效的 UTF8 编码字符';
  SBadLineComment = '字符串不是有效的行注释内容';
  SBadBlockComment = '字符串不是有效的块注释内容';

const
  LowerHexChars: array [0 .. 15] of WideChar = ('0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
  JsonDataTypeNames: array [TQJsonDataType] of UnicodeString = ('unknown',
    'null', 'bool', 'number', 'number', 'number', 'string', 'datetime', 'array',
    'object', 'comment', 'comment');
  CSpaceMin = #$09;
  CSpaceMax = #$20;
  CSpaces: array [0 .. 3] of WideChar = (#$20, #10, #13, #9);
  CTokenDelimeters: array [0 .. 6] of WideChar = (
    // 逗号
    #$2C,
    // ']'
    #$5D,
    // }
    #$7D,
    // 空格
    #$20,
    // \n
    #$0A,
    // \t
    #$09,
    // \r
    #$0D);
  CNoTokenMin = #$09;
  CNoTokenMax = #$7D;
  // 兼容 3.0 的接口，但不再推荐，直接从队列
function AcquireJson: PQJsonNode;
procedure ReleaseJson(ANode: PQJsonNode);

implementation

type
  TQJsonStringEqualityComparer = class(TCustomComparer<UnicodeString>)
  protected
    function Compare(const Left, Right: UnicodeString): Integer; override;
    function Equals(const Left, Right: UnicodeString): Boolean; override;
    function GetHashCode(const Value: UnicodeString): Integer; override;
  end;

function AcquireJson: PQJsonNode;
begin
  // 初始版本只为兼容，后面加入页面池缓存支持
  New(Result);
  FillChar(Result^, SizeOf(TQJsonNode), 0);
end;

procedure ReleaseJson(ANode: PQJsonNode);
begin
  Dispose(ANode);
end;
{ TQJsonParser }

procedure TQJsonParser.AppendAndPeekNextChar;
begin
  AppendLastChar;
  if FLastChar = $0A then
  begin
    Inc(FLineNo);
    FColNo := 0;
  end
  else
    Inc(FColNo);
  Inc(FCurrent, FLastCharSize);
  FCharReader;
end;

procedure TQJsonParser.AppendLastChar;
begin
  if FLastChar >= $10000 then
  begin
    FStringBuilder.Append(WideChar((((FLastChar - $00010000) shr 10) and
      $000003FF) or $D800));
    FStringBuilder.Append(WideChar(((FLastChar - $00010000) and $000003FF)
      or $DC00));
  end
  else
    FStringBuilder.Append(WideChar(FLastChar));
end;

constructor TQJsonParser.Create(const AMode: TQJsonStoreMode; AStrict: Boolean);
begin
  inherited Create;
  FStoreMode := AMode;
  FStrict := AStrict;
  FStringBuilder.Initialize;
end;

destructor TQJsonParser.Destroy;
begin
  FStringBuilder.Cleanup;
  inherited;
end;

procedure TQJsonParser.DoParseStage(ANode: PQJsonNode;
  AStage: TQJsonParseStage);
begin
  if Assigned(FOnParseStage) then
    FOnParseStage(Self, ANode, AStage, FParseAction);
end;

function TQJsonParser.InternalTryParseText(const p: PByte; AReader: TCharReader;
  ACallback: TQJsonParseCallback): Boolean;
begin
  Reset;
  FOnParseStage := ACallback;
  FCharReader := AReader;
  FBuffer := p;
  FCurrent := FBuffer;
  DoParse;
  Result := FErrorCode = 0;
end;

function TQJsonParser.IsFixedToken(AExpect: PWideChar): Boolean;
begin
  while (Ord(AExpect^) = FLastChar) or (Ord(AExpect^) = (FLastChar + $20)) do
  begin
    PeekNextChar;
    Inc(AExpect);
  end;
  if AExpect^ <> #0 then
    Result := false
  else
    Result := (FLastChar = 0) or LastCharIn(CNoTokenMin, CNoTokenMax,
      CTokenDelimeters);
end;

function TQJsonParser.LastCharIn(const cmin, cmax: WideChar;
  delims: PWideChar): Boolean;
begin
  if (FLastChar >= Ord(cmin)) and (FLastChar <= Ord(cmax)) then
  begin
    while delims^ <> #0 do
    begin
      if FLastChar = Ord(delims^) then
        Exit(true);
      Inc(delims);
    end;
  end;
  Result := false;
end;

function TQJsonParser.LastChars: UnicodeString;
begin
  if FLastChar < $10000 then
    Result := WideChar(FLastChar)
  else
  begin
    SetLength(Result, 2);
    Result[Low(Result)] :=
      WideChar((((FLastChar - $00010000) shr 10) and $000003FF) or $D800);
    Result[High(Result)] := WideChar(((FLastChar - $00010000) and $000003FF)
      or $DC00);
  end;
end;

function TQJsonParser.NeedCharBytes(const ACharSize: Cardinal): Boolean;
begin
  FLastCharSize := ACharSize;
  Result := true;
  if NativeUInt(FEof - FCurrent) < ACharSize then
  begin
    if not Assigned(FBufferReader) or (FBufferReader(Self) = 0) or
      (NativeUInt(FEof - FCurrent) < ACharSize) then
    begin
      FLastChar := 0;
      if FEof > FCurrent then
        SetLastError(EJSON_BAD_UTF8CHAR, SBadUtf8CharFound);
      Result := false;
    end;
  end;
end;

function TQJsonParser.ParseChildren(AParent: PQJsonNode): Boolean;
var
  ATemp: TQJsonNode;
  AChild: PQJsonNode;
  AName: UnicodeString;
  // Used for cache only
  ABcd: TBcd;
  procedure NeedChild;
  begin
    case FStoreMode of
      jsmNormal, jsmCacheNames, jsmCacheStrings:
        begin
          case FParseAction of
            jpaContinue:
              begin
                New(AChild);
                AChild.Initialize(AParent, jdtUnknown);
              end;
            jpaSkipSiblings: // 跳过相邻结点模式下，后续兄弟结点只是占位，并不实际解析
              begin
                AChild := @ATemp;
                AChild.FPrior := AParent.FValue.Items.Last;
                AChild.FIndex := AParent.FValue.Items.Count;
                Inc(AParent.FValue.Items.Count);
                AChild.FParent := AParent;
              end;
            jpaStop:
              // 不应该执行到这儿
              Assert(FParseAction <> jpaStop);
          end;
        end;
      jsmForwardOnly:
        begin
          if not Assigned(AChild) then
          begin
            AChild := @ATemp;
            AChild.Initialize(nil, jdtUnknown);
            AChild.FName := TQJsonStringCaches.MakeReference(@AName);
            AChild.FParent := AParent;
          end
          else
            Inc(AChild.FIndex);
          Inc(AParent.FValue.Items.Count);
        end;
    end;
  end;

begin
  Result := ReadToken;
  if not Result then
    Exit;
  AChild := nil;
  case AParent.DataType of
    jdtArray:
      begin
        DoParseStage(AParent, TQJsonParseStage.jpsStartArray);
        while (FParseAction <> TQJsonParseAction.jpaStop) do
        begin
          if FActiveTokenKind <> jtkArrayEnd then
          begin
            NeedChild;
            if ParseValue(AChild^, @ABcd) and ReadToken then
            begin
              if FActiveTokenKind = jtkItemDelimiter then
              begin
                if ReadToken then
                  continue
                else
                  break;
              end
              else if FActiveTokenKind = jtkArrayEnd then
              begin
                DoParseStage(AParent, TQJsonParseStage.jpsEndArray);
                Exit(FErrorCode = 0);
              end
            end
            else
              break;
          end
          else
          begin
            DoParseStage(AParent, TQJsonParseStage.jpsEndArray);
            Exit;
          end;
        end;
        SetLastError(EJSON_BAD_TOKEN, Format(SUnexpectToken, [LastChars]));
      end;
    jdtObject:
      begin
        DoParseStage(AParent, TQJsonParseStage.jpsStartObject);
        while (FParseAction <> TQJsonParseAction.jpaStop) do
        begin
          if FActiveTokenKind = jtkObjectEnd then
          begin
            DoParseStage(AParent, TQJsonParseStage.jpsEndObject);
            Exit(FErrorCode = 0);
          end
          else if FActiveTokenKind = jtkString then
          begin
            NeedChild;
            // 解析项目名称
            if FParseAction = TQJsonParseAction.jpaContinue then
            begin
              if ReadString then
              begin
                FStringBuilder.ToString(AName);
                case FStoreMode of
                  jsmNormal:
                    begin
                      New(AChild.FName);
                      AChild.FName^ := AName;
                    end;
                  jsmCacheNames, jsmCacheStrings:
                    AChild.FName := TQJsonStringCaches.Current.AddRef(@AName);
                  jsmForwardOnly:
                    // AName=AChild.FName
                    ;
                end;
                DoParseStage(AChild, TQJsonParseStage.jpsStartItem);
              end
              else
              begin
                SetLastError(EJSON_BAD_CHAR, Format(SUnknownJsonToken,
                  [LastChars]));
                Exit(false);
              end;
            end
            else
              SkipString;
            if ReadToken and (FActiveTokenKind = jtkKVDelimiter) and ReadToken
            then
            begin
              if ParseValue(AChild^, @ABcd) and ReadToken then
              begin
                if FActiveTokenKind = jtkItemDelimiter then
                begin
                  if ReadToken then
                    continue
                  else
                    break;
                end
                else if FActiveTokenKind = jtkObjectEnd then
                begin
                  DoParseStage(AParent, TQJsonParseStage.jpsEndObject);
                  Exit(FErrorCode = 0);
                end
              end
              else
                break;
            end;
          end;
          SetLastError(EJSON_BAD_TOKEN, Format(SUnexpectToken, [LastChars]));
        end;
      end;
  end;
  Result := FErrorCode = 0;
end;

procedure TQJsonParser.ParseFile(ARoot: PQJsonNode;
  const AFileName: UnicodeString; AEncoding: TEncoding;
  ACallback: TQJsonParseCallback);
begin
  if not TryParseFile(ARoot, AFileName, AEncoding, ACallback) then
    raise EJsonError.CreateFmt(SJsonParseError, [FErrorLine, FErrorColumn,
      FErrorMsg]);
end;

procedure TQJsonParser.ParseStream(ARoot: PQJsonNode; const AStream: TStream;
  AEncoding: TEncoding; ACallback: TQJsonParseCallback);
begin
  if not TryParseStream(ARoot, AStream, AEncoding, ACallback) then
    raise EJsonError.CreateFmt(SJsonParseError, [FErrorLine, FErrorColumn,
      FErrorMsg]);
end;

procedure TQJsonParser.ParseText(ARoot: PQJsonNode; const AText: UnicodeString;
  ACallback: TQJsonParseCallback);
begin
  if not TryParseText(ARoot, AText, ACallback) then
    raise EJsonError.CreateFmt(SJsonParseError, [FErrorLine, FErrorColumn,
      FErrorMsg]);
end;

function TQJsonParser.ParseValue(var AChild: TQJsonNode; ABcd: PBcd): Boolean;
var
  ASavedAction: TQJsonParseAction;
  AValue: UnicodeString;
begin
  Result := true;
  case FActiveTokenKind of
    jtkNull:
      begin
        AChild.DataType := jdtNull;
        DoParseStage(@AChild, TQJsonParseStage.jpsEndItem);
      end;
    jtkTrue:
      begin
        if FParseAction = TQJsonParseAction.jpaContinue then
        begin
          AChild.AsBoolean := true;
          DoParseStage(@AChild, TQJsonParseStage.jpsEndItem);
        end;
      end;
    jtkFalse:
      begin
        if FParseAction = TQJsonParseAction.jpaContinue then
        begin
          AChild.AsBoolean := false;
          DoParseStage(@AChild, TQJsonParseStage.jpsEndItem);
        end;
      end;
    jtkFloat:
      begin
        if FParseAction = TQJsonParseAction.jpaContinue then
        begin
          if ReadNumber(AChild, ABcd) then
          begin
            DoParseStage(@AChild, TQJsonParseStage.jpsEndItem);
          end
          else
            SetLastError(EJSON_BAD_TOKEN, Format(SUnexpectToken,
              [FStringBuilder.ToString]));
        end;
      end;
    jtkString:
      begin
        if FParseAction = TQJsonParseAction.jpaContinue then
        begin
          AChild.DataType := jdtString;
          if ReadString then
          begin
            case FStoreMode of
              jsmNormal, jsmCacheNames:
                begin
                  if not Assigned(AChild.FValue.AsString) then
                    New(AChild.FValue.AsString);
                  FStringBuilder.ToString(AChild.FValue.AsString^);
                end;
              jsmCacheStrings:
                begin
                  FStringBuilder.ToString(AValue);
                  AChild.FValue.AsString :=
                    TQJsonStringCaches.Current.AddRef(@AValue);
                end;
              jsmForwardOnly:
                begin
                  FStringBuilder.ToString(AValue);
                  AChild.FValue.AsString :=
                    TQJsonStringCaches.MakeReference(@AValue);
                end;
            end;
            DoParseStage(@AChild, TQJsonParseStage.jpsEndItem);
          end
          else
            SetLastError(EJSON_BAD_CHAR, Format(SUnknownJsonToken,
              [LastChars]));;
        end
        else
          SkipString;
      end;
    jtkArrayStart:
      begin
        AChild.DataType := jdtArray;
        ASavedAction := FParseAction;
        if ParseChildren(@AChild) then
        begin
          FParseAction := ASavedAction;
        end
        else
          SetLastError(EJSON_BAD_TOKEN, Format(SUnexpectToken,
            [FStringBuilder.ToString]));
      end;
    jtkItemDelimiter:
      begin
        (* 暂时忽略，在考虑将来加入自定义的格式支持，比如支持 [1,2,,3,,,,5,7] 对应于 [1,2,null,3,null,null,null,5,7] 这种格式的支持，
          但这种格式标准 JSON 解析器并不支持，但对于导出数据来说，这样子可以节省大量的空间占用，如导出表数据时，可以实现如下样式
          {
          "fields":["id","name","age","score","locate"],
          "rows"[
          [1,"jone",12,60,"G"],
          [2,"kilx",,25,'B'],
          [3,"tom",,,]
          }
          也就是说，数据库里值为空或默认值的字段，我们都可以直接用不写，从而减少网络传输数据量
        *)
      end;
    jtkObjectStart:
      begin
        AChild.DataType := jdtObject;
        ASavedAction := FParseAction;
        if ParseChildren(@AChild) then
        begin
          FParseAction := ASavedAction;
        end
        else
          SetLastError(EJSON_BAD_TOKEN, Format(SUnexpectToken,
            [FStringBuilder.ToString]));
      end;
    jtkLineComment, jtkBlockComment:
      begin
        if FParseAction = TQJsonParseAction.jpaContinue then
        begin
          if FActiveTokenKind = jtkLineComment then
            AChild.DataType := jdtLineComment
          else
            AChild.DataType := jdtBlockComment;
          AChild.FValue.AsString := TQJsonStringCaches.MakeReference(@AValue);
          FStringBuilder.ToString(AValue);
        end;
      end
  else
    begin
      Result := false;
      SetLastError(EJSON_BAD_TOKEN, Format(SUnexpectToken,
        [FStringBuilder.ToString]));
    end;
  end;
end;

function TQJsonParser.PeekAndRemoveHexValue(var AValue: Cardinal): Boolean;
begin
  Result := true;
  PeekNextChar;
  case FLastChar of
    Ord('0') .. Ord('9'):
      AValue := FLastChar - Ord('0');
    Ord('a') .. Ord('f'):
      AValue := 10 + FLastChar - Ord('a');
    Ord('A') .. Ord('F'):
      AValue := 10 + FLastChar - Ord('A')
  else
    Result := false;
  end;
end;

procedure TQJsonParser.PeekCharAnsi;
var
  AChars: array [0 .. 4] of WideChar;
begin
  // 非 Unicode 编码都走这儿，使用 UnicodeFromLocaleChars 来获取单个字符的长度
  if FEof = FCurrent then
  begin
    if not Assigned(FBufferReader) or (FBufferReader(Self) = 0) then
    begin
      FLastChar := 0;
      Exit;
    end;
  end;
  if FCurrent^ < $7F then // 1B Ascii 编码字符，直接返回
  begin
    FLastChar := FCurrent^;
    FLastCharSize := 1;
  end
  else if Assigned(FEncoding) then
  begin
    if FEof - FCurrent < 4 then //
    begin
      if Assigned(FBufferReader) then
        FBufferReader(Self);
    end;
    FLastCharSize := FEof - FCurrent;
    if FLastCharSize > 4 then
      FLastCharSize := 4;
    while (FLastCharSize > 0) and (UnicodeFromLocaleChars(FEncoding.CodePage, 0,
      MarshaledAString(FCurrent), FLastCharSize, @AChars, 5) > 1) do
      Dec(FLastCharSize, 2);
    if FLastCharSize = 0 then
    begin
      FLastChar := FCurrent^;
      FLastCharSize := 1;
    end
    else
      FLastChar := Ord(AChars[0]);
  end
  else
    FLastChar := 0;
end;

procedure TQJsonParser.PeekCharU16BE;
begin
  if FEof = FCurrent then
  begin
    if Assigned(FBufferReader) and (FBufferReader(Self) > 0) then
      // 从流中读取？
      FLastChar := (Cardinal(FCurrent[0]) shl 8) or (FCurrent[1])
    else
      FLastChar := 0;
  end
  else
    FLastChar := (Cardinal(FCurrent[0]) shl 8) or (FCurrent[1]);
  if FLastChar >= $D800 then
  begin
    NeedCharBytes(4);
    FLastChar := $10000 + (FLastChar - $D800) shl 10 +
      ((Cardinal(FCurrent[2]) shl 8) or (FCurrent[3])) - $DC00;
  end
  else
    FLastCharSize := 2;
end;

procedure TQJsonParser.PeekCharU16LE;
begin
  if FEof = FCurrent then
  begin
    if Assigned(FBufferReader) and (FBufferReader(Self) > 0) then
      // 从流中读取？
      FLastChar := PWord(FCurrent)^
    else
      FLastChar := 0;
  end
  else
    FLastChar := PWord(FCurrent)^;
  if FLastChar >= $D800 then
  begin
    NeedCharBytes(4);
    FLastChar := $10000 + (FLastChar - $D800) shl 10;
    Inc(FLastChar, PWord(@FCurrent[2])^ - $DC00);
  end
  else
    FLastCharSize := 2;
end;

procedure TQJsonParser.PeekCharUTF8;
begin
  if FEof = FCurrent then
  begin
    if not Assigned(FBufferReader) or (FBufferReader(Self) = 0) then
    begin
      FLastChar := 0;
      Exit;
    end;
  end;
  if FCurrent^ < $7F then // 1B
  begin
    FLastChar := FCurrent^;
    FLastCharSize := 1;
  end
  else if (FCurrent^ and $FC) = $FC then // 4000000+
  begin
    if not NeedCharBytes(6) then
      Exit;
    FLastChar := ((FCurrent[0] and $03) shl 30) or
      ((FCurrent[1] and $3F) shl 24) or ((FCurrent[2] and $3F) shl 18) or
      ((FCurrent[3] and $3F) shl 12) or ((FCurrent[4] and $3F) shl 6) or
      (FCurrent[5] and $3F);
  end
  else if (FCurrent^ and $F8) = $F8 then
  // 200000-3FFFFFF
  begin
    if not NeedCharBytes(5) then
      Exit;
    FLastChar := ((FCurrent[0] and $07) shl 24) or
      ((FCurrent[1] and $3F) shl 18) or ((FCurrent[2] and $3F) shl 12) or
      ((FCurrent[3] and $3F) shl 6) or (FCurrent[4] and $3F);
  end
  else if (FCurrent^ and $F0) = $F0 then // 10000-1FFFFF
  begin
    if not NeedCharBytes(4) then
      Exit;
    FLastChar := ((FCurrent[0] and $0F) shr 18) or
      ((FCurrent[1] and $3F) shl 12) or ((FCurrent[2] and $3F) shl 6) or
      (FCurrent[3] and $3F);
  end
  else if (FCurrent^ and $E0) = $E0 then
  // 800-FFFF
  begin
    if not NeedCharBytes(3) then
      Exit;
    FLastChar := ((FCurrent[0] and $1F) shl 12) or ((FCurrent[1] and $3F) shl 6)
      or (FCurrent[2] and $3F);
  end
  else if (FCurrent^ and $C0) = $C0 then
  // 80-7FF
  begin
    if not NeedCharBytes(2) then
      Exit;
    FLastChar := ((FCurrent[0] and $3F) shl 6) or (FCurrent[1] and $3F);
  end;
end;

procedure TQJsonParser.PeekNextChar;
begin
  if FLastChar = $0A then
  begin
    Inc(FLineNo);
    FColNo := 0;
  end
  else
    Inc(FColNo);
  Inc(FCurrent, FLastCharSize);
  FCharReader;
end;

function TQJsonParser.ReadNumber(var ANode: TQJsonNode; ABcd: PBcd): Boolean;
type
  TQJsonFloatParseResult = (prInt, prFloat, prBcd, prFailed);
{$Q-}
  function ParseInt(var AValue: Int64): TQJsonFloatParseResult;
  var
    ALast: Int64;
  begin
    AValue := 0;
    ALast := 0;
    Result := TQJsonFloatParseResult.prInt;
    if FLastChar = Ord('0') then
    begin
      AppendAndPeekNextChar;
      case FLastChar of
        Ord('x'), Ord('X'): // Hex
          begin
            AppendAndPeekNextChar;
            while (FLastChar <> 0) and
              (Result = TQJsonFloatParseResult.prInt) do
            begin
              case FLastChar of
                Ord('0') .. Ord('9'):
                  AValue := (AValue shl 4) + FLastChar - Ord('0');
                Ord('a') .. Ord('f'):
                  AValue := (AValue shl 4) + FLastChar - Ord('a') + 10;
                Ord('A') .. Ord('F'):
                  AValue := (AValue shl 4) + FLastChar - Ord('A') + 10
              else
                Exit(TQJsonFloatParseResult.prFailed);
              end;
              if ALast > AValue then // 溢出？
                Exit(TQJsonFloatParseResult.prFailed);
              ALast := AValue;
              AppendAndPeekNextChar;
            end;
          end;
        Ord('b'), Ord('B'): // Bin
          begin
            AppendAndPeekNextChar;
            while (FLastChar <> 0) and
              (Result = TQJsonFloatParseResult.prInt) do
            begin
              case FLastChar of
                Ord('0') .. Ord('1'):
                  AValue := (AValue shl 1) Or (FLastChar - Ord('0'))
              else
                Exit(TQJsonFloatParseResult.prFailed);
              end;
              if ALast > AValue then // 溢出？
                Exit(TQJsonFloatParseResult.prFailed);
              ALast := AValue;
              AppendAndPeekNextChar;
            end;
          end
      else // Oct
        begin
          AppendAndPeekNextChar;
          while (FLastChar <> 0) and (Result = TQJsonFloatParseResult.prInt) do
          begin
            case FLastChar of
              Ord('0') .. Ord('7'):
                AValue := (AValue shl 3) + FLastChar - Ord('0');
            else
              Exit(TQJsonFloatParseResult.prFailed);
            end;
            if ALast > AValue then // 溢出？
              Exit(TQJsonFloatParseResult.prFailed);
            ALast := AValue;
            AppendAndPeekNextChar;
          end;
        end;
      end;
    end
    else // Dec
    begin
      while (FLastChar <> 0) and (Result = TQJsonFloatParseResult.prInt) do
      begin
        case FLastChar of
          Ord('0') .. Ord('9'):
            begin
              AValue := AValue * 10 + FLastChar - Ord('0');
              if AValue < 0 then
                Result := TQJsonFloatParseResult.prBcd;
              AppendAndPeekNextChar;
            end
        else
          break;
        end;
        if ALast > AValue then // 溢出？
          Exit(TQJsonFloatParseResult.prBcd);
        ALast := AValue;
      end;
    end;
  end;
{$Q+}
  function ParseFloat(var AInt: Int64; var AValue: Extended; AStage: Integer)
    : TQJsonFloatParseResult;
  var
    AValues: array [0 .. 1] of Int64;
    AExpr: Extended;
    AIsNegative: Boolean;
  begin
    if FLastChar = Ord('-') then
    begin
      AIsNegative := true;
      AppendAndPeekNextChar;
    end
    else
    begin
      AIsNegative := false;
      if FLastChar = Ord('+') then
        AppendAndPeekNextChar;
    end;
    Result := ParseInt(AValues[0]);
    if Result = TQJsonFloatParseResult.prInt then
    begin
      AInt := AValues[0];
      case FLastChar of
        0, Ord(','), Ord('}'), Ord(']'):
          ;
        Ord('.'): // 取浮点部分
          begin
            AValue := AValues[0];
            if Trunc(AValue) = AValues[0] then
            begin
              AppendAndPeekNextChar;
              Result := ParseInt(AValues[1]);
              if (Result = TQJsonFloatParseResult.prInt) and (AValues[1] >= 0)
              then
              begin
                // 计算小数点部分
                AValue := AValues[1];
                while AValues[1] > 0 do
                begin
                  AValue := AValue / 10;
                  AValues[1] := AValues[1] div 10;
                end;
                AValue := AValues[0] + AValues[1];
                if Trunc(AValue) <> AValues[0] then // 整数部分如果丢失精度，那么当Bcd处理
                  Exit(TQJsonFloatParseResult.prBcd)
                else
                begin
                  SkipSpace;
                  case FLastChar of
                    0, Ord(','), Ord('}'), Ord(']'):
                      Result := TQJsonFloatParseResult.prFloat;
                  else
                    Exit(TQJsonFloatParseResult.prFailed);
                  end;
                end;
              end
              else
                Exit(TQJsonFloatParseResult.prFailed);
            end
            else
              Exit(TQJsonFloatParseResult.prBcd);
          end;
        Ord('e'), Ord('E'):
          begin
            AppendAndPeekNextChar;
            if AStage = 0 then
            begin
              Result := ParseFloat(AInt, AExpr, 1);
              if Result in [TQJsonFloatParseResult.prInt,
                TQJsonFloatParseResult.prFloat] then
              begin
                ANode.DataType := jdtFloat;
                AValue := AValue * Power(10, AExpr);
              end
              else
                Exit;
            end
            else
              Exit(TQJsonFloatParseResult.prFailed);
          end;
      end;
      // Case end
      if AIsNegative and (Result in [TQJsonFloatParseResult.prInt,
        TQJsonFloatParseResult.prFloat]) then
      begin
        AInt := -AInt;
        AValue := -AValue;
      end;
    end
    else
      Result := TQJsonFloatParseResult.prFailed;
  end;

  procedure Failed;
  begin
    if FStrict then
    begin
      SetLastError(EJSON_BAD_NUMBER, Format(SValueNotNumber,
        [FStringBuilder.ToString]));
      FParseAction := TQJsonParseAction.jpaStop;
      Result := false;
    end
    else
    begin
      while (FLastChar <> 0) and
        (not LastCharIn(CNoTokenMin, CNoTokenMax, CTokenDelimeters)) do
      begin
        AppendLastChar;
        PeekNextChar;
      end;
      ANode.AsString := FStringBuilder.ToString
    end;
  end;

  procedure AsBcd;
  begin
    if TryStrToBcd(FStringBuilder.ToString, ABcd^) then
    begin
      if FStoreMode = TQJsonStoreMode.jsmForwardOnly then
        ANode.FValue.AsBcd := TQJsonStringCaches.MakeReference(ABcd)
      else
      begin
        ANode.DataType := jdtBcd;
        New(ANode.FValue.AsBcd);
        ANode.FValue.AsBcd^ := ABcd^;
      end;
    end
    else
      Failed;
  end;

var
  AInt: Int64;
  AFloat: Extended;
  AResult: TQJsonFloatParseResult;

begin
  // [+-]a.b[eE]c.d
  Result := true;
  FStringBuilder.Length := 0;
  AResult := ParseFloat(AInt, AFloat, 0);
  case AResult of
    TQJsonFloatParseResult.prBcd:
      AsBcd;
    TQJsonFloatParseResult.prFailed:
      Failed;
    TQJsonFloatParseResult.prInt:
      begin
        ANode.DataType := jdtInteger;
        ANode.FValue.AsInt64 := AInt;
      end;
    TQJsonFloatParseResult.prFloat:
      begin
        ANode.DataType := jdtFloat;
        ANode.FValue.AsFloat := AFloat;
      end;
  end;
end;

function TQJsonParser.ReadStreamBuffer(AParser: TQJsonParser): Cardinal;
var
  AStream: TStream;
  ARemainBytes: Cardinal;
begin
  AStream := TStream(AParser.FRoot.FUserData);
  ARemainBytes := FEof - FCurrent;
  if ARemainBytes > 0 then
    Move(FCurrent^, FBuffer^, ARemainBytes);
  FBufferSize := AStream.Read(FBuffer[ARemainBytes], JSON_STREAM_BUFFER_SIZE -
    ARemainBytes);
  Inc(FBufferSize, ARemainBytes);
  FCurrent := FBuffer;
  FEof := FCurrent + FBufferSize;
  Result := FBufferSize;
end;

function TQJsonParser.ReadString: Boolean;
var
  AQuoter: Cardinal;
  AHexBytes: array [0 .. 3] of Cardinal;
begin
  Result := false;
  AQuoter := FLastChar;
  repeat
    PeekNextChar;
    if FLastChar = AQuoter then
    begin
      PeekNextChar;
      if FLastChar = AQuoter then
        AppendLastChar
      else
        Exit(true);
    end
    else if FLastChar = Ord('\') then
    begin
      PeekNextChar;
      if (FLastChar = Ord('u')) then
      begin
        if PeekAndRemoveHexValue(AHexBytes[0]) and
          PeekAndRemoveHexValue(AHexBytes[1]) and
          PeekAndRemoveHexValue(AHexBytes[2]) and
          PeekAndRemoveHexValue(AHexBytes[3]) then
        // \uxxxx
        begin
          FStringBuilder.Append(WideChar((AHexBytes[0] shl 12) or
            (AHexBytes[1] shl 8) or (AHexBytes[2] shl 4) or AHexBytes[3]));
        end
        else
          break;
      end
      else
      begin
        case FLastChar of
          Ord('a'):
            FStringBuilder.Append(#7);
          Ord('b'):
            FStringBuilder.Append(#8);
          Ord('t'):
            FStringBuilder.Append(#9);
          Ord('n'):
            FStringBuilder.Append(#10);
          Ord('v'):
            FStringBuilder.Append(#11);
          Ord('f'):
            FStringBuilder.Append(#12);
          Ord('r'):
            FStringBuilder.Append(#13);
          Ord('\'):
            FStringBuilder.Append('\')
        else
          begin
            if FLastChar = AQuoter then
              FStringBuilder.Append(AQuoter)
            else if FStrict then
              break
            else
            begin
              FStringBuilder.Append('\');
              AppendLastChar;
            end;
          end;
        end;
      end;
    end
    else
      AppendLastChar;
  until (FLastChar = 0) or (FLastChar = AQuoter);
end;

function TQJsonParser.ReadToken: Boolean;
begin
  // 读取下一个关键词类型及内容
  FStringBuilder.Length := 0;
  SkipSpace;
  if (FBufferSize = 0) or (FLastChar = 0) then // 结束了
    FActiveTokenKind := jtkEof
  else
  begin
    FActiveTokenKind := jtkUnknown;
    case FLastChar of
      Ord('{'):
        begin
          FActiveTokenKind := jtkObjectStart;
          PeekNextChar;
        end;
      Ord('}'):
        begin
          FActiveTokenKind := jtkObjectEnd;
          PeekNextChar;
        end;
      Ord('['):
        begin
          FActiveTokenKind := jtkArrayStart;
          PeekNextChar;
        end;
      Ord(']'):
        begin
          FActiveTokenKind := jtkArrayEnd;
          PeekNextChar;
        end;
      Ord(','):
        begin
          FActiveTokenKind := jtkItemDelimiter;
          PeekNextChar;
        end;
      Ord('t'), Ord('T'):
        begin
          if IsFixedToken('true') then
            FActiveTokenKind := jtkTrue;
        end;
      Ord('f'), Ord('F'):
        begin
          if IsFixedToken('false') then
            FActiveTokenKind := jtkFalse;
        end;
      Ord('n'):
        begin
          if IsFixedToken('null') then
            FActiveTokenKind := jtkNull;
        end;
      Ord(':'):
        begin
          FActiveTokenKind := jtkKVDelimiter;
          PeekNextChar;
        end;
      Ord('/'):
        begin
          PeekNextChar;
          if FLastChar = Ord('/') then // 行备注
          begin
            FActiveTokenKind := jtkLineComment;
            PeekNextChar;
            while FLastChar <> 0 do
            begin
              if FLastChar <> $0A then
                AppendLastChar
              else
                break;
            end;
          end
          else if FLastChar = Ord('*') then
          // 块备注
          begin
            FActiveTokenKind := jtkBlockComment;
            PeekNextChar;
            while FLastChar <> 0 do
            begin
              if FLastChar = Ord('*') then
              begin
                PeekNextChar;
                if FLastChar = Ord('/') then
                begin
                  PeekNextChar;
                  break;
                end
                else
                  FStringBuilder.Append('*');
              end;
              AppendAndPeekNextChar;
            end;
          end
          else
            SetLastError(EJSON_BAD_CHAR, Format(SUnknownJsonToken,
              [String('/') + WideChar(FLastChar)]));;
        end;
      Ord('0') .. Ord('9'), Ord('.'), Ord('-'), Ord('+'), Ord('e'), Ord('E'):
        FActiveTokenKind := jtkFloat;
      Ord('"'):
        FActiveTokenKind := jtkString;
      Ord(''''):
        begin
          if not FStrict then
            FActiveTokenKind := jtkString
          else
            SetLastError(EJSON_BAD_CHAR, Format(SUnknownJsonToken,
              [LastChars]));
        end;
    else
      SetLastError(EJSON_BAD_CHAR, Format(SUnknownJsonToken, [LastChars]));
    end;
  end;
  Result := (FErrorCode = 0) and
    (not(FActiveTokenKind in [TQJsonTokenKind.jtkUnknown,
    TQJsonTokenKind.jtkEof]));
end;

procedure TQJsonParser.Reset;
begin
  FErrorCode := 0;
  FErrorLine := 0;
  FErrorColumn := 0;
  SetLength(FErrorMsg, 0);
  FLineNo := 0;
  FColNo := 0;
  FCharReader := nil;
  FBufferReader := nil;
  FRoot.Reset;
  FStringBuilder.Length := 0;
end;

procedure TQJsonParser.SetLastError(const ACode: Cardinal;
  const AMsg: UnicodeString);
begin
  FErrorCode := ACode;
  FErrorMsg := AMsg;
  FErrorLine := FLineNo;
  FErrorColumn := FColNo - Cardinal(FStringBuilder.Length);
  FParseAction := TQJsonParseAction.jpaStop;
end;

procedure TQJsonParser.SkipSpace;
begin
  FCharReader;
  while LastCharIn(CSpaceMin, CSpaceMax, CSpaces) do
    PeekNextChar;
end;

procedure TQJsonParser.SkipString;
var
  AQuoter: Cardinal;
begin
  AQuoter := FLastChar;
  repeat
    PeekNextChar;
    if FLastChar = AQuoter then
    begin
      PeekNextChar;
      if FLastChar = AQuoter then
        AppendLastChar
      else
        break;
    end
    else if FLastChar = Ord('\') then
    begin
      PeekNextChar;
      if (FLastChar = AQuoter) then
        PeekNextChar;
    end
    else
      AppendLastChar;
  until (FLastChar = 0) or (FLastChar = AQuoter);
end;

procedure TQJsonParser.DoParse;
var
  ABcd: TBcd;
begin
  // 取首个项目
  FParseAction := TQJsonParseAction.jpaContinue;
  FEof := FBuffer + FBufferSize;
  if ReadToken then
    ParseValue(FRoot^, @ABcd);
end;

function TQJsonParser.TryParseFile(ARoot: PQJsonNode;
  const AFileName: UnicodeString; AEncoding: TEncoding;
  ACallback: TQJsonParseCallback): Boolean;
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Result := TryParseStream(ARoot, AStream, AEncoding, ACallback);
  finally
    FreeAndNil(AStream);
  end;
end;

function TQJsonParser.TryParseStream(ARoot: PQJsonNode; const AStream: TStream;
  AEncoding: TEncoding; ACallback: TQJsonParseCallback): Boolean;
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
        Inc(FCurrent, 2);
      end
      else if (FBuffer[0] = $FE) and (FBuffer[1] = $FF) then
      begin
        AEncoding := TEncoding.BigEndianUnicode;
        Inc(FCurrent, 2);
      end
      else if (FBufferSize >= 3) then
      begin
        if (FBuffer[0] = $EF) and (FBuffer[1] = $BB) and (FBuffer[2] = $BF) then
        // BOM
        begin
          AEncoding := TEncoding.UTF8;
          Inc(FCurrent, 3);
        end;
      end;
      if not Assigned(AEncoding) then
      begin
        if (FBuffer[0] > 0) and (FBuffer[1] = 0) then
          AEncoding := TEncoding.Unicode
        else if (FBuffer[0] = 0) and (FBuffer[1] > 0) then
          AEncoding := TEncoding.BigEndianUnicode
        else
        begin
          if TEncoding.UTF8.IsBufferValid(FBuffer, FBufferSize) then
            AEncoding := TEncoding.UTF8
          else
            AEncoding := TEncoding.ANSI;
        end;
      end;
    end;
  end;

begin
  FRoot := ARoot;
  Reset;
  GetMem(FBuffer, JSON_STREAM_BUFFER_SIZE);
  try
    FBufferSize := JSON_STREAM_BUFFER_SIZE;
    FCurrent := FBuffer;
    if not Assigned(AEncoding) then
    begin
      FBufferSize := AStream.Read(FBuffer[0], JSON_STREAM_BUFFER_SIZE);
      DetectEncoding;
      if not Assigned(AEncoding) then
        FEncoding := TEncoding.ANSI;
    end
    else
      FBufferSize := AStream.Read(FBuffer[0], JSON_STREAM_BUFFER_SIZE);
    FEncoding := AEncoding;
    FBufferReader := ReadStreamBuffer;
    FRoot.FUserData := AStream;
    FOnParseStage := ACallback;
    case AEncoding.CodePage of
      65001: // UTF8
        FCharReader := PeekCharUTF8;
      1200:
        FCharReader := PeekCharU16LE;
      1201:
        FCharReader := PeekCharU16BE
    else
      FCharReader := PeekCharAnsi;
    end;
    DoParse;
    Result := FErrorCode = 0;
  finally
    FreeMem(FBuffer);
    FBuffer := nil;
    FCurrent := nil;
    FRoot.FUserData := nil;
  end;
end;

function TQJsonParser.TryParseText(ARoot: PQJsonNode; const p: PWideChar;
  len: Integer; ACallback: TQJsonParseCallback): Boolean;
begin
  FRoot := ARoot;
  FEncoding := TEncoding.Unicode;
  Result := InternalTryParseText(PByte(p), PeekCharU16LE, ACallback);
end;

function TQJsonParser.TryParseText(ARoot: PQJsonNode; const AText: AnsiString;
  ACallback: TQJsonParseCallback): Boolean;
begin
  FRoot := ARoot;
  FBufferSize := Length(AText);
  FEncoding := TEncoding.ANSI;
  Result := InternalTryParseText(PByte(AText), PeekCharAnsi, ACallback);
end;

function TQJsonParser.TryParseText(ARoot: PQJsonNode; const AText: Utf8String;
  ACallback: TQJsonParseCallback): Boolean;
begin
  FRoot := ARoot;
  FBufferSize := Length(AText);
  FEncoding := TEncoding.UTF8;
  Result := InternalTryParseText(PByte(AText), PeekCharUTF8, ACallback);
end;

function TQJsonParser.TryParseText(ARoot: PQJsonNode;
  const AText: UnicodeString; ACallback: TQJsonParseCallback): Boolean;
begin
  FRoot := ARoot;
  FBufferSize := Length(AText) * SizeOf(WideChar);
  Result := InternalTryParseText(PByte(AText), PeekCharU16LE, ACallback);
end;

{ TQJsonStringEqualityComparer }

function TQJsonStringEqualityComparer.Compare(const Left,
  Right: UnicodeString): Integer;
begin
  Result := CompareStr(Left, Right);
end;

function TQJsonStringEqualityComparer.Equals(const Left,
  Right: UnicodeString): Boolean;
begin
  Result := CompareStr(Left, Right) = 0;
end;

function TQJsonStringEqualityComparer.GetHashCode
  (const Value: UnicodeString): Integer;
{$IFDEF FAST_HASH_CODE}
// 快速哈希取字符串的长度、首字符、中间字符和最后一个字符的低8位，构成一个哈希值，从而节约计算内容的数量
const
  FNV_PRIME = $01000193; // 16777619
  FNV_SEED = $811C9DC5; // 2166136261
var
  l: Integer;
  p: PWideChar;
  AHash: Cardinal absolute Result;
{$ENDIF}
begin
{$IFDEF FAST_HASH_CODE}
{$Q-}
  AHash := FNV_SEED;
  l := Length(Value);
  AHash := (AHash xor Cardinal(l)) * FNV_PRIME;
  p := PWideChar(Value);
  if l < 6 then
  begin
    while l > 0 do
    begin
      AHash := (AHash xor Ord(p^)) * FNV_PRIME;
      Dec(l);
      Inc(p);
    end;
  end
  else // 超过12个字节，就取前中后3个32位进行运算
  begin
    // 前4个字节
    AHash := (AHash xor PCardinal(p)^) * FNV_PRIME;
    // 后4个字节
    Inc(p, l - 2);
    AHash := (AHash xor PCardinal(p)^) * FNV_PRIME;
    // 中4个字节
    Dec(p, l div 2 - 1);
    AHash := (AHash xor PCardinal(p)^) * FNV_PRIME;
  end;
{$ELSE}
  Result := THashFNV1a32.GetHashValue(PChar(Value)^,
    SizeOf(Char) * Length(Value));
{$ENDIF}
end;

{ TQJsonNode }

function TQJsonNode.Add: PQJsonNode;
begin
  Assert(FDataType = jdtArray);
  Result := InternalAdd;
end;

function TQJsonNode.Add(const AValue: Int64): PQJsonNode;
begin
  Result := Add;
  Result.AsInt := AValue;
end;

function TQJsonNode.Add(const AValue: Extended): PQJsonNode;
begin
  Result := Add;
  Result.AsFloat := AValue;
end;

function TQJsonNode.Add(const AValue: TDateTime): PQJsonNode;
begin
  Result := Add;
  Result.AsDateTime := AValue;
end;

procedure TQJsonNode.Clear;
var
  ANode: PQJsonNode;
begin
  if FDataType in [jdtArray, jdtObject] then
  begin
    ANode := FValue.Items.First;
    while Assigned(ANode) do
    begin
      FValue.Items.First := ANode.FNext;
      ANode.Reset;
      Dispose(ANode);
      ANode := FValue.Items.First;
    end;
    FValue.Items.Count := 0;
    FValue.Items.Last := nil;
    if Assigned(FValue.Items.Caches.Items) then
      FValue.Items.Caches.FirstDirty := 0;
    Exit;
  end
  else
  begin
    case FDataType of
      jdtBcd:
        Dispose(FValue.AsBcd);
      jdtString, jdtLineComment, jdtBlockComment:
        begin
          if Assigned(FValue.AsString) and
            (TQJsonStringCaches.Current.Release(FValue.AsString)
            = FValue.AsString) then
            Dispose(FValue.AsString);
        end;
    end;
    FillChar(FValue, SizeOf(FValue), 0);
  end;
end;

procedure TQJsonNode.ConvertTypeError(ASourceType, ATargetType: TQJsonDataType);
begin
  raise EConvertError.CreateFmt(SVarTypeCouldNotConvert,
    [JsonDataTypeNames[ASourceType], JsonDataTypeNames[ATargetType]])
end;

procedure TQJsonNode.CopyTo(ANode: PQJsonNode);
var
  AChild: PQJsonNode;
begin
  ANode.DataType := DataType;
  case DataType of
    jdtLineComment, jdtBlockComment, jdtString:
      begin
        if Assigned(FValue.AsString) then
        begin
          if TQJsonStringCaches.IsReference(FValue.AsString) then
            ANode.FValue.AsString := TQJsonStringCaches.Current.AddRef
              (FValue.AsString)
          else
          begin
            New(ANode.FValue.AsString);
            ANode.FValue.AsString^ := FValue.AsString^;
          end;
        end;
      end;
    jdtBoolean .. jdtFloat:
      ANode.FValue := FValue;
    jdtBcd:
      begin
        if Assigned(FValue.AsBcd) then
        begin
          New(ANode.FValue.AsBcd);
          ANode.FValue.AsBcd^ := FValue.AsBcd^;
        end;
      end;
    jdtArray:
      begin
        ANode.Clear;
        AChild := FValue.Items.First;
        while Assigned(AChild) do
        begin
          AChild.CopyTo(ANode.Add);
          AChild := AChild.FNext;
        end;
      end;
    jdtObject:
      begin
        ANode.Clear;
        AChild := FValue.Items.First;
        while Assigned(AChild) do
        begin
          AChild.CopyTo(ANode.AddKey(AChild.Name));
          AChild := AChild.FNext;
        end;
      end;
  end;
end;

class function TQJsonNode.Create: TQJsonNode;
begin
  Result.Initialize(nil, jdtUnknown);
end;

class function TQJsonNode.CreateAsArray: TQJsonNode;
begin
  Result.Initialize(nil, jdtArray);
end;

class function TQJsonNode.CreateAsObject: TQJsonNode;
begin
  Result.Initialize(nil, jdtObject);
end;

function TQJsonNode.DateTimeByName(const AName: UnicodeString;
  const ADefVal: TDateTime): TDateTime;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) and AChild.TryToDateTime(Result) then
    Exit
  else
    Result := ADefVal
end;

function TQJsonNode.DateTimeByPath(const APath: UnicodeString;
  const ADefVal: TDateTime): TDateTime;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByPath(APath);
  if Assigned(AChild) and AChild.TryToDateTime(Result) then
    Exit
  else
    Result := ADefVal
end;

procedure TQJsonNode.Delete(const AIndex: Integer);
var
  AChild: PQJsonNode;
begin
  AChild := GetCache(AIndex);
  if Assigned(AChild.FPrior) then
    AChild.FPrior.FNext := AChild.FNext
  else
    FValue.Items.First := AChild.FNext;
  if Assigned(AChild.FNext) then
    AChild.FNext.FPrior := AChild.FPrior
  else
    FValue.Items.Last := AChild.FPrior;
  Dirty(AIndex);
  AChild.Reset;
  Dispose(AChild);
end;

procedure TQJsonNode.Detach;
begin
  if Assigned(FParent) then
  begin
    with FParent.FValue.Items do
    begin
      Dec(Count);
      if Assigned(FPrior) then
        FPrior.FNext := FNext
      else
        First := FNext;
      if Assigned(FNext) then
        FNext.FPrior := FPrior
      else
        Last := FPrior;
    end;
    FParent := nil;
  end;
end;

procedure TQJsonNode.Dirty(const AIndex: Integer);
begin
  if FValue.Items.Caches.FirstDirty > AIndex then
    FValue.Items.Caches.FirstDirty := AIndex;
end;

procedure TQJsonNode.DisposeOf;
begin
  Reset;
end;

function TQJsonNode.Encode(AFormat: TQJsonFormatSettings): UnicodeString;
  function EncodeChildren: UnicodeString;
  var
    ABuilder: TQPageBuffers;
  begin
    ABuilder.Initialize;
    try
      InternalEncode(@ABuilder, AFormat.IndentText, AFormat);
      Result := ABuilder.ToString;
    finally
      ABuilder.Cleanup;
    end;
  end;

begin
  case FDataType of
    jdtUnknown, jdtNull:
      Result := 'null';
    jdtBoolean:
      begin
        if FValue.AsBoolean then
          Result := 'true'
        else
          Result := 'false';
      end;
    jdtInteger:
      Result := IntToStr(FValue.AsInt64);
    jdtFloat:
      Result := FloatToStr(FValue.AsFloat);
    jdtBcd:
      Result := BcdToStr(FValue.AsBcd^);
    jdtString, jdtLineComment, jdtBlockComment:
      Result := TQJsonStringCaches.Value(FValue.AsPointer);
    jdtArray:
      begin
        if FValue.Items.Count = 0 then
          Result := '[]'
        else
          Result := EncodeChildren;
      end;
    jdtObject:
      begin
        if FValue.Items.Count = 0 then
          Result := '{}'
        else
          Result := EncodeChildren;
      end
  else
    SetLength(Result, 0);
  end;
end;

function TQJsonNode.Exists(const APath: UnicodeString): Boolean;
begin
  Result := ItemByPath(APath) <> nil;
end;

function TQJsonNode.FloatByName(const AName: UnicodeString;
  const ADefVal: Extended): Extended;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) and AChild.TryToFloat(Result) then
    Exit
  else
    Result := ADefVal
end;

function TQJsonNode.FloatByPath(const APath: UnicodeString;
  const ADefVal: Extended): Extended;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByPath(APath);
  if Assigned(AChild) and AChild.TryToFloat(Result) then
    Exit
  else
    Result := ADefVal
end;

procedure TQJsonNode.ForEach(ACallback: TQJsonNodeEnumCallback);
var
  AChild: PQJsonNode;
  AContinue: Boolean;
begin
  Assert(DataType in [jdtObject, jdtArray]);
  AContinue := true;
  AChild := FValue.Items.First;
  while Assigned(AChild) and AContinue do
  begin
    ACallback(AChild, AContinue);
    AChild := AChild.FNext;
  end;
end;

procedure TQJsonNode.Free;
begin
  Reset;
end;

function TQJsonNode.GetAsBase64Bytes: TBytes;
begin
  if FDataType = jdtString then
    Result := TNetEncoding.Base64.DecodeStringToBytes(AsString)
  else
    raise EConvertError.CreateFmt(SVarTypeCouldNotConvert,
      [JsonDataTypeNames[FDataType], 'Base64']);
end;

function TQJsonNode.GetAsBcd: TBcd;
begin
  if not TryToBcd(Result) then
    ConvertTypeError(FDataType, jdtBcd);
end;
{$WARN NO_RETVAL OFF}

function TQJsonNode.GetAsBoolean: Boolean;
begin
  if not TryToBool(Result) then
    ConvertTypeError(FDataType, jdtBoolean);
end;
{$WARN NO_RETVAL DEFAULT}

function TQJsonNode.GetAsDateTime: TDateTime;
begin
  if not TryToDateTime(Result) then
    ConvertTypeError(FDataType, jdtDateTime);
end;
{$WARN NO_RETVAL OFF}

function TQJsonNode.GetAsFloat: Extended;
begin
  if not TryToFloat(Result) then
    ConvertTypeError(FDataType, jdtFloat);
end;

function TQJsonNode.GetAsInt64: Int64;
begin
  if not TryToInt(Result) then
    ConvertTypeError(FDataType, jdtInteger);
end;
{$WARN NO_RETVAL DEFAULT}

function TQJsonNode.GetAsJson: UnicodeString;
begin
  Result := Encode(Default (TQJsonFormatSettings));
end;

function TQJsonNode.GetAsString: UnicodeString;
var
  AFormat: TQJsonFormatSettings;
begin
  AFormat := TQJsonEncoder.DefaultFormat;
  AFormat.Settings := [jesEscapeQuoterOnly];
  Result := Encode(AFormat);
end;

function TQJsonNode.GetCache(AIndex: NativeInt): PQJsonNode;
begin
  with FValue.Items.Caches do
  begin
    if AIndex >= FirstDirty then
      SetCache(FValue.Items.Count - 1, FValue.Items.Last);
    Result := PPointer(IntPtr(Items) + SizeOf(Pointer) * AIndex)^;
  end;
end;

function TQJsonNode.GetCount: Integer;
begin
  if FDataType in [jdtArray, jdtObject] then
    Result := FValue.Items.Count
  else
    Result := 0;
end;

function TQJsonNode.GetFirstChild: PQJsonNode;
begin
  if FDataType in [jdtArray, jdtObject] then
    Result := FValue.Items.First
  else
    Result := nil;
end;

function TQJsonNode.GetLastChild: PQJsonNode;
begin
  if FDataType in [jdtArray, jdtObject] then
    Result := FValue.Items.Last
  else
    Result := nil;
end;

function TQJsonNode.GetLevel: Integer;
var
  AParent: PQJsonNode;
begin
  Result := 0;
  AParent := FParent;
  while Assigned(AParent) do
  begin
    Inc(Result);
    AParent := AParent.FParent;
  end;
end;

function TQJsonNode.GetName: UnicodeString;
begin
  if Assigned(FName) then
    Result := TQJsonStringCaches.Value(FName)
  else
    SetLength(Result, 0);
end;

function TQJsonNode.GetPath: UnicodeString;
begin
  if Assigned(FParent) then
  begin
    Result := FParent.Path;
    if FParent.DataType = jdtArray then
      Result := Result + '[' + FIndex.ToString + ']'
    else if Length(Result) > 0 then
      Result := Result + '.' + Name
    else
      Result := Name;
  end
  else
    Result := Name;
end;

function TQJsonNode.HasChild(const APath: UnicodeString;
  var ANode: PQJsonNode): Boolean;
begin
  ANode := ItemByPath(APath);
  Result := Assigned(ANode);
end;

procedure TQJsonNode.Initialize(AParent: PQJsonNode; AType: TQJsonDataType);
begin
  FName := nil;
  FParent := AParent;
  FPrior := nil;
  FNext := nil;
  FDataType := AType;
  FUserData := nil;
  if Assigned(AParent) then
  begin
    FPrior := AParent.FValue.Items.Last;
    if Assigned(FPrior) then
      FPrior.FNext := @Self
    else
      AParent.FValue.Items.First := @Self;
    AParent.FValue.Items.Last := @Self;
    FIndex := AParent.FValue.Items.Count;
    Inc(AParent.FValue.Items.Count);
  end
  else
  begin
    FPrior := nil;
    FNext := nil;
    FIndex := 0;
  end;
  FValue.Items.First := nil;
  FValue.Items.Last := nil;
  FValue.Items.Count := 0;
  FValue.Items.Caches.Capacity := 0;
  FValue.Items.Caches.FirstDirty := 0;
  FValue.Items.Caches.Items := nil;
end;

function TQJsonNode.IntByName(const AName: UnicodeString;
  const ADefVal: Int64): Int64;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) and AChild.TryToInt(Result) then
    Exit
  else
    Result := ADefVal
end;

function TQJsonNode.IntByPath(const APath: UnicodeString;
  const ADefVal: Int64): Int64;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByPath(APath);
  if Assigned(AChild) and AChild.TryToInt(Result) then
    Exit
  else
    Result := ADefVal;
end;

function TQJsonNode.InternalAdd: PQJsonNode;
begin
  Result := AcquireJson;
  Result.FParent := @Self;
  Result.FPrior := FValue.Items.Last;
  if Assigned(FValue.Items.Last) then
    FValue.Items.Last.FNext := Result
  else
    FValue.Items.First := Result;
  FValue.Items.Last := Result;
  if FValue.Items.Caches.FirstDirty = FValue.Items.Count then
  begin
    if FValue.Items.Caches.Capacity > FValue.Items.Count then
    begin
      SetCache(FValue.Items.Caches.FirstDirty, Result);
      Inc(FValue.Items.Caches.FirstDirty);
    end;
  end;
  Inc(FValue.Items.Count);
end;

procedure TQJsonNode.InternalEncode(ABuilder: PQPageBuffers;
  const AIndent: UnicodeString; const AFormat: TQJsonFormatSettings);
var
  AChild, ANext: PQJsonNode;
  ALevelIndent: UnicodeString;
const
  EndChars: array [Boolean] of Char = (']', '}');
begin
  if jesDoFormat in AFormat.Settings then
    ALevelIndent := AIndent + '  ';
  AChild := FValue.Items.First;
  if FDataType = jdtArray then
    ABuilder.Append('[')
  else
    ABuilder.Append('{');
  while Assigned(AChild) do
  begin
    if jesDoFormat in AFormat.Settings then
      ABuilder.Append(SLineBreak).Append(ALevelIndent);
    if FDataType = jdtObject then
    begin
      ABuilder.Append('"');
      if jesEscapeQuoterOnly in AFormat.Settings then
        ABuilder.Append(StringReplace(AChild.Name, '"', '\"', [rfReplaceAll]))
      else
        TQJsonEncoder.DoJsonEscape(ABuilder, AChild.Name,
          jesDoEscape in AFormat.Settings);
      ABuilder.Append('":');
    end;
    case AChild.DataType of
      jdtUnknown, jdtNull:
        if not(jesIgnoreNull in AFormat.Settings) then
        begin
          if jesNullAsString in AFormat.Settings then
            ABuilder.Append('""')
          else
            ABuilder.Append('null');
        end;
      jdtBoolean:
        begin
          if AChild.FValue.AsBoolean then
            ABuilder.Append('true')
          else
            ABuilder.Append('false');
        end;
      jdtInteger:
        ABuilder.Append(AChild.FValue.AsInt64);
      jdtFloat:
        ABuilder.Append(FloatToStr(AChild.FValue.AsFloat));
      jdtDateTime:
        begin
          case AFormat.TimeKind of
            tkFormatedText:
              begin
                ABuilder.Append('"');
                if Trunc(FValue.AsDateTime) = 0 then
                  ABuilder.Append(FormatDateTime(AFormat.TimeFormat,
                    FValue.AsDateTime))
                else if IsZero(Frac(FValue.AsDateTime)) then
                  ABuilder.Append(FormatDateTime(AFormat.DateFormat,
                    FValue.AsDateTime))
                else
                  ABuilder.Append(FormatDateTime(AFormat.DateTimeFormat,
                    FValue.AsDateTime));
                ABuilder.Append('"');
              end;
            tkUnixTimeStamp:
              ABuilder.Append(DateTimeToUnix(FValue.AsDateTime, false));
          end;
        end;
      jdtBcd:
        ABuilder.Append(BcdToStr(AChild.FValue.AsBcd^));
      jdtArray, jdtObject:
        AChild.InternalEncode(ABuilder, ALevelIndent, AFormat);
      jdtString:
        begin
          ABuilder.Append('"');
          if jesEscapeQuoterOnly in AFormat.Settings then
            ABuilder.Append(StringReplace(AChild.AsString, '"', '\"',
              [rfReplaceAll]))
          else
            TQJsonEncoder.DoJsonEscape(ABuilder, AChild.AsString,
              jesDoEscape in AFormat.Settings);
          ABuilder.Append('"');
        end;
      jdtLineComment:
        begin
          if jesWithComment in AFormat.Settings then
            ABuilder.Append('//').Append(AChild.AsString).Append(SLineBreak);
          AChild := AChild.FNext;
          continue;
        end;
      jdtBlockComment:
        begin
          if jesWithComment in AFormat.Settings then
            ABuilder.Append('/*').Append(AChild.AsString).Append('*/')
              .Append(SLineBreak);
          AChild := AChild.FNext;
          continue;
        end
    else
      AChild.InternalEncode(ABuilder, ALevelIndent, AFormat);
    end;
    AChild := AChild.FNext;
    if Assigned(AChild) then
    begin
      ANext := AChild;
      while Assigned(ANext) and
        (ANext.DataType in [jdtLineComment, jdtBlockComment]) do
        ANext := ANext.FNext;
      if Assigned(ANext) then
        ABuilder.Append(',');
    end;
  end;
  if jesDoFormat in AFormat.Settings then
    ABuilder.Append(SLineBreak).Append(AIndent);
  if FDataType = jdtArray then
    ABuilder.Append(']')
  else
    ABuilder.Append('}');
end;

function TQJsonNode.ItemByName(const AName: UnicodeString): PQJsonNode;
begin
  Assert(FDataType = jdtObject);
  if Length(AName) = 0 then
    Exit(@Self);
  Result := FValue.Items.First;
  while Assigned(Result) do
  begin
    if CompareText(Result.Name, AName) = 0 then
      Exit;
    Result := Result.FNext;
  end;
end;

function TQJsonNode.ItemByPath(const APath: UnicodeString;
  const ADelimiter: WideChar): PQJsonNode;
var
  p: PWideChar;
  AIndex: Integer;
  AName: UnicodeString;
  function LookupNameAndIndex: Boolean;
  var
    ps: PWideChar;
  begin
    ps := p;
    AIndex := -1;
    SetLength(AName, 0);
    Result := true;
    while p^ <> #0 do
    begin
      if p^ = ADelimiter then
      begin
        SetLength(AName, p - ps);
        Inc(p);
        Move(ps^, PChar(AName)^, Length(AName) shl 1);
        break;
      end
      else if p^ = '[' then
      begin
        SetLength(AName, p - ps);
        Inc(p);
        Move(ps^, PChar(AName)^, Length(AName) shl 1);
        // Format:a.b[m][n].c
        AIndex := 0;
        while p^ <> #0 do
        begin
          if (p^ >= '0') and (p^ <= '9') then
            AIndex := AIndex * 10 + Ord(p^) - Ord('0')
          else if p^ = ']' then
          begin
            Inc(p);
            if p^ = ADelimiter then
              Inc(p);
            break;
          end
          else
          begin
            Exit(false)
          end;
        end;
        break;
      end
      else
        Inc(p);
    end;
  end;

begin
  Assert(FDataType = jdtObject);
  // 路径为空时找自己
  if Length(APath) = 0 then
    Exit(@Self);
  Result := @Self;
  p := PWideChar(APath);
  while (p^ <> #0) and (Result.DataType in [jdtArray, jdtObject]) do
  begin
    if LookupNameAndIndex then
    begin
      if Length(AName) > 0 then
        Result := Result.ItemByName(AName);
      if Assigned(Result) then
      begin
        if AIndex >= 0 then
        begin
          if (Result.DataType in [jdtArray, jdtObject]) and
            (AIndex < Result.FValue.Items.Count) then
          begin
            Result := Result.FValue.Items.First;
            while (AIndex > 0) and Assigned(Result) do
            begin
              Result := Result.FNext;
              Dec(AIndex);
            end;
            if AIndex = 0 then // 找到数组元素
              continue;
          end;
        end // 非数组元素
        else
          continue;
      end;
    end;
    Exit(nil);
  end;
end;

procedure TQJsonNode.LoadFromFile(const AFileName: UnicodeString;
  AMode: TQJsonStoreMode; AEncoding: TEncoding; ACallback: TQJsonParseCallback);
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    if not AParser.TryParseFile(@Self, AFileName, AEncoding, ACallback) then
      raise EJsonError.Create(AParser.FErrorMsg);
  finally
    FreeAndNil(AParser);
  end;
end;

procedure TQJsonNode.LoadFromStream(AStream: TStream; AMode: TQJsonStoreMode;
  AEncoding: TEncoding; ACallback: TQJsonParseCallback);
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    if not AParser.TryParseStream(@Self, AStream, AEncoding, ACallback) then
      raise EJsonError.Create(AParser.FErrorMsg);
  finally
    FreeAndNil(AParser);
  end;
end;

function TQJsonNode.Merge(ASource: PQJsonNode): Integer;
var
  AChild: PQJsonNode;
begin
  Assert((FDataType = jdtObject) and (ASource.DataType = jdtObject));
  AChild := ASource.FValue.Items.First;
  Result := 0;
  while Assigned(AChild) do
  begin
    if ItemByName(AChild.Name) = nil then
    begin
      AChild.CopyTo(AddKey(AChild.Name));
      Inc(Result);
    end;
    AChild := AChild.FNext;
  end;
end;

function TQJsonNode.Replace(ASource: PQJsonNode): Integer;
var
  AChild, ATarget: PQJsonNode;
begin
  Assert((FDataType = jdtObject) and (ASource.DataType = jdtObject));
  AChild := ASource.FValue.Items.First;
  Result := 0;
  while Assigned(AChild) do
  begin
    ATarget := ItemByName(AChild.Name);
    if Assigned(ATarget) then
    begin
      AChild.CopyTo(ATarget);
      Inc(Result);
    end;
    AChild := AChild.FNext;
  end;
end;

procedure TQJsonNode.Reset;
begin
  if DataType <> jdtUnknown then
  begin
    DataType := jdtUnknown;
    FIndex := 0;
    if Assigned(FName) then
    begin
      if TQJsonStringCaches.Current.Release(FName) = FName then
        Dispose(FName);
    end;
    FName := nil;
  end;
end;

procedure TQJsonNode.SaveToFile(const AFileName: UnicodeString;
  AEncoding: TEncoding; const AFormat: TQJsonFormatSettings;
  AWriteBom: Boolean);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream, AEncoding, AFormat, AWriteBom);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQJsonNode.SaveToStream(AStream: TStream; AEncoding: TEncoding;
  const AFormat: TQJsonFormatSettings; AWriteBom: Boolean);
var
  AEncoder: TQJsonEncoder;

  procedure DoSave(ANode: PQJsonNode; AIsPair: Boolean);
  var
    AChild: PQJsonNode;
  begin
    case ANode.DataType of
      jdtUnknown, jdtNull:
        begin
          if jesIgnoreNull in AEncoder.FFormat.Settings then
            Exit;
          if AIsPair then
            AEncoder.WritePair(ANode.Name)
          else
            AEncoder.WriteNull;
        end;
      jdtLineComment, jdtBlockComment:
        begin
          // 自动检测保重注释内容有效性
          if jesDoFormat in AFormat.Settings then
            AEncoder.WriteComment(ANode.AsString);
        end;
      jdtBoolean:
        begin
          if AIsPair then
            AEncoder.WritePair(ANode.Name, ANode.FValue.AsBoolean)
          else
            AEncoder.WriteValue(ANode.FValue.AsBoolean);
        end;
      jdtInteger:
        begin
          if AIsPair then
            AEncoder.WritePair(ANode.Name, ANode.FValue.AsInt64)
          else
            AEncoder.WriteValue(ANode.FValue.AsInt64);
        end;
      jdtDateTime:
        begin
          if AIsPair then
            AEncoder.WritePair(ANode.Name, ANode.FValue.AsDateTime)
          else
            AEncoder.WriteValue(ANode.FValue.AsDateTime);
        end;
      jdtFloat:
        begin
          if AIsPair then
            AEncoder.WritePair(ANode.Name, ANode.FValue.AsFloat)
          else
            AEncoder.WriteValue(ANode.FValue.AsFloat);
        end;
      jdtBcd:
        begin
          if AIsPair then
            AEncoder.WritePair(ANode.Name, ANode.AsBcd)
          else
            AEncoder.WriteValue(ANode.AsBcd);
        end;
      jdtString:
        begin
          if AIsPair then
            AEncoder.WritePair(ANode.Name, ANode.AsString)
          else
            AEncoder.WriteValue(ANode.AsString);
        end;
      jdtArray:
        begin
          AEncoder.StartArray;
          try
            AChild := ANode.FValue.Items.First;
            while Assigned(AChild) do
            begin
              DoSave(AChild, false);
              AChild := AChild.FNext;
            end;
          finally
            AEncoder.EndArray;
          end;
        end;
      jdtObject:
        begin
          AEncoder.StartObject;
          try
            AChild := ANode.FValue.Items.First;
            while Assigned(AChild) do
            begin
              DoSave(AChild, true);
              AChild := AChild.FNext;
            end;
          finally
            AEncoder.EndObject;
          end;
        end;
    end;
  end;

begin
  AEncoder := TQJsonEncoder.Create(AStream, AWriteBom, AFormat, AEncoding, 0);
  try
    DoSave(@Self, FDataType = jdtObject);
  finally
    FreeAndNil(AEncoder);
  end;
end;

procedure TQJsonNode.SetAsBase64Bytes(const Value: TBytes);
begin
  AsString := TNetEncoding.Base64.EncodeBytesToString(Value);
end;

procedure TQJsonNode.SetAsBcd(const Value: TBcd);
begin
  DataType := jdtBcd;
  if not Assigned(FValue.AsBcd) then
    New(FValue.AsBcd);
  FValue.AsBcd^ := Value;
end;

procedure TQJsonNode.SetAsBoolean(const Value: Boolean);
begin
  DataType := jdtBoolean;
  FValue.AsBoolean := Value;
end;

procedure TQJsonNode.SetAsDateTime(const Value: TDateTime);
begin
  DataType := jdtDateTime;
  FValue.AsDateTime := Value;
end;

procedure TQJsonNode.SetAsFloat(const Value: Extended);
begin

end;

procedure TQJsonNode.SetAsInt64(const Value: Int64);
begin
  DataType := jdtInteger;
  FValue.AsInt64 := Value;
end;

procedure TQJsonNode.SetAsJson(const Value: UnicodeString);
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(jsmNormal);
  try
    AParser.ParseText(@Self, Value, nil); // InternalParseStage);
  finally
    FreeAndNil(AParser);
  end;
end;

procedure TQJsonNode.SetAsString(const Value: UnicodeString);
begin
  case DataType of
    jdtLineComment:
      begin
        if Value.Contains(#$0A) then
          raise EJsonError.Create(SBadLineComment);
      end;
    jdtBlockComment:
      begin
        if Value.Contains('*/') then
          raise EJsonError.Create(SBadBlockComment);
      end
  else
    begin
      DataType := jdtString;
    end;
  end;
  if not Assigned(FValue.AsString) then
    New(PUnicodeString(FValue.AsString));
  FValue.AsString^ := Value;
end;

procedure TQJsonNode.SetAsStringRef(const Value: UnicodeString);
begin
  DataType := jdtString;
  FValue.AsString := TQJsonStringCaches.Current.AddRef(@Value);
end;

procedure TQJsonNode.SetCache(AIndex: NativeInt; ANode: PQJsonNode);
var
  pd: PPointer;
begin
  if not Assigned(FValue.Items.Caches.Items) then
  begin
    FValue.Items.Caches.Capacity := FValue.Items.Count;
    GetMem(FValue.Items.Caches.Items, SizeOf(Pointer) * FValue.Items.Count);
  end
  else if FValue.Items.Caches.Capacity < FValue.Items.Count then
  begin
    FValue.Items.Caches.Capacity := FValue.Items.Count;
    ReallocMem(FValue.Items.Caches.Items, SizeOf(Pointer) * FValue.Items.Count);
  end;
  pd := PPointer(IntPtr(FValue.Items.Caches.Items) + SizeOf(Pointer) * AIndex);
  pd^ := ANode;
  ANode.FIndex := AIndex;
  while ANode.FIndex > FValue.Items.Caches.FirstDirty do
  begin
    ANode.FPrior.FIndex := ANode.FIndex - 1;
    ANode := ANode.FPrior;
    Dec(pd);
    pd^ := ANode;
  end;
end;

procedure TQJsonNode.SetDataType(const Value: TQJsonDataType);
begin
  if FDataType <> Value then
  begin
    Clear;
    if (FDataType in [jdtArray, jdtObject]) and
      (not(Value in [jdtArray, jdtObject])) then
    begin
      if Assigned(FValue.Items.Caches.Items) then
      begin
        FreeMem(FValue.Items.Caches.Items);
        FValue.Items.Caches.Items := nil;
      end;
    end;
    FDataType := Value;
  end;
end;

procedure TQJsonNode.SortByNames(AComparer: IComparer<UnicodeString>;
  ADesc, AIsNest: Boolean);
var
  AItems: TArray<PQJsonNode>;
  I: Integer;
begin
  Assert(DataType = jdtObject);
  if FValue.Items.Count = 0 then
    Exit;
  if not Assigned(AComparer) then
    AComparer := TComparer<UnicodeString>.Default;
  AItems := ToArray;
  TArray.Sort<PQJsonNode>(AItems, TComparer<PQJsonNode>.Construct(
    function(const l, R: PQJsonNode): Integer
    begin
      Result := AComparer.Compare(l.Name, R.Name);
      if ADesc then
        Result := -Result;
    end));
  FValue.Items.First := AItems[0];
  FValue.Items.First.FPrior := nil;
  FValue.Items.Last := AItems[High(AItems)];
  FValue.Items.Last.FNext := nil;
  FValue.Items.Caches.FirstDirty := 0; // 索引失效
  AItems[0].FIndex := 0;
  for I := 1 to High(AItems) do
  begin
    Items[I].FIndex := I;
    Items[I].FPrior := Items[I - 1];
    Items[I - 1].FNext := Items[I];
  end;
  if AIsNest then
  begin
    for I := 0 to High(AItems) do
    begin
      if AItems[I].DataType = jdtObject then
        AItems[I].SortByNames(AComparer, ADesc, AIsNest);
    end;
  end;
end;

procedure TQJsonNode.SortByValues(AComparer: IComparer<PQJsonNode>;
ADesc, AIsNest: Boolean);
var
  AItems: TArray<PQJsonNode>;
  I: Integer;
  AChild: PQJsonNode;
  ADefaultComparer: IComparer<PQJsonNode>;
  procedure GetDefaultComparer;
  var
    ACompareType: TQJsonDataType;
  begin
    AChild := FValue.Items.First;
    ACompareType := AChild.DataType;
    repeat
      AChild := AChild.FNext;
      if Assigned(AChild) then
      begin
        if AChild.DataType > ACompareType then
          ACompareType := AChild.DataType;
      end;
    until not Assigned(AChild);
    case ACompareType of
      jdtUnknown .. jdtNull:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          begin
            Result := 0;
          end);
      jdtBoolean:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          begin
            Result := Ord(l.AsBoolean) - Ord(R.AsBoolean);
          end);
      jdtInteger:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          var
            ADelta: Int64;
          begin
            ADelta := l.AsInt - R.AsInt;
            if ADelta > 0 then
              Result := 1
            else if ADelta < 0 then
              Result := -1
            else
              Result := 0;
          end);
      jdtDateTime:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          var
            ADelta: Double;
          begin
            ADelta := l.AsDateTime - R.AsDateTime;
            if ADelta > 0 then
              Result := 1
            else if ADelta < 0 then
              Result := -1
            else
              Result := 0;
          end);
      jdtFloat:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          var
            ADelta: Extended;
          begin
            ADelta := l.AsFloat - R.AsFloat;
            if ADelta > 0 then
              Result := 1
            else if ADelta < 0 then
              Result := -1
            else
              Result := 0;
          end);
      jdtBcd:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          var
            ADelta: TBcd;
          begin
            ADelta := l.AsBcd - R.AsBcd;
            if ADelta > 0 then
              Result := 1
            else if ADelta < 0 then
              Result := -1
            else
              Result := 0;
          end);
      jdtString:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          begin
            Result := CompareStr(l.AsString, R.AsString);
          end);
      jdtArray, jdtObject:
        AComparer := TComparer<PQJsonNode>.Construct(
          function(const l, R: PQJsonNode): Integer
          begin
            Result := Ord(l.DataType) - Ord(R.DataType);
          end);
    end;
    ADefaultComparer := AComparer;
  end;

begin
  Assert(DataType in [jdtObject, jdtArray]);
  if FValue.Items.Count = 0 then
    Exit;
  if not Assigned(AComparer) then
    GetDefaultComparer;
  AItems := ToArray;
  TArray.Sort<PQJsonNode>(AItems, TComparer<PQJsonNode>.Construct(
    function(const l, R: PQJsonNode): Integer
    begin
      Result := AComparer.Compare(l, R);
      if ADesc then
        Result := -Result;
    end));
  FValue.Items.First := AItems[0];
  FValue.Items.First.FPrior := nil;
  FValue.Items.Last := AItems[High(AItems)];
  FValue.Items.Last.FNext := nil;
  FValue.Items.Caches.FirstDirty := 0; // 索引失效
  for I := 1 to High(AItems) do
  begin
    Items[I].FPrior := Items[I - 1];
    Items[I - 1].FNext := Items[I];
  end;
  if AIsNest then
  begin
    for I := 0 to High(AItems) do
    begin
      if AItems[I].DataType in [jdtArray, jdtObject] then
      begin
        if ADefaultComparer = AComparer then
          AItems[I].SortByValues(nil, ADesc, AIsNest)
        else
          AItems[I].SortByValues(AComparer, ADesc, AIsNest);
      end;
    end;
  end;
end;

function TQJsonNode.ToArray: TArray<PQJsonNode>;
var
  AChild: PQJsonNode;
  ACount: Integer;
begin
  Assert(DataType in [jdtArray, jdtObject]);
  SetLength(Result, FValue.Items.Count);
  ACount := 0;
  // 如果缓存没有问题，则直接复制
  if FValue.Items.Caches.FirstDirty = ACount then
    Move(FValue.Items.Caches.Items^, Result[0], ACount * SizeOf(PQJsonNode))
  else
  begin
    AChild := FValue.Items.First;
    while Assigned(AChild) do
    begin
      SetCache(ACount, AChild);
      Result[ACount] := AChild;
    end;
  end;
end;

function TQJsonNode.TryLoadFromFile(const AFileName: UnicodeString;
AMode: TQJsonStoreMode; AEncoding: TEncoding;
ACallback: TQJsonParseCallback): Boolean;
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    Result := AParser.TryParseFile(@Self, AFileName, AEncoding, ACallback);
  finally
    FreeAndNil(AParser);
  end;
end;

function TQJsonNode.TryLoadFromStream(AStream: TStream; AMode: TQJsonStoreMode;
AEncoding: TEncoding; ACallback: TQJsonParseCallback): Boolean;
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    Result := AParser.TryParseStream(@Self, AStream, AEncoding, ACallback);
  finally
    FreeAndNil(AParser);
  end;
end;

function TQJsonNode.TryParse(const S: Utf8String; AMode: TQJsonStoreMode;
ACallback: TQJsonParseCallback): Boolean;
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    Result := AParser.TryParseText(@Self, S, ACallback);
  finally
    FreeAndNil(AParser);
  end;
end;

function TQJsonNode.TryParse(const S: AnsiString; AMode: TQJsonStoreMode;
ACallback: TQJsonParseCallback): Boolean;
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    Result := AParser.TryParseText(@Self, S, ACallback);
  finally
    FreeAndNil(AParser);
  end;
end;

function TQJsonNode.TryParse(const S: UnicodeString; AMode: TQJsonStoreMode;
ACallback: TQJsonParseCallback): Boolean;
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(AMode);
  try
    Result := AParser.TryParseText(@Self, S, ACallback);
  finally
    FreeAndNil(AParser);
  end;
end;

function TQJsonNode.TryToBcd(var AValue: TBcd): Boolean;
begin
  Result := true;
  case FDataType of
    jdtUnknown, jdtNull:
      AValue := 0;
    jdtBoolean:
      AValue := Ord(FValue.AsBoolean);
    jdtInteger:
      AValue := FValue.AsInt64;
    jdtFloat:
      AValue := FValue.AsFloat;
    jdtBcd:
      AValue := FValue.AsBcd^;
    jdtString:
      Result := TryStrToBcd(AsString, AValue);
    jdtDateTime:
      AValue := FValue.AsDateTime
  else
    Result := false;
  end;
end;

function TQJsonNode.TryToBool(var AValue: Boolean): Boolean;
begin
  Result := true;
  case FDataType of
    jdtUnknown, jdtNull:
      AValue := false;
    jdtBoolean:
      AValue := FValue.AsBoolean;
    jdtInteger:
      AValue := FValue.AsInt64 <> 0;
    jdtFloat:
      AValue := not IsZero(FValue.AsFloat);
    jdtBcd:
      AValue := FValue.AsBcd^ = 0;
    jdtString:
      Result := TryStrToBool(AsString, AValue)
  else
    Result := false;
  end;
end;

function TQJsonNode.TryToDateTime(var AValue: TDateTime): Boolean;
  function DateTimeFromString(AStr: UnicodeString; var AResult: TDateTime;
  const AFormat: UnicodeString): Boolean; overload;
  // 日期时间格式
    function DecodeTagValue(var pf, ps: PWideChar; cl, cu: WideChar;
    var AValue, ACount: Integer; AMaxOnOne: Integer): Boolean;
    begin
      AValue := 0;
      ACount := 0;
      Result := true;
      while (pf^ = cl) or (pf^ = cu) do
      begin
        if (ps^ >= '0') and (ps^ <= '9') then
        begin
          AValue := AValue * 10 + Ord(ps^) - Ord('0');
          Inc(ps);
          Inc(pf);
          Inc(ACount);
        end
        else
        begin
          Result := false;
          Exit;
        end;
      end;
      if (ACount = 1) and (ACount < AMaxOnOne) then
      begin
        while (ACount < AMaxOnOne) and (ps^ >= '0') and (ps^ <= '9') do
        begin
          AValue := AValue * 10 + Ord(ps^) - Ord('0');
          Inc(ACount);
          Inc(ps);
        end;
      end;
    end;
    function DecodeAsFormat(fmt: UnicodeString): Boolean;
    var
      pf, ps, pl: PWideChar;
      c, Y, M, d, H, N, S, MS: Integer;
      ADate, ATime: TDateTime;
    begin
      pf := PWideChar(fmt);
      ps := PWideChar(AStr);
      c := 0;
      Y := 0;
      M := 0;
      d := 0;
      H := 0;
      N := 0;
      S := 0;
      MS := 0;
      Result := true;
      while (pf^ <> #0) and Result do
      begin
        if (pf^ = 'y') or (pf^ = 'Y') then
        // 到了年份的部分
        begin
          Result := DecodeTagValue(pf, ps, 'y', 'Y', Y, c, 4) and (c <> 3);
          if Result then
          begin
            if c = 2 then // 两位年时
            begin
              if Y < 50 then
                Y := 2000 + Y
              else
                Y := 1900 + Y;
            end
          end;
        end
        else if (pf^ = 'm') or (pf^ = 'M') then
          Result := DecodeTagValue(pf, ps, 'm', 'M', M, c, 2)
        else if (pf^ = 'd') or (pf^ = 'D') then
          Result := DecodeTagValue(pf, ps, 'd', 'D', d, c, 2)
        else if (pf^ = 'h') or (pf^ = 'H') then
          Result := DecodeTagValue(pf, ps, 'h', 'H', H, c, 2)
        else if (pf^ = 'n') or (pf^ = 'N') then
          Result := DecodeTagValue(pf, ps, 'n', 'N', N, c, 2)
        else if (pf^ = 's') or (pf^ = 'S') then
          Result := DecodeTagValue(pf, ps, 's', 'S', S, c, 2)
        else if (pf^ = 'z') or (pf^ = 'Z') then
          Result := DecodeTagValue(pf, ps, 'z', 'Z', MS, c, 3)
        else if (pf^ = '"') or (pf^ = '''') then
        begin
          pl := pf;
          Inc(pf);
          while ps^ = pf^ do
          begin
            Inc(pf);
            Inc(ps);
          end;
          if pf^ = pl^ then
            Inc(pf);
        end
        else if pf^ = ' ' then
        begin
          Inc(pf);
          while ps^ = ' ' do
            Inc(ps);
        end
        else if pf^ = ps^ then
        begin
          Inc(pf);
          Inc(ps);
        end
        else
          Result := false;
      end;
      Result := Result and ((ps^ = #0) or (ps^ = '+'));
      if Result then
      begin
        if M = 0 then
          M := 1;
        if d = 0 then
          d := 1;
        Result := TryEncodeDate(Y, M, d, ADate);
        Result := Result and TryEncodeTime(H, N, S, MS, ATime);
        if Result then
          AResult := ADate + ATime;
      end;
    end;
    procedure SmartDetect;
    var
      V: Int64;
      l: Integer;
      ps, p, tz: PWideChar;
      I, ATimezone: Integer;
    const
      KnownFormats: array [0 .. 15] of String = ('y-m-d h:n:s.z', 'y-m-d h:n:s',
        'y-m-d', 'h:n:s.z', 'h:n:s', 'y-m-d"T"h:n:s.z', 'y-m-d"T"h:n:s',
        'd/m/y h:n:s.z', 'd/m/y h:n:s', 'd/m/y', 'm/d/y h:n:s.z', 'm/d/y h:n:s',
        'm/d/y', 'y/m/d h:n:s.z', 'y/m/d h:n:s', 'y/m/d');
    begin
      ps := PWideChar(AStr);
      tz := StrPos(ps, '+'); // +xxyy
      ATimezone := 0;
      if tz <> nil then
      begin
        l := (IntPtr(tz) - IntPtr(ps)) shr 1;
        Inc(tz);
        while tz^ <> #0 do
        begin
          ATimezone := ATimezone * 10 + Ord(tz^) - Ord('0');
          Inc(tz);
        end;
        // 如果存在时区，则将结果转换为本地时区
        Dec(ATimezone, TTimezone.Local.UtcOffset.Hours);
      end
      else
        l := Length(AStr);
      Result := true;
      if (l = 5) and DecodeAsFormat('h:n:s') then
      begin
        AResult := AResult + ATimezone / 24;
        Exit
      end
      else if l = 6 then
      begin
        if TryStrToInt64(AStr, V) then
        begin
          if V > 235959 then
          // 大于这个的肯定不是时间，那么可能是yymmdd
          begin
            if not DecodeAsFormat('yymmdd') then
              Result := false;
          end
          else if ((V mod 10000) > 1231) or ((V mod 100) > 31) then
          // 月份+日期组合不可能大于1231
          begin
            if not DecodeAsFormat('hhnnss') then
              Result := false;
          end
          else if not DecodeAsFormat('yymmdd') then
            Result := false;
        end;
      end
      // 检测连续的数字格式
      else if (l = 8) and (DecodeAsFormat('hh:nn:ss') or
        DecodeAsFormat('yy-mm-dd') or DecodeAsFormat('yyyymmdd')) then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end
      else if (l = 9) and DecodeAsFormat('hhnnsszzz') then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end
      else if l = 10 then
      // yyyy-mm-dd yyyy/mm/dd mm/dd/yyyy dd.mm.yyyy dd/mm/yy
      begin
        p := ps;
        Inc(p, 2);
        if (p^ < '0') or (p^ > '9') then
        // mm?dd?yyyy or dd?mm?yyyy
        begin
          // dd mm yyyy 的国家居多，优先识别为这种
          if DecodeAsFormat('dd' + p^ + 'mm' + p^ + 'yyyy') or
            DecodeAsFormat('mm' + p^ + 'dd' + p^ + 'yyyy') then
          begin
            AResult := AResult + ATimezone / 24;
            Exit;
          end;
        end
        else if DecodeAsFormat('yyyy-mm-dd') then // 其它格式都是100移动卡
        begin
          AResult := AResult + ATimezone / 24;
          Exit;
        end;
      end
      else if (l = 12) and (DecodeAsFormat('yymmddhhnnss') or
        DecodeAsFormat('hh:nn:ss.zzz')) then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end
      else if (l = 14) and DecodeAsFormat('yyyymmddhhnnss') then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end
      else if (l = 17) and DecodeAsFormat('yyyymmddhhnnsszzz') then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end
      else if (l = 19) and (DecodeAsFormat('yyyy-mm-dd hh:nn:ss') or
        DecodeAsFormat('yyyy-mm-dd"T"hh:nn:ss')) then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end
      else if (l = 23) and (DecodeAsFormat('yyyy-mm-dd hh:nn:ss.zzz') or
        DecodeAsFormat('yyyy-mm-dd"T"hh:nn:ss.zzz')) then
      begin
        AResult := AResult + ATimezone / 24;
        Exit;
      end;
      for I := Low(KnownFormats) to High(KnownFormats) do
      begin
        if DecodeAsFormat(KnownFormats[I]) then
        begin
          AResult := AResult + ATimezone / 24;
          Exit;
        end;
      end;
      AResult := HttpToDate(ps, true);
      Result := not IsZero(AResult);
    end;

  begin
    AStr := Trim(AStr);
    if Length(AFormat) > 0 then
      Result := DecodeAsFormat(AFormat)
    else
      // 检测日期时间类型格式
      SmartDetect;
  end;

begin
  case FDataType of
    jdtString:
      Result := DateTimeFromString(AsString, AValue, '');
    jdtDateTime:
      begin
        AValue := FValue.AsDateTime;
        Result := true;
      end
  else
    Result := false;
  end;
end;

function TQJsonNode.TryToFloat(var AValue: Extended): Boolean;
begin
  Result := true;
  case FDataType of
    jdtUnknown, jdtNull:
      AValue := 0;
    jdtBoolean:
      AValue := Ord(FValue.AsBoolean);
    jdtInteger:
      AValue := FValue.AsInt64;
    jdtFloat:
      AValue := FValue.AsFloat;
    jdtBcd:
      AValue := StrToFloat(BcdToStr(FValue.AsBcd^));
    jdtString:
      Result := TryStrToFloat(AsString, AValue);
    jdtDateTime:
      AValue := FValue.AsDateTime
  else
    Result := false;
  end;
end;

function TQJsonNode.TryToInt(var AValue: Int64): Boolean;
begin
  Result := true;
  case FDataType of
    jdtUnknown, jdtNull:
      AValue := 0;
    jdtBoolean:
      AValue := Ord(FValue.AsBoolean);
    jdtInteger:
      AValue := FValue.AsInt64;
    jdtFloat:
      AValue := Trunc(FValue.AsFloat);
    jdtBcd:
      AValue := BcdToInt64(FValue.AsBcd^);
    jdtString:
      Result := TryStrToInt64(AsString, AValue);
    jdtDateTime:
      AValue := Trunc(FValue.AsDateTime)
  else
    Result := false;
  end;
end;

function TQJsonNode.ValueByName(const AName: UnicodeString;
ADefVal: UnicodeString): String;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) then
    Result := AChild.AsString
  else
    Result := ADefVal;
end;

function TQJsonNode.ValueByPath(const AName: UnicodeString;
ADefVal: UnicodeString): String;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByPath(AName);
  if Assigned(AChild) then
    Result := AChild.AsString
  else
    Result := ADefVal;
end;

function TQJsonNode.Add(const AValue: UnicodeString): PQJsonNode;
begin
  Result := Add;
  Add.AsString := AValue;
end;

function TQJsonNode.Add(const AValue: TBcd): PQJsonNode;
begin
  Result := Add;
  Add.AsBcd := AValue;
end;

function TQJsonNode.Add(const AValue: Boolean): PQJsonNode;
begin
  Result := Add;
  Result.AsBoolean := AValue;
end;

function TQJsonNode.AddArray: PQJsonNode;
begin
  Result := Add;
  Result.DataType := jdtArray;
end;

function TQJsonNode.AddKey(const AName: UnicodeString): PQJsonNode;
begin
  Assert(FDataType = jdtObject);
  Result := InternalAdd;
  New(Result.FName);
  Result.FName^ := AName;
end;

function TQJsonNode.AddObject: PQJsonNode;
begin
  Result := Add;
  Result.DataType := jdtObject;
end;

function TQJsonNode.AddPair(const AName: UnicodeString; const AValue: Int64)
  : PQJsonNode;
begin
  Result := AddKey(AName);
  Result.AsInt := AValue;
end;

function TQJsonNode.AddPair(const AName: UnicodeString; const AValue: Extended)
  : PQJsonNode;
begin
  Result := AddKey(AName);
  Result.AsFloat := AValue;
end;

function TQJsonNode.AddPair(const AName: UnicodeString; const AValue: TBcd)
  : PQJsonNode;
begin
  Result := AddKey(AName);
  Result.AsBcd := AValue;
end;

function TQJsonNode.AddPair(const AName, AValue: UnicodeString): PQJsonNode;
begin
  Result := AddKey(AName);
  Result.AsString := AValue;
end;

function TQJsonNode.AddPair(const AName: UnicodeString; const AValue: TDateTime)
  : PQJsonNode;
begin
  Result := AddKey(AName);
  Result.AsDateTime := AValue;
end;

function TQJsonNode.AddPair(const AName: UnicodeString; AValue: Boolean)
  : PQJsonNode;
begin
  Result := AddKey(AName);
  Result.AsBoolean := AValue;
end;

function TQJsonNode.AddPairArray(const AName: UnicodeString): PQJsonNode;
begin
  Result := AddKey(AName);
  Result.DataType := jdtArray;
end;

function TQJsonNode.AddPairObject(const AName: UnicodeString): PQJsonNode;
begin
  Result := AddKey(AName);
  Result.DataType := jdtObject;
end;

procedure TQJsonNode.Attach(ANewParent: PQJsonNode);
begin
  Assert(Assigned(ANewParent) and (ANewParent.DataType in [jdtArray,
    jdtObject]));
  if FParent <> ANewParent then
  begin
    if Assigned(FParent) then
      Detach;
    FParent := ANewParent;
    with FParent.FValue.Items do
    begin
      if Assigned(Last) then
        Last.FNext := @Self
      else
        First := @Self;
      FPrior := Last;
      Last := @Self;
      Inc(Count);
    end;
  end;
end;

function TQJsonNode.BcdByName(const AName: UnicodeString;
const ADefVal: TBcd): TBcd;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) and AChild.TryToBcd(Result) then
    Exit
  else
    Result := ADefVal
end;

function TQJsonNode.BcdByPath(const APath: UnicodeString;
const ADefVal: TBcd): TBcd;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByPath(APath);
  if Assigned(AChild) and AChild.TryToBcd(Result) then
    Exit
  else
    Result := ADefVal
end;

function TQJsonNode.BoolByName(const AName: UnicodeString;
const ADefVal: Boolean): Boolean;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) and AChild.TryToBool(Result) then
    Exit
  else
    Result := ADefVal
end;

function TQJsonNode.BoolByPath(const APath: UnicodeString;
const ADefVal: Boolean): Boolean;
var
  AChild: PQJsonNode;
begin
  AChild := ItemByPath(APath);
  if Assigned(AChild) and AChild.TryToBool(Result) then
    Exit
  else
    Result := ADefVal;
end;

{ TQJsonEncoder }

class constructor TQJsonEncoder.Create;
begin
  FDefaultFormat := Default (TQJsonFormatSettings);
  FDefaultFormat.DateTimeFormat := 'yyyy-mm-dd hh:nn:ss';
  FDefaultFormat.TimeFormat := 'hh:nn:ss';
  FDefaultFormat.DateFormat := 'yyyy-mm-dd';
  FDefaultFormat.IndentText := '  ';
  FDefaultFormat.TimeKind := tkFormatedText;
end;

constructor TQJsonEncoder.Create(AStream: TStream; AWriteBom: Boolean;
const AFormat: TQJsonFormatSettings; AEncoding: TEncoding; ABufSize: Integer);
  procedure AppendBom;
  var
    ABom: TBytes;
  begin
    ABom := FEncoding.GetPreamble;
    if Length(ABom) > 0 then
    begin
      FBuffered := Length(ABom);
      Move(ABom[0], FBuffer[0], FBuffered);
    end;
  end;

begin
  inherited Create;
  FEncoding := AEncoding;
  FStream := AStream;
  FFormat := AFormat;
  FStartOffset := AStream.Position;
  if ABufSize <= 0 then // 默认 8KB
    ABufSize := 8192
  else if ABufSize < 1024 then // 最小分配1KB空间
    ABufSize := 1024;
  SetLength(FBuffer, ABufSize); // 8K
  if AWriteBom then
    AppendBom;
  FCurrent := @FRoot;
end;

constructor TQJsonEncoder.Create;
begin
  Create(TMemoryStream.Create, false, DefaultFormat, TEncoding.UTF8, 4196);
end;

destructor TQJsonEncoder.Destroy;
var
  AStack, ANext: PQJsonStackItem;
begin
  AStack := FRoot.Next;
  while Assigned(AStack) do
  begin
    ANext := AStack.Next;
    Dispose(AStack);
    AStack := ANext;
  end;
  inherited;
end;

class procedure TQJsonEncoder.DoJsonEscape(ABuilder: PQPageBuffers;
const S: UnicodeString; ADoEscape: Boolean);
var
  ps, p: PWideChar;
const
  CharNum1: PWideChar = '1';
  CharNum0: PWideChar = '0';
  Char7: PWideChar = '\a';
  Char8: PWideChar = '\b';
  Char9: PWideChar = '\t';
  Char10: PWideChar = '\n';
  Char11: PWideChar = '\v';
  Char12: PWideChar = '\f';
  Char13: PWideChar = '\r';
  CharQuoter: PWideChar = '\"';
  CharBackslash: PWideChar = '\\';
  CharCode: PWideChar = '\u00';
  CharEscape: PWideChar = '\u';
  procedure Append(const AText: PWideChar);
  var
    ACount: NativeInt;
  begin
    ACount := p - ps;
    if ACount > 0 then
      ABuilder.Append(ps, 0, ACount);
    ABuilder.Append(AText);
    ps := p;
    Inc(ps);
  end;

begin
  ps := PWideChar(S);
  p := ps;
  while p^ <> #0 do
  begin
    case p^ of
      #7:
        Append(Char7);
      #8:
        Append(Char8);
      #9:
        Append(Char9);
      #10:
        Append(Char10);
      #11:
        Append(Char11);
      #12:
        Append(Char12);
      #13:
        Append(Char13);
      '"':
        Append(CharQuoter);
      '\':
        Append(CharBackslash)
    else
      begin
        if p^ < #$1F then
        begin
          Append(CharCode);
          if p^ > #$F then
            ABuilder.Append(CharNum1^)
          else
            ABuilder.Append(CharNum0^);
          ABuilder.Append(LowerHexChars[Ord(p^) and $0F]);
        end
        else if (p^ > #$7E) and ADoEscape then // 非英文字符区
        begin
          Append(CharEscape);
          ABuilder.Append(LowerHexChars[(PWord(p)^ shr 12) and $0F])
            .Append(LowerHexChars[(PWord(p)^ shr 8) and $0F])
            .Append(LowerHexChars[(PWord(p)^ shr 4) and $0F])
            .Append(LowerHexChars[PWord(p)^ and $0F]);
        end;
      end;
    end;
    Inc(p);
  end;
  ABuilder.Append(ps, 0, p - ps);
end;

procedure TQJsonEncoder.EndArray;
begin
  Assert(FCurrent.DataType = jdtArray);
  WritePrefix(true);
  WriteString(']', false);
  FCurrent := FCurrent.Prior;
  if not Assigned(FCurrent) then // Write done
    Flush
  else
    Inc(FCurrent.Count);
end;

procedure TQJsonEncoder.EndObject;
begin
  Assert(FCurrent.DataType = jdtObject);
  WritePrefix(true);
  WriteString('}', false);
  FCurrent := FCurrent.Prior;
  if not Assigned(FCurrent) then // Write done
    Flush
  else
    Inc(FCurrent.Count);
end;

procedure TQJsonEncoder.Flush;
begin
  if FBuffered > 0 then
  begin
    FStream.WriteBuffer(FBuffer[0], FBuffered);
    FBuffered := 0;
  end;
end;

procedure TQJsonEncoder.InternalWritePair(const AName, AValue: UnicodeString;
ADoQuote: Boolean);
begin
  WritePrefix;
  WriteString(AName, true);
  WriteString(':', false);
  WriteString(AValue, ADoQuote or (jesForceAsString in FFormat.Settings));
  Inc(FCurrent.Count);
end;

procedure TQJsonEncoder.InternalWriteValue(const AValue: UnicodeString;
ADoQuote: Boolean);
begin
  Assert(FCurrent.Stage = wsValue);
  WritePrefix;
  WriteString(AValue, ADoQuote or (jesForceAsString in FFormat.Settings));
  Inc(FCurrent.Count);
  if FCurrent.DataType = jdtObject then
    FCurrent.Stage := wsName;
end;

class function TQJsonEncoder.JavaEscape(const S: UnicodeString;
ADoEscape: Boolean): UnicodeString;
var
  ABuilder: TQPageBuffers;
begin
  ABuilder.Initialize;
  try
    DoJsonEscape(@ABuilder, S, ADoEscape);
    Result := ABuilder.ToString;
  finally
    ABuilder.Cleanup;
  end;
end;

procedure TQJsonEncoder.NextType(AType: TQJsonDataType);
var
  APrior: PQJsonStackItem;
begin
  if not Assigned(FCurrent) then
    FCurrent := @FRoot
  else if Assigned(FCurrent.Next) then
    FCurrent := FCurrent.Next
  else
  begin
    APrior := FCurrent;
    New(FCurrent);
    FCurrent.Prior := APrior;
    FCurrent.Next := nil;
    APrior.Next := FCurrent;
    if jesDoFormat in FFormat.Settings then
      FCurrent.Indent := FCurrent.Prior.Indent + '  ';
  end;
  FCurrent.DataType := AType;
  FCurrent.Count := 0;
end;

procedure TQJsonEncoder.StartArray;
begin
  WritePrefix;
  WriteString('[', false);
  NextType(jdtArray);
  FCurrent.Stage := wsValue;
end;

procedure TQJsonEncoder.StartArrayPair(const AName: UnicodeString);
begin
  InternalWritePair(AName, '[', false);
  NextType(jdtArray);
  FCurrent.Stage := wsValue;
end;

procedure TQJsonEncoder.StartObject;
begin
  WritePrefix;
  WriteString('{', false);
  NextType(jdtObject);
  FCurrent.Stage := wsName;
end;

procedure TQJsonEncoder.StartObjectPair(const AName: UnicodeString);
begin
  InternalWritePair(AName, '{', false);
  NextType(jdtObject);
  FCurrent.Stage := wsName;
end;

procedure TQJsonEncoder.StartPair(const AName: UnicodeString);
begin
  Assert(FCurrent.Stage = wsName);
  WritePrefix;
  WriteString(AName, true);
  WriteString(':', false);
  FCurrent.Stage := wsValue;
end;

function TQJsonEncoder.ToString: String;
var
  ABytes: TBytes;
  ACount: NativeInt;
begin
  Flush;
  ACount := FStream.Position - FStartOffset;
  SetLength(ABytes, ACount);
  FStream.Position := FStartOffset;
  FStream.ReadBuffer(ABytes, ACount);
  Result := FEncoding.GetString(ABytes);
end;

procedure TQJsonEncoder.WriteComment(const AComment: UnicodeString);
var
  AIsBlock: Boolean;
  ps, p: PWideChar;
  ALine: UnicodeString;
begin
  // 要支持注释，暂时必需使用格式化模式
  Assert(jesDoFormat in FFormat.Settings);
  // 我们需要检查是否存在块注释结束字符串 */，如果存在，则要改成行注释
  ps := PWideChar(AComment);
  AIsBlock := false;
  p := ps;
  while p^ <> #0 do
  begin
    case p^ of
      #$0A:
        AIsBlock := true;
      '*':
        begin
          Inc(p);
          if p^ = '/' then
          begin
            AIsBlock := false;
            break;
          end
          else
            continue;
        end;
    end;
    Inc(p);
  end;
  if AIsBlock then
  begin
    if jesDoFormat in FFormat.Settings then
    begin
      WriteString(SLineBreak, false);
      WriteString(FCurrent.Indent, false);
    end;
    WriteString('/*', false);
    WriteString(AComment, false);
    WriteString('*/', false);
  end
  else
  begin
    p := ps;
    while p^ <> #0 do
    begin
      if jesDoFormat in FFormat.Settings then
      begin
        WriteString(SLineBreak, false);
        WriteString(FCurrent.Indent, false);
      end;
      WriteString('//', false);
      while p^ <> #0 do
      begin
        case p^ of
          #$0A:
            begin
              SetString(ALine, ps, p - ps + 1);
              WriteString(ALine, false);
              ps := p + 1;
            end;
        end;
        Inc(p);
      end;
      if ps < p then
      begin
        SetString(ALine, ps, p - ps + 1);
        WriteString(ALine, false);
      end;
    end;
  end;
end;

procedure TQJsonEncoder.WriteNull;
begin
  WritePrefix;
  WriteString('null', false);
  Inc(FCurrent.Count);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString; const V: TBcd);
begin
  InternalWritePair(AName, BcdToStr(V), false);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString; const V: Extended;
const AFormat: UnicodeString);
var
  AValue: UnicodeString;
  ADummy: Extended;
begin
  if Length(AFormat) > 0 then
  begin
    AValue := FormatFloat(AFormat, V);
    InternalWritePair(AName, AValue, not TryStrToFloat(AValue, ADummy))
  end
  else
    InternalWritePair(AName, FloatToStr(V), false);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString; const V: Int64;
AIsSign: Boolean);
begin
  if AIsSign then
    InternalWritePair(AName, IntToStr(V), false)
  else
    InternalWritePair(AName, UIntToStr(UInt64(V)), false);
end;

procedure TQJsonEncoder.WritePair(const AName, V: UnicodeString);
begin
  InternalWritePair(AName, V, true);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString; const V: Boolean);
begin
  if V then
    InternalWritePair(AName, 'true', false)
  else
    InternalWritePair(AName, 'false', false);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString);
begin
  WritePrefix;
  WriteString(':null', false);
  Inc(FCurrent.Count);
end;

procedure TQJsonEncoder.WritePrefix(AIsLast: Boolean);
begin
  if Assigned(FCurrent) and (FCurrent.Count > 0) and (not AIsLast) then
    WriteString(',', false);
  if jesDoFormat in FFormat.Settings then
  begin
    WriteString(SLineBreak, false); // 使用 \n，不使用 \r\n
    WriteString(FCurrent.Indent, false);
  end;
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString; const V: TBytes);
begin
  InternalWritePair(AName, TNetEncoding.Base64.EncodeBytesToString(V), true);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString; const V: Currency;
const AFormat: UnicodeString);
var
  AValue: UnicodeString;
  ADummy: Extended;
begin
  if Length(AFormat) > 0 then
  begin
    AValue := FormatFloat(AFormat, V);
    InternalWritePair(AName, AValue, not TryStrToFloat(AValue, ADummy))
  end
  else
    InternalWritePair(AName, CurrToStr(V), false);
end;

procedure TQJsonEncoder.WritePair(const AName: UnicodeString;
const V: TDateTime);
begin
  case FFormat.TimeKind of
    tkFormatedText:
      begin
        if Trunc(V) = 0 then
          InternalWritePair(AName, FormatDateTime(FFormat.TimeFormat, V), true)
        else if Frac(V) > 0 then
          InternalWritePair(AName,
            FormatDateTime(FFormat.DateTimeFormat, V), true)
        else
          InternalWritePair(AName, FormatDateTime(FFormat.DateFormat, V), true);
      end;
    tkUnixTimeStamp:
      InternalWritePair(AName, IntToStr(DateTimeToUnix(V, false)), false);
  end;
end;

procedure TQJsonEncoder.WriteString(const AValue: UnicodeString;
ADoQuote: Boolean);
  procedure DoWrite(const S: UnicodeString);
  var
    ACount: Integer;
    p: PWideChar;
  begin
    p := PWideChar(S);
    if (FEncoding = TEncoding.Unicode) or
      (FEncoding = TEncoding.BigEndianUnicode) then
      ACount := Length(S) * 2
    else
      ACount := LocaleCharsFromUnicode(FEncoding.CodePage, 0, p, Length(S), nil,
        0, nil, nil);
    if ACount + FBuffered > Length(FBuffer) then
      Flush;
    if ACount > Length(FBuffer) then
      SetLength(FBuffer, (ACount + 4095) div 4096 * 4096);
    if FEncoding <> TEncoding.Unicode then
      Inc(FBuffered, LocaleCharsFromUnicode(FEncoding.CodePage, 0, p, Length(S),
        @FBuffer[FBuffered], ACount, nil, nil))
    else
    begin
      Move(p^, FBuffer[FBuffered], ACount);
      Inc(FBuffered, ACount);
    end;
  end;

begin
  if ADoQuote then
  begin
    DoWrite('"');
    DoWrite(JavaEscape(AValue, jesDoEscape in FFormat.Settings));
    DoWrite('"');
  end
  else
    DoWrite(AValue);
end;

procedure TQJsonEncoder.WriteValue(const V: Extended;
const AFormat: UnicodeString);
var
  AValue: UnicodeString;
  ADummy: Extended;
begin
  if Length(AFormat) > 0 then
  begin
    AValue := FormatFloat(AFormat, V);
    InternalWriteValue(AValue, not TryStrToFloat(AValue, ADummy))
  end
  else
    InternalWriteValue(FloatToStr(V), false);
end;

procedure TQJsonEncoder.WriteValue(const V: Int64; AIsSign: Boolean);
begin
  if AIsSign then
    InternalWriteValue(IntToStr(V), false)
  else
    InternalWriteValue(SysUtils.UIntToStr(UInt64(V)), false);
end;

procedure TQJsonEncoder.WriteValue(const V: UnicodeString);
begin
  InternalWriteValue(V, true);
end;

procedure TQJsonEncoder.WriteValue(const V: TBcd);
begin
  InternalWriteValue(BcdToStr(V), false);
end;

procedure TQJsonEncoder.WriteValue(const V: TBytes);
begin
  InternalWriteValue(TNetEncoding.Base64.EncodeBytesToString(V), true);
end;

procedure TQJsonEncoder.WriteValue(const V: UInt64);
begin
  InternalWriteValue(SysUtils.UIntToStr(V), false);
end;

procedure TQJsonEncoder.WriteValue(const V: Currency;
const AFormat: UnicodeString);
var
  AValue: UnicodeString;
  ADummy: Extended;
begin
  if Length(AFormat) > 0 then
  begin
    AValue := FormatFloat(AFormat, V);
    InternalWriteValue(AValue, not TryStrToFloat(AValue, ADummy))
  end
  else
    InternalWriteValue(CurrToStr(V), false);
end;

procedure TQJsonEncoder.WriteValue(const V: TDateTime);
begin
  case FFormat.TimeKind of
    tkFormatedText:
      begin
        if Trunc(V) = 0 then
          InternalWriteValue(FormatDateTime(FFormat.TimeFormat, V), true)
        else if Frac(V) > 0 then
          InternalWriteValue(FormatDateTime(FFormat.DateTimeFormat, V), true)
        else
          InternalWriteValue(FormatDateTime(FFormat.DateFormat, V), true);
      end;
    tkUnixTimeStamp:
      InternalWriteValue(IntToStr(DateTimeToUnix(V, false)), false);
  end;
end;

procedure TQJsonEncoder.WriteValue(const V: Boolean);
begin
  if V then
    InternalWriteValue('true', false)
  else
    InternalWriteValue('false', false);
end;

{ TQJsonStringCaches }

class function TQJsonStringCaches.GetCurrent: TQJsonStringCaches;
  procedure CreateInstance;
  var
    ATemp: TQJsonStringCaches;
  begin
    ATemp := TQJsonStringCaches.Create(TQJsonStringEqualityComparer.Create);
    if AtomicCmpExchange(Pointer(FCurrent), Pointer(ATemp), nil) <> nil then
      FreeAndNil(ATemp);
  end;

begin
  if not Assigned(FCurrent) then
    CreateInstance;
  Result := FCurrent;
end;

procedure CreateDefaultWriter(AStream: TStream; var AWriter: IQSerializeWriter);
begin
  AWriter := TQJsonEncoder.Create(AStream, false, TQJsonEncoder.DefaultFormat,
    TEncoding.UTF8, 8192);
end;

procedure CreateDefaultReader(AStream: TStream; const AText: UnicodeString;
var AReader: IQSerializeReader);
begin
  if Assigned(AStream) then
    AReader := TQJsonDecoder.Create(AStream)
  else
    AReader := TQJsonDecoder.Create(AText);
end;

{ TQJsonDecoder }

constructor TQJsonDecoder.Create(const AText: UnicodeString);
begin
  inherited Create;
  FText := AText;
end;

constructor TQJsonDecoder.Create(AStream: TStream);
begin
  inherited Create;
  FStream := AStream;
end;

procedure TQJsonDecoder.DoParse;
var
  AParser: TQJsonParser;
begin
  AParser := TQJsonParser.Create(TQJsonStoreMode.jsmForwardOnly);
  try
    if Assigned(FStream) then
      AParser.ParseStream(@FRootNode, FStream, nil,
        procedure(AParser: TQJsonParser; AItem: PQJsonNode;
          AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction)
        begin
          HandleStage(AParser, AItem, AStage, AParseAction);
        end)
    else
      AParser.ParseText(@FRootNode, FText,
        procedure(AParser: TQJsonParser; AItem: PQJsonNode;
          AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction)
        begin
          HandleStage(AParser, AItem, AStage, AParseAction);
        end);
  finally
    FreeAndNil(AParser);
  end;
end;

procedure TQJsonDecoder.HandleStage(AParser: TQJsonParser; AItem: PQJsonNode;
AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction);
begin
  case AStage of
    jpsStartItem:
      begin
        if not TryRead(AItem.Name) then
          AParseAction := TQJsonParseAction.jpaSkipCurrent;
      end;
    jpsEndItem:
      begin
      end;
    jpsStartArray:
      ;
    jpsEndArray:
      ;
    jpsStartObject:
      ;
    jpsEndObject:
      ;
  end;
end;

initialization

TQSerializer.Current.RegisterCodec('json', CreateDefaultReader,
  CreateDefaultWriter);

end.

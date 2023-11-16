{*******************************************************}
{                                                       }
{       YxdJSON Library                                 }
{                                                       }
{       ��Ȩ���� (C) 2014 YangYxd, Swish                }
{                                                       }
{*******************************************************}
{
 --------------------------------------------------------
  ˵��
 --------------------------------------------------------
 YXDJSON����swish��QJSON�޸ģ���лswish����лQJson
 QJson����QDAC��Ŀ����Ȩ��swish(QQ:109867294)����
 ��л���ѵ�֧�֣��ֺ롢è��
 QDAC�ٷ�Ⱥ��250530692
 --------------------------------------------------------
 �� ���¼�¼ ��
 --------------------------------------------------------
 2014.07.16 ver 1.0.3
 1. ����addChildObject, addChildArray
 --------------------------------------------------------
 2014.07.15 ver 1.0.2
 1. �Ż������������� ^_^
 --------------------------------------------------------
 2014.07.13 ver 1.0.1
 1. XE6֧��
}

unit YxdJson;

interface

//Delphi 2007
{$IFDEF VER185}
{$DEFINE JSON_SUPPORT}
{$ENDIF}

//Delphi XE
{$IFDEF VER220}
{$DEFINE JSON_SUPPORT}
{$DEFINE JSON_UNICODE}
{$DEFINE JSON_RTTI}
{$ENDIF}

//Rad Studio XE6
{$IFDEF VER270}
{$DEFINE JSON_SUPPORT}
{$DEFINE JSON_UNICODE}
{$DEFINE JSON_RTTI}
{$DEFINE JSON_RTTI_NAMEFIELD}
{$ENDIF}

//Rad Studio XE7
{$IFDEF VER280}
{$DEFINE JSON_SUPPORT}
{$DEFINE JSON_UNICODE}
{$DEFINE JSON_RTTI}
{$DEFINE JSON_RTTI_NAMEFIELD}
{$ENDIF}
{$IFNDEF JSON_SUPPORT}
{$MESSAGE WARN '!!!JSON Only test in 2007 and XE6,No support in other version!!!'}
{$ENDIF}

{.$DEFINE USEYxdCommon}  // �Ƿ�ʹ��YxdCommon��Ԫ
{.$DEFINE FUNCTIONDEBUG} // ���ܵ�ʽģʽ
uses
  {$IFDEF USEYxdCommon}YxdCommon, {$ENDIF}
  {$IFNDEF JSON_UNICODE}Windows, {$ELSE} {$IFDEF MSWINDOWS}Windows, {$ENDIF}{$ENDIF}
  {$IF (RTLVersion>=26) and (not Defined(NEXTGEN))}AnsiStrings, {$IFEND}
  SysUtils, Classes, Variants, Math, DateUtils;

type
  JSONStringA = AnsiString;
  {$IFDEF JSON_UNICODE}
  JSONStringW = UnicodeString;
  JSONString = JSONStringW;
  JSONChar = WideChar;
  PJSONChar = PWideChar;
  TIntArray = TArray<Integer>;
  {$ELSE}
  JSONStringW = WideString;
  JSONString = JSONStringA;
  JSONChar = AnsiChar;
  PJSONChar = PAnsiChar;
  TIntArray = array of Integer;
  IntPtr = Integer;
  {$ENDIF}

type
  SerializeFilter = interface(IInterface) end;

type
  TTextEncoding = (teUnknown, {δ֪�ı���} teAuto,{�Զ����} teAnsi, { Ansi���� }
    teUnicode16LE, { Unicode LE ���� } teUnicode16BE, { Unicode BE ���� }
    teUTF8 { UTF8���� } );

type
  JSONDataType = (jdtUnknown, jdtNull, jdtString, jdtInteger, jdtFloat,
    jdtBoolean, jdtDateTime, jdtObject);

type
  JSONStringCatHelper = class
  private
    FValue: array of JSONChar;
    FStart, FDest: PJSONChar;
    FBlockSize: Integer;
    FSize: Integer;
    function GetValue: JSONString;
    function GetPosition: Integer;
    function GetChars(AIndex:Integer): JSONChar;
    procedure SetPosition(const Value: Integer);
    procedure NeedSize(ASize:Integer);
  public
    constructor Create; overload;
    constructor Create(ASize: Integer); overload;
    destructor Destroy; override;
    function Cat(p: PJSONChar; len: Integer): JSONStringCatHelper; overload;
    function Cat(const s: JSONString): JSONStringCatHelper; overload;
    function Cat(c: JSONChar): JSONStringCatHelper; overload;
    function Space(count:Integer): JSONStringCatHelper;
    function Back(ALen: Integer): JSONStringCatHelper;
    function BackIf(const s: PJSONChar): JSONStringCatHelper;
    property Value: JSONString read GetValue;
    property Chars[Index: Integer]: JSONChar read GetChars;
    property Start: PJSONChar read FStart;
    property Current: PJSONChar read FDest;
    property Position: Integer read GetPosition write SetPosition;
  end;

type
  JSONBase = class;
  JSONObject = class;
  JSONArray = class;
  
  JSONValue = packed record
  private
    FObject: JSONBase;
    function ValueAsDateTime(const DateFormat, TimeFormat, DateTimeFormat: JSONString): JSONString;
    function GetAsBoolean: Boolean;
    function GetAsByte: Byte;
    function GetAsDouble: Double;
    function GetAsDWORD: Cardinal;
    function GetAsFloat: Extended;
    function GetAsInt64: Int64;
    function GetAsInteger: Integer;
    function GetAsJSONArray: JSONArray;
    function GetAsJSONObject: JSONObject;
    function GetAsString: JSONString;
    function GetAsVariant: Variant;
    function GetAsWord: Word;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsByte(const Value: Byte);
    procedure SetAsDouble(const Value: Double);
    procedure SetAsDWORD(const Value: Cardinal);
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsInt64(const Value: Int64);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsJSONArray(const Value: JSONArray);
    procedure SetAsJSONObject(const Value: JSONObject);
    procedure SetAsString(const Value: JSONString);
    procedure SetAsVariant(const Value: Variant);
    procedure SetAsWord(const Value: Word);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function GetSize: Cardinal;
    procedure Free();
  public
    FType: JSONDataType;
    FName: JSONString;
    FNameHash: Cardinal;
    FValue: TBytes;
    function ToString: JSONString;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsByte: Byte read GetAsByte write SetAsByte;
    property AsWord: Word read GetAsWord write SetAsWord;
    property AsDWORD: Cardinal read GetAsDWORD write SetAsDWORD;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsString: JSONString read GetAsString write SetAsString;
    property AsVariant: Variant read GetAsVariant write SetAsVariant; // ��֧�ֳ�������
    property AsJsonObject: JSONObject read GetAsJSONObject write SetAsJSONObject;
    property AsJsonArray: JSONArray read GetAsJSONArray write SetAsJSONArray;
    property Size: Cardinal read GetSize;
  end;
  PJSONValue = ^JSONValue;

  JSONBase = class(TObject)
  private
    FParent: JSONBase;
    FItems: TList;
    FData: Pointer;
    FValue: PJSONValue; // FParent��Ϊnilʱ, FValue�ض���Ϊnil
    function GetItemIndex: Integer;
    function GetPath: JSONString;
    function GetValue: JSONString;
    procedure SetValue(const Value: JSONString);
    function GetName: JSONString;
    procedure RemoveObject(obj: JSONBase);
    function FormatParseError(ACode: Integer; AMsg: JSONString; ps,p:PJSONChar): JSONString;
    procedure RaiseParseException(ACode: Integer; ps, p: PJSONChar);

    //�¼�һ����JSON����
    function NewChildObject(const key: JSONString): JSONObject; //inline;
    //�¼�һ����JSON����
    function NewChildArray(const key: JSONString): JSONArray; //inline;
  protected
    function GetCount: Integer; virtual;
    function GetItems(Index: Integer): PJSONValue; virtual;
    function GetIsArray: Boolean; virtual;
    /// <summary>����Ϊ�ַ���</summary>
    /// <param name="ADoFormat">�Ƿ��ʽ���ַ����������ӿɶ���</param>
    /// <param name="AIndent">ADoFormat����ΪTrueʱ��������С</param>
    /// <returns>���ر������ַ���</returns>
    class function Encode(Obj: JSONBase; AIndent: Integer = 0): JSONString; virtual;
    class function InternalEncode(Obj: JSONBase; ABuilder: JSONStringCatHelper; AIndent: Integer): JSONStringCatHelper;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="p">Ҫ�������ַ���</param>
    /// <param name="len">�ַ������ȣ�<=0��Ϊ����\0(#0)��β��C���Ա�׼�ַ���</param>
    procedure Decode(p: PJSONChar; len: Integer = -1); overload;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="s">Ҫ������JSON�ַ���</param>
    procedure Decode(const s: JSONString); overload;
    procedure DecodeObject(var p: PJSONChar);
    function ParseJsonPair(ABuilder: JSONStringCatHelper; var p: PJSONChar): Integer;
    function ParseName(ABuilder: JSONStringCatHelper; var p: PJSONChar; var ErrCode: Integer): JSONString;
    function ParseValue(ABuilder: JSONStringCatHelper; var p: PJSONChar;
      const FName: JSONString): Integer;
    procedure BuildJsonString(ABuilder: JSONStringCatHelper; var p: PJSONChar);
    {$IFDEF JSON_UNICODE}
    function CharUnescape(var p: PJSONChar): JSONChar;
    {$ELSE}
    procedure CharUnescape(ABuilder: JSONStringCatHelper; var p: PJSONChar);
    {$ENDIF}
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear(); virtual; 

    procedure parse(const text: JSONString); overload;
    procedure parse(p: PJSONChar; len: Integer = -1); overload; virtual;
    {$IFDEF JSON_UNICODE}
    function ToString: JSONString; overload; override;
    {$ENDIF}
    function toString(AIndent: Integer{$IFNDEF JSON_UNICODE} = 0{$ENDIF}): JSONString; {$IFDEF JSON_UNICODE} overload;{$ENDIF}
    procedure Assign(ANode: JSONBase);
    
    // ���JSON�ַ����������Զ�����
    procedure putJSONStr(const key, value: JSONString; avType: JsonDataType = jdtUnknown); 

    /// <summary>���浱ǰ�������ݵ�����</summary>
    ///  <param name="AStream">Ŀ��������</param>
    ///  <param name="AEncoding">�����ʽ</param>
    ///  <param name="AWriteBom">�Ƿ�д��BOM</param>
    ///  <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream: TStream; AEncoding: TTextEncoding; AWriteBOM: Boolean); overload;
    procedure SaveToStream(AStream: TStream); overload;
    /// <summary>�����ĵ�ǰλ�ÿ�ʼ����JSON����</summary>
    ///  <param name="AStream">Դ������</param>
    ///  <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    ///  <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream: TStream; AEncoding: TTextEncoding=teUnknown);
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    ///  <param name="AFileName">�ļ���</param>
    ///  <param name="AEncoding">�����ʽ</param>
    ///  <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    ///  <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(const AFileName: JSONString); overload;
    procedure SaveToFile(const AFileName: JSONString; AEncoding: TTextEncoding; AWriteBOM: Boolean); overload;
    /// <summary>��ָ�����ļ��м��ص�ǰ����</summary>
    ///  <param name="AFileName">Ҫ���ص��ļ���</param>
    ///  <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    procedure LoadFromFile(const AFileName: JSONString; AEncoding: TTextEncoding=teUnknown);

    /// <summary>����ָ�����ƵĽ�������</summary>
    /// <param name="AName">Ҫ���ҵĽ������</param>
    /// <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOf(const Key: JSONString): Integer; virtual;
    procedure Remove(Index: Integer); virtual;

    // ����ָ����JSON�ַ���
    class function parseObject(const text: JSONString): JSONObject; overload;
    // ����ָ����JSON�ַ���
    class function parseArray(const text: JSONString): JSONArray; overload;  

    //�����
    property Parent: JSONBase read FParent;
    //�ӽ���ֵ
    property Value: JSONString read GetValue write SetValue;
    //����·����·���м���"\"�ָ�
    property Path: JSONString read GetPath;
    //�ڸ�����е�����˳�򣬴�0��ʼ�������-1��������Լ��Ǹ����
    property ItemIndex: Integer read GetItemIndex;
    //�ڵ�����(��һ��������)
    property Name: JSONString read GetName;
    //����ĸ������ݳ�Ա�����û�������������
    property Data: Pointer read FData write FData;
    //�ӽ������
    property Count: Integer read GetCount;
    //��ȡһ���ӽڵ�
    property Items[Index: Integer]: PJSONValue read GetItems; default;
  end;

  JSONObject = class(JSONBase)
  private
    procedure NewJsonValue(var v: PJSONValue); inline;
    function getItem(const key: JSONString): PJSONValue;
  protected
    procedure put(const key: JSONString; ABuilder: JSONStringCatHelper); overload;
  public
    procedure put(const key: JSONString; value: Integer); overload;
    procedure put(const key: JSONString; value: Word); overload;
    procedure put(const key: JSONString; value: Cardinal); overload;
    procedure put(const key: JSONString; value: Byte); overload;
    procedure put(const key: JSONString; const value: JSONString); overload;
    procedure put(const key: JSONString; const value: Int64); overload;
    procedure put(const key: JSONString; const value: Extended); overload;
    procedure put(const key: JSONString; const value: Double); overload;
    procedure put(const key: JSONString; const value: Variant); overload;
    procedure put(const key: JSONString; value: JSONObject); overload;
    procedure put(const key: JSONString; value: JSONArray); overload;
    procedure putDateTime(const key: JSONString; value: TDateTime);

    procedure Delete(const key: JSONString);
    function exist(const key: JSONString): Boolean;
    function Clone: JSONObject;

    function addChildObject(const key: JSONString): JSONObject;
    function addChildArray(const key: JSONString): JSONArray;

    function getByte(const key: JSONString): Byte;
    function getBoolean(const key: JSONString): Boolean;
    function getInt(const key: JSONString): Integer;
    function getInt64(const key: JSONString): Int64;
    function getWord(const key: JSONString): Word;
    function getDWORD(const key: JSONString): Cardinal;
    function getFloat(const key: JSONString): Extended;
    function getDouble(const key: JSONString): Double;
    function getString(const key: JSONString): JSONString;
    function getDateTime(const key: JSONString): TDateTime;
    function getVariant(const key: JSONString): Variant;
    function getJsonObject(const key: JSONString): JSONObject;
    function getJsonArray(const key: JSONString): JSONArray;
  end;

  JSONArray = class(JSONBase)
  private
    procedure NewJsonValue(var v: PJSONValue); inline;
  protected
    function GetIsArray: Boolean; override;
  public
    procedure add(value: Integer); overload;
    procedure add(value: Word); overload;
    procedure add(value: Cardinal); overload;
    procedure add(value: Byte); overload;
    procedure add(const value: JSONString); overload;
    procedure add(const value: Int64); overload;
    procedure add(const value: Extended); overload;
    procedure add(const value: Double); overload;
    procedure add(const value: Variant); overload;
    procedure add(value: JSONObject); overload;
    procedure add(value: JSONArray); overload;
    procedure addDateTime(value: TDateTime);
    // ���JSON�ַ����������Զ�����
    procedure addJSONStr(const key, value: JSONString; avType: JsonDataType = jdtUnknown); overload;

    function Clone: JSONArray;
    function addChildObject(): JSONObject;
    function addChildArray(): JSONArray;

    function getByte(Index: Integer): Byte;
    function getBoolean(Index: Integer): Boolean;
    function getInt(Index: Integer): Integer;
    function getInt64(Index: Integer): Int64;
    function getWord(Index: Integer): Word;
    function getDWORD(Index: Integer): Cardinal;
    function getFloat(Index: Integer): Extended;
    function getDouble(Index: Integer): Double;
    function getString(Index: Integer): JSONString;
    function getDateTime(Index: Integer): TDateTime;
    function getVariant(Index: Integer): Variant;
    function getJsonObject(Index: Integer): JSONObject;
    function getJsonArray(Index: Integer): JSONArray;
  end;

(*
type
  ///<summary>�����ⲿ֧�ֶ���صĺ���������һ���µ�QJSON����ע��ӳ��д����Ķ���</summary>
  ///<returns>�����´�����JSON����</returns>
  JsonCreateEvent = function(DataType: JSONDataType): JSONBase;
type
  ///<summary>�����ⲿ�����󻺴棬�Ա����ö���</summary>
  ///<param name="AJson">Ҫ�ͷŵ�JSON����</param>
  JsonFreeEvent = procedure (AJson: JSONBase);
*)

var
  // �Ƿ������ϸ���ģʽ�����ϸ�ģʽ�£�
  // 1.���ƻ��ַ�������ʹ��˫���Ű�������,���ΪFalse�������ƿ���û�����Ż�ʹ�õ����š�
  // 2.ע�Ͳ���֧�֣����ΪFalse����֧��//��ע�ͺ�/**/�Ŀ�ע��
  StrictJson: Boolean = False;
  // �Ƿ�����Key��Сд</summary>
  JsonCaseSensitive: Boolean = True;
  // ����Java��ʽ���룬��#$0�ַ�����Ϊ#$C080
  JavaFormatUtf8: Boolean = True;
  (*
  // ����Ҫ�½�һ��Json����ʱ����
  OnJsonCreate: JsonCreateEvent;
  // ����Ҫ�ͷ�һ��Json����ʱ����
  OnJsonFree: JsonFreeEvent;
  *)
{$IFDEF FUNCTIONDEBUG}
var
  ParseRef: Integer = 0;
  WhileRef: Integer = 0;
{$ENDIF}

function StrDup(const S: PJSONChar; AOffset: Integer = 0; const ACount: Integer = MaxInt): JSONString;
function IsHexChar(c: JSONChar): Boolean; inline;
function HexValue(c: JSONChar): Integer;
function HexChar(v: Byte): JSONChar;
//����ַ��Ƿ���ָ�����б���
function CharIn(const c, list: PJSONChar; ACharLen:PInteger = nil): Boolean; inline;
function CharInA(c, list: PAnsiChar; ACharLen: PInteger = nil): Boolean;
function CharInW(c, list: PWideChar; ACharLen: PInteger = nil): Boolean;
function CharInU(c, list: PAnsiChar; ACharLen: PInteger = nil): Boolean;
//���㵱ǰ�ַ��ĳ���
function CharSizeA(c: PAnsiChar): Integer;
function CharSizeU(c: PAnsiChar): Integer;
function CharSizeW(c: PWideChar): Integer;
function CharUpperA(c: AnsiChar): AnsiChar;
function CharUpperW(c: WideChar): WideChar;
//�����ַ��������кţ������е���ʼ��ַ
function StrPosA(start, current: PAnsiChar; var ACol, ARow:Integer): PAnsiChar;
function StrPosU(start, current: PAnsiChar; var ACol, ARow:Integer): PAnsiChar;
function StrPosW(start, current: PWideChar; var ACol, ARow:Integer): PWideChar;
//��ȡһ��
function DecodeLineA(var p:PAnsiChar; ASkipEmpty:Boolean=True): JSONStringA;
function DecodeLineW(var p:PWideChar; ASkipEmpty:Boolean=True): JSONStringW;
//�����հ��ַ������� Ansi���룬��������#9#10#13#161#161������UCS���룬��������#9#10#13#$3000
function SkipSpaceA(var p: PAnsiChar): Integer;
function SkipSpaceU(var p: PAnsiChar): Integer;
function SkipSpaceW(var p: PWideChar): Integer;
//����һ��,��#10Ϊ�н�β
function SkipLineA(var p: PAnsiChar): Integer;
function SkipLineU(var p: PAnsiChar): Integer;
function SkipLineW(var p: PWideChar): Integer;
//����Ƿ��ǿհ��ַ�
function IsSpaceA(const c:PAnsiChar; ASpaceSize:PInteger=nil): Boolean;
function IsSpaceU(const c:PAnsiChar; ASpaceSize:PInteger=nil): Boolean;
function IsSpaceW(const c:PWideChar; ASpaceSize:PInteger=nil): Boolean;
//����ֱ������ָ�����ַ�
function SkipUntilA(var p: PAnsiChar; AExpects: PAnsiChar; AQuoter: AnsiChar = #0): Integer;
function SkipUntilU(var p: PAnsiChar; AExpects: PAnsiChar; AQuoter: AnsiChar = #0): Integer;
function SkipUntilW(var p: PWideChar; AExpects: PWideChar; AQuoter: WideChar = #0): Integer;
//�ж��Ƿ�����ָ�����ַ�����ʼ
function StartWith(s, startby: PJSONChar; AIgnoreCase: Boolean): Boolean;
//�����ı�
procedure SaveTextA(AStream: TStream; const S: AnsiString);
procedure SaveTextU(AStream: TStream; const S: AnsiString; AWriteBom: Boolean = True);
procedure SaveTextW(AStream: TStream; const S: WideString; AWriteBom: Boolean = True);
procedure SaveTextWBE(AStream: TStream; const S: WideString; AWriteBom: Boolean = True);
//�����ı�
function LoadTextA(AStream: TStream; AEncoding: TTextEncoding=teUnknown): AnsiString; overload;
function LoadTextU(AStream: TStream; AEncoding: TTextEncoding=teUnknown): AnsiString; overload;
function LoadTextW(AStream: TStream; AEncoding: TTextEncoding=teUnknown): WideString; overload;
//����ת��
function AnsiEncode(p:PWideChar; l:Integer): AnsiString; overload;
function AnsiEncode(const p: WideString):AnsiString; overload;
function AnsiDecode(p: PAnsiChar; l:Integer): WideString;
function Utf8Encode(const p: WideString): AnsiString; overload;
function Utf8Encode(p: PWideChar; l: Integer): AnsiString; overload;

implementation

resourcestring
  SBadUnicodeChar = '��Ч��Unicode�ַ�:%d';
  SBadJson = '��ǰ���ݲ�����Ч��JSON�ַ���.';
  SCharNeeded = '��ǰλ��Ӧ���� "%s", ������ "%s".';
  SBadConvert = '%s ����һ����Ч�� %s ���͵�ֵ��';
  SBadNumeric = '"%s"������Ч����ֵ.';
  SBadJsonTime = '"%s"����һ����Ч������ʱ��ֵ.';
  SNameNotFound = '��Ŀ����δ�ҵ�.';
  SCommentNotSupport = '�ϸ�ģʽ�²�֧��ע��, Ҫ��������ע�͵�JSON����, �뽫StrictJson��������ΪFalse.';
  SUnsupportArrayItem = '��ӵĶ�̬�����%d��Ԫ�����Ͳ���֧�֡�';
  SBadStringStart = '�ϸ����JSON�ַ���������"��ʼ��';
  SUnknownToken = '�޷�ʶ���ע�ͷ�, ע�ͱ�����//��/**/����.';
  SNotSupport = '���� [%s] �ڵ�ǰ���������²���֧��.';
  SBadJsonArray = '%s ����һ����Ч��JSON���鶨��.';
  SBadJsonObject = '%s ����һ����Ч��JSON������.';
  SBadJsonEncoding = '��Ч�ı���, ����ֻ����UTF-8, ANSI, Unicode 16 LE, Unicode 16 BE.';
  SJsonParseError = '��%d�е�%d��: %s '#13#10'��: %s';
  SBadJsonName = '%s ����һ����Ч��JSON��������.';
  SBadNameStart = 'Json�������Ӧ��''"''�ַ���ʼ.';
  SBadNameEnd = 'Json��������δ��ȷ����.';
  SEndCharNeeded = '��ǰλ����ҪJson�����ַ�",]}".';
  SUnknownError = 'δ֪�Ĵ���.';
  SObjectChildNeedName = '���� %s �ĵ� %d ���ӽ������δ��ֵ, �������ǰ���踳ֵ.';

const
  JsonTypeName: array [0 .. 8] of JSONString = ('Unknown', 'Null', 'String',
    'Integer', 'Float', 'Boolean', 'DateTime', 'Array', 'Object');
  EParse_Unknown            = -1;
  EParse_BadStringStart     = 1;
  EParse_BadJson            = 2;
  EParse_CommentNotSupport  = 3;
  EParse_UnknownToken       = 4;
  EParse_EndCharNeeded      = 5;
  EParse_BadNameStart       = 6;
  EParse_BadNameEnd         = 7;
  EParse_NameNotFound       = 8;
const
  //��������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��
  JsonDateFormat: JSONString = 'yyyy-mm-dd';
  //ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��
  JsonTimeFormat: JSONString = 'yyyy-mm-dd''T''hh:nn:ss.zzz';
  //����ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��
  JsonDateTimeFormat: JSONString = 'hh:nn:ss.zzz';
  //����ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��
  JsonDefaultDateTimeFormat: JSONString = 'yyyy-mm-dd hh:nn:ss';

//���㵱ǰ�ַ��ĳ���
// GB18030,����GBK��GB2312
// ���ֽڣ���ֵ��0��0x7F��
// ˫�ֽڣ���һ���ֽڵ�ֵ��0x81��0xFE���ڶ����ֽڵ�ֵ��0x40��0xFE��������0x7F����
// ���ֽڣ���һ���ֽڵ�ֵ��0x81��0xFE���ڶ����ֽڵ�ֵ��0x30��0x39���������ֽڴ�0x81��0xFE�����ĸ��ֽڴ�0x30��0x39��
function CharSizeA(c: PAnsiChar): Integer;
begin
  {$IFDEF JSON_UNICODE}
  if TEncoding.ANSI.CodePage = 936 then begin
  {$ELSE}
  if GetACP = 936 then begin
  {$ENDIF}
    Result:=1;
    if (c^>=#$81) and (c^<=#$FE) then begin
      Inc(c);
      if (c^>=#$40) and (c^<=#$FE) and (c^<>#$7F) then
        Result:=2
      else if (c^>=#$30) and (c^<=#$39) then begin
        Inc(c);
        if (c^>=#$81) and (c^<=#$FE) then begin
          Inc(c);
          if (c^>=#$30) and (c^<=#$39) then
            Result:=4;
        end;
      end;
    end;
  end else
    {$IFDEF JSON_UNICODE}
    Result := AnsiStrings.StrCharLength(PAnsiChar(c));
    {$ELSE}
    Result := StrCharLength(PAnsiChar(c));
    {$ENDIF}
end;

function CharSizeU(c: PAnsiChar): Integer;
begin
  if (Ord(c^) and $80) = 0 then
    Result := 1
  else begin
    if (Ord(c^) and $FC) = $FC then //4000000+
      Result := 6
    else if (Ord(c^) and $F8)=$F8 then//200000-3FFFFFF
      Result := 5
    else if (Ord(c^) and $F0)=$F0 then//10000-1FFFFF
      Result := 4
    else if (Ord(c^) and $E0)=$E0 then//800-FFFF
      Result := 3
    else if (Ord(c^) and $C0)=$C0 then//80-7FF
      Result := 2
    else
      Result := 1;
  end
end;

function CharSizeW(c: PWideChar): Integer;
begin
  if (c[0]>=#$DB00) and (c[0]<=#$DBFF) and (c[1] >= #$DC00) and (c[1] <= #$DFFF) then
    Result := 2
  else
    Result := 1;
end;

procedure CalcCharLengthA(var Lens: TIntArray; list: PAnsiChar);
var
  i, l: Integer;
begin
  i := 0;
  System.SetLength(Lens, Length(List));
  while i< Length(List) do begin
    l := CharSizeA(@list[i]);
    lens[i] := l;
    Inc(i, l);
  end;
end;

procedure CalcCharLengthU(var Lens: TIntArray; list: PAnsiChar);
var
  i, l: Integer;
begin
  i := 0;
  System.SetLength(Lens, Length(List));
  while i< Length(List) do begin
    l := CharSizeU(@list[i]);
    lens[i] := l;
    Inc(i, l);
  end;
end;

// ����ַ��Ƿ���ָ�����б���
function CharIn(const c, list: PJSONChar; ACharLen:PInteger = nil): Boolean;
begin
{$IFDEF JSON_UNICODE}
  Result := CharInW(c, list, ACharLen);
{$ELSE}
  Result := CharInA(c, list, ACharLen);
{$ENDIF}
end;

function CharInA(c, list: PAnsiChar; ACharLen: PInteger = nil): Boolean;
var
  i: Integer;
  lens: TIntArray;
begin
  Result := False;
  CalcCharLengthA(lens, list);
  i := 0;
  while i < Length(list) do begin
    if CompareMem(c, @list[i], lens[i]) then begin
      if ACharLen <> nil then
        ACharLen^:=lens[i];
      Result := True;
      Break;
    end else
      Inc(i, lens[i]);
  end;
end;

function CharInW(c, list: PWideChar; ACharLen: PInteger = nil): Boolean;
var
  p: PWideChar;
begin
  Result:=False;
  p := list;
  while p^ <> #0 do begin
    if p^ = c^ then begin
      if (p[0]>=#$DB00) and (p[0]<=#$DBFF) then begin
        if p[1]=c[1] then begin
          Result := True;
          if ACharLen <> nil then
            ACharLen^ := 2;
          Break;
        end;
      end else begin
        Result := True;
        if ACharLen <> nil then
          ACharLen^ := 1;
        Break;
      end;
    end;
    Inc(p);
  end;
end;

function CharInU(c, list: PAnsiChar; ACharLen: PInteger = nil): Boolean;
var
  i: Integer;
  lens: TIntArray;
begin
  Result := False;
  CalcCharLengthU(lens, list);
  i := 0;
  while i < Length(list) do begin
    if CompareMem(c, @list[i], lens[i]) then begin
      if ACharLen <> nil then
        ACharLen^ := lens[i];
      Result := True;
      Break;
    end else
      Inc(i, lens[i]);
  end;
end;

function StrDup(const S: PJSONChar; AOffset: Integer; const ACount: Integer): JSONString;
var
  C, ACharSize: Integer;
  p, pds, pd: PJSONChar;
begin
  C := 0;
  p := S + AOffset;
  SetLength(Result, 4096);
  pd := PJSONChar(Result);
  pds := pd;
  while (p^ <> #0) and (C < ACount) do begin
    ACharSize := {$IFDEF JSON_UNICODE} CharSizeW(p); {$ELSE} CharSizeA(p); {$ENDIF}
    AOffset := pd - pds;
    if AOffset + ACharSize = Length(Result) then begin
      SetLength(Result, Length(Result){$IFDEF JSON_UNICODE} shl 1{$ENDIF});
      pds := PJSONChar(Result);
      pd := pds + AOffset;
    end;
    Inc(C);
    pd^ := p^;
    if ACharSize = 2 then
      pd[1] := p[1];
    Inc(pd, ACharSize);
    Inc(p, ACharSize);
  end;
  SetLength(Result, pd-pds);
end;

function StrPosA(start, current: PAnsiChar; var ACol, ARow:Integer): PAnsiChar;
begin
  ACol := 1;
  ARow := 1;
  Result := start;
  while IntPtr(start) < IntPtr(current) do begin
    if start^=#10 then begin
      Inc(ARow);
      ACol := 1;
      Inc(start);
      Result := start;
    end else begin
      Inc(start, CharSizeA(start));
      Inc(ACol);
    end;
  end;
end;

function StrPosU(start, current: PAnsiChar; var ACol, ARow:Integer): PAnsiChar;
begin
  ACol := 1;
  ARow := 1;
  Result := start;
  while IntPtr(start)<IntPtr(current) do begin
    if start^=#10 then begin
      Inc(ARow);
      ACol := 1;
      Inc(start);
      Result := start;
    end else begin
      Inc(start, CharSizeU(start));
      Inc(ACol);
    end;
  end;
end;

function StrPosW(start, current: PWideChar; var ACol, ARow:Integer): PWideChar;
begin
  ACol := 1;
  ARow := 1;
  Result := start;
  while start < current do begin
    if start^=#10 then begin
      Inc(ARow);
      ACol := 1;
      Inc(start);
      Result := start;
    end else begin
      Inc(start, CharSizeW(start));
      Inc(ACol);
    end;
  end;
end;

function DecodeLineA(var p: PAnsiChar; ASkipEmpty: Boolean): JSONStringA;
var
  ps: PAnsiChar;
  i: Integer;
begin
  ps := p;
  while p^<>#0 do begin
    if (PWORD(p)^ = $0D0A) or (PWORD(p)^ = $0A0D) then
      i := 2
    else if (p^ = #13) then
      i := 1
    else
      i := 0;
    if i > 0 then begin
      if ps = p then begin
        if ASkipEmpty then begin
          Inc(p, i);
          ps := p;
        end else begin
          Result := '';
          Exit;
        end;
      end else begin
        SetLength(Result, p-ps);
        Move(ps^, PAnsiChar(Result)^, p-ps);
        Inc(p, i);
        Exit;
      end;
    end else
      Inc(p);
  end;
  if ps = p then
    Result := ''
  else begin
    SetLength(Result, p-ps);
    Move(ps^, PAnsiChar(Result)^, p-ps);
  end;
end;

function DecodeLineW(var p: PWideChar; ASkipEmpty: Boolean): JSONStringW;
var
  ps: PWideChar;
  i: Integer;
begin
  ps := p;
  while p^<>#0 do begin
    if (PCardinal(Result)^ = $000D000A) or (PCardinal(Result)^ = $000A000D) then
      i := 2
    else if (p^ = #13) then
      i := 1
    else
      i := 0;
    if i > 0 then begin
      if ps = p then begin
        if ASkipEmpty then begin
          Inc(p, i);
          ps := p;
        end else begin
          Result := '';
          Exit;
        end;
      end else begin
        SetLength(Result, p-ps);
        Move(ps^, PWideChar(Result)^, p-ps);
        Inc(p, i);
        Exit;
      end;
    end else
      Inc(p);
  end;
  if ps = p then
    Result := ''
  else begin
    SetLength(Result, p-ps);
    Move(ps^, PWideChar(Result)^, p-ps);
  end;
end;

function IsSpaceA(const c: PAnsiChar; ASpaceSize: PInteger): Boolean;
begin
  if c^ in [#9, #10, #13, #32] then begin
    Result := True;
    if ASpaceSize <> nil then
      ASpaceSize^ := 1;
  end else if PWORD(c)^ = $A1A1 then begin
    Result := True;
    if ASpaceSize <> nil then
      ASpaceSize^ := 2;
  end else
    Result:=False;
end;

function IsSpaceW(const c: PWideChar; ASpaceSize: PInteger): Boolean;
begin
  Result := (c^=#9) or (c^=#10) or (c^=#13) or (c^=#32) or (c^=#$3000);
  if Result and (ASpaceSize <> nil) then
    ASpaceSize^ := 1;
end;

//ȫ�ǿո�$3000��UTF-8������227,128,128
function IsSpaceU(const c: PAnsiChar; ASpaceSize: PInteger): Boolean;
begin
  if c^ in [#9, #10, #13, #32] then begin
    Result := True;
    if (ASpaceSize <> nil) then
      ASpaceSize^ := 1;
  end else if (c^=#227) and (PWORD(c+1)^ = $8080) then begin
    Result := True;
    if (ASpaceSize <> nil) then
      ASpaceSize^ := 3;
  end else
    Result:=False;
end;

function SkipSpaceA(var p: PAnsiChar): Integer;
var
  ps: PAnsiChar;
  L: Integer;
begin
  ps := p;
  while p^<>#0 do begin
    if IsSpaceA(p, @L) then
      Inc(p, L)
    else
      Break;
  end;
  Result:= p - ps;
end;

function SkipSpaceU(var p: PAnsiChar): Integer;
var
  ps: PAnsiChar;
  L: Integer;
begin
  ps := p;
  while p^<>#0 do begin
    if IsSpaceU(p, @L) then
      Inc(p, L)
    else
      Break;
  end;
  Result:= p - ps;
end;

function SkipSpaceW(var p: PWideChar): Integer;
var
  ps: PWideChar;
  L:Integer;
begin
  ps := p;
  while p^<>#0 do begin
    if IsSpaceW(p, @L) then
      Inc(p,L)
    else
      Break;
  end;
  Result := p - ps;
end;

function SkipLineA(var p: PAnsiChar): Integer;
var
  ps: PAnsiChar;
begin
  ps := p;
  while p^ <> #0 do begin
    if (PWORD(p)^ = $0D0A) or (PWORD(p)^ = $0A0D) then begin
      Inc(p, 2);
      Break;
    end else if  (p^ = #13) then begin
      Inc(p);
      Break;
    end else
      Inc(p);
  end;
  Result := p - ps;
end;

function SkipLineU(var p: PAnsiChar): Integer;
begin
  Result := SkipLineA(p);
end;

function SkipLineW(var p: PWideChar): Integer;
var
  ps: PWideChar;
begin
  ps := p;
  while p^ <> #0 do begin
    if (PCardinal(p)^ = $000D000A) or (PCardinal(p)^ = $000A000D) then begin
      Inc(p, 2);
      Break;
    end else if  (p^ = #13) then begin
      Inc(p);
      Break;
    end else
      Inc(p);
  end;
  Result := p - ps;
end;

function SkipUntilA(var p: PAnsiChar; AExpects: PAnsiChar; AQuoter: AnsiChar): Integer;
var
  ps: PAnsiChar;
begin
  ps := p;
  while p^<>#0 do begin
    if (p^ = AQuoter) then begin
      Inc(p);
      while p^<>#0 do begin
        if p^ = #$5C then begin
          Inc(p);
          if p^<>#0 then
            Inc(p);
        end else if p^ = AQuoter then begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end else
          Inc(p);
      end;
    end else if CharInA(p, AExpects) then
      Break
    else
      Inc(p, CharSizeA(p));
  end;
  Result := p - ps;
end;

function SkipUntilU(var p: PAnsiChar; AExpects: PAnsiChar; AQuoter: AnsiChar): Integer;
var
  ps: PAnsiChar;
begin
  ps := p;
  while p^<>#0 do begin
    if (p^ = AQuoter) then begin
      Inc(p);
      while p^<>#0 do begin
        if p^=#$5C then begin
          Inc(p);
          if p^<>#0 then
            Inc(p);
        end else if p^=AQuoter then begin
          Inc(p);
          if p^=AQuoter then
            Inc(p)
          else
            Break;
        end else
          Inc(p);
      end;
    end else if CharInU(p, AExpects) then
      Break
    else
      Inc(p, CharSizeU(p));
  end;
  Result := p - ps;
end;

function SkipUntilW(var p: PWideChar; AExpects: PWideChar; AQuoter: WideChar): Integer;
var
  ps: PWideChar;
begin
  ps := p;
  while p^<>#0 do begin
    if (p^=AQuoter) then begin
      Inc(p);
      while p^<>#0 do begin
        if p^=#$5C then begin
          Inc(p);
          if p^<>#0 then
            Inc(p);
        end else if p^=AQuoter then begin
          Inc(p);
          if p^=AQuoter then
            Inc(p)
          else
            Break;
        end else
          Inc(p);
      end;
    end else if CharInW(p, AExpects) then
      Break
    else
      Inc(p, CharSizeW(p));
  end;
  Result := p - ps;
end;

function CharUpperA(c: AnsiChar): AnsiChar;
begin
  if (c>=#$61) and (c<=#$7A) then
    Result := AnsiChar(Ord(c)-$20)
  else
    Result := c;
end;

function CharUpperW(c: WideChar): WideChar;
begin
  if (c>=#$61) and (c<=#$7A) then
    Result := WideChar(PWord(@c)^-$20)
  else
    Result := c;
end;

function StartWith(s, startby: PJSONChar; AIgnoreCase: Boolean): Boolean;
begin
  while (s^<>#0) and (startby^<>#0) do begin
    if AIgnoreCase then begin
      {$IFDEF JSON_UNICODE}
      if CharUpperW(s^) <> CharUpperW(startby^) then
      {$ELSE}
      if CharUpperA(s^) <> CharUpperA(startby^) then
      {$ENDIF}
        Break;
    end else if s^<>startby^ then
      Break;
    Inc(s);
    Inc(startby);
  end;
  Result := startby^ = #0;
end;

{$IFNDEF USEYxdCommon}
function HashOf(const Key: Pointer; KeyLen: Cardinal): Cardinal;
var
  ps: PCardinal;
  lr: Cardinal;
begin
  Result := 0;
  if KeyLen > 0 then begin
    ps := Key;
    lr := (KeyLen and $03);//��鳤���Ƿ�Ϊ4��������
    KeyLen := (KeyLen and $FFFFFFFC);//��������
    while KeyLen > 0 do begin
      Result := ((Result shl 5) or (Result shr 27)) xor ps^;
      Inc(ps);
      Dec(KeyLen, 4);
    end;
    if lr <> 0 then begin
      case lr of
        1: KeyLen := PByte(ps)^;
        2: KeyLen := PWORD(ps)^;
        3: KeyLen := PWORD(ps)^ or (PByte(Cardinal(ps) + 2)^ shl 16);
      end;
      Result := ((Result shl 5) or (Result shr 27)) xor KeyLen;
    end;
  end;
end;
{$ENDIF}

function IsHexChar(c: JSONChar): Boolean; inline;
begin
  Result:=((c>='0') and (c<='9')) or
    ((c>='a') and (c<='f')) or
    ((c>='A') and (c<='F'));
end;

function HexValue(c: JSONChar): Integer;
begin
  if (c>='0') and (c<='9') then
    Result := Ord(c) - Ord('0')
  else if (c>='a') and (c<='f') then
    Result := 10+ Ord(c)-Ord('a')
  else
    Result := 10+ Ord(c)-Ord('A');
end;

function HexChar(v: Byte): JSONChar;
begin
  if v<10 then
    Result := JSONChar(v + Ord('0'))
  else
    Result := JSONChar(v-10 + Ord('A'));
end;

function ParseHex(var p:PJSONChar;var Value:Int64):Integer;
var
  ps: PJSONChar;
begin
  Value := 0;
  ps := p;
  while IsHexChar(p^) do begin
    Value := (Value shl 4) + HexValue(p^);
    Inc(p);
  end;
  Result := p - ps;
end;

function ParseInt(var s:PJSONChar; var ANum:Int64):Integer;
var
  ps: PJSONChar;
  ANeg: Boolean;
begin
  ps:=s;
  //����16���ƿ�ʼ�ַ�
  if s^ = '$' then begin
    Inc(s);
    Result := ParseHex(s, ANum);
  end else if (s^='0') and ((s[1]='x') or (s[1]='X')) then begin
    Inc(s, 2);
    Result := ParseHex(s, ANum);
  end else begin
    if (s^='-') then begin
      ANeg := True;
      Inc(s);
    end else begin
      ANeg := False;
      if s^='+' then
        Inc(s);
    end;
    ANum := 0;
    while (s^>='0') and (s^<='9') do begin
      ANum := ANum * 10 + Ord(s^)-Ord('0');
      Inc(s);
    end;
    if ANeg then
      ANum := -ANum;
    Result := s - ps;
  end;
end;

function ParseNumeric(var s: PJSONChar; var ANum:Extended): Boolean;
var
  ps: PJSONChar;

  function ParseHexInt:Boolean;
  var
    iVal:Int64;
  begin
    iVal:=0;
    while IsHexChar(s^) do begin
      iVal := (iVal shl 4) + HexValue(s^);
      Inc(s);
    end;
    Result := (s<>ps);
    ANum := iVal;
  end;
  
  function ParseDec: Boolean;
  var
    ACount:Integer;
    iVal:Int64;
    APow:Extended;
  begin
    ParseInt(s, iVal);
    ANum := iVal;
    if s^='.' then begin //С������
      Inc(s);
      ACount := ParseInt(s, iVal);
      if ACount>0 then
        ANum := ANum + iVal / IntPower(10, ACount);
    end;
    if (s^='e') or (s^='E') then begin
      Inc(s);
      if ParseNumeric(s,APow) then
        ANum := ANum * Power(10, APow);
    end;
    Result := (s <> ps);
  end;

begin
  ps := s;
  if s^='$' then begin
    Inc(s);
    Result := ParseHexInt;
    Exit;
  end else if (s^='0') and ((s[1]='x') or (s[1]='X')) then begin
    Inc(s, 2);
    Result := ParseHexInt;
    Exit;
  end else
    Result := ParseDec;
end;  

function ParseDateTime(s: PJSONChar; var AResult:TDateTime):Boolean;
var
  Y,M,D,H,N,Sec,MS: Word;
  AQuoter: JSONChar;
  ADate: TDateTime;

  function ParseNum(var n:Word):Boolean;
  var
    neg: Boolean;
    ps: PJSONChar;
  begin
    n := 0; ps := s;
    if s^ = '-' then begin
      neg := true;
      Inc(s);
    end else
      neg:=false;
    while s^<>#0 do begin
      if (s^>='0') and (s^<='9') then begin
        n:=n*10+Ord(s^)-48;
        Inc(s);
      end else
        Break;
    end;
    if neg then
      n := -n;
    Result := ps <> s;
  end;

begin
  if (s^='"') or (s^='''') then begin
    AQuoter := s^;
    Inc(s);
  end else
    AQuoter:=#0;
  Result := ParseNum(Y);
  if not Result then
    Exit;
  if s^='-' then begin
    Inc(s);
    Result:=ParseNum(M);
    if (not Result) or (s^<>'-') then
      Exit;
    Inc(s);
    Result:=ParseNum(D);
    if (not Result) or ((s^<>'T') and (s^<>' ') and (s^<>#0)) then
      Exit;
    if s^<>#0 then Inc(s);
    Result := TryEncodeDate(Y,M,D,ADate);
    if not Result then
      Exit;
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(s);
    if s^<>#0 then begin
      if not ParseNum(H) then begin //û��ʱ��ֵ
        AResult:=ADate;
        Exit;
      end;
      if s^<>':' then begin
        if H in [0..23] then
          AResult := ADate + EncodeTime(H,0,0,0)
        else
          Result:=False;
        Exit;
      end;
      Inc(s);
    end else begin
      AResult:=ADate;
      Exit;
    end;
  end else if s^=':' then begin
    ADate:=0;
    H:=Y;
    Inc(s);
  end else begin
    Result:=False;
    Exit;
  end;
  if H>23 then begin
    Result:=False;
    Exit;
  end;
  if not ParseNum(N) then begin
    if AQuoter<>#0 then begin
      if s^=AQuoter then
        AResult:=ADate+EncodeTime(H,0,0,0)
      else
        Result:=False;
    end else
      AResult:=ADate+EncodeTime(H,0,0,0);
    Exit;
  end else if N>59 then begin
    Result:=False;
    Exit;
  end;
  Sec:=0;
  MS:=0;
  if s^=':' then begin
    Inc(s);
    if not ParseNum(Sec) then begin
      if AQuoter<>#0 then begin
        if s^=AQuoter then
          AResult:=ADate+EncodeTime(H,N,0,0)
        else
          Result:=False;
      end else
        AResult:=ADate+EncodeTime(H,N,0,0);
      Exit;
    end else if Sec>59 then begin
      Result:=False;
      Exit;
    end;
    if s^='.' then begin
      Inc(s);
      if not ParseNum(MS) then begin
        if AQuoter<>#0 then begin
          if AQuoter=s^ then
            AResult:=ADate+EncodeTime(H,N,Sec,0)
          else
            Result:=False;
        end else
          AResult:=ADate+EncodeTime(H,N,Sec,0);
        Exit;
      end else if MS>=1000 then begin//����1000����΢��Ϊ��λ��ʱ�ģ�ת��Ϊ����
        while MS>=1000 do
          MS:=MS div 10;
      end;
      if AQuoter<>#0 then begin
        if AQuoter=s^ then
          AResult:=ADate+EncodeTime(H,N,Sec,MS)
        else
          Result:=False;
        Exit;
      end else
        AResult:=ADate+EncodeTime(H,N,Sec,MS);
    end else begin
      if AQuoter<>#0 then begin
        if AQuoter=s^ then
          AResult:=ADate+EncodeTime(H,N,Sec,0)
        else
          Result:=False;
      end else
        AResult:=ADate+EncodeTime(H,N,Sec,0)
    end;
  end else begin
    if AQuoter<>#0 then begin
      if AQuoter=s^ then
        AResult:=ADate+EncodeTime(H,N,0,0)
      else
        Result:=False;
    end else
      AResult:=ADate+EncodeTime(H,N,0,0);
  end;
end;

function ParseWebTime(p:PJSONChar;var AResult:TDateTime):Boolean;
var
  I:Integer;
  Y,M,D,H,N,S:Integer;
const
  MonthNames:array [0..11] of JSONString=('Jan', 'Feb', 'Mar', 'Apr', 'May',
    'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  Comma: PJSONChar = ',';
  Digits: PJSONChar = '0123456789';
begin
  //�������ڣ��������ֱ��ͨ�����ڼ������������Ҫ
  {$IFDEF JSON_UNICODE}SkipUntilW{$ELSE}SkipUntilA{$ENDIF}(p, Comma, #0);
  if p^=#0 then begin
    Result:=false;
    Exit;
  end else
    Inc(p);
  {$IFDEF JSON_UNICODE}SkipUntilW{$ELSE}SkipUntilA{$ENDIF}(p, Digits, #0);
  D := 0;
  //����
  while (p^>='0') and (p^<='9') do begin
    D:=D*10+Ord(p^)-Ord('0');
    Inc(p);
  end;
  if (D<1) or (D>31) then begin
    Result:=false;
    Exit;
  end;
  {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
  M:=0;
  for I := 0 to 11 do begin
    if StartWith(p, PJSONChar(MonthNames[I]),true) then begin
      M:=I+1;
      Break;
    end;
  end;
  if (M<1) or (M>12) then begin
    Result:=False;
    Exit;
  end;
  while (p^<>#0) and ((p^<'0') or (p^>'9')) do
    Inc(p);
  Y:=0;
  while (p^>='0') and (p^<='9') do begin
    Y:=Y*10+Ord(p^)-Ord('0');
    Inc(p);
  end;
  while p^=' ' do Inc(p);
  H:=0;
  while (p^>='0') and (p^<='9') do begin
    H:=H*10+Ord(p^)-Ord('0');
    Inc(p);
  end;
  while p^=':' do Inc(p);
  N:=0;
  while (p^>='0') and (p^<='9') do begin
    N:=N*10+Ord(p^)-Ord('0');
    Inc(p);
  end;
  while p^=':' do Inc(p);
  S:=0;
  while (p^>='0') and (p^<='9') do begin
    S:=S*10+Ord(p^)-Ord('0');
    Inc(p);
  end;
  while p^=':' do Inc(p);
  Result := TryEncodeDateTime(Y,M,D,H,N,S,0,AResult);
end;

function ParseJsonTime(p: PJSONChar; var ATime: TDateTime): Boolean;
var
  MS, TimeZone: Int64;
begin
  // Javascript���ڸ�ʽΪ/DATE(��1970.1.1�����ڵĺ�����+ʱ��)/
  Result := False;
  if not StartWith(p, '/DATE', False) then
    Exit;
  Inc(p, 5);
  {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
  if p^ <> '(' then
    Exit;
  Inc(p);
  {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
  if ParseInt(p, MS) = 0 then
    Exit;
  {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
  if (p^ = '+') or (p^ = '-') then begin
    if ParseInt(p, TimeZone) = 0 then
      Exit;
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
  end else
    TimeZone := 0;
  if p^ = ')' then begin
    ATime := (MS div 86400000) + ((MS mod 86400000) / 86400000.0);
    if TimeZone <> 0 then
      ATime := IncHour(ATime, -TimeZone);
    Inc(p);
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
    Result := True
  end;
end;

function AnsiEncode(p:PWideChar; l:Integer): AnsiString;
var
  ps: PWideChar;
  len: Integer;
begin
  if l<=0 then begin
    ps:=p;
    while ps^<>#0 do Inc(ps);
    l:=ps-p;
  end;
  if l>0 then  begin
    {$IFDEF MSWINDOWS}
    len := WideCharToMultiByte(CP_ACP,0,p,l,nil,0,nil,nil);
    SetLength(Result, len);
    WideCharToMultiByte(CP_ACP,0,p,l,PAnsiChar(Result), len, nil, nil);
    {$ELSE}
    len := l shl 1;
    SetLength(Result, l);
    Move(p^, PAnsiChar(Result)^, len);
    Result := TEncoding.Convert(TEncoding.Unicode,TEncoding.ANSI, Result, 0, len);
    {$ENDIF}
  end else
    Result := '';
end;

function AnsiEncode(const p: WideString):AnsiString;
begin
  Result := AnsiEncode(PWideChar(p), Length(p));
end;

function AnsiDecode(p: PAnsiChar; l:Integer): WideString;
var
  ps: PAnsiChar;
{$IFNDEF MSWINDOWS}
  ABytes:TBytes;
{$ENDIF}
begin
  if l<=0 then begin
    ps := p;
    while ps^<>#0 do Inc(ps);
    l:=IntPtr(ps)-IntPtr(p);
  end;
  if l>0 then begin
    {$IFDEF MSWINDOWS}
    System.SetLength(Result, MultiByteToWideChar(CP_ACP,0,PAnsiChar(p),l,nil,0));
    MultiByteToWideChar(CP_ACP, 0, PAnsiChar(p),l,PWideChar(Result),Length(Result));
    {$ELSE}
    System.SetLength(ABytes, l);
    Move(p^, PByte(@ABytes[0])^, l);
    Result := TEncoding.ANSI.GetString(ABytes);
    {$ENDIF}
  end else
    System.SetLength(Result,0);
end;

procedure SaveTextA(AStream: TStream; const S: AnsiString);
begin
  AStream.WriteBuffer(PAnsiChar(S)^, Length(S))
end;

function Utf8Encode(const p: WideString): AnsiString;
begin
  Result:=Utf8Encode(PWideChar(p), Length(p));
end;

function Utf8Encode(p:PWideChar; l:Integer): AnsiString;
var
  ps:PWideChar;
  pd,pds:PAnsiChar;
  c:Cardinal;
begin
  if p=nil then
    Result := ''
  else begin
    if l<=0 then begin
      ps:=p;
      while ps^<>#0 do
        Inc(ps);
      l:=ps-p;
      end;
    SetLength(Result, l*6);//UTF8ÿ���ַ����6�ֽڳ�,һ���Է����㹻�Ŀռ�
    if l>0 then begin
      Result[1] := #1;
      ps:=p;
      pd:=PAnsiChar(Result);
      pds:=pd;
      while l>0 do begin
        c:=Cardinal(ps^);
        Inc(ps);
        if (c>=$D800) and (c<=$DFFF) then begin//Unicode ��չ���ַ�
          c:=(c-$D800);
          if (ps^>=#$DC00) and (ps^<=#$DFFF) then begin
            c:=$10000+((c shl 10) + (Cardinal(ps^)-$DC00));
            Inc(ps);
            Dec(l);
          end else
            raise Exception.Create(Format(SBadUnicodeChar,[IntPtr(ps^)]));
        end;
        Dec(l);
        if c=$0 then begin
          if JavaFormatUtf8 then begin//����Java��ʽ���룬��#$0�ַ�����Ϊ#$C080
            pd^:=#$C0;
            Inc(pd);
            pd^:=#$80;
            Inc(pd);
          end else begin
            pd^:=AnsiChar(c);
            Inc(pd);
          end;
        end else if c<=$7F then begin //1B
          pd^:=AnsiChar(c);
          Inc(pd);
        end else if c<=$7FF then begin//$80-$7FF,2B
          pd^:=AnsiChar($C0 or (c shr 6));
          Inc(pd);
          pd^:=AnsiChar($80 or (c and $3F));
          Inc(pd);
        end else if c<=$FFFF then begin //$8000 - $FFFF,3B
          pd^:=AnsiChar($E0 or (c shr 12));
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 6) and $3F));
          Inc(pd);
          pd^:=AnsiChar($80 or (c and $3F));
          Inc(pd);
        end else if c<=$1FFFFF then begin //$01 0000-$1F FFFF,4B
          pd^:=AnsiChar($F0 or (c shr 18));//1111 0xxx
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 12) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 6) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or (c and $3F));//10 xxxxxx
          Inc(pd);
        end else if c<=$3FFFFFF then begin//$20 0000 - $3FF FFFF,5B
          pd^:=AnsiChar($F8 or (c shr 24));//1111 10xx
          Inc(pd);
          pd^:=AnsiChar($F0 or ((c shr 18) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 12) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 6) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or (c and $3F));//10 xxxxxx
          Inc(pd);
        end else if c<=$7FFFFFFF then begin //$0400 0000-$7FFF FFFF,6B
          pd^:=AnsiChar($FC or (c shr 30));//1111 11xx
          Inc(pd);
          pd^:=AnsiChar($F8 or ((c shr 24) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($F0 or ((c shr 18) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 12) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or ((c shr 6) and $3F));//10 xxxxxx
          Inc(pd);
          pd^:=AnsiChar($80 or (c and $3F));//10 xxxxxx
          Inc(pd);
        end;
      end;
      pd^:=#0;
      SetLength(Result, IntPtr(pd)-IntPtr(pds));
    end;
  end;
end;

function Utf8Decode(p: PAnsiChar; l: Integer): WideString;
var
  ps,pe: PByte;
  pd,pds: PWord;
  c: Cardinal;
begin
  if l<=0 then begin
    ps:=PByte(p);
    while ps^<>0 do Inc(ps);
    l := Integer(ps) - Integer(p);
  end;
  ps := PByte(p);
  pe := ps;
  Inc(pe, l);
  System.SetLength(Result, l);
  pd := PWord(PWideChar(Result));
  pds := pd;
  while Integer(ps)<Integer(pe) do begin
    if (ps^ and $80)<>0 then begin
      if (ps^ and $FC)=$FC then begin //4000000+
        c:=(ps^ and $03) shl 30;
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 24);
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 18);
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 12);
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 6);
        Inc(ps);
        c:=c or (ps^ and $3F);
        Inc(ps);
        c:=c-$10000;
        pd^:=$D800+((c shr 10) and $3FF);
        Inc(pd);
        pd^:=$DC00+(c and $3FF);
        Inc(pd);
      end else if (ps^ and $F8)=$F8 then begin //200000-3FFFFFF
        c:=(ps^ and $07) shl 24;
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 18);
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 12);
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 6);
        Inc(ps);
        c:=c or (ps^ and $3F);
        Inc(ps);
        c:=c-$10000;
        pd^:=$D800+((c shr 10) and $3FF);
        Inc(pd);
        pd^:=$DC00+(c and $3FF);
        Inc(pd);
      end else if (ps^ and $F0)=$F0 then begin //10000-1FFFFF
        c:=(ps^ and $0F) shr 18;
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 12);
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 6);
        Inc(ps);
        c:=c or (ps^ and $3F);
        Inc(ps);
        c:=c-$10000;
        pd^:=$D800+((c shr 10) and $3FF);
        Inc(pd);
        pd^:=$DC00+(c and $3FF);
        Inc(pd);
      end else if (ps^ and $E0)=$E0 then begin //800-FFFF
        c:=(ps^ and $1F) shl 12;
        Inc(ps);
        c:=c or ((ps^ and $3F) shl 6);
        Inc(ps);
        c:=c or (ps^ and $3F);
        Inc(ps);
        pd^:=c;
        Inc(pd);
      end else if (ps^ and $C0)=$C0 then begin //80-7FF
        pd^:=(ps^ and $3F) shl 6;
        Inc(ps);
        pd^:=pd^ or (ps^ and $3F);
        Inc(pd);
        Inc(ps);
      end else
        raise Exception.Create(Format('��Ч��UTF8�ַ�:%d',[Integer(ps^)]));
    end else begin
      pd^ := ps^;
      Inc(ps);
      Inc(pd);
    end;
  end;
  System.SetLength(Result, (Integer(pd)-Integer(pds)) shr 1);
end;

procedure SaveTextU(AStream: TStream; const S: AnsiString; AWriteBom: Boolean);

  procedure WriteBom;
  var
    ABom:TBytes;
  begin
    SetLength(ABom,3);
    ABom[0]:=$EF;
    ABom[1]:=$BB;
    ABom[2]:=$BF;
    AStream.WriteBuffer(ABom[0],3);
  end;

  procedure SaveAnsi;
  var
    T: AnsiString;
  begin
    T := Utf8Encode(S);
    AStream.WriteBuffer(PAnsiChar(T)^, Length(T));
  end;

begin
  if AWriteBom then
    WriteBom;
  SaveAnsi;
end;

procedure SaveTextW(AStream: TStream; const S: WideString; AWriteBom: Boolean);
  procedure WriteBom;
  var
    bom: Word;
  begin
    bom := $FEFF;
    AStream.WriteBuffer(bom, 2);
  end;
begin
  if AWriteBom then
    WriteBom;
  AStream.WriteBuffer(PWideChar(S)^, System.Length(S) shl 1);
end;

procedure SaveTextWBE(AStream: TStream; const S: WideString; AWriteBom: Boolean);
var
  pw, pe: PWord;
  w: Word;
  ABuilder: JSONStringCatHelper;
begin
  pw := PWord(PWideChar(S));
  pe := pw;
  Inc(pe, Length(S));
  ABuilder := JSONStringCatHelper.Create(IntPtr(pe)-IntPtr(pw));
  try
    while IntPtr(pw)<IntPtr(pe) do begin
      w := (pw^ shr 8) or (pw^ shl 8);
      ABuilder.Cat(@w, 1);
      Inc(pw);
    end;
    if AWriteBom then
      AStream.WriteBuffer(#$FE#$FF, 2);
    AStream.WriteBuffer(ABuilder.FStart^, Length(S) shl 1);
  finally
    ABuilder.Free;
  end;
end;

function DetectTextEncoding(const p: Pointer; L: Integer; var b: Boolean): TTextEncoding;
var
  pAnsi: PByte;
  pWide: PWideChar;
  I, AUtf8CharSize: Integer;

  function IsUtf8Order(var ACharSize:Integer):Boolean;
  var
    I: Integer;
    ps: PByte;
  const
    Utf8Masks:array [0..4] of Byte=($C0,$E0,$F0,$F8,$FC);
  begin
    ps := pAnsi;
    ACharSize := CharSizeU(PAnsiChar(ps));
    Result := False;
    if ACharSize>1 then begin
      I := ACharSize-2;
      if ((Utf8Masks[I] and ps^) = Utf8Masks[I]) then begin
        Inc(ps);
        Result:=True;
        for I := 1 to ACharSize-1 do begin
          if (ps^ and $80)<>$80 then begin
            Result:=False;
            Break;
          end;
          Inc(ps);
        end;
      end;
    end;
  end;
  
begin
  Result := teAnsi;
  b := false;
  if L >= 2 then begin
    pAnsi := PByte(p);
    pWide := PWideChar(p);
    b := True;
    if pWide^ = #$FEFF then
      Result := teUnicode16LE
    else if pWide^ = #$FFFE then
      Result := teUnicode16BE
    else if L >= 3 then begin
      if (pAnsi^ = $EF) and (PByte(IntPtr(pAnsi) + 1)^ = $BB) and
        (PByte(IntPtr(pAnsi) + 2)^ = $BF) then // UTF-8����
        Result := teUTF8
      else begin// ����ַ����Ƿ��з���UFT-8���������ַ���11...
        b := false;
        Result := teUTF8;//�����ļ�ΪUTF8���룬Ȼ�����Ƿ��в�����UTF-8���������
        I := 0;
        Dec(L, 2);
        while I<=L do begin
          if (pAnsi^ and $80) <> 0 then begin // ��λΪ1
            if IsUtf8Order(AUtf8CharSize) then begin
              if AUtf8CharSize>2 then//���ִ���2���ֽڳ��ȵ�UTF8���У�99%����UTF-8�ˣ������ж�
                Break;
              Inc(pAnsi,AUtf8CharSize);
              Inc(I,AUtf8CharSize);
            end else begin
              Result:=teAnsi;
              Break;
            end;
          end else begin
            if pAnsi^=0 then begin //00 xx (xx<128) ��λ��ǰ����BE����
              if PByte(IntPtr(pAnsi)+1)^<128 then begin
                Result := teUnicode16BE;
                Break;
              end;
            end else if PByte(IntPtr(pAnsi)+1)^=0 then begin//xx 00 ��λ��ǰ����LE����
              Result:=teUnicode16LE;
              Break;
            end;
            Inc(pAnsi);    
            Inc(I);
          end;
        end;
      end;
    end;
  end;
end;

procedure ExchangeByteOrder(p:PAnsiChar; l:Integer);
var
  pe: PAnsiChar;
  c: AnsiChar;
begin
  pe := p;
  Inc(pe,l);
  while IntPtr(p)<IntPtr(pe) do begin
    c := p^;
    p^ := PAnsiChar(IntPtr(p)+1)^;
    PAnsiChar(IntPtr(p)+1)^ :=c ;
    Inc(p, 2);
  end;
end;

function LoadTextA(AStream: TStream; AEncoding: TTextEncoding): AnsiString;
var
  ASize: Integer;
  ABuffer: TBytes;
  ABomExists: Boolean;
begin
  ASize := AStream.Size - AStream.Position;
  if ASize > 0 then begin
    SetLength(ABuffer, ASize);
    AStream.ReadBuffer((@ABuffer[0])^, ASize);
    if AEncoding in [teUnknown,teAuto] then
      AEncoding := DetectTextEncoding(@ABuffer[0], ASize, ABomExists);
    if AEncoding=teAnsi then
      Result := AnsiString(ABuffer)
    else if AEncoding = teUTF8 then begin
      if ABomExists then
        Result := AnsiEncode(Utf8Decode(@ABuffer[3], ASize-3))
      else
        Result := AnsiEncode(Utf8Decode(@ABuffer[0], ASize));
      end
    else begin
      if AEncoding = teUnicode16BE then
        ExchangeByteOrder(@ABuffer[0],ASize);
      if ABomExists then
        Result := AnsiEncode(PWideChar(@ABuffer[2]), (ASize-2) shr 1)
      else
        Result := AnsiEncode(PWideChar(@ABuffer[0]), ASize shr 1);
    end;
  end else
    Result := '';
end;

function LoadTextU(AStream: TStream; AEncoding: TTextEncoding): AnsiString;
var
  ASize: Integer;
  ABuffer: TBytes;
  ABomExists: Boolean;
  P: PAnsiChar;
begin
  ASize := AStream.Size - AStream.Position;
  if ASize>0 then begin
    SetLength(ABuffer, ASize);
    AStream.ReadBuffer((@ABuffer[0])^, ASize);
    if AEncoding in [teUnknown, teAuto] then
      AEncoding:=DetectTextEncoding(@ABuffer[0],ASize,ABomExists)
    else if ASize>=2 then begin
      case AEncoding of
        teUnicode16LE:
          ABomExists:=(ABuffer[0]=$FF) and (ABuffer[1]=$FE);
        teUnicode16BE:
          ABomExists:=(ABuffer[1]=$FE) and (ABuffer[1]=$FF);
        teUTF8:
          begin
            if ASize>3 then
              ABomExists:=(ABuffer[0]=$EF) and (ABuffer[1]=$BB) and (ABuffer[2]=$BF)
            else
              ABomExists:=False;
          end;
      end;
    end else
      ABomExists:=False;
    if AEncoding=teAnsi then
      Result := YxdJson.Utf8Encode(AnsiDecode(@ABuffer[0], ASize))
    else if AEncoding = teUTF8 then begin
      if ABomExists then begin
        Dec(ASize, 3);
        SetLength(Result, ASize);
        P := @ABuffer[0];
        Inc(P, 3);
        Move(P^, PAnsiChar(@Result[1])^, ASize);
      end else
        Result := AnsiString(ABuffer);
    end else begin
      if AEncoding=teUnicode16BE then
        ExchangeByteOrder(@ABuffer[0],ASize);
      if ABomExists then
        Result := Utf8Encode(PWideChar(@ABuffer[2]), (ASize-2) shr 1)
      else
        Result := Utf8Encode(PWideChar(@ABuffer[0]), ASize shr 1);
      end;
    end
  else
    Result := '';
end;

function LoadTextW(AStream: TStream; AEncoding: TTextEncoding): WideString;
var
  ASize: Integer;
  ABuffer: TBytes;
  ABomExists: Boolean;
begin
  ASize := AStream.Size - AStream.Position;
  if ASize>0 then begin
    SetLength(ABuffer, ASize);
    AStream.ReadBuffer((@ABuffer[0])^, ASize);
    if (AEncoding = teUnknown) or (AEncoding = teAuto) then
      AEncoding := DetectTextEncoding(@ABuffer[0], ASize, ABomExists)
    else if ASize>=2 then begin
      case AEncoding of
        teUnicode16LE:
          ABomExists:=(ABuffer[0]=$FF) and (ABuffer[1]=$FE);
        teUnicode16BE:
          ABomExists:=(ABuffer[1]=$FE) and (ABuffer[1]=$FF);
        teUTF8:
          begin
            if ASize>3 then
              ABomExists := (ABuffer[0]=$EF) and (ABuffer[1]=$BB) and (ABuffer[2]=$BF)
            else
              ABomExists := False;
          end;
      end;
    end else
      ABomExists:=False;
    if AEncoding=teAnsi then
      Result := AnsiDecode(@ABuffer[0], ASize)
    else if AEncoding=teUTF8 then begin
      if ABomExists then
        Result:=Utf8Decode(@ABuffer[3], ASize-3)
      else
        Result:=Utf8Decode(@ABuffer[0], ASize);
    end else begin
      if AEncoding=teUnicode16BE then
        ExchangeByteOrder(@ABuffer[0], ASize);
      if ABomExists then begin
        Dec(ASize, 2);
        SetLength(Result, ASize shr 1);
        Move(ABuffer[2], PWideChar(Result)^, ASize);
      end else begin
        SetLength(Result,ASize shr 1);
        Move(ABuffer[0], PWideChar(Result)^, ASize);
      end;
    end;
  end else
    Result := '';
end;

{ JSONValue }

procedure JSONValue.Free;
begin
  if (FType = jdtObject) and (FObject <> nil) then
    FObject.Free;
end;

function JSONValue.GetAsBoolean: Boolean;
begin
  if High(FValue) > -1 then
    Result := PBoolean(@FValue[0])^
  else Result := False;
end;

function JSONValue.GetAsByte: Byte;
begin
  Result := GetAsDWORD();
end;

function JSONValue.GetAsDateTime: TDateTime;
begin
  if (FType = jdtFloat) or (FType = jdtDateTime) then
    Result := GetAsFloat
  else if FType = jdtString then begin
    if not(ParseDateTime(PJSONChar(FValue), Result) or
      ParseJsonTime(PJSONChar(FValue), Result) or ParseWebTime(PJSONChar(FValue), Result)) then
      raise Exception.Create(Format(SBadConvert, ['String', 'DateTime']))
  end else if FType = jdtInteger then
    Result := AsInt64
  else
    raise Exception.Create(Format(SBadConvert, [JsonTypeName[Integer(FType)], 'DateTime']));
end;

function JSONValue.GetAsDouble: Double;
begin
  Result := GetAsFloat;
end;

function JSONValue.GetAsDWORD: Cardinal;
begin
  case High(FValue) of
    3: Result := PCardinal(@FValue[0])^;
    0: Result := PByte(@FValue[0])^;
    1: Result := PWord(@FValue[0])^;
    7: Result := PInt64(@FValue[0])^;
  else
    Result := 0;
  end;
end;

function JSONValue.GetAsFloat: Extended;
begin
  if Length(FValue) = 8 then
    Result := PDouble(@FValue[0])^
  else if Length(FValue) >= SizeOf(Extended) then
    Result := PExtended(@FValue[0])^
  else
    Result := 0;
end;

function JSONValue.GetAsInt64: Int64;
begin
  case High(FValue) of
    3: Result := PInteger(@FValue[0])^;
    7: Result := PInt64(@FValue[0])^;
    0: Result := PShortInt(@FValue[0])^;
    1: Result := PSmallInt(@FValue[0])^;
  else
    Result := 0;
  end;
end;

function JSONValue.GetAsInteger: Integer;
begin
  Result := GetAsInt64;
end;

function JSONValue.GetAsJSONArray: JSONArray;
begin
  if FObject.GetIsArray then
    Result := JSONArray(FObject)
  else
    Result := nil;
end;

function JSONValue.GetAsJSONObject: JSONObject;
begin
  if not FObject.GetIsArray then
    Result := JSONObject(FObject)
  else
    Result := nil;
end;

function JSONValue.GetAsString: JSONString;
begin
  Result := ToString();
end;

function JSONValue.GetAsVariant: Variant;
begin
  case FType of
    jdtString: Result := AsString;
    jdtInteger: Result := AsInt64;
    jdtFloat: Result := AsFloat;
    jdtBoolean: Result := AsBoolean;
    jdtDateTime: Result := AsFloat;
  else
    Result := varEmpty;
  end;
end;

function JSONValue.GetAsWord: Word;
begin
  Result := GetAsDWORD;
end;

function JSONValue.GetSize: Cardinal;
begin
  Result := Length(FValue);
end;

procedure JSONValue.SetAsBoolean(const Value: Boolean);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PBoolean(@FValue[0])^ := Value;
  FType := jdtBoolean;
end;

procedure JSONValue.SetAsByte(const Value: Byte);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  FValue[0] := Value;
  FType := jdtInteger;
end;

procedure JSONValue.SetAsDateTime(const Value: TDateTime);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PDouble(@FValue[0])^ := Value;
  FType := jdtDateTime;
end;

procedure JSONValue.SetAsDouble(const Value: Double);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PDouble(@FValue[0])^ := Value;
  FType := jdtFloat;
end;

procedure JSONValue.SetAsDWORD(const Value: Cardinal);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PCardinal(@FValue[0])^ := Value;
  FType := jdtInteger;
end;

procedure JSONValue.SetAsFloat(const Value: Extended);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PExtended(@FValue[0])^ := Value;
  FType := jdtFloat;
end;

procedure JSONValue.SetAsInt64(const Value: Int64);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PInt64(@FValue[0])^ := Value;
  FType := jdtInteger;
end;

procedure JSONValue.SetAsInteger(const Value: Integer);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PInteger(@FValue[0])^ := Value;
  FType := jdtInteger;
end;

procedure JSONValue.SetAsJSONArray(const Value: JSONArray);
begin
  if Length(FValue) <> 0 then SetLength(FValue, 0);
  FObject := Value;
  FType := jdtObject;
end;

procedure JSONValue.SetAsJSONObject(const Value: JSONObject);
begin
  if Length(FValue) <> 0 then SetLength(FValue, 0);
  FObject := Value;
  FType := jdtObject;
end;

procedure JSONValue.SetAsString(const Value: JSONString);
begin
  if Length(Value) > 0 then begin
    {$IFDEF JSON_UNICODE}
    SetLength(FValue, (Length(Value) shl 1));
    Move(PJSONChar(Value)^, FValue[0], Length(Value) shl 1);
    {$ELSE}
    SetLength(FValue, (Length(Value) + 1));
    Move(Value[1], FValue[0], Length(Value));
    {$ENDIF}
  end else
    SetLength(FValue, 0);
  FType := jdtString;
end;

procedure JSONValue.SetAsVariant(const Value: Variant);
begin
  case FindVarData(Value)^.VType of
    varBoolean: SetAsBoolean(Value);
    varByte: SetAsByte(Value);
    varWord: SetAsWord(Value);
    varSmallint: SetAsInteger(Value);
    varInteger,
    varShortInt: SetAsInteger(Value);
    varLongWord: SetAsDWORD(Value);
    varInt64: SetAsInt64(Value);
    varSingle: SetAsDouble(Value);
    varDouble: SetAsDouble(Value);
    varDate: SetAsDateTime(Value);
    varCurrency: SetAsFloat(Value);
    varOleStr, varString: SetAsString(VarToStrDef(Value, ''));
    else begin
      SetLength(FValue, 0);
      FType := jdtNull;
    end;
  end;
end;

procedure JSONValue.SetAsWord(const Value: Word);
begin
  if Length(FValue) <> SizeOf(Value) then SetLength(FValue, SizeOf(Value));
  PWord(@FValue[0])^ := Value;
  FType := jdtInteger;
end;

function JSONValue.ToString: JSONString;
begin
  case FType of
    jdtString:
      {$IFDEF JSON_UNICODE}
      begin
        Result := JSONString(FValue);
        SetLength(Result, System.Length(FValue) shr 1);
      end;
      {$ELSE}
      Result := JSONString(FValue);
      {$ENDIF}
    jdtInteger:
      Result := IntToStr(AsInteger);
    jdtFloat:
      Result := FloatToStr(AsFloat);
    jdtBoolean:
      Result := BoolToStr(AsBoolean);
    jdtObject:
      Result := JSONBase.Encode(FObject);
    jdtDateTime:
      Result := ValueAsDateTime(JsonDateFormat, JsonTimeFormat, JsonDateTimeFormat);
    jdtNull, jdtUnknown:
      Result := 'null';
  end;
end;

function JSONValue.ValueAsDateTime(const DateFormat, TimeFormat,
  DateTimeFormat: JSONString): JSONString;
var
  ADate: Integer;
  AValue: Double;
begin
  AValue := AsDateTime;
  ADate := Trunc(AValue);
  if SameValue(ADate, 0) then begin //DateΪ0����ʱ��
    if SameValue(AValue, 0) then
      Result := FormatDateTime(DateFormat, AValue)
    else
      Result := FormatDateTime(TimeFormat, AValue);
  end else begin
    if SameValue(AValue-ADate, 0) then
      Result := FormatDateTime(DateFormat, AValue)
    else
      Result := FormatDateTime(DateTimeFormat, AValue);
  end;
end;

{ JSONBase }

procedure JSONBase.Assign(ANode: JSONBase);
begin
  Self.parse(ANode.toString());
end;

procedure JSONBase.BuildJsonString(ABuilder: JSONStringCatHelper; var p: PJSONChar);
var
  AQuoter: JSONChar;
  ps: PJSONChar;
begin
  ABuilder.Position := 0;
  if (p^='"') or (p^='''') then begin
    AQuoter := p^;
    Inc(p);
    ps := p;
    while p^<>#0 do begin
      if (p^ = AQuoter) then begin
        if ps <> p then
          ABuilder.Cat(ps,p-ps);
        if p[1] = AQuoter then begin
          ABuilder.Cat(AQuoter);
          Inc(p, 2);
          ps := p;
        end else begin
          Inc(p);
          {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
          ps := p;
          Break;
        end;
      end else if p^='\' then begin
        if ps<>p then
          ABuilder.Cat(ps, p-ps);
        {$IFDEF JSON_UNICODE}
        ABuilder.Cat(CharUnescape(p));
        {$ELSE}
        CharUnescape(ABuilder, p);
        {$ENDIF}
        ps := p;
      end else
        Inc(p);
    end;
    if ps <> p then
      ABuilder.Cat(ps, p-ps);
  end else begin
    while p^<>#0 do begin
      if (p^=':') or (p^=']') or (p^=',') or (p^='}') then
        Break
      else
        ABuilder.Cat(p,1);
      Inc(p);
    end
  end;
end;

{$IFDEF JSON_UNICODE}
function JSONBase.CharUnescape(var p: PJSONChar): JSONChar;
{$ELSE}
procedure JSONBase.CharUnescape(ABuilder: JSONStringCatHelper; var p: PJSONChar);
{$ENDIF}

  function DecodeOrd: Integer;
  var
    C:Integer;
  begin
    Result := 0;
    C := 0;
    while (p^<>#0) and (C<4) do begin
      if IsHexChar(p^) then
        Result := (Result shl 4) + HexValue(p^)
      else
        Break;
      Inc(p);
      Inc(C);
    end
  end;
  
begin
  if p^=#0 then begin
    {$IFDEF JSON_UNICODE} Result := #0; {$ENDIF}
    Exit;
  end;  
  if p^ <> '\' then begin
    {$IFDEF JSON_UNICODE}Result := p^;{$ELSE}ABuilder.Cat(p^);{$ENDIF}
    Inc(p);
    Exit;
  end;
  Inc(p);
  case p^ of
    'b':
      begin
        {$IFDEF JSON_UNICODE}Result := #7;{$ELSE}ABuilder.Cat(#7);{$ENDIF}
        Inc(p);
      end;
    't':
      begin
        {$IFDEF JSON_UNICODE}Result := #9;{$ELSE}ABuilder.Cat(#9);{$ENDIF}
        Inc(p);
      end;
    'n':
      begin
        {$IFDEF JSON_UNICODE}Result := #10;{$ELSE}ABuilder.Cat(#10);{$ENDIF}
        Inc(p);
      end;
    'f':
      begin
        {$IFDEF JSON_UNICODE}Result := #12;{$ELSE}ABuilder.Cat(#12);{$ENDIF}
        Inc(p);
      end;
    'r':
      begin
        {$IFDEF JSON_UNICODE}Result := #13;{$ELSE}ABuilder.Cat(#13);{$ENDIF}
        Inc(p);
      end;
    '\':
      begin
        {$IFDEF JSON_UNICODE}Result := '\';{$ELSE}ABuilder.Cat('\');{$ENDIF}
        Inc(p);
      end;
    '''':
      begin
        {$IFDEF JSON_UNICODE}Result := '''';{$ELSE}ABuilder.Cat('''');{$ENDIF}
        Inc(p);
      end;
    '"':
      begin
        {$IFDEF JSON_UNICODE}Result := '"';{$ELSE}ABuilder.Cat('"');{$ENDIF}
        Inc(p);
      end;
    'u':
      begin
        //\uXXXX
        if IsHexChar(p[1]) and IsHexChar(p[2]) and IsHexChar(p[3]) and IsHexChar(p[4]) then begin
          {$IFDEF JSON_UNICODE}
          Result := WideChar((HexValue(p[1]) shl 12) or (HexValue(p[2]) shl 8) or
            (HexValue(p[3]) shl 4) or HexValue(p[4]));
          {$ELSE}
          ABuilder.Cat(JSONString(WideChar((HexValue(p[1]) shl 12) or (HexValue(p[2]) shl 8) or
            (HexValue(p[3]) shl 4) or HexValue(p[4]))));
          {$ENDIF}
        end else
          raise Exception.CreateFmt(SCharNeeded, ['0-9A-Fa-f', StrDup(p,0,4)]);
      end;
    '/':
      begin
        {$IFDEF JSON_UNICODE}Result := '/';{$ELSE}ABuilder.Cat('/');{$ENDIF}
        Inc(p);
      end
    else begin
      if StrictJson then
        raise Exception.CreateFmt(SCharNeeded, ['btfrn"u''/', StrDup(p,0,4)])
      else begin
        {$IFDEF JSON_UNICODE}Result := p^;{$ELSE}ABuilder.Cat(p^);{$ENDIF}
        Inc(p);
      end;
    end;
  end;
end;

procedure JSONBase.Clear;
var
  I: Integer;
  Item: PJSONValue;
begin
  if FItems.Count > 0 then begin
    for I := 0 to FItems.Count - 1 do begin
      Item := FItems.Items[i];
      if (Item <> nil) then begin
        Item.Free;
        Dispose(Item);
      end;
    end;
    FItems.Clear;
  end;
end;

constructor JSONBase.Create;
begin
  FData := nil;
  FParent := nil;
  FValue := nil;
  FItems := TList.Create;
  inherited Create;
end;

procedure JSONBase.Decode(p: PJSONChar; len: Integer);
  procedure DecodeCopy;
  var
    S: JSONString;
  begin
    S := StrDup(p, 0, len);
    p := PJSONChar(S);
    DecodeObject(p);
  end;
begin
  Clear;
  if (len>0) and (p[len] <> #0) then
    DecodeCopy
  else
    DecodeObject(p);
end;

procedure JSONBase.Decode(const s: JSONString);
begin
  Decode(PJSONChar(S), Length(S));
end;

procedure JSONBase.DecodeObject(var p: PJSONChar);
var
  ABuilder: JSONStringCatHelper;
  ps: PJSONChar;
  ErrCode: Integer;
begin
  {$IFDEF FUNCTIONDEBUG}
  ParseRef := 0;
  WhileRef := 0;
  {$ENDIF}
  ABuilder := JSONStringCatHelper.Create;
  ps := p;
  try
    try
      {$IFDEF JSON_UNICODE}SkipSpaceW(p);{$ELSE}SkipSpaceA(p);{$ENDIF}
      ErrCode := ParseJsonPair(ABuilder, p);
      {$IFDEF FUNCTIONDEBUG}
      OutputDebugString(PChar(Format('ParseRef %d.', [ParseRef])));
      OutputDebugString(PChar(Format('WhileRef %d.', [WhileRef])));
      {$ENDIF}
      if ErrCode <> 0 then
        RaiseParseException(ErrCode, ps, p);
    finally
      ABuilder.Free;
    end;
  except on E:Exception do
    raise Exception.Create(FormatParseError(EParse_Unknown, E.Message, ps, p));
  end;
end;

destructor JSONBase.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

class function JSONBase.Encode(Obj: JSONBase; AIndent: Integer): JSONString;
var
  ABuilder: JSONStringCatHelper;
begin
  if Obj = nil then Exit;  
  ABuilder := JSONStringCatHelper.Create;
  try
    InternalEncode(Obj, ABuilder, AIndent);
    ABuilder.Back(1); //ɾ�����һ������
    Result := ABuilder.Value;
  finally
    ABuilder.Free;
  end;
end;

function JSONBase.FormatParseError(ACode: Integer; AMsg: JSONString; ps,
  p: PJSONChar): JSONString;
var
  ACol, ARow: Integer;
  ALine: JSONString;
begin
  if ACode<>0 then begin
    p := {$IFDEF JSON_UNICODE}StrPosW{$ELSE}StrPosA{$ENDIF}(ps, p, ACol, ARow);
    ALine := {$IFDEF JSON_UNICODE}DecodeLineW{$ELSE}DecodeLineA{$ENDIF}(p, False);
    Result:=Format(SJsonParseError,[ARow, ACol, AMsg, ALine]);
  end else
    Result := '';
end;

function JSONBase.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function JSONBase.GetIsArray: Boolean;
begin
  Result := False;
end;

function JSONBase.GetItemIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if Assigned(Parent) then begin
    for I := 0 to Parent.GetCount - 1 do begin
      if Parent.GetItems(i).FObject = Self then begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

function JSONBase.GetItems(Index: Integer): PJSONValue;
begin
  Result := FItems.Items[index];
end;

function JSONBase.GetName: JSONString;
begin
  if FValue = nil then
    Result := ''
  else
    Result := FValue.FName;
end;

function JSONBase.GetPath: JSONString;
var
  AParent: JSONBase;
begin
  Result := '';
  AParent := Self;
  while Assigned(AParent) do begin
    if AParent.FParent <> nil then
      Result := '\' + AParent.FValue.FName + Result
    else
      Break;
    AParent := AParent.FParent;
  end;
end;

function JSONBase.GetValue: JSONString;
begin
  Result := Encode(Self);
end;

function JSONBase.IndexOf(const Key: JSONString): Integer;
var
  I, l: Integer;
  Item: PJSONValue;
  AHash: Cardinal;
begin
  Result := -1;
  l := Length(Key);
  if l > 0 then
    AHash := HashOf(PJSONChar(Key), l{$IFDEF JSON_UNICODE} shl 1{$ENDIF})
  else
    AHash := 0;
  for I := 0 to FItems.Count - 1 do begin
    Item := GetItems(i);
    if Length(Item.FName) = l then begin
      if JsonCaseSensitive then begin
        if Item.FNameHash = 0 then
          Item.FNameHash := HashOf(PJSONChar(Item.FName), l{$IFDEF JSON_UNICODE} shl 1{$ENDIF});
        if (Item.FNameHash = AHash) and (Item.FName = Key) then begin
          Result := I;
          Break;
        end;
      end else if StartWith(PJSONChar(Item.FName), PJSONChar(Key), True) then begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

class function JSONBase.InternalEncode(Obj: JSONBase; ABuilder: JSONStringCatHelper;
  AIndent: Integer): JSONStringCatHelper;
const
  CharStringStart:  PJSONChar = '"';
  CharStringEnd:    PJSONChar = '",';
  CharNameEnd:      PJSONChar = '":';
  CharArrayStart:   PJSONChar = '[';
  CharArrayEnd:     PJSONChar = '],';
  CharObjectStart:  PJSONChar = '{';
  CharObjectEnd:    PJSONChar = '},';
  CharNull:         PJSONChar = 'null,';
  CharFalse:        PJSONChar = 'false,';
  CharTrue:         PJSONChar = 'true,';
  CharComma:        PJSONChar = ',';
  CharNum0:         PJSONChar = '0';
  CharNum1:         PJSONChar = '1';
  Char7:            PJSONChar = '\b';
  Char9:            PJSONChar = '\t';
  Char10:           PJSONChar = '\n';
  Char12:           PJSONChar = '\f';
  Char13:           PJSONChar = '\r';
  CharQuoter:       PJSONChar = '\"';
  CharBackslash:    PJSONChar = '\\';
  CharCode:         PJSONChar = '\u00';

  procedure CatValue(const AValue: JSONString);
  var
    ps: PJSONChar;
  begin
    ps := PJSONChar(AValue);
    while ps^ <> #0 do begin
      case ps^ of
        #7:   ABuilder.Cat(Char7, 2);
        #9:   ABuilder.Cat(Char9, 2);
        #10:  ABuilder.Cat(Char10, 2);
        #12:  ABuilder.Cat(Char12, 2);
        #13:  ABuilder.Cat(Char13, 2);
        '\':  ABuilder.Cat(CharBackslash, 2);
        '"':  ABuilder.Cat(CharQuoter, 2);
        else begin
          if ps^ < #$1F then begin
            ABuilder.Cat(CharCode, 4);
            if ps^ > #$F then
              ABuilder.Cat(CharNum1, 1)
            else
              ABuilder.Cat(CharNum0, 1);
            ABuilder.Cat(HexChar(Ord(ps^) and $0F));
          end else
            ABuilder.Cat(ps, 1);
        end;
      end;
      Inc(ps);
    end;
  end;

  procedure StrictJsonTime(ATime:TDateTime);
  const
    JsonTimeStart: PJSONChar = '"/DATE(';
    JsonTimeEnd:   PJSONChar = ')/"';
  var
    MS: Int64;//ʱ����Ϣ������
  begin
    MS := Trunc(ATime * 86400000);
    ABuilder.Cat(JsonTimeStart, 7);
    ABuilder.Cat(IntToStr(MS));
    ABuilder.Cat(JsonTimeEnd, 3);
  end;

  procedure DoEncode(ANode: JSONBase; ALevel:Integer);
  var
    I: Integer;
    Item: PJSONValue;
    ArrayWraped, IsArray: Boolean;
  begin
    ArrayWraped := False;
    if ANode.GetIsArray then begin
      IsArray := True;
      ABuilder.Cat(CharArrayStart, 1);
    end else begin
      IsArray := False;
      ABuilder.Cat(CharObjectStart, 1);
    end;

    if ANode.FItems.Count > 0 then begin
      for I := 0 to ANode.FItems.Count - 1 do begin
        Item := ANode.FItems[I];
        if Item = nil then Continue;
        if AIndent > 0 then begin
          ABuilder.Cat(SLineBreak);
          ABuilder.Space(AIndent * (ALevel + 1));
        end;
        if Length(item.FName) > 0 then begin
          ABuilder.Cat(CharStringStart, 1);
          CatValue(item.FName);
          ABuilder.Cat(CharNameEnd, 2);
        end;
        case Item.FType of
          jdtObject:
            begin
              if Item.FObject <> nil then begin
                if Item.FObject.GetIsArray then begin
                  if AIndent > 0 then
                    ArrayWraped := True;
                end else begin
                  if (not IsArray) and (Length(Item.FName) = 0) then
                    raise Exception.CreateFmt(SObjectChildNeedName, [Item.FName, I]);
                end;
                DoEncode(Item.FObject, ALevel+1);
              end;
            end;
          jdtString:
            begin
              ABuilder.Cat(CharStringStart, 1);
              CatValue(Item.AsString);
              ABuilder.Cat(CharStringEnd, 2);
            end;
          jdtInteger:
            begin
              ABuilder.Cat(IntToStr(Item.AsInt64));
              ABuilder.Cat(CharComma, 1);
            end;
          jdtFloat:
            begin
              ABuilder.Cat(FloatToStr(Item.AsFloat));
              ABuilder.Cat(CharComma, 1);
            end;
          jdtBoolean:
            begin
              ABuilder.Cat(BoolToStr(Item.AsBoolean));
              ABuilder.Cat(CharComma, 1);
            end;
          jdtDateTime:
            begin
              ABuilder.Cat(CharStringStart, 1);
              if StrictJson then
                StrictJsonTime(Item.AsDateTime)
              else
                ABuilder.Cat(FormatDateTime(JsonDefaultDateTimeFormat, Item.AsDateTime));
              ABuilder.Cat(CharStringEnd, 1);
              ABuilder.Cat(CharComma, 1);
            end;
          jdtNull, jdtUnknown:
            ABuilder.Cat(CharNull, 5);
        end;
      end;
      ABuilder.Back(1);
    end;

    if IsArray then begin
      if ArrayWraped then begin
        ABuilder.Cat(SLineBreak);
        ABuilder.Space(AIndent * ALevel);
      end;
      ABuilder.Cat(CharArrayEnd, 2);
    end else begin
      if AIndent > 0 then begin
        ABuilder.Cat(SLineBreak);
        ABuilder.Space(AIndent * ALevel);
      end;
      ABuilder.Cat(CharObjectEnd, 2);
    end;
  end;
begin
  Result := ABuilder;
  DoEncode(Obj, 0);
end;

procedure JSONBase.LoadFromFile(const AFileName: JSONString;
  AEncoding: TTextEncoding);
var
  AStream: TFileStream;
begin
  AStream:=TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

procedure JSONBase.LoadFromStream(AStream: TStream; AEncoding: TTextEncoding);
var
  S: JSONString;
begin
  S := {$IFDEF JSON_UNICODE}LoadTextW{$ELSE}LoadTextA{$ENDIF}(AStream, AEncoding);
  if Length(S) > 2 then
    Decode(PJSONChar(S), Length(S))
  else
    raise Exception.Create(SBadJson);
end;

function JSONBase.NewChildArray(const key: JSONString): JSONArray;
var
  Item: PJSONValue;
begin
  Result := JSONArray.Create;
  Result.FParent := Self;
  New(Item);
  Item.FName := key;
  Item.FNameHash := 0;
  Item.FObject := Result;
  Item.FType := jdtObject;
  FItems.Add(Item);
  Result.FValue := Item;
end;

function JSONBase.NewChildObject(const key: JSONString): JSONObject;
var
  Item: PJSONValue;
begin
  Result := JSONObject.Create;
  Result.FParent := Self;
  New(Item);
  Item.FName := key;
  Item.FNameHash := 0;
  Item.FObject := Result;
  Item.FType := jdtObject;
  FItems.Add(Item);
  Result.FValue := Item;
end;
     
function JSONBase.ParseValue(ABuilder: JSONStringCatHelper;
  var p: PJSONChar; const FName: JSONString): Integer;
const
  JsonEndChars: PJSONChar = ',}]';
var
  ANum: Extended;
begin
  if p^ = '"' then begin
    BuildJsonString(ABuilder, p);
    JSONObject(Self).put(FName, ABuilder);
  end else if p^='''' then begin
    if StrictJson then begin
      Result := EParse_BadStringStart;
      Exit;
    end;
    BuildJsonString(ABuilder, p);
    JSONObject(Self).put(FName, ABuilder.Value);
  end else if ParseNumeric(p, ANum) then begin //���֣�
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
    if (p^ = #0) or {$IFDEF JSON_UNICODE}CharInW{$ELSE}CharInA{$ENDIF}(p, JsonEndChars) then begin
      if SameValue(ANum, Trunc(ANum)) then
        JSONObject(Self).put(FName, Trunc(ANum))
      else
        JSONObject(Self).put(FName, ANum);
    end else begin
      Result := EParse_BadJson;
      Exit;
    end;
  end else if StartWith(p, 'False', True) then begin //False
    Inc(p,5);
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
    JSONObject(Self).put(FName, False);
  end else if StartWith(p, 'True', True) then begin //True
    Inc(p,4);
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
    JSONObject(Self).put(FName, True);
  end else if StartWith(p, 'NULL', True) then begin //Null
    Inc(p,4);
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
    JSONObject(Self).put(FName, varEmpty);
  end else begin
    Result := EParse_BadJson;
    Exit;
  end;
  Result := 0;
end;

function JSONBase.ParseJsonPair(ABuilder: JSONStringCatHelper; var p: PJSONChar): Integer;
var
  AChild: JSONBase;
  AObjEnd: JSONChar;
  FTmp: JSONString;
begin
  Result := 0;
  {$IFDEF FUNCTIONDEBUG}Inc(ParseRef);{$ENDIF}
  if p^ = '{' then begin
    AObjEnd := '}'
  end else if p^ = '[' then begin
    AObjEnd := ']';
    if Length(Self.GetName) = 0 then begin // ����Ϊ����Ϊ������
      AChild := NewChildArray('unknown');
      Result := AChild.ParseJsonPair(ABuilder, p);
      Exit;
    end;
  end else begin
    Result := EParse_EndCharNeeded;
    Exit;
  end; 
  Inc(p);
  {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);

  //����ע�ͣ���ֱ������
  while p^ = '/' do begin
    if StrictJson then begin
      Result := EParse_CommentNotSupport;
      Exit;
    end;
    if p[1] = '/' then begin
      {$IFDEF JSON_UNICODE}SkipUntilW{$ELSE}SkipUntilA{$ENDIF}(p, #10);
      {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
      Inc(p,2);
      while p^<>#0 do begin
        if (p[0]='*') and (p[1]='/') then begin
          Inc(p, 2);
          {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
          Break;
        end;
      end;
    end else begin
      Result := EParse_UnknownToken;
      Exit;
    end;
  end;

  while (p^<>#0) and (p^<>AObjEnd) do begin
    {$IFDEF FUNCTIONDEBUG}Inc(WhileRef);{$ENDIF}
    if AObjEnd = '}' then begin
      FTmp := ParseName(ABuilder, p, Result);
      if Result <> 0 then Exit;
    end;
    if (p^ = '{') or (p^ = '[') then begin
      if (p^ = '{') then
        AChild := NewChildObject(FTmp)
      else
        AChild := NewChildArray(FTmp);
      Result := AChild.ParseJsonPair(ABuilder, p);
    end else begin
      Result := ParseValue(ABuilder, p, FTmp);
    end;
    if Result <> 0 then Exit;
    if p^ = ',' then begin
      Inc(p);
      {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
    end;
  end;

  if p^ <> AObjEnd then begin
    Result := EParse_BadJson;
    Exit;
  end else begin
    Inc(p);
    {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
  end;
end;

function JSONBase.ParseName(ABuilder: JSONStringCatHelper; var p: PJSONChar; var ErrCode: Integer): JSONString;
begin
  if StrictJson and (p^<>'"') then begin
    ErrCode := EParse_BadNameStart;
    Exit;
  end;
  BuildJsonString(ABuilder, p);
  if p^ <> ':' then begin
    ErrCode := EParse_BadNameEnd;
    Exit;
  end;
  if ABuilder.Position = 0 then begin
    ErrCode := EParse_NameNotFound;
    Exit;
  end;
  Result := ABuilder.Value;
  //�����������
  Inc(p);
  {$IFDEF JSON_UNICODE}SkipSpaceW{$ELSE}SkipSpaceA{$ENDIF}(p);
end;

procedure JSONBase.parse(const text: JSONString);
begin
  Decode(PJSONChar(text), Length(text));
end;

procedure JSONBase.parse(p: PJSONChar; len: Integer);
begin
  Decode(p, len);
end;

class function JSONBase.parseArray(const text: JSONString): JSONArray;
begin
  Result := JSONArray.Create;
  try
    JSONArray(Result).parse(text);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

class function JSONBase.parseObject(const text: JSONString): JSONObject;
begin
  Result := JSONObject.Create;
  try
    JSONObject(Result).parse(text);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure JSONBase.putJSONStr(const key, value: JSONString;
  avType: JsonDataType);
var
  p: PJSONChar;
  Item: PJSONValue;

  procedure AddAsDateTime;
  var
    ATime: TDateTime;
  begin
    if ParseDateTime(p, ATime) then
      Item.AsDateTime := ATime
    else if ParseJsonTime(p, ATime) then
      Item.AsDateTime := ATime
    else
      raise Exception.Create(SBadJsonTime);
  end;

  procedure AddUnknown();
  var
    I: Integer;
    ABuilder: JSONStringCatHelper;
  begin
    ABuilder := JSONStringCatHelper.Create;
    try
      if (p^ = '{') then
        i := NewChildObject(key).ParseJsonPair(ABuilder, p)
      else if (p^ = '[') then
        i := NewChildArray(key).ParseJsonPair(ABuilder, p)
      else
        i := ParseValue(ABuilder, p, key);
      if i <> 0 then
        JSONObject(Self).put(key, value);
    finally
      ABuilder.Free;
    end;
  end;

begin
  p := PJSONChar(value);
  if avType = jdtUnknown then begin
    AddUnknown();
  end else begin
    New(Item);
    Item.FObject := nil;
    Item.FNameHash := 0;
    Item.FName := key;
    FItems.Add(Item);
    case avType of
      jdtString:
        Item.AsString := value;
      jdtInteger:
        Item.AsInteger := StrToInt(value);
      jdtFloat:
        item.AsFloat := StrToFloat(value);
      jdtBoolean:
        item.AsBoolean := StrToBool(value);
      jdtDateTime:
        AddAsDateTime;
      jdtObject:
        begin
          if (p^ = '{') then
            Item.AsJsonObject := JSONObject.parseObject(value)
          else if (p^ = '[') then
            Item.AsJsonArray := JSONArray.parseArray(value)
          else
            raise Exception.CreateFmt(SBadJsonObject, [Value]);
          if Assigned(Item.FObject) then begin
            Item.FObject.FValue := Item;
            Item.FObject.FParent := Self;
          end;
        end;
    end;
  end;
end;

procedure JSONBase.RaiseParseException(ACode: Integer; ps, p: PJSONChar);
begin
  if ACode<>0 then begin
    case ACode of
      EParse_BadStringStart:
        raise Exception.Create(FormatParseError(ACode,SBadStringStart,ps,p));
      EParse_BadJson:
        raise Exception.Create(FormatParseError(ACode,SBadJson, ps,p));
      EParse_CommentNotSupport:
        raise Exception.Create(FormatParseError(ACode,SCommentNotSupport, ps,p));
      EParse_UnknownToken:
        raise Exception.Create(FormatParseError(ACode,SCommentNotSupport, ps,p));
      EParse_EndCharNeeded:
        raise Exception.Create(FormatParseError(ACode,SEndCharNeeded, ps,p));
      EParse_BadNameStart:
        raise Exception.Create(FormatParseError(ACode,SBadNameStart, ps,p));
      EParse_BadNameEnd:
        raise Exception.Create(FormatParseError(ACode,SBadNameEnd, ps,p));
      EParse_NameNotFound:
        raise Exception.Create(FormatParseError(ACode,SNameNotFound, ps,p))
      else
        raise Exception.Create(FormatParseError(ACode,SUnknownError, ps,p));
    end;
  end;
end;

procedure JSONBase.Remove(Index: Integer);
var
  item: PJSONValue;
begin
  if (Index > -1) and (Index < FItems.Count) then begin 
    item := FItems.Items[index];
    if item <> nil then begin
      item.Free;
      Dispose(Item);
      FItems.Delete(Index);
    end;
  end;
end;

procedure JSONBase.RemoveObject(obj: JSONBase);
var
  I: Integer;
  item: PJSONValue;
begin
  for I := 0 to FItems.Count - 1 do begin
    item := FItems.Items[i];
    if (item <> nil) and (item.FObject = obj) then begin
      obj.FParent := nil;
      obj.FValue := nil;
      FItems.Delete(i);
      Dispose(Item);
    end;
  end;
end;

procedure JSONBase.SaveToFile(const AFileName: JSONString);
begin
  SaveToFile(AFileName, {$IFDEF JSON_UNICODE}teUnicode16LE{$ELSE}teAnsi{$ENDIF}, False);
end;

procedure JSONBase.SaveToFile(const AFileName: JSONString; AEncoding: TTextEncoding;
  AWriteBOM: Boolean);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    SaveToStream(AStream, AEncoding, AWriteBOM);
    AStream.SaveToFile(AFileName);
  finally
    AStream.Free;
  end;
end;

procedure JSONBase.SaveToStream(AStream: TStream; AEncoding: TTextEncoding;
  AWriteBOM: Boolean);
begin
  if AEncoding = teUTF8 then
    SaveTextU(AStream, Utf8Encode(toString(2)), AWriteBom)
  else if AEncoding = teAnsi then
    SaveTextA(AStream, AnsiString(toString(2)))
  else if AEncoding = teUnicode16LE then
    SaveTextW(AStream, toString(2), AWriteBom)
  else
    SaveTextWBE(AStream, toString(2), AWriteBom);
end;

procedure JSONBase.SaveToStream(AStream: TStream);
begin
  SaveToStream(AStream, {$IFDEF JSON_UNICODE}teUTF8{$ELSE}teAnsi{$ENDIF}, False);
end;

procedure JSONBase.SetValue(const Value: JSONString);
begin
  Decode(Value);
end;

{$IFDEF JSON_UNICODE}
function JSONBase.toString: JSONString;
begin
  Result := Encode(Self, 0);
end;
{$ENDIF}

function JSONBase.toString(AIndent: Integer): JSONString;
begin
  Result := Encode(Self, AIndent);
end;

{ JSONStringCatHelper }

function JSONStringCatHelper.Back(ALen: Integer): JSONStringCatHelper;
begin
  Result := Self;
  Dec(FDest, ALen);
  if FDest < PJSONChar(FValue) then
    FDest := PJSONChar(FValue);
end;

function JSONStringCatHelper.BackIf(const s: PJSONChar): JSONStringCatHelper;
var
  ps:PJSONChar;
begin
  Result := Self;
  ps := PJSONChar(FValue);
  while FDest > ps do begin
    {$IFDEF JSON_UNICODE}
    if (FDest[-1] >= #$DC00) and (FDest[-1] <= #$DFFF) then begin
      if CharIn(FDest-2, s) then
        Dec(FDest, 2)
      else
        Break;
    end else if CharIn(FDest-1,s) then
      Dec(FDest)
    else
      Break;
    {$ELSE}
    if CharIn(FDest-1, s) then
      Dec(FDest)
    else
      Break;
    {$ENDIF}
  end;
end;

function JSONStringCatHelper.Cat(const s: JSONString): JSONStringCatHelper;
begin
  Result := Cat(PJSONChar(s), Length(s));
end;

function JSONStringCatHelper.Cat(c: JSONChar): JSONStringCatHelper;
begin
  if (FDest-FStart)=FSize then
    NeedSize(-1);
  FDest^ := c;
  Inc(FDest);
  Result := Self; 
end;

function JSONStringCatHelper.Cat(p: PJSONChar;
  len: Integer): JSONStringCatHelper;
begin
  Result := Self;
  if len < 0 then begin
    while p^ <> #0 do begin
      if FDest-FStart >= FSize then
        NeedSize(FSize + FBlockSize);
      FDest^ := p^;
      Inc(p);
      Inc(FDest);
    end;
  end else begin
    NeedSize(-len);
    Move(p^, FDest^, len{$IFDEF JSON_UNICODE} shl 1{$ENDIF});
    Inc(FDest, len);
  end;
end;

constructor JSONStringCatHelper.Create(ASize: Integer);
begin
  inherited Create;
  FBlockSize := ASize;
  NeedSize(FBlockSize);
end;

destructor JSONStringCatHelper.Destroy;
begin
  SetLength(FValue, 0);
  inherited;
end;

constructor JSONStringCatHelper.Create;
begin
  inherited Create;
  FBlockSize := 4096;
  NeedSize(FBlockSize);
end;

function JSONStringCatHelper.GetChars(AIndex: Integer): JSONChar;
begin
  Result := FStart[AIndex];
end;

function JSONStringCatHelper.GetPosition: Integer;
begin
  Result := FDest - PJSONChar(FValue);
end;

function JSONStringCatHelper.GetValue: JSONString;
var
  L: Integer;
begin
  L := FDest - PJSONChar(FValue);
  SetLength(Result, L);
  Move(FStart^, PJSONChar(Result)^, L{$IFDEF JSON_UNICODE} shl 1{$ENDIF});
end;

procedure JSONStringCatHelper.NeedSize(ASize: Integer);
var
  offset:Integer;
begin
  offset := FDest-FStart;
  if ASize < 0 then
    ASize := offset - ASize;
  if ASize > FSize then begin
    FSize := ((ASize + FBlockSize) div FBlockSize) * FBlockSize;
    SetLength(FValue, FSize);
    FStart := PJSONChar(@FValue[0]);
    FDest := FStart + offset;
  end;
end;

function JSONStringCatHelper.Space(count: Integer): JSONStringCatHelper;
begin
{$IFDEF JSON_UNICODE}
  Result := Self;
  if Count > 0 then begin
    while Count>0 do begin
      Cat(' ');
      Dec(Count);
    end;
  end;
{$ELSE}
  Result := Self;
  if Count > 0 then begin
    while Count>0 do begin
      Cat(' ');
      Dec(Count);
    end;
  end;
{$ENDIF}
end;

procedure JSONStringCatHelper.SetPosition(const Value: Integer);
begin
  if Value <= 0 then
    FDest := PJSONChar(FValue)
  else if Value>Length(FValue) then begin
    NeedSize(Value);
    FDest := PJSONChar(FValue) + Value;
  end else
    FDest := PJSONChar(FValue) + Value;
end;

{ JSONObject }

procedure JSONObject.put(const key: JSONString; value: Byte);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.Asbyte := value;
end;

procedure JSONObject.put(const key, value: JSONString);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsString := value;
end;

procedure JSONObject.put(const key: JSONString; const value: Int64);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsInt64 := value;
end;

procedure JSONObject.put(const key: JSONString; value: Integer);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsInteger := value;
end;

procedure JSONObject.put(const key: JSONString; value: Word);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsWord := value;
end;

procedure JSONObject.put(const key: JSONString; value: Cardinal);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsDWORD := value;
end;

procedure JSONObject.put(const key: JSONString; value: JSONObject);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsJsonObject := value;
  if value.FParent <> nil then
    value.FParent.RemoveObject(value);
  value.FParent := Self;
  value.FValue := item;
end;

function JSONObject.addChildArray(const key: JSONString): JSONArray;
begin
  if Length(key) > 0 then
    Result := NewChildArray(key)
  else
    Result := nil;
end;

function JSONObject.addChildObject(const key: JSONString): JSONObject;
begin
  if Length(key) > 0 then
    Result := NewChildObject(key)
  else
    Result := nil;
end;

function JSONObject.Clone: JSONObject;
begin
  Result := JSONObject.Create;
  Result.Assign(Self);
end;

procedure JSONObject.Delete(const key: JSONString);
begin
  Remove(IndexOf(key));
end;

function JSONObject.exist(const key: JSONString): Boolean;
begin
  Result := IndexOf(Key) > -1;
end;

function JSONObject.getBoolean(const key: JSONString): Boolean;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsBoolean
  else
    Result := False;
end;

function JSONObject.getByte(const key: JSONString): Byte;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsByte
  else
    Result := 0;
end;

function JSONObject.getDateTime(const key: JSONString): TDateTime;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsDateTime
  else
    Result := 0;
end;

function JSONObject.getDouble(const key: JSONString): Double;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsDouble
  else
    Result := 0;
end;

function JSONObject.getDWORD(const key: JSONString): Cardinal;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsDWORD
  else
    Result := 0;
end;

function JSONObject.getFloat(const key: JSONString): Extended;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsFloat
  else
    Result := 0;
end;

function JSONObject.getInt(const key: JSONString): Integer;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsInteger
  else
    Result := 0;
end;

function JSONObject.getInt64(const key: JSONString): Int64;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsInt64
  else
    Result := 0;
end;

function JSONObject.getItem(const key: JSONString): PJSONValue;
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I < 0 then
    Result := nil
  else
    Result := FItems[I]; 
end;

function JSONObject.getJsonArray(const key: JSONString): JSONArray;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsJsonArray
  else
    Result := nil;
end;

function JSONObject.getJsonObject(const key: JSONString): JSONObject;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsJsonObject
  else
    Result := nil;
end;

function JSONObject.getString(const key: JSONString): JSONString;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsString
  else
    Result := '';
end;

function JSONObject.getVariant(const key: JSONString): Variant;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsVariant
  else
    Result := varEmpty;
end;

function JSONObject.getWord(const key: JSONString): Word;
var
  Item: PJSONValue;
begin
  Item := getItem(key);
  if Item <> nil then
    Result := Item.AsWord
  else
    Result := 0;
end;

procedure JSONObject.NewJsonValue(var v: PJSONValue);
begin
  New(v);
  //FillChar(v^, SizeOf(JSONValue), 0);
  v.FObject := nil;
  v.FNameHash := 0;
  v.FType := jdtUnknown;
  FItems.Add(v);
end;

procedure JSONObject.put(const key: JSONString; value: JSONArray);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsJsonArray := value;
  if value.FParent <> nil then
    value.FParent.RemoveObject(value);
  value.FParent := Self;
  value.FValue := item;
end;

procedure JSONObject.put(const key: JSONString; ABuilder: JSONStringCatHelper);
var
  item: PJSONValue;
  L: Integer;
begin
  NewJsonValue(item);
  item.FName := key;
  item.FType := jdtString;
  {$IFDEF JSON_UNICODE}
  L := ABuilder.Position{$IFDEF JSON_UNICODE} shl 1{$ENDIF};
  SetLength(item.FValue, L);
  if (L > 0) then
    Move(ABuilder.FStart^, Item.FValue[0], L);
  {$ELSE}
  L := ABuilder.Position;
  SetLength(item.FValue, L + 1);
  if (L > 0) then
    Move(ABuilder.FStart^, Item.FValue[0], L);
  {$ENDIF}
end;

procedure JSONObject.put(const key: JSONString; const value: Variant);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsVariant := value;
end;

procedure JSONObject.put(const key: JSONString; const value: Extended);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsFloat := value;
end;

procedure JSONObject.put(const key: JSONString; const value: Double);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsDouble := value;
end;

procedure JSONObject.putDateTime(const key: JSONString; value: TDateTime);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.FName := key;
  item.AsDateTime := value;
end;

{ JSONArray }

procedure JSONArray.add(value: JSONObject);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsJsonObject := value;
  if value.FParent <> nil then
    value.FParent.RemoveObject(value);
  value.FParent := Self;
  value.FValue := item;
end;

procedure JSONArray.add(value: Byte);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.Asbyte := value;
end;

procedure JSONArray.add(const value: JSONString);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsString := value;
end;

procedure JSONArray.add(value: Cardinal);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsDWORD := value;  
end;

procedure JSONArray.add(value: Integer);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsInteger := value;
end;

procedure JSONArray.add(value: Word);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsWord := value;
end;

procedure JSONArray.add(const value: Int64);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsInt64 := value;
end;

procedure JSONArray.add(const value: Variant);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsVariant := value;
end;

procedure JSONArray.add(value: JSONArray);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsJsonArray := value;
  if value.FParent <> nil then
    value.FParent.RemoveObject(value);
  value.FParent := Self;
  value.FValue := item;
end;

function JSONArray.addChildArray: JSONArray;
begin
  Result := NewChildArray('');
end;

function JSONArray.addChildObject: JSONObject;
begin
  Result := NewChildObject(''); 
end;

procedure JSONArray.add(const value: Extended);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsFloat := value;
end;

procedure JSONArray.add(const value: Double);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsDouble := value;
end;

procedure JSONArray.addDateTime(value: TDateTime);
var
  item: PJSONValue;
begin
  NewJsonValue(item);
  item.AsDateTime := value;
end;

procedure JSONArray.addJSONStr(const key, value: JSONString;
  avType: JsonDataType);
begin
  putJSONStr(key, value, avType);  
end;

function JSONArray.Clone: JSONArray;
begin
  Result := JSONArray.Create;
  Result.Assign(Self);
end;

function JSONArray.getBoolean(Index: Integer): Boolean;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsBoolean
  else
    Result := False;
end;

function JSONArray.getByte(Index: Integer): Byte;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsByte
  else
    Result := 0;
end;

function JSONArray.getDateTime(Index: Integer): TDateTime;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsDateTime
  else
    Result := 0;
end;

function JSONArray.getDouble(Index: Integer): Double;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsDouble
  else
    Result := 0;
end;

function JSONArray.getDWORD(Index: Integer): Cardinal;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsDWORD
  else
    Result := 0;
end;

function JSONArray.getFloat(Index: Integer): Extended;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsFloat
  else
    Result := 0;
end;

function JSONArray.getInt(Index: Integer): Integer;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsInteger
  else
    Result := 0;
end;

function JSONArray.getInt64(Index: Integer): Int64;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsInt64
  else
    Result := 0;
end;

function JSONArray.GetIsArray: Boolean;
begin
  Result := True;
end;

function JSONArray.getJsonArray(Index: Integer): JSONArray;
var
  item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then  
    Result := Item.AsJsonArray
  else
    Result := nil;
end;

function JSONArray.getJsonObject(Index: Integer): JSONObject;
var
  item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then  
    Result := Item.AsJsonObject
  else
    Result := nil;
end;

function JSONArray.getString(Index: Integer): JSONString;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsString
  else
    Result := '';
end;

function JSONArray.getVariant(Index: Integer): Variant;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsVariant
  else
    Result := varEmpty;
end;

function JSONArray.getWord(Index: Integer): Word;
var
  Item: PJSONValue;
begin
  Item := FItems[index];
  if Item <> nil then
    Result := Item.AsWord
  else
    Result := 0;
end;

procedure JSONArray.NewJsonValue(var v: PJSONValue);
begin
  New(v);
  v.FObject := nil;
  v.FName := '';
  v.FNameHash := 0;
  v.FType := jdtUnknown;
  FItems.Add(v);
end;

initialization

finalization

end.

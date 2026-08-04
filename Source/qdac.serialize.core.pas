unit qdac.serialize.core;

interface

uses classes, sysutils, typinfo, dateutils, math, ansistrings, Character, generics.Collections, generics.Defaults, rtti, variants, fmtbcd, qdac.common, qdac.attribute;

const
  PAGE_BUFFER_SIZE = 4096 - sizeof(Pointer) - sizeof(Word);

type
  PQSerializeField = ^TQSerializeField;
  TQSerializeProc = procedure(AField: PQSerializeField; ASourceType: PTypeInfo; ASource, ATarget: Pointer) of object;
  PQSerializeFields = ^TQSerializeFields;
  IQSerializeWriter = interface;
  IQSerializeReader = interface;

  { ---- 共享 DOM 结点基类型 ----
    为什么用 record 而不用 class？

    1. 零开销联合体（variant record）
       每个结点的值类型不同（整数/浮点/字符串/布尔/BCD/日期等），
       record 的 case 语法让所有类型共享同一块内存，按最大成员对齐。
       如果用 class，每个值字段独立占堆空间，要么用 TValue/Variant 绕，
       引入额外内存分配和类型分派开销。

    2. 公共头 + 指针转型 = C 风格的 struct embedding（零成本"继承"）
       TQNodeBase 作为所有结点类型的首个字段（Base: TQNodeBase），
       代码通过 PQNodeBase/PQMsgPackNode/PQXmlNode 之间直接指针转换，
       实现"基类"共享遍历逻辑（ForEach/Find/ItemByPath/XPath）。
       没有 VMT 间接寻址，没有 as/is 运行时 RTTI 检查。

    3. 无 VMT 开销
       Delphi class 每个实例 8 字节 VMT 指针，record 没有。
       对于百万级结点的解析树，仅 VMT 就能省 8 MB。

    4. 确定性生命周期，零引用计数
       结点树是批量创建、批量释放的——解析完成后整体访问，访问完一次性释放。
       record + New/Dispose 没有接口 _AddRef/_Release 写屏障，
       没有 ARC/GC 延迟，也适合配合自定义内存池。
       而 class + 接口管理会在父子引用时产生大量不必要的引用计数操作。

    5. 内存布局固定，序列化友好
       JSON/MessagePack/XML 都是高吞吐格式。record 编译期确定偏移，
       可以直接内存映射或块操作，不依赖 RTTI 遍历字段。

    适用场景：
       适合结点量大、类型多样、生命周期明确（批量创建→访问→批量释放）的
       DOM 解析树。如果需要多态行为（虚方法）、细粒度生命周期管理
       （单个结点独立创建/释放）、或与现有 class 框架集成，则应选用 class。

    下面是具体的"基类型"，三个结点（JSON/MsgPack/XML）用它作为首个字段，
    配合指针转换实现"继承"效果。
  }
  PQNodeBase = ^TQNodeBase;
  TQNodeBase = record
    Next: PQNodeBase;
    Prior: PQNodeBase;
    FirstChild: PQNodeBase;
    LastChild: PQNodeBase;
    ChildCount: Integer;
    Name: UnicodeString;
  end;
  TQNodeForEachCallback = reference to procedure(ANode: PQNodeBase; var AContinue: Boolean);

  TQSerializeTypeData = record
    Prefix: UnicodeString; // 名称前缀
    NameFormat: TSerializeNameFormat; // 名称格式
    IdentFormat: TSerializeNameFormat; // 枚举或标志时值的转换规则
    DateTimeFormat: TSerializeDateTimeFormat; // 日期时间类型格式
    FormatText: string; // 目前仅 FormatDateTime/FormatFloat 支持
    TypeInfo: PTypeInfo; // 类型信息
    TypeData: PTypeData; // 类型数据
    PropInfo: PPropInfo; // 如果是属性时，对应的属性信息
    // Delphi 整数与标志字符串之间转换
    IdentToInt: TIdentToInt;
    IntToIdent: TIntToIdent;
  // 原始类型信息
  // 集合对应的枚举类型或数组元素的项目类型
  case Integer of
    0: (BaseType: PTypeInfo; BaseTypeData: PTypeData;);
    1: (ElementType: PTypeInfo; ElementTypeData: PTypeData; ElementFields: PQSerializeFields;);
    2: (
      EnumType: PTypeInfo;
      EnumTypeData: PTypeData;
      // 是否将枚举类型识别为整数
      EnumAsInt: Boolean;
    );
  end;

  PQSerializeTypeData = ^TQSerializeTypeData;

  TQSerializeField = record
    TypeData: TQSerializeTypeData; // 关联的类型信息缓存
    Parent, Fields: PQSerializeFields; // 成员列表
    // 字段的名称，可以有多个别名，如由于历史原因，可能原来叫 a1，后面改名叫 a2，则Names就是 ['a2','a1']
    Names: TArray<UnicodeString>;
    Pathes: TArray<UnicodeString>;
    // 枚举或标志符映射及反映射
    KVMap: TArray<TStringPair>;
    VKMap: TArray<TStringPair>;
    FormatedName: UnicodeString;
    // 字段相对偏移
    Offset: Integer;
    // 字段长度
    Size: Integer;
    // 强制为字符串类型
    ForceAsString: Boolean;
  end;

  TQSerializeFieldHelper = record helper for TQSerializeField
    function FieldInstance<TPointer>(const AParent: Pointer): TPointer; inline;
  end;

  PQSerializeStackItem = ^TQSerializeStackItem;

  // 使用它以避免递归序列化，如 A 里引用了自身，或者 A 引用了B，B里又引用了A
  TQSerializeStackItem = record
    Instance: Pointer;
    TypeInfo: PTypeInfo;
    Fields: PQSerializeFields;
    Field: PQSerializeField;
    Prior: PQSerializeStackItem;
    UserData: Pointer;
  end;

  TQSerializeReadEventKind = (
      srekStartObject,
      srekEndObject,
      srekStartArray,
      srekEndArray,
      srekValue
  );

  TQSerializeReadEvent = record
    Kind: TQSerializeReadEventKind;
    Name: UnicodeString;
  end;

  // 用户定义的类型序列化
  IQCustomSerializer = interface
    ['{51BE1847-BD95-4C2D-A642-7BAE41B9BBC3}']
    procedure Write(AWriter: IQSerializeWriter; AStack: PQSerializeStackItem; AField: PQSerializeField);
    procedure Read(AReader: IQSerializeReader; AStack: PQSerializeStackItem; AField: PQSerializeField);
  end;

  // 可选的流式读取接口。ReadRawValue 仅在 srekValue 回调期间有效。
  IQCustomSerializerEvents = interface
    ['{CD1C07D5-BA6E-4C7F-88E4-74F9DEBB6E31}']
    procedure BeginRead(AReader: IQSerializeReader; AStack: PQSerializeStackItem; AField: PQSerializeField);
    procedure ReadEvent(AReader: IQSerializeReader; AStack: PQSerializeStackItem; AField: PQSerializeField;
        const AEvent: TQSerializeReadEvent);
    procedure EndRead(AReader: IQSerializeReader; AStack: PQSerializeStackItem; AField: PQSerializeField;
        ACompleted: Boolean);
  end;

  TQSerializeFields = record
    TypeData: TQSerializeTypeData;
    CustomSerializer: IQCustomSerializer;
    Fields: TArray<TQSerializeField>;
  end;
  TQSerializeChildrenCallback = reference to procedure;
  IQSerializeWriter = interface
    ['{6596818B-32B7-4A2F-9512-1229E7553A0B}']
    procedure StartObject;
    procedure EndObject;
    procedure WriteObject(const AName: UnicodeString; const ACallback: TQSerializeChildrenCallback);
    procedure StartArray;
    procedure EndArray;
    procedure WriteArray(const AName: UnicodeString; const ACallback: TQSerializeChildrenCallback);
    procedure WriteValue(const V: UnicodeString); overload;
    procedure WriteValue(const V: Int64; AIsSign: Boolean = true); overload;
    procedure WriteValue(const V: UInt64); overload;
    procedure WriteValue(const V: Extended; const AFormat: string = ''); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency; const AFormat: string = ''); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteNull; overload;
    procedure StartObjectPair(const AName: UnicodeString);
    procedure StartArrayPair(const AName: UnicodeString);
    procedure StartPair(const AName: UnicodeString);
    procedure WritePair(const AName: UnicodeString; const V: UnicodeString); overload;
    procedure WritePair(const AName: UnicodeString; const V: Int64; AIsSign: Boolean = true); overload;
    procedure WritePair(const AName: UnicodeString; const V: UInt64); overload;
    procedure WritePair(const AName: UnicodeString; const V: Extended; const AFormat: string = ''); overload;
    procedure WritePair(const AName: UnicodeString; const V: TBcd); overload;
    procedure WritePair(const AName: UnicodeString; const V: Boolean); overload;
    procedure WritePair(const AName: UnicodeString; const V: TDateTime); overload;
    procedure WritePair(const AName: UnicodeString; const V: Currency; const AFormat: string = ''); overload;
    procedure WritePair(const AName: UnicodeString; const V: TBytes); overload;
    procedure WritePair(const AName: UnicodeString); overload;
    procedure Flush;
  end;

  IQTextSerializeWriter = interface(IQSerializeWriter)
    ['{A3709898-54E4-4907-A615-3228A62D3C4E}']
    procedure WriteRawValue(const AText: UnicodeString);
    procedure WriteRawPair(const AName, AText: UnicodeString);
  end;

  IQBinarySerializeWriter = interface(IQSerializeWriter)
    ['{F948BC27-6161-47C1-B6E0-C0F7C60A92E9}']
    procedure WriteRawValue(const ABytes: TBytes);
    procedure WriteRawPair(const AName: UnicodeString; const ABytes: TBytes);
  end;

  // 从流或字符串中反序列化实例
  IQSerializeReader = interface
    ['{F65DB855-C751-4C84-AD91-346ADC335D62}']
    procedure SetRoot(const AInstance: Pointer; AFields: PQSerializeFields);
    function TryRead(const AName: string): Boolean;
    procedure EndRead;
    procedure DoParse;
    function GetActiveInstance: Pointer;
    function GetActiveFields: PQSerializeFields;
    property ActiveInstance: Pointer read GetActiveInstance;
    property ActiveFields: PQSerializeFields read GetActiveFields;
  end;

  IQTextSerializeReader = interface(IQSerializeReader)
    ['{D8C5503B-B68F-45A8-8FE0-7914CD7C8A77}']
    procedure ReadRawValue(out AText: UnicodeString);
    function ReadRawPair(out AName, AText: UnicodeString): Boolean;
  end;

  IQBinarySerializeReader = interface(IQSerializeReader)
    ['{EF39D1A1-A39D-47B9-A3CF-C7A5F967E169}']
    procedure ReadRawValue(out ABytes: TBytes);
    function ReadRawPair(out AName: UnicodeString; out ABytes: TBytes): Boolean;
  end;

  TQSerializeWriterCreateProc = procedure(AStream: TStream; var AWriter: IQSerializeWriter);
  TQSerializeReaderCreateProc = procedure(AStream: TStream; const AText: UnicodeString; var AReader: IQSerializeReader);

  TQSerializeFormatCodec = record
    Reader: TQSerializeReaderCreateProc;
    Writer: TQSerializeWriterCreateProc;
  end;

  TQBaseReader = class(TInterfacedObject, IQSerializeReader)
  protected
    FRoot: TQSerializeStackItem;
    FCurrent: PQSerializeStackItem;
    function GetActiveInstance: Pointer;
    function GetActiveFields: PQSerializeFields;
    function TryRead(const AName: string): Boolean;
    procedure EndRead;
    procedure SetRoot(const AInstance: Pointer; AFields: PQSerializeFields);
    procedure DoParse; virtual; abstract;
  public
    destructor Destroy; override;
    procedure Push(AInstance: Pointer; AFields: PQSerializeFields); overload;
    procedure Push(AParentInstance: Pointer; AField: PQSerializeField); overload;
    procedure Push(AInstance: Pointer; AType: PTypeInfo; AFields: PQSerializeFields); overload;
    procedure Pop;
  end;

  TQSerializer = class sealed
  private
    class var
      FCurrent: TQSerializer;
  protected
    var
      FKeyComparer, FValueComparer: IComparer<TStringPair>;
      FCodecs: TDictionary<UnicodeString, TQSerializeFormatCodec>;
      FCachedTypes: TDictionary<PTypeInfo, PQSerializeFields>;
      FRttiContext: TRttiContext;
    class function GetCurrent: TQSerializer; static;
    function InternalRegisterType(AType: PTypeInfo): PQSerializeFields;
    class procedure DoSerialize(AWriter: IQSerializeWriter; const AStack: TQSerializeStackItem); static;
    function DoRegister(AType: PTypeInfo): PQSerializeFields; inline;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function RegisterType(AType: PTypeInfo; const ACustomSerializer: IQCustomSerializer = nil): PQSerializeFields;
    procedure Register(AType: PTypeInfo; const AFields: TQSerializeFields);
    function Find(AType: PTypeInfo): PQSerializeFields;
    procedure Clear;
    // Codec
    procedure RegisterCodec(
        const ACode: UnicodeString;
        AReader: TQSerializeReaderCreateProc;
        AWriter: TQSerializeWriterCreateProc
    );
    procedure SaveToStream<T>(AInstance: T; AStream: TStream; const AFormat: UnicodeString = 'json');
    procedure SaveToFile<T>(AInstance: T; AFileName: UnicodeString; const AFormat: UnicodeString = 'json');
    procedure LoadFromStream<T>(AInstance: T; AStream: TStream; const AFormat: UnicodeString = 'json');
    procedure LoadFromFile<T>(AInstance: T; AFileName: UnicodeString; const AFormat: UnicodeString = 'json');
    class function FormatName(const S: UnicodeString; const AFormat: TSerializeNameFormat): UnicodeString;
    class procedure FromRtti<T>(AWriter: IQSerializeWriter; const AInstance: T); static;
    class procedure ToRtti<T>(AReader: IQSerializeReader; var AInstance: T); static;
    class procedure WriteRawValue(AWriter: IQSerializeWriter; const AText: UnicodeString); overload; static;
    class procedure WriteRawPair(AWriter: IQSerializeWriter; const AName, AText: UnicodeString); overload; static;
    class procedure WriteRawValue(AWriter: IQSerializeWriter; const ABytes: TBytes); overload; static;
    class procedure WriteRawPair(AWriter: IQSerializeWriter; const AName: UnicodeString; const ABytes: TBytes); overload; static;
    class procedure ReadRawValue(AReader: IQSerializeReader; out AText: UnicodeString); overload; static;
    class function ReadRawPair(AReader: IQSerializeReader; out AName, AText: UnicodeString): Boolean; overload; static;
    class procedure ReadRawValue(AReader: IQSerializeReader; out ABytes: TBytes); overload; static;
    class function ReadRawPair(AReader: IQSerializeReader; out AName: UnicodeString; out ABytes: TBytes): Boolean; overload; static;
    class property Current: TQSerializer read GetCurrent;
  end;
  PQPageBuffer = ^TQPageBuffer;
  PQPageBuffers = ^TQPageBuffers;

  // sizeof(TQPageBuffer)=4096
  TQPageBuffer = packed record
    Next: PQPageBuffer;
    // Cached Pointer
    NextByte, EofByte: PByte;
    PageNo: Cardinal;
    Data: array[0..PAGE_BUFFER_SIZE - 1] of Byte;
    function Used: Cardinal; inline;
  end;

  // 页面顺序缓冲区，如果要随机访问，应该额外建立页索引表，我们这里不考虑这块
  TQPageBuffers = record
  private
    First: TQPageBuffer;
    Last, Current: PQPageBuffer;
    PageCount: Cardinal;
  private
    function GetLength: NativeInt;
    procedure SetLength(const Value: NativeInt);
    function NeedNextPage(APage: PQPageBuffer): PQPageBuffer;
    // inline;
    function GetBytes(AIndex: Integer): Byte;
  public
    procedure Initialize;
    procedure Cleanup;
    function ToString: UnicodeString; overload;
    procedure ToString(var S: UnicodeString); overload;
    property Length: NativeInt read GetLength write SetLength;
    function RawAppend(const ABytes: TBytes; const AOffset, ACount: NativeInt): PQPageBuffers; overload; inline;
    function RawAppend(const p: Pointer; const AOffset, ACount: NativeInt): PQPageBuffers; overload; inline;
    // Todo:AppendUtf8(...)/AppendBE(...)
    // 按 Unicode 16 LE 插入，用于替换 TStringBuilder 对应功能
    function Append(c: WideChar): PQPageBuffers; overload; inline;
    function Append(const p: PWideChar; const AOffset, ACount: NativeInt): PQPageBuffers; overload; inline;
    function Append(const p: PWideChar): PQPageBuffers; overload; inline;
    function Append(const S: UnicodeString): PQPageBuffers; overload; inline;
    function Append(const V: Int64): PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Currency): PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Single): PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Double): PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Extended): PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: TDateTime): PQPageBuffers; overload; inline;
    property Bytes[AIndex: Integer]: Byte read GetBytes;
  end;

{ ---- 共享 DOM 操作函数 ---- }
procedure NodeAddChild(AParent, AChild: PQNodeBase);
procedure NodeDeleteChild(AParent: PQNodeBase; AIndex: Integer);
function NodeFindByName(AParent: PQNodeBase; const AName: UnicodeString): PQNodeBase;
procedure NodeForEach(ARoot: PQNodeBase; ACallback: TQNodeForEachCallback);
function NodeFindAll(ARoot: PQNodeBase; const AName: UnicodeString): TArray<PQNodeBase>;
procedure NodeSort(ARoot: PQNodeBase; ASC: Boolean);
function NodeByPath(ARoot: PQNodeBase; const APath: UnicodeString; ADelimiter: WideChar): PQNodeBase;
function NodeForcePath(ARoot: PQNodeBase; const APath: UnicodeString; ADelimiter: WideChar): PQNodeBase;
function NodeForceName(ARoot: PQNodeBase; const AName: UnicodeString): PQNodeBase;
function NodeXPath(ARoot: PQNodeBase; const AExpr: UnicodeString): TArray<PQNodeBase>;

type
TQValueCaches < TItemType >= class //
private //
type //
PItemType =^TItemType;

type
TQCachedItem = record //
HashCode: Integer; //
RefCount: Integer;
Value: TItemType;
end;

type
PQCachedItem =^TQCachedItem;

const
POINTER_IS_REF = IntPtr($02);
POINTER_IS_CACHED = IntPtr($01);
POINTER_MASK: IntPtr = not IntPtr(3);
private
FItems: TArray<PQCachedItem>;
FCount: Integer;
FComparer: IEqualityComparer<TItemType>;
FGrowThreshold: NativeInt;
FKeepCaches: Boolean;
procedure Grow;
procedure Rehash(NewCapPow2: NativeInt);
function GetBucketIndex(const Key: TItemType; HashCode: Integer): NativeInt;
procedure SetKeepCaches(const Value: Boolean);
public
constructor Create(AComparer: IEqualityComparer<TItemType>);
overload;
destructor Destroy;
override;
function AddRef(const AValue: Pointer): Pointer;
virtual;
function RefValue(const AValue: TItemType): TItemType;
virtual;
function Release(const AValue: Pointer): Pointer;
virtual;
procedure Clear;
class
function Value(ARef: Pointer): TItemType;
// 判断对应的地址是否是一个引用，如果是引用，则不能直接赋值
class
function IsReference(p: Pointer): Boolean;
inline;
class
function ReferenceSource(p: Pointer): Pointer;
inline;
class
function MakeReference(p: Pointer): Pointer;
inline;
property Count: Integer read FCount;
property KeepCaches: Boolean read FKeepCaches write SetKeepCaches;
end;

implementation

{ TQSerializer }

procedure TQSerializer.Clear;
begin
for var AValue in FCachedTypes.Values do
Dispose(AValue);
FCachedTypes.Clear;
end;

constructor TQSerializer.Create;
begin
inherited;
FRttiContext := TRttiContext.Create;
FCodecs := TDictionary<UnicodeString, TQSerializeFormatCodec>.Create;
FCachedTypes := TDictionary<PTypeInfo, PQSerializeFields>.Create;
FKeyComparer := TComparer<TStringPair>.Construct(
function(const L, R: TStringPair): Integer
begin
Result := CompareStr(L.Key, R.Key);
end);
FValueComparer := TComparer<TStringPair>.Construct(
function(const L, R: TStringPair): Integer
begin
Result := CompareStr(L.Value, R.Value);
end);
end;
destructor TQSerializer.Destroy;
begin
FRttiContext := Default(TRttiContext);
Clear;
FreeAndNil(FCachedTypes);
FreeAndNil(FCodecs);
inherited;
end;

function TQSerializer.DoRegister(AType: PTypeInfo): PQSerializeFields;
begin
Result := InternalRegisterType(AType);
end;

// 如果 AFields 为空，则根据 AType 自动获取当前实例对应的类型，这块应该可以优化
class procedure TQSerializer.DoSerialize(AWriter: IQSerializeWriter;
const AStack: TQSerializeStackItem);
type
TLargestSet = set of Byte;
PLargestSet =^TLargestSet;

var
S: UnicodeString;
procedure WriteField(AInstance: Pointer; const AField: TQSerializeField;
const AKind: TTypeKind); forward;

function GetOrdInstanceValue(AInstance: Pointer; AOrdType: TOrdType): Int64;
begin
case AOrdType of
otUByte:
Result := PByte(AInstance)^;
otSByte:
Result := PShortint(AInstance)^;
otUWord:
Result := PWord(AInstance)^;
otSWord:
Result := PSmallint(AInstance)^;
otULong:
Result := PCardinal(AInstance)^;
otSLong:
Result := PInteger(AInstance)^
else // avoid compile warning
Result := 0;
end;
end;
function GetIntValue(AInstance: Pointer;
const AField: TQSerializeField): Int64;
begin
if Assigned(AField.TypeData.PropInfo) then
begin
case AField.TypeData.PropInfo.PropType^.Kind of
tkInteger, tkEnumeration:
Result := GetOrdProp(AInstance, AField.TypeData.PropInfo);
tkInt64:
Result := GetInt64Prop(AInstance, AField.TypeData.PropInfo)
else // avoid compile error
Result := 0;
end;
end
else
begin
case AField.TypeData.TypeInfo.Kind of
tkInteger, tkEnumeration:
Result := GetOrdInstanceValue
(AField.FieldInstance<Pointer>(AInstance),
AField.TypeData.BaseTypeData.OrdType);
tkInt64:
Result := AField.FieldInstance<PInt64>(AInstance)^
else // avoid compile error
Result := 0;
end;
end;
end;

function GetFloatValue(AInstance: Pointer; const AField: TQSerializeField)
: Extended;
begin
if Assigned(AField.TypeData.PropInfo) then
Result := GetFloatProp(AInstance, AField.TypeData.PropInfo)
else
begin
case AField.TypeData.BaseTypeData.FloatType of
ftSingle:
Result := AField.FieldInstance<PSingle>(AInstance)^;
ftDouble:
Result := AField.FieldInstance<PDouble>(AInstance)^;
ftExtended:
Result := AField.FieldInstance<PExtended>(AInstance)^;
ftComp:
Result := AField.FieldInstance<PComp>(AInstance)^;
ftCurr:
Result := AField.FieldInstance<PCurrency>(AInstance)^
else // avoid compile error
Result := 0;
end;
end;
end;

function GetCurrValue(AInstance: Pointer; const AField: TQSerializeField)
: Currency;
var
M: TMethod;
type
TGetProc = function: Currency of object;
TIdxGetProc = function(Index: Integer): Currency of object;
begin
if AField.TypeData.BaseTypeData.FloatType = ftCurr then
begin
if Assigned(AField.TypeData.PropInfo) then
begin
if (IntPtr(AField.TypeData.PropInfo.GetProc) and PROPSLOT_MASK) = PROPSLOT_FIELD
then
Result := PCurrency(PByte(AInstance) +
(IntPtr(AField.TypeData.PropInfo.GetProc) and not PROPSLOT_MASK))^
else
begin
if (IntPtr(AField.TypeData.PropInfo.GetProc) and PROPSLOT_MASK) = PROPSLOT_VIRTUAL
then // Virtual Method
M.Code := PPointer(PNativeUInt(AInstance)^+
(UIntPtr(AField.TypeData.PropInfo.GetProc) and $FFFF))^
else // Static method
M.Code := AField.TypeData.PropInfo.GetProc;
M.Data := AInstance;
if AField.TypeData.PropInfo^.
Index = Low(AField.TypeData.PropInfo^.Index) then
// no index
Result := TGetProc(M)()
else
Result := TIdxGetProc(M)(AField.TypeData.PropInfo^.Index);
end
end
else
Result := AField.FieldInstance<PCurrency>(AInstance)^
end
else // avoid complie error
Result := 0;
end;

function GetBooleanValue(AInstance: Pointer;
const AField: TQSerializeField): Boolean;
begin
if (AField.TypeData.BaseType = TypeInfo(Boolean)) or
(AField.TypeData.BaseType = TypeInfo(ByteBool)) or
(AField.TypeData.BaseType = TypeInfo(WordBool)) or
(AField.TypeData.BaseType = TypeInfo(LongBool)) or
((AField.TypeData.BaseType.Kind = tkEnumeration) and
(AField.TypeData.BaseType.NameFld.ToString = 'bool')) then
begin
if Assigned(AField.TypeData.PropInfo) then
Result := GetOrdProp(AInstance, AField.TypeData.PropInfo) <> 0
else
Result := GetIntValue(AInstance, AField) <> 0;
end
else
Result := false;
end;

function GetEnumValue(AInstance: Pointer; const AField: TQSerializeField)
: UnicodeString;
begin
if Assigned(AField.TypeData.PropInfo) then
Result := GetEnumName(AField.TypeData.PropInfo.PropType^,
GetOrdProp(AInstance, AField.TypeData.PropInfo))
else
begin
Result := GetEnumName(AField.TypeData.TypeInfo,
GetIntValue(AInstance, AField));
end;
if Length(AField.TypeData.Prefix) > 0 then
begin
  if Result.StartsWith(AField.TypeData.Prefix) then
    Result := Result.Substring(Length(AField.TypeData.Prefix));
end;
end;

function GetStrValue(AInstance: Pointer; const AField: TQSerializeField): UnicodeString;
begin
  if Assigned(AField.TypeData.PropInfo) then
    Result := GetStrProp(AInstance, AField.TypeData.PropInfo)
  else begin
    case AField.TypeData.BaseType.Kind of
{$IFNDEF NEXTGEN}
      tkString: Result := UnicodeString(AField.FieldInstance<PShortString>(AInstance)^);
      tkWString: Result := UnicodeString(AField.FieldInstance<PWideString>(AInstance)^);
{$ENDIF !NEXTGEN}
      tkLString: Result := UnicodeString(AField.FieldInstance<PAnsiString>(AInstance)^);
      tkUString: Result := AField.FieldInstance<PUnicodeString>(AInstance)^;
    else
      Result := '';
    end;
  end;
end;

function GetObjectValue(AInstance: Pointer; const AField: TQSerializeField): TObject;
begin
  if Assigned(AField.TypeData.PropInfo) then
    Result := TObject(GetOrdProp(AInstance, AField.TypeData.PropInfo))
  else
    Result := AField.FieldInstance<PObject>(AInstance)^;
end;

function RemovePrefix(const AName, APrefix: UnicodeString; ANameFormat: TSerializeNameFormat): UnicodeString;
begin
  if Length(APrefix) > 0 then begin
    if AName.StartsWith(AName, false) then
      Result := FormatName(AName.Substring(Length(APrefix)), ANameFormat)
    else
      Result := FormatName(AName, ANameFormat);
  end
  else
    Result := FormatName(AName, ANameFormat);
end;

procedure WriteSetItems(
    ASet: PLargestSet;
    ASetType, AEnumType: PTypeInfo;
    APrefix: UnicodeString;
    ANameFormat: TSerializeNameFormat
);
var
  ABit: Byte;
  ABits: Integer;
  AValue: UnicodeString;
begin
  if Assigned(AEnumType) then begin
    for ABit := AEnumType.TypeData.MinValue to AEnumType.TypeData.MaxValue do begin
      if ABit in ASet^ then begin
        AValue := RemovePrefix(GetEnumName(AEnumType, ABit), APrefix, ANameFormat);
        AWriter.WriteValue(AValue);
      end;
    end;
  end
  else // how?
  begin
    ABits := SizeOfSet(ASetType) * 8;
    for ABit := 0 to ABits - 1 do begin
      if ABit in ASet^ then
        AWriter.WriteValue(ABit);
    end;
  end;
end;

procedure WriteSetValue(AInstance: Pointer; const AField: TQSerializeField);
var
  APrefix: string;
  ANameFormat: TSerializeNameFormat;
begin
  AWriter.StartArrayPair(AField.FormatedName);
  try
    if Assigned(AField.TypeData.EnumType) then begin
      APrefix := AField.TypeData.Prefix;
      ANameFormat := AField.TypeData.IdentFormat;
      if (Length(APrefix) = 0) and Assigned(AField.TypeData.ElementFields) then
        APrefix := AField.TypeData.ElementFields.TypeData.Prefix;
      WriteSetItems(
          AField.FieldInstance<PLargestSet>(AInstance),
          AField.TypeData.TypeInfo,
          AField.TypeData.EnumType,
          APrefix,
          ANameFormat
      );
    end;
  finally
    AWriter.EndArray;
  end;
end;

procedure WriteIntValue(AInstance: Pointer; const AField: TQSerializeField);
begin
  if AField.TypeData.BaseType.Kind = tkInt64 then begin
    with AField.TypeData.BaseTypeData^ do
      AWriter.WritePair(AField.FormatedName, GetIntValue(AInstance, AField), MaxInt64Value < MinInt64Value)
  end
  else
    AWriter.WritePair(AField.FormatedName, GetIntValue(AInstance, AField));
end;

function CanSerialize(AInstance: Pointer): Boolean;
var
  bp: PQSerializeStackItem;
begin
  if Assigned(AInstance) then begin
    bp := @AStack;
    while Assigned(bp) do begin
      if (bp.Instance = AInstance) or ((bp.TypeInfo.Kind = tkClass) and (PPointer(bp.Instance)^ = AInstance)) then
        Exit(false);
      bp := bp.Prior;
    end;
    Result := true;
  end
  else
    Result := false;
end;
function NewStack(AType: PTypeInfo; AInstance: Pointer; AFields: PQSerializeFields): TQSerializeStackItem;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Instance := AInstance;
  Result.TypeInfo := AType;
  if not Assigned(AFields) then begin
    if AType.Kind = tkClass then
      AFields := Current.RegisterType(TObject(AInstance).ClassInfo)
    else
      AFields := Current.RegisterType(AType);
  end;
  Result.Fields := AFields;
  Result.Prior := @AStack;
end;

procedure WriteDynArrayItems(AInstance: Pointer; const ATypeData: TQSerializeTypeData);
var
  AElement: Pointer;
  I, ACount: Integer;
begin
  ACount := DynArraySize(AInstance);
  for I := 0 to ACount - 1 do begin
    AElement := PByte(AInstance) + ATypeData.ElementTypeData.elSize * I;
    if CanSerialize(AElement) then
      DoSerialize(AWriter, NewStack(ATypeData.ElementType, AElement, ATypeData.ElementFields));
  end;
end;

procedure WriteFixedArrayItems(AInstance: Pointer; const ATypeData: TQSerializeTypeData);
var
  AElement: Pointer;
  I, ACount: Integer;
begin
  ACount := ATypeData.BaseTypeData.ArrayData.ElCount - 1;
  for I := 0 to ACount - 1 do begin
    AElement := PByte(AInstance) + ATypeData.ElementTypeData.elSize * I;
    if CanSerialize(AElement) then
      DoSerialize(AWriter, NewStack(ATypeData.ElementType, AInstance, ATypeData.ElementFields));
  end;
end;

procedure WriteArrayValue(AInstance: Pointer; const AField: TQSerializeField);
begin
  if AField.TypeData.TypeInfo.Kind = tkDynArray then begin
    if Assigned(AField.TypeData.PropInfo) then
      AInstance := GetDynArrayProp(AInstance, AField.TypeData.PropInfo)
    else
      AInstance := AField.FieldInstance<PPointer>(AInstance)^;
    AWriter.StartArrayPair(AField.FormatedName);
    try
      WriteDynArrayItems(AInstance, AField.TypeData);
    finally
      AWriter.EndArray;
    end;
  end
  else if AField.TypeData.TypeInfo.Kind = tkArray then begin
    AWriter.StartArrayPair(AField.FormatedName);
    try
      WriteFixedArrayItems(AField.FieldInstance<Pointer>(AInstance), AField.TypeData);
    finally
      AWriter.EndArray;
    end;
  end;
end;

function WriteEnumerable(AObject: TObject; AField: PQSerializeField): Boolean;
var
  AClass: TClass;
  AContext: TRttiContext;
  AEnumeratorGetter, AMoveNext: TRttiMethod;
  AValueGetter: TRttiProperty;
  AEnumerator: TObject;
  AType: TRttiType;
  AValue: TValue;
begin
  Result := false;
  if Assigned(AObject) then begin
    AClass := AObject.ClassType;
    repeat
      if AClass.ClassName.StartsWith('TEnumerable<') and AClass.ClassName.EndsWith('>') then begin
        Result := true;
        if Assigned(AField) then
          AWriter.StartArrayPair(AField.FormatedName)
        else
          AWriter.StartArray;
        AContext := TRttiContext.Create;
        try
          AType := AContext.GetType(AObject.ClassInfo);
          if not Assigned(AType) then
            Exit;
          AEnumeratorGetter := AType.GetMethod('GetEnumerator');
          if not Assigned(AEnumeratorGetter) then
            Exit;
          AEnumerator := AEnumeratorGetter.Invoke(AObject, []).AsObject;
          if not Assigned(AEnumerator) then
            Exit;
          AType := AContext.GetType(AEnumerator.ClassInfo);
          if not Assigned(AType) then
            Exit;
          AMoveNext := AType.GetMethod('MoveNext');
          if not Assigned(AMoveNext) then
            Exit;
          AValueGetter := AType.GetProperty('Current');
          if not Assigned(AValueGetter) then
            Exit;
          // function MoveNext: Boolean;
          while AMoveNext.Invoke(AEnumerator, []).AsBoolean do begin
            AValue := AValueGetter.GetValue(AEnumerator);
            DoSerialize(AWriter, NewStack(AValue.TypeInfo, AValue.GetReferenceToRawData, nil));
          end;
        finally
          AWriter.EndArray;
        end;
        break;
      end
      else
        AClass := AClass.ClassParent;
    until not Assigned(AClass);
  end;
end;

function DateTimeToUnixMs(const AValue: TDateTime; AInputIsUTC: Boolean): Int64;
var
  LDate: TDateTime;
begin
  if AInputIsUTC then
    LDate := AValue
  else
    LDate := TTimeZone.Local.ToUniversalTime(AValue);
  Result := MilliSecondsBetween(UnixDateDelta, LDate);
  if LDate < UnixDateDelta then
    Result := -Result;
end;

function WriteDateTimeField(const ATime: TDateTime; const AField: TQSerializeField): string;
begin
  case AField.TypeData.DateTimeFormat of
    AutoDetect: begin
      if not IsZero(Frac(ATime)) then begin
        if Trunc(ATime) > 0 then
          AWriter.WritePair(AField.FormatedName, FormatDateTime('yyyy-mm-dd hh:nn:ss', ATime))
        else
          AWriter.WritePair(AField.FormatedName, FormatDateTime('hh:nn:ss', ATime));
      end
      else
        AWriter.WritePair(AField.FormatedName, FormatDateTime('yyyy-mm-dd', ATime));
    end;
    UnixTimeStamp: begin
      AWriter.WritePair(AField.FormatedName, DateTimeToUnix(ATime, false));
    end;
    UnixTimeStampMs: begin
      AWriter.WritePair(AField.FormatedName, DateTimeToUnixMs(ATime, false))
    end
  else
    begin
      AWriter.WritePair(AField.FormatedName, FormatDateTime(AField.TypeData.FormatText, ATime));
    end;
  end;
end;

function WriteDateTimeValue(const ATime: TDateTime; const ATypeData: TQSerializeTypeData): string;
begin
  case ATypeData.DateTimeFormat of
    AutoDetect: begin
      if not IsZero(Frac(ATime)) then begin
        if Trunc(ATime) > 0 then
          AWriter.WriteValue(FormatDateTime('yyyy-mm-dd hh:nn:ss', ATime))
        else
          AWriter.WriteValue(FormatDateTime('hh:nn:ss', ATime));
      end
      else
        AWriter.WriteValue(FormatDateTime('yyyy-mm-dd', ATime));
    end;
    UnixTimeStamp: begin
      AWriter.WriteValue(DateTimeToUnix(ATime, false));
    end;
    UnixTimeStampMs: AWriter.WriteValue(DateTimeToUnixMs(ATime, false))
  else
    AWriter.WriteValue(FormatDateTime(ATypeData.FormatText, ATime));
  end;
end;

function FindMapedValue(
    const AValues: TArray<TStringPair>;
    const AKey: UnicodeString;
    var AValue: UnicodeString
): Boolean;
var
  APair: TStringPair;
  AIndex: Integer;
begin
  APair.Key := AKey;
  Result := TArray.BinarySearch<TStringPair>(AValues, APair, AIndex, Current.FKeyComparer);
  if Result then
    AValue := AValues[AIndex].Value;
end;

function GetIdentValue(const AValue: Integer; const AField: TQSerializeField): UnicodeString;
begin
  if not AField.TypeData.IntToIdent(AValue, Result) then
    Result := IntToStr(AValue)
  else begin
    if Length(AField.KVMap) > 0 then // 如果用户指定了键值映射对，则按键值映射走
    begin
      if FindMapedValue(AField.KVMap, Result, Result) then
        Exit;
    end;
    if Length(AField.TypeData.Prefix) > 0 then
      Result := RemovePrefix(Result, AField.TypeData.Prefix, AField.TypeData.IdentFormat)
    else if Assigned(AField.Fields) and (Length(AField.Fields.TypeData.Prefix) > 0) then
      Result := RemovePrefix(Result, AField.Fields.TypeData.Prefix, AField.TypeData.IdentFormat);
  end;
end;

procedure WriteVarValue(const AValue: Variant);
var
  ATypeId: Word;
  ALo, AHi: Integer;
begin
  ATypeId := VarType(AValue);
  case ATypeId of
    varEmpty, varNull: AWriter.WriteNull;
    varSmallInt: AWriter.WriteValue(FindVarData(AValue).VSmallInt);
    varInteger: AWriter.WriteValue(FindVarData(AValue).VInteger);
    varShortInt: AWriter.WriteValue(FindVarData(AValue).VShortInt);
    varByte: AWriter.WriteValue(FindVarData(AValue).VByte);
    varWord: AWriter.WriteValue(FindVarData(AValue).VWord);
    varUInt32: AWriter.WriteValue(FindVarData(AValue).VUInt32);
    varInt64: AWriter.WriteValue(FindVarData(AValue).VInt64);
    varUInt64: AWriter.WriteValue(FindVarData(AValue).VUInt64);
    varSingle: AWriter.WriteValue(Extended(FindVarData(AValue).VSingle));
    varDouble: AWriter.WriteValue(Extended(FindVarData(AValue).VDouble));
    varCurrency: AWriter.WriteValue(FindVarData(AValue).VCurrency);
    varDate: AWriter.WriteValue(FindVarData(AValue).VDate);
    varOleStr, varString, varUString: AWriter.WriteValue(VarToStr(AValue));
    varBoolean: AWriter.WriteValue(Boolean(AValue))
  else
    begin
      if VarIsArray(AValue) then begin
        AHi := VarArrayHighBound(AValue, 1);
        AWriter.StartArray;
        try
          for ALo := VarArrayLowBound(AValue, 1) to AHi do
            WriteVarValue(AValue[ALo]);
        finally
          AWriter.EndArray;
        end;
      end
      else
        AWriter.WriteValue(VarToStr(AValue));
    end;
  end;
end;

procedure WriteVarPair(const AName: UnicodeString; const AValue: Variant);
var
  ATypeId: Word;
  ALo, AHi: Integer;
begin
  ATypeId := VarType(AValue);
  case ATypeId of
    varEmpty, varNull: AWriter.WritePair(AName);
    varSmallInt: AWriter.WritePair(AName, FindVarData(AValue).VSmallInt);
    varInteger: AWriter.WritePair(AName, FindVarData(AValue).VInteger);
    varShortInt: AWriter.WritePair(AName, FindVarData(AValue).VShortInt);
    varByte: AWriter.WritePair(AName, FindVarData(AValue).VByte);
    varWord: AWriter.WritePair(AName, FindVarData(AValue).VWord);
    varUInt32: AWriter.WritePair(AName, FindVarData(AValue).VUInt32);
    varInt64: AWriter.WritePair(AName, FindVarData(AValue).VInt64);
    varUInt64: AWriter.WritePair(AName, FindVarData(AValue).VUInt64);
    varSingle: AWriter.WritePair(AName, Extended(FindVarData(AValue).VSingle));
    varDouble: AWriter.WritePair(AName, Extended(FindVarData(AValue).VDouble));
    varCurrency: AWriter.WritePair(AName, FindVarData(AValue).VCurrency);
    varDate: AWriter.WritePair(AName, FindVarData(AValue).VDate);
    varOleStr, varString, varUString: AWriter.WritePair(AName, VarToStr(AValue));
    varBoolean: AWriter.WritePair(AName, Boolean(AValue))
  else
    begin
      if VarIsArray(AValue) then begin
        AHi := VarArrayHighBound(AValue, 1);
        AWriter.StartArray;
        try
          for ALo := VarArrayLowBound(AValue, 1) to AHi do
            WriteVarValue(AValue[ALo]);
        finally
          AWriter.EndArray;
        end;
      end
      else
        AWriter.WriteValue(VarToStr(AValue));
    end;
  end;
end;
procedure WriteCollection(ACollection: TCollection; AField: PQSerializeField);
var
  ASubFields: PQSerializeFields;
  AChildInstance: TObject;
  I: Integer;
begin
  if Assigned(AField) then
    AWriter.StartArrayPair(AField.FormatedName)
  else
    AWriter.StartArray;
  try
    ASubFields := Current.Find(ACollection.ItemClass.ClassInfo);
    for I := 0 to ACollection.Count - 1 do begin
      AChildInstance := ACollection.Items[I];
      if CanSerialize(AChildInstance) then begin
        if TObject(AChildInstance).ClassType = ACollection.ItemClass then
          DoSerialize(AWriter, NewStack(TObject(AChildInstance).ClassInfo, @AChildInstance, ASubFields))
        else
          DoSerialize(AWriter, NewStack(TObject(AChildInstance).ClassInfo, @AChildInstance, nil));
      end;
    end;
  finally
    AWriter.EndArray;
  end;
end;

procedure WriteRecord(AInstance: Pointer; AType: PTypeInfo; AField: PQSerializeField);
var
  I: Integer;
begin
  if AType = TypeInfo(TBcd) then begin
    if Assigned(AField) then
      AWriter.WritePair(AField.FormatedName, PBcd(AInstance)^)
    else
      AWriter.WriteValue(PBcd(AInstance)^);
  end
  else if AType = TypeInfo(TGuid) then begin
    if Assigned(AField) then
      AWriter.WritePair(AField.FormatedName, GuidToString(PGuid(AInstance)^))
    else
      AWriter.WriteValue(GuidToString(PGuid(AInstance)^));
  end
  else if AType = TypeInfo(TValue) then begin
    if Assigned(AField) then
      WriteField(AInstance, AField^, PValue(AInstance).TypeInfo.Kind)
    else
      ;
  end
  else if Assigned(AField) then begin
    if Assigned(AField.Fields) then begin
      AWriter.StartObjectPair(AField.FormatedName);
      try
        for I := 0 to High(AField.Fields.Fields) do
          WriteField(AInstance, AField.Fields.Fields[I], AField.Fields.Fields[I].TypeData.TypeInfo.Kind);
      finally
        AWriter.EndObject;
      end;
    end;
  end
  else if Assigned(AStack.Fields) then begin
    AWriter.StartObject;
    try
      for I := 0 to High(AStack.Fields.Fields) do
        WriteField(AInstance, AStack.Fields.Fields[I], AStack.Fields.Fields[I].TypeData.TypeInfo.Kind);
    finally
      AWriter.EndObject;
    end;
  end;
end;

procedure WriteObject(AObject: TObject; AField: PQSerializeField);
var
  I: Integer;
begin
  // TStrings/TCollection/TEnumerator<T>的子类当做数组初始化
  if Assigned(AObject) then begin
    if AObject is TStrings then begin
      if Assigned(AField) then begin
        if AField.ForceAsString then begin
          AWriter.WritePair(AField.FormatedName, TStrings(AObject).Text);
          Exit;
        end;
        AWriter.StartArrayPair(AField.FormatedName);
      end
      else
        AWriter.StartArray;
      try
        for I := 0 to TStrings(AObject).Count - 1 do
          AWriter.WriteValue(TStrings(AObject).Strings[I]);
      finally
        AWriter.EndArray;
      end;
    end
    else if AObject is TCollection then
      WriteCollection(TCollection(AObject), AField)
    else if not WriteEnumerable(AObject, nil) then begin
      AWriter.StartObject;
      if Assigned(AStack.Fields) then begin
        for I := 0 to High(AStack.Fields.Fields) do begin
          WriteField(AObject, AStack.Fields.Fields[I], AStack.Fields.Fields[I].TypeData.TypeInfo.Kind);
        end;
      end;
      AWriter.EndObject;
    end;
  end;
end;

procedure WriteInterface(const AIntf: IInterface; const AField: PQSerializeField);
var
  I: Integer;
  AFieldInstance: Pointer;
begin
  if Assigned(AIntf) then begin
    if Assigned(AField) then
      AWriter.StartObjectPair(AField.FormatedName)
    else
      AWriter.StartObject;
    try
      for I := 0 to High(AField.Fields.Fields) do begin
        with AField.Fields.Fields[I] do begin
          AFieldInstance := FieldInstance<Pointer>(AIntf);
          if CanSerialize(AFieldInstance) then
            DoSerialize(AWriter, NewStack(TypeData.TypeInfo, AFieldInstance, Fields));
        end;
      end;
    finally
      AWriter.EndObject;
    end;
  end;
end;

procedure WriteField(AInstance: Pointer; const AField: TQSerializeField; const AKind: TTypeKind);
var
  AFieldInstance: Pointer;
begin
  case AKind of
    tkInteger: begin
      if Assigned(AField.TypeData.IntToIdent) then
        AWriter.WritePair(AField.FormatedName, GetIdentValue(GetIntValue(AInstance, AField), AField))
      else
        AWriter.WritePair(AField.FormatedName, GetIntValue(AInstance, AField));
    end;
    tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
      AWriter.WritePair(AField.FormatedName, GetStrValue(AInstance, AField));
    tkEnumeration:
      if AField.TypeData.EnumAsInt then
        AWriter.WritePair(AField.FormatedName, GetIntValue(AInstance, AField))
      else if IsBoolType(AField.TypeData.TypeInfo) then
        AWriter.WritePair(AField.FormatedName, GetBooleanValue(AInstance, AField))
      else
        AWriter.WritePair(AField.FormatedName, GetEnumValue(AInstance, AField));
    tkFloat: begin
      if AField.TypeData.BaseTypeData.FloatType = ftCurr then begin
        AWriter.WritePair(AField.FormatedName, GetCurrValue(AInstance, AField))
      end
      else if (AField.TypeData.BaseType = TypeInfo(TDateTime))
          or (AField.TypeData.BaseType = TypeInfo(TDate))
          or (AField.TypeData.BaseType = TypeInfo(TTime)) then
        WriteDateTimeField(GetFloatValue(AInstance, AField), AField)
      else
        AWriter.WritePair(AField.FormatedName, GetFloatValue(AInstance, AField), AField.TypeData.FormatText);
    end;
    tkSet: WriteSetValue(AInstance, AField);
    tkClass: begin
      AFieldInstance := GetObjectValue(AInstance, AField);
      if CanSerialize(AFieldInstance) then
        WriteObject(AFieldInstance, @AField);
    end;
    tkVariant: WriteVarPair(AField.FormatedName, AField.FieldInstance<PVariant>(AInstance)^);
    tkArray, tkDynArray: WriteArrayValue(AInstance, AField);
    tkRecord: begin
      AFieldInstance := AField.FieldInstance<Pointer>(AInstance);
      if CanSerialize(AFieldInstance) then
        WriteRecord(AFieldInstance, AField.TypeData.TypeInfo, @AField);
    end;
    tkInterface: begin
      AFieldInstance := nil;
      IInterface(AFieldInstance) := GetInterfaceProp(AInstance, AField.TypeData.PropInfo);
      if CanSerialize(AFieldInstance) then
        WriteInterface(IInterface(AFieldInstance), @AField);
    end;
    tkInt64:
      AWriter.WritePair(
          AField.FormatedName,
          GetIntValue(AInstance, AField),
          AField.TypeData.BaseTypeData.MinInt64Value > AField.TypeData.BaseTypeData.MaxInt64Value
      );
    tkClassRef: begin
      S := TClass(AInstance).ClassName;
      if S.StartsWith('T') then
        S := S.Substring(1);
      AWriter.WritePair(AField.FormatedName, S);
    end;
    tkPointer, tkProcedure, tkMRecord:
      // 无类型指针，没法处理，忽略
          ;
  end;
end;

function GetVarValue(AInstance: Pointer; const AField: TQSerializeField): Variant;
begin
  if Assigned(AField.TypeData.PropInfo) then
    Result := GetVariantProp(AInstance, AField.TypeData.PropInfo)
  else
    Result := PVariant(AInstance)^;
end;

procedure WriteValue;
begin
  if Assigned(AStack.Fields) and Assigned(AStack.Fields.CustomSerializer) then
    AStack.Fields.CustomSerializer.Write(AWriter, @AStack, nil)
  else begin
    case AStack.TypeInfo.Kind of
      tkInteger: AWriter.WriteValue(GetOrdInstanceValue(AStack.Instance, AStack.Fields.TypeData.BaseTypeData.OrdType));
      tkChar: AWriter.WriteValue(UnicodeString(WideChar(PByte(AStack.Instance)^)));
      tkEnumeration: begin
        if Assigned(AStack.Fields) then begin
          if IsBoolType(AStack.Fields.TypeData.TypeInfo) then
            AWriter.WriteValue(GetOrdInstanceValue(AStack.Instance, AStack.Fields.TypeData.TypeData.OrdType))
          else if AStack.Fields.TypeData.EnumAsInt then
            AWriter.WriteValue(GetOrdInstanceValue(AStack.Instance, AStack.Fields.TypeData.BaseTypeData.OrdType))
          else
            AWriter.WriteValue(
                RemovePrefix(
                    GetEnumName(
                        AStack.TypeInfo,
                        GetOrdInstanceValue(AStack.Instance, AStack.Fields.TypeData.BaseTypeData.OrdType)
                    ),
                    AStack.Fields.TypeData.Prefix,
                    AStack.Fields.TypeData.IdentFormat
                )
            );
        end
        else
          AWriter.WriteValue(
              GetEnumName(
                  AStack.TypeInfo,
                  GetOrdInstanceValue(AStack.Instance, AStack.Fields.TypeData.BaseTypeData.OrdType)
              )
          );
      end;
      tkFloat: begin
        if (AStack.TypeInfo = TypeInfo(TDateTime))
            or (AStack.TypeInfo = TypeInfo(TDate))
            or (AStack.TypeInfo = TypeInfo(TTime)) then
          WriteDateTimeValue(PDateTime(AStack.Instance)^, AStack.Fields.TypeData)
        else begin
          case AStack.Fields.TypeData.BaseTypeData.FloatType of
            ftSingle: AWriter.WriteValue(PSingle(AStack.Instance)^, AStack.Fields.TypeData.FormatText);
            ftDouble: AWriter.WriteValue(PDouble(AStack.Instance)^, AStack.Fields.TypeData.FormatText);
            ftExtended: AWriter.WriteValue(PExtended(AStack.Instance)^, AStack.Fields.TypeData.FormatText);
            ftComp: AWriter.WriteValue(Extended(PComp(AStack.Instance)^), AStack.Fields.TypeData.FormatText);
            ftCurr: AWriter.WriteValue(PCurrency(AStack.Instance)^, AStack.Fields.TypeData.FormatText);
          end;
        end;
      end;
      tkString: AWriter.WriteValue(UnicodeString(PShortString(AStack.Instance)^));
      tkSet: begin
        AWriter.StartArray;
        if Assigned(AStack.Fields) then
          WriteSetItems(
              PLargestSet(AStack.Instance),
              AStack.Fields.TypeData.TypeInfo,
              AStack.Fields.TypeData.EnumType,
              AStack.Fields.TypeData.Prefix,
              AStack.Fields.TypeData.IdentFormat
          );
        AWriter.EndArray;
      end;
      tkRecord, tkMRecord: WriteRecord(AStack.Instance, AStack.TypeInfo, nil);
      tkClass: WriteObject(TObject(PPointer(AStack.Instance)^), nil);
      tkInterface: WriteInterface(IInterface(AStack.Instance), nil);
      tkWChar: AWriter.WriteValue(UnicodeString(PWideChar(AStack.Instance)^));
      tkLString: AWriter.WriteValue(UnicodeString(PAnsiString(AStack.Instance)^));
      tkWString: AWriter.WriteValue(PWideString(AStack.Instance)^);
      tkVariant: WriteVarValue(PVariant(AStack.Instance)^);
      tkArray: begin
        AWriter.StartArray;
        try
          WriteFixedArrayItems(AStack.Instance, AStack.Fields.TypeData);
        finally
          AWriter.EndArray;
        end;
      end;
      tkInt64: begin
        if AStack.TypeInfo.TypeData.MinInt64Value > AStack.TypeInfo.TypeData.MaxInt64Value then
          AWriter.WriteValue(PUInt64(AStack.Instance)^)
        else
          AWriter.WriteValue(PInt64(AStack.Instance)^);
      end;
      tkDynArray: begin
        AWriter.StartArray;
        try
          WriteDynArrayItems(PPointer(AStack.Instance)^, AStack.Fields.TypeData);
        finally
          AWriter.EndArray;
        end;
      end;
      tkUString: AWriter.WriteValue(PUnicodeString(AStack.Instance)^);
      tkClassRef: begin
        // 类
        if Assigned(PPointer(AStack.Instance)^) then begin
          S := TClass(PPointer(AStack.Instance)^).ClassName;
          if S.StartsWith('T') then
            S := S.Substring(1);
          AWriter.WriteValue(S);
        end;
      end;
    end;
  end;
end;

begin
  if not Assigned(AStack.Instance) then
    Exit;
  WriteValue;
end;

function TQSerializer.Find(AType: PTypeInfo): PQSerializeFields;
begin
  TMonitor.Enter(Self);
  try
    if not FCachedTypes.TryGetValue(AType, Result) then begin
      Result := DoRegister(AType);
    end;
  finally
    TMonitor.Exit(Self);
  end;
end;

class function TQSerializer.FormatName(const S: UnicodeString; const AFormat: TSerializeNameFormat): UnicodeString;
const
  LC_UPPER = 1;
  LC_LOWER = 2;
  LC_UNDERLINE = 4;
  LC_OTHER = 8;
  procedure SkipIfUnderline(var pd, p: PWideChar);
  begin
    if p^ = '_' then begin
      while p^ = '_' do
        Inc(p);
      if not p^.IsLetter then begin
        pd^ := '_';
        Inc(pd);
      end;
    end;
  end;

  procedure TrimTailUnderline(const ps: PWideChar; var pd: PWideChar);
  begin
    while pd > ps do begin
      Dec(pd);
      if pd^ <> '_' then begin
        Inc(pd);
        break;
      end;
    end;
  end;

  function CharType(c: WideChar): Byte;
  begin
    if c.IsUpper then
      Result := LC_UPPER
    else if c.IsLower then
      Result := LC_LOWER
    else if c = '_' then
      Result := LC_UNDERLINE
    else
      Result := LC_OTHER;
  end;

  function CopyUntil(var pd, p: PWideChar; AStopBits: Byte): Boolean;
  begin
    while (p^ <> #0) and ((CharType(p^) and AStopBits) = 0) do begin
      pd^ := p^;
      Inc(pd);
      if p^ = '_' then begin
        while p^ = '_' do
          Inc(p);
      end
      else
        Inc(p);
    end;
    Result := p^ <> #0;
  end;

  function DoLowerCamel: UnicodeString;
  var
    p, pd: PWideChar;
  begin
    SetLength(Result, Length(S));
    p := PWideChar(S);
    pd := PWideChar(Result);
    SkipIfUnderline(pd, p);
    if CopyUntil(pd, p, LC_UPPER or LC_LOWER) then begin
      if p^.IsUpper then begin
        pd^ := p^.ToLower;
        Inc(p);
        Inc(pd);
      end;
      while p^ <> #0 do begin
        if not p^.IsLetter then begin
          while p^ = '_' do
            Inc(p);
          if p^.IsLower then begin
            pd^ := p^.ToUpper;
            Inc(pd);
            Inc(p);
            continue;
          end;
        end;
        pd^ := p^;
        Inc(pd);
        Inc(p);
      end;
    end;
    TrimTailUnderline(PWideChar(Result), pd);
    SetLength(Result, pd - PWideChar(Result));
  end;

  function DoUpperCamel: UnicodeString;
  var
    p, pd: PWideChar;
  begin
    SetLength(Result, Length(S));
    p := PWideChar(S);
    pd := PWideChar(Result);
    SkipIfUnderline(pd, p);
    if CopyUntil(pd, p, LC_UPPER or LC_LOWER) then begin
      if p^.IsLower then begin
        pd^ := p^.ToUpper;
        Inc(p);
        Inc(pd);
      end;
      while p^ <> #0 do begin
        if not p^.IsLetter then begin
          while p^ = '_' do
            Inc(p);
          if p^.IsLower then begin
            pd^ := p^.ToUpper;
            Inc(pd);
            Inc(p);
            continue;
          end;
        end;
        pd^ := p^;
        Inc(pd);
        Inc(p);
      end;
    end;
    TrimTailUnderline(PWideChar(Result), pd);
    SetLength(Result, pd - PWideChar(Result));
  end;

  procedure CopyOthers(var pd, ps: PWideChar);
  begin
    while not (ps^.IsLetter or (ps^ = '_')) do begin
      pd^ := ps^;
      Inc(pd);
      Inc(ps);
    end;
  end;

  function DoUnderline: UnicodeString;
  var
    p, ps, pd: PWideChar;
    ALastType: Byte;
  begin
    SetLength(Result, Length(S) shl 1);
    p := PWideChar(S);
    pd := PWideChar(Result);
    SkipIfUnderline(pd, p);
    CopyOthers(pd, p);
    ps := p;
    ALastType := CharType(p^);
    // AbcDef -> Abc_Def,abcDef-> abc_Def, abc___def -> abc_def
    while p^ <> #0 do begin
      if p^.IsLetter then begin
        if p = ps then begin
          pd^ := p^;
          Inc(pd);
          Inc(p);
          ALastType := CharType(p^);
          continue;
        end
        else if p^.IsUpper and (ALastType = LC_LOWER) then begin
          pd^ := '_';
          Inc(pd);

          pd^ := p^;
          Inc(pd);
          Inc(p);

          ALastType := CharType(p^);
          ps := p;
          continue;
        end
        else if p^.IsLower and (ALastType = LC_UPPER) then begin
          pd^ := '_';
          Inc(pd);

          pd^ := p^;
          Inc(pd);
          Inc(p);

          ALastType := CharType(p^);
          ps := p;
          continue;
        end;
      end
      else if p^ = '_' then begin
        ALastType := LC_UNDERLINE;
        while p^ = '_' do
          Inc(p);
        pd^ := '_';
        Inc(pd);
        ps := p;
        continue;
      end;
      pd^ := p^;
      ALastType := CharType(p^);
      Inc(pd);
      Inc(p);
    end;
    TrimTailUnderline(PWideChar(Result), pd);
    SetLength(Result, pd - PWideChar(Result));
  end;

  function DoUpperUnderline: UnicodeString;
  begin
    Result := DoUnderline.ToUpper;
  end;

  function DoLowerUnderline: UnicodeString;
  begin
    Result := DoUnderline.ToLower;
  end;

  function MergeUnderline(const S: UnicodeString): UnicodeString;
  var
    p, pd: PWideChar;
  begin
    SetLength(Result, Length(S));
    p := PWideChar(S);
    pd := PWideChar(Result);
    SkipIfUnderline(pd, p);
    while p^ <> #0 do begin
      if p^ = '_' then begin
        while p^ = '_' do
          Inc(p);
        pd^ := '_';
      end
      else begin
        pd^ := p^;
        Inc(p);
      end;
      Inc(pd);
    end;
    TrimTailUnderline(PWideChar(Result), pd);
    SetLength(Result, pd - PWideChar(Result));
  end;

begin
  case AFormat of
    LowerCamel: Result := DoLowerCamel;
    UpperCamel: Result := DoUpperCamel;
    Underline: Result := DoUnderline;
    UpperCase: Result := MergeUnderline(S).ToUpper;
    LowerCase: Result := MergeUnderline(S).ToLower;
    UpperCaseUnderline: Result := DoUpperUnderline;
    LowerCaseUnderline: Result := DoLowerUnderline
  else
    Result := S;
  end;
end;

class procedure TQSerializer.FromRtti<T>(AWriter: IQSerializeWriter; const AInstance: T);
var
  AStack: TQSerializeStackItem;
begin
  FillChar(AStack, SizeOf(AStack), 0);
  AStack.Instance := @AInstance;
  AStack.TypeInfo := TypeInfo(T);
  AStack.Fields := Current.Find(AStack.TypeInfo);
  Current.DoSerialize(AWriter, AStack);
  AWriter.Flush;
end;

class function TQSerializer.ReadRawPair(
    AReader: IQSerializeReader;
    out AName: UnicodeString;
    out ABytes: TBytes
): Boolean;
var
  ABinaryReader: IQBinarySerializeReader;
begin
  if not Supports(AReader, IQBinarySerializeReader, ABinaryReader) then
    raise Exception.CreateFmt(SSerializeRawReaderNotSupport, ['二进制']);
  Result := ABinaryReader.ReadRawPair(AName, ABytes);
end;

class function TQSerializer.ReadRawPair(
    AReader: IQSerializeReader;
    out AName, AText: UnicodeString
): Boolean;
var
  ATextReader: IQTextSerializeReader;
begin
  if not Supports(AReader, IQTextSerializeReader, ATextReader) then
    raise Exception.CreateFmt(SSerializeRawReaderNotSupport, ['文本']);
  Result := ATextReader.ReadRawPair(AName, AText);
end;

class procedure TQSerializer.ReadRawValue(AReader: IQSerializeReader; out ABytes: TBytes);
var
  ABinaryReader: IQBinarySerializeReader;
begin
  if not Supports(AReader, IQBinarySerializeReader, ABinaryReader) then
    raise Exception.CreateFmt(SSerializeRawReaderNotSupport, ['二进制']);
  ABinaryReader.ReadRawValue(ABytes);
end;

class procedure TQSerializer.ReadRawValue(AReader: IQSerializeReader; out AText: UnicodeString);
var
  ATextReader: IQTextSerializeReader;
begin
  if not Supports(AReader, IQTextSerializeReader, ATextReader) then
    raise Exception.CreateFmt(SSerializeRawReaderNotSupport, ['文本']);
  ATextReader.ReadRawValue(AText);
end;

class procedure TQSerializer.WriteRawPair(
    AWriter: IQSerializeWriter;
    const AName: UnicodeString;
    const ABytes: TBytes
);
var
  ABinaryWriter: IQBinarySerializeWriter;
begin
  if not Supports(AWriter, IQBinarySerializeWriter, ABinaryWriter) then
    raise Exception.CreateFmt(SSerializeRawWriterNotSupport, ['二进制']);
  ABinaryWriter.WriteRawPair(AName, ABytes);
end;

class procedure TQSerializer.WriteRawPair(
    AWriter: IQSerializeWriter;
    const AName, AText: UnicodeString
);
var
  ATextWriter: IQTextSerializeWriter;
begin
  if not Supports(AWriter, IQTextSerializeWriter, ATextWriter) then
    raise Exception.CreateFmt(SSerializeRawWriterNotSupport, ['文本']);
  ATextWriter.WriteRawPair(AName, AText);
end;

class procedure TQSerializer.WriteRawValue(AWriter: IQSerializeWriter; const ABytes: TBytes);
var
  ABinaryWriter: IQBinarySerializeWriter;
begin
  if not Supports(AWriter, IQBinarySerializeWriter, ABinaryWriter) then
    raise Exception.CreateFmt(SSerializeRawWriterNotSupport, ['二进制']);
  ABinaryWriter.WriteRawValue(ABytes);
end;

class procedure TQSerializer.WriteRawValue(AWriter: IQSerializeWriter; const AText: UnicodeString);
var
  ATextWriter: IQTextSerializeWriter;
begin
  if not Supports(AWriter, IQTextSerializeWriter, ATextWriter) then
    raise Exception.CreateFmt(SSerializeRawWriterNotSupport, ['文本']);
  ATextWriter.WriteRawValue(AText);
end;

class function TQSerializer.GetCurrent: TQSerializer;
  procedure CreateInstance;
  var
    ATemp: TQSerializer;
  begin
    ATemp := TQSerializer.Create;
    if System.AtomicCmpExchange(Pointer(FCurrent), Pointer(ATemp), nil) <> nil then
      FreeAndNil(ATemp);
  end;

begin
  if not Assigned(FCurrent) then
    CreateInstance;
  Result := FCurrent;
end;

function TQSerializer.InternalRegisterType(AType: PTypeInfo): PQSerializeFields;
var
  ARttiType: TRttiType;
  ARttiFields: TArray<TRttiField>;
  Attrs: TArray<TCustomAttribute>;
  Attr: TCustomAttribute;
  ASerializeFields: PQSerializeFields;
  AExcludeFields: TArray<UnicodeString>;
  AFieldIndex, AttrIndex, ACount: Integer;
  AIncludeProps: Boolean;

  function GetBaseType(AType: PTypeInfo): PTypeInfo;
  var
    ATypeData: PTypeData;
  begin
    Result := AType;
    if AType.Kind = tkEnumeration then begin
      repeat
        ATypeData := GetTypeData(Result);
        if Assigned(ATypeData.BaseType) and Assigned(ATypeData.BaseType^) and (Result <> ATypeData.BaseType^) then
          Result := ATypeData.BaseType^
        else
          break;
      until 1 > 2;
    end;
  end;

  procedure RegisterIfNeeded(AChildType: PTypeInfo; var AFields: PQSerializeFields);
  begin
    if not FCachedTypes.TryGetValue(AChildType, AFields) then
      AFields := InternalRegisterType(AChildType);
  end;

  function IsMemberWritable(AMember: TRttiMember): Boolean;
  begin
    if AMember is TRttiProperty then
      Result := TRttiProperty(AMember).IsWritable
    else if AMember is TRttiField then
      Result := True
    else
      Result := False;
  end;

  function AddRttiField(var AResult: TQSerializeField; AField: TRttiMember): Boolean;
  var
    I: Integer;
    AFieldType: TRttiType;
  begin
    Result := false;
    if AField is TRttiField then begin
      AResult.TypeData.PropInfo := nil;
      AFieldType := TRttiField(AField).FieldType;
    end
    else if AField is TRttiInstanceProperty then begin
      AResult.TypeData.PropInfo := TRttiInstanceProperty(AField).PropInfo;
      AFieldType := TRttiProperty(AField).PropertyType;
    end
    else
      Exit;
    // 如果找不到对应的成员类型信息，如 TOrderFlags=set of 0..5 这种定义，TypeInfo(TOrderFlags) 找不到，我们忽略
    if not Assigned(AFieldType) then
      Exit;
    if (IsMemberWritable(AField)) and (not (AFieldType.TypeKind in [tkUnknown, tkMethod, tkPointer, tkProcedure])) then
    begin
      for I := 0 to High(AExcludeFields) do begin
        if CompareText(AExcludeFields[I], AField.Name) = 0 then
          Exit;
      end;
      Attrs := AField.GetAttributes;
      for I := 0 to High(Attrs) do begin
        Attr := Attrs[I];
        if Attr is AliasAttribute then begin
          AResult.Names := AResult.Names + AliasAttribute(Attr).Values;
        end
        else if Attr is PathAttribute then begin
          AResult.Pathes := AResult.Pathes + [PathAttribute(Attr).Path];
        end
        else if Attr is IncludePropsAttribute then
          AIncludeProps := true
        else if Attr is DateTimeFormatAttribute then begin
          AResult.TypeData.DateTimeFormat := DateTimeFormatAttribute(Attr).Format;
          AResult.TypeData.FormatText := DateTimeFormatAttribute(Attr).FormatText;
          case AResult.TypeData.DateTimeFormat of
            AutoDetect:;
            DateTimeString: begin
              if Length(AResult.TypeData.FormatText) = 0 then
                AResult.TypeData.FormatText := 'yyyy-mm-dd hh:nn:ss';
            end;
            UnixTimeStamp:;
            DateString: begin
              if Length(AResult.TypeData.FormatText) = 0 then
                AResult.TypeData.FormatText := 'yyyy-mm-dd';
            end;
            TimeString: begin
              if Length(AResult.TypeData.FormatText) = 0 then
                AResult.TypeData.FormatText := 'hh:nn:ss';
            end;
          end;
        end
        else if Attr is FloatFormatAttribute then
          AResult.TypeData.FormatText := FloatFormatAttribute(Attr).FormatText
        else if Attr is PrefixAttribute then
          AResult.TypeData.Prefix := PrefixAttribute(Attr).Prefix
        else if Attr is EnumAsIntAttribute then
          AResult.TypeData.EnumAsInt := true
        else if Attr is IdentMapAttribute then begin
          AResult.KVMap :=
              AResult.KVMap + [TStringPair.Create(IdentMapAttribute(Attr).Key, IdentMapAttribute(Attr).Value)];
        end
        else if Attr is NameAttribute then
          AResult.FormatedName := NameAttribute(Attr).Name
        else if Attr is ForceAsStringAttribute then
          AResult.ForceAsString := true
        else if Attr is ExcludeAttribute then
          Exit;
      end;
      case AFieldType.TypeKind of
        tkClass, tkRecord, tkMRecord, tkInterface: begin
          if (AFieldType.Handle <> TypeInfo(TBcd))
              and (AFieldType.Handle <> TypeInfo(TValue))
              and (AFieldType.Handle <> TypeInfo(TGuid)) then // Bcd不需要处理
            RegisterIfNeeded(AFieldType.Handle, AResult.Fields);
        end;
        tkArray: begin
          var AArrType := FRttiContext.GetType(AFieldType.Handle) as TRttiArrayType;
          if Assigned(AArrType) and Assigned(AArrType.ElementType) then
            AResult.TypeData.ElementType := AArrType.ElementType.Handle;
          if Assigned(AResult.TypeData.ElementType) then begin
            RegisterIfNeeded(AResult.TypeData.ElementType, AResult.TypeData.ElementFields);
            AResult.TypeData.ElementTypeData := GetTypeData(AResult.TypeData.ElementType);
          end;
        end;
        tkDynArray: begin
          AResult.TypeData.ElementType := GetTypeData(AFieldType.Handle).DynArrElType^;
          if Assigned(AResult.TypeData.ElementType) then begin
            RegisterIfNeeded(AResult.TypeData.ElementType, AResult.TypeData.ElementFields);
            AResult.TypeData.ElementTypeData := GetTypeData(AResult.TypeData.ElementType);
          end;
        end;
      end;
      if not Assigned(AResult.TypeData.PropInfo) then
        AResult.Offset := TRttiField(AField).Offset;
      AResult.Size := AFieldType.TypeSize;
      if Length(AResult.FormatedName) = 0 then
        AResult.FormatedName := FormatName(AField.Name, ASerializeFields.TypeData.NameFormat);
      AResult.Names := [AField.Name];
      if AResult.FormatedName <> AField.Name then
        AResult.Names := [AResult.FormatedName] + AResult.Names;
      AResult.TypeData.TypeInfo := AFieldType.Handle;
      AResult.TypeData.TypeData := GetTypeData(AResult.TypeData.TypeInfo);
      case AResult.TypeData.TypeInfo.Kind of
        tkEnumeration: begin
          AResult.TypeData.BaseType := GetBaseType(AResult.TypeData.TypeInfo);
          AResult.TypeData.BaseTypeData := GetTypeData(AResult.TypeData.BaseType);
        end;
        tkSet: begin
          if Assigned(AResult.TypeData.TypeData.CompType) then begin
            AResult.TypeData.EnumType := AResult.TypeData.TypeData.CompType^;
            if Assigned(AResult.TypeData.EnumType) then begin
              AResult.TypeData.EnumTypeData := GetTypeData(AResult.TypeData.EnumType);
              RegisterIfNeeded(AResult.TypeData.EnumType, AResult.TypeData.ElementFields);
            end;
          end;
        end
      else
        begin
          if not (AFieldType.Handle.Kind in [tkArray, tkDynArray]) then begin
            AResult.TypeData.BaseType := AResult.TypeData.TypeInfo;
            AResult.TypeData.BaseTypeData := AResult.TypeData.TypeData;
            if (AResult.TypeData.TypeInfo.Kind = tkInteger) and (AResult.TypeData.TypeInfo <> TypeInfo(Integer)) then
            begin
              AResult.TypeData.IdentToInt := FindIdentToInt(AResult.TypeData.TypeInfo);
              AResult.TypeData.IntToIdent := FindIntToIdent(AResult.TypeData.TypeInfo);
            end
          end;
        end;
      end;
      if Length(AResult.KVMap) > 0 then begin
        AResult.VKMap := Copy(AResult.KVMap);
        TArray.Sort<TStringPair>(AResult.KVMap, FKeyComparer);
        TArray.Sort<TStringPair>(AResult.VKMap, FValueComparer);
      end;
      Result := true;
    end;
  end;

  procedure AddProps;
  var
    AProps: TArray<TRttiProperty>;
    APropIndex: Integer;
  begin
    AProps := ARttiType.GetProperties;
    SetLength(Result.Fields, Length(Result.Fields) + Length(AProps));
    for APropIndex := 0 to High(AProps) do begin
      if AddRttiField(Result.Fields[ACount], AProps[APropIndex]) then
        Inc(ACount);
    end;
  end;

begin
  if Assigned(AType) then begin
    New(Result);
    FillChar(Result^, sizeof(TQSerializeFields), 0);
    Result.TypeData.TypeInfo := AType;
    Result.TypeData.TypeData := GetTypeData(AType);
    if AType.Kind = tkEnumeration then begin
      Result.TypeData.BaseType := GetBaseType(AType);
      Result.TypeData.BaseTypeData := GetTypeData(Result.TypeData.BaseType);
    end
    else begin
      Result.TypeData.BaseType := AType;
      Result.TypeData.BaseTypeData := Result.TypeData.TypeData;
    end;
    Result.TypeData.PropInfo := nil;
    FCachedTypes.Add(AType, Result);
    if AType.Kind = tkArray then begin
      if Assigned(Result.TypeData.BaseTypeData.elType) and Assigned(Result.TypeData.BaseTypeData.elType^) then
        Result.TypeData.ElementType := Result.TypeData.BaseTypeData.elType^
      else if Assigned(Result.TypeData.TypeData.elType2) and Assigned(Result.TypeData.BaseTypeData.elType2^) then
        Result.TypeData.ElementType := Result.TypeData.BaseTypeData.elType2^
      else
        Exit;
      Result.TypeData.ElementTypeData := GetTypeData(Result.TypeData.ElementType);
      RegisterIfNeeded(Result.TypeData.ElementType, Result.TypeData.ElementFields);
    end
    else if AType.Kind = tkDynArray then begin
      if Result.TypeData.TypeData.DynArrElType <> nil then
        Result.TypeData.ElementType := Result.TypeData.TypeData.DynArrElType^;
      if Assigned(Result.TypeData.ElementType) then begin
        Result.TypeData.ElementTypeData := GetTypeData(Result.TypeData.ElementType);
        RegisterIfNeeded(Result.TypeData.ElementType, Result.TypeData.ElementFields);
      end;
    end
    else if AType.Kind = tkSet then begin
      if Assigned(Result.TypeData.TypeData.CompType) then
        Result.TypeData.EnumType := Result.TypeData.TypeData.CompType^
      else
        Result.TypeData.EnumType := nil;
      if Assigned(Result.TypeData.EnumType) then begin
        Result.TypeData.EnumTypeData := GetTypeData(Result.TypeData.EnumType);
        RegisterIfNeeded(Result.TypeData.TypeInfo, Result.TypeData.ElementFields);
      end;
    end
    else if AType.Kind = tkInteger then begin
      Result.TypeData.IdentToInt := FindIdentToInt(AType);
      Result.TypeData.IntToIdent := FindIntToIdent(AType);
    end
    else if AType.Kind in [tkRecord, tkClass, tkInterface, tkMRecord] then begin
      // Reserved types:TBcd as float number,TValue refer to realtype,TStrings treat as string array,TGuid as string
      if (AType = TypeInfo(TBcd))
          or (AType = TypeInfo(TValue))
          or (AType = TypeInfo(TGuid))
          or (AType = TypeInfo(TStrings)) then
        Exit;
      ARttiType := FRttiContext.GetType(AType);
      if not Assigned(ARttiType) then
        Exit(nil);
      ASerializeFields := Result;
      AIncludeProps := False;
      Attrs := ARttiType.GetAttributes;
      for AttrIndex := 0 to High(Attrs) do begin
        Attr := Attrs[AttrIndex];
        if Attr is NameFormatAttribute then
          Result.TypeData.NameFormat := NameFormatAttribute(Attr).NameFormat
        else if Attr is ExcludeFieldsAttribute then
          // 记录排除的字段
          AExcludeFields := ExcludeFieldsAttribute(Attr).Values
        else if Attr is IncludePropsAttribute then
          AIncludeProps := true
        else if Attr is PrefixAttribute then
          Result.TypeData.Prefix := PrefixAttribute(Attr).Prefix
        else if Attr is EnumAsIntAttribute then
          Result.TypeData.EnumAsInt := true
        else if Attr is IdentFormatAttribute then
          Result.TypeData.IdentFormat := NameFormatAttribute(Attr).NameFormat;
      end;
      ACount := 0;
      if ARttiType.TypeKind in [tkRecord, tkMRecord] then
        // 记录类型,直接操作数据成员
        begin
          ARttiFields := ARttiType.GetFields;
          SetLength(Result.Fields, Length(ARttiFields));
          for AFieldIndex := 0 to High(ARttiFields) do begin
            if AddRttiField(Result.Fields[ACount], ARttiFields[AFieldIndex]) then begin
              Result.Fields[ACount].Parent := Result;
              Inc(ACount);
            end;
          end;
        end;
      if AIncludeProps then
        AddProps;
      // 属性仅在 IncludePropsAttribute 显式标注时加入
      SetLength(Result.Fields, ACount);
    end;
  end
  else
    Result := nil;
end;

procedure TQSerializer.LoadFromFile<T>(AInstance: T; AFileName: UnicodeString; const AFormat: UnicodeString);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(AInstance, AStream, AFormat);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQSerializer.LoadFromStream<T>(AInstance: T; AStream: TStream; const AFormat: UnicodeString);
var
  AReader: IQSerializeReader;
  ACodec: TQSerializeFormatCodec;
begin
  AReader := nil;
  System.TMonitor.Enter(Self);
  try
    if FCodecs.TryGetValue(AFormat, ACodec) and Assigned(ACodec.Reader) then
      ACodec.Reader(AStream, '', AReader);
  finally
    System.TMonitor.Exit(Self);
  end;
  if not Assigned(AReader) then
    raise Exception.CreateFmt(SSerializeFormatNotSupport, [AFormat]);
  ToRtti(AReader, AInstance);
end;

procedure TQSerializer.Register(AType: PTypeInfo; const AFields: TQSerializeFields);
var
  AExists: PQSerializeFields;
begin
  TMonitor.Enter(Self);
  try
    if not FCachedTypes.TryGetValue(AType, AExists) then begin
      New(AExists);
      FCachedTypes.Add(AType, AExists);
    end;
    AExists^ := AFields;
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TQSerializer.RegisterCodec(
    const ACode: UnicodeString;
    AReader: TQSerializeReaderCreateProc;
    AWriter: TQSerializeWriterCreateProc
);
var
  AValue: TQSerializeFormatCodec;
begin
  AValue.Reader := AReader;
  AValue.Writer := AWriter;
  FCodecs.AddOrSetValue(ACode, AValue);
end;

function TQSerializer.RegisterType(AType: PTypeInfo; const ACustomSerializer: IQCustomSerializer): PQSerializeFields;
begin
  TMonitor.Enter(Self);
  try
    if not FCachedTypes.TryGetValue(AType, Result) then
      Result := DoRegister(AType);
    if Assigned(ACustomSerializer) then
      Result.CustomSerializer := ACustomSerializer;
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TQSerializer.SaveToFile<T>(AInstance: T; AFileName: UnicodeString; const AFormat: UnicodeString);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AInstance, AStream, AFormat);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQSerializer.SaveToStream<T>(AInstance: T; AStream: TStream; const AFormat: UnicodeString);
var
  AWriter: IQSerializeWriter;
  ACodec: TQSerializeFormatCodec;
begin
  AWriter := nil;
  System.TMonitor.Enter(Self);
  try
    if FCodecs.TryGetValue(AFormat, ACodec) and Assigned(ACodec.Writer) then
      ACodec.Writer(AStream, AWriter);
  finally
    System.TMonitor.Exit(Self);
  end;
  if not Assigned(AWriter) then
    raise Exception.CreateFmt(SSerializeFormatNotSupport, [AFormat]);
  FromRtti(AWriter, AInstance);
end;

class procedure TQSerializer.ToRtti<T>(AReader: IQSerializeReader; var AInstance: T);
begin
  AReader.SetRoot(@AInstance, Current.Find(TypeInfo(T)));
  AReader.DoParse;
end;

{ TQValueCaches<T> }

function TQValueCaches<TItemType>.AddRef(const AValue: Pointer): Pointer;
var
  AHashCode, AIndex: Integer;
  V: TItemType;
  ACache: PQCachedItem;
begin
  if (IntPtr(AValue) and POINTER_IS_CACHED) <> 0 then begin
    ACache := Pointer((IntPtr(AValue) and POINTER_MASK) - sizeof(TQCachedItem) - sizeof(TItemType));
    AtomicIncrement(ACache.RefCount);
    Exit(AValue)
  end
  else begin
    System.TMonitor.Enter(Self);
    try
      if FCount >= FGrowThreshold then
        Grow;
      V := PItemType(IntPtr(AValue) and POINTER_MASK)^;
      AHashCode := FComparer.GetHashCode(V);
      AIndex := GetBucketIndex(V, AHashCode);
      if AIndex >= 0 then begin
        Result := @FItems[AIndex].Value;
        AtomicIncrement(FItems[AIndex].RefCount);
      end
      else begin
        AIndex := not AIndex;
        New(FItems[AIndex]);
        FItems[AIndex].HashCode := AHashCode;
        FItems[AIndex].Value := PItemType(AValue)^;
        if KeepCaches then
          FItems[AIndex].RefCount := 2
        else
          FItems[AIndex].RefCount := 1;
        Result := @FItems[AIndex].Value;
        Inc(FCount);
      end;
      Result := Pointer(IntPtr(MakeReference(Result)) or POINTER_IS_CACHED);
    finally
      System.TMonitor.Exit(Self);
    end;
  end;
end;

procedure TQValueCaches<TItemType>.Clear;
var
  I: Integer;
begin
  System.TMonitor.Enter(Self);
  try
    for I := 0 to High(FItems) do begin
      if Assigned(FItems[I]) then
        Dispose(FItems[I]);
      FItems[I] := nil;
    end;
    FCount := 0;
  finally
    System.TMonitor.Exit(Self);
  end;
end;

constructor TQValueCaches<TItemType>.Create(AComparer: IEqualityComparer<TItemType>);
begin
  inherited Create;
  if not Assigned(AComparer) then
    FComparer := TEqualityComparer<TItemType>.Default
  else
    FComparer := AComparer;
end;

destructor TQValueCaches<TItemType>.Destroy;
begin
  Clear;
  inherited;
end;

function TQValueCaches<TItemType>.GetBucketIndex(const Key: TItemType; HashCode: Integer): NativeInt;
var
  L: NativeInt;
  hc: Integer;
  p: PQCachedItem;
begin
  L := Length(FItems);
  if L = 0 then
    Exit(not High(NativeInt));

  Result := HashCode and (L - 1);
  while true do begin
    p := FItems[Result];
    if Assigned(p) then begin
      hc := p.HashCode;
      if (hc = HashCode) and FComparer.Equals(p.Value, Key) then
        Exit;
      Inc(Result);
      if Result >= L then
        Result := 0;
    end
    else
      Exit(not Result);
  end;
end;

procedure TQValueCaches<TItemType>.Grow;
var
  newCap: NativeInt;
begin
  newCap := Length(FItems) * 2;
  if newCap = 0 then
    newCap := 4;
  Rehash(newCap);
end;

class function TQValueCaches<TItemType>.IsReference(p: Pointer): Boolean;
begin
  Result := (IntPtr(p) and POINTER_IS_REF) <> 0;
end;

class function TQValueCaches<TItemType>.MakeReference(p: Pointer): Pointer;
begin
  Result := Pointer(IntPtr(p) or POINTER_IS_REF);
end;

class function TQValueCaches<TItemType>.ReferenceSource(p: Pointer): Pointer;
begin
  if IsReference(p) then
    Result := Pointer(IntPtr(p) and POINTER_MASK)
  else
    Result := p;
end;

function TQValueCaches<TItemType>.RefValue(const AValue: TItemType): TItemType;
begin
  Result := PItemType(AddRef(@AValue))^;
end;

procedure TQValueCaches<TItemType>.Rehash(NewCapPow2: NativeInt);
var
  oldItems, newItems: TArray<PQCachedItem>;
  I, j: NativeInt;
begin
  if NewCapPow2 = Length(FItems) then
    Exit
  else if NewCapPow2 < 0 then
    OutOfMemoryError;
  oldItems := FItems;
  SetLength(newItems, NewCapPow2);
  FItems := newItems;
  FGrowThreshold := NewCapPow2 shr 1; // 50%
  for I := 0 to High(oldItems) do begin
    if Assigned(oldItems[I]) then begin
      j := not GetBucketIndex(oldItems[I].Value, oldItems[I].HashCode);
      FItems[j] := oldItems[I];
    end;
  end;
end;

function TQValueCaches<TItemType>.Release(const AValue: Pointer): Pointer;
var
  ACache: PQCachedItem;
  AIndex: Integer;
begin
  if (IntPtr(AValue) and POINTER_IS_CACHED) <> 0 then begin
    Result := Pointer(IntPtr(AValue) and POINTER_MASK);
    ACache := Pointer(IntPtr(Result) - sizeof(TQCachedItem) + sizeof(TItemType));
    if AtomicDecrement(ACache.RefCount) = 0 then begin
      System.TMonitor.Enter(Self);
      try
        AIndex := GetBucketIndex(PItemType(Result)^, ACache.HashCode);
        if AIndex >= 0 then begin
          Dispose(FItems[AIndex]);
          FItems[AIndex] := nil;
          Dec(FCount);
        end;
      finally
        System.TMonitor.Exit(Self);
      end;
    end;
  end
  else
    Result := Pointer(IntPtr(AValue) and POINTER_MASK);
end;

procedure TQValueCaches<TItemType>.SetKeepCaches(const Value: Boolean);
var
  ADelta, I: Integer;
begin
  if FKeepCaches <> Value then begin
    TMonitor.Enter(Self);
    try
      FKeepCaches := Value;
      if FKeepCaches then
        ADelta := 1
      else
        ADelta := -1;
      for I := 0 to High(FItems) do begin
        if Assigned(FItems[I]) then
          AtomicIncrement(FItems[I].RefCount, ADelta);
      end;
    finally
      TMonitor.Exit(Self);
    end;
  end;
end;

class function TQValueCaches<TItemType>.Value(ARef: Pointer): TItemType;
begin
  Result := PItemType(ReferenceSource(ARef))^;
end;

{ TQPageBuffers }

function TQPageBuffers.Append(c: WideChar): PQPageBuffers;
begin
  if Current.NextByte = Current.EofByte then begin
    Current := NeedNextPage(Current);
    Current.NextByte := @Current.Data;
  end;
  PWideChar(Current.NextByte)^ := c;
  Inc(Current.NextByte, 2);
  Result := @Self;
end;

function TQPageBuffers.Append(const S: UnicodeString): PQPageBuffers;
begin
  Result := Append(PWideChar(S), 0, S.Length);
end;

function TQPageBuffers.Append(const V: Int64): PQPageBuffers;
begin
  Result := Append(IntToStr(V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Single): PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Double): PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Extended): PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

function TQPageBuffers.Append(const p: PWideChar): PQPageBuffers;
begin
  Result := Append(p, 0, StrLen(p));
end;

function TQPageBuffers.Append(const p: PWideChar; const AOffset, ACount: NativeInt): PQPageBuffers;
begin
  Result := RawAppend(p, AOffset * 2, ACount * 2);
end;

procedure TQPageBuffers.Cleanup;
begin
  Current := First.Next;
  while Assigned(Current) do begin
    Last := Current.Next;
    FreeMem(Current);
    Current := Last;
  end;
  Initialize;
end;

function TQPageBuffers.GetBytes(AIndex: Integer): Byte;
var
  APageNo: Cardinal;
  APage: PQPageBuffer;
begin
  Assert((AIndex >= 0) and (AIndex < Length));
  APageNo := AIndex div sizeof(First.Data);
  if APageNo = PageCount - 1 then
    APage := Last
  else if APageNo > 0 then begin
    if APageNo >= Current.PageNo then begin
      Dec(APageNo, Current.PageNo);
      APage := Current;
    end
    else
      APage := @First;
    while Assigned(APage) and (APageNo > 0) do begin
      APage := APage.Next;
      Dec(APageNo);
    end;
  end
  else
    APage := @First;
  Result := APage.Data[AIndex mod sizeof(First.Data)];
end;

function TQPageBuffers.GetLength: NativeInt;
begin
  Result := (PageCount - 1) * sizeof(First.Data) + Last.Used;
end;

procedure TQPageBuffers.Initialize;
begin
  First.NextByte := @First.Data;
  First.EofByte := First.NextByte + sizeof(First.Data);
  First.Next := nil;
  First.PageNo := 0;
  Last := @First;
  Current := @First;
  PageCount := 1;
end;

function TQPageBuffers.NeedNextPage(APage: PQPageBuffer): PQPageBuffer;
begin
  if not Assigned(APage.Next) then begin
    GetMem(Result, sizeof(TQPageBuffer));
    Result.NextByte := @Result.Data;
    Result.EofByte := Result.NextByte + sizeof(Result.Data);
    Result.Next := nil;
    Result.PageNo := PageCount;
    Last := Result;
    Inc(PageCount);
    APage.Next := Result;
  end
  else
    Result := APage.Next;
end;

function TQPageBuffers.RawAppend(const p: Pointer; const AOffset, ACount: NativeInt): PQPageBuffers;
var
  L, ADelta: Integer;
  ps: PByte;
begin
  L := ACount;
  ps := PByte(p) + AOffset;
  while L > 0 do begin
    if Current.NextByte + L > Current.EofByte then
      ADelta := sizeof(Current.Data) - Current.Used
    else
      ADelta := L;
    Move(ps^, Current.NextByte^, ADelta);
    Inc(Current.NextByte, ADelta);
    Inc(ps, ADelta);
    Dec(L, ADelta);
    if L > 0 then
      Current := NeedNextPage(Current);
  end;
  Result := @Self;
end;

function TQPageBuffers.RawAppend(const ABytes: TBytes; const AOffset, ACount: NativeInt): PQPageBuffers;
begin
  Result := RawAppend(@ABytes[0], AOffset, ACount);
end;

procedure TQPageBuffers.SetLength(const Value: NativeInt);
var
  APage, ANext: PQPageBuffer;
  APageNo: Cardinal;
  ARemaining: NativeInt;
begin
  if Value < 0 then
    raise EArgumentOutOfRangeException.Create('Length must not be negative');

  APage := @First;
  APageNo := 0;
  ARemaining := Value;
  while ARemaining > SizeOf(APage.Data) do begin
    APage.NextByte := APage.EofByte;
    APage.PageNo := APageNo;
    Dec(ARemaining, SizeOf(APage.Data));
    if Assigned(APage.Next) then
      APage := APage.Next
    else
      APage := NeedNextPage(APage);
    Inc(APageNo);
  end;

  APage.PageNo := APageNo;
  APage.NextByte := PByte(@APage.Data) + ARemaining;
  Current := APage;
  Last := APage;
  PageCount := APageNo + 1;

  ANext := APage.Next;
  APage.Next := nil;
  while Assigned(ANext) do begin
    APage := ANext.Next;
    FreeMem(ANext);
    ANext := APage;
  end;
end;

procedure TQPageBuffers.ToString(var S: UnicodeString);
var
  APage: PQPageBuffer;
  pd: PByte;
begin
  System.SetLength(S, Length div 2);
  APage := @First;
  pd := PByte(S);
  while Assigned(APage) and (APage.Used > 0) do begin
    Move(APage.Data[0], pd^, APage.Used);
    Inc(pd, APage.Used);
    APage := APage.Next;
  end;
end;

function TQPageBuffers.ToString: UnicodeString;
begin
  ToString(Result);
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: TDateTime): PQPageBuffers;
begin
  Result := Append(FormatDateTime(AFormat, V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Currency): PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

{ TQPageBuffer }

function TQPageBuffer.Used: Cardinal;
begin
  Result := NextByte - PByte(@Data);
end;

{ TQSerializeFieldHelper }

function TQSerializeFieldHelper.FieldInstance<TPointer>(const AParent: Pointer): TPointer;
var
  ARef: PByte absolute Result;
begin
  Assert(not Assigned(TypeData.PropInfo));
  ARef := AParent;
  Inc(ARef, Offset);
end;

{ TQBaseReader }

destructor TQBaseReader.Destroy;
begin
  while Assigned(FCurrent) and (FCurrent <> @FRoot) do
    Pop;
  inherited;
end;

procedure TQBaseReader.EndRead;
begin
  Pop;
end;

function TQBaseReader.GetActiveFields: PQSerializeFields;
begin
  Assert(Assigned(FCurrent));
  Result := FCurrent.Fields;
end;

function TQBaseReader.GetActiveInstance: Pointer;
begin
  Assert(Assigned(FCurrent));
  Result := FCurrent.Instance;
end;

procedure TQBaseReader.Pop;
var
  ACurrent: PQSerializeStackItem;
begin
  Assert(Assigned(FCurrent), 'Can not popup,push/pop mismatch?');
  if FCurrent = @FRoot then begin
    FCurrent := nil;
    FillChar(FRoot, SizeOf(FRoot), 0);
    Exit;
  end;
  ACurrent := FCurrent;
  FCurrent := ACurrent.Prior;
  Dispose(ACurrent);
end;

procedure TQBaseReader.Push(AInstance: Pointer; AFields: PQSerializeFields);
begin
  Assert(Assigned(AFields));
  Push(AInstance, AFields.TypeData.TypeInfo, AFields);
end;

procedure TQBaseReader.Push(AParentInstance: Pointer; AField: PQSerializeField);
begin
  Assert(Assigned(AField));
  if Assigned(AField.TypeData.PropInfo) then
    Push(AParentInstance, AField.TypeData.TypeInfo, AField.Fields)
  else
    Push(AField.FieldInstance<Pointer>(AParentInstance), AField.TypeData.TypeInfo, AField.Fields);
  FCurrent.Field := AField;
end;

procedure TQBaseReader.Push(AInstance: Pointer; AType: PTypeInfo; AFields: PQSerializeFields);
var
  ANext: PQSerializeStackItem;
begin
  Assert(Assigned(AType));
  if not Assigned(FCurrent) then begin
    FillChar(FRoot, SizeOf(FRoot), 0);
    FCurrent := @FRoot;
  end
  else begin
    New(ANext);
    FillChar(ANext^, SizeOf(ANext^), 0);
    ANext.Prior := FCurrent;
    FCurrent := ANext;
  end;
  FCurrent.Instance := AInstance;
  FCurrent.Fields := AFields;
  FCurrent.TypeInfo := AType;
end;

procedure TQBaseReader.SetRoot(const AInstance: Pointer; AFields: PQSerializeFields);
begin
  Push(AInstance, AFields);
end;
function TQBaseReader.TryRead(const AName: string): Boolean;
var
  AField: PQSerializeField;
  AParentInstance: Pointer;
  I, J: Integer;
begin
  Result := False;
  if not Assigned(FCurrent) or not Assigned(FCurrent.Fields) then
    Exit;
  AParentInstance := FCurrent.Instance;
  if FCurrent.TypeInfo.Kind = tkClass then begin
    if Assigned(FCurrent.Field) and Assigned(FCurrent.Field.TypeData.PropInfo) then
      AParentInstance := GetObjectProp(TObject(FCurrent.Instance), FCurrent.Field.TypeData.PropInfo)
    else
      AParentInstance := PPointer(FCurrent.Instance)^;
  end;
  if not Assigned(AParentInstance) then
    Exit;
  for I := 0 to High(FCurrent.Fields.Fields) do begin
    AField := @FCurrent.Fields.Fields[I];
    for J := 0 to High(AField.Names) do begin
      if CompareText(AName, AField.Names[J]) = 0 then begin
        Push(AParentInstance, AField);
        Exit(True);
      end;
    end;
  end;
end;

{ ---- 共享 DOM 操作实现 ---- }

procedure NodeAddChild(AParent, AChild: PQNodeBase);
begin
  AChild.Prior := AParent.LastChild;
  AChild.Next := nil;
  if AParent.LastChild <> nil then
    AParent.LastChild.Next := AChild
  else
    AParent.FirstChild := AChild;
  AParent.LastChild := AChild;
  Inc(AParent.ChildCount);
end;

procedure NodeDeleteChild(AParent: PQNodeBase; AIndex: Integer);
var
  N: PQNodeBase;
  I: Integer;
begin
  N := AParent.FirstChild;
  I := 0;
  while (N <> nil) and (I < AIndex) do begin
    N := N.Next;
    Inc(I);
  end;
  if N = nil then
    Exit;
  if N.Prior <> nil then
    N.Prior.Next := N.Next
  else
    AParent.FirstChild := N.Next;
  if N.Next <> nil then
    N.Next.Prior := N.Prior
  else
    AParent.LastChild := N.Prior;
  Dec(AParent.ChildCount);
end;

function NodeFindByName(AParent: PQNodeBase; const AName: UnicodeString): PQNodeBase;
begin
  Result := AParent.FirstChild;
  while Result <> nil do begin
    if Result.Name = AName then
      Exit;
    Result := Result.Next;
  end;
end;

procedure NodeForEach(ARoot: PQNodeBase; ACallback: TQNodeForEachCallback);
var
  N: PQNodeBase;
  C: Boolean;
begin
  N := ARoot.FirstChild;
  while N <> nil do begin
    C := True;
    ACallback(N, C);
    if not C then
      Exit;
    NodeForEach(N, ACallback);
    N := N.Next;
  end;
end;

function NodeFindAll(ARoot: PQNodeBase; const AName: UnicodeString): TArray<PQNodeBase>;
var
  List: TList<PQNodeBase>;
  procedure DoFind(N: PQNodeBase);
  begin
    while N <> nil do begin
      if N.Name = AName then
        List.Add(N);
      DoFind(N.FirstChild);
      N := N.Next;
    end;
  end;
begin
  List := TList<PQNodeBase>.Create;
  try
    DoFind(ARoot.FirstChild);
    Result := List.ToArray;
  finally
    List.Free;
  end;
end;

procedure NodeSort(ARoot: PQNodeBase; ASC: Boolean);
var
  A, B: PQNodeBase;
  Tmp: UnicodeString;
begin
  A := ARoot.FirstChild;
  while A <> nil do begin
    B := A.Next;
    while B <> nil do begin
      if (ASC and (A.Name > B.Name)) or (not ASC and (A.Name < B.Name)) then begin
        Tmp := A.Name;
        A.Name := B.Name;
        B.Name := Tmp;
      end;
      B := B.Next;
    end;
    A := A.Next;
  end;
end;

function NodeByPath(ARoot: PQNodeBase; const APath: UnicodeString; ADelimiter: WideChar): PQNodeBase;
var
  p: PWideChar;
  AName: UnicodeString;
  AIndex: Integer;

  function NextSegment: Boolean;
  var
    ps: PWideChar;
  begin
    ps := p;
    AIndex := -1;
    AName := '';
    Result := True;
    while p^ <> #0 do begin
      if p^ = ADelimiter then begin
        AName := Copy(APath, ps - PWideChar(APath) + 1, p - ps);
        Inc(p);
        Break;
      end
      else if p^ = '[' then begin
        AName := Copy(APath, ps - PWideChar(APath) + 1, p - ps);
        Inc(p);
        AIndex := 0;
        while (p^ <> #0) do begin
          if (p^ >= '0') and (p^ <= '9') then
            AIndex := AIndex * 10 + Ord(p^) - Ord('0')
          else if p^ = ']' then begin
            Inc(p);
            if p^ = ADelimiter then
              Inc(p);
            Break;
          end
          else
            Exit(False);
        end;
        Break;
      end
      else
        Inc(p);
    end;
    if (Length(AName) = 0) and (p > ps) then
      AName := Copy(APath, ps - PWideChar(APath) + 1, p - ps);
  end;
begin
  Result := ARoot;
  if APath = '' then
    Exit;
  p := PWideChar(APath);
  while (p^ <> #0) and (Result <> nil) do begin
    if not NextSegment then begin
      Result := nil;
      Exit;
    end;
    if Length(AName) > 0 then begin
      Result := NodeFindByName(Result, AName);
      if (Result <> nil) and (AIndex >= 0) then begin
        var N := Result.FirstChild;
        var I := 0;
        while (N <> nil) and (I < AIndex) do begin
          N := N.Next;
          Inc(I);
        end;
        Result := N;
      end;
    end;
  end;
end;

function NodeForcePath(ARoot: PQNodeBase; const APath: UnicodeString; ADelimiter: WideChar): PQNodeBase;
var
  p: PWideChar;
  AName: UnicodeString;
begin
  Result := ARoot;
  p := PWideChar(APath);
  while p^ <> #0 do begin
    AName := '';
    while (p^ <> #0) and (p^ <> ADelimiter) do begin
      AName := AName + p^;
      Inc(p);
    end;
    if p^ = ADelimiter then
      Inc(p);
    if AName = '' then
      Continue;
    var N := NodeFindByName(Result, AName);
    if N = nil then begin
      New(N);
      FillChar(N^, SizeOf(TQNodeBase), 0);
      N.Name := AName;
      NodeAddChild(Result, N);
    end;
    Result := N;
  end;
end;

function NodeForceName(ARoot: PQNodeBase; const AName: UnicodeString): PQNodeBase;
begin
  Result := NodeFindByName(ARoot, AName);
  if Result = nil then begin
    New(Result);
    FillChar(Result^, SizeOf(TQNodeBase), 0);
    Result.Name := AName;
    NodeAddChild(ARoot, Result);
  end;
end;

function NodeXPath(ARoot: PQNodeBase; const AExpr: UnicodeString): TArray<PQNodeBase>;
var
  p: PWideChar;
  StepName, AttrFilter, AttrVal: UnicodeString;
  Idx: Integer;
  Results: TList<PQNodeBase>;
  CurrentNodes: TList<PQNodeBase>;

  procedure EvaluateStep;
  var
    I: Integer;
    N: PQNodeBase;
    IsDescendant: Boolean;
    Tag: UnicodeString;
    NewNodes: TList<PQNodeBase>;
  begin
    if StepName = '.' then
      Exit;
    Tag := StepName;
    IsDescendant := Copy(Tag, 1, 1) = '/';
    if IsDescendant then
      Delete(Tag, 1, 1);
    if Tag = '*' then
      Tag := '';

    NewNodes := TList<PQNodeBase>.Create;
    try
      for I := 0 to CurrentNodes.Count - 1 do begin
        if IsDescendant then
          NodeForEach(
              CurrentNodes[I],
              procedure(ANode: PQNodeBase; var ACont: Boolean)
              begin
                if (Tag = '') or (ANode.Name = Tag) then
                  if (AttrFilter = '') or (NodeFindByName(ANode.FirstChild, AttrFilter) <> nil) then
                    NewNodes.Add(ANode);
              end
          )
        else begin
          N := CurrentNodes[I].FirstChild;
          while N <> nil do begin
            if (Tag = '') or (N.Name = Tag) then
              if (AttrFilter = '')
                  or ((N.FirstChild <> nil)
                      and (N.FirstChild.Name = AttrFilter)
                      and (N.FirstChild.Next <> nil)
                      and (N.FirstChild.Next.Name = AttrVal)) then
                NewNodes.Add(N);
            N := N.Next;
          end;
        end;
      end;

      CurrentNodes.Clear;
      if Idx < 0 then
        for I := 0 to NewNodes.Count - 1 do
          CurrentNodes.Add(NewNodes[I])
      else if Idx < NewNodes.Count then
        CurrentNodes.Add(NewNodes[Idx]);
    finally
      NewNodes.Free;
    end;
  end;

begin
  SetLength(Result, 0);
  if AExpr = '' then
    Exit;
  CurrentNodes := TList<PQNodeBase>.Create;
  try
    CurrentNodes.Add(ARoot);
    Idx := -1;
    StepName := '';
    AttrFilter := '';
    AttrVal := '';
    p := PWideChar(AExpr);

    if p^ = '/' then
      Inc(p);
    if p^ = '/' then begin
      StepName := '//';
      Inc(p);
    end;

    while p^ <> #0 do begin
      if p^ = '/' then begin
        if StepName <> '' then begin
          EvaluateStep;
          StepName := '';
          AttrFilter := '';
          AttrVal := '';
          Idx := -1;
        end;
        if p[1] = '/' then begin
          StepName := '//';
          Inc(p, 2);
          Continue;
        end;
        Inc(p);
        Continue;
      end;
      if p^ = '[' then begin
        Inc(p);
        if p^ = '@' then begin
          Inc(p);
          AttrFilter := '';
          while (p^ <> #0) and (p^ <> '=') and (p^ <> ']') do begin
            AttrFilter := AttrFilter + p^;
            Inc(p);
          end;
          if p^ = '=' then begin
            Inc(p);
            var Q: WideChar := ' ';
            if (p^ = '''') or (p^ = '"') then begin
              Q := p^;
              Inc(p);
            end;
            AttrVal := '';
            while (p^ <> #0) and (p^ <> Q) and (p^ <> ']') do begin
              AttrVal := AttrVal + p^;
              Inc(p);
            end;
            if p^ = Q then
              Inc(p);
          end;
        end
        else begin
          Idx := 0;
          while (p^ >= '0') and (p^ <= '9') do begin
            Idx := Idx * 10 + Ord(p^) - Ord('0');
            Inc(p);
          end;
        end;
        if p^ = ']' then
          Inc(p);
        Continue;
      end;
      StepName := StepName + p^;
      Inc(p);
    end;
    if StepName <> '' then
      EvaluateStep;

    Result := CurrentNodes.ToArray;
  finally
    CurrentNodes.Free;
  end;
end;

initialization

finalization

  if Assigned(TQSerializer.FCurrent) then
    FreeAndNil(TQSerializer.FCurrent);

end.

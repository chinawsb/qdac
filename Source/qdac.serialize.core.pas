unit qdac.serialize.core;

interface

uses classes, sysutils, typinfo, generics.Collections, generics.Defaults, rtti,
  fmtbcd,qdac.attribute;

const
  PAGE_BUFFER_SIZE = 4096 - sizeof(Pointer) - sizeof(Word);

type
  PQSerializeField = ^TQSerializeField;
  TQSerializeProc = procedure(AField: PQSerializeField; ASourceType: PTypeInfo;
    ASource, ATarget: Pointer) of object;

  TQSerializeField = record
    // 字段的名称，可以有多个别名，如由于历史原因，可能原来叫 a1，后面改名叫 a2，则Names就是 ['a2','a1']
    Names: TArray<UnicodeString>;
    Pathes: TArray<UnicodeString>;
    TypeInfo: PTypeInfo;
    // 字段相对偏移
    Offset: Integer;
    // 字段长度
    Size: Integer;
    // 读值函数
    OnGetValue: TQSerializeProc;
    // 写值函数
    OnSetValue: TQSerializeProc;
  end;

  PQSerializeFields = ^TQSerializeFields;

  TQSerializeFields = record
    TypeInfo: PTypeInfo;
    Fields: TArray<TQSerializeField>;
  end;

  IQSerializeWriter = interface
    ['{6596818B-32B7-4A2F-9512-1229E7553A0B}']
    procedure StartObject;
    procedure EndObject;
    procedure StartArray;
    procedure EndArray;
    procedure WriteValue(const V: UnicodeString); overload;
    procedure WriteValue(const V: Int64); overload;
    procedure WriteValue(const V: Extended); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteNull; overload;
    procedure WritePair(const AName: UnicodeString;
      const V: UnicodeString); overload;
    procedure WritePair(const AName: UnicodeString; const V: Int64); overload;
    procedure WritePair(const AName: UnicodeString; const V: Extended);
      overload;
    procedure WritePair(const AName: UnicodeString; const V: TBcd); overload;
    procedure WritePair(const AName: UnicodeString; const V: Boolean); overload;
    procedure WritePair(const AName: UnicodeString;
      const V: TDateTime); overload;
    procedure WritePair(const AName: UnicodeString; const V: Currency);
      overload;
    procedure WritePair(const AName: UnicodeString; const V: TBytes); overload;
    procedure WritePair(const AName: UnicodeString); overload;
  end;

  // 从流中序列化实例，如果是从JSONL一类的格式中序列化子项，使用 SerializeChildren 来执行，它会在解析到根部数组后，开始挨项序列化（再考虑） ？？？
  IQSerializeReader = interface
    ['{F65DB855-C751-4C84-AD91-346ADC335D62}']
    procedure SetUserData(const V: Pointer);
    function GetUserData: Pointer;
    procedure StartObject;
    procedure EndObject;
    procedure StartArray;
    procedure EndArray;
    procedure EndItem(const AName: String; const AValue: Pointer;
      const AValueType: PTypeInfo);
  end;

  TQSerializer = class sealed
  private
    class var FCurrent: TQSerializer;

  var
    FCachedTypes: TDictionary<PTypeInfo, PQSerializeFields>;
    class function GetCurrent: TQSerializer; static;
  protected
    function InternalRegisterType(AType: PTypeInfo): PQSerializeFields;
    procedure ToInt(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromInt(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToChar(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromChar(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToEnumeration(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromEnumeration(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToFloat(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromFloat(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToAnsiString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromAnsiString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToSet(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromSet(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToClass(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromClass(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToWideChar(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromWideChar(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToLongString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromLongString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToWideString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromWideString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToVariant(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromVariant(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToFixedArray(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromFixedArray(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToRecord(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromRecord(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToInterface(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromInterface(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToInt64(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromInt64(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToDynArray(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromDynArray(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToUnicodeString(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromUnicodeString(AField: PQSerializeField;
      ASourceType: PTypeInfo; ASource, ATarget: Pointer); virtual;
    procedure ToClassRef(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromClassRef(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure ToMRecord(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    procedure FromMRecord(AField: PQSerializeField; ASourceType: PTypeInfo;
      ASource, ATarget: Pointer); virtual;
    class procedure DoSerialize(AWriter: IQSerializeWriter; AInstance: Pointer;
      const AFields: PQSerializeFields); static;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function RegisterType(AType: PTypeInfo): PQSerializeFields;
    procedure Register(AType: PTypeInfo; const AFields: TQSerializeFields);
    function Find(AType: PTypeInfo): PQSerializeFields;
    procedure Clear;
    class procedure FromRtti<T>(AWriter: IQSerializeWriter;
      const AInstance: T); static;
    class procedure ToRtti<T>(AReader: IQSerializeReader;
      var AInstance: T); static;
    class procedure SerializeChildren<T>(AReader: IQSerializeReader;
      var AInstance: T); static;
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
    Data: array [0 .. PAGE_BUFFER_SIZE - 1] of Byte;
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
    function NeedNextPage(APage: PQPageBuffer): PQPageBuffer; // inline;
    function GetBytes(AIndex: Integer): Byte;
  public
    procedure Initialize;
    procedure Cleanup;
    function ToString: UnicodeString; overload;
    procedure ToString(var S: UnicodeString); overload;
    property Length: NativeInt read GetLength write SetLength;
    function RawAppend(const ABytes: TBytes; const AOffset, ACount: NativeInt)
      : PQPageBuffers; overload; inline;
    function RawAppend(const p: Pointer; const AOffset, ACount: NativeInt)
      : PQPageBuffers; overload; inline;
    // Todo:AppendUtf8(...)/AppendBE(...)
    // 按 Unicode 16 LE 插入，用于替换 TStringBuilder 对应功能
    function Append(c: WideChar): PQPageBuffers; overload; inline;
    function Append(const p: PWideChar; const AOffset, ACount: NativeInt)
      : PQPageBuffers; overload; inline;
    function Append(const p: PWideChar): PQPageBuffers; overload; inline;
    function Append(const S: UnicodeString): PQPageBuffers; overload; inline;
    function Append(const V: Int64): PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Currency)
      : PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Single)
      : PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Double)
      : PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: Extended)
      : PQPageBuffers; overload; inline;
    function Append(const AFormat: UnicodeString; const V: TDateTime)
      : PQPageBuffers; overload; inline;
    property Bytes[AIndex: Integer]: Byte read GetBytes;
  end;

type
TQValueCaches < TItemType >= class //
  private //
  type PItemType = ^TItemType;
TQCachedItem = record //
  HashCode: Integer; //
RefCount:
Integer;
Value:
TItemType;
end;
PQCachedItem = ^TQCachedItem;

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
  FCachedTypes := TDictionary<PTypeInfo, PQSerializeFields>.Create;
end;

destructor TQSerializer.Destroy;
begin
  Clear;
  FreeAndNil(FCachedTypes);
  inherited;
end;

class procedure TQSerializer.DoSerialize(AWriter: IQSerializeWriter;
  AInstance: Pointer; const AFields: PQSerializeFields);
begin

end;

function TQSerializer.Find(AType: PTypeInfo): PQSerializeFields;
begin
  TMonitor.Enter(Self);
  try
    if not FCachedTypes.TryGetValue(AType, Result) then
      Result := InternalRegisterType(AType);
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TQSerializer.FromChar(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromClass(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromClassRef(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromDynArray(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromEnumeration(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromFixedArray(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromFloat(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromInt(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromInt64(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromInterface(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromLongString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromMRecord(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromRecord(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

class procedure TQSerializer.FromRtti<T>(AWriter: IQSerializeWriter;
  const AInstance: T);
begin
  DoSerialize(AWriter, @AInstance, Current.RegisterType(TypeInfo(T)));
end;

procedure TQSerializer.FromSet(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromAnsiString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromUnicodeString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromVariant(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromWideChar(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.FromWideString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

class function TQSerializer.GetCurrent: TQSerializer;
  procedure CreateInstance;
  var
    ATemp: TQSerializer;
  begin
    ATemp := TQSerializer.Create;
    if System.AtomicCmpExchange(Pointer(FCurrent), Pointer(ATemp), nil) <> nil
    then
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
  AFieldIndex, AttrIndex, ACount: Integer;
  AIncludeProps: Boolean;
  procedure AddProps;
  var
    AProps: TArray<TRttiProperty>;
    APropIndex: Integer;
  begin
    AProps := ARttiType.GetProperties;
    for APropIndex := 0 to High(AProps) do
    begin

    end;
  end;

begin
  ARttiType := TRttiContext.Create.GetType(AType);
  Assert(Assigned(ARttiType));
  if ARttiType.TypeKind in [tkClass, tkInterface, tkRecord, tkMRecord] then
  begin
    New(Result);
    Result.TypeInfo := AType;
  end
  else
    Exit(nil);
  AIncludeProps := ARttiType.TypeKind in [tkClass, tkInterface];
  ACount := 0;
  if ARttiType.TypeKind in [tkRecord, tkMRecord] then // 记录类型,直接操作数据成员
  begin
    ARttiFields := ARttiType.GetFields;
    SetLength(Result.Fields, Length(ARttiFields));
    for AFieldIndex := 0 to High(ARttiFields) do
    begin
      if (ARttiFields[AFieldIndex].IsWritable) and
        (not(ARttiFields[AFieldIndex].FieldType.TypeKind in [tkUnknown,
        tkMethod, tkPointer, tkProcedure])) then
      begin
        Result.Fields[ACount].Offset := ARttiFields[AFieldIndex].Offset;
        Result.Fields[ACount].TypeInfo := ARttiFields[AFieldIndex]
          .FieldType.Handle;
        Result.Fields[ACount].Size := ARttiFields[AFieldIndex]
          .FieldType.TypeSize;
        Result.Fields[ACount].Names := [ARttiFields[AFieldIndex].Name];
        Attrs := ARttiFields[AFieldIndex].GetAttributes;
        for AttrIndex := 0 to High(Attrs) do
        begin
          if Attrs[AttrIndex] is AliasAttribute then
          begin
            Result.Fields[ACount].Names := Result.Fields[ACount].Names +
              AliasAttribute(Attrs[AttrIndex]).Values;
          end
          else if Attrs[AttrIndex] is PathAttribute then
          begin
            Result.Fields[ACount].Pathes := Result.Fields[ACount].Pathes +
              [PathAttribute(Attrs[AttrIndex]).Path];
          end
          else if Attrs[AttrIndex] is IncludePropsAttribute then
            AIncludeProps := true;
        end;
        case ARttiFields[AFieldIndex].FieldType.TypeKind of
          tkInteger:
            begin
              Result.Fields[ACount].OnGetValue := ToInt;
              Result.Fields[ACount].OnSetValue := FromInt;
            end;
          tkChar:
            begin
              Result.Fields[ACount].OnGetValue := ToChar;
              Result.Fields[ACount].OnSetValue := FromChar;
            end;
          tkEnumeration:
            begin
              Result.Fields[ACount].OnGetValue := ToEnumeration;
              Result.Fields[ACount].OnSetValue := FromEnumeration;
            end;
          tkFloat:
            begin
              Result.Fields[ACount].OnGetValue := ToFloat;
              Result.Fields[ACount].OnSetValue := FromFloat;
            end;
          tkString:
            begin
              Result.Fields[ACount].OnGetValue := ToAnsiString;
              Result.Fields[ACount].OnSetValue := FromAnsiString;
            end;
          tkSet:
            begin
              Result.Fields[ACount].OnGetValue := ToSet;
              Result.Fields[ACount].OnSetValue := FromSet;
            end;
          tkClass:
            begin
              if not FCachedTypes.ContainsKey
                (ARttiFields[AFieldIndex].FieldType.Handle) then
                InternalRegisterType(ARttiFields[AFieldIndex].FieldType.Handle);
              Result.Fields[ACount].OnGetValue := ToClass;
              Result.Fields[ACount].OnSetValue := FromClass;
            end;
          tkWChar:
            begin
              Result.Fields[ACount].OnGetValue := ToWideChar;
              Result.Fields[ACount].OnSetValue := FromWideChar;
            end;
          tkLString:
            begin
              Result.Fields[ACount].OnGetValue := ToLongString;
              Result.Fields[ACount].OnSetValue := FromLongString;
            end;
          tkWString:
            begin
              Result.Fields[ACount].OnGetValue := ToWideString;
              Result.Fields[ACount].OnSetValue := FromWideString;
            end;
          tkVariant:
            begin
              Result.Fields[ACount].OnGetValue := ToVariant;
              Result.Fields[ACount].OnSetValue := FromVariant;
            end;
          tkArray:
            begin
              Result.Fields[ACount].OnGetValue := ToFixedArray;
              Result.Fields[ACount].OnSetValue := FromFixedArray;
            end;
          tkRecord:
            begin
              Result.Fields[ACount].OnGetValue := ToRecord;
              Result.Fields[ACount].OnSetValue := FromRecord;
            end;
          tkInterface:
            begin
              if not FCachedTypes.ContainsKey
                (ARttiFields[AFieldIndex].FieldType.Handle) then
                InternalRegisterType(ARttiFields[AFieldIndex].FieldType.Handle);
              Result.Fields[ACount].OnGetValue := ToInterface;
              Result.Fields[ACount].OnSetValue := FromInterface;
            end;
          tkInt64:
            begin
              Result.Fields[ACount].OnGetValue := ToInt64;
              Result.Fields[ACount].OnSetValue := FromInt64;
            end;
          tkDynArray:
            begin
              Result.Fields[ACount].OnGetValue := ToDynArray;
              Result.Fields[ACount].OnSetValue := FromDynArray;
            end;
          tkUString:
            begin
              Result.Fields[ACount].OnGetValue := ToUnicodeString;
              Result.Fields[ACount].OnSetValue := FromUnicodeString;
            end;
          tkClassRef:
            begin
              Result.Fields[ACount].OnGetValue := ToClassRef;
              Result.Fields[ACount].OnSetValue := FromClassRef;
            end;
          tkMRecord:
            begin
              if not FCachedTypes.ContainsKey
                (ARttiFields[AFieldIndex].FieldType.Handle) then
                InternalRegisterType(ARttiFields[AFieldIndex].FieldType.Handle);
              Result.Fields[ACount].OnGetValue := ToMRecord;
              Result.Fields[ACount].OnSetValue := FromMRecord;
            end;
        end;
        Inc(ACount);
      end;
    end;
  end;
  if AIncludeProps then
    AddProps;
  // 如果是记录，默认不检查属性
  SetLength(Result.Fields, ACount);
  FCachedTypes.Add(AType, Result);
end;

procedure TQSerializer.Register(AType: PTypeInfo;
  const AFields: TQSerializeFields);
var
  AExists: PQSerializeFields;
begin
  TMonitor.Enter(Self);
  try
    if not FCachedTypes.TryGetValue(AType, AExists) then
    begin
      New(AExists);
      FCachedTypes.Add(AType, AExists);
    end;
    AExists^ := AFields;
  finally
    TMonitor.Exit(Self);
  end;
end;

function TQSerializer.RegisterType(AType: PTypeInfo): PQSerializeFields;
begin
  TMonitor.Enter(Self);
  try
    if not FCachedTypes.TryGetValue(AType, Result) then
      Result := InternalRegisterType(AType);
  finally
    TMonitor.Exit(Self);
  end;
end;

class procedure TQSerializer.SerializeChildren<T>(AReader: IQSerializeReader;
  var AInstance: T);
begin

end;

procedure TQSerializer.ToChar(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToClass(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToClassRef(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToDynArray(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToEnumeration(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToFixedArray(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToFloat(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToInt(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToInt64(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToInterface(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToLongString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToMRecord(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToRecord(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

class procedure TQSerializer.ToRtti<T>(AReader: IQSerializeReader;
  var AInstance: T);
begin

end;

procedure TQSerializer.ToSet(AField: PQSerializeField; ASourceType: PTypeInfo;
  ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToAnsiString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToUnicodeString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToVariant(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToWideChar(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;

procedure TQSerializer.ToWideString(AField: PQSerializeField;
  ASourceType: PTypeInfo; ASource, ATarget: Pointer);
begin

end;


{ TQValueCaches<T> }

function TQValueCaches<TItemType>.AddRef(const AValue: Pointer): Pointer;
var
  AHashCode, AIndex: Integer;
  V: TItemType;
  ACache: PQCachedItem;
begin
  if (IntPtr(AValue) and POINTER_IS_CACHED) <> 0 then
  begin
    ACache := Pointer((IntPtr(AValue) and POINTER_MASK) - sizeof(TQCachedItem) -
      sizeof(TItemType));
    AtomicIncrement(ACache.RefCount);
    Exit(AValue)
  end
  else
  begin
    System.TMonitor.Enter(Self);
    try
      if FCount >= FGrowThreshold then
        Grow;
      V := PItemType(IntPtr(AValue) and POINTER_MASK)^;
      AHashCode := FComparer.GetHashCode(V);
      AIndex := GetBucketIndex(V, AHashCode);
      if AIndex >= 0 then
      begin
        Result := @FItems[AIndex].Value;
        AtomicIncrement(FItems[AIndex].RefCount);
      end
      else
      begin
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
    for I := 0 to High(FItems) do
    begin
      if Assigned(FItems[I]) then
        Dispose(FItems[I]);
      FItems[I] := nil;
    end;
    FCount := 0;
  finally
    System.TMonitor.Exit(Self);
  end;
end;

constructor TQValueCaches<TItemType>.Create
  (AComparer: IEqualityComparer<TItemType>);
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

function TQValueCaches<TItemType>.GetBucketIndex(const Key: TItemType;
  HashCode: Integer): NativeInt;
var
  L: NativeInt;
  hc: Integer;
  p: PQCachedItem;
begin
  L := Length(FItems);
  if L = 0 then
    Exit(not High(NativeInt));

  Result := HashCode and (L - 1);
  while true do
  begin
    p := FItems[Result];
    if Assigned(p) then
    begin
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
  for I := 0 to High(oldItems) do
  begin
    if Assigned(oldItems[I]) then
    begin
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
  if (IntPtr(AValue) and POINTER_IS_CACHED) <> 0 then
  begin
    Result := Pointer(IntPtr(AValue) and POINTER_MASK);
    ACache := Pointer(IntPtr(Result) - sizeof(TQCachedItem) +
      sizeof(TItemType));
    if AtomicDecrement(ACache.RefCount) = 0 then
    begin
      System.TMonitor.Enter(Self);
      try
        AIndex := GetBucketIndex(PItemType(Result)^, ACache.HashCode);
        if AIndex >= 0 then
        begin
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
  if FKeepCaches <> Value then
  begin
    TMonitor.Enter(Self);
    try
      FKeepCaches := Value;
      if FKeepCaches then
        ADelta := 1
      else
        ADelta := -1;
      for I := 0 to High(FItems) do
      begin
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
  if Current.NextByte = Current.EofByte then
  begin
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

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Single)
  : PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Double)
  : PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Extended)
  : PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

function TQPageBuffers.Append(const p: PWideChar): PQPageBuffers;
begin
  Result := Append(p, 0, StrLen(p));
end;

function TQPageBuffers.Append(const p: PWideChar;
  const AOffset, ACount: NativeInt): PQPageBuffers;
begin
  Result := RawAppend(p, AOffset * 2, ACount * 2);
end;

procedure TQPageBuffers.Cleanup;
begin
  Current := First.Next;
  while Assigned(Current) do
  begin
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
  else if APageNo > 0 then
  begin
    if APageNo >= Current.PageNo then
    begin
      Dec(APageNo, Current.PageNo);
      APage := Current;
    end
    else
      APage := @First;
    while Assigned(APage) and (APageNo > 0) do
    begin
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
  if not Assigned(APage.Next) then
  begin
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

function TQPageBuffers.RawAppend(const p: Pointer;
  const AOffset, ACount: NativeInt): PQPageBuffers;
var
  L, ADelta: Integer;
  ps: PByte;
begin
  L := ACount;
  ps := PByte(p) + AOffset;
  while L > 0 do
  begin
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

function TQPageBuffers.RawAppend(const ABytes: TBytes;
  const AOffset, ACount: NativeInt): PQPageBuffers;
begin
  Result := RawAppend(@ABytes[0], AOffset, ACount);
end;

procedure TQPageBuffers.SetLength(const Value: NativeInt);
var
  APage: PQPageBuffer;
  ALen: NativeInt;
begin
  APage := @First;
  ALen := 0;
  repeat
    APage.NextByte := PByte(@APage.Data) + Word(Value mod PAGE_BUFFER_SIZE);
    Inc(ALen, APage.Used);
    if ALen < Value then
      APage := NeedNextPage(APage)
    else if APage.Used = sizeof(APage.Data) then
    begin
      if Assigned(APage.Next) then
        APage.Next.NextByte := @APage.Next.Data;
    end;
  until ALen = Value;
end;

procedure TQPageBuffers.ToString(var S: UnicodeString);
var
  APage: PQPageBuffer;
  pd: PByte;
begin
  System.SetLength(S, Length div 2);
  APage := @First;
  pd := PByte(S);
  while Assigned(APage) and (APage.Used > 0) do
  begin
    Move(APage.Data[0], pd^, APage.Used);
    Inc(pd, APage.Used);
    APage := APage.Next;
  end;
end;

function TQPageBuffers.ToString: UnicodeString;
begin
  ToString(Result);
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: TDateTime)
  : PQPageBuffers;
begin
  Result := Append(FormatDateTime(AFormat, V));
end;

function TQPageBuffers.Append(const AFormat: UnicodeString; const V: Currency)
  : PQPageBuffers;
begin
  Result := Append(FormatFloat(AFormat, V));
end;

{ TQPageBuffer }

function TQPageBuffer.Used: Cardinal;
begin
  Result := NextByte - PByte(@Data);
end;

end.

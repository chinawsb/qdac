unit qdac.serialize.core;

interface

uses classes, sysutils, typinfo, generics.Collections, generics.Defaults, rtti,
  fmtbcd, qdac.attribute;

const
  PAGE_BUFFER_SIZE = 4096 - sizeof(Pointer) - sizeof(Word);

type
  PQSerializeField = ^TQSerializeField;
  TQSerializeProc = procedure(AField: PQSerializeField; ASourceType: PTypeInfo;
    ASource, ATarget: Pointer) of object;
  // 序列化时字段名的匹配模式（Delphi是用大驼峰命名，但程序员可能不一定遵守，Normal会按程序员定义匹配）
  // - Normal : 正常匹配（默认），字段名要与数据源名称一致(AgeKind->AgeKind)
  // - LowerCamel : 小驼峰匹配，字段名与源的小驼峰命名反转后的值一致(ageKind->AgeKind/FAgeKind)
  // - UpperCamel : 大驼峰匹配，字段名与源的大驼峰命名反转后的值一致(AgeKind->AgeKind/FAgeKind)
  // - Underline : 下划线匹配，字段名被删除下划线（age_kind->AgeKind/FAgeKind)
  TSerializeNameFormat = (Normal, LowerCamel, UpperCamel, Underline);

  // 序列化导出时的命名格式
  NameFormatAttribute = class(TCustomAttribute)
  private
    FNameFormat: TSerializeNameFormat;
  public
    constructor Create(AFormat: TSerializeNameFormat); overload;
    property NameFormat: TSerializeNameFormat read FNameFormat
      write FNameFormat;
  end;

  // 不序列化指定的项目符号
  ExcludeAttribute = class(TCustomAttribute)

  end;

  // 序列化记录类型的属性值
  IncludePropsAttribute = class(TCustomAttribute)

  end;

  // 排除掉不需要的序列化的字段
  ExcludeFieldsAttribute = class(TCustomAttribute)
  private
    FFields: TArray<UnicodeString>;
  public
    constructor Create(const AFields: TArray<UnicodeString>);
  end;

  TSerializeDateTimeFormat = (DateTimeString, UnixTimeStamp, DateString,
    TimeString);

  DateTimeFormatAttribute = class(TCustomAttribute)
  private
    FFormat: TSerializeDateTimeFormat;
  public
    constructor Create(const AFormat: TSerializeDateTimeFormat);
    property Format: TSerializeDateTimeFormat read FFormat;
  end;

  PrefixAttribute = class(TCustomAttribute)
  private
    FPrefix: UnicodeString;
  public
    constructor Create(const APrefix: UnicodeString);
    property Prefix: UnicodeString read FPrefix;
  end;

  PQSerializeFields = ^TQSerializeFields;

  TQSerializeField = record
    // 字段的名称，可以有多个别名，如由于历史原因，可能原来叫 a1，后面改名叫 a2，则Names就是 ['a2','a1']
    Names: TArray<UnicodeString>;
    Pathes: TArray<UnicodeString>;
    FormatedName: UnicodeString;
    Prefix: UnicodeString; // 枚举或集合类型的前缀
    DateTimeFormat: TSerializeDateTimeFormat; // 日期时间类型格式

    Fields: PQSerializeFields; // 子字段列表
    // 字段相对偏移
    Offset: Integer;
    // 字段长度
    Size: Integer;
    // 是否是属性
    IsProp: Boolean;
    case Boolean of
      false:
        (TypeInfo: PTypeInfo; // 当前字段类型
        );
      true:
        (PropInfo: PPropInfo; // 如果 IsProp 为 true
        );
  end;

  TQSerializeFields = record
    TypeInfo: PTypeInfo;
    NameFormat: TSerializeNameFormat;
    Fields: TArray<TQSerializeField>;
  end;

  IQSerializeWriter = interface
    ['{6596818B-32B7-4A2F-9512-1229E7553A0B}']
    procedure StartObject;

    procedure EndObject;
    procedure StartArray;
    procedure EndArray;
    procedure WriteValue(const V: UnicodeString); overload;
    procedure WriteValue(const V: Int64; AIsSign: Boolean = true); overload;
    procedure WriteValue(const V: Extended); overload;
    procedure WriteValue(const V: TBcd); overload;
    procedure WriteValue(const V: Boolean); overload;
    procedure WriteValue(const V: TDateTime); overload;
    procedure WriteValue(const V: Currency); overload;
    procedure WriteValue(const V: TBytes); overload;
    procedure WriteNull; overload;
    procedure StartObjectPair(const AName: UnicodeString);
    procedure StartArrayPair(const AName: UnicodeString);
    procedure StartPair(const AName: UnicodeString);
    procedure WritePair(const AName: UnicodeString;
      const V: UnicodeString); overload;
    procedure WritePair(const AName: UnicodeString; const V: Int64;
      AIsSign: Boolean = true); overload;
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
    class procedure DoSerialize(AWriter: IQSerializeWriter; AInstance: Pointer;
      AType: PTypeInfo; const AFields: PQSerializeFields); static;
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
    function NeedNextPage(APage: PQPageBuffer): PQPageBuffer;
    // inline;
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
  AInstance: Pointer; AType: PTypeInfo; const AFields: PQSerializeFields);
type
  TLargestSet = set of Byte;
  PLargestSet = ^TLargestSet;
var
  S: UnicodeString;
  AFieldIndex: Integer;

  function GetEnumTypeValue(AInstance: Pointer; AType: PTypeInfo): Cardinal;
  begin
    case GetTypeData(AType)^.OrdType of
      otUByte, otSByte:
        Result := PByte(AInstance)^;
      otUWord, otSWord:
        Result := PWord(AInstance)^;
      otULong, otSLong:
        Result := PCardinal(AInstance)^
    else // 不可能执行到此位置
      Result := 0;
    end;
  end;

  function IsBooleanType(AType: PTypeInfo): Boolean;
  begin
    if AType <> TypeInfo(Boolean) then
      Result := (AType.Kind = tkEnumeration) and
        (GetTypeData(GetTypeData(AType).BaseType^).MinValue < 0)
    else
      Result := true;
  end;

  function GetEnumFieldValue(const AField: TQSerializeField): UnicodeString;
  var
    AValue: Cardinal;
  begin
    if AField.IsProp then
      Result := GetEnumName(AField.PropInfo.PropType^,
        GetOrdProp(AInstance, AField.PropInfo))
    else
    begin
      Result := GetEnumName(AField.TypeInfo,
        GetEnumTypeValue(Pointer(PByte(AInstance) + AField.Offset),
        AField.TypeInfo));
    end;
    if Length(AField.Prefix) > 0 then
    begin
      if Result.StartsWith(AField.Prefix) then
        Result := Result.Substring(Length(AField.Prefix));
    end;
  end;

  function FormatEnumValue(const AName, APrefix: UnicodeString): UnicodeString;
  begin
    if Length(APrefix) > 0 then
      Result := AName.Substring(Length(APrefix))
    else
      Result := AName;
  end;

  procedure DoWriteSetValue(AInstance: Pointer; AType: PTypeInfo;
    const AKey, APrefix: UnicodeString);
  var
    B: Byte;
    EnumOffset: Integer;
    PEnumInfo: PPTypeInfo;
    AValue: UnicodeString;
  begin
    AWriter.StartArray;
    PEnumInfo := GetTypeData(AType)^.CompType;
    if PEnumInfo <> nil then
    begin
      EnumOffset := ByteOffsetOfSet(AType) * 8;
      for B := 0 to SizeOfSet(AType) * 8 - 1 do
        if B in PLargestSet(AInstance)^ then
        begin
          AValue := GetEnumName(PEnumInfo^, B + EnumOffset);
          if (Length(APrefix) > 0) and AValue.StartsWith(APrefix) then
            AValue := AValue.Substring(Length(APrefix));
          if Length(AKey) > 0 then
            AWriter.WritePair(AKey, AValue)
          else
            AWriter.WriteValue(AValue);
        end;
    end
    else
    begin
      for B := 0 to SizeOfSet(AType) * 8 - 1 do
        if B in PLargestSet(AInstance)^ then
        begin
          AValue := GetEnumName(PEnumInfo^, B);
          if (Length(APrefix) > 0) and AValue.StartsWith(APrefix) then
            AValue := AValue.Substring(Length(APrefix));
          if Length(AKey) > 0 then
            AWriter.WritePair(AKey, AValue)
          else
            AWriter.WriteValue(AValue);
        end;
    end;
  end;

  procedure WriteIntValue(AInstance: Pointer; const AField: TQSerializeField);
  begin
    if AField.IsProp then
    begin
      with GetTypeData(AField.PropInfo.PropType^)^ do
      begin
        AWriter.WritePair(AField.FormatedName,
          GetOrdProp(AInstance, AField.PropInfo), MinValue > MaxValue);
      end;
    end;
  end;
  procedure WriteArrayValue(AInstance: Pointer; ACount: Integer;
    AType: PTypeInfo);
  begin

  end;
  procedure WriteField(const AField: TQSerializeField);
  var
    AName: UnicodeString;
    ASubFields: PQSerializeFields;
    ATypeData: PTypeData;
    AFieldInstance: Pointer;
    I: Integer;
  begin
    if AField.IsProp then
    begin
      case AField.PropInfo.PropType^.Kind of
        tkInteger:
          begin
            ATypeData := GetTypeData(AField.PropInfo.PropType^);
            if ATypeData.MinValue > ATypeData.MaxValue then
              AWriter.WritePair(AField.FormatedName,
                GetOrdProp(AInstance, AField.PropInfo), false)
            else
              AWriter.WritePair(AField.FormatedName,
                GetOrdProp(AInstance, AField.PropInfo));
          end;
        tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
          AWriter.WritePair(AField.FormatedName,
            GetStrProp(AInstance, AField.PropInfo));
        tkEnumeration:
          begin
            if IsBooleanType(AField.PropInfo.PropType^) then
              AWriter.WritePair(AField.FormatedName,
                GetOrdProp(AInstance, AField.PropInfo) <> 0)
            else
              AWriter.WritePair(AField.FormatedName,
                FormatEnumValue(GetEnumProp(AInstance, AField.PropInfo),
                AField.Prefix));
          end;
        tkFloat:
          begin
            AWriter.WritePair(AField.FormatedName,
              GetFloatProp(AInstance, AField.PropInfo));
          end;
        tkSet:
          AWriter.WritePair(AField.FormatedName,
            GetSetProp(AInstance, AField.PropInfo, true));
        tkClass:
          begin
            if Assigned(AField.Fields) then
            begin
              AFieldInstance := GetObjectProp(AInstance, AField.PropInfo);
              if Assigned(AFieldInstance) then
              begin
                AWriter.StartObjectPair(AField.FormatedName);
                try
                  for I := 0 to High(AField.Fields.Fields) do
                  begin
                    AWriter.StartPair(AField.Fields.Fields[I].FormatedName);
                    DoSerialize(AWriter, AFieldInstance,
                      AField.Fields.Fields[I].TypeInfo, AField.Fields);
                  end;
                finally
                  AWriter.EndObject;
                end;
              end;
            end;
          end;
        tkVariant:
          begin
          end;
        tkArray:
          ;
        tkRecord:
          ;
        tkInterface:
          begin
            AFieldInstance := nil;
            IInterface(AFieldInstance) := GetInterfaceProp(AInstance,
              AField.PropInfo);
            if Assigned(AFieldInstance) then
            begin
              AWriter.StartObjectPair(AField.FormatedName);
              try
                for I := 0 to High(AField.Fields.Fields) do
                begin
                  AWriter.StartPair(AField.Fields.Fields[I].FormatedName);
                  DoSerialize(AWriter, AFieldInstance,
                    AField.Fields.Fields[I].TypeInfo, AField.Fields);
                end;
              finally
                AWriter.EndObject;
              end;
            end;
            IInterface(AFieldInstance) := nil;
          end;
        tkInt64:
          with GetTypeData(AField.PropInfo.PropType^)^ do
            AWriter.WritePair(AField.FormatedName,
              GetInt64Prop(AInstance, AField.PropInfo), MinValue > MaxValue);
        tkDynArray:
          begin
            AFieldInstance := GetDynArrayProp(AInstance, AField.PropInfo);
            if Assigned(AFieldInstance) then
            begin
              AWriter.StartObjectPair(AField.FormatedName);
              try
                WriteArrayValue(AFieldInstance,
                  System.DynArraySize(AFieldInstance),
                  AField.PropInfo.PropType^);
              finally
                AWriter.EndArray;
              end;
            end;
          end;
        tkClassRef:
          ;
        tkPointer:
          ;
        tkProcedure:
          ;
        tkMRecord:
          ;
      end;
    end
    else
    begin

    end;
  end;

begin
  case AType.Kind of
    tkInteger:
      begin
        case AType.TypeData.OrdType of
          otSByte:
            AWriter.WriteValue(PShortInt(AInstance)^);
          otUByte:
            AWriter.WriteValue(PByte(AInstance)^);
          otSWord:
            AWriter.WriteValue(PSmallint(AInstance)^);
          otUWord:
            AWriter.WriteValue(PWord(AInstance)^);
          otSLong:
            AWriter.WriteValue(PInteger(AInstance)^);
          otULong:
            AWriter.WriteValue(PCardinal(AInstance)^);
        end;
      end;
    tkChar:
      AWriter.WriteValue(UnicodeString(WideChar(PByte(AInstance)^)));
    tkEnumeration:
      DoWriteEnumValue;
    tkFloat:
      begin
        case AType.TypeData.FloatType of
          ftSingle:
            AWriter.WriteValue(PSingle(AInstance)^);
          ftDouble:
            AWriter.WriteValue(PDouble(AInstance)^);
          ftExtended:
            AWriter.WriteValue(PExtended(AInstance)^);
          ftComp:
            AWriter.WriteValue(PInt64(AInstance)^);
          ftCurr:
            AWriter.WriteValue(PCurrency(AInstance)^);
        end;
      end;
    tkString:
      AWriter.WriteValue(UnicodeString(PShortString(AInstance)^));
    tkSet:
      DoWriteSetValue;
    tkClass, tkRecord, tkMRecord, tkInterface:
      begin
        AWriter.StartObject;
        for AFieldIndex := 0 to High(AFields.Fields) do
        begin
          WriteField(AFields.Fields[AFieldIndex]);
        end;
        AWriter.EndObject;
      end;
    tkWChar:
      AWriter.WriteValue(UnicodeString(PWideChar(AInstance)^));
    tkLString:
      AWriter.WriteValue(UnicodeString(PAnsiString(AInstance)^));
    tkWString:
      AWriter.WriteValue(PWideString(AInstance)^);
    tkVariant:
      begin
        // Todo:Write values
      end;
    tkArray:
      begin
        // Todo:Write values
      end;
    tkInt64:
      begin
        if AType.TypeData.MinInt64Value > AType.TypeData.MaxInt64Value then
          AWriter.WriteValue(PUInt64(AInstance)^)
        else
          AWriter.WriteValue(PInt64(AInstance)^);
      end;
    tkDynArray:
      begin
        // Todo:Write values
      end;
    tkUString:
      AWriter.WriteValue(PUnicodeString(AInstance)^);
    tkClassRef:
      begin
        // 类
        if Assigned(PPointer(AInstance)^) then
        begin
          S := TClass(PPointer(AInstance)^).ClassName;
          if S.StartsWith('T') then
            S := S.Substring(1);
          AWriter.WriteValue(S);
        end;
      end;
  end;
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

class procedure TQSerializer.FromRtti<T>(AWriter: IQSerializeWriter;
  const AInstance: T);
begin
  Current.DoSerialize(AWriter, @AInstance, TypeInfo(T),
    Current.RegisterType(TypeInfo(T)));
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
  AExcludeFields: TArray<UnicodeString>;
  ANameFormat: TSerializeNameFormat;
  p, ps, pd: PWideChar;
  AFieldIndex, AttrIndex, ACount: Integer;
  AIncludeProps: Boolean;

  function AddRttiField(var AResult: TQSerializeField;
    AField: TRttiDataMember): Boolean;
  var
    I: Integer;
    AElementType: PPTypeInfo;
    AFieldType: TRttiType;

  begin
    Result := false;
    if AField is TRttiField then
    begin
      AResult.IsProp := false;
      AFieldType := TRttiField(AField).FieldType;
      AResult.TypeInfo := AFieldType.Handle;
    end
    else if AField is TRttiProperty then
    begin
      AResult.IsProp := true;
      AResult.PropInfo := TRttiProperty(AField).Handle;
      AFieldType := TRttiProperty(AField).PropertyType;
    end
    else
      Exit;
    if (AField.IsWritable) and
      (not(AFieldType.TypeKind in [tkUnknown, tkMethod, tkPointer, tkProcedure]))
    then
    begin
      for I := 0 to High(AExcludeFields) do
      begin
        if AExcludeFields[I].Compare(AExcludeFields[I], AField.Name) = 0 then
          Exit;
      end;
      Attrs := AField.GetAttributes;
      for I := 0 to High(Attrs) do
      begin
        if Attrs[I] is AliasAttribute then
        begin
          AResult.Names := AResult.Names + AliasAttribute(Attrs[I]).Values;
        end
        else if Attrs[I] is PathAttribute then
        begin
          AResult.Pathes := AResult.Pathes + [PathAttribute(Attrs[I]).Path];
        end
        else if Attrs[I] is IncludePropsAttribute then
          AIncludeProps := true
        else if Attrs[I] is DateTimeFormatAttribute then
          AResult.DateTimeFormat := DateTimeFormatAttribute(Attrs[I]).FFormat
        else if Attrs[I] is PrefixAttribute then
          AResult.Prefix := PrefixAttribute(Attrs[I]).FPrefix
        else if Attrs[I] is ExcludeAttribute then
          Exit;
      end;
      case AFieldType.TypeKind of
        tkClass, tkRecord, tkMRecord, tkInterface:
          begin
            if not FCachedTypes.ContainsKey(AFieldType.Handle) then
            begin
              AResult.Fields := InternalRegisterType(AFieldType.Handle);
              if not Assigned(AResult.Fields) then
                Exit;
            end;
          end;
        tkArray:
          begin
            AElementType := GetTypeData(AFieldType.Handle).elType;
            if Assigned(AElementType) and Assigned(AElementType^) and
              (not FCachedTypes.ContainsKey(AType)) then
            begin
              if InternalRegisterType(AElementType^) = nil then
                Exit;
            end;
          end;
        tkDynArray:
          begin
            AElementType :=
              GetTypeData(ARttiFields[AFieldIndex].FieldType.Handle)
              .DynArrElType;
            if Assigned(AElementType) and Assigned(AElementType^) and
              (not FCachedTypes.ContainsKey(AType)) then
            begin
              if InternalRegisterType(AElementType^) = nil then
                Exit;
            end;
          end;
      end;
      AResult.IsProp := false;
      if not AResult.IsProp then
        AResult.Offset := TRttiField(AField).Offset;
      AResult.Size := AFieldType.TypeSize;
      AResult.FormatedName := AField.Name;
      AResult.Names := [AField.Name];
      case ANameFormat of
        LowerCamel:
          begin
            p := PWideChar(AResult.FormatedName);
            pd := p;
            while p^ <> #0 do
            begin
              case p^ of
                'A' .. 'Z':
                  pd^ := Char(Word(pd^) xor $0020)
              else
                pd^ := p^;
              end;
              Inc(p);
              pd := p;
              while p^ <> #0 do
              begin
                if p^ = '_' then
                begin
                  while p^ = '_' do
                    Inc(p);
                  break;
                end
                else
                begin
                  pd^ := p^;
                  Inc(pd);
                  Inc(p);
                end;
              end;
            end;
            SetLength(AResult.FormatedName,
              pd - PWideChar(AResult.FormatedName));
          end;
        UpperCamel:
          begin
            p := PWideChar(AResult.FormatedName);
            pd := p;
            while p^ <> #0 do
            begin
              case p^ of
                'a' .. 'z':
                  pd^ := Char(Word(pd^) or $0020)
              else
                pd^ := p^;
              end;
              Inc(p);
              pd := p;
              while p^ <> #0 do
              begin
                if p^ = '_' then
                begin
                  while p^ = '_' do
                    Inc(p);
                  break;
                end
                else
                begin
                  pd^ := p^;
                  Inc(pd);
                  Inc(p);
                end;
              end;
            end;
            SetLength(AResult.FormatedName,
              pd - PWideChar(AResult.FormatedName));
          end;
        Underline:
          begin
            SetLength(AResult.FormatedName, Length(AField.Name) shl 1);
            p := PWideChar(AField.Name);
            ps := p;
            pd := PWideChar(AResult.FormatedName);
            while p^ <> #0 do
            begin
              case p^ of
                'A' .. 'Z':
                  begin
                    if p > ps then
                    begin
                      pd^ := '_';
                      Inc(pd);
                    end;
                    pd^ := Char(Word(pd^) xor $0020);
                  end
              else
                pd^ := p^;
              end;
              Inc(p);
              pd := p;
              while (p^ <> #0) and ((p^ <= 'A') or (p^ >= 'Z')) do
              begin
                if p^ = '_' then
                begin
                  while p^ = '_' do
                    Inc(p);
                  break;
                end
                else
                begin
                  pd^ := p^;
                  Inc(pd);
                  Inc(p);
                end;
              end;
            end;
            SetLength(AResult.FormatedName,
              pd - PWideChar(AResult.FormatedName));
          end;
      end;
      if AResult.FormatedName <> AField.Name then
        AResult.Names := [AResult.FormatedName] + AResult.Names;
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
    for APropIndex := 0 to High(AProps) do
    begin
      if AddRttiField(Result.Fields[ACount], AProps[APropIndex]) then
        Inc(ACount);
    end;
  end;

begin
  if not Assigned(AType) then
    Exit(nil);
  case AType.Kind of
    tkClass, tkInterface, tkRecord, tkMRecord:
      begin
        New(Result);
        Result.TypeInfo := AType;
      end;
    tkArray:
      begin
        InternalRegisterType(GetTypeData(AType).elType^);
        Exit(nil);
      end;
    tkDynArray:
      begin
        InternalRegisterType(GetTypeData(AType).DynArrElType^);
        Exit(nil);
      end
  else
    Exit(nil);
  end;
  ARttiType := TRttiContext.Create.GetType(AType);
  if not Assigned(ARttiType) then
    Exit(nil);
  AIncludeProps := ARttiType.TypeKind in [tkClass, tkInterface];
  Attrs := ARttiType.GetAttributes;
  for AttrIndex := 0 to High(Attrs) do
  begin
    if Attrs[AttrIndex] is NameFormatAttribute then
      ANameFormat := NameFormatAttribute(Attrs[AttrIndex]).NameFormat
    else if Attrs[AttrIndex] is ExcludeFieldsAttribute then
      // 记录排除的字段
      AExcludeFields := ExcludeFieldsAttribute(Attrs[AttrIndex]).FFields
    else if Attrs[AttrIndex] is IncludePropsAttribute then
      AIncludeProps := true;
  end;
  Result.NameFormat := ANameFormat;
  ACount := 0;
  if ARttiType.TypeKind in [tkRecord, tkMRecord] then
  // 记录类型,直接操作数据成员
  begin
    ARttiFields := ARttiType.GetFields;
    SetLength(Result.Fields, Length(ARttiFields));
    for AFieldIndex := 0 to High(ARttiFields) do
    begin
      if AddRttiField(Result.Fields[ACount], ARttiFields[AFieldIndex]) then
        Inc(ACount);
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

class procedure TQSerializer.ToRtti<T>(AReader: IQSerializeReader;
  var AInstance: T);
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

{ NameKindAttribute }

constructor NameFormatAttribute.Create(AFormat: TSerializeNameFormat);
begin
  inherited Create;
  FNameFormat := AFormat;
end;

{ ExcludeFieldsAttribute }

constructor ExcludeFieldsAttribute.Create(const AFields: TArray<UnicodeString>);
begin
  inherited Create;
  FFields := Copy(AFields);
end;

{ DateTimeFormatAttribute }

constructor DateTimeFormatAttribute.Create(const AFormat
  : TSerializeDateTimeFormat);
begin
  inherited Create;
  FFormat := AFormat;
end;

{ PrefixAttribute }

constructor PrefixAttribute.Create(const APrefix: UnicodeString);
begin
  inherited Create;
  FPrefix := APrefix;
end;

end.

unit qdac.attribute;

interface

uses Classes, Sysutils, Math, Generics.Collections, qdac.common, qdac.validator;

const
  SHttpGet = 'GET';
  SHttpPost = 'POST';
  SHttpPut = 'PUT';
  SHttpDelete = 'DELETE';

type

  // 内容为文本的注解基类
  TQTextAttribute = class(TCustomAttribute)
  protected
    FText: UnicodeString;
    property Text: String read FText;
  public
    constructor Create(const AText: UnicodeString); overload;
  end;

  // 名称注解，用于设置序列化的名称，如果设置了，NameFormat 注解将被忽略
  NameAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  // 路径注解，用于解析内容到特定的路径上去，路径间分隔使用反斜线“/”，如[Path('/home/swish')]
  PathAttribute = class(TQTextAttribute)
  public
    property Path: UnicodeString read FText;
  end;

  // 方法名称注解，用于映射方法名，具体用途取决于使用的位置。如 [MethodName('GET')]
  MethodNameAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  // 协议名称注解，如 [Protocol('https')]
  ProtocolAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  // 架构名称注解，如 [Schema('public')]
  SchemaAttribute = class(ProtocolAttribute)
  public
    property Name: String read FText;
  end;

  // 令牌类型，如[TokenType('jwt')]

  TokenTypeAttribute = class(TQTextAttribute)
  public
    property Kind: UnicodeString read FText;
  end;

  // 基础路径，一般用于路由，如[BasePath('https://blog.qdac.cc/api/')]
  BasePathAttribute = class(TQTextAttribute)
  public
    property Path: UnicodeString read FText;
  end;

  StringListAttribute = class(TCustomAttribute)
  public
    FValues: TArray<UnicodeString>;
  public
    constructor Create(const AValues: UnicodeString;
      ADelimiter: Char = #0); overload;
    property Values: TArray<UnicodeString> read FValues;
  end;

  // 别名注解，用于设置别名，以保持版本间兼容，如 [Alias(['name1','name2'])]
  AliasAttribute = class(StringListAttribute)

  end;

  // 类型严格匹配模式，严格模式下，字符串与数值、布尔等类型之间不允许自动转换，而是抛出错误，如 [StrictType]
  StrictTypeAttribute = class(TCustomAttribute)
  end;

  IncludePropsAttribute = class(TCustomAttribute)

  end;

  // 序列化时字段名的匹配模式（Delphi是用大驼峰命名，但程序员可能不一定遵守，Normal会按程序员定义匹配）
  // - Normal : 正常匹配（默认），字段名要与数据源名称一致(AgeKind->AgeKind)
  // - LowerCamel : 小驼峰匹配，字段名与源的小驼峰命名反转后的值一致(ageKind->AgeKind/FAgeKind)
  // - UpperCamel : 大驼峰匹配，字段名与源的大驼峰命名反转后的值一致(AgeKind->AgeKind/FAgeKind)
  // - Underline : 下划线匹配，字段名被删除下划线（Age_Kind->AgeKind/FAgeKind)
  // - UpperCase : 全大写(AGEKIND -> AgeKind/FAgeKind/age_kind)
  // - LowerCase : 全小写(agekind ->AgeKind/FAgeKind/age_kind)
  // - UpperCaseUnderLine : 大写+下划线(AGE_KIND -> AgeKind/FAgeKind/age_kind)
  // - LowerCaseUnderLine : 小写+下划线(age_kind -> AgeKind/FAgeKind/age_kind)
  TSerializeNameFormat = (Normal, LowerCamel, UpperCamel, Underline, UpperCase,
    LowerCase, UpperCaseUnderLine, LowerCaseUnderLine);

  // 序列化导出时的命名格式
  NameFormatAttribute = class(TCustomAttribute)
  private
    FNameFormat: TSerializeNameFormat;
  public
    constructor Create(AFormat: TSerializeNameFormat); overload;
    property NameFormat: TSerializeNameFormat read FNameFormat
      write FNameFormat;
  end;

  IdentFormatAttribute = class(NameFormatAttribute)

  end;

  // 不序列化指定的项目符号
  ExcludeAttribute = class(TCustomAttribute)

  end;

  // 排除掉不需要的序列化的字段
  ExcludeFieldsAttribute = class(StringListAttribute)
  public

  end;

  // 枚举类型按整数来转换
  EnumAsIntAttribute = class(TCustomAttribute)
  end;

  TSerializeDateTimeFormat = (AutoDetect, DateTimeString, UnixTimeStamp,
    UnixTimeStampMs, DateString, TimeString);

  DateTimeFormatAttribute = class(TCustomAttribute)
  private
    FFormat: TSerializeDateTimeFormat;
    FFormatText: UnicodeString;
  public
    constructor Create(const AFormat: TSerializeDateTimeFormat;
      const AFormatText: UnicodeString = '');
    property Format: TSerializeDateTimeFormat read FFormat;
    property FormatText: UnicodeString read FFormatText;
  end;

  FloatFormatAttribute = class(TQTextAttribute)
  public
    property FormatText: UnicodeString read FText;
  end;

  StringPairAttribute = class(TCustomAttribute)
  private
    FKey, FValue: UnicodeString;
  public
    constructor Create(const AKey, AValue: UnicodeString); overload;
    property Key: UnicodeString read FKey;
    property Value: UnicodeString read FValue;
  end;

  IdentMapAttribute = class(StringPairAttribute)

  end;

  // 基于验证器的注解
  TQValidatorAttribute = class(TCustomAttribute)
  protected
    FValidator: IQValidator;
  public
    property validator: IQValidator read FValidator;
  end;

  // 值范围，如 [ValueRange<SmallInt>(0,120,'Age must between [MinValue]-[MaxValue]')]
ValueRangeAttribute < TQValueType >= class(TQValidatorAttribute)
  public constructor Create(const AMinValue, AMaxValue: TQValueType;
  const AErrorMsg: UnicodeString = ''; ABounds: TQRangeBounds = []);
end;

// 长度限制，如 [LengthRange<UnicodeString>(4,12,'[Size] out of range [MinSize] to [MaxSize]')]
LengthRangeAttribute < TQValueType >= class(TQValidatorAttribute)
  public constructor Create(const AMinSize, AMaxSize: SizeInt;
  const AErrorMsg: UnicodeString = '');
end;

// 默认值，指明如果序列化时，没有赋值时如何处理，如果不指定，默认为 Default<TQValueType>，用例:[DefaultValue<String>('male')]
DefaultValueAttribute < TQValueType >= class(TCustomAttribute)private FValue
  : TQValueType;
public
  constructor Create(const AValue: TQValueType);
  overload;
  property Value: TQValueType read FValue;
  end;

  // 序列化时忽略该项，用例：[Ignore]
  IgnoreAttribute = class(TCustomAttribute)

  end;

  // 序列化时强制写入，用例：[NoDefault]
  NoDefaultAttribute = class(TCustomAttribute)

  end;

  // 格式校验规则，如 [Validator('email')]指明值使用 email 验证器进行验证
  ValidatorAttribute = class(TQValidatorAttribute)private FErrorMsg: String;
public
  constructor Create(const AName: UnicodeString;
    const AErrorMsg: UnicodeString = '');
  overload;
  end;

  // 前缀，如 clWhite 指定前缀为 cl，则实际保存时，值被保存为 White，前缀和后缀可能有多个，如:
  // clSnow,clWebSnow，前缀分别是 cl,wlWebSnow，程序序列化时，优先使用较长前缀
  PrefixAttribute = class(TQTextAttribute)public property Prefix: UnicodeString
    read FText;
  end;

  // 尾缀，如 DynamicOrder 指定后缀为 Order，则实际保存时，值被序列化为 Dynamic
  TailAttribute = class(TQTextAttribute)public property Tail: UnicodeString
    read FText;
  end;

  // 序列化时，值保存的位置，如 XML 序列化或反序列化时，需要确定将值存在结点的属性还是子结点中
  TQValueStorage = (attribute, ChildNode);
  // 指定序列化元素位置，如果不指定，则继续上级结点的默认行为，如果都没指定，默认为属性，如果 [ValueStorage(ChildNode)]
  ValueStorageAttribute = class(TCustomAttribute)private FStorage
    : TQValueStorage;
public
  constructor Create(const AStorage: TQValueStorage);
  overload;
  property Storage: TQValueStorage read FStorage;
  end;

  // 正则表达式规则验证，如 [RegexValidator('^\d+$')]
  RegexValidatorAttribute = class(TQValidatorAttribute)public constructor Create
    (const ARegexpr: UnicodeString; const AErrorMsg: UnicodeString = '');
  overload;
  end;

  // 类型转字符串格式设置，参考系统的 Format 函数，如：[TextFormat('%5.2f')]
  TextFormatAttribute = class(TQTextAttribute)public property Format
    : UnicodeString read FText;
  end;

  // 文本转换器，用于将指定的值转换为特定的文本，比如首字母大写，小驼峰，大驼峰，全角转半角，首行缩进等等，这里只保存名称
  // 如 Transform('FullToHalf')
  TransformAttribute = class(TQTextAttribute)public property Name: UnicodeString
    read FText;
  end;

  // 值模拟来源名称，为自动生成测试数据而创建，值来源名称由实现定义注册到 qdac.test.values.TQValueSources，如 [ValueSource('age')]
  ValueSourceAttribute = class(TQTextAttribute)public property SourceName
    : UnicodeString read FText;
  end;

  // 多线程注解，指明某个函数是否可以在多线程中直接访问，三种模式：主线程（默认）、单线程（可后台单线程跑）、多线程
  // 如 [ThreadMode(MainThread)] 限制函数只应在主线程中被调用
  TQMultiThreadMode = (MainThread, SingleThread, MultiThread);
  ThreadModeAttribute = class(TCustomAttribute)private FMode: TQMultiThreadMode;
public
  constructor Create(AMode: TQMultiThreadMode);
  overload;
  property Mode: TQMultiThreadMode read FMode;
  end;

implementation

{ ValueRangeAttribute<TQValueType> }

constructor ValueRangeAttribute<TQValueType>.Create(const AMinValue,
  AMaxValue: TQValueType; const AErrorMsg: UnicodeString;
  ABounds: TQRangeBounds);
begin
  inherited Create;
  FValidator := TQRangeValidator<TQValueType>.Create(AMinValue, AMaxValue,
    AErrorMsg, nil);
  TQRangeValidator<TQValueType>(FValidator).Bounds := ABounds;
end;

{ LengthRangeAttribute<TQValueType> }

constructor LengthRangeAttribute<TQValueType>.Create(const AMinSize,
  AMaxSize: SizeInt; const AErrorMsg: UnicodeString);
begin
  inherited Create;
  FValidator := TQLengthValidator<TQValueType>.Create(AMinSize, AMaxSize,
    AErrorMsg);
end;

{ DefaultValueAttribute<TQValueType> }

constructor DefaultValueAttribute<TQValueType>.Create
  (const AValue: TQValueType);
begin
  inherited Create;
  FValue := AValue;
end;

{ ValidatorAttribute }

constructor ValidatorAttribute.Create(const AName, AErrorMsg: UnicodeString);
begin
  inherited Create;
  FValidator := TQValidators.Custom<UnicodeString>(AName) as TQTextValidator;
  FErrorMsg := AErrorMsg;
end;

{ RegexValidatorAttribute }

constructor RegexValidatorAttribute.Create(const ARegexpr,
  AErrorMsg: UnicodeString);
begin
  inherited Create;
  FValidator := TQRegexValidator.Create(AErrorMsg);
  (FValidator.AsValidator as TQRegexValidator).Regex := ARegexpr;
end;

{ ThreadModeAttribute }

constructor ThreadModeAttribute.Create(AMode: TQMultiThreadMode);
begin
  inherited Create;
  FMode := AMode;
end;

{ TQTextAttribute }

constructor TQTextAttribute.Create(const AText: UnicodeString);
begin
  inherited Create;
  FText := AText;
end;

{ ValueListAttribute<TQValueType> }

{ ValueStorageAttribute }

constructor ValueStorageAttribute.Create(const AStorage: TQValueStorage);
begin
  inherited Create;
  FStorage := AStorage;
end;

{ NameFormatAttribute }

constructor NameFormatAttribute.Create(AFormat: TSerializeNameFormat);
begin
  inherited Create;
  FNameFormat := AFormat;
end;

{ DateTimeFormatAttribute }

constructor DateTimeFormatAttribute.Create(const AFormat
  : TSerializeDateTimeFormat; const AFormatText: String);
begin
  inherited Create;
  FFormat := AFormat;
  FFormatText := AFormatText;
end;

{ StringListAttribute }

constructor StringListAttribute.Create(const AValues: UnicodeString;
  ADelimiter: Char);
begin
  if ADelimiter = #0 then
    FValues := AValues.Split([',', ';', ' ', #9],
      TStringSplitOptions.ExcludeEmpty)
  else
    FValues := AValues.Split([ADelimiter], TStringSplitOptions.ExcludeEmpty)
end;

{ StringPairAttribute }

constructor StringPairAttribute.Create(const AKey, AValue: UnicodeString);
begin
  inherited Create;
  FKey := AKey;
  FValue := AValue;
end;

end.

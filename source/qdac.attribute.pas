unit qdac.attribute;

interface

uses Classes, Sysutils,Generics.Collections, qdac.common, qdac.validator;

const
  SHttpGet='GET';
  SHttpPost='POST';
  SHttpPut='PUT';
  SHttpDelete='DELETE';
type

  //内容为文本的注解基类
  TQTextAttribute = class(TCustomAttribute)
  protected
    FText:UnicodeString;
    property Text:String read FText;
  public
    constructor Create(const AText:UnicodeString);overload;
  end;

  // 路径注解，用于解析内容到特定的路径上去，路径间分隔使用反斜线“/”，如[Path('/home/swish')]
  PathAttribute = class(TQTextAttribute)
  public
    property Path: UnicodeString read FText;
  end;

  //方法名称注解，用于映射方法名，具体用途取决于使用的位置。如 [MethodName('GET')]
  MethodNameAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  //协议名称注解，如 [Protocol('https')]
  ProtocolAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  //架构名称注解，如 [Schema('public')]
  SchemaAttribute = class(ProtocolAttribute)
  public
    property Name:String read FText;
  end;

  //令牌类型，如[TokenType('jwt')]

  TokenTypeAttribute=class(TQTextAttribute)
  public
    property Kind:UnicodeString read FText;
  end;

  //基础路径，一般用于路由，如[BasePath('https://blog.qdac.cc/api/')]
  BasePathAttribute = class(TQTextAttribute)
  public
    property Path: UnicodeString read FText;
  end;

  //值列表，如 ValueList<Integer>([1,3,5])]
  ValueListAttribute<TQValueType>=class(TCustomAttribute)
  private
    FValues:TArray<TQValueType>;
  public
    constructor Create(const AValues:TArray<TQValueType>);overload;
    property Values: TArray<TQValueType> read FValues;
  end;

  // 别名注解，用于设置别名，以保持版本间兼容，如 [Alias(['name1','name2'])]
  AliasAttribute = class(ValueListAttribute<UnicodeString>)
  end;

  // 类型严格匹配模式，严格模式下，字符串与数值、布尔等类型之间不允许自动转换，而是抛出错误，如 [StrictType]
  StrictTypeAttribute = class(TCustomAttribute)
  end;

  // 日期时间类型格式
  TQDateTimeKind = (FormatedText, DelphiFloat, UnixTimeStamp, UnixTimeStampMS);
  // 日期时间类型转换，用来指明原始数据是那一个时间格式，如 [DateTimeKind(UnixTimeStamp)]
  DateTimeKindAttribute = class(TCustomAttribute)
  private
    FKind: TQDateTimeKind;
    FFormat: UnicodeString;
  public
    constructor Create(AKind: TQDateTimeKind; const AFormat: UnicodeString=''); overload;
    property Kind: TQDateTimeKind read FKind;
    property Format: UnicodeString read FFormat;
  end;

  //基于验证器的注解
  TQValidatorAttribute=class(TCustomAttribute)
  protected
    FValidator:IQValidator;
  public
    property Validator:IQValidator read FValidator;
  end;

  //值范围，如 [ValueRange<SmallInt>(0,120,'Age must between [MinValue]-[MaxValue]')]
  ValueRangeAttribute<TQValueType>=class(TQValidatorAttribute)
  public
    constructor Create(const AMinValue,AMaxValue:TQValueType;const AErrorMsg:UnicodeString=''; ABounds:TQRangeBounds=[]);
  end;

  //长度限制，如 [LengthRange<UnicodeString>(4,12,'[Size] out of range [MinSize] to [MaxSize]')]
  LengthRangeAttribute<TQValueType>=class(TQValidatorAttribute)
  public
    constructor Create(const AMinSize,AMaxSize:SizeInt;const AErrorMsg:UnicodeString='');
  end;

  //默认值，指明如果序列化时，没有赋值时如何处理，如果不指定，默认为 Default<TQValueType>，用例:[DefaultValue<String>('male')]
  DefaultValueAttribute<TQValueType>=class(TCustomAttribute)
  private
    FValue: TQValueType;
  public
    constructor Create(const AValue:TQValueType);overload;
    property Value:TQValueType read FValue;
  end;

  //序列化时忽略该项，用例：[Ignore]
  IgnoreAttribute=class(TCustomAttribute)

  end;

  //序列化时强制写入，用例：[NoDefault]
  NoDefaultAttribute=class(TCustomAttribute)

  end;

  //格式校验规则，如 [Validator('email')]指明值使用 email 验证器进行验证
  ValidatorAttribute=class(TQValidatorAttribute)
  private
    FErrorMsg: String;
  public
    constructor Create(const AName:UnicodeString; const AErrorMsg:UnicodeString = '');overload;
  end;

  //前缀，如 clWhite 指定前缀为 cl，则实际保存时，值被保存为 White，前缀和后缀可能有多个，如:
  // clSnow,clWebSnow，前缀分别是 cl,wlWebSnow，程序序列化时，优先使用较长前缀
  PrefixAttribute=class(TQTextAttribute)
  public
    property Prefix: UnicodeString read FText;
  end;

  //尾缀，如 DynamicOrder 指定后缀为 Order，则实际保存时，值被序列化为 Dynamic
  TailAttribute=class(TQTextAttribute)
  public
    property Tail:UnicodeString read FText;
  end;

  //序列化时，值保存的位置，如 XML 序列化或反序列化时，需要确定将值存在结点的属性还是子结点中
  TQValueStorage = (Attribute,ChildNode);
  //指定序列化元素位置，如果不指定，则继续上级结点的默认行为，如果都没指定，默认为属性，如果 [ValueStorage(ChildNode)]
  ValueStorageAttribute=class(TCustomAttribute)
  private
    FStorage: TQValueStorage;
  public
    constructor Create(const AStorage:TQValueStorage);overload;
    property Storage:TQValueStorage read FStorage;
  end;

  //正则表达式规则验证，如 [RegexValidator('^\d+$')]
  RegexValidatorAttribute=class(TQValidatorAttribute)
  public
    constructor Create(const ARegexpr: UnicodeString; const AErrorMsg: UnicodeString = '');overload;
  end;

  //类型转字符串格式设置，参考系统的 Format 函数，如：[TextFormat('%5.2f')]
  TextFormatAttribute=class(TQTextAttribute)
  public
    property Format: UnicodeString read FText;
  end;

  //文本转换器，用于将指定的值转换为特定的文本，比如首字母大写，小驼峰，大驼峰，全角转半角，首行缩进等等，这里只保存名称
  //如 Transform('FullToHalf')
  TransformAttribute=class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;


  //值模拟来源名称，为自动生成测试数据而创建，值来源名称由实现定义注册到 qdac.test.values.TQValueSources，如 [ValueSource('age')]
  ValueSourceAttribute=class(TQTextAttribute)
  public
    property SourceName:UnicodeString read FText;
  end;

  //多线程注解，指明某个函数是否可以在多线程中直接访问，三种模式：主线程（默认）、单线程（可后台单线程跑）、多线程
  //如 [ThreadMode(MainThread)] 限制函数只应在主线程中被调用
  TQMultiThreadMode = (MainThread,SingleThread,MultiThread);
  ThreadModeAttribute=class(TCustomAttribute)
  private
    FMode: TQMultiThreadMode;
  public
    constructor Create(AMode:TQMultiThreadMode);overload;
    property Mode:TQMultiThreadMode read FMode;
  end;

implementation

{ DateTimeKindAttribute }

constructor DateTimeKindAttribute.Create(AKind: TQDateTimeKind; const AFormat: UnicodeString);
begin
  inherited Create;
  FKind := AKind;
  FFormat := AFormat;
end;

{ ValueRangeAttribute<TQValueType> }

constructor ValueRangeAttribute<TQValueType>.Create(const AMinValue, AMaxValue: TQValueType;
  const AErrorMsg:UnicodeString; ABounds: TQRangeBounds);
begin
  inherited Create;
  FValidator := TQRangeValidator<TQValueType>.Create(AMinValue,AMaxValue,AErrorMsg,nil);
  TQRangeValidator<TQValueType>(FValidator).Bounds:=ABounds;
end;

{ LengthRangeAttribute<TQValueType> }

constructor LengthRangeAttribute<TQValueType>.Create(const AMinSize, AMaxSize: SizeInt; const AErrorMsg: UnicodeString);
begin
  inherited Create;
  FValidator := TQLengthValidator<TQValueType>.Create(AMinSize,AMaxSize,AErrorMsg);
end;

{ DefaultValueAttribute<TQValueType> }

constructor DefaultValueAttribute<TQValueType>.Create(const AValue: TQValueType);
begin
  inherited Create;
  FValue := AValue;
end;

{ ValidatorAttribute }

constructor ValidatorAttribute.Create(const AName,AErrorMsg:UnicodeString);
begin
  inherited Create;
  FValidator := TQValidators.Custom<UnicodeString>(AName) as TQTextValidator;
  FErrorMsg := AErrorMsg;
end;

{ RegexValidatorAttribute }

constructor RegexValidatorAttribute.Create(const ARegexpr,AErrorMsg: UnicodeString);
begin
  inherited Create;
  FValidator:=TQRegexValidator.Create(AErrorMsg);
  (FValidator.AsValidator as TQRegexValidator).Regex:=ARegexpr;
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

constructor ValueListAttribute<TQValueType>.Create(const AValues: TArray<TQValueType>);
begin
  inherited Create;
  FValues := Copy(AValues);
end;

{ ValueStorageAttribute }

constructor ValueStorageAttribute.Create(const AStorage: TQValueStorage);
begin
  inherited Create;
  FStorage := AStorage;
end;

end.

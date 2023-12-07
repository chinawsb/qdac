unit qdac.attribute;

interface

uses Classes, Sysutils,Generics.Collections, qdac.common, qdac.validator;

type

  //内容为文本的注解基类
  TQTextAttribute = class(TCustomAttribute)
  protected
    FText:UnicodeString;
    property Text:String read FText;
  public
    constructor Create(const AText:UnicodeString);overload;
  end;

  // 路径注解，用于解析内容到特定的路径上去，路径间分隔使用反斜线“/”
  PathAttribute = class(TQTextAttribute)
  public
    property Path: UnicodeString read FText;
  end;

  //方法名称注解
  MethodNameAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  //协议名称注解
  ProtocolAttribute = class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;

  //架构名称注解
  SchemaAttribute = class(ProtocolAttribute)
  public
    property Name:String read FText;
  end;

  //基础路径，一般用于路由
  BasePathAttribute = class(TQTextAttribute)
  public
    property Path: UnicodeString read FText;
  end;

  ValueListAttribute<TQValueType>=class(TCustomAttribute)
  private
    FValues:TArray<TQValueType>;
  public
    constructor Create(const AValues:TArray<TQValueType>);overload;
    property Values: TArray<TQValueType> read FValues;
  end;

  // 别名注解，用于设置别名，以保持版本间兼容
  AliasAttribute = class(TCustomAttribute)
  private
    FItems: TStringArray;
  public
    constructor Create(const AItems: TStringArray); overload;
    property Items: TStringArray read FItems;
  end;

  // 类型严格匹配模式，严格模式下，字符串与数值、布尔等类型之间不允许自动转换，而是抛出错误
  StrictTypeAttribute = class(TCustomAttribute)
  end;

  // 日期时间类型格式
  TQDateTimeKind = (FormatedText, DelphiFloat, UnixTimeStamp, UnixTimeStampMS);
  // 日期时间类型转换，用来指明原始数据是那一个时间格式
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

  //值范围
  ValueRangeAttribute<TQValueType>=class(TQValidatorAttribute)
  public
    constructor Create(const AMinValue,AMaxValue:TQValueType;const AErrorMsg:UnicodeString=''; ABounds:TQRangeBounds=[]);
  end;

  //长度限制
  LengthRangeAttribute<TQValueType>=class(TQValidatorAttribute)
  public
    constructor Create(const AMinSize,AMaxSize:SizeInt;const AErrorMsg:UnicodeString='');
  end;

  //默认值
  DefaultValueAttribute<TQValueType>=class(TCustomAttribute)
  private
    FValue: TQValueType;
  public
    constructor Create(const AValue:TQValueType);overload;
    property Value:TQValueType read FValue;
  end;

  //格式校验规则
  ValidatorAttribute=class(TQValidatorAttribute)
  private
    FErrorMsg: String;
  public
    constructor Create(const AName:UnicodeString; const AErrorMsg:UnicodeString = '');overload;
  end;

  //前缀
  PrefixAttribute=class(TQTextAttribute)
  public
    property Prefix: UnicodeString read FText;
  end;

  //尾缀
  TailAttribute=class(TQTextAttribute)
  public
    property Tail:UnicodeString read FText;
  end;

  //正则表达式规则验证
  RegexValidatorAttribute=class(TQValidatorAttribute)
  public
    constructor Create(const ARegexpr: UnicodeString; const AErrorMsg: UnicodeString = '');overload;
  end;

  //类型转字符串格式设置
  TextFormatAttribute=class(TQTextAttribute)
  public
    property Format: UnicodeString read FText;
  end;

  //文本转换器，用于将指定的值转换为特定的文本，比如首字母大写，小驼峰，大驼峰，全角转半角，首行缩进等等，这里只保存名称
  TextTransformAttribute=class(TQTextAttribute)
  public
    property Name: UnicodeString read FText;
  end;


  //值模拟来源名称，为自动生成测试数据而创建，值来源名称由实现定义注册到 qdac.test.values.TQValueSources
  ValueSourceAttribute=class(TQTextAttribute)
  public
    property SourceName:UnicodeString read FText;
  end;

  //多线程注解，指明某个函数是否可以在多线程中直接访问，三种模式：主线程（默认）、单线程（可后台单线程跑）、多线程
  TQMultiThreadMode = (MainThread,SingleThread,MultiThread);
  ThreadModeAttribute=class(TCustomAttribute)
  private
    FMode: TQMultiThreadMode;
  public
    constructor Create(AMode:TQMultiThreadMode);overload;
    property Mode:TQMultiThreadMode read FMode;
  end;

implementation

{ AliasAttribute }

constructor AliasAttribute.Create(const AItems: TStringArray);
begin
  inherited Create;
  FItems := Copy(AItems);
end;

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

end.

unit qdac.validator;

interface
uses System.Classes,System.SysUtils,System.TypInfo,System.Generics.Defaults,System.Generics.Collections,
  System.RegularExpressionsCore,System.Rtti;

type
  EValidateException=class(Exception)

  end;
  // 验证器的基类，声明基础的接口和方法
  TQValidator < TValueType >= class 
  private 
    FErrorMessage: UnicodeString;
  protected
    //验证器类型标志符，子类应该重该本方法
    class function GetTypeName: UnicodeString;virtual;
    class function FormatError(const AErrorMsg:UnicodeString;const AParams:TArray<TPair<UnicodeString, UnicodeString>>)
      :UnicodeString;static;

  public
    constructor Create(const AErrorMsg: UnicodeString); overload;
    function Accept(const AValue: TValueType): Boolean; virtual; abstract;
    procedure Check(const AValue: TValueType); virtual; abstract;
    function Require(const AValue: TValueType; const ADefaultValue: TValueType)
      : TValueType; virtual;abstract;
    property ErrorMessage: UnicodeString read FErrorMessage write FErrorMessage;
  end;

  TQLengthValidator<TValueType> = class(TQValidator<TValueType>)
  private
    FMinSize,FMaxSize: UInt64;
  protected
  public
    constructor Create(const AMinSize,AMaxSize:UInt64;const AErrorMsg: UnicodeString); overload;
    function Accept(const AValue: TValueType): Boolean; overload; override;
    procedure Check(const AValue: TValueType); overload; override;
    function Require(const AValue: TValueType; const ADefaultValue: TValueType)
      : TValueType; overload; override;
    property MinSize:UInt64 read FMinSize;
    property MaxSize:UInt64 read FMaxSize;
    //class methods
    class function LengthOf<TValueType>(const AValue:TValueType):UInt64;static;
    class function Accept<TValueType>(const AValue:TValueType;const AMinSize,AMaxSize:UInt64):Boolean; overload; static;
    class procedure Check<TValueType>(const AValue:TValueType;const AMinSize,AMaxSize:UInt64;
      const AErrorMsg: UnicodeString); overload; static;
    class function Require<TValueType>(const AValue:TValueType;const AMinSize,AMaxSize:UInt64;
      const ADefaultValue:TValueType):TValueType; overload; static;

  end;

  //边界处理规则，默认相等
  TQRangeBound=(GreatThanMin,LessThanMax);
  
  TQRangeBounds=set of TQRangeBound;
  
  TQRangeValidator<TValueType> = class(TQValidator<TValueType>)
  private
    FBounds:TQRangeBounds;
    FComparer:IComparer<TValueType>;
    FMinValue,FMaxValue:TValueType;
  protected
    class function GetTypeName: UnicodeString;override;
  public
    constructor Create(const AMinValue,AMaxValue:TValueType;const AErrorMsg: UnicodeString;
      AComparer:IComparer<TValueType>); overload;
    function Accept(const AValue: TValueType): Boolean; overload; override;
    procedure Check(const AValue: TValueType); overload; override;
    function Require(const AValue: TValueType; const ADefaultValue: TValueType)
      : TValueType; overload; override;    
    property MinValue:TValueType read FMinValue;
    property MaxValue:TValueType read FMaxValue;
    property Bounds:TQRangeBounds read FBounds write FBounds;
    //class methods
    class function Accept<TValueType>(const AValue:TValueType;const AMinValue,AMaxValue:TValueType;
      ABounds:TQRangeBounds=[];const AComparer:IComparer<TValueType>=nil):Boolean; overload; static;
    class procedure Check<TValueType>(const AValue:TValueType;const AMinValue,AMaxValue:TValueType;
      const AErrorMsg: UnicodeString;ABounds:TQRangeBounds=[];const AComparer:IComparer<TValueType>=nil); overload; static;
    class function Require<TValueType>(const AValue:TValueType;const AMinValue,AMaxValue:TValueType;
      const ADefaultValue:TValueType;ABounds:TQRangeBounds=[];const AComparer:IComparer<TValueType>=nil):TValueType; overload; static;
    
  end;
  
  //基于文本的验证规则
  TQTextValidator=class(TQValidator<UnicodeString>)
  protected
    class function GetValueTypeName: UnicodeString;virtual;
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
    procedure Check(const AValue: UnicodeString);  override;
    function Require(const AValue: UnicodeString; const ADefaultValue: UnicodeString='')
      : UnicodeString; override;    
  end;

  TQChineseIdValidator=class(TQTextValidator)
  protected
    class function GetValueTypeName: UnicodeString;override;
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
    function TryDecode(const AIdNo:UnicodeString;var ACityCode:String;var ABirthday:TDateTime;var AIsFemale:Boolean):Boolean;
  end;

  TQEmailValidator=class(TQTextValidator)
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
  end;

  //IPV4地址验证规则
  TQIPV4Validator=class(TQTextValidator)
  protected
    class function GetValueTypeName: UnicodeString;override;
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
  end;

  TQChineseMobileValidator=class(TQTextValidator)
  protected
    class function GetValueTypeName: UnicodeString;override;
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
  end;

  TQBase64Validator=class(TQTextValidator)
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
  end;

  TQUrlValidator = class(TQTextValidator)
  public
    function Accept(const AValue: UnicodeString): Boolean; override;
    function TryDecode(const AUrl:UnicodeString;var ASchema,AUserName,APassword,AHost,ADocPath:UnicodeString;
      var AParams:TArray<UnicodeString>; APort:Word):Boolean;
  end;

  
  //基于类型的规则验证实现，对特定类型的子规则都在其名下定义
  TQTypeValidator<TValueType>=class
  public
    type
      TQValidatorType=TQValidator<TValueType>;
  private
    var
    FTypeInfo:PTypeInfo;
    FItems:TDictionary<string,TQValidatorType>;
  public
    constructor Create(const AValidators:TArray<TQValidator<TValueType>>);
    destructor Destroy;override;
    /// <summary> 注册一个规则验证器 </summary>
    /// <param name="AName"> 规则名称，字符串类型，同名规则后注册替换先注册 </param>
    /// <param name="AValidator"> 对应规则的验证器 </param>
    procedure Register(const AName: UnicodeString;AValidator:TQValidatorType);
  end;
  
  TQValidators = class sealed
  private
    class var
      FCurrent:TQValidators;
      FEmail: TQTextValidator;
      FChineseMobile: TQTextValidator;
      FBase64: TQTextValidator;
      FChineseId: TQChineseIdValidator;
      FUrl: TQUrlValidator;
    class function GetCurrent:TQValidators;static;
  private
    FTypeValidators:TDictionary<PTypeInfo,TObject>;
    class function GetBase64: TQTextValidator; static;
    class function GetChineseId: TQChineseIdValidator; static;
    class function GetChineseMobile: TQTextValidator; static;
    class function GetEmail: TQTextValidator; static;
    class function GetUrl: TQUrlValidator; static;
  public
    constructor Create;
    destructor Destroy;override;
    class constructor Create;
    class destructor Destroy;
    class procedure Register<TValueType>(ATypeValidator:TQTypeValidator<TValueType>);
    //Known validators
    class function Length<TValueType>:TQLengthValidator<TValueType>;
    class function Range<TValueType>:TQRangeValidator<TValueType>;
    class function Custom<TValueType>(const AName:UnicodeString):TQValidator<TValueType>;
    class property Email:TQTextValidator read GetEmail write FEmail;
    class property ChineseMobile:TQTextValidator read GetChineseMobile write FChineseMobile;
    class property ChineseId:TQChineseIdValidator read GetChineseId write FChineseId;
    class property Base64:TQTextValidator read GetBase64 write FBase64;
    class property Url:TQUrlValidator read GetUrl write FUrl;
    class property Current:TQValidators read GetCurrent;
  end;

implementation

uses qdac.resource;

{ TQValidator<TValueType> }

constructor TQValidator<TValueType>.Create(const AErrorMsg: UnicodeString);
begin
  inherited Create;
  FErrorMessage := AErrorMsg;
end;

class function TQValidator<TValueType>.FormatError(const AErrorMsg:UnicodeString;const AParams: TArray<TPair<UnicodeString, UnicodeString>>): UnicodeString;
var
  ps,p:PWideChar;
  ABuilder:TStringBuilder;
  AName:String;
  AFound:Boolean;
begin
  //这里只支持简单替换，使用 \[ 可以避免 [xxx] 被解析为参数名
  ps := PWideChar(AErrorMsg);
  ABuilder := TStringBuilder.Create;
  try
    p := ps;
    while p^ <> #0 do
    begin
      if p^ = '\' then //转义 [，其它忽略
      begin
        ABuilder.Append(ps,0,p-ps);
        Inc(p);
        if p ^= '[' then
          ABuilder.Append(p^)
        else
          ABuilder.Append('\');
        ps := p;
      end
      else if p ^= '[' then
        begin
          ABuilder.Append(ps,0,p-ps);
          Inc(p);
          ps:=p;
          while ( p^ <> #0 ) and (p^<> ']') do
          begin
            Inc(p);
          end;
          if p^ = ']' then
          begin
            AName:=Copy(ps,0,p-ps);
            AFound:=false;
            for var I := 0 to High(AParams) do
            begin
              if CompareText(AName,AParams[I].Key)=0 then
              begin
                ABuilder.Append(AParams[I].Value);
                AFound := true;
                break;
              end;
            end;
            if not AFound then
            begin
              ABuilder.Append('[').Append(AName).Append(']');
            end;
          end
          else
          begin
            ABuilder.Append(ps);
          end;
        end
      else
        Inc(p);
    end;
    Result:=ABuilder.ToString;
  finally
    FreeAndNil(ABuilder);
  end;
end;

class function TQValidator<TValueType>.GetTypeName: UnicodeString;
begin
  //默认验证器类型名称规则，去掉前面的 TQ 和后面的 Validator 后小写，如 TQLengthValidator<UnicodeString> 解析为 length
  Result:=ClassName.Split(['<','>'],TSTringSplitOptions.ExcludeEmpty)[0];
  if Result.StartsWith('TQ') and Result.EndsWith('Validator') then
    Result:=Result.Substring(2,Length(Result)-11).ToLower
  else if Result.StartsWith('T') then
    Result:=Result.Substring(1,Length(Result)-1).ToLower;
end;

{ TQLengthValidator<TValueType> }

function TQLengthValidator<TValueType>.Accept(
  const AValue: TValueType): Boolean;
begin
  Result:=Accept<TValueType>(AValue,FMinSize,FMaxSize);
end;

class function TQLengthValidator<TValueType>.Accept<TValueType>(
  const AValue: TValueType; const AMinSize, AMaxSize: UInt64): Boolean;
var
  ALen:UInt64;
begin
  Assert((AMaxSize>=AMinSize) and (AMinSize>=0),SAssertSizeError);
  if AMaxSize>0 then
  begin
    ALen := LengthOf<TValueType>(AValue);
    Result:= (ALen >= AMinSize) and (ALen <= AMaxSize);
  end
  else
    Result:=true;
end;

procedure TQLengthValidator<TValueType>.Check(const AValue: TValueType);
begin
  Check<TValueType>(AValue,FMinSize,FMaxSize,FErrorMessage);
end;

class procedure TQLengthValidator<TValueType>.Check<TValueType>(
  const AValue: TValueType; const AMinSize, AMaxSize: UInt64;
  const AErrorMsg: UnicodeString);
begin
  if not Accept<TValueType>(AValue,AMinSize,AMaxSize) then
    raise EValidateException.Create(FormatError(AErrorMsg,[
      TPair<UnicodeString,UnicodeString>.Create('Size',LengthOf<TValueType>(AValue).ToString),
      TPair<UnicodeString,UnicodeString>.Create('MinSize',AMinSize.ToString),
      TPair<UnicodeString,UnicodeString>.Create('MaxSize',AMaxSize.ToString)
      ]));
end;

constructor TQLengthValidator<TValueType>.Create(const AMinSize, AMaxSize: UInt64; const AErrorMsg: UnicodeString);
begin
  Assert((AMaxSize>=AMinSize) and (AMinSize>=0),SAssertSizeError);
  inherited Create(AErrorMsg);
  FMinSize:=AMinSize;
  FMaxSize:=AMaxSize;
end;

class function TQLengthValidator<TValueType>.LengthOf<TValueType>(const AValue: TValueType): UInt64;
begin
  //只有字符串、动态数组类型支持长度判断
  case GetTypeData(TypeInfo(TValueType)).BaseType^.Kind of
    tkUnicodeString:
      Result := Length(PUnicodeString(@AValue)^);
    tkAnsiString:
      Result := Length(PAnsiString(@AValue)^);
    tkWideString:
      Result := Length(PWideString(@AValue)^);
    tkDynArray:
      Result := DynArraySize(@AValue)
    else
      raise EValidateException.Create(SLengthOnlySupportStringAndArray);
  end;
end;

function TQLengthValidator<TValueType>.Require(const AValue,
  ADefaultValue: TValueType): TValueType;
begin
  Result:=Require<TValueType>(AValue,FMinSize,FMaxSize,ADefaultValue);
end;

class function TQLengthValidator<TValueType>.Require<TValueType>(const AValue: TValueType;
  const AMinSize, AMaxSize: UInt64;const ADefaultValue:TValueType):TValueType;
begin
  if Accept<TValueType>(AValue,AMinSize,AMaxSize) then
    Result:=AValue
  else
    Result:=ADefaultValue;
end;

{ TQValidator }

constructor TQValidators.Create;
begin
  inherited;
  FTypeValidators:=TDictionary<PTypeInfo,TObject>.Create;
  FEmail:= TQEmailValidator.Create(SValueTypeError);
  FChineseMobile:=TQChineseMobileValidator.Create(SValueTypeError);
  FBase64:=TQBase64Validator.Create(SValueTypeError);
  FChineseId:= TQChineseIdValidator.Create(SValueTypeError);
  FUrl:= TQUrlValidator.Create(SValueTypeError);
end;

class constructor TQValidators.Create;
begin
  FCurrent:=TQValidators.Create;
end;

class function TQValidators.Custom<TValueType>(
  const AName: UnicodeString): TQValidator<TValueType>;
var
  AValidators:TQTypeValidator<TValueType>;
begin
  Result:=nil;
  TMonitor.Enter(FCurrent.FTypeValidators);
  try
    if FCurrent.FTypeValidators.TryGetValue(TypeInfo(TValueType),TObject(AValidators)) then
    begin
      AValidators.FItems.TryGetValue(AName,TQValidator<TValueType>(Result));
    end;
  finally
    TMonitor.Exit(FCurrent.FTypeValidators);
  end;
end;

class destructor TQValidators.Destroy;
begin
  FreeAndNil(FCurrent);
end;

destructor TQValidators.Destroy;
var
  AItems:TArray<TObject>;
  I:Integer;
begin
  AItems:=FTypeValidators.Values.ToArray;
  for I := 0 to High(AItems) do
  begin
    FreeAndNil(AItems[I]);
  end;
  FreeAndNil(FTypeValidators);
end;

class function TQValidators.GetBase64: TQTextValidator;
begin
  if not Assigned(FBase64) then
    begin
    var ATemp:=TQBase64Validator.Create(SValueTypeError);
    end;
  Result := FBase64;
end;

class function TQValidators.GetChineseId: TQChineseIdValidator;
begin
  Result := FChineseId;
end;

class function TQValidators.GetChineseMobile: TQTextValidator;
begin
  Result := FChineseMobile;
end;

class function TQValidators.GetCurrent: TQValidators;
begin
  Result:=FCurrent;
end;

class function TQValidators.GetEmail: TQTextValidator;
begin
  Result := FEmail;
end;

class function TQValidators.GetUrl: TQUrlValidator;
begin
  Result := FUrl;
end;

class function TQValidators.Length<TValueType>: TQLengthValidator<TValueType>;
type
  TLengthValidator=TQLengthValidator<TValueType>;
begin
  Result:=Custom<TValueType>(TLengthValidator.GetTypeName) as TLengthValidator;
end;

class function TQValidators.Range<TValueType>: TQRangeValidator<TValueType>;
type
  TRangeValidator=TQRangeValidator<TValueType>;
begin
  Result:=Custom<TValueType>(TRangeValidator.GetTypeName) as TRangeValidator;
end;

class procedure TQValidators.Register<TValueType>(
  ATypeValidator: TQTypeValidator<TValueType>);
var
  AExists:TQTypeValidator<TValueType>;
begin
  TMonitor.Enter(FCurrent.FTypeValidators);
  try
    if not FCurrent.FTypeValidators.TryGetValue(TypeInfo(TValueType),TObject(AExists)) then
      AExists := nil;
    if AExists<>ATypeValidator then
    begin
      FCurrent.FTypeValidators.AddOrSetValue(TypeInfo(TValueType),ATypeValidator);
      if Assigned(AExists) then
        FreeAndNil(AExists);
    end;
  finally
    TMonitor.Exit(FCurrent.FTypeValidators);
  end;
end;

{ TQTypeValidator<TValueType> }

constructor TQTypeValidator<TValueType>.Create(const AValidators:TArray<TQValidator<TValueType>>);
var
  I:Integer;
begin
  inherited Create;
  FTypeInfo:=TypeInfo(TValueType);
  FItems:=TDictionary<String,TQValidator<TValueType>>.Create;
  for I := 0 to High(AValidators) do
    FItems.AddOrSetValue(AValidators[I].GetTypeName,AValidators[I]);
end;

destructor TQTypeValidator<TValueType>.Destroy;
var
  AItems:TArray<TQValidatorType>;
  I:Integer;
begin
  AItems:=FItems.Values.ToArray;
  for I:= 0 to High(AItems) do
  begin
    FreeAndNil(AItems[I]);
  end;
  FreeAndNil(FItems);
  inherited;
end;

procedure TQTypeValidator<TValueType>.Register(const AName: UnicodeString;
  AValidator: TQValidatorType);
var
  AExists:TQValidatorType;  
begin
  //Register must call before any process
  if not FItems.TryGetValue(AName,AExists) then
    AExists:=nil;
  if AExists <> AValidator then
  begin
    FItems.AddOrSetValue(AName,AValidator);
    if Assigned(AExists) then
    begin
      FreeAndNil(AExists);
    end;
  end;
end;

{ TQRangeValidator<TValueType> }

function TQRangeValidator<TValueType>.Accept(const AValue: TValueType): Boolean;
begin
  Result:=Accept<TValueType>(AValue,FMinValue,FMaxValue,FBounds);
end;

class function TQRangeValidator<TValueType>.Accept<TValueType>(const AValue,
  AMinValue, AMaxValue: TValueType; ABounds: TQRangeBounds;const AComparer:IComparer<TValueType>): Boolean;
var
  AMinResult,AMaxResult:Integer;
begin
  if Assigned(AComparer) then
  begin
    AMinResult := AComparer.Compare(AValue, AMinValue);
    AMaxResult := AComparer.Compare(AValue, AMaxValue);
  end
  else
  begin
    with TComparer<TValueType>.Default do
    begin
      AMinResult := Compare(AValue, AMinValue);
      AMaxResult := Compare(AValue, AMaxValue);
    end;
  end;
  Result:=((AMinResult > 0) or ((AMinResult = 0) and (not (TQRangeBound.GreatThanMin in ABounds)))) and
    ((AMaxResult < 0) or ((AMaxResult = 0) and (not (TQRangeBound.LessThanMax in ABounds))));
end;

procedure TQRangeValidator<TValueType>.Check(const AValue: TValueType);
begin
  Check<TValueType>(AValue,FMinValue,FMaxValue,FErrorMessage,FBounds);
end;

class procedure TQRangeValidator<TValueType>.Check<TValueType>(const AValue,
  AMinValue, AMaxValue: TValueType; const AErrorMsg: UnicodeString;
  ABounds: TQRangeBounds;const AComparer:IComparer<TValueType>);
begin
  if not Accept<TValueType>(AValue,AMinValue,AMaxValue,ABounds,AComparer) then
  begin
    raise EValidateException.Create(FormatError(AErrorMsg,[
      TPair<UnicodeString,UnicodeString>.Create('Value',TValue.From<TValueType>(AValue).ToString),
      TPair<UnicodeString,UnicodeString>.Create('MinValue',TValue.From<TValueType>(AMinValue).ToString),
      TPair<UnicodeString,UnicodeString>.Create('MaxValue',TValue.From<TValueType>(AMaxValue).ToString)
      ]));
  end;
end;

constructor TQRangeValidator<TValueType>.Create(const AMinValue,
  AMaxValue: TValueType; const AErrorMsg: UnicodeString;AComparer:IComparer<TValueType>);
begin
  inherited Create(AErrorMsg);
  FMinValue := AMinValue;
  FMaxValue := AMaxValue;
  if Assigned(AComparer) then
    FComparer := AComparer
  else
    FComparer := TComparer<TValueType>.Default;
end;

class function TQRangeValidator<TValueType>.GetTypeName: UnicodeString;
begin
  Result:='range';//Dont localize
end;

function TQRangeValidator<TValueType>.Require(const AValue,
  ADefaultValue: TValueType): TValueType;
begin
  Result:=Require<TValueType>(AValue,FMinValue,FMaxValue,ADefaultValue,FBounds);
end;

class function TQRangeValidator<TValueType>.Require<TValueType>(const AValue,
  AMinValue, AMaxValue, ADefaultValue: TValueType;
  ABounds: TQRangeBounds;const AComparer:IComparer<TValueType>): TValueType;
begin
  if Accept<TValueType>(AValue,AMinValue,AMaxValue,ABounds,AComparer) then
    Result := AValue
  else
    Result := ADefaultValue;
end;

/// <summary>注册默认的验证器</summary>

procedure RegisterDefaultValidators;
begin
  //字符串，默认可以执行长度校验
  with TQValidators.FCurrent do
  begin
    FTypeValidators.Add(TypeInfo(UnicodeString),
    TQTypeValidator<UnicodeString>.Create([
     TQLengthValidator<UnicodeString>.Create(0, 0, SDefaultLengthError)
     ]
    ));
    FTypeValidators.Add(TypeInfo(AnsiString),
      TQTypeValidator<AnsiString>.Create([
       TQLengthValidator<AnsiString>.Create(0, 0, SDefaultLengthError)
       ]
      ));
    FTypeValidators.Add(TypeInfo(WideString),
      TQTypeValidator<WideString>.Create([
       TQLengthValidator<WideString>.Create(0, 0, SDefaultLengthError)
       ]
      ));
    FTypeValidators.Add(TypeInfo(ShortString),
      TQTypeValidator<ShortString>.Create([
       TQLengthValidator<ShortString>.Create(0, 0, SDefaultLengthError)
       ]
      ));
    //数值类型
    FTypeValidators.Add(TypeInfo(Shortint),
      TQTypeValidator<Shortint>.Create([
       TQRangeValidator<Shortint>.Create(-128, 127, SDefaultRangeError,nil)
       ]
      ));
    FTypeValidators.Add(TypeInfo(Smallint),
      TQTypeValidator<Smallint>.Create([
       TQRangeValidator<Smallint>.Create(-32768,32767,SDefaultRangeError,nil)
       ]
      ));
    FTypeValidators.Add(TypeInfo(Integer),
      TQTypeValidator<Integer>.Create([
       TQRangeValidator<Integer>.Create(-2147483648,2147483647,SDefaultLengthError,nil)
       ]
      ));
    FTypeValidators.Add(TypeInfo(Int64),
      TQTypeValidator<Int64>.Create([
       TQRangeValidator<Int64>.Create(-9223372036854775808,9223372036854775807,SDefaultLengthError,nil)
       ]
      ));
    FTypeValidators.Add(TypeInfo(Byte),
      TQTypeValidator<Byte>.Create([
       TQRangeValidator<Byte>.Create(0, 255, SDefaultRangeError,nil)
       ]
      ));
    FTypeValidators.Add(TypeInfo(Word),
      TQTypeValidator<Word>.Create([
       TQLengthValidator<Word>.Create(0,65535,SDefaultRangeError)
       ]
      ));
    FTypeValidators.Add(TypeInfo(UINT32),
      TQTypeValidator<UINT32>.Create([
       TQLengthValidator<UINT32>.Create(0, 4294967295, SDefaultLengthError)
       ]
      ));
    FTypeValidators.Add(TypeInfo(UInt64),
      TQTypeValidator<UInt64>.Create([
       TQLengthValidator<UInt64>.Create(0, 18446744073709551615,SDefaultLengthError)
       ]
      ));
  end;
end;

{ TQChineseIdValidator }

function TQChineseIdValidator.Accept(const AValue: UnicodeString): Boolean;
var
  ACityCode:UnicodeString;
  ABirthday:TDateTime;
  AIsFemale:Boolean;
begin
  Result:=TryDecode(AValue,ACityCode,ABirthday,AIsFemale);
end;

class function TQChineseIdValidator.GetValueTypeName: UnicodeString;
begin
  Result:=SChineseId;
end;

function TQChineseIdValidator.TryDecode(const AIdNo: UnicodeString; var ACityCode: UnicodeString; var ABirthday: TDateTime;
  var AIsFemale: Boolean): Boolean;
begin
  //Todo:
  Result:=false;
end;

{ TQTextValidator }

function TQTextValidator.Accept(const AValue: UnicodeString): Boolean;
begin
  Result:=true;
end;

procedure TQTextValidator.Check(const AValue: UnicodeString);
begin
  if not Accept(AValue) then
  begin
    raise EValidateException.Create(FormatError(FErrorMessage,[
      TPair<UnicodeString,UnicodeString>.Create('Value',AValue),
      TPair<UnicodeString,UnicodeString>.Create('ValueType',GetTypeName)
      ]));
  end;
end;

class function TQTextValidator.GetValueTypeName: UnicodeString;
begin
  Result := GetTypeName;
end;

function TQTextValidator.Require(const AValue, ADefaultValue: UnicodeString): UnicodeString;
begin
  if Accept(AValue) then
  begin
    Result := AValue;
  end
  else
  begin
    Result := ADefaultValue;
  end;
end;

{ TQEmailValidator }

function TQEmailValidator.Accept(const AValue: UnicodeString): Boolean;
begin
  //Todo:验证邮件地址
end;

{ TQChinesseMobile }

function TQChineseMobileValidator.Accept(const AValue: UnicodeString): Boolean;
begin
  //Todo:验证手机号
end;

{ TQBase64Validator }

function TQBase64Validator.Accept(const AValue: UnicodeString): Boolean;
begin
  //Todo:验证 Base64 编码
end;

{ TQUrlValidator }

function TQUrlValidator.Accept(const AValue: UnicodeString): Boolean;
var
  ASchema,AUserName,APassword,AHost,APath:UnicodeString;
  AParams:TArray<UnicodeString>;
  APort:Word;
begin
  Result:=TryDecode(AValue,ASchema,AUserName,APassword,AHost,APath,AParams,APort);
end;

function TQUrlValidator.TryDecode(const AUrl: UnicodeString; var ASchema, AUserName, APassword, AHost,
  ADocPath: UnicodeString; var AParams: TArray<UnicodeString>; APort: Word): Boolean;
begin
  //Todo: 验证URL
end;

class function TQChineseMobileValidator.GetValueTypeName: UnicodeString;
begin
  Result:=SChineseMobile;
end;

{ TQIPV4Validator }

function TQIPV4Validator.Accept(const AValue: UnicodeString): Boolean;
var
  len,i,ipSegCount,segStart: Integer;
  ipByte,curCode: SmallInt;
begin
  len := Length(AValue);
  if (len < 7) or (len > 15) then
    exit(false);
  ipSegCount := 0;
  segStart := 1;
  ipByte := 0;
  for i := 1 to len do
  begin
     if ipSegCount > 3 then
       exit(false);
     case AValue[i] of
     '0'..'9':
       begin
         ipByte := ipByte*10+ Ord(AValue[i]) - 48;
         if ipByte > 255 then
           Exit(False);
       end;
     '.':
       begin
         inc(ipSegCount);
         ipByte := 0;
       end;
     else
       Exit(False);
     end;
  end;
  Result := (ipSegCount = 3) and (ipByte < 255);
end;

class function TQIPV4Validator.GetValueTypeName: UnicodeString;
begin
  Result := SIPV4;
end;

initialization
  RegisterDefaultValidators;
end.

unit qdac.validator;

interface
uses System.Classes,System.SysUtils,System.TypInfo,System.Generics.Defaults,System.Generics.Collections,
  System.RegularExpressionsCore;

type

  TQValidator < TValueType >= class 
  private 
    FErrorMessage: UnicodeString;
  protected
    class function GetTypeName: UnicodeString;virtual;
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
    FMinSize,FMaxSize:NativeInt;  
  protected
    class function GetTypeName: UnicodeString;override;
  public
    constructor Create(const AMinSize,AMaxSize:NativeInt;const AErrorMsg: UnicodeString); overload;
    function Accept(const AValue: TValueType): Boolean; overload; override;
    procedure Check(const AValue: TValueType); overload; override;
    function Require(const AValue: TValueType; const ADefaultValue: TValueType)
      : TValueType; overload; override;    
    property MinSize:NativeInt read FMinSize;
    property MaxSize:NativeInt read FMaxSize;
    //class methods
    class function Accept<TValueType>(const AValue:TValueType;const AMinSize,AMaxSize:NativeInt):Boolean; overload; static;
    class function Check<TValueType>(const AValue:TValueType;const AMinSize,AMaxSize:NativeInt;
      const AErrorMsg: UnicodeString):Boolean; overload; static;
    class function Require<TValueType>(const AValue:TValueType;const AMinSize,AMaxSize:NativeInt;
      const ADefaultValue:TValueType):TValueType; overload; static;

  end;

  //边界处理规则，默认相等
  TQRangeBound=(GreateThanMin,LessThanMax);
  
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
      ABounds:TQRangeBounds):Boolean; overload; static;
    class function Check<TValueType>(const AValue:TValueType;const AMinValue,AMaxValue:TValueType;
      const AErrorMsg: UnicodeString;ABounds:TQRangeBounds):Boolean; overload; static;
    class function Require<TValueType>(const AValue:TValueType;const AMinValue,AMaxValue:TValueType;
      const ADefaultValue:TValueType;ABounds:TQRangeBounds):TValueType; overload; static;
    
  end;
    
  TQTypeValidator<TValueType>=class
  public
    type
      TQValidatorType=TQValidator<TValueType>;
  private
    var
    FTypeInfo:PTypeInfo;
    FItems:TDictionary<string,TQValidatorType>;
  public
    constructor Create(AType:PTypeInfo);
    destructor Destroy;override;
    procedure Register(const AName: UnicodeString;AValidator:TQValidatorType);
  end;
  
  TQValidator = class sealed
  private
    class var
      FTypeValidators:TDictionary<PTypeInfo,TObject>;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Register<TValueType>(ATypeValidator:TQTypeValidator<TValueType>);
    class function Length<TValueType>:TQLengthValidator<TValueType>;
    class function Range<TValueType>:TQRangeValidator<TValueType>;
    class function Custom<TValueType>(const AName:UnicodeString):TQValidator<TValueType>;
  end;

implementation

uses qdac.resource;

type
  TUnicodeStringValidator=class(TQTypeValidator<UnicodeString>)
  public
    constructor Create;overload;
  end;


{ TQValidator<TValueType> }

constructor TQValidator<TValueType>.Create(const AErrorMsg: UnicodeString);
begin
  inherited Create;
  FErrorMessage := AErrorMsg;
end;

class function TQValidator<TValueType>.GetTypeName: UnicodeString;
begin
  Result:='';
end;

{ TQLengthValidator<TValueType> }

function TQLengthValidator<TValueType>.Accept(
  const AValue: TValueType): Boolean;
begin
  Result:=Accept<TValueType>(AValue,FMinSize,FMaxSize);
end;

class function TQLengthValidator<TValueType>.Accept<TValueType>(
  const AValue: TValueType; const AMinSize, AMaxSize: NativeInt): Boolean;
begin
  Result:=true;
  //todo:TQLengthValidator<TValueType>.Accept
  
end;

procedure TQLengthValidator<TValueType>.Check(const AValue: TValueType);
begin
  Check<TValueType>(AValue,FMinSize,FMaxSize,FErrorMessage);
end;

class function TQLengthValidator<TValueType>.Check<TValueType>(
  const AValue: TValueType; const AMinSize, AMaxSize: NativeInt;
  const AErrorMsg: UnicodeString): Boolean;
begin
  Result:=true;
  //todo:TQLengthValidator<TValueType>.Check
end;

constructor TQLengthValidator<TValueType>.Create(const AMinSize, AMaxSize: NativeInt; const AErrorMsg: UnicodeString);
begin
  Assert((AMaxSize>=AMinSize) and (AMinSize>=0),'AMaxSize must >= AMinSize and AMinSize must >= 0');
  inherited Create(AErrorMsg);
  FMinSize:=AMinSize;
  FMaxSize:=AMaxSize;
end;

class function TQLengthValidator<TValueType>.GetTypeName: UnicodeString;
begin
  Result:='length';//fixed,dont localize
end;

function TQLengthValidator<TValueType>.Require(const AValue,
  ADefaultValue: TValueType): TValueType;
begin
  Result:=Require<TValueType>(AValue,FMinSize,FMaxSize,ADefaultValue);
end;

class function TQLengthValidator<TValueType>.Require<TValueType>(const AValue: TValueType;
  const AMinSize, AMaxSize: NativeInt;const ADefaultValue:TValueType):TValueType;
begin
  Result:=Default(TValueType);
  //todo:TQLengthValidator<TValueType>.Require
end;

{ TQValidator }

class constructor TQValidator.Create;
begin
  FTypeValidators:=TDictionary<PTypeInfo,TObject>.Create;  
end;

class function TQValidator.Custom<TValueType>(
  const AName: UnicodeString): TQValidator<TValueType>;
var
  AValidators:TQTypeValidator<TValueType>;
begin
  Result:=nil;
  TMonitor.Enter(FTypeValidators);
  try
    if FTypeValidators.TryGetValue(TypeInfo(TValueType),TObject(AValidators)) then
    begin
      AValidators.FItems.TryGetValue(AName,TQValidator<TValueType>(Result));
    end;
  finally
    TMonitor.Exit(FTypeValidators);
  end;
end;

class destructor TQValidator.Destroy;
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

class function TQValidator.Length<TValueType>: TQLengthValidator<TValueType>;
type
  TLengthValidator=TQLengthValidator<TValueType>;
begin
  Result:=Custom<TValueType>(TLengthValidator.GetTypeName) as TLengthValidator;
end;

class function TQValidator.Range<TValueType>: TQRangeValidator<TValueType>;
type
  TRangeValidator=TQRangeValidator<TValueType>;
begin
  Result:=Custom<TValueType>(TRangeValidator.GetTypeName) as TRangeValidator;
end;

class procedure TQValidator.Register<TValueType>(
  ATypeValidator: TQTypeValidator<TValueType>);
var
  AExists:TQTypeValidator<TValueType>;
begin
  TMonitor.Enter(FTypeValidators);
  try
    if not FTypeValidators.TryGetValue(TypeInfo(TValueType),TObject(AExists)) then
      AExists := nil;
    if AExists<>ATypeValidator then
    begin
      FTypeValidators.AddOrSetValue(TypeInfo(TValueType),ATypeValidator);
      if Assigned(AExists) then
        FreeAndNil(AExists);
    end;
  finally
    TMonitor.Exit(FTypeValidators);
  end;
end;

{ TQTypeValidator<TValueType> }

constructor TQTypeValidator<TValueType>.Create(AType: PTypeInfo);
begin
  inherited Create;
  FTypeInfo:=AType;
  FItems:=TDictionary<String,TQValidator<TValueType>>.Create;
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
  AMinValue, AMaxValue: TValueType; ABounds: TQRangeBounds): Boolean;
begin
  //Todo:TQRangeValidator<TValueType>.Accept
end;

procedure TQRangeValidator<TValueType>.Check(const AValue: TValueType);
begin
  Check<TValueType>(AValue,FMinValue,FMaxValue,FErrorMessage,FBounds);
end;

class function TQRangeValidator<TValueType>.Check<TValueType>(const AValue,
  AMinValue, AMaxValue: TValueType; const AErrorMsg: UnicodeString;
  ABounds: TQRangeBounds): Boolean;
begin
  //Todo:TQRangeValidator<TValueType>.Accept
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
  ABounds: TQRangeBounds): TValueType;
begin
  //Todo:TQRangeValidator<TValueType>.Require
end;

{ TUnicodeStringValidator }

constructor TUnicodeStringValidator.Create;
var
  AValidator:TQValidator<UnicodeString>;
begin
  inherited Create(TypeInfo(UnicodeString));
  AValidator:=TQLengthValidator<UnicodeString>.Create(0,0,SDefaultLengthError);
  Register(AValidator.GetTypeName,AValidator);
end;

/// <summary>注册默认的验证器</summary>

procedure RegisterDefaultValidators;
begin
  TQValidator.FTypeValidators.Add(TypeInfo(UnicodeString),TUnicodeStringValidator.Create);
  //Todo:实现各个验证器
end;

initialization
  RegisterDefaultValidators;
end.

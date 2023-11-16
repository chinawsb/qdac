unit qjson_output_channel;

interface

uses classes, sysutils, math, variants, fmtbcd, typinfo, qstring, qjson,
  qjson_input_channel;

{
  本源码来自QDAC项目，版权归swish(QQ:109867294)所有。
  (1)、使用许可及限制
  您可以自由复制、分发、修改本源码，但您的修改应该反馈给作者，并允许作者在必要时，
  合并到本项目中以供使用，合并后的源码同样遵循QDAC版权声明限制。
  您的产品的关于中，应包含以下的版本声明:
  本产品使用的JSON解析器来自QDAC项目中的QJSON，版权归作者所有。
  (2)、技术支持
  有技术问题，您可以加入QDAC官方QQ群250530692共同探讨。
  (3)、赞助
  您可以自由使用本源码而不需要支付任何费用。如果您觉得本源码对您有帮助，您可以赞
  助本项目（非强制），以使作者不为生活所迫，有更多的精力为您呈现更好的作品：
  赞助方式：
  支付宝： guansonghuan@sina.com 姓名：管耸寰
  建设银行：
  户名：管耸寰
  账号：4367 4209 4324 0179 731
  开户行：建设银行长春团风储蓄所
}
{ 修订日志
  2021.12.14
  ==========
  + 初始版本
}
type
  IQJsonObjectEncoder = interface;
  IQJsonArrayEncoder = interface;
{$IFDEF UNICODE}
  TQJsonArrayCallback = reference to procedure(AParent: IQJsonArrayEncoder);
  TQJsonObjectCallback = reference to procedure(ASender: IQJsonObjectEncoder);
{$ELSE}
  TQJsonArrayCallback = procedure(AParent: IQJsonArrayEncoder) of object;
  TQJsonObjectCallback = procedure(ASender: IQJsonObjectEncoder) of object;
{$ENDIF}

  TQParamPair = record
    Key: QStringW;
    Value: Variant; //
    class function Create(const AKey: QStringW; const AValue: Variant)
      : TQParamPair; static;
  end;

  TQJsonParams = array of TQParamPair;

  IQJsonArrayEncoder = interface
    ['{AB651EAF-E654-4EB7-BB52-36E9820496C6}']
    procedure Write(const V: Double); overload;
    procedure Write(const V: Int64); overload;
    procedure Write(const V: TDateTime); overload;
    procedure Write(const V: QStringW); overload;
    procedure Write(const V: PWideChar); overload;
    procedure WriteBase64(const V: TBytes); overload;
    procedure WriteBase64(const AStream: TStream); overload;
    procedure WriteBase64(const AFileName: QStringW); overload;
    procedure WriteBase64(const V: PByte; const ALen: Integer); overload;
    procedure Write; overload;
    procedure Write(const V: Boolean); overload;
    procedure Write(AJson: TQJson); overload;
    procedure Write(const V: TBcd); overload;
    procedure Write(const V: TObject; AParams: TQJsonParams = []); overload;
    procedure WriteArray(ACallback: TQJsonArrayCallback);
    procedure WriteObject(ACallback: TQJsonObjectCallback);
  end;

  IQJsonObjectEncoder = interface
    ['{D43D8B3C-7A1A-42A8-8C66-971C5E1A76F2}']
    procedure Write(const AName: QStringW; const V: Double); overload;
    procedure Write(const AName: QStringW; const V: Int64); overload;
    procedure Write(const AName: QStringW; const V: TDateTime); overload;
    procedure Write(const AName: QStringW; const V: QStringW); overload;
    procedure Write(const AName: QStringW; const V: PWideChar); overload;
    procedure WriteBase64(const AName: QStringW; const V: TBytes); overload;
    procedure WriteBase64(const AName: QStringW;
      const AStream: TStream); overload;
    procedure WriteBase64(const AName: QStringW;
      const AFileName: QStringW); overload;
    procedure WriteBase64(const AName: QStringW; const V: PByte;
      const ALen: Integer); overload;
    procedure Write(const AName: QStringW); overload;
    procedure Write(const AName: QStringW; const V: Boolean); overload;
    procedure Write(const AName: QStringW; AJson: TQJson); overload;
    procedure Write(const AName: QStringW; const V: TBcd); overload;
    procedure Write(const AName: QStringW; const V: TObject;
      AParams: TQJsonParams = []); overload;
    procedure WriteArray(const AName: QStringW; ACallback: TQJsonArrayCallback);
    procedure WriteObject(const AName: QStringW;
      ACallback: TQJsonObjectCallback);
  end;

  IQJsonStreamEncoder = interface
    ['{D8D41F1D-6520-41D9-ADE2-F2EE1D172B3E}']
    // 数组结点下写入子元素
    procedure WriteElement(const V: Double); overload;
    procedure WriteElement(const V: Extended); overload;
    procedure WriteElement(const V: Int64); overload;
    procedure WriteElement(const V: TDateTime); overload;
    procedure WriteElement(const V: QStringW); overload;
    procedure WriteElement(const V: PWideChar); overload;
    procedure WriteElement; overload;
    procedure WriteElement(const V: Boolean); overload;
    procedure WriteElement(AJson: TQJson); overload;
    procedure WriteElement(const V: TBcd); overload;
    procedure WriteElement(const V: TObject; AParams: TQJsonParams = []
      ); overload;
    procedure WriteElement(const V: Pointer; AType: PTypeInfo;
      AParams: TQJsonParams = []); overload;
    procedure WriteElement(const V: Variant); overload;
    procedure WriteBase64Element(const V: TBytes); overload;
    procedure WriteBase64Element(const AStream: TStream); overload;
    procedure WriteBase64Element(const AFileName: QStringW); overload;
    procedure WriteBase64Element(const V: PByte; const ALen: Integer); overload;
    // 对象结点下写入子结点
    procedure WriteChild(const AName: QStringW; const V: Double); overload;
    procedure WriteChild(const AName: QStringW; const V: Extended); overload;
    procedure WriteChild(const AName: QStringW; const V: Int64); overload;
    procedure WriteChild(const AName: QStringW; const V: TDateTime); overload;
    procedure WriteChild(const AName: QStringW; const V: QStringW); overload;
    procedure WriteChild(const AName: QStringW; const V: Boolean); overload;
    procedure WriteChild(const AName: QStringW); overload;
    procedure WriteChild(const AName: QStringW;
      const AValue: PWideChar); overload;
    procedure WriteChild(const AName: QStringW; AJson: TQJson); overload;
    procedure WriteChild(const AName: QStringW; const V: TBcd); overload;
    procedure WriteChild(const AName: QStringW; const V: TObject;
      AParams: TQJsonParams = []); overload;
    procedure WriteChild(const AName: QStringW; const V: Pointer;
      AType: PTypeInfo; AParams: TQJsonParams = []); overload;
    procedure WriteChild(const AName: QStringW; const V: Variant); overload;
    procedure WriteBase64Child(const AName: QStringW; const V: TBytes);
      overload;
    procedure WriteBase64Child(const AName: QStringW;
      const AStream: TStream); overload;
    procedure WriteBase64Child(const AName: QStringW;
      const AFileName: QStringW); overload;
    procedure WriteBase64Child(const AName: QStringW; const V: PByte;
      const ALen: Integer); overload;
    procedure BeginObject(const AName: QStringW);
    procedure EndObject;
    procedure BeginArray(const AName: QStringW);
    procedure EndArray;
    procedure WriteArray(const AName: QStringW; ACallback: TQJsonArrayCallback);
    procedure WriteObject(const AName: QStringW;
      ACallback: TQJsonObjectCallback);
    procedure Flush;
    function NewParam(const AKey: QStringW; const AValue: Variant): TQParamPair;
    function ParamValue(const AParams: TQJsonParams; const AKey: QStringW)
      : Variant; overload;
    function ParamValue(const AKey: QStringW; const ADef: Variant)
      : Variant; overload;
  end;

  IQJsonOutputEncoder = interface
    ['{8BE5E756-6F66-424C-80B9-F847BAB3A6DD}']
    procedure Encode(AEncoder: IQJsonStreamEncoder; APersistent: TObject;
      const AParams: TQJsonParams);
  end;

  TQJsonTypeEncoder = record
    InputType: PTypeInfo;
    Encoder: IQJsonOutputEncoder;
  end;

  TQJsonOutputChannel = class
  private
    class var FTypeEncoders: array of TQJsonTypeEncoder;
    class function InternalFindEncoder(ATypeInfo: PTypeInfo;
      var AIndex: Integer): Boolean;
    class function FindTypeEncoder(AType: PTypeInfo): TQJsonTypeEncoder;
  public
    class function CreateEncoder(AEncoding: TTextEncoding; AStream: TStream;
      AWriteBom: Boolean = false; AStackSize: Integer = 32;
      ABufSize: Integer = 0): IQJsonStreamEncoder;
    class procedure RegisterTypeEncoder(AType: PTypeInfo;
      AEncoder: IQJsonOutputEncoder);
  end;

implementation

uses {$IF RTLVersion>27} System.NetEncoding{$ELSE}EncdDecd{$IFEND};

const
  JsonMaxDepth = 64;
  JSON_TYPE_ROOT = 0;
  JSON_TYPE_PAIR = 1;
  JSON_TYPE_OBJECT = 2;
  JSON_TYPE_ARRAY = 3;
  // 最大参数层次
  JSON_PARAMS_MAX_LEVEL = 64;

type
  TQJsonEncoder = class(TInterfacedObject, IQJsonStreamEncoder)
  protected
    FTypeStack: TBytes;
    FNodeLevel: Integer;
    FStream: TStream;
    FBuffer: TQStringCatHelperW;
    FEncodeParams: array [0 .. JSON_PARAMS_MAX_LEVEL - 1] of TQJsonParams;
    FActiveParams: Integer;
    FBufferSize: Integer;
    FIsFirstChild: Boolean;
    procedure WriteString(const S: QStringW; AQuoter: QCharW);
    procedure InternalWriteString(const S: QStringW); virtual; abstract;
    function CurrentType: Integer;
    procedure PushType(const AType: Byte);
    procedure PopType;
    procedure WriteName(const AName: QStringW);
    procedure ArrayNeeded;
    function EncodeBase64(const p: PByte; const L: Integer): QStringW; overload;
    function EncodeBase64(AStream: TStream): QStringW; overload;
    procedure PushParams(const AParams: TQJsonParams);
    procedure PopParams(const AParams: TQJsonParams);
  public
    constructor Create(AStream: TStream; AStackSize, ABufSize: Integer);
    destructor Destroy; override;
    procedure WriteElement(const V: Double); overload;
    procedure WriteElement(const V: Extended); overload;
    procedure WriteElement(const V: Int64); overload;
    procedure WriteElement(const V: TDateTime); overload;
    procedure WriteElement(const V: QStringW); overload;
    procedure WriteElement(const V: PWideChar); overload;
    procedure WriteElement; overload;
    procedure WriteElement(const V: Boolean); overload;
    procedure WriteElement(AJson: TQJson); overload;
    procedure WriteElement(const V: TBcd); overload;
    procedure WriteElement(const V: TObject; AParams: TQJsonParams = []
      ); overload;
    procedure WriteElement(const V: Pointer; AType: PTypeInfo;
      AParams: TQJsonParams = []); overload;
    procedure WriteElement(const V: Variant); overload;
    procedure WriteBase64Element(const V: TBytes); overload;
    procedure WriteBase64Element(const AStream: TStream); overload;
    procedure WriteBase64Element(const AFileName: QStringW); overload;
    procedure WriteBase64Element(const V: PByte; const ALen: Integer); overload;
    // 对象结点下写入子结点
    procedure WriteChild(const AName: QStringW; const V: Double); overload;
    procedure WriteChild(const AName: QStringW; const V: Extended); overload;
    procedure WriteChild(const AName: QStringW; const V: Int64); overload;
    procedure WriteChild(const AName: QStringW; const V: TDateTime); overload;
    procedure WriteChild(const AName: QStringW; const V: QStringW); overload;
    procedure WriteChild(const AName: QStringW; const V: Boolean); overload;
    procedure WriteChild(const AName: QStringW); overload;
    procedure WriteChild(const AName: QStringW;
      const AValue: PWideChar); overload;
    procedure WriteChild(const AName: QStringW; AJson: TQJson); overload;
    procedure WriteChild(const AName: QStringW; const V: TBcd); overload;
    procedure WriteChild(const AName: QStringW; const V: TObject;
      AParams: TQJsonParams = []); overload;
    procedure WriteChild(const AName: QStringW; const V: Pointer;
      AType: PTypeInfo; AParams: TQJsonParams = []); overload;
    procedure WriteChild(const AName: QStringW; const V: Variant); overload;
    procedure WriteBase64Child(const AName: QStringW; const V: TBytes);
      overload;
    procedure WriteBase64Child(const AName: QStringW;
      const AStream: TStream); overload;
    procedure WriteBase64Child(const AName: QStringW;
      const AFileName: QStringW); overload;
    procedure WriteBase64Child(const AName: QStringW; const V: PByte;
      const ALen: Integer); overload;
    procedure BeginObject(const AName: QStringW);
    procedure EndObject;
    procedure BeginArray(const AName: QStringW);
    procedure EndArray;
    procedure WriteArray(const AName: QStringW; ACallback: TQJsonArrayCallback);
    procedure WriteObject(const AName: QStringW;
      ACallback: TQJsonObjectCallback);
    procedure Flush;
    function NewParam(const AKey: QStringW; const AValue: Variant): TQParamPair;
    function ParamValue(const AParams: TQJsonParams; const AKey: QStringW)
      : Variant; overload;
    function ParamValue(const AKey: QStringW; const ADef: Variant)
      : Variant; overload;
  end;

  TQJsonAnsiEncoder = class(TQJsonEncoder)
  protected
    procedure InternalWriteString(const S: QStringW); override;
  end;

  TQJsonUtf8Encoder = class(TQJsonEncoder)
  protected
    procedure InternalWriteString(const S: QStringW); override;
  end;

  TQJsonUtf16LeEncoder = class(TQJsonEncoder)
  protected
    procedure InternalWriteString(const S: QStringW); override;
  end;

  TQJsonUtf16BeEncoder = class(TQJsonEncoder)
  protected
    procedure InternalWriteString(const S: QStringW); override;
  end;

  TQJsonArrayEncoder = class(TInterfacedObject, IQJsonArrayEncoder)
  protected
    FOwner: TQJsonEncoder;
    procedure Write(const V: Double); overload;
    procedure Write(const V: Int64); overload;
    procedure Write(const V: TDateTime); overload;
    procedure Write(const V: QStringW); overload;
    procedure Write(const V: PWideChar); overload;
    procedure Write; overload;
    procedure Write(const V: Boolean); overload;
    procedure Write(AJson: TQJson); overload;
    procedure Write(const V: TBcd); overload;
    procedure Write(const V: TObject; AParams: TQJsonParams = []); overload;
    procedure WriteArray(ACallback: TQJsonArrayCallback);
    procedure WriteObject(ACallback: TQJsonObjectCallback);
    procedure WriteBase64(const V: TBytes); overload;
    procedure WriteBase64(const AStream: TStream); overload;
    procedure WriteBase64(const AFileName: QStringW); overload;
    procedure WriteBase64(const V: PByte; const ALen: Integer); overload;
  public
    constructor Create(AOwner: TQJsonEncoder);
  end;

  TQJsonObjectEncoder = class(TInterfacedObject, IQJsonObjectEncoder)
  protected
    FOwner: TQJsonEncoder;
    procedure Write(const AName: QStringW; const V: Double); overload;
    procedure Write(const AName: QStringW; const V: Int64); overload;
    procedure Write(const AName: QStringW; const V: TDateTime); overload;
    procedure Write(const AName: QStringW; const V: QStringW); overload;
    procedure Write(const AName: QStringW; const V: PWideChar); overload;
    procedure Write(const AName: QStringW); overload;
    procedure Write(const AName: QStringW; const V: Boolean); overload;
    procedure Write(const AName: QStringW; AJson: TQJson); overload;
    procedure Write(const AName: QStringW; const V: TBcd); overload;
    procedure Write(const AName: QStringW; const V: TObject;
      AParams: TQJsonParams = []); overload;
    procedure WriteArray(const AName: QStringW; ACallback: TQJsonArrayCallback);
    procedure WriteObject(const AName: QStringW;
      ACallback: TQJsonObjectCallback);
    procedure WriteBase64(const AName: QStringW; const V: TBytes); overload;
    procedure WriteBase64(const AName: QStringW;
      const AStream: TStream); overload;
    procedure WriteBase64(const AName: QStringW;
      const AFileName: QStringW); overload;
    procedure WriteBase64(const AName: QStringW; const V: PByte;
      const ALen: Integer); overload;
  public
    constructor Create(AOwner: TQJsonEncoder);
  end;
  { TQJsonEncoder }

procedure TQJsonEncoder.WriteArray(const AName: QStringW;
  ACallback: TQJsonArrayCallback);
var
  AParent: IQJsonArrayEncoder;
begin
  BeginArray(AName);
  try
    AParent := TQJsonArrayEncoder.Create(Self);
    ACallback(AParent);
  finally
    EndArray;
  end;
end;

procedure TQJsonEncoder.WriteBase64Child(const AName: QStringW; const V: PByte;
  const ALen: Integer);
begin
  WriteChild(AName, EncodeBase64(V, ALen));
end;

procedure TQJsonEncoder.WriteBase64Child(const AName, AFileName: QStringW);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    WriteChild(AName, EncodeBase64(AStream));
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQJsonEncoder.WriteBase64Child(const AName: QStringW;
  const AStream: TStream);
begin
  WriteChild(AName, EncodeBase64(AStream));
end;

procedure TQJsonEncoder.WriteBase64Child(const AName: QStringW;
  const V: TBytes);
begin
  if Length(V) > 0 then
    WriteChild(AName, EncodeBase64(@V[0], Length(V)))
  else
    WriteChild(AName, '');
end;

procedure TQJsonEncoder.WriteBase64Element(const V: PByte; const ALen: Integer);
begin
  if ALen > 0 then
    WriteElement(EncodeBase64(V, ALen))
  else
    WriteElement('');
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: Extended);
begin
  WriteName(AName);
  WriteString(FloatToStr(V), #0);
end;

procedure TQJsonEncoder.WriteBase64Element(const AFileName: QStringW);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    WriteBase64Element(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQJsonEncoder.WriteBase64Element(const AStream: TStream);
begin
  WriteElement(EncodeBase64(AStream));
end;

procedure TQJsonEncoder.WriteBase64Element(const V: TBytes);
begin
  if Length(V) > 0 then
    WriteElement(EncodeBase64(@V[0], Length(V)))
  else
    WriteElement('');
end;

procedure TQJsonEncoder.WriteObject(const AName: QStringW;
  ACallback: TQJsonObjectCallback);
var
  AParent: IQJsonObjectEncoder;
begin
  BeginObject(AName);
  try
    AParent := TQJsonObjectEncoder.Create(Self);
    if Assigned(ACallback) then
      ACallback(AParent);
  finally
    EndObject;
  end;
end;

procedure TQJsonEncoder.WriteString(const S: QStringW; AQuoter: QCharW);
begin
  if Assigned(FBuffer) then
  begin
    FBuffer.Cat(S, AQuoter);
    if FBuffer.Position >= FBufferSize then
    begin
      InternalWriteString(FBuffer.Value);
      FBuffer.Reset;
    end;
  end
  else
  begin
    if AQuoter <> #0 then
      InternalWriteString(QuotedStrW(S, AQuoter))
    else
      InternalWriteString(S);
  end;
end;

procedure TQJsonEncoder.ArrayNeeded;
begin
  if CurrentType in [JSON_TYPE_ARRAY, JSON_TYPE_ROOT] then
  begin
    if not FIsFirstChild then
      WriteString(',', #0);
    FIsFirstChild := false;
  end
  else
    raise Exception.Create('无名的对象结点上级只能是根或数组');
end;

procedure TQJsonEncoder.BeginArray(const AName: QStringW);
begin
  if Length(AName) = 0 then
  begin
    // 数组只能在数组或者是根结点时使用
    if CurrentType in [JSON_TYPE_ARRAY, JSON_TYPE_ROOT] then
    begin
      if FIsFirstChild then
        WriteString('[', #0)
      else
        WriteString(',[', #0);
    end
    else
      raise Exception.Create('无名的数组结点上级只能是根或数组');
  end
  else
  begin
    if CurrentType in [JSON_TYPE_OBJECT, JSON_TYPE_ROOT] then
    begin
      if FIsFirstChild then
        WriteString(AName, '"')
      else
      begin
        WriteString(',', #0);
        WriteString(AName, '"');
      end;
      WriteString(':[', #0)
    end
    else
      raise Exception.Create('命名的数组结点上级只能是根或对象');
  end;
  PushType(JSON_TYPE_ARRAY);
  FIsFirstChild := true;
end;

procedure TQJsonEncoder.BeginObject(const AName: QStringW);
begin
  if Length(AName) = 0 then
  begin
    // 数组只能在数组或者是根结点时使用
    if CurrentType in [JSON_TYPE_ARRAY, JSON_TYPE_ROOT] then
    begin
      if FIsFirstChild then
        WriteString('{', #0)
      else
        WriteString(',{', #0);
    end
    else
      raise Exception.Create('无名的对象结点上级只能是根或数组');
  end
  else
  begin
    if CurrentType in [JSON_TYPE_OBJECT, JSON_TYPE_ROOT] then
    begin
      if FIsFirstChild then
        WriteString(AName, '"')
      else
      begin
        WriteString(',', #0);
        WriteString(AName, '"');
      end;
      WriteString(':{', #0)
    end
    else
      raise Exception.Create('命名的对象结点上级只能是根或对象');
  end;
  PushType(JSON_TYPE_OBJECT);
  FIsFirstChild := true;
end;

constructor TQJsonEncoder.Create(AStream: TStream;
  AStackSize, ABufSize: Integer);
begin
  inherited Create;
  FStream := AStream;
  SetLength(FTypeStack, AStackSize);
  if ABufSize > 0 then
  begin
    FBuffer := TQStringCatHelperW.Create(ABufSize);
    FBufferSize := ABufSize;
  end;
  FIsFirstChild := true;
  FActiveParams := -1;
end;

function TQJsonEncoder.CurrentType: Integer;
begin
  Result := FTypeStack[FNodeLevel];
end;

destructor TQJsonEncoder.Destroy;
begin
  if Assigned(FBuffer) then
  begin
    Flush;
    FreeAndNil(FBuffer);
  end;
  inherited;
end;

function TQJsonEncoder.EncodeBase64(AStream: TStream): QStringW;
var
  AOut: TMemoryStream;
  T: QStringA;
begin
  AOut := TMemoryStream.Create;
  try
{$IF RTLVersion<=27}
    EncodeStream(AStream, AOut);
{$ELSE}
    TNetEncoding.Base64.Encode(AStream, AOut);
{$ENDIF}
    T.Length := AOut.Size;
    Move(AOut.Memory^, PQCharA(T)^, AOut.Size);
    Result := qstring.Utf8Decode(T);
  finally
    FreeObject(AOut);
  end;
end;

function TQJsonEncoder.EncodeBase64(const p: PByte; const L: Integer): QStringW;
{$IF RTLVersion<=27}
var
  AIn, AOut: TMemoryStream;
  T: QStringA;
{$IFEND}
begin
{$IF RTLVersion<=27}
  AIn := TMemoryStream.Create;
  AOut := TMemoryStream.Create;
  try
    AIn.WriteBuffer(p^, L);
    AIn.Position := 0;
    EncodeStream(AIn, AOut);
    T.Length := AOut.Size;
    Move(AOut.Memory^, PQCharA(T)^, AOut.Size);
    Result := qstring.Utf8Decode(T);
  finally
    FreeObject(AIn);
    FreeObject(AOut);
  end;
{$ELSE}
  Result := TNetEncoding.Base64.EncodeBytesToString(p, L);
{$ENDIF}
end;

procedure TQJsonEncoder.EndArray;
begin
  if CurrentType <> JSON_TYPE_ARRAY then
    raise Exception.Create('当前类型不是数组，不能调用 EndArray');
  WriteString(']', #0);
  FIsFirstChild := false;
  PopType;
end;

procedure TQJsonEncoder.EndObject;
begin
  if CurrentType <> JSON_TYPE_OBJECT then
    raise Exception.Create('当前类型不是对象，不能调用 EndObject');
  WriteString('}', #0);
  FIsFirstChild := false;
  PopType;
end;

procedure TQJsonEncoder.Flush;
begin
  if Assigned(FBuffer) and (FBuffer.Position > 0) then
  begin
    InternalWriteString(FBuffer.Value);
    FBuffer.Reset;
  end;
end;

function TQJsonEncoder.NewParam(const AKey: String; const AValue: Variant)
  : TQParamPair;
begin
  Result.Key := AKey;
  Result.Value := AValue;
end;

function TQJsonEncoder.ParamValue(const AParams: TQJsonParams;
  const AKey: QStringW): Variant;
var
  I: Integer;
begin
  for I := 0 to High(AParams) do
  begin
    if CompareText(AParams[I].Key, AKey) = 0 then
      Exit(AParams[I].Value);
  end;
  Result := Unassigned;
end;

function TQJsonEncoder.ParamValue(const AKey: QStringW;
  const ADef: Variant): Variant;
var
  AIndex: Integer;
begin
  AIndex := FActiveParams;
  while AIndex >= 0 do
  begin
    Result := ParamValue(FEncodeParams[AIndex], AKey);
    if not VarIsEmpty(Result) then
      Exit;
    Dec(AIndex);
  end;
  Result := ADef;
end;

procedure TQJsonEncoder.PopParams(const AParams: TQJsonParams);
begin
  if (Length(AParams) > 0) and (FActiveParams >= 0) then
  begin
    FEncodeParams[FActiveParams] := [];
    Dec(FActiveParams);
  end;
end;

procedure TQJsonEncoder.PopType;
begin
  Dec(FNodeLevel);
end;

procedure TQJsonEncoder.PushParams(const AParams: TQJsonParams);
begin
  if Length(AParams) > 0 then
  begin
    if FActiveParams = JSON_PARAMS_MAX_LEVEL - 1 then
      raise Exception.Create('当前 JSON 参数层次超出限制');
    Inc(FActiveParams);
    FEncodeParams[FActiveParams] := AParams;
  end;
end;

procedure TQJsonEncoder.PushType(const AType: Byte);
begin
  if FNodeLevel > High(FTypeStack) then
    raise Exception.Create('当前 JSON 层次超出限制');
  Inc(FNodeLevel);
  FTypeStack[FNodeLevel] := AType;
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: QStringW);
begin
  WriteName(AName);
  WriteString(JavaEscape(V, false), '"');
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: Boolean);
begin
  WriteName(AName);
  if V then
    WriteString('true', #0)
  else
    WriteString('false', #0);
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW);
begin
  WriteName(AName);
  WriteString('null', #0);
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW;
  const AValue: PWideChar);
begin
  WriteChild(AName, QStringW(AValue));
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: Double);
begin
  WriteName(AName);
  WriteString(FloatToStr(V), #0);
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: Int64);
begin
  WriteName(AName);
  WriteString(IntToStr(V), #0);
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: TDateTime);
var
  ADate: Integer;
begin
  WriteName(AName);
  ADate := Trunc(V);
  if SameValue(ADate, 0) then // Date为0，是时间
  begin
    if SameValue(V, 0) then
      WriteString(FormatDateTime(JsonDateFormat, V), '"')
    else
      WriteString(FormatDateTime(JsonTimeFormat, V), '"');
  end
  else
  begin
    if SameValue(V - ADate, 0) then
      WriteString(FormatDateTime(JsonDateFormat, V), '"')
    else
      WriteString(FormatDateTime(JsonDateTimeFormat, V), '"');
  end;
end;

procedure TQJsonEncoder.WriteElement(const V: QStringW);
begin
  ArrayNeeded;
  WriteString(JavaEscape(V, false), '"');
end;

procedure TQJsonEncoder.WriteElement;
begin
  ArrayNeeded;
  WriteString('null', #0);
end;

procedure TQJsonEncoder.WriteElement(const V: Boolean);
begin
  ArrayNeeded;
  if V then
    WriteString('true', #0)
  else
    WriteString('false', #0);
end;

procedure TQJsonEncoder.WriteElement(const V: PWideChar);
begin
  WriteElement(QStringW(V));
end;

procedure TQJsonEncoder.WriteName(const AName: QStringW);
begin
  if CurrentType in [JSON_TYPE_OBJECT, JSON_TYPE_ROOT] then
  begin
    if not FIsFirstChild then
      WriteString(',', #0);
    FIsFirstChild := false;
    WriteString(JavaEscape(AName, false), '"');
    WriteString(':', #0);
  end
  else
    raise Exception.Create('命名的对象结点上级只能是根或对象');
end;

procedure TQJsonEncoder.WriteElement(const V: Double);
begin
  ArrayNeeded;
  WriteString(FloatToStr(V), #0);
end;

procedure TQJsonEncoder.WriteElement(const V: Int64);
begin
  ArrayNeeded;
  WriteString(IntToStr(V), #0);
end;

procedure TQJsonEncoder.WriteElement(const V: TDateTime);
var
  ADate: Integer;
begin
  ArrayNeeded;
  ADate := Trunc(V);
  if SameValue(ADate, 0) then // Date为0，是时间
  begin
    if SameValue(V, 0) then
      WriteString(FormatDateTime(JsonDateFormat, V), '"')
    else
      WriteString(FormatDateTime(JsonTimeFormat, V), '"');
  end
  else
  begin
    if SameValue(V - ADate, 0) then
      WriteString(FormatDateTime(JsonDateFormat, V), '"')
    else
      WriteString(FormatDateTime(JsonDateTimeFormat, V), '"');
  end;
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; AJson: TQJson);
var
  I: Integer;
begin
  case AJson.DataType of
    jdtUnknown, jdtNull:
      begin
        WriteName(AName);
        WriteString('null', #0);
      end;
    jdtString, jdtDateTime:
      begin
        WriteName(AName);
        WriteString(JavaEscape(AJson.AsString, false), '"');
      end;
    jdtInteger, jdtFloat, jdtBcd, jdtBoolean:
      begin
        WriteName(AName);
        WriteString(AJson.AsString, #0);
      end;
    jdtArray:
      begin
        BeginArray(AName);
        try
          for I := 0 to AJson.Count - 1 do
            WriteElement(AJson[I]);
        finally
          EndArray;
        end;
      end;
    jdtObject:
      begin
        BeginObject(AName);
        try
          for I := 0 to AJson.Count - 1 do
            WriteChild(AJson[I].Name, AJson[I]);
        finally
          EndObject;
        end;
      end;
  end;
end;

procedure TQJsonEncoder.WriteElement(AJson: TQJson);
var
  I: Integer;
begin
  case AJson.DataType of
    jdtUnknown, jdtNull:
      WriteElement;
    jdtString, jdtDateTime:
      WriteElement(AJson.AsString);
    jdtInteger, jdtFloat, jdtBcd, jdtBoolean:
      begin
        ArrayNeeded;
        WriteString(AJson.AsString, #0);
      end;
    jdtArray:
      begin
        BeginArray('');
        try
          for I := 0 to AJson.Count - 1 do
            WriteElement(AJson[I]);
        finally
          EndArray;
        end;
      end;
    jdtObject:
      begin
        BeginObject('');
        try
          for I := 0 to AJson.Count - 1 do
            WriteChild(AJson[I].Name, AJson[I]);
        finally
          EndObject;
        end;
      end;
  end;
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: TBcd);
begin
  WriteName(AName);
  WriteString(BcdToStr(V), #0);
end;

procedure TQJsonEncoder.WriteElement(const V: TBcd);
begin
  ArrayNeeded;
  WriteString(BcdToStr(V), #0);
end;

procedure TQJsonEncoder.WriteElement(const V: TObject; AParams: TQJsonParams);
var
  AEncoder: TQJsonTypeEncoder;
begin
  PushParams(AParams);
  try
    AEncoder := TQJsonOutputChannel.FindTypeEncoder(V.ClassInfo);
    if AEncoder.Encoder <> nil then
      AEncoder.Encoder.Encode(Self, V, AParams)
    else
      WriteElement(V, V.ClassType.ClassInfo, []);
  finally
    PopParams(AParams);
  end;
end;

procedure TQJsonEncoder.WriteElement(const V: Extended);
begin
  ArrayNeeded;
  WriteString(FloatToStr(V), #0);
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: TObject;
  AParams: TQJsonParams);
var
  AEncoder: TQJsonTypeEncoder;
begin
  PushParams(AParams);
  try
    AEncoder := TQJsonOutputChannel.FindTypeEncoder(V.ClassInfo);
    if AEncoder.Encoder <> nil then
    begin
      WriteName(AName);
      AEncoder.Encoder.Encode(Self, V, AParams);
    end
    else
      WriteChild(AName, V, V.ClassType.ClassInfo, []);
  finally
    PopParams(AParams);
  end;
end;

procedure TQJsonEncoder.WriteElement(const V: Variant);
var
  AType: Word;
begin
  ArrayNeeded;
  AType := VarType(V);
  if AType in [varEmpty, varNull] then
    WriteElement
  else if AType in [varSmallint .. varCurrency, varShortInt .. varUInt64] then
    WriteString(VarToStr(V), #0)
  else if (AType = varOleStr) or (AType = varString) or (AType = varUString)
  then
    WriteString(VarToStr(V), '"')
  else if AType = varDate then
    WriteElement(TDateTime(V))
  else if AType = varBoolean then
    WriteElement(Boolean(V))
    // Todo:支持结构体和对象
  else
    raise Exception.Create('不支持的变体类型');
end;

procedure TQJsonEncoder.WriteElement(const V: Pointer; AType: PTypeInfo;
  AParams: TQJsonParams);
var
  AEnumAsInt: Boolean;
  function GetFixedArrayItemType: PTypeInfo;
  var
    pType: PPTypeInfo;
  begin
    pType := GetTypeData(AType)^.ArrayData.elType;
    if pType = nil then
      Result := nil
    else
      Result := pType^;
  end;
  procedure WriteArray;
  var
    I, ACount, ASize: Integer;
    ASubType: PTypeInfo;
  begin
    ACount := AType.TypeData.ArrayData.ElCount;
    ASubType := GetFixedArrayItemType;
    ASize := 1;
    case ASubType.Kind of
      tkInteger, tkEnumeration, tkSet:
        begin
          case GetTypeData(ASubType).OrdType of
            otSWord, otUWord:
              ASize := 2;
            otSLong, otULong:
              ASize := 4;
          end;
        end;
      tkFloat:
        case GetTypeData(ASubType)^.FloatType of
          ftSingle:
            ASize := SizeOf(Single);
          ftDouble:
            ASize := SizeOf(Double);
          ftExtended:
            ASize := SizeOf(Extended);
          ftComp:
            ASize := SizeOf(Comp);
          ftCurr:
            ASize := SizeOf(Currency);
        end;
      tkVariant, tkUString
{$IFNDEF NEXTGEN}
        , tkString, tkLString, tkWString
{$ENDIF !NEXTGEN}
        :
        ASize := SizeOf(PShortString);
      tkClass:
        ASize := SizeOf(Pointer);
      tkWChar:
        ASize := SizeOf(WideChar);
      tkArray, tkDynArray:
        ASize := GetTypeData(ASubType)^.elSize;
      tkRecord {$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} :
        ASize := GetTypeData(ASubType)^.RecSize;
      tkInt64:
        ASize := SizeOf(Int64)
    else
      Exit;
    end;
    ArrayNeeded;
    BeginArray('');
    try
      for I := 0 to ACount - 1 do
        WriteElement(Pointer(IntPtr(V) + ASize * I), ASubType);
    finally
      EndArray();
    end;
  end;

begin
  if not Assigned(V) then
    Exit;
  PushParams(AParams);
  try
    // 通过 RTTI 信息来写入
    case AType.Kind of
      tkRecord{$IFDEF MANAGED_RECORD}, tkMRecord{$ENDIF}:
        begin
          ArrayNeeded;
          WriteChild('', V, AType, []);
        end;
      tkClass:
        begin
          ArrayNeeded;
          WriteChild('', V, AType, []);
        end;
      tkDynArray, tkArray:
        WriteArray;
      tkInteger:
        case AType.TypeData^.OrdType of
          otSByte:
            WriteElement(PShortint(V)^);
          otUByte:
            WriteElement(PByte(V)^);
          otSWord:
            WriteElement(PSmallint(V)^);
          otUWord:
            WriteElement(PWord(V)^);
          otSLong:
            WriteElement(PInteger(V)^);
          otULong:
            WriteElement(PCardinal(V)^);
        end;
{$IFNDEF NEXTGEN}
      tkChar:
        WriteElement(QStringW(WideChar(PByte(V)^)));
      tkString:
        WriteElement(String(PShortString(V)^));
      tkLString:
        WriteElement(String(PAnsiString(V)^));
      tkWString:
        WriteElement(PWideString(V)^);
{$ENDIF}
      tkWChar:
        WriteElement(QStringW(PWideChar(V)^));
{$IFDEF UNICODE}
      tkUString:
        WriteElement(PUnicodeString(V)^);
{$ENDIF}
      tkEnumeration:
        begin
          if GetTypeData(AType)^.BaseType^ = TypeInfo(Boolean) then
            WriteElement(PBoolean(V)^)
          else
          begin
            AEnumAsInt := ParamValue('EnumAsInt', false);
            case AType.TypeData^.OrdType of
              otSByte:
                begin
                  if AEnumAsInt then
                    WriteElement(PShortint(V)^)
                  else
                    WriteElement(GetEnumName(AType, PShortint(V)^));
                end;
              otUByte:
                begin
                  if AEnumAsInt then
                    WriteElement(PByte(V)^)
                  else
                    WriteElement(GetEnumName(AType, PByte(V)^));
                end;
              otSWord:
                begin
                  if AEnumAsInt then
                    WriteElement(PSmallint(V)^)
                  else
                    WriteElement(GetEnumName(AType, PSmallint(V)^));
                end;
              otUWord:
                begin
                  if AEnumAsInt then
                    WriteElement(PSmallint(V)^)
                  else
                    WriteElement(GetEnumName(AType, PSmallint(V)^));
                end;
              otSLong:
                begin
                  if AEnumAsInt then
                    WriteElement(PInteger(V)^)
                  else
                    WriteElement(GetEnumName(AType, PInteger(V)^));
                end;
              otULong:
                begin
                  if AEnumAsInt then
                    WriteElement(PCardinal(V)^)
                  else
                    WriteElement(GetEnumName(AType, PCardinal(V)^));
                end;
            end;
          end
        end;
      tkSet:
        WriteElement(SetToString(AType, V));
      tkVariant:
        WriteElement(PVariant(V)^);
      tkInt64:
        WriteElement(PInt64(V)^);
      tkFloat:
        begin
          if (AType = TypeInfo(TDateTime)) or (AType = TypeInfo(TTime)) or
            (AType = TypeInfo(TDate)) then
            WriteElement(PDateTime(V)^)
          else
          begin
            case AType.TypeData^.FloatType of
              ftSingle:
                WriteElement(Double(PSingle(V)^));
              ftDouble:
                WriteElement(PDouble(V)^);
              ftExtended:
                WriteElement(PExtended(V)^);
              ftComp:
                WriteElement(PComp(V)^);
              ftCurr:
                WriteElement(PCurrency(V)^);
            end;
          end;
        end;
    end;
  finally
    PopParams(AParams);
  end;
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: Variant);
var
  AType: Word;
begin
  AType := VarType(V);
  if AType in [varEmpty, varNull] then
    WriteChild(AName)
  else if AType in [varSmallint .. varCurrency, varShortInt .. varUInt64] then
  begin
    WriteName(AName);
    WriteString(VarToStr(V), #0);
  end
  else if (AType = varOleStr) or (AType = varString) or (AType = varUString)
  then
  begin
    WriteName(AName);
    WriteString(VarToStr(V), '"');
  end
  else if AType = varDate then
    WriteChild(AName, TDateTime(V))
  else if AType = varBoolean then
    WriteChild(AName, Boolean(V))
    // todo:支持varRecord,varClass
  else
    raise Exception.Create('不支持的变体类型');
end;

procedure TQJsonEncoder.WriteChild(const AName: QStringW; const V: Pointer;
  AType: PTypeInfo; AParams: TQJsonParams);
var
  AEnumAsInt: Boolean;
  function GetFixedArrayItemType: PTypeInfo;
  var
    pType: PPTypeInfo;
  begin
    pType := GetTypeData(AType)^.ArrayData.elType;
    if pType = nil then
      Result := nil
    else
      Result := pType^;
  end;
  procedure WriteArray;
  var
    I, ACount, ASize: Integer;
    ASubType: PTypeInfo;
  begin
    ACount := AType.TypeData.ArrayData.ElCount;
    ASubType := GetFixedArrayItemType;
    ASize := 1;
    case ASubType.Kind of
      tkInteger, tkEnumeration, tkSet:
        begin
          case GetTypeData(ASubType).OrdType of
            otSWord, otUWord:
              ASize := 2;
            otSLong, otULong:
              ASize := 4;
          end;
        end;
      tkFloat:
        case GetTypeData(ASubType)^.FloatType of
          ftSingle:
            ASize := SizeOf(Single);
          ftDouble:
            ASize := SizeOf(Double);
          ftExtended:
            ASize := SizeOf(Extended);
          ftComp:
            ASize := SizeOf(Comp);
          ftCurr:
            ASize := SizeOf(Currency);
        end;
      tkVariant, tkUString
{$IFNDEF NEXTGEN}
        , tkString, tkLString, tkWString
{$ENDIF !NEXTGEN}
        :
        ASize := SizeOf(PShortString);
      tkClass:
        ASize := SizeOf(Pointer);
      tkWChar:
        ASize := SizeOf(WideChar);
      tkArray, tkDynArray:
        ASize := GetTypeData(ASubType)^.elSize;
      tkRecord {$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} :
        ASize := GetTypeData(ASubType)^.RecSize;
      tkInt64:
        ASize := SizeOf(Int64)
    else
      Exit;
    end;
    BeginArray(AName);
    try
      for I := 0 to ACount - 1 do
        WriteElement(Pointer(IntPtr(V) + ASize * I), ASubType);
    finally
      EndArray();
    end;
  end;

  procedure WriteRecord;
  begin
    // Todo:使用RTTI来写属性
  end;
  procedure WriteObject;
  begin
    // Todo:使用RTTI来写属性
  end;

begin
  if not Assigned(V) then
    Exit;
  PushParams(AParams);
  try
    // 通过 RTTI 信息来写入
    case AType.Kind of
      tkRecord{$IFDEF MANAGED_RECORD}, tkMRecord{$ENDIF}:
        WriteRecord;
      tkClass:
        WriteObject;
      tkDynArray, tkArray:
        WriteArray;
      tkInteger:
        case AType.TypeData^.OrdType of
          otSByte:
            WriteChild(AName, PShortint(V)^);
          otUByte:
            WriteChild(AName, PByte(V)^);
          otSWord:
            WriteChild(AName, PSmallint(V)^);
          otUWord:
            WriteChild(AName, PWord(V)^);
          otSLong:
            WriteChild(AName, PInteger(V)^);
          otULong:
            WriteChild(AName, PCardinal(V)^);
        end;
{$IFNDEF NEXTGEN}
      tkChar:
        WriteChild(AName, QStringW(WideChar(PByte(V)^)));
      tkString:
        WriteChild(AName, String(PShortString(V)^));
      tkLString:
        WriteChild(AName, String(PAnsiString(V)^));
      tkWString:
        WriteChild(AName, PWideString(V)^);
{$ENDIF}
      tkWChar:
        WriteChild(AName, QStringW(PWideChar(V)^));
{$IFDEF UNICODE}
      tkUString:
        WriteChild(AName, PUnicodeString(V)^);
{$ENDIF}
      tkEnumeration:
        begin
          if GetTypeData(AType)^.BaseType^ = TypeInfo(Boolean) then
            WriteChild(AName, PBoolean(V)^)
          else
          begin
            AEnumAsInt := ParamValue('EnumAsInt', false);
            case AType.TypeData^.OrdType of
              otSByte:
                begin
                  if AEnumAsInt then
                    WriteChild(AName, PShortint(V)^)
                  else
                    WriteChild(AName, GetEnumName(AType, PShortint(V)^));
                end;
              otUByte:
                begin
                  if AEnumAsInt then
                    WriteChild(AName, PByte(V)^)
                  else
                    WriteChild(AName, GetEnumName(AType, PByte(V)^));
                end;
              otSWord:
                begin
                  if AEnumAsInt then
                    WriteChild(AName, PSmallint(V)^)
                  else
                    WriteChild(AName, GetEnumName(AType, PSmallint(V)^));
                end;
              otUWord:
                begin
                  if AEnumAsInt then
                    WriteChild(AName, PSmallint(V)^)
                  else
                    WriteChild(AName, GetEnumName(AType, PSmallint(V)^));
                end;
              otSLong:
                begin
                  if AEnumAsInt then
                    WriteChild(AName, PInteger(V)^)
                  else
                    WriteChild(AName, GetEnumName(AType, PInteger(V)^));
                end;
              otULong:
                begin
                  if AEnumAsInt then
                    WriteChild(AName, PCardinal(V)^)
                  else
                    WriteChild(AName, GetEnumName(AType, PCardinal(V)^));
                end;
            end;
          end
        end;
      tkSet:
        WriteChild(AName, SetToString(AType, V));
      tkVariant:
        WriteChild(AName, PVariant(V)^);
      tkInt64:
        WriteChild(AName, PInt64(V)^);
      tkFloat:
        begin
          if (AType = TypeInfo(TDateTime)) or (AType = TypeInfo(TTime)) or
            (AType = TypeInfo(TDate)) then
            WriteChild(AName, PDateTime(V)^)
          else
          begin
            case AType.TypeData^.FloatType of
              ftSingle:
                WriteChild(AName, Double(PSingle(V)^));
              ftDouble:
                WriteChild(AName, PDouble(V)^);
              ftExtended:
                WriteChild(AName, PExtended(V)^);
              ftComp:
                WriteChild(AName, PComp(V)^);
              ftCurr:
                WriteChild(AName, PCurrency(V)^);
            end;
          end;
        end;
    end;
  finally
    EndObject;
  end;
end;

{ TQJsonUtf8Encoder }

procedure TQJsonUtf8Encoder.InternalWriteString(const S: QStringW);
var
  ATemp: QStringA;
begin
  ATemp := qstring.Utf8Encode(S);
  FStream.WriteBuffer(PQCharA(ATemp)^, ATemp.Length);
end;

{ TQJsonUtf16LeEncoder }

procedure TQJsonUtf16LeEncoder.InternalWriteString(const S: QStringW);
begin
  FStream.WriteBuffer(PQCharW(S)^, Length(S) shl 1);
end;

{ TQJsonUtf16BeEncoder }

procedure TQJsonUtf16BeEncoder.InternalWriteString(const S: QStringW);
var
  ATemp: QStringW;
begin
  ATemp := S;
  UniqueString(ATemp);
  ExchangeByteOrder(PQCharA(ATemp), Length(ATemp) shl 1);
  FStream.WriteBuffer(PQCharW(ATemp)^, Length(ATemp) shl 1);
end;

{ TQJsonOutputChannel }

class function TQJsonOutputChannel.CreateEncoder(AEncoding: TTextEncoding;
  AStream: TStream; AWriteBom: Boolean; AStackSize, ABufSize: Integer)
  : IQJsonStreamEncoder;
const
  Utf8Bom: array [0 .. 2] of Byte = ($EF, $BB, $BF);
  Utf16LEBom: array [0 .. 1] of Byte = ($FF, $FE);
  Utf16BEBom: array [0 .. 1] of Byte = ($FE, $FF);
begin
  if AWriteBom then
  begin
    case AEncoding of
      teUnknown, teAuto, teUtf8:
        AStream.Write(Utf8Bom[0], Length(Utf8Bom));
      teUnicode16LE:
        AStream.Write(Utf16LEBom[0], Length(Utf16LEBom));
      teUnicode16BE:
        AStream.Write(Utf16LEBom[0], Length(Utf16LEBom));
    end;
  end;
  case AEncoding of
    teUnicode16LE:
      Result := TQJsonUtf16LeEncoder.Create(AStream, AStackSize, ABufSize);
    teUnicode16BE:
      Result := TQJsonUtf16BeEncoder.Create(AStream, AStackSize, ABufSize);
    teAnsi:
      Result := TQJsonAnsiEncoder.Create(AStream, AStackSize, ABufSize)
  else
    Result := TQJsonUtf8Encoder.Create(AStream, AStackSize, ABufSize);
  end;
end;

class function TQJsonOutputChannel.FindTypeEncoder(AType: PTypeInfo)
  : TQJsonTypeEncoder;
var
  I: Integer;
begin
  if AType^.Kind = tkClass then
  begin
    while Assigned(AType) do
    begin
      if InternalFindEncoder(AType, I) then
        Exit(FTypeEncoders[I]);
      AType := AType.TypeData.ParentInfo^;
    end;
  end;
  Result.InputType := AType;
  Result.Encoder := nil;
end;

class function TQJsonOutputChannel.InternalFindEncoder(ATypeInfo: PTypeInfo;
  var AIndex: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := false;
  L := 0;
  H := High(FTypeEncoders);
  AIndex := -1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := IntPtr(FTypeEncoders[I].InputType) - IntPtr(ATypeInfo);
    if C < 0 then
      L := I + 1
    else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := true;
        AIndex := I;
        Break;
      end;
    end;
  end;
  if AIndex = -1 then
    AIndex := L;
end;

class procedure TQJsonOutputChannel.RegisterTypeEncoder(AType: PTypeInfo;
  AEncoder: IQJsonOutputEncoder);
var
  AIndex: Integer;
begin
  if InternalFindEncoder(AType, AIndex) then
    raise Exception.CreateFmt('类型 %s 的 JSON 编码器已经存在。', [AType.Name]);
  SetLength(FTypeEncoders, Length(FTypeEncoders) + 1);
  if AIndex < High(FTypeEncoders) then
  begin
    Move(FTypeEncoders[AIndex], FTypeEncoders[AIndex + 1],
      (High(FTypeEncoders) - AIndex) * SizeOf(TQJsonTypeEncoder));
    FillChar(FTypeEncoders[AIndex], SizeOf(TQJsonTypeEncoder), 0);
  end;
  FTypeEncoders[AIndex].InputType := AType;
  FTypeEncoders[AIndex].Encoder := AEncoder;
end;

{ TQJsonArrayEncoder }

constructor TQJsonArrayEncoder.Create(AOwner: TQJsonEncoder);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TQJsonArrayEncoder.Write(const V: TDateTime);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write(const V: QStringW);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write(const V: Int64);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write(const V: Double);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write(const V: TBcd);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write(AJson: TQJson);
begin
  FOwner.WriteElement(AJson);
end;

procedure TQJsonArrayEncoder.Write(const V: Boolean);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write(const V: PWideChar);
begin
  FOwner.WriteElement(V);
end;

procedure TQJsonArrayEncoder.Write;
begin
  FOwner.WriteElement;
end;

procedure TQJsonArrayEncoder.WriteArray(ACallback: TQJsonArrayCallback);
begin
  FOwner.WriteArray('', ACallback);
end;

procedure TQJsonArrayEncoder.WriteBase64(const V: TBytes);
begin
  FOwner.WriteBase64Element(V);
end;

procedure TQJsonArrayEncoder.WriteBase64(const AStream: TStream);
begin
  FOwner.WriteBase64Element(AStream);
end;

procedure TQJsonArrayEncoder.WriteBase64(const AFileName: QStringW);
begin
  FOwner.WriteBase64Element(AFileName);
end;

procedure TQJsonArrayEncoder.WriteBase64(const V: PByte; const ALen: Integer);
begin
  FOwner.WriteBase64Element(V, ALen);
end;

procedure TQJsonArrayEncoder.WriteObject(ACallback: TQJsonObjectCallback);
begin
  FOwner.WriteObject('', ACallback);
end;

procedure TQJsonArrayEncoder.Write(const V: TObject; AParams: TQJsonParams);
begin
  FOwner.WriteElement(V, AParams);
end;

{ TQJsonObjectEncoder }

constructor TQJsonObjectEncoder.Create(AOwner: TQJsonEncoder);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: TDateTime);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName, V: QStringW);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: Int64);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: Double);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: TBcd);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; AJson: TQJson);
begin
  FOwner.WriteChild(AName, AJson);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: Boolean);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: PWideChar);
begin
  FOwner.WriteChild(AName, V);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW);
begin
  FOwner.WriteChild(AName);
end;

procedure TQJsonObjectEncoder.WriteArray(const AName: QStringW;
  ACallback: TQJsonArrayCallback);
begin
  FOwner.WriteArray(AName, ACallback);
end;

procedure TQJsonObjectEncoder.WriteBase64(const AName: QStringW;
  const V: TBytes);
begin
  FOwner.WriteBase64Child(AName, V);
end;

procedure TQJsonObjectEncoder.WriteBase64(const AName: QStringW;
  const AStream: TStream);
begin
  FOwner.WriteBase64Child(AName, AStream);
end;

procedure TQJsonObjectEncoder.WriteBase64(const AName, AFileName: QStringW);
begin
  FOwner.WriteBase64Child(AName, AFileName);
end;

procedure TQJsonObjectEncoder.WriteBase64(const AName: QStringW; const V: PByte;
  const ALen: Integer);
begin
  FOwner.WriteBase64Child(AName, V, ALen);
end;

procedure TQJsonObjectEncoder.WriteObject(const AName: QStringW;
  ACallback: TQJsonObjectCallback);
begin
  FOwner.WriteObject(AName, ACallback);
end;

procedure TQJsonObjectEncoder.Write(const AName: QStringW; const V: TObject;
  AParams: TQJsonParams);
begin
  FOwner.WriteChild(AName, V, AParams);
end;

{ TQJsonAnsiEncoder }

procedure TQJsonAnsiEncoder.InternalWriteString(const S: QStringW);
var
  ATemp: QStringA;
begin
  ATemp := qstring.AnsiEncode(S);
  FStream.WriteBuffer(PQCharA(ATemp)^, ATemp.Length);
end;

{ TQJsonParamPair }

class function TQParamPair.Create(const AKey: String; const AValue: Variant)
  : TQParamPair;
begin
  Result.Key := AKey;
  Result.Value := AValue;
end;

end.

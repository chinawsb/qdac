unit qprov_http;

interface

uses classes, sysutils, dateutils, qstring, qjson, qdigest, db, fmtbcd, qdb,
  qvalue, qhttprequest, qconverter_stds;

type
  TQHttpToken = record
    Value: String;
    ExpireTime: TDateTime;
  end;

  EQDBHttpException = class(Exception)
  private
    FHelp: QStringW;
    FErrorCode: Integer;
  public
    constructor Create(AJson: TQJson);
    property ErrorCode: Integer read FErrorCode;
    property Help: QStringW read FHelp;
  end;

  TQHttpProvider = class(TQProvider)
  protected
    FAccessToken, FRefreshToken: TQHttpToken;
    FRequests: TQHttpRequests;
    FServiceUrl: QStringW;
    FAppSalt: QStringW;
    FServerExtParams: TQJson;
    function GetCustomHeaders: IQHttpHeaders;
    function GetServiceUrl: QStringW;
    procedure SetServiceUrl(const Value: QStringW);
    function GetAppId: QStringW;
    procedure SetAppId(const Value: QStringW);
    function InternalExecute(var ARequest: TQSQLRequest): Boolean; override;
    procedure InternalClose; override;
    procedure InternalOpen; override;
    procedure InternalApplyChanges(Fields: TFieldDefs;
      ARecords: TQRecords); override;
    function Rest(Action: QStringW; Params: TStrings; AData: TQJson;
      AUseToken: Boolean): TQJson;
    function CheckError(AJson: TQJson; ARaiseError: Boolean): Boolean;
    procedure RaiseError(AJson: TQJson);
    procedure Json2DataSet(ASource: TQJson; AFieldDefs: TFieldDefs;
      ARecords: TQRecords);
    procedure CloseHandle(AHandle: THandle); override;
    procedure KeepAliveNeeded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AccessToken: TQHttpToken read FAccessToken;
    property RefreshToken: TQHttpToken read FRefreshToken;
    property CustomHeaders: IQHttpHeaders read GetCustomHeaders;
  published
    property ServiceUrl: QStringW read FServiceUrl write SetServiceUrl;
    property AppId: QStringW read GetAppId write SetAppId;
    property AppSalt: QStringW read FAppSalt write FAppSalt;
    property ServerExtParams: TQJson read FServerExtParams;
  end;

implementation

resourcestring
  SHttpError = 'HTTP �������������� %d';
  SUnknownError = 'δ֪����';
  SUnknownJsonFormat = '���������ص����ݸ�ʽ��ƥ��';

  { TQHttpProvider }
const
  ERROR_SUCCESS = 0;
  ERROR_TOKEN_TIMEOUT = Cardinal(-1);
  ERROR_BAD_VALUE = Cardinal(-2);
  ERROR_MISSED = Cardinal(-3);
  ERROR_UNSUPPORT = Cardinal(-4);

type
  TPDONativeType = record
    Name: String;
    FieldType: TFieldType;
  end;

function TQHttpProvider.CheckError(AJson: TQJson; ARaiseError: Boolean)
  : Boolean;
var
  ACode: Integer;
begin
  (* TQHttpProvider ���ؽṹ��ʽ��
    {
    "code":�����������,
    "hint":"�ַ���������ʾ��Ҳ����error message",
    "help":"����ʱ�����İ�����Ϣ��һ�㲻���ָ��û�",
    "result":����������������ͬ�����صĿ����ǵ�һֵ���������飩
    }
    ����Ľṹ�У�code ��ʼ�մ��ڵģ�����ɹ�������0��ʧ�ܣ����ش������
  *)
  ACode := AJson.IntByName('code', MaxInt);
  Result := ACode = 0;
  if (not Result) then
  begin
    SetError(Cardinal(ACode), AJson.ValueByName('hint', ''));
    if ARaiseError then
      RaiseError(AJson);
  end
  else
    SetError(0, '');
end;

procedure TQHttpProvider.CloseHandle(AHandle: THandle);
begin
  inherited;
  // ��֧�֣�����
end;

constructor TQHttpProvider.Create(AOwner: TComponent);
begin
  inherited;
  FRequests := TQHttpRequests.Create;
  FServerExtParams := TQJson.Create;
end;

destructor TQHttpProvider.Destroy;
begin
  FreeAndNil(FServerExtParams);
  inherited;
  FreeAndNil(FRequests);
end;

function TQHttpProvider.GetAppId: QStringW;
begin
  Result := Params.Values['appid'];
end;

function TQHttpProvider.GetCustomHeaders: IQHttpHeaders;
begin
  Result := FRequests.DefaultHeaders;
end;

function TQHttpProvider.GetServiceUrl: QStringW;
begin
  Result := Params.Values['url'];
end;

procedure TQHttpProvider.InternalApplyChanges(Fields: TFieldDefs;
  ARecords: TQRecords);
begin
  // Todo:ת��SQLΪ����SQL�ű���Ҫ�������������
end;

procedure TQHttpProvider.InternalClose;
var
  AResult, ATokens: TQJson;
begin
  inherited;
  AResult := Rest('Close', nil, nil, true);
  try
    CheckError(AResult, false);
    FAccessToken.Value := '';
    FAccessToken.ExpireTime := 0;
    FRefreshToken.Value := '';
    FRefreshToken.ExpireTime := 0;
    FHandle := 0;
  finally
    FreeAndNil(AResult);
  end;
end;

function TQHttpProvider.InternalExecute(var ARequest: TQSQLRequest): Boolean;
var
  AReqJson, AResult: TQJson;
  I: Integer;
  ATokenTimeout: Boolean;
  procedure FetchAsStream;
  begin
    AResult := Rest('OpenDataSet', nil, AReqJson, true);
    CheckError(AResult, false);
    if FErrorCode = ERROR_TOKEN_TIMEOUT then
    begin
      KeepAliveNeeded;
      FreeAndNil(AResult);
      FetchAsStream;
    end
    else if FErrorCode <> 0 then
      RaiseError(AResult)
    else
    begin
      Json2DataSet(AResult.ItemByName('result'), FActiveFieldDefs,
        FActiveRecords);
    end;
  end;
  procedure FetchDataSet;
  var
    ADataSet: TQDataSet;
  begin
    AResult := Rest('OpenDataSet', nil, AReqJson, true);
    CheckError(AResult, false);
    if FErrorCode = ERROR_TOKEN_TIMEOUT then
    begin
      KeepAliveNeeded;
      FreeAndNil(AResult);
      FetchDataSet;
    end
    else if FErrorCode <> 0 then
      RaiseError(AResult)
    else
    begin
      Json2DataSet(AResult.ItemByName('result'), FActiveFieldDefs,
        FActiveRecords);
    end;
  end;

  procedure DoExecuteSQL;
  begin
    AResult := Rest('ExecSQL', nil, AReqJson, true);
    CheckError(AResult, false);
    if FErrorCode = ERROR_TOKEN_TIMEOUT then
    begin
      KeepAliveNeeded;
      FreeAndNil(AResult);
      DoExecuteSQL;
    end
    else if FErrorCode <> 0 then
      RaiseError(AResult)
    else
      ARequest.Result.Statics.AffectRows := AResult.IntByName('result', 0);
  end;

begin
  Result := false;
  AResult := nil;
  ATokenTimeout := false;
  AReqJson := TQJson.Create;
  try
    AReqJson.Add('id').AsString := ARequest.Command.Id;
    AReqJson.Add('sql').AsString := ARequest.Command.SQL;
    if TransactionLevel > 0 then
      AReqJson.Add('transaction').AsBoolean := true;
    if Length(ARequest.Command.Params) > 0 then
    begin
      with AReqJson.Add('params', jdtArray) do
      begin
        for I := 0 to High(ARequest.Command.Params) do
          Add.AsVariant := ARequest.Command.Params[I].AsVariant
      end;
    end;
    case ARequest.Command.Action of
      caPrepare: // ��֧��
        Result := true;
      caFetchStream:
        FetchAsStream;
      caFetchRecords:
        begin
          FetchDataSet;
          Result := true;
        end;
      caExecute:
        begin
          DoExecuteSQL;
          Result := true;
        end;
      caUnprepare:
        Result := true;
    end;
  finally
    FreeAndNil(AReqJson);
    if Assigned(AResult) then
      FreeAndNil(AResult);
  end;
end;

procedure TQHttpProvider.InternalOpen;
var
  AResult, ATokens: TQJson;
  ATime: TDateTime;
  AExpire: Integer;
begin
  inherited;
  AResult := Rest('Open', Params, nil, false);
  try
    CheckError(AResult, true);
    if AResult.HasChild('result', ATokens) then
    begin
      // ������token
      ATime := Now;
      FAccessToken.Value := ATokens.ValueByName('access_token', '');
      // Ĭ�ϻỰ��Ч��Ϊ2Сʱ��7200�룩
      AExpire := ATokens.IntByName('access_expire', 7200);
      FAccessToken.ExpireTime := IncSecond(ATime, AExpire);
      if AExpire > 30 then // ��ǰ30��ˢ�»Ự
        PeekInterval := AExpire - 30;
      FRefreshToken.Value := ATokens.ValueByName('refresh_token', '');
      // ˢ�»Ự��Ч�ڣ�Ĭ��Ϊ30��
      FRefreshToken.ExpireTime :=
        IncSecond(ATime, ATokens.IntByName('refresh_expire', 2592000));
      // ���Ӿ��
      FHandle := IntPtr(Self);
      FServerExtParams.Assign(ATokens);
    end;
  finally
    FreeAndNil(AResult);
  end;
end;

procedure TQHttpProvider.Json2DataSet(ASource: TQJson; AFieldDefs: TFieldDefs;
  ARecords: TQRecords);
var
  AFieldsRoot, ARowsRoot, AItem: TQJson;
  ADefs: TQFieldDefs;
  ADef: TQFieldDef;
  function TypeOfName(const AName: String): TFieldType;
  begin
    for Result := Low(TFieldType) to High(TFieldType) do
    begin
      if FieldTypeNames[Result] = AName then
        Exit;
    end;
    Result := ftWideMemo;
  end;

  function CheckSize(AValue: Integer): Integer;
  var
    I: Integer;
  begin
    if ADef.DataType in ftFixedSizeTypes then
      Result := 0
    else if ADef.DataType = ftGuid then
      Result := dsGuidStringLength
    else if ADef.DataType = ftBcd then
    begin
      if AValue > 32 then
        Result := 32
      else
        Result := AValue;
    end
    else if AValue < 0 then
    begin
      if ADef.DataType in [ftString, ftWideString] then
        Result := MaxInt
      else
        Result := 0;
    end
    else
      Result := AValue;
  end;

  function ForceInRange(const V, AMin, AMax: Integer): Integer;
  begin
    if V < AMin then
      Result := AMin
    else if V > AMax then
      Result := AMax
    else
      Result := V;
  end;

  procedure LoadFieldDefs;
  var
    I, J: Integer;
    AFlags: TQJson;
    S: String;
  begin
    AFieldDefs.BeginUpdate;
    try
      ADefs := AFieldDefs as TQFieldDefs;
      for I := 0 to AFieldsRoot.Count - 1 do
      begin
        AItem := AFieldsRoot[I];
        ADef := ADefs.AddFieldDef as TQFieldDef;
        ADef.Name := AItem.ValueByName('name', '');
        ADef.Table := AItem.ValueByName('table', '');
        ADef.Schema := AItem.ValueByName('schema', '');
        ADef.Database := AItem.ValueByName('category', '');
        ADef.BaseName := AItem.ValueByName('base_name', '');
        // ADef.Nullable:=AItem
        ADef.DBNo := I;
        ADef.DataType := TypeOfName(AItem.ValueByName('delphi_type',
          'WideMemo'));
        ADef.Size := CheckSize(AItem.IntByName('len', -1));
        ADef.Precision := AItem.IntByName('precision', -1);
        ADef.Scale := AItem.IntByName('scale', 0);
        if AItem.HasChild('flags', AFlags) then
        begin
          for J := 0 to AFlags.Count - 1 do
          begin
            S := LowerCase(AFlags[J].AsString);
            if S = 'not_null' then
              ADef.Nullable := false
            else if (S = 'primary_key') or (S = 'multiple_key') then
            begin
              ADef.IsPrimary := true;
              ADef.IsIndex := true;
            end
            else if S = 'unique_key' then
            begin
              ADef.IsUnique := true;
              ADef.IsIndex := true;
            end
            else if S = 'blob' then // Blob���ֶ������п���ֱ�ӻ�ȡ������Ҫ����
                ;

          end;

        end;
      end;
    finally
      AFieldDefs.EndUpdate;
    end;
  end;
  procedure WriteBlobStream(AStream: TStream; AValue: TQJson);
  var
    ABytes: TBytes;
    V: String;
  begin
    if ADef.DataType = ftWideMemo then
    begin
      V := AValue.AsString;
      if Length(V) > 0 then
        AStream.Write(PChar(V)^, Length(V) shl 1);
    end
    else if ADef.DataType in [ftMemo, ftFmtMemo] then
    begin
      ABytes := qstring.AnsiEncode(V);
      if Length(ABytes) > 0 then
        AStream.Write(ABytes[0], Length(ABytes));
    end
    else
      AValue.StreamFromValue(AStream);
  end;
  procedure LoadRecords;
  var
    I: Integer;
    J: Integer;
    ARec: TQRecord;
    AFieldItem: TQJson;
  begin
    for I := 0 to ARowsRoot.Count - 1 do
    begin
      AItem := ARowsRoot[I];
      ARec := TQRecord.Create(ADefs);
      ARec.AddRef;
      for J := 0 to ADefs.Count - 1 do
      begin
        ADef := ADefs[J] as TQFieldDef;
        AFieldItem := AItem[J];
        with ARec.Values[J].OldValue do
        begin
          if AFieldItem.IsNull then
            Reset
          else
          begin
            TypeNeeded(ADef.ValueType);
            case ValueType of
              vdtBoolean:
                Value.AsBoolean := AFieldItem.AsBoolean;
              vdtFloat:
                Value.AsFloat := AFieldItem.AsFloat;
              vdtInteger:
                Value.AsInteger := AFieldItem.AsInteger;
              vdtInt64:
                Value.AsInt64 := AFieldItem.AsInt64;
              vdtCurrency:
                Value.AsCurrency := AFieldItem.AsFloat;
              vdtBcd:
                Value.AsBcd^ := DoubleToBcd(AFieldItem.AsFloat);
              vdtGuid:
                if not TryStrToGuid(AFieldItem.AsString, Value.AsGuid^) then
                begin
                  if ADef.Nullable then
                    Reset;
                end;
              vdtDateTime:
                if AFieldItem.IsDateTime then
                  Value.AsDateTime := AFieldItem.AsDateTime
                else if ADef.Nullable then
                  Reset
                else
                  Value.AsDateTime := 0;
              vdtInterval:
                Value.AsInt64 := AFieldItem.AsInt64;
              vdtString:
                Value.AsString^ := AFieldItem.AsString;
              vdtStream:
                WriteBlobStream(Value.AsStream, AFieldItem);
            end;
          end;
        end;
      end;
      AddResultRecord(ARec);
    end;
  end;

begin
  AFieldsRoot := ASource.ItemByName('Fields');
  ARowsRoot := ASource.ItemByName('Records');
  if Assigned(AFieldsRoot) and Assigned(ARowsRoot) then
  begin
    LoadFieldDefs;
    LoadRecords;
  end
  else
    DatabaseError(SUnknownJsonFormat);
end;

procedure TQHttpProvider.KeepAliveNeeded;
var
  AParams: TStringList;
  AResult, ATokens: TQJson;
  ATime: TDateTime;
begin
  AParams := TStringList.Create;
  AResult := nil;
  try
    AParams.Add('refreshtoken=' + RefreshToken.Value);
    AResult := Rest('RefreshToken', AParams, nil, true);
    CheckError(AResult, true);
    if AResult.HasChild('result', ATokens) then
    begin
      ATime := Now;
      FAccessToken.Value := ATokens.ValueByName('access_token', '');
      FAccessToken.ExpireTime :=
        IncSecond(ATime, ATokens.IntByName('access_expire', 7200));
      FRefreshToken.Value := ATokens.ValueByName('refresh_token', '');
      FRefreshToken.ExpireTime :=
        IncSecond(ATime, ATokens.IntByName('refresh_expire', 2592000));
      FHandle := IntPtr(Self);
      FServerExtParams.Assign(ATokens);
    end;
  finally
    FreeAndNil(AParams);
    if Assigned(AResult) then
      FreeAndNil(AResult);
  end;
end;

procedure TQHttpProvider.RaiseError(AJson: TQJson);
begin
  raise EQDBHttpException.Create(AJson);
end;

function TQHttpProvider.Rest(Action: QStringW; Params: TStrings; AData: TQJson;
  AUseToken: Boolean): TQJson;
var
  AUrl: TQUrl;
  AStatus: Integer;
begin
  Result := TQJson.Create;
  AUrl := TQUrl.Create(ServiceUrl + Action);
  try
    // ǿ��Ϊ����������ֵ
    // URLǩ�������㷨Ϊ����ֵ+Salt,SaltΪAppSalt
    if Assigned(Params) then
      AUrl.Params.Assign(Params);
    // ����� Access Token������
    if AUseToken and (Length(AccessToken.Value) > 0) then
      AUrl.Params.Values['token'] := AccessToken.Value
    else if Length(AppId) > 0 then
      AUrl.Params.Values['appid'] := AppId;
    // ǿ�ƴ�ʱ�����ȥ���������˻��¼�ͻ��˺ͷ������˵�ʱ����죬���̫�󣬻�ܾ������Ա���α�����ʷ���ݰ�
    // ע�⣺����������Ҫ��ͻ������������ʱ��һ�£�������ʱ�����������¼�ͻ��˵�ʱ��������ͷ������˵Ĳ�ֵ��
    // �Ƚ�Ҳ���������ֵΪ�������Ӷ����ⲻ��Ҫ�鷳����Ȼ�ͻ���Ҳ����ͬ����������ʱ��
    AUrl.Params.Values['timestamp'] := IntToStr(DateTimeToUnix(Now));
    AUrl.SortParams();
    // ����ǩ��
    AUrl.Params.Values['sign'] :=
      DigestToString(MD5Hash(AUrl.OriginParams + '&' + AppSalt), true);
    // ��������
    AUrl.RandSortParams;
    repeat
      AStatus := FRequests.Rest(AUrl.Url, AData, Result, CustomHeaders,
        nil, reqPost);
    until AStatus <> 12030; // 12030- HTTP��������ʱ������������ֹ
    if AStatus <> 200 then
    begin
      Result.Add('code').AsInteger := -1000 - AStatus;
      Result.Add('hint').AsString := Format(SHttpError, [AStatus]);
    end;
  finally
    FreeAndNil(AUrl);
  end;
end;

procedure TQHttpProvider.SetAppId(const Value: QStringW);
begin
  Params.Values['appid'] := Value;
end;

procedure TQHttpProvider.SetServiceUrl(const Value: QStringW);
begin
  if FServiceUrl <> Value then
  begin
    Close;
    if not EndWithW(Value, '/', false) then
      FServiceUrl := Value + '/'
    else
      FServiceUrl := Value;
  end;
end;

{ TQDBHttpException }

constructor EQDBHttpException.Create(AJson: TQJson);
begin
  inherited Create(AJson.ValueByName('hint', SUnknownError));
  FErrorCode := AJson.IntByName('code', -999);
  FHelp := AJson.ValueByName('help', '');
end;

end.

unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.DialogService, FMX.Platform, FMX.Memo,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, weipay, FMX.StdCtrls, FMX.Layouts, FMX.ScrollBox,
  qjson, qstring, qworker, qdac_fmx_modaldlg;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Layout1: TLayout;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure DoPayDone(AJob: PQJob);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qsdk.wechat,
  qdac_fmx_pophint, System.Net.httpclient, System.NetConsts,
  System.Net.UrlClient;
{$R *.fmx}

type
  TSimplePaymentService = class(TInterfacedObject, IPaymentService)
  protected
    FPayDoneSignalId: Cardinal;
    function Prepay(ACartItems: ICartItems; APayOrder: IPayOrder): Boolean;
    // ������Ԥ֧��
    procedure AfterPay(ACartItems: ICartItems; APayOrder: IPayOrder); // ֧����ɵĴ���
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

const
  ERROR_REST_BASE = -1;
  ERROR_REST_EXCEPTION = ERROR_REST_BASE - 1;
  ERROR_REST_BADFORMAT = ERROR_REST_BASE - 2;
  ERROR_REST_HTTPCODE = ERROR_REST_BASE - 1000;

  ERROR_USER_NOT_EXISTS = 1;
  ERROR_USER_EXISTS = 2;
  ERROR_ACTIVATE_KEY_MISMATCH = 3;
  ERROR_SIGN_MISMATCH = 4;
  ERROR_USER_ACTIVATED = 5;
  ERROR_USER_NOT_ACTIVATED = 6;
  ERROR_USER_DISABLED = 7;
  ERROR_UNKNOWN_SOURCE = 8;
  ERROR_INTERNAL = 9;
  ERROR_REDIRECT_NEEDED = 10;
  ERROR_PASSWORD_MISMATCH = 11;
  ERROR_REGISTER_CLOSED = 12;
  ERROR_SESSION_NOT_EXISTS = 13;
  ERROR_SESSION_TIMEOUT = 14;
  ERROR_ACTIVATE_KEY_TIMEOUT = 15;
  ERROR_PARAMETER_MISSING = 16;
  ERROR_ACTIVATE_KEY_GETFAILED = 17;
  ERROR_REGISTERFAILED = 18;

  SignalPayDone = 'Order.PayDone';
  CreateOrderUrl = 'http://ddb.b86400.com:75/app_ddb/v2/orders/prepay.php';

function RestGet(AUrl: String; AData: TQJson;
  AIsRetry: Boolean = false): TQJson;
var
  ARequest: THttpClient;
  AReply: IHttpResponse;
  AStream: TMemoryStream;
  AErrorCode: Int64;
  AExceptionMsg: String;
  procedure DoRedirect(ANewUrl: String);
  var
    AParams: QStringW;
    // http://addr:port?
  begin
    FreeObject(Result);
    AParams := AUrl;
    DecodeTokenW(AParams, '?', #0, false, true);
    if ContainsCharW(ANewUrl, '?') then
      Result := RestGet(ANewUrl + '&' + AParams, AData)
    else
      Result := RestGet(ANewUrl + '?' + AParams, AData);
  end;
  function RemoveExceptionUrl(S: String): String;
  var
    p: PQCharW;
  begin
    AErrorCode := ERROR_REST_EXCEPTION;
    if S = SNetHttpClientUnknownError then
      Result := 'δ֪����ִ������ʱ�쳣��ֹ'
    else if StartWithW(PQCharW(S), 'Error ', false) then
    begin
      p := PQCharW(S);
      Inc(p, 6);
      SkipSpaceW(p);
      ParseInt(p, AErrorCode);
      p := StrStrW(p, ': ');
      if Assigned(p) then
      begin
        Inc(p, 2);
        Result := p;
      end
      else
        Result := S;
    end
    else
      Result := S;
  end;
  function JsonError: String;
  var
    AJson: TQJson;
  begin
    AJson := TQJson.Create;
    Result := '';
    try
      AJson.parse(AReply.ContentAsString());
    except
      on E: Exception do
        Result := E.Message
    end;
  end;
  function HandleJavaException(var S: String): Boolean;
  var
    ps: PChar;
  begin
    ps := PChar(S);
    Result := false;
    if StartWithW(ps, 'java.net.', false) then
    begin
      Inc(ps, 9);
      if StartWithW(ps, 'UnknownHostException', false) then // �޷���������
      begin
        S := '�޷�������������ַ���볢�����´����߻��ƶ��������硣';
        Result := true;
      end
      else if StartWithW(ps, 'SocketException', false) then
        Result := true
      else if StartWithW(ps, 'SocketTimeoutException', false) then
      begin
        S := 'δ����ָ����ʱ������ɲ������볢�����´����߻��ƶ��������硣';
      end;
    end;
  end;

begin
  ARequest := THttpClient.Create;
  try
    // ARequest.UserAgent := UserAgent;
    ARequest.AcceptEncoding := 'compress';
    ARequest.ConnectionTimeout := 3000;
    if Assigned(AData) then
    begin
      ARequest.ContentType := 'application/json';
      AStream := TMemoryStream.Create;
      try
        AData.SaveToStream(AStream, teUTF8, false, false);
        AStream.Position := 0;
        DebugOut('Post to %s', [AUrl]);
        AReply := ARequest.Post(AUrl, AStream);
      finally
        FreeObject(AStream);
      end;
    end
    else
    begin
      DebugOut('Get from %s', [AUrl]);
      AReply := ARequest.Get(AUrl);
    end;
    if Assigned(AReply) then
    begin
      if AReply.StatusCode = 200 then
      begin
        Result := TQJson.Create;
        if not Result.TryParse(AReply.ContentAsString()) then
        begin
          Result.Clear;
          Result.Add('code').AsInteger := -1;
          Result.Add('message').AsString := AReply.ContentAsString() +
            SLineBreak + ' ������Ч�� JSON ����'{$IFDEF DEBUG}
            + ':' + SLineBreak + JsonError{$ENDIF}
            ;
        end
        else // �����ض����µ�ַ
        begin
          if Result.IntByName('code', -1) = ERROR_REDIRECT_NEEDED then
            DoRedirect(Result.ValueByPath('result.location', ''));
        end;
      end
      else
      begin
        Result := TQJson.Create;
        Result.Add('code').AsInteger := ERROR_REST_HTTPCODE - AReply.StatusCode;
        Result.Add('message').AsString := AReply.StatusText;
      end;
    end;
  except
    on E: Exception do
    begin
      AExceptionMsg := RemoveExceptionUrl(E.Message);
{$IFDEF ANDROID}
      if HandleJavaException(AExceptionMsg) and (not AIsRetry) then
        Result := RestGet(AUrl, AData, true)
      else
      begin
{$ENDIF}
        Result := TQJson.Create;
        Result.Add('message').AsString := AExceptionMsg;
        Result.Add('code').AsInteger := AErrorCode;
{$IFDEF ANDROID}
      end;
{$ENDIF}
    end
  end;
  ARequest.DisposeOf;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ACartItems: ICartItems;
begin
  ACartItems := NewCartItems;
  ACartItems.Subject := '��������Ա����';
  ACartItems.Add('55151', '����ע������', 0.01, 1);
  ACartItems.Add('55152', '������������', 0, 1);
  AppPay(ACartItems);
end;

{ TSimplePaymentService }

procedure TSimplePaymentService.AfterPay(ACartItems: ICartItems;
  APayOrder: IPayOrder);
begin
  // ֧����ɣ�����֧�����
  Workers.Signal(FPayDoneSignalId, Pointer(APayOrder), jdfFreeAsInterface);
end;

constructor TSimplePaymentService.Create;
begin
  FPayDoneSignalId := Workers.RegisterSignal(SignalPayDone);
  // ΢�ŷ����AppId��MchId
  WechatService.AppId := 'wx8bc703a355d45e78';
  WechatService.MchId := '1376816302';
end;

destructor TSimplePaymentService.Destroy;
begin

  inherited;
end;

function TSimplePaymentService.Prepay(ACartItems: ICartItems;
  APayOrder: IPayOrder): Boolean;
var
  AOrderJson, AResultJson, AParams: TQJson;
  AWechatOrder: IWechatPayOrder;
  I: Integer;
  AItem: PCartItem;
begin
  RunInMainThread(
    procedure
    begin
      PopupHint.ShowHint('��������֧��������Ϣ�����Ժ򡭡�', TTextAlign.Center,
        TTextAlign.Trailing);
    end);
  AParams := TQJson.Create;
  try
    AParams.Add('sid').AsString := '009add0a-fbf0-4ddf-802a-343b566d93a8';
    AParams.Add('pt').AsInteger := Integer(APayOrder.Source) -
      Integer(psWechat);
    AParams.Add('source').AsString := 'DDB';
    with AParams.Add('order') do
    begin
      Add('total').AsInteger := Trunc(APayOrder.Fee * 100);
      // �Ż�ȯ�ݲ�֧��
      Add('promo').AsString := '';
      with Add('items', jdtArray) do
      begin
        for I := 0 to ACartItems.Count - 1 do
        begin
          AItem := ACartItems[I];
          if AItem.Selected then // ѡ�е���Ʒ
          begin
            with Add do
            begin
              Add('id').AsString := AItem.Id;
              Add('name').AsString := AItem.Name;
              Add('quantity').AsInteger := AItem.Num;
              Add('price').AsInteger := Trunc(AItem.Price * 100);
            end;
          end;
        end;
      end;
    end;
    AOrderJson := RestGet(CreateOrderUrl, AParams);
    if AOrderJson.HasChild('result', AResultJson) then
    begin
      Result := true;
      if APayOrder.Source = TPaySource.psWechat then
      begin
        with AResultJson do
        begin
          AWechatOrder := APayOrder as IWechatPayOrder;
          AWechatOrder.OrderId := ValueByName('orderid', '');
          AWechatOrder.PrepayId := ValueByName('prepayid', '');
          AWechatOrder.NonceStr := ValueByName('noncestr', '');
          AWechatOrder.Sign := ValueByName('sign', '');
          AWechatOrder.Timestamp := IntByName('timestamp', 0);
        end;
      end
      else if APayOrder.Source = TPaySource.psAlipay then
      begin
        with AResultJson do
        begin
          APayOrder.OrderId := ValueByName('orderid', '');
          APayOrder.Timestamp := IntByName('timestamp', 0);
          with APayOrder as IAliPayOrder do
          begin
            PayStr := ValueByName('paystr', '');
            Timeout := IntByName('timeout', 30);
          end;
          // ����֧���Ķ�����ʱ����
        end;
      end
      else // ����֧����ʽ����ʱʵ���ϲ�֧�֣�����Ĵ������ As Is �Ķ���
      begin
        with AResultJson do
        begin
          APayOrder.OrderId := ValueByName('orderid', '');
          APayOrder.Timestamp := IntByName('timestamp', 0);
          APayOrder.Sign := ValueByName('sign', '');
        end;
      end;
    end
    else
    begin
      APayOrder.ErrorCode := AOrderJson.IntByName('code', -1);
      APayOrder.ErrorMsg := AOrderJson.ValueByName('message', '');
      Result := false;
    end;
  finally
    FreeAndNil(AParams);
    FreeAndNil(AOrderJson);
  end;
end;

procedure TForm1.DoPayDone(AJob: PQJob);
var
  AOrder: IPayOrder;
begin
  AOrder := IPayOrder(AJob.Data);
  if Assigned(AOrder) then
  begin
    AOrder := IPayOrder(AJob.Data);
    if AOrder.PayResult = TPayResult.prOk then
      Memo1.Lines.Add(AOrder.OrderId + ' ֧���ɹ���')
    else
    begin
      Memo1.Lines.Add(AOrder.OrderId + ' ֧��ʧ��,�������:' +
        IntToStr(AOrder.ErrorCode));
      Memo1.Lines.Add(AOrder.ErrorMsg);
    end
  end
  else
    Memo1.Lines.Add('�û�ȡ���˶������ɡ�');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Workers.Wait(DoPayDone, SignalPayDone, true);
end;

initialization

TPlatformServices.Current.AddPlatformService(IPaymentService,
  TSimplePaymentService.Create);

end.

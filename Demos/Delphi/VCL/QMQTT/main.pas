unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  QMqttClient, QJson, QLog, qdac_ssl_ics;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    leServerHost: TLabeledEdit;
    leServerPort: TLabeledEdit;
    leUserName: TLabeledEdit;
    lePassword: TLabeledEdit;
    Button1: TButton;
    Panel5: TPanel;
    btnSubscribe: TButton;
    Panel6: TPanel;
    Panel7: TPanel;
    btnPublish: TButton;
    Splitter1: TSplitter;
    Label1: TLabel;
    edtSubscribeTopic: TEdit;
    Label2: TLabel;
    edtPublishTopic: TEdit;
    Label3: TLabel;
    edtMessage: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel8: TPanel;
    Label4: TLabel;
    cbxQoSLevel: TComboBox;
    Panel9: TPanel;
    Label5: TLabel;
    cbxRecvQoSLevel: TComboBox;
    tmSend: TTimer;
    chkAutoSend: TCheckBox;
    chkAutoClearLog: TCheckBox;
    Label6: TLabel;
    edtClientId: TEdit;
    tmStatics: TTimer;
    pnlStatus: TPanel;
    chkSSL: TCheckBox;
    cbxVersion: TComboBox;
    btnUnsubscribe: TButton;
    Panel10: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure btnPublishClick(Sender: TObject);
    procedure tmSendTimer(Sender: TObject);
    procedure chkAutoSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmStaticsTimer(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure chkSSLClick(Sender: TObject);
    procedure btnUnsubscribeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FClient: TQMQTTMessageClient;
    procedure DoClientConnecting(ASender: TQMQTTMessageClient);
    procedure DoClientConnected(ASender: TQMQTTMessageClient);
    procedure DoClientDisconnected(ASender: TQMQTTMessageClient);
    procedure DoClientError(ASender: TQMQTTMessageClient; const AErrorCode: Integer; const AErrorMsg: String);
    procedure DoSubscribeDone(ASender: TQMQTTMessageClient; const AResults: TQMQTTSubscribeResults);
    procedure DoBeforePublish(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoAfterPublished(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoRecvTopic(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoStdTopicTest(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoPatternTopicTest(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoRegexTopicTest(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoMultiDispatch1(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoMultiDispatch2(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoBeforeUnsubscribe(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
    procedure DoAfterUnsubscribe(ASender: TQMQTTMessageClient; const ATopic: String);
    procedure SaveSettings;
    procedure LoadSettings;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qstring;
{$R *.dfm}

procedure TForm1.btnPublishClick(Sender: TObject);
begin
  if Assigned(FClient) then
    FClient.Publish(edtPublishTopic.Text, edtMessage.Text, TQMQTTQoSLevel(cbxQoSLevel.ItemIndex));
end;

procedure TForm1.btnSubscribeClick(Sender: TObject);
var
  ATopics: TArray<String>;
  S: String;
  p: PChar;
  C: Integer;
begin
  if Assigned(FClient) then
  begin
    SetLength(ATopics, 4);
    S := edtSubscribeTopic.Text;
    p := PChar(S);
    C := 0;
    while p^ <> #0 do
    begin
      ATopics[C] := DecodeTokenW(p, ',', #0, true);
      Inc(C);
    end;
    SetLength(ATopics, C);
    FClient.Subscribe(ATopics, TQMQTTQoSLevel(cbxRecvQoSLevel.ItemIndex));
  end;
end;

procedure TForm1.btnUnsubscribeClick(Sender: TObject);
var
  ATopics: TArray<String>;
  S: String;
  p: PChar;
  C: Integer;
begin
  if Assigned(FClient) then
  begin
    SetLength(ATopics, 4);
    S := edtSubscribeTopic.Text;
    p := PChar(S);
    C := 0;
    while p^ <> #0 do
    begin
      ATopics[C] := DecodeTokenW(p, ',', #0, true);
      Inc(C);
    end;
    SetLength(ATopics, C);
    FClient.Unsubscribe(ATopics);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Button1.Caption = '����' then
  begin
    if not Assigned(FClient) then
      FClient := TQMQTTMessageClient.Create(Self);
    FClient.Stop;
    // ClientId �����ָ��������Զ�����һ�������ClientId������ָ��
    FClient.ClientId := edtClientId.Text;
    FClient.ServerHost := leServerHost.Text;
    FClient.ServerPort := StrToIntDef(leServerPort.Text, 1883);
    FClient.UserName := leUserName.Text;
    FClient.Password := lePassword.Text;
    FClient.UseSSL := chkSSL.Checked;
    // if FClient.UseSSL then
    // FClient.SSLManager.LoadCAFiles('root.pem');
    if cbxVersion.ItemIndex = 1 then
    begin
      FClient.ProtocolVersion := pv5_0;
      FClient.ConnectProps.AsInt[MP_NEED_PROBLEM_INFO] := 1;
    end
    else
      FClient.ProtocolVersion := pv3_1_1;
    FClient.PeekInterval := 15;
    // 5.0 test
    //
    // ����������м�����ӹ��̣���Щ�¼�����Ҫ��
    FClient.BeforeConnect := DoClientConnecting;
    FClient.AfterConnected := DoClientConnected;
    FClient.AfterDisconnected := DoClientDisconnected;
    FClient.AfterSubscribed := DoSubscribeDone;
    FClient.BeforePublish := DoBeforePublish;
    FClient.AfterPublished := DoAfterPublished;
    FClient.BeforeUnsubscribe := DoBeforeUnsubscribe;
    FClient.AfterUnsubscribed := DoAfterUnsubscribe;
    FClient.OnError := DoClientError;
    FClient.OnRecvTopic := DoRecvTopic;
    // ����������Լ��Ķ��ģ����������Ҫ���͵��������˵ģ����Բ�֧�����򣬵�����ʹ��������˱��ʽƥ��
    // ��ο���http://itindex.net/detail/58722-mqtt-topic-%E9%80%9A%E9%85%8D%E7%AC%A6
    FClient.Subscribe(['/Topic/Dispatch'], qlMax1);
    // ������ɷ�����֧����ȫƥ�䣨Ĭ�ϣ���������˱��ʽ��������ʽ�����յ���Ӧ������ʱ�������Ӧ�Ĵ�����
    FClient.RegisterDispatch('/Topic/Dispatch', DoStdTopicTest);
    FClient.RegisterDispatch('/+/Dispatch', DoPatternTopicTest, mtPattern);
    FClient.RegisterDispatch('/Topic\d', DoRegexTopicTest, mtRegex);
    FClient.RegisterDispatch('/Topic1', DoMultiDispatch1, mtFull);
    FClient.RegisterDispatch('/Topic1', DoMultiDispatch2, mtFull);
    // ������̨����
    FClient.Start;
  end
  else
  begin
    FClient.Stop;
    Button1.Caption := '����';
  end;
end;

procedure TForm1.chkAutoSendClick(Sender: TObject);
begin
  tmSend.Enabled := chkAutoSend.Checked;
end;

procedure TForm1.chkSSLClick(Sender: TObject);
begin
  if chkSSL.Checked then
    leServerPort.Text := '8883'
  else
    leServerPort.Text := '1883';
end;

procedure TForm1.DoAfterPublished(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo2.Lines.Add('���� ' + ATopic + ' ID=' + IntToStr(AReq.TopicId) + ',��С:' + IntToStr(AReq.Size) + ' ���');
end;

procedure TForm1.DoAfterUnsubscribe(ASender: TQMQTTMessageClient; const ATopic: String);
begin
  Memo1.Lines.Add('���� ' + ATopic + ' ��ȡ��');
end;

procedure TForm1.DoBeforePublish(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo2.Lines.Add('���ڷ��� ' + ATopic + ' ID=' + IntToStr(AReq.TopicId) + ',��С:' + IntToStr(AReq.Size) + ' ...');
end;

procedure TForm1.DoBeforeUnsubscribe(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('����ȡ������ ' + ATopic + '...');
end;

procedure TForm1.DoClientConnected(ASender: TQMQTTMessageClient);
begin
  Memo1.Lines.Add(ASender.ServerHost + ':' + IntToStr(ASender.ServerPort) + ' ���ӳɹ�.');
  Button1.Caption := '�Ͽ�';
end;

procedure TForm1.DoClientConnecting(ASender: TQMQTTMessageClient);
begin
  Memo1.Lines.Add('�������� ' + ASender.ServerHost + ':' + IntToStr(ASender.ServerPort));
end;

procedure TForm1.DoClientDisconnected(ASender: TQMQTTMessageClient);
begin
  Memo1.Lines.Add('���� ' + ASender.ServerHost + ':' + IntToStr(ASender.ServerPort) + '�ѶϿ�');
end;

procedure TForm1.DoClientError(ASender: TQMQTTMessageClient; const AErrorCode: Integer; const AErrorMsg: String);
begin
  Memo1.Lines.Add('����:' + AErrorMsg + ',����:' + IntToStr(AErrorCode));
end;

procedure TForm1.DoMultiDispatch1(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('Dispatch1 ���յ�Topic:' + ATopic + SLineBreak + '  ID:' + IntToStr(AReq.TopicId) + SLineBreak + '  ����(' +
    RollupSize(AReq.TopicContentSize) + '):' + AReq.TopicText);
end;

procedure TForm1.DoMultiDispatch2(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('Dispatch2 ���յ�Topic:' + ATopic + SLineBreak + '  ID:' + IntToStr(AReq.TopicId) + SLineBreak + '  ����(' +
    RollupSize(AReq.TopicContentSize) + '):' + AReq.TopicText);
end;

procedure TForm1.DoPatternTopicTest(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('ͨ�������ģʽƥ���ɷ�:' + ATopic + SLineBreak + '  ID:' + IntToStr(AReq.TopicId) + SLineBreak + '  ����(' +
    RollupSize(AReq.TopicContentSize) + '):' + AReq.TopicText);
end;

procedure TForm1.DoRecvTopic(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('���յ�Topic:' + ATopic + SLineBreak + '  ID:' + IntToStr(AReq.TopicId) + SLineBreak + '  ����(' +
    RollupSize(AReq.TopicContentSize) + '):' + AReq.TopicText);
end;

procedure TForm1.DoRegexTopicTest(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('ͨ�����������ƥ���ɷ�:' + ATopic + SLineBreak + '  ID:' + IntToStr(AReq.TopicId) + SLineBreak + '  ����(' +
    RollupSize(AReq.TopicContentSize) + '):' + AReq.TopicText);
end;

procedure TForm1.DoStdTopicTest(ASender: TQMQTTMessageClient; const ATopic: String; const AReq: PQMQTTMessage);
begin
  Memo1.Lines.Add('ͨ��������ɷ�:' + ATopic + SLineBreak + '  ID:' + IntToStr(AReq.TopicId) + SLineBreak + '  ����(' +
    RollupSize(AReq.TopicContentSize) + '):' + AReq.TopicText);
end;

procedure TForm1.DoSubscribeDone(ASender: TQMQTTMessageClient; const AResults: TQMQTTSubscribeResults);
var
  I: Integer;
begin
  for I := 0 to High(AResults) do
  begin
    if AResults[I].Success then
      Memo1.Lines.Add(AResults[I].Topic + ' -> QoS ' + IntToStr(Ord(AResults[I].Qos)) + ' �������')
    else
      Memo1.Lines.Add(AResults[I].Topic + ' -> QoS ' + IntToStr(Ord(AResults[I].Qos)) + ' ����ʧ��');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetDefaultLogFile('', 2097152, false);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(FClient) then
    FClient.AfterDisconnected := nil;
end;

procedure TForm1.LoadSettings;
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  try
    if FileExists('mqtt.config') then
      AJson.LoadFromFile('mqtt.config');
    leServerHost.Text := AJson.ValueByName('host', '');
    leServerPort.Text := AJson.ValueByName('port', '1883');
    leUserName.Text := AJson.ValueByName('user', '');
    lePassword.Text := AJson.ValueByName('pass', '');
  finally
    FreeAndNil(AJson);
  end;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
  if Assigned(FClient) then
    FClient.Publish('/Topic1', StringReplicateW('0', 16848), qlMax1);
end;

procedure TForm1.SaveSettings;
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  try
    AJson.Add('host').AsString := leServerHost.Text;
    AJson.Add('port').AsString := leServerPort.Text;
    AJson.Add('user').AsString := leUserName.Text;
    AJson.Add('pass').AsString := lePassword.Text;
    AJson.SaveToFile('mqtt.config');
  finally
    FreeAndNil(AJson);
  end;

end;

procedure TForm1.tmSendTimer(Sender: TObject);
begin
  btnPublishClick(Sender);
  if chkAutoClearLog.Checked then
  begin
    if tmSend.Tag = 0 then
      tmSend.Tag := GetTickCount
    else if GetTickCount - Cardinal(tmSend.Tag) > 15000 then
    begin
      tmSend.Tag := GetTickCount;
      Memo1.Text := '';
      Memo2.Text := '';
    end;
  end;
end;

procedure TForm1.tmStaticsTimer(Sender: TObject);
begin
  if Assigned(FClient) then
    pnlStatus.Caption := '�յ�����:' + IntToStr(FClient.RecvTopics) + ' ��������:' + IntToStr(FClient.SentTopics);
end;

end.

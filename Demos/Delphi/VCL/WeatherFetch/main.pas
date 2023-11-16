unit main;

interface

{ ��ʾ����ʾ��һ����΢���ӵ�QWorker������
  1��������ҵʹ����һ�����л���TQJobGroup�����һ�����̿���
  1.1���Ӱٶ�����ʹ��For���л�ȡ148�����е�������Ϣ����д�뵽Memo��
  1.2�������߳�����ʾ���������ѵ�ʱ��
  2����ҵִ�н�������ʾ�ָ���ť״̬�������´β���
}
uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, QString, QWorker, wininet,
  ExtCtrls;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoFetchWeathers(AJob: PQJob);
    procedure FetchCityWeather(ALoopMgr: TQForJobs; AJob: PQJob;
      AIndex: NativeInt);
    procedure DoLogWeather(AJob: PQJob);
    procedure DoShowResult(AJob: PQJob);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses qjson;
{$R *.dfm}

const
  Cities: array [0 .. 147] of String = ('������', '�ӱ߳�����������', '��ƽ��', '�׳���', '�����',
    'ʯ��ׯ��', '��ɽ��', '�ػʵ���', '������', '��̨��', '������', '�żҿ���', '�е���', '������', '�ȷ���',
    '��ˮ��', '�Ϻ���', '̫ԭ��', '��ͬ��', '��Ȫ��', '������', '������', '˷����', '������', '�˳���', '������',
    '�ٷ���', '������', '���������', '������', '�׸���', '˫Ѽɽ��', '������', '������', '��ľ˹��', '��̨����',
    'ĵ������', '�ں���', '�绯��', '���˰������', '�Ϻ���', '�ϲ���', '��������', 'Ƽ����', '�Ž���', '������',
    'ӥ̶��', '������', '������', '�˴���', '������', '������', '��ɳ��', '������', '��̶��', '������', '������',
    '������', '������', '�żҽ���,', '������', '������', '������', '������', '¦����', '������', '������',
    '�ع���', '������', '�麣��', '��ͷ��', '��ɽ��', '������', 'տ����', 'ï����', '������', '������', '÷����',
    '��β��', '��Դ��', '������', '��Զ��', '��ݸ��', '��ɽ��', '������', '������', '�Ƹ���', '������', '������',
    '������', '������', '������', '���Ǹ���', '������', '�����', '������', '��ɫ��', '������', '�ӳ���',
    '������', '������', '������', '������', '��Ϫ��', '��ɽ��', '��ͨ��', '������', '�ն���', '�ٲ���', '������',
    '�����', '��ɽ��', '��˫������', '����', '�º�', 'ŭ��', '����', '������', '����', 'ɽ��', '�տ���',
    '����', '����', '��֥', '������', 'ͭ����', '������', '������', 'μ����', '�Ӱ���', '������', '������',
    '������', '������', '������', '������', '����', '����', '����', '����', '����', '����', '����',
    '���ͺ�����', '��ͷ��', '�ں���', '�����', 'ͨ����');

const
  BaiduAK: String = 'rZh9hrIOiQMzC7Cj3r6PYvcq';
  // �ٶ�ÿ����5000��������ƣ��������Ϊ�Լ���AK����Ϊ��ʾ��;

procedure TForm4.Button1Click(Sender: TObject);
var
  AGroup: TQJobGroup;
begin
Button1.Enabled := False;
Button1.Caption := '��ȡ��...';
Memo1.Lines.Clear;
AGroup := TQJobGroup.Create(True);
AGroup.Prepare;
AGroup.Add(DoFetchWeathers, nil, False);
AGroup.Add(DoShowResult, Pointer(GetTickCount), True);
AGroup.Run();
AGroup.MsgWaitFor();
FreeObject(AGroup);
Button1.Caption := '��ʼ';
Button1.Enabled := True;
end;

procedure TForm4.DoFetchWeathers(AJob: PQJob);
begin
//�����������ƣ�Ϊ�˷��������û���ȡ�ɹ����޸�����Ϊÿ��ֻ��ȡ10������
TQForJobs.For(0, 9, FetchCityWeather);
end;

procedure TForm4.DoLogWeather(AJob: PQJob);
begin
Memo1.Lines.Add(PString(AJob.Data)^);
Dispose(PString(AJob.Data));
end;

procedure TForm4.DoShowResult(AJob: PQJob);
begin
ShowMessage('��ȡ����������ɣ���ʱ' + Rolluptime((GetTickCount - Cardinal(AJob.Data))
  div 1000));
end;

procedure TForm4.FetchCityWeather(ALoopMgr: TQForJobs; AJob: PQJob;
  AIndex: NativeInt);
var
  AConn, AHttp: HINTERNET;
  AReaded: Cardinal;
  S: TMemoryStream;
  AJson: TQJson;
  AWeather: PString;
  ABuf: array [0 .. 65535] of Byte;
  function EncodeUtf8Url(S: QStringW): QStringW;
  var
    U8: QStringA;
    p: PQCharA;
  begin
  U8 := QString.Utf8Encode(S);
  p := PQCharA(U8);
  SetLength(Result, 0);
  while p^ <> 0 do
    begin
    if p^ < 128 then
      begin
      Result := Result + Char(p^);
      Inc(p);
      end
    else
      begin
      while p^ >= 128 do
        begin
        Result := Result + '%' + IntToHex(p^, 2);
        Inc(p);
        end;
      end;
    end;
  end;

begin
AConn := InternetOpen(nil, INTERNET_OPEN_TYPE_DIRECT, nil, nil, 0);
if AConn <> nil then
  begin
  AHttp := InternetOpenUrl(AConn,
    PChar('http://api.map.baidu.com/telematics/v3/weather?location=' +
    EncodeUtf8Url(Cities[AIndex]) + '&output=json&ak=' + BaiduAK), nil,
    0, 0, 0);
  if AHttp <> nil then
    begin
    S := TMemoryStream.Create;
    try
      while InternetReadFile(AHttp, @ABuf[0], 65536, AReaded) and
        (AReaded > 0) do
        S.WriteBuffer(ABuf[0], AReaded);
      S.Position := 0;
      AJson := TQJson.Create;
      try
        if AJson.TryParse(LoadTextW(S)) then
          begin
          // ����������Ϣ
          New(AWeather);
          AWeather^ := IntToStr(AIndex) + '-' + Cities[AIndex] + '����:'#13#10 +
            AJson.AsJson;
          Workers.Post(DoLogWeather, AWeather, True);
          end;
      finally
        FreeObject(AJson);
      end;
    finally
      FreeObject(S);
      InternetCloseHandle(AHttp);
    end;
    end;
  InternetCloseHandle(AConn);
  end;
end;

end.

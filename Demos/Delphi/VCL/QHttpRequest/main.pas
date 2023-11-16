unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  qhttprequest, QJson, QWorker;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FWebRequests: TQHttpRequests;
    procedure DoReqestDone(ASender: TObject);
    procedure DoRecvProgress(const Sender: TObject; ATotal, AReaded: Int64;
      var Abort: Boolean);
    procedure DoError(ASender: TObject; AError: Exception);
    procedure DoRedirect(ASender: TObject; var Allow: Boolean);
    procedure DoBeforeDownload(ASender: TObject; AHeaders: IQHttpHeaders;
      var AContinue: Boolean);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses qstring;
{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  AReq: TQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self);
  AReq.MainThreadNotify := True; // ��Ϊ���ǹ��������̵߳�֪ͨ�����Բ��ܵȴ��������
  AReq.Url := Edit1.Text;
  AReq.OnRecvData := DoRecvProgress;
  AReq.AfterDone := DoReqestDone;
  AReq.OnError := DoError;
  AReq.BeforeUrlRedirect := DoRedirect;
  FWebRequests.Push(AReq);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  AReq: TQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self);
  AReq.MainThreadNotify := True; // ��Ϊ���ǹ��������̵߳�֪ͨ�����Բ��ܵȴ��������
  AReq.Url := Edit1.Text;
  AReq.OnRecvData := DoRecvProgress;
  AReq.AfterDone := DoReqestDone;
  AReq.OnError := DoError;
  AReq.Action := reqHead;
  // AReq.ConnectionTimeut:=100;
  AReq.BeforeUrlRedirect := DoRedirect;
  FWebRequests.Push(AReq);

end;

procedure TForm2.Button3Click(Sender: TObject);
var
  AReq: TQHttpFileRequestItem;
begin
  AReq := TQHttpFileRequestItem.Create(Self);
  AReq.MainThreadNotify := True;
  AReq.Url := Edit1.Text;
  AReq.OnRecvData := DoRecvProgress;
  AReq.AfterDone := DoReqestDone;
  AReq.OnError := DoError;
  AReq.Path := ExtractFilePath(Application.ExeName);
  AReq.FileName := 'temp.~a';
  AReq.ResumeBroken := True;
  AReq.BeforeDownload := DoBeforeDownload;
  AReq.BeforeUrlRedirect := DoRedirect;
  FWebRequests.Push(AReq);
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  AStatusCode: Integer;
  AText: String;
begin
  AStatusCode := FWebRequests.Get('http://blog.qdac.cc', AText);
  Memo1.Lines.Add('StatusCode=' + IntToStr(AStatusCode));
  Memo1.Lines.Add(AText);
end;

procedure TForm2.Button5Click(Sender: TObject);
var
  AResult: TQJSon;
begin
  AResult := TQJSon.Create;
  try
    if FWebRequests.Rest
      ('http://api.map.baidu.com/telematics/v3/weather?location=%E5%8C%97%E4%BA%AC&output=json&ak=rZh9hrIOiQMzC7Cj3r6PYvcq',
      TQJSon(nil), AResult) = 200 then
      Memo1.Lines.Add(AResult.AsJson)
    else
      Memo1.Lines.Add('����ʧ��');
  finally
    FreeAndNil(AResult);
  end;
end;

procedure TForm2.DoBeforeDownload(ASender: TObject; AHeaders: IQHttpHeaders;
  var AContinue: Boolean);
begin
  Memo1.Lines.Add('Server Reply:');
  Memo1.Lines.Add(AHeaders.Text);
end;

procedure TForm2.DoError(ASender: TObject; AError: Exception);
begin
  Memo1.Lines.Add('����ʧ��:' + AError.Message);
  Memo1.Lines.Add('StatusCode:' + IntToStr((ASender as TQHttpRequestItem)
    .StatusCode));
end;

procedure TForm2.DoRecvProgress(const Sender: TObject; ATotal, AReaded: Int64;
  var Abort: Boolean);
var
  AReq: TQHttpRequestItem;
  S: String;
begin
  if not Abort then
  begin
    AReq := Sender as TQHttpRequestItem;
    if AReq is TQHttpFileRequestItem then
    begin
      with AReq as TQHttpFileRequestItem do
      begin
        S := RollupSize(ResponseStream.Position);
        if AReq.ContentLength > 0 then
          S := S + '/' + RollupSize(FileSize);
      end;
    end
    else
      S := '';
    S := S + ' -' + RollupSize(AReaded);
    if ATotal > 0 then
      Caption := S + '/' + RollupSize(ATotal)
    else
      Caption := S;
  end;
end;

procedure TForm2.DoRedirect(ASender: TObject; var Allow: Boolean);
begin
  Memo1.Lines.Add(IntToStr((ASender as TQHttpRequestItem).RedirectTimes) +
    '''s Redirect to:' + (ASender as TQHttpRequestItem).ResultUrl);
end;

procedure TForm2.DoReqestDone(ASender: TObject);
  function IsTextContent(AType: String): Boolean;
  begin
    AType := Lowercase(AType);
    Result := (Pos('text', AType) > 0) or (Pos('xml', AType) > 0) or
      (Pos('json', AType) > 0) or (Pos('java', AType) > 0);
  end;

begin
  with TQHttpRequestItem(ASender) do
  begin
    Memo1.Lines.Add('==============Header============');
    Memo1.Lines.Add('Request:');
    Memo1.Lines.Add(RequestHeaders.Text);
    Memo1.Lines.Add('Reply:');
    Memo1.Lines.Add('Http status:' + IntToStr(StatusCode) + ' ' + StatusText);
    Memo1.Lines.Add(ResponseHeaders.Text);
    Memo1.Lines.Add('==============Body============');
    if IsTextContent(ResponseHeaders['content-type']) then
      Memo1.Lines.Add(ContentAsString)
    else
      Memo1.Lines.Add('[Content is not known text format,ignore]');
    Memo1.Lines.Add('==============Statics=========');
    Memo1.Lines.Add('Expect Url:' + Url);
    Memo1.Lines.Add('Real Url:' + ResultUrl);
    Memo1.Lines.Add('StartTime:' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',
      StartTime));
    Memo1.Lines.Add('StopTime:' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',
      StopTime));
    Memo1.Lines.Add('Sent bytes:' + RollupSize(SentBytes));
    Memo1.Lines.Add('Recv bytes:' + RollupSize(RecvBytes));
    if IsAborted then
      Memo1.Lines.Add('Aborted');
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FWebRequests := TQHttpRequests.Create;
  FWebRequests.MaxClients := 3;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FWebRequests);
end;

procedure TForm2.Panel1Click(Sender: TObject);
var
  AGroup: TQJobGroup;
  I: Integer;
begin
  if Panel1.Tag = 0 then
  begin
    Panel1.Tag := 1;
    Workers.MaxWorkers := 50;
    FWebRequests.MaxClients := 20;
    AGroup := TQJobGroup.Create();
    try
      repeat
      AGroup.MaxWorkers := 8;
      Caption := 'Starting...';
      for I := 0 to 99 do
        AGroup.Add(
          procedure(AJob: PQJob)
          var
            S: String;
          begin
            FWebRequests.Rest('http://www.baidu.com', TQJSon(nil), nil);
          end, nil);
      Caption := 'Wait for done';
      AGroup.MsgWaitFor();
      Caption := 'Done';
      until 1>2;
    finally
      AGroup.Free;
      Panel1.Tag:=0;
    end;
  end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  Caption := IntToStr(Workers.Workers) + '-' + IntToStr(Workers.IdleWorkers) +
    '-' + IntToStr(Workers.BusyWorkers);
end;

end.

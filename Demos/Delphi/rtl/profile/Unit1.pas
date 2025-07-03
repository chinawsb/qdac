unit Unit1;

interface

{
  ��ʾ�������� JclDebug ��������Է�����Ϣ���������� Windows ƽ̨��
  ��Ϊ Delphi û�� C++ ������ __FILE__/__FUNC__/__LINE__ һ��ĺ���������޷�ͨ��Ԥ������ȡ��ǰ���Ʋ�����
  ���������ṩ�����ֽ��������
  -
  �����ֱ�Ӵ��������ƣ����Ժ�����һ�δ���
  �������� Windows ƽ̨�µ��� TQProfile.Calc()
}
{$DEFINE ENABLE_JCL_DEBUG }

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdContext, IdCustomHTTPServer, IdBaseComponent,
  IdComponent, IdCustomTCPServer, IdHTTPServer{$IFDEF ENABLE_JCL_DEBUG}, qdac.profile.win{$ENDIF};

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    IdHTTPServer1: TIdHTTPServer;
    Button7: TButton;
    Button8: TButton;
    chkByMs: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure chkByMsClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoProfile(ALevel: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qdac.profile;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  // ����һ���ֲ��������浱ǰջ��Ϣ���Ա� TThread.ForceQueue ���ܹ���¼������Ϣ���������Ҫ���տ��Ժ��Է���ֵ
  var
  AStack := TQProfile.Calc('TForm1.Button1Click').CurrentStack;
  DoProfile(0);
  TThread.ForceQueue(nil,
    procedure
    begin
      TQProfile.Calc('TForm1.Button1Click.ForceQueue', AStack);
      ShowMessage('Queued clicked');
    end);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Text := TQProfile.AsString;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  TQProfile.Calc('TForm1.Button3Click');
  TThread.CreateAnonymousThread(
    procedure
    begin
      DoProfile(0);
    end).Start;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  TQProfile.Calc('DoCost');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  TQProfile.Calc('TForm1.Button5Click');
  DoProfile(0);
  TThread.ForceQueue(nil,
    procedure
    begin
      TQProfile.Calc('TForm1.Button5Click.ForceQueue#TForm1.Button5Click');
      ShowMessage('Queued clicked');
    end);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  IdHTTPServer1.Active := true;
  ShellExecute(Handle, 'open', PChar('http://localhost:' + IntToStr(IdHTTPServer1.DefaultPort)), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  TQProfile.Calc();
  ShowMessage('Simple calc');
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  ASleep: Cardinal;
begin
  TQProfile.Calc(
    procedure(const AEscaped: Double)
    begin
      Memo1.Lines.Add('Sleep(' + ASleep.ToString + ') ʵ����ʱ ' + AEscaped.ToString + ' ����');
    end);
  ASleep := random(50 + random(300));
  TThread.Sleep(ASleep);
end;

procedure TForm1.chkByMsClick(Sender: TObject);
begin
  if chkByMs.Checked then
    TQProfile.TimeUnit := tuMilliSecond
  else
    TQProfile.TimeUnit := tuDefault;
end;

procedure TForm1.DoProfile(ALevel: Integer);
begin
  // ���Ǹ�һ���Զ��������
  TQProfile.Calc('TForm1.DoProfile');
  Inc(ALevel);
  if ALevel < 32 then
    DoProfile(ALevel);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TQProfile.Translation.Start := '��ʼ';
  TQProfile.Translation.Thread := '�߳�';
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo;
AResponseInfo: TIdHTTPResponseInfo);
  function ExtractJsFileName(const S: String): String;
  var
    AList: TArray<String>;
  begin
    AList := S.Split(['/', '\']);
    Result := AList[High(AList)];
  end;
  procedure LoadJs;
  var
    AFileName: String;
  begin
    if ARequestInfo.Document.StartsWith('/mermaid.esm.min/chunks/mermaid.esm.min/') then
      AFileName := '../../mermaid.esm.min/chunks/' + ExtractJsFileName(ARequestInfo.Document)
    else
      AFileName := '../../mermaid.esm.min/' + ExtractJsFileName(ARequestInfo.Document);
    if FileExists(AFileName) then
    begin
      AResponseInfo.ContentType := 'application/javascript;charset=utf-8';
      AResponseInfo.ServeFile(AContext, AFileName);
    end
    else
      AResponseInfo.ResponseNo := 404;
  end;

begin
  if ARequestInfo.Document.StartsWith('/mermaid.esm.min') then
    LoadJs
  else if ARequestInfo.Document = '/' then
  begin
    AResponseInfo.ContentText := '<html>' + SLineBreak + //
      '<body>' + SLineBreak + //
      '<pre class="mermaid">' + SLineBreak + //
      TQProfile.AsDiagrams + SLineBreak + //
      '</pre>' + SLineBreak + //
      '<script type="module">' + SLineBreak + //
      'import mermaid from "/mermaid.esm.min/mermaid.esm.min.mjs"' + SLineBreak + //
      'mermaid.initialize({ startOnLoad: true });' + SLineBreak + //
      '</script>' + SLineBreak + //
      '</body>' + SLineBreak + //
      '</html>'; //
    AResponseInfo.ContentType := 'text/html;charset=utf-8';
  end
  else
    AResponseInfo.ResponseNo := 404;
end;

initialization

ReportMemoryLeaksOnShutdown := true;

end.

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
  // 定义一个局部变量缓存当前栈信息，以便 TThread.ForceQueue 中能够记录引用信息，如果不需要，刚可以忽略返回值
  var
  AProfile := TQProfile.Calc('TForm1.Button1Click');
  DoProfile(0);
  TThread.ForceQueue(nil,
    procedure
    begin
      TQProfile.Calc('TForm1.Button1Click.ForceQueue#1', AProfile.Stack);
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
  TQProfile.Calc('PerfCost');
end;

procedure TForm1.DoProfile(ALevel: Integer);
begin
  TQProfile.Calc('TForm1.DoProfile');
  Inc(ALevel);
  if ALevel < 32 then
    DoProfile(ALevel);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TThread.NameThreadForDebugging('MainThread');
end;

end.

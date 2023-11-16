unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QWorker, Vcl.Menus, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    miTools: TMenuItem;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure DoUpdateProgress(AJob: PQJob);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DoUpdateProgress(AJob: PQJob);
begin
  ProgressBar1.Position := Integer(AJob.Data);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Workers.Wait(DoUpdateProgress,
    Workers.RegisterSignal('Progress.Update'), True);
  Workers.Signal('Application.Starting');
  // ...
  Workers.Signal('Application.Started');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Workers.Signal('Application.Stopping');
  // ...
  Workers.Signal('Application.Stopped');
end;

end.

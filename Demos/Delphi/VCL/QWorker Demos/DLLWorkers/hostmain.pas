unit hostmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
type
  TDoJob=procedure;stdcall;
procedure TForm2.Button1Click(Sender: TObject);
var
  hDLL:HINST;
  AProc:TDoJob;
begin
  hDLL:=LoadLibrary('dll.dll');
  if hDLL<>0 then
    begin
    AProc:=TDoJob(GetProcAddress(hDLL,'DoJob'));
    AProc;
    Sleep(1000);
    FreeLibrary(hDLL);
    end;
end;

end.

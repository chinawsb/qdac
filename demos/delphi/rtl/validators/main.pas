unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,qdac.validator;

type
  TForm4 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormCreate(Sender: TObject);
var
  ipv4: TQIPV4Validator;
begin
  ipv4 := TQIPV4Validator.create;
  if ipv4.Accept('123.04.05.1') then
    ShowMessage('gasdf');
end;

end.

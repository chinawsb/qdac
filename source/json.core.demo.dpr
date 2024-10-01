program json.core.demo;

uses
  Vcl.Forms,
  main in '..\demos\delphi\rtl\json.core.demo\main.pas' {Form1},
  qdac.json.core in 'qdac.json.core.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program serialization;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  qdac.serialize.base in '..\..\..\..\source\qdac.serialize.base.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

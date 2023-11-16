program dgbuilder;

uses
  System.StartUpCopy,
  FMX.Forms,
  qdac_fmx_dialog_builder in '..\..\..\..\Source\qdac_fmx_dialog_builder.pas' {Form1},
  main in 'main.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

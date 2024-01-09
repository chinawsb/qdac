program Exe;

uses
  Vcl.Forms,
  Frm_Main in 'Frm_Main.pas' {Form_Main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Main, Form_Main);
  Application.Run;
end.

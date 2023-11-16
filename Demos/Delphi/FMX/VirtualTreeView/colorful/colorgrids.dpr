program colorgrids;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {frmGridStyles};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGridStyles, frmGridStyles);
  Application.Run;
end.

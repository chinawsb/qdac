unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Unit3, Vcl.ComCtrls, Vcl.StdCtrls,
  qplugins_base, qplugins, qplugins_vcl_formsvc;

type
  TForm4 = class(TForm3)
  private
    { Private declarations }
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); override;stdcall;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}
{ TForm4 }

procedure TForm4.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin
  inherited;
  if AId = FNotifyId then // 多个通知关联到同一个对象时，通过AId进行进行区分
  begin
    if not Visible then
      Show;
    ProgressBar1.Position := 100 - AParams[0].AsInteger;
  end;
end;

initialization

RegisterServices('/Services/Docks/Forms',
  [TQVCLFormService.Create('DLL_Shared4', TForm4.Create(nil), nil)]);
RegisterServices('/Services/Docks/Forms',
  [TQVCLFormService.Create('DLL_MutiInstance4', TForm4)]);

finalization

UnregisterServices('/Services/Docks/Forms', ['DLL_Shared4', 'DLL_MutiInstance4']);

end.

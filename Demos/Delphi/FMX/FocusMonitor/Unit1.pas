unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.Controls.Presentation, FMX.Edit,System.Messaging;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    ShadowEffect1: TShadowEffect;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FSubscribeId:Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses qdac_fmx_vkhelper;
{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
FSubscribeId:=TMessageManager.DefaultManager.SubscribeToMessage(TFocusChanged,
  procedure (const Sender: TObject; const M: TMessage)
  var
    ACtrl:TControl;
  begin
    if Assigned(Screen.FocusControl) then
      begin
      ACtrl:=Screen.FocusControl as TControl;
      Edit1.Text:=ACtrl.Name;
      ShadowEffect1.Parent:=ACtrl;
      end;
  end);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
TMessageManager.DefaultManager.Unsubscribe(TFocusChanged,FSubscribeId);
end;

end.

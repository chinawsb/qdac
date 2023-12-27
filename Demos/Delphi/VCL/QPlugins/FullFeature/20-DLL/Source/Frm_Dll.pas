unit Frm_Dll;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.ExtCtrls;

type
  TForm_Dll = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    LabeledEdit1: TLabeledEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  Form_Dll: TForm_Dll; }

implementation

{$R *.dfm}

procedure TForm_Dll.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 10 do
  begin
    Memo1.Lines.Add(Format('%d年Delphi一场梦！', [I]));
  end;
end;

//按下回车按钮
procedure TForm_Dll.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Button1Click(Self);
  end;
end;

end.

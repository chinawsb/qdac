unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    StyleBook1: TStyleBook;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses qdac_fmx_dialog_builder, FMX.objects, FMX.Edit;
{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
  CustomDialog('Dialog', 'Build dialog test',
    'I create this dialog for demo not real ', ['Yes', 'No'], diWarning);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
begin
  ABuilder := NewDialog('Edit');
  ABuilder.AutoSize := true;
  with ABuilder.AddContainer(TDialogItemAlignMode.amVertTop) do
  begin
    ItemSpace := 10;
    AutoSize := true;
    with TLabel(ABuilder.AddControl(TLabel).Control) do
    begin
      Margins.Rect := RectF(3, 3, 3, 3);
      AutoSize := true;
      Text := '姓名:';
    end;
    with TEdit(ABuilder.AddControl(TEdit).Control) do
    begin
      Margins.Rect := RectF(3, 3, 3, 3);
      TextPrompt := '请在此输入您的姓名';
    end;
  end;
  with ABuilder.AddContainer(TDialogItemAlignMode.amHorizRight) do
  begin
    Height := 24;
    Paddings:=Rect(5,5,5,5);
    ItemSpace := 10;
    AddButton('确定', mrOk);
    AddButton('取消', mrCancel);
  end;
  ABuilder.ShowModal;
end;

end.

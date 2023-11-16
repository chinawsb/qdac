unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, qdac_fmx_virtualtree,
  Data.Bind.GenData, Data.Bind.Components, Data.Bind.ObjectScope, FMX.ScrollBox,
  FMX.Memo;

type
  TfrmGridStyles = class(TForm)
    QVirtualTreeView1: TQVirtualTreeView;
    QVTCustomTextCell1: TQVTCustomTextCell;
    Memo1: TMemo;
    QVTTextEditor1: TQVTTextEditor;
    QVTPickListCell1: TQVTPickListCell;
    procedure QVirtualTreeView1GetNodeBackground(Sender: TQVirtualTreeView;
      ANode: TQVTNode; AFill: TBrush; var AHandled: Boolean);
    procedure QVTCustomTextCell1GetText(ASender: TObject; var AText: string);
    procedure QVirtualTreeView1InitNode(Sender: TQVirtualTreeView;
      ANode: TQVTNode);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGridStyles: TfrmGridStyles;

implementation

{$R *.fmx}

const
  DemoData: array [0 .. 6, 0 .. 2] of String = (('White', 'Jony wheak',
    'Programer'), ('Black', 'Hai cai', 'UI designer'),
    ('Yellow', 'Cooker', 'UX'), ('Blue', 'Gookus Tom', 'Tester'),
    ('Gray', 'Cai Cai', 'Tester'), ('Red', 'Otata', 'Manager'),
    ('Pink', 'Deeper', 'Dept Manager'));

procedure TfrmGridStyles.QVirtualTreeView1GetNodeBackground
  (Sender: TQVirtualTreeView; ANode: TQVTNode; AFill: TBrush;
  var AHandled: Boolean);
begin
  if (ANode.Index mod 2) = 1 then
    AFill.Color := $FFB8CCE4
  else
    AHandled := false;
end;

procedure TfrmGridStyles.QVirtualTreeView1InitNode(Sender: TQVirtualTreeView;
  ANode: TQVTNode);
begin
if (ANode.Index and $1)<>0 then
  ANode.Height:=Sender.DefaultRowHeight*1.5;//奇数行高度为默认高度的1.5x
end;

procedure TfrmGridStyles.QVTCustomTextCell1GetText(ASender: TObject;
  var AText: string);
begin
  with QVTCustomTextCell1 do
    AText := DemoData[Node.Index][ColumnId];
end;

end.

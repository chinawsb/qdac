unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, qdac_fmx_virtualtree, FMX.Layouts,
  FMX.Edit, FMX.ScrollBox, FMX.Memo;

type
  TForm3 = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    QVirtualTreeView1: TQVirtualTreeView;
    Layout3: TLayout;
    Layout4: TLayout;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    EllipsesEditButton1: TEllipsesEditButton;
    odLogFile: TOpenDialog;
    tcData: TQVTCustomTextCell;
    procedure EllipsesEditButton1Click(Sender: TObject);
    procedure tcDataGetText(ASender: TObject; var AText: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.EllipsesEditButton1Click(Sender: TObject);
begin
if odLogFile.Execute then
  begin
  //
  end;
end;

procedure TForm3.tcDataGetText(ASender: TObject; var AText: string);
begin
//
//tcData.Node.Tag
end;

end.

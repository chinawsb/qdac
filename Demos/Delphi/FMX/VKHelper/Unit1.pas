unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit,qdac_fmx_vkhelper, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Memo1: TMemo;
    Layout1: TLayout;
    Button1: TButton;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    StyleBook1: TStyleBook;
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  S:String;
  function CompProps(AComp:TComponent):String;
  var
    S1:TMemoryStream;
    S2:TStringStream;
  begin
    S1:=TMemoryStream.Create;
    S2:=TStringStream.Create;
    S1.WriteComponent(AComp);
    S1.Position:=0;
    ObjectBinaryToText(S1,S2);
    Result:=S2.DataString;
    S1.DisposeOf;
    S2.DisposeOf;
  end;
  procedure EnumChildren(AIdent:String;AParent:TFMXObject);
  var
    I:Integer;
    AChild:TFMXObject;
  begin
  for I := 0 to AParent.ChildrenCount-1 do
    begin
    AChild:=AParent.Children[I];
    S:=S+AIdent+AChild.ClassName+':'+AChild.Name+SLineBreak;
    EnumChildren(AIdent+'   ',AChild);
    end;
  end;
begin
S:='';
//EnumChildren('',Self);

ShowMessage(S);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
Edit1.Text:=IntToStr(Width)+'x'+IntToStr(Height);
end;

end.

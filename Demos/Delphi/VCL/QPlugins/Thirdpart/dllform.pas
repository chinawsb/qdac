unit dllform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VirtualTrees, qplugins,qplugins_base,
  qplugins_vcl_formsvc;

type
  TForm2 = class(TForm)
    vstLines: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure vstLinesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  vstLines.RootNodeCount := 100;
end;

procedure TForm2.vstLinesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  CellText := '���ǵ�' + IntToStr(Node.Index) + '��';
end;

initialization

RegisterFormService('Services/Docks/Forms', 'VSTForm', TForm2, False);

finalization

UnregisterServices('Services/Docks/Forms', ['VSTForm']);

end.

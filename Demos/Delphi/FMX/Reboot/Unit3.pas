unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Button1: TButton;
    CalloutPanel1: TCalloutPanel;
    Image1: TImage;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
Label3.Text:='������ر��豸��ҪRoot��Ȩ��'#13#10'δ��ȡ�������Ȩ������Ϊ��'#13#10+
'1���豸δRoot����ʹ����ع����������Root��'#13#10+
'2����δΪ�������ṩ��Ӧ��Ȩ�ޣ��������ṩȨ�ޡ�';
end;

end.

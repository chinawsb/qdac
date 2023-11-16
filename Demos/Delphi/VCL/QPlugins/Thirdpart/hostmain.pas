unit hostmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, qplugins,qplugins_base, qplugins_formsvc,
  qplugins_vcl_formsvc, qplugins_loader_lib, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  AService: IQFormService;
begin
  if Supports(PluginsManager.ByPath('Services/Docks/Forms/VSTForm'),
    IQFormService, AService) then
  begin
    AService.DockTo(Panel1.Handle, Panel1.ClientRect);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
// ע�⣺���� DLL �еķ���ʹ�õ� VirtualStringTree �����˺�̨�߳�
//�������ע����̨����Ļ���Ӧ�ó����˳�ʱ�������� Delphi ����ʵ�ֵ�����
//��ɳ����޷��˳������������Ƴ�ע�ᣬȻ���������رվͺ���
  UnregisterServices('Services/Docks/Forms', ['VSTForm']);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PluginsManager.Loaders.Add
    (TQDLLLoader.Create(ExtractFilePath(Application.ExeName), '.DLL'));
  PluginsManager.Start;
end;

end.

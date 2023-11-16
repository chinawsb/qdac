unit hostmain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, qplugins, qplugins_params,
  qplugins_formsvc, qplugins_vcl_formsvc, qplugins_loader_lib;

{ ע��ʹ�� MDI �Ӵ�����Ϊ����������Ͳ��������ͬʱ����rtl/vcl����ʱ��
}
type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FOpenChildren: array of IQFormService;
    procedure DoFormClosed(AForm: IQFormService; var Action: TCloseAction);
    procedure DoFormFree(AForm: IQFormService);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DoFormClosed(AForm: IQFormService; var Action: TCloseAction);
var
  I: Integer;
begin
  // ����1������ActionΪcaFree��Ȼ����DoFormFree�¼��������������
  // Action := caFree;
  // ����2��ֱ���ͷ����þͿ��ԣ��ŵ��ǲ��ô��� OnFree �¼���
  for I := 0 to High(FOpenChildren) do
  begin
    if FOpenChildren[I] = AForm then
    begin
      Delete(FOpenChildren, I, 1);
      Break;
    end;
  end;
end;

procedure TForm1.DoFormFree(AForm: IQFormService);
var
  I: Integer;
begin
  // ֱ���ͷ����þͿ���
  for I := 0 to High(FOpenChildren) do
  begin
    if FOpenChildren[I] = AForm then
    begin
      Delete(FOpenChildren, I, 1);
      Break;
    end;
  end;
end;

procedure TForm1.File1Click(Sender: TObject);
var
  AService: IQFormService;
  AEvents: TQFormEvents;
begin
  if Supports(PluginsManager.ByPath('/Services/Forms/MDI/MDITest'),
    IQFormService, AService) then
  begin
    FillChar(AEvents, SizeOf(AEvents), 0);
    AEvents.OnClose := DoFormClosed;
    AEvents.OnFree := DoFormFree;
    AService.HookEvents(AEvents);
    AService.Show;
    SetLength(FOpenChildren, Length(FOpenChildren) + 1);
    FOpenChildren[High(FOpenChildren)] := AService;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
  AEvents: TQFormEvents;
begin
  // ��ֱ�ӹر�ǰ��Ҫ���Ƴ��¼������������ڷ����ͷ�ʱ���ص�DoFormFreeʱ�����
  FillChar(AEvents, SizeOf(AEvents), 0);
  for I := 0 to High(FOpenChildren) do
    FOpenChildren[I].HookEvents(AEvents);
  SetLength(FOpenChildren, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  with PluginsManager do
  begin
    Loaders.Add(TQDLLLoader.Create
      (ExtractFilePath(Application.ExeName), '.dll'));
    Start;
  end;
end;

end.

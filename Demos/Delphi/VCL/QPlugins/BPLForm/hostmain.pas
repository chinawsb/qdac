unit hostmain;

interface

{
  VCL DLL����������Ҫ���� QPlugins.VCL ��Ԫ���õ�Ԫʵ�����������Ϣ������ɷ�
}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, qplugins, qplugins_base,qplugins_loader_lib, QPlugins_Vcl_messages;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    PageControl1: TPageControl;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PageControl1Resize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  IDockableControl = interface
    ['{D0A4BDFA-CB29-4725-9158-C199B9C373C9}']
    procedure DockTo(AHandle: HWND); stdcall;
    procedure HostSizeChanged; stdcall;
  end;

  TDockHostPage = class(TTabSheet)
  private
    procedure SetDockedControl(const Value: IDockableControl);
  protected
    FDockedControl: IDockableControl;
  public
    property DockedControl: IDockableControl read FDockedControl
      write SetDockedControl;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ACtrl: IDockableControl;
  ATabSheet: TDockHostPage;
begin
  ACtrl := PluginsManager.ByPath('Services/Docks/Frame') as IDockableControl;
  if Assigned(ACtrl) then
  begin
    ATabSheet := TDockHostPage.Create(PageControl1);
    ATabSheet.PageControl := PageControl1;
    ATabSheet.Caption := '�� ' + IntToStr(PageControl1.PageCount) + ' ҳ';
    ATabSheet.DockedControl := ACtrl;
    PageControl1.ActivePage := ATabSheet;
  end
  else
    Application.MessageBox('Services/Docks/Frame ����δע�ᣬ�����DLL�ȡ�', '����δע��',
      MB_OK or MB_ICONSTOP);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ACtrl: IDockableControl;
  ATabSheet: TDockHostPage;
begin
  ACtrl := PluginsManager.ByPath('Services/Docks/bplFrame') as IDockableControl;
  if Assigned(ACtrl) then
  begin
    ATabSheet := TDockHostPage.Create(PageControl1);
    ATabSheet.PageControl := PageControl1;
    ATabSheet.Caption := '�� ' + IntToStr(PageControl1.PageCount) + ' ҳ';
    ATabSheet.DockedControl := ACtrl;
    PageControl1.ActivePage := ATabSheet;
  end
  else
    Application.MessageBox('Services/Docks/bplFrame ����δע�ᣬ�����DLL�ȡ�', '����δע��',
      MB_OK or MB_ICONSTOP);
end;


procedure TForm1.FormCreate(Sender: TObject);
var
  APath: String;
begin
  ReportMemoryLeaksOnShutdown := True;
  APath := ExtractFilePath(Application.ExeName);
  // ע��Ĭ�ϵ� DLL ����������չ�����Ը���ʵ�ʵ���������޸ģ������չ��֮���ö��Ż�ֺŷָ�
  PluginsManager.Loaders.Add(TQDLLLoader.Create(APath, '.dll'));
  PluginsManager.Loaders.Add(TQBPLLoader.Create(APath, '.bpl'));
  // �������ע�ᣬ���Ҫ��ʾ���ؽ��ȣ�����ע��IQNotify��Ӧ������Ӧ����֪ͨ
  PluginsManager.Start;
end;

procedure TForm1.PageControl1Resize(Sender: TObject);
var
  I: Integer;
  APage: TDockHostPage;
begin
  for I := 0 to PageControl1.PageCount - 1 do
  begin
    APage := PageControl1.Pages[I] as TDockHostPage;
    if APage.DockedControl <> nil then
      APage.DockedControl.HostSizeChanged;
  end;
end;

{ TDockHostPage }

procedure TDockHostPage.SetDockedControl(const Value: IDockableControl);
begin
  if FDockedControl <> Value then
  begin
    FDockedControl := Value;
    if Assigned(Value) then
      Value.DockTo(Handle);
  end;
end;

end.

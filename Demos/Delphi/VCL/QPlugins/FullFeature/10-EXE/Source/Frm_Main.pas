unit Frm_Main;

interface
//==============================================================================
// ע��  2023��12��27��
//       ����Ķ๦����ʾ��֧����ʱ��֪ͨ����������ж�أ��ӽӿڷ������ݵȡ�
//       QPlugins��DEMO���޶�interface��ļ��غ��ͷš���Ϊ���䣬�ޱ������ڴ�й©��
//       ����ע�ͣ��о���3��д�ġ���DEMO��tianpanhaha���ס�
//==============================================================================

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
  Vcl.ExtCtrls,
  qplugins_vcl_formsvc,
  qplugins_loader_lib,
  qplugins_base,
  qplugins_params,
  QPlugins,
  qplugins_router_delayload;

type
  IMyService = interface
    ['{BE3C2C6D-96E5-406E-AEEA-0B5A851279C5}']
    function GetServiceInst(): THandle; stdcall;
    function ShowDllForm(): TForm; stdcall;
  end;

type
  // ���ڶ��ؼ̳У�����֪ͨ��Ӧ�ӿ�
  TForm_Main = class(TForm, IQNotify)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  public
    DllPath: string;
    DllForm:TForm;
    MyLoader1: IQLoader;
    MyService1: IMyService;
  private
    // ��֪ͨ����ʱ��֪ͨ��Ӧ�����ӿ�
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  end;

var
  Form_Main: TForm_Main;

implementation

{$R *.dfm}

uses
  System.IOUtils,
  System.JSON;

// ����DLL���
procedure TForm_Main.Button1Click(Sender: TObject);
begin
  // ���ط������
  if Assigned(MyLoader1) then
  begin
    // ͨ��MyLoader1�����������ػ�ж�ز��
    MyLoader1.LoadServices(PWideChar(DllPath + 'DLL.dll'));
    // ����ӿڸ�ֵ
    MyService1 := PluginsManager.ByPath('Services/Functest/Dll01')
      as IMyService;
    if Assigned(MyService1) then
    begin
      Memo1.Lines.Add('MyService1���سɹ���');
      Memo1.Lines.Add(MyService1.GetServiceInst.ToString());
      FreeAndNil(DllForm);
      DllForm := MyService1.ShowDllForm();
      DllForm.Show;
    end;
  end;
end;

// ���»س���ť
procedure TForm_Main.Button2Click(Sender: TObject);
var
  m_Inst: THandle;
begin
  // ͨ��MyLoader1�����������ػ�ж�ز��
  if Assigned(MyLoader1) and Assigned(MyService1) then
  begin
    m_Inst := MyService1.GetServiceInst;
    // ����һ�о����������Ӿ��и��ʱ���
    Pointer(MyService1) := nil;
    FreeAndNil(DllForm);
    // ж���������
    MyLoader1.UnloadServices(m_Inst);
    Memo1.Lines.Add('-----------MyService1 ж��-----------');
  end;
end;

// ������ʱ���ص������ļ�
function CreateDelayJson(AId: TGUID; APath: string; ALoader: string;
  AModule: string): string;
var
  m_JsonArray: TJSONArray;
  m_Json: TJSONObject;
begin
  m_JsonArray := TJSONArray.Create;
  m_Json := TJSONObject.Create;
  m_Json.AddPair('Id', GUIDToString(AId));
  m_Json.AddPair('Path', 'Services/Functest/Dll01');
  m_Json.AddPair('Loader', 'Loader_DLL');
  m_Json.AddPair('Module', 'DLL.dll');
  try
    m_JsonArray.Add(m_Json);
    Result := m_JsonArray.ToString();
  finally
    // m_Json.Free;
    m_JsonArray.Free;
  end;
end;

procedure TForm_Main.FormCreate(Sender: TObject);
var
  m_GUID: TGUID;
  m_DelayRouter: TQDelayRouter;
  m_DelayJson: string;
begin
  // ����ڴ�й©
  ReportMemoryLeaksOnShutdown := True;

  // ����GUIDΨһ
  CreateGUID(m_GUID);
  // ������ʱ���ص������ļ�
  m_DelayJson := CreateDelayJson(m_GUID, 'Services/Functest/Dll01',
    'Loader_DLL', 'DLL.dll');
  Memo1.Lines.Add(m_DelayJson);

  // �����ļ����浽����
  TFile.WriteAllText(DllPath + 'delayload.config', m_DelayJson);
  // ����ͬĿ¼DLL�ļ�
  PluginsManager.Loaders.Add(TQDLLLoader.Create(DllPath, '.dll'));
  // �����ӳټ��ط���
  m_DelayRouter := TQDelayRouter.Create;
  m_DelayRouter.ConfigFile := ExtractFilePath(Application.ExeName) +
    'delayload.config';
  // ���һ���ӷ���ӿ�ʵ��
  PluginsManager.Routers.Add(m_DelayRouter);

  // ִ��֪ͨ����
  with PluginsManager as IQNotifyManager do
  begin
    // Subscribe����֪ͨ
    Subscribe(NID_PLUGIN_LOADING, Self);
    Subscribe(NID_PLUGIN_UNLOADING, Self);
    Subscribe(NID_PLUGIN_LOADED, Self);
  end;

  // ���ط������
  MyLoader1 := PluginsManager.ByPath('/Loaders/Loader_DLL') as IQLoader;
end;

procedure TForm_Main.FormDestroy(Sender: TObject);
begin
  // ����֪ͨ
  with PluginsManager as IQNotifyManager do
  begin
    // ȡ������֪ͨ
    Unsubscribe(NID_PLUGIN_LOADING, Self);
    Unsubscribe(NID_PLUGIN_UNLOADING, Self);
    Unsubscribe(NID_PLUGIN_LOADED, Self);
  end;
  // �˳�������
  Pointer(MyService1) := nil;
end;

// ��֪ͨ����ʱ��֪ͨ��Ӧ�����ӿ�
procedure TForm_Main.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
var
  m_Param: IQParam;
begin
  if Assigned(AParams) then
  begin
    // ���ݴ���Ĳ��������в�ͬ�����
    case AId of
      // ����
      NID_PLUGIN_LOADING:
        begin
          // ȡDLL���ȫ·��
          m_Param := AParams.ByName('File');
          Memo1.Lines.Add('---���ز�� ' + ParamAsString(m_Param) + '---');
        end;
      // �������
      NID_PLUGIN_LOADED:
        begin
          // ����ӿڸ�ֵ
          MyService1 := PluginsManager.ByPath('Services/HoldService')
            as IMyService;
          if Assigned(MyService1) then
          begin
            Memo1.Lines.Add('HoldService �Ѿ��ɹ�����');
          end;
        end;
      // ж��
      NID_PLUGIN_UNLOADING:
        begin
          // ȡDLL���ȫ·��
          m_Param := AParams.ByName('Instance');
          if Assigned(m_Param) then
          begin
            // ж��֮��֪ͨһ��
            m_Param := AParams.ByName('File');
            Memo1.Lines.Add('---ж�ز��' + ParamAsString(m_Param) + '���Ƴ���������---');
          end;
        end;
    end;
  end;
end;

end.

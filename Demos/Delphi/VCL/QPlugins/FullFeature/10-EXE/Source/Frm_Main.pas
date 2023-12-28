unit Frm_Main;

interface
//==============================================================================
// 注释  2023年12月27日
//       插件的多功能演示，支持延时，通知，反复加载卸载，从接口返回内容等。
//       QPlugins的DEMO中无对interface类的加载和释放。作为补充，无报错无内存泄漏。
//       逐行注释，研究了3天写的。此DEMO由tianpanhaha贡献。
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
  // 窗口多重继承，增加通知响应接口
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
    // 在通知发生时，通知响应函数接口
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

// 调用DLL插件
procedure TForm_Main.Button1Click(Sender: TObject);
begin
  // 加载服务存在
  if Assigned(MyLoader1) then
  begin
    // 通过MyLoader1加载器来加载或卸载插件
    MyLoader1.LoadServices(PWideChar(DllPath + 'DLL.dll'));
    // 服务接口赋值
    MyService1 := PluginsManager.ByPath('Services/Functest/Dll01')
      as IMyService;
    if Assigned(MyService1) then
    begin
      Memo1.Lines.Add('MyService1加载成功！');
      Memo1.Lines.Add(MyService1.GetServiceInst.ToString());
      FreeAndNil(DllForm);
      DllForm := MyService1.ShowDllForm();
      DllForm.Show;
    end;
  end;
end;

// 按下回车按钮
procedure TForm_Main.Button2Click(Sender: TObject);
var
  m_Inst: THandle;
begin
  // 通过MyLoader1加载器来加载或卸载插件
  if Assigned(MyLoader1) and Assigned(MyService1) then
  begin
    m_Inst := MyService1.GetServiceInst;
    // 加这一行就正常，不加就有概率报错
    Pointer(MyService1) := nil;
    FreeAndNil(DllForm);
    // 卸载这个服务
    MyLoader1.UnloadServices(m_Inst);
    Memo1.Lines.Add('-----------MyService1 卸载-----------');
  end;
end;

// 创建延时加载的配置文件
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
  // 检测内存泄漏
  ReportMemoryLeaksOnShutdown := True;

  // 创建GUID唯一
  CreateGUID(m_GUID);
  // 创建延时加载的配置文件
  m_DelayJson := CreateDelayJson(m_GUID, 'Services/Functest/Dll01',
    'Loader_DLL', 'DLL.dll');
  Memo1.Lines.Add(m_DelayJson);

  // 配置文件保存到本地
  TFile.WriteAllText(DllPath + 'delayload.config', m_DelayJson);
  // 加载同目录DLL文件
  PluginsManager.Loaders.Add(TQDLLLoader.Create(DllPath, '.dll'));
  // 创建延迟加载服务
  m_DelayRouter := TQDelayRouter.Create;
  m_DelayRouter.ConfigFile := ExtractFilePath(Application.ExeName) +
    'delayload.config';
  // 添加一个子服务接口实例
  PluginsManager.Routers.Add(m_DelayRouter);

  // 执行通知功能
  with PluginsManager as IQNotifyManager do
  begin
    // Subscribe订阅通知
    Subscribe(NID_PLUGIN_LOADING, Self);
    Subscribe(NID_PLUGIN_UNLOADING, Self);
    Subscribe(NID_PLUGIN_LOADED, Self);
  end;

  // 加载服务存在
  MyLoader1 := PluginsManager.ByPath('/Loaders/Loader_DLL') as IQLoader;
end;

procedure TForm_Main.FormDestroy(Sender: TObject);
begin
  // 订阅通知
  with PluginsManager as IQNotifyManager do
  begin
    // 取消订阅通知
    Unsubscribe(NID_PLUGIN_LOADING, Self);
    Unsubscribe(NID_PLUGIN_UNLOADING, Self);
    Unsubscribe(NID_PLUGIN_LOADED, Self);
  end;
  // 退出不报错
  Pointer(MyService1) := nil;
end;

// 在通知发生时，通知响应函数接口
procedure TForm_Main.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
var
  m_Param: IQParam;
begin
  if Assigned(AParams) then
  begin
    // 根据传入的参数，进行不同的输出
    case AId of
      // 加载
      NID_PLUGIN_LOADING:
        begin
          // 取DLL插件全路径
          m_Param := AParams.ByName('File');
          Memo1.Lines.Add('---加载插件 ' + ParamAsString(m_Param) + '---');
        end;
      // 加载完成
      NID_PLUGIN_LOADED:
        begin
          // 服务接口赋值
          MyService1 := PluginsManager.ByPath('Services/HoldService')
            as IMyService;
          if Assigned(MyService1) then
          begin
            Memo1.Lines.Add('HoldService 已经成功加载');
          end;
        end;
      // 卸载
      NID_PLUGIN_UNLOADING:
        begin
          // 取DLL插件全路径
          m_Param := AParams.ByName('Instance');
          if Assigned(m_Param) then
          begin
            // 卸载之后，通知一下
            m_Param := AParams.ByName('File');
            Memo1.Lines.Add('---卸载插件' + ParamAsString(m_Param) + '，移除关联服务---');
          end;
        end;
    end;
  end;
end;

end.

unit DllPlugins;

interface

uses
  Vcl.Forms,
  qstring,
  QPlugins,
  qplugins_base;

type
  IMyService = interface
    ['{BE3C2C6D-96E5-406E-AEEA-0B5A851279C5}']
    function GetServiceInst(): THandle; stdcall;
    function ShowDllForm(): TForm; stdcall;
  end;

  TMyService = class(TQService, IMyService)
    constructor Create(const AId: TGUID; AName: QStringW); overload; override;
    function GetServiceInst(): THandle; stdcall;
    function ShowDllForm(): TForm; stdcall;
  end;

implementation

uses
  Frm_Dll;

  {TMyService}

constructor TMyService.Create(const AId: TGUID; AName: QStringW);
begin
  // �����󷵻��Լ�GUID
  inherited Create(AId, AName);
end;

function TMyService.GetServiceInst: THandle;
begin
  // ���ز�������ַ
  Result := Self.GetOwnerInstance();
end;

function TMyService.ShowDllForm(): TForm; stdcall;
begin
  Result := TForm_Dll.Create(nil);
end;

initialization

// ע�����
  RegisterServices('Services/Functest', [TMyService.Create(IMyService, 'Dll01')]);


finalization

// ȡ������ע��
  UnregisterServices('Services/Functest', ['Dll01']);

end.


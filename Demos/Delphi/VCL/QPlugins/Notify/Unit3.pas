unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  QString,
  QPlugins,QPlugins_base,
  QPlugins_vcl_formsvc,
  QPlugins_params;

type
  TForm3 = class(TForm ,IQNotify)
    CheckBox1: TCheckBox;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);

    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);

  protected
    { Private declarations }
    FNotifyId: Integer;
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); virtual;stdcall;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}



procedure TForm3.CheckBox1Click(Sender: TObject);
var
  AMgr: IQNotifyManager;
begin
  AMgr := PluginsManager as IQNotifyManager;
  // ע��֪ͨ���¼������Ʋ���Ҫ����ע�ᣬIdByName�����Ʋ�����ʱ�����Զ�ע�Ტ����һ���µ�ID����
  // �����ͬ�� Id �Ͷ�ζ��ļ���
  FNotifyId := AMgr.IdByName('Tracker.Changed');

  if CheckBox1.Checked  then
     AMgr.Subscribe(FNotifyId, Self)
  else
    AMgr.unSubscribe(FNotifyId, Self);

end;

procedure TForm3.FormCreate(Sender: TObject);
var
  AMgr: IQNotifyManager;
begin

  Label2.Caption := 'ʵ������ʱ�䣺' + FormatDateTime('hh:nn:ss', Now);

  AMgr := PluginsManager as IQNotifyManager;
  // ע��֪ͨ���¼������Ʋ���Ҫ����ע�ᣬIdByName�����Ʋ�����ʱ�����Զ�ע�Ტ����һ���µ�ID����
  // �����ͬ�� Id �Ͷ�ζ��ļ���
  FNotifyId := AMgr.IdByName('Tracker.Changed');
  AMgr.Subscribe(FNotifyId, Self);
end;


procedure TForm3.FormDestroy(Sender: TObject);
var
  AMgr: IQNotifyManager;
begin
  AMgr := PluginsManager as IQNotifyManager;
  // ע��֪ͨ���¼������Ʋ���Ҫ����ע�ᣬIdByName�����Ʋ�����ʱ�����Զ�ע�Ტ����һ���µ�ID����
  // �����ͬ�� Id �Ͷ�ζ��ļ���
  FNotifyId := AMgr.IdByName('Tracker.Changed');
  AMgr.unSubscribe(FNotifyId, Self);

end;

procedure TForm3.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin

  if AId = FNotifyId then // ���֪ͨ������ͬһ������ʱ��ͨ��AId���н�������
  begin
    if not Visible then
      Show;
    ProgressBar1.Position  := AParams[0].AsInteger;
  end;
end;

initialization

RegisterServices('/Services/Docks/Forms',
  [TQVCLFormService.Create('DLL_Shared', TForm3.Create(nil),nil)]);
RegisterServices('/Services/Docks/Forms',
  [TQVCLFormService.Create('DLL_MutiInstance', TForm3)]);

finalization

UnregisterServices('/Services/Docks/Forms', ['DLL_Shared', 'DLL_MutiInstance']);

end.

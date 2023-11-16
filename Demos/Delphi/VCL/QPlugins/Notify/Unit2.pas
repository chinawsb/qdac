unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.StdCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Gauges,
  QPlugins,QPlugins_base,QPlugins_params;

type
  TForm2 = class(TForm, IQNotify)
    Gauge1: TGauge;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    FNotifyId: Integer;
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}
{ TForm2 }

procedure TForm2.CheckBox1Click(Sender: TObject);
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

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
var
  AMgr: IQNotifyManager;
begin
  AMgr := PluginsManager as IQNotifyManager;
  // ע��֪ͨ���¼������Ʋ���Ҫ����ע�ᣬIdByName�����Ʋ�����ʱ�����Զ�ע�Ტ����һ���µ�ID����
  // �����ͬ�� Id �Ͷ�ζ��ļ���
  FNotifyId := AMgr.IdByName('Tracker.Changed');
  AMgr.unSubscribe(FNotifyId, Self);
  action := CaFree;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  AMgr: IQNotifyManager;
begin
  AMgr := PluginsManager as IQNotifyManager;
  // ע��֪ͨ���¼������Ʋ���Ҫ����ע�ᣬIdByName�����Ʋ�����ʱ�����Զ�ע�Ტ����һ���µ�ID����
  // �����ͬ�� Id �Ͷ�ζ��ļ���
  FNotifyId := AMgr.IdByName('Tracker.Changed');
  AMgr.Subscribe(FNotifyId, Self);
end;

procedure TForm2.Notify(const AId: Cardinal; AParams: IQParams;
  var AFireNext: Boolean);
begin


  if AId = FNotifyId then // ���֪ͨ������ͬһ������ʱ��ͨ��AId���н�������
  begin
    if not Visible then
      Show;
    Gauge1.Progress := AParams[0].AsInteger;
  end;
end;

end.

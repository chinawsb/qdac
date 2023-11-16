unit Unit1;

interface
{��ʾ����ʾ�� QWorker �� QAndroidShell ������Ԫ��һ�����÷���
1.ʹ�� Workers.Post �Ķ�ʱ��ҵ�����߳��첽ִ������
2.ʹ�� QAndroidShell.AskForRoot ��ȡ����ԱȨ�޲�ִ�йػ�����������
[��֪����]
* �޷���Ӧң�����ϵ�ȷ�ϼ���û�д��� KeyDown�¼�
}
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, QString, QWorker,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  QAndroid.Shell, Androidapi.JNI.App, FMX.Notification.Android,
  Androidapi.Helpers, Androidapi.JNIBridge,FMX.Platform,
  FMX.Effects, FMX.Notification;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    btnReboot: TButton;
    btnShutdown: TButton;
    Label1: TLabel;
    Popup1: TPopup;
    btnCancel: TButton;
    GlowEffect1: TGlowEffect;
    StyleBook1: TStyleBook;
    procedure btnRebootClick(Sender: TObject);
    procedure btnShutdownClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    FRootShell: TQAndroidShell;
    FShutdownTime: Int64;
    FTimerHandle: IntPtr;
    procedure DoRootDeny(AJob: PQJob);
    procedure DoShutdownCounter(AJob: PQJob);
  public
    { Public declarations }
    property RootShell: TQAndroidShell read FRootShell;
    function RootNeeded: Boolean;
    procedure PendShutdown(AMinutes: Integer);
  end;

var
  Form1: TForm1;
procedure SendAppToBack;

const
  vkReply = $E8; { 232 }

implementation

{$R *.fmx}

uses unit2, unit3, dateutils, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes;

// ͨ���������潫Ӧ���л�����̨
procedure SendAppToBack;
var
  intent: JIntent;
begin
intent := TJIntent.Create;
intent.setAction(TJIntent.JavaClass.ACTION_MAIN);
intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
intent.addCategory(TJIntent.JavaClass.CATEGORY_HOME);
SharedActivityContext.startActivity(intent);
end;
// ����� ActivityManager ʵ��
function SharedActivityManager: JActivityManager;
var
  AService: JObject;
begin
AService := SharedActivityContext.getSystemService
  (TJContext.JavaClass.ACTIVITY_SERVICE);
Result := TJActivityManager.Wrap((AService as ILocalObject).GetObjectID);
end;
// ����ǰӦ�����͵�ǰ̨����Ҫ reorder tasks Ȩ�ޣ���moveTaskToBack�Ϳ��Է��������͵���̨
procedure BringAppToFront;
begin
SharedActivityManager.moveTaskToFront(SharedActivity.getTaskId,
  TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
end;
// �жϵ�ǰӦ�ó����Ƿ���ǰ̨���ָ��û���������ǣ����Ե���BringAppToFront��ʵ�����͵�ǰ̨
function IsAppActive: Boolean;
var
  AList: JList;
  AProcess: JActivityManager_RunningAppProcessInfo;
  AName: JString;
  AIterator: JIterator;
begin
AList := SharedActivityManager.getRunningAppProcesses;
AName := SharedActivityContext.getPackageName;
Result := False;
if Assigned(AList) then
  begin
  AIterator := AList.iterator;
  while AIterator.hasNext do
    begin
    AProcess := TJActivityManager_RunningAppProcessInfo.Wrap
      ((AIterator.next as ILocalObject).GetObjectID);
    if AProcess.processName.equals(AName) then
      begin
      if AProcess.importance = TJActivityManager_RunningAppProcessInfo.
        JavaClass.IMPORTANCE_FOREGROUND then
        begin
        Result := True;
        Break;
        end;
      end;
    end;
  end;
end;
// ����
procedure TForm1.btnRebootClick(Sender: TObject);
begin
if RootNeeded then
  FRootShell.Execute('reboot');
end;
// �ػ�
procedure TForm1.btnShutdownClick(Sender: TObject);
begin
if not Assigned(Form2) then
  Form2 := TForm2.Create(Application);
Form2.Show;
end;
// ��ȡ Root Ȩ��ʧ��ʱ�����Ĵ�����ʾ
procedure TForm1.DoRootDeny(AJob: PQJob);
begin
Form3 := TForm3.Create(Application);
Form3.Show;
end;
// �ػ�����ʱ������1������ʾΪ���ӣ�С��1������ʾ������ʱ�䵽��ػ�
procedure TForm1.DoShutdownCounter(AJob: PQJob);
var
  ARemain: Int64;
begin
ARemain := FShutdownTime - GetTimeStamp;
if ARemain <= Q1Minute then
  begin
  if not IsAppActive then
    begin
    BringAppToFront;
    Workers.Post(
      procedure(AJob: PQJob)
      begin
      Workers.ClearSingleJob(FTimerHandle);
      FTimerHandle := Workers.Post(DoShutdownCounter, Q1Second, nil, True);
      end, nil, False);
    end;
  btnCancel.Text := 'ȡ���ػ�(���� ' + RollupTime(ARemain div Q1Second) + ' �ػ�)';
  if ARemain <= 0 then
    begin
    if RootNeeded then
      FRootShell.Execute('reboot -p');
    end;
  end
else
  btnCancel.Text := 'ȡ���ػ�(���� ' + RollupTime((ARemain div Q1Minute) *
    60) + ' �ػ�)';
end;
// ȡ���ػ�����
procedure TForm1.btnCancelClick(Sender: TObject);
begin
Workers.ClearSingleJob(FTimerHandle);
FTimerHandle := 0;
btnCancel.Text := 'ȡ���ػ�';
btnCancel.Enabled := False;
end;
// ���캯��
procedure TForm1.FormCreate(Sender: TObject);
begin
FRootShell.Initliaize;
RegisterKeyMapping(23,vkReturn,TKeyKind.Functional);
end;
// ��ӦӲ����������Ҫ��Ҫ�ṩ�Ժ���ң������֧��
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
Shift: TShiftState);
var
  AEvent: TNotifyEvent;
begin
btnCancel.Text:='KeyCode='+IntToStr(Key);
case Key of
  vkUp, vkLeft, vkVolumeUp:
    begin
    if ActiveControl = btnReboot then
      begin
      if btnCancel.Enabled then
        ActiveControl := btnCancel
      else
        ActiveControl := btnShutdown;
      end
    else if ActiveControl = btnShutdown then
      ActiveControl := btnReboot
    else if ActiveControl = btnCancel then
      ActiveControl := btnShutdown
    else if btnCancel.Enabled then
      ActiveControl := btnCancel
    else
      ActiveControl := btnShutdown;
    Key := 0;
    end;
  vkDown, vkRight, vkVolumeDown:
    begin
    if ActiveControl = btnReboot then
      ActiveControl := btnShutdown
    else if ActiveControl = btnShutdown then
      begin
      if btnCancel.Enabled then
        ActiveControl := btnCancel
      else
        ActiveControl := btnReboot;
      end
    else if ActiveControl = btnCancel then
      ActiveControl := btnReboot
    else
      ActiveControl := btnShutdown;
    Key := 0;
    end;
  vkReturn:
    begin
    AEvent := (Focused.GetObject as TControl).OnClick;
    if Assigned(AEvent) then
      AEvent(Self);
    Key := 0;
    Exit;
    end;
  vkHardwareBack://���ؼ�ʱ�������ǰ�Ѿ��ƻ��ػ����򷵻����棬����Ӧ���˳�
    begin
    if FTimerHandle<>0 then
      SendAppToBack
    else
      Application.Terminate;
    Key := 0;
    end;
end;
if Assigned(ActiveControl) then
  GlowEffect1.Parent := ActiveControl;
end;
// �ƻ��ػ�
procedure TForm1.PendShutdown(AMinutes: Integer);
begin
if AMinutes = 0 then
  begin
  Form1.RootShell.Execute('reboot -p ');
  end
else
  begin
  FShutdownTime := GetTimeStamp + AMinutes * Q1Minute;
  FTimerHandle := Workers.Post(DoShutdownCounter, Q1Minute, nil, True);
  btnCancel.Text := 'ȡ���ػ�(���� ' + RollupTime(AMinutes * 60) + ' �ػ�)';
  btnCancel.Enabled := True;
  SendAppToBack;
  end;
end;
// ��� Root Ȩ��
function TForm1.RootNeeded: Boolean;
begin
Result := FRootShell.AskForRoot;
if not Result then
  Workers.Post(DoRootDeny, nil, True);
end;

end.

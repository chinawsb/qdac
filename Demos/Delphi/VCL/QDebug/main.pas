unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, qmapsymbols;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses qstring, qrbtree, syncobjs;
{$R *.dfm}

type
  TDeadLockThread = class(TThread)
  protected
    FCS1, FCS2: TCriticalSection;
    procedure Execute; override;
  end;

var
  CS1, CS2: TCriticalSection;

procedure TForm4.Button1Click(Sender: TObject);
var
  AEvent: TNotifyEvent;
  T1, T2: Cardinal;
  ALocate: TQSymbolLocation;
  I: Integer;
begin
AEvent := Button1Click;
T1 := GetTickCount;
Symbols.LoadSymbols;
T2 := GetTickCount;
T1 := T2 - T1;
for I := 0 to 999999 do
  Symbols.Locate(TMethod(AEvent).Code, ALocate);
T2 := GetTickCount - T2;
ShowMessage('������ʱ:' + IntToStr(T1) + 'ms'#13#10 + '��ѯ��ʱ(100���)��' + IntToStr(T2)
  + 'ms(ƽ��:' + FloatToStr(T2 / 1000000) + 'ms/��)'#13#10 + '��ַ:' +
  IntToHex(NativeInt(ALocate.Addr), SizeOf(NativeInt) shl 1) + #13#10 + '�����ռ�:'
  + ALocate.UnitName + #13#10'�ļ���:' + ALocate.FileName + #13#10'����:' +
  ALocate.FunctionName + #13#10 + '�к�:' + IntToStr(ALocate.LineNo));
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
ShowMessage(StackByThreadId(GetCurrentThreadId));
end;

procedure TForm4.Button3Click(Sender: TObject);
var
  AThread1, AThread2: TDeadLockThread;
  ACode: DWord;
begin
if Application.MessageBox('�⽫��ʾһ�������ȴ����Ƿ������', '����', MB_YESNO OR MB_ICONQUESTION)
  = IDYES then
  begin
  CS1 := TCriticalSection.Create;
  CS2 := TCriticalSection.Create;
  // �����߳��Ƚ���
  CS1.Enter;
  CS2.Enter;
  AThread1 := TDeadLockThread.Create(True);
  AThread1.FCS1 := CS1;
  AThread1.FCS2 := CS2;
  AThread1.Suspended := False;
  AThread2 := TDeadLockThread.Create(True);
  AThread2.FCS1 := CS2;
  AThread2.FCS2 := CS1;
  AThread2.Suspended := False;
  CS1.Leave;
  CS2.Leave;
  Sleep(100);
  ShowMessage(EnumWaitChains);
  ACode := 0;
  TerminateThread(AThread1.Handle, ACode);
  TerminateThread(AThread2.Handle, ACode);
  FreeObject(AThread1);
  FreeObject(AThread2);
  FreeObject(CS1);
  FreeObject(CS2);
  end;
end;

procedure TForm4.Button4Click(Sender: TObject);
var
  AThread1, AThread2: TDeadLockThread;
  ACode: DWord;
begin
if Application.MessageBox('�⽫��ʾһ���̼߳��������⽫���ڳ���Ŀ¼������һ��deadlock.log��¼������ͻ���Ƿ������',
  '��ʾ', MB_YESNO OR MB_ICONQUESTION) = IDYES then
  begin
  EnableDeadLockCheck;
  CS1 := TCriticalSection.Create;
  CS2 := TCriticalSection.Create;
  // �����߳��Ƚ���
  CS1.Enter;
  CS2.Enter;
  AThread1 := TDeadLockThread.Create(True);
  AThread1.FCS1 := CS1;
  AThread1.FCS2 := CS2;
  AThread1.Suspended := False;
  AThread2 := TDeadLockThread.Create(True);
  AThread2.FCS1 := CS2;
  AThread2.FCS2 := CS1;
  AThread2.Suspended := False;
  CS1.Leave;
  CS2.Leave;
  Sleep(6000);
  ACode := 0;
  TerminateThread(AThread1.Handle, ACode);
  TerminateThread(AThread2.Handle, ACode);
  FreeObject(AThread1);
  FreeObject(AThread2);
  FreeObject(CS1);
  FreeObject(CS2);
  end;
end;

{ TDeadLockThread }

procedure TDeadLockThread.Execute;
begin
inherited;
FCS1.Enter; // This will be blocked
Sleep(10);
FCS2.Enter;
end;

end.

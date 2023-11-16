unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox;

type
  TForm1 = class(TForm)
    btnShortlog: TButton;
    btnLongLog: TButton;
    btnLoopLog: TButton;
    Label1: TLabel;
    cbxLogLevel: TComboBox;
    Label2: TLabel;
    chkMode: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnShortlogClick(Sender: TObject);
    procedure btnLongLogClick(Sender: TObject);
    procedure btnLoopLogClick(Sender: TObject);
    procedure chkModeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qstring, qlog,qcndate,ioutils{$IFDEF MSWINDOWS}, windows{$ENDIF}{$IFDEF ANDROID},
  Androidapi.ioutils{$ENDIF};
{$R *.fmx}

procedure TForm1.btnShortlogClick(Sender: TObject);
begin
  PostLog(TQLogLevel(cbxLogLevel.ItemIndex), '����һ�������־.');
end;

procedure TForm1.btnLongLogClick(Sender: TObject);
begin
  PostLog(TQLogLevel(cbxLogLevel.ItemIndex),
    '����һ���ܳ���������־��Ŀ���ǳ���syslogԼ����1024���ַ������ơ�' +
    '��ǰ����ɽ��ɽ�������������Ϻ����ڸ�С�������ʫ����ʫ�����ݰ�����'#13#10 +
    '������� ������ ����ӯ� �������� �������� ���ն���'#13#10 +
    '���ų��� �������� �������� ¶��Ϊ˪ ������ˮ �������'#13#10 +
    '���ž��� ���ҹ�� �������� ���ؽ潪 ���̺ӵ� ��Ǳ����'#13#10 +
    '��ʦ��� ����˻� ʼ������ �˷����� ��λ�ù� ��������'#13#10 +
    '������ �ܷ����� �����ʵ� ����ƽ�� �������� ������Ǽ'#13#10 +
    '����һ�� �ʱ����� �������� �׾�ʳ�� ������ľ ������'#13#10 +
    '�Ǵ��� �Ĵ��峣 ��Ω���� ��һ��� ŮĽ��� ��Ч����'#13#10 +
    '֪���ظ� ����Ī�� ��̸�˶� ���Ѽ��� ��ʹ�ɸ� ��������'#13#10 +
    'ī��˿Ⱦ ʫ�޸��� ����ά�� ������ʥ �½����� �ζ˱���'#13#10 +
    '�չȴ��� ����ϰ�� ������ ��Ե���� ��起Ǳ� �����Ǿ�'#13#10 +
    '�ʸ��¾� Ի���뾴 Т������ ������ �����ı� �����¢�'#13#10 +
    '����˹ܰ ����֮ʢ ������Ϣ Ԩ��ȡӳ ��ֹ��˼ �Դǰ���'#13#10 +
    '�Ƴ����� �������� ��ҵ���� �����޾� ѧ�ŵ��� ��ְ����'#13#10 +
    '���Ը��� ȥ����ӽ ������ ����� �Ϻ����� �򳪸���'#13#10 +
    '���ܸ�ѵ ���ĸ�� ��ò��� ���ӱȶ� �׻��ֵ� ͬ����֦'#13#10 +
    '����Ͷ�� ��ĥ��� �ʴ����� ��θ��� �������� ����˿�'#13#10 +
    '�Ծ����� �Ķ���ƣ ����־�� �������� ����Ų� �þ�����'#13#10 +
    '���ػ��� �������� �������� ��μ���� �������� ¥�۷ɾ�'#13#10 +
    'ͼд���� �������� ������� ���ʶ�� ������ϯ ��ɪ����'#13#10 +
    '�����ɱ� ��ת���� ��ͨ���� ������ �ȼ��ص� ���ȺӢ'#13#10 +
    '�Ÿ����� ����ھ� ���޽��� ·������ ������� �Ҹ�ǧ��'#13#10 +
    '�߹����� �����ӧ ��»�޸� ���ݷ��� �߹�ïʵ �ձ�����'#13#10 +
    '��Ϫ���� ��ʱ���� ��լ���� ΢����Ӫ ������� ��������'#13#10 +
    '粻غ��� ˵���䶡 �������� ��ʿ���� �������� ��κ����'#13#10 +
    '��;��� �������� ����Լ�� ���׷��� �������� �þ��'#13#10 +
    '����ɳĮ �������� ������ �ٿ��ز� ����̩� ������ͤ'#13#10 +
    '�������� ������ ������ʯ ��Ұ��ͥ ��Զ���� �����ڤ'#13#10 +
    '�α���ũ ���ʼ�� ������Ķ ������� ˰�칱�� Ȱ������'#13#10 +
    '������� ʷ���ֱ ������ӹ ��ǫ��� �������� ��ò��ɫ'#13#10 +
    '���ʼ��� ������ֲ ʡ������ �������� ������� �ָ��Ҽ�'#13#10 +
    '������� ����˭�� �����д� ��Ĭ���� ���Ѱ�� ɢ����ң'#13#10 +
    '������ǲ ��л���� ���ɵ��� ԰ç���� ������� ��ͩ���'#13#10 +
    '�¸�ί�� ��ҶƮҡ �΢޶��� ��Ħ��� �������� ԢĿ����'#13#10 +
    '�ע���η ����ԫǽ ���Ųͷ� �ʿڳ䳦 �������� �����㿷'#13#10 +
    '���ݹʾ� �������� ������� �̽�ᡷ� ����Բ�� ����쿻�'#13#10 +
    '����Ϧ�� ������ �Ҹ���� �ӱ����� ���ֶ��� ��ԥ�ҿ�'#13#10 +
    '�պ����� ����᳢ ����ٰ� 㤾�ֻ� ��뺼�Ҫ �˴�����'#13#10 +
    '������ԡ ִ��Ը�� ¿�⶿�� ��Ծ���� ��ն���� ��������'#13#10 +
    '�������� ������Х �����ֽ �����ε� �ͷ����� ��Լ���'#13#10 +
    'ëʩ���� �����Ц ��ʸÿ�� �������� ������� ���ǻ���'#13#10 +
    'ָн���� ���缪ۿ �ز����� �������� ������ׯ �ǻ�հ��'#13#10 + '��ª���� ���ɵ�ڽ ν������ ���պ�Ҳ');
end;

procedure TForm1.btnLoopLogClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 999 do
    btnLongLogClick(Sender);
  ShowMessage('��־Ͷ����ɡ�');
end;

procedure TForm1.chkModeChange(Sender: TObject);
begin
  if chkMode.IsChecked then
    Logs.Mode := lmAsyn
  else
    Logs.Mode := lmSync;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  AWriter: TQLogSocketWriter;
begin
{$IFNDEF MSWINDOWS}
  AWriter := TQLogSocketWriter.Create;
  AWriter.ServerHost := '192.168.0.2';
  AWriter.ServerPort := 514;
  // ���Ҫʹ��TCPЭ�飬��ô�������������ΪTrue���ɣ���QLogServerĿǰ��֧��TCPЭ��
  // ����TCPЭ��һ�������������ߣ����ܻ���ɲ���Ҫ����־��ѹ
  // AWriter.UseTcp:=True;
  Logs.Castor.AddWriter(AWriter);
{$IFDEF ANDROID}
  Logs.Castor.AddWriter(TQLogFileWriter.Create(GetExtSDDir + 'qlogdemo.log'));
  Label1.Text := '����SDCardĿ¼Ϊ��' + GetExtSDDir;
{$ENDIF}
{$ELSE}
  SetDefaultLogFile;
{$ENDIF}
  // �����־������̨
  Logs.Castor.AddWriter(TQLogConsoleWriter.Create);
  // �����־���ļ�
//  SetDefaultLogFile({$IFDEF ANDROID}GetExtSDDir + '/' + Application.Title +
//    '.log'{$ELSE}''{$ENDIF}, 2 * 1024 * 1024, false);
  PostLog(llHint, 'Application Started.');
  ReportMemoryLeaksOnShutdown := True;
end;

end.

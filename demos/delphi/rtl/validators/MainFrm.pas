unit MainFrm;

interface

uses
  winapi.Windows,
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
  Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  qdac.validator; // validator��Ԫ�еĺ�������

procedure TMainForm.Button1Click(Sender: TObject);
begin
  // ʹ��Custom������ֵ
  TQValidators.Custom<UnicodeString>('ipv4').Check('1.2.4.8');
  try
    // û������Ĭ��У�飬�����׳��쳣
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Failed');
  except
    OutputDebugString('Pass');
  end;
  // ���� UnicodeString ���͵�Ĭ��У��
  TQValidators.SetDefaultValidator<UnicodeString>(TQValidators.Length<UnicodeString>);
  try
    // �Ҳ���ʱ������Ĭ�ϼ���
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Pass');
  except
    OutputDebugString('Failed');
  end;

  // ʹ����������У��ֵ
  TQValidators.ChineseId.Check('371100197711110719');
  TQValidators.ChineseMobile.Check('17788653263');
  TQValidators.Email.Check('"abc.kkk"@K.com.');
  TQValidators.Length<UnicodeString>.CheckEx('123456', 6, 16, '���ȱ������ [MinSize] �� [MaxSize] ֮��');
  var AData: TBytes;
  SetLength(AData, 4);
  TQValidators.Length<TBytes>.CheckEx(AData, 8, 20);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  // �ж��Ƿ�Ϊ���䣬ʧ�����׳��쳣����ڱ༭��
  try
    TQValidators.Email.Check('"abc.kkk"K.c1m.��');
  except
    Memo1.Lines.Add('Except Caught 001!');
  end;
end;

end.


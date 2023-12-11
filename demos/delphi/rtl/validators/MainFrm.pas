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
  qdac.validator; // validator单元中的函数测试

procedure TMainForm.Button1Click(Sender: TObject);
begin
  // 使用Custom来检验值
  TQValidators.Custom<UnicodeString>('ipv4').Check('1.2.4.8');
  try
    // 没有设置默认校验，所以抛出异常
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Failed');
  except
    OutputDebugString('Pass');
  end;
  // 设置 UnicodeString 类型的默认校验
  TQValidators.SetDefaultValidator<UnicodeString>(TQValidators.Length<UnicodeString>);
  try
    // 找不到时，会走默认检验
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Pass');
  except
    OutputDebugString('Failed');
  end;

  // 使用内置属性校验值
  TQValidators.ChineseId.Check('371100197711110719');
  TQValidators.ChineseMobile.Check('17788653263');
  TQValidators.Email.Check('"abc.kkk"@K.com.');
  TQValidators.Length<UnicodeString>.CheckEx('123456', 6, 16, '长度必需介于 [MinSize] 到 [MaxSize] 之间');
  var AData: TBytes;
  SetLength(AData, 4);
  TQValidators.Length<TBytes>.CheckEx(AData, 8, 20);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  // 判断是否为邮箱，失败则抛出异常输出在编辑框
  try
    TQValidators.Email.Check('"abc.kkk"K.c1m.啊');
  except
    Memo1.Lines.Add('Except Caught 001!');
  end;
end;

end.


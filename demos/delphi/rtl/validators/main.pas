unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,qdac.validator;

type
  TForm4 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormCreate(Sender: TObject);
begin
  //使用Custom来检验值
  TQValidators.Custom<UnicodeString>('ipv4').Check('1.2.4.8');
  try
    //没有设置默认校验，所以抛出异常
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Failed');
  except
    OutputDebugString('Pass');
  end;
  //设置 UnicodeString 类型的默认校验
  TQValidators.SetDefaultValidator<UnicodeString>(TQValidators.Length<UnicodeString>);
  try
    //找不到时，会走默认检验
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Pass');
  except
    OutputDebugString('Failed');
  end;

  //使用内置属性校验值
  TQValidators.ChineseId.Check('371100197711110719');
  TQValidators.ChineseMobile.Check('17788653263');
  TQValidators.Email.Check('"abc.kkk"@K.com.');
  TQValidators.Length<UnicodeString>.CheckEx('123456',6,16,'长度必需介于 [MinSize] 到 [MaxSize] 之间');
  var
    AData:TBytes;
    SetLength(AData,4);
  TQValidators.Length<TBytes>.CheckEx(AData,8,20);
end;

end.

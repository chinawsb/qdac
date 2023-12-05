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
  //ʹ��Custom������ֵ
  TQValidators.Custom<UnicodeString>('ipv4').Check('1.2.4.8');
  try
    //û������Ĭ��У�飬�����׳��쳣
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Failed');
  except
    OutputDebugString('Pass');
  end;
  //���� UnicodeString ���͵�Ĭ��У��
  TQValidators.SetDefaultValidator<UnicodeString>(TQValidators.Length<UnicodeString>);
  try
    //�Ҳ���ʱ������Ĭ�ϼ���
    TQValidators.Custom<UnicodeString>('NotExists').Check('11111');
    OutputDebugString('Pass');
  except
    OutputDebugString('Failed');
  end;

  //ʹ����������У��ֵ
  TQValidators.ChineseId.Check('371100197711110719');
  TQValidators.ChineseMobile.Check('17788653263');
  TQValidators.Email.Check('"abc.kkk"@K.com.');
  TQValidators.Length<UnicodeString>.CheckEx('123456',6,16,'���ȱ������ [MinSize] �� [MaxSize] ֮��');
  var
    AData:TBytes;
    SetLength(AData,4);
  TQValidators.Length<TBytes>.CheckEx(AData,8,20);
end;

end.

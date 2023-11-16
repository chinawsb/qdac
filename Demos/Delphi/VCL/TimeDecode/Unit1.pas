unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qstring;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
  procedure DoTest(S, AFormat: String);
  begin
    if Length(AFormat) = 0 then
      Memo1.Lines.Add(S + SLineBreak+'    �Զ�ʶ�� => ' +
        FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', DateTimeFromString(S,
        AFormat))+SLineBreak)
    else
      Memo1.Lines.Add(S + SLineBreak+'    '+AFormat+' => ' +
        FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', DateTimeFromString(S,
        AFormat))+SLineBreak);
  end;

begin
  DoTest('2017-3-5T6:12:34.879', 'yyyy-m-d"T"h:n:s.z');
  DoTest('2017-3-5T6:12:34.879', '');
  DoTest('20170305061234879', '');
  DoTest('20170305', '');
  DoTest('061234879', '');
  DoTest('20170305061234', '');
  DoTest('2017-3-5 6:12:34.879', '');
  DoTest('17-3-5 6:12:34.879', '');
  DoTest('17-3-5', '');
  DoTest('31/5/2018', '');
  DoTest('5/31/2018', '');
  DoTest('2018/01/02 11:22:25.111', '');
  DoTest('2018��1��2�� 11��22��25��', 'y��m��d�� h��n��s��');
  DoTest('Fri, 13 Apr 2018 14:29:59 GMT', '');
  DoTest('13-Apr-2018 14:29:59 GMT+08:00', '');
  Memo1.Lines.Add('������Զ�ʶ���޷���ȷ���֣���Ҫ�ֶ�ָ����ʽ');
  DoTest('12/10/1998', '');
  DoTest('12/10/1998', 'm/d/y');
  DoTest('12/10/1998', 'd/m/y');
end;

end.

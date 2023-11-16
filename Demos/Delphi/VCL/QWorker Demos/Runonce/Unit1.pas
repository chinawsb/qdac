unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses qworker;
{$R *.dfm}
var
  //��ʼ��ȫ�ֿ��Ʊ�����CanRun �����ʼ��Ϊ1
  runonce:TQRunonceTask=(CanRun:1);
//�ص�����������ȫ�ֺ�������Ա��������������
procedure DoRunonce;
begin
  ShowMessage('Run once only,not run on your next click');
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
{$IFDEF UNICODE}
runonce.Runonce(
  procedure
  begin
  ShowMessage('Run once only,not run on your next click');
  end);
{$ELSE}
runonce.Runonce(DoRunonce);
{$ENDIF}
end;

end.

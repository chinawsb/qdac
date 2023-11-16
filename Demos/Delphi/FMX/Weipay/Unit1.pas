unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses qsdk.wechat,qsdk.alipay;
{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
WechatService.AppId:='wx88888888';
WechatService.MchId:='174672727';
end;

end.

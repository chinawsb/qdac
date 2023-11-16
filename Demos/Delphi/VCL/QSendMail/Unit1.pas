unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    edtSmtpServer: TEdit;
    Label2: TLabel;
    edtSmtpUser: TEdit;
    edtSmtpPass: TEdit;
    Label3: TLabel;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Label4: TLabel;
    edtSubject: TEdit;
    Label5: TLabel;
    edtTarget: TEdit;
    Label6: TLabel;
    CheckBox2: TCheckBox;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qsendmail;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  AMailSender: TQMailSender;
  AResult: Boolean;
begin
  AMailSender := TQMailSender.Create(edtSmtpServer.Text, edtSmtpUser.Text,
    edtSmtpPass.Text);
  AMailSender.Subject := edtSubject.Text;
  AMailSender.RecipientMail := edtTarget.Text;
  AMailSender.Body := Memo1.Text;
  if CheckBox2.Checked then
    AMailSender.Body := AMailSender.Body +
      EncodeMailImage(Image1.Picture.Graphic);
  if CheckBox1.Checked then
    AResult := AMailSender.SendBySSL
  else
    AResult := AMailSender.Send;
  if not AResult then
    ShowMessage(AMailSender.LastError);
end;

end.

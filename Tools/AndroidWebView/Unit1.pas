unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, QWorker, Androidapi.JNI.JavaTypes, Androidapi.JNIBridge,
  syncobjs, QString,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Rtti, FMX.WebBrowser.Android,
  Androidapi.JNI.Webkit, Androidapi.JNI.Embarcadero, Androidapi.Helpers,
  FMX.Helpers.Android;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
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
  Form1: TForm1;

implementation

uses qandroid_webbrowser;
{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  V: String;
begin
  V := WebBrowser1.Eval('1+1;');
  ShowMessage(VarToStr(V));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DebugOut('@@@@From Standard Error@@@@', []);
end;

end.

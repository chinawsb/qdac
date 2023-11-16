unit vcl.form.share;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, vcl.Graphics,
  vcl.Controls, vcl.Forms, vcl.Dialogs, vcl.StdCtrls, QString, QPlugins,
  qplugins_params, qplugins_formsvc, QPlugins_vcl_formsvc, vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Shape1: TShape;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  AService: IQService;
  S: String;
  function AttrText: String;
  var
    I: Integer;
    AParam: IQParam;
  begin
    Result := '';
    for I := 0 to AService.Attrs.Count - 1 do
    begin
      AParam := AService.Attrs[I];
      Result := Result + AParam.Name + '=' + ParamAsString(AParam) + SLineBreak;
    end;
  end;

begin
  AService := FindFormService(Self) as IQService;
  if Assigned(AService) then
  begin
    S := ServicePath(AService);
    if AService.Attrs.Count > 0 then
      S := S + '����' + SLineBreak + AttrText
    else
      S := S + '����:��';
    AService := AService.Creator;
    if Assigned(AService) then
      S := S + SLineBreak + '�̳���ʵ�������ߣ�' + SLineBreak + AttrText;
    ShowMessage(S);
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  Label2.Caption := 'ʵ������ʱ�䣺' + FormatDateTime('hh:nn:ss', Now);
end;

initialization

// ע��һ����ʵ���Ĵ�������������ʼ�վ����ж���
RegisterFormService('/Services/Docks/Forms', 'DLL_Shared', TForm3, False).Align
  := faRightCenter;
// ע��һ����ʵ���Ĵ������
RegisterFormService('/Services/Docks/Forms', 'DLL_MutiInstance', TForm3, True);

finalization

UnregisterServices('/Services/Docks/Forms', ['DLL_Shared', 'DLL_MutiInstance']);

end.

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    mmo1: TMemo;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
 uses qjson;
{$R *.dfm}
type
  // ������Ϣ
  // 0:��; 1:�ǼǷ���,2:ע���Ǽǣ�3:��¼��4:�ǳ�;5:��ʱ;6:�����7:���񴥷�
  TSend_Type = (stNone, stRegister, stUnRegister, stLogin, stLogout, stTimer,
    stInterval, stService);
  // ��Ϣ����
  TMsg_Type = (mtInnerSys, mtInnerUser, mtSvcSys, mtSvcUser);
TAppMsg = record
    Sess_Id: string; // ��¼sessID������Ҫʱ��Ÿ�ֵ
    Sess_Ids:string;// ���sessionID������Ͷ���̣߳�����ѭ��������߳�
    ID: string; // ��ϢΨһID
    Sender_ID: string; // ������ID
    Sender_Name: string; // ����������
    Groups: string; // ��Ϣ��������
    Title: string; // ��Ϣ����
    Msg_Info: string; // ��Ϣ��Ϣ
    Msg_Type: TMsg_Type; // ��Ϣ����
    Send_Type: TSend_Type; // ��������
    SEND_START_TIME: TTime; // ������ʼ�ͽ�ֹʱ��
    SEND_End_TIME: TTime; // ������ʼ�ͽ�ֹʱ��
    Weeks: Integer; // ��1����2����������7��ȫѡ Ϊ 127����ѡ��Ϊ0
    Timers: string; // JSON�ַ���
    Timers_Delay: Integer; // ��ʱ�ӳ�
    Create_Time: TDateTime;
    Start_Time: TDateTime; // ��Ч��ʼʱ��
    End_Time: TDateTime; // ��Ч��ֹʱ��
    Using: Boolean; // ʹ��
end;

  TReadOnlyTest=class
  private
    FValue: Integer;
  published
  property Value:Integer {read FValue;} write FValue;
  end;
procedure TForm1.btn1Click(Sender: TObject);
var
  json:TQJson;
  AppMsg:TAppMsg;
  ATest:TReadOnlyTest;
begin
  ATest:=TReadOnlyTest.Create;
  json:=TQJson.Create;
  ATest.FValue:=100;
  json.FromRtti(ATest);
  json.ToRtti(ATest);
//  json.Parse(mmo1.Text);
//  json.ToRecord<TAppMsg>(AppMsg);
//  ShowMessage(AppMsg.Msg_Info);
  json.Free;


end;

end.

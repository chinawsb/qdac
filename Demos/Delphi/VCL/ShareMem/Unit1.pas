unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.SyncObjs, QString,
  qsocket_sharemem,
  Vcl.StdCtrls;

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

uses QWorker;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  AServer, AClient: TQShareMemConnection;
  AGroup: TQJobGroup;
begin
  // ����һ�������ڴ�Ŀͻ�/�����
  AServer := TQShareMemConnection.Create;
  AClient := TQShareMemConnection.Create;
  // �趨���ص�ַ�����ӵ��Է��ı��ص�ַ
  AServer.ConnectTo(AClient.LocalAddr);
  AClient.ConnectTo(AServer.LocalAddr);
  // ��ҵ���������߳���ִ�У�һ������д�룬һ�������ȡ��������ݽ���
  AGroup := TQJobGroup.Create(False);
  AGroup.Prepare;
  // ����������ҵд������
  AGroup.Add(
    procedure(AJob: PQJob)
    var
      AStream: TMemoryStream;
      AConnection: TQShareMemConnection;
    begin
      AConnection := AJob.Data;
      AStream := TMemoryStream.Create;
      AStream.LoadFromFile('C:\Windows\comsetup.log');
      AConnection.WriteStream.WriteData(AStream.Size);
      AConnection.WriteStream.CopyFrom(AStream, 0);
      FreeAndNil(AStream);
    end, AServer);
  // �ͻ�����ҵ��ȡ����
  AGroup.Add(
    procedure(AJob: PQJob)
    var
      AStream: TMemoryStream;
      ASize: Int64;
      AConnection: TQShareMemConnection;
    begin
      Sleep(0);
      AConnection := AJob.Data;
      AStream := TMemoryStream.Create;
      if AConnection.WaitForData(10000) = wrSignaled then
      begin
        if AConnection.ReadStream.ReadData(ASize) = SizeOf(ASize) then
        begin
          while AStream.Size < ASize do
          begin
            if AConnection.WaitForData(1000) = wrSignaled then
              AStream.CopyFrom(AConnection.ReadStream, 0)
            else//����ȴ�1�뻹û�������ݽ��룬���˳�
              break;
          end;
        end;
      end;
      AStream.Position := 0;
      RunInMainThread(
        procedure
        begin
          Memo1.Text := LoadTextW(AStream);
        end);
      FreeAndNil(AStream);
    end, AClient);
  AGroup.Run();
  AGroup.MsgWaitFor();
  FreeAndNil(AClient);
  FreeAndNil(AServer);
end;

end.

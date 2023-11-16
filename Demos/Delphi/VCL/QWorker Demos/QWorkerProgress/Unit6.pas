unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Types,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, QWorker,
  Vcl.Samples.Gauges;

{
  ��ʾ����ʾ�������QWorker�к�̨��ҵ�����Ԫ�ؽ��н����Ļ�����������Ȼ�ⲻ��Ψһ
  �ķ���������ש��������ҪĿ�ġ�
  1����ʾ����ʾ��һ��������ҵ��
  ��1�����ֱ����8��TStringList���󣬲���ʾ�����ȡ�
  ��2�����ϲ�8��TStringList�Ľ�㵽��һ��TStringList
  ��3�����ں�̨�߳��б����ϲ����TStringList��������ָ���ض����ַ� A ���ֵĴ�����
  2����ʾ���У�ʹ����QMsgPack����Ϊ���Ӳ������ݵķ�ʽ����Ҳֻ��һ����ʾ���ѡ�
}
type
  TForm6 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Button1: TButton;
    Label9: TLabel;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Gauge3: TGauge;
    Gauge4: TGauge;
    Gauge5: TGauge;
    Gauge6: TGauge;
    Gauge7: TGauge;
    Gauge8: TGauge;
    Gauge9: TGauge;
    Label10: TLabel;
    Gauge10: TGauge;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FRepeatTimes: Integer;
    procedure DoCreateListData(AJob: PQJob);
    procedure DoFillListData(ALoopMgr: TQForJobs; AJob: PQJob;
      AIndex: NativeInt);
    procedure DoUpdateProgress(AJob: PQJob);
    procedure DoMergeListData(AJob: PQJob);
    procedure DoSearchChar(AJob: PQJob); overload;
    procedure DoSearchChar(ALoopMgr: TQForJobs; AJob: PQJob;
      AIndex: NativeInt); overload;
    procedure NotifyProgress(AIndex, AProgress: Integer);
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses qmsgpack, qstring;
{$R *.dfm}

const
  PerListCount = 1000000;
  MergedCount = 8000000;

type
  TStringListArray = array of TStringList;
  PStringListArray = ^TStringListArray;

procedure TForm6.Button1Click(Sender: TObject);
var
  AGroup: TQJobGroup;
  ALists: TStringListArray;
  I: Integer;
begin
  Gauge1.Progress := 0;
  Gauge2.Progress := 0;
  Gauge3.Progress := 0;
  Gauge4.Progress := 0;
  Gauge5.Progress := 0;
  Gauge6.Progress := 0;
  Gauge7.Progress := 0;
  Gauge8.Progress := 0;
  Gauge9.Progress := 0;
  Button1.Enabled := False;
  SetLength(ALists, 8);
  AGroup := TQJobGroup.Create(True);
  AGroup.Prepare;
  for I := 0 to 7 do
    ALists[I] := TStringList.Create;
  AGroup.Add(DoCreateListData, @ALists, False);
  AGroup.Add(DoMergeListData, @ALists, False);
  AGroup.Add(DoSearchChar, ALists[0], False);
  AGroup.Run();
  AGroup.MsgWaitFor();

  Gauge10.Progress := 100;
  FreeAndNil(AGroup);
  for I := 0 to 7 do
    FreeAndNil(ALists[I]);
  ShowMessage('�ַ� A �ظ�����Ϊ��' + IntToStr(FRepeatTimes));
  Button1.Enabled := True;
end;

procedure TForm6.DoCreateListData(AJob: PQJob);
begin
  Workers.&For(0, 7, DoFillListData, False, AJob.Data);
end;

procedure TForm6.DoFillListData(ALoopMgr: TQForJobs; AJob: PQJob;
  AIndex: NativeInt);
var
  AList: TStringList;
  I: Integer;
  T: Cardinal;
  function RandomString: String;
  var
    C: Integer;
    p: PChar;
  begin
    C := 1 + random(100);
    SetLength(Result, C);
    p := PChar(Result);
    while C > 0 do
    begin
      p^ := WideChar(Ord('A') + random(32));
      Inc(p);
      Dec(C);
    end;
  end;

begin
  AList := PStringListArray(AJob.Data)^[AIndex];
  AList.Capacity := PerListCount; // 1���
  T := GetTickCount;
  for I := 0 to PerListCount - 1 do
  begin
    AList.Add(RandomString);
    if GetTickCount - T > 50 then // ÿ50ms���½���һ��
    begin
      T := GetTickCount;
      NotifyProgress(AIndex, (I + 1) * 100 div PerListCount);
    end;
  end;
  NotifyProgress(AIndex, 100);
end;

procedure TForm6.DoMergeListData(AJob: PQJob);
var
  I: Integer;
  ALists: PStringListArray;
begin
  ALists := AJob.Data;
  ALists^[0].Capacity := MergedCount;
  for I := 1 to 7 do
  begin
    ALists^[0].AddStrings(ALists^[I]);
    NotifyProgress(8, I * 100 div 7);
  end;
  // ��Ϊ���˳����ҵִ��ʱ��û�б���߳�д������������Գ�ʼ�����ǰ�ȫ��
  FRepeatTimes := 0;
end;

procedure TForm6.DoSearchChar(AJob: PQJob);
begin
  Workers.&For(0, MergedCount - 1, DoSearchChar, False, AJob.Data);
end;

procedure TForm6.DoSearchChar(ALoopMgr: TQForJobs; AJob: PQJob;
  AIndex: NativeInt);
var
  S: String;
  p: PChar;
begin
  S := TStringList(AJob.Data).Strings[AIndex];
  p := PChar(S);
  while p^ <> #0 do
  begin
    if p^ = 'A' then
      AtomicIncrement(FRepeatTimes);
    Inc(p);
  end;
  if (AIndex mod 10000) = 0 then
    NotifyProgress(9, AIndex * 100 div MergedCount);
end;

procedure TForm6.DoUpdateProgress(AJob: PQJob);
var
  AMsgPack: TQMsgPack;
begin
  AMsgPack := AJob.Data;
  case AMsgPack.IntByName('Index', -1) of
    0:
      Gauge1.Progress := AMsgPack.IntByName('Progress', 0);
    1:
      Gauge2.Progress := AMsgPack.IntByName('Progress', 0);
    2:
      Gauge3.Progress := AMsgPack.IntByName('Progress', 0);
    3:
      Gauge4.Progress := AMsgPack.IntByName('Progress', 0);
    4:
      Gauge5.Progress := AMsgPack.IntByName('Progress', 0);
    5:
      Gauge6.Progress := AMsgPack.IntByName('Progress', 0);
    6:
      Gauge7.Progress := AMsgPack.IntByName('Progress', 0);
    7:
      Gauge8.Progress := AMsgPack.IntByName('Progress', 0);
    8:
      Gauge9.Progress := AMsgPack.IntByName('Progress', 0);
    9:
      Gauge10.Progress := AMsgPack.IntByName('Progress', 0);
  end;

end;

procedure TForm6.FormDestroy(Sender: TObject);
begin
  Workers.Clear(Self);
end;

procedure TForm6.NotifyProgress(AIndex, AProgress: Integer);
var
  AParams: TQMsgPack;
begin
  AParams := TQMsgPack.Create;
  AParams.Add('Index', AIndex);
  AParams.Add('Progress', AProgress); // (I+1)*100/10000=>(I+1)/100
  Workers.Post(DoUpdateProgress, AParams, True, jdfFreeAsObject);
end;

end.

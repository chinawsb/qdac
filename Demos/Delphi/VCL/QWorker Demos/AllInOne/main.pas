unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, qstring, qrbtree, qtimetypes, qworker,
  SyncObjs, ExtCtrls, dateutils, ExtActns
{$IFDEF UNICODE}
    , System.Rtti
{$ENDIF}
    ;
{$M+}
type
  TQSystemTimes = record
    IdleTime, UserTime, KernelTime: UInt64;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    Button3: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Label3: TLabel;
    Button16: TButton;
    Button17: TButton;
    Label4: TLabel;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button33: TButton;
    Button34: TButton;
    Button35: TButton;
    Button36: TButton;
    Button37: TButton;
    Button38: TButton;
    Button39: TButton;
    lblPlanStatic: TLabel;
    btnHandleTest: TButton;
    Button40: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Button34Click(Sender: TObject);
    procedure Button35Click(Sender: TObject);
    procedure Button36Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button38Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
    procedure btnHandleTestClick(Sender: TObject);
    procedure Button40Click(Sender: TObject);
  private
  protected
    { Private declarations }
    FSignalId: Integer;
    FMulticastSignal: Integer;
    FRuns: Integer;
    FSignalWaitHandle: IntPtr;
    FTestHandle: IntPtr;
    FLastTimes: TQSystemTimes;
    FMaxCpuUsage: Double;
    procedure DoJobProc(AJob: PQJob);
    procedure DoPostJobDone(AJob: PQJob);
    procedure DoMainThreadWork(AJob: PQJob);
    procedure DoPostJobMsg(var AMsg: TMessage); message WM_APP;
    procedure SignalWaitProc(AJob: PQJob);
    procedure DoSignalJobMsg(var AMsg: TMessage); message WM_APP + 1;
    procedure DoTimerProc(AJob: PQJob);
    procedure DoTimerJobMsg(var AMsg: TMessage); message WM_APP + 2;
    procedure DoLongtimeWork(AJob: PQJob);
    procedure DoLongworkDone(AJob: PQJob);
    procedure DoAtTimeJob1(AJob: PQJob);
    procedure DoAtTimeJob2(AJob: PQJob);
    procedure DoDelayJob(AJob: PQJob);
    procedure DoCancelJob(AJob: PQJob);
    procedure DoNullJob(AJob: PQJob);
    procedure DoCOMJob(AJob: PQJob);
    procedure DoRandDelay(AJob: PQJob);
    procedure DoMsgPackJob(AJob: PQJob);
    procedure DoFirstJobStep(AJob: PQJob);
    procedure DoSecondJobStep(AJob: PQJob);
    procedure SelfTerminateJob(AJob: PQJob);
    procedure DoMulticastSingal1(AJob: PQJob);
    procedure DoMulticastSingal2(AJob: PQJob);
    procedure DoTimeoutGroupJob(AJob: PQJob);
    procedure DoGroupTimeout(ASender: TObject);
    procedure DoGroupTimeoutDone(AJob: PQJob);
    procedure DoLoopJob(AJob: PQJob);
    procedure DoThreadSyncJob(AJob: PQJob);
    procedure DoThreadSyncMsg;
    procedure PostTestJobs(ACount: Integer);
    procedure DoWorkerPostJob(AJob: PQJob);
    procedure DoForJobProc(AMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt);
    procedure DoRepeatJob(AJob: PQJob);
    procedure ShowRepeatDone(AJob: PQJob);
    procedure DoCreateComplex(var AData: Pointer);
    procedure DoFreeComplexRecord(AData: Pointer);
    procedure DoComplexJob(AJob: PQJob);
    procedure DoStringDataJob(AJob: PQJob);
    procedure DoExceptionJob(AJob: PQJob);
    procedure DoRunInMainThreadJob(AJob: PQJob);
    procedure RunInMainO(AData: Pointer);
    procedure DoPlanJob(AJob: PQJob);virtual;
    procedure DoCustomPlanJob(AJob: PQJob);
    function GetCpuUsage: Double;
    function GetCodeMethodName(const AData, ACode: Pointer): String;
  public
    { Public declarations }
  end;

  TAutoFreeTestObject = class
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

  PAutoFreeRecord = ^TAutoFreeRecord;

  TAutoFreeRecord = record
    Id: Integer;
  end;

  PComplexRecord = ^TComplexRecord;

  TComplexRecord = record
    Name: String;
    Age: Integer;
    Temp: array of Single;
  end;

var
  Form1: TForm1;

implementation

uses comobj, qmsgpack, qmapsymbols;
{$R *.dfm}

function GetThreadStacks(AThread: TThread): QStringW;
begin
  Result := StackOfThread(AThread);
end;

procedure TForm1.SelfTerminateJob(AJob: PQJob);
begin
  Label4.Caption := '�Խ�����ҵ������ ' + IntToStr(AJob.Runs) + '��';
  if AJob.Runs = 3 then
  begin
    AJob.IsTerminated := True;
    Label4.Caption := '�Խ�����ҵ�ѽ���.';
  end;
end;

procedure TForm1.ShowRepeatDone(AJob: PQJob);
begin
  ShowMessage('�ظ�Ͷ����ҵ��ɡ�');
end;

procedure TForm1.SignalWaitProc(AJob: PQJob);
begin
  PostMessage(Handle, WM_APP + 1, AJob.Runs, 0);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  ACpuUsage: Double;
begin
  Workers.Signal(FSignalId);
  ACpuUsage := GetCpuUsage;
  if ACpuUsage > FMaxCpuUsage then
    FMaxCpuUsage := ACpuUsage;
  Caption :=
    Format('QWorkerʾ��(%d ����,%d ������,%d æ ,CPU:%0.2f%%/%0.2f%%:Max,%d ��ҵ)',
    [GetCpuCount, Workers.Workers, Workers.BusyWorkers, ACpuUsage, FMaxCpuUsage,
    Workers.PeekJobStatics.Total]);
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  ATime: TDateTime;
begin
  ATime := Now;
  ATime := IncSecond(ATime, 10);
  Workers.At(DoAtTimeJob2, ATime, qworker.Q1Hour, nil, True);
  ShowMessage('���������' + FormatDateTime('hh:nn:ss.zzz', ATime) +
    'ʱ��һ���������Ժ�ÿ��1Сʱ��ʱ����һ�Ρ�');
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  Workers.Post(DoCancelJob, Pointer(1));
  // ֱ��ȡ������ҵ�����е���ҵ�������������û���ļ�ִ��
  Workers.Clear(DoCancelJob, Pointer(1));
  Workers.Post(DoCancelJob, Pointer(2));
  // ��ҵ�Ѿ������ˣ�ȡ��������ȴ���ҵ���
  Sleep(100);
  Workers.Clear(DoCancelJob, Pointer(2));
  // �ظ���ҵ
  Workers.Post(DoCancelJob, 1000, Pointer(3));
  // ֱ��ȡ���ظ���ҵ�����е���ҵ
  Workers.Clear(DoCancelJob, Pointer(3));
  // �ظ���ҵ
  Workers.Post(DoCancelJob, 1000, Pointer(4));
  Sleep(200);
  // ֱ��ȡ���ظ���ҵ�����е���ҵ
  Workers.Clear(DoCancelJob, Pointer(4));
  // �ź���ҵ����
  Workers.Wait(DoCancelJob, FSignalId);
  Workers.Clear(DoCancelJob, nil);

end;

procedure TForm1.Button12Click(Sender: TObject);
var
  AData: PAutoFreeRecord;
begin
  Workers.Post(DoNullJob, TAutoFreeTestObject.Create, false, jdfFreeAsObject);
  New(AData);
  Workers.Delay(DoNullJob, 1000, AData, false, jdfFreeAsSimpleRecord);
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  Workers.Post(DoCOMJob, nil);
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  Workers.Signal('MySignal.Start');
  Workers.Signal('MySignal.Start');
  Workers.Post(DoNullJob, nil);
  Workers.Clear('MySignal.Start');
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  Workers.Delay(DoRandDelay, Q1Second, nil);
end;

procedure DoGlobalJob(AJob: PQJob);
begin
  ShowMessage('ȫ�ֺ�����ҵ�ѵ��á�');
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  Workers.Post(DoGlobalJob, nil, True);
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  Workers.Post(SelfTerminateJob, 10000, nil, True);
end;

procedure TForm1.Button18Click(Sender: TObject);
var
  AId: Integer;
  T: Cardinal;
begin
  AId := Workers.RegisterSignal('Signal.SelfKill');
  Workers.Wait(SelfTerminateJob, AId, True);
  Workers.Signal(AId);
  T := GetTickCount;
  while GetTickCount - T < 500 do
    Application.ProcessMessages;
  Workers.Signal(AId);
  T := GetTickCount;
  while GetTickCount - T < 500 do
    Application.ProcessMessages;
  Workers.Signal(AId);
  T := GetTickCount;
  while GetTickCount - T < 500 do
    Application.ProcessMessages;
  Workers.Signal(AId);
end;

procedure TForm1.Button19Click(Sender: TObject);
var
  AGroup: TQJobGroup;
  AMsg: String;
begin
  AGroup := TQJobGroup.Create(True);
  if AGroup.WaitFor() <> wrSignaled then
    AMsg := 'WaitFor����ҵ�б�ʧ��';
  AGroup.Prepare;
  AGroup.Add(DoExceptionJob, nil, false);
  AGroup.Add(DoLongtimeWork, nil, false);
  AGroup.Add(DoNullJob, nil, false);
  AGroup.Add(DoNullJob, nil, false);
  AGroup.Run;
  if AGroup.MsgWaitFor() <> wrSignaled then
    AMsg := 'WaitFor�����ҵʧ��';
  FreeObject(AGroup);
  if Length(AMsg) > 0 then
    ShowMessage(AMsg)
  else
    ShowMessage('������ҵִ�гɹ���ɡ�');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Timer1Timer(Sender);
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
{$IFDEF UNICODE}
  Workers.Post(
    procedure(AJob: PQJob)
    begin
      ShowMessage('����������ҵ�����Ѿ������á�');
    end, nil, True);
{$ELSE}
  ShowMessage('��ǰDelphi�汾���ͣ�������������֧�֡�');
{$ENDIF}
end;

procedure TForm1.Button21Click(Sender: TObject);
var
  AMsgPack: TQMsgPack;
  // ��ǰ��Ҳ����ʹ��XML����JSON��ʽ���ݲ�����Ч���ϻ���ûɶ���
begin
  // д��1
  Workers.Post(DoMsgPackJob, TQMsgPack.Create.Add('Name', '������ʽ1')
    .Parent.Add('Id', 100).Parent, True, jdfFreeAsObject
  // ����ΪjdfFreeAsObject��ϵͳ�Զ���Data��Ա���������ͷ�
    );
  // д��2
  AMsgPack := TQMsgPack.Create;
  AMsgPack.Add('Name', '������ʽ2');
  AMsgPack.Add('Id', 101);
  Workers.Post(DoMsgPackJob, AMsgPack, True, jdfFreeAsObject)
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
  Workers.Post(DoFirstJobStep, nil, false);
end;

procedure TForm1.Button23Click(Sender: TObject);
var
  AGroup: TQJobGroup;
begin
  AGroup := TQJobGroup.Create(True);
  AGroup.Prepare;
  AGroup.Add(DoFirstJobStep, Pointer(1), false);
  AGroup.Add(DoSecondJobStep, nil, True);
  AGroup.Run;
  // ��Ϊ��ҵ2�����߳������У����Բ��ܼ򵥵�WaitForһֱ�ȴ������������
  while AGroup.WaitFor(10) <> wrSignaled do
    Application.ProcessMessages;
  FreeObject(AGroup);
end;

procedure TForm1.Button24Click(Sender: TObject);
var
  AParams: TQMsgPack;
begin
  AParams := TQMsgPack.Create;
  AParams.Add('TimeStamp').AsDateTime := Now;
  AParams.Add('Sender', 'Button24');
  Workers.Signal(FMulticastSignal, AParams, jdfFreeAsObject);
end;

procedure TForm1.Button25Click(Sender: TObject);
var
  AGroup: TQJobGroup;
  I: Integer;
  ACount: PInteger;
begin
  AGroup := TQJobGroup.Create(True);
  New(ACount);
  AGroup.Tag := ACount;
  ACount^ := 0;
  AGroup.Prepare;
  for I := 0 to 4 do
    AGroup.Add(DoTimeoutGroupJob, ACount);
  AGroup.Run(100);
  AGroup.AfterDone := DoGroupTimeout;
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
  Workers.Post(DoLoopJob, nil, false);
  Sleep(100);
  Workers.Clear(DoLoopJob, nil);
end;

procedure TForm1.Button27Click(Sender: TObject);
begin
  Workers.Post(DoThreadSyncJob, nil);
end;

procedure TForm1.Button28Click(Sender: TObject);
var
  AGroup: TQJobGroup;
begin
  AGroup := TQJobGroup.Create;
  AGroup.Add(DoThreadSyncJob, nil);
  if AGroup.MsgWaitFor() = wrSignaled then
    ShowMessage('��̨�̴߳������.')
  else
    ShowMessage('��̨�̴߳���δ�������.');
  FreeObject(AGroup);
end;

procedure TForm1.Button29Click(Sender: TObject);
begin
  Workers.Clear(DoTimerProc, INVALID_JOB_DATA);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Workers.Post(DoPostJobDone, nil);
end;

procedure DoFreeJobDataC1(ASender: TQWorkers; AFreeType: TQJobDataFreeType;
const AData: Pointer);
begin
  Dispose(PComplexRecord(AData));
end;

procedure TForm1.Button30Click(Sender: TObject);
var
  p: PComplexRecord;
begin
  New(p);
  p.Name := 'QDAC';
  p.Age := 2;
  SetLength(p.Temp, 2);
  p.Temp[0] := 36.5;
  p.Temp[1] := 37;
  Workers.OnCustomFreeData := DoFreeJobDataC1;
  Workers.Post(DoNullJob, p, false, jdfFreeAsC1);
end;

procedure DoGlobalJob1(AJob: PQJob);
begin
  AtomicIncrement(Form1.FRuns);
end;

procedure TForm1.Button31Click(Sender: TObject);
var
  T: Cardinal;
begin
  FRuns := 0;
  T := GetTickCount;
{$IFDEF UNICODE}
  TQForJobs.For(0, 999999,
    procedure(AMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt)
    begin
      AtomicIncrement(FRuns);
      // ���Ҫ�ж�ѭ��������AMrg.Break����,ע�⣬�����ǲ��������������յ�ִ�д����ܿ���
      // �����AIndex��ֵ
      // if AIndex>50000 then
      // AMgr.BreakIt;
    end, false, nil);
{$ELSE}
  TQForJobs.For(0, 999999, DoForJobProc, false, nil);
{$ENDIF}
  T := GetTickCount - T;
  ShowMessage(IntToStr(T) + 'ms,Runs=' + IntToStr(FRuns));
end;

procedure TForm1.Button32Click(Sender: TObject);
var
  AStatus: TQWorkerStatus;
  I: Integer;
  ASeconds: Int64;
  S: String;
begin
  AStatus := Workers.EnumWorkerStatus;
  for I := Low(AStatus) to High(AStatus) do
  begin
    S := S + '�������� ' + IntToStr(I) + '(ID=' + IntToStr(AStatus[I].ThreadId) +
      ')��'#13#10 + ' �Ѵ���:' + IntToStr(AStatus[I].Processed) + ' ״̬:';
    if AStatus[I].IsIdle then
    begin
      ASeconds := (GetTimeStamp - AStatus[I].LastActive) div Q1Second;
      if ASeconds > 0 then
        S := S + '����,ĩ�ι���ʱ��:' + RollupTime(ASeconds) + 'ǰ)'#13#10#13#10
      else
        S := S + '����,ĩ�ι���ʱ��:0��ǰ)'#13#10#13#10;
    end
    else
    begin
      S := S + 'æµ(��ҵ:' + AStatus[I].ActiveJob + ')'#13#10;
      if Length(AStatus[I].Stacks) > 0 then
        S := S + ' ��ջ:'#13#10 + AStatus[I].Stacks + #13#10#13#10
      else
        S := S + #13#10;
    end;
  end;
  ShowMessage(S);
end;

procedure TForm1.Button33Click(Sender: TObject);
begin
  ShowMessage(EnumWaitChains);
end;

procedure TForm1.Button34Click(Sender: TObject);
begin
  Workers.Post(DoRepeatJob, nil);
end;

procedure TForm1.Button35Click(Sender: TObject);
var
  AData: PComplexRecord;
begin
  New(AData);
  // AData����DoFreeComplexRecord���Զ��ͷ�
  AData.Name := 'Do you hat QDAC?';
  Workers.Post(DoComplexJob, TQJobExtData.Create(AData, DoFreeComplexRecord),
    True, jdfFreeAsObject);
  Workers.Post(DoComplexJob, TQJobExtData.Create(DoCreateComplex,
    DoFreeComplexRecord), True, jdfFreeAsObject);
  Workers.Post(DoStringDataJob, TQJobExtData.Create('Hello,world of QDAC'),
    True, jdfFreeAsObject);
{$IFDEF UNICODE}
  // ʹ�����������ͷ�
  New(AData);
  AData.Name := 'Do you like QDAC?';
  Workers.Post(DoComplexJob, TQJobExtData.Create(AData,
    procedure(AData: Pointer)
    begin
      Dispose(PComplexRecord(AData));
    end), True, jdfFreeAsObject);
  // ʹ������������ʼ�����ͷ�
  Workers.Post(DoComplexJob, TQJobExtData.Create(
    procedure(var AData: Pointer)
    var
      S: PComplexRecord;
    begin
      New(S);
      S.Name := 'Hello,I am too simple!';
      S.Age := 11;
      SetLength(S.Temp, 2);
      AData := S;
    end,
    procedure(AData: Pointer)
    begin
      Dispose(PComplexRecord(AData));
    end), True, jdfFreeAsObject);
{$ENDIF}
end;

procedure TForm1.Button36Click(Sender: TObject);
var
  AStates: TQJobStateArray;
  I: Integer;
  ATime: Int64;
  ALoc: TQSymbolLocation;
  ABuilder: TQStringCatHelperW;
  AForm: TForm;
  AMemo: TMemo;
begin
  AForm := TForm.Create(Self);
  AMemo := TMemo.Create(AForm);
  AMemo.Parent := AForm;
  AMemo.Align := alClient;
  AForm.Position := poScreenCenter;
  ATime := GetTimeStamp;
  AStates := Workers.EnumJobStates;
  ABuilder := TQStringCatHelperW.Create;
  ABuilder.Cat('������ ').Cat(Length(AStates)).Cat(' ����ҵ'#13#10);
  for I := 0 to High(AStates) do
  begin
    if ABuilder.Position > 1000 then
    begin
      ABuilder.Cat('...(����ʡ��)');
      Break;
    end;
    ABuilder.Cat('��ҵ #').Cat(I + 1);
    if (AStates[I].Flags and JOB_ANONPROC) = 0 then
    begin
      if AStates[I].Proc.Data <> nil then
        ABuilder.Cat(GetCodeMethodName(AStates[I].Proc.Data,
          AStates[I].Proc.Code))
      else
        ABuilder.Cat('Unknown<').Cat(IntPtr(AStates[I].Proc.Code), True);
    end
    else
      ABuilder.Cat(' - ��������');
    if AStates[I].IsRunning then
      ABuilder.Cat(' ������:'#13#10)
    else
      ABuilder.Cat(' �ƻ���:'#13#10);
    case AStates[I].Handle and $03 of
      0:
        begin
          ABuilder.Cat(' ����ҵ'#13#10);
          Continue;
        end;
      1:
        ABuilder.Cat(' �ظ���ҵ(���´�ִ��ʱ��: ' + FormatFloat('0.#',
          (AStates[I].NextTime - ATime) / 10) + 'ms)'#13#10);
      2:
        ABuilder.Cat(' �ź���ҵ'#13#10);
      3:
        begin
          ABuilder.Cat(' �ƻ�����'#13#10);
          ABuilder.Cat('   �´�ִ��ʱ��: ' + FormatDateTime('yyyy-mm-dd hh:nn:ss',
            AStates[I].Plan.NextTime) + #13#10);
          ABuilder.Cat('   ����:').Cat(AStates[I].Plan.AsString).Cat(#13#10);
        end;
    end;
    ABuilder.Cat(' ������:').Cat(AStates[I].Runs).Cat(' ��'#13#10).Cat(' �����ύʱ��: ')
      .Cat(RollupTime((ATime - AStates[I].PushTime) div 10000)).Cat(' ǰ'#13#10);
    if AStates[I].PopTime <> 0 then
    begin
      ABuilder.Cat(' ĩ��ִ��ʱ��: ');
      if ATime - AStates[I].PopTime > 10000 then
        ABuilder.Cat(RollupTime((ATime - AStates[I].PopTime) div 10000))
          .Cat(' ǰ'#13#10)
      else
        ABuilder.Cat(FloatToStr((ATime - AStates[I].PopTime) / 10))
          .Cat('ms ǰ'#13#10);
    end;
    ABuilder.Cat(' ƽ��ÿ����ʱ:').Cat(FormatFloat('0.#', AStates[I].AvgTime / 10))
      .Cat('ms'#13#10).Cat(' �ܼ���ʱ:')
      .Cat(FormatFloat('0.#', AStates[I].TotalTime / 10)).Cat('ms'#13#10)
      .Cat(' �����ʱ:').Cat(FormatFloat('0.#', AStates[I].MaxTime / 10))
      .Cat('ms'#13#10).Cat(' ��С��ʱ:')
      .Cat(FormatFloat('0.#', AStates[I].MinTime / 10)).Cat('ms'#13#10);
    ABuilder.Cat(' ��־λ:');
    if (AStates[I].Flags and JOB_RUN_ONCE) <> 0 then
      ABuilder.Cat('����,');
    if (AStates[I].Flags and JOB_IN_MAINTHREAD) <> 0 then
      ABuilder.Cat('���߳�,');
    if (AStates[I].Flags and JOB_GROUPED) <> 0 then
      ABuilder.Cat('�ѷ���,');
    ABuilder.Cat(SLineBreak);
  end;
  ClearJobStates(AStates);
  AMemo.Lines.Text := ABuilder.Value;
  AForm.ShowModal;
  FreeObject(AForm);
  FreeObject(ABuilder);
end;

procedure TForm1.Button37Click(Sender: TObject);
var
  AState: TQJobState;
  S: String;
  ATime: Int64;
  ALoc: TQSymbolLocation;
begin
  ATime := GetTimeStamp;
  if Workers.PeekJobState(FSignalWaitHandle, AState) then
  begin
    S := '��ҵ ';
    if (AState.Flags and JOB_ANONPROC) = 0 then
    begin
      if LocateSymbol(AState.Proc.Code, ALoc) then
        S := S + ' - ' + ALoc.FunctionName
      else
        S := S + TObject(AState.Proc.Data).MethodName(AState.Proc.Code);
    end
    else
      S := S + ' - ��������';
    if AState.IsRunning then
      S := S + ' ������:'#13#10
    else
      S := S + ' �ƻ���:'#13#10;
    case AState.Handle and $03 of
      0:
        begin
          S := S + ' ����ҵ'#13#10;
          ShowMessage(S);
          Exit;
        end;
      1:
        S := S + ' �ظ���ҵ(���´�ִ��ʱ��: ' + FormatFloat('0.#',
          (AState.NextTime - ATime) / 10) + 'ms)'#13#10;
      2:
        S := S + ' �ź���ҵ'#13#10;
    end;
    S := S + ' ������:' + IntToStr(AState.Runs) + ' ��'#13#10 + ' �����ύʱ��:' +
      RollupTime((ATime - AState.PushTime) div 10000) + ' ǰ'#13#10;
    if AState.PopTime <> 0 then
      S := S + ' ĩ��ִ��ʱ��:' + RollupTime((ATime - AState.PopTime) div 10000) +
        ' ǰ' + #13#10;
    S := S + ' ƽ��ÿ����ʱ:' + FormatFloat('0.#', AState.AvgTime / 10) + 'ms'#13#10 +
      ' �ܼ���ʱ:' + FormatFloat('0.#', AState.TotalTime / 10) + 'ms'#13#10 +
      ' �����ʱ:' + FormatFloat('0.#', AState.MaxTime / 10) + 'ms'#13#10 + ' ��С��ʱ:'
      + FormatFloat('0.#', AState.MinTime / 10) + 'ms'#13#10;
    S := S + ' ��־λ:';
    if (AState.Flags and JOB_RUN_ONCE) <> 0 then
      S := S + '����,';
    if (AState.Flags and JOB_IN_MAINTHREAD) <> 0 then
      S := S + '���߳�,';
    if (AState.Flags and JOB_GROUPED) <> 0 then
      S := S + '�ѷ���,';
    if S[Length(S)] = ',' then
      SetLength(S, Length(S) - 1);
    ShowMessage(S);
    ClearJobState(AState);
  end
  else
    ShowMessage('δ�ҵ�����ľ����Ӧ����ҵ����ҵ�����Ѿ���ɡ�');
end;

procedure RunInMainG(AData: Pointer);
begin
  ShowMessage('���ã����߳�ȫ�ֺ����汾(��ǰ�߳�ID=' + IntToStr(GetCurrentThreadId) + ',���߳�ID='
    + IntToStr(MainThreadId) + ').');
end;

procedure TForm1.RunInMainO(AData: Pointer);
begin
  ShowMessage('���ã����̶߳����Ա�����汾(��ǰ�߳�ID=' + IntToStr(GetCurrentThreadId) +
    ',���߳�ID=' + IntToStr(MainThreadId) + ').');
end;

procedure TForm1.DoRunInMainThreadJob(AJob: PQJob);
begin
{$IFDEF UNICODE}
  RunInMainThread(
    procedure
    begin
      ShowMessage('���ã����߳����������汾(��ǰ�߳�ID=' + IntToStr(GetCurrentThreadId) +
        ',���߳�ID=' + IntToStr(MainThreadId) + ').');
    end);
{$ENDIF}
  RunInMainThread(RunInMainG, nil);
  RunInMainThread(RunInMainO, nil);
end;

procedure TForm1.Button38Click(Sender: TObject);
begin
  Workers.Post(DoRunInMainThreadJob, nil);
end;

procedure TForm1.Button39Click(Sender: TObject);
var
  AFormat: String;
  AMask: TQPlanMask;
begin
  AMask := TQPlanMask.Create;
  if InputQuery('�ƻ���������', '������Linux Cron ��ʽ�ļƻ�����(�� �� ʱ �� �� �� ��)', AFormat) then
  begin
    AMask.AsString := AFormat;
    Workers.Plan(DoCustomPlanJob, AMask, nil, True);
    ShowMessage('���������������ת��Ϊ��Ľ��Ϊ��' + AMask.AsString + #13#10 +
      'ϵͳ�Ѿ����������Ҫ�ļƻ��������ĵȴ�����ִ�С�');
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ShowMessage(IntToStr(GetTimeStamp));
end;

procedure TForm1.PostTestJobs(ACount: Integer);
var
  J: Integer;
begin
  J := 0;
  while J < ACount do
  begin
    assert(Workers.Post(DoJobProc, nil) <> 0, 'Post failure');
    Inc(J);
  end;
end;

procedure TForm1.DoWorkerPostJob(AJob: PQJob);
begin
  PostTestJobs(NativeInt(AJob.Data));
end;

procedure TForm1.btnHandleTestClick(Sender: TObject);
var
  AHandle: IntPtr;
  T, APlanStart: Cardinal;
  ADone: Boolean;
begin
  btnHandleTest.Enabled := false;
  btnHandleTest.Caption := '���Լ���ҵ';
  ADone := false;
  // Simple Jobs
  AHandle := Workers.Post(
    procedure(AJob: PQJob)
    begin
      if AHandle <> AJob.Handle then
        ShowMessage('Error')
      else
        ShowMessage('Simple:' + IntToStr(AJob.Handle));
      ADone := True;
    end, nil, True);
  while not ADone do
    Application.ProcessMessages;
  btnHandleTest.Caption := '�����ظ���ҵ';
  // Repeat Jobs
  ADone := false;
  AHandle := Workers.Post(
    procedure(AJob: PQJob)
    begin
      Workers.ClearSingleJob(AJob.Handle, false);
      if AJob.Handle <> AHandle then
        ShowMessage('Error')
      else
        ShowMessage('Repeat:' + IntToStr(AJob.Handle));
      ADone := True;
    end, 100, nil, True);
  while not ADone do
    Application.ProcessMessages;
  btnHandleTest.Caption := '�����ź���ҵ';
  // Signal Job
  ADone := false;
  AHandle := Workers.Wait(
    procedure(AJob: PQJob)
    begin
      Workers.ClearSingleJob(AJob.Handle, false);
      if AHandle <> AJob.Handle then
        ShowMessage('Error')
      else
        ShowMessage('Signal:' + IntToStr(AJob.Handle));
      ADone := True;
    end, FSignalId, True);
  while not ADone do
    Application.ProcessMessages;
  // Plan Job
  btnHandleTest.Caption := '�ƻ���ҵ-60��';
  ADone := false;
  AHandle := Workers.Plan(
    procedure(AJob: PQJob)
    begin
      Workers.ClearSingleJob(AJob.Handle, false);
      if AHandle <> AJob.Handle then
        ShowMessage('Error')
      else
        ShowMessage('Plan:' + IntToStr(AJob.Handle));
      ADone := True;
    end, '*', nil, True);
  T := GetTickCount;
  APlanStart := T;
  while not(ADone or Application.Terminated) do
  begin
    if GetTickCount - T > 1000 then
    begin
      if GetTickCount - APlanStart < 60000 then
        btnHandleTest.Caption := '�ƻ���ҵ-' +
          IntToStr(60 - (GetTickCount - APlanStart) div 1000) + '��'
      else
        btnHandleTest.Caption := '���Լƻ���ҵ';
      T := GetTickCount;
    end;
    Application.ProcessMessages;
  end;
  btnHandleTest.Caption := '�������';
  btnHandleTest.Enabled := True;
end;

procedure TForm1.Button40Click(Sender: TObject);
var
  AGroup: TQJobGroup;
begin
  AGroup := TQJobGroup.Create();
  AGroup.MaxWorkers := 1; // ʵ�ʳ�Ϊ˳��ִ��
  AGroup.Prepare;
  AGroup.Add(DoLongtimeWork, nil);
  AGroup.Add(DoLongtimeWork, nil);
  AGroup.Add(DoLongtimeWork, nil);
  AGroup.Run();
  AGroup.MsgWaitFor();
  FreeAndNil(AGroup);
end;

procedure TForm1.Button4Click(Sender: TObject);
const
  ACount: Integer = 1000000;
var
  ANeedRuns, ACpuNum: Int64;
  S: String;
  I: Integer;
  T1: Int64;
  procedure WaitDone;
  begin
    while (FRuns < ANeedRuns) do
    begin
{$IFDEF MSWINDOWS}
      SwitchToThread;
{$ELSE}
      TThread.Yield;
{$ENDIF}
      Application.ProcessMessages;
    end;
  end;

  procedure RunWithPoster(APostWorkers: Integer);
  var
    I, ASubCount, ASubTotal: Integer;
  begin
    T1 := GetTimeStamp;
    FRuns := 0;
    ASubCount := (ACount div APostWorkers);
    ASubTotal := 0;
    for I := 0 to APostWorkers - 1 do
    begin
      if I = APostWorkers - 1 then
        ASubCount := ACount - ASubTotal
      else
        Inc(ASubTotal, ASubCount);
      Workers.Post(DoWorkerPostJob, Pointer(ASubCount), false);
    end;
    WaitDone;
    T1 := (GetTimeStamp - T1);
    S := S + IntToStr(APostWorkers) + ' ���߳�Ͷ���ߣ���ʱ:' + IntToStr(T1 div 10) +
      'ms,�ٶ�:' + IntToStr(Int64(FRuns) * 10000 div T1) + '��/��'#13#10;
  end;

begin
  Button4.Enabled := false;
  ANeedRuns := ACount;
  // ���߳�Ͷ�ģ����̴߳������
  ACpuNum := GetCpuCount;
  T1 := GetTimeStamp;
  FRuns := 0;
  Workers.DisableWorkers;
  PostTestJobs(ACount);
  Workers.EnableWorkers;
  WaitDone;
  T1 := (GetTimeStamp - T1);
  S := '���߳�Ͷ��(����ģʽ)����ʱ:' + IntToStr(T1 div 10) + 'ms,�ٶ�:' +
    IntToStr(Int64(FRuns) * 10000 div T1) + '��/��'#13#10;
  T1 := GetTimeStamp;
  FRuns := 0;
  PostTestJobs(ACount);
  WaitDone;
  T1 := (GetTimeStamp - T1);
  S := S + '���߳�Ͷ�ģ���ʱ:' + IntToStr(T1 div 10) + 'ms,�ٶ�:' +
    IntToStr(Int64(FRuns) * 10000 div T1) + '��/��'#13#10;
  for I := 1 to ACpuNum * 2 do
  begin
    RunWithPoster(I);
  end;
  ShowMessage(S);
  Button4.Enabled := True;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Workers.Post(DoMainThreadWork, nil, True);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Workers.Signal('MySignal.Start');
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  if Workers.LongtimeJob(DoLongtimeWork, nil) = 0 then
    ShowMessage('��ʱ����ҵͶ��ʧ��');
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  ShowMessage('���������5����һ���������Ժ�ÿ��1Сʱ��ʱ����һ�Ρ�');
  Workers.At(DoAtTimeJob1, 5 * qworker.Q1Second, qworker.Q1Hour, nil, True)
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Workers.Delay(DoDelayJob, 5 * qworker.Q1Second, nil, True)
end;

procedure TForm1.DoAtTimeJob1(AJob: PQJob);
begin
  ShowMessage('��ʱ5���ִ�е������Ѿ�ִ����' + IntToStr(AJob.Runs + 1) + '�Σ�1Сʱ��ִ����һ��');
end;

procedure TForm1.DoAtTimeJob2(AJob: PQJob);
begin
  ShowMessage('��ʱ��������' + FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + '��ʼ��'
    + IntToStr(AJob.Runs + 1) + '��ִ�У�1Сʱ��ִ����һ��'#13#10 + '���ʱ��:' +
    IntToStr(AJob.PushTime) + #13#10 + '����ʱ��:' + IntToStr(AJob.PopTime));
end;

procedure TForm1.DoCancelJob(AJob: PQJob);
begin
  OutputDebugStringW(PWideChar(QStringW('DoCancelJob(') + IntToHex(IntPtr(AJob),
    8) + ')-' + IntToStr(Integer(AJob.Data)) + ' Started'));
  Sleep(5000);
  OutputDebugStringW(PWideChar(QStringW('DoCancelJob(') + IntToHex(IntPtr(AJob),
    8) + ')-' + IntToStr(Integer(AJob.Data)) + ' Finished'));
end;

procedure TForm1.DoCOMJob(AJob: PQJob);
var
  ADispatch: IDispatch;
begin
  AJob.Worker.ComNeeded();
  try
    ADispatch := CreateOleObject('ADODB.Recordset');
  except
  end;
end;

procedure TForm1.DoComplexJob(AJob: PQJob);
var
  AData: PComplexRecord;
begin
  AData := AJob.ExtData.Origin;
  ShowMessage(AData.Name);
end;

procedure TForm1.DoCreateComplex(var AData: Pointer);
var
  S: PComplexRecord;
begin
  New(S);
  S.Name := 'Hello,I am from QDAC Complex Demo';
  S.Age := 3;
  SetLength(S.Temp, 2);
  AData := S;
end;

procedure TForm1.DoCustomPlanJob(AJob: PQJob);
var
  APlan: PQJob;
begin
  APlan := AJob.PlanJob;
  lblPlanStatic.Caption := '�ƻ�������ִ��' + IntToStr(AJob.Runs + 1) + '��'#13#10 +
    '����:' + APlan.ExtData.AsPlan.Plan.Content;
end;

procedure TForm1.DoDelayJob(AJob: PQJob);
begin
  ShowMessage('�ӳٵ������Ѿ�ִ������ˡ�'#13#10 + '���ʱ��:' + IntToStr(AJob.PushTime) + #13#10
    + '����ʱ��:' + IntToStr(AJob.PopTime));
end;

procedure TForm1.DoExceptionJob(AJob: PQJob);
begin
  raise Exception.Create('ֻ��һ��������ҵ�쳣');
end;

procedure TForm1.DoFirstJobStep(AJob: PQJob);
var
  AUrl: TDownloadURL;
begin
  AUrl := TDownloadURL.Create(nil);
  AUrl.URL :=
    'http://api.map.baidu.com/geocoder/v2/?address=������ͬ��·&output=json&ak=E4805d16520de693a3fe707cdc962045&callback=showLocation';
  AUrl.Filename := ExtractFilePath(Application.ExeName) + 'baidu.html';
  if AUrl.Execute and (not Assigned(AJob.Data)) then
  begin
    Workers.Post(DoSecondJobStep, nil, True, jdfFreeAsSimpleRecord);
  end;
  AUrl.Free;
end;

procedure TForm1.DoForJobProc(AMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt);
begin
  AtomicIncrement(FRuns);
end;

procedure TForm1.DoFreeComplexRecord(AData: Pointer);
begin
  Dispose(PComplexRecord(AData));
end;

procedure TForm1.DoGroupTimeout(ASender: TObject);
begin
  Workers.Post(DoGroupTimeoutDone, ASender, True, jdfFreeAsObject)
end;

procedure TForm1.DoGroupTimeoutDone(AJob: PQJob);
var
  AGroup: TQJobGroup;
begin
  AGroup := AJob.Data;
  ShowMessage('���鳬ʱ��ҵʵ�����' + IntToStr(PInteger(AGroup.Tag)^) + '��(�ƻ�10��)');
  Dispose(AGroup.Tag);
end;

procedure TForm1.DoJobProc(AJob: PQJob);
begin
  AtomicIncrement(FRuns);
end;

procedure TForm1.DoLongtimeWork(AJob: PQJob);
begin
  OutputDebugString('��ʱ����ҵ��ʼ.');
  while not AJob.IsTerminated do
  begin
    Sleep(1000);
    if AJob.ElapsedTime > 50000 then // 5s���������ע���ʱ��λΪ0.1ms
      AJob.IsTerminated := True;
  end;
  if not Workers.Terminating then
    // ���δ�������򴥷�һ��֪ͨ��ǰ̨����������ǰ̨��һЩ��һ������
    Workers.Signal('Longwork.Done');
  OutputDebugString('��ʱ����ҵ����.');
end;

procedure TForm1.DoLongworkDone(AJob: PQJob);
begin
  ShowMessage('��ʱ����ҵ�Ѿ����');
end;

procedure TForm1.DoLoopJob(AJob: PQJob);
begin
  while not AJob.IsTerminated do
  begin
    Sleep(50);
  end;
end;

procedure TForm1.DoMainThreadWork(AJob: PQJob);
begin
  ShowMessage('���������߳��д������첽��ҵ��');
end;

procedure TForm1.DoMsgPackJob(AJob: PQJob);
begin
  ShowMessage(TQMsgPack(AJob.Data).AsString);
end;

procedure TForm1.DoMulticastSingal1(AJob: PQJob);
var
  AParams: TQMsgPack;
begin
  AParams := AJob.Data;
  ShowMessage('����ʾ����DoMulticastSignal1,������'#13#10 + AParams.AsString);
end;

procedure TForm1.DoMulticastSingal2(AJob: PQJob);
var
  AParams: TQMsgPack;
begin
  AParams := AJob.Data;
  ShowMessage('����ʾ����DoMulticastSignal2,������'#13#10 + AParams.AsString);
end;

procedure TForm1.DoNullJob(AJob: PQJob);
begin
  OutputDebugString('Null Job Executed');
end;

procedure TForm1.DoPlanJob(AJob: PQJob);
var
  APlan: PQJob;
begin
  APlan := AJob.PlanJob;
  lblPlanStatic.Caption := '�ƻ�������ִ��' + IntToStr(AJob.Runs + 1) + '��'#13#10 +
    '����:' + APlan.ExtData.AsPlan.Plan.Content;
end;

procedure TForm1.DoPostJobDone(AJob: PQJob);
begin
  PostMessage(Handle, WM_APP, AJob.PopTime - AJob.PushTime, 0);
end;

procedure TForm1.DoPostJobMsg(var AMsg: TMessage);
begin
  ShowMessage(Format('��ҵͶ�ĵ�ִ����ʱ %g ms', [AMsg.WParam / 10]));
end;

procedure TForm1.DoRandDelay(AJob: PQJob);
begin
  Label3.Caption := '�����ҵĩ���ӳ� ' + IntToStr((AJob.PopTime - AJob.PushTime)
    div 10) + 'ms';
  Workers.Delay(AJob.WorkerProc.Proc, qworker.Q1Second +
    random(qworker.Q1Second), AJob.Data, True);
end;

procedure TForm1.DoRepeatJob(AJob: PQJob);
begin
  if Integer(AJob.Data) = 3 then
    Workers.Post(ShowRepeatDone, nil, True)
  else
  begin
    // ʹ��AJob��WorkerProc��Ա��Ͷ��
{$IFDEF UNICODE}
    if AJob.IsAnonWorkerProc then // �����Ļ���ʹ�õ�һ�ַ�ʽ�������õڶ��ּ���
      Workers.Delay(TQJobProcA(AJob.WorkerProc.ProcA), random(30000),
        Pointer(Integer(AJob.Data) + 1))
    else
{$ENDIF}
      Workers.Delay(AJob.WorkerProc.Proc, random(30000),
        Pointer(Integer(AJob.Data) + 1));
    // ��ֱ�ӵ���ֱ��ʹ��Workers.Delay(DoRepeatJob,...)����Ϊ�����Լ����Լ�������
    // ����Լ���ô�ܲ�֪���Լ���ɶ��
  end;
end;

procedure TForm1.DoSecondJobStep(AJob: PQJob);
var
  AFileName: String;
begin
  AFileName := ExtractFilePath(Application.ExeName) + 'baidu.html';
  MessageBoxW(Handle, PQCharW(LoadTextW(AFileName)), '���', MB_OK);
  DeleteFile(AFileName);
end;

procedure TForm1.DoSignalJobMsg(var AMsg: TMessage);
begin
  Label2.Caption := Format('�ź�MySignal.Start�Ѵ��� %d��', [AMsg.WParam]);
end;

procedure TForm1.DoStringDataJob(AJob: PQJob);
begin
  ShowMessage(AJob.ExtData.AsString);
end;

procedure TForm1.DoThreadSyncJob(AJob: PQJob);
begin
  AJob.Synchronize(DoThreadSyncMsg);
end;

procedure TForm1.DoThreadSyncMsg;
begin
  ShowMessage('��ҵ�е����̵߳�ͬ���������');
end;

procedure TForm1.DoTimeoutGroupJob(AJob: PQJob);
begin
  Sleep(50);
  AtomicIncrement(PInteger(AJob.Data)^);
end;

procedure TForm1.DoTimerJobMsg(var AMsg: TMessage);
begin
  Label1.Caption := '��ʱ������ִ��' + IntToStr(AMsg.WParam) + '��';
end;

procedure TForm1.DoTimerProc(AJob: PQJob);
begin
  PostMessage(Handle, WM_APP + 2, AJob.Runs, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutDown := True;
  // ע��һ���źŴ����������Ա��ڴ���ʱִ��
  FSignalId := Workers.RegisterSignal('MySignal.Start');
  FMulticastSignal := Workers.RegisterSignal('Multicase.Start');
  Workers.Wait(DoMulticastSingal1, FMulticastSignal);
  Workers.Wait(DoMulticastSingal2, FMulticastSignal);
  FSignalWaitHandle := Workers.Wait(SignalWaitProc, FSignalId);
  /// // / ʹ���������������ź�
  Workers.Wait(DoLongworkDone, Workers.RegisterSignal('Longwork.Done'), True);
  // ע��һ����ʱִ�������źţ�ÿ0.1�봥��һ��
  Workers.Post(DoTimerProc, 1000, nil);
  Workers.Plan(DoPlanJob, '0 * * * * * "1 Minute Plan Job"', nil, True);
  Workers.Plan(DoPlanJob, '0 0/2 * * * * "2 Minute Plan Job"', nil, True);
  Timer1Timer(Sender);
  GetThreadStackInfo := GetThreadStacks;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := false;
  Workers.Clear(Self);
end;

function TForm1.GetCodeMethodName(const AData, ACode: Pointer): String;
var
  AContext: TRttiContext;
  AType: TRttiType;
  AMethods: TArray<TRttiMethod>;
  I: Integer;
begin
  if AData <> nil then
  begin
    if AData = Pointer(-1) then
      Result := (IInterface(ACode) as TObject).ClassName + '.Invoke'
    else
    begin
//      TObject(AData).GetInterfaceEntry()
      AContext := TRttiContext.Create;
      AType := AContext.GetType(TObject(AData).ClassType);
      AMethods := AType.GetMethods;
      for I := 0 to High(AMethods) do
      begin
        if AMethods[I].CodeAddress = ACode then
          Exit(AType.QualifiedName + '.' + AMethods[I].Name)
      end;
      Result := TObject(AData).ClassType.QualifiedClassName + '.' + IntToHex(IntPtr(ACode),
        SizeOf(Pointer) * 2);
    end;
  end
  else
    Result := IntToHex(IntPtr(ACode), SizeOf(Pointer) * 2);
end;

function TForm1.GetCpuUsage: Double;
var
  Usage, Idle: UInt64;
  CreateTime, ExitTime, IdleTime, UserTime, KernelTime: TFileTime;
  CurTimes: TQSystemTimes;
  function FileTimeToI64(const ATime: TFileTime): Int64;
  begin
    Result := (Int64(ATime.dwHighDateTime) shl 32) + ATime.dwLowDateTime;
  end;

begin
  Result := 0;
  if GetProcessTimes(GetCurrentProcess, CreateTime, ExitTime, KernelTime,
    UserTime) then
  begin
    CurTimes.UserTime := FileTimeToI64(UserTime);
    CurTimes.KernelTime := FileTimeToI64(KernelTime);
    CurTimes.IdleTime := GetTimeStamp;
    Usage := (CurTimes.UserTime - FLastTimes.UserTime) +
      (CurTimes.KernelTime - FLastTimes.KernelTime);
    if FLastTimes.IdleTime <> 0 then
    begin
      Idle := CurTimes.IdleTime - FLastTimes.IdleTime;
      if Idle > 0 then
        Result := Usage / Idle / GetCpuCount / 10;
    end;
    FLastTimes := CurTimes;
  end;

end;

{ TAutoFreeTestObject }

constructor TAutoFreeTestObject.Create;
begin
  OutputDebugString('TAutoFreeTestObject.Create');
end;

destructor TAutoFreeTestObject.Destroy;
begin
  OutputDebugString('TAutoFreeTestObject.Free');
  inherited;
end;

end.

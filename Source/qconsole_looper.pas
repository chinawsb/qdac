unit qconsole_looper;

interface

uses classes, sysutils, syncobjs, qstring{$IFDEF POSIX}, Posix.UniStd,
  Posix.Signal{$ELSE},Windows{$ENDIF};

type
  { TQConsoleLooper ��������̨ѭ������֤�����ܹ������߳���ִ��һЩ��̨�߳���Ҫǰ̨����Ĺ��̣�
    ��ע���������� ReadLn һ���IO������������ֹ���߳�ȥִ�� TThread.Queue/Synchronize/ForceQueue
    ������ִ�е��첽����������ִ����ɺ��ָ�ִ�С�ͬ����ǲ��ò�������Ҫ��Ͷ�ݵĺ���������������

    �������²���֧�֣�
    -install ������װΪ linux ��ϵͳ���񣨽�֧�� systemd ģʽ�ķ�����ͬ��
    -uninstall ������� linux ϵͳ�������Ƴ�
    -start ���������ػ�����(���û������ PidFile������Ҫ�û����д��� OnStop �¼�)
    -stop ֹͣ�����ػ�����
    -reload ���¼������ã��ò���ʵ�����ػ����̷����� SIGUSR1�������û���Ҫ��ʹ����
    -restart ɱ����ǰ�ػ����̲������µ��ػ�����
    ע�⣬���������в�����Ҫ��Ӧ��Ȩ�ޣ���ȷ�����������Ӧ��Ȩ�ޡ�
  }

  TPosixSignalNotify = procedure(Sender: TObject; ASignalNum: Integer;
    var AHandled: Boolean) of object;
  TPosixInstallEvent = procedure(Sender: TObject; AIni: TCustomIniFile)
    of object;

  TQConsoleLooper = class
  private
    class var FCurrent: TQConsoleLooper;
    class function GetCurrent: TQConsoleLooper; static;
  protected
    FEvent: TEvent;
    FOnTerminate: TNotifyEvent;
    FBeforeRun: TNotifyEvent;
    FOnReload: TNotifyEvent;
    FPidFile: String;
    FName, FTitle: String;
    FOnSignal: TPosixSignalNotify;
    FOnInstall: TPosixInstallEvent;
    FTerminated, FTerminateOnException, FIsDaemon, FIsWorker: Boolean;
    FSignals: TIntegerSet;
    FDaemonProcessId: Integer;
    procedure DoWakeMainThread(AObject: TObject);
    function GetTitle: String;
    function GetName: String;
{$IFDEF POSIX}
    procedure DoSignalEvent(ASignalNum: Integer);
    class procedure DoSignal(SigNum: Integer); cdecl; static;
{$ENDIF}
  public
    constructor Create(ATerminateOnException: Boolean); overload;
    destructor Destroy; override;
    class destructor Destroy;
    procedure Run;
    procedure Terminate;
{$IFDEF POSIX}
    procedure HandleSignal(ASignalNum: Integer);
    procedure UnhandleSignal(ASignalNum: Integer);
{$ENDIF}
    property Terminated: Boolean read FTerminated;
    property TerminateOnException: Boolean read FTerminateOnException
      write FTerminateOnException;
    property IsDaemon: Boolean read FIsDaemon write FIsDaemon;
    property IsWorker: Boolean read FIsWorker;
    property Name: String read GetName write FName;
    property Title: String read GetTitle write FTitle;
    property BeforeRun: TNotifyEvent read FBeforeRun write FBeforeRun;
    property OnTerminate: TNotifyEvent read FOnTerminate write FOnTerminate;
    property OnReload: TNotifyEvent read FOnReload write FOnReload;
{$IFDEF POSIX}
    property OnSignal: TPosixSignalNotify read FOnSignal write FOnSignal;
    property OnInstall: TPosixInstallEvent read FOnInstall write FOnInstall;
    property PidFile: String read FPidFile write FPidFile;
    property DaemonProcessId: Integer read FDaemonProcessId;
{$ENDIF}
    class property Current: TQConsoleLooper read GetCurrent;
  end;

implementation

{ TQConsoleLooper }

constructor TQConsoleLooper.Create(ATerminateOnException: Boolean);
begin
  inherited Create;
  FTerminateOnException := ATerminateOnException;
  FEvent := TEvent.Create(nil, false, false, '');
  WakeMainThread := DoWakeMainThread;
{$IFDEF POSIX}
  Signal(SIGQUIT, DoSignal);
  Signal(SIGINT, DoSignal);
  Signal(SIGUSR1, DoSignal);
{$ENDIF}
end;

destructor TQConsoleLooper.Destroy;
begin
  FreeAndNil(FEvent);
  inherited;
end;

class function TQConsoleLooper.GetCurrent: TQConsoleLooper;
begin
  if not Assigned(FCurrent) then
    FCurrent := TQConsoleLooper.Create(false);
  Result := FCurrent;
end;

function TQConsoleLooper.GetName: String;
begin
  if Length(FName) = 0 then
    FName := ExtractFileName(ParamStr(0));
  Result := FName;
end;
function TQConsoleLooper.GetTitle: String;
begin
  if Length(FTitle) = 0 then
    FTitle := ExtractFileName(ParamStr(0));
  Result := FTitle;
end;
{$IFDEF POSIX}
procedure TQConsoleLooper.HandleSignal(ASignalNum: Integer);
begin
  Signal(ASignalNum, DoSignal);
end;
{$ENDIF}

procedure TQConsoleLooper.Run;
{$IFDEF POSIX}
  function Exec(const ACmd: String; const AParams: array of String): Integer;
  var
    ACmdline: String;
    I: Integer;
  begin
    ACmdline := ACmd;
    for I := 0 to High(AParams) do
      ACmdline := ACmdline + ' ' + QuotedStrW(AParams[I], '"');
    Result := _system(MarshaledAString(System.UTF8Encode(ACmdline)));
  end;
  procedure Install;
  var
    AList: TMemIniFile;
    AFileName: String;
    AServiceName: String;
  begin
    WriteLn('Install service ' + Name);
    AFileName :=  ExpandFileName(ParamStr(0));
    AList := TMemIniFile.Create('/lib/systemd/system/' + Name + '.service');
    try
      AList.WriteString('Unit', 'Description', Title);
      // AList.WriteString('Unit', 'Before', '');
      AList.WriteString('Unit', 'After', 'syslog.target network.target');
      // AList.WriteString('Unit','Conflicts','');
      // AList.WriteString('Unit','Wants','');
      // AList.WriteString('Unit', 'Documentation', '');
      // AList.WriteString('Unit', 'Requisite','');
      // AList.WriteString('Unit', 'Requires','');
      // AList.WriteString('Unit', 'RequiresOverridable','');
      // ����ע��
      // simple/dbus/forking/oneshot/notify/idle  ��TQConsoleLooper Ĭ��ע��Ϊforking
      AList.WriteString('Service', 'Type', 'forking');
      // AList.WriteString('Service', 'BusName', ''); //��Type=dbusʱ������
      // AList.WriteBoolean('Unit', 'RemainAfterExit',false);
      AList.WriteString('Service', 'PIDFile', PidFile);
      // ExecStartPre/ExecStartPost,RestartSec,TimeoutSec
      AList.WriteString('Service', 'ExecStart', AFileName);
      AList.WriteString('Service', 'ExecStop', AFileName + ' -stop');
      AList.WriteString('Service', 'ExecReload', AFileName + ' -reload');
      // ��װ
      AList.WriteString('Install', 'WantedBy', 'multi-user.target');
      // AList.WriteString('Install','Alias','');
      // AList.WriteString('Install','Also','');
      if Assigned(FOnInstall) then
        FOnInstall(Self, AList);
      AList.UpdateFile;
    finally
      FreeAndNil(AList);
    end;
    AServiceName := Name + '.service';
    WriteLn('Enable service ' + Name + '...');
    Exec('systemctl', ['enable', AServiceName]);
    Exec('systemctl', ['daemon-reload']);
    WriteLn('Start service ' + Name + '...');
    Exec('systemctl', ['start', AServiceName]);
    WriteLn('Service ' + Name + ' started.');
  end;
  function IsStarted: Boolean;
  var
    S: String;
  begin
    Result := false;
    if (Length(PidFile) > 0) and FileExists(PidFile) then
    begin
      S := LoadTextW(PidFile, teUtf8);
      if TryStrToInt(S, FDaemonProcessId) then
    begin
        // �������Ƿ�ǰ��������
        if DirectoryExists('/proc/' + S) then
        begin
          if FindCmdlineSwitch('restart') then
            kill(FDaemonProcessId, SIGKILL)
          else
          begin
            if FindCmdlineSwitch('stop') then
            begin
              WriteLn('Stop service');
              kill(FDaemonProcessId, SIGSTOP);
              WriteLn('Service stopped');
            end
            else if FindCmdlineSwitch('reload') then
              kill(FDaemonProcessId, SIGUSR1);
            Result := True;
          end;
        end;
      end;
    end;
  end;
  procedure Uninstall;
  var
    AServiceName: String;
  begin
    AServiceName := Name + '.service';
    WriteLn('Prepare remove service ' + Name + '...');
    Exec('systemctl', ['disable', AServiceName]);
    Exec('systemctl', ['stop', AServiceName]);
    WriteLn('Delete service ' + Name + '...');
    if (Length(PidFile) > 0) and FileExists(PidFile) then
      DeleteFile(PidFile);
    AServiceName := '/lib/systemd/system/' + AServiceName;
    if FileExists(AServiceName) then
      DeleteFile(AServiceName);
    WriteLn('Reload system services...');
    Exec('systemctl', ['daemon-reload']);
    WriteLn('Service uninstall done.');
  end;
  //���ִ����ɣ��򷵻�true
  function DaemonCheck: Boolean;
  begin
    Result := false;
    if IsDaemon then // �ػ�����ֻ������ Linux������ϵͳ��֧��
    begin
      if FindCmdlineSwitch('install') then
      begin
        Install;
        Exit(True);
      end
      else if FindCmdlineSwitch('uninstall') then
      begin
        Uninstall;
        Exit(True);
      end;
      // �ȼ������Ƿ��Ѿ�����
      if IsStarted then
        Exit(True);
      FDaemonProcessId := fork();
      if FDaemonProcessId <> 0 then
      begin
        Result := True;
        if Length(PidFile) > 0 then
        begin
          try
            SaveTextU(PidFile, IntToStr(FDaemonProcessId), false);
          except
            on E: Exception do
            begin
              DebugOut('Cant create pid file:%s', [E.Message]);
      end;
    end;
  end;
      end
      else
      begin
        FDaemonProcessId := getpid();
        // �ػ����̣�����������
        FIsWorker := True;
      end;
    end
    else
      FIsWorker := True;
  end;
{$ENDIF}

begin
  try
{$IFDEF LINUX}
    DaemonCheck;
{$ENDIF}
    if Assigned(BeforeRun) then
      BeforeRun(Self);
    if not IsWorker then
      Exit;
  repeat
    try
      CheckSynchronize;
      if not FTerminated then
        FEvent.WaitFor(INFINITE);
    except
      on E: Exception do
      begin
        if not(E is EAbort) then
        begin
          WriteLn(E.ClassName + ':' + E.Message);
          if FTerminateOnException then
            FTerminated := True;
        end;
      end;
    end;
  until FTerminated;
  finally
    if Assigned(OnTerminate) then
      OnTerminate(Self);
  end;
end;

procedure TQConsoleLooper.Terminate;
begin
  FTerminated := True;
  FEvent.SetEvent;
end;
{$IFDEF POSIX}

procedure TQConsoleLooper.UnhandleSignal(ASignalNum: Integer);
begin
  Signal(ASignalNum, TSignalHandler(SIG_DFL));
end;
{$ENDIF}
class destructor TQConsoleLooper.Destroy;
begin
  if Assigned(FCurrent) then
    FreeAndNil(FCurrent);
end;

{$IFDEF POSIX}

class procedure TQConsoleLooper.DoSignal(SigNum: Integer);
begin
  Current.DoSignalEvent(SigNum);
end;

procedure TQConsoleLooper.DoSignalEvent(ASignalNum: Integer);
var
  AHandled: Boolean;
begin
  AHandled := false;
  if Assigned(OnSignal) then
    OnSignal(Self, ASignalNum, AHandled);
  if ASignalNum = SIGUSR1 then // ���¼�������
  begin
    if Assigned(OnReload) then
      OnReload(Self);
    AHandled := True;
  end;
  if not AHandled then
  begin
    if (ASignalNum in [SIGQUIT, SIGINT, SIGABRT]) or TerminateOnException then
      Terminate;
  end;
end;
{$ENDIF}

procedure TQConsoleLooper.DoWakeMainThread(AObject: TObject);
begin
  FEvent.SetEvent;
end;




end.

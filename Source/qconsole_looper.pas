unit qconsole_looper;

interface

uses classes, sysutils, syncobjs, qstring{$IFDEF POSIX}, Posix.UniStd,
  Posix.Signal{$ELSE},Windows{$ENDIF};

type
  { TQConsoleLooper 用来控制台循环，保证程序能够在主线程中执行一些后台线程需要前台处理的过程，
    请注意如果你调用 ReadLn 一类的IO阻塞操作会阻止主线程去执行 TThread.Queue/Synchronize/ForceQueue
    等请求执行的异步函数，在其执行完成后会恢复执行。同理除非不得不做，不要在投递的函数做阻塞操作。

    内置以下参数支持：
    -install 将程序安装为 linux 的系统服务（仅支持 systemd 模式的服务，下同）
    -uninstall 将程序从 linux 系统服务中移除
    -start 启动服务守护进程(如果没有设置 PidFile，则需要用户自行处理 OnStop 事件)
    -stop 停止服务守护进程
    -reload 重新加载设置，该参数实际向守护进程发送了 SIGUSR1，所以用户不要再使用它
    -restart 杀死当前守护进程并重启新的守护进程
    注意，上述命令行操作需要相应的权限，请确保程序具有相应的权限。
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
      // 服务注册
      // simple/dbus/forking/oneshot/notify/idle  ，TQConsoleLooper 默认注册为forking
      AList.WriteString('Service', 'Type', 'forking');
      // AList.WriteString('Service', 'BusName', ''); //仅Type=dbus时有意义
      // AList.WriteBoolean('Unit', 'RemainAfterExit',false);
      AList.WriteString('Service', 'PIDFile', PidFile);
      // ExecStartPre/ExecStartPost,RestartSec,TimeoutSec
      AList.WriteString('Service', 'ExecStart', AFileName);
      AList.WriteString('Service', 'ExecStop', AFileName + ' -stop');
      AList.WriteString('Service', 'ExecReload', AFileName + ' -reload');
      // 安装
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
        // 检查进程是否当前正在运行
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
  //如果执行完成，则返回true
  function DaemonCheck: Boolean;
  begin
    Result := false;
    if IsDaemon then // 守护进程只测试了 Linux，其它系统不支持
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
      // 先检查服务是否已经启动
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
        // 守护进程，不是主程序
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
  if ASignalNum = SIGUSR1 then // 重新加载配置
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

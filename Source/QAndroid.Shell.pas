unit QAndroid.Shell;

interface

{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�QAndroidShell����QDAC��Ŀ����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}
{
  ����Ԫʵ����һ��α��Shell������������Android������ִ��Shell��������ҪRootȨ�ޣ�
  ����ִ��ǰ������AskForRoot��������ȡ�û���Root��Ȩ�����������Ҫ��Root�˺���ִ��
  ��������ExitRoot�������˳�Root�˺ŷ�����ͨ�˺�ģʽ��
  1������TQAndroidShell.Initialize��������ʼ����ǰʵ��
  AShell.Initialize;
  2�������ҪRootȨ��ִ��ĳЩ�������TQAndroidShell.AskForRoot���RootȨ�ޣ�������Դ˲���
  if AShell.AskForRoot then
  begin
  ...
  end
  else //����ʧ�ܣ��ֻ�δRoot�����û��ܾ�����RootȨ��
  ...;
  3������Execute������ִ�������в���÷��صĽ��
  AShell.Execute('ls /proc -l');
  4�����Ҫ�л�����ͨ�˺�ģʽ������AShell.ExitRoot�����ص�ǰ��ͨ�˺�ģʽ
  ��ע�⡿TQAndroidShell��һ����¼������Ҫ�ֹ��ͷţ���������New���ɵģ�

}

uses System.SysUtils, System.Diagnostics, Androidapi.Jni,
  Androidapi.JNIBridge,
  Androidapi.Jni.GraphicsContentViewText,
  Androidapi.Jni.JavaTypes,
  Androidapi.Helpers,
  FMX.Helpers.Android, FMX.Forms, FMX.Dialogs, qstring;

type
  PQAndroidShell = ^TQAndroidShell;

  TQAndroidShell = record
  private
    FRuntime: JObject;
    FProcess: JObject;
    FInRoot: Boolean;
    function GetIsRooted: Boolean;
    function InternalReadReply(AProcess: JObject; ATimeout: Cardinal): QStringW;
    /// <summary>����һ��������</summary>
    /// <param name="ACmdline">Ҫ���͵�����������</param>
    /// <returns>�ɹ�������true��ʧ�ܣ�����false</returns>
    /// <remarks>������Rootģʽ��</remarks>
    function SendCmd(const ACmdline: QStringW): Boolean;
    function ReadReply(ATimeout: Cardinal = INFINITE): QStringW;
  public
    /// <summary>��ʼ�����������ڳ�ʼ��һ��TQAndroidShellʵ��</summary>
    /// <returns>���ص�ǰ��¼��ָ��</returns>
    function Initliaize: PQAndroidShell;
    /// <summary>����RootȨ���Խ���Root�˺�׼��ִ�к���������</summary>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ʧ�ܣ�һ�������ֿ��ܣ�
    /// 1���豸δRoot����ʱIsRooted����ΪFalse��
    /// 2���û��ܾ���Ȩ
    /// </remarks>
    function AskForRoot: Boolean;
    /// <summary>ִ��ָ���������в��ȴ�����</summary>
    /// <param name="ACmdline">����������</param>
    /// <param name="ATimeout">�ȴ�����ִ��ǰ�ȴ���ʱ�䣬��λΪ����</param>
    /// <returns>���������е�������</returns>
    function Execute(const ACmdline: QStringW; ATimeout: Cardinal = INFINITE)
      : QStringW;
    /// <summary>�˳�Rootģʽ</summary>
    /// <remarks>���δ����Rootģʽ��ʲôҲ���ᷢ��</remarks>
    procedure ExitRoot;
    /// <summary>��ǰ�Ƿ���Rootģʽ</summary>
    property InRoot: Boolean read FInRoot;
    /// <summary>��ǰ�豸�Ƿ��Ѿ�Root����</summary>
    property IsRooted: Boolean read GetIsRooted;
  end;

implementation

type
  JProcess = interface;
  JRuntime = interface;

  // ----------------------------------JProcess----------------------
  JProcessClass = interface(JObjectClass)
    ['{7BFD2CCB-89B6-4382-A00B-A7B5BB0BC7C9}']

  end;

  [JavaSignature('java/lang/Process')]
  JProcess = interface(JObject)
    ['{476414FD-570F-4EDF-B678-A2FE459EA6EB}']
    { Methods }
    procedure destroy; cdecl;
    function exitValue: integer; cdecl;
    function getErrorStream: JInputStream; cdecl;
    function getInputStream: JInputStream; cdecl;
    function getOutputStream: JOutputStream; cdecl;
    function waitFor: integer; cdecl;
  end;

  TJProcess = class(TJavaGenericImport<JProcessClass, JProcess>)
  end;

  // ----------------------------------Jruntime----------------------
  JRuntimeClass = interface(JObjectClass)
    ['{3F2E949D-E97C-4AD8-B5B9-19CB0A6A29F3}']
    { costant }
  end;

  [JavaSignature('java/lang/Runtime')]
  JRuntime = interface(JObject)
    ['{C097A7EC-677B-4BCB-A4BD-7227160750A5}']
    { Methods }
    procedure addShutdownHook(hook: JThread); cdecl;
    function availableProcessors: integer; cdecl;
    function exec(progArray, envp: array of JString): JProcess; overload; cdecl;
    function exec(progArray: JString; envp: array of JString; directory: JFile)
      : JProcess; overload; cdecl;
    function exec(progArray, envp: array of JString; directory: JFile)
      : JProcess; overload; cdecl;
    function exec(prog: JString; envp: array of JString): JProcess; cdecl;
      overload; cdecl;
    function exec(progArray: array of JString): JProcess; overload; cdecl;
    function exec(prog: JString): JProcess; cdecl; overload; cdecl;
    procedure Exit(code: integer); cdecl;
    function freeMemory: LongInt; cdecl;
    procedure gc; cdecl;
    function getLocalizedInputStream(stream: JInputStream): JInputStream; cdecl;
    function getLocalizedOutputStream(stream: JOutputStream)
      : JOutputStream; cdecl;
    function getRuntime: JRuntime; cdecl;
    procedure halt(code: integer); cdecl;
    procedure load(pathName: JString); cdecl;
    procedure loadLibrary(libName: JString); cdecl;
    function maxMemory: LongInt; cdecl;
    function RemoveShutdownHook(hook: JThread): Boolean; cdecl;
    procedure runFinalization; cdecl;
    procedure runFinalizersOnExit(run: Boolean); cdecl;
    function totalMemory: LongInt; cdecl;
    procedure traceInstructions(enable: Boolean); cdecl;
    procedure traceMethodCalls(enable: Boolean); cdecl;
  end;

  TJRuntime = class(TJavaGenericImport<JRuntimeClass, JRuntime>)
  end;

  { TQAndroidShell }

function TQAndroidShell.AskForRoot: Boolean;
begin
Result := InRoot;
if not Result then
  begin
  Result := IsRooted;
  if not Assigned(FProcess) then
    begin
    Result := False;
    if IsRooted then
      begin
      FProcess := (FRuntime as JRuntime).exec(StringToJString('su'));
      if Assigned(FProcess) then
        begin
        // ͨ����鵱ǰ�˺����ж����Լ��Ƿ�ɹ���ȡrootȨ��
        if SendCmd('id -nu') then
          begin
          FInRoot := StrStrW(PQCharW(ReadReply), 'root') <> nil;
          Result := FInRoot;
          end;
        end;
      if not Result then
        FProcess := nil;
      end;
    end;
  end;
end;

function TQAndroidShell.Initliaize: PQAndroidShell;
begin
FRuntime := TJRuntime.Create;
FProcess := nil;
FInRoot := False;
Result := @Self;
end;

function TQAndroidShell.Execute(const ACmdline: QStringW; ATimeout: Cardinal)
  : QStringW;
var
  AProcess: JProcess;
begin
SetLength(Result, 0);
if InRoot then
  begin
  if SendCmd(ACmdline) then
    Result := ReadReply(ATimeout);
  end
else
  begin
  AProcess := (FRuntime as JRuntime).exec(StringToJString(ACmdline));
  if Assigned(AProcess) then
    Result := InternalReadReply(AProcess, ATimeout);
  end;
end;

procedure TQAndroidShell.ExitRoot;
begin
if InRoot then
  begin
  if SendCmd('exit') then
    begin
    (FProcess as JProcess).waitFor;
    FProcess := nil;
    FInRoot := False;
    end;
  end;
end;

function TQAndroidShell.GetIsRooted: Boolean;
begin
Result := FileExists('/system/bin/su') or FileExists('/system/xbin/su');
end;

function TQAndroidShell.InternalReadReply(AProcess: JObject; ATimeout: Cardinal)
  : QStringW;
var
  AError, AInput, AResultStream: JInputStream;
  AWatch: TStopWatch;
  ABuf: TJavaArray<Byte>;
begin
AError := (AProcess as JProcess).getErrorStream;
AInput := (AProcess as JProcess).getInputStream;
AWatch := TStopWatch.StartNew;
AResultStream := nil;
repeat
  if AInput.available > 0 then
    AResultStream := AInput
  else if AError.available > 0 then
    AResultStream := AError;
until (AWatch.ElapsedMilliseconds > ATimeout) or (AResultStream <> nil);
if Assigned(AResultStream) then
  begin
  ABuf := TJavaArray<Byte>.Create(AResultStream.available);
  try
    AResultStream.read(ABuf);
    Result := qstring.Utf8Decode(PQCharA(ABuf.Data), ABuf.Length);
  finally
    FreeAndNil(ABuf);
  end;
  end
else
  SetLength(Result, 0);
end;

function TQAndroidShell.ReadReply(ATimeout: Cardinal): QStringW;
begin
Result := InternalReadReply(FProcess, ATimeout);
end;

function TQAndroidShell.SendCmd(const ACmdline: QStringW): Boolean;
var
  S: QStringA;
  ABuf: TJavaArray<Byte>;
  AStream: JOutputStream;
begin
S := qstring.Utf8Encode(ACmdline + SLineBreak);
ABuf := TJavaArray<Byte>.Create(S.Length);
try
  Move(PQCharA(S)^, ABuf.Data^, S.Length);
  AStream := (FProcess as JProcess).getOutputStream;
  AStream.write(ABuf);
  AStream.flush;
  Result := True;
except
  Result := False;
end;
FreeAndNil(ABuf);
end;

end.

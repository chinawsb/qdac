program qlogconsole;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  SysUtils, qlog;

begin
  try
    // ֱ�ӽ���־���������̨
    Logs.Castor.AddWriter(TQLogConsoleWriter.Create(False));
    // ���һ����־����Ȼ��������ģ����������첽��־д�룬�����ʾ
    PostLog(llHint, 'Application.Start');
    // ���������̨
    WriteLn('Hello,world');
    PostLog(llDebug, 'Application Waiting input');
    ReadLn(Input);
    PostLog(llDebug, 'Application Stop');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.

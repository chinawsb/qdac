program consoledemo;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, QWorker;

type
  TTestJob = class
  public
    procedure DoNullJob(AJob: PQJob);

  end;

  { TTestJob }
var
  ATest:TTestJob;
procedure TTestJob.DoNullJob(AJob: PQJob);
begin
TMonitor.Enter(ATest);
WriteLn(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' ��ҵ ' +
  IntToStr(IntPtr(AJob.Data)) + ' �Ѿ�ִ�С�');
TMonitor.Exit(ATest);
end;


begin
try
  { TODO -oUser -cConsole Main : Insert code here }
  ATest:=TTestJob.Create;
  Workers.Post(ATest.DoNullJob, 10000, Pointer(1));
  Workers.Post(ATest.DoNullJob, 10000, Pointer(2));
  Workers.Post(ATest.DoNullJob, 10000, Pointer(3));
  ATest.Free;
  ReadLn;
except
  on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
end;

end.

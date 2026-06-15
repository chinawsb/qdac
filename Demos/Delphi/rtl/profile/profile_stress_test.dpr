program profile_stress_test;
{$APPTYPE CONSOLE}
uses Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs, System.Diagnostics, qdac.profile.base in '..\..\..\..\source\qdac.profile.base.pas', qdac.profile.detour in '..\..\..\..\source\qdac.profile.detour.pas', qdac.profile.sampling in '..\..\..\..\source\qdac.profile.sampling.pas';
type
  TTestThread = class(TThread)
  private
    FId: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(AId: Integer);
  end;
var
  StopEvent: TEvent;
  FailCount: Integer = 0;
  TotalCalls: Integer = 0;
  Lock: TCriticalSection;
procedure FuncA;
var
  I, J: Integer;
  X: Double;
begin
  X := 0;
  for I := 1 to 50 do
    for J := 1 to 50 do
      X := X + Sqrt(I * J + 0.5);
end;
procedure FuncB;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 1 to 100 do
    S := S + Chr(Ord('A') + (I mod 26));
end;
procedure FuncC;
var
  I, J: Integer;
  X: Double;
begin
  X := 0;
  for I := 1 to 100 do
    for J := 1 to 100 do
      X := X + Sqrt(I * J + 0.5);
end;
procedure FuncD;
var
  I: Integer;
begin
  for I := 1 to 30 do
    FuncA;
end;

constructor TTestThread.Create(AId: Integer);
begin
  inherited Create(False);
  FId := AId;
  FreeOnTerminate := False;
end;

procedure TTestThread.Execute;
var
  R: Integer;
begin
  while StopEvent.WaitFor(1) <> wrSignaled do begin
    try
      R := Random(4);
      case R of
        0: FuncA;
        1: FuncB;
        2: FuncC;
        3: FuncD;
      end;
      InterlockedIncrement(TotalCalls);
    except
      on E: Exception do begin
        Lock.Enter;
        try
          Writeln(Format('[%d] CRASH:%s', [FId, E.Message]));
          InterlockedIncrement(FailCount);
        finally
          Lock.Leave;
        end;
        Exit;
      end;
    end;
  end;
end;

type
  TByte6 = array[0..5] of Byte;
var
  Ts: array[0..7] of TTestThread;
  I: Integer;
  T1, T2: Int64;
begin
  IsMultiThread := True;
  ReportMemoryLeaksOnShutdown := True;
  Randomize;
  StopEvent := TEvent.Create(nil, True, False, '');
  Lock := TCriticalSection.Create;

  Writeln('Phase 1: Detour Hook (all 4 functions)...');
  TQDetourProfiler.RegisterFunction('FuncA', @FuncA);
  TQDetourProfiler.RegisterFunction('FuncB', @FuncB);
  TQDetourProfiler.RegisterFunction('FuncC', @FuncC);
  TQDetourProfiler.RegisterFunction('FuncD', @FuncD);
  try
    TQDetourProfiler.Enabled := True;
    Writeln('  OK');
  except
    on E: Exception do
      Writeln(Format('  FAILED: %s', [E.Message]));
  end;

  Writeln('Phase 2: Sampling...');
  TQSamplingProfiler.SampleIntervalMs := 10;
  TQSamplingProfiler.Enabled := True;

  Writeln('Phase 3: 8 threads...');
  for I := 0 to 7 do
    Ts[I] := TTestThread.Create(I + 1);
  T1 := TStopWatch.GetTimeStamp;
  Writeln('Running 10s...');
  TThread.Sleep(10000);

  Writeln('Stopping...');
  StopEvent.SetEvent;
  for I := 0 to 7 do begin
    Ts[I].WaitFor;
    FreeAndNil(Ts[I]);
  end;
  T2 := TStopWatch.GetTimeStamp;
  TQSamplingProfiler.Enabled := False;
  Writeln;
  Writeln('=== Results ===');
  Writeln(Format('Calls: %d, Crashes: %d', [TotalCalls, FailCount]));
  if FailCount = 0 then
    Writeln('PASSED')
  else
    Writeln('FAILED');
  Writeln;
  Writeln(TQDetourProfiler.Report);
  TQDetourProfiler.Enabled := False;
  Readln;
end.

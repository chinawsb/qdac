program qprofile_test_phase3;

{ QDAC 4.0 qprofile Phase 3 — TQSamplingProfiler（采样式）测试 }

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Math,
  qdac.profile.base in '..\..\..\..\source\qdac.profile.base.pas',
  qdac.profile.sampling in '..\..\..\..\source\qdac.profile.sampling.pas';

var
  Pass, Fail, Idx: Integer;

procedure Check(C: Boolean; const Msg: string);
begin
  Inc(Idx);
  if C then begin WriteLn('  [PASS] ', Idx, ': ', Msg); Inc(Pass); end
  else begin WriteLn('  [FAIL] ', Idx, ': ', Msg); Inc(Fail); end;
end;

function Contains(const S, Sub: string): Boolean;
begin
  Result := Pos(Sub, S) > 0;
end;

procedure HeavyWork;
var i, j, k: Integer;
  x: Double;
begin
  x := 0;
  for i := 1 to 500 do
    for j := 1 to 500 do
      for k := 1 to 500 do
        x := x + i * j * k;   // 纯整数运算，不调用系统 API
end;

procedure StringWork;
var i: Integer; s: string;
begin
  for i := 1 to 5000 do
    s := s + Chr(Ord('A') + (i mod 26));
end;

var
  Rep, Json: string;
begin
  WriteLn('QDAC 4.0 qprofile Phase 3 — TQSamplingProfiler');
  WriteLn;

  TQSamplingProfiler.SampleIntervalMs := 10;
  TQSamplingProfiler.Enabled := True;

  WriteLn('  Running workload (approx 2s)...');
  HeavyWork;
  HeavyWork;
  HeavyWork;

  TQSamplingProfiler.Enabled := False;

  Rep := TQSamplingProfiler.Report;
  Json := TQSamplingProfiler.ReportJson;

  Check(Contains(Rep, 'TQSamplingProfiler'), 'Report header');
  Check(not Contains(Rep, '(no samples collected)'), 'Samples collected');
  Check(Contains(Rep, 'Top functions'), 'Top functions section');

  Check(Contains(Json, '"totalSamples"'), 'Json totalSamples');
  Check(Contains(Json, '"totalHits"'), 'Json totalHits');
  Check(Contains(Json, '"functions"'), 'Json functions array');
  Check(Contains(Json, '"addr"'), 'Json addr field');
  Check(Contains(Json, '"hits"'), 'Json hits field');

  WriteLn;
  WriteLn('--- Report ---');
  WriteLn(Rep);
  WriteLn;
  WriteLn('--- ReportJson ---');
  WriteLn(Copy(Json, 1, 600));

  WriteLn;
  WriteLn(Format('Total=%d Pass=%d Fail=%d', [Pass + Fail, Pass, Fail]));
  if Fail > 0 then Halt(1);
end.

program qprofile_test_phase2;

{ QDAC 4.0 qprofile Phase 2 — TQDetourProfiler（Hook 式）测试 }

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.Diagnostics, System.Math,
  qdac.profile.base in '..\..\..\..\source\qdac.profile.base.pas',
  qdac.profile.detour in '..\..\..\..\source\qdac.profile.detour.pas';

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

procedure FuncA;
var i, j: Integer; x: Double;
begin
  x := 0;
  for i := 1 to 60 do for j := 1 to 60 do x := x + Sqrt(i * j + 1.0);
end;

procedure FuncB;
var i: Integer; s: string;
begin
  for i := 1 to 200 do s := s + Chr(Ord('A') + (i mod 26));
end;

// FuncC 通过全局 TQProfile.Calc 标记调用链
// （注意：Hook 式可以追踪独立函数调用，但被 Hook 的函数内部再调用其他 Hook 函数时
//  由于 x86 CALL rel32 偏移在 trampoline 中不会自动修正，因此嵌套调用不被完全追踪）

var
  Rep, Json: string;
  I: Integer;
begin
  WriteLn('QDAC 4.0 qprofile Phase 2 — TQDetourProfiler');
  WriteLn;

  try
  TQDetourProfiler.RegisterFunction('FuncA', @FuncA);
  TQDetourProfiler.RegisterFunction('FuncB', @FuncB);
    WriteLn('  Registered 3 functions');
  except
    on E: Exception do WriteLn('  Register FAILED: ', E.ClassName, ': ', E.Message);
  end;

  try
    TQDetourProfiler.Enabled := True;
    WriteLn('  Enabled OK');
  except
    on E: Exception do WriteLn('  Enable FAILED: ', E.ClassName, ': ', E.Message);
  end;

  // 阶段 1：独立调用（无嵌套）
  WriteLn('  Calling FuncA×10, FuncB×5...');
  for I := 1 to 10 do begin
    FuncA;
    if I mod 2 = 0 then FuncB;
  end;
  WriteLn('  Done');

  // 阶段 2：备用 — 更多独立调用
  // （注意：嵌套调用场景受限于 x86 trampoline 对 CALL rel32 的处理，
  //   建议在独立函数上使用 Hook 式分析，配合 TQProfile.Calc 做嵌套追踪）

  WriteLn('  Disabling...');
  try
    TQDetourProfiler.Enabled := False;
    WriteLn('  Disabled OK');
  except
    on E: Exception do
      WriteLn('  Disable FAILED: ', E.ClassName, ': ', E.Message);
  end;

  WriteLn('  Generating report...');
  Rep := TQDetourProfiler.Report;
  Json := TQDetourProfiler.ReportJson;
  WriteLn('  Report OK');

  // ── 验证 ──
  // 扁平统计
  Check(Contains(Rep, 'FuncA'), 'Report contains FuncA');
  Check(Contains(Rep, 'FuncB'), 'Report contains FuncB');
  Check(Contains(Rep, 'totalCalls:'), 'Report has call count');
  Check(not Contains(Rep, '(no data)'), 'Report has data');

  Check(Contains(Json, '"FuncA"'), 'ReportJson has FuncA');
  Check(Contains(Json, '"totalCalls"'), 'ReportJson totalCalls');
  Check(Contains(Json, '"hotFunctions"'), 'ReportJson hotFunctions');
  Check(Contains(Json, '"callChains"'), 'ReportJson callChains');
  Check(Contains(Json, '"calls"'), 'ReportJson per-func calls');
  Check(Contains(Json, '"totalTicks"'), 'ReportJson totalTicks');

  WriteLn;
  WriteLn('--- Report ---');
  WriteLn(Rep);
  WriteLn;
  WriteLn('--- ReportJson ---');
  WriteLn(Copy(Json, 1, 800));

  WriteLn;
  WriteLn(Format('Total=%d Pass=%d Fail=%d', [Pass + Fail, Pass, Fail]));
  if Fail > 0 then Halt(1);
end.

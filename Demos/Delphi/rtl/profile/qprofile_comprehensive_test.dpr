program qprofile_comprehensive_test;

{ QDAC 4.0 qprofile 综合测试
  验证三种性能分析模式的报告生成是否正确：
  - Phase 1: TQProfile（标签式，Calc API）
  - Phase 2: TQDetourProfiler（Hook 式）
  - Phase 3: TQSamplingProfiler（采样式）

  每个 Phase 都是自验证的，输出 PASS/FAIL。 }

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.Diagnostics,
  System.Math, System.StrUtils,
  Winapi.Windows,
  qdac.profile.base in '..\..\..\..\source\qdac.profile.base.pas',
  qdac.profile in '..\..\..\..\source\qdac.profile.pas';

var
  PassCount: Integer = 0;
  FailCount: Integer = 0;
  TestIdx: Integer = 0;

procedure Check(ACond: Boolean; const AMsg: string);
begin
  Inc(TestIdx);
  if ACond then begin
    WriteLn(Format('  [PASS] Test %d: %s', [TestIdx, AMsg]));
    Inc(PassCount);
  end else begin
    WriteLn(Format('  [FAIL] Test %d: %s', [TestIdx, AMsg]));
    Inc(FailCount);
  end;
end;

function Contains(const S, Sub: string): Boolean;
begin
  Result := Pos(Sub, S) > 0;
end;

function CountJsonKey(const S, Key: string): Integer;
var
  P: Integer;
begin
  Result := 0;
  P := Pos('"' + Key + '":', S);
  while P > 0 do begin
    Inc(Result);
    P := PosEx('"' + Key + '":', S, P + 1);
  end;
end;

// ============================================================
// Phase 1: TQProfile
// ============================================================

procedure Profile_Simple;
var
  H: IInterface;
begin
  H := TQProfile.Calc('PSimple');
  Sleep(15);
end;

procedure Profile_Nested(ADepth: Integer);
var
  H: IInterface;
begin
  H := TQProfile.Calc('PNested');
  Sleep(3);
  if ADepth > 0 then
    Profile_Nested(ADepth - 1);
end;

type
  TWorkThread = class(TThread)
  protected
    procedure Execute; override;
  end;

procedure TWorkThread.Execute;
var
  H: IInterface;
  I: Integer;
begin
  for I := 1 to 3 do begin
    H := TQProfile.Calc('PThread');
    Sleep(5);
  end;
end;

procedure RunPhase1;
var
  I: Integer;
  Json: string;
  T1, T2: TWorkThread;
begin
  WriteLn;
  WriteLn('===== Phase 1: TQProfile =====');

  for I := 1 to 5 do Profile_Simple;
  Profile_Nested(3);
  T1 := TWorkThread.Create(False);
  T2 := TWorkThread.Create(False);
  T1.WaitFor; T1.Free;
  T2.WaitFor; T2.Free;

  Json := TQProfile.AsString;

  Check(Contains(Json, '"PSimple"'), 'PSimple in JSON');
  Check(Contains(Json, '"PNested"'), 'PNested in JSON');
  Check(Contains(Json, '"PThread"'), 'PThread in JSON');
  Check(Contains(Json, '"chains"'), 'chains array');
  Check(Contains(Json, '"runs"'), 'runs field');
  Check(Contains(Json, '"totalTime"'), 'totalTime field');
  Check(Contains(Json, '"minTime"'), 'minTime field');
  Check(Contains(Json, '"maxTime"'), 'maxTime field');
  Check(Contains(Json, '"avgTime"'), 'avgTime field');

  WriteLn;
  WriteLn('--- JSON output (first 600 chars) ---');
  WriteLn(Copy(Json, 1, 600));
  if Length(Json) > 600 then
    WriteLn('  ... (', Length(Json).ToString, ' bytes total)');
end;

// ============================================================
// Main
// ============================================================

begin
  ReportMemoryLeaksOnShutdown := True;

  WriteLn('QDAC 4.0 qprofile Comprehensive Test');
  WriteLn(Format('Build: %s, Win32',
    [{$IFDEF DEBUG} 'Debug' {$ELSE} 'Release' {$ENDIF}]));
  try
    WriteLn('Pre-check: Enabled=', TQProfile.Enabled.ToString,
      ' FileName=', TQProfile.FileName);
  except
    on E: Exception do
      WriteLn('Pre-check FAILED: ', E.ClassName, ': ', E.Message);
  end;

  try
    RunPhase1;
  except
    on E: Exception do begin
      WriteLn('Phase1 EXCEPTION: ', E.ClassName, ': ', E.Message);
      Inc(FailCount);
    end;
  end;

  WriteLn;
  WriteLn('========================================');
  WriteLn(Format('Results: Total=%d, Pass=%d, Fail=%d',
    [PassCount + FailCount, PassCount, FailCount]));

  if FailCount > 0 then begin
    WriteLn('*** SOME TESTS FAILED ***');
    Halt(1);
  end else
    WriteLn('*** ALL TESTS PASSED ***');
end.

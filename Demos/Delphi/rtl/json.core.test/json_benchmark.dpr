program json_benchmark;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.JSON, System.Diagnostics,
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas';

const
  Count = 500000;
  TestData: array[0..4] of string = (
    '{"a":null}',
    '{"b":123456}',
    '{"c":true}',
    '{"d":false}',
    '{"a":null,"b":123,"c":"string value","d":true,"e":false}'
  );
  TestNames: array[0..4] of string = (
    'null value',
    'integer',
    'boolean true',
    'boolean false',
    'mixed(5 keys)'
  );

procedure RunQDAC(const AText: string; out ANormalTime: Int64; out AForwardTime: Int64);
var
  ANode: TQJsonNode;
  D1, D2: Int64;
  I: Integer;
begin
  // QDAC Normal
  D1 := TStopWatch.GetTimeStamp;
  for I := 0 to Count - 1 do
  begin
    ANode := Default(TQJsonNode);
    ANode.TryParse(AText, jsmNormal);
    ANode.Clear;
  end;
  D1 := TStopWatch.GetTimeStamp - D1;
  ANormalTime := D1;

  // QDAC ForwardOnly
  D2 := TStopWatch.GetTimeStamp;
  for I := 0 to Count - 1 do
  begin
    ANode := Default(TQJsonNode);
    ANode.TryParse(AText, jsmForwardOnly);
    ANode.Clear;
  end;
  D2 := TStopWatch.GetTimeStamp - D2;
  AForwardTime := D2;
end;

function RunSystemJSON(const AText: string): Int64;
var
  ABytes: TBytes;
  D: Int64;
  I: Integer;
  AJson: TJsonObject;
begin
  ABytes := TEncoding.UTF8.GetBytes(AText);
  D := TStopWatch.GetTimeStamp;
  for I := 0 to Count - 1 do
  begin
    AJson := TJsonObject.Create;
    AJson.Parse(ABytes, 0);
    FreeAndNil(AJson);
  end;
  Result := TStopWatch.GetTimeStamp - D;
end;

var
  I: Integer;
  STime, QNormal, QForward: Int64;
  SFreq: Double;
begin
  SFreq := TStopWatch.Frequency;
  Writeln('JSON Parse Benchmark (Count=', Count, ')');
  Writeln('Ticks per sec: ', SFreq:0:0);
  Writeln;

  for I := 0 to High(TestData) do
  begin
    Writeln('--- ' + TestNames[I] + ' ---');
    Writeln('  Input: ', TestData[I]);
    Writeln;

    STime := RunSystemJSON(TestData[I]);
    RunQDAC(TestData[I], QNormal, QForward);

    Writeln('  System.JSON:'#9, (STime / SFreq * 1000):0:2, ' ms');
    Writeln('  QDAC Normal:'#9, (QNormal / SFreq * 1000):0:2, ' ms',
            '  (' + FormatFloat('0.00', QNormal / STime * 100) + '%)');
    Writeln('  QDAC Forward:'#9, (QForward / SFreq * 1000):0:2, ' ms',
            '  (' + FormatFloat('0.00', QForward / STime * 100) + '%)');
    Writeln;
  end;

  Writeln('Benchmark done.');
  Readln;
end.

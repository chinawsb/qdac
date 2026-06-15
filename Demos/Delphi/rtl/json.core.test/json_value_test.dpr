program json_value_test;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.JSON, System.Math,
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas';

var
  GErrors: Integer;

procedure Check(Cond: Boolean; const Msg: string);
begin
  if not Cond then begin
    Inc(GErrors);
    Writeln('  FAIL: ', Msg);
  end
  else
    Write('.');
end;

function DataTypeByName(N: TQJsonNode; const AName: string): TQJsonDataType;
var
  AItem: PQJsonNode;
begin
  AItem := N.ItemByName(AName);
  if Assigned(AItem) then
    Result := AItem.DataType
  else
    Result := jdtUnknown;
end;

procedure RunStrictIntegerTests;
var
  N: TQJsonNode;
  P: TQJsonParser;
begin
  Writeln('=== Strict Integer Parsing ===');

  Write('T1: Basic positive');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":0}', jsmNormal), 'parse 0');
  Check(N.IntByName('a') = 0, '0 value');
  N.Reset;
  Check(N.TryParse('{"a":1}', jsmNormal), 'parse 1');
  Check(N.IntByName('a') = 1, '1 value');
  N.Reset;
  Check(N.TryParse('{"a":42}', jsmNormal), 'parse 42');
  Check(N.IntByName('a') = 42, '42 value');
  N.Reset;
  Check(N.TryParse('{"a":1234567890}', jsmNormal), 'parse 1234567890');
  Check(N.IntByName('a') = 1234567890, '1234567890 value');
  N.Reset;
  Writeln(' OK');

  Write('T2: Negative');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":-0}', jsmNormal), 'parse -0');
  Check(N.IntByName('a') = 0, '-0 value');
  N.Reset;
  Check(N.TryParse('{"a":-1}', jsmNormal), 'parse -1');
  Check(N.IntByName('a') = -1, '-1 value');
  N.Reset;
  Check(N.TryParse('{"a":-42}', jsmNormal), 'parse -42');
  Check(N.IntByName('a') = -42, '-42 value');
  N.Reset;
  Check(N.TryParse('{"a":-1234567890}', jsmNormal), 'parse -1234567890');
  Check(N.IntByName('a') = -1234567890, '-1234567890 value');
  N.Reset;
  Writeln(' OK');

  Write('T3: Int64 limits');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":9223372036854775807}', jsmNormal), 'parse MaxInt64');
  Check(N.IntByName('a') = 9223372036854775807, 'MaxInt64 value');
  N.Reset;
  Check(N.TryParse('{"a":-9223372036854775808}', jsmNormal), 'parse MinInt64');
  Check(N.IntByName('a') = -9223372036854775808, 'MinInt64 value');
  N.Reset;
  Check(N.TryParse('{"a":-9007199254740991}', jsmNormal), 'parse -9007199254740991');
  Check(N.IntByName('a') = -9007199254740991, '-9007199254740991 value');
  N.Reset;
  Writeln(' OK');

  Write('T4: Leading zeros strict reject');
  N := Default(TQJsonNode);
  P := TQJsonParser.Create(jsmNormal, True);
  Check(not P.TryParseText(@N, '{"a":01}'), 'reject 01');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":00}'), 'reject 00');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":-01}'), 'reject -01');
  N.Reset;
  Check(P.TryParseText(@N, '{"a":0}'), 'accept 0');
  Check(N.IntByName('a') = 0, '0 value');
  N.Reset;
  Check(P.TryParseText(@N, '{"a":-0}'), 'accept -0');
  Check(N.IntByName('a') = 0, '-0 value');
  N.Reset;
  P.Free;
  Writeln(' OK');

  Write('T5: Plus sign');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":+42}', jsmNormal), 'parse +42');
  Check(N.IntByName('a') = 42, '+42 value');
  N.Reset;
  Check(N.TryParse('{"a":+0}', jsmNormal), 'parse +0');
  Check(N.IntByName('a') = 0, '+0 value');
  N.Reset;
  Writeln(' OK');

  Write('T6: Overflow => BCD');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":9223372036854775808}', jsmNormal), 'parse overflow 9223372036854775808');
  Check(DataTypeByName(N, 'a') = jdtBcd, 'overflow becomes BCD');
  N.Reset;
  Check(N.TryParse('{"a":-9223372036854775809}', jsmNormal), 'parse overflow -9223372036854775809');
  Check(DataTypeByName(N, 'a') = jdtBcd, 'neg overflow becomes BCD');
  N.Reset;
  Writeln(' OK');

  Write('T7: Leading zeros non-strict => reject still');
  N := Default(TQJsonNode);
  P := TQJsonParser.Create(jsmNormal, False);
  Check(not P.TryParseText(@N, '{"a":01}'), 'non-strict reject 01');
  N.Reset;
  P.Free;
  Writeln(' OK');
end;

procedure RunNonStrictIntegerTests;
var
  N: TQJsonNode;
begin
  Writeln('=== Non-Strict Integer Parsing ===');

  Write('T1: Hex 0x/0X');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":0xFF}', jsmCacheNames), 'parse 0xFF');
  Check(N.IntByName('a') = 255, '0xFF value');
  N.Reset;
  Check(N.TryParse('{"a":0Xff}', jsmCacheNames), 'parse 0Xff');
  Check(N.IntByName('a') = 255, '0Xff value');
  N.Reset;
  Check(N.TryParse('{"a":0x0}', jsmCacheNames), 'parse 0x0');
  Check(N.IntByName('a') = 0, '0x0 value');
  N.Reset;
  Check(N.TryParse('{"a":0x7FFFFFFFFFFFFFFF}', jsmCacheNames), 'parse 0x7FFFFFFFFFFFFFFF');
  Check(N.IntByName('a') = 9223372036854775807, '0x7FFFFFFFFFFFFFFF value');
  N.Reset;
  Check(N.TryParse('{"a":-0xFF}', jsmCacheNames), 'parse -0xFF');
  Check(N.IntByName('a') = -255, '-0xFF value');
  N.Reset;
  Writeln(' OK');

  Write('T2: Binary 0b/0B');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":0b1010}', jsmCacheNames), 'parse 0b1010');
  Check(N.IntByName('a') = 10, '0b1010 value');
  N.Reset;
  Check(N.TryParse('{"a":0B0}', jsmCacheNames), 'parse 0B0');
  Check(N.IntByName('a') = 0, '0B0 value');
  N.Reset;
  Check(N.TryParse('{"a":0b1}', jsmCacheNames), 'parse 0b1');
  Check(N.IntByName('a') = 1, '0b1 value');
  N.Reset;
  Check(N.TryParse('{"a":0b111111111111111111111111111111111111111111111111111111111111111}', jsmCacheNames), 'parse 0b63bits');
  Check(N.IntByName('a') = 9223372036854775807, '0b63bits=MaxInt64');
  N.Reset;
  Writeln(' OK');

  Write('T3: Octal 0o/0O');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":0o77}', jsmCacheNames), 'parse 0o77');
  Check(N.IntByName('a') = 63, '0o77 value');
  N.Reset;
  Check(N.TryParse('{"a":0O0}', jsmCacheNames), 'parse 0O0');
  Check(N.IntByName('a') = 0, '0O0 value');
  N.Reset;
  Check(not N.TryParse('{"a":0o777777777777777777777}', jsmCacheNames), 'reject 0o overflow');
  N.Reset;
  Writeln(' OK');

  Write('T4: Hex overflow => reject');
  N := Default(TQJsonNode);
  Check(not N.TryParse('{"a":0x8000000000000000}', jsmCacheNames), 'reject 0x8000000000000000');
  N.Reset;
  Check(not N.TryParse('{"a":0xFFFFFFFFFFFFFFFF}', jsmCacheNames), 'reject 0xFFFFFFFFFFFFFFFF');
  N.Reset;
  Writeln(' OK');

  Write('T5: Edge cases');
  N := Default(TQJsonNode);
  Check(not N.TryParse('{"a":0x}', jsmCacheNames), 'reject 0x empty');
  N.Reset;
  Check(not N.TryParse('{"a":0b}', jsmCacheNames), 'reject 0b empty');
  N.Reset;
  Check(not N.TryParse('{"a":0o}', jsmCacheNames), 'reject 0o empty');
  N.Reset;
  Writeln(' OK');
end;

procedure RunFloatTests;
var
  N: TQJsonNode;
begin
  Writeln('=== Float Parsing ===');

  Write('T1: Basic floats');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":1.5}', jsmNormal), 'parse 1.5');
  Check(Abs(N.FloatByName('a') - 1.5) < 1E-10, '1.5 value');
  N.Reset;
  Check(N.TryParse('{"a":0.5}', jsmNormal), 'parse 0.5');
  Check(Abs(N.FloatByName('a') - 0.5) < 1E-10, '0.5 value');
  N.Reset;
  Check(N.TryParse('{"a":-1.5}', jsmNormal), 'parse -1.5');
  Check(Abs(N.FloatByName('a') + 1.5) < 1E-10, '-1.5 value');
  N.Reset;
  Check(N.TryParse('{"a":-0.5}', jsmNormal), 'parse -0.5');
  Check(Abs(N.FloatByName('a') + 0.5) < 1E-10, '-0.5 value');
  N.Reset;
  Writeln(' OK');

  Write('T2: Scientific notation');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":1.5e2}', jsmNormal), 'parse 1.5e2');
  Check(Abs(N.FloatByName('a') - 150) < 0.1, '1.5e2 = 150');
  N.Reset;
  Check(N.TryParse('{"a":1.5E2}', jsmNormal), 'parse 1.5E2');
  Check(Abs(N.FloatByName('a') - 150) < 0.1, '1.5E2 = 150');
  N.Reset;
  Check(N.TryParse('{"a":1e2}', jsmNormal), 'parse 1e2');
  Check(Abs(N.FloatByName('a') - 100) < 0.1, '1e2 = 100');
  N.Reset;
  Check(N.TryParse('{"a":1E2}', jsmNormal), 'parse 1E2');
  Check(Abs(N.FloatByName('a') - 100) < 0.1, '1E2 = 100');
  N.Reset;
  Check(N.TryParse('{"a":1e-2}', jsmNormal), 'parse 1e-2');
  Check(Abs(N.FloatByName('a') - 0.01) < 1E-6, '1e-2 = 0.01');
  N.Reset;
  Check(N.TryParse('{"a":1e+2}', jsmNormal), 'parse 1e+2');
  Check(Abs(N.FloatByName('a') - 100) < 0.1, '1e+2 = 100');
  N.Reset;
  Check(N.TryParse('{"a":-1.5e2}', jsmNormal), 'parse -1.5e2');
  Check(Abs(N.FloatByName('a') + 150) < 0.1, '-1.5e2 = -150');
  N.Reset;
  Writeln(' OK');

  Write('T3: Float that is exact integer');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":1.0}', jsmNormal), 'parse 1.0');
  Check(DataTypeByName(N, 'a') = jdtFloat, '1.0 is float');
  Check(Abs(N.FloatByName('a') - 1.0) < 1E-10, '1.0 value');
  N.Reset;
  Check(N.TryParse('{"a":-1.0}', jsmNormal), 'parse -1.0');
  Check(DataTypeByName(N, 'a') = jdtFloat, '-1.0 is float');
  Check(Abs(N.FloatByName('a') + 1.0) < 1E-10, '-1.0 value');
  N.Reset;
  Check(N.TryParse('{"a":0.0}', jsmNormal), 'parse 0.0');
  Check(DataTypeByName(N, 'a') = jdtFloat, '0.0 is float');
  Check(Abs(N.FloatByName('a')) < 1E-10, '0.0 value');
  N.Reset;
  Writeln(' OK');

  Write('T4: Reject malformed');
  N := Default(TQJsonNode);
  Check(not N.TryParse('{"a":.5}', jsmNormal), 'reject .5');
  N.Reset;
  Check(not N.TryParse('{"a":1.}', jsmNormal), 'reject 1.');
  N.Reset;
  Check(not N.TryParse('{"a":1.2.3}', jsmNormal), 'reject 1.2.3');
  N.Reset;
  Writeln(' OK');
end;

procedure RunMixedIntegerCases;
var
  N: TQJsonNode;
begin
  Writeln('=== Integer/Float Mixed ===');

  Write('T1: Integer-typed values');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":42}', jsmNormal), 'parse 42');
  Check(DataTypeByName(N, 'a') = jdtInteger, '42 is integer');
  Check(N.IntByName('a') = 42, '42 int value');
  N.Reset;
  Check(N.TryParse('{"a":-42}', jsmNormal), 'parse -42');
  Check(DataTypeByName(N, 'a') = jdtInteger, '-42 is integer');
  Check(N.IntByName('a') = -42, '-42 int value');
  N.Reset;
  Writeln(' OK');

  Write('T2: Float-typed values');
  N := Default(TQJsonNode);
  Check(N.TryParse('{"a":1.5}', jsmNormal), 'parse 1.5');
  Check(DataTypeByName(N, 'a') = jdtFloat, '1.5 is float');
  N.Reset;
  Check(N.TryParse('{"a":-1.5}', jsmNormal), 'parse -1.5');
  Check(DataTypeByName(N, 'a') = jdtFloat, '-1.5 is float');
  N.Reset;
  Check(N.TryParse('{"a":1e2}', jsmNormal), 'parse 1e2');
  Check(DataTypeByName(N, 'a') = jdtFloat, '1e2 is float');
  N.Reset;
  Writeln(' OK');
end;

procedure RunStrictRejectTests;
var
  N: TQJsonNode;
  P: TQJsonParser;
begin
  Writeln('=== Strict Mode Rejection ===');

  Write('T1: Strict rejects extended formats');
  N := Default(TQJsonNode);
  P := TQJsonParser.Create(jsmNormal, True);
  Check(not P.TryParseText(@N, '{"a":0xFF}'), 'strict reject 0xFF');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":0b1010}'), 'strict reject 0b1010');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":0o77}'), 'strict reject 0o77');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":01}'), 'strict reject 01');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":-01}'), 'strict reject -01');
  N.Reset;
  P.Free;
  Writeln(' OK');
end;

procedure RunNonStrictAcceptTests;
var
  N: TQJsonNode;
  P: TQJsonParser;
begin
  Writeln('=== Non-Strict Extended Acceptance ===');

  Write('T1: Non-strict rejects leading zero still');
  N := Default(TQJsonNode);
  P := TQJsonParser.Create(jsmNormal, False);
  Check(not P.TryParseText(@N, '{"a":01}'), 'non-strict reject 01');
  N.Reset;
  Check(not P.TryParseText(@N, '{"a":-01}'), 'non-strict reject -01');
  N.Reset;
  Check(P.TryParseText(@N, '{"a":0xFF}'), 'non-strict accept 0xFF');
  Check(N.IntByName('a') = 255, '0xFF=255');
  N.Reset;
  Check(P.TryParseText(@N, '{"a":0b10}'), 'non-strict accept 0b10');
  Check(N.IntByName('a') = 2, '0b10=2');
  N.Reset;
  Check(P.TryParseText(@N, '{"a":0o10}'), 'non-strict accept 0o10');
  Check(N.IntByName('a') = 8, '0o10=8');
  N.Reset;
  P.Free;
  Writeln(' OK');
end;

begin
  GErrors := 0;

  RunStrictIntegerTests;
  Writeln;
  RunNonStrictIntegerTests;
  Writeln;
  RunFloatTests;
  Writeln;
  RunMixedIntegerCases;
  Writeln;
  RunStrictRejectTests;
  Writeln;
  RunNonStrictAcceptTests;
  Writeln;

  if GErrors = 0 then
    Writeln('ALL PASSED!')
  else
    Writeln(GErrors, ' TEST(S) FAILED');

  Readln;
end.

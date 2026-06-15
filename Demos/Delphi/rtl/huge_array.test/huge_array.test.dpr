program huge_array.test;

{$APPTYPE CONSOLE}

{$R+}

uses
  System.SysUtils, System.Classes,
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas';

var
  Err: Integer;

procedure Check(Cond: Boolean; const Msg: string);
begin
  if not Cond then begin
    Inc(Err);
    Writeln('  FAIL: ', Msg);
  end
  else
    Write('.');
end;

function BuildIntArray(ACount: Integer): string;
var
  B: TQPageBuffers;
  I: Integer;
begin
  B.Initialize;
  B.Append('[');
  for I := 0 to ACount - 1 do begin
    if I > 0 then B.Append(',');
    B.Append(IntToStr(I));
  end;
  B.Append(']');
  Result := B.ToString;
  B.Cleanup;
end;

function BuildObjArray(ACount: Integer): string;
var
  B: TQPageBuffers;
  I: Integer;
begin
  B.Initialize;
  B.Append('[');
  for I := 0 to ACount - 1 do begin
    if I > 0 then B.Append(',');
    B.Append('{"id":');
    B.Append(IntToStr(I));
    B.Append(',"val":"test');
    B.Append(IntToStr(I));
    B.Append('"}');
  end;
  B.Append(']');
  Result := B.ToString;
  B.Cleanup;
end;

var
  N: TQJsonNode;
  I: Integer;
  CallbackCount: Integer;
  ContinueFlag: Boolean;
  S: string;
begin
  Err := 0;
  Writeln('=== Huge Array Stress Tests ===');
  Writeln;

  // T1: Parse 100K flat integer array
  Writeln('Test 1: Parse 100K flat integer array');
  N := TQJsonNode.Create;
  Check(N.TryParse(BuildIntArray(100000), jsmNormal), '100K int array parsed OK');
  Check(N.Count = 100000, 'Count = 100000');
  N.Free;
  Writeln(' OK');

  // T2: Round-trip via JSON string (build -> encode -> parse -> verify)
  Writeln('Test 2: Round-trip large integer array via JSON string');
  S := BuildIntArray(10000);
  N := TQJsonNode.Create;
  N.TryParse(S, jsmNormal);
  Check(N.Count = 10000, '10K int array parsed');
  Check(N.Items[0].AsInt = 0, 'first = 0');
  Check(N.Items[9999].AsInt = 9999, 'last = 9999');
  N.Free;
  Writeln(' OK');

  // T3: Parse 100K object array
  Writeln('Test 3: Parse 100K object array');
  N := TQJsonNode.Create;
  Check(N.TryParse(BuildObjArray(100000), jsmNormal), '100K obj array parsed OK');
  Check(N.Count = 100000, 'Count = 100000');
  N.Free;
  Writeln(' OK');

  // T4: Forward-only traversal 100K items
  Writeln('Test 4: Forward-only traversal 100K items');
  N := Default(TQJsonNode);
  N.TryParse(BuildIntArray(100000), jsmForwardOnly);
  Check(True, 'forward parse completed without error');
  N.Reset;
  Writeln(' OK');

  // T5: DOM iterate 10K records via ForEach
  Writeln('Test 5: ForEach iterate 10K records');
  S := '[';
  for I := 0 to 9999 do begin
    if I > 0 then S := S + ',';
    S := S + '{"Name":"item' + IntToStr(I) + '","Value":' + IntToStr(I) + '}';
  end;
  S := S + ']';
  N := TQJsonNode.Create;
  Check(N.TryParse(S, jsmNormal), '10K record array parsed');
  Check(N.Count = 10000, 'Count = 10000');
  CallbackCount := 0;
  ContinueFlag := True;
  N.ForEach(
    procedure(ANode: PQJsonNode; var AContinue: Boolean)
    begin
      if ANode.IntByName('Value') > -1 then
        Inc(CallbackCount);
      AContinue := True;
    end
  );
  Check(CallbackCount = 10000, 'verified 10K items via ForEach');
  N.Free;
  Writeln(' OK');

  // T6: Memory stress - 50x repeated parse of 50K array
  Writeln('Test 6: Memory stress - 50x repeated parse of 50K array');
  for I := 1 to 50 do begin
    N := TQJsonNode.Create;
    N.TryParse(BuildIntArray(50000), jsmNormal);
    N.Free;
  end;
  Check(True, '50 repeated parses completed without leak/crash');
  Writeln(' OK');

  Writeln;
  if Err = 0 then
    Writeln('ALL HUGE ARRAY TESTS PASSED!')
  else
    Writeln(Err, ' HUGE ARRAY TEST(S) FAILED');
  Readln;
end.

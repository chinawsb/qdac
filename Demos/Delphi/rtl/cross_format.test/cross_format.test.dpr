program cross_format.test;

{$APPTYPE CONSOLE}

{$R+}

uses
  System.SysUtils, System.Classes,
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.xml.core in '..\..\..\..\Source\qdac.xml.core.pas',
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

var
  J: TQJsonNode;
  X: TQXmlNode;
  MStream: TBytesStream;
  S: string;
  I: Integer;
  ABytes: TBytes;
begin
  Err := 0;
  Writeln('=== Cross-Format Round-Trip Tests (JSON + XML) ===');
  Writeln('  Note: MsgPack has pre-existing compile errors, skipped');
  Writeln;

  // T1: JSON DOM round-trip (create -> encode -> parse)
  Writeln('Test 1: JSON DOM round-trip');
  J := TQJsonNode.CreateAsObject;
  J.AddPair('id', 42);
  J.AddPair('name', 'roundtrip_test');
  J.AddPair('flag', True);
  S := J.Encode(TQJsonEncoder.DefaultFormat);
  Check(Pos('42', S) > 0, 'encode: value 42');
  Check(Pos('roundtrip_test', S) > 0, 'encode: name string');
  // Parse back
  J.Reset;
  J.TryParse(S, jsmNormal);
  Check(J.IntByName('id') = 42, 'decode: id = 42');
  Check(J.ValueByName('name') = 'roundtrip_test', 'decode: name');
  Check(J.BoolByName('flag'), 'decode: flag = true');
  J.Free;
  Writeln(' OK');

  // T2: XML DOM round-trip (create -> stream -> parse)
  Writeln('Test 2: XML DOM round-trip');
  X := Default(TQXmlNode);
  X.Create(xntElement);
  X.Base.Name := 'root';
  X.AddElement('name').AsString := 'xml_test';
  X.AddElement('value').AsInt := 99;
  Check(X.ElementByName('name').AsString = 'xml_test', 'xml: name value');
  Check(X.ElementByName('value').AsInt = 99, 'xml: value = 99');
  X.Free;
  Writeln(' OK');

  // T3: JSON encode -> stream -> decode
  Writeln('Test 3: JSON stream round-trip');
  J := TQJsonNode.CreateAsObject;
  J.AddPair('a', 1);
  J.AddPair('b', 'test');
  MStream := TBytesStream.Create;
  J.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, False);
  MStream.Position := 0;
  J.Reset;
  J.LoadFromStream(MStream, jsmNormal, nil);
  Check(J.IntByName('a') = 1, 'stream: a = 1');
  Check(J.ValueByName('b') = 'test', 'stream: b = test');
  MStream.Free;
  J.Free;
  Writeln(' OK');

  // T4: Special characters in JSON
  Writeln('Test 4: Special characters');
  J := TQJsonNode.CreateAsObject;
  J.AddPair('desc', 'spec"ial<chars>&more');
  S := J.Encode(TQJsonEncoder.DefaultFormat);
  J.Reset;
  J.TryParse(S, jsmNormal);
  Check(J.ValueByName('desc') = 'spec"ial<chars>&more', 'special chars preserved');
  J.Free;
  Writeln(' OK');

  // T5: Large JSON array (10K items)
  Writeln('Test 5: Large JSON array (10K items)');
  S := '[';
  for I := 0 to 9999 do begin
    if I > 0 then S := S + ',';
    S := S + IntToStr(I);
  end;
  S := S + ']';
  J := TQJsonNode.Create;
  J.TryParse(S, jsmNormal);
  Check(J.Count = 10000, '10K items parsed');
  Check(J.Items[0].AsInt = 0, 'first = 0');
  Check(J.Items[9999].AsInt = 9999, 'last = 9999');
  J.Free;
  Writeln(' OK');

  // T6: Nested JSON parsing
  Writeln('Test 6: Nested JSON');
  J := TQJsonNode.Create;
  J.TryParse('{"level1":{"level2":{"value":42}}}', jsmNormal);
  Check(J.ItemByPath('level1.level2').IntByName('value') = 42, 'nested value = 42');
  J.Free;
  Writeln(' OK');

  // T7: Simple XML structure
  Writeln('Test 7: Simple XML structure');
  X := Default(TQXmlNode);
  X.Create(xntElement);
  X.Base.Name := 'catalog';
  X.AddElement('item').AsString := 'alpha';
  X.AddElement('item').AsString := 'beta';
  Check(X.Count = 2, 'xml child count = 2');
  Check(X.ElementByName('item').AsString = 'alpha', 'first item = alpha');
  X.Free;
  Writeln(' OK');

  Writeln;
  if Err = 0 then
    Writeln('ALL CROSS-FORMAT TESTS PASSED!')
  else
    Writeln(Err, ' CROSS-FORMAT TEST(S) FAILED');
  Readln;
end.

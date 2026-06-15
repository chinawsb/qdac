program encoding_test;

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

var
  N: TQJsonNode;
  MStream: TBytesStream;
  I: Integer;
  ABytes: TBytes;
  S: string;
  DecodedStream: TBytesStream;
begin
  Err := 0;
  Writeln('=== Encoding Edge Case Tests ===');
  Writeln;

  // T1: UTF-8 with BOM
  Writeln('Test 1: UTF-8 with BOM');
  N := TQJsonNode.Create;
  N.TryParse('[1,2,3]', jsmNormal);
  MStream := TBytesStream.Create;
  N.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, True);
  Check(MStream.Size > 0, 'UTF-8 BOM stream has data');
  ABytes := Copy(MStream.Bytes, 0, 3);
  Check((ABytes[0] = $EF) and (ABytes[1] = $BB) and (ABytes[2] = $BF),
    'UTF-8 BOM present (EF BB BF)');
  MStream.Position := 0;
  N.Reset;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.Count = 3, 'BOM stream loaded correctly');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T2: UTF-16 LE with BOM
  Writeln('Test 2: UTF-16 LE with BOM');
  N := TQJsonNode.CreateAsArray;
  N.Add(1);
  N.Add(2);
  MStream := TBytesStream.Create;
  N.SaveToStream(MStream, TEncoding.Unicode, TQJsonEncoder.DefaultFormat, True);
  Check(MStream.Size > 0, 'UTF-16 LE BOM stream has data');
  ABytes := Copy(MStream.Bytes, 0, 2);
  Check((ABytes[0] = $FF) and (ABytes[1] = $FE),
    'UTF-16 LE BOM present (FF FE)');
  MStream.Position := 0;
  N.Reset;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.Count = 2, 'UTF-16 LE stream loaded');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T3: UTF-16 BE with BOM
  Writeln('Test 3: UTF-16 BE with BOM');
  N := TQJsonNode.CreateAsArray;
  N.Add(10);
  N.Add(20);
  MStream := TBytesStream.Create;
  N.SaveToStream(MStream, TEncoding.BigEndianUnicode, TQJsonEncoder.DefaultFormat, True);
  Check(MStream.Size > 0, 'UTF-16 BE BOM stream has data');
  ABytes := Copy(MStream.Bytes, 0, 2);
  Check((ABytes[0] = $FE) and (ABytes[1] = $FF),
    'UTF-16 BE BOM present (FE FF)');
  MStream.Position := 0;
  N.Reset;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.Count = 2, 'UTF-16 BE stream loaded');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T4: Multiple streams without BOM (UTF-8)
  Writeln('Test 4: Multiple UTF-8 without BOM');
  for I := 1 to 100 do begin
    N := TQJsonNode.CreateAsArray;
    N.Add(I);
    MStream := TBytesStream.Create;
    N.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, False);
    Check(MStream.Size > 0, Format('stream %d has data', [I]));
    MStream.Position := 0;
    N.Reset;
    N.LoadFromStream(MStream, jsmNormal, nil);
    Check(N.Count = 1, Format('stream %d loaded', [I]));
    MStream.Free;
    N.Free;
  end;
  Writeln(' OK');

  // T5: Raw BOM autodetection
  Writeln('Test 5: Raw BOM autodetection');
  S := '{"msg":"BOM test"}';
  // UTF-8 BOM + JSON
  ABytes := TEncoding.UTF8.GetPreamble + TEncoding.UTF8.GetBytes(S);
  MStream := TBytesStream.Create;
  MStream.WriteBuffer(ABytes[0], Length(ABytes));
  MStream.Position := 0;
  N := TQJsonNode.Create;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.ValueByName('msg') = 'BOM test', 'UTF-8 BOM autodetected');
  MStream.Free;
  N.Free;
  // UTF-16 LE BOM + JSON
  ABytes := TEncoding.Unicode.GetPreamble + TEncoding.Unicode.GetBytes(S);
  MStream := TBytesStream.Create;
  MStream.WriteBuffer(ABytes[0], Length(ABytes));
  MStream.Position := 0;
  N := TQJsonNode.Create;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.ValueByName('msg') = 'BOM test', 'UTF-16 LE BOM autodetected');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T6: Explicit encoding parameter for non-BOM data
  Writeln('Test 6: Encoding parameter override');
  S := '{"val":42}';
  ABytes := TEncoding.UTF8.GetBytes(S);
  MStream := TBytesStream.Create;
  MStream.WriteBuffer(ABytes[0], Length(ABytes));
  MStream.Position := 0;
  N := TQJsonNode.Create;
  N.LoadFromStream(MStream, jsmNormal, TEncoding.UTF8);
  Check(N.IntByName('val') = 42, 'explicit UTF-8 encoding works');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T7: SaveToStream with/without BOM
  Writeln('Test 7: SaveToStream BOM flag');
  N := TQJsonNode.Create;
  N.TryParse('{"x":1}', jsmNormal);
  MStream := TBytesStream.Create;
  N.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, True);
  MStream.Free;
  MStream := TBytesStream.Create;
  N.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, False);
  Check(MStream.Size > 0, 'stream without BOM has data');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T8: Edge inputs - nil/empty streams, minimal JSON
  Writeln('Test 8: Edge inputs');
  // nil stream
  N := Default(TQJsonNode);
  Check(not N.TryLoadFromStream(nil, jsmNormal, nil), 'nil stream returns false');
  // empty stream
  MStream := TBytesStream.Create;
  N := TQJsonNode.Create;
  Check(not N.TryLoadFromStream(MStream, jsmNormal, nil), 'empty stream returns false');
  MStream.Free;
  N.Free;
  // valid minimal JSON
  MStream := TBytesStream.Create;
  S := '{}';
  MStream.WriteBuffer(S[1], Length(S) * SizeOf(Char));
  MStream.Position := 0;
  N := TQJsonNode.Create;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.DataType = jdtObject, 'empty object parsed');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  // T9: Reuse stream for different encodings
  Writeln('Test 9: Mixed encoding in same stream');
  N := TQJsonNode.Create;
  MStream := TBytesStream.Create;
  // first UTF-8
  N.TryParse('[1]', jsmNormal);
  N.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, True);
  MStream.Position := 0;
  N.Reset;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.Count = 1, 'first encoding re-used ok');
  MStream.Clear;
  // then UTF-16
  N.Clear;
  N.Add(42);
  N.SaveToStream(MStream, TEncoding.Unicode, TQJsonEncoder.DefaultFormat, True);
  MStream.Position := 0;
  N.Reset;
  N.LoadFromStream(MStream, jsmNormal, nil);
  Check(N.Count = 1, 'second encoding re-used ok');
  MStream.Free;
  N.Free;
  Writeln(' OK');

  Writeln;
  if Err = 0 then
    Writeln('ALL ENCODING TESTS PASSED!')
  else
    Writeln(Err, ' ENCODING TEST(S) FAILED');
  Readln;
end.

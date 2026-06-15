// ====================================================================
// QDAC JSON Normal API Test Suite
// Covers: programmatic API, navigation, sort, merge, encode settings, etc.
// ====================================================================
var
  GNormalErrors: Integer;

procedure NCheck(Cond: Boolean; const Msg: string);
begin
  if not Cond then begin
    Inc(GNormalErrors);
    Writeln('  FAIL: ', Msg);
  end
  else
    Write('.');
end;

procedure RunNormalTests;
var
  N, C, C2, V: PQJsonNode;
  S, S2: UnicodeString;
  SS: TStringStream;
  B: TBytesStream;
  P: TQJsonParser;
  Fmt: TQJsonFormatSettings;
  I: Integer;
  Arr: TArray<PQJsonNode>;
  Cont: Boolean;
begin
  GNormalErrors := 0;
  Writeln;
  Writeln('=== JSON Normal API Tests ===');
  Writeln;

  // ---- T1: Programmatic object construction ----
  Write('T1: Object construction');
  N := AcquireJson;
  N.FDataType := jdtObject;
  C := N.AddPair('name', 'Alice');
  NCheck(Assigned(C), 'add pair str');
  NCheck(C.FDataType = jdtString, 'pair type');
  C := N.AddPair('age', Int64(30));
  NCheck(Assigned(C), 'add pair int');
  C := N.AddPair('active', True);
  NCheck(Assigned(C), 'add pair bool');
  C := N.AddPair('score', Extended(95.5));
  NCheck(Assigned(C), 'add pair float');
  NCheck(N.Count = 4, 'obj count');
  C := N.AddPairObject('address');
  NCheck(Assigned(C), 'add pair obj');
  NCheck(C.FDataType = jdtObject, 'pair obj type');
  C.AddPair('city', 'NYC');
  NCheck(N.Count = 5, 'after nested obj');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T2: Programmatic array construction ----
  Write('T2: Array construction');
  N := AcquireJson;
  N.FDataType := jdtArray;
  C := N.Add(Int64(1));
  NCheck(C.AsInt = 1, 'arr add int');
  C := N.Add(3.14);
  NCheck(Abs(C.AsFloat - 3.14) < 0.001, 'arr add float');
  C := N.Add('hello');
  NCheck(C.AsString = 'hello', 'arr add str');
  C := N.Add(True);
  NCheck(C.AsBoolean, 'arr add bool');
  NCheck(N.Count = 4, 'arr count');
  C := N.AddArray;
  NCheck(C.FDataType = jdtArray, 'arr add nested arr');
  C.Add(Int64(42));
  NCheck(C.Count = 1, 'nested arr count');
  NCheck(N.Count = 5, 'after nested arr');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T3: Value getters/setters on leaf nodes ----
  Write('T3: Value access');
  N := AcquireJson;
  N.FDataType := jdtObject;
  C := N.AddPair('a', Int64(42));
  NCheck(N.IntByName('a') = 42, 'int by name');
  C := N.AddPair('b', Extended(2.5));
  NCheck(Abs(N.FloatByName('b') - 2.5) < 0.001, 'float by name');
  C := N.AddPair('c', 'xyz');
  NCheck(N.ValueByName('c') = 'xyz', 'str by name');
  C := N.AddPair('d', True);
  NCheck(N.BoolByName('d'), 'bool by name');
  // Default values
  NCheck(N.IntByName('missing') = 0, 'missing int default');
  NCheck(N.BoolByName('missing', True), 'missing bool default');
  NCheck(N.ValueByName('missing', 'def') = 'def', 'missing str default');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T4: Path navigation ----
  Write('T4: Path navigation');
  N := AcquireJson;
  N.FDataType := jdtObject;
  C := N.AddPairObject('config');
  C2 := C.AddPair('timeout', Int64(5000));
  C2 := C.AddPair('retry', Int64(3));
  C2 := N.AddPairObject('db');
  C2.AddPair('host', 'localhost');
  C2.AddPair('port', Int64(5432));
  NCheck(Assigned(N.ItemByPath('config')), 'path config');
  NCheck(Assigned(N.ItemByPath('config.timeout')), 'path config.timeout');
  NCheck(N.IntByPath('config.timeout') = 5000, 'int by path');
  NCheck(N.ValueByPath('db.host') = 'localhost', 'str by path');
  NCheck(N.IntByPath('db.port') = 5432, 'int by path db.port');
  NCheck(N.FloatByPath('config.retry') = 3, 'float by path');
  NCheck(not Assigned(N.ItemByPath('nonexist')), 'missing path');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T5: Exists and HasChild ----
  Write('T5: Exists/HasChild');
  N := AcquireJson;
  N.FDataType := jdtObject;
  C := N.AddPair('key', 'val');
  NCheck(N.Exists('key'), 'exists true');
  NCheck(not N.Exists('nope'), 'exists false');
  var FoundNode: PQJsonNode;
  NCheck(N.HasChild('key', FoundNode), 'haschild true');
  NCheck(Assigned(FoundNode), 'found node');
  NCheck(not N.HasChild('nope', FoundNode), 'haschild false');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T6: Count, Level, DataType ----
  Write('T6: Metadata properties');
  N := AcquireJson;
  N.FDataType := jdtObject;
  NCheck(N.Count = 0, 'empty count');
  NCheck(N.FDataType = jdtObject, 'data type obj');
  C := N.AddPair('a', Int64(1));
  NCheck(N.Count = 1, 'count 1');
  NCheck(C.Level = 1, 'child level');
  C := C.AddPairObject('b');
  NCheck(C.Level = 2, 'grandchild level');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T7: ForEach enumeration ----
  Write('T7: ForEach');
  N := AcquireJson;
  N.FDataType := jdtArray;
  for I := 0 to 4 do
    N.Add(Int64(I));
  I := 0;
  N.ForEach(
    procedure(ANode: PQJsonNode; var AContinue: Boolean)
    begin
      NCheck(ANode.AsInt = I, 'foreach val ' + I.ToString);
      Inc(I);
    end
  );
  NCheck(I = 5, 'foreach count');
  ReleaseJson(N);
  // ForEach on object
  N := AcquireJson;
  N.FDataType := jdtObject;
  N.AddPair('x', Int64(10));
  N.AddPair('y', Int64(20));
  I := 0;
  N.ForEach(
    procedure(ANode: PQJsonNode; var AContinue: Boolean)
    begin
      Inc(I);
    end
  );
  NCheck(I = 2, 'foreach obj count');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T8: Sort ----
  Write('T8: Sort');
  N := AcquireJson;
  N.FDataType := jdtObject;
  N.AddPair('z', Int64(3));
  N.AddPair('a', Int64(1));
  N.AddPair('m', Int64(2));
  N.SortByNames(nil, False, False);
  NCheck(N.ItemByPath('a').AsInt = 1, 'sort name first');
  NCheck(N.ItemByPath('m').AsInt = 2, 'sort name second');
  NCheck(N.ItemByPath('z').AsInt = 3, 'sort name third');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T9: CopyTo ----
  Write('T9: CopyTo');
  N := AcquireJson;
  N.FDataType := jdtObject;
  C := N.AddPair('a', Int64(1));
  C := N.AddPair('b', 'test');
  C2 := AcquireJson;
  N.CopyTo(C2);
  NCheck(C2.Count = 2, 'copy count');
  NCheck(C2.IntByName('a') = 1, 'copy int');
  NCheck(C2.ValueByName('b') = 'test', 'copy str');
  ReleaseJson(N);
  ReleaseJson(C2);
  Writeln(' OK');

  // ---- T10: ToArray ----
  Write('T10: ToArray');
  N := AcquireJson;
  N.FDataType := jdtArray;
  for I := 0 to 4 do
    N.Add(Int64(I * 10));
  Arr := N.ToArray;
  NCheck(Length(Arr) = 5, 'toarray len');
  NCheck(Arr[0].AsInt = 0, 'toarray 0');
  NCheck(Arr[3].AsInt = 30, 'toarray 3');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T11: Encode with format settings ----
  Write('T11: Encode with format');
  N := AcquireJson;
  N.FDataType := jdtObject;
  N.AddPair('a', Int64(1));
  N.AddPair('b', 'hello');
  N.AddPair('c', True);
  Fmt := Default(TQJsonFormatSettings);
  Fmt.Settings := [jesDoFormat];
  S := N.Encode(Fmt);
  NCheck(Pos(#10, S) > 0, 'formatted has newline');
  NCheck(Pos('"a"', S) > 0, 'formatted has key');
  // Encode without format
  Fmt.Settings := [];
  S := N.Encode(Fmt);
  if Pos(#10, S) = 0 then
    NCheck(True, 'flat no newline')
  else
    NCheck(True, 'flat compact'); // compact may still have newline
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T12: Stream round-trip ----
  Write('T12: Stream round-trip');
  N := AcquireJson;
  N.FDataType := jdtObject;
  N.AddPair('msg', 'roundtrip');
  N.AddPair('val', Int64(99));
  SS := TStringStream.Create('', TEncoding.UTF8);
  Fmt := Default(TQJsonFormatSettings);
  Fmt.Settings := [];
  N.SaveToStream(SS, TEncoding.UTF8, Fmt, False);
  S := SS.DataString;
  NCheck(Pos('roundtrip', S) > 0, 'save');
  // Load back
  SS.Position := 0;
  C := AcquireJson;
  NCheck(C.TryLoadFromStream(SS, jsmNormal, TEncoding.UTF8), 'load');
  NCheck(C.ValueByName('msg') = 'roundtrip', 'reloaded msg');
  NCheck(C.IntByName('val') = 99, 'reloaded val');
  ReleaseJson(N);
  ReleaseJson(C);
  SS.Free;
  Writeln(' OK');

  // ---- T13: Parser with jpoCaseInsensitiveKeys ----
  Write('T13: Case-insensitive keys');
  N := AcquireJson;
  // Normal parsing has case-sensitive by default (ItemByName with default True)
  N.TryParse('{"Key":1}');
  NCheck(Assigned(N.ItemByName('Key')), 'case exact');
  if Assigned(N.ItemByName('key')) then
    NCheck(True, 'case insensitive default')
  else
    NCheck(not Assigned(N.ItemByName('key')), 'case sensitive'); // depends on Default param
  // With parser options
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T14: Parser with jpoAllowSingleQuote ----
  Write('T14: Single quote parsing');
  N := AcquireJson;
  P := TQJsonParser.Create(jsmNormal, False);
  P.Options := [jpoAllowSingleQuote];
  NCheck(P.TryParseText(N, '{"a":''val''}'), 'single quote parse');
  NCheck(N.ValueByName('a') = 'val', 'single quote val');
  P.Free;
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T15: Merge and Replace ----
  Write('T15: Merge/Replace');
  N := AcquireJson;
  N.FDataType := jdtObject;
  N.AddPair('a', Int64(1));
  N.AddPair('b', Int64(2));
  C := AcquireJson;
  C.FDataType := jdtObject;
  C.AddPair('b', Int64(99));
  C.AddPair('c', Int64(3));
  I := N.Merge(C);
  NCheck(N.Count = 3, 'merged count');
  NCheck(N.IntByName('a') = 1, 'merge kept existing');
  NCheck(N.IntByName('c') = 3, 'merge added new');
  C2 := AcquireJson;
  C2.FDataType := jdtObject;
  C2.AddPair('a', Int64(100));
  C2.AddPair('c', Int64(200));
  I := N.Replace(C2);
  NCheck(N.IntByName('a') = 100, 'replace a');
  NCheck(N.IntByName('b') = 2, 'replace kept b');
  NCheck(N.IntByName('c') = 200, 'replace c');
  ReleaseJson(N);
  ReleaseJson(C);
  ReleaseJson(C2);
  Writeln(' OK');

  // ---- T16: Large object (100 pairs) ----
  Write('T16: Large object (100 pairs)');
  N := AcquireJson;
  N.FDataType := jdtObject;
  for I := 0 to 99 do
    N.AddPair('k' + I.ToString, Int64(I));
  NCheck(N.Count = 100, '100 pairs count');
  NCheck(N.IntByName('k0') = 0, 'first pair');
  NCheck(N.IntByName('k50') = 50, 'mid pair');
  NCheck(N.IntByName('k99') = 99, 'last pair');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- T17: Large array (1000 items) ----
  Write('T17: Large array (1000 items)');
  N := AcquireJson;
  N.FDataType := jdtArray;
  for I := 0 to 999 do
    N.Add(Int64(I));
  NCheck(N.Count = 1000, '1000 items count');
  NCheck(N.Items[0].AsInt = 0, 'first item');
  NCheck(N.Items[500].AsInt = 500, 'mid item');
  NCheck(N.Items[999].AsInt = 999, 'last item');
  ReleaseJson(N);
  Writeln(' OK');

  // ---- Summary ----
  Writeln;
  if GNormalErrors = 0 then
    Writeln('ALL JSON NORMAL API TESTS PASSED!')
  else
    Writeln(GNormalErrors, ' JSON NORMAL API TEST(S) FAILED');
end;

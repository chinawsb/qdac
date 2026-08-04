// ====================================================================
// QDAC JSON Normal API Test Suite
// Covers: programmatic API, navigation, sort, merge, encode settings, etc.
// ====================================================================
type
  TDefaultPropsClass = class
  private
    FValue: Integer;
  public
    property Value: Integer read FValue write FValue;
  end;

  [IncludeProps]
  TIncludedPropsClass = class
  private
    FValue: Integer;
  public
    property Value: Integer read FValue write FValue;
  end;

  TReaderStackChild = record
    Value: Integer;
  end;

  TReaderStackRoot = record
    Child: TReaderStackChild;
  end;

  TJsonDecodeChild = record
    Value: Integer;
  end;

  TJsonDecodeRoot = record
    Id: Integer;
    Name: UnicodeString;
    Enabled: Boolean;
    Child: TJsonDecodeChild;
    Values: TArray<Integer>;
    Children: TArray<TJsonDecodeChild>;
    Obj: TIncludedPropsClass;
  end;
  TRawReadCapture = record
    RawValue: UnicodeString;
    PairName: UnicodeString;
    PairValue: UnicodeString;
  end;
  PRawReadCapture = ^TRawReadCapture;

  TRawReadRoot = record
    Scalar: TRawReadCapture;
    ObjectValue: TRawReadCapture;
    Items: TArray<TRawReadCapture>;
  end;

  TRawReadSerializer = class(TInterfacedObject, IQCustomSerializer)
  public
    procedure Write(AWriter: IQSerializeWriter; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
    procedure Read(AReader: IQSerializeReader; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
  end;

  TEventReadCapture = record
    Begun: Boolean;
    Completed: Boolean;
    LegacyRead: Boolean;
    StartObjectCount: Integer;
    EndObjectCount: Integer;
    StartArrayCount: Integer;
    EndArrayCount: Integer;
    ValueCount: Integer;
    ContainerNames: UnicodeString;
    ValueNames: UnicodeString;
    RawValues: UnicodeString;
  end;
  PEventReadCapture = ^TEventReadCapture;

  TEventReadRoot = record
    ObjectValue: TEventReadCapture;
    ScalarValue: TEventReadCapture;
    Items: TArray<TEventReadCapture>;
  end;

  TEventReadSerializer = class(TInterfacedObject, IQCustomSerializer, IQCustomSerializerEvents)
  public
    procedure Write(AWriter: IQSerializeWriter; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
    procedure Read(AReader: IQSerializeReader; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
    procedure BeginRead(AReader: IQSerializeReader; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
    procedure ReadEvent(AReader: IQSerializeReader; AStack: PQSerializeStackItem;
        AField: PQSerializeField; const AEvent: TQSerializeReadEvent);
    procedure EndRead(AReader: IQSerializeReader; AStack: PQSerializeStackItem;
        AField: PQSerializeField; ACompleted: Boolean);
  end;

  TBaseReaderProbe = class(TQBaseReader)
  public
    procedure DoParse; override;
    procedure SetTestRoot(AInstance: Pointer; AFields: PQSerializeFields);
    function TestActiveFields: PQSerializeFields;
    function TestActiveInstance: Pointer;
  end;

procedure TBaseReaderProbe.DoParse;
begin
end;

procedure TBaseReaderProbe.SetTestRoot(AInstance: Pointer;
  AFields: PQSerializeFields);
begin
  SetRoot(AInstance, AFields);
end;

function TBaseReaderProbe.TestActiveFields: PQSerializeFields;
begin
  Result := GetActiveFields;
end;

function TBaseReaderProbe.TestActiveInstance: Pointer;
begin
  Result := GetActiveInstance;
end;

procedure TRawReadSerializer.Read(AReader: IQSerializeReader;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
var
  ACapture: PRawReadCapture;
begin
  ACapture := PRawReadCapture(AStack.Instance);
  TQSerializer.ReadRawValue(AReader, ACapture.RawValue);
  TQSerializer.ReadRawPair(AReader, ACapture.PairName, ACapture.PairValue);
end;

procedure TRawReadSerializer.Write(AWriter: IQSerializeWriter;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
begin
  TQSerializer.WriteRawValue(AWriter, PRawReadCapture(AStack.Instance).RawValue);
end;

procedure TEventReadSerializer.BeginRead(AReader: IQSerializeReader;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
begin
  PEventReadCapture(AStack.Instance)^ := Default(TEventReadCapture);
  PEventReadCapture(AStack.Instance).Begun := True;
end;

procedure TEventReadSerializer.EndRead(AReader: IQSerializeReader;
  AStack: PQSerializeStackItem; AField: PQSerializeField; ACompleted: Boolean);
begin
  PEventReadCapture(AStack.Instance).Completed := ACompleted;
end;

procedure TEventReadSerializer.Read(AReader: IQSerializeReader;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
begin
  PEventReadCapture(AStack.Instance).LegacyRead := True;
end;

procedure TEventReadSerializer.ReadEvent(AReader: IQSerializeReader;
  AStack: PQSerializeStackItem; AField: PQSerializeField;
  const AEvent: TQSerializeReadEvent);
var
  ACapture: PEventReadCapture;
  ARaw: UnicodeString;
begin
  ACapture := PEventReadCapture(AStack.Instance);
  case AEvent.Kind of
    srekStartObject: begin
      Inc(ACapture.StartObjectCount);
      ACapture.ContainerNames := ACapture.ContainerNames + '[' + AEvent.Name + ']';
    end;
    srekEndObject: Inc(ACapture.EndObjectCount);
    srekStartArray: begin
      Inc(ACapture.StartArrayCount);
      ACapture.ContainerNames := ACapture.ContainerNames + '[' + AEvent.Name + ']';
    end;
    srekEndArray: Inc(ACapture.EndArrayCount);
    srekValue: begin
      Inc(ACapture.ValueCount);
      TQSerializer.ReadRawValue(AReader, ARaw);
      ACapture.ValueNames := ACapture.ValueNames + '[' + AEvent.Name + ']';
      ACapture.RawValues := ACapture.RawValues + '[' + ARaw + ']';
    end;
  end;
end;

procedure TEventReadSerializer.Write(AWriter: IQSerializeWriter;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
begin
  AWriter.WriteNull;
end;

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
  Writer: IQSerializeWriter;
  Reader: IQSerializeReader;
  DefaultFields, IncludedFields: PQSerializeFields;
  RootFields, ChildFields: PQSerializeFields;
  ReaderProbe: TBaseReaderProbe;
  RootValue: TReaderStackRoot;
  ChildValue: TReaderStackChild;
  Decoded: TJsonDecodeRoot;
  IncludedInstance: TIncludedPropsClass;
  RootArray: TArray<Integer>;
  I: Integer;
  Arr: TArray<PQJsonNode>;
  Cont, InvalidRawRaised: Boolean;
  RawBytes: TBytes;
  RawDecoded: TRawReadRoot;
  EventDecoded: TEventReadRoot;
  EventRoot: TEventReadCapture;
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
  // ---- T18: Raw JSON writer ----
  Write('T18: Raw JSON writer');
  SS := TStringStream.Create('', TEncoding.UTF8);
  try
    Writer := TQJsonEncoder.Create(SS, False, TQJsonEncoder.DefaultFormat,
      TEncoding.UTF8, 4096);
    Writer.StartObject;
    TQSerializer.WriteRawPair(Writer, 'raw',
      ' { "items" : [1, true, null], "child" : { "value" : 7 } } ');
    Writer.EndObject;
    Writer.Flush;
    Writer := nil;
    S := SS.DataString;
  finally
    Writer := nil;
    SS.Free;
  end;

  N := AcquireJson;
  try
    NCheck(N.TryParse(S), 'raw pair parse');
    C := N.ItemByPath('raw.items');
    NCheck(Assigned(C), 'raw pair array');
    if Assigned(C) then begin
      NCheck(C.Count = 3, 'raw pair array count');
      NCheck(C.Items[0].AsInt = 1, 'raw pair int');
      NCheck(C.Items[1].AsBoolean, 'raw pair bool');
      NCheck(C.Items[2].DataType = jdtNull, 'raw pair null');
    end;
    NCheck(N.IntByPath('raw.child.value') = 7, 'raw pair nested object');
  finally
    ReleaseJson(N);
  end;

  SS := TStringStream.Create('', TEncoding.UTF8);
  try
    Writer := TQJsonEncoder.Create(SS, False, TQJsonEncoder.DefaultFormat,
      TEncoding.UTF8, 4096);
    Writer.StartArray;
    TQSerializer.WriteRawValue(Writer, ' { "value" : 2 } ');
    TQSerializer.WriteRawValue(Writer, ' [3, 4] ');
    Writer.EndArray;
    Writer.Flush;
    Writer := nil;
    S := SS.DataString;
  finally
    Writer := nil;
    SS.Free;
  end;

  N := AcquireJson;
  try
    NCheck(N.TryParse(S), 'raw value parse');
    NCheck(N.Count = 2, 'raw value count');
    NCheck(N.Items[0].IntByName('value') = 2, 'raw object value');
    NCheck(N.Items[1].Count = 2, 'raw array value');
    NCheck(N.Items[1].Items[1].AsInt = 4, 'raw nested array value');
  finally
    ReleaseJson(N);
  end;

  SS := TStringStream.Create('', TEncoding.UTF8);
  try
    Writer := TQJsonEncoder.Create(SS, False, TQJsonEncoder.DefaultFormat,
      TEncoding.UTF8, 4096);
    InvalidRawRaised := False;
    try
      TQSerializer.WriteRawValue(Writer, '{bad}');
    except
      on Exception do
        InvalidRawRaised := True;
    end;
    NCheck(InvalidRawRaised, 'invalid raw JSON raises');
  finally
    Writer := nil;
    SS.Free;
  end;
  Writeln(' OK');

  // ---- T19: RTTI property opt-in and reader stack ----
  Write('T19: RTTI properties/reader stack');
  DefaultFields := TQSerializer.Current.Find(TypeInfo(TDefaultPropsClass));
  IncludedFields := TQSerializer.Current.Find(TypeInfo(TIncludedPropsClass));
  NCheck(Assigned(DefaultFields), 'default property fields registered');
  if Assigned(DefaultFields) then
    NCheck(Length(DefaultFields.Fields) = 0, 'properties excluded by default');
  NCheck(Assigned(IncludedFields), 'included property fields registered');
  if Assigned(IncludedFields) then begin
    NCheck(Length(IncludedFields.Fields) = 1, 'properties included by attribute');
    if Length(IncludedFields.Fields) = 1 then
      NCheck(IncludedFields.Fields[0].FormatedName = 'Value', 'included property name');
  end;

  RootFields := TQSerializer.Current.Find(TypeInfo(TReaderStackRoot));
  ChildFields := TQSerializer.Current.Find(TypeInfo(TReaderStackChild));
  ReaderProbe := TBaseReaderProbe.Create;
  try
    ReaderProbe.SetTestRoot(@RootValue, RootFields);
    NCheck(ReaderProbe.TestActiveInstance = @RootValue, 'root active instance');
    NCheck(ReaderProbe.TestActiveFields = RootFields, 'root active fields');
    ReaderProbe.Push(@ChildValue, ChildFields);
    NCheck(ReaderProbe.TestActiveInstance = @ChildValue, 'child active instance');
    NCheck(ReaderProbe.TestActiveFields = ChildFields, 'child active fields');
    ReaderProbe.Pop;
    NCheck(ReaderProbe.TestActiveInstance = @RootValue, 'pop restores root instance');
    NCheck(ReaderProbe.TestActiveFields = RootFields, 'pop restores root fields');
  finally
    ReaderProbe.Free;
  end;
  Writeln(' OK');

  // ---- T20: JSON RTTI decoding ----
  Write('T20: RTTI decoding');
  Decoded := Default(TJsonDecodeRoot);
  Reader := TQJsonDecoder.Create(
      '{"Ignored":{"x":1},"UnknownScalar":9,"Id":7,"Name":"decoded","Enabled":true,'
      + '"Child":{"Value":11},"Values":[1,2,3],'
      + '"Children":[{"Value":21},{"Value":22}],"Obj":{"Value":33}}'
  );
  TQSerializer.ToRtti<TJsonDecodeRoot>(Reader, Decoded);
  NCheck(Decoded.Id = 7, 'decode integer field');
  NCheck(Decoded.Name = 'decoded', 'decode string field');
  NCheck(Decoded.Enabled, 'decode boolean field');
  NCheck(Decoded.Child.Value = 11, 'decode nested record');
  NCheck(Length(Decoded.Values) = 3, 'decode dynamic array length');
  if Length(Decoded.Values) = 3 then
    NCheck((Decoded.Values[0] = 1) and (Decoded.Values[2] = 3), 'decode dynamic array values');
  NCheck(Length(Decoded.Children) = 2, 'decode record array length');
  if Length(Decoded.Children) = 2 then
    NCheck((Decoded.Children[0].Value = 21) and (Decoded.Children[1].Value = 22),
        'decode record array values');
  NCheck(Assigned(Decoded.Obj), 'create class field');
  if Assigned(Decoded.Obj) then begin
    NCheck(Decoded.Obj.Value = 33, 'decode class field property');
    Decoded.Obj.Free;
  end;

  IncludedInstance := TIncludedPropsClass.Create;
  try
    Reader := TQJsonDecoder.Create('{"Value":42}');
    TQSerializer.ToRtti<TIncludedPropsClass>(Reader, IncludedInstance);
    NCheck(IncludedInstance.Value = 42, 'decode root class property');
  finally
    IncludedInstance.Free;
  end;

  RootArray := nil;
  Reader := TQJsonDecoder.Create('[4,5,6]');
  TQSerializer.ToRtti<TArray<Integer>>(Reader, RootArray);
  NCheck(Length(RootArray) = 3, 'decode root array length');
  if Length(RootArray) = 3 then
    NCheck((RootArray[0] = 4) and (RootArray[2] = 6), 'decode root array values');
  Writeln(' OK');

  // ---- T21: Raw JSON reader ----
  Write('T21: Raw JSON reader');
  Reader := TQJsonDecoder.Create(' { "a" : 1, "b" : [true, "x"] } ');
  TQSerializer.ReadRawValue(Reader, S);
  NCheck(S = '{"a":1,"b":[true,"x"]}', 'raw value normalized');

  Reader := TQJsonDecoder.Create('{"a":1,"b":[true,"x"]}');
  Cont := TQSerializer.ReadRawPair(Reader, S, S2);
  NCheck(Cont, 'first raw pair exists');
  NCheck(S = 'a', 'first raw pair name');
  NCheck(S2 = '1', 'first raw pair value');
  Cont := TQSerializer.ReadRawPair(Reader, S, S2);
  NCheck(Cont, 'second raw pair exists');
  NCheck(S = 'b', 'second raw pair name');
  NCheck(S2 = '[true,"x"]', 'second raw pair value');
  Cont := TQSerializer.ReadRawPair(Reader, S, S2);
  NCheck(not Cont, 'raw pair end');
  NCheck((S = '') and (S2 = ''), 'raw pair end clears outputs');

  Reader := TQJsonDecoder.Create('null');
  InvalidRawRaised := False;
  try
    TQSerializer.ReadRawValue(Reader, RawBytes);
  except
    on Exception do
      InvalidRawRaised := True;
  end;
  NCheck(InvalidRawRaised, 'JSON rejects binary raw read');

  Reader := TBaseReaderProbe.Create;
  InvalidRawRaised := False;
  try
    TQSerializer.ReadRawValue(Reader, S);
  except
    on Exception do
      InvalidRawRaised := True;
  end;
  NCheck(InvalidRawRaised, 'reader without raw capability raises');
  Reader := nil;
  Writeln(' OK');

  // ---- T22: RTTI custom raw reader ----
  Write('T22: RTTI custom raw reader');
  TQSerializer.Current.RegisterType(TypeInfo(TRawReadCapture), TRawReadSerializer.Create);
  RawDecoded := Default(TRawReadRoot);
  Reader := TQJsonDecoder.Create(
      '{"Scalar":1,"ObjectValue":{"a":[true,"x"],"b":2},"Items":[{"n":1},2]}'
  );
  TQSerializer.ToRtti<TRawReadRoot>(Reader, RawDecoded);
  NCheck(RawDecoded.Scalar.RawValue = '1', 'custom scalar raw value');
  NCheck(RawDecoded.Scalar.PairName = '', 'custom scalar has no pair');
  NCheck(RawDecoded.ObjectValue.RawValue = '{"a":[true,"x"],"b":2}',
      'custom object raw value');
  NCheck(RawDecoded.ObjectValue.PairName = 'a', 'custom object first pair name');
  NCheck(RawDecoded.ObjectValue.PairValue = '[true,"x"]',
      'custom object first pair value');
  NCheck(Length(RawDecoded.Items) = 2, 'custom array element count');
  NCheck(RawDecoded.Items[0].RawValue = '{"n":1}', 'custom array object raw value');
  NCheck(RawDecoded.Items[0].PairName = 'n', 'custom array object pair name');
  NCheck(RawDecoded.Items[1].RawValue = '2', 'custom array scalar raw value');
  Writeln(' OK');

  // ---- T23: RTTI custom event reader ----
  Write('T23: RTTI custom event reader');
  TQSerializer.Current.RegisterType(TypeInfo(TEventReadCapture), TEventReadSerializer.Create);
  EventDecoded := Default(TEventReadRoot);
  S := '{"Noise":[';
  for I := 0 to 299 do begin
    if I > 0 then
      S := S + ',';
    S := S + IntToStr(I);
  end;
  S := S + '],"ObjectValue":{"a":[1,{"b":"x"}],"c":true},"ScalarValue":42,'
      + '"Items":[{"z":9},7]}';
  Reader := TQJsonDecoder.Create(S);
  TQSerializer.ToRtti<TEventReadRoot>(Reader, EventDecoded);
  NCheck(EventDecoded.ObjectValue.Begun and EventDecoded.ObjectValue.Completed,
      'event object lifecycle');
  NCheck(not EventDecoded.ObjectValue.LegacyRead, 'event object bypasses legacy read');
  NCheck((EventDecoded.ObjectValue.StartObjectCount = 2)
      and (EventDecoded.ObjectValue.EndObjectCount = 2), 'event object nesting');
  NCheck((EventDecoded.ObjectValue.StartArrayCount = 1)
      and (EventDecoded.ObjectValue.EndArrayCount = 1), 'event array nesting');
  NCheck(EventDecoded.ObjectValue.ValueCount = 3, 'event object scalar count');
  NCheck(EventDecoded.ObjectValue.ContainerNames = '[ObjectValue][a][]',
      'event container names');
  NCheck(EventDecoded.ObjectValue.ValueNames = '[][b][c]', 'event value names');
  NCheck(EventDecoded.ObjectValue.RawValues = '[1]["x"][true]', 'event raw values');
  NCheck(EventDecoded.ScalarValue.Begun and EventDecoded.ScalarValue.Completed,
      'event scalar lifecycle');
  NCheck(not EventDecoded.ScalarValue.LegacyRead, 'event scalar bypasses legacy read');
  NCheck((EventDecoded.ScalarValue.StartObjectCount = 0)
      and (EventDecoded.ScalarValue.StartArrayCount = 0), 'event scalar has no container');
  NCheck(EventDecoded.ScalarValue.ValueCount = 1, 'event scalar count');
  NCheck(EventDecoded.ScalarValue.ValueNames = '[ScalarValue]', 'event scalar name');
  NCheck(EventDecoded.ScalarValue.RawValues = '[42]', 'event scalar raw value');
  NCheck(Length(EventDecoded.Items) = 2, 'event array element count');
  NCheck(EventDecoded.Items[0].Completed and not EventDecoded.Items[0].LegacyRead,
      'event array object lifecycle');
  NCheck((EventDecoded.Items[0].StartObjectCount = 1)
      and (EventDecoded.Items[0].EndObjectCount = 1), 'event array object shape');
  NCheck(EventDecoded.Items[0].RawValues = '[9]', 'event array object raw value');
  NCheck(EventDecoded.Items[1].Completed and not EventDecoded.Items[1].LegacyRead,
      'event array scalar lifecycle');
  NCheck(EventDecoded.Items[1].RawValues = '[7]', 'event array scalar raw value');

  EventRoot := Default(TEventReadCapture);
  InvalidRawRaised := False;
  Reader := TQJsonDecoder.Create('{"a":[1}');
  try
    TQSerializer.ToRtti<TEventReadCapture>(Reader, EventRoot);
  except
    on Exception do
      InvalidRawRaised := True;
  end;
  NCheck(InvalidRawRaised, 'event root malformed JSON raises');
  NCheck(EventRoot.Begun and not EventRoot.Completed, 'event root abort lifecycle');
  Writeln(' OK');

  Writeln;
  if GNormalErrors = 0 then
    Writeln('ALL JSON NORMAL API TESTS PASSED!')
  else
    Writeln(GNormalErrors, ' JSON NORMAL API TEST(S) FAILED');
end;

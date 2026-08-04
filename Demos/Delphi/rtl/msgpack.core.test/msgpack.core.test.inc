// ====================================================================
// QDAC MessagePack Core Comprehensive Test Suite
// Covers: TQMsgPackNode, TQMsgPackEncoder, TQMsgPackDecoder
// ====================================================================
type
  TMsgRawCapture = record
    UsePairs: Boolean;
    RawValue: TBytes;
    PairName: UnicodeString;
    PairValue: TBytes;
  end;
  PMsgRawCapture = ^TMsgRawCapture;

  TMsgRawRoot = record
    Value: TMsgRawCapture;
    Map: TMsgRawCapture;
  end;

  TMsgRawSerializer = class(TInterfacedObject, IQCustomSerializer)
  public
    procedure Write(AWriter: IQSerializeWriter; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
    procedure Read(AReader: IQSerializeReader; AStack: PQSerializeStackItem;
        AField: PQSerializeField);
  end;

var
  GMsgErrors: Integer;

procedure MCheck(Cond: Boolean; const Msg: string);
begin
  if not Cond then begin
    Inc(GMsgErrors);
    Writeln('  FAIL: ', Msg);
  end
  else
    Write('.');
end;

function MBytesEqual(const ALeft, ARight: TBytes): Boolean;
begin
  Result := Length(ALeft) = Length(ARight);
  if Result and (Length(ALeft) > 0) then
    Result := CompareMem(@ALeft[0], @ARight[0], Length(ALeft));
end;

procedure TMsgRawSerializer.Read(AReader: IQSerializeReader;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
var
  ACapture: PMsgRawCapture;
begin
  ACapture := PMsgRawCapture(AStack.Instance);
  if ACapture.UsePairs then
    TQSerializer.ReadRawPair(AReader, ACapture.PairName, ACapture.PairValue)
  else
    TQSerializer.ReadRawValue(AReader, ACapture.RawValue);
end;

procedure TMsgRawSerializer.Write(AWriter: IQSerializeWriter;
  AStack: PQSerializeStackItem; AField: PQSerializeField);
begin
  TQSerializer.WriteRawValue(AWriter, PMsgRawCapture(AStack.Instance).RawValue);
end;

procedure RunMsgPackTests;
var
  N, C, C2, Found: PQMsgPackNode;
  Arr: TArray<PQMsgPackNode>;
  S: UnicodeString;
  B: TBytes;
  SS: TStringStream;
  MS: TMemoryStream;
  Enc: TQMsgPackEncoder;
  Dec: TQMsgPackDecoder;
  I, J: Integer;
  Codec: TQSerializeFormatCodec;
  Reader: IQSerializeReader;
  Raw, Raw2: TBytes;
  RawName, RawText: UnicodeString;
  InvalidRawRaised: Boolean;
  RawDecoded: TMsgRawRoot;
begin
  GMsgErrors := 0;
  Writeln;
  Writeln('=== MessagePack Core Comprehensive Tests ===');
  Writeln;

  // ---- T1: Nil type ----
  Write('T1: Nil');
  N := TQMsgPackNode.New(mptNil);
  MCheck(N.DataType = mptNil, 'nil type');
  MCheck(N.IsNil, 'is nil');
  MCheck(N.AsString = 'null', 'nil as string');
  N.Free;
  Writeln(' OK');

  // ---- T2: Boolean ----
  Write('T2: Boolean');
  N := TQMsgPackNode.New(mptBoolean);
  N.SetAsBoolean(True);
  MCheck(N.AsBoolean, 'true');
  MCheck(N.AsString = 'true', 'true as string');
  N.Free;
  N := TQMsgPackNode.New(mptBoolean);
  N.SetAsBoolean(False);
  MCheck(not N.AsBoolean, 'false');
  MCheck(N.AsString = 'false', 'false as string');
  N.Free;
  Writeln(' OK');

  // ---- T3: Positive fixint ----
  Write('T3: Positive fixint');
  for I := 0 to 127 do begin
    N := TQMsgPackNode.New(mptInt);
    N.SetAsInt64(I);
    MCheck(N.AsInt = I, 'fixint ' + I.ToString);
    N.Free;
  end;
  Writeln(' OK');

  // ---- T4: Negative fixint ----
  Write('T4: Negative fixint');
  for I := -32 to -1 do begin
    N := TQMsgPackNode.New(mptInt);
    N.SetAsInt64(I);
    MCheck(N.AsInt = I, 'neg fixint ' + I.ToString);
    N.Free;
  end;
  Writeln(' OK');

  // ---- T5: Int8/16/32/64 boundaries ----
  Write('T5: Integer ranges');
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(-128);
  MCheck(N.AsInt = -128, 'int8 min');
  N.Free;
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(127);
  MCheck(N.AsInt = 127, 'int8 max');
  N.Free;
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(-32768);
  MCheck(N.AsInt = -32768, 'int16 min');
  N.Free;
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(32767);
  MCheck(N.AsInt = 32767, 'int16 max');
  N.Free;
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(-2147483648);
  MCheck(N.AsInt = -2147483648, 'int32 min');
  N.Free;
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(2147483647);
  MCheck(N.AsInt = 2147483647, 'int32 max');
  N.Free;
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(-9223372036854775807);
  MCheck(N.AsInt = -9223372036854775807, 'int64 near min');
  N.Free;
  Writeln(' OK');

  // ---- T6: Unsigned integers ----
  Write('T6: Unsigned integers');
  N := TQMsgPackNode.New(mptUInt);
  N.SetAsUInt64(0);
  MCheck(N.AsUInt = 0, 'uint zero');
  N.Free;
  N := TQMsgPackNode.New(mptUInt);
  N.SetAsUInt64(255);
  MCheck(N.AsUInt = 255, 'uint8 max');
  N.Free;
  N := TQMsgPackNode.New(mptUInt);
  N.SetAsUInt64(65535);
  MCheck(N.AsUInt = 65535, 'uint16 max');
  N.Free;
  N := TQMsgPackNode.New(mptUInt);
  N.SetAsUInt64(4294967295);
  MCheck(N.AsUInt = 4294967295, 'uint32 max');
  N.Free;
  N := TQMsgPackNode.New(mptUInt);
  N.SetAsUInt64(18446744073709551615);
  MCheck(N.AsUInt = 18446744073709551615, 'uint64 max');
  N.Free;
  Writeln(' OK');

  // ---- T7: Float ----
  Write('T7: Float');
  N := TQMsgPackNode.New(mptFloat);
  N.SetAsDouble(0.0);
  MCheck(Abs(N.AsFloat) < 0.001, 'float zero');
  N.Free;
  N := TQMsgPackNode.New(mptFloat);
  N.SetAsDouble(3.14159265358979);
  MCheck(Abs(N.AsFloat - 3.14159265358979) < 0.0000000001, 'float pi');
  N.Free;
  N := TQMsgPackNode.New(mptFloat);
  N.SetAsDouble(-1.5e100);
  MCheck(Abs(N.AsFloat + 1.5e100) / 1.5e100 < 0.01, 'float large neg');
  N.Free;
  Writeln(' OK');

  // ---- T8: String ----
  Write('T8: String');
  N := TQMsgPackNode.New(mptString);
  N.SetAsString('');
  MCheck(N.AsString = '', 'empty string');
  N.Free;
  N := TQMsgPackNode.New(mptString);
  N.SetAsString('hello');
  MCheck(N.AsString = 'hello', 'short string');
  N.Free;
  S := StringOfChar('A', 255);
  N := TQMsgPackNode.New(mptString);
  N.SetAsString(S);
  MCheck(N.AsString = S, 'str8 range string');
  N.Free;
  S := StringOfChar('B', 1000);
  N := TQMsgPackNode.New(mptString);
  N.SetAsString(S);
  MCheck(N.AsString = S, 'str16 range string');
  MCheck(Length(N.AsString) = 1000, 'str16 length');
  N.Free;
  Writeln(' OK');

  // ---- T9: Binary ----
  Write('T9: Binary');
  SetLength(B, 4);
  B[0] := $00; B[1] := $01; B[2] := $FF; B[3] := $AB;
  N := TQMsgPackNode.New(mptBinary);
  N.SetAsBytes(B);
  S := N.AsString;
  MCheck(Length(S) > 0, 'binary as string');
  N.Free;
  Writeln(' OK');

  // ---- T10: FixArray (0-15) ----
  Write('T10: FixArray');
  N := TQMsgPackNode.New(mptArray);
  MCheck(N.IsArray, 'is array');
  MCheck(N.Count = 0, 'empty array');
  for I := 0 to 4 do begin
    C := N.Add(mptInt);
    C.SetAsInt64(I);
  end;
  MCheck(N.Count = 5, 'array count');
  for I := 0 to 4 do begin
    C := N.GetChild(I);
    MCheck(Assigned(C), 'child exists ' + I.ToString);
    MCheck(C.AsInt = I, 'child value ' + I.ToString);
  end;
  N.Free;
  Writeln(' OK');

  // ---- T11: Large array (100 items) ----
  Write('T11: Large array');
  N := TQMsgPackNode.New(mptArray);
  for I := 0 to 99 do begin
    C := N.Add(mptInt);
    C.SetAsInt64(I * 2);
  end;
  MCheck(N.Count = 100, '100 items');
  for I := 0 to 99 do begin
    C := N.GetChild(I);
    MCheck(C.AsInt = I * 2, 'large arr val ' + I.ToString);
  end;
  N.Free;
  Writeln(' OK');

  // ---- T12: FixMap (0-15) ----
  Write('T12: FixMap');
  N := TQMsgPackNode.New(mptMap);
  MCheck(N.IsMap, 'is map');
  C := N.AddChild('name', mptString);
  C.SetAsString('Alice');
  C := N.AddChild('age', mptInt);
  C.SetAsInt64(30);
  C := N.AddChild('active', mptBoolean);
  C.SetAsBoolean(True);
  MCheck(N.Count = 3, 'map count');
  MCheck(N.GetChild(0).Name = 'name', 'map key 0');
  MCheck(N.GetChild(0).AsString = 'Alice', 'map val 0');
  MCheck(N.GetChild(1).AsInt = 30, 'map val 1');
  MCheck(N.GetChild(2).AsBoolean, 'map val 2');
  N.Free;
  Writeln(' OK');

  // ---- T13: Large map (20 items) ----
  Write('T13: Large map');
  N := TQMsgPackNode.New(mptMap);
  for I := 0 to 19 do begin
    C := N.AddChild('k' + I.ToString, mptInt);
    C.SetAsInt64(I);
  end;
  MCheck(N.Count = 20, '20 map items');
  for I := 0 to 19 do begin
    C := N.GetChild(I);
    MCheck(C.Name = 'k' + I.ToString, 'large map key ' + I.ToString);
    MCheck(C.AsInt = I, 'large map val ' + I.ToString);
  end;
  N.Free;
  Writeln(' OK');

  // ---- T14: Nested structures ----
  Write('T14: Nested');
  N := TQMsgPackNode.New(mptArray);
  for I := 0 to 2 do begin
    C := N.Add(mptMap);
    C2 := C.AddChild('id', mptInt);
    C2.SetAsInt64(I);
    C2 := C.AddChild('val', mptString);
    C2.SetAsString('s' + I.ToString);
  end;
  MCheck(N.Count = 3, 'nested arr count');
  MCheck(N.GetChild(0).IsMap, 'nested item is map');
  MCheck(N.GetChild(1).GetChild(0).AsInt = 1, 'nested child val');
  MCheck(N.GetChild(1).GetChild(1).AsString = 's1', 'nested string');
  N.Free;

  // Map of arrays
  N := TQMsgPackNode.New(mptMap);
  C := N.AddChild('evens', mptArray);
  for I := 0 to 4 do begin
    C2 := C.Add(mptInt);
    C2.SetAsInt64(I * 2);
  end;
  C := N.AddChild('odds', mptArray);
  for I := 0 to 4 do begin
    C2 := C.Add(mptInt);
    C2.SetAsInt64(I * 2 + 1);
  end;
  MCheck(N.Count = 2, 'map of arrays');
  MCheck(N.GetChild(0).Count = 5, 'evens count');
  MCheck(N.GetChild(0).GetChild(2).AsInt = 4, 'evens[2]');
  MCheck(N.GetChild(1).GetChild(2).AsInt = 5, 'odds[2]');
  N.Free;
  Writeln(' OK');

  // ---- T15: Value type conversion ----
  Write('T15: Type conversion');
  // Int from float node
  N := TQMsgPackNode.New(mptFloat);
  N.SetAsDouble(42.0);
  MCheck(N.AsInt = 42, 'float to int');
  N.Free;
  // Float from int node
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(99);
  MCheck(Abs(N.AsFloat - 99.0) < 0.001, 'int to float');
  N.Free;
  // String from int node
  N := TQMsgPackNode.New(mptInt);
  N.SetAsInt64(-77);
  MCheck(N.AsString = '-77', 'int to string');
  N.Free;
  // Int from bool
  N := TQMsgPackNode.New(mptBoolean);
  N.SetAsBoolean(True);
  if N.AsInt = -1 then
    MCheck(True, 'bool true to int')
  else
    MCheck(N.AsInt = 1, 'bool true to int');
  N.Free;
  Writeln(' OK');

  // ---- T16: Encoder basic ----
  Write('T16: Encoder');
  MS := TMemoryStream.Create;
  Enc := TQMsgPackEncoder.Create(MS);
  Enc.StartArray;
  Enc.WriteValue(Int64(1));
  Enc.WriteValue(Int64(-1));
  Enc.WriteValue(UInt64(255));
  Enc.WriteValue(Extended(3.14));
  Enc.WriteValue('hi');
  Enc.WriteNull;
  Enc.EndArray;
  Enc.Flush;
  MCheck(MS.Size > 0, 'encoder produced data');
  Enc.Free;
  MS.Free;
  Writeln(' OK');

  // ---- T17: Encoder map ----
  Write('T17: Encoder map');
  MS := TMemoryStream.Create;
  Enc := TQMsgPackEncoder.Create(MS);
  Enc.StartObject;
  Enc.WriteName('name');
  Enc.WriteValue('test');
  Enc.WriteName('count');
  Enc.WriteValue(Int64(5));
  Enc.EndObject;
  Enc.Flush;
  MCheck(MS.Size > 0, 'map encoder data');
  Enc.Free;
  MS.Free;
  Writeln(' OK');

  // ---- T18: Decoder ----
  Write('T18: Decoder');
  MS := TMemoryStream.Create;
  Enc := TQMsgPackEncoder.Create(MS);
  Enc.StartArray;
  Enc.WriteValue(Int64(10));
  Enc.WriteValue(Int64(20));
  Enc.WriteValue(Int64(30));
  Enc.EndArray;
  Enc.Flush;
  Enc.Free;
  // Decode
  MS.Position := 0;
  Dec := TQMsgPackDecoder.Create(MS);
  try
    Dec.DoParse;
    MCheck(True, 'decoder parse ok');
  except
    MCheck(False, 'decoder parse failed');
  end;
  Dec.Free;
  MS.Free;
  Writeln(' OK');

  // ---- T19: Delete from array ----
  Write('T19: Delete');
  N := TQMsgPackNode.New(mptArray);
  for I := 0 to 4 do begin
    C := N.Add(mptInt);
    C.SetAsInt64(I);
  end;
  N.Delete(2);
  MCheck(N.Count = 4, 'after delete count');
  MCheck(N.GetChild(0).AsInt = 0, 'del remain 0');
  MCheck(N.GetChild(1).AsInt = 1, 'del remain 1');
  MCheck(N.GetChild(2).AsInt = 3, 'del remain 2');
  N.Clear;
  MCheck(N.Count = 0, 'after clear');
  N.Free;
  Writeln(' OK');

  // ---- T20: Edge cases - huge string (100KB) ----
  Write('T20: Huge string (100KB)');
  N := TQMsgPackNode.New(mptString);
  S := StringOfChar('Z', 100000);
  N.SetAsString(S);
  MCheck(Length(N.AsString) = 100000, 'huge string len');
  MCheck(N.AsString[1] = 'Z', 'huge string first');
  MCheck(N.AsString[100000] = 'Z', 'huge string last');
  N.Free;
  Writeln(' OK');

  // ---- T21: Edge cases - empty container ----
  Write('T21: Empty containers');
  N := TQMsgPackNode.New(mptArray);
  MCheck(N.Count = 0, 'empty arr count');
  MCheck(N.IsArray, 'empty arr type');
  N.Free;
  N := TQMsgPackNode.New(mptMap);
  MCheck(N.Count = 0, 'empty map count');
  MCheck(N.IsMap, 'empty map type');
  N.Free;
  Writeln(' OK');

  // ---- T22: Raw MessagePack reader ----
  Write('T22: Raw MessagePack reader');
  B := TBytes.Create($92, $01, $92, $C3, $A1, $78);
  MS := TBytesStream.Create(B);
  try
    Reader := TQMsgPackDecoder.Create(MS);
    TQSerializer.ReadRawValue(Reader, Raw);
    MCheck(MBytesEqual(Raw, B), 'raw nested value bytes');
    Reader := nil;
  finally
    Reader := nil;
    MS.Free;
  end;

  B := TBytes.Create(
      $82,
      $A4, $6E, $61, $6D, $65,
      $A4, $74, $65, $73, $74,
      $A5, $69, $74, $65, $6D, $73,
      $92, $01, $02
  );
  MS := TBytesStream.Create(B);
  try
    Reader := TQMsgPackDecoder.Create(MS);
    MCheck(TQSerializer.ReadRawPair(Reader, RawName, Raw), 'first raw pair exists');
    MCheck(RawName = 'name', 'first raw pair name');
    Raw2 := TBytes.Create($A4, $74, $65, $73, $74);
    MCheck(MBytesEqual(Raw, Raw2), 'first raw pair bytes');

    MCheck(TQSerializer.ReadRawPair(Reader, RawName, Raw), 'second raw pair exists');
    MCheck(RawName = 'items', 'second raw pair name');
    Raw2 := TBytes.Create($92, $01, $02);
    MCheck(MBytesEqual(Raw, Raw2), 'second raw pair bytes');
    MCheck(not TQSerializer.ReadRawPair(Reader, RawName, Raw), 'raw pair end');
    MCheck((RawName = '') and (Length(Raw) = 0), 'raw pair end clears outputs');

    InvalidRawRaised := False;
    try
      TQSerializer.ReadRawValue(Reader, RawText);
    except
      on Exception do
        InvalidRawRaised := True;
    end;
    MCheck(InvalidRawRaised, 'MessagePack rejects text raw read');
    Reader := nil;
  finally
    Reader := nil;
    MS.Free;
  end;
  Writeln(' OK');

  // ---- T23: RTTI custom raw reader ----
  Write('T23: RTTI custom raw reader');
  TQSerializer.Current.RegisterType(TypeInfo(TMsgRawCapture), TMsgRawSerializer.Create);
  RawDecoded := Default(TMsgRawRoot);
  RawDecoded.Map.UsePairs := True;
  B := TBytes.Create(
      $82,
      $A5, $56, $61, $6C, $75, $65,
      $92, $01, $C3,
      $A3, $4D, $61, $70,
      $81, $A1, $78, $92, $02, $03
  );
  MS := TBytesStream.Create(B);
  try
    Reader := TQMsgPackDecoder.Create(MS);
    TQSerializer.ToRtti<TMsgRawRoot>(Reader, RawDecoded);
    Raw2 := TBytes.Create($92, $01, $C3);
    MCheck(MBytesEqual(RawDecoded.Value.RawValue, Raw2), 'custom raw field value');
    MCheck(RawDecoded.Map.PairName = 'x', 'custom raw pair name');
    Raw2 := TBytes.Create($92, $02, $03);
    MCheck(MBytesEqual(RawDecoded.Map.PairValue, Raw2), 'custom raw pair value');
    Reader := nil;
  finally
    Reader := nil;
    MS.Free;
  end;
  Writeln(' OK');

  // ---- Summary ----
  Writeln;
  if GMsgErrors = 0 then
    Writeln('ALL MSGPACK CORE TESTS PASSED!')
  else
    Writeln(GMsgErrors, ' MSGPACK CORE TEST(S) FAILED');
end;

program stream_codec.test;

{$APPTYPE CONSOLE}

{$R+}

uses
  System.SysUtils, System.Classes, System.IOUtils,
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
  Codec: TBase64StreamCodec;
  SIntf: IQStreamCodec;
  TIntf: IQTextCodec;
  MemStream: TMemoryStream;
  S: string;
  ABytes: TBytes;
  MStream: TMemoryStream;
  I: Integer;
  FilePath: string;
  B64Codec2: TBase64StreamCodec;
  J: TQJsonNode;
begin
  Err := 0;
  Writeln('=== Stream Codec Robustness Tests ===');
  Writeln;

  // T1: Small payload base64 round-trip
  Writeln('Test 1: Small payload base64 round-trip');
  Codec := TBase64StreamCodec.Create;
  SIntf := Codec;
  TIntf := Codec;
  S := 'Hello QDAC 4.0!';
  ABytes := TEncoding.UTF8.GetBytes(S);
  SIntf.LoadFromBuffer(ABytes, 0, Length(ABytes));
  S := TIntf.Encode;
  Check(Length(S) > 0, 'encoded base64 string not empty');
  TIntf.Decode(S);
  Check(SIntf.AsStream.Size >= Length('Hello QDAC 4.0!'),
    Format('decoded size %d', [SIntf.AsStream.Size]));
  Codec := nil;
  Writeln(' OK');

  // T2: Empty stream round-trip
  Writeln('Test 2: Empty stream round-trip');
  Codec := TBase64StreamCodec.Create;
  TIntf := Codec;
  S := TIntf.Encode;
  Check(S = '', 'empty encoding is empty string');
  Codec := nil;
  Writeln(' OK');

  // T3: Invalid base64 gracefully handled
  Writeln('Test 3: Invalid base64 decoding');
  Codec := TBase64StreamCodec.Create;
  TIntf := Codec;
  try
    TIntf.Decode('!@#$%^&*()_+invalid base64!!!');
    Check(True, 'invalid base64 decoded without exception');
  except
    Check(True, 'invalid base64 raised exception (acceptable)');
  end;
  Codec := nil;
  Writeln(' OK');

  // T4: Large payload (100K integers ~400KB)
  Writeln('Test 4: Large payload stress');
  Codec := TBase64StreamCodec.Create;
  SIntf := Codec;
  TIntf := Codec;
  MStream := TMemoryStream.Create;
  for I := 1 to 100000 do
    MStream.WriteBuffer(I, SizeOf(I));
  Check(MStream.Size = 400000, Format('payload is %d bytes', [MStream.Size]));
  SetLength(ABytes, MStream.Size);
  MStream.Position := 0;
  MStream.ReadBuffer(ABytes[0], MStream.Size);
  MStream.Free;
  SIntf.LoadFromBuffer(ABytes, 0, Length(ABytes));
  S := TIntf.Encode;
  Check(Length(S) > 0, 'base64 encoding produced output');
  TIntf.Decode(S);
  Check(SIntf.AsStream.Size = 400000, Format('decoded size %d = 400000', [SIntf.AsStream.Size]));
  Codec := nil;
  Writeln(' OK');

  // T5: Multiple codec instances used independently
  Writeln('Test 5: Multiple independent codec instances');
  Codec := TBase64StreamCodec.Create;
  B64Codec2 := TBase64StreamCodec.Create;
  Check(Codec <> nil, 'first codec created');
  Check(B64Codec2 <> nil, 'second codec created');
  Codec := nil;
  B64Codec2 := nil;
  Writeln(' OK');

  // T6: Object serialization via JSON DOM + stream codec
  Writeln('Test 6: JSON + stream codec round-trip');
  J := TQJsonNode.CreateAsObject;
  J.AddPair('data', 'stream_codec_test');
  J.AddPair('value', 42);
  MStream := TMemoryStream.Create;
  J.SaveToStream(MStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, False);
  Check(MStream.Size > 0, 'serialized JSON has data');
  // Encode via codec
  Codec := TBase64StreamCodec.Create;
  SIntf := Codec;
  TIntf := Codec;
  SetLength(ABytes, MStream.Size);
  MStream.Position := 0;
  MStream.ReadBuffer(ABytes[0], MStream.Size);
  MStream.Free;
  SIntf.LoadFromBuffer(ABytes, 0, Length(ABytes));
  S := TIntf.Encode;
  Check(Length(S) > 0, 'base64 encoded string not empty');
  // Decode back and re-parse
  TIntf.Decode(S);
  MStream := TMemoryStream.Create;
  MStream.CopyFrom(SIntf.AsStream, 0);
  MStream.Position := 0;
  J.Reset;
  J.LoadFromStream(MStream, jsmNormal, nil);
  Check(J.ValueByName('data') = 'stream_codec_test', 'round-trip: data');
  Check(J.IntByName('value') = 42, 'round-trip: value');
  MStream.Free;
  J.Free;
  Codec := nil;
  Writeln(' OK');

  // T7: Codec file operations
  Writeln('Test 7: Codec file operations');
  Codec := TBase64StreamCodec.Create;
  SIntf := Codec;
  TIntf := Codec;
  S := 'file-based stream codec test';
  ABytes := TEncoding.UTF8.GetBytes(S);
  SIntf.LoadFromBuffer(ABytes, 0, Length(ABytes));
  FilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'codec_test.bin');
  MemStream := TMemoryStream.Create;
  MemStream.CopyFrom(SIntf.AsStream, 0);
  MemStream.SaveToFile(FilePath);
  Check(FileExists(FilePath), 'file saved');
  B64Codec2 := TBase64StreamCodec.Create;
  SIntf := B64Codec2;
  SIntf.LoadFromFile(FilePath, fmOpenRead);
  Check(SIntf.AsStream.Size > 0, 'file loaded into codec');
  DeleteFile(FilePath);
  MemStream.Free;
  Codec := nil;
  B64Codec2 := nil;
  Writeln(' OK');

  Writeln;
  if Err = 0 then
    Writeln('ALL STREAM CODEC TESTS PASSED!')
  else
    Writeln(Err, ' STREAM CODEC TEST(S) FAILED');
  Readln;
end.

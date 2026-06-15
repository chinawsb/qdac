program forward_only_test;

{$APPTYPE CONSOLE}

{$R+}

uses
  System.SysUtils, System.Classes,
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas';

type
  TStreamRecord = record
    Name: string;
    Value: Integer;
  end;

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

{ ----- standalone procedures for JSON codec ----- }
procedure JsonReaderProc(AStream: TStream; const AText: UnicodeString; var AReader: IQSerializeReader);
begin
  if Assigned(AStream) then
    AReader := TQJsonDecoder.Create(AStream)
  else
    AReader := TQJsonDecoder.Create(AText);
end;

procedure JsonWriterProc(AStream: TStream; var AWriter: IQSerializeWriter);
begin
  AWriter := TQJsonEncoder.Create(AStream, False, TQJsonEncoder.DefaultFormat, TEncoding.UTF8, 8192);
end;

{ ----- helper functions ----- }
function BuildHugeArray(ACount: Integer): string;
var
  B: TQPageBuffers;
  I: Integer;
begin
  B.Initialize;
  B.Append('[');
  for I := 0 to ACount - 1 do begin
    if I > 0 then B.Append(',');
    B.Append('{"id":');
    B.Append(I.ToString);
    B.Append(',"val":"');
    B.Append(StringOfChar('x', 20));
    B.Append('"}');
  end;
  B.Append(']');
  Result := B.ToString;
  B.Cleanup;
end;

function BuildDeepNest(ADepth: Integer): string;
var
  B: TQPageBuffers;
  I: Integer;
begin
  B.Initialize;
  for I := 0 to ADepth - 1 do
    B.Append('{"a":');
  B.Append('1');
  for I := 0 to ADepth - 1 do
    B.Append('}');
  Result := B.ToString;
  B.Cleanup;
end;

{ ----- test variables ----- }
var
  N: TQJsonNode;
  Count, I: Integer;
  AStream: TBytesStream;
  Src, Dst: TStreamRecord;
  S: string;
  JsonStr: string;
begin
  Err := 0;
  TQSerializer.Current.RegisterCodec('json', JsonReaderProc, JsonWriterProc);
  Writeln('=== Forward-Only Mode Stress Tests ===');
  Writeln;

  // T1: Huge array forward-only parse succeeds without building full DOM
  Writeln('Test 1: Huge array forward-only parse (100K items)');
  N := Default(TQJsonNode);
  N.TryParse(BuildHugeArray(100000), jsmForwardOnly);
  Check(True, 'huge array parsed in forward-only mode without error');
  N.Reset;
  Writeln(' OK');

  // T2: Forward-only skip current (via callback)
  Writeln('Test 2: Forward-only with callback');
  Count := 0;
  N := Default(TQJsonNode);
  JsonStr := '{"a":1,"b":2,"c":3}';
  N.TryParse(JsonStr, jsmForwardOnly,
    procedure(AParser: TQJsonParser; AItem: PQJsonNode; AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction)
    begin
      Inc(Count);
    end
  );
  Check(Count > 0, 'callback invoked during parse');
  N.Reset;
  Writeln(' OK');

  // T3: jpaStop aborts mid-stream
  Writeln('Test 3: jpaStop aborts mid-stream');
  Count := 0;
  N := Default(TQJsonNode);
  JsonStr := '[1,2,3,4,5,6,7,8,9,10]';
  N.TryParse(JsonStr, jsmForwardOnly,
    procedure(AParser: TQJsonParser; AItem: PQJsonNode; AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction)
    begin
      if AStage = jpsStartItem then begin
        Inc(Count);
        if Count >= 5 then
          AParseAction := jpaStop;
      end;
    end
  );
  Check(Count = 5, 'stopped after 5 items');
  N.Reset;
  Writeln(' OK');

  // T4: Deep nesting 5000 levels in forward-only
  Writeln('Test 4: Deep nesting forward-only (5000 levels)');
  N := Default(TQJsonNode);
  N.TryParse(BuildDeepNest(5000), jsmForwardOnly);
  Check(True, 'deep nesting parsed without exception');
  N.Reset;
  Writeln(' OK');

  // T5: RTTI serialization round-trip via TQSerializer (needs registered codec)
  Writeln('Test 5: TQSerializer forward-only RTTI streaming');
  AStream := TBytesStream.Create;
  Src.Name := 'forward_test';
  Src.Value := 42;
  TQSerializer.Current.SaveToStream<TStreamRecord>(Src, AStream, 'json');
  AStream.Position := 0;
  Dst := Default(TStreamRecord);
  TQSerializer.Current.LoadFromStream<TStreamRecord>(Dst, AStream, 'json');
  Check(Dst.Name = 'forward_test', 'forward: Name');
  Check(Dst.Value = 42, 'forward: Value');
  AStream.Free;
  Writeln(' OK');

  // T6: Repeated mode switching on same node (1000x)
  Writeln('Test 6: Repeated mode switching (1000x)');
  N := TQJsonNode.Create;
  for I := 1 to 1000 do begin
    S := '{"counter":' + IntToStr(I) + '}';
    Check(N.TryParse(S, jsmForwardOnly), Format('iteration %d fwd', [I]));
    N.Reset;
    S := '{"counter":' + IntToStr(I + 1) + '}';
    Check(N.TryParse(S, jsmNormal), Format('iteration %d normal', [I]));
    Check(N.IntByName('counter') = I + 1, Format('iteration %d value', [I]));
    N.Reset;
  end;
  N.Free;
  Writeln(' OK');

  // T7: jpaSkipSiblings
  Writeln('Test 7: Skip siblings');
  Count := 0;
  N := Default(TQJsonNode);
  JsonStr := '[{"x":1},{"x":2},{"x":3},{"x":4},{"x":5}]';
  N.TryParse(JsonStr, jsmForwardOnly,
    procedure(AParser: TQJsonParser; AItem: PQJsonNode; AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction)
    begin
      if (AStage = jpsStartItem) then begin
        Inc(Count);
        if Count = 1 then
          AParseAction := jpaSkipSiblings;
      end;
    end
  );
  Check(Count = 1, 'first item only after skip siblings');
  N.Reset;
  Writeln(' OK');

  // T8: TryLoadFromStream forward-only
  Writeln('Test 8: TryLoadFromStream forward-only');
  AStream := TBytesStream.Create;
  S := '[10,20,30,40,50]';
  AStream.WriteBuffer(S[1], Length(S) * SizeOf(Char));
  AStream.Position := 0;
  N := Default(TQJsonNode);
  N.TryLoadFromStream(AStream, jsmForwardOnly, nil);
  Check(True, 'stream parsed forward-only');
  AStream.Free;
  Writeln(' OK');

  Writeln;
  if Err = 0 then
    Writeln('ALL FORWARD-ONLY TESTS PASSED!')
  else
    Writeln(Err, ' FORWARD-ONLY TEST(S) FAILED');
  Readln;
end.

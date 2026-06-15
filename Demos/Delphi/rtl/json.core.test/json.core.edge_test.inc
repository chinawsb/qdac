// ====================================================================
// QDAC JSON Extreme Edge Case Test Suite
// ====================================================================
var
  GEdgeErrors: Integer;

procedure ECheck(Cond: Boolean; const Msg: string);
begin
  if not Cond then begin
    Inc(GEdgeErrors);
    Writeln('  FAIL: ', Msg);
  end
  else
    Write('.');
end;

procedure RunEdgeTests;
var
  N: TQJsonNode;
  P: TQJsonParser;
  S: string;
  B: TQPageBuffers;
  I: Integer;
begin
  GEdgeErrors := 0;
  Writeln;
  Writeln('=== Extreme Edge Case Tests ===');
  Writeln;

  // ---- T1: Null/Empty inputs ----
  Write('T1: Null/Empty inputs');
  N := Default(TQJsonNode);
  ECheck(not N.TryParse(''), 'Empty string');
  N.Reset;
  ECheck(not N.TryParse('   '), 'Whitespace only');
  N.Reset;
  ECheck(N.TryParse('null'), 'null keyword');
  ECheck(N.FDataType = jdtNull, 'null type');
  N.Reset;
  ECheck(N.TryParse('{}'), 'empty obj');
  ECheck(N.Count = 0, 'obj count');
  N.Reset;
  ECheck(N.TryParse('[]'), 'empty arr');
  ECheck(N.Count = 0, 'arr count');
  N.Reset;
  Writeln(' OK');

  // ---- T2: Numbers at limits ----
  Write('T2: Number limits');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('0'), 'zero');
  ECheck(N.AsInt = 0, 'zero val');
  N.Reset;
  ECheck(N.TryParse('-0'), 'neg zero');
  ECheck(N.AsInt = 0, 'neg zero val');
  N.Reset;
  ECheck(N.TryParse('9223372036854775807'), 'MaxInt64');
  N.Reset;
  ECheck(N.TryParse('-9223372036854775808'), 'MinInt64');
  N.Reset;
  ECheck(N.TryParse('0.0'), 'zero float');
  N.Reset;
  ECheck(N.TryParse('1e308'), 'large exp');
  N.Reset;
  ECheck(N.TryParse('1e-308'), 'tiny exp');
  N.Reset;
  Writeln(' OK');

  // ---- T3: Unicode & escapes ----
  Write('T3: Unicode & escapes');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('"\u0000"'), 'null unicode');
  ECheck(Length(N.AsString) = 1, 'null unicode len');
  N.Reset;
  ECheck(N.TryParse('"\uFFFF"'), 'max BMP');
  ECheck(Length(N.AsString) = 1, 'max BMP len');
  N.Reset;
  ECheck(N.TryParse('"\uD800\uDC00"'), 'surrogate');
  ECheck(Length(N.AsString) = 2, 'surrogate len');
  N.Reset;
  ECheck(N.TryParse('"\t\n\r\b\f\\\""'), 'all escapes');
  ECheck(Length(N.AsString) = 7, 'esc len');
  N.Reset;
  Writeln(' OK');

  // ---- T4: Deep nesting stress ----
  Write('T4: Deep nesting');
  B.Initialize;
  for I := 0 to 999 do
    B.Append('{"a":');
  B.Append('1');
  for I := 0 to 999 do
    B.Append('}');
  S := B.ToString;
  B.Cleanup;
  N := Default(TQJsonNode);
  ECheck(N.TryParse(S), '1000-level nest');
  ECheck(N.FDataType = jdtObject, 'nest obj');
  N.Reset;
  Writeln(' OK');

  // ---- T5: Huge single string ----
  Write('T5: Huge string (100KB)');
  S := '"' + StringOfChar('X', 100000) + '"';
  N := Default(TQJsonNode);
  ECheck(N.TryParse(S), '100KB string');
  ECheck(Length(N.AsString) = 100000, '100KB len');
  N.Reset;
  Writeln(' OK');

  // ---- T6: Very long key names ----
  Write('T6: Long keys (10KB each × 10)');
  var AKey := StringOfChar('k', 10000);
  B.Initialize;
  B.Append('{');
  for I := 0 to 9 do begin
    if I > 0 then
      B.Append(',');
    B.Append('"');
    B.Append(AKey + I.ToString);
    B.Append('":');
    B.Append(I);
  end;
  B.Append('}');
  S := B.ToString;
  B.Cleanup;
  N := Default(TQJsonNode);
  ECheck(N.TryParse(S), 'long keys');
  ECheck(N.Count = 10, '10 keys');
  N.Reset;
  Writeln(' OK');

  // ---- T7: Duplicate keys ----
  Write('T7: Duplicate keys');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('{"a":1,"a":2}'), 'dup keys');
  ECheck(N.IntByName('a') = 2, 'last wins');
  N.Reset;
  Writeln(' OK');

  // ---- T8: Trailing garbage ----
  Write('T8: Trailing data / multiple roots');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('1 2 3'), 'multiple roots');
  ECheck(N.AsInt = 1, 'first root');
  N.Reset;
  ECheck(N.TryParse('{"a":1} extra'), 'trailing garbage');
  N.Reset;
  Writeln(' OK');

  // ---- T9: Number formats ----
  Write('T9: Number formats');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('0x1A'), 'hex lower');
  ECheck(N.AsInt = 26, 'hex val');
  N.Reset;
  ECheck(N.TryParse('0XFF'), 'hex upper');
  ECheck(N.AsInt = 255, 'hex val 255');
  N.Reset;
  ECheck(N.TryParse('0b1010'), 'binary');
  ECheck(N.AsInt = 10, 'bin val');
  N.Reset;
  ECheck(N.TryParse('0o77'), 'octal');
  ECheck(N.AsInt = 63, 'oct val');
  N.Reset;
  ECheck(N.TryParse('-42'), 'neg int');
  ECheck(N.AsInt = -42, 'neg val');
  N.Reset;
  ECheck(N.TryParse('1.5e2'), 'float exp');
  ECheck(Abs(N.AsFloat - 150) < 0.1, 'float exp val');
  N.Reset;
  Writeln(' OK');

  // ---- T10: Malformed JSON ----
  Write('T10: Malformed JSON');
  N := Default(TQJsonNode);
  ECheck(not N.TryParse('{bad}'), 'bad token');
  N.Reset;
  ECheck(not N.TryParse('{"a":1,}'), 'trailing comma');
  N.Reset;
  ECheck(not N.TryParse('[,]'), 'empty arr item');
  N.Reset;
  ECheck(not N.TryParse('{,}'), 'empty obj item');
  N.Reset;
  ECheck(not N.TryParse('"unclosed'), 'unclosed string');
  N.Reset;
  ECheck(not N.TryParse('{"a":01}'), 'leading zero');
  N.Reset;
  ECheck(not N.TryParse('{"a":-01}'), 'neg leading zero');
  N.Reset;
  ECheck(not N.TryParse('{"a":.5}'), 'no leading digit');
  N.Reset;
  ECheck(not N.TryParse('1.2.3'), 'multiple dots');
  N.Reset;
  ECheck(not N.TryParse('{'), 'unclosed obj');
  N.Reset;
  ECheck(not N.TryParse('['), 'unclosed arr');
  N.Reset;
  Writeln(' OK');

  // ---- T11: Flexible parsing edge cases ----
  Write('T11: Flexible parsing');
  N := Default(TQJsonNode);
  P := TQJsonParser.Create(jsmNormal, False);
  P.Options := [jpoAllowUnquotedString];
  ECheck(P.TryParseText(@N, '{key:value}'), 'unquoted');
  ECheck(N.ValueByName('key') = 'value', 'unquoted val');
  P.Free;
  N.Reset;

  P := TQJsonParser.Create(jsmNormal, False);
  P.Options := [jpoAllowUnquotedString];
  ECheck(P.TryParseText(@N, '{empty:}'#10), 'empty unquoted');
  ECheck(N.ValueByName('empty') = '', 'empty val');
  P.Free;
  N.Reset;

  N.Reset;
  P := TQJsonParser.Create(jsmNormal, False);
  P.Options := [jpoAllowUnquotedString];
  ECheck(P.TryParseText(@N, '{'#10'a:1'#10'b:2'#10'}'), 'multi unquoted');
  ECheck(N.Count = 2, 'multi count');
  P.Free;
  N.Reset;

  N.Reset;
  P := TQJsonParser.Create(jsmNormal, False);
  P.Options := [jpoAllowSingleQuote];
  ECheck(P.TryParseText(@N, '{"a":''val''}'), 'single quote');
  ECheck(N.ValueByName('a') = 'val', 'sq val');
  P.Free;
  N.Reset;
  Writeln(' OK');

  // ---- T12: All falsey values ----
  Write('T12: Falsey values');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('{"a":0,"b":false,"c":"","d":null}'), 'falsey');
  ECheck(N.IntByName('a') = 0, 'zero');
  ECheck(N.BoolByName('b') = False, 'false');
  ECheck(N.ValueByName('c') = '', 'empty str');
  ECheck(N.ItemByName('d').FDataType = jdtNull, 'null');
  N.Reset;
  Writeln(' OK');

  // ---- T13: Whitespace tolerance ----
  Write('T13: Whitespace');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('  [  1  ,  2  ,  3  ]  '), 'ws arr');
  ECheck(N.TryParse('  {  "a"  :  1  }  '), 'ws obj');
  ECheck(N.IntByName('a') = 1, 'ws val');
  N.Reset;
  Writeln(' OK');

  // ---- T14: Nested empty ----
  Write('T14: Nested empty');
  N := Default(TQJsonNode);
  ECheck(N.TryParse('[[[[]]]]'), 'empty nest arr');
  ECheck(N.TryParse('{"a":{"b":{}}}'), 'empty nest obj');
  N.Reset;
  Writeln(' OK');

  // ---- T15: Supplementary plane encoding (DoJsonEscape via JavaEscape) ----
  Write('T15: Supplementary plane encoding');
  // U+1F600 😀 = surrogate pair #$D83D#$DE00 (LowerHexChars='0'..'9','a'..'f')
  S := TQJsonEncoder.JavaEscape(#$D83D#$DE00, True);
  ECheck(Pos('\ud83d', S) > 0, 'surr pair high escape');
  ECheck(Pos('\ude00', S) > 0, 'surr pair low escape');
  // Without escaping
  S := TQJsonEncoder.JavaEscape(#$D83D#$DE00, False);
  ECheck(Pos(#$D83D, S) > 0, 'surr pair raw high');
  ECheck(Pos(#$DE00, S) > 0, 'surr pair raw low');
  // Lone high surrogate
  S := TQJsonEncoder.JavaEscape(#$D83D, True);
  ECheck(Pos('\ud83d', S) > 0, 'lone high escape');
  // Lone low surrogate
  S := TQJsonEncoder.JavaEscape(#$DE00, True);
  ECheck(Pos('\ude00', S) > 0, 'lone low escape');
  // BMP character
  S := TQJsonEncoder.JavaEscape(#$4E2D, True);  // U+4E2D '中'
  ECheck(Pos('\u4e2d', S) > 0, 'BMP escape');
  Writeln(' OK');

  // ---- Summary ----
  Writeln;
  if GEdgeErrors = 0 then
    Writeln('ALL EDGE CASE TESTS PASSED!')
  else
    Writeln(GEdgeErrors, ' EDGE CASE TEST(S) FAILED');
end;

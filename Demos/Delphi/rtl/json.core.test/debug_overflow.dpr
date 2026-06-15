program debug_overflow;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas';

var
  N: TQJsonNode;
  OK: Boolean;
  I: Int64;
  D: TQJsonDataType;
begin
  N := Default(TQJsonNode);

  // Test 1: positive overflow → BCD
  OK := N.TryParse('{"a":99999999999999999999}', jsmNormal);
  D := N.ItemByName('a').DataType;
  Writeln('1: huge decimal: parse=', OK, ' dt=', Ord(D));

  N.Reset;
  N := Default(TQJsonNode);

  // Test 2: complex hex overflow
  OK := N.TryParse('{"a":0x8000000000000000}', jsmCacheNames);
  D := N.ItemByName('a').DataType;
  Writeln('2: hex 0x8000...: parse=', OK, ' dt=', Ord(D));

  N.Reset;
  N := Default(TQJsonNode);

  // Test 3: hex max overflow
  OK := N.TryParse('{"a":0xFFFFFFFFFFFFFFFF}', jsmCacheNames);
  D := N.ItemByName('a').DataType;
  Writeln('3: hex 0xFF...F: parse=', OK, ' dt=', Ord(D));

  N.Reset;
  N := Default(TQJsonNode);

  // Test 4: oct 0o huge
  OK := N.TryParse('{"a":0o777777777777777777777}', jsmCacheNames);
  D := N.ItemByName('a').DataType;
  Writeln('4: oct huge: parse=', OK, ' dt=', Ord(D));

  N.Reset;
  N := Default(TQJsonNode);

  // Test 5: 0x1p2
  OK := N.TryParse('{"a":0x1p2}', jsmCacheNames);
  Writeln('5: 0x1p2: parse=', OK);

  N.Reset;
  N := Default(TQJsonNode);

  // Test 6: 1e2.3 reject
  OK := N.TryParse('{"a":1e2.3}', jsmNormal);
  Writeln('6: 1e2.3: parse=', OK, ' (expected False)');

  N.Reset;
  N := Default(TQJsonNode);

  // Test 7: -9223372036854775809 overflow
  OK := N.TryParse('{"a":-9223372036854775809}', jsmNormal);
  D := N.ItemByName('a').DataType;
  Writeln('7: -9223372036854775809: parse=', OK, ' dt=', Ord(D));

  Readln;
end.

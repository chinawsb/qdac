program json.core.comprehensive_test;

{$APPTYPE CONSOLE}

uses System.SysUtils, System.Classes,
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas',
  qdac.attribute in '..\..\..\..\Source\qdac.attribute.pas',
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas';

{$INCLUDE 'json.core.edge_test.inc'}
{$INCLUDE 'json.core.normal_test.inc'}

begin
  Writeln('=== Edge Case Tests ===');
  RunEdgeTests;
  Writeln;
  Writeln('=== Normal API Tests ===');
  RunNormalTests;
  Writeln;
  if (GEdgeErrors = 0) and (GNormalErrors = 0) then
    Writeln('ALL PASSED!')
  else begin
    if GEdgeErrors > 0 then Writeln(GEdgeErrors, ' edge test(s) failed');
    if GNormalErrors > 0 then Writeln(GNormalErrors, ' normal test(s) failed');
  end;
  ReadLn;
end.

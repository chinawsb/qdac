program edge_test;

{$APPTYPE CONSOLE}

uses System.SysUtils, System.Classes, System.DateUtils, System.Math, qdac.json.core in 'C:\temp\qdac-4.0\source\qdac.json.core.pas', qdac.common in 'C:\temp\qdac-4.0\source\qdac.common.pas', qdac.serialize.core in 'C:\temp\qdac-4.0\source\qdac.serialize.core.pas';

{$INCLUDE 'edge_test.inc'}

begin
  RunEdgeTests;
  if GEdgeErrors = 0 then
    Writeln('ALL PASSED!');
  ReadLn;
end.

program xml.core.test;

{$APPTYPE CONSOLE}

uses System.SysUtils, System.Classes,
  qdac.xml.core in '..\..\..\..\Source\qdac.xml.core.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas',
  qdac.common in '..\..\..\..\Source\qdac.common.pas';

{$INCLUDE 'xml.core.test.inc'}

begin
  RunXmlTests;
  if GXmlErrors = 0 then
    Writeln('ALL PASSED!');
  ReadLn;
end.

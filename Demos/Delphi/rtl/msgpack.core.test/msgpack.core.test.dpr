program msgpack.core.test;

{$APPTYPE CONSOLE}

uses System.SysUtils, System.Classes,
  qdac.msgpack.core in '..\..\..\..\Source\qdac.msgpack.core.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas',
  qdac.common in '..\..\..\..\Source\qdac.common.pas';

{$INCLUDE 'msgpack.core.test.inc'}

begin
  RunMsgPackTests;
  if GMsgErrors = 0 then
    Writeln('ALL PASSED!');
  ReadLn;
end.

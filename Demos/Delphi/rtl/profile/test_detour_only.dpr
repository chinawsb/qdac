program test_detour_only;
{$APPTYPE CONSOLE}
uses System.SysUtils, qdac.profile.base in '..\..\..\..\source\qdac.profile.base.pas', qdac.profile.detour in '..\..\..\..\source\qdac.profile.detour.pas';
procedure Foo;
begin
end;
begin
  Writeln('Starting...');
  TQDetourProfiler.RegisterFunction('Foo', @Foo);
  TQDetourProfiler.Enabled := True;
  Foo;
  Foo;
  Foo;
  Writeln('OK');
  TQDetourProfiler.Enabled := False;
  Readln;
end.

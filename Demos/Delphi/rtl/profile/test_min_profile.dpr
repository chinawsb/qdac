program test_min_profile;
{$APPTYPE CONSOLE}
uses
  System.SysUtils,
  qdac.profile.base in '..\..\..\..\source\qdac.profile.base.pas',
  qdac.profile in '..\..\..\..\source\qdac.profile.pas';
var
  H: IInterface;
begin
  Writeln('Enabled: ', TQProfile.Enabled.ToString);
  Writeln('Calling Calc...');
  H := TQProfile.Calc('TestFunc');
  Writeln('After Calc, sleeping...');
  Sleep(10);
  Writeln('Done');
  H := nil;
  Writeln('Released');
end.

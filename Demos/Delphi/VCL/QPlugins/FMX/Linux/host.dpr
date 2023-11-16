program host;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,qplugins,qplugins_loader_lib;
type
  ISumService=interface
    ['{6ED81A6D-52D8-466C-A2E9-77F5C287DF07}']
    function Add(x,y:Integer):Integer;
  end;
var
  AService:ISumService;
begin
  try
    WriteLn('Register SO Loader...');
    PluginsManager.Loaders.Add(TQSOLoader.Create);
    WriteLn('Start loading plugins...');
    PluginsManager.Start;
    WriteLn('Plugins started,Call sum service');
    if Supports(PluginsManager,ISumService,AService) then
      WriteLn(Format('ISumService.Add(10,10)=%d', [AService.Add(10,10)]))
    else
      WriteLn('ISumService not registered,ignore');
    WriteLn('QPlugins for Linux demo done.');
    PluginsManager.Stop;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

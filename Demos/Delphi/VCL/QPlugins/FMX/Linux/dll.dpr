library dll;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,qplugins_base,qplugins;

{$R *.res}
type
  ISumService=interface
    ['{6ED81A6D-52D8-466C-A2E9-77F5C287DF07}']
    function Add(x,y:Integer):Integer;
  end;
  TSumService=class(TInterfacedObject,ISumService)
     function Add(x,y:Integer):Integer;
  end;
{ TSumService }

function TSumService.Add(x, y: Integer): Integer;
begin
  Result:=x+y;
end;

begin
  WriteLn('Share Object Loading,register ISumService');
  PluginsManager.AddExtension(TSumService.Create);
  WriteLn('ISumService registered.');
end.

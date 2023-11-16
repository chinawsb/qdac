library dll_origin;

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
  System.Classes, HotReplace, qplugins_base, qplugins;

{$R *.res}

type
  TOriginDemoService = class(TQService, IReplaceDemoService)
  protected
    function GetDescription: PWideChar;
  end;

const
  ServiceDescription: PWideChar = '这是原始的服务，来自 dll_origin.dll';
  { TOriginDemoService }

function TOriginDemoService.GetDescription: PWideChar;
begin
  Result := ServiceDescription;
end;

begin
  RegisterServices('/Services', [TOriginDemoService.Create(IReplaceDemoService,
    'ReplaceDemo')]);

end.

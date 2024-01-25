// JCL_DEBUG_EXPERT_GENERATEJDBG OFF
library dll;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters.

  Important note about VCL usage: when this DLL will be implicitly
  loaded and this DLL uses TWicImage / TImageCollection created in
  any unit initialization section, then Vcl.WicImageInit must be
  included into your library's USES clause. }

uses
  System.SysUtils,
  System.Classes, QLog, Winapi.Windows;

{$R *.res}

procedure MyDLLHandler(Reason: integer);
begin
  case Reason of
    DLL_PROCESS_DETACH:
      begin
        PostLog(llHint, 'QLogStop');
      end;
    DLL_Process_Attach:
      begin
        SetDefaultLogFile('test.log', 1024 * 1024, False, true).MaxLogHistories := 1; // 最大保留两个历史日志+1个当前日志文件
        PostLog(llHint, 'QLogStart');
      end;
    DLL_Thread_Attach:
      ;
    DLL_Thread_Detach:
      ;
  end;
end;

begin
  DLLProc := @MyDLLHandler;
  MyDLLHandler(DLL_Process_Attach);
end.

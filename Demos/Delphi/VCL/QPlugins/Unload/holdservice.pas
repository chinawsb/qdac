unit holdservice;

interface

uses qstring, qplugins, qplugins_params;

type
  // ���ֻ���������ԣ�ʵ����ʲôҲ����
  THoldService = class(TQService)

  end;

implementation

initialization

RegisterServices('/Services', [THoldService.Create(NewId, 'HoldService')]);

finalization

UnregisterServices('/Services', ['HoldService']);

end.

unit QMrsw;

interface

uses classes, syncobjs, qstring, windows;

type
  TQMRSW = class(TObject)
  protected
    FFlags: Integer;
    FReadCount: Integer; // ���ڶ�ȡ������
    FWriteCount: Integer; // ���ڵȴ�д�������
    FReadEvent, FWriteEvent: TEvent; // ��д�¼�֪ͨ��������һ����д������
    FWritingThread: TThreadId; // ����д����̱߳���
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
    function TryRead(AWaitTime: Cardinal): Boolean;
    function TryWrite(AWaitTime: Cardinal): Boolean;
  end;

implementation

const
  MRSW_READING = $01;
  MRSW_WRITING = $02;
  MRSW_ENDING  = $04;
  { TQMRSW }

procedure TQMRSW.BeginRead;
begin
TryRead(INFINITE);
end;

procedure TQMRSW.BeginWrite;
begin
TryWrite(INFINITE);
end;

constructor TQMRSW.Create;
begin
inherited;
FReadEvent := TEvent.Create(nil, true, false, '');
FWriteEvent := TEvent.Create(nil, false, false, '');
end;

destructor TQMRSW.Destroy;
begin
FreeObject(FReadEvent);
FreeObject(FWriteEvent);
inherited;
end;

procedure TQMRSW.EndRead;
var
  AFlags: Integer;
begin
if AtomicDecrement(FReadCount) = 0 then
  begin
  AtomicCmpExchange(FFlags, FFlags and (not MRSW_READING), MRSW_READING);
  FReadEvent.ResetEvent;
  // û�ж����ˣ���ô�ͼ����û����Ҫд�ģ����򴥷�д�¼�
  if (FFlags = 0) and (FWriteCount > 0) then
    FWriteEvent.SetEvent;
  end;
end;

procedure TQMRSW.EndWrite;
var
  AThreadId: TThreadId;
begin
AThreadId := GetCurrentThreadId;
assert(FWritingThread = AThreadId, 'Only Writing Thread can EndWrite');
AtomicCmpExchange(FWritingThread, 0, AThreadId);
if AtomicCmpExchange(FFlags, FFlags and (not MRSW_WRITING), MRSW_WRITING) = MRSW_WRITING
then
  begin
  if AtomicDecrement(FWriteCount) = 0 then
    begin
    // ��д���ˣ��Ǽ����û�ж���
    if ((FFlags and MRSW_WRITING) = 0) and (FReadCount > 0) then
      FReadEvent.SetEvent;
    end
  else // ������һ��д
    FWriteEvent.SetEvent;
  end;
end;

function TQMRSW.TryRead(AWaitTime: Cardinal): Boolean;
var
  AWaited: Cardinal;
  AFlags: Integer;
begin
Result := false;
AtomicIncrement(FReadCount);
AWaited := 0;
repeat
  AFlags := FFlags;
  if (AFlags and MRSW_WRITING) <> 0 then // ����д����ȴ��´�
    begin
    FReadEvent.ResetEvent;
    if FReadEvent.WaitFor(100) = wrSignaled then
      Continue;
    Inc(AWaited, 100);
    end
  else
    begin
    if (AtomicCmpExchange(FFlags, MRSW_READING, AFlags) and MRSW_WRITING) = 0
    then
      begin
      // δ����д��״̬
      Result := true;
      Break;
      end;
    end;
until (AWaited >= AWaitTime);
if not Result then
  AtomicDecrement(FReadCount);
end;

function TQMRSW.TryWrite(AWaitTime: Cardinal): Boolean;
var
  AFlags: Integer;
begin
Result := false;
AtomicIncrement(FWriteCount);
repeat
  AFlags := AtomicCmpExchange(FFlags, MRSW_WRITING, 0);
  if (AFlags = 0) then
    begin
    Result := true;
    FWritingThread := GetCurrentThreadId;
    Break;
    end
  else
    begin
    if FWriteEvent.WaitFor(AWaitTime) = wrSignaled then
      Continue
    else
      Break;
    end;
until false;

end;

end.

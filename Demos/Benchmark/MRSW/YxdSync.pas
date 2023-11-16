
unit YxdSync;

{$IFDEF MSWINDOWS}
{$IFNDEF UNICODE}
{$DEFINE RWSync}
{$ELSE}
{$IFNDEF WIN64}
{$DEFINE RWSync}
{$ENDIF}
{$ENDIF}
{$ENDIF}

interface

uses
  {$IFNDEF RWSync}SyncObjs{$ELSE}Windows{$ENDIF};

{$IFDEF RWSync}
type
  // ����������дͬ��
  // Copyright Adam Wu, 2008-2009
  // Slim Multi-read Exclusive-write spin lock
  // �������������д������
  // NOTE: 1. The no yield methods are designed to synchronize VERY VERY small pieces of code.
  // They are super lightweight, but wasteful if long wait is required.
  // Use yield functions if long wait is exepcted to be common.
  // ��Yield����ר��Ϊͬ��*����*��С�Ĵ�����ƣ��ǳ�������
  // ���ǣ�����Ҫ�ϳ�ʱ��ȴ�������»�ȽϷ�CPU��
  // ���Ԥ����Ҫ������ʱ��ȴ������ô�Yield������
  // 2. For performance reasons, we don't have much error correction capability.
  // In other words, MAKE SURE YOU KNOW WHAT YOU ARE DOING!
  // Ϊ�������Ż������뼸��û�о�����������ȷ����ȷʹ�ã�
  // 3. This implementation is NOT starvation free;
  // This implementation does not support thread lock recursion.
  // ����д����ʵ��: ����"������"�ģ���֧���߳�����.
  // 4. ReadSyncWrite guarantees lock holding if it used by ONLY ONE thread.
  // ReadSyncWrite (��������д��)����֤һ���߳�����䲻��ʧ��.
  TSlimRWSync = record
    SyncInt: Integer;
    procedure Initialize;
    function TryRead: Boolean; // Try acquire read lock
    function TryWrite: Boolean; // Try acquire write lock
    procedure ReadSync; // Acquire read lock, no yield
    procedure WriteSync; // Acquire write lock, no yield
    procedure ReadSyncYield; // Acquire read lock, yield on spin
    procedure WriteSyncYield; // Acquire write lock, yield on spin
    procedure ReadDone; // Release read lock
    procedure WriteDone; // Release write lock
    procedure ReadSyncWrite; // Promote read lock to write, yield on spin
    procedure WriteSyncRead; // Depromote write lock to read
  end;
{$ENDIF}

type
  /// <summary>
  /// �������ռд�� (��֧���߳���������С��ʹ��)
  /// by YangYxd 2015.08.26
  /// </summary>
  TShareRWSync = class({$IFDEF RWSync}TObject{$ELSE}TCriticalSection{$ENDIF})
  private
    {$IFDEF RWSync}
    FSync: TSlimRWSync;
    {$ENDIF}
  public
    {$IFDEF RWSync}
    constructor Create;
    procedure Enter(Read: Boolean = True); inline;
    procedure Leave(Read: Boolean = True); inline;
    // ����ȡ�ö���
    function TryRead: Boolean; inline;
    // ����ȡ��д��
    function TryWrite: Boolean; inline;
    // ��������������
    procedure ReadSync; inline;
    // д������������
    procedure WriteSync; inline;
    // ����������������
    procedure ReadSyncYield; inline;
    // д��������������
    procedure WriteSyncYield; inline;
    // �ͷŶ���
    procedure ReadDone; inline;
    // �ͷ�д��
    procedure WriteDone; inline;
    // ��������Ϊд������������
    procedure ReadSyncWrite; inline;
    // д������Ϊ����
    procedure WriteSyncRead; inline;
    {$ENDIF}
    procedure Lock(const Read: Boolean); inline;
    procedure UnLock(const Read: Boolean); inline; 
  end;

implementation

{ TSlimRWSync }

{$IFDEF RWSync}
procedure TSlimRWSync.Initialize;
ASM
  XOR EDX, EDX
  MOV [EAX], EDX
END;
{$ENDIF}

{$IFDEF RWSync}
function TSlimRWSync.TryRead: Boolean;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
  MOV EAX, [ EDX ]
@@Retry:
  TEST EAX, EAX
  JS @@Done

  LEA ECX, [ EAX + 1 ]
  LOCK CMPXCHG [ EDX ], ECX
  JNZ @@Retry

@@Done:
  SETZ AL
END;
{$ENDIF}

{$IFDEF RWSync}
function TSlimRWSync.TryWrite: Boolean;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
  XOR EAX, EAX
  MOV ECX, -1
  LOCK CMPXCHG [ EDX ], ECX
  SETZ AL
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.ReadSync;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
@@Back:
  MOV EAX, [ EDX ]
@@Retry:
  TEST EAX, EAX
  JS @@Spin

  LEA ECX, [ EAX + 1 ]
  LOCK CMPXCHG [ EDX ], ECX
  JNZ @@Retry
  RET

@@Spin:
  {$IFDEF Spin_Pause}
  PAUSE
  {$ENDIF Spin_Pause}
  JMP @@Back
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.ReadSyncYield;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
@@Back:
  MOV EAX, [ EDX ]
@@Retry:
  TEST EAX, EAX
  JS @@Spin

  LEA ECX, [ EAX + 1 ]
  LOCK CMPXCHG [ EDX ], ECX
  JNZ @@Retry
  RET

@@Spin:
  PUSH EDX
  CALL Windows.SwitchToThread
  POP EDX
  JMP @@Back
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.WriteSync;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
@@Back:
  MOV EAX, [ EDX ]
  TEST EAX, EAX
  JNZ @@Spin

  MOV ECX, -1
  LOCK CMPXCHG [ EDX ], ECX
  JZ @@Done

@@Spin:
  {$IFDEF Spin_Pause}
  PAUSE
  {$ENDIF Spin_Pause}
  JMP @@Back

@@Done:
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.WriteSyncYield;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
@@Back:
  MOV EAX, [ EDX ]
  TEST EAX, EAX
  JNZ @@Spin

  MOV ECX, -1
  LOCK CMPXCHG [ EDX ], ECX
  JZ  @@Done

@@Spin:
  PUSH EDX
  CALL Windows.SwitchToThread
  POP EDX
  JMP @@Back

@@Done:
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.ReadSyncWrite;
// EAX: @SyncInt
ASM
  // 1. Put the lock into "Pre-write" state (so that no new read locks are granted)
  LOCK OR [ EAX ], $80000000

  // 2. Release the read lock (before we release our read lock, no write lock can be granted)
  LOCK DEC [ EAX ]

  // 3. Now we can try get a write lock (only ReadSyncWrite threads will compete)
  MOV EDX, EAX
@@Back:
  MOV EAX, [ EDX ]
  TEST EAX, $7FFFFFFF
  JNZ @@Spin

  MOV ECX, -1
  LOCK CMPXCHG [ EDX ], ECX
  JZ  @@Done

@@Spin:
  PUSH EDX
  CALL Windows.SwitchToThread
  POP EDX
  JMP @@Back
@@Done:
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.WriteSyncRead;
// EAX: @SyncInt
ASM
  MOV EDX, EAX
  MOV EAX, -1
  MOV ECX, 1

  LOCK CMPXCHG [ EDX ], ECX
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.ReadDone;
// EAX: @SyncInt
ASM
  LOCK DEC [ EAX ]
END;
{$ENDIF}

{$IFDEF RWSync}
procedure TSlimRWSync.WriteDone;
// EAX: @SyncInt
ASM
  LOCK INC [ EAX ]
END;
{$ENDIF}

{ TShareRWSync }

{$IFDEF RWSync}
constructor TShareRWSync.Create;
begin
  FSync.Initialize;
end;
{$ENDIF}

{$IFDEF RWSync}
procedure TShareRWSync.Enter(Read: Boolean);
begin
  Lock(Read);
end;

procedure TShareRWSync.Leave(Read: Boolean);
begin
  UnLock(Read);
end;
{$ENDIF}

procedure TShareRWSync.Lock(const Read: Boolean);
begin
  {$IFDEF RWSync}
  if Read then
    FSync.ReadSyncYield
  else
    FSync.WriteSyncYield;
  {$ELSE}
  Enter;
  {$ENDIF}
end;

{$IFDEF RWSync}
procedure TShareRWSync.ReadDone;
begin
  FSync.ReadDone;
end;

procedure TShareRWSync.ReadSync;
begin
  FSync.ReadSync;
end;

procedure TShareRWSync.ReadSyncWrite;
begin
  FSync.ReadSyncWrite;
end;

procedure TShareRWSync.ReadSyncYield;
begin
  FSync.ReadSyncYield;
end;

function TShareRWSync.TryRead: Boolean;
begin
  Result := FSync.TryRead;
end;

function TShareRWSync.TryWrite: Boolean;
begin
  Result := FSync.TryWrite;
end;
{$ENDIF}

procedure TShareRWSync.UnLock(const Read: Boolean);
begin
  {$IFDEF RWSync}
  if Read then
    FSync.ReadDone
  else
    FSync.WriteDone;
  {$ELSE}
  Leave;
  {$ENDIF}
end;

{$IFDEF RWSync}
procedure TShareRWSync.WriteDone;
begin
  FSync.WriteDone;
end;

procedure TShareRWSync.WriteSync;
begin
  FSync.WriteSync;
end;

procedure TShareRWSync.WriteSyncRead;
begin
  FSync.WriteSyncRead;
end;

procedure TShareRWSync.WriteSyncYield;
begin
  FSync.WriteSyncYield;
end;
{$ENDIF}

END.

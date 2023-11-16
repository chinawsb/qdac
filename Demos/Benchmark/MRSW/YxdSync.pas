
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
  // 超轻量级读写同步
  // Copyright Adam Wu, 2008-2009
  // Slim Multi-read Exclusive-write spin lock
  // 超轻量级多读单写自旋锁
  // NOTE: 1. The no yield methods are designed to synchronize VERY VERY small pieces of code.
  // They are super lightweight, but wasteful if long wait is required.
  // Use yield functions if long wait is exepcted to be common.
  // 无Yield方法专门为同步*及其*短小的代码设计，非常轻量，
  // 但是，在需要较长时间等待的情况下会比较费CPU。
  // 如果预计需要经常长时间等待，请用带Yield方法。
  // 2. For performance reasons, we don't have much error correction capability.
  // In other words, MAKE SURE YOU KNOW WHAT YOU ARE DOING!
  // 为了性能优化，代码几乎没有纠错能力，请确保正确使用！
  // 3. This implementation is NOT starvation free;
  // This implementation does not support thread lock recursion.
  // 本读写锁的实现: 不是"防饿死"的；不支持线程重锁.
  // 4. ReadSyncWrite guarantees lock holding if it used by ONLY ONE thread.
  // ReadSyncWrite (读锁升级写锁)仅保证一个线程在其间不丢失锁.
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
  /// 共享读独占写锁 (不支持线程重锁，请小心使用)
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
    // 尝试取得读锁
    function TryRead: Boolean; inline;
    // 尝试取得写锁
    function TryWrite: Boolean; inline;
    // 读锁定，不自旋
    procedure ReadSync; inline;
    // 写锁定，不自旋
    procedure WriteSync; inline;
    // 读锁定，产生自旋
    procedure ReadSyncYield; inline;
    // 写锁定，产生自旋
    procedure WriteSyncYield; inline;
    // 释放读锁
    procedure ReadDone; inline;
    // 释放写锁
    procedure WriteDone; inline;
    // 读锁升级为写锁，产生自旋
    procedure ReadSyncWrite; inline;
    // 写锁降级为读锁
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

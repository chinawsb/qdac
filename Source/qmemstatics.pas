unit qmemstatics;

interface

uses classes, sysutils;

{ �ڴ�������ͳ�Ƶ�Ԫ
  QMemStatics�ṩ��һ��;��������ϵͳ���ڴ����������м򵥵�ͳ�Ʒ�����٣��Է���
  ����ͨ�����ʵ��ֶΣ������ڴ���Ƭ�Ĳ�����
  QMemStatics�ṩ��һ����򵥵ļ����ڴ���Ƭ�İ취�����������ڴ��������ȣ�ͨ����
  ����������RESIZESMALLBLOCK���Ϳ�������ֻ������С�ڴ����ߴ�ΪResizeMaxBlockSize��
  ���پ�������ڴ���Ƭ��������Ĭ����64B)��
  ��������ѡ�� RESIZEONLY ������ģ�鲻Ϊÿ���ڴ��������ʶ���ͷ����־����ͬʱ��Ҳ
  �����ͳ�ƹ���ʧЧ��һ��ֻ�ڷ����İ汾��ʹ�á�
  Ĭ������£�������ѡ�δ���ã��Ա���ʵ��Ӧ�ڴ���������
  Demos\Delphi\VCL\QMemStatics\dlgMemStatics��Ԫʵ����һ��ʾ���Ե�ͼ�λ����ڴ�ͳ��
  ��������ĳ����У�����ֱ�ӵ���ShowMemoryStatics�������������ʾ�ڴ�״̬��
  ����Ԫ������QString.pas��qdac.inc�����ļ���
  ����Ԫ֧��XE7���Ժ�汾
}
{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}
{ �޶���־
  2014.7.29
  =========
  * �����ԸĽ���������XE2�±���ͨ��
  2014.7.25
  =========
  * �����˼����ڴ��쳣
  * �������ڴ���С�����ߴ��Ϊ64�ֽ�
  * �޸�ͳ�Ƶ��ڴ��СΪ4KB����
  * ������ͳ�ƽ�����ܳ��ָ���������
  2014.7.24
  =========
  + ��һ��
}
{.$DEFINE RESIZEONLY }
{$IFDEF RESIZEONLY}
{$IFNDEF RESIZESMALLBLOCK}
{$DEFINE RESIZESMALLBLOCK}
{$ENDIF}
{$ELSE}
{.$DEFINE RESIZESMALLBLOCK }
{$ENDIF}
{$HPPEMIT '#pragma link "qmemstatics"'}
const
  MaxStaticMemSize = 4096;
  ResizeMaxBlockSize = 64;
type
{$IF RTLVersion<=22}
  NativeInt = Integer;
  PNativeInt = ^NativeInt;
  PNativeUInt = ^Cardinal;
{$IFEND}

  TMemoryStatic = record
    Count: Integer; // ��ǰ����
    MaxCount: Integer; // �������
    AllocateTimes: Integer; // �������
    FreeTimes: Integer; // �ͷŴ���
  end;

  PMemoryStatic = ^TMemoryStatic;

  TMemStaticItem = record
    Size: Integer; // �ڴ�ߴ�
    Statics: TMemoryStatic; // ͳ�ƽ��
  end;

  TMemStatics = array of TMemStaticItem;
  TMemStaticsSortMethod = (ssmNone, ssmCount, ssmMaxCount, ssmAllocateTimes,
    ssmFreeTimes);

procedure GetMemStatics(var AStatics: TMemStatics;
  ASortType: TMemStaticsSortMethod);
procedure SortMemStatics(var AStatics: TMemStatics;
  ASortType: TMemStaticsSortMethod);
function GetMemStaticsText(const AStatics: TMemStatics): String;

implementation

uses qstring, windows;

type
  TMemMagic = record
    {$IFNDEF X64}
    Reserved:Int64;//���ڱ�֤TMemMagic����󣬵�ַ����16�ֽڶ���
    {$ENDIF}
    Size: NativeInt;
    Magic: NativeInt;
  end;

  PMemMagic = ^TMemMagic;

var
  MemoryStatics: array [0 .. MaxStaticMemSize] of TMemoryStatic;
  OldMemMgr: TMemoryManagerEx;
  DebugSize: Integer = 17;
  DebugCount: Integer = 0;
  MemMagic:NativeInt;

procedure LogAllocMem(ASize: NativeInt);
var
  pItem: PMemoryStatic;
  ACount, AMax: Integer;
begin
if ASize > MaxStaticMemSize then
  pItem := @MemoryStatics[MaxStaticMemSize]
else
  pItem := @MemoryStatics[ASize - 1];
if DebugSize = ASize then
  AtomicIncrement(DebugCount);
AtomicIncrement(pItem.Count);
AtomicIncrement(pItem.AllocateTimes);
repeat
  ACount := pItem.Count;
  AMax := pItem.MaxCount;
until (ACount <= AMax) or (AtomicCmpExchange(pItem.MaxCount, ACount, AMax)
  = ACount);
end;

procedure LogFreeMem(ASize: NativeInt);
var
  pItem: PMemoryStatic;
  ACount: Integer;
begin
if ASize > MaxStaticMemSize then
  pItem := @MemoryStatics[MaxStaticMemSize]
else
  pItem := @MemoryStatics[ASize - 1];
AtomicIncrement(pItem.FreeTimes);
ACount := AtomicDecrement(pItem.Count);
if DebugSize = ASize then
  begin
  if AtomicDecrement(DebugCount) <> ACount then
    begin
    DebugBreak;
    end;
  end;
end;

function MarkMagic(P:Pointer;ASize:NativeInt):Pointer;inline;
var
  pMagic:PMemMagic;
begin
pMagic:=P;
pMagic.Size:=ASize;
pMagic.Magic:=MemMagic;
Result:=Pointer(IntPtr(P)+SizeOf(TMemMagic));
end;

function MagicOf(P:Pointer):PMemMagic;inline;
begin
Result:=Pointer(IntPtr(P)-SizeOf(TMemMagic));
if Result.Magic<>MemMagic then
  Result:=nil;
end;

function Hook_GetMem(Size: NativeInt): Pointer;
begin
{$IFDEF RESIZESMALLBLOCK}
if Size < ResizeMaxBlockSize then
  Size := ResizeMaxBlockSize;
{$ENDIF}
{$IFDEF RESIZEONLY}
Result := OldMemMgr.GetMem(Size);
{$ELSE}
Result := OldMemMgr.GetMem(Size + SizeOf(TMemMagic));
if Result <> nil then//ͷ������ǩ����Ϣ
  begin
  LogAllocMem(Size);
  Result:=MarkMagic(Result, Size);
  end;
{$ENDIF}
end;

{
  FreeMem����ֵΪ������룬����ɹ����򷵻�0
}
function Hook_FreeMem(P: Pointer): Integer;
var
  pMagic: PMemMagic;
  ASize: NativeInt;
begin
{$IFDEF RESIZEONLY}
Result := OldMemMgr.FreeMem(P);
{$ELSE}
if P <> nil then
  begin
  pMagic := PMemMagic(IntPtr(P) - SizeOf(TMemMagic));
  if pMagic.Magic = MemMagic then
    begin
    ASize := pMagic.Size;
    Result := OldMemMgr.FreeMem(pMagic);
    if Result = 0 then
      LogFreeMem(ASize);
    end
  else // �����Լ�����ģ�����ԭ����
    Result := OldMemMgr.FreeMem(P);
  end
else
  Result := 0;
{$ENDIF}
end;

function Hook_ReallocMem(P: Pointer; Size: NativeInt): Pointer;
var
  pMagic: PMemMagic;
begin
{$IFDEF RESIZESMALLBLOCK}
if Size < ResizeMaxBlockSize then
  Size := ResizeMaxBlockSize;
{$ENDIF}
{$IFDEF RESIZEONLY}
Result := OldMemMgr.ReallocMem(P, Size);
{$ELSE}
if P = nil then
  Result := Hook_GetMem(Size)
else
  begin
  pMagic := PMemMagic(IntPtr(P) - SizeOf(TMemMagic));
  if pMagic.Magic = MemMagic then
    begin
    if Size <> pMagic.Size then
      begin
      Result := OldMemMgr.ReallocMem(pMagic, Size + SizeOf(TMemMagic));
      if Result <> nil then
        begin
        if Result <> pMagic then
          begin
          pMagic := PMemMagic(IntPtr(P) - SizeOf(TMemMagic));
          pMagic.Magic := MemMagic;
          end;
        LogAllocMem(Size);
        LogFreeMem(pMagic.Size);
        pMagic.Size := Size;
        Result := Pointer(IntPtr(Result) + SizeOf(TMemMagic));
        end;
      end
    else
      begin
      Result := P;
      Exit;
      end;
    end
  else // �����Լ�����ģ�ϵͳ����ģ�����ԭ���ĺ�������
    begin
    Result := OldMemMgr.ReallocMem(P, Size);
    end;
  end;
{$ENDIF}
end;

function Hook_AllocMem(Size: {$IF RTLVersion>22}NativeInt{$ELSE}Cardinal{$IFEND}): Pointer;
begin
Result := Hook_GetMem(Size);
if Result <> nil then
  FillChar(Result^, Size, 0);
end;

function Hook_RegisterExpectedMemoryLeak(P: Pointer): Boolean;
var
  pMagic: PMemMagic;
begin
if P <> nil then
  begin
  pMagic := PMemMagic(IntPtr(P) - SizeOf(TMemMagic));
  if pMagic.Magic = MemMagic then
    Result := OldMemMgr.RegisterExpectedMemoryLeak(pMagic)
  else
    Result := OldMemMgr.RegisterExpectedMemoryLeak(P);
  end
else
  Result := OldMemMgr.RegisterExpectedMemoryLeak(P)
end;

function Hook_UnregisterExpectedMemoryLeak(P: Pointer): Boolean;
var
  pMagic: PMemMagic;
begin
if P <> nil then
  begin
  pMagic := PMemMagic(IntPtr(P) - SizeOf(TMemMagic));
  if pMagic.Magic = MemMagic then
    Result := OldMemMgr.UnregisterExpectedMemoryLeak(pMagic)
  else
    Result := OldMemMgr.UnregisterExpectedMemoryLeak(P);
  end
else
  Result := OldMemMgr.UnregisterExpectedMemoryLeak(P)
end;

procedure RegisterMemMgr;
var
  AMgr: TMemoryManagerEx;
begin
GetMemoryManager(OldMemMgr);
AMgr.GetMem := Hook_GetMem;
AMgr.FreeMem := Hook_FreeMem;
AMgr.ReallocMem := Hook_ReallocMem;
AMgr.AllocMem := Hook_AllocMem;
AMgr.RegisterExpectedMemoryLeak := Hook_RegisterExpectedMemoryLeak;
AMgr.UnregisterExpectedMemoryLeak := Hook_UnregisterExpectedMemoryLeak;
SetMemoryManager(AMgr);
end;

procedure SortMemStatics(var AStatics: TMemStatics;
  ASortType: TMemStaticsSortMethod);

  function DoCompare(P1, P2: Integer): Integer;
  begin
  case ASortType of
    ssmCount:
      Result := AStatics[P1].Statics.Count - AStatics[P2].Statics.Count;
    ssmMaxCount:
      Result := AStatics[P1].Statics.MaxCount - AStatics[P2].Statics.MaxCount;
    ssmAllocateTimes:
      Result := AStatics[P1].Statics.AllocateTimes - AStatics[P2]
        .Statics.AllocateTimes;
    ssmFreeTimes:
      Result := AStatics[P1].Statics.FreeTimes - AStatics[P2].Statics.FreeTimes
  else
    Result := 0;

  end;
  end;
  procedure ExchangeItem(P1, P2: Integer);
  var
    S: TMemStaticItem;
  begin
  S := AStatics[P1];
  AStatics[P1] := AStatics[P2];
  AStatics[P2] := S;
  end;
  procedure SortStatics(L, R: Integer);
  var
    I, J, P: Integer;
  begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while DoCompare(I, P) < 0 do
        Inc(I);
      while DoCompare(J, P) > 0 do
        Dec(J);
      if I <= J then
        begin
        if I <> J then
          ExchangeItem(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
        end;
    until I > J;
    if L < J then
      SortStatics(L, J);
    L := I;
  until I >= R;
  end;

begin
SortStatics(0, High(AStatics))
end;

procedure GetMemStatics(var AStatics: TMemStatics;
  ASortType: TMemStaticsSortMethod);
var
  I: Integer;
begin
SetLength(AStatics, MaxStaticMemSize + 1);
for I := 0 to MaxStaticMemSize - 1 do
  begin
  AStatics[I].Size := I + 1;
  Move(MemoryStatics[I], AStatics[I].Statics, SizeOf(TMemoryStatic));
  end;
AStatics[MaxStaticMemSize].Size := -1;
AStatics[MaxStaticMemSize].Statics := MemoryStatics[MaxStaticMemSize];
if ASortType <> ssmNone then
  SortMemStatics(AStatics, ASortType);
end;

function GetMemStaticsText(const AStatics: TMemStatics): String;
var
  I: Integer;
  ATotal: TMemoryStatic;
  ABuilder: TQStringCatHelperW;
begin
SetLength(Result, 0);
FillChar(ATotal, SizeOf(TMemoryStatic), 0);
for I := Low(AStatics) to High(AStatics) do
  begin
  Inc(ATotal.Count, AStatics[I].Statics.Count);
  Inc(ATotal.AllocateTimes, AStatics[I].Statics.AllocateTimes);
  Inc(ATotal.MaxCount, AStatics[I].Statics.MaxCount);
  Inc(ATotal.FreeTimes, AStatics[I].Statics.FreeTimes);
  end;
ABuilder := TQStringCatHelperW.Create;
try
  ABuilder.Cat('�ܼ�:').Cat(SLineBreak).Cat('  ������:')
    .Cat(ATotal.MaxCount).Cat('��');
  ABuilder.Cat(SLineBreak).Cat('  ����:').Cat(ATotal.Count).Cat('��');
  ABuilder.Cat(SLineBreak).Cat('  �������:').Cat(ATotal.AllocateTimes);
  ABuilder.Cat(SLineBreak).Cat('  �ͷŴ���:').Cat(ATotal.FreeTimes);
  ABuilder.Cat(SLineBreak).Cat('��ϸ:').Cat(SLineBreak);
  for I := Low(AStatics) to High(AStatics) do
    begin
    if AStatics[I].Statics.AllocateTimes <> 0 then
      begin
      if AStatics[I].Size <> -1 then
        begin
        ABuilder.Cat(AStatics[I].Size).Cat('B:��� ')
          .Cat(AStatics[I].Statics.MaxCount).Cat('��');
        if ATotal.MaxCount > 0 then
          ABuilder.Cat('(')
            .Cat(RollupSize(AStatics[I].Size * AStatics[I].Statics.MaxCount))
            .Cat(',').Cat(FormatFloat('0.##', AStatics[I].Statics.MaxCount * 100
            / ATotal.MaxCount)).Cat('%)');
        end
      else
        ABuilder.Cat('>=').Cat(MaxStaticMemSize).Cat('B:��� ')
          .Cat(AStatics[I].Statics.MaxCount).Cat('��(');
      ABuilder.Cat(',��ǰ ').Cat(AStatics[I].Statics.Count).Cat('��');
      if ATotal.Count > 0 then
        ABuilder.Cat('(')
          .Cat(RollupSize(AStatics[I].Size * AStatics[I].Statics.Count))
          .Cat(',').Cat(FormatFloat('0.##', AStatics[I].Statics.Count * 100 /
          ATotal.Count)).Cat('%)');
      ABuilder.Cat(',�������:').Cat(AStatics[I].Statics.AllocateTimes);
      if ATotal.AllocateTimes > 0 then
        ABuilder.Cat('(')
          .Cat(FormatFloat('0.##', AStatics[I].Statics.AllocateTimes * 100 /
          ATotal.AllocateTimes)).Cat('%)');
      ABuilder.Cat(',�ͷŴ���:').Cat(AStatics[I].Statics.FreeTimes);
      if ATotal.AllocateTimes > 0 then
        ABuilder.Cat('(').Cat(FormatFloat('0.##', AStatics[I].Statics.FreeTimes
          * 100 / ATotal.FreeTimes)).Cat('%)');
      ABuilder.Cat(SLineBreak);
      end;
    end;
  Result := ABuilder.Value;
finally
  FreeObject(ABuilder);
end;
end;


initialization
FillChar(MemMagic,SizeOf(MemMagic),1);
FillChar(MemoryStatics, SizeOf(MemoryStatics), 0);
RegisterMemMgr;

end.

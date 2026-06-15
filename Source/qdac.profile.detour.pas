unit qdac.profile.detour;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, System.Generics.Defaults, System.Math, System.SyncObjs, System.Diagnostics, Winapi.Windows,
  qdac.profile.base;

type
  TQDetourFuncStat = record
    Name: string;
    Address: Pointer;
    EntryCount: Int64;
    TotalTicks: UInt64;
    MinTicks: UInt64;
    MaxTicks: UInt64;
  end;

  TQMapEntry = record
    Name: string;
    Address: Pointer;
  end;

  /// <summary>调用边统计 — 记录 Caller→Callee 的调用关系</summary>
  TQDetourCallEdge = record
    CallerAddr: Pointer;
    CalleeAddr: Pointer;
    CallerName: string;
    CalleeName: string;
    EntryCount: Int64;
    TotalTicks: UInt64;
    MinTicks: UInt64;
    MaxTicks: UInt64;
  end;

  TQDetourProfiler = class(TQProfileBase)
  private
    class var
      FEnabled: Boolean;
      FFileName: string;
      FMapEntries: TArray<TQMapEntry>;
      FHookAddrs: TArray<Pointer>;
      FTrampolines: TArray<Pointer>;
      FOrigBytes: TArray<TArray<Byte>>;
      FLock: TCriticalSection;
      FFuncStats: TDictionary<Pointer, TQDetourFuncStat>;
      FCallEdges: TDictionary<string, TQDetourCallEdge>;
      FTotalCalls: Int64;
    class function FindMapFile: string; static;
    class function ParseMapFile(const AFileName: string): TArray<TQMapEntry>; static;
    class procedure LoadMap; static;
    class procedure InstallHook(const AEntry: TQMapEntry; AIndex: Integer); static;
    class procedure UninstallHooks; static;
  private
    class function EdgeKey(CallerAddr, CalleeAddr: Pointer): string; static;
    class procedure AppendChainJson(SB: TStringBuilder; CallerAddr: Pointer; Indent: string); static;
    class procedure AppendChainText(SB: TStringBuilder; CallerAddr: Pointer; Indent: string; IsLast: Boolean); static;
    class procedure SetEnabledProc(const Value: Boolean); static;
    class procedure SetFileNameProc(const Value: string); static;
  public
    // TQProfileBase — 公共状态（虚方法，供基类 SaveToFile 调用）
    class function GetEnabled: Boolean; override;
    class function GetFileName: string; override;
    // 供 Users 直接调用的属性（读写 class var + 静态访问器）
    class property Enabled: Boolean read FEnabled write SetEnabledProc;
    class property FileName: string read FFileName write SetFileNameProc;
    class function Report: string; override;
    class function ReportJson: string; override;
    class procedure SaveOnExit;
    class procedure RegisterFunction(const AName: string; AAddr: Pointer);
    class procedure Reset; override;
    class constructor Create;
    class destructor Destroy;
  end;

procedure HookEntry_Start(AFuncIdx: Integer); stdcall;
procedure HookEntry_End(AFuncIdx: Integer); stdcall;

implementation

uses System.IOUtils;

threadvar
  TicksStack: array[0..31] of UInt64;
  FuncStack: array[0..31] of Integer;  // 调用栈（函数索引）
  RetStack: array[0..31] of Pointer;
  TicksDepth: Integer;

{$IFDEF WIN32}
const
  HSIZE = 6;
  TSIZE = 96;
{$ENDIF}
{$IFDEF WIN64}
const
  HSIZE = 14;
  TSIZE = 160;
{$ENDIF}

{ ---- HookEntry ---- }

procedure HookEntry_Start(AFuncIdx: Integer); stdcall;
var
  Depth: Integer;
begin
  Depth := TicksDepth;
  if Depth < 32 then begin
    TicksStack[Depth] := TStopWatch.GetTimeStamp;
    FuncStack[Depth] := AFuncIdx;  // 记录调用栈
    TicksDepth := Depth + 1;
  end;
    TQDetourProfiler.FLock.Enter;
  try
    Inc(TQDetourProfiler.FTotalCalls);
  finally
    TQDetourProfiler.FLock.Leave;
  end;
end;

procedure HookEntry_End(AFuncIdx: Integer); stdcall;
var
  EndTick, Delta: UInt64;
  Stat: TQDetourFuncStat;
  Addr, CallerAddr: Pointer;
  CallerIdx: Integer;
  Depth: Integer;
  EdgeKey: string;
  Edge: TQDetourCallEdge;
begin
  Depth := TicksDepth;
  if Depth > 0 then begin
    Dec(Depth);
    TicksDepth := Depth;
    EndTick := TStopWatch.GetTimeStamp;
    Delta := EndTick - TicksStack[Depth];

    // 确定调用者地址
    CallerAddr := nil;
    if Depth > 0 then begin
      CallerIdx := FuncStack[Depth - 1];
      if (CallerIdx >= 0) and (CallerIdx < Length(TQDetourProfiler.FMapEntries)) then
        CallerAddr := TQDetourProfiler.FMapEntries[CallerIdx].Address;
    end;

    TQDetourProfiler.FLock.Enter;
    try
      if AFuncIdx < Length(TQDetourProfiler.FMapEntries) then begin
        Addr := TQDetourProfiler.FMapEntries[AFuncIdx].Address;

        // ── 更新调用边统计 ──
        EdgeKey := TQDetourProfiler.EdgeKey(CallerAddr, Addr);
        if TQDetourProfiler.FCallEdges.TryGetValue(EdgeKey, Edge) then begin
          Edge.EntryCount := Edge.EntryCount + 1;
          Edge.TotalTicks := Edge.TotalTicks + Delta;
          if Delta < Edge.MinTicks then Edge.MinTicks := Delta;
          if Delta > Edge.MaxTicks then Edge.MaxTicks := Delta;
          TQDetourProfiler.FCallEdges[EdgeKey] := Edge;
        end
        else begin
          Edge.CallerAddr := CallerAddr;
          Edge.CalleeAddr := Addr;
          if CallerAddr <> nil then begin
            Edge.CallerName := TQDetourProfiler.FMapEntries[CallerIdx].Name;
          end;
          Edge.CalleeName := TQDetourProfiler.FMapEntries[AFuncIdx].Name;
          Edge.EntryCount := 1;
          Edge.TotalTicks := Delta;
          Edge.MinTicks := Delta;
          Edge.MaxTicks := Delta;
          TQDetourProfiler.FCallEdges.Add(EdgeKey, Edge);
        end;

        // ── 更新全函数统计 ──
        if TQDetourProfiler.FFuncStats.TryGetValue(Addr, Stat) then begin
          Inc(Stat.EntryCount);
          Inc(Stat.TotalTicks, Delta);
          if Delta < Stat.MinTicks then Stat.MinTicks := Delta;
          if Delta > Stat.MaxTicks then Stat.MaxTicks := Delta;
        end
        else begin
          Stat.Name := TQDetourProfiler.FMapEntries[AFuncIdx].Name;
          Stat.Address := Addr;
          Stat.EntryCount := 1;
          Stat.TotalTicks := Delta;
          Stat.MinTicks := Delta;
          Stat.MaxTicks := Delta;
          TQDetourProfiler.FFuncStats.Add(Addr, Stat);
        end;
        TQDetourProfiler.FFuncStats[Addr] := Stat;
      end;
    finally
      TQDetourProfiler.FLock.Leave;
    end;
  end;
end;

{$IFDEF WIN32}
procedure BuildTrampoline(AIndex: Integer; ATarget: Pointer; out Tramp: Pointer; out OutOrigOfs: Integer);
var
  B: PByte;
  Ofs, ExitOfs, OrigOfs: Integer;
begin
  Tramp := VirtualAlloc(nil, TSIZE, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if (Tramp = nil) or (NativeUInt(Tramp) < $10000) then begin
    if Tramp <> nil then
      VirtualFree(Tramp, 0, MEM_RELEASE);
    Tramp := nil;
    Exit;
  end;
  FillChar(Tramp^, TSIZE, 0);
  B := PByte(Tramp);
  Ofs := 0;
  // push ebp; mov ebp,esp; push ecx/edx/eax
  B[0] := $55;
  B[1] := $89;
  B[2] := $E5;
  Ofs := 3;
  B[Ofs] := $51;
  Inc(Ofs);
  B[Ofs] := $52;
  Inc(Ofs);
  B[Ofs] := $50;
  Inc(Ofs);
  // push func_idx; call HookEntry_Start
  B[Ofs] := $68;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := AIndex;
  Inc(Ofs, 4);
  B[Ofs] := $E8;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := Integer(@HookEntry_Start) - (Integer(Tramp) + Ofs + 4);
  Inc(Ofs, 4);
  // pop eax; pop edx; pop ecx; pop ebp
  B[Ofs] := $58;
  Inc(Ofs);
  B[Ofs] := $5A;
  Inc(Ofs);
  B[Ofs] := $59;
  Inc(Ofs);
  B[Ofs] := $5D;
  Inc(Ofs);
  // ExitOfs: --> function returns here
  ExitOfs := Ofs;
  // push eax; push ebp; push ecx/edx/eax; push idx; call End; restore; pop eax; ret
  B[Ofs] := $50;
  Inc(Ofs);
  B[Ofs] := $55;
  Inc(Ofs);
  B[Ofs] := $89;
  B[Ofs + 1] := $E5;
  Inc(Ofs, 2);
  B[Ofs] := $51;
  Inc(Ofs);
  B[Ofs] := $52;
  Inc(Ofs);
  B[Ofs] := $50;
  Inc(Ofs);
  B[Ofs] := $68;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := AIndex;
  Inc(Ofs, 4);
  B[Ofs] := $E8;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := Integer(@HookEntry_End) - (Integer(Tramp) + Ofs + 4);
  Inc(Ofs, 4);
  B[Ofs] := $58;
  Inc(Ofs);
  B[Ofs] := $5A;
  Inc(Ofs);
  B[Ofs] := $59;
  Inc(Ofs);
  B[Ofs] := $5D;
  Inc(Ofs);
  B[Ofs] := $58;
  Inc(Ofs);
  B[Ofs] := $C3;
  Inc(Ofs);
  // push ExitAddr; jmp OrigCode
  B[Ofs] := $68;
  Inc(Ofs); // push ExitAddr (32-bit)
  PInteger(@B[Ofs])^ := Integer(NativeUInt(Tramp) + ExitOfs);
  Inc(Ofs, 4);
  B[Ofs] := $E9;
  Inc(Ofs); // jmp OrigCode (placeholder rel32)
  var JmpPos := Ofs;
  Inc(Ofs, 4); // rel32 placeholder
  // align, OrigCode
  while (Ofs mod 4) <> 0 do begin
    B[Ofs] := $90;
    Inc(Ofs);
  end;
  OrigOfs := Ofs;
  Inc(Ofs, HSIZE);
  // JMP ATarget+HSIZE
  B[Ofs] := $E9;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := Integer(ATarget) + HSIZE - (Integer(Tramp) + Ofs + 4);
  Inc(Ofs, 4);
  // fix jmp OrigCode rel32
  PInteger(NativeUInt(Tramp) + JmpPos)^ := OrigOfs - (JmpPos + 4);
  // 输出 OrigOfs 供 InstallHook 使用
  PInteger(NativeUInt(Tramp) + TSIZE - 8)^ := OrigOfs;
  OutOrigOfs := OrigOfs;
end;
{$ENDIF}

{$IFDEF WIN64}
// x64 Trampoline — call OrigCode 模式
// [入口] push rcx,rdx,r8,r9 → sub rsp,40 → call Start → call OrigCode
// [出口] push rax → call End → jmp rax
// [OrigCode] 14 字节原指令 → mov rax,ATarget+14 → jmp rax
procedure BuildTrampoline(AIndex: Integer; ATarget: Pointer; out Tramp: Pointer; out OutOrigOfs: Integer);
var
  B: PByte;
  Ofs, CallRelPos: Integer;
begin
  Tramp := VirtualAlloc(nil, TSIZE, MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
  if Tramp = nil then begin
    OutOrigOfs := 0;
    Exit;
  end;
  FillChar(Tramp^, TSIZE, 0);
  B := PByte(Tramp);
  Ofs := 0;
  // push rcx; push rdx; push r8; push r9
  B[Ofs] := $51;
  Inc(Ofs);
  B[Ofs] := $52;
  Inc(Ofs);
  B[Ofs] := $41;
  Inc(Ofs);
  B[Ofs] := $50;
  Inc(Ofs);
  B[Ofs] := $41;
  Inc(Ofs);
  B[Ofs] := $51;
  Inc(Ofs);
  // sub rsp, 40
  B[Ofs] := $48;
  Inc(Ofs);
  B[Ofs] := $83;
  Inc(Ofs);
  B[Ofs] := $EC;
  Inc(Ofs);
  B[Ofs] := $28;
  Inc(Ofs);
  // mov rdx, [rsp+72] (真实返回地址)
  B[Ofs] := $48;
  Inc(Ofs);
  B[Ofs] := $8B;
  Inc(Ofs);
  B[Ofs] := $54;
  Inc(Ofs);
  B[Ofs] := $24;
  Inc(Ofs);
  B[Ofs] := $48;
  Inc(Ofs);
  // mov ecx, AIndex
  B[Ofs] := $B9;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := AIndex;
  Inc(Ofs, 4);
  // call HookEntry_Start
  B[Ofs] := $E8;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := Integer(@HookEntry_Start) - (Integer(Tramp) + Ofs + 4);
  Inc(Ofs, 4);
  // add rsp, 40
  B[Ofs] := $48;
  Inc(Ofs);
  B[Ofs] := $83;
  Inc(Ofs);
  B[Ofs] := $C4;
  Inc(Ofs);
  B[Ofs] := $28;
  Inc(Ofs);
  // pop r9; pop r8; pop rdx; pop rcx
  B[Ofs] := $41;
  Inc(Ofs);
  B[Ofs] := $59;
  Inc(Ofs);
  B[Ofs] := $41;
  Inc(Ofs);
  B[Ofs] := $58;
  Inc(Ofs);
  B[Ofs] := $5A;
  Inc(Ofs);
  B[Ofs] := $59;
  Inc(Ofs);
  // call OrigCode (占位)
  B[Ofs] := $E8;
  Inc(Ofs);
  CallRelPos := Ofs;
  Inc(Ofs, 4);
  // 出口代码
  B[Ofs] := $50;
  Inc(Ofs); // push rax (save retval)
  B[Ofs] := $48;
  Inc(Ofs);
  B[Ofs] := $83;
  Inc(Ofs);
  B[Ofs] := $EC;
  Inc(Ofs);
  B[Ofs] := $20;
  Inc(Ofs); // sub rsp,32
  B[Ofs] := $B9;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := AIndex;
  Inc(Ofs, 4); // mov ecx,AIndex
  B[Ofs] := $E8;
  Inc(Ofs);
  PInteger(@B[Ofs])^ := Integer(@HookEntry_End) - (Integer(Tramp) + Ofs + 4);
  Inc(Ofs, 4); // call End
  B[Ofs] := $48;
  Inc(Ofs);
  B[Ofs] := $83;
  Inc(Ofs);
  B[Ofs] := $C4;
  Inc(Ofs);
  B[Ofs] := $20;
  Inc(Ofs); // add rsp,32
  B[Ofs] := $58;
  Inc(Ofs); // pop rax (restore retval)
  B[Ofs] := $FF;
  Inc(Ofs);
  B[Ofs] := $E0;
  Inc(Ofs); // jmp rax (End 的返回值 = 真实返回地址)
  // OrigCode
  var OrigOfs := Ofs;
  Inc(Ofs, HSIZE);
  OutOrigOfs := OrigOfs;
  // mov rax, ATarget+HSIZE; jmp rax
  B[Ofs] := $48;
  Inc(Ofs);
  B[Ofs] := $B8;
  Inc(Ofs);
  PPointer(@B[Ofs])^ := Pointer(NativeUInt(ATarget) + HSIZE);
  Inc(Ofs, 8);
  B[Ofs] := $FF;
  Inc(Ofs);
  B[Ofs] := $E0;
  Inc(Ofs);
  // 修正 call rel32
  PInteger(NativeUInt(Tramp) + CallRelPos)^ := OrigOfs - (CallRelPos + 4);
end;
{$ENDIF}

// (continues below...)

{ ---- InstallHook ---- }

class procedure TQDetourProfiler.InstallHook(const AEntry: TQMapEntry; AIndex: Integer);
var
  Target: PByte;
  Tramp: Pointer;
  OldProtect: DWORD;
  I, OrigOfs: Integer;
{$IFDEF WIN32}
  JmpB: array[0..5] of Byte;
{$ELSE}
  JmpB: array[0..13] of Byte;
{$ENDIF}
begin
  Target := PByte(AEntry.Address);
  if Target = nil then
    Exit;
  for I := 0 to High(FHookAddrs) do
    if FHookAddrs[I] = Target then
      Exit;
  BuildTrampoline(AIndex, Target, Tramp, OrigOfs);
  if Tramp = nil then
    Exit;

  SetLength(FOrigBytes, Length(FOrigBytes) + 1);
  SetLength(FOrigBytes[High(FOrigBytes)], HSIZE);
  Move(Target^, FOrigBytes[High(FOrigBytes)][0], HSIZE);
  Move(Target^, Pointer(NativeUInt(Tramp) + OrigOfs)^, HSIZE);

{$IFDEF WIN32}
  JmpB[0] := $E9;
  PInteger(@JmpB[1])^ := Integer(Tramp) - (Integer(Target) + 5);
  JmpB[5] := $90;
{$ENDIF}
{$IFDEF WIN64}
  JmpB[0] := $FF;
  JmpB[1] := $25;
  JmpB[2] := 0;
  JmpB[3] := 0;
  JmpB[4] := 0;
  JmpB[5] := 0;
  PPointer(@JmpB[6])^ := Tramp;
{$ENDIF}

  VirtualProtect(Target, HSIZE, PAGE_EXECUTE_READWRITE, @OldProtect);
  Move(JmpB, Target^, HSIZE);
  VirtualProtect(Target, HSIZE, OldProtect, @OldProtect);
  FlushInstructionCache(GetCurrentProcess, Target, HSIZE);

  SetLength(FHookAddrs, Length(FHookAddrs) + 1);
  FHookAddrs[High(FHookAddrs)] := Target;
  SetLength(FTrampolines, Length(FTrampolines) + 1);
  FTrampolines[High(FTrampolines)] := Tramp;
end;

class procedure TQDetourProfiler.UninstallHooks;
var
  I: Integer;
  OldProtect: DWORD;
begin
  for I := 0 to High(FHookAddrs) do
    if (FHookAddrs[I] <> nil) and (I < Length(FOrigBytes)) then begin
      VirtualProtect(FHookAddrs[I], HSIZE, PAGE_EXECUTE_READWRITE, @OldProtect);
      Move(FOrigBytes[I][0], FHookAddrs[I]^, HSIZE);
      VirtualProtect(FHookAddrs[I], HSIZE, OldProtect, @OldProtect);
    end;
  FlushInstructionCache(GetCurrentProcess, nil, 0);
  for I := 0 to High(FTrampolines) do
    if FTrampolines[I] <> nil then
      VirtualFree(FTrampolines[I], 0, MEM_RELEASE);
  FHookAddrs := nil;
  FTrampolines := nil;
  FOrigBytes := nil;
end;

class function TQDetourProfiler.FindMapFile: string;
var
  E, M: string;
begin
  E := ParamStr(0);
  M := ChangeFileExt(E, '.map');
  if FileExists(M) then
    Exit(M);
  M := ExtractFilePath(E) + ChangeFileExt(ExtractFileName(E), '.map');
  if FileExists(M) then
    Exit(M);
  Result := '';
end;

class function TQDetourProfiler.ParseMapFile(const AFileName: string): TArray<TQMapEntry>;
var
  L: TArray<string>;
  I: Integer;
  Line: string;
  InP: Boolean;
  SB: array[1..8] of DWORD;
  SN: Word;
  Off: DWORD;
  Nm: string;
  RVA: DWORD;
  E: TQMapEntry;
begin
  Result := nil;
  if not FileExists(AFileName) then
    Exit;
  L := TFile.ReadAllLines(AFileName);
  FillChar(SB, SizeOf(SB), 0);
  for I := 0 to Min(19, High(L)) do begin
    Line := Trim(L[I]);
    if (Length(Line) > 20) and (Line[5] = ':') then begin
      SN := StrToIntDef('$' + Copy(Line, 1, 4), 0);
      if (SN < 1) or (SN > 8) then
        Continue;
      RVA := StrToIntDef('$' + Copy(Line, 6, 9), 0);
      SB[SN] := RVA;
    end;
  end;
  InP := False;
  for I := 0 to High(L) do begin
    Line := Trim(L[I]);
    if Line = '' then
      Continue;
    if Line.Contains('Publics by Value') then begin
      InP := True;
      Continue;
    end;
    if InP then begin
      if Line.StartsWith('Line numbers for ') or Line.StartsWith('Program entry point') then
        Break;
      if (Length(Line) >= 15) and (Line[5] = ':') then begin
        SN := StrToIntDef('$' + Copy(Line, 1, 4), 0);
        if (SN < 1) or (SN > 8) then
          Continue;
        Off := StrToIntDef('$' + Copy(Line, 6, 8), 0);
        Nm := Trim(Copy(Line, 19, MaxInt));
        if (Nm = '') or Nm.StartsWith('$') then
          Continue;
        if Nm.StartsWith('System.')
            or Nm.StartsWith('Sysutils.')
            or Nm.StartsWith('Winapi.')
            or Nm.StartsWith('Vcl.') then
          Continue;
        if Nm.EndsWith('.Finalization') then
          Continue;
        E.Address := Pointer(SB[SN] + Off);
        E.Name := Nm;
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := E;
      end;
    end;
  end;
end;

class procedure TQDetourProfiler.LoadMap;
begin
end;

class procedure TQDetourProfiler.RegisterFunction(const AName: string; AAddr: Pointer);
var
  E: TQMapEntry;
begin
  E.Name := AName;
  E.Address := AAddr;
  FLock.Enter;
  try
    SetLength(FMapEntries, Length(FMapEntries) + 1);
    FMapEntries[High(FMapEntries)] := E;
  finally
    FLock.Leave;
  end;
end;

class function TQDetourProfiler.EdgeKey(CallerAddr, CalleeAddr: Pointer): string;
begin
  Result := IntToHex(NativeUInt(CallerAddr), 8) + '|' + IntToHex(NativeUInt(CalleeAddr), 8);
end;

class constructor TQDetourProfiler.Create;
begin
  FEnabled := False;
  FFileName := ExtractFilePath(ParamStr(0)) + 'detour_profile.json';
  FLock := TCriticalSection.Create;
  FFuncStats := TDictionary<Pointer, TQDetourFuncStat>.Create;
  FCallEdges := TDictionary<string, TQDetourCallEdge>.Create;
  FTotalCalls := 0;
end;

class destructor TQDetourProfiler.Destroy;
begin
  SetEnabledProc(False);
  FreeAndNil(FFuncStats);
  FreeAndNil(FCallEdges);
  FreeAndNil(FLock);
end;

class function TQDetourProfiler.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

class procedure TQDetourProfiler.SetEnabledProc(const Value: Boolean);
var
  I: Integer;
begin
  if FEnabled = Value then
    Exit;
  if Value then begin
    for I := 0 to High(FMapEntries) do
      InstallHook(FMapEntries[I], I);
  end
  else
    UninstallHooks;
  FEnabled := Value;
end;

class procedure TQDetourProfiler.Reset;
begin
  FLock.Enter;
  try
    FFuncStats.Clear;
    FCallEdges.Clear;
    FTotalCalls := 0;
  finally
    FLock.Leave;
  end;
end;

class procedure TQDetourProfiler.AppendChainJson(SB: TStringBuilder; CallerAddr: Pointer; Indent: string);
var
  Edges: TArray<TQDetourCallEdge>;
  Edge: TQDetourCallEdge;
  I, ChildCount: Integer;
  EdgeKey: string;
begin
  // 收集所有以 CallerAddr 为调用者的边
  Edges := nil;
  for Edge in FCallEdges.Values do begin
    if Edge.CallerAddr = CallerAddr then begin
      SetLength(Edges, Length(Edges) + 1);
      Edges[High(Edges)] := Edge;
    end;
  end;

  for I := 0 to High(Edges) do begin
    Edge := Edges[I];
    SB.Append(Indent).Append('{');
    SB.Append('"name":"').Append(Edge.CalleeName).Append('"');
    SB.Append(',"addr":"').Append(IntToHex(NativeUInt(Edge.CalleeAddr))).Append('"');
    SB.Append(',"calls":').Append(Edge.EntryCount);
    SB.Append(',"totalTicks":').Append(Edge.TotalTicks);
    SB.Append(',"minTicks":').Append(Edge.MinTicks);
    SB.Append(',"maxTicks":').Append(Edge.MaxTicks);
    SB.Append(',"avgTicks":').Append(Edge.TotalTicks div Edge.EntryCount);
    // 递归找子节点
    SB.Append(',').AppendLine;
    SB.Append(Indent).Append('"children": [');
    var SubIndent := Indent + '  ';
    // 检查是否有子节点
    ChildCount := 0;
    for EdgeKey in FCallEdges.Keys do
      if FCallEdges[EdgeKey].CallerAddr = Edge.CalleeAddr then
        Inc(ChildCount);
    if ChildCount > 0 then begin
      SB.AppendLine;
      AppendChainJson(SB, Edge.CalleeAddr, SubIndent);
      SB.Append(Indent);
    end;
    SB.Append(']');
    SB.Append('}');
    if I < High(Edges) then
      SB.Append(',');
    SB.AppendLine;
  end;
end;

class procedure TQDetourProfiler.AppendChainText(SB: TStringBuilder; CallerAddr: Pointer; Indent: string; IsLast: Boolean);
var
  Edges: TArray<TQDetourCallEdge>;
  Edge: TQDetourCallEdge;
  I: Integer;
  Sep: string;
begin
  Edges := nil;
  for Edge in FCallEdges.Values do begin
    if Edge.CallerAddr = CallerAddr then begin
      SetLength(Edges, Length(Edges) + 1);
      Edges[High(Edges)] := Edge;
    end;
  end;

  for I := 0 to High(Edges) do begin
    Edge := Edges[I];
    if I = High(Edges) then
      Sep := '  └─ '
    else
      Sep := '  ├─ ';
    SB.Append(Indent).Append(Sep).Append(Edge.CalleeName);
    SB.Append('  (').Append(Edge.EntryCount).Append(' calls, ');
    SB.Append(FormatFloat('0.00', Edge.TotalTicks / TStopWatch.Frequency * 1000)).Append(' ms)');
    SB.AppendLine;
    AppendChainText(SB, Edge.CalleeAddr, Indent + '  ', I = High(Edges));
  end;
end;

class function TQDetourProfiler.Report: string;
var
  SB: TStringBuilder;
  L: TList<TQDetourFuncStat>;
  P: TPair<Pointer, TQDetourFuncStat>;
  I: Integer;
begin
  SB := TStringBuilder.Create;
  try
    SB.AppendLine('=== TQDetourProfiler ===');
    SB.Append('  totalCalls: ').Append(FTotalCalls).AppendLine;
    if (FFuncStats.Count = 0) and (FCallEdges.Count = 0) then
      Exit('(no data)');

    // ── 调用链树 ──
    if FCallEdges.Count > 0 then begin
      SB.AppendLine;
      SB.AppendLine('--- Call Chains ---');
      AppendChainText(SB, nil, '', True);
    end;

    // ── 平铺函数统计 ──
    if FFuncStats.Count > 0 then begin
      L := TList<TQDetourFuncStat>.Create;
      try
        for P in FFuncStats do
          L.Add(P.Value);
        L.Sort(
            TComparer<TQDetourFuncStat>.Construct(
                function(const L, R: TQDetourFuncStat): Integer
                begin
                  Result := -CompareValue(L.TotalTicks, R.TotalTicks);
                end
            )
        );
        SB.AppendLine;
        SB.AppendLine('--- Flat Profile (by total time) ---');
        SB.AppendLine('  Calls  Avg(us)  Tot(ms)  Function');
        SB.AppendLine('  ' + StringOfChar('-', 70));
        for I := 0 to Min(L.Count - 1, 50) do
          with L[I] do
            SB
                .AppendFormat(
                    '  %5d  %7.2f  %8.2f  %s',
                    [
                        EntryCount,
                        TotalTicks / EntryCount / TStopWatch.Frequency * 1000000,
                        TotalTicks / TStopWatch.Frequency * 1000,
                        Name
                    ])
                .AppendLine;
      finally
        L.Free;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TQDetourProfiler.ReportJson: string;
var
  SB: TStringBuilder;
  L: TList<TQDetourFuncStat>;
  P: TPair<Pointer, TQDetourFuncStat>;
  I: Integer;
  TotalHits: Int64;
begin
  SB := TStringBuilder.Create;
  try
    TotalHits := 0;
    for P in FFuncStats do
      Inc(TotalHits, P.Value.EntryCount);

    SB.AppendLine('{');
    SB.Append('  "totalCalls": ').Append(FTotalCalls).Append(',').AppendLine;

    // ── 调用链 ──
    SB.AppendLine('  "callChains": [');
    AppendChainJson(SB, nil, '    ');
    SB.AppendLine('  ],');

    // ── 平铺函数统计 ──
    SB.AppendLine('  "hotFunctions": [');
    if FFuncStats.Count > 0 then begin
      L := TList<TQDetourFuncStat>.Create;
      try
        for P in FFuncStats do
          L.Add(P.Value);
        L.Sort(
          TComparer<TQDetourFuncStat>.Construct(
            function(const L, R: TQDetourFuncStat): Integer
            begin
              Result := -CompareValue(L.TotalTicks, R.TotalTicks);
            end
          )
        );
        for I := 0 to L.Count - 1 do begin
          with L[I] do begin
            SB.Append('    {"name":"').Append(Name)
              .Append('","addr":"').Append(IntToHex(NativeUInt(Address)))
              .Append('","calls":').Append(EntryCount)
              .Append(',"totalTicks":').Append(TotalTicks)
              .Append(',"minTicks":').Append(MinTicks)
              .Append(',"maxTicks":').Append(MaxTicks)
              .Append(',"avgTicks":').Append(TotalTicks div EntryCount)
              .Append(',"pct":').Append(FormatFloat('0.00', EntryCount / TotalHits * 100))
              .Append('"}');
          end;
          if I < L.Count - 1 then
            SB.Append(',');
          SB.AppendLine;
        end;
      finally
        L.Free;
      end;
    end;
    SB.AppendLine('  ]');
    SB.AppendLine('}');
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TQDetourProfiler.GetFileName: string;
begin
  Result := FFileName;
end;

class procedure TQDetourProfiler.SetFileNameProc(const Value: string);
begin
  FFileName := Value;
end;

class procedure TQDetourProfiler.SaveOnExit;
begin
  SaveToFile;
end;

procedure DetourExitProc;
begin
  TQDetourProfiler.SaveOnExit;
end;

initialization
  AddExitProc(DetourExitProc);

finalization
  TQDetourProfiler.Enabled := False;
end.

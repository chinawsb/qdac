unit QFileMapStream;

interface

uses classes, sysutils, windows;

const
  FILE_MAP_WINDOW_MAX_SIZE = 64 * 1024; // 64K，理论上这个窗口大点更好

type
  TQFileStream = class(TFileStream)
  protected
    FWindowOffset: Int64;
    FWindow: PByte;
    FWindowSize: Integer;
    FMapHandle: THandle;
    procedure WindowNeeded;
    procedure SetSize(const NewSize: Int64); override;
  public
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Read(Buffer: TBytes; Offset, Count: Longint): Longint; override;
    function Write(const Buffer: TBytes; Offset, Count: Longint)
      : Longint; override;
  end;

implementation

{ TQFileStream }

destructor TQFileStream.Destroy;
begin
  if Assigned(FWindow) then
    UnmapViewOfFile(FWindow);
  if FMapHandle <> 0 then
    CloseHandle(FMapHandle);
  inherited;
end;

function TQFileStream.Read(Buffer: TBytes; Offset, Count: Integer): Longint;
begin
  Result := Read(Buffer[Offset], Count);
end;

procedure TQFileStream.SetSize(const NewSize: Int64);
begin
  if NewSize <> Size then
  begin
    if FMapHandle <> 0 then
    begin
      CloseHandle(FMapHandle);
      FMapHandle := 0;
    end;
  end;
  inherited;

end;

function TQFileStream.Read(var Buffer; Count: Integer): Longint;
var
  APos, ASize: Int64;
  AToCopy, AOffset, ARemain: Integer;
  ps, pd: PByte;
begin
  Result := 0;
  if Count > 0 then
  begin
    APos := Position;
    ASize := Size;
    pd := Pointer(@Buffer);
    while Count > 0 do
    begin
      WindowNeeded;
      AOffset := APos - FWindowOffset;
      ps := FWindow + AOffset;
      ARemain := FWindowSize - AOffset;
      if ARemain = 0 then
        Break;
      AToCopy := Count;
      if AToCopy > ARemain then
        AToCopy := ARemain;
      Move(ps^, pd^, AToCopy);
      Inc(APos, AToCopy);
      Inc(pd, AToCopy);
      Dec(Count, AToCopy);
      Inc(Result, AToCopy);
      Position := Position + AToCopy;
    end;
  end;

end;

procedure TQFileStream.WindowNeeded;
var
  APos: LARGE_INTEGER;
begin
  if FMapHandle = 0 then
  begin
    FMapHandle := CreateFileMappingW(Handle, nil, PAGE_READWRITE,
      0, 0, nil);
    if FMapHandle = 0 then
      RaiseLastOSError(GetLastError);
  end;
  APos.QuadPart := Position;
  APos.LowPart := APos.LowPart and $FFFF0000; // 64K对齐
  if not Assigned(FWindow) then
  begin
    FWindowSize := Size - APos.QuadPart;
    if FWindowSize > FILE_MAP_WINDOW_MAX_SIZE then
      FWindowSize := FILE_MAP_WINDOW_MAX_SIZE;
    FWindowOffset := APos.QuadPart;
    FWindow := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, APos.LowPart,
      APos.HighPart, FWindowSize);
  end
  else if FWindowOffset <> APos.QuadPart then
  begin
    UnmapViewOfFile(FWindow);
    FWindowSize := Size - APos.QuadPart;
    if FWindowSize > FILE_MAP_WINDOW_MAX_SIZE then
      FWindowSize := FILE_MAP_WINDOW_MAX_SIZE;
    FWindowOffset := APos.QuadPart;
    FWindow := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, APos.HighPart,
      APos.LowPart, FWindowSize);
  end;
  if not Assigned(FWindow) then
    RaiseLastOSError(GetLastError);
end;

function TQFileStream.Write(const Buffer: TBytes;
  Offset, Count: Integer): Longint;
begin
  Result := Write(Buffer[Offset], Count);
end;

function TQFileStream.Write(const Buffer; Count: Integer): Longint;
var
  APos, ASize: Int64;
  ps, pd: PByte;
  AOffset, ARemain, AToCopy: Integer;
begin
  Result := 0;
  if Count > 0 then
  begin
    APos := Position;
    ASize := Size;
    // 首先预分配空间，然后才能映射
    if APos + Count > ASize then
    begin
      Size := APos + Count;
      Position := APos;
      if Assigned(FWindow) then
      begin
        UnmapViewOfFile(FWindow);
        FWindow := nil;
      end;
    end;
    ps := Pointer(@Buffer);
    repeat
      WindowNeeded;
      AOffset := APos - FWindowOffset;
      pd := FWindow + AOffset;
      ARemain := FWindowSize - AOffset;
      if ARemain = 0 then
        Break;
      AToCopy := Count;
      if AToCopy > ARemain then
        AToCopy := ARemain;
      Move(ps^, pd^, AToCopy);
      Inc(APos, AToCopy);
      Inc(pd, AToCopy);
      Dec(Count, AToCopy);
      Inc(Result, AToCopy);
      Position := Position + AToCopy;
    until Count = 0;
  end;
end;

end.

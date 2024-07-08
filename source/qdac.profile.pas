unit qdac.profile;

interface

uses System.Classes, System.SysUtils, System.Generics.Defaults, System.Generics.Collections, System.Diagnostics,
  System.TimeSpan;

type
  TQProfileStatics = record
    InvokeTimes: Cardinal;
    MinTime, MaxTime: Double;
    TotalTime: TTimeSpan;
    Watch: TStopWatch;
  end;

  PQProfileStatics = ^TQProfileStatics;

  IQProfileItem = interface
    ['{DC00C3C3-7140-4BEB-AF09-7F20E36C169E}']
    function GetName: String;
    function GetStatics: PQProfileStatics;
    property Name: String read GetName;
    property Statics: PQProfileStatics read GetStatics;
  end;

  TQProfile = class sealed
  private
    class var FCurrent: TQProfile;
  private
    FItems: TDictionary<NativeUInt, IQProfileItem>;
    FEnabled: Boolean;
    constructor Create;
    procedure SaveProfiles();
  public
    property Enabled: Boolean read FEnabled write FEnabled;
    class property Current: TQProfile read FCurrent;
  end;

{$IFDEF CPUX64}
{$DEFINE CPU_CLASSIC}
{$ENDIF}
{$IFDEF CPUX86}
{$DEFINE CPU_CLASSIC}
{$ENDIF}
{$IFDEF CPU_CLASSIC}

  // 只有 X86/64 CPU 才支持，其它不支持汇编，无法获取
function GetEIP: NativeUInt; stdcall;
{$ENDIF}
function ProfileLog(const AName: String; Addr: NativeUInt = 0): IInterface;

implementation

type
  TQProfileItem = class(TInterfacedObject, IQProfileItem, IUnknown)
  private
    FName: String;
    FAddr: NativeUInt;
    FWatch: TStopWatch;
    FStatics: TQProfileStatics;
    function GetName: String;
    function GetStatics: PQProfileStatics;
  public
    constructor Create(const AName: string; const Addr: NativeUInt);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;
{$IFDEF CPU_CLASSIC}

function GetEIP: NativeUInt; stdcall;
asm
  {$IFDEF CPUX86}
  POP EAX;
  PUSH EAX;
  {$ELSE}
  POP RAX;
  PUSH RAX;
  {$ENDIF}
end;
{$ENDIF}

function ProfileLog(const AName: String; Addr: NativeUInt): IInterface;
var
  ATemp: IQProfileItem;
begin
  if TQProfile.FCurrent.Enabled then
  begin
    TMonitor.Enter(TQProfile.FCurrent);
    try
      if not TQProfile.FCurrent.FItems.TryGetValue(Addr, ATemp) then
      begin
        ATemp := TQProfileItem.Create(AName, Addr);
        TQProfile.FCurrent.FItems.Add(Addr, ATemp);
      end;
    finally
      TMonitor.Exit(TQProfile.FCurrent);
    end;
    Result := ATemp;
  end
  else
    Result := nil;
end;

{ TQProfile }

constructor TQProfile.Create;
begin
  inherited;
  FItems := TDictionary<NativeUInt, IQProfileItem>.Create;
end;

procedure TQProfile.SaveProfiles;
var
  ABuilder: TStringBuilder;
  AItems: TArray<IQProfileItem>;
  AStream: TFileStream;
  AData: TBytes;
begin
  FEnabled := false;
  ABuilder := TStringBuilder.Create;
  try
    ABuilder.Append('{').Append(SLineBreak);
    AItems := FItems.Values.ToArray;
    TArray.Sort<IQProfileItem>(AItems, TComparer<IQProfileItem>.Construct(
      function(const L, R: IQProfileItem): Integer
      begin
        if L.Statics.TotalTime > R.Statics.TotalTime then
          Result := 1
        else if L.Statics.TotalTime < R.Statics.TotalTime then
          Result := -1
        else
          Result := 0;
      end));
    for var I := 0 to High(AItems) do
    begin
      if I > 0 then
        ABuilder.Append(',').Append(SLineBreak);
      with AItems[I].Statics^ do
      begin
        ABuilder.Append('"').Append(AItems[I].Name).Append('":{').Append(SLineBreak) //
          .Append('  "totalTime":').Append(TotalTime.TotalMilliseconds).Append(SLineBreak) //
          .Append('  "invokeTimes":').Append(InvokeTimes).Append(SLineBreak) //
          .Append('  "minTime":').Append(MinTime).Append(SLineBreak) //
          .Append('  "maxTime":').Append(MaxTime).Append(SLineBreak) //
          .Append('  "avgTime":').Append(Double(TotalTime.TotalMilliseconds / InvokeTimes)).Append(SLineBreak)
          .Append('  }');
      end;
    end;
    ABuilder.Append(SLineBreak).Append('}');
    AStream := TFileStream.Create('profiles.json', fmCreate);
    try
      AData := TEncoding.UTF8.GetBytes(ABuilder.ToString);
      AStream.WriteBuffer(AData[0], Length(AData));
    finally
      FreeAndNil(AStream);
    end;
  finally
    FreeAndNil(ABuilder);
    FEnabled := true;
  end;
end;

{ TQProfileItem }

constructor TQProfileItem.Create(const AName: string; const Addr: NativeUInt);
begin
  inherited Create;
  FName := AName;
  FAddr := Addr;
end;

function TQProfileItem.GetName: String;
begin
  Result := FName;
end;

function TQProfileItem.GetStatics: PQProfileStatics;
begin
  Result := @FStatics;
end;

function TQProfileItem._AddRef: Integer;
begin
  Result := inherited;
  if Result = 2 then // 如果是递归，忽略后续调用
  begin
    FWatch.Reset;
    FWatch.Start;
  end;
end;

function TQProfileItem._Release: Integer;
var
  ADelta: TTimeSpan;
begin
  Result := inherited;
  if Result = 1 then
  begin
    FWatch.Stop;
    Inc(FStatics.InvokeTimes);
    ADelta := FWatch.Elapsed;
    if FStatics.InvokeTimes = 1 then
    begin
      FStatics.MinTime := ADelta.TotalMilliseconds;
      FStatics.MaxTime := FStatics.MinTime;
    end
    else
    begin
      var
      ADuration := ADelta.TotalMilliseconds;
      if ADuration > FStatics.MaxTime then
        FStatics.MaxTime := ADuration;
      if ADuration < FStatics.MinTime then
        FStatics.MinTime := ADuration;
    end;
    FStatics.TotalTime := FStatics.TotalTime + ADelta;
  end;
end;

initialization

TQProfile.FCurrent := TQProfile.Create;
TQProfile.FCurrent.Enabled := true;

finalization

TQProfile.FCurrent.SaveProfiles;
FreeAndNil(TQProfile.FCurrent);

end.

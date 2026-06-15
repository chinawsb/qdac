program serialization.thread_test;

{$APPTYPE CONSOLE}

uses
  System.SysUtils, System.Classes, System.SyncObjs, System.DateUtils,
  System.Generics.Collections,
  qdac.common in '..\..\..\..\Source\qdac.common.pas',
  qdac.attribute in '..\..\..\..\Source\qdac.attribute.pas',
  qdac.serialize.core in '..\..\..\..\Source\qdac.serialize.core.pas',
  qdac.json.core in '..\..\..\..\Source\qdac.json.core.pas';

type
  TThreadTestRecord = record
    Id: Integer;
    Name: string;
    Value: Double;
  end;

  TParseThread = class(TThread)
  private
    FJson: string;
    FIndex: Integer;
    FErrCount: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(const AJson: string; AIndex: Integer);
    property ErrCount: Integer read FErrCount;
  end;

  TCacheThread = class(TThread)
  private
    FIterations: Integer;
    FErrCount: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(AIterations: Integer);
    property ErrCount: Integer read FErrCount;
  end;

  TSerializerThread = class(TThread)
  private
    FData: TThreadTestRecord;
    FErrCount: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(const AData: TThreadTestRecord);
    property ErrCount: Integer read FErrCount;
  end;

var
  GErr: Integer;
  GErrLock: TCriticalSection;
  GTotalThreads: Integer;
  GCompletedThreads: Integer;
  GCompleteLock: TCriticalSection;

procedure LogErr;
begin
  GErrLock.Enter;
  try
    Inc(GErr);
  finally
    GErrLock.Leave;
  end;
end;

{ TParseThread }

constructor TParseThread.Create(const AJson: string; AIndex: Integer);
begin
  inherited Create(False);
  FJson := AJson;
  FIndex := AIndex;
  FErrCount := 0;
  FreeOnTerminate := False;
end;

procedure TParseThread.Execute;
var
  N: TQJsonNode;
  I: Integer;
begin
  N := TQJsonNode.Create;
  try
    for I := 1 to 500 do begin
      N.TryParse(FJson, jsmNormal);
      if N.IntByName('a') <> 42 then begin
        Inc(FErrCount);
        LogErr;
      end;
      N.Reset;
      // Alternate modes
      if (I mod 10) = 0 then begin
        N.TryParse(FJson, jsmCacheStrings);
        N.Reset;
        N.TryParse(FJson, jsmForwardOnly);
        N.Reset;
      end;
    end;
  finally
    N.Free;
  end;
  GCompleteLock.Enter;
  try
    Inc(GCompletedThreads);
  finally
    GCompleteLock.Leave;
  end;
end;

{ TCacheThread }

constructor TCacheThread.Create(AIterations: Integer);
begin
  inherited Create(False);
  FIterations := AIterations;
  FErrCount := 0;
  FreeOnTerminate := False;
end;

procedure TCacheThread.Execute;
var
  I: Integer;
  S: string;
begin
  for I := 1 to FIterations do begin
    S := 'key_' + I.ToString;
    // Concurrent AddRef/Release on TQJsonStringCaches
    var P := TQJsonStringCaches.Current.AddRef(@S);
    if TQJsonStringCaches.Current.Release(P) <> P then begin
      Inc(FErrCount);
      LogErr;
    end;
  end;
  GCompleteLock.Enter;
  try
    Inc(GCompletedThreads);
  finally
    GCompleteLock.Leave;
  end;
end;

{ TSerializerThread }

constructor TSerializerThread.Create(const AData: TThreadTestRecord);
begin
  inherited Create(False);
  FData := AData;
  FErrCount := 0;
  FreeOnTerminate := False;
end;

procedure TSerializerThread.Execute;
var
  AStream: TBytesStream;
  AResult: TThreadTestRecord;
  I: Integer;
begin
  for I := 1 to 500 do begin
    AStream := TBytesStream.Create;
    try
      TQSerializer.Current.SaveToStream<TThreadTestRecord>(FData, AStream, 'json');
      AStream.Position := 0;
      AResult := Default(TThreadTestRecord);
      TQSerializer.Current.LoadFromStream<TThreadTestRecord>(AResult, AStream, 'json');
      if (AResult.Id <> FData.Id) or (AResult.Name <> FData.Name) then begin
        Inc(FErrCount);
        LogErr;
      end;
    finally
      AStream.Free;
    end;
  end;
  GCompleteLock.Enter;
  try
    Inc(GCompletedThreads);
  finally
    GCompleteLock.Leave;
  end;
end;

var
  Threads: TArray<TThread>;
  I, TotalErrors: Integer;
  StartTime: TDateTime;
  Src: TThreadTestRecord;
begin
  GErrLock := TCriticalSection.Create;
  GCompleteLock := TCriticalSection.Create;
  Threads := [];
  GErr := 0;
  GCompletedThreads := 0;

  Writeln('=== Thread Safety Stress Tests ===');
  Writeln;

  // Test 1: Concurrent parsing — 8 threads parse JSON 500 times each
  Writeln('Test 1: Concurrent parsing (8 threads x 500 iterations)');
  GCompletedThreads := 0;
  for I := 0 to 7 do
    Threads := Threads + [TParseThread.Create('{"a":42,"b":"hello","c":3.14}', I)];
  for I := 0 to High(Threads) do
    Threads[I].WaitFor;
  for I := 0 to High(Threads) do
    Threads[I].Free;
  Threads := [];
  Writeln(Format('  %d threads completed, %d errors', [8, GErr]));

  // Test 2: Concurrent string cache — 4 threads hammer TQJsonStringCaches
  Writeln('Test 2: Concurrent string cache (4 threads x 5000 AddRef/Release)');
  TQJsonStringCaches.Current.Clear;
  GErr := 0;
  GCompletedThreads := 0;
  for I := 0 to 3 do
    Threads := Threads + [TCacheThread.Create(5000)];
  for I := 0 to High(Threads) do
    Threads[I].WaitFor;
  for I := 0 to High(Threads) do
    Threads[I].Free;
  Threads := [];
  Writeln(Format('  cache entries: %d, errors: %d', [TQJsonStringCaches.Current.Count, GErr]));

  // Test 3: Concurrent serialization — 8 threads serialize/deserialize
  Writeln('Test 3: Concurrent serialization (8 threads x 500 round-trips)');
  GErr := 0;
  GCompletedThreads := 0;
  for I := 0 to 7 do begin
    Src.Id := I;
    Src.Name := 'Thread_' + I.ToString;
    Src.Value := I * 1.5;
    Threads := Threads + [TSerializerThread.Create(Src)];
  end;
  for I := 0 to High(Threads) do
    Threads[I].WaitFor;
  for I := 0 to High(Threads) do
    Threads[I].Free;
  Threads := [];
  Writeln(Format('  %d threads completed, %d errors', [8, GErr]));

  // Summary
  TotalErrors := GErr;
  Writeln;
  if TotalErrors = 0 then
    Writeln('ALL THREAD SAFETY TESTS PASSED!')
  else
    Writeln(TotalErrors, ' THREAD SAFETY TEST(S) FAILED');

  GErrLock.Free;
  GCompleteLock.Free;
  Readln;
end.

unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, syncobjs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qworker, SQLMemCriticalSection, yxdsync;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ACS: TCriticalSection;
  ASMRSW: TSQLMemReadWriteThreadSyncByCriticalSections;
  AYxd: TShareRWSync;
  AVcl: TMultiReadExclusiveWriteSynchronizer;
  AReadCount: Integer;
  AWriteCount: Integer;
  TM, TC, TS, TY, TV: Cardinal;
  I: Integer;
  AGroup: TQJobGroup;
begin
  Button1.Enabled := False;
  Application.ProcessMessages;
  Workers.MaxWorkers := 500;
  ACS := TCriticalSection.Create;
  ASMRSW := TSQLMemReadWriteThreadSyncByCriticalSections.Create(True);
  AYxd := TShareRWSync.Create;
  AVcl := TMultiReadExclusiveWriteSynchronizer.Create;
  AGroup := TQJobGroup.Create(False);
  try
    Memo1.Lines.Add('Prepare testing');
    AGroup.Prepare;
    for I := 0 to 100 do
      AGroup.Add(
        procedure(AJob: PQJob)
        begin
          Sleep(0);
        end, nil);
    AGroup.Run;
    AGroup.MsgWaitFor();
    Memo1.Lines.Add('Delphi default testing...');
    TV := GetTickCount;
    AReadCount := 0;
    AWriteCount := 0;
    AGroup.Prepare;
    for I := 0 to 99 do
    begin
      AGroup.Add(
        procedure(AJob: PQJob)
        var
          J: Integer;
        begin
          if (IntPtr(AJob.Data) mod 10) < 8 then
          begin
            for J := 0 to 99 do
            begin
              AVcl.BeginRead;
              AtomicIncrement(AReadCount);
              Sleep(10);
              AVcl.EndRead;
            end;
          end
          else
          begin
            for J := 0 to 99 do
            begin
              AVcl.BeginWrite;
              AtomicIncrement(AWriteCount);
              Sleep(10);
              AVcl.EndWrite;
            end;
          end;
        end, Pointer(I));
    end;
    AGroup.Run();
    AGroup.MsgWaitFor();
    TV := GetTickCount - TV;
    Memo1.Lines.Add('Delphi:' + IntToStr(TV) + 'ms');
    Memo1.Lines.Add('CrticalSection testing...');
    TC := GetTickCount;
    AReadCount := 0;
    AWriteCount := 0;
    AGroup.Prepare;
    for I := 0 to 99 do
    begin
      AGroup.Add(
        procedure(AJob: PQJob)
        var
          J: Integer;
        begin
          if (IntPtr(AJob.Data) mod 10) < 8 then
          begin
            for J := 0 to 99 do
            begin
              ACS.Enter;
              AtomicIncrement(AReadCount);
              Sleep(10);
              ACS.Leave;
            end;
          end
          else
          begin
            for J := 0 to 99 do
            begin
              ACS.Enter;
              AtomicIncrement(AWriteCount);
              Sleep(10);
              ACS.Leave;
            end;
          end;
        end, Pointer(I));
    end;
    AGroup.Run();
    AGroup.MsgWaitFor();
    TC := GetTickCount - TC;
    Memo1.Lines.Add('CriticalSection :' + IntToStr(TC) + 'ms');
    Memo1.Lines.Add('SQLMemMRSW testing...');
    TS := GetTickCount;
    AReadCount := 0;
    AWriteCount := 0;
    AGroup.Prepare;
    for I := 0 to 99 do
    begin
      AGroup.Add(
        procedure(AJob: PQJob)
        var
          J: Integer;
        begin
          if (IntPtr(AJob.Data) mod 10) < 8 then
          begin
            for J := 0 to 99 do
            begin
              ASMRSW.WaitAndLockForRead;
              AtomicIncrement(AReadCount);
              Sleep(10);
              ASMRSW.Unlock;
            end;
          end
          else
          begin
            for J := 0 to 99 do
            begin
              ASMRSW.WaitAndLockForWrite;
              AtomicIncrement(AWriteCount);
              Sleep(10);
              ASMRSW.Unlock;
            end;
          end;
        end, Pointer(I));
    end;
    AGroup.Run();
    AGroup.MsgWaitFor();
    TS := GetTickCount - TS;
    Memo1.Lines.Add('SQLMemMRSW:' + IntToStr(TS) + 'ms');
    Memo1.Lines.Add('YxdSync testing...');
    TY := GetTickCount;
    AReadCount := 0;
    AWriteCount := 0;
    AGroup.Prepare;
    for I := 0 to 99 do
    begin
      AGroup.Add(
        procedure(AJob: PQJob)
        var
          J: Integer;
        begin
          if (IntPtr(AJob.Data) mod 10) < 8 then
          begin
            for J := 0 to 99 do
            begin
              AYxd.Lock(True);
              AtomicIncrement(AReadCount);
              Sleep(10);
              AYxd.Unlock(True);
            end;
          end
          else
          begin
            for J := 0 to 99 do
            begin
              AYxd.Lock(False);
              AtomicIncrement(AWriteCount);
              Sleep(10);
              AYxd.Unlock(False);
            end;
          end;
        end, Pointer(I));
    end;
    AGroup.Run();
    AGroup.MsgWaitFor();
    TY := GetTickCount - TY;
    Memo1.Lines.Add('YdxSync:' + IntToStr(TY) + 'ms');
    // ShowMessage(IntToStr(TM) + 'ms with MRSW,' + IntToStr(TC) + 'ms with CS,' +
    // IntToStr(TS) + 'ms with SQLMem,'+IntToStr(TY)+'ms with Yxd');
  finally
    ASMRSW.Free;
    ACS.Free;
    AGroup.Free;
    AYxd.Free;
    AVcl.Free;
    Button1.Enabled := True;
    Caption := 'Read ' + IntToStr(AReadCount) + ' times,Write ' +
      IntToStr(AWriteCount) + ' times';
  end;
end;

end.

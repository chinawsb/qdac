unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.syncobjs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, qstring, QWorker, Data.DB,
  Data.Win.ADODB;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FLastTime:Cardinal;
    FIds: array [0 .. 2] of Integer;
    procedure DoSignal1(AJob: PQJob);
    procedure DoSignal2(AJob: PQJob);
    procedure DoSignal3(AJob: PQJob);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    Workers.PostSignal('Signal1', nil);
    Workers.PostSignal('Signal2', nil);
    Workers.PostSignal('Signal3', nil);
  end
  else
  begin
    Workers.SendSignal('Signal1', nil);
    Workers.SendSignal('Signal2', nil);
    Workers.SendSignal('Signal3', nil);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    Workers.PostSignal(FIds[0], nil);
    Workers.PostSignal(FIds[1], nil);
    Workers.PostSignal(FIds[2], nil);
  end
  else
  begin
    Workers.SendSignal(FIds[0], nil);
    Workers.SendSignal(FIds[1], nil);
    Workers.SendSignal(FIds[2], nil);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FLastTime:=GetTickCount;
  Workers.Post(
    procedure(AJob: PQJob)
    var
      ATick:Cardinal;
    begin
      ATick:=GetTickCount;
      if ATick-FLastTime>2000 then
        Caption:=IntToStr(ATick-FLastTime)+' Found';
      FLastTime:=ATick;
      Memo1.Lines.Add(FormatDateTime('hh:nn:ss', Now));
    end, Q1Second,nil, true);
end;

procedure TForm1.DoSignal1(AJob: PQJob);
begin
  AJob.Worker.ComNeeded();
  Memo1.Lines.Add('Signal1 fired');
end;

procedure TForm1.DoSignal2(AJob: PQJob);
begin
  Memo1.Lines.Add('Signal2 fired');
end;

procedure TForm1.DoSignal3(AJob: PQJob);
begin
  Memo1.Lines.Add('Signal3 fired');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FIds[0] := Workers.RegisterSignal('Signal1');
  FIds[1] := Workers.RegisterSignal('Signal2');
  FIds[2] := Workers.RegisterSignal('Signal3');
  Workers.Wait(DoSignal1, FIds[0], true);
  Workers.Wait(DoSignal2, FIds[1], true);
  Workers.Wait(DoSignal3, FIds[2], true);
  ReportMemoryLeaksOnShutdown := true;
end;

end.

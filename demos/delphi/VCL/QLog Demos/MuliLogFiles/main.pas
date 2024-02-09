unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, qlog, qstring, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm4 = class(TForm)
    sbPostLogs: TSpeedButton;
    Panel1: TPanel;
    Memo1: TMemo;
    sbLogs0: TSpeedButton;
    sbLogs2_9: TSpeedButton;
    sbCustomLogs: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbPostLogsClick(Sender: TObject);
    procedure sbLogs0Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbLogs2_9Click(Sender: TObject);
    procedure sbCustomLogsClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoFilterTags(Sender: TQLogWriter; AItem: PQLogItem; var Accept: Boolean);
    procedure LoadLogs(const AFileName: String);
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.DoFilterTags(Sender: TQLogWriter; AItem: PQLogItem; var Accept: Boolean);
var
  ATagId: Integer;
begin
  Accept := true;
  if AItem.Tag.StartsWith('tag') then
  begin
    if TryStrToInt(Copy(AItem.Tag, 4), ATagId) then
      Accept := (ATagId < 0) or (ATagId > 9); // tag0-tag9已经被分割到不同的文件
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
  function AddWriter(const AFileName: String; const ATags: string): TQLogWriter;
  begin
    Result := TQLogFileWriter.Create(AFileName);
    Result.AcceptTags := ATags;
    Logs.Castor.AddWriter(Result);
  end;

begin
  AddWriter('log_tag1.log', 'tag1');
  AddWriter('log_tag2_9.log', 'tag2,tag3,tag4,tag5,tag6,tag7,tag8,tag9');
  AddWriter('log_tag0.log', 'tag0');
  AddWriter('log_custom.log', '').OnAccept := DoFilterTags;
end;

procedure TForm4.LoadLogs(const AFileName: String);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    Memo1.Lines.Text := LoadTextW(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TForm4.sbCustomLogsClick(Sender: TObject);
begin
  LoadLogs('log_custom.log');
end;

procedure TForm4.sbLogs0Click(Sender: TObject);
begin
  LoadLogs('log_tag0.log');
end;

procedure TForm4.sbLogs2_9Click(Sender: TObject);
begin
  LoadLogs('log_tag2_9.log');
end;

procedure TForm4.sbPostLogsClick(Sender: TObject);
var
  ATag: String;
begin
  for var I := 0 to 99 do
  begin
    ATag := 'tag' + IntToStr(random(20));
    PostLog(llDebug, 'this is a test message with %s', [ATag], ATag);
  end;
end;

procedure TForm4.SpeedButton1Click(Sender: TObject);
begin
  LoadLogs('log_tag1.log');
end;

end.

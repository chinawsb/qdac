unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, qlog;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    ListBox1: TListBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FCount: Integer;
    FMemoWriter, FListWriter: TQLogStringsWriter;
    procedure DoListLogList(AWriter: TQLogWriter; AItem: PQLogItem;
      var Accept: Boolean);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qstring,qdialog_builder;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Label3.Caption := 'Log start time is ' +
    FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);
  DebugOut('%s:Start post', [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now)]);
  while FCount < 100000 do
  begin
    PostLog(TQLogLevel(random(8)), 'Test log %d', [FCount]);
    Inc(FCount);
  end;
  DebugOut('%s Posted', [FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now)]);
  FCount := 0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  PostLog(llDebug, 'This is log with tag', 'Demo');
  PostLog(llDebug, 'This is log without tag');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
CustomDialog('Dialog Demo','Hello,world','This is a world message',['Yes','No'],diWarning);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  FMemoWriter.LazyMode := CheckBox1.Checked;
  FListWriter.LazyMode := CheckBox1.Checked;
end;

procedure TForm1.DoListLogList(AWriter: TQLogWriter; AItem: PQLogItem;
  var Accept: Boolean);
begin
  Accept := Accept or (AItem.Tag = 'Demo');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetDefaultLogFile;
  FMemoWriter := TQLogStringsWriter.Create;
  FMemoWriter.Items := Memo1.Lines;
  FMemoWriter.MaxItems := SpinEdit1.Value;
  Logs.Castor.AddWriter(FMemoWriter);
  FListWriter := TQLogStringsWriter.Create;
  FListWriter.Items := ListBox1.Items;
  FListWriter.AcceptLevels := [llError];
  FListWriter.MaxItems := SpinEdit2.Value;
  Logs.Castor.AddWriter(FListWriter);
  FMemoWriter.LazyMode := CheckBox1.Checked;
  FListWriter.LazyMode := CheckBox1.Checked;
  FListWriter.OnAccept := DoListLogList;
  ReportMemoryLeaksOnShutdown := true;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  FMemoWriter.MaxItems := SpinEdit1.Value;
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin

  FListWriter.MaxItems := SpinEdit2.Value;
end;

end.

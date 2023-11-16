unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, QDB,
  QProv_Http, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm2 = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    Button1: TButton;
    ComboBox1: TComboBox;
    Button2: TButton;
    Panel2: TPanel;
    mmSQL: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    TabSheet2: TTabSheet;
    mmLogs: TMemo;
    Button3: TButton;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    FDataSet: TQDataSet;
    FProvider: TQHttpProvider;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses qstring, qworker;
{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  I: Integer;
  SQL, S: String;
  T: Cardinal;
begin
  PageControl1.ActivePage := TabSheet2;
  Button1.Enabled := false;
  try
    if not FProvider.Connected then
      FProvider.Database := ComboBox1.Text;
    mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' �������ӵ� ' +
      FProvider.ServiceUrl + ' �� ' + FProvider.Database);
    T := GetTickCount;
    FProvider.Connected := True;
    mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ���ӳɹ�����ʱ ' +
      IntToStr(GetTickCount - T) + 'ms');
  except
    on E: Exception do
      mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ����ʧ��:' +
        E.Message);
  end;

  Button1.Enabled := true;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  T: Cardinal;
  ARows: Integer;
  SQL: String;
begin
  if not FProvider.Connected then
    Button1Click(Sender);
  PageControl1.ActivePage := TabSheet2;
  T := GetTickCount;
  if mmSQL.SelLength > 0 then
    SQL := QString.DeleteSideCharsW(mmSQL.SelText, #9#10#13#32)
  else
    SQL := QString.DeleteSideCharsW(mmSQL.Text, #9#10#13#32);
  mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ִ�нű� ' +
    SLineBreak + SQL);
  Button2.Enabled := False;
  try
    ARows := FProvider.ExecuteCmd(SQL);
    mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ִ�нű���ɣ�' +
      IntToStr(ARows) + ' ����¼��Ӱ��,��ʱ ' + IntToStr(GetTickCount - T) + ' ms');
  except
    on E: Exception do
      mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + '  ִ�нű�ʧ��:' +
        E.Message);
  end;
  Button2.Enabled := True;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  SQL: String;
  T: Cardinal;
  I: Integer;
begin
  if not FProvider.Connected then
    Button1Click(Sender);
  PageControl1.ActivePage := TabSheet1;
  T := GetTickCount;
  if mmSQL.SelLength > 0 then
    SQL := QString.DeleteSideCharsW(mmSQL.SelText, #9#10#13#32)
  else
    SQL := QString.DeleteSideCharsW(mmSQL.Text, #9#10#13#32);

  mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' �����ݼ� ' +
    SLineBreak + SQL);
  Button3.Enabled := False;
  try
    if not Assigned(FDataSet) then
    begin
      FDataSet := FProvider.OpenDataSet(SQL);
      DataSource1.DataSet := FDataSet;
    end
    else
      FProvider.OpenDataSet(FDataSet, SQL);
    mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' �����ݼ��ɹ�����ʱ ' +
      IntToStr(GetTickCount - T) + ' ms������ ' + IntToStr(FDataSet.RecordCount)
      + ' ����¼');
  except
    on E: Exception do
    begin
      PageControl1.ActivePage := TabSheet2;
      mmLogs.Lines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' �����ݼ�ʧ�ܣ�' +
        E.Message);
    end;
  end;
  Button3.Enabled := True;
  for I := 0 to DBGrid1.Columns.Count - 1 do
    if DBGrid1.Columns[I].Width > 120 then
      DBGrid1.Columns[I].Width := 120;
end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
  FProvider.Connected := False;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FProvider := TQHttpProvider.Create(Self);
  // ���� URL
  FProvider.ServiceUrl :='http://www.kinsys.cn/qdb/qdb_httpprov.php';
//    'http://192.168.199.236/httpprovider/qdb_httpprov.php';
  // 'https://blog.qdac.cc/qdb/qdb_httpprov.php';
  // ��������ͨ�� AppId ����Ӧһ�� AppSalt ��������ã��Ա������Ȩ���ʣ�ֻ��֪����Ӧ����ֵ���ܷ���
  FProvider.AppId := 'Demos.HttpProvider';
  // ��������ǩ��ʹ�õ���ֵ
  FProvider.AppSalt := 'Demos.HttpProvider.Key';
  FProvider.KeepAlive := True;
  ReportMemoryLeaksOnShutdown := False;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);
end;

end.

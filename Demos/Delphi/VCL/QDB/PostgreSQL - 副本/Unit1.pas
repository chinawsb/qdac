unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, qdb, qprov_pgsql, qworker, qlog,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, winsock, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, Vcl.ExtCtrls, MemDS, DBAccess, Uni, UniProvider,
  PostgreSQLUniProvider, DAScript, UniScript, qconverter_stds, Vcl.Samples.Spin,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Stan.StorageBin, FireDAC.Stan.StorageJSON;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Button1: TButton;
    UniConnection1: TUniConnection;
    PostgreSQLUniProvider1: TPostgreSQLUniProvider;
    UniQuery1: TUniQuery;
    Button2: TButton;
    Button3: TButton;
    btnConnect: TButton;
    UniScript1: TUniScript;
    Splitter1: TSplitter;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    Button4: TButton;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    UniSQL1: TUniSQL;
    Button5: TButton;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    Button6: TButton;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
    FProv: TQPgSQLProvider;
    FDataSet: TQDataSet;
    procedure DoUniScriptError(Sender: TObject; E: Exception; SQL: string;
      var Action: TErrorAction);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qstring;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  T1, T2: Int64;
  I: Integer;
  ASQL: String;
begin
  btnConnectClick(Sender);
  DataSource1.DataSet := nil;
  try
    ASQL := 'select * from arraytest order by id limit ' +//config
      IntToStr(SpinEdit1.Value) + ' offset 0 ';
    T1 := GetTickCount;
    if FProv.OpenDataSet(FDataSet, ASQL) then
      Memo1.Lines.Add('QDAC 打开成功，记录数：' + IntToStr(FDataSet.RecordCount))
    else
      Memo1.Lines.Add('QDAC 打开失败，错误信息：' + FProv.LastErrorMsg);
    T1 := GetTickCount - T1;
    Memo1.Lines.Add('QDAC 测试用时:' + IntToStr(T1) + 'ms(' +
      RollupTime(T1 div 1000, False) + ')');
    T2 := GetTickCount;
    try
      UniQuery1.SQL.Text := ASQL;
      UniQuery1.Open;
      Memo1.Lines.Add('UniDAC 打开成功，记录数：' + IntToStr(UniQuery1.RecordCount))
    except
      on E: Exception do
        Memo1.Lines.Add('UniDAC 打开失败，错误信息：' + E.Message);
    end;
    T2 := GetTickCount - T2;
    Memo1.Lines.Add('UniDAC 测试用时:' + IntToStr(T2) + 'ms(' +
      RollupTime(T2 div 1000, False) + ')');
    T2 := GetTickCount;
    try
      FDQuery1.SQL.Text := ASQL;
      FDQuery1.Open;
      Memo1.Lines.Add('FireDAC 打开成功，记录数：' + IntToStr(UniQuery1.RecordCount))
    except
      on E: Exception do
        Memo1.Lines.Add('FireDAC 打开失败，错误信息：' + E.Message);
    end;
    T2 := GetTickCount - T2;
    Memo1.Lines.Add('FireDAC 测试用时:' + IntToStr(T2) + 'ms(' +
      RollupTime(T2 div 1000, False) + ')');
  finally
    DataSource1.DataSet := FDataSet;
    for I := 0 to DBGrid1.Columns.Count - 1 do
      DBGrid1.Columns[I].Width := 120;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AStream: TMemoryStream;
  T: Cardinal;
  S: String;
begin
  btnConnectClick(Sender);
  AStream := TMemoryStream.Create;
  try
    S := 'select * from config limit ' + IntToStr(SpinEdit1.Value) +
      ' offset 0';
    Memo1.Lines.Add(SpinEdit1.Text + ' 条记录测试');
    T := GetTickCount;
    if FProv.OpenStream(AStream, S, TQJsonConverter) then
    begin
      Memo1.Lines.Add('QDAC 用时:' + IntToStr(GetTickCount - T) + 'ms');
    end;
    AStream.Size := 0;
    T := GetTickCount;
    UniQuery1.SQL.Text := S;
    UniQuery1.Open;
    UniQuery1.SaveToXML(AStream);
    Memo1.Lines.Add('UniDAC 用时:' + IntToStr(GetTickCount - T) + 'ms');
    AStream.Size := 0;
    T := GetTickCount;
    FDQuery1.SQL.Text := S;
    FDQuery1.Active := True;
    FDQuery1.SaveToStream(AStream);
    Memo1.Lines.Add('FireDAC 用时:' + IntToStr(GetTickCount - T) + 'ms');
  finally
    FreeObject(AStream);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  T: Cardinal;
  ARows: Integer;
  I, AStop: Integer;
  S: String;
begin
  btnConnectClick(Sender);
  FProv.ExecuteCmd('truncate table config');
  Memo1.Lines.Add('执行脚本速度测试(插入' + IntToStr(SpinEdit1.Value) + ')');
  I := 0;
  ARows := 0;
  if Application.MessageBox('是否执行UniDAC的插入测试，它将消耗较长的时间？','插入测试',MB_YESNO or MB_ICONQUESTION)=IDYES then
    begin
    T := GetTickCount;
    AStop := SpinEdit1.Value;
    while I < AStop do
    begin
      UniScript1.SQL.Add('insert into config(id,key,"value") values (' +
        IntToStr(I) + ',''unidac'',''unidac inserted value'');');
      if (I > 0) and (I mod 1000 = 0) then
      begin
        UniScript1.OnError := DoUniScriptError;
        UniScript1.Execute;
        Inc(ARows, UniScript1.RowsAffected);
        Caption := 'UniDAC 已更新 ' + IntToStr(ARows) + ' 行';
        UniScript1.SQL.Clear;
        Application.ProcessMessages;
      end;
      Inc(I);
    end;
    UniScript1.OnError := DoUniScriptError;
    UniScript1.Execute;
    Inc(ARows, UniScript1.RowsAffected);
    T := GetTickCount - T;
    Memo1.Lines.Add('UniDAC 操作用时:' + IntToStr(T) + 'ms');
    end;
  Caption := 'QDAC 测试开始';
  Application.ProcessMessages;
  T := GetTickCount;
  AStop := I + SpinEdit1.Value;
  ARows := 0;
  while I < AStop do
  begin
    S := S + 'insert into config(id,key,"value") values (' + IntToStr(I) +
      ',''qdac'',''qdac inserted value'');'#13#10;
    if (I > 0) and (I mod 1000 = 0) then
    begin
      Inc(ARows, FProv.ExecuteCmd(S));
      S := '';
      Caption := 'QDAC 已更新 ' + IntToStr(ARows) + ' 行';
      Application.ProcessMessages;
    end;
    Inc(I);
  end;
  Inc(ARows, FProv.ExecuteCmd(S));
  T := GetTickCount - T;
  if ARows < 0 then
  begin
    Memo1.Lines.Add('QDAC 操作用时:' + IntToStr(T) + 'ms，错误信息：');
    Memo1.Lines.Add(FProv.LastErrorMsg);
  end
  else
    Memo1.Lines.Add('QDAC 操作用时:' + IntToStr(T) + 'ms');
  Caption := 'FireDAC 测试开始';
  Application.ProcessMessages;
  T := GetTickCount;
  AStop := I + SpinEdit1.Value;
  ARows := 0;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.BeginUpdate;
  while I < AStop do
  begin
    FDQuery1.SQL.Add('insert into config(id,key,"value") values (' + IntToStr(I)
      + ',''qdac'',''qdac inserted value'');');
    if (I > 0) and (I mod 1000 = 0) then
    begin
      FDQuery1.SQL.EndUpdate;
      FDQuery1.ExecSQL;
      FDQuery1.SQL.BeginUpdate;
      FDQuery1.SQL.Clear;
      Inc(ARows, 1000);
      Caption := 'FireDAC 已更新 ' + IntToStr(ARows) + ' 行';
      Application.ProcessMessages;
    end;
    Inc(I);
  end;
  FDQuery1.SQL.EndUpdate;
  FDQuery1.ExecSQL;
  T := GetTickCount - T;
  Memo1.Lines.Add('FireDAC 操作用时:' + IntToStr(T) + 'ms');
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ACmd: TQCommand;
begin
  btnConnectClick(Sender);
  UniQuery1.SQL.Text := 'select * from config where id<:id';
  UniQuery1.Params.ParamByName('id').AsInteger := 100;
  UniQuery1.Open;
  if FProv.Prepare(ACmd, 'select * from config where id<$1') then
  begin
    if FProv.ExecuteCmd(ACmd, [100]) >= 0 then
      Memo1.Lines.Add('OK')
    else
      Memo1.Lines.Add(FProv.LastErrorMsg);
    FProv.FreeCommand(ACmd);
  end
  else
    Memo1.Lines.Add(FProv.LastErrorMsg);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  FProv.OpenDataSet(FDataSet,
  'select id,char_d from dbtypes order by id;'+
  'select id,abstime_d from dbtypes order by id;');
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if FDataSet.ActiveRecordset > 0 then
    FDataSet.ActiveRecordset := FDataSet.ActiveRecordset - 1;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  if FDataSet.ActiveRecordset + 1 < FDataSet.RecordsetCount then
    FDataSet.ActiveRecordset := FDataSet.ActiveRecordset + 1;
end;

procedure TForm1.DoUniScriptError(Sender: TObject; E: Exception; SQL: string;
  var Action: TErrorAction);
begin
  Memo1.Lines.Add(E.Message);
  Action := eaContinue;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  if not FProv.Connected then
  begin
    FProv.ServerHost := 'www.qdac.cc';
    FProv.ServerPort := 15432;
    FProv.UserName := 'qdac';
    FProv.Password := 'Qdac.Demo';
    FProv.Database := 'QDAC_Demo';
    FProv.KeepAlive := False;
    if FProv.Open then
    begin
      Memo1.Lines.Add('服务器已连接');
      Memo1.Lines.AddStrings(FProv.Params);
    end
    else
      Memo1.Lines.Add('服务器连接失败:' + FProv.LastErrorMsg);
    UniConnection1.ProviderName := 'PostgreSQL';
    UniConnection1.Server := FProv.ServerHost;
    UniConnection1.Port := FProv.ServerPort;
    UniConnection1.UserName := FProv.UserName;
    UniConnection1.Password := FProv.Password;
    UniConnection1.Database := FProv.Database;
    UniConnection1.Open;
    FDConnection1.Params.Database := FProv.Database;
    FDConnection1.Params.Values['Server'] := FProv.ServerHost;
    FDConnection1.Params.Values['Port'] := IntToStr(FProv.ServerPort);
    FDConnection1.Params.UserName := FProv.UserName;
    FDConnection1.Params.Password := FProv.Password;
    FDConnection1.Open();
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutDown := True;
  FProv := TQPgSQLProvider.Create(Self);
  FDataSet := FProv.AcquireDataSet;
  FDataSet.BatchMode := False;
  DataSource1.DataSet := FDataSet;
  SetDefaultLogFile();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FProv.ReleaseDataSet(FDataSet);
end;

end.

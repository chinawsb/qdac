unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, qdb,
  qprov_pgsql, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Timer1: TTimer;
    Panel1: TPanel;
    chkDelayFetch: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FProv: TQPgSQLProvider;
    FMasterDataSet, FDetailDataSet: TQDataSet;
    procedure DoMasterChanged(ADataSet: TDataSet);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DoMasterChanged(ADataSet: TDataSet);
begin
  if chkDelayFetch.Checked then
  begin
    // ������һ����ʱ�����ӳٸ�����ϸ���ݣ�����������ʱ��ͣ�����������ȡ�û���Զ���ῴ��������
    Timer1.Enabled := False;
    Timer1.Enabled := True;
    FDetailDataSet.Close;
  end
  else
    Timer1Timer(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FProv := TQPgSQLProvider.Create(Self);
  FProv.ServerHost := 'www.qdac.cc';
  FProv.ServerPort := 15432;
  FProv.UserName := 'qdac';
  FProv.Password := 'Qdac.Demo';
  FProv.Database := 'QDAC_Demo';
  FProv.KeepAlive := False;
  if not FProv.Open then
    raise Exception.Create(FProv.LastErrorMsg);
  FMasterDataSet := TQDataSet.Create(Self);
  FProv.OpenDataSet(FMasterDataSet,
    'select oid,relname from pg_class where relkind=''r''');
  FDetailDataSet := TQDataSet.Create(Self);
  DataSource1.DataSet := FMasterDataSet;
  DataSource2.DataSet := FDetailDataSet;
  FDetailDataSet.OnMasterChanged := DoMasterChanged;
  FDetailDataSet.MasterSource := DataSource1;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  // ���û�ֹͣ50ms��������ȡ��ϸ����
  FProv.OpenDataSet(FDetailDataSet, 'select * from pg_attribute where attrelid='
    + FMasterDataSet.FieldByName('oid').AsString);
end;

end.

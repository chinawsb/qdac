unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, MemDS, DBAccess, Uni,
  Vcl.ExtDlgs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, QDB,
  qconverter_adoxml,
  UniProvider, PostgreSQLUniProvider, VirtualTable;

type
  TForm1 = class(TForm)
    Splitter1: TSplitter;
    Panel1: TPanel;
    Label3: TLabel;
    Button3: TButton;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    chkDeleted: TCheckBox;
    chkUnchange: TCheckBox;
    chkModified: TCheckBox;
    chkInserted: TCheckBox;
    cbxConverterType: TComboBox;
    Button5: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    DBGrid1: TDBGrid;
    Panel4: TPanel;
    Label1: TLabel;
    DBGrid2: TDBGrid;
    Panel3: TPanel;
    mmSQL: TMemo;
    Panel5: TPanel;
    Image1: TImage;
    Image2: TImage;
    Memo1: TMemo;
    Memo2: TMemo;
    Button6: TButton;
    Button7: TButton;
    DataSource2: TDataSource;
    OpenPictureDialog1: TOpenPictureDialog;
    OpenDialog1: TOpenDialog;
    DataSource1: TDataSource;
    ucPgSQL: TUniConnection;
    UniQuery1: TUniQuery;
    PostgreSQLUniProvider1: TPostgreSQLUniProvider;
    VirtualTable1: TVirtualTable;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FQDataset: TQDataSet;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  UniQuery1.Close;
  UniQuery1.SQL.Text := mmSQL.Text;
  UniQuery1.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    FQDataset.SaveToStream(AStream, TQADOXMLConverter, merAll);
    AStream.Position := 0;
    VirtualTable1.LoadFromStream(AStream);
    VirtualTable1.Open;
    DataSource1.DataSet := VirtualTable1;
    // FQDataset.LoadFromStream(AStream, TQADOXMLConverter);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    UniQuery1.SaveToXML(AStream);
    AStream.Position := 0;
    FQDataset.LoadFromStream(AStream, TQADOXMLConverter);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  UniQuery1.SaveToXML('c:\temp\unidac.xml');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FQDataset := TQDataSet.Create(Self);
  DataSource2.DataSet := FQDataset;
end;

end.

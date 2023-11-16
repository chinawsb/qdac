unit main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.TextLayout,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects
  // Custom units
    , qdac_fmx_virtualtree, dbadapter, Math,
  System.Generics.Collections,
  FMX.ImgList,
  FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Layouts, Data.DB, Datasnap.DBClient, FMX.Edit;

type

  TfrmMain = class(TForm)
    Layout1: TLayout;
    chkHorizLine: TCheckBox;
    chkTreeLine: TCheckBox;
    chkShowHeader: TCheckBox;
    chkNodeButton: TCheckBox;
    chkVertLine: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    chkDrawHover: TCheckBox;
    chkRowSelection: TCheckBox;
    chkColSelection: TCheckBox;
    chkColSizable: TCheckBox;
    chkRowSizable: TCheckBox;
    Label1: TLabel;
    btnViewAsTree: TButton;
    btnMilloNodes: TButton;
    adsData: TClientDataSet;
    adsDataId: TIntegerField;
    adsDataName: TStringField;
    adsDataPrice: TCurrencyField;
    adsDataSold: TFloatField;
    adsDataPackable: TBooleanField;
    adsDataStatus: TBooleanField;
    adsDataParent: TIntegerField;
    chkMultiSort: TCheckBox;
    btnEditor: TButton;
    chkAutoCascade: TCheckBox;
    btnMultiDrawer: TButton;
    vtGrid: TQVirtualTreeView;
    dsData: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure chkTreeLineChange(Sender: TObject);
    procedure chkShowHeaderChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure chkRowSizableChange(Sender: TObject);
    procedure btnViewAsTreeClick(Sender: TObject);
    procedure btnMilloNodesClick(Sender: TObject);
    procedure btnEditorClick(Sender: TObject);
    procedure btnMultiDrawerClick(Sender: TObject);
    procedure vtGridHoverChanged(Sender: TObject);
    procedure vtGridSortmarkerChanged(Sender: TObject);
  private
    FIndexExists: Boolean;
    FAdapter: TQVTDBAdapter;
    procedure CreateDemoDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses dbtreeview, millonodes, inspector, qdac_fmx_modaldlg, multidrawer;
{$R *.fmx}

procedure TfrmMain.btnEditorClick(Sender: TObject);
begin
  ModalDialog(TfrmObjInspector, nil);
end;

procedure TfrmMain.btnMilloNodesClick(Sender: TObject);
begin
  ModalDialog(TfrmMillioNodes, nil);
end;

procedure TfrmMain.btnMultiDrawerClick(Sender: TObject);
begin
  ModalDialog(TfrmCellMultiDrawer, nil);
end;

procedure TfrmMain.btnViewAsTreeClick(Sender: TObject);
begin
  ModalDialog(TfrmDBTree, nil);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  vtGrid.VertScrollBar.Value := vtGrid.VertScrollBar.Value + 10;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  vtGrid.VertScrollBar.Value := vtGrid.VertScrollBar.Value - 10;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  vtGrid.HorzScrollBar.Value := vtGrid.HorzScrollBar.Value + 10;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  vtGrid.HorzScrollBar.Value := vtGrid.HorzScrollBar.Value - 10;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  vtGrid.FocusNode := vtGrid.RootNode.GetFirstChild;
end;

procedure TfrmMain.chkRowSizableChange(Sender: TObject);
var
  AOptions: TQVTOptions;
begin
  AOptions := vtGrid.Options;
  if chkRowSizable.IsChecked then
    AOptions := AOptions + [TQVTOption.toRowSizable]
  else
    AOptions := AOptions - [TQVTOption.toRowSizable];
  if chkAutoCascade.IsChecked then
    AOptions := AOptions + [TQVTOption.toAutoCascade]
  else
    AOptions := AOptions - [TQVTOption.toAutoCascade];
  vtGrid.Options := AOptions;
  if chkColSizable.IsChecked then
    vtGrid.Header.Options := vtGrid.Header.Options +
      [TQVTHeaderOption.hoResizable]
  else
    vtGrid.Header.Options := vtGrid.Header.Options -
      [TQVTHeaderOption.hoResizable];
end;

procedure TfrmMain.chkShowHeaderChange(Sender: TObject);
var
  AOptions: TQVTHeaderOptions;
begin
  AOptions := vtGrid.Header.Options;
  if chkShowHeader.IsChecked then
    AOptions := AOptions + [TQVTHeaderOption.hoVisible]
  else
    AOptions := AOptions - [TQVTHeaderOption.hoVisible];
  if chkMultiSort.IsChecked then
    AOptions := AOptions + [TQVTHeaderOption.hoMultiSortColumns]
  else
    AOptions := AOptions - [TQVTHeaderOption.hoMultiSortColumns];
  vtGrid.Header.Options := AOptions;
end;

procedure TfrmMain.chkTreeLineChange(Sender: TObject);
var
  AOptions: TQVTPaintOptions;
begin
  AOptions := [];
  if chkHorizLine.IsChecked then
    AOptions := AOptions + [TQVTPaintOption.poHorizLine];
  if chkVertLine.IsChecked then
    AOptions := AOptions + [TQVTPaintOption.poVertLine];
  if chkTreeLine.IsChecked then
    AOptions := AOptions + [TQVTPaintOption.poTreeLine];
  if chkNodeButton.IsChecked then
    AOptions := AOptions + [TQVTPaintOption.poNodeButton];
  if chkDrawHover.IsChecked then
  begin
    AOptions := AOptions + [TQVTPaintOption.poHover];
    vtGrid.Options := vtGrid.Options + [TQVTOption.toTestHover];
  end
  else
    vtGrid.Options := vtGrid.Options - [TQVTOption.toTestHover];
  if chkRowSelection.IsChecked then
    AOptions := AOptions + [TQVTPaintOption.poRowSelection];
  if chkColSelection.IsChecked then
    AOptions := AOptions + [TQVTPaintOption.poColSelection];
  vtGrid.PaintOptions := AOptions;
end;

procedure TfrmMain.CreateDemoDataSet;
const
  ANames: array [0 .. 10] of String = ('西红柿', '白菜', '菠菜', '黄瓜', // 植物x4
    '猪肉', '草鱼', // 动物x2
    '桔子', '荔芝', '苹果', '香蕉', '西瓜' // 水果x5
    );
var
  I, AId: Integer;
begin
  adsData.CreateDataSet;
  adsData.Append;
  adsDataId.AsInteger := 1;
  adsDataName.AsString := '蔬菜';
  adsData.Post;
  adsData.Append;
  adsDataId.AsInteger := 2;
  adsDataName.AsString := '水果';
  adsData.Post;
  adsData.Append;
  adsDataId.AsInteger := 3;
  adsDataName.AsString := '植物';
  adsDataParent.AsInteger := 1;
  adsData.Post;
  adsData.Append;
  adsDataId.AsInteger := 4;
  adsDataName.AsString := '动物';
  adsDataParent.AsInteger := 1;
  adsData.Post;
  AId := 5;
  // 植物:50
  for I := 0 to 49 do
  begin
    adsData.Append;
    adsDataId.AsInteger := AId;
    adsDataName.AsString := ANames[Random(4)]; // 0..3
    adsDataParent.AsInteger := 3;
    adsDataPrice.AsCurrency := 1 + Random(100) / 10;
    adsDataSold.AsFloat := Random(100);
    adsDataPackable.AsBoolean := Boolean(Random(2));
    adsDataStatus.AsBoolean := Boolean(Random(2));
    adsData.Post;
    Inc(AId);
  end;
  // 动物：50
  for I := 0 to 49 do
  begin
    adsData.Append;
    adsDataId.AsInteger := AId;
    adsDataName.AsString := ANames[4 + Random(2)]; // 4..5
    adsDataParent.AsInteger := 4;
    adsDataPrice.AsCurrency := 1 + Random(100) / 10;
    adsDataSold.AsFloat := Random(100);
    adsDataPackable.AsBoolean := Boolean(Random(2));
    adsDataStatus.AsBoolean := Boolean(Random(2));
    adsData.Post;
    Inc(AId);
  end;
  // 水果
  for I := 0 to 49 do
  begin
    adsData.Append;
    adsDataId.AsInteger := AId;
    adsDataName.AsString := ANames[6 + Random(4)];
    adsDataParent.AsInteger := 2;
    adsDataPrice.AsCurrency := 1 + Random(100) / 10;
    adsDataSold.AsFloat := Random(100);
    adsDataPackable.AsBoolean := Boolean(Random(2));
    adsDataStatus.AsBoolean := Boolean(Random(2));
    adsData.Post;
    Inc(AId);
  end;
end;

// procedure TfrmMain.DoSortMarkerChanged(ASender: TObject);
// var
// ASort, ADescs: String;
// I: Integer;
// AField: TField;
// ADesc: Boolean;
// begin
// ASort := '';
// ADesc := false;
// // for I := 0 to vtGrid.SortColumns.Count - 1 do
// // begin
// // AField := (FCellDatas[vtGrid.SortColumns[I].Index]
// // as TQDBCellData).Field;
// // ASort := ASort + AField.FieldName + ';';
// // if vtGrid.SortColumns[I].Title.SortMarker = TQVTColumnSortMarker.smDesc
// // then
// // ADescs := ADescs + AField.FieldName + ';';
// // end;
// if Length(ASort) > 0 then
// SetLength(ASort, Length(ASort) - 1);
// if Length(ADescs) > 0 then
// SetLength(ADescs, Length(ADescs) - 1);
// if FIndexExists then
// adsData.DeleteIndex('Idx_OnFly');
// if Length(ADescs) > 0 then
// adsData.AddIndex('Idx_OnFly', ASort, [ixDescending], ADescs)
// else
// adsData.AddIndex('Idx_OnFly', ASort, [], ADescs);
// adsData.IndexName := 'Idx_OnFly';
// FIndexExists := True;
// end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  I: Integer;
  AField: TField;
  ADrawerType: TQVTDrawerType;
begin
  vtGrid.PaintOptions := [TQVTPaintOption.poHorizLine,
    TQVTPaintOption.poVertLine, TQVTPaintOption.poTreeLine,
    TQVTPaintOption.poNodeButton, TQVTPaintOption.poRowSelection];
  // 修改默认的排序图标
  // TQVTHeaderDrawer.AscPath.Data :=
  // 'M260.62336 662.82496h502.74816L512 361.16992l-251.37664 301.65504z';
  // 修改默认的展开与收缩按钮样式
  TQVTMasterDrawer.ExpandedPath.Data :=
    'M959.434495 288.282752 512 735.717248 64.565505 288.282752 959.434495 288.282752z';
  TQVTMasterDrawer.CascadedPath.Data :=
    'M237.6 73.4l548.8 439.1-548.8 439.1V73.4z';
  // 修改默认的复选框样式，需要3种样式，禁用的状态下自动变淡，出于演示目的，我们只改选中状态的，其它类同
  TQVTCheckDrawer.CheckedPath.Data :=
    'M73.6 580.86c-13.922-13.62-15.68-36.436-3.27-51.768l1.052-1.3c12.116-14.97 35.42-18.286 50.7-8.292l163.82 107.15c32.116 21.006 82.808 18.434 112.724'
    + '-5.35l509.812-405.32c14.88-11.832 38.64-9.98 52.208 3.3l-13.57-13.28c13.954 13.654 14.36 35.392-0.144 49.582L394.408 796.234c-27.81 27.212-72.576 27.526-100.508 0.194L73.6 580.86z';
  CreateDemoDataSet;
  FAdapter := TQVTDBAdapter.Create(Self);
  FAdapter.KeyFieldName := 'id';
  FAdapter.ParentFieldName := 'parent';
  FAdapter.DataSource := dsData;
  vtGrid.DataAdapter := FAdapter;
  (vtGrid.Columns.Add as TQVTDBColumn).FieldName := 'id';
end;

procedure TfrmMain.vtGridHoverChanged(Sender: TObject);
begin
  if vtGrid.HoverNode <> nil then
    Caption := '当前行 ' + IntToStr(vtGrid.HoverNode.RowIndex) + ',列 ' +
      IntToStr(vtGrid.HoverColumn)
  else
    Caption := '无热点';
end;

procedure TfrmMain.vtGridSortmarkerChanged(Sender: TObject);
begin
  //
end;

end.

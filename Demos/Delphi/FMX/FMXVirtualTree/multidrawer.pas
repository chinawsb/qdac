unit multidrawer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.TextLayout,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  qdac_fmx_virtualtree;

type
  TfrmCellMultiDrawer = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FTreeView: TQVirtualTreeView;
    procedure DoGetCellData(Sender: TQVirtualTreeView; ANode: TQVTNode;
      ACol: Integer; var AData: IQVTCellData);
  public
    { Public declarations }
  end;

var
  frmCellMultiDrawer: TfrmCellMultiDrawer;

implementation

uses System.generics.collections;
{$R *.fmx}

type
  TMultiDataCell = class(TQVTDefaultCellData, IQVTTextCellData,
    IQVTProgressCellData, IQVTMultiDataCell)
  protected
    FText: String;
    FProgress: Single;
    FActiveIndex: Integer;
    function GetText: String;
    function GetProgress: Single;
    procedure SetProgress(const V: Single);
    function GetDrawerIndex: Integer;
    procedure SetDrawerIndex(const Value: Integer);
  public
    constructor Create(AText: String; AProgress: Single);
  end;

procedure TfrmCellMultiDrawer.DoGetCellData(Sender: TQVirtualTreeView;
  ANode: TQVTNode; ACol: Integer; var AData: IQVTCellData);
begin
  if not ANode.ExtByType(IQVTCellData, AData) then
  begin
    AData := TMultiDataCell.Create('Progress', random(100));
    ANode.Exts.Add(AData);
  end;
end;

procedure TfrmCellMultiDrawer.FormCreate(Sender: TObject);
var
  ADrawers: TQCellMultiDrawers;
begin
  FTreeView := TQVirtualTreeView.Create(Self);
  FTreeView.Options := [TQVTOption.toTestHover];
  FTreeView.PaintOptions := [TQVTPaintOption.poHorizLine,
    TQVTPaintOption.poVertLine, TQVTPaintOption.poTreeLine,
    TQVTPaintOption.poRowSelection, TQVTPaintOption.poNodeButton];
  FTreeView.Header.Options := [TQVTHeaderOption.hoVisible,
    TQVTHeaderOption.hoResizable];
  FTreeView.Parent := Self;
  FTreeView.OnGetCellData := DoGetCellData;
  FTreeView.Align := TAlignLayout.Client;
  FTreeView.DefaultRowHeight := 48;
  FTreeView.RootNodeCount := 3;
  ADrawers := TQCellMultiDrawers.Create;
  ADrawers.Add(TQSizableDrawer.Create(TQVirtualTreeView.GetDefaultDrawer
    (TQVTDrawerType.dtText), RectF(0, 0, 0, 0),
    function(AData: IQVTCellData; const AContentRect: TRectF): TSizeF
    var
      AText: IQVTTextCellData;
      ASettings: IQVTTextDrawable;
      R: TRectF;
    begin
      if Supports(AData, IQVTTextCellData, AText) then
      begin
        R.Left := 0;
        R.Top := 0;
        R.Right := MaxInt;
        R.Bottom := MaxInt;
        if Supports(AData, IQVTTextDrawable, ASettings) then
        begin
          AData.TreeView.Canvas.Font.Assign(ASettings.TextSettings.Font);
          AData.TreeView.Canvas.MeasureText(R, AText.Text, False, [],
            TTextAlign.Leading, TTextAlign.Leading);
        end
        else
          AData.TreeView.Canvas.MeasureText(R, AText.Text, False, [],
            TTextAlign.Leading, TTextAlign.Leading);
        Result.cx := R.Width;
        Result.cy := R.Height;
      end
      else
      begin
        Result.cx := 0;
        Result.cy := 0;
      end;
    end));
  ADrawers.Add(TQSizableDrawer.Create(TQVirtualTreeView.GetDefaultDrawer
    (TQVTDrawerType.dtProgress), RectF(3, 3, 3, 3),
    function(AData: IQVTCellData; const AContentRect: TRectF): TSizeF
    begin
      Result.cx := AContentRect.Width;
      Result.cy := AContentRect.Height;
    end));
  ADrawers.IsVertical := False;
  with FTreeView.Header.Columns.Add do
  begin
    Title.Text := '水平绘制';
    Title.TextSettings.FontColor := TAlphaColors.Black;
    Width := 300;
    Drawer := ADrawers;
  end;
  ADrawers := TQCellMultiDrawers.Create;
  ADrawers.Add(TQSizableDrawer.Create(TQVirtualTreeView.GetDefaultDrawer
    (TQVTDrawerType.dtText), RectF(0, 0, 0, 0),
    function(AData: IQVTCellData; const AContentRect: TRectF): TSizeF
    var
      AText: IQVTTextCellData;
      ASettings: IQVTTextDrawable;
      R: TRectF;
    begin
      if Supports(AData, IQVTTextCellData, AText) then
      begin
        R.Left := 0;
        R.Top := 0;
        R.Right := MaxInt;
        R.Bottom := MaxInt;
        if Supports(AData, IQVTTextDrawable, ASettings) then
        begin
          AData.TreeView.Canvas.Font.Assign(ASettings.TextSettings.Font);
          AData.TreeView.Canvas.MeasureText(R, AText.Text, False, [],
            TTextAlign.Leading, TTextAlign.Leading);
        end
        else
          AData.TreeView.Canvas.MeasureText(R, AText.Text, False, [],
            TTextAlign.Leading, TTextAlign.Leading);
        Result.cx := R.Width;
        Result.cy := R.Height;
      end
      else
      begin
        Result.cx := 0;
        Result.cy := 0;
      end;
    end));
  ADrawers.Add(TQSizableDrawer.Create(TQVirtualTreeView.GetDefaultDrawer
    (TQVTDrawerType.dtProgress), RectF(3, 3, 3, 3),
    function(AData: IQVTCellData; const AContentRect: TRectF): TSizeF
    begin
      Result.cx := AContentRect.Width;
      Result.cy := AContentRect.Height;
    end));
  ADrawers.IsVertical := True;
  with FTreeView.Header.Columns.Add do
  begin
    Title.Text := '垂直绘制';
    Title.TextSettings.FontColor := TAlphaColors.Black;
    Width := 300;
    Drawer := ADrawers;
  end;
end;

{ TMultiDataCell }

constructor TMultiDataCell.Create(AText: String; AProgress: Single);
begin
  inherited Create;
  FText := AText;
  FProgress := AProgress;
end;

function TMultiDataCell.GetDrawerIndex: Integer;
begin
  Result := FActiveIndex;
end;

function TMultiDataCell.GetProgress: Single;
begin
  Result := FProgress;
end;

function TMultiDataCell.GetText: String;
begin
  if FActiveIndex = 0 then
    Result := FText
  else
    Result := FormatFloat('0.00', FProgress);
end;

procedure TMultiDataCell.SetDrawerIndex(const Value: Integer);
begin
  FActiveIndex := Value;
end;

procedure TMultiDataCell.SetProgress(const V: Single);
begin
  FProgress := V;
end;

end.

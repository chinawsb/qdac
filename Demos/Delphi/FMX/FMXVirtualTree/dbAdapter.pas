unit dbAdapter;

interface

uses classes, sysutils, db, variants, generics.collections, generics.defaults,
  qdac_fmx_virtualtree;

type
  TQVTDBAdapter = class;

  TQVTDBCellData = class(TQVTExtendableObject)
  protected
  public
  end;

  TQVTDBColumn = class(TQVTColumn)
  private
    procedure SetFieldName(const Value: String);
  protected
    FFieldName: String;
    FValidRegex: String;
    FField: TField;
  published
    property FieldName: String read FFieldName write SetFieldName;
    property ValidRegex: String read FValidRegex write FValidRegex;
  end;

  TQVTDataLink = class(TDataLink)
  protected
    [unsafe]
    FAdapter: TQVTDBAdapter;
    procedure ActiveChanged; override;
    procedure CheckBrowseMode; override;
    procedure DataEvent(Event: TDataEvent; Info: NativeInt); override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure EditingChanged; override;
    procedure FocusControl(Field: TFieldRef); override;
    function GetActiveRecord: Integer; override;
    function GetBOF: Boolean; override;
    function GetBufferCount: Integer; override;
    function GetEOF: Boolean; override;
    function GetRecordCount: Integer; override;
    procedure LayoutChanged; override;
    function MoveBy(Distance: Integer): Integer; override;
    procedure RecordChanged(Field: TField); override;
    procedure SetActiveRecord(Value: Integer); override;
    procedure SetBufferCount(Value: Integer); override;
    procedure UpdateData; override;
  end;

  TQVTDBTreeItem = class(TInterfacedObject)
  private
    function GetChildren: TList<TQVTDBTreeItem>;
  protected
    FBookmark: TBookmark;
    FValues: Variant;
    FChildren: TList<TQVTDBTreeItem>;
    FInternalFlags: Integer;
  public
    constructor Create;
    function Add: TQVTDBTreeItem; overload;
    function Add(const AItem: TQVTDBTreeItem): Integer; overload;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    property Children: TList<TQVTDBTreeItem> read GetChildren;
    destructor Destroy; override;
  end;

  TQVTDBAdapterOrphanAction = (oaAsRoot, oaIgnore);

  [ComponentPlatformsAttribute(AllCurrentPlatforms)]
  TQVTDBTextCell = class(TQVTCustomTextCell)
  private
    procedure SetField(const Value: TField);
  protected
    FField: TField;
    function GetText: String; override;
    procedure SetText(const S: String); override;
    function GetEnabled: Boolean; override;
  published
    property Field: TField read FField write SetField;
  end;

  [ComponentPlatformsAttribute(AllCurrentPlatforms)]
  TQVTDBAdapter = class(TComponent, IQVTDataAdapter)
  private
    FOption: TQVTDBAdapterOrphanAction;
    FRootValue: Variant;
    function GetDataSource: TDataSource;
  protected
    FTreeView: TQVirtualTreeView;
    FDataSource: TDataSource;
    FDataLink: TQVTDataLink;
    FKeyFieldName, FParentFieldName: String;
    FKeyField, FParentField: TField;
    FRoot: TQVTDBTreeItem;

    procedure SetDataSource(const Value: TDataSource);
    function GetChildCount(ANode: TQVTNode): Integer;
    function GetCellData(ANode: TQVTNode; AColumn: Integer): IQVTCellData;
    function CanEdit(ANode: TQVTNode; AColumn: Integer): Boolean;
    function GetTreeView: TQVirtualTreeView;
    procedure SetTreeView(const AValue: TQVirtualTreeView);
    procedure SetKeyFieldName(const Value: String);
    procedure SetParentFieldName(const Value: String);
    procedure BuildTree;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property RootValue: Variant read FRootValue write FRootValue;
  published
    property TreeView: TQVirtualTreeView read FTreeView write SetTreeView;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ParentFieldName: String read FParentFieldName
      write SetParentFieldName;
    property KeyFieldName: String read FKeyFieldName write SetKeyFieldName;
    property OrphanAction: TQVTDBAdapterOrphanAction read FOption write FOption;
  end;

implementation

{ TQVTDBTextCell }

function TQVTDBTextCell.GetEnabled: Boolean;
begin
  if Assigned(FField) then
    Result := not FField.ReadOnly
  else
    Result := inherited;
end;

function TQVTDBTextCell.GetText: String;
begin
  if Assigned(FField) and FField.DataSet.Active then
    Result := FField.AsString
  else
    Result := DefaultText;
  if Assigned(OnGetText) then
    OnGetText(Self, Result);
end;

procedure TQVTDBTextCell.SetField(const Value: TField);
begin
  if FField <> Value then
  begin
    FField := Value;
    if Assigned(Node) then
      Node.TreeView.Invalidate;
  end;
end;

procedure TQVTDBTextCell.SetText(const S: String);
begin
  inherited;
  if Assigned(FField) and FField.DataSet.Active then
  begin
    if not(FField.DataSet.State in [dsEdit, dsInsert]) then
      FField.DataSet.Edit;
    FField.AsString := S;
  end;
end;
{ TQVTDBAdapter }

procedure TQVTDBAdapter.BuildTree;
var
  ADataSet: TDataSet;
  ABookmark: TBookmark;
  AList: TList<TQVTDBTreeItem>;
  AItem, AParent: TQVTDBTreeItem;
  AComparer: IComparer<TQVTDBTreeItem>;
  I: Integer;
  function DoSearch(const AKey: Variant): TQVTDBTreeItem;
  var
    L, H, C, M: Integer;
    AValue: Variant;
  begin
    L := 0;
    H := AList.Count - 1;
    Result := nil;
    while L <= H do
    begin
      M := (L + H) shr 1;
      AValue := AList[M].FValues[FKeyField.Index];
      if AValue < AKey then
        L := M + 1
      else if AValue > AKey then
        H := M - 1
      else
      begin
        Result := AList[M];
        Exit;
      end;
    end;
  end;

begin
  if (Length(FParentFieldName) > 0) and (Length(FKeyFieldName) > 0) and
    Assigned(FDataLink.DataSource) and (FDataLink.Active) and Assigned(FTreeView)
  then
  begin
    FDataLink.CheckBrowseMode;
    ADataSet := FDataLink.DataSet;
    AComparer := TComparer<TQVTDBTreeItem>.Construct(
      function(const L, R: TQVTDBTreeItem): Integer
      var
        vL, vR: Variant;
      begin
        vL := L.FValues[FKeyField.Index];
        vR := R.FValues[FKeyField.Index];
        if vL < vR then
          Result := -1
        else if vL > vR then
          Result := 1
        else
          Result := 0;
      end);
    AList := TList<TQVTDBTreeItem>.Create(AComparer);
    ADataSet.DisableControls;
    try
      ABookmark := ADataSet.Bookmark;
      FKeyField := ADataSet.FindField(FKeyFieldName);
      FParentField := ADataSet.FindField(FParentFieldName);
      FRoot.Clear;
      ADataSet.First;
      AList.Capacity := ADataSet.RecordCount;
      while not ADataSet.Eof do
      begin
        AItem := TQVTDBTreeItem.Create;
        AItem.FBookmark := ADataSet.Bookmark;
        AItem.FValues := VarArrayCreate([0, ADataSet.FieldCount - 1],
          varVariant);
        for I := 0 to ADataSet.FieldCount - 1 do
          AItem.FValues[I] := ADataSet.Fields[I].Value;
        AList.Add(AItem);
        ADataSet.Next;
      end;
      if Assigned(FKeyField) then // 主键字段
      begin
        AList.Sort;
        if Assigned(FParentField) then // 要求建立父子关系
        begin
          for I := 0 to AList.Count - 1 do
          begin
            AItem := AList[I];
            if AItem.FValues[FParentField.Index] = RootValue then
            begin
              AItem.FInternalFlags := 4;
              AParent.Add(AItem);
            end
            else
            begin
              AParent := DoSearch(AItem.FValues[FParentField.Index]);
              if Assigned(AParent) then
              begin
                AItem.FInternalFlags := 1;
                AParent.Add(AItem);
              end
              else if OrphanAction = oaAsRoot then
              begin
                AItem.FInternalFlags := 2;
                FRoot.Add(AItem);
              end;
            end;
          end;
          for I := 0 to AList.Count - 1 do
          begin
            AItem := AList[I];
            if AItem.FInternalFlags = 0 then
              AItem.DisposeOf;
          end;
          AList.Clear;
        end
        else
          FRoot.Children.AddRange(AList);
      end
      else
        FRoot.Children.AddRange(AList);
      TreeView.RootNodeCount := 0;
      TreeView.RootNodeCount := FRoot.Children.Count;
    finally
      if ADataSet.BookmarkValid(ABookmark) then
        ADataSet.Bookmark := ABookmark;
      ADataSet.EnableControls;
      FreeAndNil(AList);
    end;
  end
  else if Assigned(TreeView) then
  begin
    TreeView.RootNodeCount := 0;
    FRoot.Clear;
  end;
end;

function TQVTDBAdapter.CanEdit(ANode: TQVTNode; AColumn: Integer): Boolean;
begin
  Result := FDataLink.Editing;
end;

constructor TQVTDBAdapter.Create(AOwner: TComponent);
begin
  inherited;
  FDataLink := TQVTDataLink.Create;
  FDataLink.FAdapter := Self;
  FRoot := TQVTDBTreeItem.Create;
end;

destructor TQVTDBAdapter.Destroy;
begin
  Destroying;
  DataSource := nil;
  FreeAndNil(FRoot);
  FreeAndNil(FDataLink);
  inherited;
end;

function TQVTDBAdapter.GetCellData(ANode: TQVTNode; AColumn: Integer)
  : IQVTCellData;
var
  AExt: TQVTDBTreeItem;
begin
  AExt := ANode.ExtByType(TQVTDBTreeItem) as TQVTDBTreeItem;
end;

function TQVTDBAdapter.GetChildCount(ANode: TQVTNode): Integer;
var
  AData: TQVTDBTreeItem;
begin
end;

function TQVTDBAdapter.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TQVTDBAdapter.GetTreeView: TQVirtualTreeView;
begin
  Result := FTreeView;
end;

procedure TQVTDBAdapter.SetDataSource(const Value: TDataSource);
begin
  if Value = FDataLink.DataSource then
    Exit;
  FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

procedure TQVTDBAdapter.SetKeyFieldName(const Value: String);
begin
  FKeyFieldName := Value;
end;

procedure TQVTDBAdapter.SetParentFieldName(const Value: String);
begin
  FParentFieldName := Value;
end;

procedure TQVTDBAdapter.SetTreeView(const AValue: TQVirtualTreeView);
begin
  if FTreeView <> AValue then
  begin
    FTreeView := AValue;
    if FDataLink.Active then
      BuildTree;
  end;
end;

{ TQVTDBTreeItem }

function TQVTDBTreeItem.Add: TQVTDBTreeItem;
begin
  Result := TQVTDBTreeItem.Create;
  Children.Add(Result);
end;

function TQVTDBTreeItem.Add(const AItem: TQVTDBTreeItem): Integer;
begin
  Result := Children.Add(AItem);
end;

procedure TQVTDBTreeItem.Clear;
var
  I: Integer;
begin
  if Assigned(FChildren) then
  begin
    for I := 0 to FChildren.Count - 1 do
      FChildren[I].DisposeOf;
    FChildren.Clear;
  end;
end;

constructor TQVTDBTreeItem.Create;
begin
  inherited;
end;

procedure TQVTDBTreeItem.Delete(AIndex: Integer);
begin
  FChildren[AIndex].DisposeOf;
  FChildren.Clear;
end;

destructor TQVTDBTreeItem.Destroy;
begin
  Clear;
  if Assigned(FChildren) then
    FreeAndNil(FChildren);
  inherited;
end;

function TQVTDBTreeItem.GetChildren: TList<TQVTDBTreeItem>;
begin
  if not Assigned(FChildren) then
    FChildren := TList<TQVTDBTreeItem>.Create;
  Result := FChildren;
end;

{ TQVTDataLink }

procedure TQVTDataLink.ActiveChanged;
begin
  inherited;
  FAdapter.BuildTree;
end;

procedure TQVTDataLink.CheckBrowseMode;
begin
  inherited;
  if Assigned(FAdapter.TreeView) then
  begin
    if not FAdapter.TreeView.EndEdit then
      FAdapter.TreeView.CancelEdit;
  end;
end;

procedure TQVTDataLink.DataEvent(Event: TDataEvent; Info: NativeInt);
begin
  inherited;

end;

procedure TQVTDataLink.DataSetChanged;
begin
  inherited;

end;

procedure TQVTDataLink.DataSetScrolled(Distance: Integer);
begin
  inherited;

end;

procedure TQVTDataLink.EditingChanged;
begin
  inherited;

end;

procedure TQVTDataLink.FocusControl(Field: TFieldRef);
begin
  inherited;

end;

function TQVTDataLink.GetActiveRecord: Integer;
begin
  Result := inherited;
end;

function TQVTDataLink.GetBOF: Boolean;
begin
  Result := inherited;
end;

function TQVTDataLink.GetBufferCount: Integer;
begin
  Result := inherited;
end;

function TQVTDataLink.GetEOF: Boolean;
begin
  Result := inherited;
end;

function TQVTDataLink.GetRecordCount: Integer;
begin
  Result := inherited;
end;

procedure TQVTDataLink.LayoutChanged;
begin
  inherited;

end;

function TQVTDataLink.MoveBy(Distance: Integer): Integer;
begin
  Result := inherited;
end;

procedure TQVTDataLink.RecordChanged(Field: TField);
begin
  inherited;

end;

procedure TQVTDataLink.SetActiveRecord(Value: Integer);
begin
  inherited;

end;

procedure TQVTDataLink.SetBufferCount(Value: Integer);
begin
  inherited;

end;

procedure TQVTDataLink.UpdateData;
begin
  inherited;

end;

{ TQVTDBColumn }

procedure TQVTDBColumn.SetFieldName(const Value: String);
var
  Adapter: TQVTDBAdapter;
begin
  if FFieldName <> Value then
  begin
    FFieldName := Value;
    winapi.messages
    Adapter := TreeView.DataAdapter as TQVTDBAdapter;
    if Assigned(Adapter) and Assigned(Adapter.FDataLink.DataSet) then
      FField := Adapter.FDataLink.DataSet.FindField(Value)
    else
      FField := nil;
  end;
end;

end.

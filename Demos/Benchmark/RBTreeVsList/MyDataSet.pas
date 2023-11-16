unit MyDataSet;

interface

uses sysutils;

type
  //分页信息
  PPage = ^TPage;
  TPage = class
  protected
    FStartIndex: Integer; // 起始索引，默认从0开始计数
    FUsedCount: Integer;  // 当前页已使用的Items数量
    FItems: array of Pointer;
  public
    constructor Create(APageSize: Integer);
    destructor Destroy; override;
  end;

  TMyList = class
  private
    FTag: Integer;
    FCount: Integer; //元素数量
    FPageSize: Integer; // 每页大小
    FPages: array of TPage; // 页面列表，从0开始
    FLastUsedPageIndex: Integer;   // 最后使用的页面，从0开始
    FFirstDirtyPageIndex: Integer; // 首个索引脏的页面，没有脏页面时等于Length(FPages)
    function GetItems(AIndex: Integer): Pointer;
    procedure SetItems(AIndex: Integer; const Value: Pointer);
    function FindPage(AIndex: Integer): Integer;
    function GetPageCount: Integer;
  public
    constructor Create(APageSize: Integer = 512);
    destructor Destroy; override;

    procedure Insert(AIndex: Integer; const p: Pointer);
    function Add(const p: Pointer): Integer;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    procedure Pack;
    function Print: String;
    //批量插入
    function BatchInsertBegin(AIndex: Integer): Integer; //返回一个批插入标识
    procedure BatchInsert(AInsertID: Integer; const p: Pointer);
    procedure BatchInsertEnd(AInsertID: Integer);
    property Items[AIndex: Integer]: Pointer read GetItems
      write SetItems; default;
    property PageCount: Integer read GetPageCount;
    property PageSize: Integer read FPageSize;
    property Count: Integer read FCount;
    property Tag: Integer read FTag write FTag;
  end;

const
  G_POINTER_SIZE = SizeOf(Pointer); //指针占内存大小
  G_TPAGE_OBJ_SIZE = SizeOf(TPage); //对象占内存大小

implementation

{ TMyPageList }

//function TMyList.Add(const p: Pointer): Integer;
//begin
//  Result := FCount;
//  //1 是添加到末尾
//     //1.1 如果未曾分配页，或当前页已没有空间了，则分配新页
//  if (FLastUsedPageIndex<0) or (FPages[FLastUsedPageIndex].FUsedCount = FPageSize) then begin
//    SetLength(FPages, Length(FPages)+1);
//    Inc(FLastUsedPageIndex);
//    { 上面两行可改为下面两行，性能有一丁点提升
//      Inc(FLastUsedPageIndex);
//      SetLength(FPages, FLastUsedPageIndex+1);
//    }
//    FPages[FLastUsedPageIndex] := TPage.Create(FPageSize);
//    FPages[FLastUsedPageIndex].FStartIndex := FCount;
//    if FLastUsedPageIndex=0 then
//      FFirstDirtyPageIndex := 1;
//    //FFirstDirtyPageIndex := FLastUsedPageIndex + 1;  //上面if的两句如果去掉，则要用这句，更准确些，但速度稍慢。
//  end;
//   //1.2 存值
//  FPages[FLastUsedPageIndex].FItems[FPages[FLastUsedPageIndex].FUsedCount] := p;
//  Inc(FPages[FLastUsedPageIndex].FUsedCount);
//  Inc(FCount);
//end;

  function Pt(const p: PPage; c: Integer): PPage; inline;
  begin
    Result := PPage(Integer(p)+G_TPAGE_OBJ_SIZE*c);
  end;

function TMyList.Add(const p: Pointer): Integer;
var
  pgTem1: PPage; //用于优化数组访问，要不通过index访问还是有好几条汇编的
begin
  Result := FCount;
  //1.1 如果当前页已没有空间了，则分配新页
  pgTem1 := @FPages[FLastUsedPageIndex];
  if pgTem1^.FUsedCount = FPageSize then begin
    SetLength(FPages, Length(FPages)+1);
    Inc(FLastUsedPageIndex);
    pgTem1 := @FPages[FLastUsedPageIndex];
    pgTem1^ := TPage.Create(FPageSize);
    pgTem1^.FStartIndex := FCount;
  end;
   // 1.2 存值
  pgTem1^.FItems[pgTem1^.FUsedCount] := p;
  Inc(pgTem1^.FUsedCount);
  Inc(FCount);
end;

procedure TMyList.BatchInsert(AInsertID: Integer; const p: Pointer);
var
  list: TMyList;
begin
  list := TMyList(AInsertID);
  list.Add(p);
end;

function TMyList.BatchInsertBegin(AIndex: Integer): Integer;
var
  list: TMyList;
begin
  list := TMyList.Create(FPageSize);
  list.Tag := AIndex;
  Result := Integer(list);
end;

procedure TMyList.BatchInsertEnd(AInsertID: Integer);
var
  list: TMyList;
  pageIdx, AIndex: Integer;
  page: TPage;
begin
  list := TMyList(AInsertID);
  AIndex := list.Tag;
  pageIdx := FindPage(AIndex);
  if pageIdx<0 then
    pageIdx := 0;
  page := FPages[pageIdx];

  Dec(AIndex, page.FStartIndex);
  if list.FCount <= (FPageSize - page.FUsedCount) then begin
    //插入点的空闲空间可容纳新插入数据的话直接Move过来
    System.Move(page.FItems[AIndex], page.FItems[AIndex+list.FCount], list.FCount * G_POINTER_SIZE);
    System.Move(list.FPages[0].FItems[0], page.FItems[AIndex], list.FCount * G_POINTER_SIZE);
    Inc(page.FUsedCount, list.FCount);
    Inc(pageIdx);
    if FFirstDirtyPageIndex>pageIdx then
      FFirstDirtyPageIndex := pageIdx;
  end else begin
    //否则，把新插入数据直接作为新加页插入进来
    SetLength(FPages, Length(FPages) + list.PageCount);

  end;


  list.Free;
end;

procedure TMyList.Clear;
 var
   i: Integer;
 begin
   //为后面优化减少判断，Clear总留着一块内存。
   for i := Low(FPages) to High(FPages) do
     FPages[i].Free;
   SetLength(FPages, 1);
   FPages[0] := TPage.Create(FPageSize);
   FCount := 0;
   FLastUsedPageIndex := 0;
   FFirstDirtyPageIndex := 1;
 end;

 constructor TMyList.Create(APageSize: Integer);
 begin
   if APageSize <= 0 then
     APageSize := 512;
   FPageSize := APageSize;
   Clear;
 end;

procedure TMyList.Delete(AIndex: Integer);
var
  pageIdx: Integer;
  page: TPage;
begin
  pageIdx := FindPage(AIndex);
  if pageIdx >= 0 then
  begin
    page := FPages[pageIdx];
    Dec(AIndex, page.FStartIndex);
    Dec(page.FUsedCount);
    System.Move(page.FItems[AIndex + 1], page.FItems[AIndex],
      G_POINTER_SIZE * (page.FUsedCount - AIndex));
    Dec(FCount);
    Inc(pageIdx);
    if pageIdx < FFirstDirtyPageIndex then
      FFirstDirtyPageIndex := pageIdx;
  end;
end;

 destructor TMyList.Destroy;
begin
  Clear;
  FPages[0].Free;
  SetLength(FPages, 0);
  inherited;
end;

{
为提高插入/删除效率，完成操作后仅置FFirstDirtyPageIndex跟踪被改动页，而不对其后
各页的FStartIndex进行重新计算，仅当在要取某个Index的记录时，必定触发FindPage函数，
才在此函数中对各Dirty页进行计算处理，但也仅处理到能包含到要获取的AIndex，这样尽
了最大能力地保证插入和删除的效率。
AIndex从0开始计数，一切和TList看齐。
}
function TMyList.FindPage(AIndex: Integer): Integer;
var
  i, L, H, topIdx: Integer;
  pTemp1, pTemp2: TPage;
begin
  L := 0;
  //1  如果AIndex在Dirty页范围内，则重新计算Dirty页直到包含住AIndex
  pTemp1 := FPages[FFirstDirtyPageIndex-1];
  if (FFirstDirtyPageIndex<Length(FPages))
    and (Aindex >= pTemp1.FStartIndex + pTemp1.FUsedCount) then begin
    for i := FFirstDirtyPageIndex to FLastUsedPageIndex do begin
      pTemp1 := FPages[i];
      pTemp2 := FPages[i-1];
      pTemp1.FStartIndex := pTemp2.FStartIndex + pTemp2.FUsedCount;
      if pTemp1.FStartIndex > AIndex then begin
        Result := i-1;
        FFirstDirtyPageIndex := i+1;
        Exit;
      end else if pTemp1.FStartIndex = AIndex then begin
        Result := i;
        FFirstDirtyPageIndex := i + 1;
        Exit;
      end;
    end;
    H := FLastUsedPageIndex;
  end else
    H := FFirstDirtyPageIndex-1;

  //2 然后使用二分法搜索AIndex对应的页面
  while L<=H do begin
    i := (L + H) shr 1; //除以2操作
    pTemp1 := FPages[i];
    topIdx := pTemp1.FStartIndex + pTemp1.FUsedCount - 1;
    if AIndex > topIdx then
      L := i + 1
    else if (AIndex>=pTemp1.FStartIndex) and (AIndex<=topIdx) then begin
      //找到所在页，退出！
      Result := i;
      Exit;
    end else
      H := i - 1;
  end;
  Result := -1;
end;

function TMyList.GetItems(AIndex: Integer): Pointer;
var
  idx: Integer;
  pTemp: TPage;
begin
  idx := FindPage(AIndex);
  if idx <> -1 then begin
    pTemp := FPages[idx];
    Result := pTemp.FItems[AIndex-pTemp.FStartIndex];
  end else
    raise Exception.Create('索引越界:' + IntToStr(AIndex));
end;

function TMyList.GetPageCount: Integer;
begin
  Result := Length(FPages);
end;

procedure TMyList.Insert(AIndex: Integer; const p: Pointer);
var
  pageIdx, newPageIdx: Integer;
  pgTem1, pgTem2: PPage;
begin
  if AIndex<0 then
    AIndex := 0;

  if AIndex>=FCount then begin
    //1 是添加到末尾
      //1.1 如果当前页已没有空间了，则分配新页
      pgTem1 := @FPages[FLastUsedPageIndex];
      if pgTem1^.FUsedCount = FPageSize then begin
        SetLength(FPages, Length(FPages)+1);
        Inc(FLastUsedPageIndex);
        pgTem1 := @FPages[FLastUsedPageIndex];
        pgTem1^ := TPage.Create(FPageSize);
        pgTem1^.FStartIndex := FCount;
      end;
       // 1.2 存值
      pgTem1^.FItems[pgTem1^.FUsedCount] := p;
      Inc(pgTem1^.FUsedCount);

  end else if AIndex<=0 then begin
    //2 插在页首，单独就这情况做处理是为了提高插入效率，因为不用调用一次FindPage。
    pgTem1 := @FPages[0];
    if pgTem1^.FUsedCount=FPageSize then begin
      SetLength(FPages, FLastUsedPageIndex+2);
      pgTem1 := @FPages[0];
      Inc(FLastUsedPageIndex);
      System.Move(pgTem1^, FPages[1], G_TPAGE_OBJ_SIZE * FLastUsedPageIndex);
      pgTem1^ := TPage.Create(FPageSize);
      pgTem1^.FUsedCount := 1;
    end else begin
      System.Move(pgTem1^.FItems[0], pgTem1^.FItems[1],
                    pgTem1^.FUsedCount * G_POINTER_SIZE);
      Inc(pgTem1^.FUsedCount);
    end;
    pgTem1^.FItems[0] := p;
    FFirstDirtyPageIndex := 1;
  end else begin
    //3 在页中间插入，经过上面大于FCount和小于等于0的处理，此处的FindPage不会返回-1，因此不用判断是否为-1的情况，又加快点速度
    pageIdx := FindPage(AIndex);
    pgTem1 := @FPages[pageIdx];
    Dec(AIndex, pgTem1^.FStartIndex);
    if pgTem1^.FUsedCount=FPageSize then begin
      //检查下一页是否有空间，如有则腾移一下，如此做是为了减少生成的页数，而提高随机插入性能
      newPageIdx := pageIdx + 1;
      if (pageIdx = FLastUsedPageIndex) or (FPages[newPageIdx].FUsedCount = FPageSize) then begin
        //否则新建一页，把插入位置后的数据移入新页，然后修正FStartIndex和FUsedCount
        SetLength(FPages, FLastUsedPageIndex+2);
        Inc(FLastUsedPageIndex);
        pgTem1 := @FPages[pageIdx];
        pgTem2 := @FPages[newPageIdx];
        if newPageIdx < FLastUsedPageIndex then
          System.Move(pgTem2^, FPages[newPageIdx+1],
                        G_TPAGE_OBJ_SIZE * (FLastUsedPageIndex - newPageIdx));

        pgTem2^ := TPage.Create(FPageSize);
        pgTem2^.FUsedCount := pgTem1^.FUsedCount - AIndex;
        pgTem1^.FUsedCount := AIndex + 1;
        pgTem2^.FStartIndex := pgTem1^.FStartIndex + pgTem1^.FUsedCount;

        System.Move(pgTem1^.FItems[AIndex],
                      pgTem2^.FItems[0],
                        pgTem2^.FUsedCount * G_POINTER_SIZE);
        Inc(newPageIdx);
      end else begin
        pgTem2 := @FPages[newPageIdx];
        System.Move(pgTem2^.FItems[0], pgTem2^.FItems[1], pgTem2^.FUsedCount * G_POINTER_SIZE);
        System.Move(pgTem1^.FItems[FPageSize-1], pgTem2^.FItems[0], G_POINTER_SIZE);
        System.Move(pgTem1^.FItems[AIndex], pgTem1^.FItems[AIndex+1], (FPageSize-AIndex-1)*G_POINTER_SIZE);
        Inc(pgTem2^.FUsedCount);
        Inc(newPageIdx);
      end;
    end else begin
      //把插入位置以下有数据的下移一个SizeOf(Pointer)
      System.Move(pgTem1^.FItems[AIndex],
                    pgTem1^.FItems[AIndex+1],
                      (pgTem1^.FUsedCount - AIndex) * G_POINTER_SIZE);
      Inc(pgTem1^.FUsedCount);
      newPageIdx := pageIdx + 1;
    end;

    pgTem1^.FItems[AIndex] := p;
    if FFirstDirtyPageIndex > newPageIdx then
      FFirstDirtyPageIndex := newPageIdx;
  end;
  Inc(FCount);
end;

procedure TMyList.Pack;
var
  i, pageIdx1, pageIdx2, moveCount: Integer;
  page1, page2: PPage;
begin
  if Length(FPages)=1 then
    Exit;
  //1 从第一页开始检查，逐页的记录往上凑
  page1 := @FPages[0];
  page2 := @FPages[1];

  pageIdx1 := 0;   //和page1同步
  pageIdx2 := 1;   //和page2同步
  while pageIdx2<=High(FPages) do begin
    moveCount := FPageSize - page1^.FUsedCount;
    if page2^.FUsedCount<=moveCount then begin
      //page2数量小于page1可用空间，全部移到page1
      System.Move(page2^.FItems[0], page1^.FItems[page1^.FUsedCount], page2^.FUsedCount * G_POINTER_SIZE);
      Inc(page1^.FUsedCount, page2^.FUsedCount);
      page2^.FUsedCount := 0;
      Inc(page2);
      Inc(pageIdx2);
    end else begin
      //page2数量大于page1可用空间，只移动page1空间块大小的内存
      System.Move(page2^.FItems[0], page1^.FItems[page1^.FUsedCount], moveCount * G_POINTER_SIZE);
      System.Move(page2^.FItems[moveCount], page2^.FItems[0], (page2^.FUsedCount - moveCount) * G_POINTER_SIZE);
      page1^.FUsedCount := FPageSize;
      page2^.FUsedCount := page2^.FUsedCount - moveCount;
    end;

    if page1^.FUsedCount = FPageSize then begin
      moveCount := page1^.FStartIndex + FPageSize;
      Inc(page1);
      Inc(pageIdx1);
      page1^.FStartIndex := moveCount;
      if pageIdx1 = pageIdx2 then begin
        Inc(page2);
        Inc(pageIdx2);
      end;
    end;
  end;

  if page1^.FUsedCount>0 then
    Inc(pageIdx1);
  for i := pageIdx1 to High(FPages) do
    FreeAndNil(FPages[i]);
  SetLength(FPages, pageIdx1);
  FLastUsedPageIndex := pageIdx1;
  FFirstDirtyPageIndex := pageIdx1;
end;

function TMyList.Print: String;
var
  i, j: Integer;
begin
  for i := Low(FPages) to High(FPages) do begin
    Result := Result + '页' + IntToStr(i+1)
      + '[FStartIndex: ' + IntToStr(FPages[i].FStartIndex)
      + ', FUsedCount: ' + IntToStr(FPages[i].FUsedCount)
      + ']' + #13#10;
    for j := 0 to FPageSize-1 do
      if j<FPages[i].FUsedCount then
        Result := Result + IntToStr(Integer(FPages[i].FItems[j])) + #13#10
      else
        Result := Result + '--' + #13#10;

    Result := Result + #13#10;
  end;
end;

procedure TMyList.SetItems(AIndex: Integer; const Value: Pointer);
var
  idx: Integer;
begin
  idx := FindPage(AIndex);
  if idx <> -1 then
    FPages[idx].FItems[AIndex-FPages[idx].FStartIndex] := Value
  else
    raise Exception.Create('索引越界：' + IntToStr(Aindex));
end;

{ TPages }

constructor TPage.Create(APageSize: Integer);
begin
  SetLength(FItems, APageSize);
end;

destructor TPage.Destroy;
begin
  SetLength(FItems, 0);
  inherited;
end;

end.

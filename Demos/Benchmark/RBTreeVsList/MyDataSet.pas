unit MyDataSet;

interface

uses sysutils;

type
  //��ҳ��Ϣ
  PPage = ^TPage;
  TPage = class
  protected
    FStartIndex: Integer; // ��ʼ������Ĭ�ϴ�0��ʼ����
    FUsedCount: Integer;  // ��ǰҳ��ʹ�õ�Items����
    FItems: array of Pointer;
  public
    constructor Create(APageSize: Integer);
    destructor Destroy; override;
  end;

  TMyList = class
  private
    FTag: Integer;
    FCount: Integer; //Ԫ������
    FPageSize: Integer; // ÿҳ��С
    FPages: array of TPage; // ҳ���б���0��ʼ
    FLastUsedPageIndex: Integer;   // ���ʹ�õ�ҳ�棬��0��ʼ
    FFirstDirtyPageIndex: Integer; // �׸��������ҳ�棬û����ҳ��ʱ����Length(FPages)
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
    //��������
    function BatchInsertBegin(AIndex: Integer): Integer; //����һ���������ʶ
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
  G_POINTER_SIZE = SizeOf(Pointer); //ָ��ռ�ڴ��С
  G_TPAGE_OBJ_SIZE = SizeOf(TPage); //����ռ�ڴ��С

implementation

{ TMyPageList }

//function TMyList.Add(const p: Pointer): Integer;
//begin
//  Result := FCount;
//  //1 ����ӵ�ĩβ
//     //1.1 ���δ������ҳ����ǰҳ��û�пռ��ˣ��������ҳ
//  if (FLastUsedPageIndex<0) or (FPages[FLastUsedPageIndex].FUsedCount = FPageSize) then begin
//    SetLength(FPages, Length(FPages)+1);
//    Inc(FLastUsedPageIndex);
//    { �������пɸ�Ϊ�������У�������һ��������
//      Inc(FLastUsedPageIndex);
//      SetLength(FPages, FLastUsedPageIndex+1);
//    }
//    FPages[FLastUsedPageIndex] := TPage.Create(FPageSize);
//    FPages[FLastUsedPageIndex].FStartIndex := FCount;
//    if FLastUsedPageIndex=0 then
//      FFirstDirtyPageIndex := 1;
//    //FFirstDirtyPageIndex := FLastUsedPageIndex + 1;  //����if���������ȥ������Ҫ����䣬��׼ȷЩ�����ٶ�������
//  end;
//   //1.2 ��ֵ
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
  pgTem1: PPage; //�����Ż�������ʣ�Ҫ��ͨ��index���ʻ����кü�������
begin
  Result := FCount;
  //1.1 �����ǰҳ��û�пռ��ˣ��������ҳ
  pgTem1 := @FPages[FLastUsedPageIndex];
  if pgTem1^.FUsedCount = FPageSize then begin
    SetLength(FPages, Length(FPages)+1);
    Inc(FLastUsedPageIndex);
    pgTem1 := @FPages[FLastUsedPageIndex];
    pgTem1^ := TPage.Create(FPageSize);
    pgTem1^.FStartIndex := FCount;
  end;
   // 1.2 ��ֵ
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
    //�����Ŀ��пռ�������²������ݵĻ�ֱ��Move����
    System.Move(page.FItems[AIndex], page.FItems[AIndex+list.FCount], list.FCount * G_POINTER_SIZE);
    System.Move(list.FPages[0].FItems[0], page.FItems[AIndex], list.FCount * G_POINTER_SIZE);
    Inc(page.FUsedCount, list.FCount);
    Inc(pageIdx);
    if FFirstDirtyPageIndex>pageIdx then
      FFirstDirtyPageIndex := pageIdx;
  end else begin
    //���򣬰��²�������ֱ����Ϊ�¼�ҳ�������
    SetLength(FPages, Length(FPages) + list.PageCount);

  end;


  list.Free;
end;

procedure TMyList.Clear;
 var
   i: Integer;
 begin
   //Ϊ�����Ż������жϣ�Clear������һ���ڴ档
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
Ϊ��߲���/ɾ��Ч�ʣ���ɲ��������FFirstDirtyPageIndex���ٱ��Ķ�ҳ�����������
��ҳ��FStartIndex�������¼��㣬������Ҫȡĳ��Index�ļ�¼ʱ���ض�����FindPage������
���ڴ˺����жԸ�Dirtyҳ���м��㴦����Ҳ�������ܰ�����Ҫ��ȡ��AIndex��������
����������ر�֤�����ɾ����Ч�ʡ�
AIndex��0��ʼ������һ�к�TList���롣
}
function TMyList.FindPage(AIndex: Integer): Integer;
var
  i, L, H, topIdx: Integer;
  pTemp1, pTemp2: TPage;
begin
  L := 0;
  //1  ���AIndex��Dirtyҳ��Χ�ڣ������¼���Dirtyҳֱ������סAIndex
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

  //2 Ȼ��ʹ�ö��ַ�����AIndex��Ӧ��ҳ��
  while L<=H do begin
    i := (L + H) shr 1; //����2����
    pTemp1 := FPages[i];
    topIdx := pTemp1.FStartIndex + pTemp1.FUsedCount - 1;
    if AIndex > topIdx then
      L := i + 1
    else if (AIndex>=pTemp1.FStartIndex) and (AIndex<=topIdx) then begin
      //�ҵ�����ҳ���˳���
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
    raise Exception.Create('����Խ��:' + IntToStr(AIndex));
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
    //1 ����ӵ�ĩβ
      //1.1 �����ǰҳ��û�пռ��ˣ��������ҳ
      pgTem1 := @FPages[FLastUsedPageIndex];
      if pgTem1^.FUsedCount = FPageSize then begin
        SetLength(FPages, Length(FPages)+1);
        Inc(FLastUsedPageIndex);
        pgTem1 := @FPages[FLastUsedPageIndex];
        pgTem1^ := TPage.Create(FPageSize);
        pgTem1^.FStartIndex := FCount;
      end;
       // 1.2 ��ֵ
      pgTem1^.FItems[pgTem1^.FUsedCount] := p;
      Inc(pgTem1^.FUsedCount);

  end else if AIndex<=0 then begin
    //2 ����ҳ�ף��������������������Ϊ����߲���Ч�ʣ���Ϊ���õ���һ��FindPage��
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
    //3 ��ҳ�м���룬�����������FCount��С�ڵ���0�Ĵ����˴���FindPage���᷵��-1����˲����ж��Ƿ�Ϊ-1��������ּӿ���ٶ�
    pageIdx := FindPage(AIndex);
    pgTem1 := @FPages[pageIdx];
    Dec(AIndex, pgTem1^.FStartIndex);
    if pgTem1^.FUsedCount=FPageSize then begin
      //�����һҳ�Ƿ��пռ䣬����������һ�£��������Ϊ�˼������ɵ�ҳ��������������������
      newPageIdx := pageIdx + 1;
      if (pageIdx = FLastUsedPageIndex) or (FPages[newPageIdx].FUsedCount = FPageSize) then begin
        //�����½�һҳ���Ѳ���λ�ú������������ҳ��Ȼ������FStartIndex��FUsedCount
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
      //�Ѳ���λ�����������ݵ�����һ��SizeOf(Pointer)
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
  //1 �ӵ�һҳ��ʼ��飬��ҳ�ļ�¼���ϴ�
  page1 := @FPages[0];
  page2 := @FPages[1];

  pageIdx1 := 0;   //��page1ͬ��
  pageIdx2 := 1;   //��page2ͬ��
  while pageIdx2<=High(FPages) do begin
    moveCount := FPageSize - page1^.FUsedCount;
    if page2^.FUsedCount<=moveCount then begin
      //page2����С��page1���ÿռ䣬ȫ���Ƶ�page1
      System.Move(page2^.FItems[0], page1^.FItems[page1^.FUsedCount], page2^.FUsedCount * G_POINTER_SIZE);
      Inc(page1^.FUsedCount, page2^.FUsedCount);
      page2^.FUsedCount := 0;
      Inc(page2);
      Inc(pageIdx2);
    end else begin
      //page2��������page1���ÿռ䣬ֻ�ƶ�page1�ռ���С���ڴ�
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
    Result := Result + 'ҳ' + IntToStr(i+1)
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
    raise Exception.Create('����Խ�磺' + IntToStr(Aindex));
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

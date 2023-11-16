unit qdac.htmlrender;

interface

uses classes, sysutils, types, uitypes, qdac.htmlparser, qstring;

type
  TQHtmlRender = class;
  TQHtmlStyle = class;
  {
    TQHtmlPosition
    hpStatic��
    ������ѭ����������ʱ4����λƫ�����Բ��ᱻӦ�á�
    hpRelative��
    ������ѭ�����������Ҳ��������ڳ������е�λ��ͨ��top��right��bottom��left��4����λƫ�����Խ���ƫ��ʱ����Ӱ�쳣�����е��κ�Ԫ�ء�
    hpAbsolute��
    �������볣��������ʱƫ�����Բ��յ�������������Ķ�λ����Ԫ�أ����û�ж�λ������Ԫ�أ���һֱ���ݵ�bodyԪ�ء����ӵ�ƫ��λ�ò�Ӱ�쳣�����е��κ�Ԫ�أ���margin���������κ�margin�۵���
    hpFixed��
    ��absoluteһ�£���ƫ�ƶ�λ���Դ���Ϊ�ο��������ֹ�����ʱ�����󲻻����Ź�����
    hpCenter��
    ��absoluteһ�£���ƫ�ƶ�λ���Զ�λ����Ԫ�ص����ĵ�Ϊ�ο��������������������ֱˮƽ���С���CSS3��
    hpPage��
    ��absoluteһ�¡�Ԫ���ڷ�ҳý�����������ڣ�Ԫ�صİ�����ʼ���ǳ�ʼ�����飬����ȡ����ÿ��absoluteģʽ����CSS3��
    hpSticky��
    �����ڳ�̬ʱ��ѭ����������������relative��fixed�ĺ��壬������Ļ��ʱ���������Ű棬��������Ļ��ʱ�������fixed�������Եı�������ʵ�������������Ч������CSS3��
  }
  TQHtmlPosition = (hpStatic, hpRelative, hpAbsolute, hpFixed, hpCenter, hpPage,
    hpSticky);
  TQHtmlStyle = class
  private
    FHtmlTag: TQHTMLTag;
    FParent: TQHtmlStyle;
    FItems: TStringList;
    FName: QStringW;
    FPosition: TQHtmlPosition;
    FZOrder: Integer;
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQHtmlStyle;
  public
    constructor Create(AStyleName: QStringW); virtual;
    destructor Destroy; override;
    function Add(const AStyleName: QStringW): TQHtmlStyle;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    function Find(const AStyleName: QStringW): TQHtmlStyle;
    function CalcBounds(AMaxBounds: TRect; AStartPoint: TPoint): TRect;
      virtual; abstract;
    procedure Draw(AMaxBounds: TRect; AStartPoint: TPoint); virtual; abstract;
    property HtmlTag: TQHTMLTag read FHtmlTag write FHtmlTag;
    property Parent: TQHtmlStyle read FParent; // ����ʽ
    property Name: QStringW read FName;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: TQHtmlStyle read GetItems;
  end;

  // HTML Ԫ�ص���Ⱦ��һ������Ⱦ����ϵ
  TQHtmlRenderItem = class
  protected
    FHtmlTag: TQHTMLTag;
    FRender: TQHtmlStyle;
    FItems: TList;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function Add(const AClassName: QStringW): TQHTMLTag;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    procedure Invalidate; virtual;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: TQHtmlRender read GetItems; default;
  end;

  TQHtmlRender = class
  protected
    FStyles: TStringList; // �������ʽ�б�����
    FRootTag: TQHTMLTag;
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQHtmlRender;
  public
    function Add(const AClassName: QStringW): TQHTMLTag;
    procedure Delete(AIndex: Integer);
    procedure Clear;
    procedure Invalidate; virtual;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: TQHtmlRender read GetItems; default;
  end;

implementation

{ TQHtmlStyle }

function TQHtmlStyle.Add(const AStyleName: QStringW): TQHtmlStyle;
begin
  Result := Find(AStyleName);
  if not Assigned(Result) then
  begin
    Result := TQHtmlStyle.Create(AStyleName);
    FItems.AddObject(Result.Name, Result);
  end;
end;

procedure TQHtmlStyle.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    FreeObject(FItems.Objects[I]);
  FItems.Clear;
end;

constructor TQHtmlStyle.Create(AStyleName: QStringW);
begin
  inherited Create;
  FName := AStyleName;
  FItems := TStringList.Create;
  FItems.Sorted := True;
  FItems.Duplicates := dupIgnore;
end;

procedure TQHtmlStyle.Delete(AIndex: Integer);
begin
  FreeObject(Items[AIndex]);
  FItems.Delete(AIndex);
end;

destructor TQHtmlStyle.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TQHtmlStyle.Find(const AStyleName: QStringW): TQHtmlStyle;
var
  AIndex: Integer;
begin
  if FItems.Find(AStyleName, AIndex) then
    Result := Items[AIndex]
  else
    Result := nil;
end;

function TQHtmlStyle.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQHtmlStyle.GetItems(AIndex: Integer): TQHtmlStyle;
begin
  Result := FItems.Objects[AIndex] as TQHtmlStyle;
end;

end.

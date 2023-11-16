unit simplehtml;

interface

uses classes, sysutils, qstring;

type
  TQHtmlTag = class;

  TQHtmlAttr = class
  private
    FName, FValue: QStringW;
    function GetAsInteger: Integer;
    procedure SetAsInteger(const Value: Integer);
    function GetAsInt64: Int64;
    procedure SetAsInt64(const Value: Int64);
    function GetAsFloat: Extended;
    procedure SetAsFloat(const Value: Extended);
    function GetAsBoolean: Boolean;
    procedure SetAsBoolean(const Value: Boolean);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetName(const Value: QStringW);
  public
    /// <summary>��������</summary>
    property Name: QStringW read FName write SetName;
    /// <summary>����ֵ</summary>
    property Value: QStringW read FValue write FValue;
    /// <summary>���԰�����ֵ������ֵ����</summary>
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    /// <summary>������64λ������ʽ������ֵ����</summary>
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    /// <summary>�����Ը���������ʽ������ֵ����</summary>
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    /// <summary>�������ַ�������ʽ������ֵ���ݣ��ȼ��ڷ���Value)
    property AsString: QStringW read FValue write FValue;
    /// <summary>�����Բ�������ʽ����ֵ����
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    /// <summary>����������ʱ�����ͷ�������
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
  end;

{$IFDEF QDAC_UNICODE}

  TQHtmlAttrList = TList<TQHtmlAttr>;
  TQHtmlTagList = TList<TQHtmlTag>;
{$ELSE}
  TQHtmlAttrList = TList;
  TQHtmlTagList = TList;
{$ENDIF !QDAC_UNICODE}
  TQHtmlAttrEnumerator = class;

  /// <summary>XML�����б��ڲ�ʹ��</summary>
  TQHtmlAttrs = class
  private
    FItems: TQHtmlAttrList;
    FOwner: TQHtmlTag;
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQHtmlAttr;
  public
    /// <summary>����һ��XML�����б�</summary>
    /// <param name="AOwner">��������XML���</param>
    constructor Create(AOwner: TQHtmlTag); overload;
    /// <summary>����һ��XML���Ե�����</summary>
    procedure Assign(ASource: TQHtmlAttrs);
    /// <summary>���һ��XML����</summary>
    /// <param name="AName">Ҫ��ӵ�XML��������</param>
    /// <returns>������ӵ�XML���Զ���
    function Add(const AName: QStringW): TQHtmlAttr; overload;
    /// <summary>���һ��XML���Ե�ֵ</summary>
    /// <param name="AName">��������</param>
    /// <param name="AValue">����ֵ</param>
    /// <returns>������ӵ�XML���Ե�����</returns>
    /// <remarks>QHtml������Ƿ��ظ��������ȷ���Ƿ��Ѵ��ڣ������ǰ������
    /// ItemByName��IndexByName������Ƿ��������
    function Add(const AName, AValue: QStringW): Integer; overload;
    /// <summary>����ָ�����Ƶ�����</summary>
    /// <param name="AName">Ҫ���ҵ���������</param>
    /// <returns>�����ҵ������Զ���</returns>
    function ItemByName(const AName: QStringW): TQHtmlAttr;
    /// <summary>��ȡָ�����Ƶ����Ե�������</summary>
    /// <param name="AName">Ҫ���ҵ���������</param>
    /// <returns>�����ҵ������Ե����������δ�ҵ�������-1</returns>
    function IndexOfName(const AName: QStringW): Integer;
    /// <summary>��ȡָ�����Ƶ����Ե�ֵ</summary>
    /// <param name="AName">��������</param>
    /// <param name="ADefVal">������Բ����ڣ����ص�Ĭ��ֵ</param>
    /// <returns>�����ҵ������Ե�ֵ�����δ�ҵ�������ADefVal������ֵ</returns>
    function ValueByName(const AName: QStringW; const ADefVal: QStringW = '')
      : QStringW;
    /// <summary>ɾ��ָ������������ֵ</summary>
    /// <param name="AIndex">��������</param>
    procedure Delete(AIndex: Integer); overload;
    /// <summary>ɾ��ָ�����Ƶ�����ֵ</summary>
    /// <param name="AName">��������</param>
    /// <remarks>��������������ԣ�ֻ��ɾ����һ���ҵ�������</remarks>
    procedure Delete(AName: QStringW); overload;
    /// <summary>������е�����</summary>
    procedure Clear;
    /// <summary>��������</summary>
    destructor Destroy; override;
    /// <summary>for..in֧�ֺ���</summary>
    function GetEnumerator: TQHtmlAttrEnumerator;
    /// <summary>���Ը���</summary>
    property Count: Integer read GetCount;
    /// <summary>�����б�</summary>
    property Items[AIndex: Integer]: TQHtmlAttr read GetItems; default;
    /// <summary>���������߽��</summary>
    property Owner: TQHtmlTag read FOwner;
  end;

  TQHtmlAttrEnumerator = class
  private
    FIndex: Integer;
    FList: TQHtmlAttrs;
  public
    constructor Create(AList: TQHtmlAttrs);
    function GetCurrent: TQHtmlAttr; inline;
    function MoveNext: Boolean;
    property Current: TQHtmlAttr read GetCurrent;
  end;

  TQHtmlTagEnumerator = class
  private
    FIndex: Integer;
    FList: TQHtmlTag;
  public
    constructor Create(AList: TQHtmlTag);
    function GetCurrent: TQHtmlTag; inline;
    function MoveNext: Boolean;
    property Current: TQHtmlTag read GetCurrent;
  end;

  /// <summary>HTML�������<summary>
  /// <list>
  /// <item><term>httNode</term><description>��ͨ���</description></item>
  /// <item><term>httText</term><description>�ı�����</description></item>
  /// <item><term>httComment</term><description>ע��</description></item>
  /// </list>
  TQHtmlTagType = (httNode, httText, httComment);

  TQHtmlTag = class
  private
    FTagType: TQHtmlTagType;
    function GetAsHtml: QStringW;
    function GetAttrs: TQHtmlAttrs;
    function GetCapacity: Integer;
    function GetCount: Integer;
    function GetItemIndex: Integer;
    function GetItems(AIndex: Integer): TQHtmlTag;
    function GetName: QStringW;
    function GetPath: QStringW;
    function GetText: QStringW;
    procedure SetAsHtml(const Value: QStringW);
    procedure SetCapacity(const Value: Integer);
    procedure SetName(const Value: QStringW);
    procedure SetTagType(const Value: TQHtmlTagType);
    procedure SetText(const Value: QStringW);
  protected
    FAttrs: TQHtmlAttrs;
    FItems: TQHtmlTagList;
    FParent: TQHtmlTag;
    FName: QStringW;
    FNameHash: Integer; // ���ƵĹ�ϣֵ
    FData: Pointer;
    function CreateTag: TQHtmlTag; virtual;
    procedure FreeTag(ATag: TQHtmlTag); virtual;
  public
    /// <summary>���캯��</summary>
    constructor Create; overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
    /// <summary>ֵ��������</summary>
    procedure Assign(ANode: TQHtmlTag);
    /// <summary>���һ��δ�������</summary>
    /// <remarks>����������һ��δ������㣬����ʱ���ý��㼶�������Զ�ֱ�ӱ�����һ��</remarks>
    function Add: TQHtmlTag; overload;
    /// <summary>���һ����㡢�ı���ע�ͻ�CData</summary>
    /// <param name="AName_Text">���ƻ����ݣ�����ȡ����AType����</param>
    /// <returns>������ӵĽ��ʵ��</returns>
    function Add(const AName_Text: QStringW; AType: TQHtmlTagType = httNode)
      : TQHtmlTag; overload;
    /// <summary>���һ�����</summary>
    /// <param name="AName">�������</param>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>�ȼ��ڵ���Add(AName,xntNode)</remarks>
    function AddNode(const AName: QStringW): TQHtmlTag; virtual;
    /// <summary>���һ���ı����</summary>
    /// <param name="AText">Ҫ��ӵ��ı�����</param>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>�ȼ��ڵ���Add(AText,xntText)</remarks>
    function AddText(const AText: QStringW): TQHtmlTag;
    /// <summary>���һ��ע��</summary>
    /// <param name="AText">Ҫ��ӵ�ע�����ݣ����ܰ���--&gt;</param>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>�ȼ��ڵ���Add(AText,xntComment)</remarks>
    function AddComment(const AText: QStringW): TQHtmlTag;
    /// <summary>��ȡָ�����Ƶĵ�һ�����</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����ҵ��Ľ�㣬���δ�ҵ������ؿ�(NULL/nil)</returns>
    /// <remarks>ע��XML������������ˣ�������������Ľ�㣬ֻ�᷵�ص�һ�����</remarks>
    function ItemByName(const AName: QStringW): TQHtmlTag; overload;
    /// <summary>��ȡָ�����ƵĽ�㵽�б���</summary>
    /// <param name="AName">�������</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByName(const AName: QStringW; AList: TQHtmlTagList;
      ANest: Boolean = False): Integer; overload;
    /// <summary>��ȡָ��·����JSON����</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <returns>�����ҵ����ӽ�㣬���δ�ҵ�����NULL(nil)</returns>
    function ItemByPath(const APath: QStringW): TQHtmlTag;
    /// <summary>��ȡ����ָ�����ƹ���Ľ�㵽�б���</summary>
    /// <param name="ARegex">������ʽ</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByRegex(const ARegex: QStringW; AList: TQHtmlTagList;
      ANest: Boolean = False): Integer; overload;
    /// <summary>��ȡָ��·�������ı�����</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <param name="ADefVal">��·�������ڣ����ص�Ĭ��ֵ</param>
    /// <returns>����ҵ���㣬�����ҵ��Ľ����ı����ݣ����򷵻�ADefVal������ֵ</returns>
    function TextByPath(const APath, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ��·���µ��ӽ��������ƥ��ָ��ֵ�Ľ��</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <param name="AttrName">Ҫ������������</param>
    /// <param name="AttrValue">Ҫ��������ֵ</param>
    /// <returns>����ҵ���㣬�����ҵ��Ľ�㣬���򷵻ؿ�(nil/NULL)</returns>
    function ItemWithAttrValue(const APath: QStringW;
      const AttrName, AttrValue: QStringW): TQHtmlTag;
    /// <summary>��ȡָ��·������ָ������</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <param name="AttrName">��������</param>
    /// <returns>����ҵ������Ӧ�����ԣ������ҵ������ԣ����򷵻�NULL/nil</returns>
    /// <remarks>
    function AttrByPath(const APath, AttrName: QStringW): TQHtmlAttr;
    /// <summary>��ȡָ��·������ָ������ֵ</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <param name="AttrName">��������</param>
    /// <param name="ADefVal">��·�������ڣ����ص�Ĭ��ֵ</param>
    /// <returns>����ҵ������Ӧ�����ԣ������ҵ������Ե��ı����ݣ����򷵻�ADefVal������ֵ</returns>
    /// <remarks>
    function AttrValueByPath(const APath, AttrName, ADefVal: QStringW)
      : QStringW;

    /// <summary>ǿ��һ��·������,���������,�����δ�����Ҫ�Ľ��</summary>
    /// <param name="APath">Ҫ��ӵĽ��·��</param>
    /// <returns>����·����Ӧ�Ķ���</returns>
    function ForcePath(APath: QStringW): TQHtmlTag;
    /// <summary>����Ϊ�ַ���</summary>
    /// <param name="ADoFormat">�Ƿ��ʽ���ַ����������ӿɶ���</param>
    /// <param name="AIndent">ADoFormat����ΪTrueʱ���������ݣ�Ĭ��Ϊ�����ո�</param>
    /// <returns>���ر������ַ���</returns>
    /// <remarks>AsXML�ȼ���Encode(True,'  ')</remarks>
    function Encode(ADoFormat: Boolean; AIndent: QStringW = '  '): QStringW;
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function Copy: TQHtmlTag;
    /// <summary>��¡����һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊʵ����ִ�е��ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ��
    /// ��������һ�����󣬲��������һ���������Ӱ�죬������Ϊ����������֤������
    /// �����Ϊ���ã��Ա��໥Ӱ�졣
    /// </remarks>
    function Clone: TQHtmlTag;
    /// <summary>ɾ��ָ�������Ľ��</summary>
    /// <param name="AIndex">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���ָ�������Ľ�㲻���ڣ����׳�EOutRange�쳣
    /// </remarks>
    procedure Delete(AIndex: Integer); overload; virtual;
    /// <summary>ɾ��ָ�����ƵĽ��</summary>
    /// <param name="AName">Ҫɾ���Ľ������</param>
    /// <param name="ADeleteAll">�Ƿ�ɾ��ȫ��ͬ���Ľ��</param>
    procedure Delete(AName: QStringW; ADeleteAll: Boolean = True); overload;
    /// <summary>����ָ�����ƵĽ�������</summary>
    /// <param name="AName">Ҫ���ҵĽ������</param>
    /// <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOf(const AName: QStringW): Integer; virtual;
    /// <summary>������еĽ��</summary>
    procedure Clear; virtual;
    /// <summary>����ָ����XML�ַ���</summary>
    /// <param name="p">Ҫ�������ַ���</param>
    /// <param name="l">�ַ������ȣ�<=0��Ϊ����\0(#0)��β��C���Ա�׼�ַ���</param>
    /// <remarks>���l>=0������p[l]�Ƿ�Ϊ\0�������Ϊ\0����ᴴ������ʵ������������ʵ��</remarks>
    procedure Parse(p: PQCharW; len: Integer = -1); overload;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name='s'>Ҫ������JSON�ַ���</param>
    procedure Parse(const s: QStringW); overload;
    /// <summary>��ָ�����ļ��м��ص�ǰ����</summary>
    /// <param name="AFileName">Ҫ���ص��ļ���</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    procedure LoadFromFile(AFileName: QStringW;
      AEncoding: TTextEncoding = teUnknown);
    /// <summary>�����ĵ�ǰλ�ÿ�ʼ����JSON����</summary>
    /// <param name="AStream">Դ������</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    /// <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream: TStream;
      AEncoding: TTextEncoding = teUnknown);
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    /// <param name="AFileName">�ļ���</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(AFileName: QStringW; AEncoding: TTextEncoding = teUTF8;
      AWriteBom: Boolean = False);
    /// <summary>���浱ǰ�������ݵ�����</summary>
    /// <param name="AStream">Ŀ��������</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBom">�Ƿ�д��BOM</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream: TStream; AEncoding: TTextEncoding = teUTF8;
      AWriteBom: Boolean = False);
    /// <summary>����TObject.ToString����</summary>
    function ToString: string; {$IFDEF QDAC_UNICODE}override; {$ENDIF}
    /// <summary>for..in֧�ֺ���</summary>
    function GetEnumerator: TQHtmlTagEnumerator;
    /// <summary>�ӽ������</<summary>summary>
    property Count: Integer read GetCount;
    /// <summary>�ӽ������</summary>
    property Items[AIndex: Integer]: TQHtmlTag read GetItems; default;
    /// <summary>����ĸ������ݳ�Ա�����û�������������</summary>
    property Data: Pointer read FData write FData;
    /// <summary>����·�����м���"\"�ָ�</summary>
    property Path: QStringW read GetPath;
    /// <summary>����ڸ�����ϵ�����������Լ��Ǹ���㣬�򷵻�-1</summary>
    property ItemIndex: Integer read GetItemIndex;
    /// <summary>�����</summary>
    property Parent: TQHtmlTag read FParent write FParent;
  published
    /// <summary>�������</summary>
    property Name: QStringW read GetName write SetName;
    /// <summary>���Ĵ��ı����ݣ�����ע�ͣ�ֻ����Text��CDATA)</summary>
    property Text: QStringW read GetText write SetText;
    /// <summary>�������</summary>
    property TagType: TQHtmlTagType read FTagType write SetTagType;
    /// <summary>�����б�</summary>
    property Attrs: TQHtmlAttrs read GetAttrs;
    /// <summary>�б�����</summary>
    property Capacity: Integer read GetCapacity write SetCapacity;
    /// <summary>����XML��ʽ������</summary>
    property AsHtml: QStringW read GetAsHtml write SetAsHtml;
  end;

implementation

resourcestring
  SValueNotNumeric = '�ַ��� %s ������Ч����ֵ��';
  SValueNotBoolean = '�ַ��� %s ������Ч�Ĳ���ֵ��';
  SValueNotDateTime = '�ַ��� %s ������Ч������ʱ��ֵ��';
  SBadTagName = 'ָ����Html���(Tag)������Ч��';

function ValidTagName(const s: QStringW): Boolean;
begin
  // Not check now
  Result := True;
end;
{ TQHtmlAttr }

function TQHtmlAttr.GetAsBoolean: Boolean;
begin
  if not TryStrToBool(FValue, Result) then
  begin
    try
      Result := (AsInt64 <> 0);
    except
      raise Exception.Create(SValueNotBoolean);
    end;
  end;
end;

function TQHtmlAttr.GetAsDateTime: TDateTime;
begin
  if not ParseDateTime(PQCharW(FValue), Result) then
    Result := GetAsFloat;
end;

function TQHtmlAttr.GetAsFloat: Extended;
var
  p: PQCharW;
begin
  p := PQCharW(FValue);
  if not ParseNumeric(p, Result) then
    raise Exception.CreateFmt(SValueNotNumeric, [FValue]);
end;

function TQHtmlAttr.GetAsInt64: Int64;
begin
  Result := Trunc(AsFloat);
end;

function TQHtmlAttr.GetAsInteger: Integer;
begin
  Result := AsInt64;
end;

procedure TQHtmlAttr.SetAsBoolean(const Value: Boolean);
begin
  FValue := BoolToStr(Value, True);
end;

procedure TQHtmlAttr.SetAsDateTime(const Value: TDateTime);
begin
  FValue := FloatToStr(Value);
end;

procedure TQHtmlAttr.SetAsFloat(const Value: Extended);
begin
  FValue := FloatToStr(Value);
end;

procedure TQHtmlAttr.SetAsInt64(const Value: Int64);
begin
  FValue := IntToStr(Value);
end;

procedure TQHtmlAttr.SetAsInteger(const Value: Integer);
begin
  SetAsInt64(Value);
end;

procedure TQHtmlAttr.SetName(const Value: QStringW);
begin
  if FName <> Value then
    FName := Value;
end;

{ TQHtmlAttrs }

function TQHtmlAttrs.Add(const AName, AValue: QStringW): Integer;
var
  Attr: TQHtmlAttr;
begin
  if ValidTagName(AName) then
  begin
    Attr := TQHtmlAttr.Create;
    Attr.FName := AName;
    Attr.FValue := AValue;
    Result := FItems.Add(Attr);
  end
  else
    raise Exception.Create(SBadTagName);
end;

function TQHtmlAttrs.Add(const AName: QStringW): TQHtmlAttr;
begin
  if ValidTagName(AName) then
  begin
    Result := TQHtmlAttr.Create;
    Result.FName := AName;
    FItems.Add(Result);
  end
  else
    raise Exception.Create(SBadTagName);
end;

procedure TQHtmlAttrs.Assign(ASource: TQHtmlAttrs);
var
  I: Integer;
  Attr, ASrc: TQHtmlAttr;
begin
  Clear;
  if (ASource <> nil) and (ASource.Count > 0) then
  begin
    for I := 0 to ASource.Count - 1 do
    begin
      ASrc := ASource[I];
      Attr := TQHtmlAttr.Create;
      Attr.FName := ASrc.FName;
      Attr.FValue := ASrc.FValue;
      FItems.Add(Attr);
    end;
  end;
end;

procedure TQHtmlAttrs.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    FreeObject(Items[I]);
  FItems.Clear;
end;

constructor TQHtmlAttrs.Create(AOwner: TQHtmlTag);
begin
  inherited Create;
  FOwner := AOwner;
  FItems := TQHtmlAttrList.Create;
end;

procedure TQHtmlAttrs.Delete(AName: QStringW);
var
  AIndex: Integer;
begin
  AIndex := IndexOfName(AName);
  if AIndex <> -1 then
    Delete(AIndex);
end;

procedure TQHtmlAttrs.Delete(AIndex: Integer);
begin
  FreeObject(Items[AIndex]);
  FItems.Delete(AIndex);
end;

destructor TQHtmlAttrs.Destroy;
begin
  Clear;
  FreeObject(FItems);
  inherited;
end;

function TQHtmlAttrs.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQHtmlAttrs.GetEnumerator: TQHtmlAttrEnumerator;
begin
  Result := TQHtmlAttrEnumerator.Create(Self);
end;

function TQHtmlAttrs.GetItems(AIndex: Integer): TQHtmlAttr;
begin
  Result := FItems[AIndex];
end;

function TQHtmlAttrs.IndexOfName(const AName: QStringW): Integer;
var
  I, L: Integer;
  AItem: TQHtmlAttr;
begin
  Result := -1;
  L := Length(AName);
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if Length(AItem.FName) = L then // Html���Ʋ����ִ�Сд
    begin
      if StartWithW(PQCharW(AItem.FName), PQCharW(AName), True) then
      begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

function TQHtmlAttrs.ItemByName(const AName: QStringW): TQHtmlAttr;
var
  I: Integer;
begin
  Result := nil;
  I := IndexOfName(AName);
  if I <> -1 then
    Result := Items[I];
end;

function TQHtmlAttrs.ValueByName(const AName, ADefVal: QStringW): QStringW;
var
  I: Integer;
begin
  I := IndexOfName(AName);
  if I <> -1 then
    Result := Items[I].FValue
  else
    Result := ADefVal;
end;

{ TQHtmlAttrEnumerator }

constructor TQHtmlAttrEnumerator.Create(AList: TQHtmlAttrs);
begin
  FList := AList;
  FIndex := -1;
  inherited Create;
end;

function TQHtmlAttrEnumerator.GetCurrent: TQHtmlAttr;
begin
  Result := FList[FIndex];
end;

function TQHtmlAttrEnumerator.MoveNext: Boolean;
begin
  if FIndex < FList.Count - 1 then
  begin
    Inc(FIndex);
    Result := True;
  end
  else
    Result := False;
end;

{ TQHtmlTagEnumerator }

constructor TQHtmlTagEnumerator.Create(AList: TQHtmlTag);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TQHtmlTagEnumerator.GetCurrent: TQHtmlTag;
begin
  Result := FList[FIndex];
end;

function TQHtmlTagEnumerator.MoveNext: Boolean;
begin
  if FIndex + 1 < FList.Count then
  begin
    Inc(FIndex);
    Result := True;
  end
  else
    Result := False;
end;

{ TQHtmlTag }

function TQHtmlTag.Add: TQHtmlTag;
begin
  Result := CreateTag;
  Result.FParent := Self;
  if not Assigned(FItems) then
    FItems := TQHtmlTagList.Create;
  FItems.Add(Result);
end;

function TQHtmlTag.Add(const AName_Text: QStringW; AType: TQHtmlTagType)
  : TQHtmlTag;
begin
  if AType = httNode then
    Result := AddNode(AName_Text)
  else
  begin
    Result := Add;
    Result.FTagType := AType;
    Result.Text := AName_Text;
  end;
end;

function TQHtmlTag.AddComment(const AText: QStringW): TQHtmlTag;
begin
  Result := Add(AText, httComment);
end;

function TQHtmlTag.AddNode(const AName: QStringW): TQHtmlTag;
begin
  if ValidTagName(AName) then
  begin
    Result := Add;
    Result.FTagType := httNode;
    Result.FName := AName;
  end;
end;

function TQHtmlTag.AddText(const AText: QStringW): TQHtmlTag;
begin
  Result := Add(AText, httText);
end;

procedure TQHtmlTag.Assign(ANode: TQHtmlTag);
var
  I: Integer;
begin
  FName := ANode.FName;
  FTagType := ANode.TagType;
  Clear;
  if Assigned(ANode.FAttrs) then
    Attrs.Assign(ANode.Attrs);
  for I := 0 to ANode.Count - 1 do
    Add.Assign(ANode.Items[I]);
end;

function TQHtmlTag.AttrByPath(const APath, AttrName: QStringW): TQHtmlAttr;
var
  ANode: TQHtmlTag;
begin
  ANode := ItemByPath(APath);
  if Assigned(ANode) then
    Result := ANode.Attrs.ItemByName(AttrName)
  else
    Result := nil;
end;

function TQHtmlTag.AttrValueByPath(const APath, AttrName, ADefVal: QStringW)
  : QStringW;
var
  Attr: TQHtmlAttr;
begin
  Attr := AttrByPath(APath, AttrName);
  if Assigned(Attr) then
    Result := Attr.Value
  else
    Result := ADefVal;
end;

procedure TQHtmlTag.Clear;
var
  I: Integer;
begin
  if Assigned(FItems) then
  begin
    for I := 0 to FItems.Count - 1 do
      FreeTag(Items[I]);
    FItems.Clear;
  end;
  if Assigned(FAttrs) then
    FAttrs.Clear;
end;

function TQHtmlTag.Clone: TQHtmlTag;
begin
  Result := Copy;
end;

function TQHtmlTag.Copy: TQHtmlTag;
begin
  Result := CreateTag;
  Result.Assign(Self);
end;

constructor TQHtmlTag.Create;
begin
  inherited;
end;

function TQHtmlTag.CreateTag: TQHtmlTag;
begin
  // if Assigned(OnQHtmlTagCreate) then
  // Result:=OnQHtmlTagCreate
  // else
  Result := TQHtmlTag.Create;
end;

procedure TQHtmlTag.Delete(AIndex: Integer);
begin
  if Assigned(FItems) then
  begin
    FreeTag(Items[AIndex]);
    FItems.Delete(AIndex);
  end;
end;

procedure TQHtmlTag.Delete(AName: QStringW; ADeleteAll: Boolean);
var
  I: Integer;
begin
  I := 0;
  while I < Count do
  begin
    if Items[I].FName = AName then
    begin
      Delete(I);
      if not ADeleteAll then
        Break;
    end
    else
      Inc(I);
  end;
end;

destructor TQHtmlTag.Destroy;
begin
  if Assigned(FItems) then
  begin
    Clear;
    FreeObject(FItems);
  end;
  if Assigned(FAttrs) then
    FreeObject(FAttrs);
  inherited;
end;

function TQHtmlTag.Encode(ADoFormat: Boolean; AIndent: QStringW): QStringW;
begin
end;

function TQHtmlTag.ForcePath(APath: QStringW): TQHtmlTag;
var
  AName: QStringW;
  p: PQCharW;
  AParent: TQHtmlTag;
const
  PathDelimiters: PWideChar = './\';
begin
  p := PQCharW(APath);
  AParent := Self;
  Result := Self;
  while p^ <> #0 do
  begin
    AName := DecodeTokenW(p, PathDelimiters, WideChar(0), True);
    Result := AParent.ItemByName(AName);
    if not Assigned(Result) then
      Result := AParent.Add(AName);
    AParent := Result;
  end;
end;

procedure TQHtmlTag.FreeTag(ATag: TQHtmlTag);
begin
  // if Assigned(FOnQHtmlFreeTag) then
  // FOnQHtmlFreeTag(ATag);
  // else
  FreeObject(ATag);
end;

function TQHtmlTag.GetAsHtml: QStringW;
begin
  Result := Encode(True);
end;

function TQHtmlTag.GetAttrs: TQHtmlAttrs;
begin
  if not Assigned(FAttrs) then
    FAttrs := TQHtmlAttrs.Create(Self);
  Result := FAttrs;
end;

function TQHtmlTag.GetCapacity: Integer;
begin
  if Assigned(FItems) then
    Result := FItems.Capacity
  else
    Result := 0;
end;

function TQHtmlTag.GetCount: Integer;
begin
  if Assigned(FItems) then
    Result := FItems.Count
  else
    Result := 0;
end;

function TQHtmlTag.GetEnumerator: TQHtmlTagEnumerator;
begin
  Result := TQHtmlTagEnumerator.Create(Self);
end;

function TQHtmlTag.GetItemIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  if Assigned(FParent) then
  begin
    for I := 0 to FParent.Count - 1 do
    begin
      if FParent.Items[I] = Self then
      begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

function TQHtmlTag.GetItems(AIndex: Integer): TQHtmlTag;
begin
  Result := FItems[AIndex];
end;

function TQHtmlTag.GetName: QStringW;
begin
  if TagType = httNode then
    Result := FName
  else
    SetLength(Result, 0);
end;

function TQHtmlTag.GetPath: QStringW;
var
  AParent: TQHtmlTag;
begin
  Result := Name;
  AParent := FParent;
  while Assigned(AParent) do
  begin
    if Length(AParent.Name) > 0 then
      Result := AParent.Name + '\' + Result;
    AParent := AParent.FParent;
  end;
end;

function TQHtmlTag.GetText: QStringW;
var
  ABuilder: TQStringCatHelperW;
  procedure InternalGetText(ANode: TQHtmlTag);
  var
    I: Integer;
  begin
    if ANode.TagType = httNode then
    begin
      for I := 0 to ANode.Count - 1 do
        InternalGetText(ANode.Items[I]);
    end
    else // if ANode.NodeType<>xntComment then //ע�Ͳ�������Text�У��ı���CDATA���ݷ���
      ABuilder.Cat(ANode.FName);
  end;

begin
  ABuilder := TQStringCatHelperW.Create;
  try
    InternalGetText(Self);
    Result := ABuilder.Value;
  finally
    ABuilder.Free;
  end;
end;

function TQHtmlTag.IndexOf(const AName: QStringW): Integer;
var
  AIndex: Integer;
begin
  AIndex := IndexOf(AName);
  if AIndex <> -1 then
    Result := Items[AIndex]
  else
    Result := nil;
end;

function TQHtmlTag.ItemByName(const AName: QStringW; AList: TQHtmlTagList;
  ANest: Boolean): Integer;
var
  ANode: TQHtmlTag;
  function InternalFind(AParent: TQHtmlTag): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to AParent.Count - 1 do
    begin
      ANode := AParent.Items[I];
      if ANode.Name = AName then
      begin
        AList.Add(ANode);
        Inc(Result);
      end;
      if ANest then
        Inc(Result, InternalFind(ANode));
    end;
  end;

begin
  Result := InternalFind(Self);
end;

function TQHtmlTag.ItemByName(const AName: QStringW): TQHtmlTag;
begin

end;

function TQHtmlTag.ItemByPath(const APath: QStringW): TQHtmlTag;
var
  AName: QStringW;
  pPath: PQCharW;
  AParent, AItem: TQHtmlTag;
const
  PathDelimiters: PWideChar = '/\.';
begin
  if Length(APath) > 0 then
  begin
    pPath := PQCharW(APath);
    AParent := Self;
    AItem := nil;
    while pPath^ <> #0 do
    begin
      AName := DecodeTokenW(pPath, PathDelimiters, WideChar(0), False);
      AItem := AParent.ItemByName(AName);
      if Assigned(AItem) then
        AParent := AItem
      else
        Break;
    end;
    if AParent = AItem then
      Result := AParent
    else
      Result := nil;
  end
  else
    Result := Self;
end;

function TQHtmlTag.ItemByRegex(const ARegex: QStringW; AList: TQHtmlTagList;
  ANest: Boolean): Integer;
begin

end;

function TQHtmlTag.ItemWithAttrValue(const APath, AttrName, AttrValue: QStringW)
  : TQHtmlTag;
var
  ANode: TQHtmlTag;
  I: Integer;
  Attr: TQHtmlAttr;
  AFound: Boolean;
begin
  Result := nil;
  ANode := ItemByPath(APath);
  if Assigned(ANode) then
  begin
    I := ANode.ItemIndex;
    while I < ANode.Parent.Count do
    begin
      ANode := ANode.Parent[I];
      Attr := ANode.Attrs.ItemByName(AttrName);
      if Attr <> nil then
      begin
        if Length(Attr.Value) = Length(AttrValue) then
        begin
          AFound := StartWithW(PQCharW(Attr.Value), PQCharW(AttrValue), True);
          if AFound then
          begin
            Result := ANode;
            Break;
          end;
        end;
      end;
      Inc(I);
    end;
  end;
end;

procedure TQHtmlTag.LoadFromFile(AFileName: QStringW; AEncoding: TTextEncoding);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(AStream);
  finally
    FreeObject(AStream);
  end;
end;

procedure TQHtmlTag.LoadFromStream(AStream: TStream; AEncoding: TTextEncoding);
begin
  Parse(LoadTextW(AStream));
end;

procedure TQHtmlTag.Parse(const s: QStringW);
begin

end;

procedure TQHtmlTag.Parse(p: PQCharW; len: Integer);
begin

end;

procedure TQHtmlTag.SaveToFile(AFileName: QStringW; AEncoding: TTextEncoding;
  AWriteBom: Boolean);
begin

end;

procedure TQHtmlTag.SaveToStream(AStream: TStream; AEncoding: TTextEncoding;
  AWriteBom: Boolean);
begin

end;

procedure TQHtmlTag.SetAsHtml(const Value: QStringW);
begin

end;

procedure TQHtmlTag.SetCapacity(const Value: Integer);
begin

end;

procedure TQHtmlTag.SetName(const Value: QStringW);
begin

end;

procedure TQHtmlTag.SetTagType(const Value: TQHtmlTagType);
begin
  FTagType := Value;
end;

procedure TQHtmlTag.SetText(const Value: QStringW);
begin

end;

function TQHtmlTag.TextByPath(const APath, ADefVal: QStringW): QStringW;
begin

end;

function TQHtmlTag.ToString: string;
begin

end;

end.

unit qmsgpack;
{$i 'qdac.inc'}

interface

{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}

{ �޶���־
  2014.6.26
  ==========
  * ������ToRtti.ToRecord�Ӻ���������������ʱ�Ĵ���(��лȺ�ѷɺ������RTTI����Ͳ���)
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.23
  ==========
  + FromRecord֧�ֶ�̬�������ͨ����
  2014.6.21
  ==========
  + ����RTTI����֧��(Invoke/FromRtti/ToRtti/FromRecord/ToRecord)
  2014.6.20
  ==========
  + ���Ӷ�Single���͵�֧��(AsSingle)������ȫ��MessagePack��ʽ��֧��������
  2014.6.19
  ==========
  * ������QMsgPack����ʱ�����ڳ���Ϊ0���ַ���������������
  2014.6.17
  ==========
  * �׸���ʽ�汾������Ŀǰ��RTTI��صļ���������ʱ������
}
uses classes, sysutils, math, qstring, qrbtree, typinfo,
  variants
  {$IFDEF UNICODE}, Generics.Collections,Rtti{$ENDIF}
  {$IF RTLVersion<22}//2007-2010
    ,PerlRegEx,pcre
  {$ELSE}
      ,RegularExpressionsCore
  {$IFEND};
{$HPPEMIT '#pragma link "qmsgpack"'}
type
  TQMsgPack = class;
  TQMsgPackType = (mptUnknown, mptInteger, mptNull, mptBoolean, mptSingle,
    mptFloat, mptString, mptBinary, mptArray, mptMap, mptExtended, mptDateTime);
{$IFDEF UNICODE}
  /// <summary>
  /// RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQMsgPack����</param>
  /// <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  /// <param name="AType">���Ի��ֶε�������Ϣ</param>
  /// <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  /// <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQMsgPackRttiFilterEventA = reference to procedure(ASender: TQMsgPack;
    AObject: Pointer; AName: QStringW; AType: PTypeInfo; var Accept: Boolean;
    ATag: Pointer);
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQMsgPack����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQMsgPackFilterEventA = reference to procedure(ASender, AItem: TQMsgPack;
    var Accept: Boolean; ATag: Pointer);
{$ENDIF UNICODE}
  /// <summary>
  /// RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQMsgPack����</param>
  /// <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  /// <param name="AType">���Ի��ֶε�������Ϣ</param>
  /// <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  /// <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQMsgPackRttiFilterEvent = procedure(ASender: TQMsgPack; AObject: Pointer;
    AName: QStringW; AType: PTypeInfo; var Accept: Boolean; ATag: Pointer)
    of object;
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQMsgPack����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQMsgPackFilterEvent = procedure(ASender, AItem: TQMsgPack;
    var Accept: Boolean; ATag: Pointer) of object;
  {$IFDEF UNICODE}
  TQMsgPackList = TList<TQMsgPack>;
  {$ELSE}
    TQMsgPackList = TList;
  {$ENDIF}
  TQMsgPackEnumerator = class
  private
    FIndex: Integer;
    FList: TQMsgPack;
  public
    constructor Create(AList: TQMsgPack);
    function GetCurrent: TQMsgPack; inline;
    function MoveNext: Boolean;
    property Current: TQMsgPack read GetCurrent;
  end;

  TQMsgPack = class
  private
    FName: QStringW; // ����
    FNameHash: Cardinal; // ��ϣֵ
    FValue: TBytes; // ֵ
    FItems: TQMsgPackList;
    FParent: TQMsgPack;
    FDataType: TQMsgPackType;
    FExtType: Shortint;
    FData: Pointer;
    function GetAsBoolean: Boolean;
    function GetAsDateTime: TDateTime;
    function GetAsFloat: Double;
    function GetAsInt64: Int64;
    function GetAsInteger: Integer;
    function GetAsMsgPack: TBytes;
    function GetAsString: QStringW;
    function GetAsVariant: Variant;
    function GetCount: Integer;
    function GetIsArray: Boolean;
    function GetIsDateTime: Boolean;
    function GetIsNull: Boolean;
    function GetIsNumeric: Boolean;
    function GetIsObject: Boolean;
    function GetIsString: Boolean;
    function GetItemIndex: Integer;
    function GetItems(AIndex: Integer): TQMsgPack;
    function GetPath: QStringW;
    function GetValue: QStringW;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsFloat(const Value: Double);
    procedure SetAsInt64(const Value: Int64);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsMsgPack(const Value: TBytes);
    procedure SetAsString(const Value: QStringW);
    procedure SetAsVariant(const Value: Variant);
    procedure SetDataType(const Value: TQMsgPackType);
    procedure InternalParse(var p: PByte; l: Integer);
    procedure ArrayNeeded(ANewType: TQMsgPackType);
    function CreateItem: TQMsgPack; virtual;
    procedure FreeItem(AItem: TQMsgPack); virtual;
    procedure CopyValue(ASource: TQMsgPack); inline;
    procedure SetExtType(const Value: Shortint);
    function GetAsExtBytes: TBytes;
    procedure SetExtBytes(const Value: TBytes);
    function GetAsBytes: TBytes;
    procedure SetAsBytes(const Value: TBytes);
    function GetAsSingle: Single;
    procedure SetAsSingle(const Value: Single);
  protected
    procedure Replace(AIndex: Integer; ANewItem: TQMsgPack); virtual;
  public
    /// <summary>���캯��</summary>
    constructor Create; overload;
    constructor Create(const AName: QStringW;
      ADataType: TQMsgPackType = mptUnknown); overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
    { <summary�����һ���ӽ��<��summary>
      <param name="ANode">Ҫ��ӵĽ��</param>
      <returns>������ӵĽ������</returns>
    }
    function Add(ANode: TQMsgPack): Integer; overload;
    /// <summary>���һ��δ������MsgPack�ӽ��</summary>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>
    /// һ������£������������ͣ���Ӧ���δ������ʵ��
    /// </remarks>
    function Add: TQMsgPack; overload;
    /// <summary>���һ������</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AItems">Ҫ��ӵ���������</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function Add(const AName: QStringW; AItems: array of const)
      : TQMsgPack; overload;
    { <summary>���һ���ӽ��</summary>
      <param name="AName">Ҫ��ӵĽ����</param>
      <param name="ADataType">Ҫ��ӵĽ���������ͣ����ʡ�ԣ����Զ�����ֵ�����ݼ��</param>
      <returns>������ӵ��¶���</returns>
      <remarks>
      1.�����ǰ���Ͳ���jdtObject��jdtArray�����Զ�ת��ΪjdtObject����
      2.�ϲ�Ӧ�Լ������������
      </remarks>
    }
    function Add(AName: QStringW; ADataType: TQMsgPackType): TQMsgPack;
      overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName, AValue: QStringW): TQMsgPack; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Double): TQMsgPack; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Int64): TQMsgPack; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Boolean): TQMsgPack; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; const AValue: TBytes): TQMsgPack; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddDateTime(AName: QStringW; AValue: TDateTime)
      : TQMsgPack; overload;
    /// <summary>���һ���ӽ��(Null)</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW): TQMsgPack; overload; virtual;

    /// <summary>ǿ��һ��·������,���������,�����δ�����Ҫ�Ľ��(jdtObject��jdtArray)</summary>
    /// <param name="APath">Ҫ��ӵĽ��·��</param>
    /// <returns>����·����Ӧ�Ķ���</returns>
    /// <remarks>
    /// ��������·����ȫ�����ڣ���ForcePath�ᰴ���¹���ִ��:
    /// 1�����APath�а���[]������Ϊ��Ӧ��·�����Ϊ���飬ʾ�����£�
    /// (1)��'a.b[].name'��
    /// a -> jdtObject
    /// b -> jdtArray
    /// b[0].name -> jdtNull(b������δָ�����Զ���Ϊ��b[0]
    /// (2)��'a.c[2].name'��
    /// a -> jdtObject
    /// c -> jdtArray
    /// c[2].name -> jdtNull
    /// ����,c[0],c[1]���Զ�����������ֵΪjdtNull��ִ����ɺ�cΪ��������Ԫ�ص�����
    /// (3)��'a[0]'��
    /// a -> jdtArray
    /// a[0] -> jdtNull
    /// 2��·���ָ���./\�ǵȼ۵ģ����ҽ�������в�Ӧ�������������ַ�֮һ,����
    /// a.b.c��a\b\c��a/b/c����ȫ��ͬ��·��
    /// 3�����APathָ���Ķ������Ͳ�ƥ�䣬����׳��쳣����aΪ���󣬵�ʹ��a[0].b����ʱ��
    /// </remarks>
    function ForcePath(APath: QStringW): TQMsgPack;
    /// <summary>����ָ����MsgPack�ֽ�����</summary>
    /// <param name="p">Ҫ�������ֽ�����</param>
    /// <param name="l">�ַ������ȣ�<=0��Ϊ����\0(#0)��β��C���Ա�׼�ַ���</param>
    /// <remarks>���l>=0������p[l]�Ƿ�Ϊ\0�������Ϊ\0����ᴴ������ʵ������������ʵ��</remarks>
    procedure Parse(p: PByte; l: Integer = -1); overload;
    /// <summary>����ָ����MsgPack�ַ���</summary>
    /// <param name="s">Ҫ������MsgPack�ַ���</param>
    procedure Parse(const s: TBytes); overload;
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function Copy: TQMsgPack;
{$IFDEF UNICODE}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function CopyIf(const ATag: Pointer; AFilter: TQMsgPackFilterEventA)
      : TQMsgPack; overload;
{$ENDIF UNICODE}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function CopyIf(const ATag: Pointer; AFilter: TQMsgPackFilterEvent)
      : TQMsgPack; overload;
    /// <summary>��¡����һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊʵ����ִ�е��ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ��
    /// ��������һ�����󣬲��������һ���������Ӱ�죬������Ϊ����������֤������
    /// �����Ϊ���ã��Ա��໥Ӱ�졣
    /// </remarks>
    function Clone: TQMsgPack;
    /// <summary>����</summary>
    /// <returns>���ر������ֽ���</returns>
    /// <remarks>AsMsgPack�ȼ��ڱ�����</remarks>
    function Encode: TBytes;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <returns>����Ӧ����ֵ</returns>
    function ValueByName(AName, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ��·������ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function ValueByPath(APath, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ�����Ƶĵ�һ�����</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����ҵ��Ľ�㣬���δ�ҵ������ؿ�(NULL/nil)</returns>
    /// <remarks>ע��QMsgPack���������������ˣ�������������Ľ�㣬ֻ�᷵�ص�һ�����</remarks>
    function ItemByName(AName: QStringW): TQMsgPack; overload;
    /// <summary>��ȡָ�����ƵĽ�㵽�б���</summary>
    /// <param name="AName">�������</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByName(const AName: QStringW; AList: TQMsgPackList;
      ANest: Boolean = False): Integer; overload;
    /// <summary>��ȡ����ָ�����ƹ���Ľ�㵽�б���</summary>
    /// <param name="ARegex">������ʽ</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByRegex(const ARegex: QStringW; AList: TQMsgPackList;
      ANest: Boolean = False): Integer; overload;
    /// <summary>��ȡָ��·����MsgPack����</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <returns>�����ҵ����ӽ�㣬���δ�ҵ�����NULL(nil)</returns>
    function ItemByPath(APath: QStringW): TQMsgPack;
    /// <summary>��Դ������MsgPack��������</summary>
    /// <param name="ANode">Ҫ���Ƶ�Դ���</param>
    /// <remarks>ע�ⲻҪ�����ӽ����Լ�������������ѭ����Ҫ�����ӽ�㣬�ȸ�
    /// ��һ���ӽ�����ʵ�����ٴ���ʵ������
    /// </remarks>
    procedure Assign(ANode: TQMsgPack); virtual;
    /// <summary>ɾ��ָ�������Ľ��</summary>
    /// <param name="AIndex">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���ָ�������Ľ�㲻���ڣ����׳�EOutRange�쳣
    /// </remarks>
    procedure Delete(AIndex: Integer); overload; virtual;
    /// <summary>ɾ��ָ�����ƵĽ��</summary>
    /// <param name="AName">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���Ҫ��������Ľ�㣬��ֻɾ����һ��
    procedure Delete(AName: QStringW); overload;
{$IFDEF UNICODE}
    /// <summary>
    /// ɾ�������������ӽ��
    /// </summary>
    /// <param name="ATag">�û��Լ����ӵĶ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQMsgPackFilterEventA); overload;
{$ENDIF UNICODE}
    /// <summary>
    /// ɾ�������������ӽ��
    /// </summary>
    /// <param name="ATag">�û��Լ����ӵĶ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQMsgPackFilterEvent); overload;
    /// <summary>����ָ�����ƵĽ�������</summary>
    /// <param name="AName">Ҫ���ҵĽ������</param>
    /// <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOf(const AName: QStringW): Integer; virtual;
{$IFDEF UNICODE}
    /// <summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQMsgPackFilterEventA): TQMsgPack; overload;
{$ENDIF UNICODE}
    /// <summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag: Pointer; ANest: Boolean;
      AFilter: TQMsgPackFilterEvent): TQMsgPack; overload;
    /// <summary>������еĽ��</summary>
    procedure Clear; virtual;
    /// <summary>���浱ǰ�������ݵ�����</summary>
    /// <param name="AStream">Ŀ��������</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBom">�Ƿ�д��BOM</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream: TStream);
    /// <summary>�����ĵ�ǰλ�ÿ�ʼ����MsgPack����</summary>
    /// <param name="AStream">Դ������</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    /// <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream: TStream);
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    /// <param name="AFileName">�ļ���</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(AFileName: String);
    /// <summary>��ָ�����ļ��м��ص�ǰ����</summary>
    /// <param name="AFileName">Ҫ���ص��ļ���</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    procedure LoadFromFile(AFileName: String);
    /// / <summary>����ֵΪNull���ȼ���ֱ������DataTypeΪjdtNull</summary>
    procedure ResetNull;
    /// <summary>����TObject.ToString����</summary>
    function ToString: string; {$IFDEF UNICODE}override; {$ELSE}virtual;
{$ENDIF}
{$IFDEF UNICODE}
    /// <summary>ʹ�õ�ǰJson�����������ָ���������Ӧ����</summary>
    /// <param name="AInstance">�����������Ķ���ʵ��</param>
    /// <returns>���غ������õĽ��</returns>
    /// <remarks>��������Ϊ��ǰ������ƣ������Ĳ����������ӽ�������Ҫ����һ��</remarks>
    function Invoke(AInstance: TValue): TValue;
    /// <summary>����ǰ��ֵת��ΪTValue���͵�ֵ</summary>
    /// <returns>���ص�ǰ���ת�����TValueֵ</returns>
    function ToRttiValue: TValue;
    /// <summary>��ָ����RTTIʵ��������JSON����</summary>
    /// <param name="AInstance">���������RTTI����ֵ</param>
    /// <remarks>ע�ⲻ��ȫ��RTTI���Ͷ���֧�֣���ӿ�ɶ��</remarks>
    procedure FromRtti(AInstance: TValue); overload;
    /// <summary>��ָ������Դ��ַ��ָ������������JSON����</summary>
    /// <param name="ASource">�����ṹ���ַ</param>
    /// <param name="AType">�����ṹ��������Ϣ</param>
    procedure FromRtti(ASource: Pointer; AType: PTypeInfo); overload;
    /// <summary>��ָ���ļ�¼ʵ��������JSON����</summary>
    /// <param name="ARecord">��¼ʵ��</param>
    procedure FromRecord<T>(const ARecord: T);
    /// <summary>�ӵ�ǰJSON�л�ԭ��ָ���Ķ���ʵ����</summary>
    /// <param name="AInstance">ʵ����ַ</param>
    /// <remarks>ʵ���ϲ���ֻ֧�ֶ��󣬼�¼����Ŀǰ�޷�ֱ��ת��ΪTValue������û
    /// ���壬������������Ϊ��ֵ������ʵ�ʾ��㸳ֵ��Ҳ���ز��ˣ����������</remarks>
    procedure ToRtti(AInstance: TValue); overload;
    /// <summary>�ӵ�ǰJSON�а�ָ����������Ϣ��ԭ��ָ���ĵ�ַ</summary>
    /// <param name="ADest">Ŀ�ĵ�ַ</param>
    /// <param name="AType">�����ṹ���������Ϣ</param>
    /// <remarks>ADest��Ӧ��Ӧ�Ǽ�¼������������Ͳ���֧��</remarks>
    procedure ToRtti(ADest: Pointer; AType: PTypeInfo); overload;
    /// <summary>�ӵ�ǰ��JSON�л�ԭ��ָ���ļ�¼ʵ����</summary>
    /// <param name="ARecord">Ŀ�ļ�¼ʵ��</param>
    procedure ToRecord<T>(const ARecord: T);
{$ENDIF}
    function GetEnumerator: TQMsgPackEnumerator;
    /// <summary>�ж��Լ��Ƿ���һ��ָ���Ķ�����Ӷ���</summary>
    /// <param name="AParent">���ܵĸ�����</param>
    /// <returns>����Լ���ָ��������Ӷ����򷵻�True�����򣬷���False</returns>
    function IsChildOf(AParent: TQMsgPack): Boolean;
    /// <summary>�ж��Լ��Ƿ���һ��ָ���Ķ���ĸ�����</summary>
    /// <param name="AParent">���ܵ��Ӷ���</param>
    /// <returns>����Լ���ָ������ĸ������򷵻�True�����򣬷���False</returns>
    function IsParentOf(AChild: TQMsgPack): Boolean;
    /// <summary>�����м��ض���������</summary>
    /// <param name="AStream">Դ������</param>
    /// <param name="ACount">Ҫ�������ֽ��������Ϊ0���򿽱�Դ��������ȫ������</param>
    procedure BytesFromStream(AStream: TStream; ACount: Integer);
    /// <summary>���ļ��м��ض���������</summary>
    /// <param name="AFileName">Դ�ļ���</param>
    procedure BytesFromFile(AFileName: QStringW);
    /// <summary>����ǰ���ݱ��浽����</summary>
    /// <param name="AStream">Ŀ��������</param>
    procedure BytesToStream(AStream: TStream);
    /// <summary>����ǰ���ݱ��浽�ļ���</summary>
    /// <param name="AFileName">Ŀ���ļ���</param>
    procedure BytesToFile(AFileName: QStringW);
    /// <summary>�����</summary>
    property Parent: TQMsgPack read FParent;
    /// <summary>�������</summary>
    /// <seealso>TQMsgPackType</seealso>
    property DataType: TQMsgPackType read FDataType write SetDataType;
    /// <summary>�������</summary>
    property Name: QStringW read FName;
    /// <summary>�ӽ������</<summary>summary>
    property Count: Integer read GetCount;
    /// <summary>�ӽ������</summary>
    property Items[AIndex: Integer]: TQMsgPack read GetItems; default;
    /// <summary>�ӽ���ֵ</summary>
    property Value: QStringW read GetValue;
    /// <summary>�ж��Ƿ���NULL����</summary>
    property IsNull: Boolean read GetIsNull;
    /// <summary>�ж��Ƿ�����������</summary>
    property IsNumeric: Boolean read GetIsNumeric;
    /// <summary>�ж��Ƿ�������ʱ������</summary>
    property IsDateTime: Boolean read GetIsDateTime;
    /// <summary>�ж��Ƿ����ַ�������</summary>
    property IsString: Boolean read GetIsString;
    /// <summary>�ж��Ƿ��Ƕ���</summary>
    property IsObject: Boolean read GetIsObject;
    /// <summary>�ж��Ƿ�������</summary>
    property IsArray: Boolean read GetIsArray;
    /// <summary>����ǰ��㵱���������ͷ���</summary>
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    /// <summary>����ǰ�����Ϊ�ֽ���������</summary>
    property AsBytes: TBytes read GetAsBytes write SetAsBytes;
    /// <summary>����ǰ��㵱����������������</summary>
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    /// <summary>����ǰ��㵱��64λ��������������</summary>
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    /// <summary>����ǰ��㵱��˫��������������</summary>
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    /// <summary>����ǰ��㵱�������ȸ�������������</summary>
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    /// <summary>����ǰ��㵱������ʱ������������</summary>
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    /// <summary>����ǰ��㵱���ַ������ͷ���</summary>
    property AsString: QStringW read GetAsString write SetAsString;
    /// <summary>���Լ�����Variant����������</summary>
    property AsVariant: Variant read GetAsVariant write SetAsVariant;
    /// <summary>���Լ�����MsgPack����������</summary>
    property AsMsgPack: TBytes read GetAsMsgPack write SetAsMsgPack;
    /// <summary>���Լ�������չ����������</summary>
    property AsExtBytes: TBytes read GetAsExtBytes write SetExtBytes;
    // <summary>����ĸ������ݳ�Ա�����û�������������</summary>
    property Data: Pointer read FData write FData;
    /// <summary>����·����·���м���"\"�ָ�</summary>
    property Path: QStringW read GetPath;
    /// <summary>�ڸ�����е�����˳�򣬴�0��ʼ�������-1��������Լ��Ǹ����</summary>
    property ItemIndex: Integer read GetItemIndex;
    /// <summary>���ƹ�ϣֵ</summary>
    property NameHash: Cardinal read FNameHash;
    /// <summary>��չ����</summary>
    property ExtType: Shortint read FExtType write SetExtType;
  end;

  TQHashedMsgPack = class(TQMsgPack)
  protected
    FHashTable: TQHashTable;
    function CreateItem: TQMsgPack; override;
    procedure Replace(AIndex: Integer; ANewItem: TQMsgPack); override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Assign(ANode: TQMsgPack); override;
    function Add(AName: QStringW): TQMsgPack; override;
    function IndexOf(const AName: QStringW): Integer; override;
    procedure Delete(AIndex: Integer); override;
    procedure Clear; override;
  end;

  /// <summary>�����ⲿ֧�ֶ���صĺ���������һ���µ�TQMsgPack����ע��ӳ��д����Ķ���</summary>
  /// <returns>�����´�����TQMsgPack����</returns>
  TQMsgPackCreateEvent = function: TQMsgPack;
  /// <summary>�����ⲿ�����󻺴棬�Ա����ö���</summary>
  /// <param name="AObj">Ҫ�ͷŵ�MsgPack����</param>
  TQMsgPackFreeEvent = procedure(AObj: TQMsgPack);

var
  /// <summary>��������ת��Ϊ�ַ���ʱ���������������θ�ʽ��</summary>
  MsgPackDateFormat: QStringW;
  /// <summary>ʱ������ת��Ϊ�ַ���ʱ���������������θ�ʽ��</summary>
  MsgPackTimeFormat: QStringW;
  /// <summary>����ʱ������ת��Ϊ�ַ���ʱ���������������θ�ʽ��</summary>
  MsgPackDateTimeFormat: QStringW;
  /// <summary>��ItemByName/ItemByPath/ValueByName/ValueByPath�Ⱥ������ж��У��Ƿ��������ƴ�Сд</summary>
  MsgPackCaseSensitive: Boolean;
  /// ����Ҫ�½�һ��TQMsgPack����ʱ����
  OnQMsgPackCreate: TQMsgPackCreateEvent;
  /// ����Ҫ�ͷ�һ��TQMsgPack����ʱ����
  OnQMsgPackFree: TQMsgPackFreeEvent;
  QMsgPackPathDelimiter: QCharW = '\';

implementation

resourcestring

  SNotArrayOrMap = '%s ����ӳ������顣';
  SUnsupportArrayItem = '��ӵĶ�̬�����%d��Ԫ�����Ͳ���֧�֡�';
  SBadMsgPackArray = '%s ����һ����Ч��MsgPack���鶨�塣';
  SBadMsgPackName = '%s ����һ����Ч��MsgPack���ơ�';
  SBadConvert = '%s ����һ����Ч�� %s ���͵�ֵ��';
  SVariantNotSupport = '��֧��ת��ΪVariant���͡�';
  SNotSupport = '���� [%s] �ڵ�ǰ���������²���֧�֡�';
  SReservedExtType = '<0����չ���ͱ���׼����Ϊ���������á�';
  SReplaceTypeNeed = '�滻��������Ҫ���� %s �������ࡣ';
  SParamMissed = '���� %s ͬ���Ľ��δ�ҵ���';
  SMethodMissed = 'ָ���ĺ��� %s �����ڡ�';
  SMissRttiTypeDefine =
    '�޷��ҵ� %s ��RTTI������Ϣ�����Խ���Ӧ�����͵�������(��array[0..1] of Byte��ΪTByteArr=array[0..1]��Ȼ����TByteArr����)��';
  SUnsupportPropertyType = '��֧�ֵ���������';
  SUnsupportValueType = 'TValue��֧�ֶ����ƻ���չ����.';
  SArrayTypeMissed = 'δ֪������Ԫ�����͡�';

type
  PQD2007Byte = ^TQD2007ByteArray;

  TQD2007ByteArray = packed record
    Bytes: array [0 .. 7] of Byte;
  end;

  TQMsgPackValue = packed record
    ValueType: Byte;
    case Integer of
      0:
        (U8Val: Byte);
      1:
        (I8Val: Shortint);
      2:
        (U16Val: Word);
      3:
        (I16Val: Smallint);
      4:
        (U32Val: Cardinal);
      5:
        (I32Val: Integer);
      6:
        (U64Val: UInt64);
      7:
        (I64Val: Int64);
      8:
        (F32Val: Single);
      9:
        (F64Val: Double);
      10:
        (BArray: array [0 .. 16] of Byte);
  end;

const
  MsgPackTypeName: array [0 .. 10] of QStringW = ('Unknown', 'Integer', 'Null',
    'Boolean', 'Float', 'String', 'Binary', 'Array', 'Map', 'Extended',
    'DateTime');
  { TQMsgPack }

constructor TQMsgPack.Create;
begin
inherited;
end;

constructor TQMsgPack.Create(const AName: QStringW; ADataType: TQMsgPackType);
begin
FName := AName;
DataType := ADataType;
end;

function TQMsgPack.CreateItem: TQMsgPack;
begin
if Assigned(OnQMsgPackCreate) then
  Result := OnQMsgPackCreate
else
  Result := TQMsgPack.Create;
end;

procedure TQMsgPack.Delete(AName: QStringW);
var
  I: Integer;
begin
I := IndexOf(AName);
if I <> -1 then
  Delete(I);
end;

procedure TQMsgPack.Delete(AIndex: Integer);
begin
if FDataType in [mptArray, mptMap] then
  begin
  FreeItem(Items[AIndex]);
  FItems.Delete(AIndex);
  end
else
  raise Exception.Create(Format(SNotArrayOrMap, [FName]));
end;

procedure TQMsgPack.DeleteIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQMsgPackFilterEvent);
  procedure DeleteChildren(AParent: TQMsgPack);
  var
    I: Integer;
    Accept: Boolean;
    AChild: TQMsgPack;
  begin
  I := 0;
  while I < AParent.Count do
    begin
    Accept := True;
    AChild := AParent.Items[I];
    if ANest then
      DeleteChildren(AChild);
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      AParent.Delete(I)
    else
      Inc(I);
    end;
  end;

begin
if Assigned(AFilter) then
  DeleteChildren(Self)
else
  Clear;
end;
{$IFDEF UNICODE}

procedure TQMsgPack.DeleteIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQMsgPackFilterEventA);
  procedure DeleteChildren(AParent: TQMsgPack);
  var
    I: Integer;
    Accept: Boolean;
    AChild: TQMsgPack;
  begin
  I := 0;
  while I < AParent.Count do
    begin
    Accept := True;
    AChild := AParent.Items[I];
    if ANest then
      DeleteChildren(AChild);
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      AParent.Delete(I)
    else
      Inc(I);
    end;
  end;

begin
if Assigned(AFilter) then
  DeleteChildren(Self)
else
  Clear;
end;
{$ENDIF UNICODE}

destructor TQMsgPack.Destroy;
begin
if DataType in [mptArray, mptMap] then
  begin
  Clear;
  FreeObject(FItems);
  end;
inherited;
end;

function TQMsgPack.Add(const AName: QStringW; AItems: array of const)
  : TQMsgPack;
var
  I: Integer;
begin
Result := Add(AName, mptArray);
for I := Low(AItems) to High(AItems) do
  begin
  case AItems[I].VType of
    vtInteger:
      Result.Add.AsInteger := AItems[I].VInteger;
    vtBoolean:
      Result.Add.AsBoolean := AItems[I].VBoolean;
{$IFNDEF NEXTGEN}
    vtChar:
      Result.Add.AsString := QStringW(AItems[I].VChar);
{$ENDIF !NEXTGEN}
    vtExtended:
      Result.Add.AsFloat := AItems[I].VExtended^;
{$IFNDEF NEXTGEN}
    vtPChar:
      Result.Add.AsString := QStringW(AItems[I].VPChar);
    vtString:
      Result.Add.AsString := QStringW(AItems[I].VString^);
    vtAnsiString:
      Result.Add.AsString := QStringW(
{$IFDEF UNICODE}
        PAnsiString(AItems[I].VAnsiString)^
{$ELSE}
        AItems[I].VPChar
{$ENDIF UNICODE}
        );
    vtWideString:
      Result.Add.AsString := PWideString(AItems[I].VWideString)^;
{$ENDIF !NEXTGEN}
    vtPointer:
      Result.Add.AsInt64 := IntPtr(AItems[I].VPointer);
    vtWideChar:
      Result.Add.AsString := AItems[I].VWideChar;
    vtPWideChar:
      Result.Add.AsString := AItems[I].VPWideChar;
    vtCurrency:
      Result.Add.AsFloat := AItems[I].VCurrency^;
    vtInt64:
      Result.Add.AsInt64 := AItems[I].VInt64^;
{$IFDEF UNICODE}       // variants
    vtUnicodeString:
      Result.Add.AsString := AItems[I].VPWideChar;
{$ENDIF UNICODE}
    vtVariant:
      Result.Add.AsVariant := AItems[I].VVariant^;
    vtObject:
      begin
      if TObject(AItems[I].VObject) is TQMsgPack then
        Result.Add(TObject(AItems[I].VObject) as TQMsgPack)
      else
        raise Exception.Create(Format(SUnsupportArrayItem, [I]));
      end
  else
    raise Exception.Create(Format(SUnsupportArrayItem, [I]));
  end; // End case
  end; // End for
end;

function TQMsgPack.Add(AName: QStringW; ADataType: TQMsgPackType): TQMsgPack;
begin
Result := Add(AName);
Result.DataType := ADataType;
end;

function TQMsgPack.Add: TQMsgPack;
begin
ArrayNeeded(mptMap);
Result := TQMsgPack.Create;
Result.FParent := Self;
FItems.Add(Result);
end;

function TQMsgPack.Add(AName: QStringW; AValue: Boolean): TQMsgPack;
begin
Result := Add(AName);
Result.AsBoolean := AValue;
end;

function TQMsgPack.Add(AName: QStringW): TQMsgPack;
begin
Result := Add;
Result.FName := AName;
end;

function TQMsgPack.Add(AName: QStringW; const AValue: TBytes): TQMsgPack;
begin
Result := Add(AName);
Result.DataType := mptBinary;
Result.FValue := AValue;
end;

function TQMsgPack.Add(AName, AValue: QStringW): TQMsgPack;
begin
Result := Add(AName);
Result.AsString := AValue;
end;

function TQMsgPack.Add(AName: QStringW; AValue: Double): TQMsgPack;
begin
Result := Add(AName);
Result.AsFloat := AValue;
end;

function TQMsgPack.Add(AName: QStringW; AValue: Int64): TQMsgPack;
begin
Result := Add(AName);
Result.AsInt64 := AValue;
end;

function TQMsgPack.Add(ANode: TQMsgPack): Integer;
begin
ArrayNeeded(mptArray);
Result := FItems.Add(ANode);
end;

function TQMsgPack.AddDateTime(AName: QStringW; AValue: TDateTime): TQMsgPack;
begin
Result := Add(AName);
Result.AsDateTime := AValue;
end;

procedure TQMsgPack.ArrayNeeded(ANewType: TQMsgPackType);
begin
if not(DataType in [mptArray, mptMap]) then
  DataType := ANewType;
end;

procedure TQMsgPack.Assign(ANode: TQMsgPack);
var
  I: Integer;
begin
FName := ANode.FName;
FNameHash := ANode.FNameHash;
if ANode.FDataType in [mptArray, mptMap] then
  begin
  DataType := ANode.FDataType;
  Clear;
  for I := 0 to ANode.Count - 1 do
    Add.Assign(ANode[I])
  end
else
  CopyValue(ANode);
end;

procedure TQMsgPack.Clear;
var
  I: Integer;
begin
if FDataType in [mptArray, mptMap] then
  begin
  for I := 0 to Count - 1 do
    FreeItem(FItems[I]);
  FItems.Clear;
  end;
end;

function TQMsgPack.Clone: TQMsgPack;
begin
Result := Copy;
end;

function TQMsgPack.Copy: TQMsgPack;
begin
Result := CreateItem;
Result.Assign(Self);
end;
{$IFDEF UNICODE}

function TQMsgPack.CopyIf(const ATag: Pointer; AFilter: TQMsgPackFilterEventA)
  : TQMsgPack;
  procedure NestCopy(AParentSource, AParentDest: TQMsgPack);
  var
    I: Integer;
    Accept: Boolean;
    AChildSource, AChildDest: TQMsgPack;
  begin
  for I := 0 to AParentSource.Count - 1 do
    begin
    Accept := True;
    AChildSource := AParentSource[I];
    AFilter(Self, AChildSource, Accept, ATag);
    if Accept then
      begin
      AChildDest := AParentDest.Add(AChildSource.FName, AChildSource.DataType);
      if AChildSource.DataType in [mptArray, mptMap] then
        begin
        AChildDest.DataType := AChildSource.DataType;
        NestCopy(AChildSource, AChildDest)
        end
      else
        AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;

begin
if Assigned(AFilter) then
  begin
  Result := CreateItem;
  Result.FName := Name;
  if DataType in [mptArray, mptMap] then
    begin
    NestCopy(Self, Result);
    end
  else
    Result.CopyValue(Self);
  end
else
  Result := Copy;
end;
{$ENDIF UNICODE}

function TQMsgPack.CopyIf(const ATag: Pointer; AFilter: TQMsgPackFilterEvent)
  : TQMsgPack;
  procedure NestCopy(AParentSource, AParentDest: TQMsgPack);
  var
    I: Integer;
    Accept: Boolean;
    AChildSource, AChildDest: TQMsgPack;
  begin
  for I := 0 to AParentSource.Count - 1 do
    begin
    Accept := True;
    AChildSource := AParentSource[I];
    AFilter(Self, AChildSource, Accept, ATag);
    if Accept then
      begin
      AChildDest := AParentDest.Add(AChildSource.FName, AChildSource.DataType);
      if AChildSource.DataType in [mptArray, mptMap] then
        begin
        AChildDest.DataType := AChildSource.DataType;
        NestCopy(AChildSource, AChildDest)
        end
      else
        AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;

begin
if Assigned(AFilter) then
  begin
  Result := CreateItem;
  Result.FName := Name;
  if DataType in [mptArray, mptMap] then
    begin
    NestCopy(Self, Result);
    end
  else
    Result.CopyValue(Self);
  end
else
  Result := Copy;
end;

procedure TQMsgPack.CopyValue(ASource: TQMsgPack);
var
  l: Integer;
begin
l := Length(ASource.FValue);
DataType := ASource.DataType;
SetLength(FValue, l);
if l > 0 then
  Move(ASource.FValue[0], FValue[0], l shl 1);
end;

function TQMsgPack.Encode: TBytes;
var
  AStream: TMemoryStream;
  AValue: TQMsgPackValue;

  procedure WriteNull;
  begin
  AValue.U8Val := $C0;
  AStream.Write(AValue.U8Val, 1);
  end;

  procedure LE2BE(ASize: Integer);
  var
    I, C: Integer;
    B: Byte;
  begin
  C := ASize shr 1;
  for I := 0 to C - 1 do
    begin
    B := AValue.BArray[I];
    AValue.BArray[I] := AValue.BArray[ASize - I - 1];
    AValue.BArray[ASize - I - 1] := B;
    end;
  end;

  procedure WriteInt(const iVal: Int64);
  begin
  if iVal >= 0 then
    begin
    if iVal <= 127 then
      begin
      AValue.U8Val := Byte(iVal);
      AStream.WriteBuffer(AValue.U8Val, 1);
      end
    else if iVal <= 255 then // UInt8
      begin
      AValue.ValueType := $CC;
      AValue.U8Val := Byte(iVal);
      AStream.WriteBuffer(AValue, 2);
      end
    else if iVal <= 65535 then
      begin
      AValue.ValueType := $CD;
      AValue.BArray[0] := (iVal shr 8);
      AValue.BArray[1] := (iVal and $FF);
      AStream.WriteBuffer(AValue, 3);
      end
    else if iVal <= Cardinal($FFFFFFFF) then
      begin
      AValue.ValueType := $CE;
      AValue.BArray[0] := (iVal shr 24) and $FF;
      AValue.BArray[1] := (iVal shr 16) and $FF;
      AValue.BArray[2] := (iVal shr 8) and $FF;
      AValue.BArray[3] := iVal and $FF;
      AStream.WriteBuffer(AValue, 5);
      end
    else
      begin
      AValue.ValueType := $CF;
      AValue.BArray[0] := (iVal shr 56) and $FF;
      AValue.BArray[1] := (iVal shr 48) and $FF;
      AValue.BArray[2] := (iVal shr 40) and $FF;
      AValue.BArray[3] := (iVal shr 32) and $FF;
      AValue.BArray[4] := (iVal shr 24) and $FF;
      AValue.BArray[5] := (iVal shr 16) and $FF;
      AValue.BArray[6] := (iVal shr 8) and $FF;
      AValue.BArray[7] := iVal and $FF;
      AStream.WriteBuffer(AValue, 9);
      end;
    end
  else // <0
    begin
    if iVal <= -2147483648 then // 64λ
      begin
      AValue.ValueType := $D3;
      AValue.BArray[0] := (iVal shr 56) and $FF;
      AValue.BArray[1] := (iVal shr 48) and $FF;
      AValue.BArray[2] := (iVal shr 40) and $FF;
      AValue.BArray[3] := (iVal shr 32) and $FF;
      AValue.BArray[4] := (iVal shr 24) and $FF;
      AValue.BArray[5] := (iVal shr 16) and $FF;
      AValue.BArray[6] := (iVal shr 8) and $FF;
      AValue.BArray[7] := iVal and $FF;
      AStream.WriteBuffer(AValue, 9);
      end
    else if iVal <= -32768 then
      begin
      AValue.ValueType := $D2;
      AValue.BArray[0] := (iVal shr 24) and $FF;
      AValue.BArray[1] := (iVal shr 16) and $FF;
      AValue.BArray[2] := (iVal shr 8) and $FF;
      AValue.BArray[3] := iVal and $FF;
      AStream.WriteBuffer(AValue, 5);
      end
    else if iVal <= -128 then
      begin
      AValue.ValueType := $D1;
      AValue.BArray[0] := (iVal shr 8);
      AValue.BArray[1] := (iVal and $FF);
      AStream.WriteBuffer(AValue, 3);
      end
    else if iVal < -32 then
      begin
      AValue.ValueType := $D0;
      AValue.I8Val := iVal;
      AStream.WriteBuffer(AValue, 2);
      end
    else
      begin
      AValue.I8Val := iVal;
      AStream.Write(AValue.I8Val, 1);
      end;
    end; // End <0
  end;

  procedure WriteFloat(fVal: Extended);
  begin
  AValue.F64Val := fVal;
  LE2BE(SizeOf(Double));
  AValue.ValueType := $CB;
  AStream.WriteBuffer(AValue, 9);
  end;
  procedure WriteSingle(fVal: Extended);
  begin
  AValue.F32Val := fVal;
  LE2BE(SizeOf(Single));
  AValue.ValueType := $CA;
  AStream.WriteBuffer(AValue, 5);
  end;
  procedure WriteString(const s: QStringW);
  var
    U: QStringA;
    l: Integer;
  begin
  U := qstring.Utf8Encode(s);
  l := U.Length;
  if l <= 31 then
    begin
    AValue.ValueType := $A0 + Byte(l);
    AStream.WriteBuffer(AValue.ValueType, 1);
    end
  else if l <= 255 then
    begin
    AValue.ValueType := $D9;
    AValue.U8Val := Byte(l);
    AStream.WriteBuffer(AValue, 2);
    end
  else if l <= 65535 then
    begin
    AValue.ValueType := $DA;
    AValue.U16Val := ((l shr 8) and $FF) or ((l shl 8) and $FF00);
    AStream.Write(AValue, 3);
    end
  else
    begin
    AValue.ValueType := $DB;
    AValue.BArray[0] := (l shr 24) and $FF;
    AValue.BArray[1] := (l shr 16) and $FF;
    AValue.BArray[2] := (l shr 8) and $FF;
    AValue.BArray[3] := l and $FF;
    AStream.WriteBuffer(AValue, 5);
    end;
  AStream.WriteBuffer(PQCharA(U)^, l);
  end;

  procedure WriteBinary(p: PByte; l: Integer);
  begin
  if l <= 255 then
    begin
    AValue.ValueType := $C4;
    AValue.U8Val := Byte(l);
    AStream.WriteBuffer(AValue, 2);
    end
  else if l <= 65535 then
    begin
    AValue.ValueType := $C5;
    AValue.BArray[0] := (l shr 8) and $FF;
    AValue.BArray[1] := l and $FF;
    AStream.WriteBuffer(AValue, 3);
    end
  else
    begin
    AValue.ValueType := $C6;
    AValue.BArray[0] := (l shr 24) and $FF;
    AValue.BArray[1] := (l shr 16) and $FF;
    AValue.BArray[2] := (l shr 8) and $FF;
    AValue.BArray[3] := l and $FF;
    AStream.WriteBuffer(AValue, 5);
    end;
  AStream.WriteBuffer(p^, l);
  end;

  procedure InternalEncode(ANode: TQMsgPack; AStream: TMemoryStream);
  var
    I, ANewSize, C: Integer;
    AChild: TQMsgPack;
  begin
  if AStream.Position = AStream.Size then
    begin
    ANewSize := 0;
    while AStream.Position + ANewSize <= AStream.Size do // Try+16K
      Inc(ANewSize, 16384);
    AStream.Size := AStream.Size + ANewSize;
    end;
  case ANode.DataType of
    mptUnknown, mptNull:
      WriteNull;
    mptInteger:
      WriteInt(ANode.AsInt64);
    mptBoolean:
      begin
      if ANode.AsBoolean then
        AValue.U8Val := $C3
      else
        AValue.U8Val := $C2;
      AStream.WriteBuffer(AValue.U8Val, 1);
      end;
    mptDateTime, mptFloat:
      WriteFloat(ANode.AsFloat);
    mptSingle:
      WriteSingle(ANode.AsSingle);
    mptString:
      WriteString(ANode.AsString);
    mptBinary:
      WriteBinary(@ANode.FValue[0], Length(ANode.FValue));
    mptArray:
      begin
      C := ANode.Count;
      if C <= 15 then
        begin
        AValue.ValueType := $90 + C;
        AStream.WriteBuffer(AValue.ValueType, 1);
        end
      else if C <= 65535 then
        begin
        AValue.ValueType := $DC;
        AValue.BArray[0] := (C shr 8) and $FF;
        AValue.BArray[1] := C and $FF;
        AStream.WriteBuffer(AValue, 3);
        end
      else
        begin
        AValue.ValueType := $DD;
        AValue.BArray[0] := (C shr 24) and $FF;
        AValue.BArray[1] := (C shr 16) and $FF;
        AValue.BArray[2] := (C shr 8) and $FF;
        AValue.BArray[3] := C and $FF;
        AStream.WriteBuffer(AValue, 5);
        end;
      for I := 0 to C - 1 do
        InternalEncode(ANode[I], AStream);
      end;
    mptMap:
      begin
      C := ANode.Count;
      if C <= 15 then
        begin
        AValue.ValueType := $80 + C;
        AStream.WriteBuffer(AValue.ValueType, 1);
        end
      else if C <= 65535 then
        begin
        AValue.ValueType := $DE;
        AValue.BArray[0] := (C shr 8) and $FF;
        AValue.BArray[1] := C and $FF;
        AStream.WriteBuffer(AValue, 3);
        end
      else
        begin
        AValue.ValueType := $DF;
        AValue.BArray[0] := (C shr 24) and $FF;
        AValue.BArray[1] := (C shr 16) and $FF;
        AValue.BArray[2] := (C shr 8) and $FF;
        AValue.BArray[3] := C and $FF;
        AStream.WriteBuffer(AValue, 5);
        end;
      for I := 0 to C - 1 do
        begin
        AChild := ANode[I];
        WriteString(AChild.FName);
        InternalEncode(AChild, AStream);
        end;
      end;
    mptExtended:
      begin
      C := Length(ANode.FValue);
      if C = 1 then
        begin
        AValue.ValueType := $D4;
        AValue.BArray[0] := ANode.FExtType;
        AValue.BArray[1] := ANode.FValue[0];
        AStream.WriteBuffer(AValue, 3);
        end
      else if C = 2 then
        begin
        AValue.ValueType := $D5;
        AValue.BArray[0] := ANode.FExtType;
        AValue.BArray[1] := ANode.FValue[0];
        AValue.BArray[2] := ANode.FValue[1];
        AStream.WriteBuffer(AValue, 4);
        end
      else if C = 4 then
        begin
        AValue.ValueType := $D6;
        AValue.BArray[0] := ANode.FExtType;
        PInteger(@AValue.BArray[1])^ := PInteger(@ANode.FValue[0])^;
        AStream.WriteBuffer(AValue, 6);
        end
      else if C = 8 then
        begin
        AValue.ValueType := $D7;
        AValue.BArray[0] := ANode.FExtType;
        PInt64(@AValue.BArray[1])^ := PInt64(@ANode.FValue[0])^;
        AStream.WriteBuffer(AValue, 10);
        end
      else if C = 16 then
        begin
        AValue.ValueType := $D8;
        AValue.BArray[0] := ANode.FExtType;
        PInt64(@AValue.BArray[1])^ := PInt64(@ANode.FValue[0])^;
        PInt64(@AValue.BArray[9])^ := PInt64(@ANode.FValue[8])^;
        AStream.WriteBuffer(AValue, 18);
        end
      else if C <= 255 then
        begin
        AValue.ValueType := $C7;
        AValue.BArray[0] := Byte(C);
        AValue.BArray[1] := ANode.FExtType;
        AStream.WriteBuffer(AValue, 3);
        AStream.WriteBuffer(ANode.FValue[0], C);
        end
      else if C <= 65535 then
        begin
        AValue.ValueType := $C8;
        AValue.BArray[0] := (C shr 8) and $FF;
        AValue.BArray[1] := (C and $FF);
        AValue.BArray[2] := ANode.FExtType;
        AStream.WriteBuffer(AValue, 4);
        AStream.WriteBuffer(ANode.FValue[0], C);
        end
      else
        begin
        AValue.ValueType := $C8;
        AValue.BArray[0] := (C shr 24) and $FF;
        AValue.BArray[1] := (C shr 16) and $FF;
        AValue.BArray[2] := (C shr 8) and $FF;
        AValue.BArray[3] := (C and $FF);
        AValue.BArray[4] := ANode.FExtType;
        AStream.WriteBuffer(AValue, 4);
        end;
      end;
  end;
  end;

begin
AStream := TMemoryStream.Create;
AStream.Size := 16384;
try
  InternalEncode(Self, AStream);
  SetLength(Result, AStream.Position);
  Move(PByte(AStream.Memory)^, Result[0], AStream.Position);
finally
  FreeObject(AStream);
end;
end;

function TQMsgPack.FindIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQMsgPackFilterEvent): TQMsgPack;
  function DoFind(AParent: TQMsgPack): TQMsgPack;
  var
    I: Integer;
    AChild: TQMsgPack;
    Accept: Boolean;
  begin
  Result := nil;
  for I := 0 to AParent.Count - 1 do
    begin
    AChild := AParent[I];
    Accept := True;
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      Result := AChild
    else if ANest then
      Result := DoFind(AChild);
    if Result <> nil then
      Break;
    end;
  end;

begin
if Assigned(AFilter) then
  Result := DoFind(Self)
else
  Result := nil;
end;
{$IFDEF UNICODE}

function TQMsgPack.FindIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQMsgPackFilterEventA): TQMsgPack;
  function DoFind(AParent: TQMsgPack): TQMsgPack;
  var
    I: Integer;
    AChild: TQMsgPack;
    Accept: Boolean;
  begin
  Result := nil;
  for I := 0 to AParent.Count - 1 do
    begin
    AChild := AParent[I];
    Accept := True;
    AFilter(Self, AChild, Accept, ATag);
    if Accept then
      Result := AChild
    else if ANest then
      Result := DoFind(AChild);
    if Result <> nil then
      Break;
    end;
  end;

begin
if Assigned(AFilter) then
  Result := DoFind(Self)
else
  Result := nil;
end;
{$ENDIF UNICODE}

function TQMsgPack.ForcePath(APath: QStringW): TQMsgPack;
var
  AName: QStringW;
  p, pn, ws: PQCharW;
  AParent: TQMsgPack;
  l: Integer;
  AIndex: Int64;
const
  PathDelimiters: PWideChar = './\';
begin
p := PQCharW(APath);
AParent := Self;
Result := Self;
while p^ <> #0 do
  begin
  AName := DecodeTokenW(p, PathDelimiters, WideChar(0), True);
  if not(AParent.DataType in [mptArray, mptMap]) then
    AParent.DataType := mptMap;
  Result := AParent.ItemByName(AName);
  if not Assigned(Result) then
    begin
    pn := PQCharW(AName);
    l := Length(AName);
    AIndex := -1;
    if (pn[l - 1] = ']') then
      begin
      repeat
        if pn[l] = '[' then
          begin
          ws := pn + l + 1;
          ParseInt(ws, AIndex);
          Break;
          end
        else
          Dec(l);
      until l = 0;
      if l > 0 then
        begin
        AName := StrDupX(pn, l);
        Result := AParent.ItemByName(AName);
        if Result = nil then
          Result := AParent.Add(AName, mptArray)
        else if Result.DataType <> mptArray then
          raise Exception.CreateFmt(SBadMsgPackArray, [AName]);
        if AIndex >= 0 then
          begin
          while Result.Count <= AIndex do
            Result.Add;
          Result := Result[AIndex];
          end;
        end
      else
        raise Exception.CreateFmt(SBadMsgPackName, [AName]);
      end
    else
      Result := AParent.Add(AName);
    end;
  AParent := Result;
  end;
end;

procedure TQMsgPack.FreeItem(AItem: TQMsgPack);
begin
if Assigned(OnQMsgPackFree) then
  OnQMsgPackFree(AItem)
else
  FreeObject(AItem);
end;

{$IFDEF UNICODE}

procedure TQMsgPack.FromRecord<T>(const ARecord: T);
begin
FromRtti(@ARecord, TypeInfo(T));
end;

procedure TQMsgPack.FromRtti(ASource: Pointer; AType: PTypeInfo);
var
  AValue: TValue;
  procedure AddCollection(AParent: TQMsgPack; ACollection: TCollection);
  var
    J: Integer;
  begin
  for J := 0 to ACollection.Count - 1 do
    AParent.Add.FromRtti(ACollection.Items[J]);
  end;

  procedure AddRecord;
  var
    AContext: TRttiContext;
    AFields: TArray<TRttiField>;
    ARttiType: TRttiType;
    I, J: Integer;
    AObj: TObject;
  begin
  AContext := TRttiContext.Create;
  ARttiType := AContext.GetType(AType);
  AFields := ARttiType.GetFields;
  for J := Low(AFields) to High(AFields) do
    begin
    if AFields[J].FieldType <> nil then
      begin
      // ����Ǵӽṹ�壬���¼���Ա������Ƕ�����ֻ��¼�乫�������ԣ����⴦��TStrings��TCollection
      case AFields[J].FieldType.TypeKind of
        tkInteger:
          Add(AFields[J].Name).AsInteger := AFields[J].GetValue(ASource)
            .AsInteger;
{$IFNDEF NEXTGEN}tkString, tkLString, tkWString,
        {$ENDIF !NEXTGEN}tkUString:
          Add(AFields[J].Name).AsString := AFields[J].GetValue(ASource)
            .AsString;
        tkEnumeration:
          begin
          if GetTypeData(AFields[J].FieldType.Handle)
            .BaseType^ = TypeInfo(Boolean) then
            Add(AFields[J].Name).AsBoolean := AFields[J].GetValue(ASource)
              .AsBoolean
          else
            Add(AFields[J].Name).AsString :=
              AFields[J].GetValue(ASource).ToString;
          end;
        tkChar, tkWChar, tkSet:
          Add(AFields[J].Name).AsString := AFields[J].GetValue(ASource)
            .ToString;
        tkFloat:
          begin
          if (AFields[J].FieldType.Handle = TypeInfo(TDateTime)) or
            (AFields[J].FieldType.Handle = TypeInfo(TTime)) or
            (AFields[J].FieldType.Handle = TypeInfo(TDate)) then
            Add(AFields[J].Name).AsDateTime := AFields[J].GetValue(ASource)
              .AsExtended
          else
            Add(AFields[J].Name).AsFloat := AFields[J].GetValue(ASource)
              .AsExtended;
          end;
        tkInt64:
          Add(AFields[J].Name).AsInt64 := AFields[J].GetValue(ASource).AsInt64;
        tkVariant:
          Add(AFields[J].Name).AsVariant := AFields[J].GetValue(ASource)
            .AsVariant;
        tkArray, tkDynArray:
          begin
          with Add(AFields[J].Name, mptArray) do
            begin
            AValue := AFields[J].GetValue(ASource);
            for I := 0 to AValue.GetArrayLength - 1 do
              Add.FromRtti(AValue.GetArrayElement(I));
            end;
          end;
        tkClass:
          begin
          AValue := AFields[J].GetValue(ASource);
          AObj := AValue.AsObject;
          if (AObj is TStrings) then
            Add(AFields[J].Name).AsString := TStrings(AObj).Text
          else if AObj is TCollection then
            AddCollection(Add(AFields[J].Name, mptArray), AObj as TCollection)
          else // �������͵Ķ��󲻱���
            Add(AFields[J].Name).FromRtti(AObj, AFields[J].FieldType.Handle);
          end;
        tkRecord:
          begin
          DataType := mptMap;
          AValue := AFields[J].GetValue(ASource);
          Add(AFields[J].Name)
            .FromRtti(Pointer(IntPtr(ASource) + AFields[J].Offset),
            AFields[J].FieldType.Handle);
          end;
      end;
      end
    else
      raise Exception.CreateFmt(SMissRttiTypeDefine, [AFields[J].Name]);
    end;
  end;

  procedure AddObject;
  var
    APropList: PPropList;
    ACount: Integer;
    J: Integer;
    AObj, AChildObj: TObject;
    AName: String;
  begin
  AObj := ASource;
  if AObj is TStrings then
    AsString := (AObj as TStrings).Text
  else if AObj is TCollection then
    AddCollection(Self, AObj as TCollection)
  else
    begin
    ACount := GetPropList(AType, APropList);
    for J := 0 to ACount - 1 do
      begin
      if not IsDefaultPropertyValue(AObj, APropList[J], nil) then
        begin
{$IF RTLVersion>25}
        AName := APropList[J].NameFld.ToString;
{$ELSE}
        AName := String(APropList[J].Name);
{$IFEND}
        case APropList[J].PropType^.Kind of
          tkClass:
            begin
            AChildObj := Pointer(GetOrdProp(AObj, APropList[J]));
            if AChildObj is TStrings then
              Add(AName).AsString := (AChildObj as TStrings).Text
            else if AChildObj is TCollection then
              AddCollection(Add(AName), AChildObj as TCollection)
            else
              Add(AName).FromRtti(AChildObj);
            end;
          tkRecord, tkArray, tkDynArray: // ��¼�����顢��̬��������ϵͳҲ�����棬Ҳû�ṩ����̫�õĽӿ�
            raise Exception.Create(SUnsupportPropertyType);
          tkInteger:
            Add(AName).AsInt64 := GetOrdProp(AObj, APropList[J]);
          tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
            Add(AName).AsString := GetStrProp(AObj, APropList[J]);
          tkEnumeration:
            begin
            if GetTypeData(APropList[J]^.PropType^)^.BaseType^ = TypeInfo
              (Boolean) then
              Add(AName).AsBoolean := GetOrdProp(AObj, APropList[J]) <> 0
            else
              Add(AName).AsString := GetEnumProp(AObj, APropList[J]);
            end;
          tkSet:
            Add(AName).AsString := GetSetProp(AObj, APropList[J], True);
          tkVariant:
            Add(AName).AsVariant := GetPropValue(AObj, APropList[J]);
          tkInt64:
            Add(AName).AsInt64 := GetInt64Prop(AObj, APropList[J]);
        end;
        end;
      end;
    end;
  end;
  procedure AddArray;
  var
    I, C: Integer;
  begin
  DataType := mptArray;
  Clear;
  TValue.Make(ASource, AType, AValue);
  C := AValue.GetArrayLength;
  for I := 0 to C - 1 do
    Add.FromRtti(AValue.GetArrayElement(I));
  end;

begin
if ASource = nil then
  Exit;
case AType.Kind of
  tkRecord:
    AddRecord;
  tkClass:
    AddObject;
  tkDynArray:
    AddArray;
end;
end;

procedure TQMsgPack.FromRtti(AInstance: TValue);
var
  I, C: Integer;
begin
case AInstance.Kind of
  tkClass:
    FromRtti(AInstance.AsObject, AInstance.TypeInfo);
  tkRecord:
    FromRtti(AInstance.GetReferenceToRawData, AInstance.TypeInfo);
  tkArray, tkDynArray:
    begin
    DataType := mptArray;
    Clear;
    C := AInstance.GetArrayLength;
    for I := 0 to C - 1 do
      Add.FromRtti(AInstance.GetArrayElement(I));
    end;
  tkInteger:
    AsInt64 := AInstance.AsInt64;
  tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
    AsString := AInstance.ToString;
  tkEnumeration:
    begin
    if GetTypeData(AInstance.TypeInfo)^.BaseType^ = TypeInfo(Boolean) then
      AsBoolean := AInstance.AsBoolean
    else
      AsString := AInstance.ToString;
    end;
  tkSet:
    AsString := AInstance.ToString;
  tkVariant:
    AsVariant := AInstance.AsVariant;
  tkInt64:
    AsInt64 := AInstance.AsInt64;
end;
end;
{$ENDIF UNICODE}

procedure TQMsgPack.BytesFromFile(AFileName: QStringW);
var
  AStream: TMemoryStream;
begin
AStream := TMemoryStream.Create;
try
  AStream.LoadFromFile(AFileName);
  BytesFromStream(AStream, 0);
finally
  FreeObject(AStream);
end;
end;

procedure TQMsgPack.BytesFromStream(AStream: TStream; ACount: Integer);
begin
DataType := mptBinary;
if ACount = 0 then
  begin
  ACount := AStream.Size;
  AStream.Position := 0;
  end
else
  begin
  if AStream.Size - AStream.Position < ACount then
    ACount := AStream.Size - AStream.Position;
  end;
SetLength(FValue, ACount);
AStream.ReadBuffer(FValue[0], ACount);
end;

procedure TQMsgPack.BytesToFile(AFileName: QStringW);
var
  AStream: TMemoryStream;
begin
AStream := TMemoryStream.Create;
try
  BytesToStream(AStream);
finally
  FreeObject(AStream);
end;
end;

procedure TQMsgPack.BytesToStream(AStream: TStream);
begin
AStream.WriteBuffer(FValue[0], Length(FValue));
end;

function TQMsgPack.GetAsBoolean: Boolean;
begin
if DataType = mptBoolean then
  Result := PBoolean(FValue)^
else if DataType = mptString then
  begin
  if not TryStrToBool(AsString, Result) then
    raise Exception.Create(Format(SBadConvert, [AsString, 'Boolean']));
  end
else if DataType in [mptFloat, mptDateTime] then
  Result := not SameValue(AsFloat, 0)
else if DataType = mptSingle then
  Result := not SameValue(AsSingle, 0)
else if DataType = mptInteger then
  Result := AsInt64 <> 0
else if DataType in [mptNull, mptUnknown] then
  Result := False
else
  raise Exception.Create(Format(SBadConvert,
    [MsgPackTypeName[Integer(DataType)], 'Boolean']));
end;

function TQMsgPack.GetAsBytes: TBytes;
begin
Result := FValue;
end;

function TQMsgPack.GetAsDateTime: TDateTime;
begin
if DataType in [mptDateTime, mptFloat] then
  Result := PDouble(FValue)^
else if DataType = mptSingle then
  Result := PSingle(FValue)^
else if DataType = mptString then
  begin
  if not(ParseDateTime(PWideChar(FValue), Result) or
    ParseWebTime(PQCharW(FValue), Result)) then
    raise Exception.Create(Format(SBadConvert,
      [MsgPackTypeName[Integer(DataType)], 'DateTime']))
  end
else if DataType in [mptInteger, mptNull, mptUnknown] then
  Result := AsInt64
else
  raise Exception.Create(Format(SBadConvert,
    [MsgPackTypeName[Integer(DataType)], 'DateTime']));
end;

function TQMsgPack.GetAsExtBytes: TBytes;
begin
if DataType = mptExtended then
  Result := FValue
else
  SetLength(Result, 0);
end;

function TQMsgPack.GetAsFloat: Double;
begin
if DataType in [mptFloat, mptDateTime] then
  Result := PDouble(FValue)^
else if DataType = mptSingle then
  Result := PSingle(FValue)^
else if DataType = mptBoolean then
  Result := Integer(AsBoolean)
else if DataType = mptString then
  begin
  if not TryStrToFloat(AsString, Result) then
    raise Exception.Create(Format(SBadConvert, [AsString, 'Numeric']));
  end
else if DataType = mptInteger then
  Result := AsInt64
else if DataType in [mptNull, mptUnknown] then
  Result := 0
else
  raise Exception.Create(Format(SBadConvert,
    [MsgPackTypeName[Integer(DataType)], 'Numeric']))
end;

function TQMsgPack.GetAsInt64: Int64;
begin
if DataType = mptInteger then
  Result := PInt64(FValue)^
else if DataType in [mptFloat, mptDateTime] then
  Result := Trunc(PDouble(FValue)^)
else if DataType = mptSingle then
  Result := Trunc(PSingle(FValue)^)
else if DataType = mptBoolean then
  Result := Integer(AsBoolean)
else if DataType = mptString then
  Result := Trunc(AsFloat)
else if DataType in [mptNull, mptUnknown] then
  Result := 0
else
  raise Exception.Create(Format(SBadConvert,
    [MsgPackTypeName[Integer(DataType)], 'Numeric']))
end;

function TQMsgPack.GetAsInteger: Integer;
begin
Result := AsInt64;
end;

function TQMsgPack.GetAsMsgPack: TBytes;
begin
Result := Encode;
end;

function TQMsgPack.GetAsSingle: Single;
begin
if DataType = mptSingle then
  Result := PSingle(FValue)^
else if DataType in [mptFloat, mptDateTime] then
  Result := PDouble(FValue)^
else if DataType = mptBoolean then
  Result := Integer(AsBoolean)
else if DataType = mptString then
  begin
  if not TryStrToFloat(AsString, Result) then
    raise Exception.Create(Format(SBadConvert, [AsString, 'Numeric']));
  end
else if DataType = mptInteger then
  Result := AsInt64
else if DataType in [mptNull, mptUnknown] then
  Result := 0
else
  raise Exception.Create(Format(SBadConvert,
    [MsgPackTypeName[Integer(DataType)], 'Numeric']))
end;

function TQMsgPack.GetAsString: QStringW;
  function EncodeDateTime: QStringW;
  var
    AValue: TDateTime;
  begin
  AValue := AsDateTime;
  if SameValue(AValue - Trunc(AValue), 0) then // Date
    Result := FormatDateTime(MsgPackDateFormat, AValue)
  else
    begin
    if Trunc(AValue) = 0 then
      Result := FormatDateTime(MsgPackTimeFormat, AValue)
    else
      Result := FormatDateTime(MsgPackDateTimeFormat, AValue);
    end;
  end;
  function EncodeArray: QStringW;
  const
    ArrayStart: PWideChar = '[';
    ArrayEnd: PWideChar = ']';
    ArrayDelim: PWideChar = ',';
  var
    I: Integer;
    ABuilder: TQStringCatHelperW;
  begin
  ABuilder := TQStringCatHelperW.Create;
  try
    ABuilder.Cat(ArrayStart, 1);
    if Count > 0 then
      begin
      for I := 0 to Count - 1 do
        ABuilder.Cat(Items[I].AsString).Cat(ArrayDelim, 1);
      ABuilder.Back(1);
      end;
    ABuilder.Cat(ArrayEnd, 1);
    Result := ABuilder.Value;
  finally
    FreeObject(ABuilder);
  end;
  end;
  function EncodeMap: QStringW;
  const
    MapStart: PWideChar = '{';
    MapEnd: PWideChar = '}';
    MapDelim: PWideChar = ',';
    MapValueDelim: PWideChar = ':';
    MapEmptyName: PWideChar = '""';
    MapStrStart: PWideChar = '"';
  var
    I: Integer;
    ABuilder: TQStringCatHelperW;
    AItem: TQMsgPack;
  begin
  ABuilder := TQStringCatHelperW.Create;
  try
    ABuilder.Cat(MapStart, 1);
    if Count > 0 then
      begin
      for I := 0 to Count - 1 do
        begin
        AItem := Items[I];
        if Length(AItem.Name) > 0 then
          ABuilder.Cat(QuotedStrW(AItem.Name, '"')).Cat(MapValueDelim, 1)
        else
          ABuilder.Cat(MapEmptyName).Cat(MapValueDelim, 1);
        case AItem.DataType of
          mptString, mptBinary, mptDateTime:
            ABuilder.Cat(QuotedStrW(AItem.AsString, '"'))
        else
          ABuilder.Cat(AItem.AsString);
        end;
        ABuilder.Cat(MapDelim, 1);
        end;
      ABuilder.Back(1);
      end;
    ABuilder.Cat(MapEnd, 1);
    Result := ABuilder.Value;
  finally
    FreeObject(ABuilder);
  end;
  end;
  function EncodeExtended: QStringW;
  begin
  Result := '{TypeId:' + IntToStr(FExtType) + ',Data:' +
    qstring.BinToHex(@FValue[0], Length(FValue));
  end;

begin
if DataType = mptString then
  begin
  SetLength(Result, Length(FValue) shr 1);
  Move(FValue[0], PQCharW(Result)^, Length(FValue));
  end
else
  begin
  case DataType of
    mptUnknown, mptNull:
      Result := 'null';
    mptInteger:
      Result := IntToStr(AsInt64);
    mptBoolean:
      Result := BoolToStr(AsBoolean, True);
    mptFloat:
      Result := FloatToStrF(AsFloat, ffGeneral, 15, 0);
    mptSingle:
      Result := FloatToStrF(AsSingle, ffGeneral, 7, 0);
    mptBinary:
      Result := qstring.BinToHex(@FValue[0], Length(FValue));
    mptDateTime:
      Result := EncodeDateTime;
    mptArray:
      Result := EncodeArray;
    mptMap:
      Result := EncodeMap;
    mptExtended:
      Result := EncodeExtended;
  end;
  end;
end;

function TQMsgPack.GetAsVariant: Variant;
var
  I: Integer;
  procedure BytesAsVariant;
  var
    J:Integer;
  begin
  I:=Length(FValue);
  Result:=VarArrayCreate([0,I-1],varByte);
  I:=VarArrayHighBound(Result,1);
  for J := 0 to I do
    Result[J]:=FValue[J];
  end;
begin
case DataType of
  mptString:
    Result := AsString;
  mptInteger:
    Result := AsInt64;
  mptFloat:
    Result := AsFloat;
  mptSingle:
    Result := AsSingle;
  mptDateTime:
    Result := AsDateTime;
  mptBoolean:
    Result := AsBoolean;
  mptArray, mptMap:
    begin
    Result := VarArrayCreate([0, Count - 1], varVariant);
    for I := 0 to Count - 1 do
      Result[I] := Items[I].AsVariant;
    end;
  mptBinary:
    BytesAsVariant;
  mptExtended:
    raise Exception.Create(SVariantNotSupport)
else
  VarClear(Result);
end;
end;

function TQMsgPack.GetCount: Integer;
begin
if DataType in [mptArray, mptMap] then
  Result := FItems.Count
else
  Result := 0;
end;

function TQMsgPack.GetEnumerator: TQMsgPackEnumerator;
begin
Result := TQMsgPackEnumerator.Create(Self);
end;

function TQMsgPack.GetIsArray: Boolean;
begin
Result := (DataType = mptArray);
end;

function TQMsgPack.GetIsDateTime: Boolean;
var
  ATime: TDateTime;
begin
Result := (DataType = mptDateTime);
if not Result then
  begin
  if DataType = mptString then
    Result := ParseDateTime(PQCharW(FValue), ATime) or
      ParseWebTime(PQCharW(FValue), ATime)
  end;
end;

function TQMsgPack.GetIsNull: Boolean;
begin
Result := (DataType = mptNull);
end;

function TQMsgPack.GetIsNumeric: Boolean;
var
  ANum: Extended;
  s: QStringW;
  p: PWideChar;
begin
Result := (DataType in [mptInteger, mptSingle, mptFloat]);
if DataType = mptString then
  begin
  s := AsString;
  p := PWideChar(s);
  if ParseNumeric(p, ANum) then
    begin
    SkipSpaceW(p);
    Result := (p^ = #0);
    end;
  end;
end;

function TQMsgPack.GetIsObject: Boolean;
begin
Result := (DataType = mptMap);
end;

function TQMsgPack.GetIsString: Boolean;
begin
Result := (DataType = mptString);
end;

function TQMsgPack.GetItemIndex: Integer;
var
  I: Integer;
begin
Result := -1;
if Assigned(Parent) then
  begin
  for I := 0 to Parent.Count - 1 do
    begin
    if Parent.Items[I] = Self then
      begin
      Result := I;
      Break;
      end;
    end;
  end;
end;

function TQMsgPack.GetItems(AIndex: Integer): TQMsgPack;
begin
Result := FItems[AIndex];
end;

function TQMsgPack.GetPath: QStringW;
var
  AParent, AItem: TQMsgPack;
begin
AParent := FParent;
AItem := Self;
repeat
  if Assigned(AParent) and AParent.IsArray then
    Result := '[' + IntToStr(AItem.ItemIndex) + ']' + Result
  else if AItem.IsArray then
    Result := QMsgPackPathDelimiter + AItem.FName + Result
  else
    Result := QMsgPackPathDelimiter + AItem.FName + Result;
  AItem := AParent;
  AParent := AItem.Parent;
until AParent = nil;
if Length(Result) > 0 then
  Result := StrDupX(PQCharW(Result) + 1, Length(Result) - 1);
end;

function TQMsgPack.GetValue: QStringW;
begin
Result := AsString;
end;

function TQMsgPack.IndexOf(const AName: QStringW): Integer;
var
  I, l: Integer;
  AItem: TQMsgPack;
  AHash: Cardinal;
begin
Result := -1;
l := Length(AName);
if l > 0 then
  AHash := HashOf(PQCharW(AName), l shl 1)
else
  AHash := 0;
for I := 0 to Count - 1 do
  begin
  AItem := Items[I];
  if Length(AItem.FName) = l then
    begin
    if MsgPackCaseSensitive then
      begin
      if AItem.FNameHash = 0 then
        AItem.FNameHash := HashOf(PQCharW(AItem.FName), l shl 1);
      if AItem.FNameHash = AHash then
        begin
        if AItem.FName = AName then
          begin
          Result := I;
          Break;
          end;
        end;
      end
    else if StartWithW(PQCharW(AItem.FName), PQCharW(AName), True) then
      begin
      Result := I;
      Break;
      end;
    end;
  end;
end;

procedure TQMsgPack.InternalParse(var p: PByte; l: Integer);
var
  ps: PByte;
  AExtType: Byte;
  I: Integer;
  ACount: Cardinal;

  function mtoh16(var p: PByte): Word; inline;
  begin
  Result := (p^ shl 8);
  Inc(p);
  Inc(Result, p^);
  Inc(p);
  end;

  function mtoh32(var p: PByte): Cardinal; inline;
  var
    T: PQD2007Byte;
  begin
  T := PQD2007Byte(p);
  Result := (T.Bytes[0] shl 24) or (T.Bytes[1] shl 16) or (T.Bytes[2] shl 8) or
    T.Bytes[3];
  Inc(p, 4);
  end;
  function mtof32(var p: PByte): Single; inline;
  var
    T: Cardinal;
  begin
  T := mtoh32(p);
  Result := PSingle(@T)^;
  end;
  function mtoh64(var p: PByte): UInt64; inline;
  var
    T: PQD2007Byte;
  begin
  T := PQD2007Byte(p);
  Result := (UInt64(T.Bytes[0]) shl 56) or (UInt64(T.Bytes[1]) shl 48) or
    (UInt64(T.Bytes[2]) shl 40) or (UInt64(T.Bytes[3]) shl 32) or
    (T.Bytes[4] shl 24) or (T.Bytes[5] shl 16) or (T.Bytes[6] shl 8) or
    T.Bytes[7];
  Inc(p, 8);
  end;
  function mtof64(var p: PByte): Single; inline;
  var
    T: Int64;
  begin
  T := mtoh64(p);
  Result := PDouble(@T)^;
  end;

begin
ps := p;

while IntPtr(p) - IntPtr(ps) < l do
  begin
  if p^ in [$0 .. $7F] then // 0-127������
    begin
    AsInteger := p^;
    Inc(p);
    Break;
    end
  else if p^ in [$80 .. $8F] then // ��ӳ�䣬���15��
    begin
    DataType := mptMap;
    FItems.Capacity := p^ - $80; // ����
    ACount := FItems.Capacity;
    Inc(p);
    for I := 0 to ACount - 1 do
      begin
      with Add do
        begin
        // ����
        InternalParse(p, l - (Integer(p) - Integer(ps)));
        FName := AsString;
        // ����ֵ
        InternalParse(p, l - (Integer(p) - Integer(ps)));
        end;
      end;
    Break;
    end
  else if p^ in [$90 .. $9F] then // �����飬���15��
    begin
    DataType := mptArray;
    FItems.Capacity := p^ - $90;
    ACount := FItems.Capacity;
    Inc(p);
    for I := 0 to ACount - 1 do
      Add.InternalParse(p, l - (Integer(p) - Integer(ps)));
    Break;
    end
  else if p^ in [$A0 .. $BF] then // ���ַ��������31���ֽ�
    begin
    DataType := mptString;
    ACount := p^ - $A0;
    Inc(p);
    if ACount > 0 then
      begin
      AsString := qstring.Utf8Decode(PQCharA(p), ACount);
      Inc(p, ACount);
      end
    else
      AsString := '';
    Break;
    end
  else if p^ in [$E0 .. $FF] then
    begin
    AsInt64 := Shortint(p^);
    Break;
    end
  else
    begin
    case p^ of
      $C0: // nil/null
        begin
        DataType := mptNull;
        Inc(p);
        end;
      $C1: // ����
        raise Exception.Create('����������');
      $C2: // False
        begin
        AsBoolean := False;
        Inc(p);
        end;
      $C3: // True
        begin
        AsBoolean := True;
        Inc(p);
        end;
      $C4: // �̶����ƣ��255�ֽ�
        begin
        Inc(p);
        DataType := mptBinary;
        ACount := p^;
        SetLength(FValue, ACount);
        Inc(p);
        Move(p^, FValue[0], ACount);
        Inc(p, ACount);
        end;
      $C5: // �����ƣ�16λ���65535B
        begin
        Inc(p);
        DataType := mptBinary;
        ACount := mtoh16(p);
        SetLength(FValue, ACount);
        Move(p^, FValue[0], ACount);
        Inc(p, ACount);
        end;
      $C6: // �����ƣ�32λ���2^32-1
        begin
        Inc(p);
        DataType := mptBinary;
        ACount := mtoh32(p);
        SetLength(FValue, ACount);
        Inc(p, 4);
        Move(p^, FValue[0], ACount);
        Inc(p, ACount);
        end;
      $C7: // Ext8
        begin
        Inc(p);
        DataType := mptExtended;
        ACount := p^;
        SetLength(FValue, ACount);
        Inc(p);
        FExtType := p^;
        Inc(p);
        Move(p^, FValue[0], ACount);
        Inc(p, ACount);
        end;
      $C8: // Ext16
        begin
        Inc(p);
        DataType := mptExtended;
        ACount := mtoh16(p);
        SetLength(FValue, ACount);
        FExtType := p^;
        Inc(p);
        Move(p^, FValue[0], ACount);
        Inc(p, ACount);
        end;
      $C9: // Ext32,4B
        begin
        Inc(p);
        DataType := mptExtended;
        ACount := mtoh32(p);
        SetLength(FValue, ACount);
        FExtType := p^;
        Inc(p);
        Move(p^, FValue[0], ACount);
        Inc(p, ACount);
        end;
      $CA: // float 32
        begin
        Inc(p);
        AsSingle := mtof32(p);
        end;
      $CB: // Float 64
        begin
        Inc(p);
        AsFloat := mtof64(p);
        end;
      $CC: // UInt8
        begin
        Inc(p);
        AsInt64 := p^;
        Inc(p);
        end;
      $CD: // UInt16
        begin
        Inc(p);
        AsInt64 := mtoh16(p);
        end;
      $CE:
        begin
        Inc(p);
        AsInt64 := mtoh32(p);
        end;
      $CF:
        begin
        Inc(p);
        AsInt64 := mtoh64(p);
        end;
      $D0: // Int8
        begin
        Inc(p);
        AsInt64 := p^;
        Inc(p);
        end;
      $D1: // Int16
        begin
        Inc(p);
        AsInt64 := Smallint(mtoh16(p));
        end;
      $D2: // Int32
        begin
        Inc(p);
        AsInt64 := Integer(mtoh32(p));
        end;
      $D3: // Int64
        begin
        Inc(p);
        AsInt64 := Int64(mtoh64(p));
        end;
      $D4: // Fixed ext8,1B
        begin
        Inc(p);
        DataType := mptExtended;
        SetLength(FValue, 1);
        FExtType := p^;
        Inc(p);
        FValue[0] := p^;
        Inc(p);
        end;
      $D5: // Fixed Ext16,2B
        begin
        Inc(p);
        DataType := mptExtended;
        SetLength(FValue, 2);
        FExtType := p^;
        Inc(p);
        PWord(@FValue[0])^ := PWord(p)^;
        Inc(p, 2);
        end;
      $D6: // Fixed Ext32,4B
        begin
        Inc(p);
        DataType := mptExtended;
        SetLength(FValue, 4);
        FExtType := p^;
        Inc(p);
        PCardinal(@FValue[0])^ := PCardinal(p)^;
        Inc(p, 4);
        end;
      $D7: // Fixed Ext64,8B
        begin
        Inc(p);
        DataType := mptExtended;
        SetLength(FValue, 8);
        FExtType := p^;
        Inc(p);
        PInt64(@FValue[0])^ := PInt64(p)^;
        Inc(p, 8);
        end;
      $D8: // Fixed Ext 128bit,16B
        begin
        Inc(p);
        DataType := mptExtended;
        SetLength(FValue, 16);
        FExtType := p^;
        Inc(p);
        PInt64(@FValue[0])^ := PInt64(p)^;
        Inc(p, 8);
        PInt64(@FValue[8])^ := PInt64(p)^;
        Inc(p, 8);
        end;
      $D9: // Str
        begin
        Inc(p);
        ACount := p^;
        Inc(p);
        AsString := Utf8Decode(PQCharA(p), ACount);
        Inc(p, ACount);
        end;
      $DA: // Str 16
        begin
        Inc(p);
        ACount := mtoh16(p);
        AsString := Utf8Decode(PQCharA(p), ACount);
        Inc(p, ACount);
        end;
      $DB: // Str 32
        begin
        Inc(p);
        ACount := mtoh32(p);
        AsString := Utf8Decode(PQCharA(p), ACount);
        Inc(p, ACount);
        end;
      $DC: // array 16
        begin
        Inc(p);
        DataType := mptArray;
        ACount := mtoh16(p);
        FItems.Capacity := ACount;
        for I := 0 to ACount - 1 do
          Add.InternalParse(p, l - (Integer(p) - Integer(ps)));
        end;
      $DD: // Array 32
        begin
        Inc(p);
        DataType := mptArray;
        ACount := mtoh32(p);
        FItems.Capacity := ACount;
        for I := 0 to ACount - 1 do
          Add.InternalParse(p, l - (Integer(p) - Integer(ps)));
        end;
      $DE: // Object map 16
        begin
        Inc(p);
        DataType := mptMap;
        ACount := mtoh16(p);
        FItems.Capacity := ACount;
        for I := 0 to ACount - 1 do
          begin
          with Add do
            begin
            // ����
            InternalParse(p, l - (Integer(p) - Integer(ps)));
            FName := AsString;
            // ����ֵ
            InternalParse(p, l - (Integer(p) - Integer(ps)));
            end;
          end;
        end;
      $DF:
        begin
        Inc(p);
        DataType := mptMap;
        ACount := mtoh32(p);
        FItems.Capacity := ACount;
        for I := 0 to ACount - 1 do
          begin
          with Add do
            begin
            // ����
            InternalParse(p, l - (Integer(p) - Integer(ps)));
            FName := AsString;
            // ����ֵ
            InternalParse(p, l - (Integer(p) - Integer(ps)));
            end;
          end;
        end;
    end;
    end;
  Break;
  end;
end;

{$IFDEF UNICODE}

function TQMsgPack.Invoke(AInstance: TValue): TValue;
var
  AMethods: TArray<TRttiMethod>;
  AParams: TArray<TRttiParameter>;
  AMethod: TRttiMethod;
  AType: TRttiType;
  AContext: TRttiContext;
  AParamValues: array of TValue;
  I, C: Integer;
  AParamItem: TQMsgPack;
begin
AContext := TRttiContext.Create;
Result := TValue.Empty;
if AInstance.IsObject then
  AType := AContext.GetType(AInstance.AsObject.ClassInfo)
else if AInstance.IsClass then
  AType := AContext.GetType(AInstance.AsClass)
else if AInstance.Kind = tkRecord then
  AType := AContext.GetType(AInstance.TypeInfo)
else
  AType := AContext.GetType(AInstance.TypeInfo);
AMethods := AType.GetMethods(Name);
C := Count;
for AMethod in AMethods do
  begin
  AParams := AMethod.GetParameters;
  if Length(AParams) = C then
    begin
    SetLength(AParamValues, C);
    for I := 0 to C - 1 do
      begin
      AParamItem := ItemByName(AParams[I].Name);
      if AParamItem <> nil then
        AParamValues[I] := AParamItem.ToRttiValue
      else
        raise Exception.CreateFmt(SParamMissed, [AParams[I].Name]);
      end;
    Result := AMethod.Invoke(AInstance, AParamValues);
    Exit;
    end;
  end;
raise Exception.CreateFmt(SMethodMissed, [Name]);
end;
{$ENDIF UNICODE}

function TQMsgPack.IsChildOf(AParent: TQMsgPack): Boolean;
begin
if Assigned(AParent) then
  begin
  if AParent = FParent then
    Result := True
  else
    Result := FParent.IsChildOf(AParent);
  end
else
  Result := False;
end;

function TQMsgPack.IsParentOf(AChild: TQMsgPack): Boolean;
begin
if Assigned(AChild) then
  Result := AChild.IsChildOf(Self)
else
  Result := False;
end;

function TQMsgPack.ItemByName(AName: QStringW): TQMsgPack;
var
  AChild: TQMsgPack;
  I: Integer;
  ASelfName: String;
  function ArrayName: String;
  var
    ANamedItem: TQMsgPack;
    AParentIndexes: String;
  begin
  ANamedItem := Self;
  while ANamedItem.Parent <> nil do
    begin
    if ANamedItem.Parent.IsArray then
      begin
      AParentIndexes := AParentIndexes + '[' +
        IntToStr(ANamedItem.ItemIndex) + ']';
      ANamedItem := ANamedItem.Parent;
      end
    else
      Break;
    end;
  Result := ANamedItem.Name + AParentIndexes;
  end;

begin
Result := nil;
if DataType = mptMap then
  begin
  I := IndexOf(AName);
  if I <> -1 then
    Result := Items[I];
  end
else if DataType = mptArray then
  begin
  ASelfName := ArrayName;
  for I := 0 to Count - 1 do
    begin
    AChild := Items[I];
    if ASelfName + '[' + IntToStr(I) + ']' = AName then
      begin
      Result := AChild;
      Exit;
      end
    else if AChild.IsArray then
      begin
      Result := AChild.ItemByName(AName);
      if Assigned(Result) then
        Exit;
      end
    else
    end;
  end;
end;

function TQMsgPack.ItemByName(const AName: QStringW; AList: TQMsgPackList;
  ANest: Boolean): Integer;
var
  ANode: TQMsgPack;
  function InternalFind(AParent: TQMsgPack): Integer;
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

function TQMsgPack.ItemByPath(APath: QStringW): TQMsgPack;
var
  AParent: TQMsgPack;
  AName: QStringW;
  p, pn, ws: PQCharW;
  l: Integer;
  AIndex: Int64;
const
  PathDelimiters: PWideChar = './\';
begin
AParent := Self;
p := PQCharW(APath);
Result := nil;
while Assigned(AParent) and (p^ <> #0) do
  begin
  AName := DecodeTokenW(p, PathDelimiters, WideChar(0), False);
  if Length(AName) > 0 then
    begin
    // ���ҵ������飿
    l := Length(AName);
    AIndex := -1;
    pn := PQCharW(AName);
    if (pn[l - 1] = ']') then
      begin
      repeat
        if pn[l] = '[' then
          begin
          ws := pn + l + 1;
          ParseInt(ws, AIndex);
          Break;
          end
        else
          Dec(l);
      until l = 0;
      if l > 0 then
        begin
        AName := StrDupX(pn, l);
        Result := AParent.ItemByName(AName);
        if Result <> nil then
          begin
          if Result.DataType <> mptArray then
            Result := nil
          else if (AIndex >= 0) and (AIndex < Result.Count) then
            Result := Result[AIndex];
          end;
        end;
      end
    else
      Result := AParent.ItemByName(AName);
    if Assigned(Result) then
      AParent := Result
    else
      begin
      Exit;
      end;
    end;
  if CharInW(p, PathDelimiters) then
    Inc(p);
  // ������..��//\\��·��������
  end;
if p^ <> #0 then
  Result := nil;
end;

function TQMsgPack.ItemByRegex(const ARegex: QStringW; AList: TQMsgPackList;
  ANest: Boolean): Integer;
var
  ANode: TQMsgPack;
  APcre: TPerlRegEx;
  function InternalFind(AParent: TQMsgPack): Integer;
  var
    I: Integer;
  begin
  Result := 0;
  for I := 0 to AParent.Count - 1 do
    begin
    ANode := AParent.Items[I];
    APcre.Subject := ANode.Name;
    if APcre.Match then
      begin
      AList.Add(ANode);
      Inc(Result);
      end;
    if ANest then
      Inc(Result, InternalFind(ANode));
    end;
  end;

begin
APcre := TPerlRegEx.Create;
try
  APcre.RegEx := ARegex;
  APcre.Compile;
  Result := InternalFind(Self);
finally
  FreeObject(APcre);
end;
end;

procedure TQMsgPack.LoadFromFile(AFileName: String);
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

procedure TQMsgPack.LoadFromStream(AStream: TStream);
var
  ABytes: TBytes;
begin
SetLength(ABytes, AStream.Size - AStream.Position);
AStream.ReadBuffer(ABytes[0], Length(ABytes));
Parse(ABytes);
end;

procedure TQMsgPack.Parse(const s: TBytes);
begin
Parse(@s[0], Length(s));
end;

procedure TQMsgPack.Parse(p: PByte; l: Integer);
begin
InternalParse(p, l);
end;

procedure TQMsgPack.Replace(AIndex: Integer; ANewItem: TQMsgPack);
begin
FreeObject(Items[AIndex]);
FItems[AIndex] := ANewItem;
end;

procedure TQMsgPack.ResetNull;
begin
DataType := mptNull;
end;

procedure TQMsgPack.SaveToFile(AFileName: String);
var
  AStream: TMemoryStream;
begin
AStream := TMemoryStream.Create;
try
  SaveToStream(AStream);
  AStream.SaveToFile(AFileName);
finally
  FreeObject(AStream);
end;
end;

procedure TQMsgPack.SaveToStream(AStream: TStream);
var
  ABytes: TBytes;
begin
ABytes := Encode;
AStream.WriteBuffer(ABytes[0], Length(ABytes));
end;

procedure TQMsgPack.SetAsBoolean(const Value: Boolean);
begin
DataType := mptBoolean;
FValue[0] := Integer(Value);
end;

procedure TQMsgPack.SetAsBytes(const Value: TBytes);
begin
DataType := mptBinary;
FValue := Value;
end;

procedure TQMsgPack.SetAsDateTime(const Value: TDateTime);
begin
DataType := mptDateTime;
PDouble(@FValue[0])^ := Value;
end;

procedure TQMsgPack.SetAsFloat(const Value: Double);
begin
DataType := mptFloat;
PDouble(@FValue[0])^ := Value;
end;

procedure TQMsgPack.SetAsInt64(const Value: Int64);
begin
DataType := mptInteger;
PInt64(@FValue[0])^ := Value;
end;

procedure TQMsgPack.SetAsInteger(const Value: Integer);
begin
SetAsInt64(Value);
end;

procedure TQMsgPack.SetAsMsgPack(const Value: TBytes);
begin
Parse(@Value[0], Length(Value));
end;

procedure TQMsgPack.SetAsSingle(const Value: Single);
begin
DataType := mptSingle;
PSingle(FValue)^ := Value;
end;

procedure TQMsgPack.SetAsString(const Value: QStringW);
begin
DataType := mptString;
SetLength(FValue, Length(Value) shl 1);
Move(PQCharW(Value)^, FValue[0], Length(FValue));
end;

procedure TQMsgPack.SetAsVariant(const Value: Variant);
var
  I: Integer;
  AType:TVarType;
  procedure VarAsBytes;
  var
    ABytes:TBytes;
    J:Integer;
  begin
  SetLength(ABytes,VarArrayHighBound(Value, 1)+1);
  for J := VarArrayLowBound(Value,1) to VarArrayHighBound(Value,1) do
    ABytes[J]:=Value[J];
  AsBytes:=ABytes;
  end;
begin
if VarIsArray(Value) then
  begin
  AType:=VarType(Value);
  if (AType and varTypeMask)=varByte then
    VarAsBytes
  else
    begin
    ArrayNeeded(mptArray);
    Clear;
    for I := VarArrayLowBound(Value, VarArrayDimCount(Value))
      to VarArrayHighBound(Value, VarArrayDimCount(Value)) do
      Add.AsVariant := Value[I];
    end;
  end
else
  begin
  case VarType(Value) of
    varSmallInt, varInteger, varByte, varShortInt, varWord,
      varLongWord, varInt64:
      AsInt64 := Value;
    varSingle, varDouble, varCurrency:
      AsFloat := Value;
    varDate:
      AsDateTime := Value;
    varOleStr, varString{$IFDEF UNICODE}, varUString{$ENDIF}:
      AsString := Value;
    varBoolean:
      AsBoolean := Value;
{$IF RtlVersion>=26}
    varUInt64:
      AsInt64 := Value;
    varRecord:
      FromRtti(PVarRecord(@Value).RecInfo, PVarRecord(@Value).PRecord);
{$IFEND >=XE5}
  end;
  end;
end;

procedure TQMsgPack.SetDataType(const Value: TQMsgPackType);
begin
if FDataType <> Value then
  begin
  FDataType := Value;
  if FDataType in [mptArray, mptMap] then
    begin
    if not Assigned(FItems) then
      FItems := TQMsgPackList.Create;
    end
  else
    begin
    if Assigned(FItems) then
      FreeAndNil(FItems);
    case FDataType of
      mptUnknown, mptNull, mptString, mptBinary, mptArray, mptMap, mptExtended:
        SetLength(FValue, 0);
      mptInteger:
        SetLength(FValue, SizeOf(Int64));
      mptBoolean:
        SetLength(FValue, 1);
      mptSingle:
        SetLength(FValue, SizeOf(Single));
      mptFloat, mptDateTime:
        SetLength(FValue, SizeOf(Extended));
    end;
    end;
  end;
end;

procedure TQMsgPack.SetExtBytes(const Value: TBytes);
begin
DataType := mptExtended;
FValue := Value;
end;

procedure TQMsgPack.SetExtType(const Value: Shortint);
begin
if FExtType <> Value then
  begin
  if Value < 0 then
    raise Exception.Create(SReservedExtType);
  FExtType := Value;
  end;
end;
{$IFDEF UNICODE}

procedure TQMsgPack.ToRecord<T>(const ARecord: T);
begin
ToRtti(@ARecord, TypeInfo(T));
end;

procedure TQMsgPack.ToRtti(ADest: Pointer; AType: PTypeInfo);
  function MsgPackToValueArray(AMsgPack: TQMsgPack): TValueArray;
  var
    I: Integer;
    AChild: TQMsgPack;
  begin
  SetLength(Result, AMsgPack.Count);
  for I := 0 to AMsgPack.Count - 1 do
    begin
    AChild := AMsgPack[I];
    case AChild.DataType of
      mptNull:
        Result[I] := TValue.Empty;
      mptString:
        Result[I] := AChild.AsString;
      mptInteger:
        Result[I] := AChild.AsInteger;
      mptSingle, mptFloat:
        Result[I] := AChild.AsFloat;
      mptBoolean:
        Result[I] := AChild.AsBoolean;
      mptDateTime:
        Result[I] := AChild.AsDateTime;
      mptArray, mptMap:
        Result[I] := TValue.FromArray(TypeInfo(TValue),
          MsgPackToValueArray(AChild));
      mptBinary, mptExtended:
        raise Exception.Create(SVariantNotSupport);
    end;
    end;
  end;

  procedure LoadCollection(AMsgPack: TQMsgPack; ACollection: TCollection);
  var
    I: Integer;
  begin
  for I := 0 to AMsgPack.Count - 1 do
    AMsgPack.ToRtti(ACollection.Add);
  end;
  procedure ToRecord;
  var
    AContext: TRttiContext;
    AFields: TArray<TRttiField>;
    ARttiType: TRttiType;
    ABaseAddr: Pointer;
    J: Integer;
    AChild: TQMsgPack;
    AObj: TObject;
  begin
  AContext := TRttiContext.Create;
  ARttiType := AContext.GetType(AType);
  ABaseAddr := ADest;
  AFields := ARttiType.GetFields;
  for J := Low(AFields) to High(AFields) do
    begin
    if AFields[J].FieldType <> nil then
      begin
      AChild := ItemByName(AFields[J].Name);
      if AChild <> nil then
        begin
        case AFields[J].FieldType.TypeKind of
          tkInteger:
            AFields[J].SetValue(ABaseAddr, AChild.AsInteger);
{$IFNDEF NEXTGEN}
          tkString:
            PShortString(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
              ShortString(AChild.AsString);
{$ENDIF !NEXTGEN}
          tkUString{$IFNDEF NEXTGEN}, tkLString, tkWString{$ENDIF !NEXTGEN}:
            AFields[J].SetValue(ABaseAddr, AChild.AsString);
          tkEnumeration:
            begin
            if GetTypeData(AFields[J].FieldType.Handle)^.BaseType^ = TypeInfo
              (Boolean) then
              AFields[J].SetValue(ABaseAddr, AChild.AsBoolean)
            else
              begin
              case GetTypeData(AFields[J].FieldType.Handle).OrdType of
                otSByte:
                  PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                otUByte:
                  PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                otSWord:
                  PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                otUWord:
                  PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                otSLong:
                  PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                otULong:
                  PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                    GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
              end;
              end;
            end;
          tkSet:
            begin
            case GetTypeData(AFields[J].FieldType.Handle).OrdType of
              otSByte:
                PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                  StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
              otUByte:
                PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                  StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
              otSWord:
                PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                  StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
              otUWord:
                PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                  StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
              otSLong:
                PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                  StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
              otULong:
                PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                  StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
            end;
            end;
          tkChar, tkWChar:
            AFields[J].SetValue(ABaseAddr, AChild.AsString);
          tkFloat:
            begin
            if (AFields[J].FieldType.Handle = TypeInfo(TDateTime)) or
              (AFields[J].FieldType.Handle = TypeInfo(TTime)) or
              (AFields[J].FieldType.Handle = TypeInfo(TDate)) then
              AFields[J].SetValue(ABaseAddr, AChild.AsDateTime)
            else
              AFields[J].SetValue(ABaseAddr, AChild.AsFloat);
            end;
          tkInt64:
            AFields[J].SetValue(ABaseAddr, AChild.AsInt64);
          tkVariant:
            PVariant(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
              AChild.AsVariant;
          tkArray, tkDynArray:
            AFields[J].SetValue(ABaseAddr,
              TValue.FromArray(AFields[J].FieldType.Handle,
              MsgPackToValueArray(AChild)));
          tkClass:
            begin
            AObj := AFields[J].GetValue(ABaseAddr).AsObject;
            if AObj is TStrings then
              (AObj as TStrings).Text := AChild.AsString
            else if AObj is TCollection then
              LoadCollection(AChild, AObj as TCollection)
            else
              AChild.ToRtti(AObj);
            end;
          tkRecord:
            AChild.ToRtti(Pointer(IntPtr(ABaseAddr) + AFields[J].Offset),
              AFields[J].FieldType.Handle);
        end;
        end;
      end;
    end;
  end;

  procedure ToObject;
  var
    AProp: PPropInfo;
    ACount: Integer;
    J: Integer;
    AObj, AChildObj: TObject;
    AChild: TQMsgPack;
  begin
  AObj := ADest;
  ACount := Count;
  for J := 0 to ACount - 1 do
    begin
    AChild := Items[J];
    AProp := GetPropInfo(AObj, AChild.Name);
    if AProp <> nil then
      begin
      case AProp.PropType^.Kind of
        tkClass:
          begin
          AChildObj := Pointer(GetOrdProp(AObj, AProp));
          if AChildObj is TStrings then
            (AChildObj as TStrings).Text := AChild.AsString
          else if AChildObj is TCollection then
            LoadCollection(AChild, AChildObj as TCollection)
          else
            AChild.ToRtti(AChildObj);
          end;
        tkRecord, tkArray, tkDynArray: // tkArray,tkDynArray���͵�����û����,tkRecord����
          begin
          AChild.ToRtti(Pointer(GetOrdProp(AObj, AProp)), AProp.PropType^);
          end;
        tkInteger:
          SetOrdProp(AObj, AProp, AChild.AsInteger);
        tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
          SetStrProp(AObj, AProp, AChild.AsString);
        tkEnumeration:
          begin
          if GetTypeData(AProp.PropType^)^.BaseType^ = TypeInfo(Boolean) then
            SetOrdProp(AObj, AProp, Integer(AChild.AsBoolean))
          else
            SetEnumProp(AObj, AProp, AChild.AsString);
          end;
        tkSet:
          SetSetProp(AObj, AProp, AChild.AsString);
        tkVariant:
          SetVariantProp(AObj, AProp, AChild.AsVariant);
        tkInt64:
          SetInt64Prop(AObj, AProp, AChild.AsInt64);
      end;
      end;
    end;
  end;
  function ArrayItemTypeName(ATypeName: QStringW): QStringW;
  var
    p, ps: PQCharW;
    ACount: Integer;
  begin
  p := PQCharW(ATypeName);
  if StartWithW(p, 'TArray<', True) then
    begin
    Inc(p, 7);
    ps := p;
    ACount := 1;
    while ACount > 0 do
      begin
      if p^ = '>' then
        Dec(ACount)
      else if p^ = '<' then
        Inc(ACount);
      Inc(p);
      end;
    Result := StrDupX(ps, p - ps - 1);
    end
  else
    Result := '';
  end;
  procedure SetDynArrayLen(arr: Pointer; AType: PTypeInfo; ALen: NativeInt);
  var
    pmem: Pointer;
  begin
  pmem := PPointer(arr)^;
  DynArraySetLength(pmem, AType, 1, @ALen);
  PPointer(arr)^ := pmem;
  end;

  procedure ToArray;
  var
    AContext: TRttiContext;
    ASubType: TRttiType;
    I, l, AOffset: Integer;
    s: QStringW;
    pd, pi: PByte;
    AChildObj: TObject;
  begin
  AContext := TRttiContext.Create;
{$IF RTLVersion>25}
  s := ArrayItemTypeName(AType.NameFld.ToString);
{$ELSE}
  s := ArrayItemTypeName(String(AType.Name));
{$IFEND}
  ASubType := AContext.FindType(s);
  if ASubType <> nil then
    begin
    l := Count;
    SetDynArrayLen(ADest, ASubType.Handle, l);
    pd := PPointer(ADest)^;
    for I := 0 to l - 1 do
      begin
      AOffset := I * GetTypeData(AType).elSize;
      pi := Pointer(IntPtr(pd) + AOffset);
      case ASubType.TypeKind of
        tkInteger:
          begin
          case GetTypeData(ASubType.Handle).OrdType of
            otSByte:
              PShortint(pi)^ := Items[I].AsInteger;
            otUByte:
              pi^ := Items[I].AsInteger;
            otSWord:
              PSmallint(pi)^ := Items[I].AsInteger;
            otUWord:
              PWord(pi)^ := Items[I].AsInteger;
            otSLong:
              PInteger(pi)^ := Items[I].AsInteger;
            otULong:
              PCardinal(pi)^ := Items[I].AsInteger;
          end;
          end;
{$IFNDEF NEXTGEN}
        tkChar:
          pi^ := Ord(PAnsiChar(AnsiString(Items[I].AsString))[0]);
{$ENDIF !NEXTGEN}
        tkEnumeration:
          begin
          if GetTypeData(ASubType.Handle)^.BaseType^ = TypeInfo(Boolean) then
            PBoolean(pi)^ := Items[I].AsBoolean
          else
            begin
            case GetTypeData(ASubType.Handle)^.OrdType of
              otSByte:
                PShortint(pi)^ := GetEnumValue(ASubType.Handle,
                  Items[I].AsString);
              otUByte:
                pi^ := GetEnumValue(ASubType.Handle, Items[I].AsString);
              otSWord:
                PSmallint(pi)^ := GetEnumValue(ASubType.Handle,
                  Items[I].AsString);
              otUWord:
                PWord(pi)^ := GetEnumValue(ASubType.Handle, Items[I].AsString);
              otSLong:
                PInteger(pi)^ := GetEnumValue(ASubType.Handle,
                  Items[I].AsString);
              otULong:
                PCardinal(pi)^ := GetEnumValue(ASubType.Handle,
                  Items[I].AsString);
            end;
            end;
          end;
        tkFloat:
          case GetTypeData(ASubType.Handle)^.FloatType of
            ftSingle:
              PSingle(pi)^ := Items[I].AsFloat;
            ftDouble:
              PDouble(pi)^ := Items[I].AsFloat;
            ftExtended:
              PExtended(pi)^ := Items[I].AsFloat;
            ftComp:
              PComp(pi)^ := Items[I].AsFloat;
            ftCurr:
              PCurrency(pi)^ := Items[I].AsFloat;
          end;
{$IFNDEF NEXTGEN}
        tkString:
          PShortString(pi)^ := ShortString(Items[I].AsString);
{$ENDIF !NEXTGEN}
        tkSet:
          begin
          case GetTypeData(ASubType.Handle)^.OrdType of
            otSByte:
              PShortint(pi)^ := StringToSet(ASubType.Handle, Items[I].AsString);
            otUByte:
              pi^ := StringToSet(ASubType.Handle, Items[I].AsString);
            otSWord:
              PSmallint(pi)^ := StringToSet(ASubType.Handle, Items[I].AsString);
            otUWord:
              PWord(pi)^ := StringToSet(ASubType.Handle, Items[I].AsString);
            otSLong:
              PInteger(pi)^ := StringToSet(ASubType.Handle, Items[I].AsString);
            otULong:
              PCardinal(pi)^ := StringToSet(ASubType.Handle, Items[I].AsString);
          end;
          end;
        tkClass:
          begin
          if PPointer(pi)^ <> nil then
            begin
            AChildObj := PPointer(pi)^;
            if AChildObj is TStrings then
              (AChildObj as TStrings).Text := Items[I].AsString
            else if AChildObj is TCollection then
              LoadCollection(Items[I], AChildObj as TCollection)
            else
              Items[I].ToRtti(AChildObj);
            end;
          end;
        tkWChar:
          PWideChar(pi)^ := PWideChar(Items[I].AsString)[0];
{$IFNDEF NEXTGEN}
        tkLString:
          PAnsiString(pi)^ := AnsiString(Items[I].AsString);
        tkWString:
          PWideString(pi)^ := Items[I].AsString;
{$ENDIF}
        tkVariant:
          PVariant(pi)^ := Items[I].AsVariant;
        tkArray, tkDynArray:
          Items[I].ToRtti(pi, ASubType.Handle);
        tkRecord:
          Items[I].ToRtti(pi, ASubType.Handle);
        tkInt64:
          PInt64(pi)^ := Items[I].AsInt64;
        tkUString:
          PUnicodeString(pi)^ := Items[I].AsString;
      end;
      end;
    end
  else
    raise Exception.Create(SArrayTypeMissed);
  end;

begin
if ADest <> nil then
  begin
  if AType.Kind = tkRecord then
    ToRecord
  else if AType.Kind = tkClass then
    ToObject
  else if AType.Kind = tkDynArray then
    ToArray
  else
    raise Exception.Create(SUnsupportPropertyType);
  end;
end;

procedure TQMsgPack.ToRtti(AInstance: TValue);
begin
if AInstance.IsEmpty then
  Exit;
if AInstance.Kind = tkRecord then
  ToRtti(AInstance.GetReferenceToRawData, AInstance.TypeInfo)
else if AInstance.Kind = tkClass then
  ToRtti(AInstance.AsObject, AInstance.TypeInfo)
end;

function TQMsgPack.ToRttiValue: TValue;
  procedure AsDynValueArray;
  var
    AValues: array of TValue;
    I: Integer;
  begin
  SetLength(AValues, Count);
  for I := 0 to Count - 1 do
    AValues[I] := Items[I].ToRttiValue;
  Result := TValue.FromArray(TypeInfo(TValueArray), AValues);
  end;

begin
case DataType of
  mptString:
    Result := AsString;
  mptInteger:
    Result := AsInt64;
  mptSingle:
    Result := AsSingle;
  mptFloat:
    Result := AsFloat;
  mptDateTime:
    Result := AsDateTime;
  mptBoolean:
    Result := AsBoolean;
  mptBinary, mptExtended:
    raise Exception.Create(SUnsupportValueType);
  mptArray, mptMap: // ����Ͷ���ֻ�ܵ�������������
    AsDynValueArray
else
  Result := TValue.Empty;
end;
end;
{$ENDIF UNICODE}

function TQMsgPack.ToString: string;
begin
if Length(FName) > 0 then
  Result := FName + ':' + AsString
else
  Result := AsString;
end;

function TQMsgPack.ValueByName(AName, ADefVal: QStringW): QStringW;
var
  AChild: TQMsgPack;
begin
AChild := ItemByName(AName);
if Assigned(AChild) then
  Result := AChild.AsString
else
  Result := ADefVal;
end;

function TQMsgPack.ValueByPath(APath, ADefVal: QStringW): QStringW;
var
  AItem: TQMsgPack;
begin
AItem := ItemByPath(APath);
if Assigned(AItem) then
  Result := AItem.AsString
else
  Result := ADefVal;
end;

{ TQMsgPackEnumerator }

constructor TQMsgPackEnumerator.Create(AList: TQMsgPack);
begin
inherited Create;
FList := AList;
FIndex := -1;
end;

function TQMsgPackEnumerator.GetCurrent: TQMsgPack;
begin
Result := FList[FIndex];
end;

function TQMsgPackEnumerator.MoveNext: Boolean;
begin
if FIndex < FList.Count - 1 then
  begin
  Inc(FIndex);
  Result := True;
  end
else
  Result := False;
end;

{ TQHashedMsgPack }

function TQHashedMsgPack.Add(AName: QStringW): TQMsgPack;
begin
Result := inherited Add(AName);
Result.FNameHash := HashOf(PQCharW(AName), Length(AName) shl 1);
FHashTable.Add(Pointer(Count - 1), Result.FNameHash);
end;

procedure TQHashedMsgPack.Assign(ANode: TQMsgPack);
begin
inherited;
if (Length(FName) > 0) then
  begin
  if FNameHash = 0 then
    FNameHash := HashOf(PQCharW(FName), Length(FName) shl 1);
  if Assigned(Parent) then
    TQHashedMsgPack(Parent).FHashTable.Add(Pointer(Parent.Count - 1),
      FNameHash);
  end;
end;

procedure TQHashedMsgPack.Clear;
begin
inherited;
FHashTable.Clear;
end;

constructor TQHashedMsgPack.Create;
begin
inherited;
FHashTable := TQHashTable.Create();
FHashTable.AutoSize := True;
end;

function TQHashedMsgPack.CreateItem: TQMsgPack;
begin
if Assigned(OnQMsgPackCreate) then
  Result := OnQMsgPackCreate
else
  Result := TQHashedMsgPack.Create;
end;

procedure TQHashedMsgPack.Delete(AIndex: Integer);
var
  AItem: TQMsgPack;
begin
AItem := Items[AIndex];
FHashTable.Delete(Pointer(AIndex), AItem.NameHash);
inherited;
end;

destructor TQHashedMsgPack.Destroy;
begin
FreeObject(FHashTable);
inherited;
end;

function TQHashedMsgPack.IndexOf(const AName: QStringW): Integer;
var
  AIndex, AHash: Integer;
  AList: PQHashList;
  AItem: TQMsgPack;
begin
AHash := HashOf(PQCharW(AName), Length(AName) shl 1);
AList := FHashTable.FindFirst(AHash);
Result := -1;
while AList <> nil do
  begin
  AIndex := Integer(AList.Data);
  AItem := Items[AIndex];
  if AItem.Name = AName then
    begin
    Result := AIndex;
    Break;
    end
  else
    AList := FHashTable.FindNext(AList);
  end;
end;

procedure TQHashedMsgPack.Replace(AIndex: Integer; ANewItem: TQMsgPack);
var
  AOld: TQMsgPack;
begin
if not(ANewItem is TQHashedMsgPack) then
  raise Exception.CreateFmt(SReplaceTypeNeed, ['TQHashedMsgPack']);
AOld := Items[AIndex];
FHashTable.Delete(Pointer(AIndex), AOld.NameHash);
inherited;
if Length(ANewItem.FName) > 0 then
  FHashTable.Add(Pointer(AIndex), ANewItem.FNameHash);
end;
initialization
  MsgPackDateFormat:='yyyy-mm-dd';
  MsgPackTimeFormat:='hh:nn:ss.zzz';
  MsgPackDateTimeFormat:='yyyy-mm-dd"T"hh:nn:ss.zzz';
  MsgPackCaseSensitive:=True;
  OnQMsgPackCreate:=nil;
  OnQMsgPackFree:=nil;
end.

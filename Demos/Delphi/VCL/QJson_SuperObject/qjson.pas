unit qjson;
{$I 'qdac.inc'}
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

{�޶���־

2014.5.27
==========
  + TQHashedJson ֧�֣�����һ�������ѯ�Ż��İ汾��ʹ�ù�ϣ��ӿ�ItemByName�Ĳ�ѯ�ٶȣ�
    �������Ӧ���д�����ʹ��ItemByName��ItemByPath�Ȳ�ѯ��ʹ��������TQJson������Ӧֱ��
    ʹ��TQJson

2014.5.14
=========
  + ����CopyIf/DeleteIf/FindIf����
  + ����for..in�﷨֧��
  * ������Encode��ForcePath���ܴ��ڵ�����

2014.5.6
========
  + ����ParseBlock��������֧����ʽ���ͷֶν���
  * �����˽���\uxxxxʱ��ʶ�����
  * �޸�Parse����Ϊ��������ӽ��

2014.5.4
========
  + �����JavaScript��.net������ʱ������/DATE(MillSeconds+TimeZone)/��ʽ��֧��
  * Json����֧�ּ���VCL��TDateTime����֧�֣����ɵ�JSON����Ĭ����JsonDateFormat��
    JsonTimeFormat,JsonDateTimeFormat�����������ƣ����StrictJson����ΪTrue����
    ����/DATE(MillSeconds+TimeZone)/��ʽ
  ��ע��
  ����ʱ�����ͽ�����������ʱ������JSON��ʵ������Ϊ�ַ����������ַ����ٴδ�ʱ
  ����ʧ������Ϣ�������Կ���ֱ����AsDateTime��������д���������ʱ������ʹ��
  JavaScript��.net��ʽ���Ұ�����ʱ����Ϣ����ʱ�佫��ת��Ϊ��������ʱ�䡣

2014.5.1
========
  + ����AddRecord������֧��ֱ�ӱ����¼���ݣ����������͵ĳ�Ա�ᱻ����
    ����(Class)������(Method)���ӿ�(Interface)����������(ClassRef),ָ��(Pointer)������(Procedure)
    �������ܸ���ʵ����Ҫ�����Ƿ����֧��
  + ����ToRecord���������Jsonֱ�ӵ���¼���͵�ת��
  + ����Copy�������ڴ�����ǰ����һ������ʵ����ע��Ŀǰ�汾��¡�ڲ�������Copy�������������ܸĵ�
  * ������Assign������һ������
}
//���Ի�����ΪDelphi 2007��XE6�������汾�Ŀ����������������޸�
uses classes,sysutils,math,qstring,typinfo,qrbtree
  {$IFDEF QDAC_UNICODE}
  ,Generics.Collections,RegularExpressionsCore
  {$ENDIF}
  {$IFDEF QDAC_RTTI}
  ,Rtti
  {$ENDIF}
  ;
{$M+}
//���Ҫʹ����������ʾ��ʽ����TForm1.FormCreate,����������Ķ��壬���򷽷���ΪForm1.FormCreate
{.$DEFINE TYPENAMEASMETHODPREF}
type
  ///����Ԫ��QDAC����ɲ��֣���QDAC��Ȩ���ƣ��������QDAC��վ�˽�
  /// <summary>
  /// JSON������Ԫ�����ڿ��ٽ�����ά��JSON�ṹ.ȫ�ֱ���StrictJsonΪFalseʱ��֧��
  ///ע�ͺ����Ʋ�����'"'��
  /// </summary>
  ///  TQJsonDataType���ڼ�¼JSON����Ԫ�����ͣ���ȡֵ������
  ///  <list>
  ///    <item>
  ///    <term>jdtUnknown</term><description>δ֪���ͣ�ֻ���¹������δ��ֵʱ���Ż��Ǹ�����</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtNull</term><description>NULL</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtString</term><description>�ַ���</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtInteger</term><description>����(Int64,��������ֵ����ڲ���ʹ��64λ��������)</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtFloat</term><description>˫���ȸ�����(Double)</description>
  ///   </item>
  ///    <item>
  ///    <term>jdtBoolean</term><description>����</description>
  ///    </item>
  ///   <item>
  ///   <term>jdtDateTime</term><description>����ʱ������</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtArray</term><description>����</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtObject</term><description>����</description>
  ///    </item>
  ///  </list>
  TQJsonDataType=(jdtUnknown,jdtNull,jdtString,jdtInteger,jdtFloat,jdtBoolean,jdtDateTime,jdtArray,jdtObject);
  TQJson=class;
  {$IFDEF QDAC_UNICODE}
  /// <summary>
  ///   RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  ///  <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  ///  <param name="AType">���Ի��ֶε�������Ϣ</param>
  ///  <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  ///  <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQJsonRttiFilterEventA=reference to procedure (ASender:TQJson;AObject:Pointer;AName:QStringW;AType:PTypeInfo;var Accept:Boolean;ATag:Pointer);
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQJsonFilterEventA=reference to procedure(ASender,AItem:TQJson;var Accept:Boolean;ATag:Pointer);
  {$ENDIF}
  /// <summary>
  ///   RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  ///  <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  ///  <param name="AType">���Ի��ֶε�������Ϣ</param>
  ///  <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  ///  <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQJsonRttiFilterEvent=procedure (ASender:TQJson;AObject:Pointer;AName:QStringW;AType:PTypeInfo;var Accept:Boolean;ATag:Pointer) of object;
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQJsonFilterEvent=procedure(ASender,AItem:TQJson;var Accept:Boolean;ATag:Pointer) of object;
  PQJson=^TQJson;
  {$IFDEF QDAC_UNICODE}
  TQJsonItemList=TList<TQJson>;
  {$ELSE}
  TQJsonItemList=TList;
  {$ENDIF}
  /// <summary>
  ///   TQJsonTagType�����ڲ�AddObject��AddRecord�������ڲ�����ʹ��
  /// </summary>
  /// <list>
  ///  <item>
  ///    <term>ttAnonEvent</term><description>�ص���������</description>
  ///    <term>ttNameFilter</term><description>���Ի��Ա���ƹ���</descriptio>
  /// </list>
  TQJsonTagType=(ttAnonEvent,ttNameFilter);
  PQJsonInternalTagData=^TQJsonInternalTagData;
  /// <summary>
  /// TQJsonInternalTagData����AddRecord��AddObject������Ҫ�ڲ�����RTTI��Ϣʱʹ��
  /// </summary>
  TQJsonInternalTagData=record
    /// <summary>Tag���ݵ�����</summary>
    TagType:TQJsonTagType;
    {$IFDEF QDAC_RTTI}
    /// <summary>����ʹ�õ���������</summary>
    OnEvent:TQJsonRttiFilterEventA;
    {$ENDIF QDAC_RTTI}
    /// <summary>���ܵ�����(AddObject)���¼�ֶ�(AddRecord)���ƣ��������ͬʱ��IgnoreNames���֣���IgnoreNames�����Ϣ������</summary>
    AcceptNames:QStringW;
    /// <summary>���Ե�����(AddObject)���¼�ֶ�(AddRecord)���ƣ��������ͬʱ��AcceptNameds���AcceptNames����</summary>
    IgnoreNames:QStringW;
    /// <summary>ԭʼ���ݸ�AddObject��AddRecord�ĸ������ݳ�Ա�����������ݸ�OnEvent��Tag���Թ��û�ʹ��</summary>
    Tag:Pointer;
  end;
  TQJsonEnumerator=class;
  ///<summary>�����ⲿ֧�ֶ���صĺ���������һ���µ�QJSON����ע��ӳ��д����Ķ���</summary>
  ///  <returns>�����´�����QJSON����</returns>
  TQJsonCreateEvent=function:TQJson;
  ///<summary>�����ⲿ�����󻺴棬�Ա����ö���</summary>
  ///  <param name="AJson">Ҫ�ͷŵ�Json����</param>
  TQJsonFreeEvent=procedure (AJson:TQJson);
  TValueArray=array of TValue;
  /// <summary>
  ///  TQJson���ڽ�����ά��JSON��ʽ�Ķ������ͣ�Ҫʹ��ǰ����Ҫ���ڶ��д�����Ӧ��ʵ����
  ///  TQJson��TQXML�ھ�������ӿ��ϱ���һ�£�������Json����������Ϣ����XMLû������
  ///  ��Ϣ��ʼ����Ϊ���ַ�����������ٲ��ֽӿڻ����в�ͬ.
  ///  ������ʵ�ֲ�ͬ��QJSON���е����Ͷ���ͬһ������ʵ�֣�����DataType�Ĳ�ͬ����ʹ��
  ///  ��ͬ�ĳ�Ա�����ʡ�������ΪjdtArray������jdtObjectʱ�����������ӽ��.
  /// </summary>
  TQJson=class
  private
    function GetAsValue: TValue;
    procedure SetAsValue(const Value: TValue);
  protected
    FName:QStringW;
    FNameHash:Cardinal;
    FDataType:TQJsonDataType;
    FValue:QStringW;
    FParent:TQJson;
    FData:Pointer;
    FItems:TQJsonItemList;
    function GetValue: QStringW;
    procedure SetValue(const Value: QStringW);
    procedure SetDataType(const Value: TQJsonDataType);
    function GetAsBoolean: Boolean;
    function GetAsFloat: Extended;
    function GetAsInt64: Int64;
    function GetAsInteger: Integer;
    function GetAsString: QStringW;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsInt64(const Value: Int64);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: QStringW);
    function GetAsObject: QStringW;
    procedure SetAsObject(const Value: QStringW);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQJson;
    function CharUnescape(var p:PQCharW):QCharW;
    function CharEscape(c:QCharW;pd:PQCharW):Integer;
    procedure ArrayNeeded(ANewType:TQJsonDataType);
    procedure ValidArray;
    procedure ParseObject(var p:PQCharW);
    procedure ParseJsonPair(ABuilder:TQStringCatHelperW;var p:PQCharW);
    procedure BuildJsonString(ABuilder:TQStringCatHelperW;var p:PQCharW);
    procedure ParseName(ABuilder:TQStringCatHelperW;var p:PQCharW);
    procedure ParseValue(ABuilder:TQStringCatHelperW;var p:PQCharW);
    function BoolToStr(const b:Boolean):QStringW;
    function GetIsNull: Boolean;
    function GetIsNumeric: Boolean;
    function GetIsArray: Boolean;
    function GetIsObject: Boolean;
    function GetIsString: Boolean;
    function GetIsDateTime: Boolean;
    function GetAsArray: QStringW;
    procedure SetAsArray(const Value: QStringW);
    function GetPath: QStringW;
    function GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);
    function GetAsJson: QStringW;
    procedure SetAsJson(const Value: QStringW);
    function GetItemIndex: Integer;
    function ParseJsonTime(p:PQCharW;var ATime:TDateTime):Boolean;
    function CreateJson:TQJson;virtual;
    procedure FreeJson(AJson:TQJson);inline;
    procedure CopyValue(ASource:TQJson);inline;
    procedure Replace(AIndex:Integer;ANewItem:TQJson);virtual;
    {$IFDEF QDAC_RTTI}
    function InternalAddRecord(ATypeInfo: PTypeInfo; ABaseAddr: Pointer;AOnFilter:TQJsonRttiFilterEvent;ATag:Pointer):Boolean;
    procedure InternalToRecord(ATypeInfo:PTypeInfo;ABaseAddr:Pointer);
    {$ENDIF QDAC_RTTI}
    procedure InternalRttiFilter(ASender:TQJson;AObject:Pointer;APropName:QStringW;APropType:PTypeInfo;var Accept:Boolean;ATag:Pointer);
    function InternalEncode(ABuilder:TQStringCatHelperW;ADoFormat:Boolean;const AIndent:QStringW):TQStringCatHelperW;
  public
    ///<summary>���캯��</summary>
    constructor Create;overload;
    constructor Create(const AName,AValue:QStringW;ADataType:TQJsonDataType=jdtUnknown);overload;
    ///<summary>��������</summary>
    destructor Destroy;override;
    {<summary�����һ���ӽ��<��summary>
    <param name="ANode">Ҫ��ӵĽ��</param>
    <returns>������ӵĽ������</returns>
    }
    function Add(ANode:TQJson): Integer;overload;
    /// <summary>���һ��δ������JSON�ӽ��</summary>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>
    /// һ������£������������ͣ���Ӧ���δ������ʵ��
    /// </remarks>
    function Add:TQJson;overload;
    /// <summary>���һ������Json����</summary>
    ///  <param name="AName">Ҫ��ӵĶ���������</param>
    ///  <param name="AObject">Ҫ��ӵĶ���</param>
    /// <returns>������ӵĽ��</returns>
    function AddObject(AName:QStringW;AObject:TObject):TQJson;overload;
    /// <summary>���һ������Json����</summary>
    ///  <param name="AName">Ҫ��ӵĶ���������</param>
    ///  <param name="AObject">Ҫ��ӵĶ���</param>
    ///  <param name="AOnFilter">ָ�����Թ����¼����Թ��˵�����Ҫת��������</param>
    ///  <param name="ANest">������Ե��Ƕ����Ƿ�ݹ�</param>
    ///  <param name="ATag">���ӵ����ݳɹ��������¼��ص����û��Լ�����;</param>
    /// <returns>������ӵĽ��</returns>
    function AddObject(AName:QStringW;AObject:TObject;AOnFilter:TQJsonRttiFilterEvent;ANest:Boolean;ATag:Pointer):TQJson;overload;
    {$IFDEF QDAC_RTTI}
    /// <summary>���һ������Json����</summary>
    ///  <param name="AName">Ҫ��ӵĶ���������</param>
    ///  <param name="AObject">Ҫ��ӵĶ���</param>
    ///  <param name="AOnFilter">ָ�����Թ����¼����Թ��˵�����Ҫת��������</param>
    ///  <param name="ANest">������Ե��Ƕ����Ƿ�ݹ�</param>
    ///  <param name="ATag">���ӵ����ݳɹ��������¼��ص����û��Լ�����;</param>
    /// <returns>������ӵĽ��</returns>
    function AddObject(AName:QStringW;AObject:TObject;AOnFilter:TQJsonRttiFilterEventA;ANest:Boolean;ATag:Pointer):TQJson;overload;
    {$ENDIF QDAC_RTTI}
    /// <summary>���һ������Json����</summary>
    ///  <param name="AName">Ҫ��ӵĶ���������</param>
    ///  <param name="AObject">Ҫ��ӵĶ���</param>
    ///  <param name="AcceptProps">������������/param>
    ///  <param name="AIgnoreProps">���Բ����������</param>
    /// <returns>������ӵĽ��</returns>
    function AddObject(AName:QStringW;AObject:TObject;ANest:Boolean;AcceptProps,AIgnoreProps:QStringW):TQJson;overload;
    {$IFDEF QDAC_RTTI}
    /// <summary>���һ����¼���ṹ�壩��Json��</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AObject">Ҫ��ӵļ�¼ʵ��</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    /// <remarks>
    function AddRecord<T>(AName:QStringW;const AObject:T;AcceptFields,AIgnoreFields:QStringW):TQJson;overload;
    /// <summary>���һ����¼���ṹ�壩��Json��</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AObject">Ҫ��ӵĶ���ʵ��</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function AddRecord<T>(AName:QStringW;const AObject:T):TQJson;overload;
    /// <summary>���һ����¼���ṹ�壩��Json��</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AObject">Ҫ��ӵĶ���ʵ��</param>
    /// <param name="AOnFilter">ָ�����Թ����¼����Թ��˵�����Ҫת��������</param>
    /// <param name="ATag">���ӵ����ݳɹ��������¼��ص����û��Լ�����;</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function AddRecord<T>(AName:QStringW;const AObject:T;AOnFilter:TQJsonRttiFilterEvent;ATag:Pointer):TQJson;overload;
    {$IFDEF QDAC_UNICODE}
    /// <summary>���һ����¼���ṹ�壩��Json��</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AObject">Ҫ��ӵĶ���ʵ��</param>
    /// <param name="AOnFilter">ָ�����Թ����¼����Թ��˵�����Ҫת�������ԣ����������汾��</param>
    /// <param name="ATag">���ӵ����ݳɹ��������¼��ص����û��Լ�����;</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function AddRecord<T>(AName:QStringW;const AObject:T;AOnFilter:TQJsonRttiFilterEventA;ATag:Pointer):TQJson;overload;
    {$ENDIF QDAC_UNICODE}
    {$ENDIF QDAC_RTTI}
    {<summary>���һ���ӽ��</summary>
    <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    <param name="ADataType">Ҫ��ӵĽ���������ͣ����ʡ�ԣ����Զ�����ֵ�����ݼ��</param>
    <returns>�������ӽ�������</returns>
    <remarks>
      1.�����ǰ���Ͳ���jdtObject��jdtArray�����Զ�ת��ΪjdtObject����
      2.�ϲ�Ӧ�Լ������������
    </remarks>
    }
    function Add(AName,AValue: QStringW;ADataType:TQJsonDataType=jdtUnknown):Integer;overload;
    /// <summary>���һ������</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AItems">Ҫ��ӵ���������</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function Add(const AName:QStringW;AItems:array of const):TQJson;overload;
    {<summary>���һ���ӽ��</summary>
    <param name="AName">Ҫ��ӵĽ����</param>
    <param name="ADataType">Ҫ��ӵĽ���������ͣ����ʡ�ԣ����Զ�����ֵ�����ݼ��</param>
    <returns>������ӵ��¶���</returns>
    <remarks>
      1.�����ǰ���Ͳ���jdtObject��jdtArray�����Զ�ת��ΪjdtObject����
      2.�ϲ�Ӧ�Լ������������
    </remarks>
    }
    function Add(AName:QStringW;ADataType:TQJsonDataType):TQJson;overload;

    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:Extended):TQJson;overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:Int64):TQJson;overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:Boolean):TQJson;overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddDateTime(AName:QStringW;AValue:TDateTime):TQJson;overload;
    /// <summary>���һ���ӽ��(Null)</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW):TQJson;overload;virtual;

    /// <summary>ǿ��һ��·������,���������,�����δ�����Ҫ�Ľ��(jdtObject��jdtArray)</summary>
    /// <param name="APath">Ҫ��ӵĽ��·��</param>
    /// <returns>����·����Ӧ�Ķ���</returns>
    /// <remarks>
    /// ��������·����ȫ�����ڣ���ForcePath�ᰴ���¹���ִ��:
    /// 1�����APath�а���[]������Ϊ��Ӧ��·�����Ϊ���飬ʾ�����£�
    ///  (1)��'a.b[].name'��
    ///   a -> jdtObject
    ///   b -> jdtArray
    ///   b[0].name -> jdtNull(b������δָ�����Զ���Ϊ��b[0]
    ///  (2)��'a.c[2].name'��
    ///   a -> jdtObject
    ///   c -> jdtArray
    ///   c[2].name -> jdtNull
    ///   ����,c[0],c[1]���Զ�����������ֵΪjdtNull��ִ����ɺ�cΪ��������Ԫ�ص�����
    ///  (3)��'a[0]'��
    ///   a -> jdtArray
    ///   a[0] -> jdtNull
    /// 2��·���ָ���./\�ǵȼ۵ģ����ҽ�������в�Ӧ�������������ַ�֮һ,����
    ///  a.b.c��a\b\c��a/b/c����ȫ��ͬ��·��
    /// 3�����APathָ���Ķ������Ͳ�ƥ�䣬����׳��쳣����aΪ���󣬵�ʹ��a[0].b����ʱ��
    /// </remarks>
    function ForcePath(APath:QStringW):TQJson;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="p">Ҫ�������ַ���</param>
    /// <param name="l">�ַ������ȣ�<=0��Ϊ����\0(#0)��β��C���Ա�׼�ַ���</param>
    /// <remarks>���l>=0������p[l]�Ƿ�Ϊ\0�������Ϊ\0����ᴴ������ʵ������������ʵ��</remarks>
    procedure Parse(p:PWideChar;l:Integer=-1);overload;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="s">Ҫ������JSON�ַ���</param>
    procedure Parse(const s:QStringW);overload;
    /// <summmary>�����н����׸�JSON���ݿ�</summary>
    ///  <param name="AStream">������</param>
    ///  <param name="AEncoding">�����ݵı��뷽ʽ</param>
    /// <remarks>ParseBlock�ʺϽ����ֶ�ʽJSON������ӵ�ǰλ�ÿ�ʼ����������ǰ�������Ϊֹ.
    ///  ���Ժܺõ����㽥��ʽ�������Ҫ</remarks>
    procedure ParseBlock(AStream:TStream;AEncoding:TTextEncoding);
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    ///  ���󣬲��������һ���������Ӱ�졣
    ///  </remarks>
    function Copy:TQJson;
    {$IFDEF QDAC_RTTI}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    ///  ���󣬲��������һ���������Ӱ�졣
    ///  </remarks>
    function CopyIf(const ATag:Pointer;AFilter:TQJsonFilterEventA):TQJson;overload;
    {$ENDIF}
     /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    ///  ���󣬲��������һ���������Ӱ�졣
    ///  </remarks>
    function CopyIf(const ATag:Pointer;AFilter:TQJsonFilterEvent):TQJson;overload;
    /// <summary>��¡����һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊʵ����ִ�е��ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ��
    ///  ��������һ�����󣬲��������һ���������Ӱ�죬������Ϊ����������֤������
    ///  �����Ϊ���ã��Ա��໥Ӱ�졣
    ///  </remarks>
    function Clone:TQJson;
    /// <summary>����Ϊ�ַ���</summary>
    /// <param name="ADoFormat">�Ƿ��ʽ���ַ����������ӿɶ���</param>
    /// <param name="AIndent">ADoFormat����ΪTrueʱ���������ݣ�Ĭ��Ϊ�����ո�</param>
    /// <returns>���ر������ַ���</returns>
    ///  <remarks>AsJson�ȼ���Encode(True,'  ')</remarks>
    function Encode(ADoFormat:Boolean;AIndent:QStringW='  '):QStringW;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <returns>����Ӧ����ֵ</returns>
    function ValueByName(AName,ADefVal:QStringW):QStringW;
    /// <summary>��ȡָ��·������ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function ValueByPath(APath,ADefVal:QStringW):QStringW;
    /// <summary>��ȡָ�����Ƶĵ�һ�����</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����ҵ��Ľ�㣬���δ�ҵ������ؿ�(NULL/nil)</returns>
    /// <remarks>ע��QJson���������������ˣ�������������Ľ�㣬ֻ�᷵�ص�һ�����</remarks>
    function ItemByName(AName:QStringW):TQJson;overload;
    /// <summary>��ȡָ�����ƵĽ�㵽�б���</summary>
    /// <param name="AName">�������</param>
    ///  <param name="AList">���ڱ�������б����</param>
    ///  <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByName(const AName:QStringW;AList:TQJsonItemList;ANest:Boolean=False):Integer;overload;
    /// <summary>��ȡ����ָ�����ƹ���Ľ�㵽�б���</summary>
    /// <param name="ARegex">������ʽ</param>
    ///  <param name="AList">���ڱ�������б����</param>
    ///  <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByRegex(const ARegex:QStringW;AList:TQJsonItemList;ANest:Boolean=False):Integer;overload;
    /// <summary>��ȡָ��·����JSON����</summary>
    ///  <param name="APath">·������"."��"/"��"\"�ָ�</param>
    ///  <returns>�����ҵ����ӽ�㣬���δ�ҵ�����NULL(nil)</returns>
    function ItemByPath(APath:QStringW):TQJson;
    /// <summary>��Դ������JSON��������</summary>
    /// <param name="ANode">Ҫ���Ƶ�Դ���</param>
    /// <remarks>ע�ⲻҪ�����ӽ����Լ�������������ѭ����Ҫ�����ӽ�㣬�ȸ�
    /// ��һ���ӽ�����ʵ�����ٴ���ʵ������
    /// </remarks>
    procedure Assign(ANode:TQJson);virtual;
    /// <summary>ɾ��ָ�������Ľ��</summary>
    /// <param name="AIndex">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���ָ�������Ľ�㲻���ڣ����׳�EOutRange�쳣
    /// </remarks>
    procedure Delete(AIndex:Integer);overload;virtual;
    /// <summary>ɾ��ָ�����ƵĽ��</summary>
    ///  <param name="AName">Ҫɾ���Ľ������</param>
    ///  <remarks>
    ///  ���Ҫ��������Ľ�㣬��ֻɾ����һ��
    procedure Delete(AName:QStringW);overload;
    {$IFDEF QDAC_RTTI}
    ///<summary>
    /// ɾ�������������ӽ��
    ///</summary>
    ///  <param name="ATag">�û��Լ����ӵĶ�����</param>
    ///  <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    ///  <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag:Pointer;ANest:Boolean;AFilter:TQJsonFilterEventA);overload;
    {$ENDIF QDAC_RTTI}
    ///<summary>
    /// ɾ�������������ӽ��
    ///</summary>
    ///  <param name="ATag">�û��Լ����ӵĶ�����</param>
    ///  <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    ///  <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag:Pointer;ANest:Boolean;AFilter:TQJsonFilterEvent);overload;
    /// <summary>����ָ�����ƵĽ�������</summary>
    ///  <param name="AName">Ҫ���ҵĽ������</param>
    ///  <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOf(const AName:QStringW):Integer;virtual;
    {$IFDEF QDAC_RTTI}
    ///<summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    ///  <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    ///  <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag:Pointer;ANest:Boolean;AFilter:TQJsonFilterEventA):TQJson;overload;
    {$ENDIF QDAC_RTTI}
    ///<summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    ///  <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    ///  <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag:Pointer;ANest:Boolean;AFilter:TQJsonFilterEvent):TQJson;overload;
    /// <summary>������еĽ��</summary>
    procedure Clear;virtual;
    /// <summary>���浱ǰ�������ݵ�����</summary>
    ///  <param name="AStream">Ŀ��������</param>
    ///  <param name="AEncoding">�����ʽ</param>
    ///  <param name="AWriteBom">�Ƿ�д��BOM</param>
    ///  <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream:TStream;AEncoding:TTextEncoding;AWriteBOM:Boolean);
    /// <summary>�����ĵ�ǰλ�ÿ�ʼ����JSON����</summary>
    ///  <param name="AStream">Դ������</param>
    ///  <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    ///  <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream:TStream;AEncoding:TTextEncoding=teUnknown);
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    ///  <param name="AFileName">�ļ���</param>
    ///  <param name="AEncoding">�����ʽ</param>
    ///  <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    ///  <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(AFileName:String;AEncoding:TTextEncoding;AWriteBOM:Boolean);
    /// <summary>��ָ�����ļ��м��ص�ǰ����</summary>
    ///  <param name="AFileName">Ҫ���ص��ļ���</param>
    ///  <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    procedure LoadFromFile(AFileName:String;AEncoding:TTextEncoding=teUnknown);
    //// <summary>����ֵΪNull���ȼ���ֱ������DataTypeΪjdtNull</summary>
    procedure ResetNull;
    /// <summary>����TObject.ToString����</summary>
    function ToString: string;{$IFDEF QDAC_UNICODE}override;{$ELSE}virtual;{$ENDIF}
    /// <summary>��Json�����ݻ�ԭ��ԭ���Ķ�������</summary>
    procedure ToObject(AObject:TObject);
    {$IFDEF QDAC_RTTI}
    /// <summary>��Json�����ݻ�ԭ��ԭ���Ľṹ�壨��¼���ֶ�ֵ</summary>
    /// <param name="ARecord">Ŀ��ṹ��ʵ��</param>
    procedure ToRecord<T>(const ARecord:T);
    {$ENDIF QDAC_RTTI}
    function GetEnumerator: TQJsonEnumerator;
    function Invoke(Instance: TObject): TValue; overload;
    function Invoke(Instance: TClass): TValue; overload;
    function IsChildOf(AParent:TQJson):Boolean;
    function IsParentOf(AChild:TQJson):Boolean;
    /// <summary>�����</summary>
    property Parent:TQJson read FParent;
    ///<summary>�������</summary>
    /// <seealso>TQJsonDataType</seealso>
    property DataType:TQJsonDataType read FDataType write SetDataType;
    ///<summary>�������</summary>
    property Name:QStringW read FName;
    ///<summary>�ӽ������</<summary>summary>
    property Count:Integer read GetCount;
    ///<summary>�ӽ������</summary>
    property Items[AIndex:Integer]:TQJson read GetItems;default;
    ///<summary>�ӽ���ֵ</summary>
    property Value:QStringW read GetValue write SetValue;
    ///<summary>�ж��Ƿ���NULL����</summary>
    property IsNull:Boolean read GetIsNull;
    ///<summary>�ж��Ƿ�����������</summary>
    property IsNumeric:Boolean read GetIsNumeric;
    ///<summary>�ж��Ƿ�������ʱ������</summary>
    property IsDateTime:Boolean read GetIsDateTime;
    ///<summary>�ж��Ƿ����ַ�������</summary>
    property IsString:Boolean read GetIsString;
    ///<summary>�ж��Ƿ��Ƕ���</summary>
    property IsObject:Boolean read GetIsObject;
    ///<summary>�ж��Ƿ�������</summary>
    property IsArray:Boolean read GetIsArray;
    ///<summary>����ǰ��㵱���������ͷ���</summary>
    property AsBoolean:Boolean read GetAsBoolean write SetAsBoolean;
    ///<summary>����ǰ��㵱����������������</summary>
    property AsInteger:Integer read GetAsInteger write SetAsInteger;
    ///<summary>����ǰ��㵱��64λ��������������</summary>
    property AsInt64:Int64 read GetAsInt64 write SetAsInt64;
    ///<summary>����ǰ��㵱����������������</summary>
    property AsFloat:Extended read GetAsFloat write SetAsFloat;
    ///<summary>����ǰ��㵱������ʱ������������</summary>
    property AsDateTime:TDateTime read GetAsDateTime write SetAsDateTime;
    ///<summary>����ǰ��㵱���ַ������ͷ���</summary>
    property AsString:QStringW read GetAsString write SetAsString;
    ///<summary>����ǰ��㵱��һ�������ַ���������</summary>
    property AsObject:QStringW read GetAsObject write SetAsObject;
    ///<summary>����ǰ��㵱��һ���ַ�������������</summary>
    property AsArray:QStringW read GetAsArray write SetAsArray;
    ///<summary>���Լ�����Variant����������</summary>
    property AsVariant:Variant read GetAsVariant write SetAsVariant;
    /// <summary>���Լ�����Json����������</summary>
    property AsJson:QStringW read GetAsJson write SetAsJson;
    //<summary>����ĸ������ݳ�Ա�����û�������������</summary>
    property Data:Pointer read FData write FData;
    ///<summary>����·����·���м���"\"�ָ�</summary>
    property Path:QStringW read GetPath;
    ///<summary>�ڸ�����е�����˳�򣬴�0��ʼ�������-1��������Լ��Ǹ����</summary>
    property ItemIndex:Integer read GetItemIndex;
    ///<summary>���ƹ�ϣֵ</summary>
    property NameHash:Cardinal read FNameHash;
    //<summary>��ΪTValueֵ����</summary>
    property AsValue:TValue read GetAsValue write SetAsValue;
  end;
  TQJsonEnumerator = class
  private
    FIndex: Integer;
    FList: TQJson;
  public
    constructor Create(AList: TQJson);
    function GetCurrent: TQJson; inline;
    function MoveNext: Boolean;
    property Current: TQJson read GetCurrent;
  end;

  TQHashedJson=class(TQJson)
  protected
    FHashTable:TQHashTable;
    function CreateJson:TQJson;override;
    procedure Replace(AIndex:Integer;ANewItem:TQJson);override;
  public
    constructor Create;overload;
    destructor Destroy;override;
    procedure Assign(ANode:TQJson);override;
    function Add(AName:QStringW):TQJson;override;
    function IndexOf(const AName:QStringW):Integer;override;
    procedure Delete(AIndex:Integer);override;
    procedure Clear;override;
  end;


var
  ///<summary>�Ƿ������ϸ���ģʽ�����ϸ�ģʽ�£�
  /// 1.���ƻ��ַ�������ʹ��˫���Ű�������,���ΪFalse�������ƿ���û�����Ż�ʹ�õ����š�
  /// 2.ע�Ͳ���֧�֣����ΪFalse����֧��//��ע�ͺ�/**/�Ŀ�ע��
  /// </summary>
  StrictJson:Boolean;
  /// <summary>��������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonDateFormat:QStringW;
  /// <summary>ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonTimeFormat:QStringW;
  /// <summary>����ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonDateTimeFormat:QStringW;
  /// <summary>��ItemByName/ItemByPath/ValueByName/ValueByPath�Ⱥ������ж��У��Ƿ��������ƴ�Сд</summary>
  JsonCaseSensitive:Boolean;
  /// ����Ҫ�½�һ��TQJson����ʱ����
  OnQJsonCreate:TQJsonCreateEvent;
  /// ����Ҫ�ͷ�һ��TQJson����ʱ����
  OnQJsonFree:TQJsonFreeEvent;
implementation
uses variants,dateutils;
resourcestring
  SBadJson='��ǰ���ݲ�����Ч��JSON�ַ�����';
  SNotArrayOrObject='%s ����һ��JSON��������';
  SVarNotArray='%s �����Ͳ�����������';
  SBadConvert='%s ����һ����Ч�� %s ���͵�ֵ��';
  SCharNeeded='��ǰλ��Ӧ���� "%s" �������� "%s"��';
  SBadNumeric='"%s"������Ч����ֵ��';
  SBadJsonTime='"%s"����һ����Ч������ʱ��ֵ��';
  SNameNotFound='��Ŀ����δ�ҵ���';
  SCommentNotSupport='�ϸ�ģʽ�²�֧��ע�ͣ�Ҫ��������ע�͵�JSON���ݣ��뽫StrictJson��������ΪFalse��';
  SUnsupportArrayItem='��ӵĶ�̬�����%d��Ԫ�����Ͳ���֧�֡�';
  SBadStringStart='�ϸ����JSON�ַ���������"��ʼ��';
  SUnknownToken='�޷�ʶ���ע�ͷ���ע�ͱ�����//��/**/������';
  SNotSupport='���� [%s] �ڵ�ǰ���������²���֧�֡�';
  SBadJsonArray='%s ����һ����Ч��JSON���鶨�塣';
  SBadJsonObject='%s ����һ����Ч��JSON�����塣';
  SBadJsonEncoding='��Ч�ı��룬����ֻ����UTF-8��ANSI��Unicode 16 LE��Unicode 16 BE��';
  SJsonParseError='��%d�е�%d��:%s '#13#10'��:%s';
  SBadJsonName='%s ����һ����Ч��JSON�������ơ�';
  SObjectChildNeedName='���� %s �ĵ� %d ���ӽ������δ��ֵ���������ǰ���踳ֵ��';
  SReplaceTypeNeed='�滻��������Ҫ���� %s �������ࡣ';
const
  JsonTypeName:array [0..8] of QStringW=(
    'Unknown','Null','String','Integer','Float','Boolean','DateTime','Array','Object');
{ TQJson }

function TQJson.Add(AName: QStringW; AValue: Int64): TQJson;
begin
Result:=Add(AName,jdtInteger);
PInt64(PQCharW(Result.FValue))^:=AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Extended): TQJson;
begin
Result:=Add(AName,jdtFloat);
PExtended(PQCharW(Result.FValue))^:=AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Boolean): TQJson;
begin
Result:=Add(AName,jdtBoolean);
PBoolean(PQCharW(Result.FValue))^:=AValue;
end;

function TQJson.Add(AName: QStringW): TQJson;
begin
Result:=Add;
Result.FName:=AName;
end;

function TQJson.AddObject(AName: QStringW; AObject: TObject; ANest: Boolean;
  AcceptProps, AIgnoreProps: QStringW): TQJson;
var
  ATagData:TQJsonInternalTagData;
begin
ATagData.TagType:=ttNameFilter;
ATagData.Tag:=nil;
ATagData.AcceptNames:=AcceptProps;
ATagData.IgnoreNames:=AIgnoreProps;
Result:=AddObject(AName,AObject,InternalRttiFilter,ANest,@ATagData);
end;

function TQJson.AddObject(AName: QStringW; AObject: TObject): TQJson;
begin
Result:=AddObject(AName,AObject,TQJsonRttiFilterEvent(nil),false,nil);
end;

{$IFDEF QDAC_RTTI}
function TQJson.AddRecord<T>(AName: QStringW; const AObject: T): TQJson;
begin
Result:=Add(AName);
Result.InternalAddRecord(TypeInfo(T),@AObject,nil,nil);
end;


function TQJson.AddRecord<T>(AName: QStringW; const AObject: T; AcceptFields,
  AIgnoreFields: QStringW): TQJson;
var
  ATagData:TQJsonInternalTagData;
begin
ATagData.TagType:=ttNameFilter;
ATagData.Tag:=nil;
ATagData.AcceptNames:=AcceptFields;
ATagData.IgnoreNames:=AIgnoreFields;
Result:=Add(AName);
Result.InternalAddRecord(TypeInfo(T),@AObject,InternalRttiFilter,@ATagData);
end;

function TQJson.AddRecord<T>(AName: QStringW; const AObject: T;
  AOnFilter: TQJsonRttiFilterEvent; ATag: Pointer): TQJson;
begin
Result:=Add(AName);
Result.InternalAddRecord(TypeInfo(T),@AObject,AOnFilter,ATag);
end;

function TQJson.AddRecord<T>(AName: QStringW; const AObject: T;
  AOnFilter: TQJsonRttiFilterEventA; ATag: Pointer): TQJson;
var
  ATagData:TQJsonInternalTagData;
begin
ATagData.TagType:=ttAnonEvent;
ATagData.Tag:=ATag;
ATagData.OnEvent:=AOnFilter;
Result:=Add(AName);
Result.InternalAddRecord(TypeInfo(T),@AObject,InternalRttiFilter,@ATagData);
end;

//��������֧��
function TQJson.AddObject(AName: QStringW; AObject: TObject;
  AOnFilter: TQJsonRttiFilterEventA; ANest: Boolean; ATag: Pointer): TQJson;
var
  ATagData:TQJsonInternalTagData;
begin
if Assigned(AOnFilter) then
  begin
  ATagData.TagType:=ttAnonEvent;
  ATagData.OnEvent:=AOnFilter;
  ATagData.Tag:=ATag;
  Result:=AddObject(AName,AObject,InternalRttiFilter,ANest,@ATagData)
  end
else
  Result:=AddObject(AName,AObject,TQJsonRttiFilterEvent(nil),ANest,ATag);
end;
{$ENDIF QDAC_RTTI}

function TQJson.AddObject(AName:QStringW;AObject:TObject;
  AOnFilter:TQJsonRttiFilterEvent;ANest:Boolean;ATag:Pointer): TQJson;
  function GetObjectName(AObj:TObject):String;
  begin
  if AObj<>nil then
    begin
    {$IFDEF TYPENAMEASMETHODPREF}
    Result:=TObject(AObj).ClassName;
    {$ELSE}
    if TObject(AObj) is TComponent then
      Result:=TComponent(AObj).GetNamePath
    else if GetPropInfo(AObj,'Name')<>nil then
      Result:=GetStrProp(AObj,'Name');
    if Length(Result)=0 then
      Result:=TObject(AObj).ClassName;
    {$ENDIF TYPENAMEASMETHODPREF}
    end
  else
    SetLength(Result,0);
  end;

  function GetMethodName(AMethod:TMethod):String;
  var
    AMethodName:String;
  begin
  if AMethod.Data<>nil then
    begin
    Result:=GetObjectName(AMethod.Data);
    AMethodName:=TObject(AMethod.Data).MethodName(AMethod.Code);
    {$IFDEF CPUX64}
    if Length(Result)=0 then
      Result:=IntToHex(Int64(AMethod.Data),16);
    if Length(AMethodName)=0 then
      AMethodName:=IntToHex(Int64(AMethod.Code),16);
    {$ELSE}
    if Length(Result)=0 then
      Result:=IntToHex(IntPtr(AMethod.Data),8);
    if Length(AMethodName)=0 then
      AMethodName:=IntToHex(IntPtr(AMethod.Code),8);
    {$ENDIF CPUX64}
    Result:=Result+'.'+AMethodName;
    end
  else if AMethod.Code<>nil then
    begin
    {$IFDEF CPUX64}
    Result:=IntToHex(Int64(AMethod.Code),16);
    {$ELSE}
    Result:=IntToHex(IntPtr(AMethod.Code),8);
    {$ENDIF CPUX64}
    end
  else
    SetLength(Result,0);
  end;

  procedure AddChildren(AParent:TQJson;AObj:TObject);
  var
    AList:PPropList;
    ACount:Integer;
    I:Integer;
    AChild:TQJson;
    ACharVal:QStringA;
    V:Variant;
    Accept:Boolean;
  begin
  if AObj=nil then
    Exit;
  if PTypeInfo(AObject.ClassInfo)=nil then//����û��RTTI��Ϣ
    Exit;
  AList:=nil;
  ACount:=GetPropList(AObj,AList);
  try
  for I := 0 to ACount-1 do
    begin
    if Assigned(AOnFilter) then
      begin
      Accept:=True;
      {$IFDEF QDAC_RTTI_NAMEFIELD}
      AOnFilter(AParent,AObj,AList[I].NameFld.ToString,AList[I].PropType^,Accept,ATag);
      {$ELSE}
      AOnFilter(AParent,AObj,AList[I].Name,AList[I].PropType^,Accept,ATag);
      {$ENDIF QDAC_RTTI_NAMEFIELD}
      if not Accept then
        Continue;
      end;
    {$IFDEF QDAC_RTTI_NAMEFIELD}
    AChild:=AParent.Add(AList[I].NameFld.ToString);
    {$ELSE}
    AChild:=AParent.Add(AList[I].Name);
    {$ENDIF QDAC_RTTI_NAMEFIELD}
    case AList[I].PropType^.Kind of
      tkChar:
        begin
        ACharVal.Length:=1;
        ACharVal.Chars[0]:=GetOrdProp(AObj, AList[I]);
        AChild.AsString:=ACharVal;
        end;
      tkWChar:
        AChild.AsString:=QCharW(GetOrdProp(AObj, AList[I]));
      tkInteger:
        AChild.AsInteger:=GetOrdProp(AObj, AList[I]);
      tkClass:
        begin
        if ANest then
          AddChildren(AChild,TObject(GetOrdProp(AObj,AList[I])))
        else
          AChild.AsString:=GetObjectName(TObject(GetOrdProp(AObj,AList[I])));
        end;
      tkEnumeration:
        begin
        if GetTypeData(AList[I]^.PropType^)^.BaseType^=TypeInfo(Boolean) then
          AChild.AsBoolean:=Boolean(GetOrdProp(AObj,AList[I]))
        else
          AChild.AsString:=GetEnumProp(AObj,AList[I]);
        end;
      tkSet:
        AChild.AsString:='['+GetSetProp(AObj,AList[I])+']';
      tkFloat:
        AChild.AsFloat:=GetFloatProp(AObj, AList[I]);
      tkMethod:
        AChild.AsString:=GetMethodName(GetMethodProp(AObj,AList[I]));
      {$IFNDEF NEXTGEN}
      tkString, tkLString:
        AChild.AsString := GetStrProp(AObj, AList[I]);
      tkWString:
        AChild.AsString :=GetWideStrProp(AObj, AList[I]);
      {$ENDIF !NEXTGEN}
      {$IFDEF QDAC_UNICODE}
      tkUString:
        AChild.AsString := GetStrProp(AObj, AList[I]);
      {$ENDIF QDAC_UNICODE}
      tkVariant:
        AChild.AsVariant := GetVariantProp(AObj, AList[I]);
      tkInt64:
        AChild.AsInt64 := GetInt64Prop(AObj, AList[I]);
      tkDynArray:
        begin
        DynArrayToVariant(V,GetDynArrayProp(AObj, AList[I]),AList[I].PropType^);
        AChild.AsVariant:=V;
        end;
    end;//End case
    end;//End for
  finally
    if AList<>nil then
      FreeMem(AList);
  end;
  end;
begin
//����RTTIֱ�ӻ�ȡ�����������Ϣ�����浽�����
Result:=Add(AName);
AddChildren(Result,AObject);
end;

function TQJson.AddDateTime(AName: QStringW; AValue: TDateTime): TQJson;
begin
Result:=Add;
Result.FName:=AName;
Result.DataType:=jdtString;
Result.AsDateTime:=AValue;
end;

function TQJson.Add: TQJson;
begin
Result:=CreateJson;
Add(Result);
end;

function TQJson.Add(ANode: TQJson): Integer;
begin
ArrayNeeded(jdtObject);
Result:=FItems.Add(ANode);
ANode.FParent:=Self;
end;

function TQJson.Add(AName, AValue: QStringW;
  ADataType: TQJsonDataType): Integer;
var
  ANode:TQJson;
  p:PQCharW;
  ABuilder:TQStringCatHelperW;
  procedure AddAsDateTime;
  var
    ATime:TDateTime;
  begin
  if ParseDateTime(PQCharW(AValue),ATime) then
    ANode.AsDateTime:=ATime
  else if ParseJsonTime(PQCharW(AValue),ATime) then
    ANode.AsDateTime:=ATime
  else
    raise Exception.Create(SBadJsonTime);
  end;
begin
ANode:=CreateJson;
ANode.FName:=AName;
Result:=Add(ANode);
p:=PQCharW(AValue);
if ADataType=jdtUnknown then
  begin
  ABuilder:=TQStringCatHelperW.Create;
  try
    ANode.ParseValue(ABuilder,p);
  except
    ANode.AsString:=AValue;
  end;
  FreeObject(ABuilder);
  end
else
  begin
  case ADataType of
    jdtString:
      ANode.AsString:=AValue;
    jdtInteger:
      ANode.AsInteger:=StrToInt(AValue);
    jdtFloat:
      ANode.AsFloat:=StrToFloat(AValue);
    jdtBoolean:
      ANode.AsBoolean:=StrToBool(AValue);
    jdtDateTime:
      AddAsDateTime;
    jdtArray:
      begin
      if p^<>'[' then
        raise Exception.CreateFmt(SBadJsonArray,[Value]);
      ANode.ParseObject(p);
      end;
    jdtObject:
      begin
      if p^<>'{' then
        raise Exception.CreateFmt(SBadJsonObject,[Value]);
      ANode.ParseObject(p);
      end;
  end;

  end;
end;

function TQJson.Add(AName: QStringW; ADataType: TQJsonDataType): TQJson;
begin
Result:=Add(AName);
Result.DataType:=ADataType;
end;

function TQJson.Add(const AName: QStringW; AItems: array of const): TQJson;
var
  I:Integer;
begin
Result:=Add(AName,True);
Result.DataType:=jdtArray;
for I := Low(AItems) to High(AItems) do
  begin
  case AItems[I].VType of
    vtInteger:
      Result.Add.AsInteger:=AItems[I].VInteger;
    vtBoolean:
      Result.Add.AsBoolean:=AItems[I].VBoolean;
    {$IFNDEF NEXTGEN}
    vtChar:
      Result.Add.AsString:=QStringW(AItems[I].VChar);
    {$ENDIF !NEXTGEN}
    vtExtended:
      Result.Add.AsFloat:=AItems[I].VExtended^;
    {$IFNDEF NEXTGEN}
    vtPChar:
      Result.Add.AsString:=QStringW(AItems[I].VPChar);
    vtString:
      Result.Add.AsString:=QStringW(AItems[I].VString^);
    vtAnsiString:
      Result.Add.AsString:=QStringW(
        {$IFDEF QDAC_UNICODE}
        PAnsiString(AItems[I].VAnsiString)^
        {$ELSE}
        AItems[I].VPChar
        {$ENDIF QDAC_UNICODE}
        );
    vtWideString:
      Result.Add.AsString:=PWideString(AItems[I].VWideString)^;
    {$ENDIF !NEXTGEN}
    vtPointer:
      Result.Add.AsInt64:=IntPtr(AItems[I].VPointer);
    vtWideChar:
      Result.Add.AsString:=AItems[I].VWideChar;
    vtPWideChar:
      Result.Add.AsString:=AItems[I].VPWideChar;
    vtCurrency:
      Result.Add.AsFloat:=AItems[I].VCurrency^;
    vtInt64:
      Result.Add.AsInt64:=AItems[I].VInt64^;
    {$IFDEF QDAC_UNICODE}       //variants
    vtUnicodeString:
      Result.Add.AsString:=AItems[I].VPWideChar;
    {$ENDIF QDAC_UNICODE}
    vtVariant:
      Result.Add.AsVariant:=AItems[I].VVariant^;
    vtObject:
      begin
      if TObject(AItems[I].VObject) is TQJson then
        Result.Add(TObject(AItems[I].VObject) as TQJson)
      else
        raise Exception.Create(Format(SUnsupportArrayItem,[I]));
      end
    else
      raise Exception.Create(Format(SUnsupportArrayItem,[I]));
  end;//End case
  end;//End for
end;

procedure TQJson.ArrayNeeded(ANewType: TQJsonDataType);
begin
if not (DataType in [jdtArray,jdtObject]) then
  begin
  FDataType:=ANewType;
  ValidArray;
  end;
end;

procedure TQJson.Assign(ANode: TQJson);
var
  I:Integer;
begin
FName:=ANode.FName;
FNameHash:=ANode.FNameHash;
if ANode.FDataType in [jdtArray,jdtObject] then
  begin
  DataType:=ANode.FDataType;
  Clear;
  for I := 0 to ANode.Count - 1 do
    begin
    Add.Assign(ANode[I])
    end;
  end
else
  CopyValue(ANode);
end;

function TQJson.BoolToStr(const b: Boolean): QStringW;
begin
if b then
  Result:='true'
else
  Result:='false';
end;

procedure TQJson.BuildJsonString(ABuilder: TQStringCatHelperW; var p: PQCharW);
var
  AQuoter:QCharW;
  ps:PQCharW;
begin
ABuilder.Position:=0;
if (p^='"') or (p^='''')  then
  begin
  AQuoter:=p^;
  Inc(p);
  ps:=p;
  while p^<>#0 do
    begin
    if (p^=AQuoter) then
      begin
      if ps<>p then
        ABuilder.Cat(ps,p-ps);
      if p[1]=AQuoter then
        begin
        ABuilder.Cat(AQuoter);
        Inc(p,2);
        ps:=p;
        end
      else
        begin
        Inc(p);
        SkipSpaceW(p);
        ps:=p;
        Break;
        end;
      end
    else if p^='\' then
      begin
      if ps<>p then
        ABuilder.Cat(ps,p-ps);
      ABuilder.Cat(CharUnescape(p));
      ps:=p;
      end
    else
      Inc(p);
    end;
  if ps<>p then
    ABuilder.Cat(ps,p-ps);
  end
else
  begin
  while p^<>#0 do
    begin
    if (p^=':') or (p^=']') or (p^=',') or (p^='}') then
      Break
    else
      ABuilder.Cat(p,1);
    Inc(p);
    end
  end;
end;

function TQJson.CharEscape(c: QCharW; pd: PQCharW): Integer;
begin
case c of
  #7:
    begin
    pd[0]:='\';
    pd[1]:='b';
    Result:=2;
    end;
  #9:
    begin
    pd[0]:='\';
    pd[1]:='t';
    Result:=2;
    end;
  #10:
    begin
    pd[0]:='\';
    pd[1]:='n';
    Result:=2;
    end;
  #12:
    begin
    pd[0]:='\';
    pd[1]:='f';
    Result:=2;
    end;
  #13:
    begin
    pd[0]:='\';
    pd[1]:='r';
    Result:=2;
    end;
  '\':
    begin
    pd[0]:='\';
    pd[1]:='\';
    Result:=2;
    end;
  '''':
    begin
    pd[0]:='\';
    pd[1]:='''';
    Result:=2;
    end;
  '"':
    begin
    pd[0]:='\';
    pd[1]:='"';
    Result:=2;
    end;
  '/':
    begin
    pd[0]:='\';
    pd[1]:='/';
    Result:=2;
    end
  else
    begin
    pd[0]:=c;
    Result:=1;
    end;
end;
end;

function TQJson.CharUnescape(var p: PQCharW): QCharW;
  function DecodeOrd:Integer;
  var
    C:Integer;
  begin
  Result:=0;
  C:=0;
  while (p^<>#0) and (C<4) do
    begin
    if IsHexChar(p^) then
      Result:=(Result shl 4)+HexValue(p^)
    else
      Break;
    Inc(p);
    Inc(C);
    end
  end;
begin
if p^=#0 then
  begin
  Result:=#0;
  Exit;
  end;
if p^<>'\' then
  begin
  Result:=p^;
  Inc(p);
  Exit;
  end;
Inc(p);
case p^ of
  'b':
    begin
    Result:=#7;
    Inc(p);
    end;
  't':
    begin
    Result:=#9;
    Inc(p);
    end;
  'n':
    begin
    Result:=#10;
    Inc(p);
    end;
  'f':
    begin
    Result:=#12;
    Inc(p);
    end;
  'r':
    begin
    Result:=#13;
    Inc(p);
    end;
  '\':
    begin
    Result:='\';
    Inc(p);
    end;
  '''':
    begin
    Result:='''';
    Inc(p);
    end;
  '"':
    begin
    Result:='"';
    Inc(p);
    end;
  'u':
    begin
    //\uXXXX
    if IsHexChar(p[1]) and IsHexChar(p[2]) and IsHexChar(p[3]) and IsHexChar(p[4]) then
      begin
      Result:=WideChar((HexValue(p[1]) shl 12) or (HexValue(p[2]) shl 8) or
        (HexValue(p[3]) shl 4) or HexValue(p[4]));
      Inc(p,5);
      end
    else
      raise Exception.CreateFmt(SCharNeeded,['0-9A-Fa-f',StrDupW(p,0,4)]);
    end;
  '/':
    begin
    Result:='/';
    Inc(p);
    end
  else
    begin
    if StrictJson then
      raise Exception.CreateFmt(SCharNeeded,['btfrn"u''/',StrDupW(p,0,4)])
    else
      begin
      Result:=p^;
      Inc(p);
      end;
    end;
  end;
end;

procedure TQJson.Clear;
var
  I:Integer;
begin
if FDataType in [jdtArray,jdtObject] then
  begin
  for I := 0 to Count - 1 do
    FreeJson(FItems[I]);
  FItems.Clear;
  end;
end;

function TQJson.Clone: TQJson;
begin
Result:=Copy;
end;

function TQJson.Copy: TQJson;
begin
Result:=CreateJson;
Result.Assign(Self);
end;
{$IFDEF QDAC_RTTI}
function TQJson.CopyIf(const ATag: Pointer;
  AFilter: TQJsonFilterEventA): TQJson;
  procedure NestCopy(AParentSource,AParentDest:TQJson);
  var
    I:Integer;
    Accept:Boolean;
    AChildSource,AChildDest:TQJson;
  begin
  for I := 0 to AParentSource.Count-1 do
    begin
    Accept:=True;
    AChildSource:=AParentSource[I];
    AFilter(Self,AChildSource,Accept,ATag);
    if Accept then
      begin
      AChildDest:=AParentDest.Add(AChildSource.FName,AChildSource.DataType);
      if AChildSource.DataType in [jdtArray,jdtObject] then
        begin
        AChildDest.DataType:=AChildSource.DataType;
        NestCopy(AChildSource,AChildDest)
        end
      else
        AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;
begin
if Assigned(AFilter) then
  begin
  Result:=CreateJson;
  Result.FName:=Name;
  if DataType in [jdtObject,jdtArray] then
    begin
    NestCopy(Self,Result);
    end
  else
    Result.CopyValue(Self);
  end
else
  Result:=Copy;
end;
{$ENDIF QDAC_RTTI}
function TQJson.CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEvent): TQJson;
  procedure NestCopy(AParentSource,AParentDest:TQJson);
  var
    I:Integer;
    Accept:Boolean;
    AChildSource,AChildDest:TQJson;
  begin
  for I := 0 to AParentSource.Count-1 do
    begin
    Accept:=True;
    AChildSource:=AParentSource[I];
    AFilter(Self,AChildSource,Accept,ATag);
    if Accept then
      begin
      AChildDest:=AParentDest.Add(AChildSource.FName,AChildSource.DataType);
      if AChildSource.DataType in [jdtArray,jdtObject] then
        NestCopy(AChildSource,AChildDest)
      else
        AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;
begin
if Assigned(AFilter) then
  begin
  Result:=CreateJson;
  Result.FName:=Name;
  if DataType in [jdtObject,jdtArray] then
    begin
    NestCopy(Self,Result);
    end
  else
    Result.CopyValue(Self);
  end
else
  Result:=Copy;
end;

procedure TQJson.CopyValue(ASource: TQJson);
var
  L:Integer;
begin
L:=Length(ASource.FValue);
DataType:=ASource.DataType;
SetLength(FValue,L);
if L>0 then
  Move(PQCharW(ASource.FValue)^,PQCharW(FValue)^,L shl 1);
end;

constructor TQJson.Create(const AName, AValue: QStringW;
  ADataType: TQJsonDataType);
begin
inherited Create;
FName:=AName;
if ADataType<>jdtUnknown then
  DataType:=ADataType;
Value:=AValue;
end;

function TQJson.CreateJson: TQJson;
begin
if Assigned(OnQJsonCreate) then
  Result:=OnQJsonCreate
else
  Result:=TQJson.Create;
end;

constructor TQJson.Create;
begin
inherited;
end;

procedure TQJson.Delete(AName: QStringW);
var
  I:Integer;
begin
I:=IndexOf(AName);
if I<>-1 then
  Delete(I);
end;
{$IFDEF QDAC_RTTI}
procedure TQJson.DeleteIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEventA);
  procedure DeleteChildren(AParent:TQJson);
  var
    I:Integer;
    Accept:Boolean;
    AChild:TQJson;
  begin
  I:=0;
  while I<AParent.Count do
    begin
    Accept:=True;
    AChild:=AParent.Items[I];
    if ANest then
      DeleteChildren(AChild);
    AFilter(Self,AChild,Accept,ATag);
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
{$ENDIF QDAC_RTTI}
procedure TQJson.DeleteIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEvent);
  procedure DeleteChildren(AParent:TQJson);
  var
    I:Integer;
    Accept:Boolean;
    AChild:TQJson;
  begin
  I:=0;
  while I<AParent.Count do
    begin
    Accept:=True;
    AChild:=AParent.Items[I];
    if ANest then
      DeleteChildren(AChild);
    AFilter(Self,AChild,Accept,ATag);
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

procedure TQJson.Delete(AIndex: Integer);
begin
if FDataType in [jdtArray,jdtObject] then
  begin
  FreeJson(Items[AIndex]);
  FItems.Delete(AIndex);
  end
else
  raise Exception.Create(Format(SNotArrayOrObject,[FName]));
end;

destructor TQJson.Destroy;
begin
if DataType in [jdtArray,jdtObject] then
  begin
  Clear;
  FreeObject(FItems);
  end;
inherited;
end;

function TQJson.Encode(ADoFormat: Boolean; AIndent: QStringW): QStringW;
var
  ABuilder:TQStringCatHelperW;
begin
ABuilder:=TQStringCatHelperW.Create;
try
  InternalEncode(ABuilder,ADoFormat,AIndent);
  ABuilder.Back(1);//ɾ�����һ������
  Result:=ABuilder.Value;
finally
  FreeObject(ABuilder);
end;
end;
{$IFDEF QDAC_RTTI}
function TQJson.FindIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEventA): TQJson;
  function DoFind(AParent:TQJson):TQJson;
  var
    I:Integer;
    AChild:TQJson;
    Accept:Boolean;
  begin
  Result:=nil;
  for I := 0 to AParent.Count-1 do
    begin
    AChild:=AParent[I];
    Accept:=True;
    AFilter(Self,AChild,Accept,ATag);
    if Accept then
      Result:=AChild
    else if ANest then
      Result:=DoFind(AChild);
    if Result<>nil then
      Break;
    end;
  end;
begin
if Assigned(AFilter) then
  Result:=DoFind(Self)
else
  Result:=nil;
end;
{$ENDIF QDAC_RTTI}

function TQJson.FindIf(const ATag: Pointer; ANest: Boolean;
  AFilter: TQJsonFilterEvent): TQJson;
  function DoFind(AParent:TQJson):TQJson;
  var
    I:Integer;
    AChild:TQJson;
    Accept:Boolean;
  begin
  Result:=nil;
  for I := 0 to AParent.Count-1 do
    begin
    AChild:=AParent[I];
    Accept:=True;
    AFilter(Self,AChild,Accept,ATag);
    if Accept then
      Result:=AChild
    else if ANest then
      Result:=DoFind(AChild);
    if Result<>nil then
      Break;
    end;
  end;
begin
if Assigned(AFilter) then
  Result:=DoFind(Self)
else
  Result:=nil;
end;

function TQJson.ForcePath(APath: QStringW): TQJson;
var
  AName:QStringW;
  p,pn,ws:PQCharW;
  AParent:TQJson;
  L:Integer;
  AIndex:Int64;
const
  PathDelimiters:PWideChar='./\';
begin
p:=PQCharW(APath);
AParent:=Self;
Result:=Self;
while p^<>#0 do
  begin
  AName:=DecodeTokenW(p,PathDelimiters,WideChar(0),True);
  if not (AParent.DataType in [jdtObject,jdtArray]) then
    AParent.DataType:=jdtObject;
  Result:=AParent.ItemByName(AName);
  if not Assigned(Result) then
    begin
    pn:=PQCharW(AName);
    L:=Length(AName);
    AIndex:=-1;
    if (pn[L-1]=']') then
      begin
      repeat
        if pn[L]='[' then
          begin
          ws:=pn+L+1;
          ParseInt(ws,AIndex);
          Break;
          end
        else
          Dec(L);
      until L=0;
      if L>0 then
        begin
        AName:=StrDupX(pn,L);
        Result:=AParent.ItemByName(AName);
        if Result=nil then
          Result:=AParent.Add(AName,jdtArray)
        else if Result.DataType<>jdtArray then
          raise Exception.CreateFmt(SBadJsonArray,[AName]);
        if AIndex>=0 then
          begin
          while Result.Count<=AIndex do
            Result.Add;
          Result:=Result[AIndex];
          end;
        end
      else
        raise Exception.CreateFmt(SBadJsonName,[AName]);
      end
    else
      Result:=AParent.Add(AName);
    end;
  AParent:=Result;
  end;
end;

procedure TQJson.FreeJson(AJson:TQJson);
begin
if Assigned(OnQJsonFree) then
  OnQJsonFree(AJson)
else
  FreeObject(AJson);
end;

function TQJson.GetAsArray: QStringW;
begin
if DataType=jdtArray then
  Result:=Value
else
  raise Exception.Create(Format(SBadConvert,[AsString,'Array']));
end;

function TQJson.GetAsBoolean: Boolean;
begin
if DataType = jdtBoolean then
  Result:=PBoolean(FValue)^
else if DataType = jdtString then
  begin
  if not TryStrToBool(FValue,Result) then
    raise Exception.Create(Format(SBadConvert,[FValue,'Boolean']));
  end
else if DataType in [jdtFloat,jdtDateTime] then
  Result:=not SameValue(AsFloat,0)
else if DataType = jdtInteger then
  Result:=AsInt64<>0
else
  raise Exception.Create(Format(SBadConvert,[JsonTypeName[Integer(DataType)],'Boolean']));
end;

function TQJson.GetAsDateTime: TDateTime;
begin
if DataType in [jdtDateTime,jdtFloat] then
  Result:=PExtended(FValue)^
else if DataType=jdtString then
  begin
  if not (ParseDateTime(PWideChar(FValue),Result) or ParseJsonTime(PWideChar(FValue),Result)
    or ParseWebTime(PQCharW(FValue),Result)) then
      raise Exception.Create(Format(SBadConvert,['String','DateTime']))
  end
else if DataType=jdtInteger then
  Result:=AsInt64
else
  raise Exception.Create(Format(SBadConvert,[JsonTypeName[Integer(DataType)],'DateTime']));
end;

function TQJson.GetAsFloat: Extended;
begin
if DataType in [jdtFloat,jdtDateTime] then
  Result:=PExtended(FValue)^
else if DataType = jdtBoolean then
  Result:=Integer(AsBoolean)
else if DataType = jdtString then
  begin
  if not TryStrToFloat(FValue,Result) then
    raise Exception.Create(Format(SBadConvert,[FValue,'Numeric']));
  end
else if DataType =  jdtInteger then
  Result:=AsInt64
else if DataType = jdtNull then
  Result:=0
else
  raise Exception.Create(Format(SBadConvert,[JsonTypeName[Integer(DataType)],'Numeric']))
end;

function TQJson.GetAsInt64: Int64;
begin
if DataType =  jdtInteger then
  Result:=PInt64(FValue)^
else if DataType in [jdtFloat,jdtDateTime] then
  Result:=Trunc(PExtended(FValue)^)
else if DataType = jdtBoolean then
  Result:=Integer(AsBoolean)
else if DataType = jdtString then
  Result:=Trunc(AsFloat)
else if DataType = jdtNull then
  Result:=0
else
  raise Exception.Create(Format(SBadConvert,[JsonTypename[Integer(DataType)],'Numeric']))
end;

function TQJson.GetAsInteger: Integer;
begin
Result:=GetAsInt64;
end;

function TQJson.GetAsJson: QStringW;
begin
Result:=Encode(True,'  ');
end;

function TQJson.GetAsObject: QStringW;
begin
if DataType=jdtObject then
  Result:=Value
else
  raise Exception.Create(Format(SBadConvert,[AsString,'Object']));
end;

function TQJson.GetAsString: QStringW;
begin
Result:=Value;
end;

function TQJson.GetAsValue: TValue;
  procedure AsDynValueArray;
  var
    AValues:TValueArray;
    I:Integer;
  begin
  SetLength(AValues,Count);
  for I := 0 to Count-1 do
    AValues[I]:=Items[I].AsValue;
  Result:=TValue.FromArray(TypeInfo(TValueArray),AValues);
  end;
begin
case DataType of
  jdtString:
    Result:=AsString;
  jdtInteger:
    Result:=AsInt64;
  jdtFloat:
    Result:=AsFloat;
  jdtDateTime:
    Result:=AsDateTime;
  jdtBoolean:
    Result:=AsBoolean;
  jdtArray,jdtObject://����Ͷ���ֻ�ܵ�������������
    AsDynValueArray
  else
    Result:=TValue.Empty;
end;
end;

function TQJson.GetAsVariant: Variant;
var
  I:Integer;
begin
case DataType of
  jdtString:
    Result:=AsString;
  jdtInteger:
    Result:=AsInt64;
  jdtFloat:
    Result:=AsFloat;
  jdtDateTime:
    Result:=AsDateTime;
  jdtBoolean:
    Result:=AsBoolean;
  jdtArray,jdtObject:
    begin
    Result:=VarArrayCreate([0,Count-1],varVariant);
    for I := 0 to Count-1 do
      Result[I]:=Items[I].AsVariant;
    end
  else
    VarClear(Result);
end;
end;

function TQJson.GetCount: Integer;
begin
if DataType in [jdtObject,jdtArray] then
  Result:=FItems.Count
else
  Result:=0;
end;

function TQJson.GetEnumerator: TQJsonEnumerator;
begin
Result:=TQJsonEnumerator.Create(Self);
end;

function TQJson.GetIsArray: Boolean;
begin
Result:=(DataType=jdtArray);
end;

function TQJson.GetIsDateTime: Boolean;
var
  ATime:TDateTime;
begin
Result:=(DataType=jdtDateTime);
if not Result then
  begin
  if DataType=jdtString then
    Result:=ParseDateTime(PQCharW(FValue),ATime) or
      ParseJsonTime(PQCharW(FValue),ATime) or ParseWebTime(PQCharW(FValue),ATime)
  end;
end;

function TQJson.GetIsNull: Boolean;
begin
Result:=(DataType=jdtNull);
end;

function TQJson.GetIsNumeric: Boolean;
begin
Result:=(DataType in [jdtInteger,jdtFloat]);
end;

function TQJson.GetIsObject: Boolean;
begin
Result:=(DataType=jdtObject);
end;

function TQJson.GetIsString: Boolean;
begin
Result:=(DataType=jdtString);
end;

function TQJson.GetItemIndex: Integer;
var
  I:Integer;
begin
Result:=-1;
if Assigned(Parent) then
  begin
  for I := 0 to Parent.Count-1 do
    begin
    if Parent.Items[I]=Self then
      begin
      Result:=I;
      Break;
      end;
    end;
  end;
end;

function TQJson.GetItems(AIndex: Integer): TQJson;
begin
Result:=FItems[AIndex];
end;

function TQJson.GetPath: QStringW;
var
  AParent,AItem:TQJson;
begin
AParent:=FParent;
AItem:=Self;
repeat
  if Assigned(AParent) and AParent.IsArray then
    Result:='['+IntToStr(AItem.ItemIndex)+']'+Result
  else if AItem.IsArray then
    Result:='\'+AItem.FName+Result
  else
    Result:='\'+AItem.FName+Result;
  AItem:=AParent;
  AParent:=AItem.Parent;
until AParent=nil;
if Length(Result)>0 then
  Result:=StrDupX(PQCharW(Result)+1,Length(Result)-1);
end;

function TQJson.GetValue: QStringW;
  procedure ValueAsDateTime;
  var
    ADate:Integer;
    AValue:Extended;
  begin
  AValue:=PExtended(FValue)^;
  ADate:=Trunc(AValue);
  if SameValue(ADate,0) then//DateΪ0����ʱ��
    begin
    if SameValue(AValue,0) then
      Result:=FormatDateTime(JsonDateFormat,AValue)
    else
      Result:=FormatDateTime(JsonTimeFormat,AValue);
    end
  else
    begin
    if SameValue(AValue-ADate,0) then
      Result:=FormatDateTime(JsonDateFormat,AValue)
    else
      Result:=FormatDateTime(JsonDateTimeFormat,AValue);
    end;
  end;
begin
case DataType of
  jdtNull,jdtUnknown:
    Result:='null';
  jdtString:
    Result:=FValue;
  jdtInteger:
    Result:=IntToStr(PInt64(FValue)^);
  jdtFloat:
    Result:=FloatToStr(PExtended(FValue)^);
  jdtDateTime:
    ValueAsDateTime;
  jdtBoolean:
    Result:=BoolToStr(PBoolean(FValue)^);
  jdtArray,jdtObject:
    Result:=Encode(True);
end;
end;

function TQJson.IndexOf(const AName: QStringW): Integer;
var
  I,L:Integer;
  AItem:TQJson;
  AHash:Cardinal;
begin
Result:=-1;
L:=Length(AName);
if L>0 then
  AHash:=HashOf(PQCharW(AName),L shl 1)
else
  AHash:=0;
for I := 0 to Count - 1 do
  begin
  AItem:=Items[I];
  if Length(AItem.FName)=L then
    begin
    if JsonCaseSensitive then
      begin
      if AItem.FNameHash=0 then
        AItem.FNameHash:=HashOf(PQCharW(AItem.FName),L shl 1);
      if AItem.FNameHash=AHash then
        begin
        if AItem.FName=AName then
          begin
          Result:=I;
          break;
          end;
        end;
      end
    else if StartWithW(PQCharW(AItem.FName),PQCharW(AName),True) then
      begin
      Result:=I;
      break;
      end;
    end;
  end;
end;
{$IFDEF QDAC_RTTI}
function TQJson.InternalAddRecord(ATypeInfo: PTypeInfo;
  ABaseAddr: Pointer;AOnFilter:TQJsonRttiFilterEvent;ATag:Pointer): Boolean;
var
  AContext:TRttiContext;
  AType:TRttiType;
  I:Integer;
  AFields:TArray<TRttiField>;
  AChild:TQJson;
  Accept:Boolean;
  function ValueToVariant(AValue:TValue):Variant;
  var
    J,L:Integer;
    AItemValue:TValue;
  begin
  L:=AValue.GetArrayLength;
  Result:=VarArrayCreate([0,L-1],varVariant);
  for J := 0 to L-1 do
    begin
    AItemValue:=AValue.GetArrayElement(J);
    if AItemValue.IsArray then
      Result[J]:=ValueToVariant(AItemValue)
    else
      Result[J]:=AItemValue.AsVariant;
    end;
  end;

  function ParseDynArray:Variant;
  var
    AValue:TValue;
  begin
  AValue:=AFields[I].GetValue(ABaseAddr);
  if AValue.IsArray then
    Result:=ValueToVariant(AValue)
  else
    VarClear(Result);
  end;
begin
Result:=False;
if Assigned(ATypeInfo) then
  begin
  AType:=AContext.GetType(ATypeInfo);
  if AType<>nil then
    begin
    if AType.TypeKind=tkRecord then
      begin
      Result:=True;
      AFields:=AType.GetFields;
      for I := Low(AFields) to High(AFields) do
        begin
        Accept:=True;
        if Assigned(AOnFilter) then
          AOnFilter(Self,ABaseAddr,AFields[I].Name,AFields[I].FieldType.Handle,Accept,ATag);
        if not Accept then
          Continue;
        AChild:=Add(AFields[I].Name);
        case AFields[I].FieldType.TypeKind of
          tkInteger,tkInt64:
            AChild.AsInt64:=AFields[I].GetValue(ABaseAddr).AsInt64;
          tkUString{$IFNDEF NEXTGEN},tkString,tkLString,tkWString,tkChar,tkWChar{$ENDIF !NEXTGEN}:
            AChild.AsString:=AFields[I].GetValue(ABaseAddr).ToString;
          tkRecord:
            AChild.InternalAddRecord(AFields[I].FieldType.Handle,Pointer(IntPtr(ABaseAddr)+AFields[I].Offset),AOnFilter,ATag);
          tkEnumeration:
            AChild.AsString:=AFields[I].GetValue(ABaseAddr).ToString;
          tkSet:
            AChild.AsString:=AFields[I].GetValue(ABaseAddr).ToString;
          tkFloat:
            begin
            if (AFields[I].FieldType.Handle=TypeInfo(TDate)) or
              (AFields[I].FieldType.Handle=TypeInfo(TTime)) or
              (AFields[I].FieldType.Handle=TypeInfo(TDateTime))
             then
              AChild.AsDateTime:=AFields[I].GetValue(ABaseAddr).AsExtended
            else
              AChild.AsFloat:=AFields[I].GetValue(ABaseAddr).AsExtended;
            end;
          tkVariant:
            AChild.AsVariant:=AFields[I].GetValue(ABaseAddr).AsVariant;
          tkArray,tkDynArray:
            AChild.AsVariant:=ParseDynArray;
          tkClass,tkMethod,tkInterface,tkClassRef,tkPointer,tkProcedure:
            AChild.AsString:='<OBJECT>';
        end;
        end;
      end;
    end;
  end;
end;
{$ENDIF QDAC_RTTI}

function TQJson.InternalEncode(ABuilder: TQStringCatHelperW; ADoFormat: Boolean;
  const AIndent: QStringW): TQStringCatHelperW;
  procedure CatValue(const AValue:QStringW);
  var
    ps:PQCharW;
  const
    CharNum1:PWideChar='1';
    CharNum0:PWideChar='0';
    Char7:PWideChar='\b';
    Char9:PWideChar='\t';
    Char10:PWideChar='\n';
    Char12:PWideChar='\f';
    Char13:PWideChar='\r';
    CharQuoter:PWideChar='\"';
    CharBackslash:PWidechar='\\';
    CharCode:PWideChar='\u00';
  begin
  ps:=PQCharW(AValue);
  while ps^<>#0 do
    begin
    case ps^ of
      #7:
        ABuilder.Cat(Char7,2);
      #9:
        ABuilder.Cat(Char9,2);
      #10:
        ABuilder.Cat(Char10,2);
      #12:
        ABuilder.Cat(Char12,2);
      #13:
        ABuilder.Cat(Char13,2);
      '\':
        ABuilder.Cat(CharBackslash,2);
      '"':
        ABuilder.Cat(CharQuoter,2);
      else
        begin
        if ps^<#$1F then
          begin
          ABuilder.Cat(CharCode,4);
          if ps^>#$F then
            ABuilder.Cat(CharNum1,1)
          else
            ABuilder.Cat(CharNum0,1);
          ABuilder.Cat(HexChar(Ord(ps^) and $0F));
          end
        else
          ABuilder.Cat(ps,1);
        end;
      end;
    Inc(ps);
    end;
  end;

  procedure StrictJsonTime(ATime:TDateTime);
  var
    MS:Int64;//ʱ����Ϣ������
  const
    JsonTimeStart:PWideChar='"/DATE(';
    JsonTimeEnd:PWideChar=')/"';
  begin
  MS:=Trunc(ATime*86400000);
  ABuilder.Cat(JsonTimeStart,7);
  ABuilder.Cat(IntToStr(MS));
  ABuilder.Cat(JsonTimeEnd,3);
  end;

  procedure DoEncode(ANode:TQJson;ALevel:Integer);
  var
    I:Integer;
    ArrayWraped:Boolean;
    AChild:TQJson;
  const
    CharStringStart:PWideChar='"';
    CharStringEnd:PWideChar='",';
    CharNameEnd:PWideChar='":';
    CharArrayStart:PWideChar='[';
    CharArrayEnd:PWideChar='],';
    CharObjectStart:PWideChar='{';
    CharObjectEnd:PWideChar='},';
    CharNull:PWideChar='null,';
    CharFalse:PWideChar='false,';
    CharTrue:PWideChar='true,';
    CharComma:PWideChar=',';
  begin
  if (ANode.Parent<>nil) and (ANode.Parent.DataType<>jdtArray) and (Length(ANode.FName)>0) then
    begin
    if ADoFormat then
      ABuilder.Replicate(AIndent,ALevel);
    ABuilder.Cat(CharStringStart,1);
    CatValue(ANode.FName);
    ABuilder.Cat(CharNameEnd,2);
    end;
  case ANode.DataType of
    jdtArray:
      begin
      ABuilder.Cat(CharArrayStart,1);
      if ANode.Count>0 then
        begin
        ArrayWraped:=False;
        for I := 0 to ANode.Count - 1 do
          begin
          AChild:=ANode.Items[I];
          if AChild.DataType in [jdtArray,jdtObject] then
            begin
            if ADoFormat then
              begin
              ABuilder.Cat(SLineBreak);//���ڶ�������飬����
              ABuilder.Replicate(AIndent,ALevel+1);
              ArrayWraped:=True;
              end;
            end;
          DoEncode(AChild,ALevel+1);
          end;
        ABuilder.Back(1);
        if ArrayWraped then
          begin
          ABuilder.Cat(SLineBreak);
          ABuilder.Replicate(AIndent,ALevel);
          end;
        end;
        ABuilder.Cat(CharArrayEnd,2);
      end;
    jdtObject:
      begin
      if ADoFormat then
        begin
        ABuilder.Cat(CharObjectStart,1);
        ABuilder.Cat(SLineBreak);
        end
      else
        ABuilder.Cat(CharObjectStart,1);
      if ANode.Count>0 then
        begin
        for I := 0 to ANode.Count - 1 do
          begin
          AChild:=ANode.Items[I];
          if Length(AChild.Name)=0 then
            raise Exception.CreateFmt(SObjectChildNeedName,[ANode.Name,I]);
          DoEncode(AChild,ALevel+1);
          if ADoFormat then
            ABuilder.Cat(SLineBreak);
          end;
        if ADoFormat then
          ABuilder.Back(Length(SLineBreak)+1)
        else
          ABuilder.Back(1);
        end;
      if ADoFormat then
        begin
        ABuilder.Cat(SLineBreak);
        ABuilder.Replicate(AIndent,ALevel);
        end;
      ABuilder.Cat(CharObjectEnd,2);
      end;
    jdtNull,jdtUnknown:
      ABuilder.Cat(CharNull,5);
    jdtString:
      begin
      ABuilder.Cat(CharStringStart,1);
      CatValue(ANode.FValue);
      ABuilder.Cat(CharStringEnd,2);
      end;
    jdtInteger,jdtFloat,jdtBoolean:
      begin
      ABuilder.Cat(ANode.Value);
      ABuilder.Cat(CharComma,1);
      end;
    jdtDateTime:
      begin
      ABuilder.Cat(CharStringStart,1);
      if StrictJson then
        StrictJsonTime(ANode.AsDateTime)
      else
        ABuilder.Cat(ANode.Value);
      ABuilder.Cat(CharStringEnd,1);
      ABuilder.Cat(CharComma,1);
      end;
    end;
  end;
begin
Result:=ABuilder;
DoEncode(Self,0);
end;

procedure TQJson.InternalRttiFilter(ASender: TQJson; AObject: Pointer;
  APropName: QStringW; APropType: PTypeInfo; var Accept: Boolean; ATag: Pointer);
var
  ATagData:PQJsonInternalTagData;
  procedure DoNameFilter;
  var
    ps:PQCharW;
  begin
  if Length(ATagData.AcceptNames)>0 then
    begin
    Accept:=False;
    ps:=StrIStrW(PQCharW(ATagData.AcceptNames),PQCharW(APropName));
    if (ps<>nil) and ((ps=PQCharW(ATagData.AcceptNames)) or (ps[-1]=',') or (ps[-1]=';')) then
      begin
      ps:=ps+Length(APropName);
      Accept:=(ps^=',') or (ps^=';') or (ps^=#0);
      end;
    end
  else if Length(ATagData.IgnoreNames)>0 then
    begin
    ps:=StrIStrW(PQCharW(ATagData.IgnoreNames),PQCharW(APropName));
    Accept:=True;
    if (ps<>nil) and ((ps=PQCharW(ATagData.IgnoreNames)) or (ps[-1]=',') or (ps[-1]=';')) then
      begin
      ps:=ps+Length(APropName);
      Accept:=not ((ps^=',') or (ps^=';') or (ps^=#0));
      end;
    end;
  end;
begin
ATagData:=PQJsonInternalTagData(ATag);
if ATagData.TagType=ttNameFilter then
  begin
  DoNameFilter;
  Exit;
  end;
{$IFDEF QDAC_RTTI}
if ATagData.TagType=ttAnonEvent then
  begin
  ATagData.OnEvent(ASender,AObject,APropName,APropType,Accept,ATagData.Tag);
  end;
{$ENDIF}
end;

function TQJson.Invoke(Instance: TObject): TValue;
var
  AMethods:TArray<TRttiMethod>;
  AParams:TArray<TRttiParameter>;
  AMethod:TRttiMethod;
  AType:TRttiType;
  AContext:TRttiContext;
  AParamValues:TValueArray;
  I: Integer;
begin
AContext:=TRttiContext.Create;
AType:=AContext.GetType(Instance.ClassInfo);
AMethods:=AType.GetMethods(Name);
Result:=TValue.Empty;
for AMethod in AMethods do
  begin
  AParams:=AMethod.GetParameters;
  if Length(AParams)=Count then
    begin
    SetLength(AParamValues,Count);
    for I := 0 to Count-1 do
      AParamValues[I]:=Items[I].AsValue;
    Result:=AMethod.Invoke(Instance,AParamValues);
    end;
  end;
end;

function TQJson.Invoke(Instance: TClass): TValue;
var
  AMethods:TArray<TRttiMethod>;
  AParams:TArray<TRttiParameter>;
  AMethod:TRttiMethod;
  AType:TRttiType;
  AContext:TRttiContext;
  AParamValues:TValueArray;
  I: Integer;
begin
AContext:=TRttiContext.Create;
AType:=AContext.GetType(Instance);
AMethods:=AType.GetMethods(Name);
Result:=TValue.Empty;
for AMethod in AMethods do
  begin
  AParams:=AMethod.GetParameters;
  if Length(AParams)=Count then
    begin
    SetLength(AParamValues,Count);
    for I := 0 to Count-1 do
      AParamValues[I]:=Items[I].AsValue;
    Result:=AMethod.Invoke(Instance,AParamValues);
    end;
  end;
end;


function TQJson.IsChildOf(AParent: TQJson): Boolean;
begin
if Assigned(AParent) then
  begin
  if AParent=FParent then
    Result:=True
  else
    Result:=FParent.IsChildOf(AParent);
  end
else
  Result:=False;
end;

function TQJson.IsParentOf(AChild: TQJson): Boolean;
begin
if Assigned(AChild) then
  Result:=AChild.IsChildOf(Self)
else
  Result:=False;
end;

function TQJson.ItemByName(AName: QStringW): TQJson;
var
  AChild:TQJson;
  I:Integer;
  ASelfName:String;
  function ArrayName:String;
  var
    ANamedItem:TQJson;
    AParentIndexes:String;
  begin
  ANamedItem:=Self;
  while ANamedItem.Parent<>nil do
    begin
    if ANamedItem.Parent.IsArray then
      begin
      AParentIndexes:=AParentIndexes+'['+IntToStr(ANamedItem.ItemIndex)+']';
      ANamedItem:=ANamedItem.Parent;
      end
    else
      Break;
    end;
  Result:=ANamedItem.Name+AParentIndexes;
  end;
begin
Result:=nil;
if DataType=jdtObject then
  begin
  I:=IndexOf(AName);
  if I<>-1 then
    Result:=Items[I];
//  else
//  for I := 0 to Count - 1 do
//    begin
//    AChild:=Items[I];
//    if CompareJsonName(AChild.Name,AName) then
//      begin
//      Result:=AChild;
//      Exit;
//      end
//    else if AChild.IsArray then
//      begin
//      Result:=AChild.ItemByName(AName);
//      if Assigned(Result) then
//        Exit;
//      end;
//    end;
  end
else if DataType=jdtArray then
  begin
  ASelfName:=ArrayName;
  for I := 0 to Count-1 do
    begin
    AChild:=Items[I];
    if ASelfName+'['+IntToStr(I)+']'=AName then
      begin
      Result:=AChild;
      Exit;
      end
    else if AChild.IsArray then
      begin
      Result:=AChild.ItemByName(AName);
      if Assigned(Result) then
        Exit;
      end
    else
    end;
  end;
end;

function TQJson.ItemByName(const AName: QStringW; AList: TQJsonItemList;
  ANest: Boolean): Integer;
var
  ANode:TQJson;
  function InternalFind(AParent:TQJson):Integer;
  var
    I:Integer;
  begin
  Result:=0;
  for I := 0 to AParent.Count-1 do
    begin
    ANode:=AParent.Items[I];
    if ANode.Name=AName then
      begin
      AList.Add(ANode);
      Inc(Result);
      end;
    if ANest then
      Inc(Result,InternalFind(ANode));
    end;
  end;
begin
Result:=InternalFind(Self);
end;

function TQJson.ItemByPath(APath: QStringW): TQJson;
var
  AParent:TQJson;
  AName:QStringW;
  p,pn,ws:PQCharW;
  L:Integer;
  AIndex:Int64;
const
  PathDelimiters:PWideChar='./\';
begin
AParent:=Self;
p:=PQCharW(APath);
Result:=nil;
while Assigned(AParent) and (p^<>#0) do
  begin
  AName:=DecodeTokenW(p,PathDelimiters,WideChar(0),False);
  if Length(AName)>0 then
    begin
    //���ҵ������飿
    L:=Length(AName);
    AIndex:=-1;
    pn:=PQCharW(AName);
    if (pn[L-1]=']') then
      begin
      repeat
        if pn[L]='[' then
          begin
          ws:=pn+L+1;
          ParseInt(ws,AIndex);
          Break;
          end
        else
          Dec(L);
      until L=0;
      if L>0 then
        begin
        AName:=StrDupX(pn,L);
        Result:=AParent.ItemByName(AName);
        if Result<>nil then
          begin
          if Result.DataType<>jdtArray then
            Result:=nil
          else if (AIndex>=0) and (AIndex<Result.Count) then
            Result:=Result[AIndex];
          end;
        end;
      end
    else
      Result:=AParent.ItemByName(AName);
    if Assigned(Result) then
      AParent:=Result
    else
      begin
      Exit;
      end;
    end;
  if CharInW(p,PathDelimiters) then
    Inc(p);
  //������..��//\\��·��������
  end;
if p^<>#0 then
  Result:=nil;
end;

function TQJson.ItemByRegex(const ARegex: QStringW; AList: TQJsonItemList;
  ANest: Boolean): Integer;
var
  ANode:TQJson;
{$IFDEF QDAC_UNICODE}
  APcre:TPerlRegEx;
{$ENDIF}
  function InternalFind(AParent:TQJson):Integer;
  var
    I:Integer;
  begin
  Result:=0;
  for I := 0 to AParent.Count-1 do
    begin
    ANode:=AParent.Items[I];
    {$IFDEF QDAC_UNICODE}
    APcre.Subject:=ANode.Name;
    if APcre.Match then
    {$ELSE}
    if ANode.Name=ARegex then
    {$ENDIF}
      begin
      AList.Add(ANode);
      Inc(Result);
      end;
    if ANest then
      Inc(Result,InternalFind(ANode));
    end;
  end;
begin
{$IFDEF QDAC_UNICODE}
APcre:=TPerlRegex.Create;
try
  APcre.RegEx:=ARegex;
  APcre.Compile;
  Result:=InternalFind(Self);
finally
  FreeObject(APcre);
end;
{$ELSE}
raise Exception.Create(Format(SNotSupport,['ItemByRegex']));
{$ENDIF}
end;

procedure TQJson.LoadFromFile(AFileName: String;AEncoding:TTextEncoding);
var
  AStream:TFileStream;
begin
AStream:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(AStream);
finally
  FreeObject(AStream);
end;
end;

procedure TQJson.LoadFromStream(AStream: TStream;AEncoding:TTextEncoding);
var
  S:QStringW;
begin
S:=LoadTextW(AStream,AEncoding);
if Length(S)>2 then
  Parse(PQCharW(S),Length(S))
else
  raise Exception.Create(SBadJson);
end;

procedure TQJson.Parse(p: PWideChar; l: Integer);
  procedure ParseCopy;
  var
    S:QStringW;
  begin
  S:=StrDupW(p,0,l);
  p:=PQCharW(S);
  ParseObject(p);
  end;
begin
if DataType in [jdtObject,jdtArray] then
  Clear;
if (l>0) and (p[l]<>#0) then
  ParseCopy
else
  ParseObject(p);
end;

procedure TQJson.Parse(const s: QStringW);
begin
Parse(PQCharW(S),Length(S));
end;

procedure TQJson.ParseBlock(AStream: TStream; AEncoding: TTextEncoding);
var
  AMS:TMemoryStream;
  procedure ParseUCS2;
  var
    c:QCharW;
    ABlockCount:Integer;
  begin
  ABlockCount:=0;
  repeat
    if ABlockCount=0 then
      begin
      repeat
        AStream.ReadBuffer(c,SizeOf(QCharW));
        AMS.WriteBuffer(c,SizeOf(QCharW));
      until c='{';
      Inc(ABlockCount);
      end;
    AStream.ReadBuffer(c,SizeOf(QCharW));
    if c='{' then
      Inc(ABlockCount)
    else if c='}' then
      Dec(ABlockCount);
    AMS.WriteBuffer(c,SizeOf(QCharW));
  until ABlockCount=0;
  c:=#0;
  AMS.Write(c,SizeOf(QCharW));
  Parse(AMS.Memory,AMS.Size-1);
  end;

  procedure ParseUCS2BE;
  var
    c:Word;
    ABlockCount:Integer;
    p:PQCharW;
  begin
  ABlockCount:=0;
  repeat
    if ABlockCount=0 then
      begin
      repeat
        AStream.ReadBuffer(c,SizeOf(Word));
        c:=(c shr 8) or ((c shl 8) and $FF00);
        AMS.WriteBuffer(c,SizeOf(Word));
      until c=$7B;//#$7B={
      Inc(ABlockCount);
      end;
    AStream.ReadBuffer(c,SizeOf(Word));
    c:=(c shr 8) or ((c shl 8) and $FF00);
    if c=$7B then
      Inc(ABlockCount)
    else if c=$7D then//#$7D=}
      Dec(ABlockCount);
    AMS.WriteBuffer(c,SizeOf(QCharW));
  until ABlockCount=0;
  c:=0;
  AMS.Write(c,SizeOf(QCharW));
  p:=AMS.Memory;
  ParseObject(p);
  end;

  procedure ParseByByte;
  var
    c:Byte;
    ABlockCount:Integer;
  begin
  ABlockCount:=0;
  repeat
    if ABlockCount=0 then
      begin
      repeat
        AStream.ReadBuffer(c,SizeOf(Byte));
        AMS.WriteBuffer(c,SizeOf(Byte));
      until c=$7B;//#$7B={
      Inc(ABlockCount);
      end;
    AStream.ReadBuffer(c,SizeOf(Byte));
    if c=$7B then
      Inc(ABlockCount)
    else if c=$7D then//#$7D=}
      Dec(ABlockCount);
    AMS.WriteBuffer(c,SizeOf(Byte));
  until ABlockCount=0;
  end;

  procedure ParseUtf8;
  var
    S:QStringW;
    p:PQCharW;
  begin
  ParseByByte;
  S:=QString.Utf8Decode(AMS.Memory,AMS.Size);
  p:=PQCharW(S);
  ParseObject(p);
  end;

  procedure ParseAnsi;
  var
    S:QStringW;
  begin
  ParseByByte;
  S:=QString.AnsiDecode(AMS.Memory,AMS.Size);
  Parse(PQCharW(S));
  end;

begin
AMS:=TMemoryStream.Create;
try
  if AEncoding=teAnsi then
    ParseAnsi
  else if AEncoding=teUtf8 then
    ParseUtf8
  else if AEncoding=teUnicode16LE then
    ParseUCS2
  else if AEncoding=teUnicode16BE then
    ParseUCS2BE
  else
    raise Exception.Create(SBadJsonEncoding);
finally
  AMS.Free;
end;
end;

procedure TQJson.ParseJsonPair(ABuilder: TQStringCatHelperW; var p: PQCharW);
const
  SpaceWithSemicolon:PWideChar=': '#9#10#13#$3000;
  CommaWithSpace:PWideChar=', '#9#10#13#$3000;
  JsonEndChars:PWideChar=',}]';
  JsonComplexEnd:PWideChar='}]';
var
  AChild:TQJson;
  AObjEnd:QCharW;
begin
//����ע�ͣ���ֱ������
while p^='/' do
  begin
  if StrictJson then
    raise Exception.Create(SCommentNotSupport);
  if p[1]='/' then
    begin
    SkipUntilW(p,[WideChar(10)]);
    SkipSpaceW(p);
    end
  else if p[1]='*' then
    begin
    Inc(p,2);
    while p^<>#0 do
      begin
      if (p[0]='*') and (p[1]='/') then
        begin
        Inc(p,2);
        SkipSpaceW(p);
        Break;
        end;
      end;
    end
  else
    raise Exception.CreateFmt(SUnknownToken,[StrDupW(p,0,10)]);
  end;
//����ֵ
if (p^='{') or (p^='[') then//����
  begin
  try
    if p^='{' then
      begin
      DataType:=jdtObject;
      AObjEnd:='}';
      end
    else
      begin
      DataType:=jdtArray;
      AObjEnd:=']';
      end;
    Inc(p);
    SkipSpaceW(p);
    while (p^<>#0) and (p^<>AObjEnd) do
      begin
      AChild:=Add;
      AChild.ParseJsonPair(ABuilder,p);
      if p^=',' then
        begin
        Inc(p);
        SkipSpaceW(p);
        end;
      end;
    if p^<>AObjEnd then
      raise Exception.Create(SBadJson)
    else
      begin
      Inc(p);
      SkipSpaceW(p);
      end;
  except
    Clear;
    raise;
  end;
  end
else if Parent<>nil then
  begin
  if (Parent.DataType=jdtObject) and (Length(FName)=0) then
    ParseName(ABuilder,p);
  ParseValue(ABuilder,p);
  if not CharInW(p,JsonEndChars) then
    raise Exception.CreateFmt(SCharNeeded,[JsonEndChars,StrDupW(p,0,10)]);
  end
else
  raise Exception.Create(SBadJson);
end;

function TQJson.ParseJsonTime(p: PQCharW; var ATime: TDateTime): Boolean;
var
  MS,TimeZone:Int64;
begin
//Javascript���ڸ�ʽΪ/DATE(��1970.1.1�����ڵĺ�����+ʱ��)/
Result:=False;
if not StartWithW(p,'/DATE',false) then
  Exit;
Inc(p,5);
SkipSpaceW(p);
if p^<>'(' then
  Exit;
Inc(p);
SkipSpaceW(p);
if ParseInt(p,MS)=0 then
  Exit;
SkipSpaceW(p);
if (p^='+') or (p^='-') then
  begin
  if ParseInt(p,TimeZone)=0 then
    Exit;
  SkipSpaceW(p);
  end
else
  TimeZone:=0;
if p^=')' then
  begin
  ATime:=(MS div 86400000)+((MS mod 86400000)/86400000.0);
  if TimeZone<>0 then
    ATime:=IncHour(ATime,-TimeZone);
  Inc(p);
  SkipSpaceW(p);
  Result:=True
  end;
end;

procedure TQJson.ParseName(ABuilder: TQStringCatHelperW; var p: PQCharW);
begin
if StrictJson and (p^<>'"') then
  raise Exception.CreateFmt(SCharNeeded,['"',DecodeLineW(p)]);
BuildJsonString(ABuilder,p);
if p^<>':' then
  raise Exception.Create(SNameNotFound);
if ABuilder.Position=0 then
  raise Exception.Create(SNameNotFound);
FName:=ABuilder.Value;
//�����������
Inc(p);
SkipSpaceW(p);
end;

procedure TQJson.ParseObject(var p: PQCharW);
var
  ABuilder:TQStringCatHelperW;
  ps:PQCharW;
  procedure RaiseParseException(E:Exception);
  var
    ACol,ARow:Integer;
    ALine:QStringW;
  begin
  p:=StrPosW(ps,p,ACol,ARow);
  ALine:=DecodeLineW(p,False);
  raise Exception.CreateFmt(SJsonParseError,[ARow,ACol,E.Message,ALine]);
  end;
begin
ABuilder:=TQStringCatHelperW.Create;
try
  try
    ps:=p;
    SkipSpaceW(p);
    ParseJsonPair(ABuilder,p);
  except on E:Exception do
    RaiseParseException(E);
  end;
finally
  FreeObject(ABuilder);
end;
end;
procedure TQJson.ParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW);
var
  ANum:Extended;
begin
if p^='"' then
  begin
  BuildJsonString(ABuilder,p);
  AsString:=ABuilder.Value;
  end
else if p^='''' then
  begin
  if StrictJson then
    raise Exception.Create(SBadStringStart);
  BuildJsonString(ABuilder,p);
  AsString:=ABuilder.Value;
  end
else if ParseNumeric(p,ANum) then//���֣�
  begin
  SkipSpaceW(p);
  if SameValue(ANum,Trunc(ANum)) then
    AsInt64:=Trunc(ANum)
  else
    AsFloat:=ANum;
  end
else if StartWithW(p,'False',True) then//False
  begin
  Inc(p,5);
  SkipSpaceW(p);
  AsBoolean:=False
  end
else if StartWithW(p,'True',True) then//True
  begin
  Inc(p,4);
  SkipSpaceW(p);
  AsBoolean:=True;
  end
else if StartWithW(p,'NULL',True) then//Null
  begin
  Inc(p,4);
  SkipSpaceW(p);
  ResetNull;
  end
else if (p^='[') or (p^='{') then
  ParseJsonPair(ABuilder,p)
else
  raise Exception.Create(SBadJson);
end;

procedure TQJson.Replace(AIndex: Integer; ANewItem: TQJson);
begin
FreeObject(Items[AIndex]);
FItems[AIndex]:=ANewItem;
end;

procedure TQJson.ResetNull;
begin
DataType:=jdtNull;
end;

procedure TQJson.SaveToFile(AFileName: String; AEncoding: TTextEncoding;
  AWriteBOM: Boolean);
var
  AStream:TMemoryStream;
begin
AStream:=TMemoryStream.Create;
try
  SaveToStream(AStream,AEncoding,AWriteBOM);
  AStream.SaveToFile(AFileName);
finally
  FreeObject(AStream);
end;
end;

procedure TQJson.SaveToStream(AStream: TStream; AEncoding: TTextEncoding;
  AWriteBOM: Boolean);
begin
if AEncoding=teUTF8 then
  SaveTextU(AStream,QString.Utf8Encode(Value),AWriteBom)
else if AEncoding=teAnsi then
  SaveTextA(AStream,QString.AnsiEncode(Value))
else if AEncoding=teUnicode16LE then
  SaveTextW(AStream,Value,AWriteBom)
else
  SaveTextWBE(AStream,Value,AWriteBom);
end;

procedure TQJson.SetAsArray(const Value: QStringW);
var
  p:PQCharW;
begin
DataType:=jdtArray;
Clear;
p:=PQCharW(Value);
ParseObject(p);
end;

procedure TQJson.SetAsBoolean(const Value: Boolean);
begin
DataType:=jdtBoolean;
PBoolean(FValue)^:=Value;
end;

procedure TQJson.SetAsDateTime(const Value: TDateTime);
begin
DataType:=jdtDateTime;
PExtended(FValue)^:=Value;
end;

procedure TQJson.SetAsFloat(const Value: Extended);
begin
DataType:=jdtFloat;
PExtended(FValue)^:=Value;
end;

procedure TQJson.SetAsInt64(const Value: Int64);
begin
DataType:=jdtInteger;
PInt64(FValue)^:=Value;
end;

procedure TQJson.SetAsInteger(const Value: Integer);
begin
SetAsInt64(Value);
end;

procedure TQJson.SetAsJson(const Value: QStringW);
var
  ABuilder:TQStringCatHelperW;
  p:PQCharW;
begin
ABuilder:=TQStringCatHelperW.Create;
try
  try
    if DataType in [jdtArray,jdtObject] then
      Clear;
    p:=PQCharW(Value);
    ParseValue(ABuilder,p);
  except
    AsString:=Value;
  end;
finally
  FreeObject(ABuilder);
end;
end;

procedure TQJson.SetAsObject(const Value: QStringW);
begin
Parse(PQCharW(Value),Length(Value));
end;

procedure TQJson.SetAsString(const Value: QStringW);
begin
DataType:=jdtString;
FValue:=Value;
end;

procedure TQJson.SetAsValue(const Value: TValue);
var
  I:Integer;
  APointer:Pointer;
begin
case Value.Kind of
  tkInteger:
    AsInt64:=Value.AsInteger;
  tkChar:
    AsString:=Value.AsString;
  tkEnumeration:
    begin
    if Value.IsType<Boolean> then
      AsBoolean:=Value.AsBoolean
    else
      AsString:=Value.ToString;
    end;
  tkFloat:
    AsFloat:=Value.AsExtended;
  tkString:
    AsString:=Value.AsString;
  tkSet:
    AsString:=Value.ToString;
  tkClass:
    AsString:=Value.AsClass.ClassName;
  tkMethod:
    AsString:=Value.ToString;
  tkWChar:
    AsString:=Value.ToString;
  tkLString:
    AsString:=Value.ToString;
  tkWString:
    AsString:=Value.ToString;
  tkVariant:
    AsVariant:=Value.AsVariant;
  tkArray,tkDynArray:
    begin
    DataType:=jdtArray;
    Clear;
    for I := 0 to Value.GetArrayLength-1 do
      Add.AsValue:=Value.GetArrayElement(I);
    end;
  tkRecord:
    begin
    if Value.TypeInfo=TypeInfo(TValue) then
      AsValue:=Value.AsType<TValue>
    else
      begin
      Value.ExtractRawData(@APointer);
      InternalAddRecord(Value.TypeInfo,APointer,nil,nil);
      end;
    end;
  tkInt64:
    AsInt64:=Value.AsInt64;
  tkUString:
    AsString:=Value.AsString;
  tkInterface,tkClassRef,tkPointer,tkProcedure:
    ;
end;
end;

procedure TQJson.SetAsVariant(const Value: Variant);
var
  I:Integer;
begin
if VarIsArray(Value) then
  begin
  ArrayNeeded(jdtArray);
  Clear;
  for I := VarArrayLowBound(Value,VarArrayDimCount(Value)) to VarArrayHighBound(Value,VarArrayDimCount(Value)) do
    Add.AsVariant:=Value[I];
  end
else
  begin
  case VarType(Value) of
    varSmallInt,varInteger,varByte,varShortInt,varWord,varLongWord,varInt64:
      AsInt64:=Value;
    varSingle,varDouble,varCurrency:
      AsFloat:=Value;
    varDate:
      AsDateTime:=Value;
    varOleStr,varString{$IFDEF QDAC_UNICODE},varUString{$ENDIF}:
      AsString:=Value;
    varBoolean:
      AsBoolean:=Value;
    varRecord:
      InternalAddRecord(PVarRecord(@Value).RecInfo,PVarRecord(@Value).PRecord,nil,nil);
  end;
  end;
end;

procedure TQJson.SetDataType(const Value: TQJsonDataType);
begin
if FDataType<>Value then
  begin
  if DataType in [jdtArray,jdtObject] then
    begin
    Clear;
    if not (Value in [jdtArray,jdtObject]) then
      begin
      FreeObject(FItems);
      end;
    end;
  case Value of
    jdtNull,jdtUnknown,jdtString:
      SetLength(FValue,0);
    jdtInteger:
      begin
      SetLength(FValue,SizeOf(Int64) shr 1);
      PInt64(FValue)^:=0;
      end;
    jdtFloat,jdtDateTime:
      begin
      SetLength(FValue,SizeOf(Extended) shr 1);
      PDouble(FValue)^:=0;
      end;
    jdtBoolean:
      begin
      SetLength(FValue,1);
      PBoolean(FValue)^:=False;
      end;
    jdtArray,jdtObject:
      if not (FDataType in [jdtArray,jdtObject]) then
        ArrayNeeded(Value);
  end;
  FDataType := Value;
  end;
end;

procedure TQJson.SetValue(const Value: QStringW);
var
  p:PQCharW;
  procedure ParseNum;
  var
    ANum:Extended;
  begin
  if ParseNumeric(p,ANum) then
    begin
    if SameValue(ANum,Trunc(ANum)) then
      AsInt64:=Trunc(ANum)
    else
      AsFloat:=ANum;
    end
  else
    raise Exception.Create(Format(SBadNumeric,[Value]));
  end;
  procedure SetDateTime;
  var
    ATime:TDateTime;
  begin
  if ParseDateTime(PQCharW(Value),ATime) then
    AsDateTime:=ATime
  else if ParseJsonTime(PQCharW(Value),ATime) then
    AsDateTime:=ATime
  else
    raise Exception.Create(SBadJsonTime);
  end;
  procedure DetectValue;
  var
    ABuilder:TQStringCatHelperW;
    p:PQCharW;
  begin
  ABuilder:=TQStringCatHelperW.Create;
  try
    p:=PQCharW(Value);
    ParseValue(ABuilder,p);
  except
    AsString:=Value;
  end;
  FreeObject(ABuilder);
  end;
begin
if DataType = jdtString then
  FValue:=Value
else if DataType=jdtBoolean then
  AsBoolean:=StrToBool(Value)
else
  begin
  p:=PQCharW(Value);
  if DataType in [jdtInteger,jdtFloat] then
    ParseNum
  else if DataType=jdtDateTime then
    SetDateTime
  else if DataType in [jdtArray,jdtObject] then
    begin
    Clear;
    ParseObject(p);
    end
  else //jdtUnknown
    DetectValue;
  end;
end;

procedure TQJson.ToObject(AObject: TObject);
  procedure AssignProp(AParent:TQJson;AObj:TObject);
  var
    APropInfo:PPropInfo;
    I:Integer;
    AChild:TQJson;
    dynArray:Pointer;
  begin
  if AObj=nil then
    Exit;
  for I := 0 to Count-1 do
    begin
    AChild:=AParent[I];
    APropInfo:=GetPropInfo(AObj,AChild.Name);
    if Assigned(APropInfo) then
      begin
      case APropInfo.PropType^.Kind of
        tkChar:
          SetOrdProp(AObj,APropInfo,QString.AnsiEncode(AChild.AsString)[0]);
        tkWChar:
          SetOrdProp(AObj,APropInfo,PWord(PWideChar(AChild.AsString))^);
        tkInteger:
          SetOrdProp(AObj,APropInfo,AChild.AsInteger);
        tkClass:
          AChild.ToObject(TObject(GetOrdProp(AObj,APropInfo)));
        tkEnumeration:
          SetEnumProp(AObj,APropInfo,AChild.AsString);
        tkSet:
          SetSetProp(AObj,APropInfo,AChild.AsString);
        tkFloat:
          SetFloatProp(AObj,APropInfo,AChild.AsFloat);
        tkMethod:
          {�󶨺�����ֵ��ʱ����};
        {$IFNDEF NEXTGEN}
        tkString, tkLString,tkWString:
          SetStrProp(AObj,APropInfo,AChild.AsString);
        {$ENDIF !NEXTGEN}
        {$IFDEF QDAC_UNICODE}
        tkUString:
          SetStrProp(AObj,APropInfo,AChild.AsString);
        {$ENDIF QDAC_UNICODE}
        tkVariant:
          SetVariantProp(AObj,APropInfo,AChild.AsVariant);
        tkInt64:
          SetInt64Prop(AObj,APropInfo,AChild.AsInt64);
        tkDynArray:
          begin
          dynArray:=nil;
          DynArrayFromVariant(dynArray,AChild.AsVariant,APropInfo.PropType^);
          SetDynArrayProp(AObj,APropInfo,dynArray);
          end;
      end;
      end;
    end;
  end;
begin
if Assigned(AObject) then
  AssignProp(Self,AObject);
end;
{$IFDEF QDAC_RTTI}
procedure TQJson.InternalToRecord(ATypeInfo:PTypeInfo;ABaseAddr:Pointer);
var
  AContext:TRttiContext;
  AType:TRttiType;
  I:Integer;
  AFields:TArray<TRttiField>;
  AChild:TQJson;
  procedure SetAsIntValue(AValue:Int64);
  begin
  if AFields[I].FieldType.TypeKind=tkInt64 then
    PInt64(IntPtr(ABaseAddr)+AFields[I].Offset)^:=AValue
  else
    begin
    case GetTypeData(AFields[I].FieldType.Handle)^.OrdType
//    AFields[I].FieldType.Handle.TypeData.OrdType
      of
        otSByte, otUByte:
          PByte(IntPtr(ABaseAddr)+AFields[I].Offset)^:=AValue;
        otSWord, otUWord:
          PSmallint(IntPtr(ABaseAddr)+AFields[I].Offset)^:=AValue;
        otSLong, otULong:
          PInteger(IntPtr(ABaseAddr)+AFields[I].Offset)^:=AValue;
      end;
    end
  end;
  procedure ParseDynArray;
  var
    AValue:array of TValue;
    J:Integer;
  begin
  SetLength(AValue,AChild.Count);
  for J := 0 to AChild.Count-1 do
   AValue[J]:=TValue.FromVariant(AChild[J].AsVariant);
  AFields[I].SetValue(ABaseAddr,TValue.FromArray(AFields[I].FieldType.Handle,AValue));
  end;
  {$IFNDEF NEXTGEN}
  procedure ParseShortString;
  var
    S: ShortString;
    AValue:TValue;
  begin
  S:= ShortString(AChild.AsString);
  TValue.Make(@S, AFields[I].FieldType.Handle, AValue);
  AFields[I].SetValue(ABaseAddr,AValue);
  end;
  {$ENDIF}
begin
if not Assigned(ATypeInfo) then
  Exit;
AType:=AContext.GetType(ATypeInfo);
if AType=nil then
  Exit;
if AType.TypeKind<>tkRecord then
  Exit;
AFields:=AType.GetFields;
for I := Low(AFields) to High(AFields) do
  begin
  AChild:=ItemByName(AFields[I].Name);
  if Assigned(AChild) then
    begin
    if  AFields[I].FieldType.TypeKind =tkInteger then
      SetAsIntValue(AChild.AsInt64)
    else if AFields[I].FieldType.TypeKind=tkInt64 then
      SetAsIntValue(AChild.AsInt64)
    else if AFields[I].FieldType.TypeKind in [tkUString{$IFNDEF NEXTGEN},tkString,tkLString,tkWString,tkChar,tkWChar{$ENDIF}] then
      begin
      {$IFDEF NEXTGEN}
      AFields[I].SetValue(ABaseAddr,TValue.From(AChild.AsString));
      {$ELSE}
      if AFields[I].FieldType.TypeKind=tkString then
        ParseShortString
      else
        AFields[I].SetValue(ABaseAddr,TValue.From(AChild.AsString));
      {$ENDIF}
      end
    else if AFields[I].FieldType.TypeKind=tkRecord then
      InternalToRecord(AFields[I].FieldType.Handle,Pointer(IntPtr(ABaseAddr)+AFields[I].Offset))
    else if AFields[I].FieldType.TypeKind=tkEnumeration then
      SetAsIntValue(GetEnumValue(AFields[I].FieldType.Handle,AChild.AsString))
    else if AFields[I].FieldType.TypeKind=tkSet then
      SetAsIntValue(StringToSet(AFields[I].FieldType.Handle,AChild.AsString))
    else if AFields[I].FieldType.TypeKind=tkFloat then
      begin
      if (AFields[I].FieldType.Handle=TypeInfo(TDate)) or
        (AFields[I].FieldType.Handle=TypeInfo(TTime)) or
        (AFields[I].FieldType.Handle=TypeInfo(TDateTime))
        then
        AFields[I].SetValue(ABaseAddr,TValue.From(AChild.AsDateTime))
      else
        AFields[I].SetValue(ABaseAddr,TValue.From(AChild.AsFloat));
      end
    else if (AFields[I].FieldType.TypeKind=tkVariant) then
      AFields[I].SetValue(ABaseAddr,TValue.From(AChild.AsVariant))
    else if (AFields[I].FieldType.TypeKind in [tkArray,tkDynArray]) and AChild.IsArray then
      ParseDynArray
    else//
      begin
//      tkClass,tkMethod,tkInterface,tkClassRef,tkPointer,tkProcedure:
        {����֧�ֵ����ͣ�����};
      end;
    end;
  end;
end;
procedure TQJson.ToRecord<T>(const ARecord: T);
begin
InternalToRecord(TypeInfo(T),@ARecord);
end;
{$ENDIF}
function TQJson.ToString: string;
begin
Result:=AsString;
end;

procedure TQJson.ValidArray;
begin
if DataType in [jdtArray,jdtObject] then
  {$IFDEF QDAC_UNICODE}
  FItems:=TList<TQJson>.Create
  {$ELSE}
  FItems:=TList.Create
  {$ENDIF}
else
  raise Exception.Create(Format(SVarNotArray,[FName]));
end;

function TQJson.ValueByName(AName, ADefVal: QStringW): QStringW;
var
  AChild:TQJson;
begin
AChild:=ItemByName(AName);
if Assigned(AChild) then
  Result:=AChild.Value
else
  Result:=ADefVal;
end;

function TQJson.ValueByPath(APath, ADefVal: QStringW): QStringW;
var
  AItem:TQJson;
begin
AItem:=ItemByPath(APath);
if Assigned(AItem) then
  Result:=AItem.Value
else
  Result:=ADefVal;
end;
{ TQJsonEnumerator }

constructor TQJsonEnumerator.Create(AList: TQJson);
begin
inherited Create;
FList:=AList;
FIndex:=-1;
end;

function TQJsonEnumerator.GetCurrent: TQJson;
begin
Result:=FList[FIndex];
end;

function TQJsonEnumerator.MoveNext: Boolean;
begin
if FIndex<FList.Count-1 then
  begin
  Inc(FIndex);
  Result:=True;
  end
else
  Result:=False;
end;

{ TQHashedJson }

function TQHashedJson.Add(AName: QStringW): TQJson;
begin
Result:=inherited Add(AName);
Result.FNameHash:=HashOf(PQCharW(AName),Length(AName) shl 1);
FHashTable.Add(Pointer(Count-1),Result.FNameHash);
end;

procedure TQHashedJson.Assign(ANode: TQJson);
begin
  inherited;
if (Length(FName)>0) then
  begin
  if FNameHash=0 then
    FNameHash:=HashOf(PQCharW(FName),Length(FName) shl 1);
  if Assigned(Parent) then
    TQHashedJson(Parent).FHashTable.Add(Pointer(Parent.Count-1),FNameHash);
  end;
end;

procedure TQHashedJson.Clear;
begin
inherited;
FHashTable.Clear;
end;

constructor TQHashedJson.Create;
begin
inherited;
FHashTable:=TQHashTable.Create();
FHashTable.AutoSize:=True;
end;

function TQHashedJson.CreateJson: TQJson;
begin
if Assigned(OnQJsonCreate) then
  Result:=OnQJsonCreate
else
  Result:=TQHashedJson.Create;
end;

procedure TQHashedJson.Delete(AIndex: Integer);
var
  AItem:TQJson;
begin
AItem:=Items[AIndex];
FHashTable.Delete(Pointer(AIndex),AItem.NameHash);
inherited;
end;

destructor TQHashedJson.Destroy;
begin
FreeObject(FHashTable);
inherited;
end;

function TQHashedJson.IndexOf(const AName: QStringW): Integer;
var
  AIndex,AHash:Integer;
  AList:PQHashList;
  AItem:TQJson;
begin
AHash:=HashOf(PQCharW(AName),Length(AName) shl 1);
AList:=FHashTable.FindFirst(AHash);
Result:=-1;
while AList<>nil do
  begin
  AIndex:=Integer(AList.Data);
  AItem:=Items[AIndex];
  if AItem.Name=AName then
    begin
    Result:=AIndex;
    Break;
    end
  else
    AList:=FHashTable.FindNext(AList);
  end;
end;
procedure TQHashedJson.Replace(AIndex: Integer; ANewItem: TQJson);
var
  AOld:TQJson;
begin
if not (ANewItem is TQHashedJson) then
  raise Exception.CreateFmt(SReplaceTypeNeed,['TQHashedJson']);
AOld:=Items[AIndex];
FHashTable.Delete(Pointer(AIndex),AOld.NameHash);
inherited;
if Length(ANewItem.FName)>0 then
  FHashTable.Add(Pointer(AIndex),ANewItem.FNameHash);
end;

initialization
  StrictJson:=False;
  JsonCaseSensitive:=True;
  JsonDateFormat:='yyyy-mm-dd';
  JsonDateTimeFormat:='yyyy-mm-dd''T''hh:nn:ss.zzz';
  JsonTimeFormat:='hh:nn:ss.zzz';
  OnQJsonCreate:=nil;
  OnQJsonFree:=nil;
end.

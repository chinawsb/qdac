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

{ �޶���־
  2017.3.27
  ==========
  + ���� ForEach ������ Sort ����������
  2017.2.26
  ==========
  * ������ Replace δ�����������⣨cntlis���棩
  2017.4.10
  ==========
  + �����˴󸡵����ж�ʱ��������⣨SeMain���棩

  2017.1.1
  ==========
  + ���� Insert ϵ�к�����������ָ����λ�ò���һ����㣨��ľ���ֺ뽨�飩

  2016.11.23
  ==========
  + ���� Reset ���������ý����������ݣ�ͬʱҲ��Ӹ�������Ƴ����������б��棩

  2016.11.16
  ==========
  * ������ FromRtti ʱ������ֻ����ֻд�����Ա��棬���ToRtti�ָ�����ֵʱ�޷���������⣨KEN���棩
  2016.11.02
  ==========
  * ������ Merge �ϲ�ʱ������Ϊ Ignore ʱδ������Ԫ�ز�ͬ�����⣬�����Ԫ��û�кϲ������⣨��ľ���棩

  2016.8.23
  ==========
  * ������ ToFixedArray û�бȽ�����Ԫ�ظ������ӽ��������ɿ��ܷ���Խ������⣨���Ʊ��棩
  2016.6.24
  ==========
  * ������ JsonCat ʱ�����ڴ�ռ���ܲ�������⣨��è���屨�棩
  * �޸Ķ� encddecd ��Ԫ�����ã��ֺ뽨�飩
  2016.2.24
  ==========
  * ������ ItemByPath ʱ����������·���������ڵ����⣨�ֺ뱨�棩
  2016.1.25
  ==========
  * ������ TQHashedJson ������ʱ����ǰ�ͷ��� FHashTable ������
  2016.1.23
  ==========
  * �޸� SetValue �����Զ�������͵Ĵ��룬�����׳��쳣

  2016.1.11
  ==========
  + ���� Equals �����ж����� JSON �����Ƿ���ͬ
  + ���� CommentStyle �� Comment ����������ע
  + ���� Merge/Intersect/Diff �������������ݵĺϲ������غͲ���Ƚ�
  2015.11.19
  ===========
  * ������TQHashedJson��ӽ��ʱ��û����ȷ�����ƽ��й�ϣ�����⣨QQ���棩
  * ������ FromRtti �� Win64 ʱ�����û��������ʱ���������

  2015.10.30
  ===========
  * ������TQJsonStreamHelper.EndArrayʱ��JSON������ܳ��������(�й����챨�棩
  2015.10.23
  ===========
  + ForceName ȷ��ָ�������ƴ���

  2015.10.20
  ==========
  + Exists �����ж��Ƿ����ָ��·�����ӽ�㣨��ľ���飩
  + Sort �����ӽ�㣨�ֺ뽨�飩
  + ExchangeOrder �����������
  + ContainsName �ж��Ƿ���ָ�����Ƶ��ӽ��
  + ContainsValue �ж��Ƿ����ָ��ֵ���ӽ�㣨�ഺ���飩

  2015.10.8
  ==========
  * ����������ĩβ�����ո�ʱ������Զ��Ƴ�������

  2015.9.22
  ==========
  * ������TQJsonStreamHelperд����������ʱ�����û����Ԫ��ʱ��ɸ�ʽ���ҵ�����

  2015.7.20
  ==========
  * ������ ToRtti ʱ�Բ���Ĭ��ֵ�������ԵĿ��Ʒ���
  * ������ ToRtti �� FromRtti ���� TDateTime �������Ե����⣨��л����һ��ƽ����
  2015.6.23
  =========
  + ���� TQJsonStreamHelper ����ֱ��������д�� JSON ��ʽ�����ݣ��ŵ�������ʡ����
  TQJson����Ĵ�����ά�ٶȸ��죬ȱ������Ҫ���п��Ƹ���Ĳ��裨������Ͷ���ıպϣ�
  2015.5.22
  =========
  + ���Ӷ����Ʊ���ΪBase64��Ĭ�����ú��� EncodeJsonBinaryAsBase64�����Ҫ�ָ�Ĭ�ϣ�����
  EncodeJsonBinaryAsHex

  2015.4.21
  =========
  + IgnoreCase �������ڿ���Json������������ִ�Сд���ԣ�Ĭ�ϼ̳���ȫ�ֵ�JsonCaseSensitive����ֵ���ֺ뽨�飩
  + Root �������ڷ��ظ����
  * HashName �� TQHashedJson �Ƶ� TQJson
  2015.2.6
  =========
  * ������ AsInteger/AsFloat ʱ��֧��ʮ�����Ƶ�����

  2015.2.1
  =========
  * �޸��˽����ͱ������Ϊ����������Ϊ���ַ�����JSON���루��л Synopse��
  2015.1.26
  ==========
  + �����޲�����Delete��������ɾ���������

  2015.1.19
  ==========
  * �����˱���ʱ��һЩ�ض��ַ�Ϊ�����������������Ա�ֶ��Լ����Ʊ���Ľ�������ӿɶ��ԣ���ľ���飩
  * �������ظ����� FromRtti ʱû�����ĩ��ֵ�����⣨��ľ���棩

  2015.1.13
  ==========
  * ������ TQHashedJson �� IndexOf δ��ȷ�����Сд������
  * ������ TQHashedJson �ڽ�����ɺ�δ��ȷ���¼����ϣֵ�����⣨��ľ���棩
  * �����˽�����ֵ����ʱ Parse ʱδ��ȷ�Ƴ����ƿո������

  2015.1.6
  ========
  * ������SetAsVariant�ԷǱ�׼�ı������͵�֧�����⣨С�㱨�棩

  2015.1.5
  =========
  * ������IsChildOf��һ���жϴ�����ɿ��ܷ���AV�쳣

  2015.1.4
  =========
  * �޸��� ItemByName �Ĳ��ִ��룬������û����ȷ���� JsonCaseSensitive ��ǵ�����,��ɺ��Դ�Сд��Ч������(��ľ��
  * ������ ItemByName �������±괦����߼�����
  * ������ ItemByPath ��֧�ֶ�ά���������
  2015.1.3
  =========
  * SaveToStream/SaveToFile ������һ��ADoFormat�������Ա�����Ƿ��ʽ�����ֺ롢��ľ���飩
  2014.12.24
  ==========
  * �����˽���Json�а���ע��ʱ��������ȫ������⣨kylix2008���棩

  2014.12.13
  ==========
  + ����HasChild���������ж�ָ��·�����ӽ���Ƿ���ڣ���ľ���飩

  2014.11.25
  ==========
  * �޸���ItemByPath�Ĵ��룬֧�ְ�����˳��������jdtObject���͵��ӳ�Ա

  2014.11.24
  ==========
  * ������ToRtti.FoArray����Ϊ��������������δ�ҵ�ʱ����ʾ�쳣

  2014.11.20
  ==========
  + ����AsBytes���ԣ���֧�ֶ������������ͣ�Ĭ��ʵ��ֱ��ʹ�õ�ʮ�������ַ�����
  �ϲ��������OnQJsonEncodeBytes��OnQJsonDecodeBytes�¼����滻Ϊ�Լ���ʵ�֣���
  ZLib+Base64��
  + ����ValueFromStream/ValueFromFile/StreamFromValue/StreamFromFile����

  2014.11.14
  ==========
  * ������GetAsVariantʱû�д���jdtNull���͵�����

  2014.11.13
  ==========
  + ����IsBool�����жϵ�ǰֵ�Ƿ���ת��Ϊ����ֵ���ʣ����¹�_???-���飩
  2014.11.10
  ==========
  * ������FromRtti/ToRtti�ڴ���TCollection����ʱ���ڵ�����(��ľ����)
  * ������FromRtti��ToObject�Ӻ�����һ������(hq200306����)

  2014.11.6
  ==========
  * ������FromRttiʱ��������Ԫ����ӽ��ʱ��AName��д��Name��ɽ��δ���������⣨��ľ���棩
  + ����IntByPath,IntByName��BoolByPath,BoolByName,FloatByPath,FloatByName,DateTimeByPath,
  DateTimeByName�������Լ��жϱ��(FreeSpace8����)

  2014.10.30
  ==========
  + ����Detach��AttachTo��MoveTo��Remove����
  * ����Json��������������Ա������MoveTo��AttachToʱԪ��δ����

  2014.9.11
  =========
  * �����˴������ļ��м��ؿհ�JSON����Ͷ���ʱ��������⣨�ֺ뱨�棩
  * �޸�ֱ�ӽ��Ƕ��������ֵ���浽���еĲ��ԣ������ٷʱ��棩��
  1�����JSON���������Ѿ�ָ�����򱣴�Ϊ�����һ���Ӷ���
  2�����δָ�����ƣ�������Ϊδ֪��ΪjdtNull���򲻱����κ�����
  2014.9.3
  =========
  * �����˽��������ַ���ֵʱ���ܶ�ʧ�ַ�������(��ľ����)

  2014.8.27
  =========
  * �����˽����������������ǰ����ע��ʱ���������(��ľ����)
  2014.8.15
  =========
  * ������Add�����Զ������������ʱ������ض���ʽ��11,23ʱ�������������(Tuesday����)
  2014.7.31
  =========
  * �����˽�������ʱ������й�����ϵͳ�쳣�޷�������ʾ������(����С�ױ���)
  * �����˽���ʱ����������ѭ�������⣨����С�ױ��棩
  * �����˳����쳣ʱ���쳣����ʾ�ظ�������
  * ������ForcePathʱ'array[].subobjectname'δ��ȷ����·��������(����С�ױ���)
  2014.7.28
  =========
  * ������ToRtti���Դ����������ʱ�����ͣ���JSONΪnullʱ�������������(�ֺ걨��)
  * �޸�ToRecord��������Ϊvar��������const(�ֺ걨��)
  2014.7.16
  =========
  * ������GetPathʱ��δ��ʼ������ַ������Path���Կ��ܳ��������(����С�ױ���)
  2014.7.6
  =========
  + ToRtti����Ծ�̬�������͵�֧��

  2014.7.3
  =========
  * ������Assignʱ�����˵�ǰ������Ƶ�����

  2014.7.1
  =========
  * AsString�޸�jdtNull/jdtUnknownʱ����Ϊ���ؿ��ַ���
  2014.6.28
  =========
  * ������ForcePath('Items[]')Ĭ������˿��ӽ�������(pony,��������)
  + ����JsonRttiEnumAsIntȫ��ѡ�����ö��ֵ�ͼ���ֵ�Ƿ񱣴�����ַ�����Ĭ��ΪTrue(�ֺ뽨��)
  2014.6.27
  =========
  + ����TryParse�������ֺ뽨�飩
  * �޸���Encodeʱ���Լ�������Ҳ�ӵ��˽���ַ����е����⣨�ֺ뱨�棩
  * ������FromRTTIʱ�����ڷ������¼�������û�н��й��˵�����
  * ������ToRtti.ToArrayʱ�����ڶ�̬��������ó���ʱ���ʹ��󣨻ֺ뱨�棩
  2014.6.26
  ==========
  * ������ToRtti.ToRecord�Ӻ���������������ʱ�Ĵ���(��лȺ�ѻֺ������RTTI����Ͳ���)
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.23
  ==========
  + FromRecord֧�ֶ�̬�������ͨ����
  2014.6.21
  ==========
  * �Ƴ�ԭ��AddObject/AddRecord/ToObject/ToRecord֧��
  + ���FromRtti/ToRtti/FromRecord/ToRecord/ToRttiValue����֧�֣��滻ԭ����RTTI����
  + ���Invoke������֧��ֱ��ͨ��Json���ö�Ӧ�ĺ���������ο�Demo
  2014.6.17
  =========
  * AsFloat��ֵʱ�����Nan��Infinite��NegInfinite������Чֵ�ļ��
  * AsVariant��ֵʱ�����varNull,varEmpty,varUnknown,varUInt64���͵�֧��
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
// ���Ի�����ΪDelphi 2007��XE6�������汾�Ŀ����������������޸�
uses classes, sysutils, math, types, qstring, typinfo, qrbtree, fmtbcd,
{$IF RTLVersion>27}
  System.NetEncoding{$ELSE}EncdDecd{$IFEND}
{$IFDEF MSWINDOWS}, windows{$ENDIF}
{$IFDEF UNICODE}, Generics.Collections{$ENDIF}{$IF RTLVersion>=21},
  Rtti{$IFEND >=XE10}
{$IF RTLVersion<22}// 2007-2010
{$IFDEF ENABLE_REGEX}
    , PerlRegEx, pcre
{$ENDIF}
{$ELSE}
    , RegularExpressionsCore
{$IFEND}
    ;
{$M+}
{$HPPEMIT '#pragma link "qjson"'}
{$IF RTLVersion<=27}
{$HPPEMIT '#pragma link "soaprtl.lib"'}
{$IFEND}

// ���Ҫʹ����������ʾ��ʽ����TForm1.FormCreate,����������Ķ��壬���򷽷���ΪForm1.FormCreate
{ .$DEFINE TYPENAMEASMETHODPREF }
type
  /// ����Ԫ��QDAC����ɲ��֣���QDAC��Ȩ���ƣ��������QDAC��վ�˽�
  /// <summary>
  /// JSON������Ԫ�����ڿ��ٽ�����ά��JSON�ṹ.ȫ�ֱ���StrictJsonΪFalseʱ��֧��
  /// ע�ͺ����Ʋ�����'"'��
  /// </summary>
  /// TQJsonDataType���ڼ�¼JSON����Ԫ�����ͣ���ȡֵ������
  /// <list>
  /// <item>
  /// <term>jdtUnknown</term><description>δ֪���ͣ�ֻ���¹������δ��ֵʱ���Ż��Ǹ�����</description>
  /// </item>
  /// <item>
  /// <term>jdtNull</term><description>NULL</description>
  /// </item>
  /// <item>
  /// <term>jdtString</term><description>�ַ���</description>
  /// </item>
  /// <item>
  /// <term>jdtInteger</term><description>����(Int64,��������ֵ����ڲ���ʹ��64λ��������)</description>
  /// </item>
  /// <item>
  /// <term>jdtFloat</term><description>˫���ȸ�����(Double)</description>
  /// </item>
  /// <item>
  /// <term>jdtBcd</term><description>BCD��������</description>
  /// </item>
  /// <item>
  /// <term>jdtBoolean</term><description>����</description>
  /// </item>
  /// <item>
  /// <term>jdtDateTime</term><description>����ʱ������</description>
  /// </item>
  /// <item>
  /// <term>jdtArray</term><description>����</description>
  /// </item>
  /// <item>
  /// <term>jdtObject</term><description>����</description>
  /// </item>
  /// </list>
  TQJsonDataType = (jdtUnknown, jdtNull, jdtString, jdtInteger, jdtFloat, jdtBcd, jdtBoolean, jdtDateTime, jdtArray,
    jdtObject);
  /// <summary>ƴ��ֵ��ѡ��</summary>
  TQCatOption = (coIgnoreEmpty, coIgnoreDuplicates, coIgnoreCase);
  TQCatOptions = set of TQCatOption;

  TQJson = class;
{$IF RTLVersion>=21}
  /// <summary>
  /// RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  /// <param name="AType">���Ի��ֶε�������Ϣ</param>
  /// <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  /// <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQJsonRttiFilterEventA = reference to procedure(ASender: TQJson; AObject: Pointer; AName: QStringW; AType: PTypeInfo;
    var Accept: Boolean; ATag: Pointer);
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQJsonFilterEventA = reference to procedure(ASender, AItem: TQJson; var Accept: Boolean; ATag: Pointer);
{$IFEND >=2010}
  /// <summary>
  /// RTTI��Ϣ���˻ص���������XE6��֧��������������XE����ǰ�İ汾�����¼��ص�
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AName">������(AddObject)���ֶ���(AddRecord)</param>
  /// <param name="AType">���Ի��ֶε�������Ϣ</param>
  /// <param name="Accept">�Ƿ��¼�����Ի��ֶ�</param>
  /// <param name="ATag">�û��Զ���ĸ������ݳ�Ա</param>
  TQJsonRttiFilterEvent = procedure(ASender: TQJson; AObject: Pointer; AName: QStringW; AType: PTypeInfo;
    var Accept: Boolean; ATag: Pointer) of object;
  /// <summary>
  /// �����˴�����������XE6��֧����������
  /// </summary>
  /// <param name="ASender">�����¼���TQJson����</param>
  /// <param name="AItem">Ҫ���˵Ķ���</param>
  /// <param name="Accept">�Ƿ�Ҫ����ö���</param>
  /// <param name="ATag">�û����ӵ�������</param>
  TQJsonFilterEvent = procedure(ASender, AItem: TQJson; var Accept: Boolean; ATag: Pointer) of object;
  TListSortCompareEvent = function(Item1, Item2: Pointer): Integer of object;
  PQJson = ^TQJson;
{$IF RTLVersion>=21}
  TQJsonItemList = TList<TQJson>;
{$ELSE}
  TQJsonItemList = TList;
{$IFEND}
  /// <summary>
  /// TQJsonTagType�����ڲ�AddObject��AddRecord�������ڲ�����ʹ��
  /// </summary>
  /// <list>
  /// <item>
  /// <term>ttAnonEvent</term><description>�ص���������</description>
  /// <term>ttNameFilter</term><description>���Ի��Ա���ƹ���</descriptio>
  /// </list>
  TQJsonTagType = (ttAnonEvent, ttNameFilter);
  PQJsonInternalTagData = ^TQJsonInternalTagData;

  /// <summary>
  /// TQJsonInternalTagData����AddRecord��AddObject������Ҫ�ڲ�����RTTI��Ϣʱʹ��
  /// </summary>
  TQJsonInternalTagData = record
    /// <summary>Tag���ݵ�����</summary>
    TagType: TQJsonTagType;
{$IF RTLVersion>=21}
    /// <summary>����ʹ�õ���������</summary>
    OnEvent: TQJsonRttiFilterEventA;
{$IFEND >=2010}
    /// <summary>���ܵ�����(AddObject)���¼�ֶ�(AddRecord)���ƣ��������ͬʱ��IgnoreNames���֣���IgnoreNames�����Ϣ������</summary>
    AcceptNames: QStringW;
    /// <summary>���Ե�����(AddObject)���¼�ֶ�(AddRecord)���ƣ��������ͬʱ��AcceptNameds���AcceptNames����</summary>
    IgnoreNames: QStringW;
    /// <summary>ԭʼ���ݸ�AddObject��AddRecord�ĸ������ݳ�Ա�����������ݸ�OnEvent��Tag���Թ��û�ʹ��</summary>
    Tag: Pointer;
  end;

  TQJsonEnumerator = class;
  /// <summary>�����ⲿ֧�ֶ���صĺ���������һ���µ�QJSON����ע��ӳ��д����Ķ���</summary>
  /// <returns>�����´�����QJSON����</returns>
  TQJsonCreateEvent = function: TQJson;
  /// <summary>�����ⲿ�����󻺴棬�Ա����ö���</summary>
  /// <param name="AJson">Ҫ�ͷŵ�Json����</param>
  TQJsonFreeEvent = procedure(AJson: TQJson);
  /// <summary>
  /// JSON ������ַ���ʱ�Ŀ���ѡ��
  /// </summary>
  /// <list>
  /// <item>
  /// <term>jesIgnoreNull</term><description>����jdtNull/jdtUnknown���ͳ�Ա</description>
  /// </item>
  /// <item>
  /// <term>jdtIgnoreDefault</term><description>���Ե�jdtNull/jdtUnknown���ͼ��������͵�Ĭ��ֵ�����ַ���/0/false</description>
  /// </item>
  /// <item>
  /// <term>jesDoFormat</term><description>��ʽ�� JSON �ַ���</description>
  /// </item>
  /// <item>
  /// <term>jesDoEscape</term><description>ת��Unicode�ַ�</description>
  /// </item>
  /// <item>
  /// <term>jesNullAsString</term><description>�� jdtNull/jdtUnknown ת��Ϊ���ַ���</description>
  /// </item>
  /// <item>
  /// <term>jesJavaDateTime</term><description>����ʱ������ת��Ϊ Java �� /DATE/ ������ʽ</description>
  /// </item>
  /// <item>
  /// <term>jesWithComment</term><description>����ʱ����ע��</description>
  /// </item>
  /// <item>
  /// <term>jesEscapeSlashes</term><description>����ʱת�巴б�ߣ��������ⳡ�����ݣ�</description>
  /// </item>
  /// <item>
  /// <term>jes1Element1Line</term><description>����ʱÿ������Ԫ�ص�Ԫռһ��</description>
  /// </item>
  /// </list>
  TJsonEncodeSetting = (jesIgnoreNull, jesIgnoreDefault, jesDoFormat, jesDoEscape, jesNullAsString, jesJavaDateTime,
    jesWithComment, jesEscapeSlashes, jes1Element1Line);
  TJsonEncodeSettings = set of TJsonEncodeSetting;

  TQJsonEncodeBytesEvent = procedure(const ABytes: TBytes; var AResult: QStringW);
  TQJsonDecodeBytesEvent = procedure(const S: QStringW; var AResult: TBytes);

  EJsonError = class(Exception)
  private
    FRow, FCol: Integer;
  public
    property Row: Integer read FRow;
    property Col: Integer read FCol;
  end;

  // </summary>
  /// TQJsonCommentStyle ���ڼ�¼JSON��ע�͵����ͣ�ע�⣬�ϸ�ģʽ�£�ע�ͽ�������
  /// <list>
  /// <item>
  /// <term>jcsIgnore</term><description>����ʱ����ԭ����ע��</description>
  /// <term>jcsInherited</term><description>����ʱ�ɸ��������þ���ע�ͳ��ֵ�λ��</description>
  /// <term>jcsBeforeName</term><description>����Ŀ��֮ǰ����ע��</description>
  /// <term>jcsAfterValue</term><description>����Ŀֵ֮�󣬶��ŷָ���ǰ����ע��</description>
  /// </item>
  TQJsonCommentStyle = (jcsIgnore, jcsInherited, jcsBeforeName, jcsAfterValue);
  TQJsonMergeMethod = (jmmIgnore, jmmAsSource, jmmAppend, jmmReplace);
  TQJsonForEachCallback = procedure(AItem: TQJson; ATag: Pointer) of object;
  TQJsonMatchFilterCallback = procedure(AItem: TQJson; ATag: Pointer; var Accept: Boolean) of object;
{$IFDEF UNICODE}
  TQJsonForEachCallbackA = reference to procedure(AItem: TQJson);
  TQJsonMatchFilterCallbackA = reference to procedure(AItem: TQJson; var Accept: Boolean);
{$ENDIF}
  TQJsonMatchSetting = (jmsIgnoreCase, jmsNest, jmsMatchName, jmsMatchPath, jmsMatchValue);
  TQJsonMatchSettings = set of TQJsonMatchSetting;
  TQJsonContainerEnumerator = class;
  IQJsonContainer = interface;

  IQJsonContainer = interface
    ['{C9FF8471-19FC-435A-B1A7-21F0D5206720}']
    function GetCount: Integer;
    function GetItems(const AIndex: Integer): TQJson;
{$IFDEF UNICODE}
    function ForEach(ACallback: TQJsonForEachCallback; ATag: Pointer = nil): IQJsonContainer; overload;

    function ForEach(ACallback: TQJsonForEachCallbackA): IQJsonContainer; overload;
    function Match(const AFilter: TQJsonMatchFilterCallbackA; ATag: Pointer = nil): IQJsonContainer; overload;

    function Match(const ARegex: QStringW; ASettings: TQJsonMatchSettings): IQJsonContainer; overload;
    function Match(const AIndexes: array of Integer): IQJsonContainer; overload;
    function Match(const AStart, AStop, AStep: Integer): IQJsonContainer; overload;
    function Match(const AFilter: TQJsonMatchFilterCallback; ATag: Pointer = nil): IQJsonContainer; overload;
{$ENDIF}
    function GetEnumerator: TQJsonContainerEnumerator;
    function GetIsEmpty: Boolean;
    property Items[const AIndex: Integer]: TQJson read GetItems; default;
    property Count: Integer read GetCount;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TQJsonContainerEnumerator = class
  private
    FIndex: Integer;
    FList: IQJsonContainer;
  public
    constructor Create(AList: IQJsonContainer);
    function GetCurrent: TQJson; inline;
    function MoveNext: Boolean;
    property Current: TQJson read GetCurrent;
  end;

  TQJsonContainer = class(TInterfacedObject, IQJsonContainer)
  protected
    FItems: TQJsonItemList;
    function GetCount: Integer;
    function GetItems(const AIndex: Integer): TQJson;
    function ForEach(ACallback: TQJsonForEachCallback; ATag: Pointer = nil): IQJsonContainer; overload;
{$IFDEF UNICODE}
    function ForEach(ACallback: TQJsonForEachCallbackA): IQJsonContainer; overload;
    function Match(const AFilter: TQJsonMatchFilterCallbackA; ATag: Pointer = nil): IQJsonContainer; overload;
{$ENDIF}
    function Match(const ARegex: QStringW; ASettings: TQJsonMatchSettings): IQJsonContainer; overload;
    function Match(const AIndexes: array of Integer): IQJsonContainer; overload;
    function Match(const AStart, AStop, AStep: Integer): IQJsonContainer; overload;
    function Match(const AFilter: TQJsonMatchFilterCallback; ATag: Pointer): IQJsonContainer; overload;
    function GetIsEmpty: Boolean;
    function GetEnumerator: TQJsonContainerEnumerator;
  public
    constructor Create; overload;
    constructor Create(AJson: TQJson); overload;
    destructor Destroy; override;
  end;

  // TQJsonSortFlags=(jsmAsString,);
  /// <summary>
  /// TQJson���ڽ�����ά��JSON��ʽ�Ķ������ͣ�Ҫʹ��ǰ����Ҫ���ڶ��д�����Ӧ��ʵ����
  /// TQJson��TQXML�ھ�������ӿ��ϱ���һ�£�������Json����������Ϣ����XMLû������
  /// ��Ϣ��ʼ����Ϊ���ַ�����������ٲ��ֽӿڻ����в�ͬ.
  /// ������ʵ�ֲ�ͬ��QJSON���е����Ͷ���ͬһ������ʵ�֣�����DataType�Ĳ�ͬ����ʹ��
  /// ��ͬ�ĳ�Ա�����ʡ�������ΪjdtArray������jdtObjectʱ�����������ӽ��.
  /// </summary>
  TQJson = class
  private

  protected
    FName: QStringW;
    FValueFormat: QStringW;
    FNameHash: TQHashType;
    FDataType: TQJsonDataType;
    FValue: QStringW;
    FComment: QStringW;
    FCommentStyle: TQJsonCommentStyle;
    FParent: TQJson;
    FData: Pointer;
    FItems: TQJsonItemList;
    FIgnoreCase: Boolean;
    function GetValue: QStringW;
    procedure SetValue(const Value: QStringW);
    procedure SetDataType(const Value: TQJsonDataType);
    function TryGetAsBoolean(var AValue: Boolean): Boolean;
    function GetAsBoolean: Boolean;
    function TryGetAsFloat(var AValue: Extended): Boolean;
    function GetAsFloat: Extended;
    function TryGetAsInt64(var AValue: Int64): Boolean;
    function GetAsInt64: Int64;
    function GetAsInteger: Integer;
    function GetAsString: QStringW;
    function GetAsObject: QStringW;
    procedure SetAsObject(const Value: QStringW);
    function TryGetAsDateTime(var AValue: TDateTime): Boolean;
    function GetAsDateTime: TDateTime;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsFloat(const Value: Extended);
    procedure SetAsInt64(const Value: Int64);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: QStringW);
    procedure SetAsDateTime(const Value: TDateTime);
    function GetAsBcd: TBcd;
    procedure SetAsBcd(const Value: TBcd);
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQJson;
    class function CharUnescape(var p: PQCharW): QCharW;
    class function CharEscape(c: QCharW; pd: PQCharW): Integer;
    procedure ArrayNeeded(ANewType: TQJsonDataType);
    procedure ValidArray;
    procedure ParseObject(var p: PQCharW);
    procedure SkipBom(var p: PQCharW);
    function ParseJsonPair(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
    function ParseName(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
    procedure ParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW);
    function FormatParseError(ACode: Integer; AMsg: QStringW; ps, p: PQCharW): QStringW;
    function FormatParseErrorEx(ACode: Integer; AMsg: QStringW; ps, p: PQCharW): EJsonError;
    procedure RaiseParseException(ACode: Integer; ps, p: PQCharW);
    function TryParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
    function BooleanToStr(const b: Boolean): QStringW;
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
    function ParseJsonTime(p: PQCharW; var ATime: TDateTime): Boolean;
    function CreateJson: TQJson; virtual;
    procedure FreeJson(AJson: TQJson); virtual;
    procedure CopyValue(ASource: TQJson); inline;
    procedure InternalRttiFilter(ASender: TQJson; AObject: Pointer; APropName: QStringW; APropType: PTypeInfo;
      var Accept: Boolean; ATag: Pointer);
    function InternalEncode(ABuilder: TQStringCatHelperW; ASettings: TJsonEncodeSettings; const AIndent: QStringW)
      : TQStringCatHelperW;
    function ArrayItemTypeName(ATypeName: QStringW): QStringW;
    function ArrayItemType(ArrType: PTypeInfo): PTypeInfo;
    procedure DoJsonNameChanged(AJson: TQJson); virtual;
    procedure SetName(const Value: QStringW);
    function GetIsBool: Boolean;
    function GetAsBytes: TBytes;
    procedure SetAsBytes(const Value: TBytes);
    class function SkipSpaceAndComment(var p: PQCharW; var AComment: QStringW; lastvalidchar: QCharW = #0): Integer;
    procedure DoParsed; virtual;
    procedure SetIgnoreCase(const Value: Boolean);
    function HashName(const S: QStringW): TQHashType;
    procedure HashNeeded; inline;
    procedure FromType(const AValue: QStringW; AType: TQJsonDataType);
    function GetRoot: TQJson;
    function DoCompareName(Item1, Item2: Pointer): Integer;
    function DoCompareValueBoolean(Item1, Item2: Pointer): Integer;
    function DoCompareValueDateTime(Item1, Item2: Pointer): Integer;
    function DoCompareValueFloat(Item1, Item2: Pointer): Integer;
    function DoCompareValueInt(Item1, Item2: Pointer): Integer;
    function DoCompareValueString(Item1, Item2: Pointer): Integer;
    function GetA(const APath: String): TQJson;
    function GetB(const APath: String): Boolean;
    function GetF(const APath: String): Double;
    function GetI(const APath: String): Int64;
    function GetO(const APath: String): TQJson;
    function GetS(const APath: String): String;
    function GetT(const APath: String): TDateTime;
    function GetV(const APath: String): Variant;
    procedure SetA(const APath: String; const Value: TQJson);
    procedure SetB(const APath: String; const Value: Boolean);
    procedure SetF(const APath: String; const Value: Double);
    procedure SetI(const APath: String; const Value: Int64);
    procedure SetO(const APath: String; const Value: TQJson);
    procedure SetS(const APath, Value: String);
    procedure SetT(const APath: String; const Value: TDateTime);
    procedure SetV(const APath: String; const Value: Variant);
    function GetAsBase64Bytes: TBytes;
    procedure SetAsBase64Bytes(const Value: TBytes);
    function GetAsHexBytes: TBytes;
    procedure SetAsHexBytes(const Value: TBytes);
    function InternalGetAsBytes(AConverter: TQJsonDecodeBytesEvent; AEncoding: TTextEncoding;
      AWriteBom: Boolean): TBytes;
    procedure InternalSetAsBytes(AConverter: TQJsonEncodeBytesEvent; ABytes: TBytes);
    function InternalFlatItems(var AItems: TQStringArray; AFlatPart: Integer; AOptions: TQCatOptions): Integer;
  public
    /// <summary>���캯��</summary>
    constructor Create; overload;
    constructor Create(const AName, AValue: QStringW; ADataType: TQJsonDataType = jdtUnknown); overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
    { <summary>���һ���ӽ��</summary>
      <param name="ANode">Ҫ��ӵĽ��</param>
      <returns>������ӵĽ������</returns>
    }
    function Add(ANode: TQJson): Integer; overload;
    /// <summary>���һ��δ������JSON�ӽ��</summary>
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>
    /// һ������£������������ͣ���Ӧ���δ������ʵ��
    /// </remarks>
    function Add: TQJson; overload;
    /// <summary>���һ������</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AValue">Ҫ��ӵ����ݵ�ֵ���ʽ���ַ�����</param>
    /// <param name="ADataType">���ʽ���ͣ����ΪjdtUnknown������Զ������������</param>
    /// <returns>���ش����Ľ������</returns>
    function Add(AName, AValue: QStringW; ADataType: TQJsonDataType): Integer; overload;
    /// <summary>���һ������</summary>
    /// <param name="AName">Ҫ��ӵĶ���Ľ������</param>
    /// <param name="AItems">Ҫ��ӵ���������</param>
    /// <returns>���ش����Ľ��ʵ��</returns>
    function Add(const AName: QStringW; AItems: array of const): TQJson; overload;
    { <summary>���һ���ӽ��</summary>
      <param name="AName">Ҫ��ӵĽ����</param>
      <param name="ADataType">Ҫ��ӵĽ���������ͣ����ʡ�ԣ����Զ�����ֵ�����ݼ��</param>
      <returns>������ӵ��¶���</returns>
      <remarks>
      1.�����ǰ���Ͳ���jdtObject��jdtArray�����Զ�ת��ΪjdtObject����
      2.�ϲ�Ӧ�Լ������������
      </remarks>
    }
    function Add(AName: QStringW; ADataType: TQJsonDataType): TQJson; overload;

    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Extended): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Int64): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW; AValue: Boolean): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵ��ӽ��</param>
    /// <returns>������ӵ��¶��������λ��</returns>
    /// <remarks>��ӵĽ���ͷŹ�������㸺���ⲿ��Ӧ���ͷ�</remarks>
    function Add(AName: QStringW; AChild: TQJson): Integer; overload;
    /// <summary>���һ�����������ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddArray(AName: QStringW): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddDateTime(AName: QStringW; AValue: TDateTime): TQJson; overload;
    /// <summary>���һ���ӽ��</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function AddVariant(AName: QStringW; AValue: Variant): TQJson; overload;
    /// <summary>���һ���ӽ��(Null)</summary>
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName: QStringW): TQJson; overload; virtual;

    function Insert(AIndex: Integer; const AName: String): TQJson; overload;
    function Insert(AIndex: Integer; const AName: String; ADataType: TQJsonDataType): TQJson; overload;
    function Insert(AIndex: Integer; const AName, AValue: String; ADataType: TQJsonDataType = jdtString)
      : TQJson; overload;
    function Insert(AIndex: Integer; const AName: String; AValue: Extended): TQJson; overload;
    function Insert(AIndex: Integer; const AName: String; AValue: Int64): TQJson; overload;
    function Insert(AIndex: Integer; const AName: String; AValue: Boolean): TQJson; overload;
    procedure Insert(AIndex: Integer; AChild: TQJson); overload;
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
    function ForcePath(APath: QStringW): TQJson;
    /// <summary>ȷ��ָ�����Ƶ��ӽ�����</summary>
    /// <param name="AName">�ӽ������</param>
    /// <param name="AType">�ӽ�������</param>
    /// <returns>����ӽ����ڣ��򷵻�ָ�����ӽ�㣬��������ڣ�������ӽ�㲢����</returns>
    /// <remarks>�� Add ���������������������ӽ���Ƿ���ڣ��Ա����ظ����� Add ����顣��ForcePath���������ڲ���ʶ�������е������ַ����Ӷ����������������</remarks>
    function ForceName(AName: QStringW; AType: TQJsonDataType = jdtNull): TQJson;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="p">Ҫ�������ַ���</param>
    /// <param name="l">�ַ������ȣ�<=0��Ϊ����\0(#0)��β��C���Ա�׼�ַ���</param>
    /// <remarks>���l>=0������p[l]�Ƿ�Ϊ\0�������Ϊ\0����ᴴ������ʵ������������ʵ��</remarks>
    procedure Parse(p: PWideChar; l: Integer = -1); overload;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="s">Ҫ������JSON�ַ���</param>
    procedure Parse(const S: QStringW); overload;
    /// <summary>ֱ�ӽ�һ��JSON�ַ�������Ϊ���飬��{"a":1}{"b":2}</summary>
    /// <param name="S">Ҫ������JSON�ַ���</param>
    procedure ParseMultiBlock(const S: QStringW);
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="p">Ҫ������JSON�ַ���</param>
    /// <param name="l">Ҫ������JSON�ַ�������</param>
    function TryParse(p: PWideChar; l: Integer = -1): Boolean; overload;
    function TryParseBlock(var p: PWideChar): Boolean;
    /// <summary>����ָ����JSON�ַ���</summary>
    /// <param name="s">Ҫ������JSON�ַ���</param>
    function TryParse(const S: QStringW): Boolean; overload;
    /// <summmary>�����н����׸�JSON���ݿ�</summary>
    /// <param name="AStream">������</param>
    /// <param name="AEncoding">�����ݵı��뷽ʽ</param>
    /// <remarks>ParseBlock�ʺϽ����ֶ�ʽJSON������ӵ�ǰλ�ÿ�ʼ����������ǰ�������Ϊֹ.
    /// ���Ժܺõ����㽥��ʽ�������Ҫ</remarks>
    procedure ParseBlock(AStream: TStream; AEncoding: TTextEncoding);
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function Copy: TQJson;
{$IF RTLVersion>=21}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEventA): TQJson; overload;
{$IFEND >=2010}
    /// <summary>��������һ���µ�ʵ��</summary>
    /// <param name="ATag">�û����ӵı�ǩ����</param>
    /// <param name="AFilter">�û������¼������ڿ���Ҫ����������</param>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊ�ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ����������һ��
    /// ���󣬲��������һ���������Ӱ�졣
    /// </remarks>
    function CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEvent): TQJson; overload;
    /// <summary>��¡����һ���µ�ʵ��</summary>
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊʵ����ִ�е��ǿ����������¾ɶ���֮������ݱ��û���κι�ϵ��
    /// ��������һ�����󣬲��������һ���������Ӱ�죬������Ϊ����������֤������
    /// �����Ϊ���ã��Ա��໥Ӱ�졣
    /// </remarks>
    function Clone: TQJson;
    /// <summary>����Ϊ�ַ���</summary>
    /// <param name="ADoFormat">�Ƿ��ʽ���ַ����������ӿɶ���</param>
    /// <param name="ADoEscape">�Ƿ�ת�����ĸ�������ַ�</param>
    /// <param name="AIndent">ADoFormat����ΪTrueʱ���������ݣ�Ĭ��Ϊ�����ո�</param>
    /// <returns>���ر������ַ���</returns>
    /// <remarks>AsJson�ȼ���Encode(True,'  ')</remarks>
    function Encode(ADoFormat: Boolean; ADoEscape: Boolean = False; AIndent: QStringW = '  '): QStringW; overload;
    function Encode(ASettings: TJsonEncodeSettings; AIndent: QStringW = '  '): QStringW; overload;
    /// <summary>����Ϊ�ֽ�����</summary>
    /// <param name="AEncoding">���ݱ���</param>
    /// <param name="ASettings">��ʽ������</param>
    /// <param name="AIndent">��ʽ��ʱ������Ĭ��Ϊ�����ո�</param>
    /// <returns>���ر������ֽ�����</returns>
    function EncodeToBytes(AEncoding: TTextEncoding; ASettings: TJsonEncodeSettings; AIndent: QStringW = '  '): TBytes;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>����Ӧ����ֵ</returns>
    function ValueByName(AName, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ�Ĳ���ֵ��ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>����Ӧ����ֵ</returns>
    function BoolByName(AName: QStringW; ADefVal: Boolean): Boolean;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ������ֵ��ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>����Ӧ����ֵ</returns>
    function IntByName(AName: QStringW; ADefVal: Int64): Int64;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ�ĸ���ֵ��ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>����Ӧ����ֵ</returns>
    function FloatByName(AName: QStringW; ADefVal: Extended): Extended;
    /// <summary>��ȡָ�����ƻ�ȡ����ֵ������ʱ��ֵ��ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>����Ӧ����ֵ</returns>
    function DateTimeByName(AName: QStringW; ADefVal: TDateTime): TDateTime;
    /// <summary>��ȡָ��·������ֵ���ַ�����ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function ValueByPath(APath, ADefVal: QStringW): QStringW;
    /// <summary>��ȡָ��·������ֵ�Ĳ���ֵ��ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function BoolByPath(APath: QStringW; ADefVal: Boolean): Boolean;
    /// <summary>��ȡָ��·������ֵ��������ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function IntByPath(APath: QStringW; ADefVal: Int64): Int64;
    /// <summary>��ȡָ��·������ֵ�ĸ�������ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function FloatByPath(APath: QStringW; ADefVal: Extended): Extended;
    /// <summary>��ȡָ��·������ֵ������ʱ���ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function DateTimeByPath(APath: QStringW; ADefVal: TDateTime): TDateTime;
    /// <summary>��ȡָ��·�����Ķ����Ʊ�ʾ</summary>
    /// <param name="AName">�������</param>
    /// <param name="ADefVal">Ĭ��ֵ</param>
    /// <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    function BytesByPath(APath: QStringW; ADefVal: TBytes): TBytes;
    /// <summary>��ȡָ�����Ƶĵ�һ�����</summary>
    /// <param name="AName">�������</param>
    /// <returns>�����ҵ��Ľ�㣬���δ�ҵ������ؿ�(NULL/nil)</returns>
    /// <remarks>ע��QJson���������������ˣ�������������Ľ�㣬ֻ�᷵�ص�һ�����</remarks>
    function ItemByName(AName: QStringW): TQJson; overload; virtual;
    /// <summary>��ȡָ�����ƵĽ�㵽�б���</summary>
    /// <param name="AName">�������</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    /// <remarks>�˺�����֧�ְ������±귽ʽ����</remarks>
    function ItemByName(const AName: QStringW; AList: TQJsonItemList; ANest: Boolean = False): Integer; overload;
{$IFDEF ENABLE_REGEX}
    /// <summary>��ȡ����ָ�����ƹ���Ľ�㵽�б���</summary>
    /// <param name="ARegex">������ʽ</param>
    /// <param name="AList">���ڱ�������б����</param>
    /// <param name="ANest">�Ƿ�ݹ�����ӽ��</param>
    /// <returns>�����ҵ��Ľ�����������δ�ҵ�������0</returns>
    function ItemByRegex(const ARegex: QStringW; AList: TQJsonItemList; ANest: Boolean = False): Integer; overload;
    function Match(const ARegex: QStringW; AMatches: TQJsonMatchSettings): IQJsonContainer;
{$ENDIF}
    /// <summary>��ȡָ��·����JSON����</summary>
    /// <param name="APath">·������"."��"/"��"\"�ָ�</param>
    /// <returns>�����ҵ����ӽ�㣬���δ�ҵ�����NULL(nil)</returns>
    /// <remarks>�������������ӽ�㣬����ֱ��ʹ���±������ʣ���������Ͷ����ӽ�㣬����ʹ��[][]�����������ʡ�</remarks>
    function ItemByPath(APath: QStringW): TQJson;
    /// <summary>��Դ������JSON��������</summary>
    /// <param name="ANode">Ҫ���Ƶ�Դ���</param>
    /// <remarks>ע�ⲻҪ�����ӽ����Լ�������������ѭ����Ҫ�����ӽ�㣬�ȸ�
    /// ��һ���ӽ�����ʵ�����ٴ���ʵ������
    /// </remarks>
    procedure Assign(ANode: TQJson); virtual;
    /// <summary>ɾ��ָ���������ӽ��</summary>
    /// <param name="AIndex">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���ָ�������Ľ�㲻���ڣ����׳�EOutRange�쳣
    /// </remarks>
    procedure Delete(AIndex: Integer); overload; virtual;
    /// <summary>ɾ��ָ�����Ƶ��ӽ��</summary>
    /// <param name="AName">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���Ҫ��������Ľ�㣬��ֻɾ����һ��
    procedure Delete(AName: QStringW); overload;
    /// <summary>�Ӹ������ɾ���������û�и���㣬���ͷ��Լ�</summary>
    procedure Delete; overload;
{$IF RTLVersion>=21}
    /// <summary>
    /// ɾ�������������ӽ��
    /// </summary>
    /// <param name="ATag">�û��Լ����ӵĶ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEventA); overload;
{$IFEND >=2010}
    /// <summary>
    /// ɾ�������������ӽ��
    /// </summary>
    /// <param name="ATag">�û��Լ����ӵĶ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���ȼ���Clear</param>
    procedure DeleteIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEvent); overload;
    /// <summary>����ָ�����ƵĽ�������</summary>
    /// <param name="AName">Ҫ���ҵĽ������</param>
    /// <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOf(const AName: QStringW): Integer; virtual;
    /// <summary>����ָ����ֵ�Ľ������</summary>
    /// <param name="AValue">Ҫ���ҵĽ��ֵ</param>
    /// <param name="AStrict">�Ƿ��ϸ�ģʽ�Ƚ�</param>
    /// <returns>��������ֵ��δ�ҵ�����-1</returns>
    function IndexOfValue(const AValue: Variant; AStrict: Boolean = False): Integer;
    /// <summary>�������е��ӽ��</summary>
    /// <param name="ACallback">�����ص�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    procedure ForEach(ACallback: TQJsonFilterEvent; ANest: Boolean; const ATag: Pointer); overload;
{$IF RTLVersion>=21}
    /// <summary>�������е��ӽ��</summary>
    /// <param name="ACallback">�����ص�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    procedure ForEach(ACallback: TQJsonFilterEventA; ANest: Boolean; const ATag: Pointer); overload;
    /// <summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEventA): TQJson; overload;
{$IFEND >=2010}
    /// <summary>���������ҷ��������Ľ��</summary>
    /// <param name="ATag">�û��Զ���ĸ��Ӷ�����</param>
    /// <param name="ANest">�Ƿ�Ƕ�׵��ã����Ϊfalse����ֻ�Ե�ǰ�ӽ�����</param>
    /// <param name="AFilter">���˻ص����������Ϊnil���򷵻�nil</param>
    function FindIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEvent): TQJson; overload;
    /// <summary>������еĽ��</summary>
    procedure Clear; virtual;
    /// <summary>���浱ǰ�������ݵ�����</summary>
    /// <param name="AStream">Ŀ��������</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBom">�Ƿ�д��BOM</param>
    /// <param name="ADoFormat">�Ƿ��ʽ������</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream: TStream; AEncoding: TTextEncoding = teUtf8; AWriteBom: Boolean = True;
      ADoFormat: Boolean = True); overload;
    /// <summary>���浱ǰ�������ݵ�����</summary>
    /// <param name="AStream">Ŀ��������</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBom">�Ƿ�д��BOM</param>
    /// <param name="ASettings">�������</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream: TStream; ASettings: TJsonEncodeSettings; AEncoding: TTextEncoding = teUtf8;
      AWriteBom: Boolean = True); overload;

    /// <summary>�����ĵ�ǰλ�ÿ�ʼ����JSON����</summary>
    /// <param name="AStream">Դ������</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    /// <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream: TStream; AEncoding: TTextEncoding = teUnknown);
    procedure LoadFromResource(AInstance: HINST; const AResourceName: String; AEncoding: TTextEncoding = teUnknown);
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    /// <param name="AFileName">�ļ���</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    /// <param name="ADoFormat">�Ƿ��ʽ��Json���</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(const AFileName: String; AEncoding: TTextEncoding = teUtf8; AWriteBom: Boolean = True;
      ADoFormat: Boolean = True); overload;
    /// <summary>���浱ǰ�������ݵ��ļ���</summary>
    /// <param name="AFileName">�ļ���</param>
    /// <param name="AEncoding">�����ʽ</param>
    /// <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    /// <param name="ASettings">�������</param>
    /// <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(const AFileName: String; ASettings: TJsonEncodeSettings; AEncoding: TTextEncoding = teUtf8;
      AWriteBom: Boolean = True); overload;
    /// <summary>��ָ�����ļ��м��ص�ǰ����</summary>
    /// <param name="AFileName">Ҫ���ص��ļ���</param>
    /// <param name="AEncoding">Դ�ļ����룬���ΪteUnknown�����Զ��ж�</param>
    procedure LoadFromFile(const AFileName: String; AEncoding: TTextEncoding = teUnknown);
    /// / <summary>����ֵΪNull���ȼ���ֱ������DataTypeΪjdtNull</summary>
    procedure ResetNull;
    function Escape(const S: QStringW): QStringW;
    /// <summary>����TObject.ToString����</summary>
    function ToString: string; {$IFDEF UNICODE}override; {$ELSE}virtual;
{$ENDIF}
    /// <summary>��ȡfor..in��Ҫ��GetEnumerator֧��</summary>
    function GetEnumerator: TQJsonEnumerator;
    /// <summary>�ж��Լ��Ƿ���ָ��������Ӷ���</summmary>
    /// <param name="AParent">���ܵĸ�����</param>
    /// <returns>���AParent���Լ��ĸ����󣬷���True�����򷵻�false</returns>
    function IsChildOf(AParent: TQJson): Boolean;
    /// <summary>�ж��Լ��Ƿ���ָ������ĸ�����</summmary>
    /// <param name="AChild">���ܵ��Ӷ���</param>
    /// <returns>���AChild���Լ����Ӷ��󣬷���True�����򷵻�false</returns>
    function IsParentOf(AChild: TQJson): Boolean;
{$IF RTLVersion>=21}
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
    /// <param name="AClearCollections">�Ƿ��ڻָ�TCollection�����Ԫ��ʱ���������е�Ԫ��,Ĭ��Ϊtrur</param>
    /// <remarks>ʵ���ϲ���ֻ֧�ֶ��󣬼�¼����Ŀǰ�޷�ֱ��ת��ΪTValue������û
    /// ���壬������������Ϊ��ֵ������ʵ�ʾ��㸳ֵ��Ҳ���ز��ˣ����������</remarks>
    procedure ToRtti(AInstance: TValue; AClearCollections: Boolean = True); overload;
    /// <summary>�ӵ�ǰJSON�а�ָ����������Ϣ��ԭ��ָ���ĵ�ַ</summary>
    /// <param name="ADest">Ŀ�ĵ�ַ</param>
    /// <param name="AType">�����ṹ���������Ϣ</param>
    /// <param name="AClearCollections">�Ƿ��ڻָ�TCollection�����Ԫ��ʱ���������е�Ԫ��,Ĭ��Ϊtrur</param>
    /// <remarks>ADest��Ӧ��Ӧ�Ǽ�¼������������Ͳ���֧��</remarks>
    procedure ToRtti(ADest: Pointer; AType: PTypeInfo; AClearCollections: Boolean = True); overload;
    /// <summary>�ӵ�ǰ��JSON�л�ԭ��ָ���ļ�¼ʵ����</summary>
    /// <param name="ARecord">Ŀ�ļ�¼ʵ��</param>
    /// <param name="AClearCollections">�Ƿ��ڻָ�TCollection�����Ԫ��ʱ���������е�Ԫ��,Ĭ��Ϊtrur</param>
    procedure ToRecord<T: record >(var ARecord: T; AClearCollections: Boolean = True);
{$IFEND}
    /// <summary>��ָ���������ӽ���Ƴ�</summary>
    /// <param name="AItemIndex">Ҫ�Ƴ����ӽ������</param>
    /// <returns>���ر��Ƴ����ӽ�㣬���ָ�������������ڣ�����nil</returns>
    /// <remarks>���Ƴ����ӽ����Ҫ�û��Լ��ֹ��ͷ�</remarks>
    function Remove(AItemIndex: Integer): TQJson; overload; virtual;
    /// <summary>��ָ�����ӽ���Ƴ�</summary>
    /// <param name="AJson">Ҫ�Ƴ����ӽ��</param>
    /// <remarks>���Ƴ����ӽ����Ҫ�û��Լ��ֹ��ͷ�</remarks>
    procedure Remove(AJson: TQJson); overload;
    /// <summary>�ӵ�ǰ������з��뵱ǰ���</summary>
    /// <remarks>�����Ľ����Ҫ�����ͷ�</remarks>
    procedure Detach;
    /// <summary>����ǰ��㸽�ӵ��µĸ������</summary>
    /// <param name="AParent">Ҫ���ӵ�Ŀ����</param>
    /// <remarks>���Ӻ�Ľ���ɸ���㸺���ͷ�</remarks>
    procedure AttachTo(ANewParent: TQJson);
    /// <summary>����ǰ����ƶ����µĸ�����ָ��λ��</summary>
    /// <param name="ANewParent">�µĸ����</param>
    /// <param name="AIndex">��λ������</param>
    /// <remarks>�����λ������С�ڵ���0������뵽��ʼλ�ã�������ڸ������н������������뵽
    /// �����ĩβ��������ӵ�ָ��λ��</remarks>
    procedure MoveTo(ANewParent: TQJson; AIndex: Integer);

    /// <summary>�����м��ض���������</summary>
    /// <param name="AStream">Դ������</param>
    /// <param name="ACount">���ȣ����Ϊ0����ȫ��</param>
    procedure ValueFromStream(AStream: TStream; ACount: Cardinal);
    /// <summary>������������д�뵽����</summary>
    /// <param name="AStream">Ŀ��������</param>
    procedure StreamFromValue(AStream: TStream);

    /// <summary>�����м��ض���������</summary>
    /// <param name="AStream">Դ�ļ���</param>
    procedure ValueFromFile(AFileName: QStringW);
    /// <summary>������������д�뵽����</summary>
    /// <param name="AStream">Ŀ���ļ���</param>
    procedure FileFromValue(AFileName: QStringW);
    /// <summary>�ж��Ƿ��з���ָ��·��Ҫ����ӽ�㣬������ڣ�ͨ������AChild����ʵ����ַ������True�����򷵻�False</summary>
    /// <param name="ANamePath">���·�����ָ������ܡ�.������/������\������</param>
    /// <param name="AChild">���ڷ����ӽ��ָ��</param>
    /// <returns>�ɹ�������True��AChild��ֵΪ�ӽ��ָ�룬ʧ�ܣ�����False</returns>
    function HasChild(ANamePath: QStringW; var AChild: TQJson): Boolean; inline;
    /// <summary>��ȡ��ָ�����������·��</summary>
    /// <param name="AParent">Ŀ�길���</param>
    /// <param name="APathDelimiter">·���ָ���</param>
    /// <returns>�������·��</returns>
    function GetRelPath(AParent: TQJson; APathDelimiter: QCharW = '\'): QStringW;
    /// <summary>�����ӽ��</summary>
    /// <param name="AByName">�Ƿ���������</param>
    /// <param name="ANest">�Ƿ������ӽ��</param>
    /// <param name="AByType">�ӽ��������������ݣ����ΪjdtUnknown�����Զ���⣬����ָ������������</param>
    /// <param name="AOnCompare">����ȽϷ����������ָ������Ĭ�Ϲ������򣬷��������������</param>
    /// <remarks>AByType�����ΪjdtUnknown��������豣֤�ӽ���ֵ�ܹ�ת��ΪĿ������</remarks>
    procedure Sort(AByName, ANest: Boolean; AByType: TQJsonDataType; AOnCompare: TListSortCompareEvent); overload;
    /// <summary>�����ӽ��</summary>
    /// <param name="AByName">�Ƿ���������</param>
    /// <param name="ANest">�Ƿ������ӽ��</param>
    /// <param name="AByType">�ӽ��������������ݣ����ΪjdtUnknown�����Զ���⣬����ָ������������</param>
    /// <param name="AOnCompare">����ȽϷ����������ָ������Ĭ�Ϲ������򣬷��������������</param>
    /// <remarks>AByType�����ΪjdtUnknown��������豣֤�ӽ���ֵ�ܹ�ת��ΪĿ������</remarks>
    procedure Sort(AByName, ANest: Boolean; AByType: TQJsonDataType; AOnCompare: TListSortCompare); overload;
{$IF RTLVersion>=21}
    /// <summary>�����ӽ��</summary>
    /// <param name="AByName">�Ƿ���������</param>
    /// <param name="ANest">�Ƿ������ӽ��</param>
    /// <param name="AByType">�ӽ��������������ݣ����ΪjdtUnknown�����Զ���⣬����ָ������������</param>
    /// <param name="AOnCompare">����ȽϷ����������ָ������Ĭ�Ϲ������򣬷��������������</param>
    /// <remarks>AByType�����ΪjdtUnknown��������豣֤�ӽ���ֵ�ܹ�ת��ΪĿ������</remarks>
    procedure Sort(AByName, ANest: Boolean; AByType: TQJsonDataType; AOnCompare: TListSortCompareFunc); overload;
{$IFEND}
    /// <summary>��ת���˳��</summary>
    /// <param name="ANest">�Ƿ�Ƕ����ת</param>
    procedure RevertOrder(ANest: Boolean = False);
    /// <summary>������������˳��</summary>
    /// <param name="AIndex1">��һ���������<param>
    /// <param name="AIndex2">�ڶ����������</param>
    procedure ExchangeOrder(AIndex1, AIndex2: Integer);
    /// <summary>�ж��Ƿ����ָ�����Ƶ��ӽ��</summary>
    /// <param name="AName">�������</param>
    /// <param name="ANest">�Ƿ�Ƕ�׼���ӽ��</param>
    /// <returns>����������true�����򣬷���false</returns>
    function ContainsName(AName: QStringW; ANest: Boolean = False): Boolean;
    /// <summary>�ж��Ƿ����ָ�����Ƶ��ӽ��</summary>
    /// <param name="AValue">���ֵ</param>
    /// <param name="ANest">�Ƿ�Ƕ�׼���ӽ��</param>
    /// <param name="AStrict">�Ƿ��ϸ�Ҫ������ƥ��</param>
    /// <returns>����������true�����򣬷���false</returns>
    function ContainsValue(const AValue: Variant; ANest: Boolean = False; AStrict: Boolean = False): Boolean;
    /// <summary>�ж��Ƿ����ָ��·�����ӽ��</summary>
    /// <param name="APath">Ҫ���ҵĽ������</param>
    /// <returns>����������true��ʧ�ܣ�����false</returns>
    /// <remarks>�˺����ȼ���ItemByPath(APath)<>nil</remarks>
    function Exists(const APath: QStringW): Boolean; inline;
    /// <summary>�ϲ�ԴJSON�����ݵ���ǰJSON</summary>
    /// <param name="ASource">ԴJSON</param>
    /// <param name="AMethod">�ϲ���ʽ</param>
    /// <remarks>
    /// ��ͬ�ĺϲ���ʽЧ�����£�
    /// jmmIgnore : ����Դ���ظ�����Ŀ�ϲ�
    /// jmmAppend : ׷��Ϊ�ظ�����Ŀ
    /// jmmAsSource : �滻ΪԴ�е�����
    /// </remarks>
    procedure Merge(ASource: TQJson; AMethod: TQJsonMergeMethod);
    /// <summary>�ж�JSON�����Ƿ���ͬ</summary>
    /// <returns>�������һ�£��򷵻� true�����򷵻� false</returns>
    function Equals(AJson: TQJson): Boolean; reintroduce;
    /// <summary>��ȡ����JSON��������ͬ�Ĳ��֣����Ż���</summary>
    /// <param name="AJson">Ҫ����Ƚϵ�JSON����</param>
    /// <returns>��������JSON���Ӽ�</returns>
    /// <remarks>����ֵ��Ҫ�ֶ��ͷ�</remarks>
    function Intersect(AJson: TQJson): TQJson;
    /// <summary>��ȡ����JSON�����ݲ�ͬ�Ĳ��֣����Ż���</summary>
    /// <param name="AJson">Ҫ����Ƚϵ�JSON����</param>
    /// <returns>��������JSON�Ĳ</returns>
    /// <remarks>����ֵ��Ҫ�ֶ��ͷ�</remarks>
    function Diff(AJson: TQJson): TQJson;
    /// <summary>���ø����ֵΪĬ��״̬</summary>
    /// <param name="ADetach">�Ƿ�Ӹ�������Ƴ��Լ�</param>
    procedure Reset(ADetach: Boolean); virtual;
    /// <summary>�����Ƽ��뵽һ��TStrings ��</summary>
    function NameArray: TArray<String>;
    function ValueArray: TArray<String>;
    function CatNames(const AQuoter, ADelimiter: QCharW; AOptions: TQCatOptions): QStringW;
    function CatValues(const AQuoter, ADelimiter: QCharW; AOptions: TQCatOptions): QStringW;
    function FlatNames(AOptions: TQCatOptions): TQStringArray;
    function FlatValues(AOptions: TQCatOptions): TQStringArray;
    function NameToStrings(AList: TStrings; AOptions: TQCatOptions): Integer;
    function ValuesToStrings(AList: TStrings; AOptions: TQCatOptions): Integer; overload;
    function ValuesToStrings(AOptions: TQCatOptions): TQStringArray; overload;
    procedure ValuesFromStrings(const AValues: TQStringArray; AIsReplace: Boolean = True; AStartIndex: Integer = 0;
      ACount: Integer = MaxInt); overload;
    procedure ValuesFromStrings(AList: TStrings; AIsReplace: Boolean = True; AStartIndex: Integer = 0;
      ACount: Integer = MaxInt); overload;
    procedure ValuesFromIntegers(const AValues: TIntArray; AIsReplace: Boolean = True; AStartIndex: Integer = 0;
      ACount: Integer = MaxInt);
    procedure ValuesFromInt64s(const AValues: TInt64Array; AIsReplace: Boolean = True; AStartIndex: Integer = 0;
      ACount: Integer = MaxInt);
    procedure ValuesFromFloats(const AValues: TFloatArray; AIsReplace: Boolean = True; AStartIndex: Integer = 0;
      ACount: Integer = MaxInt);

    // ת��һ��JsonֵΪ�ַ���
    class function BuildJsonString(ABuilder: TQStringCatHelperW; var p: PQCharW): Boolean; overload;
    class function BuildJsonString(S: QStringW): QStringW; overload;
    class function BuildJsonString(ABuilder: TQStringCatHelperW; S: QStringW): Boolean; overload;
    class procedure JsonCat(ABuilder: TQStringCatHelperW; const S: QStringW; ASettings: TJsonEncodeSettings); overload;
    class function JsonCat(const S: QStringW; ASettings: TJsonEncodeSettings): QStringW; overload;
    class function JsonEscape(const S: QStringW; ASettings: TJsonEncodeSettings = [jesDoEscape]): QStringW; overload;
    class function JsonUnescape(const S: QStringW): QStringW;
    class function EncodeDateTime(const AValue: TDateTime): QStringW;
    procedure Replace(AIndex: Integer; ANewItem: TQJson); virtual;
    /// <summary>�����</summary>
    property Parent: TQJson read FParent;
    /// <summary>�������</summary>
    /// <seealso>TQJsonDataType</seealso>
    property DataType: TQJsonDataType read FDataType write SetDataType;
    /// <summary>�������</summary>
    property Name: QStringW read FName write SetName;
    /// <summary>���ڡ�ʱ�䡢�����ʽ���ã���������ʱ�����ͣ�������������ã�����ȫ������</summary>
    property ValueFormat: QStringW read FValueFormat write FValueFormat;
    /// <summary>�ӽ������</<summary>summary>
    property Count: Integer read GetCount;
    /// <summary>�ӽ������</summary>
    property Items[AIndex: Integer]: TQJson read GetItems; default;
    /// <summary>�ӽ���ֵ</summary>
    property Value: QStringW read GetValue write SetValue;
    /// <summary>�ж��Ƿ��ǲ�������</summary>
    property IsBool: Boolean read GetIsBool;
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
    /// <summary>����ǰ��㵱����������������</summary>
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    /// <summary>����ǰ��㵱��64λ��������������</summary>
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    /// <summary>����ǰ��㵱����������������</summary>
    property AsFloat: Extended read GetAsFloat write SetAsFloat;
    /// <summary>����ǰ��㵱��BCDֵ������
    property AsBcd: TBcd read GetAsBcd write SetAsBcd;
    /// <summary>����ǰ��㵱������ʱ������������</summary>
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    /// <summary>����ǰ��㵱���ַ������ͷ���</summary>
    property AsString: QStringW read GetAsString write SetAsString;
    /// <summary>����ǰ��㵱��һ�������ַ���������</summary>
    property AsObject: QStringW read GetAsObject write SetAsObject;
    /// <summary>����ǰ��㵱��һ���ַ�������������</summary>
    property AsArray: QStringW read GetAsArray write SetAsArray;
    /// <summary>���Լ�����Variant����������</summary>
    property AsVariant: Variant read GetAsVariant write SetAsVariant;
    /// <summary>���Լ�����Json����������</summary>
    property AsJson: QStringW read GetAsJson write SetAsJson;
    /// <summary>���Լ��������������ݷ���</summary>
    property AsBytes: TBytes read GetAsBytes write SetAsBytes;
    property AsHexBytes: TBytes read GetAsHexBytes write SetAsHexBytes;
    property AsBase64Bytes: TBytes read GetAsBase64Bytes write SetAsBase64Bytes;
    // <summary>����ĸ������ݳ�Ա�����û�������������</summary>
    property Data: Pointer read FData write FData;
    /// <summary>����·����·���м���"\"�ָ�</summary>
    property Path: QStringW read GetPath;

    /// <summary>�ڸ�����е�����˳�򣬴�0��ʼ�������-1��������Լ��Ǹ����</summary>
    property ItemIndex: Integer read GetItemIndex;
    /// <summary>���ƹ�ϣֵ</summary>
    property NameHash: TQHashType read FNameHash;
    /// <summary>�ȽϺ��Ƿ���Դ�Сд</summary>
    property IgnoreCase: Boolean read FIgnoreCase write SetIgnoreCase;
    /// <summary>��JSON���</summary>
    property Root: TQJson read GetRoot;
    /// <summary>ע����ʽ</summary>
    property CommentStyle: TQJsonCommentStyle read FCommentStyle write FCommentStyle;
    /// <summary>ע������</summary>
    property Comment: QStringW read FComment write FComment;
    // Super Object ���ݷ���ģʽ
{$IFDEF SUPER_OBJECT_STYLE}
    property S[const APath: String]: String read GetS write SetS;
    property b[const APath: String]: Boolean read GetB write SetB;
    property F[const APath: String]: Double read GetF write SetF;
    property O[const APath: String]: TQJson read GetO write SetO;
    property A[const APath: String]: TQJson read GetA write SetA;
    property V[const APath: String]: Variant read GetV write SetV;
    property T[const APath: String]: TDateTime read GetT write SetT;
    property I[const APath: String]: Int64 read GetI write SetI;
{$ENDIF}
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

  TQHashedJson = class(TQJson)
  protected
    FHashTable: TQHashTable;
    function CreateJson: TQJson; override;
    procedure FreeJson(AJson: TQJson); override;
    procedure DoJsonNameChanged(AJson: TQJson); override;
    procedure DoParsed; override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Assign(ANode: TQJson); override;
    procedure Replace(AIndex: Integer; ANewItem: TQJson); override;
    function IndexOf(const AName: QStringW): Integer; override;
    function ItemByName(AName: QStringW): TQJson; overload; override;
    function Remove(AIndex: Integer): TQJson; override;
    procedure Clear; override;
  end;

  PQStreamHelperStack = ^TQStreamHelperStack;

  TQStreamHelperStack = record
    Count: Integer;
    Prior: PQStreamHelperStack;
  end;

  TQJsonStreamHelper = record
  private
    FEncoding: TTextEncoding;
    FStream: TStream;
    FDoEscape: Boolean;
    FWriteBom: Boolean;
    FLast: PQStreamHelperStack;
    FStringHelper: TQStringCatHelperW;
    procedure InternalWriteString(S: QStringW; ADoAppend: Boolean = True); inline;
    procedure Push;
    procedure Pop;
  public
    procedure BeginWrite(AStream: TStream; AEncoding: TTextEncoding; ADoEscape: Boolean = False;
      AWriteBom: Boolean = True);
    procedure EndWrite;
    procedure BeginObject; overload;
    procedure BeginObject(const AName: QStringW); overload;
    procedure EndObject;
    procedure BeginArray; overload;
    procedure BeginArray(const AName: QStringW); overload;
    procedure EndArray;
    procedure WriteName(const S: QStringW);
    procedure Write(const S: QStringW); overload;
    procedure Write(const I: Int64); overload;
    procedure Write(const D: Double); overload;
    procedure WriteDateTime(const V: TDateTime); overload;
    procedure Write(const c: Currency); overload;
    procedure Write(const ABytes: TBytes); overload;
    procedure Write(const p: PByte; l: Integer); overload;
    procedure WriteNull; overload;
    procedure Write(const b: Boolean); overload;
    procedure Write(const AName, AValue: QStringW); overload;
    procedure Write(const AName: QStringW; AValue: Int64); overload;
    procedure Write(const AName: QStringW; AValue: Double); overload;
    procedure Write(const AName: QStringW; AValue: TBytes); overload;
    procedure Write(const AName: QStringW; AValue: Boolean); overload;
    procedure WriteDateTime(const AName: QStringW; AValue: TDateTime); overload;
    procedure Write(const AName: QStringW; const p: PByte; const l: Integer); overload;
    procedure WriteNull(const AName: QStringW); overload;
    property DoEscape: Boolean read FDoEscape write FDoEscape;
  end;

  TJsonDatePrecision = (jdpMillisecond, jdpSecond);
  TJsonIntToTimeStyle = (tsDeny, tsSecondsFrom1970, tsSecondsFrom1899, tsMsFrom1970, tsMsFrom1899);

const
  JSON_NO_TIMEZONE = -128;

var
  /// <summary>�Ƿ������ϸ���ģʽ�����ϸ�ģʽ�£�
  /// 1.���ƻ��ַ�������ʹ��˫���Ű�������,���ΪFalse�������ƿ���û�����Ż�ʹ�õ����š�
  /// 2.ע�Ͳ���֧�֣����ΪFalse����֧��//��ע�ͺ�/**/�Ŀ�ע��
  /// </summary>
  StrictJson: Boolean;
  /// <summary>ָ����δ���RTTI�е�ö�ٺͼ�������</summary>
  JsonRttiEnumAsInt: Boolean;
  /// <summary>��������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonDateFormat: QStringW;
  /// <summary>ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonTimeFormat: QStringW;
  /// <summary>����ʱ������ת��ΪJson����ʱ��ת�����ַ������������������θ�ʽ��</summary>
  JsonDateTimeFormat: QStringW;
  /// <summary>Json ����ʱ�����͵�ʱ��������Strictģʽ����Ч������Ϊ��Ӧ��ʱ�����Ա����</summary>
  JsonTimezone: Shortint;
  /// <summary>Json �ϸ�ģʽ���������͵ľ��ȣ�Ĭ��Ϊ���룬��������Ϊ���Ա���ĳЩϵͳ����</summary>
  JsonDatePrecision: TJsonDatePrecision;
  JsonIntToTimeStyle: TJsonIntToTimeStyle;
  /// <summary>��ItemByName/ItemByPath/ValueByName/ValueByPath�Ⱥ������ж��У��Ƿ��������ƴ�Сд</summary>
  JsonCaseSensitive: Boolean;
  /// ����Ҫ�½�һ��TQJson����ʱ����
  OnQJsonCreate: TQJsonCreateEvent;
  /// ����Ҫ�ͷ�һ��TQJson����ʱ����
  OnQJsonFree: TQJsonFreeEvent;
  /// �ַ������ֽ���֮���ת���¼�
  OnQJsonEncodeBytes: TQJsonEncodeBytesEvent;
  OnQJsonDecodeBytes: TQJsonDecodeBytesEvent;
  // �ַ���ֵ����ʼ���
  CharStringStart: QStringW = '"';
  // �ַ���ֵ�Ľ������
  CharStringEnd: QStringW = '"';
  // JSON���ƿ�ʼ���
  CharNameStart: QStringW = '"';
  // JSON���ƽ������
  CharNameEnd: QStringW = '":';
  // JSON ���鿪ʼ���
  CharArrayStart: QStringW = '[';
  // JSON ����������
  CharArrayEnd: QStringW = ']';
  // JSON ����ʼ���
  CharObjectStart: QStringW = '{';
  // JSON ����������
  CharObjectEnd: QStringW = '}';
  // JSON NULL ֵ
  CharNull: QStringW = 'null';
  // JSON �ٵ�ֵ
  CharFalse: QStringW = 'false';
  // JSON ���ֵ
  CharTrue: QStringW = 'true';
  // JSON ֵ�ָ���
  CharComma: QStringW = ',';
procedure EncodeJsonBinaryAsBase64;
procedure EncodeJsonBinaryAsHex;
// <summary>�ӻ�����л�ȡһ���µ� TQJSON ʵ��</summary>
function AcquireJson: TQJson; overload;
function AcquireJson(const AJsonText: String): TQJson; overload;
// <summary>��ʹ����ɵ� TQJSON ʵ���黹���������</summary>
procedure ReleaseJson(AJson: TQJson);
// <summary>���� TQJSON ʵ������صĴ�С</summary>
procedure ResizeJsonPool(const ASize: Cardinal);

implementation

uses variants, varutils, dateutils, qsimplepool;

resourcestring
  SBadJson = '��ǰ���ݲ�����Ч��JSON�ַ�����';
  SNotArrayOrObject = '%s ����һ��JSON��������';
  SVarNotArray = '%s �����Ͳ�����������';
  SBadConvert = '%s ����һ����Ч�� %s ���͵�ֵ��';
  SCharNeeded = '��ǰλ��Ӧ���� "%s" �������� "%s"��';
  SEndCharNeeded = '��ǰλ����ҪJson�����ַ�",]}"��';
  SBadNumeric = '"%s"������Ч����ֵ��';
  SBadJsonTime = '"%s"����һ����Ч������ʱ��ֵ��';
  SBadNameStart = 'Json����Ӧ��''"''�ַ���ʼ��';
  SBadNameEnd = 'Json����δ��ȷ������';
  SNameNotFound = '��Ŀ����δ�ҵ���';
  SCommentNotSupport = '�ϸ�ģʽ�²�֧��ע�ͣ�Ҫ��������ע�͵�JSON���ݣ��뽫StrictJson��������ΪFalse��';
  SUnsupportArrayItem = '��ӵĶ�̬�����%d��Ԫ�����Ͳ���֧�֡�';
  SBadStringStart = '�ϸ����JSON�ַ���������"��ʼ��';
  SUnknownToken = '�޷�ʶ���ע�ͷ���ע�ͱ�����//��/**/������';
  SNotSupport = '���� [%s] �ڵ�ǰ���������²���֧�֡�';
  SBadJsonArray = '%s ����һ����Ч��JSON���鶨�塣';
  SBadJsonObject = '%s ����һ����Ч��JSON�����塣';
  SBadJsonEncoding = '��Ч�ı��룬����ֻ����UTF-8��ANSI��Unicode 16 LE��Unicode 16 BE��';
  SJsonParseError = '��%d�е�%d��:%s '#13#10'%s';
  SBadJsonName = '%s ����һ����Ч��JSON�������ơ�';
  SObjectChildNeedName = '���� %s �ĵ� %d ���ӽ������δ��ֵ���������ǰ���踳ֵ��';
  SReplaceTypeNeed = '�滻��������Ҫ���� %s �������ࡣ';
  SSupportFloat = 'NaN/+��/-�޲���JSON�淶֧�֡�';
  SParamMissed = '���� %s ͬ���Ľ��δ�ҵ���';
  SMethodMissed = 'ָ���ĺ��� %s �����ڡ�';
  SMissRttiTypeDefine = '�޷��ҵ� %s ��RTTI������Ϣ�����Խ���Ӧ�����͵�������(��array[0..1] of Byte��ΪTByteArr=array[0..1]��Ȼ����TByteArr����)��';
  SUnsupportPropertyType = '��֧�ֵ��������͡�';
  SArrayTypeMissed = 'δ֪������Ԫ�����͡�';
  SUnknownError = 'δ֪�Ĵ���';
  SCantAttachToSelf = '�������Լ�����Ϊ�Լ����ӽ�㡣';
  SCanAttachToNoneContainer = '���ܽ���㸽�ӵ�������Ͷ������͵Ľ���¡�';
  SCantAttachNoNameNodeToObject = '���ܽ�δ�����Ľ����Ϊ�������͵��ӽ�㡣';
  SNodeNameExists = 'ָ���ĸ�������Ѿ�������Ϊ %s ���ӽ�㡣';
  SCantMoveToChild = '���ܽ��Լ��ƶ����Լ����ӽ������';
  SConvertError = '�޷������� %s ת��Ϊ %s ';
  SUnsupportVarType = '��֧�ֵı������� %d ��';

const
  JsonTypeName: array [TQJsonDataType] of QStringW = ('Unknown', 'Null', 'String', 'Integer', 'Float', 'Bcd', 'Boolean',
    'DateTime', 'Array', 'Object');
  EParse_Unknown = -1;
  EParse_BadStringStart = 1;
  EParse_BadJson = 2;
  EParse_CommentNotSupport = 3;
  EParse_UnknownToken = 4;
  EParse_EndCharNeeded = 5;
  EParse_BadNameStart = 6;
  EParse_BadNameEnd = 7;
  EParse_NameNotFound = 8;
  MaxInt64: Int64 = 9223372036854775807;
  MinInt64: Int64 = -9223372036854775808;

type
  TQJsonPool = class(TQSimplePool)
  private
    class var FCurrent: TQJsonPool;
    class function GetCurrent: TQJsonPool; static;
  protected
    procedure DoFree(ASender: TQSimplePool; AData: Pointer);
    procedure DoNew(ASender: TQSimplePool; var AData: Pointer);

  public
    constructor Create;
    class destructor Destroy;
    class property Current: TQJsonPool read GetCurrent;
  end;

function AcquireJson: TQJson;
begin
  Result := TQJsonPool.Current.Pop;
  // DebugOut('Get %x from pool', [IntPtr(Result)]);
  if not(Result.DataType in [jdtUnknown, jdtNull]) then
  begin
    DebugOut('Bad json %x from pool,expect null or unknown,but get %s',
      [IntPtr(Result), JsonTypeName[Result.DataType]]);
  end;
end;

function AcquireJson(const AJsonText: String): TQJson; overload;
begin
  Result := TQJsonPool.Current.Pop;
  Result.Parse(AJsonText);
end;

procedure ReleaseJson(AJson: TQJson);
var
  I: Integer;
  AChild: TQJson;
begin
  // DebugOut('Release %x to pool', [IntPtr(AJson)]);
  AJson.Detach;
  if AJson.DataType in [jdtArray, jdtObject] then
  begin
    for I := 0 to AJson.Count - 1 do
    begin
      AChild := AJson[I];
      AChild.FParent := nil;
      ReleaseJson(AChild);
    end;
    AJson.FItems.Clear;
  end;
  AJson.ResetNull;
  Assert(AJson.Count = 0);
  AJson.Name := '';
  AJson.Data := nil;
  if Assigned(TQJsonPool.FCurrent) then
    TQJsonPool.FCurrent.Push(AJson)
  else
    FreeAndNil(AJson);
end;

procedure ResizeJsonPool(const ASize: Cardinal);
begin
  TQJsonPool.Current.Size := ASize;
end;

procedure DoEncodeAsBase64(const ABytes: TBytes; var AResult: QStringW);
{$IF RTLVersion<=27}
  function EncodeBase64(const V: Pointer; len: Integer): QStringW;
  var
    AIn, AOut: TMemoryStream;
    T: QStringA;
  begin
    AIn := TMemoryStream.Create;
    AOut := TMemoryStream.Create;
    try
      AIn.WriteBuffer(V^, len);
      AIn.Position := 0;
      EncodeStream(AIn, AOut);
      T.Length := AOut.Size;
      Move(AOut.Memory^, PQCharA(T)^, AOut.Size);
      Result := qstring.Utf8Decode(T);
    finally
      FreeObject(AIn);
      FreeObject(AOut);
    end;
  end;
{$ELSE}
  function EncodeBase64(const V: Pointer; len: Integer): QStringW;
  begin
    Result := TNetEncoding.Base64.EncodeBytesToString(V, len);
  end;
{$IFEND}

begin
  if Length(ABytes) > 0 then
    AResult := QStringW(EncodeBase64(@ABytes[0], Length(ABytes)))
  else
    SetLength(AResult, 0);
end;

procedure DoDecodeAsBase64(const S: QStringW; var AResult: TBytes);
{$IF RTLVersion<=27}
  function DecodeBase64(const S: QStringW): TBytes;
  var
    AIn, AOut: TMemoryStream;
    T: QStringA;
  begin
    AIn := TMemoryStream.Create;
    AOut := TMemoryStream.Create;
    try
      T := qstring.Utf8Encode(S);
      AIn.WriteBuffer(PQCharA(T)^, T.Length);
      AIn.Position := 0;
      DecodeStream(AIn, AOut);
      SetLength(Result, AOut.Size);
      Move(AOut.Memory^, Result[0], AOut.Size);
    finally
      FreeObject(AIn);
      FreeObject(AOut);
    end;
  end;
{$ELSE}
  function DecodeBase64(const S: QStringW): TBytes;
  begin
    Result := TNetEncoding.Base64.DecodeStringToBytes(S);
  end;
{$IFEND}

begin
  if Length(S) > 0 then
    AResult := DecodeBase64(S)
  else
    SetLength(AResult, 0);
end;

procedure DoDecodeAsHex(const S: QStringW; var AResult: TBytes);
begin
  AResult := HexToBin(S);
end;

procedure DoEncodeAsHex(const ABytes: TBytes; var AResult: QStringW);
begin
  AResult := BinToHex(ABytes);
end;

function TQJson.DoCompareName(Item1, Item2: Pointer): Integer;
var
  AIgnoreCase: Boolean;
  AItem1, AItem2: TQJson;
begin
  AItem1 := Item1;
  AItem2 := Item2;
  AIgnoreCase := AItem1.IgnoreCase;
  if AIgnoreCase <> AItem2.IgnoreCase then
    AIgnoreCase := False;
  Result := StrCmpW(PWideChar(AItem1.Name), PWideChar(AItem2.Name), AIgnoreCase);
end;

function TQJson.DoCompareValueBoolean(Item1, Item2: Pointer): Integer;
var
  AItem1, AItem2: TQJson;
begin
  AItem1 := Item1;
  AItem2 := Item2;
  if AItem1.IsNull then
  begin
    if not AItem2.IsNull then
      Result := -1
    else
      Result := 0;
  end
  else
  begin
    if AItem2.IsNull then
      Result := 1
    else
      Result := Integer(AItem1.AsBoolean) - Integer(AItem2.AsBoolean);
  end;
end;

function TQJson.DoCompareValueDateTime(Item1, Item2: Pointer): Integer;
var
  AItem1, AItem2: TQJson;
begin
  AItem1 := Item1;
  AItem2 := Item2;
  if AItem1.IsNull then
  begin
    if AItem2.IsNull then
      Result := 0
    else
      Result := -1;
  end
  else
  begin
    if AItem2.IsNull then
      Result := 1
    else
      Result := CompareValue(AItem1.AsDateTime, AItem2.AsDateTime);
  end;
end;

function TQJson.DoCompareValueFloat(Item1, Item2: Pointer): Integer;
var
  AItem1, AItem2: TQJson;
begin
  AItem1 := Item1;
  AItem2 := Item2;
  if AItem1.IsNull then
  begin
    if AItem2.IsNull then
      Result := 0
    else
      Result := -1;
  end
  else
  begin
    if AItem2.IsNull then
      Result := 1
    else
      Result := CompareValue(AItem1.AsFloat, AItem2.AsFloat);
  end;
end;

function TQJson.DoCompareValueInt(Item1, Item2: Pointer): Integer;
var
  AItem1, AItem2: TQJson;
begin
  AItem1 := Item1;
  AItem2 := Item2;
  if AItem1.IsNull then
  begin
    if AItem2.IsNull then
      Result := 0
    else
      Result := -1;
  end
  else
  begin
    if AItem2.IsNull then
      Result := 1
    else
      Result := CompareValue(AItem1.AsInt64, AItem2.AsInt64);
  end;
end;

function TQJson.DoCompareValueString(Item1, Item2: Pointer): Integer;
var
  AIgnoreCase: Boolean;
  AItem1, AItem2: TQJson;
begin
  AItem1 := Item1;
  AItem2 := Item2;
  AIgnoreCase := AItem1.IgnoreCase;
  if AIgnoreCase <> AItem2.IgnoreCase then
    AIgnoreCase := False;
  Result := StrCmpW(PWideChar(AItem1.AsString), PWideChar(AItem2.AsString), AIgnoreCase);
end;
{ TQJson }

function TQJson.Add(AName: QStringW; AValue: Int64): TQJson;
begin
  Result := Add(AName, jdtInteger);
  PInt64(PQCharW(Result.FValue))^ := AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Extended): TQJson;
begin
  Result := Add(AName, jdtFloat);
  PExtended(PQCharW(Result.FValue))^ := AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Boolean): TQJson;
begin
  Result := Add(AName, jdtBoolean);
  PBoolean(PQCharW(Result.FValue))^ := AValue;
end;

function TQJson.Add(AName: QStringW): TQJson;
begin
  Result := Add;
  Result.FName := AName;
  DoJsonNameChanged(Result);
end;

function TQJson.Add(AName: QStringW; AChild: TQJson): Integer;
begin
  AChild.FName := AName;
  Result := Add(AChild);
  DoJsonNameChanged(AChild);
end;

function TQJson.AddArray(AName: QStringW): TQJson;
begin
  Result := Add(AName, jdtArray);
end;

function TQJson.AddDateTime(AName: QStringW; AValue: TDateTime): TQJson;
begin
  Result := Add(AName);
  Result.DataType := jdtString;
  Result.AsDateTime := AValue;
end;

function TQJson.AddVariant(AName: QStringW; AValue: Variant): TQJson;
begin
  Result := Add(AName);
  Result.AsVariant := AValue;
end;

function TQJson.Add: TQJson;
begin
  Result := CreateJson;
  Add(Result);
end;

function TQJson.Add(ANode: TQJson): Integer;
begin
  if Assigned(ANode.Parent) then
  begin
    if ANode.Parent <> Self then
      ANode.Parent.Remove(ANode)
    else
    begin
      Result := ANode.ItemIndex;
      Exit;
    end;
  end;
  ArrayNeeded(jdtObject);
  Result := FItems.Add(ANode);
  ANode.FParent := Self;
  ANode.FIgnoreCase := FIgnoreCase;
end;

function TQJson.Add(AName, AValue: QStringW; ADataType: TQJsonDataType): Integer;
var
  ANode: TQJson;
begin
  ANode := CreateJson;
  ANode.FName := AName;
  Result := Add(ANode);
  DoJsonNameChanged(ANode);
  ANode.FromType(AValue, ADataType);
end;

function TQJson.Add(AName: QStringW; ADataType: TQJsonDataType): TQJson;
begin
  Result := Add(AName);
  Result.DataType := ADataType;
end;

function TQJson.Add(const AName: QStringW; AItems: array of const): TQJson;
var
  I: Integer;
begin
  Result := Add(AName);
  Result.DataType := jdtArray;
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
          if TObject(AItems[I].VObject) is TQJson then
            Result.Add(TObject(AItems[I].VObject) as TQJson)
          else
            raise Exception.Create(Format(SUnsupportArrayItem, [I]));
        end
    else
      raise Exception.Create(Format(SUnsupportArrayItem, [I]));
    end; // End case
  end; // End for
end;

function TQJson.ArrayItemType(ArrType: PTypeInfo): PTypeInfo;
var
  ATypeData: PTypeData;
begin
  Result := nil;
  if (ArrType <> nil) and (ArrType.Kind in [tkArray, tkDynArray]) then
  begin
    ATypeData := GetTypeData(ArrType);
    if (ATypeData <> nil) then
      Result := ATypeData.elType2^;
    if Result = nil then
    begin
      if ATypeData.BaseType^ = TypeInfo(Byte) then
        Result := TypeInfo(Byte);
    end;
  end;
end;

function TQJson.ArrayItemTypeName(ATypeName: QStringW): QStringW;
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

procedure TQJson.ArrayNeeded(ANewType: TQJsonDataType);
begin
  if not(DataType in [jdtArray, jdtObject]) then
  begin
    SetLength(FValue, 0);
    FDataType := ANewType;
    ValidArray;
  end;
end;

procedure TQJson.Assign(ANode: TQJson);
var
  I: Integer;
  AItem, ACopy: TQJson;
begin
  if ANode.FDataType in [jdtArray, jdtObject] then
  begin
    DataType := ANode.FDataType;
    Clear;
    for I := 0 to ANode.Count - 1 do
    begin
      AItem := ANode[I];
      if Length(AItem.FName) > 0 then
      begin
        ACopy := Add(AItem.FName);
        ACopy.FNameHash := AItem.FNameHash;
      end
      else
        ACopy := Add;
      ACopy.Assign(AItem);
    end;
  end
  else
    CopyValue(ANode);
end;

procedure TQJson.AttachTo(ANewParent: TQJson);
begin
  MoveTo(ANewParent, MaxInt);
end;

function TQJson.BoolByName(AName: QStringW; ADefVal: Boolean): Boolean;
var
  AChild: TQJson;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) then
  begin
    if not AChild.TryGetAsBoolean(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.BoolByPath(APath: QStringW; ADefVal: Boolean): Boolean;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
  begin
    if not AItem.TryGetAsBoolean(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.BooleanToStr(const b: Boolean): QStringW;
begin
  if b then
    Result := CharTrue
  else
    Result := CharFalse;
end;

class function TQJson.BuildJsonString(ABuilder: TQStringCatHelperW; S: QStringW): Boolean;
var
  p: PQCharW;
begin
  p := PQCharW(S);
  Result := BuildJsonString(ABuilder, p);
end;

class function TQJson.BuildJsonString(S: QStringW): QStringW;
var
  AHelper: TQStringCatHelperW;
  p: PQCharW;
begin
  AHelper := TQStringCatHelperW.Create;
  try
    p := PQCharW(S);
    BuildJsonString(AHelper, p);
    Result := AHelper.Value;
  finally
    FreeAndNil(AHelper);
  end;
end;

class function TQJson.BuildJsonString(ABuilder: TQStringCatHelperW; var p: PQCharW): Boolean;
var
  AQuoter: QCharW;
  ps: PQCharW;
begin
  ABuilder.Position := 0;
  if (p^ = '"') or (p^ = '''') then
  begin
    AQuoter := p^;
    Inc(p);
    ps := p;
    Result := False;
    while p^ <> #0 do
    begin
      if (p^ = AQuoter) then
      begin
        if ps <> p then
          ABuilder.Cat(ps, p - ps);
        if p[1] = AQuoter then
        begin
          ABuilder.Cat(AQuoter);
          Inc(p, 2);
          ps := p;
        end
        else
        begin
          Inc(p);
          SkipSpaceW(p);
          ps := p;
          Result := True;
          Break;
        end;
      end
      else if p^ = '\' then
      begin
        if ps <> p then
          ABuilder.Cat(ps, p - ps);
        ABuilder.Cat(CharUnescape(p));
        ps := p;
      end
      else
        Inc(p);
    end;
    if Result then
    begin
      if (ps <> p) then
        ABuilder.Cat(ps, p - ps)
    end
    else
    begin
      ABuilder.Cat(ps, p - ps);
    end;
  end
  else
  begin
    Result := True;
    while p^ <> #0 do
    begin
      if (p^ = ':') or (p^ = ']') or (p^ = ',') or (p^ = '}') then
        Break
      else
        ABuilder.Cat(p, 1);
      Inc(p);
    end
  end;
end;

function TQJson.BytesByPath(APath: QStringW; ADefVal: TBytes): TBytes;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
  begin
    try
      Result := AItem.AsBytes;
    except
      Result := ADefVal;
    end;
  end
  else
    Result := ADefVal;
end;

class procedure TQJson.JsonCat(ABuilder: TQStringCatHelperW; const S: QStringW; ASettings: TJsonEncodeSettings);
var
  ps, p, pd: PQCharW;
  ADelta: Integer;
const
  CharNum1: PWideChar = '1';
  CharNum0: PWideChar = '0';
  Char7: PWideChar = '\a';
  Char8: PWideChar = '\b';
  Char9: PWideChar = '\t';
  Char10: PWideChar = '\n';
  Char11: PWideChar = '\v';
  Char12: PWideChar = '\f';
  Char13: PWideChar = '\r';
  CharQuoter: PWideChar = '\"';
  CharBackslash: PWideChar = '\\';
  CharCode: PWideChar = '\u00';
  CharEscape: PWideChar = '\u';
  CharSlash: PWideChar = '\/';
begin
  ABuilder.IncSize(Length(S)); // ���ӻ�������С
  ps := PQCharW(S);
  p := ps;
  pd := ABuilder.Current;
  while (p^ <> #0) do
  begin
    if IntPtr(ABuilder.Last) - IntPtr(pd) < 12 then // ����������� \uxxxx
    begin
      ABuilder.Current := pd;
      ADelta := Length(S) - ((IntPtr(p) - IntPtr(ps)) shr 1);
      // �����ʣ��һ����ת���ַ�����ADoEscapeΪtrue����������Ҫ6���ַ���λ��
      if ADelta < 6 then
        ADelta := 6;
      ABuilder.IncSize(ADelta);
      pd := ABuilder.Current;
      ps := p;
    end;
    case p^ of
      #7:
        begin
          PInteger(pd)^ := PInteger(Char7)^;
          Inc(pd, 2);
        end;
      #8:
        begin
          PInteger(pd)^ := PInteger(Char8)^;
          Inc(pd, 2);
        end;
      #9:
        begin
          PInteger(pd)^ := PInteger(Char9)^;
          Inc(pd, 2);
        end;
      #10:
        begin
          PInteger(pd)^ := PInteger(Char10)^;
          Inc(pd, 2);
        end;
      #11:
        begin
          PInteger(pd)^ := PInteger(Char11)^;
          Inc(pd, 2);
        end;
      #12:
        begin
          PInteger(pd)^ := PInteger(Char12)^;
          Inc(pd, 2);
        end;
      #13:
        begin
          PInteger(pd)^ := PInteger(Char13)^;
          Inc(pd, 2);
        end;
      '\':
        begin
          PInteger(pd)^ := PInteger(CharBackslash)^;
          Inc(pd, 2);
        end;
      '"':
        begin
          PInteger(pd)^ := PInteger(CharQuoter)^;
          Inc(pd, 2);
        end;
      '/':
        begin
          if jesEscapeSlashes in ASettings then
          begin
            PInteger(pd)^ := PInteger(CharSlash)^;
            Inc(pd, 2);
          end
          else
          begin
            pd^ := '/';
            Inc(pd);
          end;
        end
    else
      begin
        if p^ < #$1F then
        begin
          PInt64(pd)^ := PInt64(CharCode)^;
          Inc(pd, 4);
          if p^ > #$F then
            pd^ := CharNum1^
          else
            pd^ := CharNum0^;
          Inc(pd);
          pd^ := LowerHexChars[Ord(p^) and $0F];
          Inc(pd);
        end
        else if (p^ <= #$7E) or (not(jesDoEscape in ASettings)) then // Ӣ���ַ���
        begin
          pd^ := p^;
          Inc(pd);
        end
        else
        begin
          PInteger(pd)^ := PInteger(CharEscape)^;
          Inc(pd, 2);
          pd^ := LowerHexChars[(PWord(p)^ shr 12) and $0F];
          Inc(pd);
          pd^ := LowerHexChars[(PWord(p)^ shr 8) and $0F];
          Inc(pd);
          pd^ := LowerHexChars[(PWord(p)^ shr 4) and $0F];
          Inc(pd);
          pd^ := LowerHexChars[PWord(p)^ and $0F];
          Inc(pd);
        end;
      end;
    end;
    Inc(p);
  end;
  ABuilder.Current := pd;
end;

function TQJson.CatNames(const AQuoter, ADelimiter: QCharW; AOptions: TQCatOptions): QStringW;
var
  AItems: TQStringArray;
  ACount: Integer;
begin
  ACount := InternalFlatItems(AItems, 0, AOptions);
  Result := StrCatW(AItems, False, 0, ACount, ADelimiter, AQuoter);
end;

function TQJson.CatValues(const AQuoter, ADelimiter: QCharW; AOptions: TQCatOptions): QStringW;
var
  AItems: TQStringArray;
  ACount: Integer;
begin
  ACount := InternalFlatItems(AItems, 1, AOptions);
  Result := StrCatW(AItems, False, 0, ACount, ADelimiter, AQuoter);
end;

class function TQJson.CharEscape(c: QCharW; pd: PQCharW): Integer;
begin
  case c of
    #7:
      begin
        pd[0] := '\';
        pd[1] := 'b';
        Result := 2;
      end;
    #9:
      begin
        pd[0] := '\';
        pd[1] := 't';
        Result := 2;
      end;
    #10:
      begin
        pd[0] := '\';
        pd[1] := 'n';
        Result := 2;
      end;
    #12:
      begin
        pd[0] := '\';
        pd[1] := 'f';
        Result := 2;
      end;
    #13:
      begin
        pd[0] := '\';
        pd[1] := 'r';
        Result := 2;
      end;
    '\':
      begin
        pd[0] := '\';
        pd[1] := '\';
        Result := 2;
      end;
    // '''':
    // begin
    // pd[0] := '\';
    // pd[1] := '''';
    // Result := 2;
    // end;
    '"':
      begin
        pd[0] := '\';
        pd[1] := '"';
        Result := 2;
      end
  else
    begin
      pd[0] := c;
      Result := 1;
    end;
  end;
end;

class function TQJson.CharUnescape(var p: PQCharW): QCharW;
  function DecodeOrd: Integer;
  var
    c: Integer;
  begin
    Result := 0;
    c := 0;
    while (p^ <> #0) and (c < 4) do
    begin
      if IsHexChar(p^) then
        Result := (Result shl 4) + HexValue(p^)
      else
        Break;
      Inc(p);
      Inc(c);
    end
  end;

begin
  if p^ = #0 then
  begin
    Result := #0;
    Exit;
  end;
  if p^ <> '\' then
  begin
    Result := p^;
    Inc(p);
    Exit;
  end;
  Inc(p);
  case p^ of
    'a':
      begin
        Result := #7;
        Inc(p);
      end;
    'b':
      begin
        Result := #8;
        Inc(p);
      end;
    't':
      begin
        Result := #9;
        Inc(p);
      end;
    'n':
      begin
        Result := #10;
        Inc(p);
      end;
    'v':
      begin
        Result := #11;
        Inc(p);
      end;
    'f':
      begin
        Result := #12;
        Inc(p);
      end;
    'r':
      begin
        Result := #13;
        Inc(p);
      end;
    '\':
      begin
        Result := '\';
        Inc(p);
      end;
    '''':
      begin
        Result := '''';
        Inc(p);
      end;
    '"':
      begin
        Result := '"';
        Inc(p);
      end;
    'u':
      begin
        // \uXXXX
        if IsHexChar(p[1]) and IsHexChar(p[2]) and IsHexChar(p[3]) and IsHexChar(p[4]) then
        begin
          Result := WideChar((HexValue(p[1]) shl 12) or (HexValue(p[2]) shl 8) or (HexValue(p[3]) shl 4) or
            HexValue(p[4]));
          Inc(p, 5);
        end
        else
          raise Exception.CreateFmt(SCharNeeded, ['0-9A-Fa-f', StrDupW(p, 0, 4)]);
      end
  else
    begin
      if StrictJson then
        raise Exception.CreateFmt(SCharNeeded, ['btfrn"u''/', StrDupW(p, 0, 4)])
      else
      begin
        Result := p^;
        Inc(p);
      end;
    end;
  end;
end;

procedure TQJson.Clear;
var
  I: Integer;
begin
  if FDataType in [jdtArray, jdtObject] then
  begin
    for I := 0 to FItems.Count - 1 do
      FreeJson(FItems[I]);
    FItems.Clear;
  end;
end;

function TQJson.Clone: TQJson;
begin
  Result := Copy;
end;

function TQJson.ContainsName(AName: QStringW; ANest: Boolean): Boolean;
var
  I, H: Integer;
  AItem: TQJson;
begin
  Result := ItemByName(AName) <> nil;
  if (not Result) and ANest then
  begin
    H := Count - 1;
    for I := 0 to H do
    begin
      AItem := Items[I];
      if AItem.DataType = jdtObject then
      begin
        Result := Items[I].ContainsName(AName, ANest);
        if Result then
          Break;
      end;
    end;
  end;
end;

function TQJson.ContainsValue(const AValue: Variant; ANest, AStrict: Boolean): Boolean;
var
  I, H: Integer;
  AItem: TQJson;
  function CompareValue: Boolean;
  begin
    if AItem.DataType in [jdtUnknown, jdtNull] then
      Result := VarIsNull(AValue)
    else if AStrict then
    begin
      if AItem.DataType = jdtString then
        Result := StrCmpW(PWideChar(AItem.AsString),
          PWideChar({$IFNDEF UNICODE}QStringW({$ENDIF}VarToStr(AValue){$IFNDEF UNICODE}){$ENDIF}), IgnoreCase) = 0
      else if (AItem.DataType in [jdtInteger, jdtFloat, jdtBoolean]) and VarIsNumeric(AValue) then
        Result := (AItem.AsVariant = AValue)
      else if (AItem.DataType = jdtDateTime) and (FindVarData(AValue)^.VType = varDate) then
        Result := SameValue(AItem.AsDateTime, VarToDateTime(AValue))
      else
        Result := False;
    end
    else
      Result := AItem.AsString = VarToStr(AValue);
  end;

begin
  H := Count - 1;
  Result := False;
  for I := 0 to H do
  begin
    AItem := Items[I];
    if (not(AItem.DataType in [jdtObject, jdtArray])) and CompareValue then
    begin
      Result := True;
      Exit;
    end;
  end;
  if ANest then
  begin
    for I := 0 to H do
    begin
      AItem := Items[I];
      if AItem.DataType in [jdtObject, jdtArray] then
      begin
        Result := AItem.ContainsValue(AValue, ANest, AStrict);
        if Result then
          Exit;
      end;
    end;
  end;
end;

function TQJson.Copy: TQJson;
begin
  Result := CreateJson;
  Result.Assign(Self);
end;
{$IF RTLVersion>=21}

function TQJson.CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEventA): TQJson;
  procedure NestCopy(AParentSource, AParentDest: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChildSource, AChildDest: TQJson;
  begin
    for I := 0 to AParentSource.Count - 1 do
    begin
      Accept := True;
      AChildSource := AParentSource[I];
      AFilter(Self, AChildSource, Accept, ATag);
      if Accept then
      begin
        AChildDest := AParentDest.Add(AChildSource.FName, AChildSource.DataType);
        if AChildSource.DataType in [jdtArray, jdtObject] then
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
    Result := CreateJson;
    Result.FName := Name;
    if DataType in [jdtObject, jdtArray] then
    begin
      NestCopy(Self, Result);
    end
    else
      Result.CopyValue(Self);
  end
  else
    Result := Copy;
end;
{$IFEND >=2010}

function TQJson.CopyIf(const ATag: Pointer; AFilter: TQJsonFilterEvent): TQJson;
  procedure NestCopy(AParentSource, AParentDest: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChildSource, AChildDest: TQJson;
  begin
    for I := 0 to AParentSource.Count - 1 do
    begin
      Accept := True;
      AChildSource := AParentSource[I];
      AFilter(Self, AChildSource, Accept, ATag);
      if Accept then
      begin
        AChildDest := AParentDest.Add(AChildSource.FName, AChildSource.DataType);
        if AChildSource.DataType in [jdtArray, jdtObject] then
          NestCopy(AChildSource, AChildDest)
        else
          AChildDest.CopyValue(AChildSource);
      end;
    end;
  end;

begin
  if Assigned(AFilter) then
  begin
    Result := CreateJson;
    Result.FName := Name;
    if DataType in [jdtObject, jdtArray] then
    begin
      NestCopy(Self, Result);
    end
    else
      Result.CopyValue(Self);
  end
  else
    Result := Copy;
end;

procedure TQJson.CopyValue(ASource: TQJson);
var
  l: Integer;
begin
  l := Length(ASource.FValue);
  DataType := ASource.DataType;
  SetLength(FValue, l);
  if l > 0 then
    Move(PQCharW(ASource.FValue)^, PQCharW(FValue)^, l shl 1);
end;

constructor TQJson.Create(const AName, AValue: QStringW; ADataType: TQJsonDataType);
begin
  inherited Create;
  FName := AName;
  FIgnoreCase := not JsonCaseSensitive;
  if ADataType <> jdtUnknown then
    DataType := ADataType;
  Value := AValue;
  // DebugOut('Create Json Object %x', [IntPtr(Self)]);
end;

function TQJson.CreateJson: TQJson;
begin
  if Assigned(OnQJsonCreate) then
    Result := OnQJsonCreate
  else
    Result := AcquireJson;
end;

constructor TQJson.Create;
begin
  inherited;
  FCommentStyle := jcsInherited;
  FIgnoreCase := not JsonCaseSensitive;
  // DebugOut('Create Json Object %x', [IntPtr(Self)]);
end;

function TQJson.DateTimeByName(AName: QStringW; ADefVal: TDateTime): TDateTime;
var
  AChild: TQJson;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) then
  begin
    if not AChild.TryGetAsDateTime(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.DateTimeByPath(APath: QStringW; ADefVal: TDateTime): TDateTime;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
  begin
    if not AItem.TryGetAsDateTime(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

procedure TQJson.Delete(AName: QStringW);
var
  I: Integer;
begin
  I := IndexOf(AName);
  if I <> -1 then
    Delete(I);
end;
{$IF RTLVersion>=21}

procedure TQJson.DeleteIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEventA);
  procedure DeleteChildren(AParent: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChild: TQJson;
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
{$IFEND >=2010}

procedure TQJson.DeleteIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEvent);
  procedure DeleteChildren(AParent: TQJson);
  var
    I: Integer;
    Accept: Boolean;
    AChild: TQJson;
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

procedure TQJson.Delete(AIndex: Integer);
var
  AJson: TQJson;
begin
  AJson := Remove(AIndex);
  if Assigned(AJson) then
    FreeJson(AJson);
end;

destructor TQJson.Destroy;
begin
  // DebugOut('Free Json object %s %s', [IntToHex(IntPtr(Self), 8), Path]);
  ResetNull;
  inherited;
end;

procedure TQJson.Detach;
begin
  if Assigned(FParent) then
    FParent.Remove(Self);
end;

function TQJson.Diff(AJson: TQJson): TQJson;
  procedure DoDiff(ALeft, ARight, AParent: TQJson);
  var
    I, H1, H2, J: Integer;
    AItem1, AItem2, AResult: TQJson;
    AFound: Boolean;
  begin
    if DataType <> AJson.DataType then
      AParent.Add(ALeft.Name, ALeft)
    else
    begin
      H1 := ALeft.Count - 1;
      H2 := ARight.Count - 1;
      for I := 0 to H1 do
      begin
        AItem1 := ALeft[I];
        AFound := False;
        for J := 0 to H2 do
        begin
          AItem2 := ARight[J];
          if (AItem1.Name = AItem2.Name) then
          begin
            AFound := True;
            if not AItem1.Equals(AItem2) then
            begin
              AResult := AParent.Add(AItem1.Name, jdtObject);
              AResult.Add('Value1', AItem1.DataType).Assign(AItem1);
              AResult.Add('Value2', AItem2.DataType).Assign(AItem2);
            end;
            Break;
          end;
        end;
        if not AFound then
          AParent.Add(AItem1.Name).Assign(AItem1);
      end;
    end;
  end;

begin
  Result := AcquireJson;
  DoDiff(Self, AJson, Result);
  DoDiff(AJson, Self, Result);
end;

procedure TQJson.DoJsonNameChanged(AJson: TQJson);
begin

end;

procedure TQJson.DoParsed;
begin

end;

function TQJson.Encode(ADoFormat: Boolean; ADoEscape: Boolean; AIndent: QStringW): QStringW;
var
  ASettings: TJsonEncodeSettings;
begin
  ASettings := [];
  if ADoFormat then
    ASettings := ASettings + [jesDoFormat];
  if ADoEscape then
    ASettings := ASettings + [jesDoEscape];
  Result := Encode(ASettings, AIndent);
end;

function TQJson.Encode(ASettings: TJsonEncodeSettings; AIndent: QStringW): QStringW;
var
  ABuilder: TQStringCatHelperW;
  AIndentSize, ABreakSize: Integer;
  function CalcSize(AParent: TQJson; ALevel: Integer): Integer;
  var
    AExtended: Extended;
    AVal: Int64 absolute AExtended;
    AIndex, ACount: Integer;
    AChild: TQJson;
  begin
    Result := 0;
    case AParent.DataType of
      jdtUnknown, jdtNull:
        Inc(Result, 4);
      jdtString: // ������費��Ҫ����ת�壬����������ڴ�
        Inc(Result, Length(AParent.Value) + 2);
      jdtInteger:
        begin
          AVal := PInt64(AParent.FValue)^;
          if AVal = 0 then
            Inc(Result)
          else
          begin
            if AVal < 0 then
            begin
              Inc(Result);
              AVal := -AVal;
            end;
            while AVal > 0 do
            begin
              Inc(Result);
              AVal := AVal div 10;
            end;
          end;
        end;
      jdtFloat, jdtBcd: // �����У����󲿷�����£���ֵ�������ر��������һ���򻯴�����x.y�ܼ�16λΪһ������ֵ�������ڴ�
        Inc(Result, 16);
      jdtBoolean:
        begin
          if PBoolean(AParent.FValue)^ then
            Inc(Result, 4)
          else
            Inc(Result, 5);
        end;
      jdtDateTime:
        Inc(Result, Length(JsonDateTimeFormat));
      jdtArray:
        begin
          ACount := AParent.FItems.Count - 1;
          Inc(Result, 2);
          for AIndex := 0 to ACount do
          begin
            if AIndex = 0 then
              Inc(Result, ABreakSize + AIndentSize * ALevel)
            else
              Inc(Result, ABreakSize + 1 + AIndentSize * ALevel);
            Inc(Result, CalcSize(AParent.FItems[AIndex], ALevel + 1));
          end;
        end;
      jdtObject:
        begin
          ACount := AParent.FItems.Count - 1;
          Inc(Result, 2);
          for AIndex := 0 to ACount do
          begin
            if AIndex = 0 then
              Inc(Result, ABreakSize + AIndentSize * ALevel)
            else
              Inc(Result, ABreakSize + 1 + AIndentSize * ALevel);
            AChild := AParent.FItems[AIndex];
            Inc(Result, Length(AChild.Name) + 2);
            Inc(Result, CalcSize(AChild, ALevel + 1));
          end;
        end;
    end;
  end;

begin
  if jesDoFormat in ASettings then
  begin
    AIndentSize := Length(AIndent);
    ABreakSize := SizeOf(SLineBreak);
  end
  else
  begin
    AIndentSize := 0;
    ABreakSize := 0;
  end;
  ABuilder := TQStringCatHelperW.Create;
  try
    ABuilder.IncSize(CalcSize(Self, 0));
    InternalEncode(ABuilder, ASettings, AIndent);
    ABuilder.Back(1); // ɾ�����һ������
    Result := ABuilder.Value;
  finally
    FreeObject(ABuilder);
  end;
end;

class function TQJson.EncodeDateTime(const AValue: TDateTime): QStringW;
var
  ADate: Integer;
begin
  ADate := Trunc(AValue);
  if SameValue(ADate, 0) then // DateΪ0����ʱ��
  begin
    if SameValue(AValue, 0) then
      Result := FormatDateTime(JsonDateFormat, AValue)
    else
      Result := FormatDateTime(JsonTimeFormat, AValue);
  end
  else
  begin
    if SameValue(AValue - ADate, 0) then
      Result := FormatDateTime(JsonDateFormat, AValue)
    else
      Result := FormatDateTime(JsonDateTimeFormat, AValue);
  end;
end;

function TQJson.EncodeToBytes(AEncoding: TTextEncoding; ASettings: TJsonEncodeSettings; AIndent: QStringW): TBytes;
var
  AText: String;
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    AText := Encode(ASettings);
    case AEncoding of
      teAnsi:
        SaveTextA(AStream, AText);
      teUnicode16LE:
        SaveTextW(AStream, AText);
      teUnicode16BE:
        SaveTextWBE(AStream, AText);
      teUtf8:
        SaveTextU(AStream, AText);
    end;
    SetLength(Result, AStream.Size);
    Move(AStream.Memory^, Result[0], Length(Result));
  finally
    FreeAndNil(AStream);
  end;
end;

function TQJson.Equals(AJson: TQJson): Boolean;
var
  I, c: Integer;
begin
  if DataType = AJson.DataType then
  begin
    if DataType in [jdtArray, jdtObject] then
    begin
      Result := Count = AJson.Count;
      if Result then
      begin
        c := Count - 1;
        for I := 0 to c do
        begin
          Result := Items[I].Equals(AJson[I]);
          if not Result then
            Break;
        end;
      end;
    end
    else
      Result := FValue = AJson.FValue;
  end
  else
    Result := False;
end;

function TQJson.Escape(const S: QStringW): QStringW;
var
  ABuilder: TQStringCatHelperW;
begin
  ABuilder := TQStringCatHelperW.Create;
  try
    JsonCat(ABuilder, S, [jesDoEscape]);
    Result := ABuilder.Value;
  finally
    FreeObject(ABuilder);
  end;
end;

procedure TQJson.ExchangeOrder(AIndex1, AIndex2: Integer);
begin
  FItems.Exchange(AIndex1, AIndex2);
end;

{$IF RTLVersion>=21}

function TQJson.FindIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEventA): TQJson;
  function DoFind(AParent: TQJson): TQJson;
  var
    I: Integer;
    AChild: TQJson;
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
{$IFEND >=2010}

procedure TQJson.FileFromValue(AFileName: QStringW);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    StreamFromValue(AStream);
  finally
    FreeObject(AStream);
  end;
end;

function TQJson.FindIf(const ATag: Pointer; ANest: Boolean; AFilter: TQJsonFilterEvent): TQJson;
  function DoFind(AParent: TQJson): TQJson;
  var
    I: Integer;
    AChild: TQJson;
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

function TQJson.FlatNames(AOptions: TQCatOptions): TQStringArray;
begin
  SetLength(Result, InternalFlatItems(Result, 0, AOptions));
end;

function TQJson.FlatValues(AOptions: TQCatOptions): TQStringArray;
begin
  SetLength(Result, InternalFlatItems(Result, 1, AOptions));
end;

function TQJson.FloatByName(AName: QStringW; ADefVal: Extended): Extended;
var
  AChild: TQJson;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) then
  begin
    if not AChild.TryGetAsFloat(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.FloatByPath(APath: QStringW; ADefVal: Extended): Extended;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
  begin
    if not AItem.TryGetAsFloat(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.ForceName(AName: QStringW; AType: TQJsonDataType): TQJson;
var
  I: Integer;
begin
  I := IndexOf(AName);
  if I <> -1 then
    Result := Items[I]
  else
    Result := Add(AName, AType);
end;

function TQJson.ForcePath(APath: QStringW): TQJson;
var
  AName: QStringW;
  p, pn, ws: PQCharW;
  AParent: TQJson;
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
    if not(AParent.DataType in [jdtObject, jdtArray]) then
      AParent.DataType := jdtObject;
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
            if ParseInt(ws, AIndex) = 0 then
              AIndex := -1;
            Break;
          end
          else
            Dec(l);
        until l < 0;
        if l >= 0 then
        begin
          AName := StrDupX(pn, l);
          if Length(AName) > 0 then
          begin
            Result := AParent.ItemByName(AName);
            if EndWithW(AName, ']', False) then
            begin
              Result := AParent.ForcePath(AName);
              Result.DataType := jdtArray;
            end
            else if Result = nil then
              Result := AParent.Add(AName, jdtArray)
            else if Result.DataType <> jdtArray then
              raise Exception.CreateFmt(SBadJsonArray, [AName]);
          end
          else // Self
            Result := AParent;
          if AIndex >= 0 then
          begin
            while Result.Count <= AIndex do
              Result.Add;
            Result := Result[AIndex];
          end;
        end
        else
          raise Exception.CreateFmt(SBadJsonName, [AName]);
      end
      else
      begin
        if AParent.IsArray then
          Result := AParent.Add.Add(AName)
        else
          Result := AParent.Add(AName);
      end;
    end;
    AParent := Result;
  end;
end;

procedure TQJson.ForEach(ACallback: TQJsonFilterEvent; ANest: Boolean; const ATag: Pointer);
var
  AContinue: Boolean;
  procedure DoEnum(AParent: TQJson);
  var
    I: Integer;
    AChild: TQJson;
  begin
    I := 0;
    while (I < AParent.Count) and AContinue do
    begin
      AChild := AParent[I];
      ACallback(Self, AChild, AContinue, ATag);
      if AContinue and ANest then
        DoEnum(AChild);
      Inc(I);
    end;
  end;

begin
  if Assigned(ACallback) then
  begin
    AContinue := True;
    DoEnum(Self);
  end;
end;
{$IF RTLVersion>=21}

procedure TQJson.ForEach(ACallback: TQJsonFilterEventA; ANest: Boolean; const ATag: Pointer);
var
  AContinue: Boolean;
  procedure DoEnum(AParent: TQJson);
  var
    I: Integer;
    AChild: TQJson;
  begin
    I := 0;
    while (I < AParent.Count) and AContinue do
    begin
      AChild := AParent[I];
      ACallback(Self, AChild, AContinue, ATag);
      if AContinue and ANest then
        DoEnum(AChild);
      Inc(I);
    end;
  end;

begin
  if Assigned(ACallback) then
  begin
    AContinue := True;
    DoEnum(Self);
  end;
end;
{$IFEND}

function TQJson.FormatParseError(ACode: Integer; AMsg: QStringW; ps, p: PQCharW): QStringW;
var
  ACol, ARow: Integer;
  ALine: QStringW;
  pLine: PQCharW;
  procedure ErrorLine;
  var
    pl, pls, pe: PQCharW;
  begin
    pl := PQCharW(ALine);
    pls := pl;
    Inc(pl, ACol);
    pe := pls + Length(ALine);
    if IntPtr(pe) - IntPtr(pl) > 50 then
    begin
      pls := pl - 25;
      pe := pl + 25;
    end
    else if Length(ALine) >= 50 then
      pls := pe - 50;
    ALine := StrDupX(pls, pe - pls) + SLineBreak + StringReplicateW('0', (IntPtr(pl) - IntPtr(pls)) shr 1 - 1) + '^';
  end;

begin
  if ACode <> 0 then
  begin
    pLine := StrPosW(ps, p, ACol, ARow);
    ALine := DecodeLineW(pLine, False);
    if Length(ALine) > 1024 then // һ�������1024���ַ�
    begin
      ErrorLine;
    end;
    Result := Format(SJsonParseError, [ARow, ACol, AMsg, ALine]);
  end
  else
    SetLength(Result, 0);
end;

function TQJson.FormatParseErrorEx(ACode: Integer; AMsg: QStringW; ps, p: PQCharW): EJsonError;
var
  ACol, ARow: Integer;
  ALine: QStringW;
  pLine: PQCharW;
  procedure ErrorLine;
  var
    pl, pls, pe: PQCharW;
  begin
    pl := PQCharW(ALine);
    pls := pl;
    Inc(pl, ACol);
    pe := pls + Length(ALine);
    if IntPtr(pe) - IntPtr(pl) > 50 then
    begin
      pls := pl - 25;
      pe := pl + 25;
    end
    else if Length(ALine) >= 50 then
      pls := pe - 50;
    ALine := StrDupX(pls, pe - pls) + SLineBreak + StringReplicateW('0', (IntPtr(pl) - IntPtr(pls)) shr 1 - 1) + '^';
  end;

begin
  if ACode <> 0 then
  begin
    pLine := StrPosW(ps, p, ACol, ARow);
    ALine := DecodeLineW(pLine, False);
    if Length(ALine) > 1024 then // һ�������1024���ַ�
    begin
      ErrorLine;
    end;
    Result := EJsonError.Create(Format(SJsonParseError, [ARow, ACol, AMsg, ALine]));
    Result.FRow := ARow;
    Result.FCol := ACol;
  end
  else
    Result := nil;
end;

procedure TQJson.FreeJson(AJson: TQJson);
begin
  if Assigned(AJson) then
  begin
    AJson.FParent := nil;
    if Assigned(OnQJsonFree) then
      OnQJsonFree(AJson)
    else
      ReleaseJson(AJson);
  end;
end;

procedure TQJson.FromType(const AValue: QStringW; AType: TQJsonDataType);
var
  p: PQCharW;
  ABuilder: TQStringCatHelperW;
  procedure ToDateTime;
  var
    ATime: TDateTime;
  begin
    if ParseDateTime(PQCharW(AValue), ATime) then
      AsDateTime := ATime
    else if ParseJsonTime(PQCharW(AValue), ATime) then
      AsDateTime := ATime
    else
      raise Exception.Create(SBadJsonTime);
  end;

begin
  p := PQCharW(AValue);
  if AType = jdtUnknown then
  begin
    ABuilder := TQStringCatHelperW.Create;
    try
      if TryParseValue(ABuilder, p) <> 0 then
        AsString := AValue
      else if p^ <> #0 then
        AsString := AValue;
    finally
      FreeObject(ABuilder);
    end;
  end
  else
  begin
    case AType of
      jdtString:
        AsString := AValue;
      jdtInteger:
        AsInt64 := StrToInt64(AValue);
      jdtFloat:
        AsFloat := StrToFloat(AValue);
      jdtBoolean:
        AsBoolean := StrToBool(AValue);
      jdtDateTime:
        ToDateTime;
      jdtArray:
        begin
          if p^ <> '[' then
            raise Exception.CreateFmt(SBadJsonArray, [AValue]);
          ParseObject(p);
        end;
      jdtObject:
        begin
          if p^ <> '{' then
            raise Exception.CreateFmt(SBadJsonObject, [AValue]);
          ParseObject(p);
        end;
    end;
  end;
end;

{$IF RTLVersion>=21}

procedure TQJson.FromRecord<T>(const ARecord: T);
begin
  FromRtti(@ARecord, TypeInfo(T));
end;

procedure TQJson.FromRtti(ASource: Pointer; AType: PTypeInfo);
var
  AValue: TValue;
  procedure AddCollection(AParent: TQJson; ACollection: TCollection);
  var
    J: Integer;
  begin
    for J := 0 to ACollection.Count - 1 do
      AParent.Add.FromRtti(ACollection.Items[J]);
  end;
// ����XE6��System.rtti��TValue��tkSet���ʹ����Bug
  function SetAsOrd(AValue: TValue): Int64;
  var
    ATemp: Integer;
  begin
    AValue.ExtractRawData(@ATemp);
    case GetTypeData(AValue.TypeInfo).OrdType of
      otSByte:
        Result := PShortint(@ATemp)^;
      otUByte:
        Result := PByte(@ATemp)^;
      otSWord:
        Result := PSmallint(@ATemp)^;
      otUWord:
        Result := PWord(@ATemp)^;
      otSLong:
        Result := PInteger(@ATemp)^;
      otULong:
        Result := PCardinal(@ATemp)^
    else
      Result := 0;
    end;
  end;
  procedure AddRecord;
  var
    AContext: TRttiContext;
    AFields: TArray<TRttiField>;
    ARttiType: TRttiType;
    J: Integer;
  begin
    AContext := TRttiContext.Create;
    ARttiType := AContext.GetType(AType);
    AFields := ARttiType.GetFields;
    for J := Low(AFields) to High(AFields) do
    begin
      if AFields[J].FieldType <> nil then
      begin
        // �ӿڡ�������������ָ���޷�����
        if AFields[J].FieldType.Handle^.Kind in [tkUnknown, tkInterface, tkMethod, tkProcedure, tkClassRef, tkPointer]
        then
          continue;
        Add(AFields[J].Name).FromRtti(PByte(IntPtr(ASource) + AFields[J].Offset), AFields[J].FieldType.Handle);
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
    begin
      DataType := jdtArray;
      AddCollection(Self, AObj as TCollection)
    end
    else
    begin
      APropList := nil;
      ACount := GetPropList(AType, APropList);
      try
        for J := 0 to ACount - 1 do
        begin
          if Assigned(APropList[J].GetProc) and Assigned(APropList[J].SetProc) and
            (not(APropList[J].PropType^.Kind in [tkMethod, tkInterface, tkClassRef, tkPointer, tkProcedure])) then
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
                  if Assigned(AChildObj) then
                  begin
                    if AChildObj is TStrings then
                      Add(AName).AsString := (AChildObj as TStrings).Text
                    else if AChildObj is TCollection then
                      AddCollection(AddArray(AName), AChildObj as TCollection)
                    else
                      Add(AName, jdtObject).FromRtti(AChildObj);
                  end;
                end;
              tkRecord, tkArray, tkDynArray{$IFDEF MANAGED_RECORD}, tkMRecord{$ENDIF}: // ��¼�����顢��̬��������ϵͳҲ�����棬Ҳû�ṩ����̫�õĽӿ�
                raise Exception.Create(SUnsupportPropertyType);
              tkInteger:
                Add(AName).AsInt64 := GetOrdProp(AObj, APropList[J]);
              tkFloat:
                begin
                  if (APropList[J].PropType^ = TypeInfo(TDateTime)) or (APropList[J].PropType^ = TypeInfo(TTime)) or
                    (APropList[J].PropType^ = TypeInfo(TDate)) then
                  begin
                    // �ж�һ����ֵ�Ƿ���һ����Ч��ֵ
                    Add(AName).AsDateTime := GetFloatProp(AObj, APropList[J]);
                  end
                  else
                    Add(AName).AsFloat := GetFloatProp(AObj, APropList[J]);
                end;
              tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
                Add(AName).AsString := GetStrProp(AObj, APropList[J]);
              tkEnumeration:
                begin
                  if GetTypeData(APropList[J]^.PropType^)^.BaseType^ = TypeInfo(Boolean) then
                    Add(AName).AsBoolean := GetOrdProp(AObj, APropList[J]) <> 0
                  else if JsonRttiEnumAsInt then
                    Add(AName).AsInteger := GetOrdProp(AObj, APropList[J])
                  else
                    Add(AName).AsString := GetEnumProp(AObj, APropList[J]);
                end;
              tkSet:
                begin
                  if JsonRttiEnumAsInt then
                    Add(AName).AsInteger := GetOrdProp(AObj, APropList[J])
                  else
                    Add(AName).AsString := GetSetProp(AObj, APropList[J], True);
                end;
              tkVariant:
                Add(AName).AsVariant := GetPropValue(AObj, APropList[J]);
              tkInt64:
                Add(AName).AsInt64 := GetInt64Prop(AObj, APropList[J]);
            end;
          end;
        end;
      finally
        if Assigned(APropList) then
          FreeMem(APropList);
      end;
    end;
  end;

  procedure AddArray;
  var
    I, c: Integer;
  begin
    DataType := jdtArray;
    Clear;
    TValue.Make(ASource, AType, AValue);
    c := AValue.GetArrayLength;
    for I := 0 to c - 1 do
      Add.FromRtti(AValue.GetArrayElement(I));
  end;

begin
  if ASource = nil then
    Exit;
  Clear;
  case AType.Kind of
    tkRecord{$IFDEF MANAGED_RECORD}, tkMRecord{$ENDIF}:
      AddRecord;
    tkClass:
      begin
        // tkClassʱ�����о����ʵ����ַ
        if Assigned(PPointer(ASource)^) then
          AddObject;
      end;
    tkDynArray, tkArray:
      AddArray;
    tkInteger:
      case AType.TypeData^.OrdType of
        otSByte:
          AsInteger := PShortint(ASource)^;
        otUByte:
          AsInteger := PByte(ASource)^;
        otSWord:
          AsInteger := PSmallint(ASource)^;
        otUWord:
          AsInteger := PWord(ASource)^;
        otSLong:
          AsInteger := PInteger(ASource)^;
        otULong:
          AsInt64 := PCardinal(ASource)^;
      end;
{$IFNDEF NEXTGEN}
    tkChar:
      AsString := WideChar(PByte(ASource)^);
    tkString:
      AsString := String(PShortString(ASource)^);
    tkLString:
      AsString := String(PAnsiString(ASource)^);
    tkWString:
      AsString := PWideString(ASource)^;
{$ENDIF}
    tkWChar:
      AsString := PWideChar(ASource)^;
{$IFDEF UNICODE}
    tkUString:
      AsString := PUnicodeString(ASource)^;
{$ENDIF}
    tkEnumeration:
      begin
        if GetTypeData(AType)^.BaseType^ = TypeInfo(Boolean) then
          AsBoolean := PBoolean(ASource)^
        else
        begin
          case AType.TypeData^.OrdType of
            otSByte:
              begin
                if JsonRttiEnumAsInt then
                  AsInteger := PShortint(ASource)^
                else
                  AsString := GetEnumName(AType, PShortint(ASource)^);
              end;
            otUByte:
              begin
                if JsonRttiEnumAsInt then
                  AsInteger := PByte(ASource)^
                else
                  AsString := GetEnumName(AType, PByte(ASource)^);
              end;
            otSWord:
              begin
                if JsonRttiEnumAsInt then
                  AsInteger := PSmallint(ASource)^
                else
                  AsString := GetEnumName(AType, PSmallint(ASource)^);
              end;
            otUWord:
              begin
                if JsonRttiEnumAsInt then
                  AsInteger := PSmallint(ASource)^
                else
                  AsString := GetEnumName(AType, PSmallint(ASource)^);
              end;
            otSLong:
              begin
                if JsonRttiEnumAsInt then
                  AsInteger := PInteger(ASource)^
                else
                  AsString := GetEnumName(AType, PInteger(ASource)^);
              end;
            otULong:
              begin
                if JsonRttiEnumAsInt then
                  AsInteger := PCardinal(ASource)^
                else
                  AsString := GetEnumName(AType, PCardinal(ASource)^);
              end;
          end;
        end
      end;
    tkSet:
      AsString := SetToString(AType, ASource);
    tkVariant:
      AsVariant := PVariant(ASource)^;
    tkInt64:
      AsInt64 := PInt64(ASource)^;
    tkFloat:
      begin
        if (AType = TypeInfo(TDateTime)) or (AType = TypeInfo(TTime)) or (AType = TypeInfo(TDate)) then
          AsDateTime := PDateTime(ASource)^
        else
        begin
          case AType.TypeData^.FloatType of
            ftSingle:
              AsFloat := PSingle(ASource)^;
            ftDouble:
              AsFloat := PDouble(ASource)^;
            ftExtended:
              AsFloat := PExtended(ASource)^;
            ftComp:
              AsBcd := PComp(ASource)^;
            ftCurr:
              AsBcd := PCurrency(ASource)^;
          end;
        end;
      end;
  end;
end;

procedure TQJson.FromRtti(AInstance: TValue);
begin
  case AInstance.Kind of
    tkClass:
      FromRtti(AInstance.AsObject, AInstance.TypeInfo)
  else
    FromRtti(AInstance.GetReferenceToRawData, AInstance.TypeInfo);
  end;
end;
{$IFEND >=2010}

function TQJson.GetA(const APath: String): TQJson;
begin
  Result := ItemByPath(APath);
end;

function TQJson.GetAsArray: QStringW;
begin
  if DataType = jdtArray then
    Result := Value
  else
    raise Exception.Create(Format(SBadConvert, [AsString, 'Array']));
end;

function TQJson.GetAsBase64Bytes: TBytes;
begin
  Result := InternalGetAsBytes(DoDecodeAsBase64, teUtf8, False);
end;

function TQJson.GetAsBcd: TBcd;
begin
  if DataType = jdtBcd then
    Result := PBcd(FValue)^
  else
    Result := StrToBcd(AsString)
end;

function TQJson.GetAsBoolean: Boolean;
begin
  if not TryGetAsBoolean(Result) then
    raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType], 'Boolean']));
end;

function TQJson.GetAsBytes: TBytes;
begin
  if Assigned(OnQJsonDecodeBytes) then
    Result := InternalGetAsBytes(OnQJsonDecodeBytes, teUnicode16LE, True)
  else
    Result := InternalGetAsBytes(DoDecodeAsHex, teUnicode16LE, True);
end;

function TQJson.GetAsDateTime: TDateTime;
begin
  if not TryGetAsDateTime(Result) then
    raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType], 'DateTime']));
end;

function TQJson.GetAsFloat: Extended;
begin
  if not TryGetAsFloat(Result) then
    raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType], 'Numeric']))
end;

function TQJson.GetAsHexBytes: TBytes;
begin
  Result := InternalGetAsBytes(DoDecodeAsHex, teUtf8, False);
end;

function TQJson.GetAsInt64: Int64;
begin
  if not TryGetAsInt64(Result) then
    raise Exception.Create(Format(SBadConvert, [JsonTypeName[DataType], 'Numeric']))
end;

function TQJson.GetAsInteger: Integer;
begin
  Result := GetAsInt64;
end;

function TQJson.GetAsJson: QStringW;
begin
  Result := Encode(True, False, '  ');
end;

function TQJson.GetAsObject: QStringW;
begin
  if DataType = jdtObject then
    Result := Value
  else
    raise Exception.Create(Format(SBadConvert, [AsString, 'Object']));
end;

function TQJson.GetAsString: QStringW;
begin
  if DataType in [jdtNull, jdtUnknown] then
    SetLength(Result, 0)
  else
    Result := Value;
end;

function TQJson.GetAsVariant: Variant;
var
  I: Integer;
begin
  case DataType of
    jdtNull:
      Result := Null;
    jdtString:
      begin
        if IsDateTime then
          Result := AsDateTime
        else
          Result := AsString;
      end;
    jdtInteger:
      Result := AsInt64;
    jdtFloat:
      Result := AsFloat;
    jdtDateTime:
      Result := AsDateTime;
    jdtBoolean:
      Result := AsBoolean;
    jdtArray, jdtObject:
      begin
        Result := VarArrayCreate([0, Count - 1], varVariant);
        for I := 0 to Count - 1 do
          Result[I] := Items[I].AsVariant;
      end
  else
    VarClear(Result);
  end;
end;

function TQJson.GetB(const APath: String): Boolean;
begin
  Result := BoolByPath(APath, False);
end;

function TQJson.GetCount: Integer;
begin
  if DataType in [jdtObject, jdtArray] then
    Result := FItems.Count
  else
    Result := 0;
end;

function TQJson.GetEnumerator: TQJsonEnumerator;
begin
  Result := TQJsonEnumerator.Create(Self);
end;

function TQJson.GetF(const APath: String): Double;
begin
  Result := FloatByPath(APath, 0);
end;

function TQJson.GetI(const APath: String): Int64;
begin
  Result := IntByPath(APath, 0);
end;

function TQJson.GetIsArray: Boolean;
begin
  Result := (DataType = jdtArray);
end;

function TQJson.GetIsBool: Boolean;
begin
  if DataType = jdtBoolean then
    Result := True
  else if DataType = jdtString then
    Result := TryStrToBool(FValue, Result)
  else
    Result := DataType in [jdtInteger, jdtFloat, jdtDateTime];
end;

function TQJson.GetIsDateTime: Boolean;
var
  ATime: TDateTime;
begin
  Result := (DataType = jdtDateTime);
  if not Result then
  begin
    if DataType = jdtString then
      Result := ParseDateTime(PQCharW(FValue), ATime) or ParseJsonTime(PQCharW(FValue), ATime) or
        ParseWebTime(PQCharW(FValue), ATime);
  end;
end;

function TQJson.GetIsNull: Boolean;
begin
  Result := (DataType = jdtNull);
end;

function TQJson.GetIsNumeric: Boolean;
var
  V: Extended;
begin
  if DataType in [jdtInteger, jdtFloat] then
    Result := True
  else if (DataType = jdtString) then
    Result := TryStrToFloat(AsString, V)
  else
    Result := False;
end;

function TQJson.GetIsObject: Boolean;
begin
  Result := (DataType = jdtObject);
end;

function TQJson.GetIsString: Boolean;
begin
  Result := (DataType = jdtString);
end;

function TQJson.GetItemIndex: Integer;
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

function TQJson.GetItems(AIndex: Integer): TQJson;
begin
  Result := FItems[AIndex];
end;

function TQJson.GetO(const APath: String): TQJson;
begin
  Result := ItemByPath(APath);
end;

function TQJson.GetPath: QStringW;
begin
  Result := GetRelPath(nil);
end;

function TQJson.GetRelPath(AParent: TQJson; APathDelimiter: QCharW): QStringW;
var
  AItem, APItem: TQJson;
  AItemName: QStringW;
begin
  AItem := Self;
  SetLength(Result, 0);
  while Assigned(AItem) and (AItem <> AParent) do
  begin
    APItem := AItem.Parent;
    if Assigned(APItem) then
    begin
      if APItem.DataType = jdtArray then
        Result := '[' + IntToStr(AItem.ItemIndex) + ']' + Result
      else
      begin
        AItemName := AItem.Name;
        if Length(AItemName) > 0 then // ������Ԫ��
          Result := APathDelimiter + AItemName + Result
        else
          Result := '[' + IntToStr(AItem.ItemIndex) + ']' + Result;
      end
    end
    else
      Result := APathDelimiter + AItem.Name + Result;
    AItem := APItem;
  end;
  if (Length(Result) > 0) and (PQCharW(Result)^ = APathDelimiter) then
    Result := StrDupX(PQCharW(Result) + 1, Length(Result) - 1);
end;

function TQJson.GetRoot: TQJson;
begin
  Result := Self;
  while Result.FParent <> nil do
    Result := Result.FParent;
end;

function TQJson.GetS(const APath: String): String;
begin
  Result := ValueByPath(APath, '');
end;

function TQJson.GetT(const APath: String): TDateTime;
begin
  Result := DateTimeByPath(APath, 0);
end;

function TQJson.GetV(const APath: String): Variant;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
    Result := AItem.AsVariant
  else
    Result := Null;
end;

function TQJson.GetValue: QStringW;
  procedure ValueAsDateTime;
  var
    ADate: Integer;
    AValue: Extended;
  begin
    AValue := PExtended(FValue)^;
    ADate := Trunc(AValue);
    if SameValue(ADate, 0) then // DateΪ0����ʱ��
    begin
      if SameValue(AValue, 0) then
        Result := FormatDateTime(JsonDateFormat, AValue)
      else
        Result := FormatDateTime(JsonTimeFormat, AValue);
    end
    else
    begin
      if SameValue(AValue - ADate, 0) then
        Result := FormatDateTime(JsonDateFormat, AValue)
      else
        Result := FormatDateTime(JsonDateTimeFormat, AValue);
    end;
  end;

begin
  case DataType of
    jdtNull, jdtUnknown:
      Result := CharNull;
    jdtString:
      Result := FValue;
    jdtInteger:
      Result := IntToStr(PInt64(FValue)^);
    jdtFloat:
      begin
        if PExtended(FValue)^.SpecialType = fsNan then
          Result := 'NaN'
        else if PExtended(FValue)^.SpecialType = fsInf then
          Result := 'Infinite'
        else if PExtended(FValue)^.SpecialType = fsNInf then
          Result := '-Infinite'
        else
          Result := FloatToStr(PExtended(FValue)^);
      end;
    jdtBcd:
      Result := BcdToStr(PBcd(FValue)^);
    jdtDateTime:
      ValueAsDateTime;
    jdtBoolean:
      Result := BooleanToStr(PBoolean(FValue)^);
    jdtArray, jdtObject:
      Result := Encode(True)
  else
    raise QException.CreateFmt(SBadConvert, [Integer(DataType), 'DataType']);
  end;
end;

function TQJson.HasChild(ANamePath: QStringW; var AChild: TQJson): Boolean;
begin
  AChild := ItemByPath(ANamePath);
  Result := AChild <> nil;
end;

function TQJson.HashName(const S: QStringW): TQHashType;
var
  ATemp: QStringW;
begin
  if IgnoreCase then
  begin
    ATemp := UpperCase(S);
    Result := HashOf(PQCharW(ATemp), Length(ATemp) shl 1);
  end
  else
    Result := HashOf(PQCharW(S), Length(S) shl 1)
end;

procedure TQJson.HashNeeded;
begin
  if (FNameHash = 0) and (Length(FName) > 0) then
    FNameHash := HashName(Name);
end;

function TQJson.IndexOf(const AName: QStringW): Integer;
var
  I, l: Integer;
  AItem: TQJson;
  AHash: TQHashType;
begin
  Result := -1;
  l := Length(AName);
  if l > 0 then
    AHash := HashName(AName)
  else
    AHash := 0;
  for I := 0 to Count - 1 do
  begin
    AItem := Items[I];
    if Length(AItem.FName) = l then
    begin
      AItem.HashNeeded;
      if AItem.FNameHash = AHash then
      begin
        if StrCmpW(PQCharW(AItem.FName), PQCharW(AName), IgnoreCase) = 0 then
        begin
          Result := I;
          Break;
        end;
      end;
    end;
  end;
end;

function TQJson.IndexOfValue(const AValue: Variant; AStrict: Boolean): Integer;
var
  I: Integer;
  function DTEqual(S: QStringW; const V: TDateTime): Boolean;
  var
    T: TDateTime;
  begin
    if ParseDateTime(PWideChar(S), T) or ParseJsonTime(PWideChar(S), T) or ParseWebTime(PQCharW(FValue), T) then
      Result := SameValue(T, V)
    else
      Result := False;
  end;

  function BoolEqual(S: String; const V: Boolean): Boolean;
  var
    T: Boolean;
  begin
    if TryStrToBool(S, T) then
      Result := T = V
    else
      Result := False;
  end;

  function CompareWithVariant(ANode: TQJson; const V: Variant): Boolean;
  var
    J: Integer;
  begin
    if VarIsArray(V) then
    begin
      Result := (ANode.DataType in [jdtObject, jdtArray]) and
        (ANode.Count = VarArrayHighBound(V, VarArrayDimCount(V)) - VarArrayLowBound(V, VarArrayDimCount(V)) + 1);
      if Result then
      begin
        for J := 0 to ANode.Count - 1 do
        begin
          if not CompareWithVariant(ANode[J], V[J]) then
          begin
            Result := False;
            Break;
          end;
        end;
      end;
    end
    else if ANode.DataType in [jdtObject, jdtArray] then
      Result := False
    else
    begin
      Result := False;
      case VarType(V) of
        varEmpty, varNull, varUnknown:
          Result := ANode.IsNull;
        varSmallInt, varInteger, varByte, varShortInt, varWord, varLongWord, varInt64{$IF RtlVersion>=26}
          , varUInt64{$IFEND}:
          begin
            if ANode.DataType <> jdtString then
              Result := ANode.AsInt64 = V
            else if AStrict then
              Result := False
            else
              Result := ANode.AsString = VarToStr(V);
          end;
        varSingle, varDouble, varCurrency:
          begin
            if ANode.DataType <> jdtString then
              Result := SameValue(ANode.AsFloat, V)
            else if AStrict then
              Result := False
            else
              Result := ANode.AsString = VarToStr(V);
          end;
        varDate:
          begin
            if ANode.DataType = jdtDateTime then
              Result := SameValue(ANode.AsDateTime, V)
            else if ANode.DataType = jdtString then
              Result := DTEqual(ANode.AsString, V);
          end;
        varOleStr, varString{$IFDEF UNICODE}, varUString{$ENDIF}:
          Result := (ANode.AsString = V);
        varBoolean:
          begin
            if AStrict then
            begin
              if ANode.DataType = jdtBoolean then
                Result := ANode.AsBoolean = V
              else
                Result := False;
            end
            else
            begin
              if ANode.IsString then
                Result := BoolEqual(ANode.AsString, V)
              else
                Result := ANode.AsBoolean = V;
            end;
          end;
      end;
    end;
  end;

begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if CompareWithVariant(Items[I], AValue) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TQJson.Insert(AIndex: Integer; const AName, AValue: String; ADataType: TQJsonDataType): TQJson;
begin
  Result := Insert(AIndex, AName);
  Result.FromType(AValue, ADataType);
end;

function TQJson.Insert(AIndex: Integer; const AName: String; ADataType: TQJsonDataType): TQJson;
begin
  Result := CreateJson;
  Insert(AIndex, Result);
  Result.Name := AName;
  Result.DataType := ADataType;
end;

function TQJson.Insert(AIndex: Integer; const AName: String): TQJson;
begin
  Result := Insert(AIndex, AName, jdtUnknown);
end;

function TQJson.Insert(AIndex: Integer; const AName: String; AValue: Extended): TQJson;
begin
  Result := Insert(AIndex, AName);
  Result.AsFloat := AValue;
end;

procedure TQJson.Insert(AIndex: Integer; AChild: TQJson);
begin
  if Assigned(AChild.Parent) then
  begin
    if AChild.Parent <> Self then
      AChild.Parent.Remove(AChild)
    else
      Exit;
  end;
  ArrayNeeded(jdtObject);
  AChild.FParent := Self;
  AChild.FIgnoreCase := FIgnoreCase;
  if AIndex <= 0 then
    AIndex := 0
  else if AIndex >= Count then
    AIndex := Count;
  FItems.Insert(AIndex, AChild);
end;

function TQJson.Insert(AIndex: Integer; const AName: String; AValue: Boolean): TQJson;
begin
  Result := Insert(AIndex, AName);
  Result.AsBoolean := AValue;
end;

function TQJson.Insert(AIndex: Integer; const AName: String; AValue: Int64): TQJson;
begin
  Result := Insert(AIndex, AName);
  Result.AsInt64 := AValue;
end;

function TQJson.IntByName(AName: QStringW; ADefVal: Int64): Int64;
var
  AChild: TQJson;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) then
  begin
    if not AChild.TryGetAsInt64(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.IntByPath(APath: QStringW; ADefVal: Int64): Int64;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
  begin
    if not AItem.TryGetAsInt64(Result) then
      Result := ADefVal;
  end
  else
    Result := ADefVal;
end;

function TQJson.InternalEncode(ABuilder: TQStringCatHelperW; ASettings: TJsonEncodeSettings; const AIndent: QStringW)
  : TQStringCatHelperW;
  procedure StrictJsonTime(ATime: TDateTime);
  var
    MS: Int64; // ʱ����Ϣ������
  const
    JsonTimeStart: PWideChar = '/DATE(';
    JsonTimeEnd: PWideChar = ')/';
    UnixDelta: Int64 = 25569;
  begin
    MS := Trunc((ATime - UnixDelta) * 86400000);
    ABuilder.Cat(JsonTimeStart, 6);
    if (JsonTimezone >= -12) and (JsonTimezone <= 12) then
    begin
      Dec(MS, 3600000 * JsonTimezone);
      if JsonDatePrecision = jdpSecond then
        MS := MS div 1000;
      ABuilder.Cat(IntToStr(MS));
      if JsonTimezone >= 0 then
        ABuilder.Cat('+');
      ABuilder.Cat(JsonTimezone);
    end
    else
      ABuilder.Cat(IntToStr(MS));
    ABuilder.Cat(JsonTimeEnd, 2);
  end;
  procedure AddComment(const S: QStringW);
  var
    p: PQCharW;
    ALine: QStringW;
  const
    SLineComment: PWideChar = '//';
    SBlockComentStart: PWideChar = '/*';
    SBlockComentStop: PWideChar = '*/';
  begin
    p := PQCharW(S);
    while p^ <> #0 do
    begin
      ALine := DecodeLineW(p, False);
      ABuilder.Cat(SLineComment, 2);
      ABuilder.Cat(ALine);
      ABuilder.Cat(SLineBreak);
    end;
  end;
  function Ignore(ANode: TQJson): Boolean;
  begin
    Result := False;
    if [jesIgnoreNull, jesIgnoreDefault] * ASettings <> [] then
    begin
      if ANode.DataType in [jdtNull, jdtUnknown] then
        Result := True
      else if jesIgnoreDefault in ASettings then
      begin
        case ANode.DataType of
          jdtString:
            Result := Length(ANode.FValue) = 0;
          jdtInteger:
            Result := ANode.AsInt64 = 0;
          jdtFloat:
            Result := IsZero(ANode.AsFloat);
          jdtBoolean:
            Result := not ANode.AsBoolean;
          jdtDateTime:
            Result := IsZero(ANode.AsDateTime);
          jdtArray, jdtObject:
            Result := ANode.Count = 0;
        end;
      end;
    end;
  end;
  procedure DoEncode(ANode: TQJson; ALevel: Integer);
  var
    I, AEncoded: Integer;
    ArrayWraped: Boolean;
    AChild: TQJson;
  begin
    if (jesWithComment in ASettings) and (Length(ANode.Comment) > 0) and
      ((ANode.CommentStyle = jcsBeforeName) or ((ANode.CommentStyle = jcsInherited) and (CommentStyle = jcsBeforeName)))
    then
      AddComment(ANode.Comment);
    if (ANode.Parent <> nil) and (ANode.Parent.DataType <> jdtArray) and (ANode <> Self) then
    begin
      if jesDoFormat in ASettings then
        ABuilder.Replicate(AIndent, ALevel);
      ABuilder.Cat(CharNameStart);
      JsonCat(ABuilder, ANode.FName, ASettings);
      ABuilder.Cat(CharNameEnd);
    end;
    case ANode.DataType of
      jdtArray:
        begin
          ABuilder.Cat(CharArrayStart);
          if ANode.Count > 0 then
          begin
            ArrayWraped := False;
            AEncoded := 0;
            for I := 0 to ANode.Count - 1 do
            begin
              AChild := ANode.Items[I];
              if Ignore(AChild) then
                continue;
              if AChild.DataType in [jdtArray, jdtObject] then
              begin
                if jesDoFormat in ASettings then
                begin
                  ABuilder.Cat(SLineBreak); // ���ڶ�������飬����
                  ABuilder.Replicate(AIndent, ALevel + 1);
                  ArrayWraped := True;
                end;
              end
              else if (jes1Element1Line in ASettings) then
              begin
                ABuilder.Cat(SLineBreak);
                ABuilder.Replicate(AIndent, ALevel + 1);
                ArrayWraped := True;
              end;
              DoEncode(AChild, ALevel + 1);
              Inc(AEncoded);
            end;
            if AEncoded > 0 then
              ABuilder.Back(1);
            if ArrayWraped then
            begin
              ABuilder.Cat(SLineBreak);
              ABuilder.Replicate(AIndent, ALevel);
            end;
          end;
          ABuilder.Cat(CharArrayEnd);
        end;
      jdtObject:
        begin
          ABuilder.Cat(CharObjectStart);
          AEncoded := 0;
          if jesDoFormat in ASettings then
            ABuilder.Cat(SLineBreak);
          for I := 0 to ANode.Count - 1 do
          begin
            AChild := ANode.Items[I];
            if Ignore(AChild) then
              continue;
            DoEncode(AChild, ALevel + 1);
            Inc(AEncoded);
            if jesDoFormat in ASettings then
              ABuilder.Cat(SLineBreak);
          end;
          if AEncoded > 0 then
          begin
            if jesDoFormat in ASettings then
              ABuilder.BackIf(' '#9#10#13);
            ABuilder.Back(1);
          end;
          if (jesDoFormat in ASettings) and (AEncoded > 0) then
          begin
            ABuilder.BackIf(' '#9#10#13);
            ABuilder.Cat(SLineBreak);
          end;
          if AEncoded > 0 then
          begin
            if (jesDoFormat in ASettings) then
              ABuilder.Replicate(AIndent, ALevel);
          end
          else
            ABuilder.BackIf(' '#9#10#13);
          ABuilder.Cat(CharObjectEnd);
        end;
      jdtNull, jdtUnknown:
        begin
          if jesNullAsString in ASettings then
            ABuilder.Cat(CharStringStart).Cat(CharStringEnd)
          else
            ABuilder.Cat(CharNull);
        end;
      jdtString:
        begin
          ABuilder.Cat(CharStringStart);
          JsonCat(ABuilder, ANode.FValue, ASettings);
          ABuilder.Cat(CharStringEnd);
        end;
      jdtInteger, jdtBoolean:
        ABuilder.Cat(ANode.Value);
      jdtFloat:
        begin
          if Length(ANode.ValueFormat) > 0 then
            ABuilder.Cat(FormatFloat(ANode.ValueFormat, ANode.AsFloat))
          else
            ABuilder.Cat(ANode.Value);
        end;
      jdtBcd:
        begin
          if Length(ANode.ValueFormat) > 0 then
            ABuilder.Cat(FormatFloat(ANode.ValueFormat, ANode.AsFloat))
          else
            ABuilder.Cat(ANode.Value);
        end;
      jdtDateTime:
        begin
          ABuilder.Cat(CharStringStart);
          if jesJavaDateTime in ASettings then
            StrictJsonTime(ANode.AsDateTime)
          else if Length(ANode.ValueFormat) > 0 then
            ABuilder.Cat(FormatDateTime(ANode.ValueFormat, ANode.AsDateTime))
          else
            ABuilder.Cat(ANode.Value);
          ABuilder.Cat(CharStringEnd);
        end;
    end;
    if (jesWithComment in ASettings) and (Length(ANode.Comment) > 0) and
      ((ANode.CommentStyle = jcsAfterValue) or ((ANode.CommentStyle = jcsInherited) and (CommentStyle = jcsAfterValue)))
    then
    begin
      AddComment(ANode.Comment);
      if jesDoFormat in ASettings then
        ABuilder.Replicate(AIndent, ALevel);
    end;
    ABuilder.Cat(CharComma);
  end;

begin
  Result := ABuilder;
  DoEncode(Self, 0);
end;

function TQJson.InternalFlatItems(var AItems: TQStringArray; AFlatPart: Integer; AOptions: TQCatOptions): Integer;
var
  AIndex, ADupIndex: Integer;
  AValue: QStringW;
  AFound: Boolean;
begin
  SetLength(AItems, Count);
  Result := 0;
  for AIndex := 0 to Count - 1 do
  begin
    with Items[AIndex] do
    begin
      if AFlatPart = 0 then
        AValue := Name
      else
        AValue := AsString;
      if (Length(AValue) = 0) and (coIgnoreEmpty in AOptions) then
        continue;
      AFound := False;
      if coIgnoreDuplicates in AOptions then
      begin
        for ADupIndex := 0 to Result - 1 do
        begin
          if (AItems[ADupIndex] = AValue) or
            ((coIgnoreCase in AOptions) and (CompareText(AItems[ADupIndex], AValue) = 0)) then
          begin
            AFound := True;
            Break;
          end;
        end;
      end;
    end;
    if not AFound then
    begin
      AItems[Result] := AValue;
      Inc(Result);
    end;
  end;
end;

function TQJson.InternalGetAsBytes(AConverter: TQJsonDecodeBytesEvent; AEncoding: TTextEncoding;
  AWriteBom: Boolean): TBytes;
var
  I: Integer;
  AItem: TQJson;
  function StrToBytes: TBytes;
  var
    V: QStringW;
    U: QStringA;
  begin
    V := AsString;
    SetLength(Result, 0);
    try
      AConverter(V, Result)
    except
    end;
    if (Length(Result) = 0) and (Length(V) > 0) then
    begin
      if AEncoding = teUtf8 then
      begin
        U := qstring.Utf8Encode(V);
        if AWriteBom then
        begin
          SetLength(Result, U.Length + 3);
          // ǰ�����UTF8��BOM
          Result[0] := $EF;
          Result[1] := $BB;
          Result[2] := $BF;
          Move(PQCharA(U)^, Result[3], U.Length);
        end
        else
          Result := U;
      end
      else if AEncoding = teAnsi then // ANSIû�� BOM ͷ�����Ժ���
        Result := AnsiEncode(V)
      else if AEncoding = teUnicode16BE then
      begin
        if AWriteBom then
        begin
          SetLength(Result, Length(V) shl 1 + 2);
          Move(PWideChar(V)^, Result[2], Length(Result) - 2);
          ExchangeByteOrder(PQCharA(@Result[2]), Length(Result));
          Result[0] := $FE;
          Result[1] := $FF;
        end
        else
        begin
          SetLength(Result, Length(V) shl 1);
          Move(PWideChar(V)^, Result[0], Length(Result));
          ExchangeByteOrder(PQCharA(@Result[0]), Length(Result));
        end;
      end
      else
      begin
        if AWriteBom then
        begin
          SetLength(Result, Length(V) shl 1 + 2);
          Move(PWideChar(V)^, Result[2], Length(Result) - 2);
          Result[0] := $FF;
          Result[1] := $FE;
        end
        else
        begin
          SetLength(Result, Length(V) shl 1);
          Move(PWideChar(V)^, Result[0], Length(Result));
        end;
      end;
    end;
  end;

begin
  if DataType = jdtString then // �ַ���
  begin
    Result := StrToBytes
  end
  else if DataType = jdtArray then
  begin
    SetLength(Result, Count);
    for I := 0 to Count - 1 do
    begin
      AItem := Items[I];
      if (AItem.DataType = jdtInteger) and (AItem.AsInteger >= 0) and (AItem.AsInteger <= 255) then
        Result[I] := AItem.AsInteger
      else
        raise Exception.CreateFmt(SConvertError, ['jdtArray', 'Bytes']);
    end;
  end
  else
    raise Exception.CreateFmt(SConvertError, [JsonTypeName[DataType], 'Bytes']);
end;

procedure TQJson.InternalRttiFilter(ASender: TQJson; AObject: Pointer; APropName: QStringW; APropType: PTypeInfo;
  var Accept: Boolean; ATag: Pointer);
var
  ATagData: PQJsonInternalTagData;
  procedure DoNameFilter;
  var
    ps: PQCharW;
  begin
    if Length(ATagData.AcceptNames) > 0 then
    begin
      Accept := False;
      ps := StrIStrW(PQCharW(ATagData.AcceptNames), PQCharW(APropName));
      if (ps <> nil) and ((ps = PQCharW(ATagData.AcceptNames)) or (ps[-1] = ',') or (ps[-1] = ';')) then
      begin
        ps := ps + Length(APropName);
        Accept := (ps^ = ',') or (ps^ = ';') or (ps^ = #0);
      end;
    end
    else if Length(ATagData.IgnoreNames) > 0 then
    begin
      ps := StrIStrW(PQCharW(ATagData.IgnoreNames), PQCharW(APropName));
      Accept := True;
      if (ps <> nil) and ((ps = PQCharW(ATagData.IgnoreNames)) or (ps[-1] = ',') or (ps[-1] = ';')) then
      begin
        ps := ps + Length(APropName);
        Accept := not((ps^ = ',') or (ps^ = ';') or (ps^ = #0));
      end;
    end;
  end;

begin
  ATagData := PQJsonInternalTagData(ATag);
  if ATagData.TagType = ttNameFilter then
  begin
    DoNameFilter;
    Exit;
  end;
{$IF RTLVersion>=21}
  if ATagData.TagType = ttAnonEvent then
  begin
    ATagData.OnEvent(ASender, AObject, APropName, APropType, Accept, ATagData.Tag);
  end;
{$IFEND >=2010}
end;

procedure TQJson.InternalSetAsBytes(AConverter: TQJsonEncodeBytesEvent; ABytes: TBytes);
var
  S: QStringW;
begin
  AConverter(ABytes, S);
  AsString := S;
end;

function TQJson.Intersect(AJson: TQJson): TQJson;
var
  I, H1, H2, J: Integer;
  AItem1, AItem2, AResult: TQJson;
begin
  Result := AcquireJson;
  if DataType = AJson.DataType then
  begin
    H1 := Count - 1;
    H2 := AJson.Count - 1;
    for I := 0 to H1 do
    begin
      AItem1 := Items[I];
      for J := 0 to H2 do
      begin
        AItem2 := AJson[J];
        if (AItem1.Name = AItem2.Name) and (AItem1.DataType = AItem2.DataType) then
        begin
          if AItem1.DataType in [jdtArray, jdtObject] then
          begin
            AResult := AItem1.Intersect(AItem2);
            if AResult.Count > 0 then
              Result.Add(AItem1.Name, AResult)
            else
              FreeAndNil(AResult);
          end
          else if AItem1.FValue = AItem2.FValue then
          begin
            Result.Add(AItem1.Name, AItem1.DataType).Assign(AItem1);
            Break;
          end;
        end;
      end;
    end;
  end;
end;

function TQJson.IsChildOf(AParent: TQJson): Boolean;
begin
  if Assigned(FParent) then
  begin
    if AParent = FParent then
      Result := True
    else
      Result := FParent.IsChildOf(AParent);
  end
  else
    Result := False;
end;

function TQJson.Exists(const APath: QStringW): Boolean;
begin
  Result := ItemByPath(APath) <> nil;
end;

function TQJson.IsParentOf(AChild: TQJson): Boolean;
begin
  if Assigned(AChild) then
    Result := AChild.IsChildOf(Self)
  else
    Result := False;
end;

function TQJson.ItemByName(AName: QStringW): TQJson;
var
  I: Integer;
  p: PQCharW;
  AIndex: Int64;
begin
  Result := nil;
  if DataType = jdtObject then // ����ƥ�����ƣ�����Ҳ����������Ƿ���[n]���ַ��ʷ�ʽ
  begin
    I := IndexOf(AName);
    if I <> -1 then
      Result := Items[I];
  end;
  if not Assigned(Result) then
  begin
    p := PQCharW(AName);
    if (p^ = '[') and (DataType in [jdtObject, jdtArray]) then
    begin
      Inc(p);
      SkipSpaceW(p);
      if ParseInt(p, AIndex) <> 0 then
      begin
        SkipSpaceW(p);
        if p^ = ']' then
        begin
          Inc(p);
          if p^ <> #0 then
            Exit;
        end
        else
          Exit;
      end
      else
        Exit;
      if (AIndex >= 0) and (AIndex < Count) then
        Result := Items[AIndex];
    end;
  end;
end;

function TQJson.ItemByName(const AName: QStringW; AList: TQJsonItemList; ANest: Boolean): Integer;
var
  AHash: TQHashType;
  l: Integer;
  function InternalFind(AParent: TQJson): Integer;
  var
    I: Integer;
    AItem: TQJson;
  begin
    Result := -1;
    for I := 0 to Count - 1 do
    begin
      AItem := Items[I];
      if Length(AItem.FName) = l then
      begin
        AItem.HashNeeded;
        if AItem.FNameHash = AHash then
        begin
          if StrCmpW(PQCharW(AItem.FName), PQCharW(AName), IgnoreCase) = 0 then
            AList.Add(AItem);
        end;
      end;
      if ANest then
        InternalFind(AItem);
    end;
  end;

begin
  l := Length(AName);
  if l > 0 then
  begin
    AHash := HashName(AName);
    Result := InternalFind(Self);
  end
  else
  begin
    AHash := 0;
    Result := -1;
    Exit;
  end;
end;

function TQJson.ItemByPath(APath: QStringW): TQJson;
var
  AParent: TQJson;
  AName: QStringW;
  p, pn, ws: PQCharW;
  l: Integer;
  AIndex: Int64;
const
  PathDelimiters: PWideChar = './\';
  ArrayStart: PWideChar = '[';
begin
  AParent := Self;
  p := PQCharW(APath);
  Result := nil;
  while Assigned(AParent) and (p^ <> #0) do
  begin
    AName := JavaUnescape(DecodeTokenW(p, PathDelimiters, WideChar(0), False), False);
    if Length(AName) > 0 then
    begin
      // ���ҵ������飿
      l := Length(AName);
      AIndex := -1;
      pn := PQCharW(AName);
      if (pn[l - 1] = ']') then
      begin
        ws := pn;
        if pn^ = '[' then // �����ֱ�ӵ����飬��ֱ��ȡ��ǰ��parentΪ����ĸ�
          Result := AParent
        else
        begin
          SkipUntilW(ws, ArrayStart);
          Result := AParent.ItemByName(StrDupX(pn, (IntPtr(ws) - IntPtr(pn)) shr 1));
        end;
        if Result <> nil then
        begin
          if Result.DataType in [jdtArray, jdtObject] then
          begin
            repeat
              Inc(ws);
              SkipSpaceW(ws);
              if ParseInt(ws, AIndex) <> 0 then
              begin
                if (AIndex >= 0) and (AIndex < Result.Count) then
                begin
                  Result := Result[AIndex];
                  SkipSpaceW(ws);
                  if ws^ = ']' then
                  begin
                    Inc(ws);
                    SkipSpaceW(ws);
                    if ws^ = '[' then
                      continue
                    else if ws^ = #0 then
                      Break
                    else
                      Result := nil;
                  end
                  else
                    Result := nil;
                end
                else
                  Result := nil;
              end;
            until Result = nil;
          end
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
{$IFDEF ENABLE_REGEX}

function TQJson.ItemByRegex(const ARegex: QStringW; AList: TQJsonItemList; ANest: Boolean): Integer;
var
  ANode: TQJson;
  APcre: TPerlRegEx;
  function RegexStr(const S: QStringW):
{$IF RTLVersion<=24}UTF8String{$ELSE}UnicodeString{$IFEND};
  begin
{$IF RTLVersion<19}
    Result := System.Utf8Encode(S);
{$ELSE}
{$IF RTLVersion<=24}
    Result := UTF8String(S);
{$ELSE}
    Result := S;
{$IFEND}
{$IFEND}
  end;
  function InternalFind(AParent: TQJson): Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to AParent.Count - 1 do
    begin
      ANode := AParent.Items[I];
      APcre.Subject := RegexStr(ANode.Name);
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
    APcre.RegEx := RegexStr(ARegex);
    APcre.Compile;
    Result := InternalFind(Self);
  finally
    FreeObject(APcre);
  end;
end;

function TQJson.Match(const ARegex: QStringW; AMatches: TQJsonMatchSettings): IQJsonContainer;
var
  T: TQJsonContainer;
begin
  T := TQJsonContainer.Create;
  try
    T.FItems.Add(Self);
    Result := T.Match(ARegex, AMatches);
  finally
    FreeAndNil(T);
  end;
end;
{$ENDIF}

class function TQJson.JsonCat(const S: QStringW; ASettings: TJsonEncodeSettings): QStringW;
var
  ABuilder: TQStringCatHelperW;
begin
  ABuilder := TQStringCatHelperW.Create;
  try
    JsonCat(ABuilder, S, ASettings);
    Result := ABuilder.Value;
  finally
    FreeObject(ABuilder);
  end;
end;

class function TQJson.JsonEscape(const S: QStringW; ASettings: TJsonEncodeSettings): QStringW;
begin
  Result := JsonCat(S, ASettings);
end;

class function TQJson.JsonUnescape(const S: QStringW): QStringW;
begin
  Result := BuildJsonString(S);
end;

procedure TQJson.LoadFromFile(const AFileName: String; AEncoding: TTextEncoding);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(AStream, AEncoding);
  finally
    FreeObject(AStream);
  end;
end;

procedure TQJson.LoadFromResource(AInstance: HINST; const AResourceName: String; AEncoding: TTextEncoding);
var
  AStream: TResourceStream;
begin
  AStream := TResourceStream.Create(AInstance, AResourceName, RT_RCDATA);
  try
    LoadFromStream(AStream, AEncoding);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQJson.LoadFromStream(AStream: TStream; AEncoding: TTextEncoding);
var
  S: QStringW;
begin
  S := LoadTextW(AStream, AEncoding);
  case Length(S) of
    0:
      DataType := jdtNull;
    1:
      raise Exception.Create(SBadJson)
  else
    Parse(PQCharW(S), Length(S));
  end;
end;

procedure TQJson.Merge(ASource: TQJson; AMethod: TQJsonMergeMethod);
var
  I, AIdx: Integer;
  ASourceChild: TQJson;
  function IndexOfValue: Integer;
  var
    J, H: Integer;
    AItem: TQJson;
  begin
    H := Count - 1;
    Result := -1;
    for J := 0 to H do
    begin
      AItem := Items[J];
      if AItem.Equals(ASourceChild) then
      begin
        Result := J;
        Break;
      end;
    end;
  end;

begin
  for I := 0 to ASource.Count - 1 do
  begin
    ASourceChild := ASource[I];
    if AMethod <> jmmAppend then
    begin
      if ASourceChild.IsArray then
        AIdx := IndexOfValue
      else
        AIdx := IndexOf(ASourceChild.Name);
      if AIdx = -1 then
        ForceName(ASourceChild.Name).Assign(ASourceChild)
      else if AMethod = jmmAsSource then
        Items[AIdx].Assign(ASourceChild)
      else if AMethod = jmmIgnore then // ���һ�£����Ժϲ���Ԫ��
        Items[AIdx].Merge(ASourceChild, AMethod)
      else // jmmReplace
      begin
        // ���������滻�Ļ���ֱ���滻����ֵ������
        if Items[AIdx].DataType = jdtObject then
          Items[AIdx].Merge(ASourceChild, AMethod)
        else
          Items[AIdx].Assign(ASourceChild);
      end;
    end
    else
      Add(ASourceChild.Name, ASourceChild.DataType).Assign(ASourceChild);
  end;
end;

procedure TQJson.MoveTo(ANewParent: TQJson; AIndex: Integer);
begin
  if ANewParent = Self then
    raise Exception.Create(SCantAttachToSelf)
  else
  begin
    if Parent = ANewParent then
    begin
      Parent.FItems.Move(ItemIndex, AIndex);
      Exit;
    end;
    if IsParentOf(ANewParent) then
      raise Exception.Create(SCantMoveToChild);
    if ANewParent.DataType in [jdtArray, jdtObject] then
    begin
      if ANewParent.DataType = jdtObject then
      begin
        if Length(Name) = 0 then
          raise Exception.Create(SCantAttachNoNameNodeToObject)
        else if ANewParent.IndexOf(Name) <> -1 then
          raise Exception.CreateFmt(SNodeNameExists, [Name]);;
      end;
      if Assigned(FParent) then
        FParent.Remove(Self);
      FParent := ANewParent;
      if AIndex >= ANewParent.Count then
        ANewParent.FItems.Add(Self)
      else if AIndex <= 0 then
        ANewParent.FItems.Insert(0, Self)
      else
        ANewParent.FItems.Insert(AIndex, Self);
      DoJsonNameChanged(Self);
    end
    else
      raise Exception.Create(SCanAttachToNoneContainer);
  end;
end;

function TQJson.NameArray: TArray<String>;
begin
  SetLength(Result, Count);
  for var I := 0 to High(Result) do
    Result[I] := Items[I].Name;
end;

function TQJson.NameToStrings(AList: TStrings; AOptions: TQCatOptions): Integer;
var
  AItems: TQStringArray;
  AIndex: Integer;
begin
  Result := InternalFlatItems(AItems, 0, AOptions);
  AList.BeginUpdate;
  try
    for AIndex := 0 to Result - 1 do
      AList.Add(AItems[AIndex]);
  finally
    AList.EndUpdate;
  end;
end;

procedure TQJson.Parse(p: PWideChar; l: Integer);
  procedure ParseCopy;
  var
    S: QStringW;
  begin
    S := StrDupW(p, 0, l);
    p := PQCharW(S);
    ParseObject(p);
  end;

begin
  if DataType in [jdtObject, jdtArray] then
    Clear;
  if (l > 0) and (p[l] <> #0) then
    ParseCopy
  else if p^ <> #0 then
    ParseObject(p);
end;

procedure TQJson.Parse(const S: QStringW);
begin
  Parse(PQCharW(S), Length(S));
end;

procedure TQJson.ParseBlock(AStream: TStream; AEncoding: TTextEncoding);
var
  AMS: TMemoryStream;
  procedure ParseUCS2;
  var
    c: QCharW;
    ABlockCount: Integer;
  begin
    ABlockCount := 0;
    repeat
      if ABlockCount = 0 then
      begin
        repeat
          AStream.ReadBuffer(c, SizeOf(QCharW));
          AMS.WriteBuffer(c, SizeOf(QCharW));
        until c = '{';
        Inc(ABlockCount);
      end;
      AStream.ReadBuffer(c, SizeOf(QCharW));
      if c = '{' then
        Inc(ABlockCount)
      else if c = '}' then
        Dec(ABlockCount);
      AMS.WriteBuffer(c, SizeOf(QCharW));
    until ABlockCount = 0;
    c := #0;
    AMS.Write(c, SizeOf(QCharW));
    Parse(AMS.Memory, AMS.Size - 1);
  end;

  procedure ParseUCS2BE;
  var
    c: Word;
    ABlockCount: Integer;
    p: PQCharW;
  begin
    ABlockCount := 0;
    repeat
      if ABlockCount = 0 then
      begin
        repeat
          AStream.ReadBuffer(c, SizeOf(Word));
          c := (c shr 8) or ((c shl 8) and $FF00);
          AMS.WriteBuffer(c, SizeOf(Word));
        until c = $7B; // #$7B={
        Inc(ABlockCount);
      end;
      AStream.ReadBuffer(c, SizeOf(Word));
      c := (c shr 8) or ((c shl 8) and $FF00);
      if c = $7B then
        Inc(ABlockCount)
      else if c = $7D then // #$7D=}
        Dec(ABlockCount);
      AMS.WriteBuffer(c, SizeOf(QCharW));
    until ABlockCount = 0;
    c := 0;
    AMS.Write(c, SizeOf(QCharW));
    p := AMS.Memory;
    ParseObject(p);
  end;

  procedure ParseByByte;
  var
    c: Byte;
    ABlockCount: Integer;
  begin
    ABlockCount := 0;
    repeat
      if ABlockCount = 0 then
      begin
        repeat
          AStream.ReadBuffer(c, SizeOf(Byte));
          AMS.WriteBuffer(c, SizeOf(Byte));
        until c = $7B;
        // #$7B={
        Inc(ABlockCount);
      end;
      AStream.ReadBuffer(c, SizeOf(Byte));
      if c = $7B then
        Inc(ABlockCount)
      else if c = $7D then // #$7D=}
        Dec(ABlockCount);
      AMS.WriteBuffer(c, SizeOf(Byte));
    until ABlockCount = 0;
  end;

  procedure ParseUtf8;
  var
    S: QStringW;
    p: PQCharW;
  begin
    ParseByByte;
    S := qstring.Utf8Decode(AMS.Memory, AMS.Size);
    p := PQCharW(S);
    ParseObject(p);
  end;

  procedure ParseAnsi;
  var
    S: QStringW;
  begin
    ParseByByte;
    S := qstring.AnsiDecode(AMS.Memory, AMS.Size);
    Parse(PQCharW(S));
  end;

begin
  AMS := TMemoryStream.Create;
  try
    if AEncoding = teAnsi then
      ParseAnsi
    else if AEncoding = teUtf8 then
      ParseUtf8
    else if AEncoding = teUnicode16LE then
      ParseUCS2
    else if AEncoding = teUnicode16BE then
      ParseUCS2BE
    else
      raise Exception.Create(SBadJsonEncoding);
  finally
    AMS.Free;
  end;
end;

function TQJson.ParseJsonPair(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
const
  SpaceWithSemicolon: PWideChar = ': '#9#10#13#$3000;
  CommaWithSpace: PWideChar = ', '#9#10#13#$3000;
  JsonEndChars: PWideChar = ',}]';
  JsonComplexEnd: PWideChar = '}]';
var
  AChild: TQJson;
  AObjEnd, lastP: QCharW;
  AComment: QStringW;
begin
  Result := SkipSpaceAndComment(p, AComment);
  if Result <> 0 then
    Exit;
  if Length(AComment) > 0 then
    FComment := AComment;
  if Assigned(FParent) and (FParent.DataType = jdtObject) and (Length(FName) = 0) then
  begin
    Result := ParseName(ABuilder, p);
    if Result <> 0 then
      Exit;
  end;
  // ����ֵ
  if (p^ = '{') or (p^ = '[') then // ����
  begin
    try
      if p^ = '{' then
      begin
        DataType := jdtObject;
        AObjEnd := '}';
      end
      else
      begin
        DataType := jdtArray;
        AObjEnd := ']';
      end;
      Inc(p);
      Result := SkipSpaceAndComment(p, AComment);
      while (p^ <> #0) and (p^ <> AObjEnd) do
      begin
        if (p^ <> AObjEnd) then
        begin
          AChild := Add;
          if Length(AComment) > 0 then
          begin
            AChild.FComment := AComment;
            SetLength(AComment, 0);
          end;
          Result := AChild.ParseJsonPair(ABuilder, p);
          if Result <> 0 then
            Exit;
          if p^ = ',' then
          begin
            lastP := p^;
            Inc(p);
            Result := SkipSpaceAndComment(p, AComment, lastP);
            if Result <> 0 then
              Exit;
          end;
        end
        else
          Exit;
      end;
      Result := SkipSpaceAndComment(p, AComment);
      if Result <> 0 then
        Exit;
      if p^ <> AObjEnd then
      begin
        Result := EParse_BadJson;
        Exit;
      end
      else
      begin
        Inc(p);
        SkipSpaceAndComment(p, AComment);
      end;
    except
      Clear;
      raise;
    end;
  end
  else if Parent <> nil then
  begin
    Result := TryParseValue(ABuilder, p);
    if Result = 0 then
    begin
      SkipSpaceAndComment(p, AComment);
      if Length(AComment) > 0 then
        FComment := AComment;
      if not CharInW(p, JsonEndChars) then
      begin
        Result := EParse_EndCharNeeded;
      end;
    end;
  end
  else
    Result := TryParseValue(ABuilder, p);
end;

function TQJson.ParseJsonTime(p: PQCharW; var ATime: TDateTime): Boolean;
var
  MS, TimeZone: Int64;
const
  UnixDelta: Int64 = 25569;
begin
  // Javascript���ڸ�ʽΪ/DATE(��1970.1.1�����ڵĺ�����+ʱ��)/
  Result := False;
  if not StartWithW(p, '/DATE', True) then
    Exit;
  Inc(p, 5);
  SkipSpaceW(p);
  if p^ <> '(' then
    Exit;
  Inc(p);
  SkipSpaceW(p);
  if ParseInt(p, MS) = 0 then
    Exit;
  SkipSpaceW(p);
  if (p^ = '+') or (p^ = '-') then
  begin
    if ParseInt(p, TimeZone) = 0 then
      Exit;
    SkipSpaceW(p);
  end
  else
    TimeZone := 0;
  if p^ = ')' then
  begin
    if (MS > 10000000000) or (JsonDatePrecision = jdpMillisecond) then
      ATime := UnixDelta + (MS div 86400000) + ((MS mod 86400000) / 86400000)
    else
      ATime := UnixDelta + (MS div 86400) + ((MS mod 86400) / 86400);
    if TimeZone <> 0 then
      ATime := IncHour(ATime, TimeZone);
    Inc(p);
    SkipSpaceW(p);
    Result := True
  end;
end;

procedure TQJson.ParseMultiBlock(const S: QStringW);
var
  p: PQCharW;
begin
  p := PQCharW(S);
  DataType := jdtArray;
  Clear;
  SkipSpaceW(p);
  while p^ <> #0 do
  begin
    Add.ParseObject(p);
    SkipSpaceW(p);
  end;
end;

function TQJson.ParseName(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
var
  AInQuoter: Boolean;
  AComment: QStringW;
begin
  if StrictJson and (p^ <> '"') then
  begin
    Result := EParse_BadNameStart;
    Exit;
  end;
  AInQuoter := (p^ = '"') or (p^ = '''');
  if not BuildJsonString(ABuilder, p) then
  begin
    Result := EParse_NameNotFound;
    Exit;
  end;
  SkipSpaceAndComment(p, AComment);
  if p^ <> ':' then
  begin
    Result := EParse_BadNameEnd;
    Exit;
  end;
  if not AInQuoter then
    ABuilder.TrimRight;
  FName := ABuilder.Value;

  // �����������
  Inc(p);
  SkipSpaceAndComment(p, AComment);
  Result := 0;
end;

procedure TQJson.ParseObject(var p: PQCharW);
var
  ABuilder: TQStringCatHelperW;
  ps: PQCharW;
  AErrorCode: Integer;
  AComment: QStringW;
begin
  SkipBom(p);
  ABuilder := TQStringCatHelperW.Create;
  try
    ps := p;
    try
      SkipSpaceAndComment(p, AComment);
      if Length(AComment) > 0 then
        FComment := AComment;
      AErrorCode := ParseJsonPair(ABuilder, p);
      if AErrorCode <> 0 then
        RaiseParseException(AErrorCode, ps, p);
    except
      on E: Exception do
      begin
        if E is EJsonError then
          raise
        else
        begin
          raise FormatParseErrorEx(EParse_Unknown, E.Message, ps, p);

          { raise Exception.Create(Self.FormatParseError(EParse_Unknown,
            E.Message, ps, p)); }
        end;
      end;
    end;
  finally
    FreeObject(ABuilder);
    DoParsed;
  end;
end;

procedure TQJson.ParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW);
var
  ps: PQCharW;
begin
  ps := p;
  RaiseParseException(TryParseValue(ABuilder, p), ps, p);
end;

procedure TQJson.RaiseParseException(ACode: Integer; ps, p: PQCharW);
begin
  if ACode <> 0 then
  begin
    case ACode of
      EParse_BadStringStart:
        { raise EJsonError.Create(FormatParseError(ACode,
          SBadStringStart, ps, p)); }
        raise FormatParseErrorEx(ACode, SBadStringStart, ps, p);
      EParse_BadJson:
        // raise EJsonError.Create(FormatParseError(ACode, SBadJson, ps, p));
        raise FormatParseErrorEx(ACode, SBadJson, ps, p);
      EParse_CommentNotSupport:
        { raise EJsonError.Create(FormatParseError(ACode,
          SCommentNotSupport, ps, p)); }
        raise FormatParseErrorEx(ACode, SCommentNotSupport, ps, p);
      EParse_UnknownToken:
        { raise EJsonError.Create(FormatParseError(ACode,
          SCommentNotSupport, ps, p)); }
        raise FormatParseErrorEx(ACode, SCommentNotSupport, ps, p);
      EParse_EndCharNeeded:
        // raise EJsonError.Create(FormatParseError(ACode, SEndCharNeeded, ps, p));
        raise FormatParseErrorEx(ACode, SEndCharNeeded, ps, p);
      EParse_BadNameStart:
        // raise EJsonError.Create(FormatParseError(ACode, SBadNameStart, ps, p));
        raise FormatParseErrorEx(ACode, SBadNameStart, ps, p);
      EParse_BadNameEnd:
        // raise EJsonError.Create(FormatParseError(ACode, SBadNameEnd, ps, p));
        raise FormatParseErrorEx(ACode, SBadNameEnd, ps, p);
      EParse_NameNotFound:
        // raise EJsonError.Create(FormatParseError(ACode, SNameNotFound, ps, p))
        raise FormatParseErrorEx(ACode, SNameNotFound, ps, p);
    else
      raise FormatParseErrorEx(ACode, SUnknownError, ps, p);
      // raise EJsonError.Create(FormatParseError(ACode, SUnknownError, ps, p));
    end;
  end;
end;

function TQJson.Remove(AItemIndex: Integer): TQJson;
begin
  if FDataType in [jdtArray, jdtObject] then
  begin
    if (AItemIndex >= 0) and (AItemIndex < Count) then
    begin
      Result := Items[AItemIndex];
      FItems.Delete(AItemIndex);
      Result.FParent := nil;
    end
    else
      Result := nil;
  end
  else
    Result := nil;
end;

procedure TQJson.Remove(AJson: TQJson);
begin
  Remove(AJson.ItemIndex);
end;

procedure TQJson.Replace(AIndex: Integer; ANewItem: TQJson);
begin
  FreeObject(Items[AIndex]);
  if Assigned(ANewItem.FParent) then
    ANewItem.FParent.Remove(ANewItem.ItemIndex);
  ANewItem.FParent := Self;
  FItems[AIndex] := ANewItem;
end;

procedure TQJson.Reset(ADetach: Boolean);
begin
  if ADetach and Assigned(FParent) then
  begin
    FParent.Remove(Self);
    FParent := nil;
  end;
  SetLength(FName, 0);
  FNameHash := 0;
  DataType := jdtUnknown;
  SetLength(FValue, 0);
  SetLength(FComment, 0);
  FCommentStyle := jcsIgnore;
  FData := nil;
  FIgnoreCase := not JsonCaseSensitive;
end;

procedure TQJson.ResetNull;
begin
  DataType := jdtNull;
end;

procedure TQJson.RevertOrder(ANest: Boolean);
var
  I, H, M: Integer;
begin
  H := Count - 1;
  if H > 0 then
  begin
    M := H shr 1;
    for I := 0 to M do
      FItems.Exchange(I, H - I);
    if ANest then
    begin
      for I := 0 to H do
        Items[I].RevertOrder(ANest);
    end;
  end;
end;

procedure TQJson.SaveToFile(const AFileName: String; AEncoding: TTextEncoding; AWriteBom, ADoFormat: Boolean);
begin
  if ADoFormat then
    SaveToFile(AFileName, [jesDoFormat], AEncoding, AWriteBom)
  else
    SaveToFile(AFileName, [], AEncoding, AWriteBom);
end;

procedure TQJson.SaveToFile(const AFileName: String; ASettings: TJsonEncodeSettings; AEncoding: TTextEncoding;
  AWriteBom: Boolean);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    SaveToStream(AStream, ASettings, AEncoding, AWriteBom);
    AStream.SaveToFile(AFileName);
  finally
    FreeObject(AStream);
  end;
end;

procedure TQJson.SaveToStream(AStream: TStream; ASettings: TJsonEncodeSettings; AEncoding: TTextEncoding;
  AWriteBom: Boolean);
var
  S: QStringW;
begin
  if DataType in [jdtArray, jdtObject] then
    S := Encode(ASettings)
  else
  begin
    if DataType in [jdtUnknown, jdtNull] then
    begin
      if Length(FName) = 0 then
        S := ''
      else
        S := '{"' + Escape(FName) + '":' + Value + '}';
    end
    else
    begin
      if Length(FName) > 0 then
        S := '{"' + Escape(FName) + '":' + Encode(True) + '}'
      else
        raise Exception.Create(SNameNotFound);
    end;
  end;
  if AEncoding = teUtf8 then
    SaveTextU(AStream, qstring.Utf8Encode(S), AWriteBom)
  else if AEncoding = teAnsi then
    SaveTextA(AStream, qstring.AnsiEncode(S))
  else if AEncoding = teUnicode16LE then
    SaveTextW(AStream, S, AWriteBom)
  else
    SaveTextWBE(AStream, S, AWriteBom);

end;

procedure TQJson.SaveToStream(AStream: TStream; AEncoding: TTextEncoding; AWriteBom, ADoFormat: Boolean);
begin
  if ADoFormat then
    SaveToStream(AStream, [jesDoFormat], AEncoding, AWriteBom)
  else
    SaveToStream(AStream, [], AEncoding, AWriteBom);;
end;

procedure TQJson.SetA(const APath: String; const Value: TQJson);
begin
  ForcePath(APath).Assign(Value);
end;

procedure TQJson.SetAsArray(const Value: QStringW);
var
  p: PQCharW;
begin
  DataType := jdtArray;
  Clear;
  p := PQCharW(Value);
  ParseObject(p);
end;

procedure TQJson.SetAsBase64Bytes(const Value: TBytes);
begin
  InternalSetAsBytes(DoEncodeAsBase64, Value);
end;

procedure TQJson.SetAsBcd(const Value: TBcd);
begin
  DataType := jdtBcd;
  PBcd(FValue)^ := Value;
end;

procedure TQJson.SetAsBoolean(const Value: Boolean);
begin
  DataType := jdtBoolean;
  PBoolean(FValue)^ := Value;
end;

procedure TQJson.SetAsBytes(const Value: TBytes);
begin
  if Assigned(OnQJsonEncodeBytes) then
    InternalSetAsBytes(OnQJsonEncodeBytes, Value)
  else
    InternalSetAsBytes(DoEncodeAsHex, Value);
end;

procedure TQJson.SetAsDateTime(const Value: TDateTime);
begin
  DataType := jdtDateTime;
  PExtended(FValue)^ := Value;
end;

procedure TQJson.SetAsFloat(const Value: Extended);
begin
  // if IsNan(Value) or IsInfinite(Value) then
  // raise Exception.Create(SSupportFloat);
  DataType := jdtFloat;
  PExtended(FValue)^ := Value;
end;

procedure TQJson.SetAsHexBytes(const Value: TBytes);
begin
  InternalSetAsBytes(DoEncodeAsHex, Value);
end;

procedure TQJson.SetAsInt64(const Value: Int64);
begin
  DataType := jdtInteger;
  PInt64(FValue)^ := Value;
end;

procedure TQJson.SetAsInteger(const Value: Integer);
begin
  SetAsInt64(Value);
end;

procedure TQJson.SetAsJson(const Value: QStringW);
var
  ABuilder: TQStringCatHelperW;
  p: PQCharW;
begin
  ABuilder := TQStringCatHelperW.Create;
  try
    try
      if DataType in [jdtArray, jdtObject] then
        Clear;
      p := PQCharW(Value);
      ParseValue(ABuilder, p);
    except
      AsString := Value;
    end;
  finally
    FreeObject(ABuilder);
  end;
end;

procedure TQJson.SetAsObject(const Value: QStringW);
begin
  Parse(PQCharW(Value), Length(Value));
end;

procedure TQJson.SetAsString(const Value: QStringW);
begin
  DataType := jdtString;
  FValue := Value;
end;

procedure TQJson.SetAsVariant(const Value: Variant);
var
  I: Integer;
  AType: TVarType;
  procedure CastFromCustomVarType;
  var
    ATypeInfo: TCustomVariantType;
    AData: TVarData;
  begin
    if FindCustomVariantType(AType, ATypeInfo) then
    begin
      VariantInit(AData);
      // �ȳ���ת����˫������ֵ��������У��͵��ַ�������
      try
        try
          ATypeInfo.CastTo(AData, FindVarData(Value)^, varDouble);
          AsFloat := AData.VDouble;
        except
          AsString := Value;
        end;
      finally
        VariantClear(AData);
      end;
    end
    else
      raise Exception.CreateFmt(SUnsupportVarType, [AType]);
  end;

begin
  if VarIsArray(Value) then
  begin
    ArrayNeeded(jdtArray);
    Clear;
    for I := VarArrayLowBound(Value, VarArrayDimCount(Value)) to VarArrayHighBound(Value, VarArrayDimCount(Value)) do
      Add.AsVariant := Value[I];
  end
  else
  begin
    AType := VarType(Value);
    case AType of
      varEmpty, varNull, varUnknown:
        ResetNull;
      varSmallInt, varInteger, varByte, varShortInt, varWord, varLongWord, varInt64:
        AsInt64 := Value;
      varSingle, varDouble, varCurrency:
        AsFloat := Value;
      varDate:
        AsDateTime := Value;
      varOleStr, varString{$IFDEF UNICODE}, varUString{$ENDIF}:
        AsString := Value;
{$IF RtlVersion>=26}
      varUInt64:
        AsInt64 := Value;
      varRecord:
        FromRtti(PVarRecord(@Value).RecInfo, PVarRecord(@Value).PRecord);
{$IFEND >=XE5}
      varBoolean:
        AsBoolean := Value
    else
      CastFromCustomVarType;
    end;
  end;
end;

procedure TQJson.SetB(const APath: String; const Value: Boolean);
begin
  ForcePath(APath).AsBoolean := Value;
end;

procedure TQJson.SetDataType(const Value: TQJsonDataType);
begin
  if FDataType <> Value then
  begin
    if DataType in [jdtArray, jdtObject] then
    begin
      Clear;
      if not(Value in [jdtArray, jdtObject]) then
      begin
        FreeObject(FItems);
      end;
    end;
    case Value of
      jdtNull, jdtUnknown, jdtString:
        SetLength(FValue, 0);
      jdtInteger:
        begin
          SetLength(FValue, SizeOf(Int64) shr 1);
          PInt64(FValue)^ := 0;
        end;
      jdtFloat, jdtDateTime:
        begin
          SetLength(FValue, SizeOf(Extended) shr 1);
          PExtended(FValue)^ := 0;
        end;
      jdtBcd:
        begin
          SetLength(FValue, SizeOf(TBcd) shr 1);
          PBcd(FValue)^ := IntegerToBcd(0);
        end;
      jdtBoolean:
        begin
          SetLength(FValue, 1);
          PBoolean(FValue)^ := False;
        end;
      jdtArray, jdtObject:
        if not(FDataType in [jdtArray, jdtObject]) then
          ArrayNeeded(Value);
    end;
    FDataType := Value;
  end;
end;

procedure TQJson.SetF(const APath: String; const Value: Double);
begin
  ForcePath(APath).AsFloat := Value;
end;

procedure TQJson.SetI(const APath: String; const Value: Int64);
begin
  ForcePath(APath).AsInt64 := Value;
end;

procedure TQJson.SetIgnoreCase(const Value: Boolean);
  procedure InternalSetIgnoreCase(AParent: TQJson);
  var
    I: Integer;
  begin
    AParent.FIgnoreCase := Value;
    if AParent.FNameHash <> 0 then
      AParent.FNameHash := AParent.HashName(AParent.FName);
    if AParent.DataType in [jdtArray, jdtObject] then
    begin
      for I := 0 to AParent.Count - 1 do
        InternalSetIgnoreCase(AParent[I]);
    end;
  end;

begin
  if FIgnoreCase <> Value then
  begin
    InternalSetIgnoreCase(Root);
  end;
end;

procedure TQJson.SetName(const Value: QStringW);
begin
  if FName <> Value then
  begin
    if Assigned(FParent) then
    begin
      if FParent.IndexOf(Value) <> -1 then
        raise Exception.CreateFmt(SNodeNameExists, [Value]);
    end;
    FName := Value;
    FNameHash := 0;
    DoJsonNameChanged(Self);
  end;
end;

procedure TQJson.SetO(const APath: String; const Value: TQJson);
begin
  ForcePath(APath).Assign(Value);
end;

procedure TQJson.SetS(const APath, Value: String);
begin
  ForcePath(APath).AsString := Value;
end;

procedure TQJson.SetT(const APath: String; const Value: TDateTime);
begin
  ForcePath(APath).AsDateTime := Value;
end;

procedure TQJson.SetV(const APath: String; const Value: Variant);
begin
  ForcePath(APath).AsVariant := Value;
end;

procedure TQJson.SetValue(const Value: QStringW);
var
  p: PQCharW;
  procedure ParseNum;
  var
    ANum: Extended;
  begin
    if ParseNumeric(p, ANum) then
    begin
      if SameValue(ANum, Trunc(ANum), 5E-324) then
        AsInt64 := Trunc(ANum)
      else
        AsFloat := ANum;
    end
    else
      raise Exception.Create(Format(SBadNumeric, [Value]));
  end;
  procedure SetDateTime;
  var
    ATime: TDateTime;
  begin
    if ParseDateTime(PQCharW(Value), ATime) then
      AsDateTime := ATime
    else if ParseJsonTime(PQCharW(Value), ATime) then
      AsDateTime := ATime
    else
      raise Exception.Create(SBadJsonTime);
  end;
  procedure DetectValue;
  var
    ABuilder: TQStringCatHelperW;
    p: PQCharW;
  begin
    ABuilder := TQStringCatHelperW.Create;
    try
      p := PQCharW(Value);
      if TryParseValue(ABuilder, p) <> 0 then
        AsString := Value;
    finally
      FreeObject(ABuilder);
    end;
  end;

begin
  if DataType = jdtString then
    FValue := Value
  else if DataType = jdtBoolean then
    AsBoolean := StrToBool(Value)
  else
  begin
    p := PQCharW(Value);
    if DataType in [jdtInteger, jdtFloat] then
      ParseNum
    else if DataType = jdtDateTime then
      SetDateTime
    else if DataType in [jdtArray, jdtObject] then
    begin
      Clear;
      ParseObject(p);
    end
    else // jdtUnknown
      DetectValue;
  end;
end;

procedure TQJson.SkipBom(var p: PQCharW);
begin
  if p^ = #$FEFF then // ��BOM
    Inc(p)
  else if p^ = #$FFFE then // UTF16BE
  begin
    Inc(p);
    ExchangeByteOrder(PQCharA(p), StrLen(p));
  end;
  // UTF8/�������벻����⣬���ϲ�����֤
end;

class function TQJson.SkipSpaceAndComment(var p: PQCharW; var AComment: QStringW; lastvalidchar: QCharW = #0): Integer;
var
  ps: PQCharW;
begin
  SkipSpaceW(p);
  Result := 0;
  SetLength(AComment, 0);
  if not StrictJson then
  begin
    while p^ = '/' do
    begin
      if StrictJson then
      begin
        Result := EParse_CommentNotSupport;
        Exit;
      end;
      if p[1] = '/' then
      begin
        Inc(p, 2);
        AComment := DecodeLineW(p) + SLineBreak;
        SkipSpaceW(p);
      end
      else if p[1] = '*' then
      begin
        Inc(p, 2);
        ps := p;
        while p^ <> #0 do
        begin
          if (p[0] = '*') and (p[1] = '/') then
          begin
            AComment := AComment + StrDupX(ps, (IntPtr(p) - IntPtr(ps)) shr 1) + SLineBreak;
            Inc(p, 2);
            SkipSpaceW(p);
            Break;
          end
          else
            Inc(p);
        end;
      end
      else
      begin
        Result := EParse_UnknownToken;
        Exit;
      end;
    end;
  end
  else if ((p^ = CharObjectEnd) or (p^ = CharArrayEnd)) and (lastvalidchar = CharComma) then
  begin
    Result := EParse_EndCharNeeded;
    Exit;
  end;
  if Length(AComment) > 0 then
    SetLength(AComment, Length(AComment) - Length(SLineBreak));
end;

procedure TQJson.Sort(AByName, ANest: Boolean; AByType: TQJsonDataType; AOnCompare: TListSortCompareEvent);
  function DoCompare(Item1, Item2: Pointer): Integer;
  var
    AMethod: TMethod absolute AOnCompare;
  begin
    if AMethod.Data = nil then
      Result := TListSortCompare(AMethod.Code)(Item1, Item2)
{$IFDEF UNICODE}
    else if AMethod.Data = Pointer(-1) then
      Result := TListSortCompareFunc(AMethod.Code)(Item1, Item2)
{$ENDIF}
    else
      Result := AOnCompare(Item1, Item2);
  end;
  procedure QuickSort(l, R: Integer);
  var
    I, J, p: Integer;
  begin
    repeat
      I := l;
      J := R;
      p := (l + R) shr 1;
      repeat
        while DoCompare(Items[I], Items[p]) < 0 do
          Inc(I);
        while DoCompare(Items[J], Items[p]) > 0 do
          Dec(J);
        if I <= J then
        begin
          if I <> J then
            FItems.Exchange(I, J);
          if p = I then
            p := J
          else if p = J then
            p := I;
          Inc(I);
          Dec(J);
        end;
      until I > J;
      if l < J then
        QuickSort(l, J);
      l := I;
    until I >= R;
  end;
  function DetectCompareType: TQJsonDataType;
  var
    I, c: Integer;
  begin
    c := Count;
    if c > 0 then
    begin
      Result := Items[0].DataType;
      Dec(c);
      for I := 1 to c do
      begin
        case Items[I].DataType of
          jdtNull:
            ;
          jdtString:
            begin
              Result := jdtString;
              Break;
            end;
          jdtInteger:
            begin
              if Result in [jdtNull, jdtBoolean] then
                Result := jdtInteger;
            end;
          jdtFloat:
            begin
              if Result in [jdtNull, jdtBoolean, jdtInteger, jdtDateTime] then
                Result := jdtFloat;
            end;
          jdtBoolean:
            begin
              if Result = jdtNull then
                Result := jdtBoolean;
            end;
          jdtDateTime:
            begin
              if Result in [jdtNull, jdtBoolean, jdtInteger] then
                Result := jdtDateTime;
            end;
        end;
      end;
    end
    else
      Result := jdtUnknown;
  end;
  procedure DoSort(ADataType: TQJsonDataType);
  begin
    case ADataType of
      jdtString:
        AOnCompare := DoCompareValueString;
      jdtInteger:
        AOnCompare := DoCompareValueInt;
      jdtFloat:
        AOnCompare := DoCompareValueFloat;
      jdtBoolean:
        AOnCompare := DoCompareValueBoolean;
      jdtDateTime:
        AOnCompare := DoCompareValueDateTime
    else
      Exit;
    end;
    QuickSort(0, Count - 1);
  end;
  procedure SortChildrens;
  var
    I, H: Integer;
    AItem: TQJson;
  begin
    H := Count - 1;
    for I := 0 to H do
    begin
      AItem := Items[I];
      if AItem.IsObject then
        AItem.Sort(AByName, ANest, AByType, AOnCompare)
      else if (AItem.IsArray) and (not AByName) then
        AItem.Sort(AByName, ANest, AByType, AOnCompare);
    end;
  end;

begin
  if Count > 0 then
  begin
    if not Assigned(AOnCompare) then
    begin
      if AByName then
      begin
        AOnCompare := DoCompareName;
        QuickSort(0, Count - 1);
      end
      else if AByType = jdtUnknown then
        DoSort(DetectCompareType)
      else
        DoSort(AByType);
    end
    else
      QuickSort(0, Count - 1);
    if ANest then
      SortChildrens;
  end;
end;

procedure TQJson.Sort(AByName, ANest: Boolean; AByType: TQJsonDataType; AOnCompare: TListSortCompare);
var
  AEvent: TListSortCompareEvent;
  AMethod: TMethod absolute AEvent;
begin
  AEvent := nil;
  TListSortCompare(AMethod.Code) := AOnCompare;
  Sort(AByName, ANest, AByType, AEvent);
end;
{$IF RTLVersion>=21)}

procedure TQJson.Sort(AByName, ANest: Boolean; AByType: TQJsonDataType; AOnCompare: TListSortCompareFunc);
var
  AEvent: TListSortCompareEvent;
  AMethod: TMethod absolute AEvent;
begin
  AEvent := nil;
  AMethod.Data := Pointer(-1);
  TListSortCompareFunc(AMethod.Code) := AOnCompare;
  Sort(AByName, ANest, AByType, AEvent);
end;
{$IFEND}

procedure TQJson.StreamFromValue(AStream: TStream);
var
  ABytes: TBytes;
begin
  ABytes := AsBytes;
  AStream.WriteBuffer(ABytes[0], Length(ABytes));
end;

{$IF RTLVersion>=21}

function TQJson.Invoke(AInstance: TValue): TValue;
var
  AMethods: TArray<TRttiMethod>;
  AParams: TArray<TRttiParameter>;
  AMethod: TRttiMethod;
  AType: TRttiType;
  AContext: TRttiContext;
  AParamValues: array of TValue;
  I, c: Integer;
  AParamItem, AItemType, AItemValue: TQJson;
  function CharOfValue: Byte;
  var
    S: QStringA;
  begin
    S := AItemValue.AsString;
    if S.Length > 0 then
      Result := S.Chars[0]
    else
      Result := 0;
  end;
  function WCharOfValue: WideChar;
  var
    S: QStringW;
  begin
    S := AItemValue.AsString;
    if Length(S) > 0 then
      Result := PQCharW(S)[0]
    else
      Result := #0;
  end;

begin
  AContext := TRttiContext.Create;
  Result := TValue.Empty;
  if AInstance.IsObject then
    AType := AContext.GetType(AInstance.AsObject.ClassInfo)
  else if AInstance.IsClass then
    AType := AContext.GetType(AInstance.AsClass)
  else if AInstance.Kind in [tkRecord{$IFDEF MANAGED_RECORD}, tkMRecord{$ENDIF}] then
    AType := AContext.GetType(AInstance.TypeInfo)
  else
    AType := AContext.GetType(AInstance.TypeInfo);
  AMethods := AType.GetMethods(Name);
  c := Count;
  for AMethod in AMethods do
  begin
    AParams := AMethod.GetParameters;
    if Length(AParams) = c then
    begin
      SetLength(AParamValues, c);
      for I := 0 to c - 1 do
      begin
        AParamItem := ItemByName(AParams[I].Name);
        if AParamItem <> nil then
        begin
          if AParamItem.IsObject then // ����������������Ϣ
          begin
            if AParamItem.HasChild('Type', AItemType) and AParamItem.HasChild('Value', AItemValue) then
            begin
              case TTypeKind(AItemType.AsInteger) of
                tkInteger:
                  AParamValues[I] := AItemValue.AsInteger;
                tkChar:
                  AParamValues[I] :=
{$IFNDEF NEXTGEN}TValue.From(AnsiChar(CharOfValue)){$ELSE}CharOfValue{$ENDIF};
                tkEnumeration:
                  AParamValues[I] := AItemValue.AsInteger;
                tkFloat:
                  AParamValues[I] := AItemValue.AsFloat;
                tkString:
                  AParamValues[I] := AItemValue.AsString;
                tkWChar:
                  AParamValues[I] := WCharOfValue;
{$IFNDEF NEXTGEN}
                tkLString:
                  AParamValues[I] := TValue.From(AnsiString(AItemValue.AsString));
{$ENDIF}
                tkWString:
                  AParamValues[I] := WideString(AItemValue.AsString);
{$IFDEF UNICODE}
                tkUString:
                  AParamValues[I] := AItemValue.AsString;
{$ENDIF}
                tkPointer:
                  AParamValues[I] := Pointer(AItemValue.AsInt64);
                tkClassRef:
                  AParamValues[I] := TClass(AItemValue.AsInt64);
                tkClass:
                  AParamValues[I] := TObject(AItemValue.AsInt64)
              else
                raise Exception.CreateFmt(SParamMissed, [AParams[I].Name]);
              end;
            end
            else if AParamItem.HasChild('Value', AItemValue) then
              AParamValues[I] := AItemValue.ToRttiValue
            else
              raise Exception.CreateFmt(SParamMissed, [AParams[I].Name]);
          end
          else
            AParamValues[I] := AParamItem.ToRttiValue
        end
        else
          raise Exception.CreateFmt(SParamMissed, [AParams[I].Name]);
      end;
      Result := AMethod.Invoke(AInstance, AParamValues);
      Exit;
    end;
  end;
  raise Exception.CreateFmt(SMethodMissed, [Name]);
end;

procedure TQJson.ToRecord<T>(var ARecord: T; AClearCollections: Boolean);
begin
  ToRtti(@ARecord, TypeInfo(T), AClearCollections);
end;

procedure TQJson.ToRtti(AInstance: TValue; AClearCollections: Boolean);
begin
  if AInstance.IsEmpty then
    Exit;
  if AInstance.Kind in [tkRecord{$IFDEF MANAGED_RECORD}, tkMRecord
{$ENDIF} ] then
    ToRtti(AInstance.GetReferenceToRawData, AInstance.TypeInfo, AClearCollections)
  else if AInstance.Kind = tkClass then
    ToRtti(AInstance.AsObject, AInstance.TypeInfo, AClearCollections)
end;

procedure TQJson.ToRtti(ADest: Pointer; AType: PTypeInfo; AClearCollections: Boolean);

  procedure LoadCollection(AJson: TQJson; ACollection: TCollection);
  var
    I: Integer;
  begin
    if AClearCollections then
      ACollection.Clear;
    for I := 0 to AJson.Count - 1 do
      AJson[I].ToRtti(ACollection.Add);
  end;
  procedure ToRecord;
  var
    AContext: TRttiContext;
    AFields: TArray<TRttiField>;
    ARttiType: TRttiType;
    ABaseAddr: Pointer;
    J: Integer;
    AChild: TQJson;
    AObj: TObject;
  begin
    AContext := TRttiContext.Create;
    ARttiType := AContext.GetType(AType);
    ABaseAddr := ADest;
    AFields := ARttiType.GetFields;
    for J := Low(AFields) to High(AFields) do
    begin
      if (AFields[J].FieldType <> nil) then
      begin
        AChild := ItemByName(AFields[J].Name);
        if AChild <> nil then
        begin
          case AFields[J].FieldType.TypeKind of
            tkInteger:
              AFields[J].SetValue(ABaseAddr, AChild.AsInteger);
{$IFNDEF NEXTGEN}
            tkString:
              PShortString(IntPtr(ABaseAddr) + AFields[J].Offset)^ := ShortString(AChild.AsString);
{$ENDIF !NEXTGEN}
            tkUString{$IFNDEF NEXTGEN}, tkLString, tkWString{$ENDIF !NEXTGEN}:
              AFields[J].SetValue(ABaseAddr, AChild.AsString);
            tkEnumeration:
              begin
                if GetTypeData(AFields[J].FieldType.Handle)^.BaseType^ = TypeInfo(Boolean) then
                  AFields[J].SetValue(ABaseAddr, AChild.AsBoolean)
                else
                begin
                  case GetTypeData(AFields[J].FieldType.Handle).OrdType of
                    otSByte:
                      begin
                        if AChild.DataType = jdtInteger then
                          PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                        else
                          PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                            GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                      end;
                    otUByte:
                      begin
                        if AChild.DataType = jdtInteger then
                          PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                        else
                          PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                            GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                      end;
                    otSWord:
                      begin
                        if AChild.DataType = jdtInteger then
                          PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                        else
                          PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                            GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                      end;
                    otUWord:
                      begin
                        if AChild.DataType = jdtInteger then
                          PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                        else
                          PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                            GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                      end;
                    otSLong:
                      begin
                        if AChild.DataType = jdtInteger then
                          PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                        else
                          PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                            GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                      end;
                    otULong:
                      begin
                        if AChild.DataType = jdtInteger then
                          PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                        else
                          PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                            GetEnumValue(AFields[J].FieldType.Handle, AChild.AsString);
                      end;
                  end;
                end;
              end;
            tkSet:
              begin
                case GetTypeData(AFields[J].FieldType.Handle).OrdType of
                  otSByte:
                    begin
                      if AChild.DataType = jdtInteger then
                        PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                      else
                        PShortint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                          StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                    end;
                  otUByte:
                    begin
                      if AChild.DataType = jdtInteger then
                        PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                      else
                        PByte(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                          StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                    end;
                  otSWord:
                    begin
                      if AChild.DataType = jdtInteger then
                        PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                      else
                        PSmallint(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                          StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                    end;
                  otUWord:
                    begin
                      if AChild.DataType = jdtInteger then
                        PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                      else
                        PWord(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                          StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                    end;
                  otSLong:
                    begin
                      if AChild.DataType = jdtInteger then
                        PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                      else
                        PInteger(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                          StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                    end;
                  otULong:
                    begin
                      if AChild.DataType = jdtInteger then
                        PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsInteger
                      else
                        PCardinal(IntPtr(ABaseAddr) + AFields[J].Offset)^ :=
                          StringToSet(AFields[J].FieldType.Handle, AChild.AsString);
                    end;
                end;
              end;
            tkChar, tkWChar:
              AFields[J].SetValue(ABaseAddr, AChild.AsString);
            tkFloat:
              if (AFields[J].FieldType.Handle = TypeInfo(TDateTime)) or (AFields[J].FieldType.Handle = TypeInfo(TTime))
                or (AFields[J].FieldType.Handle = TypeInfo(TDate)) then
              begin
                if AChild.IsDateTime then
                  AFields[J].SetValue(ABaseAddr, AChild.AsDateTime)
                else if AChild.DataType in [jdtNull, jdtUnknown] then
                  AFields[J].SetValue(ABaseAddr, 0)
                else
                begin
                  if AChild.DataType = jdtInteger then // ������Unix ʱ�����
                  begin
                    case JsonIntToTimeStyle of
                      tsDeny:
                        raise Exception.CreateFmt(SBadConvert, [AChild.AsString, JsonTypeName[jdtDateTime]]);
                      tsSecondsFrom1970: // Unix
                        begin
                          if (JsonTimezone >= -12) and (JsonTimezone <= 12) then
                            AFields[J].SetValue(ABaseAddr, IncHour(UnixToDateTime(AChild.AsInt64), JsonTimezone))
                          else
                            AFields[J].SetValue(ABaseAddr, UnixToDateTime(AChild.AsInt64));
                        end;
                      tsSecondsFrom1899:
                        begin
                          if (JsonTimezone >= -12) and (JsonTimezone <= 12) then
                            AFields[J].SetValue(ABaseAddr, IncHour(AChild.AsInt64 / 86400, JsonTimezone))
                          else
                            AFields[J].SetValue(ABaseAddr, AChild.AsInt64 / 86400);
                        end;
                      tsMsFrom1970:
                        begin
                          if (JsonTimezone >= -12) and (JsonTimezone <= 12) then
                            AFields[J].SetValue(ABaseAddr, IncHour(IncMilliSecond(UnixDateDelta, AChild.AsInt64),
                              JsonTimezone))
                          else
                            AFields[J].SetValue(ABaseAddr, IncMilliSecond(UnixDateDelta, AChild.AsInt64));
                        end;
                      tsMsFrom1899:
                        if (JsonTimezone >= -12) and (JsonTimezone <= 12) then
                          AFields[J].SetValue(ABaseAddr, IncHour(AChild.AsInt64 / 86400000, JsonTimezone))
                        else
                          AFields[J].SetValue(ABaseAddr, AChild.AsInt64 / 86400000);
                    end;
                  end
                  else
                    raise Exception.CreateFmt(SBadConvert, [AChild.AsString, JsonTypeName[AChild.DataType]]);
                end;
              end
              else
                AFields[J].SetValue(ABaseAddr, AChild.AsFloat);
            tkInt64:
              AFields[J].SetValue(ABaseAddr, AChild.AsInt64);
            tkVariant:
              PVariant(IntPtr(ABaseAddr) + AFields[J].Offset)^ := AChild.AsVariant;
            tkArray, tkDynArray:
              AChild.ToRtti(Pointer(IntPtr(ABaseAddr) + AFields[J].Offset), AFields[J].FieldType.Handle);
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
            tkRecord {$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} :
              if AFields[J].FieldType.Handle = TypeInfo(TGuid) then
                PGuid(IntPtr(ABaseAddr) + AFields[J].Offset)^ := StringToGuid(AChild.AsString)
              else
                AChild.ToRtti(Pointer(IntPtr(ABaseAddr) + AFields[J].Offset), AFields[J].FieldType.Handle);
          end;
        end;
      end;
    end;
  end;

  procedure ToObject;
  var
    AProp: PPropInfo;
    ACount: Integer;
    J, V: Integer;
    AObj, AChildObj: TObject;
    AChild: TQJson;
    AIdentToInt: TIdentToInt;
  begin
    AObj := ADest;
    ACount := Count;
    if AObj is TStrings then
      (AObj as TStrings).Text := AsString
    else if AObj is TCollection then
      LoadCollection(Self, AObj as TCollection)
    else
    begin
      for J := 0 to ACount - 1 do
      begin
        AChild := Items[J];
        AProp := GetPropInfo(AObj, AChild.Name);
        if (AProp <> nil) and Assigned(AProp.SetProc) then
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
            tkRecord, tkArray, tkDynArray
{$IFDEF MANAGED_RECORD}, tkMRecord{$ENDIF} :
              begin
                AChild.ToRtti(Pointer(GetOrdProp(AObj, AProp)), AProp.PropType^);
              end;
            tkInteger:
              begin
                if AChild.DataType = jdtString then
                begin
                  AIdentToInt := FindIdentToInt(AProp.PropType^);
                  if Assigned(AIdentToInt) then
                  begin
                    if AIdentToInt(AChild.AsString, V) then
                      SetOrdProp(AObj, AProp, V);
                  end;
                end
                else
                  SetOrdProp(AObj, AProp, AChild.AsInteger);
              end;
            tkFloat:
              begin
                if (AProp.PropType^ = TypeInfo(TDateTime)) or (AProp.PropType^ = TypeInfo(TTime)) or
                  (AProp.PropType^ = TypeInfo(TDate)) then
                  SetFloatProp(AObj, AProp, AChild.AsDateTime)
                else
                  SetFloatProp(AObj, AProp, AChild.AsFloat);
              end;
            tkChar, tkString, tkWChar, tkLString, tkWString, tkUString:
              SetStrProp(AObj, AProp, AChild.AsString);
            tkEnumeration:
              begin
                if GetTypeData(AProp.PropType^)^.BaseType^ = TypeInfo(Boolean) then
                  SetOrdProp(AObj, AProp, Integer(AChild.AsBoolean))
                else if AChild.DataType = jdtInteger then
                  SetOrdProp(AObj, AProp, AChild.AsInteger)
                else
                  SetEnumProp(AObj, AProp, AChild.AsString);
              end;
            tkSet:
              begin
                if AChild.DataType = jdtInteger then
                  SetOrdProp(AObj, AProp, AChild.AsInteger)
                else
                  SetSetProp(AObj, AProp, AChild.AsString);
              end;
            tkVariant:
              SetVariantProp(AObj, AProp, AChild.AsVariant);
            tkInt64:
              SetInt64Prop(AObj, AProp, AChild.AsInt64);
          end;
        end;
      end;
    end;
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
    S: QStringW;
    pd, pi: PByte;
    AChildObj: TObject;
    ASubTypeInfo: PTypeInfo;
    AChild: TQJson;
  begin
    AContext := TRttiContext.Create;
{$IF RTLVersion>25}
    S := ArrayItemTypeName(AType.NameFld.ToString);
{$ELSE}
    S := ArrayItemTypeName(String(AType.Name));
{$IFEND}
    if Length(S) > 0 then
      ASubType := AContext.FindType(S)
    else
      ASubType := nil;
    if ASubType <> nil then
    begin
      ASubTypeInfo := ASubType.Handle;
      l := Count;
      SetDynArrayLen(ADest, AType, l);
      pd := PPointer(ADest)^;
      for I := 0 to l - 1 do
      begin
        AOffset := I * GetTypeData(AType).elSize;
        pi := Pointer(IntPtr(pd) + AOffset);
        AChild := Items[I];
        case ASubType.TypeKind of
          tkInteger:
            begin
              case GetTypeData(ASubTypeInfo).OrdType of
                otSByte:
                  PShortint(pi)^ := AChild.AsInteger;
                otUByte:
                  pi^ := Items[I].AsInteger;
                otSWord:
                  PSmallint(pi)^ := AChild.AsInteger;
                otUWord:
                  PWord(pi)^ := AChild.AsInteger;
                otSLong:
                  PInteger(pi)^ := AChild.AsInteger;
                otULong:
                  PCardinal(pi)^ := AChild.AsInteger;
              end;
            end;
{$IFNDEF NEXTGEN}
          tkChar:
            pi^ := Ord(PAnsiChar(AnsiString(AChild.AsString))[0]);
{$ENDIF !NEXTGEN}
          tkEnumeration:
            begin
              if GetTypeData(ASubTypeInfo)^.BaseType^ = TypeInfo(Boolean) then
                PBoolean(pi)^ := AChild.AsBoolean
              else
              begin
                case GetTypeData(ASubTypeInfo)^.OrdType of
                  otSByte:
                    begin
                      if AChild.DataType = jdtInteger then
                        PShortint(pi)^ := AChild.AsInteger
                      else
                        PShortint(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                    end;
                  otUByte:
                    begin
                      if AChild.DataType = jdtInteger then
                        pi^ := AChild.AsInteger
                      else
                        pi^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                    end;
                  otSWord:
                    begin
                      if AChild.DataType = jdtInteger then
                        PSmallint(pi)^ := AChild.AsInteger
                      else
                        PSmallint(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                    end;
                  otUWord:
                    begin
                      if AChild.DataType = jdtInteger then
                        PWord(pi)^ := AChild.AsInteger
                      else
                        PWord(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                    end;
                  otSLong:
                    begin
                      if AChild.DataType = jdtInteger then
                        PInteger(pi)^ := AChild.AsInteger
                      else
                        PInteger(pi)^ := GetEnumValue(ASubTypeInfo, AChild.AsString);
                    end;
                  otULong:
                    begin
                      if AChild.DataType = jdtInteger then
                        PCardinal(pi)^ := AChild.AsInteger
                      else
                        PCardinal(pi)^ := GetEnumValue(ASubTypeInfo, Items[I].AsString);
                    end;
                end;
              end;
            end;
          tkFloat:
            case GetTypeData(ASubTypeInfo)^.FloatType of
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
              case GetTypeData(ASubTypeInfo)^.OrdType of
                otSByte:
                  begin
                    if AChild.DataType = jdtInteger then
                      PShortint(pi)^ := AChild.AsInteger
                    else
                      PShortint(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
                  end;
                otUByte:
                  begin
                    if AChild.DataType = jdtInteger then
                      pi^ := AChild.AsInteger
                    else
                      pi^ := StringToSet(ASubTypeInfo, AChild.AsString);
                  end;
                otSWord:
                  begin
                    if AChild.DataType = jdtInteger then
                      PSmallint(pi)^ := AChild.AsInteger
                    else
                      PSmallint(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
                  end;
                otUWord:
                  begin
                    if AChild.DataType = jdtInteger then
                      PWord(pi)^ := AChild.AsInteger
                    else
                      PWord(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
                  end;
                otSLong:
                  begin
                    if AChild.DataType = jdtInteger then
                      PInteger(pi)^ := AChild.AsInteger
                    else
                      PInteger(pi)^ := StringToSet(ASubTypeInfo, AChild.AsString);
                  end;
                otULong:
                  begin
                    if AChild.DataType = jdtInteger then
                      PCardinal(pi)^ := AChild.AsInteger
                    else
                      PCardinal(pi)^ := StringToSet(ASubTypeInfo, Items[I].AsString);
                  end;
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
            Items[I].ToRtti(pi, ASubTypeInfo);
          tkRecord {$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} :
            Items[I].ToRtti(pi, ASubTypeInfo);
          tkInt64:
            PInt64(pi)^ := Items[I].AsInt64;
          tkUString:
            PUnicodeString(pi)^ := Items[I].AsString;
        end;
      end;
    end
    else
      raise Exception.CreateFmt(SMissRttiTypeDefine, [AType.Name]);
  end;

  function GetFixedArrayItemType: PTypeInfo;
  var
    pType: PPTypeInfo;
  begin
    pType := GetTypeData(AType)^.ArrayData.elType;
    if pType = nil then
      Result := nil
    else
      Result := pType^;
  end;
  procedure ToFixedArray;
  var
    I, c, ASize: Integer;
    ASubType: PTypeInfo;
    AChild: TQJson;
    AChildObj: TObject;
    pi: Pointer;
  begin
    c := Min(GetTypeData(AType).ArrayData.ElCount, Count);
    ASubType := GetFixedArrayItemType;
    if ASubType = nil then
      Exit;
    // avoid warning only
    ASize := 0;
    case ASubType.Kind of
      tkInteger, tkEnumeration, tkSet:
        begin
          case GetTypeData(ASubType).OrdType of
            otSByte, otUByte:
              ASize := 1;
            otSWord, otUWord:
              ASize := 2;
            otSLong, otULong:
              ASize := 4;
          end;
        end;
{$IFNDEF NEXTGEN}
      tkChar:
        ASize := 1;
{$ENDIF !NEXTGEN}
      tkFloat:
        case GetTypeData(ASubType)^.FloatType of
          ftSingle:
            ASize := SizeOf(Single);
          ftDouble:
            ASize := SizeOf(Double);
          ftExtended:
            ASize := SizeOf(Extended);
          ftComp:
            ASize := SizeOf(Comp);
          ftCurr:
            ASize := SizeOf(Currency);
        end;
      tkVariant, tkUString
{$IFNDEF NEXTGEN}
        , tkString, tkLString, tkWString
{$ENDIF !NEXTGEN}
        :
        ASize := SizeOf(PShortString);
      tkClass:
        ASize := SizeOf(Pointer);
      tkWChar:
        ASize := SizeOf(WideChar);
      tkArray, tkDynArray:
        ASize := GetTypeData(ASubType)^.elSize;
      tkRecord {$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} :
        ASize := GetTypeData(ASubType)^.RecSize;
      tkInt64:
        ASize := SizeOf(Int64)
    else
      raise Exception.Create(SUnsupportPropertyType);
    end;
    for I := 0 to c - 1 do
    begin
      pi := Pointer(IntPtr(ADest) + ASize * I);
      AChild := Items[I];
      case ASubType.Kind of
        tkInteger:
          begin
            case GetTypeData(ASubType).OrdType of
              otSByte:
                PShortint(pi)^ := AChild.AsInteger;
              otUByte:
                PByte(pi)^ := AChild.AsInteger;
              otSWord:
                PSmallint(pi)^ := AChild.AsInteger;
              otUWord:
                PWord(pi)^ := AChild.AsInteger;
              otSLong:
                PInteger(pi)^ := AChild.AsInteger;
              otULong:
                PCardinal(pi)^ := AChild.AsInteger;
            end;
          end;
{$IFNDEF NEXTGEN}
        tkChar:
          begin
            if AChild.IsString then
              PByte(pi)^ := Ord(PWideChar(AChild.AsString)^)
            else
              PByte(pi)^ := AChild.AsInteger;
          end;
{$ENDIF !NEXTGEN}
        tkEnumeration:
          begin
            if GetTypeData(ASubType)^.BaseType^ = TypeInfo(Boolean) then
              PBoolean(pi)^ := AChild.AsBoolean
            else
            begin
              case GetTypeData(ASubType)^.OrdType of
                otSByte:
                  begin
                    if AChild.DataType = jdtInteger then
                      PShortint(pi)^ := AChild.AsInteger
                    else
                      PShortint(pi)^ := GetEnumValue(ASubType, AChild.AsString);
                  end;
                otUByte:
                  begin
                    if AChild.DataType = jdtInteger then
                      PByte(pi)^ := AChild.AsInteger
                    else
                      PByte(pi)^ := GetEnumValue(ASubType, AChild.AsString);
                  end;
                otSWord:
                  begin
                    if AChild.DataType = jdtInteger then
                      PSmallint(pi)^ := AChild.AsInteger
                    else
                      PSmallint(pi)^ := GetEnumValue(ASubType, AChild.AsString);
                  end;
                otUWord:
                  begin
                    if AChild.DataType = jdtInteger then
                      PWord(pi)^ := AChild.AsInteger
                    else
                      PWord(pi)^ := GetEnumValue(ASubType, AChild.AsString);
                  end;
                otSLong:
                  begin
                    if AChild.DataType = jdtInteger then
                      PInteger(pi)^ := AChild.AsInteger
                    else
                      PInteger(pi)^ := GetEnumValue(ASubType, AChild.AsString);
                  end;
                otULong:
                  begin
                    if AChild.DataType = jdtInteger then
                      PCardinal(pi)^ := AChild.AsInteger
                    else
                      PCardinal(pi)^ := GetEnumValue(ASubType, Items[I].AsString);
                  end;
              end;
            end;
          end;
        tkFloat:
          case GetTypeData(ASubType)^.FloatType of
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
            case GetTypeData(ASubType)^.OrdType of
              otSByte:
                begin
                  if AChild.DataType = jdtInteger then
                    PShortint(pi)^ := AChild.AsInteger
                  else
                    PShortint(pi)^ := StringToSet(ASubType, AChild.AsString);
                end;
              otUByte:
                begin
                  if AChild.DataType = jdtInteger then
                    PByte(pi)^ := AChild.AsInteger
                  else
                    PByte(pi)^ := StringToSet(ASubType, AChild.AsString);
                end;
              otSWord:
                begin
                  if AChild.DataType = jdtInteger then
                    PSmallint(pi)^ := AChild.AsInteger
                  else
                    PSmallint(pi)^ := StringToSet(ASubType, AChild.AsString);
                end;
              otUWord:
                begin
                  if AChild.DataType = jdtInteger then
                    PWord(pi)^ := AChild.AsInteger
                  else
                    PWord(pi)^ := StringToSet(ASubType, AChild.AsString);
                end;
              otSLong:
                begin
                  if AChild.DataType = jdtInteger then
                    PInteger(pi)^ := AChild.AsInteger
                  else
                    PInteger(pi)^ := StringToSet(ASubType, AChild.AsString);
                end;
              otULong:
                begin
                  if AChild.DataType = jdtInteger then
                    PCardinal(pi)^ := AChild.AsInteger
                  else
                    PCardinal(pi)^ := StringToSet(ASubType, Items[I].AsString);
                end;
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
          Items[I].ToRtti(pi, ASubType);
        tkRecord {$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} :
          Items[I].ToRtti(pi, ASubType);
        tkInt64:
          PInt64(pi)^ := Items[I].AsInt64;
        tkUString:
          PUnicodeString(pi)^ := Items[I].AsString;
      end;
    end;
  end;

begin
  if ADest <> nil then
  begin
    if AType.Kind in [tkRecord
{$IFDEF MANAGED_RECORD}, tkMRecord {$ENDIF} ] then
      ToRecord
    else if AType.Kind = tkClass then
      ToObject
    else if AType.Kind = tkDynArray then
      ToArray
    else if AType.Kind = tkArray then
      ToFixedArray
    else
      raise Exception.Create(SUnsupportPropertyType);
  end;
end;

function TQJson.ToRttiValue: TValue;
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
    jdtString:
      Result := AsString;
    jdtInteger:
      Result := AsInt64;
    jdtFloat:
      Result := AsFloat;
    jdtDateTime:
      Result := AsDateTime;
    jdtBoolean:
      Result := AsBoolean;
    jdtArray, jdtObject:
      // ����Ͷ���ֻ�ܵ�������������
      AsDynValueArray
  else
    Result := TValue.Empty;
  end;
end;
{$IFEND >=2010}

function TQJson.ToString: string;
begin
  Result := AsString;
end;

function TQJson.TryParse(p: PWideChar; l: Integer): Boolean;
  procedure DoTry;
  var
    ABuilder: TQStringCatHelperW;
  begin
    SkipBom(p);
    ABuilder := TQStringCatHelperW.Create;
    try
      try
        SkipSpaceW(p);
        Result := ParseJsonPair(ABuilder, p) = 0;
      except
        on E: Exception do
          Result := False;
      end;
    finally
      FreeObject(ABuilder);
    end;
  end;
  procedure ParseCopy;
  var
    S: QStringW;
  begin
    S := StrDupW(p, 0, l);
    p := PQCharW(S);
    DoTry;
  end;

begin
  Result := False;
  if DataType in [jdtObject, jdtArray] then
    Clear;
  if ((l > 0) and (p[l] <> #0)) then
    ParseCopy
  else
    DoTry;
end;

function TQJson.TryGetAsBoolean(var AValue: Boolean): Boolean;
begin
  Result := True;
  if DataType = jdtBoolean then
    AValue := PBoolean(FValue)^
  else if DataType = jdtString then
  begin
    if not TryStrToBool(FValue, AValue) then
      Result := False;
  end
  else if DataType in [jdtFloat, jdtDateTime] then
    AValue := not SameValue(AsFloat, 0, 5E-324)
  else if DataType = jdtInteger then
    AValue := AsInt64 <> 0
  else if DataType = jdtBcd then
    AValue := BcdToStr(AsBcd) <> '0'
  else
    Result := False;
end;

function TQJson.TryGetAsDateTime(var AValue: TDateTime): Boolean;
begin
  Result := True;
  if DataType in [jdtDateTime, jdtFloat] then
    AValue := PExtended(FValue)^
  else if DataType = jdtString then
  begin
    if Length(FValue) > 0 then
      Result := ParseDateTime(PWideChar(FValue), AValue) or ParseJsonTime(PWideChar(FValue), AValue) or
        ParseWebTime(PQCharW(FValue), AValue)
    else
      Result := False;
  end
  else if DataType = jdtInteger then
    AValue := AsInt64
  else if DataType = jdtBcd then
    AValue := BcdToDouble(PBcd(FValue)^)
  else if DataType in [jdtNull, jdtUnknown] then
    AValue := 0
  else
    Result := False;
end;

function TQJson.TryGetAsFloat(var AValue: Extended): Boolean;
  procedure StrAsFloat;
  var
    p: PQCharW;
  begin
    p := PQCharW(FValue);
    if (not ParseNumeric(p, AValue)) or (p^ <> #0) then
      Result := False;
  end;

begin
  Result := True;
  if DataType in [jdtFloat, jdtDateTime] then
    AValue := PExtended(FValue)^
  else if DataType = jdtBcd then
    AValue := BcdToDouble(PBcd(FValue)^)
  else if DataType = jdtBoolean then
    AValue := Integer(AsBoolean)
  else if DataType = jdtString then
    StrAsFloat
  else if DataType = jdtInteger then
    AValue := AsInt64
  else if DataType = jdtNull then
    AValue := 0
  else
    Result := False;
end;

function TQJson.TryGetAsInt64(var AValue: Int64): Boolean;
var
  AExt: Extended;
begin
  Result := True;
  if DataType = jdtInteger then
    AValue := PInt64(FValue)^
  else if DataType in [jdtFloat, jdtDateTime] then
    AValue := Trunc(PExtended(FValue)^)
  else if (DataType = jdtBcd) and (BcdToDouble(PBcd(FValue)^) >= MinInt64) and (BcdToDouble(PBcd(FValue)^) <= MaxInt64)
  then
    AValue := StrToInt64(NameOfW(BcdToStr(PBcd(FValue)^), '.'))
  else if DataType = jdtBoolean then
    AValue := Integer(AsBoolean)
  else if DataType = jdtString then
  begin
    Result := TryGetAsFloat(AExt);
    if Result then
      AValue := Trunc(AExt);
  end
  else if DataType = jdtNull then
    AValue := 0
  else
    Result := False;
end;

function TQJson.TryParse(const S: QStringW): Boolean;
begin
  Result := TryParse(PQCharW(S), Length(S));
end;

function TQJson.TryParseBlock(var p: PWideChar): Boolean;
var
  ABuilder: TQStringCatHelperW;
begin
  SkipBom(p);
  Clear;
  ABuilder := TQStringCatHelperW.Create;
  try
    try
      SkipSpaceW(p);
      Result := ParseJsonPair(ABuilder, p) = 0;
    except
      on E: Exception do
        Result := False;
    end;
  finally
    FreeObject(ABuilder);
  end;
end;

function TQJson.TryParseValue(ABuilder: TQStringCatHelperW; var p: PQCharW): Integer;
var
  AComment: QStringW;
  AIsFloat: Boolean;
const
  JsonEndChars: PWideChar = ',]}';

  function ParseBcd: Boolean;
  var
    pl, pe: PQCharW;
    AInt, V, AFloat: Int64;
    vFloat: Extended;
    AFlags: Integer;
  const
    INT_OVERFLOW = 1;
    FRAC_OVERFLOW = 2;
    MASK_OVERFLOW = 3;
    FLOAT_SCIENTIFIC = 4;
  begin
    pl := p;
    Result := False;
    if pl^ = '$' then
    begin
      Inc(pl);
      AInt := ParseHex(pl, V);
      if AInt > 0 then
      begin
        AsInt64 := V;
        p := pl;
        Result := True;
      end;
      Exit;
    end
    else if pl^ = '0' then
    begin
      Inc(pl);
      if (pl^ = 'x') or (pl^ = 'X') then
      begin
        Inc(pl);
        AInt := ParseHex(pl, V);
        if AInt > 0 then
        begin
          AsInt64 := V;
          p := pl;
          Result := True;
        end;
        Exit;
      end
      else if (pl^ >= '0') and (pl^ <= '7') then // Oct ?
      begin
        V := 0;
        while (pl^ >= '0') and (pl^ <= '7') do
        begin
          V := V * 7 + Ord(pl^) - Ord('0');
          Inc(pl);
        end;
        AsInt64 := V;
        Result := True;
        p := pl;
        Exit;
      end
      else
        Dec(pl);
    end;
    AFlags := 0;
    if pl^ = '-' then
      Inc(pl)
    else if pl^ = '+' then
      Inc(pl);
    if (pl^ >= '0') and (pl^ <= '9') then
    begin
      AIsFloat := False;
      AInt := 0;
      AFloat := 0;
      while pl^ <> #0 do
      begin
        if (pl^ >= '0') and (pl^ <= '9') then
        begin
          if AIsFloat then
          begin
            V := AFloat * 10 + Ord(pl^) - Ord('0');
            if V < AFloat then // С���������
              AFlags := AFlags or FRAC_OVERFLOW
            else
              AFloat := V;
          end
          else
          begin
            V := AInt * 10 + Ord(pl^) - Ord('0');
            if V < AInt then
              AFlags := AFlags or INT_OVERFLOW
            else
              AInt := V;
          end;
          Inc(pl);
        end
        else if pl^ = '.' then
        begin
          if AIsFloat then
            Exit(False)
          else
            AIsFloat := True;
          Inc(pl);
        end
        else if (pl^ = 'e') or (pl^ = 'E') then
        begin
          if (AFlags and FLOAT_SCIENTIFIC) <> 0 then
            Exit(False)
          else
          begin
            AFlags := AFlags or FLOAT_SCIENTIFIC;
            Inc(pl);
            if (pl^ = '+') or (pl^ = '-') then
              Inc(pl);
          end;
        end
        else
          Break;
      end;
      pe := pl;
      SkipSpaceAndComment(pe, AComment);
      Result := (pe^ = #0) or CharInW(pe, JsonEndChars);
      if Result then
      begin
        // ��ѧ��������ʾ��ֵ��ֱ�Ӿ��ǰ�����������
        if (AFlags and FLOAT_SCIENTIFIC) <> 0 then
        begin
          Result := TryStrToFloat(StrDupX(p, pl - p), vFloat);
          if Result then
            AsFloat := vFloat
          else
            Exit(False);
        end
        // ˫���ȸ�������߾�ȷ��С�����14λ����������и���С�����϶����Ǹ�������
        else if ((AFlags and MASK_OVERFLOW) <> 0) or (AFloat > 99999999999999) then
          AsBcd := StrToBcd(StrDupX(p, pl - p))
        else if AFloat = 0 then // ���ֻ����������
        begin
          if p^ = '-' then
            AsInt64 := -AInt
          else
            AsInt64 := AInt;
        end
        else
        begin
          vFloat := StrToFloat(StrDupX(p, pl - p));
          if Frac(vFloat) <> AInt then
            AsBcd := StrToBcd(StrDupX(p, pl - p));
        end;
        p := pe;
      end;
    end
    else
      Result := False;
  end;

begin
  Result := 0;
  if p^ = '"' then
  begin
    BuildJsonString(ABuilder, p);
    AsString := ABuilder.Value;
  end
  else if p^ = '''' then
  begin
    if StrictJson then
      Result := EParse_BadStringStart;
    BuildJsonString(ABuilder, p);
    AsString := ABuilder.Value;
  end
  else if ParseBcd then // ���֣�
  begin
    SkipSpaceAndComment(p, AComment);
    if Length(AComment) > 0 then
      FComment := AComment;
    if (p^ <> #0) and (not CharInW(p, JsonEndChars)) then
      Result := EParse_BadJson;
  end
  else if StartWithW(p, 'False', True) then // False
  begin
    Inc(p, 5);
    SkipSpaceAndComment(p, AComment);
    AsBoolean := False
  end
  else if StartWithW(p, 'True', True) then
  // True
  begin
    Inc(p, 4);
    SkipSpaceAndComment(p, AComment);
    AsBoolean := True;
  end
  else if StartWithW(p, 'NULL', True) then
  // Null
  begin
    Inc(p, 4);
    SkipSpaceAndComment(p, AComment);
    ResetNull;
  end
  else if p^ = ',' then
  begin
    SkipSpaceAndComment(p, AComment);
    ResetNull;
  end
  else if (p^ = '[') or (p^ = '{') then
    Result := ParseJsonPair(ABuilder, p)
  else if StartWithW(p, 'NaN', True) then
  begin
    Inc(p, 3);
    SkipSpaceAndComment(p, AComment);
    AsFloat := NAN;
  end
  else if StartWithW(p, 'Infinity', True) then
  begin
    Inc(p, 8);
    SkipSpaceAndComment(p, AComment);
    AsFloat := Infinity;
  end
  else if StartWithW(p, '-Infinity', True) then
  begin
    Inc(p, 9);
    SkipSpaceAndComment(p, AComment);
    AsFloat := NegInfinity
  end
  else if not ParseBcd then
    Result := 2;
end;

procedure TQJson.ValidArray;
begin
  if DataType in [jdtArray, jdtObject] then
    FItems := TQJsonItemList.Create
  else
    raise Exception.Create(Format(SVarNotArray, [FName]));
end;

function TQJson.ValueArray: TArray<String>;
var
  I: Integer;
begin
  SetLength(Result, Count);
  for I := 0 to High(Result) do
    Result[I] := Items[I].AsString;
end;

function TQJson.ValueByName(AName, ADefVal: QStringW): QStringW;
var
  AChild: TQJson;
begin
  AChild := ItemByName(AName);
  if Assigned(AChild) then
    Result := AChild.AsString
  else
    Result := ADefVal;
end;

function TQJson.ValueByPath(APath, ADefVal: QStringW): QStringW;
var
  AItem: TQJson;
begin
  AItem := ItemByPath(APath);
  if Assigned(AItem) then
    Result := AItem.AsString
  else
    Result := ADefVal;
end;

procedure TQJson.ValueFromFile(AFileName: QStringW);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    ValueFromStream(AStream, 0);
  finally
    FreeObject(AStream);
  end;
end;

procedure TQJson.ValueFromStream(AStream: TStream; ACount: Cardinal);
var
  ABytes: TBytes;
begin
  if ACount = 0 then
  begin
    AStream.Position := 0;
    ACount := AStream.Size;
  end
  else if AStream.Position + ACount > AStream.Size then
    ACount := AStream.Size - AStream.Position;
  SetLength(ABytes, ACount);
  AStream.ReadBuffer(ABytes[0], ACount);
  AsBytes := ABytes;
end;

function TQJson.ValuesToStrings(AOptions: TQCatOptions): TQStringArray;
begin
  InternalFlatItems(Result, 1, AOptions);
end;

function TQJson.ValuesToStrings(AList: TStrings; AOptions: TQCatOptions): Integer;
var
  AItems: TQStringArray;
  AIndex: Integer;
begin
  Result := InternalFlatItems(AItems, 1, AOptions);
  AList.BeginUpdate;
  try
    for AIndex := 0 to Result - 1 do
      AList.Add(AItems[AIndex]);
  finally
    AList.EndUpdate;
  end;
end;

procedure TQJson.Delete;
begin
  if Assigned(FParent) then
    FParent.Delete(ItemIndex)
  else
    FreeObject(Self);
end;

procedure TQJson.ValuesFromStrings(const AValues: TQStringArray; AIsReplace: Boolean; AStartIndex, ACount: Integer);
begin
  DataType := jdtArray; // ����������
  if AIsReplace then
    Clear;
  if AStartIndex >= 0 then
  begin
    if ACount > Length(AValues) - AStartIndex then
      ACount := Length(AValues) - AStartIndex;
    // Use ACount as Stop Index
    ACount := AStartIndex + ACount;
    while AStartIndex < ACount do
    begin
      Add.AsString := AValues[AStartIndex];
      Inc(AStartIndex);
    end;
  end;
end;

procedure TQJson.ValuesFromFloats(const AValues: TFloatArray; AIsReplace: Boolean; AStartIndex, ACount: Integer);
begin
  DataType := jdtArray; // ����������
  if AIsReplace then
    Clear;
  if AStartIndex >= 0 then
  begin
    if ACount > Length(AValues) - AStartIndex then
      ACount := Length(AValues) - AStartIndex;
    // Use ACount as Stop Index
    ACount := AStartIndex + ACount;
    while AStartIndex < ACount do
    begin
      Add.AsFloat := AValues[AStartIndex];
      Inc(AStartIndex);
    end;
  end;
end;

procedure TQJson.ValuesFromInt64s(const AValues: TInt64Array; AIsReplace: Boolean; AStartIndex, ACount: Integer);
begin
  DataType := jdtArray; // ����������
  if AIsReplace then
    Clear;
  if AStartIndex >= 0 then
  begin
    if ACount > Length(AValues) - AStartIndex then
      ACount := Length(AValues) - AStartIndex;
    // Use ACount as Stop Index
    ACount := AStartIndex + ACount;
    while AStartIndex < ACount do
    begin
      Add.AsInt64 := AValues[AStartIndex];
      Inc(AStartIndex);
    end;
  end;
end;

procedure TQJson.ValuesFromIntegers(const AValues: TIntArray; AIsReplace: Boolean; AStartIndex, ACount: Integer);
begin

  DataType := jdtArray; // ����������
  if AIsReplace then
    Clear;
  if AStartIndex >= 0 then
  begin
    if ACount > Length(AValues) - AStartIndex then
      ACount := Length(AValues) - AStartIndex;
    // Use ACount as Stop Index
    ACount := AStartIndex + ACount;
    while AStartIndex < ACount do
    begin
      Add.AsFloat := AValues[AStartIndex];
      Inc(AStartIndex);
    end;
  end;
end;

procedure TQJson.ValuesFromStrings(AList: TStrings; AIsReplace: Boolean; AStartIndex, ACount: Integer);
begin
  DataType := jdtArray; // ����������
  if AIsReplace then
    Clear;
  if AStartIndex >= 0 then
  begin
    if ACount > AList.Count - AStartIndex then
      ACount := AList.Count - AStartIndex;
    // Use ACount as Stop Index
    ACount := AStartIndex + ACount;
    while AStartIndex < ACount do
    begin
      Add.AsString := AList[AStartIndex];
      Inc(AStartIndex);
    end;
  end;
end;

{ TQJsonEnumerator }

constructor TQJsonEnumerator.Create(AList: TQJson);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TQJsonEnumerator.GetCurrent: TQJson;
begin
  Result := FList[FIndex];
end;

function TQJsonEnumerator.MoveNext: Boolean;
begin
  if FIndex < FList.Count - 1 then
  begin
    Inc(FIndex);
    Result := True;
  end
  else
    Result := False;
end;

{ TQHashedJson }

procedure TQHashedJson.Assign(ANode: TQJson);
var
  I: Integer;
begin
  inherited;
  if (Length(FName) > 0) and (FNameHash = 0) then
  begin
    FNameHash := HashName(FName);
    if Assigned(Parent) then
      TQHashedJson(Parent).FHashTable.Add(Self, FNameHash);
  end;
  for I := 0 to Count - 1 do
  begin
    ANode := Items[I];
    ANode.HashNeeded;
    FHashTable.Add(ANode, ANode.NameHash);
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
  FHashTable := TQHashTable.Create();
  FHashTable.AutoSize := True;
end;

function TQHashedJson.CreateJson: TQJson;
begin
  if Assigned(OnQJsonCreate) then
    Result := OnQJsonCreate
  else
    Result := TQHashedJson.Create;
end;

destructor TQHashedJson.Destroy;
begin
  Clear;
  inherited;
  FreeAndNil(FHashTable);
end;

procedure TQHashedJson.DoJsonNameChanged(AJson: TQJson);
  procedure Rehash;
  var
    AHash: TQHashType;
    AList: PQHashList;
    AItem: TQJson;
  begin
    AHash := HashName(AJson.Name);
    if AHash <> AJson.FNameHash then
    begin
      AList := TQHashedJson(AJson.Parent).FHashTable.FindFirst(AJson.FNameHash);
      while AList <> nil do
      begin
        AItem := AList.Data;
        if AItem = AJson then
        begin
          TQHashedJson(AJson.Parent).FHashTable.ChangeHash(AJson, AJson.FNameHash, AHash);
          AJson.FNameHash := AHash;
          Break;
        end
        else
          AList := TQHashedJson(AJson.Parent).FHashTable.FindNext(AList);
      end;
    end;
  end;

begin
  if AJson.FNameHash = 0 then
  begin
    AJson.FNameHash := HashName(AJson.Name);
    if Assigned(AJson.Parent) then
      TQHashedJson(AJson.Parent).FHashTable.Add(AJson, AJson.FNameHash);
  end
  else
    Rehash;
end;

function TQHashedJson.IndexOf(const AName: QStringW): Integer;
var
  AHash: TQHashType;
  AList: PQHashList;
  AItem: TQJson;
begin
  AHash := HashName(AName);
  AList := FHashTable.FindFirst(AHash);
  Result := -1;
  while AList <> nil do
  begin
    AItem := AList.Data;
    if AItem.Name = AName then
    begin
      Result := AItem.ItemIndex;
      Break;
    end
    else
      AList := FHashTable.FindNext(AList);
  end;
end;

function TQHashedJson.ItemByName(AName: QStringW): TQJson;
  function ByHash: TQJson;
  var
    AHash: TQHashType;
    AList: PQHashList;
    AItem: TQJson;
  begin
    AHash := HashName(AName);
    AList := FHashTable.FindFirst(AHash);
    Result := nil;
    while AList <> nil do
    begin
      AItem := AList.Data;
      if StrCmpW(PQCharW(AItem.Name), PQCharW(AName), IgnoreCase) = 0 then
      begin
        Result := AItem;
        Break;
      end
      else
        AList := FHashTable.FindNext(AList);
    end;
  end;

begin
  if DataType = jdtObject then
    Result := ByHash
  else
    Result := inherited ItemByName(AName);
end;

procedure TQHashedJson.DoParsed;
var
  I: Integer;
  AJson: TQJson;
begin
  FHashTable.Resize(Count);
  for I := 0 to Count - 1 do
  begin
    AJson := Items[I];
    if Length(AJson.FName) > 0 then
    begin
      if AJson.FNameHash = 0 then
      begin
        AJson.FNameHash := HashName(AJson.FName);
        FHashTable.Add(AJson, AJson.FNameHash);
      end;
    end;
    if AJson.Count > 0 then
      AJson.DoParsed;
  end;
end;

procedure TQHashedJson.FreeJson(AJson: TQJson);
begin
  if Assigned(AJson) then
  begin
    AJson.FParent := nil;
    if Assigned(OnQJsonFree) then
      OnQJsonFree(AJson)
    else
      FreeAndNil(AJson);
  end;
end;

function TQHashedJson.Remove(AIndex: Integer): TQJson;
begin
  Result := inherited Remove(AIndex);
  if Assigned(Result) then
    FHashTable.Delete(Result, Result.NameHash);
end;

procedure TQHashedJson.Replace(AIndex: Integer; ANewItem: TQJson);
var
  AOld: TQJson;
begin
  if not(ANewItem is TQHashedJson) then
    raise Exception.CreateFmt(SReplaceTypeNeed, ['TQHashedJson']);
  AOld := Items[AIndex];
  FHashTable.Delete(AOld, AOld.NameHash);
  inherited;
  if Length(ANewItem.FName) > 0 then
  begin
    if ANewItem.NameHash = 0 then
      ANewItem.FNameHash := HashName(ANewItem.Name);
    FHashTable.Add(ANewItem, ANewItem.FNameHash);
  end;
end;

procedure EncodeJsonBinaryAsBase64;
begin
  OnQJsonEncodeBytes := DoEncodeAsBase64;
  OnQJsonDecodeBytes := DoDecodeAsBase64;
end;

procedure EncodeJsonBinaryAsHex;
begin
  OnQJsonEncodeBytes := nil;
  OnQJsonDecodeBytes := nil;
end;

{ TQJsonStreamHelper }

procedure TQJsonStreamHelper.BeginArray;
begin
  Inc(FLast.Count);
  FStringHelper.Cat('[');
  Push;
end;

procedure TQJsonStreamHelper.BeginArray(const AName: QStringW);
begin
  Inc(FLast.Count);
  WriteName(AName);
  FStringHelper.Cat('[');
  Push;
end;

procedure TQJsonStreamHelper.BeginObject;
begin
  Inc(FLast.Count);
  FStringHelper.Cat('{');
  Push;
end;

procedure TQJsonStreamHelper.BeginObject(const AName: QStringW);
begin
  Inc(FLast.Count);
  WriteName(AName);
  FStringHelper.Cat('{');
  Push;
end;

procedure TQJsonStreamHelper.BeginWrite(AStream: TStream; AEncoding: TTextEncoding; ADoEscape, AWriteBom: Boolean);
begin
  FStream := AStream;
  FEncoding := AEncoding;
  FDoEscape := ADoEscape;
  FWriteBom := AWriteBom;
  FLast := nil;
  FStringHelper := TQStringCatHelperW.Create;
  Push;
end;

procedure TQJsonStreamHelper.EndArray;
begin
  if FLast.Count > 0 then
    FStringHelper.Back(1);
  FStringHelper.Cat('],');
  Pop;
end;

procedure TQJsonStreamHelper.EndObject;
begin
  if FLast.Count > 0 then
    FStringHelper.Back(1);
  FStringHelper.Cat('},');
  Pop;
end;

procedure TQJsonStreamHelper.EndWrite;
  procedure AnsiWrite;
  var
    T: QStringA;
  begin
    T := qstring.AnsiEncode(FStringHelper.Start, FStringHelper.Position);
    FStream.Write(PQCharA(T)^, T.Length);
  end;
  procedure Utf8Write;
  var
    T: QStringA;
  const
    Utf8BOM: array [0 .. 2] of Byte = ($EF, $BB, $BF);
  begin
    T := qstring.Utf8Encode(FStringHelper.Start, FStringHelper.Position);
    if FWriteBom then
      FStream.Write(Utf8BOM, 3);
    FStream.Write(PQCharA(T)^, T.Length);
  end;
  procedure LEWrite;
  const
    Utf16LEBom: Word = $FEFF;
  begin
    if FWriteBom then
      FStream.Write(Utf16LEBom, 2);
    FStream.Write(FStringHelper.Start^, FStringHelper.Position shl 1);
  end;
  procedure BEWrite;
  const
    Utf16BEBom: Word = $FFFE;
  begin
    ExchangeByteOrder(PQCharA(FStringHelper.Start), FStringHelper.Position shl 1);
    if FWriteBom then
      FStream.Write(Utf16BEBom, 2);
    FStream.Write(FStringHelper.Start^, FStringHelper.Position shl 1);
  end;

begin
  if FLast.Count > 0 then
  begin
    FStringHelper.Back(1);
    case FEncoding of
      teAnsi:
        AnsiWrite;
      teUnicode16LE:
        LEWrite;
      teUnicode16BE:
        BEWrite;
      teUtf8:
        Utf8Write;
    end;
  end;
  Pop;
  FreeAndNil(FStringHelper);
end;

procedure TQJsonStreamHelper.InternalWriteString(S: QStringW; ADoAppend: Boolean);
begin
  FStringHelper.Cat(S);
  if ADoAppend then
    FStringHelper.Cat(',');
  Inc(FLast.Count);
end;

procedure TQJsonStreamHelper.Pop;
var
  ALast: PQStreamHelperStack;
begin
  if Assigned(FLast) then
  begin
    ALast := FLast;
    FLast := ALast.Prior;
    Dispose(ALast);
  end;
end;

procedure TQJsonStreamHelper.Push;
var
  AItem: PQStreamHelperStack;
begin
  New(AItem);
  AItem.Prior := FLast;
  AItem.Count := 0;
  FLast := AItem;
end;

procedure TQJsonStreamHelper.Write(const S: QStringW);
begin
  FStringHelper.Cat('"');
  TQJson.JsonCat(FStringHelper, S, [jesDoEscape]);
  FStringHelper.Cat('",');
  Inc(FLast.Count);
end;

procedure TQJsonStreamHelper.Write(const ABytes: TBytes);
var
  S: QStringW;
begin
  if Assigned(OnQJsonEncodeBytes) then
    OnQJsonEncodeBytes(ABytes, S)
  else
    S := qstring.BinToHex(ABytes);
  Write(S);
end;

procedure TQJsonStreamHelper.Write(const p: PByte; l: Integer);
var
  ATemp: TBytes;
begin
  SetLength(ATemp, l);
  Move(p^, ATemp[0], l);
  Write(ATemp);
end;

procedure TQJsonStreamHelper.Write(const b: Boolean);
begin
  if b then
    InternalWriteString('true')
  else
    InternalWriteString('false');
end;

procedure TQJsonStreamHelper.Write(const I: Int64);
begin
  InternalWriteString(IntToStr(I));
end;

procedure TQJsonStreamHelper.Write(const D: Double);
begin
  InternalWriteString(FloatToStr(D));
end;

procedure TQJsonStreamHelper.Write(const c: Currency);
begin
  InternalWriteString(CurrToStr(c));
end;

procedure TQJsonStreamHelper.WriteDateTime(const V: TDateTime);
  function JsonDateTime: QStringW;
  var
    MS: Int64; // ʱ����Ϣ������
  const
    JsonTimeStart: PWideChar = '/DATE(';
    JsonTimeEnd: PWideChar = ')/';
    UnixDelta: Int64 = 25569;
  begin
    MS := Trunc((V - UnixDelta) * 86400000);
    Result := JsonTimeStart;
    if (JsonTimezone >= -12) and (JsonTimezone <= 12) then
    begin
      Dec(MS, 3600000 * JsonTimezone);
      if JsonDatePrecision = jdpSecond then
        MS := MS div 1000;
      Result := Result + IntToStr(MS);
      if JsonTimezone >= 0 then
        Result := Result + '+';
      Result := Result + IntToStr(JsonTimezone);
    end
    else
      Result := Result + IntToStr(MS);
    Result := Result + JsonTimeEnd;
  end;

  function FormatedJsonTime: QStringW;
  var
    ADate: Integer;
  begin
    ADate := Trunc(V);
    if SameValue(ADate, 0) then // DateΪ0����ʱ��
    begin
      if SameValue(V, 0) then
        Result := '"' + FormatDateTime(JsonDateFormat, V) + '"'
      else
        Result := '"' + FormatDateTime(JsonTimeFormat, V) + '"';
    end
    else
    begin
      if SameValue(V - ADate, 0) then
        Result := '"' + FormatDateTime(JsonDateFormat, V) + '"'
      else
        Result := '"' + FormatDateTime(JsonDateTimeFormat, V) + '"';
    end;
  end;

begin
  if StrictJson then
    InternalWriteString(JsonDateTime)
  else
    InternalWriteString(FormatedJsonTime);
end;

procedure TQJsonStreamHelper.WriteName(const S: QStringW);
begin
  FStringHelper.Cat('"');
  TQJson.JsonCat(FStringHelper, S, [jesDoEscape]);
  FStringHelper.Cat('":');
end;

procedure TQJsonStreamHelper.WriteNull(const AName: QStringW);
begin
  WriteName(AName);
  WriteNull;
end;

procedure TQJsonStreamHelper.WriteNull;
begin
  InternalWriteString('null');
end;

procedure TQJsonStreamHelper.Write(const AName: QStringW; AValue: Double);
begin
  WriteName(AName);
  InternalWriteString(FloatToStr(AValue));
end;

procedure TQJsonStreamHelper.Write(const AName: QStringW; AValue: Int64);
begin
  WriteName(AName);
  InternalWriteString(IntToStr(AValue));
end;

procedure TQJsonStreamHelper.Write(const AName, AValue: QStringW);
begin
  WriteName(AName);
  Write(AValue);
end;

procedure TQJsonStreamHelper.Write(const AName: QStringW; const p: PByte; const l: Integer);
begin
  WriteName(AName);
  Write(p, l);
end;

procedure TQJsonStreamHelper.Write(const AName: QStringW; AValue: Boolean);
begin
  WriteName(AName);
  Write(AValue);
end;

procedure TQJsonStreamHelper.Write(const AName: QStringW; AValue: TBytes);
begin
  WriteName(AName);
  Write(AValue);
end;

procedure TQJsonStreamHelper.WriteDateTime(const AName: QStringW; AValue: TDateTime);
begin
  WriteName(AName);
  WriteDateTime(AValue);
end;

{ TQJsonContainer }

function TQJsonContainer.ForEach(ACallback: TQJsonForEachCallback; ATag: Pointer): IQJsonContainer;
var
  I: Integer;
begin
  Result := Self;
  if Assigned(ACallback) then
  begin
    for I := 0 to FItems.Count - 1 do
      ACallback(FItems[I], ATag);
  end;
end;

constructor TQJsonContainer.Create;
begin
  inherited;
  FItems := TQJsonItemList.Create;
end;

constructor TQJsonContainer.Create(AJson: TQJson);
begin
  inherited Create;
  FItems := TQJsonItemList.Create;
  if Assigned(AJson) then
    FItems.Add(AJson);
end;

destructor TQJsonContainer.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;
{$IFDEF UNICODE}

function TQJsonContainer.ForEach(ACallback: TQJsonForEachCallbackA): IQJsonContainer;
var
  I: Integer;
begin
  Result := Self;
  if Assigned(ACallback) then
  begin
    for I := 0 to FItems.Count - 1 do
      ACallback(FItems[I]);
  end;
end;

function TQJsonContainer.Match(const AFilter: TQJsonMatchFilterCallbackA; ATag: Pointer): IQJsonContainer;
var
  I: Integer;
  T: TQJsonContainer;
  Accept: Boolean;
begin
  if Assigned(AFilter) then
  begin
    T := TQJsonContainer.Create;
    Result := T;
    for I := 0 to FItems.Count - 1 do
    begin
      Accept := False;
      AFilter(FItems[I], Accept);
      if Accept then
        T.FItems.Add(FItems[I]);
    end;
  end
  else // û��ִ���κι���
    Result := Self;
end;
{$ENDIF}

function TQJsonContainer.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQJsonContainer.GetEnumerator: TQJsonContainerEnumerator;
begin
  Result := TQJsonContainerEnumerator.Create(Self);
end;

function TQJsonContainer.GetIsEmpty: Boolean;
begin
  Result := FItems.Count = 0;
end;

function TQJsonContainer.GetItems(const AIndex: Integer): TQJson;
begin
  Result := FItems[AIndex];
end;

function TQJsonContainer.Match(const AFilter: TQJsonMatchFilterCallback; ATag: Pointer): IQJsonContainer;
var
  I: Integer;
  T: TQJsonContainer;
  Accept: Boolean;
begin
  if Assigned(AFilter) then
  begin
    T := TQJsonContainer.Create;
    Result := T;
    for I := 0 to FItems.Count - 1 do
    begin
      Accept := False;
      AFilter(FItems[I], ATag, Accept);
      if Accept then
        T.FItems.Add(FItems[I]);
    end;
  end
  else // û��ִ���κι���
    Result := Self;
end;

function TQJsonContainer.Match(const AStart, AStop, AStep: Integer): IQJsonContainer;
var
  I, c: Integer;
  T: TQJsonContainer;
begin
  I := AStart;
  T := TQJsonContainer.Create;
  Result := T;
  if AStep > 0 then
  begin
    c := AStop;
    if c > FItems.Count then
      c := FItems.Count;
    while I < c do
    begin
      if I >= 0 then
        T.FItems.Add(FItems[I]);
      Inc(I, AStep);
    end;
  end
  else if AStart > AStop then // ����
  begin
    c := FItems.Count;
    while I > AStop do
    begin
      if (I >= 0) and (I < c) then
        T.FItems.Add(FItems[I]);
      Inc(I, AStep);
    end;
  end;
end;

function TQJsonContainer.Match(const AIndexes: array of Integer): IQJsonContainer;
var
  I, c: Integer;
  T: TQJsonContainer;
begin
  T := TQJsonContainer.Create;
  Result := T;
  c := FItems.Count;
  for I := 0 to High(AIndexes) do
  begin
    if (AIndexes[I] >= 0) and (AIndexes[I] < c) then
      T.FItems.Add(FItems[AIndexes[I]]);
  end;
end;

function TQJsonContainer.Match(const ARegex: QStringW; ASettings: TQJsonMatchSettings): IQJsonContainer;
var
  AReg: TPerlRegEx;
  T: TQJsonContainer;
  I: Integer;

  procedure DoMatch(AJson: TQJson);
  var
    J: Integer;
  begin
    if jmsMatchName in ASettings then
    begin
      AReg.Subject := AJson.Name;
      if AReg.Match then
      begin
        T.FItems.Add(FItems[I]);
        Exit;
      end;
    end;
    if jmsMatchPath in ASettings then
    begin
      AReg.Subject := AJson.Path;
      if AReg.Match then
      begin
        T.FItems.Add(AJson);
        Exit;
      end;
    end;
    if AJson.DataType in [jdtArray, jdtObject] then
    begin
      if jmsNest in ASettings then
      begin
        for J := 0 to AJson.Count - 1 do
          DoMatch(AJson[J]);
      end;
    end
    else if jmsMatchValue in ASettings then
    begin
      AReg.Subject := AJson.AsString;
      if AReg.Match then
        T.FItems.Add(AJson);
    end;
  end;

begin
  AReg := TPerlRegEx.Create;
  try
    AReg.RegEx := ARegex;
    if jmsIgnoreCase in ASettings then
      AReg.Options := [preCaseLess];
    AReg.Compile;
    T := TQJsonContainer.Create;
    Result := T;
    for I := 0 to FItems.Count - 1 do
      DoMatch(FItems[I]);
  finally
    FreeAndNil(AReg);
  end;
end;

{ TQJsonContainerEnumerator }

constructor TQJsonContainerEnumerator.Create(AList: IQJsonContainer);
begin
  FList := AList;
  FIndex := -1;
end;

function TQJsonContainerEnumerator.GetCurrent: TQJson;
begin
  Result := FList[FIndex];
end;

function TQJsonContainerEnumerator.MoveNext: Boolean;
begin
  if FIndex < FList.Count - 1 then
  begin
    Inc(FIndex);
    Result := True;
  end
  else
    Result := False;
end;

{ TQJsonPool }

constructor TQJsonPool.Create;
begin
  inherited Create(2048, SizeOf(Pointer));
  OnNewItem := DoNew;
  OnFree := DoFree;
end;

class destructor TQJsonPool.Destroy;
var
  ATemp: TQJsonPool;
begin
  if Assigned(FCurrent) then
  begin
    // ʹ����ʱ�����������ͷ�ʱ�������
    ATemp := FCurrent;
    FCurrent := nil;
    FreeAndNil(ATemp);
  end;
end;

procedure TQJsonPool.DoFree(ASender: TQSimplePool; AData: Pointer);
begin
  FreeAndNil(TQJson(AData));
end;

procedure TQJsonPool.DoNew(ASender: TQSimplePool; var AData: Pointer);
begin
  TQJson(AData) := TQJson.Create;
end;

class function TQJsonPool.GetCurrent: TQJsonPool;
begin
  if not Assigned(FCurrent) then
  begin
    Result := TQJsonPool.Create;
    if AtomicCmpExchange(Pointer(FCurrent), Pointer(Result), nil) <> nil then
      FreeAndNil(Result)
{$IFDEF AUTOREFCOUNT}
    else
      Result.__ObjAddRef;
{$ENDIF}
  end;
  Result := FCurrent;
end;

initialization

StrictJson := False;
JsonRttiEnumAsInt := True;
JsonCaseSensitive := True;
JsonDateFormat := 'yyyy-mm-dd';
JsonDateTimeFormat := 'yyyy-mm-dd''T''hh:nn:ss.zzz';
JsonTimeFormat := 'hh:nn:ss.zzz';
JsonTimezone := JSON_NO_TIMEZONE;
JsonDatePrecision := jdpMillisecond;
JsonIntToTimeStyle := tsDeny;
OnQJsonCreate := nil;
OnQJsonFree := nil;

end.

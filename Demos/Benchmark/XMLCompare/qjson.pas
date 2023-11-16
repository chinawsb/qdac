unit qjson;
{$I 'qdac.inc'}
interface
//���Ի�����ΪDelphi 2007��XE6
uses classes,sysutils,math,qstring
  {$IFDEF QDAC_UNICODE}
  ,Generics.Collections,System.RegularExpressionsCore
  {$ENDIF}
  ;
{$WARN SYMBOL_DEPRECATED OFF}
{$M+}
//{$HINTS OFF}
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
  ///    <item>
  ///    <term>jdtArray</term><description>����</description>
  ///    </item>
  ///    <item>
  ///    <term>jdtObject</term><description>����</description>
  ///    </item>
  ///  </list>
  TQJsonDataType=(jdtUnknown,jdtNull,jdtString,jdtInteger,jdtFloat,jdtBoolean,jdtArray,jdtObject);
  TQJson=class;
  TQJsonObjectPropFilterEvent=procedure (ASender:TQJson;AObject:TObject;APropName:String;var Accept:Boolean);
  //TQJson����������һ��Json������������ʵ�ֲ�ͬ��QJSON���е����Ͷ���ͬһ��
  ///����ʵ�֣�����DataType�Ĳ�ͬ����ʹ�ò�ͬ�ĳ�Ա�����ʡ�������ΪjdtArray������
  ///jdtObjectʱ�����������ӽ��.
  PQJson=^TQJson;
  {$IFDEF QDAC_UNICODE}
  TQJsonItemList=TList<TQJson>;
  {$ELSE}
  TQJsonItemList=TList;
  {$ENDIF}
  TQJson=class
  protected
    FName,FLastError:QStringW;
    FDataType:TQJsonDataType;
    FValue:QStringW;
    FParent:TQJson;
    FData:Pointer;
    FItems:TQJsonItemList;
    FSourceStart:PQCharW;
    function GetValue: QStringW;
    procedure SetValue(const Value: QStringW);
    procedure SetDataType(const Value: TQJsonDataType);
    function GetAsBoolean: Boolean;
    function GetAsFloat: Double;
    function GetAsInt64: Int64;
    function GetAsInteger: Integer;
    function GetAsString: QStringW;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsFloat(const Value: Double);
    procedure SetAsInt64(const Value: Int64);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: QStringW);
    function GetAsObject: QStringW;
    procedure SetAsObject(const Value: QStringW);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetLastError(const AMsg:QStringW;pc:PQCharW);
    function GetCount: Integer;
    function GetItems(AIndex: Integer): TQJson;
    procedure JsonUnescape(p:PQCharW;L:Integer;var R:QStringW);
    procedure JsonEscape(const S:QStringW;var R:QStringW);
    procedure ParseName(var p:PQCharW;var AName:QStringW);
    procedure ParseValue(var p:PQCharW;var AValue:QStringW);
    procedure ParseReserved(var p:PQCharW;var AType:TQJsonDataType;var AValue:QStringW);
    procedure ArrayNeeded(ANewType:TQJsonDataType);
    procedure ValidArray;
    procedure ParseJsonToken(var p:PQCharW;ADelimiters:PQCharW;var AResult:QStringW);
    procedure ParseNumeric(var p:PQCharW;var AType:TQJsonDataType;var AValue:QStringW);
    function ParseObject(var p:PQCharW;len:Integer=-1):Integer;
    function BoolToStr(const b:Boolean):QStringW;
    function GetIsNull: Boolean;
    function GetIsNumeric: Boolean;
    function GetIsArray: Boolean;
    function GetIsObject: Boolean;
    function GetIsString: Boolean;
    function GetAsArray: QStringW;
    procedure SetAsArray(const Value: QStringW);
    function GetPath: QStringW;
    function GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);
    function GetItemIndex: Integer;
  public
    ///���캯��
    constructor Create;overload;
    ///��������
    destructor Destroy;override;
    {! ���һ���ӽ��
    <param name="ANode">Ҫ��ӵĽ��</param>
    <returns>������ӵĽ������</returns>
    }
    function Add(ANode:TQJson): Integer;overload;
    /// ���һ��δ������JSON�ӽ��
    /// <returns>������ӵĽ��ʵ��</returns>
    /// <remarks>
    /// һ������£������������ͣ���Ӧ���δ������ʵ��
    /// </remarks>
    function Add:TQJson;overload;
    /// ���һ������Json����
    ///  <param name="AName">Ҫ��ӵĶ���������</param>
    ///  <param name="AObject">Ҫ��ӵĶ���</param>
    ///  <param name="ANest">������Ե��Ƕ����Ƿ�ݹ�</param>
    ///  <param name="AOnFilter">ָ�����Թ����¼����Թ��˵�����Ҫת��������</param>
    function Add(AName:QStringW;AObject:TObject;ANest:Boolean=False;AOnFilter:TQJsonObjectPropFilterEvent=nil):TQJson;overload;
    {! ���һ���ӽ��
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
    function Add(const AName:QStringW;AItems:array of const):TQJson;overload;
    {! ���һ���ӽ��
    <param name="AName">Ҫ��ӵĽ����</param>
    <param name="ADataType">Ҫ��ӵĽ���������ͣ����ʡ�ԣ����Զ�����ֵ�����ݼ��</param>
    <returns>������ӵ��¶���</returns>
    <remarks>
      1.�����ǰ���Ͳ���jdtObject��jdtArray�����Զ�ת��ΪjdtObject����
      2.�ϲ�Ӧ�Լ������������
    </remarks>
    }
    function Add(AName:QStringW;ADataType:TQJsonDataType):TQJson;overload;

    /// ���һ���ӽ��
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:Double):TQJson;overload;
    /// ���һ���ӽ��
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:Int64):TQJson;overload;
    /// ���һ���ӽ��
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:Boolean):TQJson;overload;
    /// ���һ���ӽ��
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <param name="AValue">Ҫ��ӵĽ��ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW;AValue:TDateTime):TQJson;overload;
    /// ���һ���ӽ��(Null)
    /// <param name="AName">Ҫ��ӵĽ�����������ǰ���Ϊ���飬�������ʱ����Ը�ֵ</param>
    /// <returns>������ӵ��¶���</returns>
    function Add(AName:QStringW):TQJson;overload;

    /// ǿ��һ��·�����ڣ���������ڣ������δ�����Ҫ�Ľ�㣨jdtObject��
    /// <param name="APath">Ҫ��ӵĽ��·��
    /// <returns>����·����Ӧ�Ķ���
    function ForcePath(APath:QStringW):TQJson;
    {! ����ָ����JSON�ַ���
    <param name="p">Ҫ�������ַ���</param>
    <param name="l">�ַ������ȣ�<=0��Ϊ����\0��β��C���Ա�׼�ַ���</param>
    }
    procedure Parse(p:PWideChar;l:Integer=-1);overload;
    {! ����ָ����JSON�ַ���
    <param name='s'>Ҫ������JSON�ַ���</param>
    }
    procedure Parse(const s:QStringW);overload;
    /// ��¡����һ���µĿ���ʵ��
    /// <returns>�����µĿ���ʵ��</returns>
    /// <remarks>��Ϊʵ����ִ�е��ǿ��������������¾ɶ���֮������ݱ��û���κι�ϵ��
    ///  ��������һ�����󣬲��������һ���������Ӱ��
    ///  </remarks>
    function Clone:TQJson;
    {! ����Ϊ�ַ���
    <param name="ADoFormat">�Ƿ��ʽ���ַ����������ӿɶ���</param>
    <param name="AIndent">ADoFormat����ΪTrueʱ���������ݣ�Ĭ��Ϊ�����ո�</param>
    <returns>���ر������ַ���</returns>
    }
    function Encode(ADoFormat:Boolean;AIndent:QStringW='  '):QStringW;
    {! ��ȡָ�����ƻ�ȡ����ֵ���ַ�����ʾ
    <param name="AName">�������</param>
    <returns>����Ӧ����ֵ</returns>
    }
    function ValueByName(AName,ADefVal:QStringW):QStringW;
    {! ��ȡָ��·������ֵ���ַ�����ʾ
    <param name="AName">�������</param>
    <returns>�����������ڣ�����Ĭ��ֵ�����򣬷���ԭʼֵ</returns>
    }
    function ValueByPath(APath,ADefVal:QStringW):QStringW;
    {! ��ȡָ�����ƻ�ȡ���
    <param name="AName">�������</param>
    <returns>�����ҵ��Ľ�㣬���δ�ҵ������ؿ�(NULL/nil)</returns>
    }
    function ItemByName(AName:QStringW):TQJson;overload;
    function ItemByName(const AName:QStringW;AList:TQJsonItemList;ANest:Boolean=False):Integer;overload;
    function ItemByRegex(const ARegex:QStringW;AList:TQJsonItemList;ANest:Boolean=False):Integer;overload;
    /// ��ȡָ��·����JSON����
    ///  <param name="APath">·������"."��"/"��"\"�ָ�</param>
    ///  <returns>�����ҵ����ӽ��</returns>
    function ItemByPath(APath:QStringW):TQJson;
    {! ��Դ������JSON��������
    <param name="ANode">Ҫ���Ƶ�Դ���</param>
    <remarks>ע�ⲻҪ�����ӽ����Լ���Ҫ�����ӽ�㣬�ȿ�¡һ���ӽ�����ʵ�����ٴ���
    ʵ������
    </remarks>
    }
    procedure Assign(ANode:TQJson);
    /// ɾ��ָ�������Ľ��
    /// <param name="AIndex">Ҫɾ���Ľ������</param>
    /// <remarks>
    /// ���ָ�������Ľ�㲻���ڣ����׳�EOutRange�쳣
    /// </remarks>
    procedure Delete(AIndex:Integer);overload;
    procedure Delete(AName:QStringW);overload;
    function IndexOf(const AName:QStringW):Integer;
    /// ������еĽ��
    procedure Clear;
    /// ���浱ǰ�������ݵ�����
    ///  <param name="AStream">Ŀ��������</param>
    ///  <param name="AEncoding">�����ʽ</param>
    ///  <param name="AWriteBom">�Ƿ�д��BOM</param>
    ///  <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToStream(AStream:TStream;AEncoding:TTextEncoding;AWriteBOM:Boolean);
    /// �����м���JSON����
    ///  <param name="AStream">Դ������</param>
    ///  <remarks>���ĵ�ǰλ�õ������ĳ��ȱ������2�ֽڣ�����������</remarks>
    procedure LoadFromStream(AStream:TStream);
    /// ���浱ǰ�������ݵ��ļ���
    ///  <param name="AFileName">�ļ���</param>
    ///  <param name="AEncoding">�����ʽ</param>
    ///  <param name="AWriteBOM">�Ƿ�д��UTF-8��BOM</param>
    ///  <remarks>ע�⵱ǰ�������Ʋ��ᱻд��</remarks>
    procedure SaveToFile(AFileName:String;AEncoding:TTextEncoding;AWriteBOM:Boolean);
    /// ��ָ�����ļ��м��ص�ǰ����
    ///  <param name="AFileName">Ҫ���ص��ļ���</param>
    procedure LoadFromFile(AFileName:String);
    //// ����ֵΪNull
    procedure ResetNull;
    /// ����TObject.ToString����
    function ToString: string;{$IFDEF QDAC_UNICODE}override;{$ENDIF}
    /// ��Json�����ݻ�ԭ��ԭ���Ķ�������
    procedure ToObject(AObject:TObject);
    ///�����
    property Parent:TQJson read FParent;
    ///�������
    /// <seealso>TQJsonDataType</seealso>
    property DataType:TQJsonDataType read FDataType write SetDataType;
    ///�������
    property Name:QStringW read FName;
    ///�ӽ������
    property Count:Integer read GetCount;
    ///�ӽ������
    property Items[AIndex:Integer]:TQJson read GetItems;default;
    ///�ӽ���ֵ
    property Value:QStringW read GetValue write SetValue;
    ///�ж��Ƿ���NULL����
    property IsNull:Boolean read GetIsNull;
    ///�ж��Ƿ�����������
    property IsNumeric:Boolean read GetIsNumeric;
    ///�ж��Ƿ����ַ�������
    property IsString:Boolean read GetIsString;
    ///�ж��Ƿ��Ƕ���
    property IsObject:Boolean read GetIsObject;
    ///�ж��Ƿ�������
    property IsArray:Boolean read GetIsArray;
    ///����ǰ��㵱���������ͷ���
    property AsBoolean:Boolean read GetAsBoolean write SetAsBoolean;
    ///����ǰ��㵱����������������
    property AsInteger:Integer read GetAsInteger write SetAsInteger;
    ///����ǰ��㵱��64λ��������������
    property AsInt64:Int64 read GetAsInt64 write SetAsInt64;
    ///����ǰ��㵱����������������
    property AsFloat:Double read GetAsFloat write SetAsFloat;
    ///����ǰ��㵱������ʱ������������
    property AsDateTime:TDateTime read GetAsDateTime write SetAsDateTime;
    ///����ǰ��㵱���ַ������ͷ���
    property AsString:QStringW read GetAsString write SetAsString;
    ///����ǰ��㵱��һ�������ַ���������
    property AsObject:QStringW read GetAsObject write SetAsObject;
    ///����ǰ��㵱��һ���ַ�������������
    property AsArray:QStringW read GetAsArray write SetAsArray;
    ///���Լ�����Variant����������
    property AsVariant:Variant read GetAsVariant write SetAsVariant;
    //����ĸ������ݳ�Ա�����û�������������
    property Data:Pointer read FData write FData;
    ///����·�����м���"\"�ָ�
    property Path:QStringW read GetPath;
    ///�ڸ�����е�����˳�򣬴�0��ʼ�������-1��������Լ��Ǹ����
    property ItemIndex:Integer read GetItemIndex;
  end;
var
  /// �Ƿ������ϸ���ģʽ���ڴ�ģʽ�£�JSON�����Ʊ�����˫���Ű���,Ĭ��false
  StrictJson:Boolean;
implementation
uses typinfo,variants;
resourcestring
  SBadJson='��ǰ���ݲ�����Ч��JSON�ַ�����';
  SNotArrayOrObject='%s ����һ��JSON��������';
  SBadString='%s ����һ����Ч��QDAC_UNICODE�����ַ�����';
  SVarNotArray='%s �����Ͳ�����������';
  SBadConvert='%s ����һ����Ч�� %s ���͵�ֵ��';
  SCharNeeded='��ǰλ��Ӧ���� "%s" �������� "%s"��';
  SBadChar='���������ֵ��ַ��� "%s"��';
  SBadNumeric='"%s"������Ч����ֵ��';
  SNameNotFound='��Ŀ����δ�ҵ���';
  SErrorOnLine='�� %d �е� %d ��:%s'#13#10'������:%s';
  SCommentNotSupport='�ϸ�ģʽ�²�֧��ע�ͣ�Ҫ��������ע�͵�JSON���ݣ��뽫StrictJson��������ΪFalse.';
  SUnsupportArrayItem='��ӵĶ�̬�����%d��Ԫ�����Ͳ���֧�֡�';
  SNotSupport='��֧�ֵĺ���[%s]';
const
  JsonTypeName:array [0..7] of QStringW=(
    'Unknown','Null','String','Integer','Float','Boolean','Array','Object');
{ TQJson }

function TQJson.Add(AName: QStringW; AValue: Int64): TQJson;
begin
Result:=Add;
Result.FName:=AName;
Result.DataType:=jdtInteger;
PInt64(PQCharW(Result.FValue))^:=AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Double): TQJson;
begin
Result:=Add;
Result.FName:=AName;
Result.DataType:=jdtFloat;
PDouble(PQCharW(Result.FValue))^:=AValue;
end;

function TQJson.Add(AName: QStringW; AValue: Boolean): TQJson;
begin
Result:=Add;
Result.FName:=AName;
Result.DataType:=jdtBoolean;
PBoolean(PQCharW(Result.FValue))^:=AValue;
end;

function TQJson.Add(AName: QStringW): TQJson;
begin
Result:=Add;
Result.FName:=AName;
end;

function TQJson.Add(AName: QStringW; AObject: TObject;ANest:Boolean;AOnFilter:TQJsonObjectPropFilterEvent): TQJson;

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
    {$ENDIF}
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
      Result:=IntToHex(Integer(AMethod.Data),8);
    if Length(AMethodName)=0 then
      AMethodName:=IntToHex(Integer(AMethod.Code),8);
    {$ENDIF}
    Result:=Result+'.'+AMethodName;
    end
  else if AMethod.Code<>nil then
    begin
    {$IFDEF CPUX64}
    Result:=IntToHex(Int64(AMethod.Code),16);
    {$ELSE}
    Result:=IntToHex(Integer(AMethod.Code),8);
    {$ENDIF}
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
  ACount:=GetPropList(AObj,AList);
  for I := 0 to ACount-1 do
    begin
    if Assigned(AOnFilter) then
      begin
      Accept:=True;
      {$IFDEF QDAC_UNICODE}
      AOnFilter(AParent,AObj,AList[I].NameFld.ToString,Accept);
      {$ELSE}
      AOnFilter(AParent,AObj,AList[I].Name,Accept);
      {$ENDIF}
      if not Accept then
        Continue;
      end;
    {$IFDEF QDAC_UNICODE}
    AChild:=AParent.Add(AList[I].NameFld.ToString);
    {$ELSE}
    AChild:=AParent.Add(AList[I].Name);
    {$ENDIF}
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
        if ANest then
          AddChildren(AChild,TObject(GetOrdProp(AObj,AList[I])))
        else
          AChild.AsString:=GetObjectName(TObject(GetOrdProp(AObj,AList[I])));
      tkEnumeration:
        if GetTypeData(AList[I]^.PropType^)^.BaseType^=TypeInfo(Boolean) then
          AChild.AsBoolean:=Boolean(GetOrdProp(AObj,AList[I]))
        else
          AChild.AsString:=GetEnumProp(AObj,AList[I]);
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
      {$ENDIF}
      tkVariant:
        AChild.AsVariant := GetVariantProp(AObj, AList[I]);
      tkInt64:
        AChild.AsInt64 := GetInt64Prop(AObj, AList[I]);
      tkDynArray:
        begin
        DynArrayToVariant(V,GetDynArrayProp(AObj, AList[I]),AList[I].PropType^);
        AChild.AsVariant:=V;
        end;
    end;
    end;
  end;
begin
//����RTTIֱ�ӻ�ȡ�����������Ϣ�����浽�����
Result:=Add(AName);
AddChildren(Result,AObject);
end;

function TQJson.Add(AName: QStringW; AValue: TDateTime): TQJson;
begin
Result:=Add;
Result.FName:=AName;
Result.DataType:=jdtString;
Result.FValue:=FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',AValue);
end;

function TQJson.Add: TQJson;
begin
Result:=TQJson.Create;
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
begin
ANode:=TQJson.Create;
ANode.FName:=AName;
p:=PQCharW(AValue);
ANode.FSourceStart:=p;//�����壬ֵ������ɺ��ͷ���
if ADataType=jdtUnknown then
  begin
  case p^ of
    '[':
      begin
      ANode.DataType:=jdtArray;
      if ANode.ParseObject(p)<0 then//����ʧ�ܣ��ַ���
        begin
        ANode.DataType:=jdtString;
        ANode.FValue:=AValue;
        end;
      end;
    '{':
      begin
      ANode.DataType:=jdtObject;
      if ANode.ParseObject(p)<0 then
        begin
        ANode.DataType:=jdtString;
        ANode.FValue:=AValue;
        end;
      end
    else
      begin
      //���ȳ��Կ��ǲ��Ǳ����ַ���
      ANode.ParseReserved(p,ADataType,ANode.FValue);
      if ADataType=jdtUnknown then
        begin
        ANode.DataType:=jdtString;
        ANode.FValue:=AValue;
        end
      else
        ANode.FDataType:=ADataType;
      end;
  end;
  end
else
  begin
  ANode.DataType:=ADataType;
  case ADataType of
    jdtString:
      ANode.FValue:=AValue;
    jdtInteger,jdtFloat:
      ParseNumeric(p,ANode.FDataType,ANode.FValue);
    jdtBoolean:
      ANode.AsBoolean:=StrToBool(AValue);
    jdtArray,jdtObject:
      if ANode.ParseObject(p)<0 then
        begin
        FLastError:=ANode.FLastError;
        {$IFDEF QDAC_UNICODE}
        ANode.DisposeOf;
        {$ELSE}
        ANode.Free;
        {$ENDIF}
        raise Exception.Create(FLastError);
        end;
  end;
  end;
try
  Result:=Add(ANode);
except
  {$IFDEF QDAC_UNICODE}
  ANode.DisposeOf;
  {$ELSE}
  ANode.Free;
  {$ENDIF}
  raise;
end;
end;

function TQJson.Add(AName: QStringW; ADataType: TQJsonDataType): TQJson;
begin
Result:=TQJson.Create;
Result.FName:=AName;
Result.DataType:=ADataType;
Add(Result);
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
      Result.Add.AsString:=String(AItems[I].VChar);
    {$ENDIF}
    vtExtended:
      Result.Add.AsFloat:=AItems[I].VExtended^;
    {$IFNDEF NEXTGEN}
    vtString:
      Result.Add.AsString:=String(AItems[I].VString^);
    {$ENDIF}
    vtPointer:
      Result.Add.AsInteger:=Integer(AItems[I].VPointer);
    {$IFNDEF NEXTGEN}
    vtPChar:
      Result.Add.AsString:=String(AItems[I].VPChar);
    {$ENDIF}
    vtWideChar:
      Result.Add.AsString:=AItems[I].VWideChar;
    vtPWideChar:
      Result.Add.AsString:=AItems[I].VPWideChar;
    {$IFNDEF NEXTGEN}
    vtAnsiString:
      Result.Add.AsString:=String(PAnsiString(AItems[I].VAnsiString)^);
    {$ENDIF}
    vtCurrency:
      Result.Add.AsFloat:=AItems[I].VCurrency^;
    vtInt64:
      Result.Add.AsInt64:=AItems[I].VInt64^;
    {$IFNDEF NEXTGEN}
    vtWideString:
      Result.Add.AsString:=PWideString(AItems[I].VWideString)^;
    {$ENDIF}
    {$IFDEF QDAC_UNICODE}
    vtUnicodeString:
      Result.Add.AsString:=PUnicodeString(AItems[I].VUnicodeString)^
    {$ENDIF}
    else
      raise Exception.Create(Format(SUnsupportArrayItem,[I]));
  end;
  end;
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
  AChild:TQJson;
  I:Integer;
begin
DataType:=ANode.FDataType;
FName:=ANode.FName;
if FDataType in [jdtArray,jdtObject] then
  begin
  Clear;
  for I := 0 to ANode.Count - 1 do
    begin
    AChild:=ANode.Items[I];
    if Assigned(AChild) then
      Add(AChild)
    end;
  end
else
  FValue:=ANode.FValue;
end;

function TQJson.BoolToStr(const b: Boolean): QStringW;
begin
if b then
  Result:='true'
else
  Result:='false';
end;

procedure TQJson.Clear;
var
  I:Integer;
begin
if FDataType in [jdtArray,jdtObject] then
  begin
  for I := 0 to Count - 1 do
    {$IFDEF QDAC_UNICODE}
    FItems[I].DisposeOf;
    {$ELSE}
    Items[I].Free;
    {$ENDIF}
  FItems.Clear;
  end
else
  raise Exception.Create(Format(SNotArrayOrObject,[FName]));
end;

function TQJson.Clone: TQJson;
begin
Result:=TQJson.Create;
Result.Assign(Self);
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

procedure TQJson.Delete(AIndex: Integer);
begin
if FDataType in [jdtArray,jdtObject] then
  begin
  {$IFDEF QDAC_UNICODE}
  Items[AIndex].DisposeOf;
  {$ELSE}
  Items[AIndex].Free;
  {$ENDIF}
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
  {$IFDEF QDAC_UNICODE}
  FItems.DisposeOf;
  {$ELSE}
  FItems.Free;
  {$ENDIF}
  end;
inherited;
end;

function TQJson.Encode(ADoFormat: Boolean; AIndent: QStringW): QStringW;
var
  p,ps:PQCharW;
const
  CommaOrLineBreak:PWideChar=','#13#10;
  procedure StrCatX(s:PQCharW;L:Integer);
  var
    ASize:Integer;
  begin
  ASize:=p-ps;
  while ASize+L>Length(Result) do
    begin
    SetLength(Result,Length(Result)+16384);
    ps:=PQCharW(Result);
    p:=ps+ASize;
    end;
  ASize:=0;
  while ASize<L do
    begin
    p[ASize]:=s[ASize];
    Inc(ASize);
    end;
  Inc(p,L);
  end;
  procedure InternalEncode(ANode:TQJson;ACurrenIndent:QStringW;AEncodeName:Boolean);
  var
    I:Integer;
    T:QStringW;
    os:PQCharW;
    ArrayWraped:Boolean;
  begin
  if (ANode<>Self) and AEncodeName then
    begin
    if ADoFormat then
      StrCatX(PQCharW(ACurrenIndent),Length(ACurrenIndent));
    if (Length(ANode.FName)>0) then
      begin
      StrCatX('"',1);
      JsonEscape(ANode.FName,T);
      StrCatX(PQCharW(T),Length(T));
      StrCatX('":',2);
      end;
    end;
  case ANode.DataType of
    jdtArray:
      begin
      StrCatX('[',1);
      ArrayWraped:=False;
      if ANode.Count>0 then
        begin
        os:=p;
        for I := 0 to ANode.Count - 1 do
          begin
          if ADoFormat and (ANode.Items[I].DataType in [jdtArray,jdtObject])  then
            begin
            StrCatX(#13#10,2);
            StrCatX(PQCharW(ACurrenIndent),Length(ACurrenIndent));
            StrCatX(PQCharW(AIndent),Length(AIndent));
            ArrayWraped:=True;
            end;
          InternalEncode(ANode.Items[I],ACurrenIndent+AIndent,false);
          if ADoFormat and (os-p>80) then
            begin
            StrCatX(#13#10,2);
            if I+1<ANode.Count then
              begin
              StrCatX(PQCharW(ACurrenIndent),Length(ACurrenIndent));
              StrCatX(PQCharW(AIndent),Length(AIndent));
              end;
            os:=p;
            ArrayWraped:=True;
            end;
          end;
        if ADoFormat and ArrayWraped then
          Dec(p,3)
        else
          Dec(p)
        end;
      if ADoFormat and ArrayWraped then
        begin
        StrCatX(#13#10,2);
        StrCatX(PQCharW(ACurrenIndent+AIndent),Length(ACurrenIndent)+Length(AIndent));
        StrCatX('],',2);
        end
      else
        StrCatX('],',2);
      end;
    jdtObject:
      begin
      if ADoFormat then
        StrCatX('{'#13#10,3)
      else
        StrCatX('{',1);
      if ANode.Count>0 then
        begin
        for I := 0 to ANode.Count - 1 do
          begin
          InternalEncode(ANode.Items[I],ACurrenIndent+AIndent,true);
          if ADoFormat then
            StrCatX(#13#10,2);
          end;
        if ADoFormat then
          Dec(p,3)
        else
          Dec(p);
        StrCatX(#13#10,2);
        if ADoFormat and (ANode<>Self) then
          StrCatX(PQCharW(ACurrenIndent+AIndent),Length(ACurrenIndent)+Length(AIndent));
        StrCatX('},',2);
        end
      else
        begin
        if ADoFormat and (ANode<>Self) then
          begin
          StrCatX(#13#10,2);
          StrCatX(PQCharW(ACurrenIndent+AIndent),Length(ACurrenIndent)+Length(AIndent));
          StrCatX('},'#13#10,4);
          end
        else
          StrCatX('},',2);
        end;
      end;
    jdtNull,jdtUnknown:
      StrCatX('null,',5);
    jdtString:
      begin
      JsonEscape(ANode.FValue,T);
      StrCatX('"',1);
      StrCatX(PQCharW(T),Length(T));
      StrCatX('",',2);
      end;
    jdtInteger,jdtFloat,jdtBoolean:
      begin
      T:=ANode.Value;
      StrCatX(PQCharW(T),Length(T));
      StrCatX(',',1);
      end;
    end;
  end;
begin
try
  SetLength(Result,16384);//Ĭ�Ϸ���16KB���ַ�
  p:=PQCharW(Result);
  ps:=p;
  InternalEncode(Self,'',DataType=jdtArray);
  Dec(p);
  while CharInW(p,CommaOrLineBreak) do
    Dec(p);
  SetLength(Result,p-ps+1);
except
  Result:=''
end;
end;

function TQJson.ForcePath(APath: QStringW): TQJson;
var
  AName:QStringW;
  p:PQCharW;
  AParent:TQJson;
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
    Result:=AParent.Add(AName);
  AParent:=Result;
  end;
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
else if DataType = jdtFloat then
  Result:=not SameValue(AsFloat,0)
else if DataType = jdtInteger then
  Result:=AsInt64<>0
else
  raise Exception.Create(Format(SBadConvert,[JsonTypeName[Integer(DataType)],'Boolean']));
end;

function TQJson.GetAsDateTime: TDateTime;
begin
if DataType=jdtString then
  begin
  if not ParseDateTime(PWideChar(FValue),Result) then
    raise Exception.Create(Format(SBadConvert,['String','DateTime']))
  end
else if DataType=jdtFloat then
  Result:=AsFloat
else if DataType=jdtInteger then
  Result:=AsInt64
else
  raise Exception.Create(Format(SBadConvert,[JsonTypeName[Integer(DataType)],'DateTime']));
end;

function TQJson.GetAsFloat: Double;
begin
if DataType = jdtFloat then
  Result:=PDouble(FValue)^
else if DataType = jdtBoolean then
  Result:=Integer(AsBoolean)
else if DataType = jdtString then
  begin
  if not TryStrToFloat(FValue,Result) then
    raise Exception.Create(Format(SBadConvert,[FValue,'Numeric']));
  end
else if DataType =  jdtInteger then
  Result:=AsInt64
else
  raise Exception.Create(Format(SBadConvert,[JsonTypeName[Integer(DataType)],'Numeric']))
end;

function TQJson.GetAsInt64: Int64;
begin
if DataType =  jdtInteger then
  Result:=PInt64(FValue)^
else if DataType = jdtFloat then
  Result:=Trunc(PDouble(FValue)^)
else if DataType = jdtBoolean then
  Result:=Integer(AsBoolean)
else if DataType = jdtString then
  Result:=Trunc(AsFloat)
else
  raise Exception.Create(Format(SBadConvert,[JsonTypename[Integer(DataType)],'Numeric']))
end;

function TQJson.GetAsInteger: Integer;
begin
Result:=GetAsInt64;
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
Result:=FItems.Count;
end;

function TQJson.GetIsArray: Boolean;
begin
Result:=(DataType=jdtArray);
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
  AParent:TQJson;
begin
Result:=Name;
AParent:=FParent;
while Assigned(AParent) do
  begin
  Result:=AParent.Name+'\'+Result;
  AParent:=AParent.FParent;
  end;
end;

function TQJson.GetValue: QStringW;
begin
case DataType of
  jdtNull,jdtUnknown:
    Result:='null';
  jdtString:
    Result:=FValue;
  jdtInteger:
    Result:=IntToStr(PInt64(FValue)^);
  jdtFloat:
    Result:=FloatToStr(PDouble(FValue)^);
  jdtBoolean:
    Result:=BoolToStr(PBoolean(FValue)^);
  jdtArray,jdtObject:
    Result:=Encode(True);
end;
end;

function TQJson.IndexOf(const AName: QStringW): Integer;
var
  I:Integer;
begin
Result:=-1;
for I := 0 to Count - 1 do
  begin
  if Items[I].Name=AName then
    begin
    Result:=I;
    Break;
    end;
  end;
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
  for I := 0 to Count - 1 do
    begin
    AChild:=Items[I];
    if AChild.IsArray then
      begin
      Result:=AChild.ItemByName(AName);
      if Assigned(Result) then
        Break;
      end
    else if AChild.FName=AName then
      begin
      Result:=AChild;
      Exit;
      end;
    end;
  end
else if DataType=jdtArray then
  begin
  ASelfName:=ArrayName;
  for I := 0 to Count-1 do
    begin
    AChild:=Items[I];
    if AChild.IsArray then
      begin
      Result:=AChild.ItemByName(AName);
      if Assigned(Result) then
        Exit;
      end
    else if ASelfName+'['+IntToStr(I)+']'=AName then
      begin
      Result:=AChild;
      Exit;
      end;
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
  p:PQCharW;
const
  PathDelimiters:PWideChar='./\';
begin
AParent:=Self;
p:=PQCharW(APath);
Result:=nil;
while Assigned(AParent) and (p^<>#0) do
  begin
  ParseJsonToken(p,'.\/',AName);
  if Length(AName)>0 then
    begin
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
  APcre.DisposeOf;
end;
{$ELSE}
raise Exception.Create(Format(SNotSupport,['ItemByRegex']));
{$ENDIF}
end;

procedure TQJson.JsonEscape(const S: QStringW; var R: QStringW);
var
  ps,pd:PQCharW;
const
  AHexChars:array [0..15] of QCharW=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
begin
SetLength(R,Length(S)*6);//���ȫ����\u0000��6���ַ�
ps:=PQCharW(S);
pd:=PQCharW(R);
while ps^<>#0 do
  begin
  case ps^ of
    #7:
      begin
      pd[0]:='\';
      pd[1]:='b';
      Inc(pd,2);
      end;
    #9:
      begin
      pd[0]:='\';
      pd[1]:='t';
      Inc(pd,2);
      end;
    #10:
      begin
      pd[0]:='\';
      pd[1]:='n';
      Inc(pd,2);
      end;
    #12:
      begin
      pd[0]:='\';
      pd[1]:='f';
      Inc(pd,2);
      end;
    #13:
      begin
      pd[0]:='\';
      pd[1]:='r';
      Inc(pd,2);
      end;
    '\':
      begin
      pd[0]:='\';
      pd[1]:='\';
      Inc(pd,2);
      end;
    '"':
      begin
      pd[0]:='\';
      pd[1]:='"';
      Inc(pd,2);
      end
    else
      begin
      if ps^<#$1F then
        begin
        pd[0]:='\';
        pd[1]:='u';
        pd[2]:='0';
        pd[3]:='0';
        if ps^>#$F then
          pd[4]:='1'
        else
          pd[4]:='0';
        pd[5]:=AHexChars[Ord(ps^) and $0F];
        Inc(pd,6);
        end
      else
        begin
        pd^:=ps^;
        Inc(pd);
        end;
      end;
    end;
  Inc(ps);
  end;
SetLength(R,pd-PQCharW(R));
end;

procedure TQJson.JsonUnescape(p: PQCharW; L: Integer; var R: QStringW);
var
  ps,pd:PQCharW;
  function DecodeOrd:Integer;
  var
    C:Integer;
  begin
  Result:=0;
  C:=0;
  while (p-ps<L) and (C<4) do
    begin
    if IsHexChar(p^) then
      Result:=(Result shl 4)+HexValue(p^)
    else
      Break;
    Inc(p);
    Inc(C);
    end
  end;
  procedure DecodeChar;
  var
    V:Integer;
    pv:PQCharW;
  begin
  pv:=p-1;
  if p[0]='u' then
    Inc(p);
  V:=DecodeOrd;
  if (V>=$D800) and (V<=$DBFF) then//QDAC_UNICODE ��չ�ַ���λ����Ҫ��������\uxxxx\uxxxx
    begin
    if (p[0]='\') and (p[1]='u') then
      begin
      pd^:=QCharW(V);
      Inc(pd);
      pv:=p;
      if (p[0]='\') and (p[1]='u') then
        begin
        Inc(p,2);
        V:=DecodeOrd;
        if (V>=$DC00) and (V<=$DFFF) then
          begin
          pd^:=QCharW(V);
          Inc(pd);
          end
        else
          raise Exception.Create(Format(SBadString,[pv]));
        end
      else
        raise Exception.Create(Format(SBadString,[pv]));
      end;
    end
  else if (V>=$DC00) and (V<=$DFFF) then
    raise Exception.Create(Format(SBadString,[pv]))
  else
    begin
    pd^:=QCharW(V);
    Inc(pd);
    end;
  end;
begin
ps:=p;
SetLength(R,L);
pd:=PQCharW(R);
while p-ps<L do
  begin
  if p^='\' then
    begin
    Inc(p);
    case p^ of
      'b':
        begin
        pd^:=#7;
        Inc(pd);
        Inc(p);
        end;
      't':
        begin
        pd^:=#9;
        Inc(pd);
        Inc(p);
        end;
      'n':
        begin
        pd^:=#10;
        Inc(pd);
        Inc(p);
        end;
      'f':
        begin
        pd^:=#12;
        Inc(pd);
        Inc(p);
        end;
      'r':
        begin
        pd^:=#13;
        Inc(pd);
        Inc(p);
        end;
      '\':
        begin
        pd^:='\';
        Inc(pd);
        Inc(p);
        end;
      '''':
        begin
        pd^:='''';
        Inc(pd);
        Inc(p);
        end;
      '"':
        begin
        pd^:='"';
        Inc(pd);
        Inc(p);
        end;
      'u':
        DecodeChar;
      else
        begin
        pd^:=p^;
        Inc(pd);
        Inc(p);
        end;
    end;
    end
  else
    begin
    pd^:=p^;
    Inc(pd);
    Inc(p);
    end;
  end;
SetLength(R,pd-PQCharW(R));
end;

procedure TQJson.LoadFromFile(AFileName: String);
var
  AStream:TFileStream;
begin
AStream:=TFileStream.Create(AFileName,fmOpenRead or fmShareDenyWrite);
try
  LoadFromStream(AStream);
finally
  begin
  {$IFDEF QDAC_UNICODE}
  AStream.DisposeOf;
  {$ELSE}
  AStream.Free;
  {$ENDIF}
  end;
end;
end;

procedure TQJson.LoadFromStream(AStream: TStream);
var
  S:QStringW;
begin
S:=LoadTextW(AStream);
if Length(S)>2 then
  Parse(PQCharW(S),Length(S))
else
  raise Exception.Create(SBadJson);
end;

procedure TQJson.Parse(p: PWideChar; l: Integer);
begin
if ParseObject(p,l)<0 then
  raise Exception.Create(FLastError);
end;

procedure TQJson.Parse(const s: QStringW);
begin
Parse(PQCharW(S),Length(S));
end;

procedure TQJson.ParseJsonToken(var p: PQCharW; ADelimiters: PQCharW;
  var AResult: QStringW);
var
  ps:PQCharW;
  procedure DecodeQuotedToken;
  var
    pd,pds:PQCharW;
    l:Integer;
    S:QStringW;
  begin
  ps:=p;
  Inc(p);
  l:=1024;
  SetLength(S,l);//Ĭ�ϻ����С
  pd:=PQCharW(S);
  pds:=pd;
  while p^<>#0 do
    begin
    if p^='\' then
      begin
      if p[1]=ps^ then
        begin
        pd^:=ps^;
        Inc(p,2);
        Inc(pd);
        end
      else
        begin
        pd[0]:=p[0];
        pd[1]:=p[1];
        Inc(p,2);
        Inc(pd,2);
        end;
      end
    else if p^=ps^ then
      begin
      if p[1]=ps^ then
        begin
        pd^:=ps^;
        Inc(p,2);
        Inc(pd);
        end
      else
        begin
        Inc(p);
        Break;
        end;
      end
    else
      begin
      pd^:=p^;
      Inc(p);
      Inc(pd);
      end;
    if pd-pds=l then
      begin
      SetLength(S,l shl 1);
      pds:=PQCharW(S);
      pd:=pds+l;
      l:=(l shl 1);
      end;
    end;
  SetLength(S,pd-pds);
  JsonUnescape(PQCharW(S),Length(S),AResult);
  end;
begin
//������������
if (p^='"') or (p^='''') then
  DecodeQuotedToken
else
  begin
  ps:=p;
  while p^<>#0 do
    begin
    if CharInW(p,ADelimiters) then
      Break
    else
      Inc(p);
    end;
  JsonUnescape(ps,p-ps,AResult);
  end;
SkipSpaceW(p);
end;

procedure TQJson.ParseName(var p: PQCharW; var AName: QStringW);
begin
if (p^<>'"') and StrictJson then
  begin
  SetLastError(Format(SCharNeeded,['"',Copy(p,0,10)+'...']),p);
  AName:='';
  end
else
  begin
  ParseJsonToken(p,':',AName);
  if Length(AName)=0 then
    SetLastError(SNameNotFound,p);
  end;
end;

procedure TQJson.ParseNumeric(var p: PQCharW; var AType: TQJsonDataType;
  var AValue: QStringW);
var
  AInt:Int64;
  AFloat:Double;
  ps:PQCharW;
  S:QStringW;
const
  JsonBreaks:PWideChar=',]} '#9#10#13;
begin
SkipSpaceW(p);
ps:=p;
SkipUntilW(p,JsonBreaks);
S:=Copy(ps,0,p-ps);
if TryStrToInt64(S,AInt) then
  begin
  AType:=jdtInteger;
  SetLength(AValue,SizeOf(Int64) shr 1);
  PInt64(PWideChar(AValue))^:=AInt;
  end
else
  begin
  if TryStrToFloat(S,AFloat) then
    begin
    AType:=jdtFloat;
    SetLength(AValue,SizeOf(Double) shr 1);
    PDouble(AValue)^:=AFloat;
    end
  else
    begin
    AType:=jdtUnknown;
    SetLength(AValue,0);
    SetLastError(Format(SBadNumeric,[S]),p);
    end;
  end;
end;

function TQJson.ParseObject(var p: PQCharW;len:Integer): Integer;
var
  AChild:TQJson;
  ACloseNeeded:Boolean;
  AEndChar:QCharW;
const
  SpaceWithSemicolon:PWideChar=': '#9#10#13#$3000;
  CommaWithSpace:PWideChar=', '#9#10#13#$3000;
  JsonEndChars:PWideChar=',}]';
  JsonComplexEnd:PWideChar='}]';
begin
Result:=0;
FSourceStart:=p;
ArrayNeeded(jdtObject);
Clear;
SkipSpaceW(p);
ACloseNeeded:=False;
if DataType=jdtArray then
  begin
  AEndChar:=']';
  if p^='[' then
    begin
    Inc(p);
    SkipSpaceW(p);
    ACloseNeeded:=True;
    end;
  end
else
  begin
  AEndChar:='}';
  if p^='{' then
    begin
    Inc(p);
    SkipSpaceW(p);
    ACloseNeeded:=True;
    end;
  end;
while (p^<>#0) and (p^<>AEndChar) and (Result>=0) do
  begin
  AChild:=TQJson.Create;
  AChild.FSourceStart:=FSourceStart;
  AChild.FParent:=Self;
  if DataType=jdtObject then
    begin
    ParseName(p,AChild.FName);
    if Length(AChild.FName)=0 then
      begin
      {$IFDEF QDAC_UNICODE}
      AChild.DisposeOf;
      {$ELSE}
      AChild.Free;
      {$ENDIF}
      Result:=-1;
      Break;
      end;
    SkipCharW(p,SpaceWithSemicolon);//�������ܴ��ڵĿհ�
    end;
  case p^ of
    '"',''''://�ַ���,JSON��׼ֻ֧��˫����,�����ַǹ����JSONʹ�õ�����
      begin
      ParseValue(p,AChild.FValue);
      if CharInW(p,JsonEndChars) then
        begin
        AChild.FDataType:=jdtString;
        FItems.Add(AChild);
        Inc(Result);
        SkipCharW(p,CommaWithSpace);
        end
       else//!(,}])
        begin
        SetLastError(Format(SCharNeeded,[',]}',Copy(p,0,10)+'...']),p);
        {$IFDEF QDAC_UNICODE}
        AChild.DisposeOf;
        {$ELSE}
        AChild.Free;
        {$ENDIF}
        Result:=-1;
        Break;
        end;
      end;
    '{'://�����Ӷ���
      begin
      if AChild.ParseObject(p)<0 then
        begin
        SetLastError(AChild.FLastError,p);
        {$IFDEF QDAC_UNICODE}
        AChild.DisposeOf;
        {$ELSE}
        AChild.Free;
        {$ENDIF}
        Result:=-1;
        Break;
        end;
      if CharInW(p,JsonEndChars) then
        begin
        if p^=',' then
          begin
          Inc(p);
          SkipSpaceW(p);
          end;
        FItems.Add(AChild);
        Inc(Result);
        end
      else//!(,}])
        begin
        SetLastError(Format(SCharNeeded,[',]}',Copy(p,0,10)+'...']),p);
        {$IFDEF QDAC_UNICODE}
        AChild.DisposeOf;
        {$ELSE}
        AChild.Free;
        {$ENDIF}
        Result:=-1;
        Break;
        end;
      end;
    '[':
      begin
      AChild.ArrayNeeded(jdtArray);
      if AChild.ParseObject(p)<0 then
        begin
        SetLastError(AChild.FLastError,p);
        {$IFDEF QDAC_UNICODE}
        AChild.DisposeOf;
        {$ELSE}
        AChild.Free;
        {$ENDIF}
        Result:=-1;
        Break;
        end
      else
        begin
        FItems.Add(AChild);
        if p^=',' then
          SkipCharW(p,CommaWithSpace)
        else if not CharInW(p,JsonComplexEnd) then
          begin
          SetLastError(Format(SCharNeeded,[',]}',Copy(p,0,10)+'...']),p);
          Result:=-1;
          Break;
          end;
        end
      end;
    '/'://ע��
      begin
      if not StrictJson then
        begin
        if p[1]='*' then//��ע��
          begin
          Inc(p,2);
          while p^<>#0 do
            begin
            if (p^='*') and (p[1]='/') then
              begin
              Inc(p,2);
              SkipSpaceW(p);
              Break;
              end
            else
            Inc(p);
            end;
          end
        else if p[1]='/' then //��ע��
          begin
          Inc(p,2);
          SkipUntilW(p,[WideChar(10)]);
          SkipSpaceW(p);
          end
        else
          begin
          Result:=-1;
          SetLastError(Format(SBadChar,['/']),p);
          end;
        end
      else
        begin
        Result:=-1;
        SetLastError(SCommentNotSupport,p);
        end;
      end
   else
    begin
    ParseReserved(p,AChild.FDataType,AChild.FValue);
    if AChild.FDataType=jdtUnknown then
      begin
      {$IFDEF QDAC_UNICODE}
      AChild.DisposeOf;
      {$ELSE}
      AChild.Free;
      {$ENDIF}
      Result:=-1;
      end
    else
      begin
      FItems.Add(AChild);
      Inc(Result);
      if p^=',' then
        SkipCharW(p,CommaWithSpace);
      end;
    end;
  end;
  end;
if Result=-1 then
  begin
  SetLastError(SBadJson,p);
  Clear;
  end
else if ACloseNeeded then
  begin
  if p^=AEndChar then
    begin
    Inc(p);
    SkipSpaceW(p);
    end
  else
    begin
    Clear;
    Result:=-1;
    SetLastError(Format(SCharNeeded,['}',p]),p);
    end;
  end;
end;

procedure TQJson.ParseReserved(var p: PQCharW; var AType: TQJsonDataType;
  var AValue: QStringW);
const
  DecChars:PWideChar='01234567899+-.';  
  procedure CheckEnd;
  const
    JsonEndChars:PWideChar=',]}';
  begin
  SkipSpaceW(p);
  if p^<>#0 then
    begin
    if not CharInW(p,JsonEndChars) then
      begin
      AValue:='';
      AType:=jdtUnknown;
      SetLastError(Format(SCharNeeded,[',]}',Copy(p,0,10)+'...']),p);
      end;
    end;
  end;
  procedure DoUnexpect;
  begin
  AType:=jdtUnknown;
  AValue:='';
  SetLastError(Format(SBadChar,[Copy(p,0,10)+'...']),p);
  end;
begin
case p^ of
  't','T':
    begin
    if StrIStrW(p,'TRUE')=p then
      begin
      SetLength(AValue,SizeOf(Boolean));
      AType:=jdtBoolean;
      PBoolean(AValue)^:=True;
      Inc(p,4);
      CheckEnd;
      end
    else
      DoUnexpect;
    end;
  'f','F':
    begin
    if StrIStrW(p,'FALSE')=p then
      begin
      SetLength(AValue,SizeOf(Boolean));
      PBoolean(AValue)^:=False;
      Inc(p,5);
      AType:=jdtBoolean;
      CheckEnd;
      end
    else
      DoUnexpect;
    end;
  'n','N':
    begin
    if StrIStrW(p,'NULL')=p then
      begin
      Inc(p,4);
      SkipSpaceW(p);
      SetLength(AValue,0);
      AType:=jdtNull;
      CheckEnd;
      end
    else
      DoUnexpect;
    end
  else
    begin
    if CharInW(p,DecChars) then
      begin
      ParseNumeric(p,AType,AValue);
      if AType<>jdtUnknown then
        CheckEnd;
      end
    else//������JSON�����ָ�ʽ
      DoUnexpect;
    end;
end;
end;

procedure TQJson.ParseValue(var p: PQCharW; var AValue: QStringW);
begin
ParseJsonToken(p,',} '#9#10#13,AValue);
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
  {$IFDEF QDAC_UNICODE}
  AStream.DisposeOf;
  {$ELSE}
  AStream.Free;
  {$ENDIF}
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
FSourceStart:=p;
ParseObject(p,Length(Value));
end;

procedure TQJson.SetAsBoolean(const Value: Boolean);
begin
DataType:=jdtBoolean;
PBoolean(FValue)^:=Value;
end;

procedure TQJson.SetAsDateTime(const Value: TDateTime);
begin
SetAsString(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz',Value));
end;

procedure TQJson.SetAsFloat(const Value: Double);
begin
DataType:=jdtFloat;
PDouble(FValue)^:=Value;
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

procedure TQJson.SetAsObject(const Value: QStringW);
begin
Parse(PQCharW(Value),Length(Value));
end;

procedure TQJson.SetAsString(const Value: QStringW);
begin
DataType:=jdtString;
FValue:=Value;
end;

procedure TQJson.SetAsVariant(const Value: Variant);
var
  I:Integer;
begin
if VarIsArray(Value) then
  begin
  ArrayNeeded(jdtArray);
  //Ŀǰʵ��ֻ֧��һά����
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
      {$IFDEF QDAC_UNICODE}
      FItems.DisposeOf;
      {$ELSE}
      FItems.Free;
      {$ENDIF}
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
    jdtFloat:
      begin
      SetLength(FValue,SizeOf(Double) shr 1);
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

procedure TQJson.SetLastError(const AMsg: QStringW; pc: PQCharW);
var
  ALineNo,AColNo:Integer;
  ALine:QStringW;
  pl:PQCharW;
begin
pl:=StrPosW(FSourceStart,pc,AColNo,ALineNo);
ALine:=DecodeLineW(pl);
FLastError:=Format(SErrorOnLine,[ALineNo,AColNo,AMsg,ALine]);
end;

procedure TQJson.SetValue(const Value: QStringW);
var
  p:PQCharW;
  V:QStringW;
  ADataType:TQJsonDataType;
begin
if DataType = jdtString then
  FValue:=Value
else if DataType=jdtBoolean then
  AsBoolean:=StrToBool(Value)
else
  begin
  p:=PQCharW(Value);
  if DataType in [jdtInteger,jdtFloat] then
    begin
    ParseNumeric(p,ADataType,V);
    if ADataType=jdtNull then
      raise Exception.Create(Format(SBadNumeric,[Value]));
    end
  else if DataType in [jdtArray,jdtObject] then
    begin
    Clear;
    if ParseObject(p)<0 then
      raise Exception.Create(SBadJson);
    end;
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
          {�󶨶�������Ժ���};
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
        {$ENDIF}
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
AssignProp(Self,AObject);
end;

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
end.

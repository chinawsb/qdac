unit qstring;
{$I 'qdac.inc'}

interface

{$REGION 'History'}
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
  2018.04.14
  ===========
  + ���� DateTimeFromString ������ת���ַ�������ʱ��ֵ�� TDateTime

  2017.1.23
  ==========
  * ������ UrlEncode����ʱû�ж�����ת���ַ�����ռ������
  + ���� UrlDecode ����������Url�ĸ�����ɲ���

  2016.11.24
  ==========
  * �Ż��˺��� HTMLUnescape ��Ч��

  2016.11.12
  ==========
  + DeleteSideCharsW ����ɾ�����ߵ��ض��ַ�

  2016.9.29
  ==========
  - ɾ�� RightStrCountW ����
  + ���� RightPosW �������������ַ����������Ҳ����ʼλ�ã���ľ���飩

  2016.9.21
  ==========
  * ������ HashOf �ڼ��㳤��Ϊ0������ʱ����AV��������⣨QQ���棩

  2016.8.23
  ==========
  * ������DecodeChineseId���֤���а���Сд x ʱ�����������
  + ���� JavaEscape �� JavaUnescape ��ת��/��ת Java �ַ���
  + ���� IsOctChar �����ָ�����ַ��Ƿ���8����������ַ�

  2016.7.16
  ==========
  + ���� FreeAndNilObject ��������� FreeAndNil

  2016.6.13
  ==========
  + ���� MemComp �������ڱȽ������ڴ���ֵ����ͬ�� BinaryCmp������Ҫ�������ڴ��ȳ�

  2016.6.3
  ==========
  + ���� IsHumanName/IsChineseName/IsNoChineseName/IsChineseAddr/IsNoChineseAddr ����

  2016.5.27
  ==========
  * ���������֤�ż�����ƶ�ƽ̨�������ַ����������������������

  2016.5.24
  ==========
  * ������TQStringCatHelperW.SetDest ���õ�ַʱδ��������߽������

  2016.3.21
  ==========
  * ������ StrIStrA �㷨���󣨰�ľ���棩
  + ������ PosA ��������ľ���飩
  + QStringA ���� UpperCase/LowerCase����
  2016.2.26
  ==========
  + ���� IsEmailAddr �������������ʽ
  + ����IsChineseMobile ������ֻ������ʽ

  2016.2.25
  ==========
  + ���� IsChineseIdNo �������ж����֤�ŵ���Ч�ԣ�������֤����������֤��
  + ���� DecodeChineseId ���������֤�ŵĸ�����ɲ�������

  2015.11.22
  ==========
  * ������PosW ���� AStartPos ����ʱû�п��Ǻ�һ�����ض�ʧAStartPos���������⣨��ľ���棩

  2015.11.18
  ==========
  * ������MemScan���Ǽ�Сlen_s���������⣨TTT���棩
  2015.11.10
  ==========
  + �������ҽ����д���� CapMoney
  + ������ת������ SimpleChineseToTraditional �� TraditionalChineseToSimple

  2015.9.26
  =========
  * ������ParseDateTime�ڽ��� "n-nxxx" ����������ʱ���󷵻�true�����⣨�������棩
  2015.9.2
  =========
  * ������ AnsiEncode �� 2007 �����ڱ�������Bug����������⣨�ǿձ��棩

  2015.8.28
  =========
  * �ϲ� InternalInsert �Ĵ��뵽 Insert
  * ������ Clear ��û������ʱ�����²���Ԫ��ʱҳ���쳣���������⣨�����������棩
  * ������ Pack ������ Clear ������ʱ��������⣨���屨�棩
  + ��������������ģʽ�� Insert ��������
  + �����������ģʽ�� Add ��������
  2015.8.27
  =========
  * ������ TQPagedList.Pack ���������������ȷ�����⣨�����������棩

  2015.8.26
  =========
  * ������ TQPagedList.Insert ����λ��С��0ʱ���������(�����������棩
  * �Ż��� TQPagedList.Add �Ĵ��룬�ĳ�ֱ�ӵ���InternalInsert(�����������飩

  2015.8.11
  =========
  * ������ HTMLUnescape ��ת�������ַ�ʱ��������⣨�����б��棩
  2015.7.15
  =========
  * ���� qsl �Ĺ�ϣ���Խ������ HashOf �����㷨��Ϊ BKDR ����Windowsƽ̨��ʹ�û��
  ������Ч�ʣ���лqsl��
  2015.6.6
  =========
  * ������ Utf8Decode ʱ��0x10000+��Χ���ַ�����ʱ��λ���󣨸�лqsl��
  2015.5.29
  =========
  * ������ TQPagedStream �ڵͰ汾��IDE���޷����������

  2015.5.25
  =========
  + TQPagedStream ���룬����д����ڴ�������ʱ���TMemoryStream

  2015.5.22
  =========
  * ������ ParseNumeric �� ParseInt ʱ���������ʾ��Χ����ֵ����ʽ
  2015.5.21
  =========
  * ������ StringReplaceWithW �� AWithTag Ϊ True ʱ�������ȷ�����⣨�����ٷʱ��棩
  * ������ StringReplaceWithW ���滻�Ľ���ַ���Ϊ��ʱ��������Ч��ַ�����⣨�����ٷʱ��棩
  2015.5.20
  =========
  + StringReplaceW ������һ�����أ������滻�ַ����е�ĳһ����Ϊ�ض��ַ���һ�����ڲ����������ݵ�����
  * �Ƴ�һ��Hint
  2015.5.8
  =========
  * �޸� TQPtr ��ʵ�֣��������ͷ��¼�����ͨ���¼�ʹ��ͬһ������
  + DecodeText �������ڴ���ֱ�Ӽ����벢����Unicode������ַ���

  2015.4.17
  =========
  * �Ż���UTFEncode��ռ���ڴ���������
  2015.4.8
  =========
  * ������ParseNumeric �ڽ��� -0.xx ���������ַ��ų�������⣨��лYZ���棩
  2015.4.1
  =========
  * ������TQStringCatHelper������Ҫ�Ļ���������ʱ�жϴ�������⣨��лetarelecca���棩
  2015.3.9
  =========
  * �޸� NaturalCompareW �����������Ƿ���Ե��հ��ַ�ѡ��ں���ʱA 10 �� A10 ������Ϊһ�µĽ��
  2015.3.5
  =========
  + ���� PosW���ȼ���ϵͳ��Pos�� �Ͱ���Ȼ���������� NaturalCompareW
  2015.2.9
  =========
  + ���� FilterCharW �� FilterNoNumberW ��������

  2015.1.27
  =========
  * ������TQPtr.Bind �����������ڴ���û�б��������

  2015.1.26
  ==========
  + TQPtr �������� Bind ����������
  + ����ȫ�ֱ��� IsFMXApp ����⵱ǰ�Ƿ��� FMX ��Ӧ�ó���

  2014.11.10
  =========
  * ������XE3����ʱTSystemTimes������Ч������

  2014.11.5
  =========
  * QStringA��From�����޸ķ���ֵ���Ͳ�����һ������
  + QStringA����Cat����
  + CharCodeA/CharCodeU/CharCodeW�����ָ��λ�õ��ַ�����ֵ

  2014.9.26
  =========
  * ��TThreadId���Ͷ�����QWorker���뱾��Ԫ
  2014.9.11
  =========
  * ������LoadTextA/LoadTextW���ش���BOMͷ�Ŀյ�Utf8��ʱ���������
  2014.8.20
  =========
  + StringReplaceWithW�����������滻һ���ǩ�е����ݣ�����ң�
  2014.8.15
  =========
  * ������֤��TQBytesCatHelper�����2007�����޷�ͨ��������(��������������沢��֤)
  + PQStringA���Ͷ���

  2014.8.14
  =========
  * ������TQBytesCatHelper.NeedSize������Delphi2007���޷����������(����С�ױ��沢�ṩ�޸�)
  2014.8.5
  ========
  * BinToHex����ALowerCase��������֧��ʹ��Сд��ʮ�����Ʊ�ʾ��ʽ
  2014.8.1
  =========
  + ��������SameCharsA/U/W������ͬ���ַ�����EndWithA/U/W�ж��Ƿ���ָ�����ַ�����β
  2014.7.17
  =========
  + ����BinaryCmp���������ڵȼ���C�е�memcmp����
  2014.7.16
  =========
  + ����MemScan����������ָ�����ڴ������в���ָ�����ֽ�����
  2014.7.12
  =========
  * ������DecodeLineU�еݹ�����Լ��Ĵ���(����С�ױ���)
  * ������CharCountU����ַ����ʱ��˫�ֽ�Utf8����ļ�����
  2014.7.10
  =========
  + �������º�����StringReplicateW,NameOfW,ValueOfW,IndexOfNameW,IndexOfValueW

  2014.6.26
  =========
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.21
  ==========
  * ������C++ Builder�б��������
  2014.6.19
  ==========
  * ������QuotedStr���ڳ���Ϊ0���ַ���������������
}
{$ENDREGION 'History'}

uses classes, sysutils, types{$IF RTLVersion>=21},
  Rtti{$IFEND >=XE10}{$IFNDEF MSWINDOWS},
  syncobjs{$ENDIF}
{$IFDEF MSWINDOWS}
    , windows
{$ENDIF}
{$IFDEF POSIX}
    , Posix.String_, Posix.Time, Posix.SysTypes
{$ENDIF}
{$IFDEF ANDROID}
    , Androidapi.Log
{$ENDIF}
{$IFDEF IOS}
    , iOSapi.Foundation, Macapi.Helpers, Macapi.ObjectiveC
{$ENDIF}
    ;
{$HPPEMIT '#pragma link "qstring"'}
{$HPPEMIT 'template<class T>'}
{$HPPEMIT 'bool __fastcall HasInterface(IUnknown *AIntf, DelphiInterface<T> &AResult)'}
{$HPPEMIT '{'}
{$HPPEMIT 'T *ATemp;'}
{$HPPEMIT 'if (AIntf&&(AIntf->QueryInterface(__uuidof(T), (void **)&ATemp) == S_OK))'}
{$HPPEMIT '{'}
{$HPPEMIT '  AResult = ATemp;'}
{$HPPEMIT '  ATemp->Release();'}
{$HPPEMIT '  return true;'}
(*$HPPEMIT '}'*)
{$HPPEMIT 'return false;'}
(*$HPPEMIT '}'*)
{$HPPEMIT 'template < class T > bool __fastcall HasInterface(TObject * AObject, DelphiInterface<T> &AResult)'}
{$HPPEMIT '{'}
{$HPPEMIT 'T *ATemp = NULL;'}
{$HPPEMIT 'if (AObject&&(AObject->GetInterface(__uuidof(T), &ATemp)))'}
{$HPPEMIT '{'}
{$HPPEMIT '  AResult = ATemp;'}
{$HPPEMIT '  ATemp->Release();'}
{$HPPEMIT '  return true;'}
(*$HPPEMIT '}'*)
{$HPPEMIT 'return false;'}
(*$HPPEMIT '}'*)
{$HPPEMIT 'template<class T>'}
{$HPPEMIT 'DelphiInterface<T> __fastcall ToInterface(TObject *AObject)'}
{$HPPEMIT '{'}
{$HPPEMIT 'DelphiInterface<T> ARetVal;'}
{$HPPEMIT 'HasInterface(AObject, ARetVal);'}
{$HPPEMIT 'return ARetVal;'}
(*$HPPEMIT '}'*)
{$HPPEMIT 'template<class T>'}
{$HPPEMIT 'DelphiInterface<T> __fastcall ToInterface(IUnknown *AIntf)'}
{$HPPEMIT '{'}
{$HPPEMIT 'DelphiInterface<T> ARetVal;'}
{$HPPEMIT 'HasInterface(AIntf, ARetVal);'}
{$HPPEMIT 'return ARetVal;'}
(*$HPPEMIT '}'*)

const
  MC_NUM = $01; // ��ʾ����
  MC_UNIT = $02; // ��ʾ��λ
  MC_HIDE_ZERO = $04; // ���������ֵ
  MC_MERGE_ZERO = $08; // �ϲ��м����ֵ
  MC_END_PATCH = $10; // ���ڲ��Էֽ���ʱ����AEndTextָ����ֵ
  MC_READ = MC_NUM or MC_UNIT or MC_HIDE_ZERO or MC_MERGE_ZERO or MC_END_PATCH;
  // ������ȡ��ʽ
  MC_PRINT = MC_NUM or MC_HIDE_ZERO; // �����״���ʽ

type
{$IFDEF UNICODE}
  QStringW = UnicodeString;
{$ELSE}
  QStringW = WideString;
{$ENDIF UNICODE}
{$IF RTLVersion<25}
  IntPtr = Integer;
  IntUPtr = Cardinal;
  UIntPtr = Cardinal;
  NativeInt = Integer;
{$IFEND IntPtr}
{$IF RTLVersion>=21}
  TValueArray = TArray<TValue>;
  TIntArray = TArray<Integer>;
  TInt64Array=TArray<Int64>;
  TFloatArray=TArray<Double>;
  TQStringArray = TArray<QStringW>;
{$ELSE}
  TIntArray = array of Integer;
  TQStringArray = array of QStringW;
{$IFEND >=2010}
  // {$IF RTLVersion<=18}
  // DWORD_PTR = DWORD;
  // ULONGLONG = Int64;
  // TBytes = array of Byte;
  // PPointer = ^Pointer;
  // {$IFEND}
{$IF RTLVersion<22}
  TThreadId = Longword;
{$IFEND}
  PIntPtr = ^IntPtr;
  QCharA = Byte;
  QCharW = WideChar;
  PQCharA = ^QCharA;
  PPQCharA = ^PQCharA;
  PQStringA = ^QStringA;
  PQCharW = PWideChar;
  PPQCharW = ^PQCharW;
  PQStringW = ^QStringW;
  TTextEncoding = (teUnknown, { δ֪�ı��� }
    teAuto, { �Զ���� }
    teAnsi, { Ansi���� }
    teUnicode16LE, { Unicode LE ���� }
    teUnicode16BE, { Unicode BE ���� }
    teUTF8 { UTF8���� }
    );
{$HPPEMIT '#define DELPHI_ANON(AType,Code,AVar) \'}
{$HPPEMIT '  class AType##AVar:public TCppInterfacedObject<AType>\'}
(*$HPPEMIT '  {\'*)
{$HPPEMIT '  public:\'}
{$HPPEMIT '    void __fastcall Invoke##Code\'}
(*$HPPEMIT '  } *AVar=new AType##AVar'*)

  // ��A��β��ΪAnsi����֧�ֵĺ�������U��β����Utf8����֧�ֵĺ�������W��β��ΪUCS2
  QStringA = record
  private
    FValue: TBytes;
    function GetChars(AIndex: Integer): QCharA;
    procedure SetChars(AIndex: Integer; const Value: QCharA);
    function GetLength: Integer;
    procedure SetLength(const Value: Integer);
    function GetIsUtf8: Boolean;
    function GetData: PByte;
    procedure SetIsUtf8(const Value: Boolean);
  public
    class operator Implicit(const S: QStringW): QStringA;
    class operator Implicit(const S: QStringA): PQCharA;
    class operator Implicit(const S: QStringA): TBytes;
    class operator Implicit(const ABytes: TBytes): QStringA;
    class operator Implicit(const S: QStringA): QStringW;
    class operator Implicit(const S: PQCharA): QStringA;
{$IFNDEF NEXTGEN}
    class operator Implicit(const S: AnsiString): QStringA;
    class operator Implicit(const S: QStringA): AnsiString;
{$ENDIF}
    class function UpperCase(S: PQCharA): QStringA; overload; static;
    class function LowerCase(S: PQCharA): QStringA; overload; static;
    class function Create(const p: PQCharA; AIsUtf8: Boolean): QStringA; static;
    function UpperCase: QStringA; overload;
    function LowerCase: QStringA; overload;
    // �ַ����Ƚ�
    function From(p: PQCharA; AOffset, ALen: Integer): PQStringA; overload;
    function From(const S: QStringA; AOffset: Integer = 0): PQStringA; overload;
    function Cat(p: PQCharA; ALen: Integer): PQStringA; overload;
    function Cat(const S: QStringA): PQStringA; overload;
    property Chars[AIndex: Integer]: QCharA read GetChars
      write SetChars; default;
    property Length: Integer read GetLength write SetLength;
    property IsUtf8: Boolean read GetIsUtf8 write SetIsUtf8;
    property Data: PByte read GetData;
  end;

  TQSingleton{$IFDEF UNICODE}<T: class>{$ENDIF} = record
    InitToNull: {$IFDEF UNICODE}T{$ELSE}Pointer{$ENDIF};

  type
{$IFDEF UNICODE}
    TGetInstanceCallback = reference to function: T;
{$ELSE}
    TGetInstanceCallback = function: Pointer;
{$ENDIF}
  function Instance(ACallback: TGetInstanceCallback):
{$IFDEF UNICODE}T{$ELSE}Pointer{$ENDIF};
  end;

  QException = class(Exception)

  end;

  // �ַ���ƴ����
  TQStringCatHelperW = class
  private
    FValue: array of QCharW;
    FStart, FDest, FLast: PQCharW;
    FBlockSize: Integer;
{$IFDEF DEBUG}
    FAllocTimes: Integer;
{$ENDIF}
    FSize: Integer;
    function GetValue: QStringW;
    function GetPosition: Integer; inline;
    procedure SetPosition(const Value: Integer);
    procedure NeedSize(ASize: Integer);
    function GetChars(AIndex: Integer): QCharW;
    function GetIsEmpty: Boolean; inline;
    procedure SetDest(const Value: PQCharW);
  public
    constructor Create; overload;
    constructor Create(ASize: Integer); overload;
    procedure LoadFromFile(const AFileName: QStringW);
    procedure LoadFromStream(const AStream: TStream);
    procedure IncSize(ADelta: Integer);
    function Cat(p: PQCharW; len: Integer; AQuoter: QCharW = #0)
      : TQStringCatHelperW; overload;
    function Cat(const S: QStringW; AQuoter: QCharW = #0)
      : TQStringCatHelperW; overload;
    function Cat(c: QCharW): TQStringCatHelperW; overload;
    function Cat(const V: Int64;const AsHexStr:Boolean=false): TQStringCatHelperW; overload;
    function Cat(const V: Double): TQStringCatHelperW; overload;
    function Cat(const V: Boolean): TQStringCatHelperW; overload;
    function Cat(const V: Currency): TQStringCatHelperW; overload;
    function Cat(const V: TGuid): TQStringCatHelperW; overload;
    function Cat(const V: Variant): TQStringCatHelperW; overload;
    function Cat(const V: TDateTime; const AFormat: String;
      AQuoter: QCharW = #0): TQStringCatHelperW; overload;
    function Replicate(const S: QStringW; count: Integer): TQStringCatHelperW;
    function Back(ALen: Integer): TQStringCatHelperW;
    function BackIf(const S: PQCharW): TQStringCatHelperW;
    procedure TrimRight;
    procedure Reset;
    function EndWith(const S: QStringW; AIgnoreCase: Boolean): Boolean;
    function ToString: QStringW; {$IFDEF UNICODE}override; {$ENDIF}
    property Value: QStringW read GetValue;
    property Chars[AIndex: Integer]: QCharW read GetChars;
    property Start: PQCharW read FStart;
    property Current: PQCharW read FDest write SetDest;
    property Last: PQCharW read FLast;
    property Position: Integer read GetPosition write SetPosition;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TQBytesCatHelper = class
  private
    FValue: TBytes;
    FStart, FDest: PByte;
    FBlockSize: Integer;
    FSize: Integer;
    function GetBytes(AIndex: Integer): Byte;
    function GetPosition: Integer;
    procedure SetPosition(const Value: Integer);
    procedure NeedSize(ASize: Integer);
    procedure SetCapacity(const Value: Integer);
    function GetValue: TBytes;
  public
    constructor Create; overload;
    constructor Create(ASize: Integer); overload;
    function Cat(const V: Byte): TQBytesCatHelper; overload;
    function Cat(const V: Shortint): TQBytesCatHelper; overload;
    function Cat(const V: Word): TQBytesCatHelper; overload;
    function Cat(const V: Smallint): TQBytesCatHelper; overload;
    function Cat(const V: Cardinal): TQBytesCatHelper; overload;
    function Cat(const V: Integer): TQBytesCatHelper; overload;
    function Cat(const V: Int64): TQBytesCatHelper; overload;
{$IFNDEF NEXTGEN}
    function Cat(const V: AnsiChar): TQBytesCatHelper; overload;
    function Cat(const V: AnsiString): TQBytesCatHelper; overload;
{$ENDIF}
    function Cat(const V: QStringA; ACStyle: Boolean = false)
      : TQBytesCatHelper; overload;
    function Cat(const c: QCharW): TQBytesCatHelper; overload;
    function Cat(const S: QStringW): TQBytesCatHelper; overload;
    function Cat(const ABytes: TBytes): TQBytesCatHelper; overload;
    function Cat(const AData: Pointer; const ALen: Integer)
      : TQBytesCatHelper; overload;
    function Cat(const V: Single): TQBytesCatHelper; overload;
    function Cat(const V: Double): TQBytesCatHelper; overload;
    function Cat(const V: Boolean): TQBytesCatHelper; overload;
    function Cat(const V: Currency): TQBytesCatHelper; overload;
    function Cat(const V: TGuid): TQBytesCatHelper; overload;
    function Cat(const V: Variant): TQBytesCatHelper; overload;
    function Replicate(const ABytes: TBytes; ACount: Integer): TQBytesCatHelper;
    function Back(ALen: Integer): TQBytesCatHelper;
    function Insert(AIndex: Cardinal; const AData: Pointer; const ALen: Integer)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Byte): TQBytesCatHelper;
      overload;
    function Insert(AIndex: Cardinal; const V: Shortint)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Word): TQBytesCatHelper;
      overload;
    function Insert(AIndex: Cardinal; const V: Smallint)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Cardinal)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Integer)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Int64)
      : TQBytesCatHelper; overload;
{$IFNDEF NEXTGEN}
    function Insert(AIndex: Cardinal; const V: AnsiChar)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: AnsiString)
      : TQBytesCatHelper; overload;
{$ENDIF}
    function Insert(AIndex: Cardinal; const V: QStringA;
      ACStyle: Boolean = false): TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const c: QCharW)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const S: QStringW)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const ABytes: TBytes)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Single)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Double)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Boolean)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Currency)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: TGuid)
      : TQBytesCatHelper; overload;
    function Insert(AIndex: Cardinal; const V: Variant)
      : TQBytesCatHelper; overload;
    function Delete(AStart: Integer; ACount: Cardinal): TQBytesCatHelper;
    procedure Reset;
    property Value: TBytes read GetValue;
    property Bytes[AIndex: Integer]: Byte read GetBytes;
    property Start: PByte read FStart;
    property Current: PByte read FDest;
    property Position: Integer read GetPosition write SetPosition;
    property Capacity: Integer read FSize write SetCapacity;
  end;

  IQPtr = interface(IInterface)
    ['{E5B28F92-CA81-4C01-8766-59FBF4E95F05}']
    function Get: Pointer;
  end;

  TQPtrFreeEvent = procedure(AData: Pointer) of object;
  PQPtrFreeEvent = ^TQPtrFreeEvent;
  TQPtrFreeEventG = procedure(AData: Pointer);
{$IFDEF UNICODE}
  TQPtrFreeEventA = reference to procedure(AData: Pointer);
  PQPtrFreeEventA = ^TQPtrFreeEventA;
{$ENDIF}

  TQPtrFreeEvents = record
    case Integer of
      0:
        (Method: TMethod);
      1:
        (OnFree: {$IFNDEF NEXTGEN}TQPtrFreeEvent{$ELSE}Pointer{$ENDIF});
      2:
        (OnFreeG: TQPtrFreeEventG);
      3:
        (OnFreeA: Pointer);
  end;

  TQPtr = class(TInterfacedObject, IQPtr)
  private
    FObject: Pointer;
    FOnFree: TQPtrFreeEvents;
  public
    constructor Create(AObject: Pointer); overload;
    destructor Destroy; override;
    class function Bind(AObject: TObject): IQPtr; overload;
    class function Bind(AData: Pointer; AOnFree: TQPtrFreeEvent)
      : IQPtr; overload;
    class function Bind(AData: Pointer; AOnFree: TQPtrFreeEventG)
      : IQPtr; overload;
{$IFDEF UNICODE}
    class function Bind(AData: Pointer; AOnFree: TQPtrFreeEventA)
      : IQPtr; overload;
{$ENDIF}
    function Get: Pointer;
  end;
{$IF RTLVersion<=23}

  TDirection = (FromBeginning, FromEnd);
  TPointerList = array of Pointer;
{$ELSE}
  // TDirection = System.Types.TDirection;
{$IFEND}

  // TQPagedList - ��ҳʽ�б��������ڼ�¼�б�
  TQListPage = class
  protected
    FStartIndex: Integer; // ��ʼ����
    FUsedCount: Integer; // ʹ�õ�ҳ�����
    FItems: array of Pointer;
  public
    constructor Create(APageSize: Integer);
    destructor Destroy; override;
  end;

  TQPagedListSortCompare = procedure(p1, p2: Pointer; var AResult: Integer)
    of object;
  TQPagedListSortCompareG = procedure(p1, p2: Pointer; var AResult: Integer);
{$IFDEF UNICODE}
  TQPagedListSortCompareA = reference to procedure(p1, p2: Pointer;
    var AResult: Integer);
  PQPagedListSortCompareA = ^TQPagedListSortCompareA;
{$ENDIF}
  TQPagedList = class;

  TQPagedListEnumerator = class
  private
    FIndex: Integer;
    FList: TQPagedList;
  public
    constructor Create(AList: TQPagedList);
    function GetCurrent: Pointer; inline;
    function MoveNext: Boolean;
    property Current: Pointer read GetCurrent;
  end;

  TQPagedList = class
  protected
    FPages: array of TQListPage; // ҳ���б�
    FPageSize: Integer; // ÿҳ��С
    FCount: Integer; // ����
    FLastUsedPage: Integer; // ���һ������ʹ�õ�ҳ������(����0)
    FFirstDirtyPage: Integer; // �׸��������ҳ��
    FOnCompare: TQPagedListSortCompare; // ���ݱȽϺ���
    /// <summary> �Ƚ�����ָ���Ӧ�����ݴ�С </summary>
    /// <param name="p1">��һ��ָ��</param>
    /// <param name="p2">�ڶ���ָ��</param>
    /// <returns>�������ݵıȽϽ��,&lt;0����p1������С��p2,�����Ϊ0����֮��&gt;0</returns>
    /// <remarks>��������Ͳ���ʱʹ��</remarks>
    function DoCompare(p1, p2: Pointer): Integer; inline;
    /// <summary>��ȡָ��������ֵ</summary>
    /// <param name="AIndex">Ҫ��ȡ��Ԫ������</param>
    /// <returns>����ָ����ָ�룬�������Խ�磬���׳��쳣</returns>
    /// <remarks>����Items�Ķ�����</remarks>
    function GetItems(AIndex: Integer): Pointer; inline;
    /// <summary>����ָ��������ֵ</summary>
    /// <param name="AIndex">Ŀ������λ�ã����Խ�磬���׳��쳣</param>
    /// <remarks>����Items��д����</remarks>
    procedure SetItems(AIndex: Integer; const Value: Pointer); inline;
    /// <summary>ɾ��֪ͨ��������</summary>
    /// <param name="p">Ҫɾ����ָ��</param>
    /// <remarks>����TQPagedList����Żᴥ��Notify����</remarks>
    procedure DoDelete(const p: Pointer); inline;
    /// <summary>����ָ���������ڵ�ҳ����</summary>
    /// <param name="p">Ŀ������λ��</param>
    /// <returns>�����ҵ���ҳ��</returns>
    function FindPage(AIndex: Integer): Integer;
    /// <summary>����ָ���������ڵ�ҳ</summary>
    /// <param name="p">Ŀ������λ��</param>
    /// <returns>�����ҵ���ҳ����</returns>
    function GetPage(AIndex: Integer): TQListPage;
    /// <summary>��Ǵ�ָ����ҳ��ʼ��ҳͷ��FStartIndex��ϢʧЧ</summary>
    /// <param name="APage">ʧЧ��ҳ������</param>
    /// <remarks>ʹ��ʧЧ��ҳ����ҳ������ʱ����Ҫ�ȸ�����ҳ������Ϣ</remarks>
    procedure Dirty(APage: Integer); inline;
    /// <summary>ָ֪ͨ����ָ�뷢���仯</summary>
    /// <param name="Ptr">�����仯��ָ������</param>
    /// <param name="Action">�����ı仯����</param>
    procedure Notify(Ptr: Pointer; Action: TListNotification); virtual;
    /// <summary>��ȡ��ǰ�б������</summary>
    /// <returns>���� PageSize*PageCount �Ľ��</returns>
    /// <remarks>����Capacity�Ķ�����</remarks>
    function GetCapacity: Integer;
    /// <summary>�����κ��£���Ϊ����TList����ʽ���ṩ</summary>
    /// <remarks>����Capacity��д����</remarks>
    procedure SetCapacity(const Value: Integer);
    /// <summary>����ǰ�������ݷŵ�һά��ָ��������</summary>
    /// <returns>�������ɵ�һά��̬����</returns>
    /// <remarks>����List�Ķ�����</remarks>
    function GetList: TPointerList;
    /// <summary>�������ݴ�С�ȽϺ���</summary>
    /// <param name="Value">�µıȽϺ���</summary>
    /// <remarks>����OnCompare��д�������޸������ܴ�����������</remarks>
    procedure SetOnCompare(const Value: TQPagedListSortCompare);
    /// <summary>��ɾ�����Ƴ�Ԫ��ʱ��������ʹ�õķ�ҳ����</summary>
    procedure CheckLastPage;
    /// <summary>��ȡ��ǰ�Ѿ��������ҳ��</summary>
    function GetPageCount: Integer;
  public
    /// <summary>
    /// Ĭ�Ϲ��캯��������δָ��ҳ���С��ʹ��Ĭ�ϴ�С512
    /// </summary>
    constructor Create; overload;
    /// <summary>���캯��</summary>
    /// <param name="APageSize">ÿҳ���������С�ڵ���0��ʹ��Ĭ��ֵ</param>
    constructor Create(APageSize: Integer); overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
{$IF RTLVersion<26}
    /// <summary>�����������ο�TList.Assign</summary>
    procedure Assign(ListA: TList; AOperator: TListAssignOp = laCopy;
      ListB: TList = nil); overload;
{$IFEND}
    /// <summary>�����������ο�TList.Assign</summary>
    procedure Assign(ListA: TQPagedList; AOperator: TListAssignOp = laCopy;
      ListB: TQPagedList = nil); overload;
    /// <summary>���һ��Ԫ��</summary>
    /// <param name="p">Ҫ��ӵ�Ԫ��</param>
    /// <returns>������Ԫ�ص�����ֵ</returns>
    function Add(const p: Pointer): Integer; overload;
    /// <summary>һ������Ӷ��Ԫ��</summary>
    /// <param name="pp">Ҫ��ӵ�Ԫ���б�ָ��</param>
    /// <param name="ACount">Ҫ��ӵ�Ԫ�ظ���</param>
    /// <returns>������Ԫ�ص�����ֵ</returns>
    procedure BatchAdd(pp: PPointer; ACount: Integer); overload;
    /// <summary>һ������Ӷ��Ԫ��</summary>
    /// <param name="AList">Ҫ��ӵ�Ԫ�ض�̬����</param>
    /// <returns>������Ԫ�ص�����ֵ</returns>
    procedure BatchAdd(AList: TPointerList); overload;
    /// <summary>��ָ����λ�ò���һ����Ԫ��</summary>
    /// <param name="AIndex">Ҫ�����λ�ã����С�ڵ���0��������ʼλ�ã�������ڵ���Count�������ĩβ</param>
    /// <param name="p">Ҫ�����Ԫ��</param>
    /// <remarks>���ָ�������������AIndex����������</remarks>
    procedure Insert(AIndex: Integer; const p: Pointer); overload;
    /// <summary>��ָ����λ��������������Ԫ��</summary>
    /// <param name="AIndex">Ҫ�����λ�ã����С�ڵ���0��������ʼλ�ã�������ڵ���Count�������ĩβ</param>
    /// <param name="pp">Ҫ�����Ԫ��</param>
    /// <param name="ACount">pp����ָ���Ԫ�ظ���</param>
    /// <remarks>���ָ�������������AIndex����������</remarks>
    procedure BatchInsert(AIndex: Integer; pp: PPointer;
      ACount: Integer); overload;
    /// <summary>��ָ����λ�ò���һ����Ԫ��</summary>
    /// <param name="AIndex">Ҫ�����λ�ã����С�ڵ���0��������ʼλ�ã�������ڵ���Count�������ĩβ</param>
    /// <param name="p">Ҫ�����Ԫ��</param>
    /// <remarks>���ָ�������������AIndex����������</remarks>
    procedure BatchInsert(AIndex: Integer; const AList: TPointerList); overload;
    /// <summary>��������Ԫ�ص�λ��</summary>
    /// <param name="AIndex1">��һ��Ԫ�ص�λ������</param>
    /// <param name="AIndex2">�ڶ���Ԫ�ص�λ������</param>
    procedure Exchange(AIndex1, AIndex2: Integer);
    /// <summary>��ָ��λ�õ�Ԫ���ƶ�����λ��</summary>
    /// <param name="AFrom">��ʼλ������</param>
    /// <param name="ATo">Ŀ��λ������</param>
    procedure MoveTo(AFrom, ATo: Integer);
    /// <summary>ʵ��ֱ�ӵ���MoveTo</summary>
    procedure Move(AFrom, ATo: Integer); inline;
    /// <summary>ɾ��ָ����Ԫ��</summary>
    procedure Delete(AIndex: Integer);
    /// <summary>�Ƴ�ָ����Ԫ��</summary>
    procedure Remove(AIndex: Integer); overload;
    /// <summary>�Ƴ�ָ����Ԫ��</summary>
    function Remove(Item: Pointer): Integer; overload; inline;
    /// <summary>��ָ���ķ���ʼ���Ҳ��Ƴ�Ԫ��</summary>
    function RemoveItem(Item: Pointer; Direction: TDirection): Integer;
    /// <summary>����ָ��Ԫ�ص�����</summary>
    /// <param name="p">Ҫ���ҵ�Ԫ��</param>
    /// <param name="AIdx">�ҵ���Ԫ������</param>
    /// <returns>����ҵ�������True,���򷵻�False��AIdxΪĿ��Ӧ���ֵ�λ��</returns>
    function Find(const p: Pointer; var AIdx: Integer): Boolean;
    /// <summary>�������Ԫ��</summary>
    /// <remarks>Clear��������ҳ�Ա�������ã�Ҫ����ҳ�������Pack����</remarks>
    procedure Clear;
    /// <summary>�����б�Ϊ���ٵ�ҳ��</summary>
    procedure Pack;
    /// <summary>����OnCompare�涨�Ĺ�������</summary>
    /// <remarks>һ��ָ��OnCompare���������Ԫ��ʱ���Զ�����Insertʱָ��������λ�ý��ᱻ����</remarks>
    procedure Sort; overload;
{$IFDEF UNICODE}
    /// <summary>����AOnCompare�����涨�Ĺ�������</summary>
    /// <remarks>һ��ָ��OnCompare���������Ԫ��ʱ���Զ�����Insertʱָ��������λ�ý��ᱻ����</remarks>
    procedure Sort(AOnCompare: TQPagedListSortCompareA); overload;
{$ENDIF}
    /// <summary>����AOnCompare�����涨�Ĺ�������</summary>
    /// <remarks>һ��ָ��OnCompare���������Ԫ��ʱ���Զ�����Insertʱָ��������λ�ý��ᱻ����</remarks>
    procedure Sort(AOnCompare: TQPagedListSortCompareG); overload;
    /// <summary> for .. in ֧��</summary>
    function GetEnumerator: TQPagedListEnumerator;
    /// <summary>��Ϊ���� TList ��ӣ��� TQPagedList ������</summary>
    function Expand: TQPagedList;
    /// <summary>�Ƴ�ָ������Ŀ</summary>
    /// <param name="Item">Ҫ�Ƴ���ֵ</param>
    function Extract(Item: Pointer): Pointer; inline;
    /// <summary>�Ƴ�ָ������Ŀ</summary>
    /// <param name="Item">Ҫ�Ƴ���ֵ</param>
    /// <param name="Direction">���ҷ���</param>
    function ExtractItem(Item: Pointer; Direction: TDirection): Pointer;
    /// <summary>�׸�Ԫ��</summary>
    function First: Pointer; inline;
    /// <summary>���һ��Ԫ��</summary>
    function Last: Pointer; inline;
    /// <summary>��ȡָ��Ԫ�ص��״γ���λ��</summary>
    /// <param name="Item">Ҫ���ҵ�Ԫ��</param>
    function IndexOf(Item: Pointer): Integer;
    /// <summary>��ָ���ķ������Ԫ���״γ��ֵ�λ��</summary>
    /// <param name="Item">Ҫ���ҵ�Ԫ��</param>
    /// <param name="Direction">���ҷ���</param>
    function IndexOfItem(Item: Pointer; Direction: TDirection): Integer;
    /// <summary>Ԫ�ظ���</summary>
    property count: Integer read FCount;
    /// <summary>Ԫ���б�</summary>
    property Items[AIndex: Integer]: Pointer read GetItems
      write SetItems; default;
    /// <summary>Ԫ�رȽϹ������ָ������Ԫ���Զ�����</summary>
    property OnCompare: TQPagedListSortCompare read FOnCompare
      write SetOnCompare;
    /// <summary>����TList���ã��� TQPagedList ������</summary>
    property Capacity: Integer read GetCapacity write SetCapacity;
    /// <summary>��ȡ���е�Ԫ��ֵ����</summary>
    property List: TPointerList read GetList;
    /// <summary>�Ѿ������ҳ��</summary>
    property PageCount: Integer read GetPageCount;
    /// <summary>��ǰҳ��С</summary>
    property PageSize: Integer read FPageSize;
  end;

  /// <summary>
  /// ��ҳ�ڴ����������ڰ�ҳ����ȡ���ݣ����Ż��ڴ�ķ�����ͷŴ������������Ч�ʣ�ʹ�÷�ʽͬ��ͨ���ڴ���һ���������ṩMemory
  /// ָ�루��Ϊ���Ͳ����������ڴ�飩�������ṩ��AsBytes��Bytes[AIndex]�ķ�ʽ������ָ�������ݡ�
  /// </summary>
  TQPagedStream = class(TStream)
  private
    procedure SetCapacity(Value: Int64);
    function GetBytes(AIndex: Int64): Byte;
    procedure SetBytes(AIndex: Int64; const Value: Byte);
    procedure SetAsBytes(const Value: TBytes);
    function GetAsBytes: TBytes;
  protected
    FPages: array of PByte;
    FPageSize: Integer;
    FSize: Int64;
    FPosition: Int64;
    FCapacity: Int64;
    function ActivePage: Integer; inline;
    function ActiveOffset: Integer; inline;
    procedure PageNeeded(APageIndex: Integer);
    function GetSize: Int64; override;
  public
    constructor Create; overload;
    constructor Create(APageSize: Integer); overload;
    destructor Destroy; override;
    procedure Clear;
    function Read(var Buffer; count: Longint): Longint; overload; override;
    function Read(Buffer: TBytes; Offset, count: Longint): Longint;
{$IF RTLVersion>23} override{$ELSE}reintroduce;
    overload{$IFEND};
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SetSize(const NewSize: Int64); override;
    procedure SetSize(NewSize: Longint); override;
    function Write(const Buffer; count: Longint): Longint; overload; override;
    function Write(const Buffer: TBytes; Offset, count: Longint): Longint;
{$IF RTLVersion>23} override{$ELSE}reintroduce;
    overload{$IFEND};
    property Capacity: Int64 read FCapacity write SetCapacity;
    property Bytes[AIndex: Int64]: Byte read GetBytes write SetBytes;
    property AsBytes: TBytes read GetAsBytes write SetAsBytes;
  end;

  /// <summary>
  /// TQBits�����򻯶Ա�־λ�ķ��ʣ��������û��ȡĳһλ��״̬
  /// </summary>
  TQBits = record
  private
    FBits: TBytes;
    function GetSize: Integer;
    procedure SetSize(const Value: Integer);
    function GetIsSet(AIndex: Integer): Boolean;
    procedure SetIsSet(AIndex: Integer; const Value: Boolean);
  public
    property Size: Integer read GetSize write SetSize;
    property IsSet[AIndex: Integer]: Boolean read GetIsSet
      write SetIsSet; default;
    property Bytes: TBytes read FBits write FBits;
  end;

  TQReadOnlyMemoryStream = class(TCustomMemoryStream)
  private
  protected
    constructor Create(); overload;
  public
    constructor Create(AData: Pointer; ASize: Integer); overload;
    function Write(const Buffer; count: Longint): Longint; override;
  end;

  TQFilterCharEvent = procedure(const AChar, AIndex: Cardinal;
    var Accept: Boolean; ATag: Pointer) of object;
{$IFDEF UNICODE}
  TQFilterCharEventA = reference to procedure(const c, AIndex: Cardinal;
    var Accept: Boolean; ATag: Pointer);
{$ENDIF}
  TQNumberType = (nftFloat, nftHexPrec, nftDelphiHex, nftCHex, nftBasicHex,
    nftNegative, nftPositive);
  TQNumberTypes = set of TQNumberType;

  TPasswordStrongLevel = (pslLowest, pslLower, pslNormal, pslHigher,
    pslHighest);
  TPasswordRule = (prIncNumber, prIncLowerCase, prIncUpperCase, prIncChart,
    prIncUnicode, prRepeat, prSimpleOrder);
  TPasswordRules = set of TPasswordRule;

  // ���뷽����mrmNone - �����룬mrmSimple - ��������,mrmBank - ���м����뷨�������������˫��
  TMoneyRoundMethod = (mrmNone, mrmSimple, mrmBank);

  /// <summary>
  /// �����ַ�����
  /// </summary>
  TNameCharType = (
    /// <summary>
    /// ����
    /// </summary>
    nctChinese,
    /// <summary>
    /// ��ĸ
    /// </summary>
    nctAlpha,
    /// <summary>
    /// ����
    /// </summary>
    nctNum,
    /// <summary>
    /// ����
    /// </summary>
    nctSymbol,
    /// <summary>
    /// �ո�ע�ⲻ�������л�Tab
    /// </summary>
    nctSpace,
    /// <summary>
    /// �����ָ���
    /// </summary>
    nctDot,
    /// <summary>
    /// ˽���ַ�
    /// </summary>
    nctCustom,
    /// <summary>
    /// ����
    /// </summary>
    nctOther);
  TNameCharSet = set of TNameCharType;

  /// <summary>
  /// ���� IsHumanName �ж������Ƿ���Чʱ���û������Զ����ж��ض��ַ��Ƿ������ȫ�ֻص�������AChar ΪҪ�����ַ���Accept
  /// Ϊ�������AHandled ���ڼ�¼�û��Ƿ��Ѿ��ж�������Ѿ��ж�������Ϊtrue��Ĭ��Ϊfalse����Ĭ���ж���
  /// </summary>
  TQCustomNameCharTest = procedure(AChar: Cardinal;
    var Accept, AHandled: Boolean);
  /// <summary>
  /// TRandCharType ������������ַ���ʱȷ���ַ����������ַ���Χ
  /// </summary>
  TRandCharType = (
    /// <summary>����</summary>
    rctChinese,
    /// <summary>��СдӢ����ĸ</summary>
    rctAlpha,
    /// <summary>��СдӢ����ĸ��rctAlphaͬʱ����</summary>
    rctLowerCase,
    /// <summary>����дӢ����ĸ</summary>
    rctUpperCase,
    /// <summary>����</summary>
    rctNum,
    /// <summary>Ӣ�ķ���</summary>
    rctSymbol,
    /// <summary>�հ��ַ����ո�Tab�ͻ��з���</summary>
    rctSpace);
  TRandCharTypes = set of TRandCharType;
  /// <summary>
  /// �����Ա�
  /// </summary>
  TQHumanSex = (
    /// <summary>
    /// δ֪
    /// </summary>
    hsUnknown,
    /// <summary>
    /// Ů��
    /// </summary>
    hsFemale,
    /// <summary>
    /// ����
    /// </summary>
    hsMale);
  TMemCompFunction = function(p1, p2: Pointer; L1, L2: Integer): Integer;
  TCNSpellCallback = function(const p: PQCharW): QCharW;
  TUrlBookmarkEncode = (ubeOnlyLast, ubeNone, ubeAll);
  TQStringCallback = procedure(var AValue: QStringW);
  // UTF8������Unicode����ת��������ʹ���Լ���ʵ��
function Utf8Decode(p: PQCharA; l: Integer): QStringW; overload;
function Utf8Decode(const p: QStringA): QStringW; overload;
function Utf8Encode(p: PQCharW; l: Integer): QStringA; overload;
function Utf8Encode(const p: QStringW): QStringA; overload;
function Utf8Encode(ps: PQCharW; sl: Integer; pd: PQCharA; dl: Integer)
  : Integer; overload;
// Ansi������Unicode����ת��������ʹ��ϵͳ��TEncodingʵ��
function AnsiEncode(p: PQCharW; l: Integer): QStringA; overload;
function AnsiEncode(const p: QStringW): QStringA; overload;
function AnsiDecode(p: PQCharA; l: Integer): QStringW; overload;
function AnsiDecode(const p: QStringA): QStringW; overload;
// ȡָ�����ַ���������ƴ������ĸ
function CNSpellChars(S: QStringA; AIgnoreEnChars: Boolean): QStringW; overload;
function CNSpellChars(S: QStringW; AIgnoreEnChars: Boolean): QStringW; overload;

// ���㵱ǰ�ַ��ĳ���
function CharSizeA(c: PQCharA): Integer;
function CharSizeU(c: PQCharA): Integer;
function CharSizeW(c: PQCharW): Integer;
// �����ַ���������CharCountW��д�԰���UCS2��չ���ַ�����
function CharCountA(const source: QStringA): Integer;
function CharCountW(const S: QStringW): Integer;
function CharCountU(const source: QStringA): Integer;
function CountOfChar(p: PQCharW; const c: QCharW): Integer;
// ���㵱ǰ�ַ���Unicode����
function CharCodeA(c: PQCharA): Cardinal;
function CharCodeU(c: PQCharA): Cardinal;
function CharCodeW(c: PQCharW): Cardinal;
function CharAdd(const w: WideChar; ADelta: Integer): WideChar; inline;
function CharDelta(const c1, c2: WideChar): Integer; inline;
// ����ַ��Ƿ���ָ�����б���
function CharInA(const c: PQCharA; const List: array of QCharA;
  ACharLen: PInteger = nil): Boolean;
function CharInW(const c: PQCharW; const List: array of QCharW;
  ACharLen: PInteger = nil): Boolean; overload;
function CharInW(const c, List: PQCharW; ACharLen: PInteger = nil)
  : Boolean; overload;
function CharInU(const c: PQCharA; const List: array of QCharA;
  ACharLen: PInteger = nil): Boolean;

function StrInW(const S: QStringW; const Values: array of QStringW;
  AIgnoreCase: Boolean = false): Integer; overload;
function StrInW(const S: QStringW; Values: TStrings;
  AIgnoreCase: Boolean = false): Integer; overload;
// ����Ƿ��ǿհ��ַ�
function IsSpaceA(const c: PQCharA; ASpaceSize: PInteger = nil): Boolean;
function IsSpaceW(const c: PQCharW; ASpaceSize: PInteger = nil): Boolean;
function IsSpaceU(const c: PQCharA; ASpaceSize: PInteger = nil): Boolean;
function TrimSpaceW(const S: QStringW): QStringW;
// ȫ�ǰ��ת��
function CNFullToHalf(const S: QStringW): QStringW;
function CNHalfToFull(const S: QStringW): QStringW;

// ���Ŵ���
function QuotedStrA(const S: QStringA; const AQuoter: QCharA = $27): QStringA;
function QuotedStrW(const S: QStringW; const AQuoter: QCharW = #$27): QStringW;
function SQLQuoted(const S: QStringW; ADoEscape: Boolean = True): QStringW;
function DequotedStrA(const S: QStringA; const AQuoter: QCharA = $27): QStringA;
function DequotedStrW(const S: QStringW; const AQuoter: QCharW = #$27)
  : QStringW;

// �����б��е��ַ�
function SkipCharA(var p: PQCharA; const List: array of QCharA): Integer;
function SkipCharU(var p: PQCharA; const List: array of QCharA): Integer;
function SkipCharW(var p: PQCharW; const List: array of QCharA)
  : Integer; overload;
function SkipCharW(var p: PQCharW; const List: PQCharW): Integer; overload;

// �����հ��ַ������� Ansi���룬��������#9#10#13#161#161������UCS���룬��������#9#10#13#$A0#$3000
function SkipSpaceA(var p: PQCharA): Integer;
function SkipSpaceU(var p: PQCharA): Integer;
function SkipSpaceW(var p: PQCharW): Integer;
// ����һ��,��#10Ϊ�н�β
function SkipLineA(var p: PQCharA): Integer;
function SkipLineU(var p: PQCharA): Integer;
function SkipLineW(var p: PQCharW): Integer;
// ����ֱ������ָ�����ַ�
function SkipUntilA(var p: PQCharA; AExpects: array of QCharA;
  AQuoter: QCharA = 0): Integer;
function SkipUntilU(var p: PQCharA; AExpects: array of QCharA;
  AQuoter: QCharA = 0): Integer;
function SkipUntilW(var p: PQCharW; AExpects: array of QCharW;
  AQuoter: QCharW = #0): Integer; overload;
function SkipUntilW(var p: PQCharW; AExpects: PQCharW; AQuoter: QCharW = #0)
  : Integer; overload;
function BackUntilW(var p: PQCharW; AExpects, AStartPos: PQCharW): Integer;
// �����ַ��������кţ������е���ʼ��ַ
function StrPosA(Start, Current: PQCharA; var ACol, ARow: Integer): PQCharA;
function StrPosU(Start, Current: PQCharA; var ACol, ARow: Integer): PQCharA;
function StrPosW(Start, Current: PQCharW; var ACol, ARow: Integer): PQCharW;

// �ַ����ֽ�
function DecodeTokenA(var p: PQCharA; ADelimiters: array of QCharA;
  AQuoter: QCharA; AIgnoreSpace: Boolean): QStringA;
function DecodeTokenU(var p: PQCharA; ADelimiters: array of QCharA;
  AQuoter: QCharA; AIgnoreSpace: Boolean): QStringA;
function DecodeTokenW(var p: PQCharW; ADelimiters: array of QCharW;
  AQuoter: QCharW; AIgnoreSpace: Boolean; ASkipDelimiters: Boolean = True)
  : QStringW; overload;
function DecodeTokenW(var p: PQCharW; ADelimiters: PQCharW; AQuoter: QCharW;
  AIgnoreSpace: Boolean; ASkipDelimiters: Boolean = True): QStringW; overload;
function DecodeTokenW(var S: QStringW; ADelimiters: PQCharW; AQuoter: QCharW;
  AIgnoreCase, ARemove: Boolean; ASkipDelimiters: Boolean = True)
  : QStringW; overload;
function SplitTokenW(AList: TStrings; p: PQCharW; ADelimiters: PQCharW;
  AQuoter: QCharW; AIgnoreSpace: Boolean): Integer; overload;
function SplitTokenW(AList: TStrings; const S: QStringW; ADelimiters: PQCharW;
  AQuoter: QCharW; AIgnoreSpace: Boolean): Integer; overload;
function SplitTokenW(const S: QStringW; ADelimiters: PQCharW; AQuoter: QCharW;
  AIgnoreSpace: Boolean): TQStringArray; overload;

function StrBeforeW(var source: PQCharW; const ASpliter: QStringW;
  AIgnoreCase, ARemove: Boolean; AMustMatch: Boolean = false)
  : QStringW; overload;
function StrBeforeW(var source: QStringW; const ASpliter: QStringW;
  AIgnoreCase, ARemove: Boolean; AMustMatch: Boolean = false)
  : QStringW; overload;
function SplitByStrW(AList: TStrings; ASource: QStringW;
  const ASpliter: QStringW; AIgnoreCase: Boolean): Integer;
function LeftStrW(const S: QStringW; AMaxCount: Integer; ACheckExt: Boolean)
  : QStringW; overload;
function LeftStrW(var S: QStringW; const ADelimiters: QStringW;
  ARemove: Boolean): QStringW; overload;
function RightStrW(const S: QStringW; AMaxCount: Integer; ACheckExt: Boolean)
  : QStringW; overload;
function RightStrW(var S: QStringW; const ADelimiters: QStringW;
  ARemove: Boolean): QStringW; overload;
function StrBetween(var S: PQCharW; AStartTag, AEndTag: QStringW;
  AIgnoreCase: Boolean; AQuoter: QCharW = #0): QStringW; overload;
function StrBetween(const S: QStringW; const AStartTag, AEndTag: QStringW;
  AIgnoreCase: Boolean; AQuoter: QCharW = #0): String; overload;
function StrBetweenTimes(const S, ADelimiter: QStringW; AIgnoreCase: Boolean;
  AStartTimes: Integer = 0; AStopTimes: Integer = 1): QStringW;
function TokenWithIndex(var S: PQCharW; AIndex: Integer; ADelimiters: PQCharW;
  AQuoter: QCharW; AIgnoreSapce: Boolean): QStringW;

// ��ȡһ��
function DecodeLineA(var p: PQCharA; ASkipEmpty: Boolean = True;
  AMaxSize: Integer = MaxInt): QStringA;
function DecodeLineU(var p: PQCharA; ASkipEmpty: Boolean = True;
  AMaxSize: Integer = MaxInt): QStringA;
function DecodeLineW(var p: PQCharW; ASkipEmpty: Boolean = True;
  AMaxSize: Integer = MaxInt; AQuoterChar: QCharW = #0): QStringW; overload;
function DecodeLineW(AStream: TStream; AEncoding: TTextEncoding;
  var ALine: QStringW): Boolean; overload;
function ReplaceLineBreak(const S, ALineBreak: QStringW): QStringW;
// ��Сдת��
function CharUpperA(c: QCharA): QCharA; inline;
function CharUpperW(c: QCharW): QCharW; inline;
function CharLowerA(c: QCharA): QCharA; inline;
function CharLowerW(c: QCharW): QCharW; inline;
function UpperFirstW(const S: QStringW): QStringW;
// �ж��Ƿ�����ָ�����ַ�����ʼ
function StartWithA(S, startby: PQCharA; AIgnoreCase: Boolean): Boolean;
function StartWithU(S, startby: PQCharA; AIgnoreCase: Boolean): Boolean;
function StartWithW(S, startby: PQCharW; AIgnoreCase: Boolean): Boolean;
// �ж��Ƿ���ָ�����ַ�����β
function EndWithA(const S, endby: QStringA; AIgnoreCase: Boolean): Boolean;
function EndWithU(const S, endby: QStringA; AIgnoreCase: Boolean): Boolean;
function EndWithW(const S, endby: QStringW; AIgnoreCase: Boolean): Boolean;
// ��������ַ����ӿ�ʼ����ͬ���ַ���
function SameCharsA(s1, s2: PQCharA; AIgnoreCase: Boolean): Integer;
function SameCharsU(s1, s2: PQCharA; AIgnoreCase: Boolean): Integer;
function SameCharsW(s1, s2: PQCharW; AIgnoreCase: Boolean): Integer;
// �����ı�
function LoadTextA(const AFileName: String;
  AEncoding: TTextEncoding = teUnknown): QStringA; overload;
function LoadTextA(AStream: TStream; AEncoding: TTextEncoding = teUnknown)
  : QStringA; overload;
function LoadTextU(const AFileName: String;
  AEncoding: TTextEncoding = teUnknown): QStringA; overload;
function LoadTextU(AStream: TStream; AEncoding: TTextEncoding = teUnknown)
  : QStringA; overload;
function LoadTextW(const AFileName: String;
  AEncoding: TTextEncoding = teUnknown): QStringW; overload;
function LoadTextW(AStream: TStream; AEncoding: TTextEncoding = teUnknown)
  : QStringW; overload;
// ����ı����벢�����ı����ݣ�ע�����û��BOM���ı��ļ�ⲻ��100%��������û��BOM
// ʱ��������Unicode��Ansi������ַ�
function DecodeText(p: Pointer; ASize: Integer;
  AEncoding: TTextEncoding = teUnknown): QStringW;
// �����ı�
procedure SaveTextA(const AFileName: String; const S: QStringA); overload;
procedure SaveTextA(AStream: TStream; const S: QStringA); overload;
procedure SaveTextU(const AFileName: String; const S: QStringA;
  AWriteBom: Boolean = True); overload;
procedure SaveTextU(const AFileName: String; const S: QStringW;
  AWriteBom: Boolean = True); overload;
procedure SaveTextU(AStream: TStream; const S: QStringA;
  AWriteBom: Boolean = True); overload;
procedure SaveTextU(AStream: TStream; const S: QStringW;
  AWriteBom: Boolean = True); overload;
procedure SaveTextW(const AFileName: String; const S: QStringW;
  AWriteBom: Boolean = True); overload;
procedure SaveTextW(AStream: TStream; const S: QStringW;
  AWriteBom: Boolean = True); overload;
procedure SaveTextWBE(AStream: TStream; const S: QStringW;
  AWriteBom: Boolean = True); overload;
// �Ӵ�����
function StrStrA(s1, s2: PQCharA): PQCharA;
function StrIStrA(s1, s2: PQCharA): PQCharA;
function StrStrU(s1, s2: PQCharA): PQCharA;
function StrIStrU(s1, s2: PQCharA): PQCharA;
function StrStrW(s1, s2: PQCharW): PQCharW;
function StrIStrW(s1, s2: PQCharW): PQCharW;

// �ַ����� Like ƥ��
function StrLikeX(var S: PQCharW; pat: PQCharW; AIgnoreCase: Boolean): PQCharW;
function StrLikeW(S, pat: PQCharW; AIgnoreCase: Boolean): Boolean; overload;
// �����Ӵ�����ʼλ��
function PosA(sub, S: PQCharA; AIgnoreCase: Boolean; AStartPos: Integer = 1)
  : Integer; overload;
function PosA(sub, S: QStringA; AIgnoreCase: Boolean; AStartPos: Integer = 1)
  : Integer; overload;
/// <summary>Pos��������ǿ�汾ʵ��</summary>
/// <param name="sub">Ҫ���ҵ����ַ���</param>
/// <param name="S">�������ҵ�ԭ�ַ���</param>
/// <param name="AIgnoreCase">�Ƿ���Դ�Сд</param>
/// <param name="AStartPos">��ʼλ�ã���һ���ַ�λ��Ϊ1</param>
/// <returns>�ҵ��������Ӵ�����ʼλ�ã�ʧ�ܣ�����0<returns>
function PosW(sub, S: PQCharW; AIgnoreCase: Boolean; AStartPos: Integer = 1)
  : Integer; overload;
/// <param name="sub">Ҫ���ҵ����ַ���</param>
/// <param name="S">�������ҵ�ԭ�ַ���</param>
/// <param name="AIgnoreCase">�Ƿ���Դ�Сд</param>
/// <param name="AStartPos">��ʼλ�ã���һ���ַ�λ��Ϊ1</param>
/// <returns>�ҵ��������Ӵ�����ʼλ�ã�ʧ�ܣ�����0<returns>
function PosW(sub, S: QStringW; AIgnoreCase: Boolean; AStartPos: Integer = 1)
  : Integer; overload;
// �ַ�������
function StrDupX(const S: PQCharW; ACount: Integer): QStringW;
function StrDupW(const S: PQCharW; AOffset: Integer = 0;
  const ACount: Integer = MaxInt): QStringW;
procedure StrCpyW(d: PQCharW; S: PQCharW; ACount: Integer = -1);
// �ַ����Ƚ�
function StrCmpA(const s1, s2: PQCharA; AIgnoreCase: Boolean): Integer;
function StrCmpW(const s1, s2: PQCharW; AIgnoreCase: Boolean): Integer;
function StrNCmpW(const s1, s2: PQCharW; AIgnoreCase: Boolean;
  ALength: Integer): Integer;
function NaturalCompareW(s1, s2: PQCharW; AIgnoreCase: Boolean;
  AIgnoreSpace: Boolean = True): Integer;
function StrCatW(const S: array of QStringW; AIgnoreZeroLength: Boolean = True;
  const AStartOffset: Integer = 0; const ACount: Integer = MaxInt;
  const ADelimiter: QCharW = ','; const AQuoter: QCharW = #0): QStringW;

// ʮ��������غ���
function IsHexChar(c: QCharW): Boolean; inline;
function IsOctChar(c: QCharW): Boolean; inline;
function HexValue(c: QCharW): Integer; inline;
function HexChar(V: Byte): QCharW; inline;
// ����ת������
function TryStrToGuid(const S: QStringW; var AGuid: TGuid): Boolean;
function TryStrToIPV4(const S: QStringW; var AIPV4:
{$IFDEF MSWINDOWS}Integer{$ELSE}Cardinal{$ENDIF}): Boolean;
/// StringReplace ��ǿ
function StringReplaceW(const S, Old, New: QStringW; AFlags: TReplaceFlags)
  : QStringW; overload;

/// <summary>�滻ָ����Χ�ڵ��ַ�Ϊָ�����ַ�</summary>
/// <param name="AChar">ռλ�ַ�</param>
/// <param name="AFrom">��ʼλ�ã���0��ʼ</param>
/// <param name="ACount">�滻����</param>
/// <returns>�����滻����ַ���</returns>
function StringReplaceW(const S: QStringW; const AChar: QCharW;
  AFrom, ACount: Integer): QStringW; overload;
/// <summary>ʹ��ָ���������滻AStartTag��EndTag֮�������</summary>
/// <params>
/// <param name="S">Ҫ�����滻���ַ���</param>
/// <param name="AStartTag">��ʼ�ı�ǩ����</param>
/// <param name="AEndTag">�����ı�ǩ����</param>
/// <param name="AReplaced">�滻�Ľ��</param>
/// <param name="AWithTag">�Ƿ���ͬAStartTag��AEndTag��ǩһ���滻��</param>
/// <param name="AIgnoreCase">�Ƚϱ�ǩ����ʱ�Ƿ���Դ�С</param>
/// <param name="AMaxTimes">����滻������Ĭ��Ϊ1</param>
/// </params>
/// <returns>�����滻�������</returns>
function StringReplaceWithW(const S, AStartTag, AEndTag, AReplaced: QStringW;
  AWithTag, AIgnoreCase: Boolean; AMaxTimes: Cardinal = 1): QStringW;
/// �ظ�ָ�����ַ�N��
function StringReplicateW(const S: QStringW; ACount: Integer)
  : QStringW; overload;
function StringReplicateW(const S, AChar: QStringW; AExpectLength: Integer)
  : QStringW; overload;
/// <summary>���ַ����м���ַ��滻Ϊָ��������</summary>
/// <param name="S">ԭʼ�ַ���</param>
/// <param name="AMaskChar">�����ַ�</param>
/// <param name="ALeft">���ౣ��ԭʼ�ַ���</param>
/// <param name="ARight">�Ҳౣ��ԭʼ�ַ���</param>
///
function MaskText(const S: QStringW; ALeft, ARight: Integer;
  AMaskChar: QCharW = '*'): QStringW;

/// <summary>
/// ���ַ�����ָ�����ַ������ڵڶ��������г��ֵ�λ���滻Ϊ����������ͬ��λ�õ��ַ�
/// </summary>
/// <param name="S">
/// Ҫ���ҵ��ַ���
/// </param>
/// <param name="AToReplace">
/// Ҫ�滻���ַ�����
/// </param>
/// <param name="AReplacement">
/// ͬλ���滻���ַ�����
/// </param>
/// <returns>
/// �����滻��ɵĽ��
/// </returns>
/// <remarks>
/// AToReplace �� AReplacement ���ַ�������Ҫ����豣��һ�£������׳��쳣��
/// </remarks>
/// <example>
/// translate('Techonthenet.com', 'met', 'ABC') ִ�еĽ��Ϊ TBchonChBnBC.coA
/// </example>
function Translate(const S, AToReplace, AReplacement: QStringW): QStringW;
/// <summary>���˵��ַ��������в���Ҫ���ַ�</summary>
/// <param name="S">Ҫ���˵��ַ���</param>
/// <param name="AcceptChars">������ַ��б�</param>
/// <returns>���ع��˺�Ľ��</returns>
function FilterCharW(const S: QStringW; AcceptChars: QStringW)
  : QStringW; overload;
/// <summary>���˵��ַ��������в���Ҫ���ַ�</summary>
/// <param name="S">Ҫ���˵��ַ���</param>
/// <param name="AOnValidate">���ڹ��˵Ļص�����</param>
/// <param name="ATag">�û��Զ���ĸ��Ӳ������ᴫ�ݸ�AOnValidate�¼�</param>
/// <returns>���ع��˺�Ľ��</returns>
function FilterCharW(const S: QStringW; AOnValidate: TQFilterCharEvent;
  ATag: Pointer = nil): QStringW; overload;
{$IFDEF UNICODE}
/// <summary>���˵��ַ��������в���Ҫ���ַ�</summary>
/// <param name="S">Ҫ���˵��ַ���</param>
/// <param name="AOnValidate">���ڹ��˵Ļص�����</param>
/// <param name="ATag">�û��Զ���ĸ��Ӳ������ᴫ�ݸ�AOnValidate�¼�</param>
/// <returns>���ع��˺�Ľ��</returns>
function FilterCharW(const S: QStringW; AOnValidate: TQFilterCharEventA;
  ATag: Pointer = nil): QStringW; overload;
{$ENDIF}
/// <summary>���˵����з���ֵ���͵��ַ����Ӷ������ʽ��һ����Ա�׼�ĸ�����</summary>
/// <param name="S">Ҫ���˵��ַ���</param>
/// <param name="Accepts">�����������</param>
/// <returns>���ع��˺�Ľ��</returns>
/// <remarks>
/// FilterNoNumberW ���˺�Ľ������ʹ�� ParseNumeric ����Ϊ���飬�󲿷������Ҳ
/// ���Ա�StrToFloat��������StrToFloat��֧����Щ�����ʽ��

function FilterNoNumberW(const S: QStringW; Accepts: TQNumberTypes): QStringW;
/// <summary>��������ת��Ϊ��������</summary>
/// <param name="S">Ҫת�����ַ���</param>
/// <returns>����ת����Ľ��</returns>
function SimpleChineseToTraditional(S: QStringW): QStringW;
/// <summary>��������ת��Ϊ��������</summary>
/// <param name="S">Ҫת�����ַ���</param>
/// <returns>����ת����Ľ��</returns>
function TraditionalChineseToSimple(S: QStringW): QStringW;
/// <summary> ������ֵת��Ϊ���ִ�д</summary>
/// <param name="AVal">����ֵ</param>
/// <param name="AFlags">��־λ��ϣ��Ծ����������ĸ�ʽ</param>
/// <param name="ANegText">������ֵΪ����ʱ����ʾ��ǰ׺</param>
/// <param name="AStartText">ǰ���ַ������硰����ң���</param>
/// <param name="AEndText">�����ַ������硰����</param>
/// <param name="AGroupNum">������ÿ���������䵥λ����һ�����飬AGroupNumָ��Ҫ�������������Ϊ0ʱ������Ա�־λ�е�MC_HIDE_ZERO��MC_MERGE_ZERO</param>
/// <param name="ARoundMethod">������뵽��ʱ���㷨</param>
/// <param name="AEndDigts">С������λ����-16~4 ֮��</param>
/// <returns>���ظ�ʽ������ַ���</returns>
function CapMoney(AVal: Currency; AFlags: Integer;
  ANegText, AStartText, AEndText: QStringW; AGroupNum: Integer;
  ARoundMethod: TMoneyRoundMethod; AEndDigits: Integer = 2): QStringW;

/// <summary>
/// �ж�ָ�����ַ����Ƿ���һ����Ч������
/// </summary>
/// <param name="S">
/// Ҫ�жϵ��ַ���
/// </param>
/// <param name="AllowChars">
/// ������ַ�����
/// </param>
/// <param name="AMinLen">
/// ��С������ַ���
/// </param>
/// <param name="AMaxLen">
/// ���������ַ���
/// </param>
/// <param name="AOnTest">
/// �û��Զ�����Թ���ص�
/// </param>
function IsHumanName(S: QStringW; AllowChars: TNameCharSet;
  AMinLen: Integer = 2; AMaxLen: Integer = 15;
  AOnTest: TQCustomNameCharTest = nil): Boolean;
/// <summary>
/// �ж�ָ�����ַ����Ƿ���һ���й�������
/// </summary>
function IsChineseName(S: QStringW): Boolean;
/// <summary>
/// �ж�ָ�����ַ����Ƿ���һ����Ч���������
/// </summary>
function IsNoChineseName(S: QStringW): Boolean;
/// <summary>
/// �ж�ָ�����ַ����Ƿ�����Ч���й���ַ
/// </summary>
function IsChineseAddr(S: QStringW; AMinLength: Integer = 3): Boolean;
/// <summary>
/// �ж�ָ�����ַ����Ƿ�����Ч�������ַ
/// </summary>
function IsNoChineseAddr(S: QStringW; AMinLength: Integer = 3): Boolean;
/// ����ָ���Ķ��������ݳ��ֵ���ʼλ��
function MemScan(S: Pointer; len_s: Integer; sub: Pointer;
  len_sub: Integer): Pointer;
function BinaryCmp(const p1, p2: Pointer; len: Integer): Integer;
{$IFNDEF WIN64}inline; {$ENDIF}
// ����ĺ���ֻ��Unicode�汾��û��Ansi��UTF-8�汾�������Ҫ���ټ���
// �ֽ�����-ֵ��
function NameOfW(const S: QStringW; ASpliter: QCharW;
  AEmptyIfMissed: Boolean = false): QStringW;
function ValueOfW(const S: QStringW; ASpliter: QCharW;
  AEmptyIfMissed: Boolean = false): QStringW;
function IndexOfNameW(AList: TStrings; const AName: QStringW;
  ASpliter: QCharW): Integer;
function IndexOfValueW(AList: TStrings; const AValue: QStringW;
  ASpliter: QCharW): Integer;

function DeleteCharW(const ASource, ADeletes: QStringW): QStringW;
function DeleteSideCharsW(const ASource: QStringW; ADeletes: QStringW;
  AIgnoreCase: Boolean = false): QStringW;
function DeleteRightW(const S, ADelete: QStringW; AIgnoreCase: Boolean = false;
  ACount: Integer = MaxInt): QStringW;
function DeleteLeftW(const S, ADelete: QStringW; AIgnoreCase: Boolean = false;
  ACount: Integer = MaxInt): QStringW;
function ContainsCharW(const S, ACharList: QStringW): Boolean;
function HtmlEscape(const S: QStringW): QStringW;
function HtmlUnescape(const S: QStringW): QStringW;
function JavaEscape(const S: QStringW; ADoEscape: Boolean): QStringW;
function JavaUnescape(const S: QStringW; AStrictEscape: Boolean): QStringW;
function HtmlTrimText(const S: QStringW): QStringW;
function IsUrl(const S: QStringW): Boolean;
function UrlEncode(const ABytes: PByte; l: Integer; ASpacesAsPlus: Boolean;
  AEncodePercent: Boolean = false;
  ABookmarkEncode: TUrlBookmarkEncode = ubeOnlyLast): QStringW; overload;
function UrlEncode(const ABytes: TBytes; ASpacesAsPlus: Boolean;
  AEncodePercent: Boolean = false;
  ABookmarkEncode: TUrlBookmarkEncode = ubeOnlyLast): QStringW; overload;
function UrlEncodeString(const S: QStringW): QStringW;
function UrlEncode(const S: QStringW; ASpacesAsPlus: Boolean;
  AUtf8Encode: Boolean = True; AEncodePercent: Boolean = false;
  ABookmarkEncode: TUrlBookmarkEncode = ubeOnlyLast): QStringW; overload;
function UrlDecode(const AUrl: QStringW;
  var AScheme, AHost, ADocument: QStringW; var APort: Word; AParams: TStrings;
  AUtf8Encode: Boolean = True): Boolean; overload;
function UrlDecode(const AValue: QStringW; var AResult: QStringW;
  AUtf8Encode: Boolean = True): Boolean; overload;
function LeftStrCount(const S: QStringW; const sub: QStringW;
  AIgnoreCase: Boolean): Integer;
function RightPosW(const S: QStringW; const sub: QStringW;
  AIgnoreCase: Boolean): Integer;
// ������һЩ��������
function ParseInt(var S: PQCharW; var ANum: Int64): Integer;
function ParseHex(var p: PQCharW; var Value: Int64): Integer;
function ParseNumeric(var S: PQCharW; var ANum: Extended): Boolean;
  overload; inline;
function ParseNumeric(var S: PQCharW; var ANum: Extended; var AIsFloat: Boolean)
  : Boolean; overload;
function ParseDateTime(S: PWideChar; var AResult: TDateTime): Boolean;
function ParseWebTime(p: PWideChar; var AResult: TDateTime): Boolean;
function DateTimeFromString(AStr: QStringW; var AResult: TDateTime;
  AFormat: String = ''): Boolean; overload;
function DateTimeFromString(Str: QStringW; AFormat: QStringW = '';
  ADef: TDateTime = 0): TDateTime; overload;
// ��ȡ��ǰʱ��ƫ�ƣ���λΪ���ӣ����й�Ϊ��8����ֵΪ480
function GetTimeZone: Integer;
// ��ȡ��ǰʱ��ƫ���ı���ʾ�����й�Ϊ��8����ֵΪ+0800
function GetTimezoneText: QStringW;
function EncodeWebTime(ATime: TDateTime): QStringW;

function RollupSize(ASize: Int64): QStringW;
function RollupTime(ASeconds: Int64; AHideZero: Boolean = True): QStringW;
function DetectTextEncoding(const p: Pointer; l: Integer; var b: Boolean)
  : TTextEncoding;
procedure ExchangeByteOrder(p: PQCharA; l: Integer); overload;
function ExchangeByteOrder(V: Smallint): Smallint; overload; inline;
function ExchangeByteOrder(V: Word): Word; overload; inline;
function ExchangeByteOrder(V: Integer): Integer; overload; inline;
function ExchangeByteOrder(V: Cardinal): Cardinal; overload; inline;
function ExchangeByteOrder(V: Int64): Int64; overload; inline;
function ExchangeByteOrder(V: Single): Single; overload; inline;
function ExchangeByteOrder(V: Double): Double; overload; // inline;

procedure FreeObject(AObject: TObject); inline;
procedure FreeAndNilObject(var AObject); inline;
// ԭ�Ӳ�������
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer;
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer;
{$IF RTLVersion<24}
// Ϊ��XE6���ݣ�InterlockedCompareExchange�ȼ�
function AtomicCmpExchange(var Target: Integer; Value: Integer;
  Comparand: Integer): Integer; inline; overload;
function AtomicCmpExchange(var Target: Pointer; Value: Pointer;
  Comparand: Pointer): Pointer; inline; overload;
// �ȼ���InterlockedExchanged
function AtomicExchange(var Target: Integer; Value: Integer): Integer;
  inline; overload;
function AtomicExchange(var Target: Pointer; Value: Pointer): Pointer;
  inline; overload;

function AtomicIncrement(var Target: Integer; const Value: Integer = 1)
  : Integer; inline;
function AtomicDecrement(var Target: Integer): Integer; inline;
{$IFEND <XE5}
//
function BinToHex(p: Pointer; l: Integer; ALowerCase: Boolean = false)
  : QStringW; overload;
function BinToHex(const ABytes: TBytes; ALowerCase: Boolean = false)
  : QStringW; overload;
function HexToBin(const S: QStringW): TBytes; overload;
procedure HexToBin(const S: QStringW; var AResult: TBytes); overload;
// ����ָ�����ݵĹ�ϣֵ
function HashOf(p: Pointer; l: Integer): Cardinal;
function NewId: TGuid;
function SameId(const V1, V2: TGuid): Boolean;

/// <summary>����ָ�����ݵ�����ǿ��</summary>
/// <param name="S">����</param>
/// <returns>����һ��>=0������ǿ��ֵ</returns>
function PasswordScale(const S: QStringW): Integer; overload;
/// <summary>����ָ�����ݵ�����ǿ��</summary>
/// <param name="S">����</param>
/// <param name="ARules">��⵽�����������Ŀ</param>
/// <returns>����һ��>=0������ǿ��ֵ</returns>
function PasswordScale(const S: QStringW; var ARules: TPasswordRules)
  : Integer; overload;
/// <summary>��ָ��������ǿ��ϵ��ת��Ϊǿ�ȵȼ�</summary>
/// <param name="AScale">ͨ��PasswordScale�õ���ǿ�ȵȼ�</param>
/// <returns>����ת�����ǿ�ȵȼ�</returns>
function CheckPassword(const AScale: Integer): TPasswordStrongLevel; overload;
/// <summary>����ָ�����ݵ������ǿ�ȵȼ�</summary>
/// <param name="S">����</param>
/// <returns>���ؼ���õ���ǿ�ȵȼ�</returns>
function CheckPassword(const S: QStringW): TPasswordStrongLevel; overload;
/// <summary>���������а������ַ�����</summary>
/// <param name="S">�ַ���</param>
/// <returns>���ذ������ַ����ͼ���</returns>
function PasswordCharTypes(const S: QStringW): TRandCharTypes;
/// <summary>��������ƥ��Ĺ�������</summary>
/// <param name="S">�ַ���</param>
/// <returns>����ƥ��Ĺ������ͼ���</returns>
function PasswordRules(const S: QStringW): TPasswordRules;
/// <summary>���ָ�����й����֤�ŵ���Ч��</summary>
/// <param name="CardNo">���֤��</param>
/// <returns>������Ϲ��򣬷���true�����򣬷���false</returns>
function IsChineseIdNo(CardNo: QStringW): Boolean;
/// <summary>����ָ�����й���½���֤�ŵ���ɲ���</summary>
/// <param name="CardNo">���֤��</param>
/// <param name="AreaCode">������������</param>
/// <param name="Birthday">��������</param>
/// <param name="IsFemale">�Ա���Ϊtrue��ŮΪfalse</param>
/// <returns>���֤����Ч������true����ͨ���������ظ������֣����򣬷���false</returns>
function DecodeChineseId(CardNo: QStringW; var AreaCode: QStringW;
  var Birthday: TDateTime; var IsFemale: Boolean): Boolean;
function AreaCodeOfChineseId(CardNo: QStringW): QStringW;
function AgeOfChineseId(CardNo: QStringW; ACalcDate: TDateTime = 0): Integer;
function BirthdayOfChineseId(CardNo: QStringW): TDateTime;
function SexOfChineseId(CardNo: QStringW): TQHumanSex;
/// <summary>���ָ�����ַ����Ƿ���ϵ��������ʽ</summary>
/// <param name="S">Ҫ���ĵ��������ַ</param>
/// <returns>�����x@y.z��ʽ���򷵻�true�����򣬷���false</returns>
function IsEmailAddr(S: QStringW): Boolean;
/// <summary>����Ƿ����й��绰�����ʽ</summary>
/// <param name="S">Ҫ���ĵ绰����</param>
/// <returns>��ʽ������[+86-]nnnn[-, ]nnnn[-]nnnn���򷵻�true�����򷵻�false</returns>
function IsChinesePhone(S: QStringW): Boolean;
/// <summary>����Ƿ����й��ֻ������ʽ</summary>
/// <param name="S">Ҫ�����ֻ�����</param>
/// <returns>��ʽ����[+86]nnnn[-, ]...��n��11λ���֣�������1��ͷ���򷵻�true������false</returns>
function IsChineseMobile(S: QStringW; ACheckNumericOnly: Boolean): Boolean;
/// <summary>��ȡָ�����ļ��Ĵ�С</summary>
/// <param name="S">Ҫ��ѯ���ļ���</param>
/// <returns>�ɹ�������ʵ�ʵ��ļ���С��ʧ�ܣ�����-1</returns>
function SizeOfFile(const S: QStringW): Int64;
/// <summary>�ж������¼���Ӧ�����Ƿ����</summary>
/// <param name="Left">��һ���¼���Ӧ����</param>
/// <param name="Right">�ڶ����¼���Ӧ����</param>
/// <returns>��ȣ�����true������ȣ�����False</param>
function MethodEqual(const Left, Right: TMethod): Boolean; inline;
/// <summary>�ϲ�����URL,�൱��TURI������·��ת��Ϊ����·���ĺ���</summary>
/// <param name="ABase">��׼·��</param>
/// <param name="ARel">���·��</param>
/// <returns>
/// 1.���ARel��һ������·������ֱ�ӷ��ظ�·��.
/// 2.���ARel��һ����//��ʼ�ľ���·�����򿽱�ABase��Э�����ͣ�����ARel�γ���·��
/// 3.���ARel��һ�����·��������ABase��·��Ϊ��׼������ARel�γ���·��
/// </returns>
function UrlMerge(const ABase, ARel: QStringW): QStringW;
/// <summary>���������Ϣ</summary>
/// <param name="AMsg">Ҫ������ַ�������</param>
/// <remark>�������־�ڵ���ʱ�������Events������</remark>
procedure Debugout(const AMsg: QStringW); overload;
/// <summary>���������Ϣ</summary>
/// <param name="AMsg">Ҫ������ַ�������</param>
/// <remark>�������־�ڵ���ʱ�������Events������</remark>
procedure Debugout(const AFmt: QStringW;
  const AParams: array of const); overload;
function RandomString(ALen: Cardinal; ACharTypes: TRandCharTypes = [];
  AllTypesNeeded: Boolean = false): QStringW;

function FindSwitchValue(ASwitch: QStringW; ANameValueSperator: QCharW;
  AIgnoreCase: Boolean; var ASwitchChar: QCharW): QStringW; overload;
function FindSwitchValue(ASwitch: QStringW; ANameValueSperator: QCharW = ':')
  : QStringW; overload;

function MonthFirstDay(ADate: TDateTime): TDateTime;
function MergeAddr(const AProv, ACity, ACounty, ATownship, AVillage,
  ADetail: QStringW; AIgnoreCityIfSameEnding: Boolean): QStringW;
function IsFMXApp: Boolean;

// <summary>���ָ�������п��ŵ���Ч��</summary>
/// <param name="ABankNo">���п�֤��</param>
/// <returns>������Ϲ��򣬷���true�����򣬷���false</returns>
/// <remark>��ʼ�汾��һŵ�ṩ������ ISO 7812 2017 ��涨����ʵ��
function IsBankNo(ABankNo: QStringW): Boolean;
// <summary>�������п������</summary>
/// <param name="ABankNo">���п�֤��</param>
/// <param name="ABankIdent">���ڷ�������IIN����</param>
/// <param name="APersonIdent">���ڷ��ظ��˱���</param>
/// <returns>������Ϲ��򣬷���true�����򣬷���false</returns>
/// <remark>IIN ������6λ��8λ��2017 ISO 7812 �涨Ϊ 8 λ����ǰΪ6λ������Ĭ�ϰ��±�׼ִ��</remark>

function DecodeBankNo(const ABankNo: QStringW;
  var ABankIdent, APersonIdent: QStringW): Boolean;
function StrPrefixW(const AFixedLength: Integer; const AValue: String;
  const APrefixChar: QCharW): QStringW;

var
  JavaFormatUtf8: Boolean;
  AppType: Integer;
  MemComp: TMemCompFunction;
  OnFetchCNSpell: TCNSpellCallback;

const
  SLineBreak: PQCharW = {$IFDEF MSWINDOWS}#13#10{$ELSE}#10{$ENDIF};
  DefaultNumberSet = [nftFloat, nftDelphiHex, nftCHex, nftBasicHex, nftHexPrec,
    nftNegative, nftPositive];
  HexChars: array [0 .. 15] of QCharW = ('0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  LowerHexChars: array [0 .. 15] of QCharW = ('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');

implementation

uses dateutils, math, sysconst, variants
{$IF (RTLVersion>=25) and (not Defined(NEXTGEN))}
    , AnsiStrings
{$IFEND >=XE4}
    ;

resourcestring
  SBadUnicodeChar = '��Ч��Unicode�ַ�:%d';
  SBadUtf8Char = '��Ч��UTF8�ַ�:%d';
  SOutOfIndex = '����Խ�磬ֵ %d ����[%d..%d]�ķ�Χ�ڡ�';
  SDayName = '��';
  SHourName = 'Сʱ';
  SMinuteName = '����';
  SSecondName = '��';
  SCharNeeded = '��ǰλ��Ӧ���� "%s" �������� "%s"��';
  SRangeEndNeeded = '�ַ���Χ�߽�����ַ�δָ����';
  STooSmallCapMoneyGroup = '�����ķ����� %d С��ʵ����Ҫ����С���ҷ����� %d��';
  SUnsupportNow = 'ָ���ĺ��� %s Ŀǰ����֧��';
  SBadJavaEscape = '��Ч�� Java ת�����У�%s';
  SBadHexChar = '��Ч��ʮ�������ַ� %s';
  SStreamReadOnly = '������һ��ֻ������������д������';
  SMismatchReplacement = '%s �� %s �ĳ��Ȳ�һ��';

type
  TGBKCharSpell = record
    SpellChar: QCharW;
    StartChar, EndChar: Word;
  end;

  TStrStrFunction = function(s1, s2: PQCharW): PQCharW;
{$IFDEF MSWINDOWS}
  TMSVCStrStr = function(s1, s2: PQCharA): PQCharA; cdecl;
  TMSVCStrStrW = function(s1, s2: PQCharW): PQCharW; cdecl;
  TMSVCMemCmp = function(s1, s2: Pointer; len: Integer): Integer; cdecl;
{$ENDIF}

  TCharRange = record
    Start, Stop: Cardinal;
    CharType: TNameCharType;
  end;
const
  // https://www.qqxiuzi.cn/zh/hanzi-unicode-bianma.php,More information see unicode.org,this is only part of unicode
  CharRanges: array [0 .. 35] of TCharRange = ( //
    // Space
    (Start: Ord(' '); Stop: Ord(' '); CharType: nctSpace), //
    // ASCII
    (Start: Ord('0'); Stop: Ord('9'); CharType: nctNum), //
    (Start: Ord('A'); Stop: Ord('Z'); CharType: nctAlpha), //
    (Start: Ord('a'); Stop: Ord('z'); CharType: nctAlpha), //
    // Dot
    (Start: Ord('��'); Stop: Ord('��'); CharType: nctDot), //
    // Unicode
    // Currency Symbols: U+20A0�CU+20CF
    (Start: $20A0; Stop: $20CF; CharType: nctSymbol), //
    // Letterlike Symbols: U+2100�CU+214F
    (Start: $2100; Stop: $214F; CharType: nctSymbol), //
    // Technical Symbols:2300-23FF��2400-243F,2440-245F
    (Start: $2300; Stop: $245F; CharType: nctSymbol), //
    // Geometric Shapes: U+25A0�CU+25FF
    (Start: $25A0; Stop: $25FF; CharType: nctSymbol), //
    // Geometrical Symbols
    (Start: $2600; Stop: $26FF; CharType: nctSymbol), //
    // Dingbats: U+2700�CU+27BF
    (Start: $2700; Stop: $27BF; CharType: nctSymbol), //
    // iscellaneous Symbols and Arrows (U+2B00..U+2BFF)
    (Start: $2B00; Stop: $2BFF; CharType: nctChinese), //
    (Start: $3400; Stop: $4DBF; CharType: nctChinese), // ��չA��6592��
    (Start: $4E00; Stop: $9FFF; CharType: nctChinese), // ��������+�������ֲ��� 20992 ��
    (Start: $E000; Stop: $F8FF; CharType: nctCustom), //
    (Start: $F900; Stop: $FAD9; CharType: nctChinese), // ���ݺ��� 472 ��
    // ȫ��
    (Start: Ord('��'); Stop: Ord('��'); CharType: nctNum), //
    (Start: Ord('��'); Stop: Ord('��'); CharType: nctAlpha), //
    (Start: Ord('��'); Stop: Ord('��'); CharType: nctAlpha), //
    // Mathematical Alphanumeric Symbols: U+1D400�CU+1D7FF
    (Start: $1D400; Stop: $1D7FF; CharType: nctSymbol),
    // 1F300..1F5FF Miscellaneous Symbols and Pictographs
    (Start: $1F300; Stop: $1F5FF; CharType: nctSymbol),
    // 1F600..1F64F Emoticons
    (Start: $1F600; Stop: $1F64F; CharType: nctSymbol),
    // Ornamental Dingbats: U+1F650�CU+1F67F
    (Start: $1F650; Stop: $1F67F; CharType: nctSymbol),
    // 1F680..1F6FF Transport and Map Symbols
    (Start: $1F680; Stop: $1F6FF; CharType: nctSymbol),
    // Geometric Shapes Extended: U+1F780�CU+1F7FF
    (Start: $1F780; Stop: $1F7FF; CharType: nctSymbol),
    // 1F900..1F9FF Supplemental Symbols and Pictographs
    (Start: $1F900; Stop: $1F9FF; CharType: nctSymbol),
    // 1FA70..1FAFF Symbols and Pictographs Extended-A
    (Start: $1FA70; Stop: $1FAFF; CharType: nctSymbol),
    // Symbols for Legacy Computing: U+1FB00-U+1FBFF
    (Start: $1FB00; Stop: $1FBFF; CharType: nctSymbol), //
    (Start: $20000; Stop: $2A6DF; CharType: nctChinese), // ��չB��42720��
    (Start: $2A700; Stop: $2B739; CharType: nctChinese), // ��չC��4154��
    (Start: $2B740; Stop: $2B81D; CharType: nctChinese), // ��չD 	222��
    (Start: $2B820; Stop: $2CEA1; CharType: nctChinese), // ��չE 	5762��
    (Start: $2CEB0; Stop: $2CEA1; CharType: nctChinese), // ��չF 	7473��
    (Start: $2F800; Stop: $2FA1D; CharType: nctChinese), // ������չ 	542��
    (Start: $30000; Stop: $3134A; CharType: nctChinese), // ��չG 	4939��
    (Start: $31350; Stop: $323AF; CharType: nctChinese) // ��չH 	4192��
    );
var
  // GBK����ƴ������ĸ��
  GBKSpells: array [0 .. 22] of TGBKCharSpell = (
    (
      SpellChar: 'A'; StartChar: $B0A1; EndChar: $B0C4;
    ), (SpellChar: 'B'; StartChar: $B0C5; EndChar: $B2C0;
    ), (SpellChar: 'C'; StartChar: $B2C1; EndChar: $B4ED;
    ), (SpellChar: 'D'; StartChar: $B4EE; EndChar: $B6E9;
    ), (SpellChar: 'E'; StartChar: $B6EA; EndChar: $B7A1;
    ), (SpellChar: 'F'; StartChar: $B7A2; EndChar: $B8C0;
    ), (SpellChar: 'G'; StartChar: $B8C1; EndChar: $B9FD;
    ), (SpellChar: 'H'; StartChar: $B9FE; EndChar: $BBF6;
    ), (SpellChar: 'J'; StartChar: $BBF7; EndChar: $BFA5;
    ), (SpellChar: 'K'; StartChar: $BFA6; EndChar: $C0AB;
    ), (SpellChar: 'L'; StartChar: $C0AC; EndChar: $C2E7;
    ), (SpellChar: 'M'; StartChar: $C2E8; EndChar: $C4C2;
    ), (SpellChar: 'N'; StartChar: $C4C3; EndChar: $C5B5;
    ), (SpellChar: 'O'; StartChar: $C5B6; EndChar: $C5BD;
    ), (SpellChar: 'P'; StartChar: $C5BE; EndChar: $C6D9;
    ), (SpellChar: 'Q'; StartChar: $C6DA; EndChar: $C8BA;
    ), (SpellChar: 'R'; StartChar: $C8BB; EndChar: $C8F5;
    ), (SpellChar: 'S'; StartChar: $C8F6; EndChar: $CBF0;
    ), (SpellChar: 'T'; StartChar: $CBFA; EndChar: $CDD9;
    ), (SpellChar: 'W'; StartChar: $CDDA; EndChar: $CEF3;
    ), (SpellChar: 'X'; StartChar: $CEF4; EndChar: $D188;
    ), (SpellChar: 'Y'; StartChar: $D1B9; EndChar: $D4D0;
    ), (SpellChar: 'Z'; StartChar: $D4D1; EndChar: $D7F9;));
{$IFDEF MSWINDOWS}
  hMsvcrtl: HMODULE;
  VCStrStr: TMSVCStrStr;
  VCStrStrW: TMSVCStrStrW;
{$IFDEF WIN64}
  VCMemCmp: TMSVCMemCmp;
{$ENDIF}
{$ENDIF}

const
  // HTMLת���

  HtmlEscapeChars: array [32 .. 255] of QStringW = ('&nbsp;', #33, '&quot;',
    #35, #36, #37, '&amp;', '&apos;', #40, #41,
    //
    #42, #43, #44, #45, #46, #47, #48, #49, #50, #51, //
    #52, #53, #54, #55, #56, #57, #58, #59, '&lt;', #61, //
    '&gt;', #63, #64, #65, #66, #67, #68, #69, #70, #71, //
    #72, #73, #74, #75, #76, #77, #78, #79, #80, #81, //
    #82, #83, #84, #85, #86, #87, #88, #89, #90, #91, //
    #92, #93, #94, #95, #96, #97, #98, #99, #100, #101, //
    #102, #103, #104, #105, #106, #107, #108, #109, #110, #111, //
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, //
    #122, #123, #124, #125, #126, #127, WideChar(128), WideChar(129),
    WideChar(130), WideChar(131), //
    WideChar(132), WideChar(133), WideChar(134), WideChar(135), WideChar(136),
    WideChar(137), WideChar(138), WideChar(139), WideChar(140), WideChar(141),
    //
    WideChar(142), WideChar(143), WideChar(144), WideChar(145), WideChar(146),
    WideChar(147), WideChar(148), WideChar(149), WideChar(150), WideChar(151),
    //
    WideChar(152), WideChar(153), WideChar(154), WideChar(155), WideChar(156),
    WideChar(157), WideChar(158), WideChar(159), WideChar(160), '&iexcl;', //
    '&cent;', '&pound;', '&curren;', '&yen;', '&brvbar;', '&sect;', '&uml;',
    '&copy;', '&ordf;', '&laquo;', //
    '&not;', '&shy;', '&reg;', '&macr;', '&deg;', '&plusmn;', WideChar(178),
    WideChar(179), '&acute;', '&micro;', //
    '&para;', '&middot;', '&cedil;', WideChar(185), '&ordm;', '&raquo;',
    WideChar(188), WideChar(189), WideChar(190), '&iquest;', //
    '&Agrave;', '&Aacute;', '&circ;', '&Atilde;', WideChar(196), '&ring;',
    '&AElig;', '&Ccedil;', '&Egrave;', '&Eacute;', //
    '&Ecirc;', '&Euml;', '&Igrave;', '&Iacute;', '&Icirc;', '&Iuml;', '&ETH;',
    '&Ntilde;', '&Ograve;', '&Oacute;', //
    '&Ocirc;', '&Otilde;', '&Ouml;', '&times;', '&Oslash;', '&Ugrave;',
    '&Uacute;', '&Ucirc;', '&Uuml;', '&Yacute;', //
    '&THORN;', '&szlig;', '&agrave;', '&aacute;', WideChar(226), '&atilde;',
    '&auml;', '&aring;', '&aelig;', '&ccedil;',
    //
    '&egrave;', '&eacute;', '&ecirc;', '&euml;', '&igrave;', '&iacute;',
    '&icirc;', '&iuml;', '&ieth;', '&ntilde;', '&ograve;', '&oacute;',
    '&ocirc;', '&otilde;', '&ouml;', '&divide;', '&oslash;', '&ugrave;',
    '&uacute;', '&ucirc;',
    //
    '&uuml;', '&yacute;', '&thorn;', '&yuml;');
  // QString����

function Utf8Decode(const p: QStringA): QStringW;
begin
  if p.IsUtf8 then
    Result := Utf8Decode(PQCharA(p), p.Length)
  else if p.Length > 0 then
    Result := AnsiDecode(p)
  else
    SetLength(Result, 0);
end;

function Utf8Encode(const p: QStringW): QStringA;
var
  l: NativeInt;
begin
  l := Length(p);
  if l > 0 then
    Result := Utf8Encode(PQCharW(p), l)
  else
  begin
    Result.Length := 0;
    Result.FValue[0] := 1;
  end;
end;

function Utf8Decode(p: PQCharA; l: Integer; var AResult: QStringW;
  var ABadAt: PQCharA): Boolean; overload;
var
  ps, pe: PByte;
  pd, pds: PWord;
  c: Cardinal;
  procedure _Utf8Decode;
  begin
    ps := PByte(p);
    pe := ps;
    Inc(pe, l);
    System.SetLength(AResult, l);
    pd := PWord(PQCharW(AResult));
    pds := pd;
    Result := True;
    while IntPtr(ps) < IntPtr(pe) do
    begin
      if (ps^ and $80) <> 0 then
      begin
        if (ps^ and $FC) = $FC then // 4000000+
        begin
          c := (ps^ and $03) shl 30;
          Inc(ps);
          c := c or ((ps^ and $3F) shl 24);
          Inc(ps);
          c := c or ((ps^ and $3F) shl 18);
          Inc(ps);
          c := c or ((ps^ and $3F) shl 12);
          Inc(ps);
          c := c or ((ps^ and $3F) shl 6);
          Inc(ps);
          c := c or (ps^ and $3F);
          Inc(ps);
          c := c - $10000;
          pd^ := $D800 + ((c shr 10) and $3FF);
          Inc(pd);
          pd^ := $DC00 + (c and $3FF);
          Inc(pd);
        end
        else if (ps^ and $F8) = $F8 then // 200000-3FFFFFF
        begin
          c := (ps^ and $07) shl 24;
          Inc(ps);
          c := c or ((ps^ and $3F) shl 18);
          Inc(ps);
          c := c or ((ps^ and $3F) shl 12);
          Inc(ps);
          c := c or ((ps^ and $3F) shl 6);
          Inc(ps);
          c := c or (ps^ and $3F);
          Inc(ps);
          c := c - $10000;
          pd^ := $D800 + ((c shr 10) and $3FF);
          Inc(pd);
          pd^ := $DC00 + (c and $3FF);
          Inc(pd);
        end
        else if (ps^ and $F0) = $F0 then // 10000-1FFFFF
        begin
          c := (ps^ and $0F) shl 18;
          Inc(ps);
          c := c or ((ps^ and $3F) shl 12);
          Inc(ps);
          c := c or ((ps^ and $3F) shl 6);
          Inc(ps);
          c := c or (ps^ and $3F);
          Inc(ps);
          c := c - $10000;
          pd^ := $D800 + ((c shr 10) and $3FF);
          Inc(pd);
          pd^ := $DC00 + (c and $3FF);
          Inc(pd);
        end
        else if (ps^ and $E0) = $E0 then // 800-FFFF
        begin
          c := (ps^ and $1F) shl 12;
          Inc(ps);
          c := c or ((ps^ and $3F) shl 6);
          Inc(ps);
          c := c or (ps^ and $3F);
          Inc(ps);
          pd^ := c;
          Inc(pd);
        end
        else if (ps^ and $C0) = $C0 then // 80-7FF
        begin
          pd^ := (ps^ and $3F) shl 6;
          Inc(ps);
          pd^ := pd^ or (ps^ and $3F);
          Inc(pd);
          Inc(ps);
        end
        else
        begin
          ABadAt := PQCharA(ps);
          Result := false;
          Exit;
        end;
      end
      else
      begin
        pd^ := ps^;
        Inc(ps);
        Inc(pd);
      end;
    end;
    System.SetLength(AResult, (IntPtr(pd) - IntPtr(pds)) shr 1);
  end;

begin
  if l <= 0 then
  begin
    ps := PByte(p);
    while ps^ <> 0 do
      Inc(ps);
    l := IntPtr(ps) - IntPtr(p);
  end;
{$IFDEF MSWINDOWS}
  SetLength(AResult, l);
  SetLength(AResult, MultiByteToWideChar(CP_UTF8, 8, PAnsiChar(p), l,
    PQCharW(AResult), l)); // 8==>MB_ERR_INVALID_CHARS
  Result := Length(AResult) <> 0;
  if not Result then
    _Utf8Decode;
{$ELSE}
  _Utf8Decode
{$ENDIF}
end;

function Utf8Decode(p: PQCharA; l: Integer): QStringW;
var
  ABadChar: PQCharA;
begin
  if not Utf8Decode(p, l, Result, ABadChar) then
    raise Exception.Create(Format(SBadUtf8Char, [ABadChar^]));
end;

function WideCharUtf8Size(c: Integer): Integer;
begin
  if c < $7F then
    Result := 1
  else if c < $7FF then
    Result := 2
  else if c < $FFFF then
    Result := 3
  else if c < $1FFFFF then
    Result := 4
  else if c < $3FFFFFF then
    Result := 5
  else
    Result := 6;
end;

function Utf8BufferSize(p: PQCharW; var l: Integer): Integer;
var
  c: Cardinal;
  T: Integer;
begin
  Result := 0;
  if l < 0 then
  begin
    l := 0;
    while p^ <> #0 do
    begin
      if (p^ >= #$D800) and (p^ <= #$DFFF) then // Unicode ��չ���ַ�
      begin
        c := (Word(p^) - $D800);
        Inc(p);
        if (p^ >= #$DC00) and (p^ <= #$DFFF) then
        begin
          c := $10000 + (c shl 10) + Word(p^) - $DC00;
          Inc(p);
        end;
        Inc(Result, WideCharUtf8Size(c));
      end
      else
        Inc(Result, WideCharUtf8Size(Word(p^)));
      Inc(p);
      Inc(l);
    end;
  end
  else
  begin
    T := l;
    while T > 0 do
    begin
      if (p^ >= #$D800) and (p^ <= #$DFFF) then // Unicode ��չ���ַ�
      begin
        c := (Word(p^) - $D800);
        Inc(p);
        if (p^ >= #$DC00) and (p^ <= #$DFFF) then
        begin
          c := $10000 + (c shl 10) + Word(p^) - $DC00;
          Inc(p);
        end;
        Inc(Result, WideCharUtf8Size(c));
      end
      else
        Inc(Result, WideCharUtf8Size(Word(p^)));
      Inc(p);
      Dec(T);
    end;
  end;
end;

function Utf8Encode(ps: PQCharW; sl: Integer; pd: PQCharA; dl: Integer)
  : Integer;
{$IFNDEF MSWINDOWS}
var
  pds: PQCharA;
  c: Cardinal;
{$ENDIF}
begin
  if (ps = nil) or (sl = 0) then
    Result := 0
  else
  begin
{$IFDEF MSWINDOWS}
    // Windows��ֱ�ӵ��ò���ϵͳ��API
    Result := WideCharToMultiByte(CP_UTF8, 0, ps, sl, PAnsiChar(pd), dl,
      nil, nil);
{$ELSE}
    pds := pd;
    while sl > 0 do
    begin
      c := Cardinal(ps^);
      Inc(ps);
      if (c >= $D800) and (c <= $DFFF) then // Unicode ��չ���ַ�
      begin
        c := (c - $D800);
        if (ps^ >= #$DC00) and (ps^ <= #$DFFF) then
        begin
          c := $10000 + ((c shl 10) + (Cardinal(ps^) - $DC00));
          Inc(ps);
          Dec(sl);
        end
        else
          raise Exception.Create(Format(SBadUnicodeChar, [IntPtr(ps^)]));
      end;
      Dec(sl);
      if c = $0 then
      begin
        if JavaFormatUtf8 then // ����Java��ʽ���룬��#$0�ַ�����Ϊ#$C080
        begin
          pd^ := $C0;
          Inc(pd);
          pd^ := $80;
          Inc(pd);
        end
        else
        begin
          pd^ := c;
          Inc(pd);
        end;
      end
      else if c <= $7F then // 1B
      begin
        pd^ := c;
        Inc(pd);
      end
      else if c <= $7FF then // $80-$7FF,2B
      begin
        pd^ := $C0 or (c shr 6);
        Inc(pd);
        pd^ := $80 or (c and $3F);
        Inc(pd);
      end
      else if c <= $FFFF then // $8000 - $FFFF,3B
      begin
        pd^ := $E0 or (c shr 12);
        Inc(pd);
        pd^ := $80 or ((c shr 6) and $3F);
        Inc(pd);
        pd^ := $80 or (c and $3F);
        Inc(pd);
      end
      else if c <= $1FFFFF then // $01 0000-$1F FFFF,4B
      begin
        pd^ := $F0 or (c shr 18); // 1111 0xxx
        Inc(pd);
        pd^ := $80 or ((c shr 12) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or ((c shr 6) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or (c and $3F); // 10 xxxxxx
        Inc(pd);
      end
      else if c <= $3FFFFFF then // $20 0000 - $3FF FFFF,5B
      begin
        pd^ := $F8 or (c shr 24); // 1111 10xx
        Inc(pd);
        pd^ := $F0 or ((c shr 18) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or ((c shr 12) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or ((c shr 6) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or (c and $3F); // 10 xxxxxx
        Inc(pd);
      end
      else if c <= $7FFFFFFF then // $0400 0000-$7FFF FFFF,6B
      begin
        pd^ := $FC or (c shr 30); // 1111 11xx
        Inc(pd);
        pd^ := $F8 or ((c shr 24) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $F0 or ((c shr 18) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or ((c shr 12) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or ((c shr 6) and $3F); // 10 xxxxxx
        Inc(pd);
        pd^ := $80 or (c and $3F); // 10 xxxxxx
        Inc(pd);
      end;
    end;
    pd^ := 0;
    Result := IntPtr(pd) - IntPtr(pds);
{$ENDIF}
  end;
end;

function CalcUtf8Length(p: PQCharW; l: Integer): Integer;
var
  c: Cardinal;
begin
  Result := 0;
  while l > 0 do
  begin
    c := Cardinal(p^);
    Inc(p);
    if (c >= $D800) and (c <= $DFFF) then // Unicode ��չ���ַ�
    begin
      c := (c - $D800);
      if (p^ >= #$DC00) and (p^ <= #$DFFF) then
      begin
        c := $10000 + ((c shl 10) + (Cardinal(p^) - $DC00));
        Inc(p);
        Dec(l);
      end
      else
        raise Exception.Create(Format(SBadUnicodeChar, [IntPtr(p^)]));
    end;
    Dec(l);
    if c = $0 then
    begin
      if JavaFormatUtf8 then // ����Java��ʽ���룬��#$0�ַ�����Ϊ#$C080
        Inc(Result, 2)
      else
        Inc(Result);
    end
    else if c <= $7F then // 1B
      Inc(Result)
    else if c <= $7FF then // $80-$7FF,2B
      Inc(Result, 2)
    else if c <= $FFFF then // $8000 - $FFFF,3B
      Inc(Result, 3)
    else if c <= $1FFFFF then // $01 0000-$1F FFFF,4B
      Inc(Result, 4)
    else if c <= $3FFFFFF then // $20 0000 - $3FF FFFF,5B
      Inc(Result, 5)
    else if c <= $7FFFFFFF then // $0400 0000-$7FFF FFFF,6B
      Inc(Result, 6);
  end;
end;

function Utf8Encode(p: PQCharW; l: Integer): QStringA;
var
  ps: PQCharW;
begin
  if l <= 0 then
  begin
    ps := p;
    while ps^ <> #0 do
      Inc(ps);
    l := ps - p;
  end;
  if l > (MaxInt div 3) then
    Result.Length := CalcUtf8Length(p, l)
  else
    Result.Length := l * 3;
  Result.IsUtf8 := True;
  if l > 0 then
    Result.Length := Utf8Encode(p, l, PQCharA(Result), Result.Length);
end;

function AnsiEncode(p: PQCharW; l: Integer): QStringA;
var
  ps: PQCharW;
begin
  if l <= 0 then
  begin
    ps := p;
    while ps^ <> #0 do
      Inc(ps);
    l := ps - p;
  end;
  if l > 0 then
  begin
{$IFDEF MSWINDOWS}
    Result.Length := WideCharToMultiByte(CP_ACP, 0, p, l, nil, 0, nil, nil);
    WideCharToMultiByte(CP_ACP, 0, p, l, LPSTR(Result.Data), Result.Length,
      nil, nil);
{$ELSE}
    Result.Length := l shl 1;
    Result.FValue[0] := 0;
    Move(p^, PQCharA(Result)^, l shl 1);
    Result := TEncoding.Convert(TEncoding.Unicode, TEncoding.ANSI,
      Result.FValue, 1, l shl 1);
{$ENDIF}
  end
  else
    Result.Length := 0;
end;

function AnsiEncode(const p: QStringW): QStringA;
var
  l: NativeInt;
begin
  l := Length(p);
  if l > 0 then
    Result := AnsiEncode(PQCharW(p), l)
  else
    Result.Length := 0;
end;

function AnsiDecode(p: PQCharA; l: Integer): QStringW;
var
  ps: PQCharA;
{$IFNDEF MSWINDOWS}
  ABytes: TBytes;
{$ENDIF}
begin
  if l <= 0 then
  begin
    ps := p;
    while ps^ <> 0 do
      Inc(ps);
    l := IntPtr(ps) - IntPtr(p);
  end;
  if l > 0 then
  begin
{$IFDEF MSWINDOWS}
    System.SetLength(Result, MultiByteToWideChar(CP_ACP, 0, PAnsiChar(p),
      l, nil, 0));
    MultiByteToWideChar(CP_ACP, 0, PAnsiChar(p), l, PWideChar(Result),
      Length(Result));
{$ELSE}
    System.SetLength(ABytes, l);
    Move(p^, PByte(@ABytes[0])^, l);
    Result := TEncoding.ANSI.GetString(ABytes);
{$ENDIF}
  end
  else
    System.SetLength(Result, 0);
end;

function AnsiDecode(const p: QStringA): QStringW;
begin
  if p.IsUtf8 then
    Result := Utf8Decode(p)
  else if p.Length > 0 then
  begin
{$IFDEF MSWINDOWS}
    Result := AnsiDecode(PQCharA(p), p.Length);
{$ELSE}
    Result := TEncoding.ANSI.GetString(p.FValue, 1, p.Length);
{$ENDIF}
  end
  else
    SetLength(Result, 0);
end;

function SpellOfChar(w: Word): QCharW;
var
  I, l, H: Integer;
begin
  Result := #0;
  l := 0;
  H := 22;
  repeat
    I := (l + H) div 2;
    if w >= GBKSpells[I].StartChar then
    begin
      if w <= GBKSpells[I].EndChar then
      begin
        Result := GBKSpells[I].SpellChar;
        Break;
      end
      else
        l := I + 1;
    end
    else
      H := I - 1;
  until l > H;
end;

function CNSpellChars(S: QStringA; AIgnoreEnChars: Boolean): QStringW;
var
  p: PQCharA;
  pd, pds: PQCharW;

begin
  if S.Length > 0 then
  begin
    p := PQCharA(S);
    System.SetLength(Result, S.Length);
    pd := PQCharW(Result);
    pds := pd;
    while p^ <> 0 do
    begin
      if p^ in [1 .. 127] then
      begin
        if not AIgnoreEnChars then
        begin
          pd^ := QCharW(CharUpperA(p^));
          Inc(pd);
        end;
        Inc(p);
      end
      else
      begin
        pd^ := SpellOfChar(ExchangeByteOrder(PWord(p)^));
        Inc(p, 2);
        if pd^ <> #0 then
          Inc(pd);
      end;
    end;
    System.SetLength(Result, pd - pds);
  end
  else
    System.SetLength(Result, 0);
end;

function CNSpellChars(S: QStringW; AIgnoreEnChars: Boolean): QStringW;
var
  pw, pd: PQCharW;
  T: QStringA;
begin
  pw := PWideChar(S);
  System.SetLength(Result, Length(S));
  pd := PQCharW(Result);
  while pw^ <> #0 do
  begin
    if pw^ < #127 then
    begin
      if not AIgnoreEnChars then
      begin
        pd^ := CharUpperW(pw^);
        Inc(pd);
      end;
    end
    else if (pw^ > #$4E00) and (pw^ <= #$9FA5) then // ��������
    begin
      if Assigned(OnFetchCNSpell) then
      begin
        pd^ := OnFetchCNSpell(pw);
        if pd^ <> #0 then
        begin
          Inc(pd);
          Inc(pw);
          continue;
        end;
      end;
      T := AnsiEncode(pw, 1);
      if T.Length = 2 then
        pd^ := SpellOfChar(ExchangeByteOrder(PWord(PQCharA(T))^));
      if pd^ <> #0 then
        Inc(pd);
    end;
    Inc(pw);
  end;
  SetLength(Result, (IntPtr(pd) - IntPtr(PQCharW(Result))) shr 1);
end;

function CharSizeA(c: PQCharA): Integer;
begin
  { GB18030,����GBK��GB2312
    ���ֽڣ���ֵ��0��0x7F��
    ˫�ֽڣ���һ���ֽڵ�ֵ��0x81��0xFE���ڶ����ֽڵ�ֵ��0x40��0xFE��������0x7F����
    ���ֽڣ���һ���ֽڵ�ֵ��0x81��0xFE���ڶ����ֽڵ�ֵ��0x30��0x39���������ֽڴ�0x81��0xFE�����ĸ��ֽڴ�0x30��0x39��
  }
{$IFDEF MSWINDOWS}
  if GetACP = 936 then
{$ELSE}
  if TEncoding.ANSI.CodePage = 936 then
{$ENDIF}
  begin
    Result := 1;
    if (c^ >= $81) and (c^ <= $FE) then
    begin
      Inc(c);
      if (c^ >= $40) and (c^ <= $FE) and (c^ <> $7F) then
        Result := 2
      else if (c^ >= $30) and (c^ <= $39) then
      begin
        Inc(c);
        if (c^ >= $81) and (c^ <= $FE) then
        begin
          Inc(c);
          if (c^ >= $30) and (c^ <= $39) then
            Result := 4;
        end;
      end;
    end;
  end
  else
{$IFDEF QDAC_ANSISTRINGS}
    Result := AnsiStrings.StrCharLength(PAnsiChar(c));
{$ELSE}
{$IFDEF NEXTGEN}
    if TEncoding.ANSI.CodePage = CP_UTF8 then
      Result := CharSizeU(c)
    else if (c^ < 128) or (TEncoding.ANSI.CodePage = 437) then
      Result := 1
    else
      Result := 2;
{$ELSE}
{$IF RTLVersion>=25}
    Result := AnsiStrings.StrCharLength(PAnsiChar(c));
{$ELSE}
    Result := sysutils.StrCharLength(PAnsiChar(c));
{$IFEND}
{$ENDIF}
{$ENDIF !QDAC_ANSISTRINGS}
end;

function CharSizeU(c: PQCharA): Integer;
begin
  if (c^ and $80) = 0 then
    Result := 1
  else
  begin
    if (c^ and $FC) = $FC then // 4000000+
      Result := 6
    else if (c^ and $F8) = $F8 then // 200000-3FFFFFF
      Result := 5
    else if (c^ and $F0) = $F0 then // 10000-1FFFFF
      Result := 4
    else if (c^ and $E0) = $E0 then // 800-FFFF
      Result := 3
    else if (c^ and $C0) = $C0 then // 80-7FF
      Result := 2
    else
      Result := 1;
  end
end;

function CharSizeW(c: PQCharW): Integer;
begin
  if (c[0] >= #$D800) and (c[0] <= #$DBFF) and (c[1] >= #$DC00) and
    (c[1] <= #$DFFF) then
    Result := 2
  else
    Result := 1;
end;

function CharCodeA(c: PQCharA): Cardinal;
var
  T: QStringA;
begin
  T := AnsiDecode(c, CharSizeA(c));
  Result := CharCodeW(PQCharW(T));
end;

function CharCodeU(c: PQCharA): Cardinal;
begin
  if (c^ and $80) <> 0 then
  begin
    if (c^ and $FC) = $FC then // 4000000+
    begin
      Result := (c^ and $03) shl 30;
      Inc(c);
      Result := Result or ((c^ and $3F) shl 24);
      Inc(c);
      Result := Result or ((c^ and $3F) shl 18);
      Inc(c);
      Result := Result or ((c^ and $3F) shl 12);
      Inc(c);
      Result := Result or ((c^ and $3F) shl 6);
      Inc(c);
      Result := Result or (c^ and $3F);
    end
    else if (c^ and $F8) = $F8 then // 200000-3FFFFFF
    begin
      Result := (c^ and $07) shl 24;
      Inc(c);
      Result := Result or ((c^ and $3F) shl 18);
      Inc(c);
      Result := Result or ((c^ and $3F) shl 12);
      Inc(c);
      Result := Result or ((c^ and $3F) shl 6);
      Inc(c);
      Result := Result or (c^ and $3F);
    end
    else if (c^ and $F0) = $F0 then // 10000-1FFFFF
    begin
      Result := (c^ and $0F) shr 18;
      Inc(c);
      Result := Result or ((c^ and $3F) shl 12);
      Inc(c);
      Result := Result or ((c^ and $3F) shl 6);
      Inc(c);
      Result := Result or (c^ and $3F);
    end
    else if (c^ and $E0) = $E0 then // 800-FFFF
    begin
      Result := (c^ and $1F) shl 12;
      Inc(c);
      Result := Result or ((c^ and $3F) shl 6);
      Inc(c);
      Result := Result or (c^ and $3F);
    end
    else if (c^ and $C0) = $C0 then // 80-7FF
    begin
      Result := (c^ and $3F) shl 6;
      Inc(c);
      Result := Result or (c^ and $3F);
    end
    else
      raise Exception.Create(Format(SBadUtf8Char, [IntPtr(c^)]));
  end
  else
    Result := c^;
end;

function CharCodeW(c: PQCharW): Cardinal;
begin
  if (c^ >= #$D800) and (c^ <= #$DFFF) then // Unicode ��չ���ַ�
  begin
    Result := (Ord(c^) - $D800);
    Inc(c);
    if (c^ >= #$DC00) and (c^ <= #$DFFF) then
    begin
      Result := $10000 + ((Result shl 10) + (Cardinal(Ord(c^)) - $DC00));
    end
    else
      Result := 0
  end
  else
    Result := Ord(c^);
end;

function CharAdd(const w: WideChar; ADelta: Integer): WideChar;
begin
  Result := WideChar(Ord(w) + ADelta);
end;

function CharDelta(const c1, c2: WideChar): Integer;
begin
  Result := Ord(c1) - Ord(c2);
end;

function CharCountA(const source: QStringA): Integer;
var
  p: PQCharA;
  l, ASize: Integer;
begin
  p := PQCharA(source);
  l := source.Length;
  Result := 0;
  while l > 0 do
  begin
    ASize := CharSizeA(p);
    Dec(l, ASize);
    Inc(p, ASize);
    Inc(Result);
  end;
  // Result:=TEncoding.ANSI.GetCharCount(source);
end;

function CharCountW(const S: QStringW): Integer;
var
  p, pe: PWord;
  ALen: Integer;
  procedure CountChar;
  begin
    if (p^ > $D800) and (p^ < $DFFF) then
    begin
      Inc(p);
      if (p^ >= $DC00) and (p^ < $DFFF) then
      begin
        Inc(p);
        Inc(Result);
      end
      else
        Result := -1;
    end
    else
    begin
      Inc(Result);
      Inc(p);
    end;
  end;

begin
  Result := 0;
  p := PWord(S);
  ALen := Length(S);
  pe := PWord(IntPtr(p) + (ALen shl 1));
  while IntPtr(p) < IntPtr(pe) do
    CountChar;
end;

function CharCountU(const source: QStringA): Integer;
var
  p, pe: PQCharA;
  procedure CountChar;
  begin
    if (p^ and $80) = 0 then
    begin
      Inc(Result);
      Inc(p);
    end
    else if (p^ and $FC) = $FC then
    begin
      Inc(Result);
      Inc(p, 6);
    end
    else if (p^ and $F8) = $F8 then
    begin
      Inc(Result);
      Inc(p, 5);
    end
    else if (p^ and $F0) = $F0 then
    begin
      Inc(Result);
      Inc(p, 4);
    end
    else if (p^ and $E0) = $E0 then
    begin
      Inc(Result);
      Inc(p, 3);
    end
    else if (p^ and $C0) = $C0 then
    begin
      Inc(Result);
      Inc(p, 2);
    end
    else
      Result := -1;
  end;

begin
  Result := 0;
  p := PQCharA(source);
  pe := PQCharA(IntPtr(p) + source.Length);
  while (IntPtr(p) < IntPtr(pe)) and (Result >= 0) do
    CountChar;
end;

procedure CalcCharLengthA(var Lens: TIntArray; const List: array of QCharA);
var
  I, l: Integer;
begin
  I := Low(List);
  System.SetLength(Lens, Length(List));
  while I <= High(List) do
  begin
    l := CharSizeA(@List[I]);
    Lens[I] := l;
    Inc(I, l);
  end;
end;

function CharInA(const c: PQCharA; const List: array of QCharA;
  ACharLen: PInteger): Boolean;
var
  I, count: Integer;
  Lens: TIntArray;
begin
  count := High(List) + 1;
  Result := false;
  CalcCharLengthA(Lens, List);
  I := Low(List);
  while I < count do
  begin
    if CompareMem(c, @List[I], Lens[I]) then
    begin
      if ACharLen <> nil then
        ACharLen^ := Lens[I];
      Result := True;
      Break;
    end
    else
      Inc(I, Lens[I]);
  end;
end;

procedure CalcCharLengthW(var Lens: TIntArray; const List: array of QCharW);
var
  I, l: Integer;
begin
  I := Low(List);
  System.SetLength(Lens, Length(List));
  while I <= High(List) do
  begin
    l := CharSizeW(@List[I]);
    Lens[I] := l;
    Inc(I, l);
  end;
end;

function CharInW(const c: PQCharW; const List: array of QCharW;
  ACharLen: PInteger): Boolean;
var
  I, count: Integer;
  Lens: TIntArray;
begin
  count := High(List) + 1;
  Result := false;
  CalcCharLengthW(Lens, List);
  I := Low(List);
  while I < count do
  begin
    if c^ = List[I] then
    begin
      if Lens[I] = 2 then
      begin
        Result := c[1] = List[I + 1];
        if Assigned(ACharLen) and Result then
          ACharLen^ := 2;
        if Result then
          Break;
      end
      else
      begin
        Result := True;
        if Assigned(ACharLen) then
          ACharLen^ := 1;
        Break;
      end;
    end;
    Inc(I, Lens[I]);
  end;
end;

function CharInW(const c, List: PQCharW; ACharLen: PInteger): Boolean;
var
  p: PQCharW;
begin
  Result := false;
  p := List;
  while p^ <> #0 do
  begin
    if p^ = c^ then
    begin
      if (p[0] >= #$D800) and (p[0] <= #$DBFF) then
      begin
        // (p[1] >= #$DC00) and (p[1] <= #$DFFF)
        if p[1] = c[1] then
        begin
          Result := True;
          if ACharLen <> nil then
            ACharLen^ := 2;
          Break;
        end;
      end
      else
      begin
        Result := True;
        if ACharLen <> nil then
          ACharLen^ := 1;
        Break;
      end;
    end;
    Inc(p);
  end;
end;

procedure CalcCharLengthU(var Lens: TIntArray; const List: array of QCharA);
var
  I, l: Integer;
begin
  I := Low(List);
  System.SetLength(Lens, Length(List));
  while I <= High(List) do
  begin
    l := CharSizeU(@List[I]);
    Lens[I] := l;
    Inc(I, l);
  end;
end;

function CharInU(const c: PQCharA; const List: array of QCharA;
  ACharLen: PInteger): Boolean;
var
  I, count: Integer;
  Lens: TIntArray;
begin
  count := High(List) + 1;
  Result := false;
  CalcCharLengthU(Lens, List);
  I := Low(List);
  while I < count do
  begin
    if CompareMem(c, @List[I], Lens[I]) then
    begin
      if ACharLen <> nil then
        ACharLen^ := Lens[I];
      Result := True;
      Break;
    end
    else
      Inc(I, Lens[I]);
  end;
end;

function StrInW(const S: QStringW; const Values: array of QStringW;
  AIgnoreCase: Boolean): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(Values) to High(Values) do
  begin
    if (Values[I] = S) or (AIgnoreCase and (CompareText(Values[I], S) = 0)) then
    begin
      Result := I;
      Break;
    end;
  end
end;

function StrInW(const S: QStringW; Values: TStrings;
  AIgnoreCase: Boolean = false): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Values.count - 1 do
  begin
    if (Values[I] = S) or (AIgnoreCase and (CompareText(Values[I], S) = 0)) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function IsSpaceA(const c: PQCharA; ASpaceSize: PInteger): Boolean;
begin
  if c^ in [9, 10, 13, 32, $A0] then
  begin
    Result := True;
    if Assigned(ASpaceSize) then
      ASpaceSize^ := 1;
  end
  else if (c^ = 161) and (PQCharA(IntPtr(c) + 1)^ = 161) then
  begin
    Result := True;
    if Assigned(ASpaceSize) then
      ASpaceSize^ := 2;
  end
  else
    Result := false;
end;

function IsSpaceW(const c: PQCharW; ASpaceSize: PInteger): Boolean;
begin
  Result := (c^ = #9) or (c^ = #10) or (c^ = #13) or (c^ = #32) or
    (c^ = WideChar($A0)) or (c^ = #$3000);
  if Result and Assigned(ASpaceSize) then
    ASpaceSize^ := 1;
end;

function IsSpaceU(const c: PQCharA; ASpaceSize: PInteger): Boolean;
begin
  // ȫ�ǿո�$3000��UTF-8������227,128,128
  if c^ in [9, 10, 13, 32, $A0] then
  begin
    Result := True;
    if Assigned(ASpaceSize) then
      ASpaceSize^ := 1;
  end
  else if (c^ = 227) and (PQCharA(IntPtr(c) + 1)^ = 128) and
    (PQCharA(IntPtr(c) + 2)^ = 128) then
  begin
    Result := True;
    if Assigned(ASpaceSize) then
      ASpaceSize^ := 3;
  end
  else
    Result := false;
end;

function TrimSpaceW(const S: QStringW): QStringW;
var
  ps, pd: PQCharW;
  ASize: Integer;
begin
  ps := PQCharW(S);
  SetLength(Result, Length(S));
  pd := PQCharW(Result);
  while ps^ <> #0 do
  begin
    if IsSpaceW(ps, @ASize) then
      Inc(ps, ASize)
    else
    begin
      pd^ := ps^;
      Inc(ps);
      Inc(pd);
    end;
  end;
  SetLength(Result, pd - PQCharW(Result));
end;

function CNFullToHalf(const S: QStringW): QStringW;
var
  p, pd: PWord;
  l: Integer;
begin
  l := Length(S);
  if l > 0 then
  begin
    System.SetLength(Result, l);
    p := PWord(PQCharW(S));
    pd := PWord(PQCharW(Result));
    while l > 0 do
    begin
      if (p^ = $3000) then // ȫ�ǿո�'��'
        pd^ := $20
      else if (p^ >= $FF01) and (p^ <= $FF5E) then
        pd^ := $21 + (p^ - $FF01)
      else
        pd^ := p^;
      Dec(l);
      Inc(p);
      Inc(pd);
    end;
  end
  else
    System.SetLength(Result, 0);
end;

function CNHalfToFull(const S: QStringW): QStringW;
var
  p, pd: PWord;
  l: Integer;
begin
  l := Length(S);
  if l > 0 then
  begin
    System.SetLength(Result, l);
    p := PWord(PQCharW(S));
    pd := PWord(PQCharW(Result));
    while l > 0 do
    begin
      if p^ = $20 then // ȫ�ǿո�'��'
        pd^ := $3000
      else if (p^ >= $21) and (p^ <= $7E) then
        pd^ := $FF01 + (p^ - $21)
      else
        pd^ := p^;
      Dec(l);
      Inc(p);
      Inc(pd);
    end;
  end
  else
    System.SetLength(Result, 0);
end;

function QuotedStrA(const S: QStringA; const AQuoter: QCharA): QStringA;
var
  p, pe, pd, pds: PQCharA;
begin
  p := PQCharA(S);
  Result.Length := S.Length shl 1;
  pe := p;
  Inc(pe, S.Length);
  pd := PQCharA(Result);
  pds := pd;
  pd^ := AQuoter;
  Inc(pd);
  while IntPtr(p) < IntPtr(pe) do
  begin
    if p^ = AQuoter then
    begin
      pd^ := AQuoter;
      Inc(pd);
      pd^ := AQuoter;
    end
    else
      pd^ := p^;
    Inc(pd);
    Inc(p);
  end;
  pd^ := AQuoter;
  Result.Length := IntPtr(pd) - IntPtr(pds) + 1;
end;

function QuotedStrW(const S: QStringW; const AQuoter: QCharW): QStringW;
var
  p, pe, pd, pds: PQCharW;
  l: Integer;
begin
  if AQuoter <> #0 then
  begin
    l := System.Length(S);
    p := PQCharW(S);
    SetLength(Result, (l + 1) shl 1);
    pe := p;
    Inc(pe, l);
    pd := PQCharW(Result);
    pds := pd;
    pd^ := AQuoter;
    Inc(pd);
    while IntPtr(p) < IntPtr(pe) do
    begin
      if p^ = AQuoter then
      begin
        pd^ := AQuoter;
        Inc(pd);
        pd^ := AQuoter;
      end
      else
        pd^ := p^;
      Inc(pd);
      Inc(p);
    end;
    pd^ := AQuoter;
    SetLength(Result, ((IntPtr(pd) - IntPtr(pds)) shr 1) + 1);
  end
  else
    Result := S;
end;

function SQLQuoted(const S: QStringW; ADoEscape: Boolean): QStringW;
begin
  if ADoEscape then
    Result := QuotedStrW(StringReplaceW(S, '\', '\\', [rfReplaceAll]))
  else
    Result := QuotedStrW(S);
end;

function DequotedStrA(const S: QStringA; const AQuoter: QCharA): QStringA;
var
  p, pe, pd, pds: PQCharA;
begin
  if (S.Length > 0) and (S[0] = AQuoter) and (S[S.Length - 1] = AQuoter) then
  begin
    p := PQCharA(S);
    pe := p;
    Inc(pe, S.Length);
    Inc(p);
    Result.Length := S.Length;
    pd := PQCharA(Result);
    pds := pd;
    while IntPtr(p) < IntPtr(pe) do
    begin
      if p^ = AQuoter then
      begin
        Inc(p);
        if p^ = AQuoter then
        begin
          pd^ := AQuoter;
        end
        else if IntPtr(p) < IntPtr(pe) then // ���治�ǵ�����,������ַ�����ֱ�ӿ�������
        begin
          pd^ := AQuoter;
          Inc(pd);
          pd^ := p^;
        end
        else
          Break;
      end
      else
        pd^ := p^;
      Inc(p);
      Inc(pd);
    end;
    Result.Length := IntPtr(pd) - IntPtr(pds);
  end
  else
    Result := S;
end;

function DequotedStrW(const S: QStringW; const AQuoter: QCharW): QStringW;
var
  p, pe, pd, pds: PQCharW;
begin
  if (Length(S) > 0) and (PQCharW(S)[0] = AQuoter) and
    (PQCharW(S)[Length(S) - 1] = AQuoter) then
  begin
    p := PQCharW(S);
    pe := p;
    Inc(pe, Length(S));
    Inc(p);
    SetLength(Result, Length(S));
    pd := PQCharW(Result);
    pds := pd;
    while IntPtr(p) < IntPtr(pe) do
    begin
      if p^ = AQuoter then
      begin
        Inc(p);
        if p^ = AQuoter then
        begin
          pd^ := AQuoter;
        end
        else if IntPtr(p) < IntPtr(pe) then // ���治�ǵ�����,������ַ�����ֱ�ӿ�������
        begin
          pd^ := AQuoter;
          Inc(pd);
          pd^ := p^;
        end
        else
          Break;
      end
      else
        pd^ := p^;
      Inc(p);
      Inc(pd);
    end;
    SetLength(Result, (IntPtr(pd) - IntPtr(pds)) shr 1);
  end
  else
    Result := S;
end;

function SkipCharA(var p: PQCharA; const List: array of QCharA): Integer;
var
  I, count: Integer;
  Lens: TIntArray;
  AFound: Boolean;
  ps: PQCharA;
begin
  count := High(List) + 1;
  Result := 0;
  if count > 0 then
  begin
    CalcCharLengthA(Lens, List);
    ps := p;
    while p^ <> 0 do
    begin
      I := Low(List);
      AFound := false;
      while I < count do
      begin
        if CompareMem(p, @List[I], Lens[I]) then
        begin
          AFound := True;
          Inc(p, Lens[I]);
          Break;
        end
        else
          Inc(I, Lens[I]);
      end;
      if not AFound then
      begin
        Result := IntPtr(p) - IntPtr(ps);
        Break;
      end;
    end;
  end;
end;

function SkipCharU(var p: PQCharA; const List: array of QCharA): Integer;
var
  I, count: Integer;
  Lens: TIntArray;
  AFound: Boolean;
  ps: PQCharA;
begin
  count := High(List) + 1;
  Result := 0;
  if count > 0 then
  begin
    CalcCharLengthU(Lens, List);
    ps := p;
    while p^ <> 0 do
    begin
      I := Low(List);
      AFound := false;
      while I < count do
      begin
        if CompareMem(p, @List[I], Lens[I]) then
        begin
          AFound := True;
          Inc(p, Lens[I]);
          Break;
        end
        else
          Inc(I, Lens[I]);
      end;
      if not AFound then
      begin
        Result := IntPtr(p) - IntPtr(ps);
        Break;
      end;
    end;
  end;
end;

function SkipCharW(var p: PQCharW; const List: array of QCharA): Integer;
var
  I, count: Integer;
  Lens: TIntArray;
  AFound: Boolean;
  ps: PQCharW;
begin
  count := High(List) + 1;
  Result := 0;
  if count > 0 then
  begin
    CalcCharLengthA(Lens, List);
    ps := p;
    while p^ <> #0 do
    begin
      I := Low(List);
      AFound := false;
      while I < count do
      begin
        if CompareMem(p, @List[I], Lens[I] shl 1) then
        begin
          AFound := True;
          Break;
        end
        else
          Inc(I, Lens[I]);
      end;
      if AFound then
        Inc(p)
      else
      begin
        Result := IntPtr(p) - IntPtr(ps);
        Break;
      end;
    end;
  end;
end;

function SkipCharW(var p: PQCharW; const List: PQCharW): Integer;
var
  l: Integer;
  ps: PQCharW;
begin
  Result := 0;
  if (List <> nil) and (List^ <> #0) then
  begin
    ps := p;
    while p^ <> #0 do
    begin
      if CharInW(p, List, @l) then
        Inc(p, l)
      else
      begin
        Result := IntPtr(p) - IntPtr(ps);
        Break;
      end;
    end;
  end;
end;

function SkipSpaceA(var p: PQCharA): Integer;
var
  ps: PQCharA;
  l: Integer;
begin
  ps := p;
  while p^ <> 0 do
  begin
    if IsSpaceA(p, @l) then
      Inc(p, l)
    else
      Break;
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function SkipSpaceU(var p: PQCharA): Integer;
var
  ps: PQCharA;
  l: Integer;
begin
  ps := p;
  while p^ <> 0 do
  begin
    if IsSpaceU(p, @l) then
      Inc(p, l)
    else
      Break;
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function SkipSpaceW(var p: PQCharW): Integer;
var
  ps: PQCharW;
  l: Integer;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if IsSpaceW(p, @l) then
      Inc(p, l)
    else
      Break;
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

// ����һ��,��#10Ϊ�н�β
function SkipLineA(var p: PQCharA): Integer;
var
  ps: PQCharA;
begin
  ps := p;
  while p^ <> 0 do
  begin
    if p^ = 10 then
    begin
      Inc(p);
      Break;
    end
    else
      Inc(p);
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function SkipLineU(var p: PQCharA): Integer;
begin
  Result := SkipLineA(p);
end;

function SkipLineW(var p: PQCharW): Integer;
var
  ps: PQCharW;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if p^ = #10 then
    begin
      Inc(p);
      Break;
    end
    else
      Inc(p);
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function StrPosA(Start, Current: PQCharA; var ACol, ARow: Integer): PQCharA;
begin
  ACol := 1;
  ARow := 1;
  Result := Start;
  while IntPtr(Start) < IntPtr(Current) do
  begin
    if Start^ = 10 then
    begin
      Inc(ARow);
      ACol := 1;
      Inc(Start);
      Result := Start;
    end
    else
    begin
      Inc(Start, CharSizeA(Start));
      Inc(ACol);
    end;
  end;
end;

function StrPosU(Start, Current: PQCharA; var ACol, ARow: Integer): PQCharA;
begin
  ACol := 1;
  ARow := 1;
  Result := Start;
  while IntPtr(Start) < IntPtr(Current) do
  begin
    if Start^ = 10 then
    begin
      Inc(ARow);
      ACol := 1;
      Inc(Start);
      Result := Start;
    end
    else
    begin
      Inc(Start, CharSizeU(Start));
      Inc(ACol);
    end;
  end;
end;

function StrPosW(Start, Current: PQCharW; var ACol, ARow: Integer): PQCharW;
begin
  ACol := 1;
  ARow := 1;
  Result := Start;
  while Start < Current do
  begin
    if Start^ = #10 then
    begin
      Inc(ARow);
      ACol := 1;
      Inc(Start);
      Result := Start;
    end
    else
    begin
      Inc(Start, CharSizeW(Start));
      Inc(ACol);
    end;
  end;
end;

function DecodeTokenA(var p: PQCharA; ADelimiters: array of QCharA;
  AQuoter: QCharA; AIgnoreSpace: Boolean): QStringA;
var
  S: PQCharA;
  l: Integer;
begin
  if AIgnoreSpace then
    SkipSpaceA(p);
  S := p;
  while p^ <> 0 do
  begin
    if p^ = AQuoter then // ���õ����ݲ����
    begin
      Inc(p);
      while p^ <> 0 do
      begin
        if p^ = $5C then
        begin
          Inc(p);
          if p^ <> 0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInA(p, ADelimiters, @l) then
      Break
    else // \",\',"",''�ֱ����ת��
      Inc(p);
  end;
  l := IntPtr(p) - IntPtr(S);
  Result.Length := l;
  Move(S^, PQCharA(Result)^, l);
  while CharInA(p, ADelimiters, @l) do
    Inc(p, l);
end;

function DecodeTokenU(var p: PQCharA; ADelimiters: array of QCharA;
  AQuoter: QCharA; AIgnoreSpace: Boolean): QStringA;
var
  S: PQCharA;
  l: Integer;
begin
  if AIgnoreSpace then
    SkipSpaceU(p);
  S := p;
  while p^ <> 0 do
  begin
    if p^ = AQuoter then // ���õ����ݲ����
    begin
      Inc(p);
      while p^ <> 0 do
      begin
        if p^ = $5C then
        begin
          Inc(p);
          if p^ <> 0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInU(p, ADelimiters, @l) then
      Break
    else // \",\',"",''�ֱ����ת��
      Inc(p);
  end;
  l := IntPtr(p) - IntPtr(S);
  Result.Length := l;
  Move(S^, PQCharA(Result)^, l);
  while CharInU(p, ADelimiters, @l) do
    Inc(p, l);
end;

function DecodeTokenW(var p: PQCharW; ADelimiters: array of QCharW;
  AQuoter: QCharW; AIgnoreSpace: Boolean; ASkipDelimiters: Boolean): QStringW;
var
  S: PQCharW;
  l: Integer;
begin
  if AIgnoreSpace then
    SkipSpaceW(p);
  S := p;
  while p^ <> #0 do
  begin
    if p^ = AQuoter then // ���õ����ݲ����
    begin
      Inc(p);
      while p^ <> #0 do
      begin
        if p^ = #$5C then
        begin
          Inc(p);
          if p^ <> #0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInW(p, ADelimiters, @l) then
      Break
    else // \",\',"",''�ֱ����ת��
      Inc(p);
  end;
  l := p - S;
  SetLength(Result, l);
  Move(S^, PQCharW(Result)^, l shl 1);
  if ASkipDelimiters then
  begin
    while CharInW(p, ADelimiters, @l) do
      Inc(p, l);
  end;
  if AIgnoreSpace then
    SkipSpaceW(p);
end;

function DecodeTokenW(var p: PQCharW; ADelimiters: PQCharW; AQuoter: QCharW;
  AIgnoreSpace: Boolean; ASkipDelimiters: Boolean): QStringW;
var
  S: PQCharW;
  l: Integer;
begin
  if AIgnoreSpace then
    SkipSpaceW(p);
  S := p;
  while p^ <> #0 do
  begin
    if p^ = AQuoter then // ���õ����ݲ����
    begin
      Inc(p);
      while p^ <> #0 do
      begin
        if p^ = #$5C then
        begin
          Inc(p);
          if p^ <> #0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInW(p, ADelimiters, @l) then
      Break
    else // \",\',"",''�ֱ����ת��
      Inc(p);
  end;
  l := p - S;
  SetLength(Result, l);
  Move(S^, PQCharW(Result)^, l shl 1);
  if ASkipDelimiters then
  begin
    while CharInW(p, ADelimiters, @l) do
      Inc(p, l);
  end;
  if AIgnoreSpace then
    SkipSpaceW(p);
end;

function DecodeTokenW(var S: QStringW; ADelimiters: PQCharW; AQuoter: QCharW;
  AIgnoreCase, ARemove, ASkipDelimiters: Boolean): QStringW;
var
  p: PQCharW;
begin
  p := PQCharW(S);
  Result := DecodeTokenW(p, ADelimiters, AQuoter, AIgnoreCase, ASkipDelimiters);
  if ARemove then
    S := StrDupX(p, Length(S) - (p - PQCharW(S)));
end;

function SplitTokenW(AList: TStrings; p: PQCharW; ADelimiters: PQCharW;
  AQuoter: QCharW; AIgnoreSpace: Boolean): Integer;
begin
  Result := 0;
  AList.BeginUpdate;
  try
    while p^ <> #0 do
    begin
      AList.Add(DecodeTokenW(p, ADelimiters, AQuoter, AIgnoreSpace, True));
      Inc(Result);
    end;
  finally
    AList.EndUpdate;
  end;
end;

function SplitTokenW(AList: TStrings; const S: QStringW; ADelimiters: PQCharW;
  AQuoter: QCharW; AIgnoreSpace: Boolean): Integer;
begin
  Result := SplitTokenW(AList, PQCharW(S), ADelimiters, AQuoter, AIgnoreSpace);
end;

function SplitTokenW(const S: QStringW; ADelimiters: PQCharW; AQuoter: QCharW;
  AIgnoreSpace: Boolean): TQStringArray;
var
  l: Integer;
  p: PQCharW;
begin
  SetLength(Result, 4);
  l := 0;
  p := PQCharW(S);
  repeat
    Result[l] := DecodeTokenW(p, ADelimiters, AQuoter, AIgnoreSpace);
    Inc(l);
    if (l = Length(Result)) and (p^ <> #0) then
      SetLength(Result, l + 4);
  until p^ = #0;
  SetLength(Result, l);
end;

function StrBeforeW(var source: PQCharW; const ASpliter: QStringW;
  AIgnoreCase, ARemove: Boolean; AMustMatch: Boolean = false): QStringW;
var
  pe: PQCharW;
  len: Integer;
begin
  if Assigned(source) then
  begin
    if AIgnoreCase then
      pe := StrIStrW(source, PQCharW(ASpliter))
    else
      pe := StrStrW(source, PQCharW(ASpliter));
    if Assigned(pe) then
    begin
      len := (IntPtr(pe) - IntPtr(source)) shr 1;
      Result := StrDupX(source, len);
      if ARemove then
      begin
        Inc(pe, Length(ASpliter));
        source := pe;
      end;
    end
    else if not AMustMatch then
    begin
      Result := source;
      if ARemove then
        source := nil;
    end
    else
      SetLength(Result, 0);
  end
  else
    SetLength(Result, 0);
end;

function StrBeforeW(var source: QStringW; const ASpliter: QStringW;
  AIgnoreCase, ARemove: Boolean; AMustMatch: Boolean): QStringW;
var
  p, pe: PQCharW;
  len: Integer;
begin
  p := PQCharW(source);
  if AIgnoreCase then
    pe := StrIStrW(p, PQCharW(ASpliter))
  else
    pe := StrStrW(p, PQCharW(ASpliter));
  if Assigned(pe) then
  begin
    len := (IntPtr(pe) - IntPtr(p)) shr 1;
    Result := StrDupX(p, len);
    if ARemove then
    begin
      Inc(pe, Length(ASpliter));
      len := Length(source) - len - Length(ASpliter);
      Move(pe^, p^, len shl 1);
      SetLength(source, len);
    end;
  end
  else if not AMustMatch then
  begin
    Result := source;
    if ARemove then
      SetLength(source, 0);
  end
  else
    SetLength(Result, 0);
end;

function SplitByStrW(AList: TStrings; ASource: QStringW;
  const ASpliter: QStringW; AIgnoreCase: Boolean): Integer;
var
  p: PQCharW;
begin
  if Length(ASource) > 0 then
  begin
    p := PQCharW(ASource);
    Result := 0;
    AList.BeginUpdate;
    try
      while Assigned(p) do
      begin
        AList.Add(StrBeforeW(p, ASpliter, AIgnoreCase, True, false));
        Inc(Result);
      end;
    finally
      AList.EndUpdate;
    end;
  end
  else
    Result := 0;
end;

function UpperFirstW(const S: QStringW): QStringW;
var
  p, pd: PQCharW;
begin
  if Length(S) > 0 then
  begin
    p := PQCharW(S);
    SetLength(Result, Length(S));
    pd := PQCharW(Result);
    pd^ := CharUpperW(p^);
    Inc(p);
    Inc(pd);
    while p^ <> #0 do
    begin
      pd^ := CharLowerW(p^);
      Inc(p);
      Inc(pd);
    end;
  end
  else
    Result := S;
end;

function DecodeLineA(var p: PQCharA; ASkipEmpty: Boolean; AMaxSize: Integer)
  : QStringA;
var
  ps: PQCharA;
begin
  ps := p;
  while p^ <> 0 do
  begin
    if ((p^ = 13) and (PQCharA(IntPtr(p) + 1)^ = 10)) or (p^ = 10) then
    begin
      if ps = p then
      begin
        if ASkipEmpty then
        begin
          if p^ = 13 then
            Inc(p, 2)
          else
            Inc(p);
          ps := p;
        end
        else
        begin
          Result.Length := 0;
          Exit;
        end;
      end
      else
      begin
        Result.Length := IntPtr(p) - IntPtr(ps);
        Move(ps^, PQCharA(Result)^, IntPtr(p) - IntPtr(ps));
        if p^ = 13 then
          Inc(p, 2)
        else
          Inc(p);
        Exit;
      end;
    end
    else
      Inc(p);
  end;
  if ps = p then
    Result.Length := 0
  else
  begin
    Result.Length := IntPtr(p) - IntPtr(ps);
    Move(ps^, PQCharA(Result)^, IntPtr(p) - IntPtr(ps));
  end;
  if Result.Length > AMaxSize then
  begin
    Move(Result.FValue[Result.Length - AMaxSize + 3], Result.FValue[4],
      AMaxSize - 3);
    Result.FValue[1] := $2E;
    // ...
    Result.FValue[2] := $2E;
    Result.FValue[3] := $2E;
  end;
end;

function DecodeLineU(var p: PQCharA; ASkipEmpty: Boolean; AMaxSize: Integer)
  : QStringA;
begin
  Result := DecodeLineA(p, ASkipEmpty, MaxInt);
  if Result.Length > 0 then
  begin
    Result.FValue[0] := 1;
    if Result.Length > AMaxSize then
    begin
      Move(Result.FValue[Result.Length - AMaxSize + 3], Result.FValue[4],
        AMaxSize - 3);
      Result.FValue[1] := $2E;
      // ...
      Result.FValue[2] := $2E;
      Result.FValue[3] := $2E;
    end;
  end;
end;

function DecodeLineW(var p: PQCharW; ASkipEmpty: Boolean; AMaxSize: Integer;
  AQuoterChar: QCharW): QStringW;
var
  ps: PQCharW;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if p^ = AQuoterChar then
    begin
      Inc(p);
      while p^ <> #0 do
      begin
        if p^ = #$5C then
        begin
          Inc(p);
          if p^ <> #0 then
            Inc(p);
        end
        else if p^ = AQuoterChar then
        begin
          Inc(p);
          if p^ = AQuoterChar then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end;
    if ((p[0] = #13) and (p[1] = #10)) or (p[0] = #10) then
    begin
      if ps = p then
      begin
        if ASkipEmpty then
        begin
          if p^ = #13 then
            Inc(p, 2)
          else
            Inc(p);
          ps := p;
        end
        else
        begin
          SetLength(Result, 0);
          Exit;
        end;
      end
      else
      begin
        SetLength(Result, p - ps);
        Move(ps^, PQCharW(Result)^, IntPtr(p) - IntPtr(ps));
        if p^ = #13 then
          Inc(p, 2)
        else
          Inc(p);
        Exit;
      end;
    end
    else
      Inc(p);
  end;
  if ps = p then
    SetLength(Result, 0)
  else
  begin
    SetLength(Result, p - ps);
    Move(ps^, PQCharW(Result)^, IntPtr(p) - IntPtr(ps));
  end;
  if Length(Result) > AMaxSize then
    Result := '...' + RightStrW(Result, AMaxSize - 3, True);
end;

function DecodeLineW(AStream: TStream; AEncoding: TTextEncoding;
  var ALine: QStringW): Boolean;
var
  ABuf: array [0 .. 4095] of Byte;
  AReaded, I, ACount: Integer;
  pd: PQCharW;
  procedure NeedSize(ADelta: Integer);
  begin
    if Length(ALine) < (ACount + (ADelta shr 1)) then
    begin
      SetLength(ALine, Length(ALine) + 4096);
      pd := PQCharW(ALine);
      Inc(pd, ACount);
    end;
  end;
  procedure Append(ADelta: Integer);
  begin
    NeedSize(ADelta);
    Move(ABuf[0], pd^, ADelta);
    pd := PQCharW(IntPtr(pd) + ADelta);
    Inc(ACount, ADelta shr 1);
  end;

begin
  ACount := 0;
  Result := false;
  SetLength(ALine, 4096);
  pd := PQCharW(ALine);
  repeat
    AReaded := AStream.Read(ABuf[0], 4096);
    for I := 0 to AReaded - 1 do
    begin
      if ABuf[I] = 10 then
      begin
        Append(I);
        if AEncoding = teUnicode16LE then
          AStream.Seek(I - AReaded + 2, soCurrent)
        else
          AStream.Seek(I - AReaded + 1, soCurrent);
        Result := True;
        Break;
      end;
    end;
    if not Result then
      Append(AReaded);
  until Result or (AStream.Position = AStream.Size);
  Result := ACount > 0;
  if AEncoding <> teUnicode16LE then
    ALine := DecodeText(PQCharW(ALine), Length(ALine) shl 1, AEncoding)
  else
  begin
    pd := PQCharW(ALine);
    if PQCharW(IntPtr(pd) + (ACount shl 1) - 2)^ = #13 then
      Dec(ACount, 1);
    SetLength(ALine, ACount);
  end;
end;

function LeftStrW(const S: QStringW; AMaxCount: Integer; ACheckExt: Boolean)
  : QStringW;
var
  ps, p: PQCharW;
  l: Integer;
begin
  l := Length(S);
  if AMaxCount > l then
    Result := S
  else if AMaxCount > 0 then
  begin
    ps := PQCharW(S);
    if ACheckExt then
    begin
      p := ps;
      while (p^ <> #0) and (AMaxCount > 0) do
      begin
        if (p^ >= #$D800) and (p^ <= #$DBFF) then
        begin
          Inc(p);
          if (p^ >= #$DC00) and (p^ <= #$DFFF) then
            Inc(p);
          // else ��Ч����չ���ַ�����Ȼѭ������
        end
        else
          Inc(p);
        Dec(AMaxCount);
      end;
      l := p - ps;
      SetLength(Result, l);
      Move(ps^, PQCharW(Result)^, l shl 1);
    end
    else
    begin
      SetLength(Result, AMaxCount);
      Move(ps^, PQCharW(Result)^, AMaxCount shl 1);
    end;
  end
  else
    SetLength(Result, 0);
end;

function LeftStrW(var S: QStringW; const ADelimiters: QStringW;
  ARemove: Boolean): QStringW;
begin
  Result := DecodeTokenW(S, PQCharW(ADelimiters), QCharW(#0), false, ARemove);
end;

function RightStrW(const S: QStringW; AMaxCount: Integer; ACheckExt: Boolean)
  : QStringW;
var
  ps, p: PQCharW;
  l: Integer;
begin
  l := Length(S);
  if AMaxCount > l then
    Result := S
  else if AMaxCount > 0 then
  begin
    ps := PQCharW(S);
    if ACheckExt then
    begin
      p := ps + l - 1;
      while (p > ps) and (AMaxCount > 0) do
      begin
        if (p^ >= #$DC00) and (p^ <= #$DFFF) then
        begin
          Dec(p);
          if (p^ >= #$D800) and (p^ <= #$DBFF) then
            Dec(p)
            // else ��Ч����չ���ַ�����Ȼѭ������
        end
        else
          Dec(p);
        Dec(AMaxCount);
      end;
      Inc(p);
      l := l - (p - ps);
      SetLength(Result, l);
      Move(p^, PQCharW(Result)^, l shl 1);
    end
    else
    begin
      Inc(ps, l - AMaxCount);
      SetLength(Result, AMaxCount);
      Move(ps^, PQCharW(Result)^, AMaxCount shl 1);
    end;
  end
  else
    SetLength(Result, 0);
end;

function RightStrW(var S: QStringW; const ADelimiters: QStringW;
  ARemove: Boolean): QStringW;
var
  ps, pe, pd: PQCharW;
begin
  ps := PQCharW(S);
  pe := PQCharW(IntPtr(ps) + (Length(S) shl 1));
  pd := PQCharW(ADelimiters);
  while pe > ps do
  begin
    Dec(pe);
    if CharInW(pe, pd) then
    begin
      Inc(pe);
      Result := StrDupX(pe, (IntPtr(ps) + (Length(S) shl 1) -
        IntPtr(pe)) shr 1);
      if ARemove then
        S := StrDupX(ps, (IntPtr(pe) - IntPtr(ps) - 1) shr 1);
      Exit;
    end;
  end;
  Result := S;
  if ARemove then
    SetLength(S, 0);
end;

function StrBetweenEx(S: QStringW; const AStartTag, AEndTag: QStringW;
  AIgnoreCase: Boolean; AQuoter: QCharW = #0): TQStringArray;
type
  TStrFounder = function(p1, p2: PQCharW): PQCharW;
var
  ps, pe: PQCharW;
  l: Integer;
  AFounder: TStrFounder;
begin
  ps := PQCharW(S);
  if AIgnoreCase then
    AFounder := StrIStrW
  else
    AFounder := StrStrW;
  ps := AFounder(ps, PQCharW(AStartTag));
  if ps <> nil then
  begin
    Inc(ps, Length(AStartTag));
    pe := AFounder(ps, PQCharW(AEndTag));
    if pe <> nil then
    begin
      SetLength(Result, 3);
      l := ps - PQCharW(S) - Length(AStartTag);
      Result[0] := Copy(S, 0, l);
      l := pe - ps;
      Result[1] := Copy(ps, 0, l);
      Inc(pe, Length(AEndTag));
      Result[2] := pe;
    end
    else
      SetLength(Result, 0);
  end
  else
    SetLength(Result, 0);
end;
function StrBetween(var S: PQCharW; AStartTag, AEndTag: QStringW;
  AIgnoreCase: Boolean; AQuoter: QCharW): QStringW;
var
  ps, pe: PQCharW;
  l: Integer;
begin
  if AIgnoreCase then
  begin
    ps := StrIStrW(S, PQCharW(AStartTag));
    if ps <> nil then
    begin
      Inc(ps, Length(AStartTag));
      pe := StrIStrW(ps, PQCharW(AEndTag));
      if pe <> nil then
      begin
        l := pe - ps;
        SetLength(Result, l);
        Move(ps^, PQCharW(Result)^, l shl 1);
        Inc(pe, Length(AEndTag));
        S := pe;
      end
      else
      begin
        SetLength(Result, 0);
        while S^ <> #0 do
          Inc(S);
      end;
    end
    else
    begin
      SetLength(Result, 0);
      while S^ <> #0 do
        Inc(S);
    end;
  end
  else
  begin
    ps := StrStrW(S, PQCharW(AStartTag));
    if ps <> nil then
    begin
      Inc(ps, Length(AStartTag));
      pe := StrStrW(ps, PQCharW(AEndTag));
      if pe <> nil then
      begin
        l := pe - ps;
        SetLength(Result, l);
        Move(ps^, PQCharW(Result)^, l shl 1);
        Inc(pe, Length(AEndTag));
        S := pe;
      end
      else
      begin
        SetLength(Result, 0);
        while S^ <> #0 do
          Inc(S);
      end
    end
    else
    begin
      SetLength(Result, 0);
      while S^ <> #0 do
        Inc(S);
    end;
  end;
end;

function StrBetween(const S: QStringW; const AStartTag, AEndTag: QStringW;
  AIgnoreCase: Boolean; AQuoter: QCharW = #0): QStringW;
var
  p: PQCharW;
begin
  p := PQCharW(S);
  Result := StrBetween(p, AStartTag, AEndTag, AIgnoreCase, AQuoter);
end;

function StrStrX(s1, s2: PQCharW; L1, L2: Integer;
  AIgnoreCase: Boolean): PQCharW;
var
  p1, p2: PQCharW;
begin
  Result := nil;
  while (s1^ <> #0) and (L1 >= L2) do
  begin
    if (s1^ = s2^) or
      (AIgnoreCase and (qstring.CharUpperW(s1^) = qstring.CharUpperW(s2^))) then
    begin
      p1 := s1;
      p2 := s2;
      repeat
        Inc(p1);
        Inc(p2);
        if p2^ = #0 then
        begin
          Result := s1;
          Exit;
        end
        else if (p1^ = p2^) or
          (AIgnoreCase and (qstring.CharUpperW(p1^) = qstring.CharUpperW(p2^)))
        then
          continue
        else
          Break;
      until 1 > 2;
    end;
    Inc(s1);
  end;
end;

function StrStrRX(s1, s2: PQCharW; L1, L2: Integer;
  AIgnoreCase: Boolean): PQCharW;
var
  ps1, ps2, p1, p2: PQCharW;
begin
  Result := nil;
  ps1 := s1 - 1;
  ps2 := s2 - 1;
  s1 := s1 - L1;
  s2 := s2 - L2;
  while (ps1 >= s1) and (L1 >= L2) do
  begin
    if (ps1^ = ps2^) or
      (AIgnoreCase and (qstring.CharUpperW(ps1^) = qstring.CharUpperW(ps2^)))
    then
    begin
      p1 := ps1;
      p2 := ps2;
      while (p2 > s2) do
      begin
        Dec(p1);
        Dec(p2);
        if (p1^ = p2^) or
          (AIgnoreCase and (qstring.CharUpperW(p1^) = qstring.CharUpperW(p2^)))
        then
          continue
        else
          Break;
      end;
      if p2 = s2 then
      begin
        Result := ps1;
        Exit;
      end;
    end;
    Dec(ps1);
  end;
end;

function StrBetweenTimes(const S, ADelimiter: QStringW; AIgnoreCase: Boolean;
  AStartTimes: Integer = 0; AStopTimes: Integer = 1): QStringW;
var
  p, ps, pl, pd: PQCharW;
  L1, L2, ATimes: Integer;
begin
  ps := PQCharW(S);
  pd := PQCharW(ADelimiter);
  L1 := Length(S);
  L2 := Length(ADelimiter);
  ATimes := 0;
  if AStopTimes > 0 then
  begin
    // ������ʼλ��
    p := ps;
    while ATimes < AStartTimes do
    begin
      pl := p;
      p := StrStrX(p, pd, L1, L2, AIgnoreCase);
      if Assigned(p) then
      begin
        Inc(p, L2);
        Dec(L1, (IntPtr(p) - IntPtr(pl)) shr 1);
        Inc(ATimes);
      end
      else
        Break;
    end;
    // ���ҽ���λ��
    ps := p;
    while ATimes < AStopTimes do
    begin
      pl := p;
      p := StrStrX(p, pd, L1, L2, AIgnoreCase);
      if Assigned(p) then
      begin
        Inc(p, Length(ADelimiter));
        Dec(L1, (IntPtr(p) - IntPtr(pl)) shr 1);
        Inc(ATimes);
      end
      else
        Break;
    end;
    if Assigned(p) then
      Result := StrDupX(ps, (IntPtr(p) - IntPtr(ps)) shr 1 - L2)
    else
      Result := S;
  end
  else if AStopTimes < 0 then // ����������
  begin
    p := ps + L1;
    while ATimes > AStartTimes do
    begin
      pl := p;
      p := StrStrRX(p, pd + L2, L1, L2, AIgnoreCase);
      if Assigned(p) then
      begin
        Dec(L1, (IntPtr(pl) - IntPtr(p)) shr 1);
        Dec(ATimes);
      end
      else
        Break;
    end;
    ps := p;
    while ATimes > AStopTimes do
    begin
      pl := p;
      p := StrStrRX(p, pd + L2, L1, L2, AIgnoreCase);
      if Assigned(p) then
      begin
        Dec(L1, (IntPtr(pl) - IntPtr(p)) shr 1);
        Dec(ATimes);
      end
      else
        Break;
    end;
    if Assigned(p) then
      Result := StrDupX(p + L2, (IntPtr(ps) - IntPtr(p)) shr 1 - L2)
    else
      Result := S;
  end;
end;

function TokenWithIndex(var S: PQCharW; AIndex: Integer; ADelimiters: PQCharW;
  AQuoter: QCharW; AIgnoreSapce: Boolean): QStringW;
begin
  SetLength(Result, 0);
  while (AIndex >= 0) and (S^ <> #0) do
  begin
    if AIndex <> 0 then
      DecodeTokenW(S, ADelimiters, AQuoter, AIgnoreSapce)
    else
    begin
      Result := DecodeTokenW(S, ADelimiters, AQuoter, AIgnoreSapce);
      Break;
    end;
    Dec(AIndex);
  end;
end;

function SkipUntilA(var p: PQCharA; AExpects: array of QCharA;
  AQuoter: QCharA): Integer;
var
  ps: PQCharA;
begin
  ps := p;
  while p^ <> 0 do
  begin
    if (p^ = AQuoter) then
    begin
      Inc(p);
      while p^ <> 0 do
      begin
        if p^ = $5C then
        begin
          Inc(p);
          if p^ <> 0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInA(p, AExpects) then
      Break
    else
      Inc(p, CharSizeA(p));
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function SkipUntilU(var p: PQCharA; AExpects: array of QCharA;
  AQuoter: QCharA): Integer;
var
  ps: PQCharA;
begin
  ps := p;
  while p^ <> 0 do
  begin
    if (p^ = AQuoter) then
    begin
      Inc(p);
      while p^ <> 0 do
      begin
        if p^ = $5C then
        begin
          Inc(p);
          if p^ <> 0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInU(p, AExpects) then
      Break
    else
      Inc(p, CharSizeU(p));
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function SkipUntilW(var p: PQCharW; AExpects: array of QCharW;
  AQuoter: QCharW): Integer;
var
  ps: PQCharW;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if (p^ = AQuoter) then
    begin
      Inc(p);
      while p^ <> #0 do
      begin
        if p^ = #$5C then
        begin
          Inc(p);
          if p^ <> #0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInW(p, AExpects) then
      Break
    else
      Inc(p, CharSizeW(p));
  end;
  Result := IntPtr(p) - IntPtr(ps);
end;

function SkipUntilW(var p: PQCharW; AExpects: PQCharW; AQuoter: QCharW)
  : Integer;
var
  ps: PQCharW;
begin
  ps := p;
  while p^ <> #0 do
  begin
    if (p^ = AQuoter) then
    begin
      Inc(p);
      while p^ <> #0 do
      begin
        if p^ = #$5C then
        begin
          Inc(p);
          if p^ <> #0 then
            Inc(p);
        end
        else if p^ = AQuoter then
        begin
          Inc(p);
          if p^ = AQuoter then
            Inc(p)
          else
            Break;
        end
        else
          Inc(p);
      end;
    end
    else if CharInW(p, AExpects) then
      Break
    else
      Inc(p, CharSizeW(p));
  end;
  Result := (IntPtr(p) - IntPtr(ps)) shr 1;
end;

function BackUntilW(var p: PQCharW; AExpects, AStartPos: PQCharW): Integer;
begin
  Result := 0;
  while p > AStartPos do
  begin
    if CharInW(p, AExpects) then
      Break;
    Dec(p);
    Inc(Result);
  end;
end;

function CharUpperA(c: QCharA): QCharA;
begin
  if (c >= $61) and (c <= $7A) then
    Result := c xor $20
  else
    Result := c;
end;

function CharUpperW(c: QCharW): QCharW;
begin
  if (c >= #$61) and (c <= #$7A) then
    Result := QCharW(PWord(@c)^ xor $20)
  else
    Result := c;
end;

function CharLowerA(c: QCharA): QCharA;
begin
  if (c >= Ord('A')) and (c <= Ord('Z')) then
    Result := Ord('a') + Ord(c) - Ord('A')
  else
    Result := c;
end;

function CharLowerW(c: QCharW): QCharW;
begin
  if (c >= 'A') and (c <= 'Z') then
    Result := QCharW(Ord('a') + Ord(c) - Ord('A'))
  else
    Result := c;
end;

function StartWithA(S, startby: PQCharA; AIgnoreCase: Boolean): Boolean;
begin
  while (S^ <> 0) and (startby^ <> 0) do
  begin
    if AIgnoreCase then
    begin
      if CharUpperA(S^) <> CharUpperA(startby^) then
        Break;
    end
    else if S^ <> startby^ then
      Break;
    Inc(S);
    Inc(startby);
  end;
  Result := (startby^ = 0);
end;

function StartWithU(S, startby: PQCharA; AIgnoreCase: Boolean): Boolean;
begin
  Result := StartWithA(S, startby, AIgnoreCase);
end;

function StartWithW(S, startby: PQCharW; AIgnoreCase: Boolean): Boolean;
begin
  if AIgnoreCase then
  begin
    while (S^ <> #0) and (startby^ <> #0) do
    begin
      if CharUpperW(S^) <> CharUpperW(startby^) then
        Break;
      Inc(S);
      Inc(startby);
    end;
  end
  else
  begin
    while (S^ <> #0) and (S^ = startby^) do
    begin
      Inc(S);
      Inc(startby);
    end;
  end;
  Result := (startby^ = #0);
end;

function EndWithA(const S, endby: QStringA; AIgnoreCase: Boolean): Boolean;
var
  p: PQCharA;
begin
  if S.Length < endby.Length then
    Result := false
  else
  begin
    p := PQCharA(S);
    Inc(p, S.Length - endby.Length);
    if AIgnoreCase then
      Result := (StrIStrA(p, PQCharA(endby)) = p)
    else
      Result := (StrStrA(p, PQCharA(endby)) = p);
  end;
end;

function EndWithU(const S, endby: QStringA; AIgnoreCase: Boolean): Boolean;
begin
  Result := EndWithA(S, endby, AIgnoreCase);
end;

function EndWithW(const S, endby: QStringW; AIgnoreCase: Boolean): Boolean;
var
  p: PQCharW;
begin
  if System.Length(S) < System.Length(endby) then
    Result := false
  else
  begin
    p := PQCharW(S);
    Inc(p, System.Length(S) - System.Length(endby));
    if AIgnoreCase then
      Result := (StrIStrW(p, PQCharW(endby)) = p)
    else
      Result := (StrStrW(p, PQCharW(endby)) = p);
  end;
end;

function SameCharsA(s1, s2: PQCharA; AIgnoreCase: Boolean): Integer;
begin
  Result := 0;
  if (s1 <> nil) and (s2 <> nil) then
  begin
    if AIgnoreCase then
    begin
      while (s1^ <> 0) and (s2^ <> 0) and
        ((s1^ = s2^) or (CharUpperA(s1^) = CharUpperA(s2^))) do
      begin
        Inc(Result);
        Inc(s1);
        Inc(s2);
      end;
    end
    else
    begin
      while (s1^ <> 0) and (s2^ <> 0) and (s1^ = s2^) do
      begin
        Inc(Result);
        Inc(s1);
        Inc(s2);
      end;
    end;
  end;
end;

function SameCharsU(s1, s2: PQCharA; AIgnoreCase: Boolean): Integer;
  function CompareSubSeq: Integer;
  var
    ACharSize1, ACharSize2: Integer;
  begin
    ACharSize1 := CharSizeU(s1) - 1;
    ACharSize2 := CharSizeU(s2) - 1;
    Result := 0;
    if ACharSize1 = ACharSize2 then
    begin
      Inc(s1);
      Inc(s2);
      while (ACharSize1 > 0) and (s1^ = s2^) do
      begin
        Inc(s1);
        Inc(s2);
      end;
      if ACharSize1 = 0 then
        Result := ACharSize2 + 1;
    end;
  end;

var
  ACharSize: Integer;
begin
  Result := 0;
  if (s1 <> nil) and (s2 <> nil) then
  begin
    if AIgnoreCase then
    begin
      while (s1^ <> 0) and (s2^ <> 0) and
        ((s1^ = s2^) or (CharUpperA(s1^) = CharUpperA(s2^))) do
      begin
        ACharSize := CompareSubSeq;
        if ACharSize <> 0 then
        begin
          Inc(Result);
          Inc(s1, ACharSize);
          Inc(s2, ACharSize);
        end
        else
          Break;
      end;
    end
    else
    begin
      while (s1^ <> 0) and (s2^ <> 0) and (s1^ = s2^) do
      begin
        ACharSize := CompareSubSeq;
        if ACharSize <> 0 then
        begin
          Inc(Result);
          Inc(s1, ACharSize);
          Inc(s2, ACharSize);
        end
        else
          Break;
      end;
    end;
  end;
end;

function SameCharsW(s1, s2: PQCharW; AIgnoreCase: Boolean): Integer;
begin
  Result := 0;
  if (s1 <> nil) and (s2 <> nil) then
  begin
    if AIgnoreCase then
    begin
      while (s1^ <> #0) and (s2^ <> #0) and
        ((s1^ = s2^) or (CharUpperW(s1^) = CharUpperW(s2^))) do
      begin
        Inc(Result);
        Inc(s1);
        Inc(s2);
      end;
    end
    else
    begin
      while (s1^ <> #0) and (s2^ <> #0) and (s1^ = s2^) do
      begin
        Inc(Result);
        Inc(s1);
        Inc(s2);
      end;
    end;
  end;
end;

function DetectTextEncoding(const p: Pointer; l: Integer; var b: Boolean)
  : TTextEncoding;
var
  pAnsi: PByte;
  pWide: PWideChar;
  I, AUtf8CharSize: Integer;
const
  NoUtf8Char: array [0 .. 3] of Byte = ($C1, $AA, $CD, $A8); // ANSI�������ͨ
  function IsUtf8Order(var ACharSize: Integer): Boolean;
  var
    I: Integer;
    ps: PByte;
  const
    Utf8Masks: array [0 .. 4] of Byte = ($C0, $E0, $F0, $F8, $FC);
  begin
    ps := pAnsi;
    ACharSize := CharSizeU(PQCharA(ps));
    Result := false;
    if ACharSize > 1 then
    begin
      I := ACharSize - 2;
      if ((Utf8Masks[I] and ps^) = Utf8Masks[I]) then
      begin
        Inc(ps);
        Result := True;
        for I := 1 to ACharSize - 1 do
        begin
          if (ps^ and $80) <> $80 then
          begin
            Result := false;
            Break;
          end;
          Inc(ps);
        end;
      end;
    end;
  end;

begin
  Result := teAnsi;
  b := false;
  if l >= 2 then
  begin
    pAnsi := PByte(p);
    pWide := PWideChar(p);
    b := True;
    if pWide^ = #$FEFF then
      Result := teUnicode16LE
    else if pWide^ = #$FFFE then
      Result := teUnicode16BE
    else if l >= 3 then
    begin
      if (pAnsi^ = $EF) and (PByte(IntPtr(pAnsi) + 1)^ = $BB) and
        (PByte(IntPtr(pAnsi) + 2)^ = $BF) then // UTF-8����
        Result := teUTF8
      else // ����ַ����Ƿ��з���UFT-8���������ַ���11...
      begin
        b := false;
        Result := teUnknown; // ����ΪUTF8���룬Ȼ�����Ƿ��в�����UTF-8���������
        I := 0;
        Dec(l, 2);
        while I <= l do
        begin
          if (pAnsi^ and $80) <> 0 then
          // ��λΪ1
          begin
            if (l - I >= 4) then
            begin
              if CompareMem(pAnsi, @NoUtf8Char[0], 4) then
              // ��ͨ��������Ե�������UTF-8������ж�����
              begin
                Inc(pAnsi, 4);
                Inc(I, 4);
                Result := teAnsi;
                continue;
              end;
            end;
            if IsUtf8Order(AUtf8CharSize) then
            begin
              Inc(pAnsi, AUtf8CharSize);
              Result := teUTF8;
              Break;
            end
            else
            begin
              Result := teAnsi;
              Break;
            end;
          end
          else
          begin
            if pAnsi^ = 0 then // 00 xx (xx<128) ��λ��ǰ����BE����
            begin
              if PByte(IntPtr(pAnsi) + 1)^ < 128 then
              begin
                Result := teUnicode16BE;
                Break;
              end;
            end
            else if PByte(IntPtr(pAnsi) + 1)^ = 0 then
            // xx 00 ��λ��ǰ����LE����
            begin
              Result := teUnicode16LE;
              Break;
            end;
            Inc(pAnsi);
            Inc(I);
          end;
          if Result = teUnknown then
            Result := teAnsi;
        end;
      end;
    end;
  end;
end;

function LoadTextA(const AFileName: String; AEncoding: TTextEncoding): QStringA;
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadTextA(AStream, AEncoding);
  finally
    AStream.Free;
  end;
end;

procedure ExchangeByteOrder(p: PQCharA; l: Integer);
var
  pe: PQCharA;
  c: QCharA;
begin
  pe := p;
  Inc(pe, l);
  while IntPtr(p) < IntPtr(pe) do
  begin
    c := p^;
    p^ := PQCharA(IntPtr(p) + 1)^;
    PQCharA(IntPtr(p) + 1)^ := c;
    Inc(p, 2);
  end;
end;

function ExchangeByteOrder(V: Smallint): Smallint;
var
  pv: array [0 .. 1] of Byte absolute V;
  pd: array [0 .. 1] of Byte absolute Result;
begin
  pd[0] := pv[1];
  pd[1] := pv[0];
end;

function ExchangeByteOrder(V: Word): Word;
var
  pv: array [0 .. 1] of Byte absolute V;
  pd: array [0 .. 1] of Byte absolute Result;
begin
  pd[0] := pv[1];
  pd[1] := pv[0];
end;

function ExchangeByteOrder(V: Integer): Integer;
var
  pv: array [0 .. 3] of Byte absolute V;
  pd: array [0 .. 3] of Byte absolute Result;
begin
  pd[0] := pv[3];
  pd[1] := pv[2];
  pd[2] := pv[1];
  pd[3] := pv[0];
end;

function ExchangeByteOrder(V: Cardinal): Cardinal;
var
  pv: array [0 .. 3] of Byte absolute V;
  pd: array [0 .. 3] of Byte absolute Result;
begin
  pd[0] := pv[3];
  pd[1] := pv[2];
  pd[2] := pv[1];
  pd[3] := pv[0];
end;

function ExchangeByteOrder(V: Int64): Int64;
var
  pv: array [0 .. 7] of Byte absolute V;
  pd: array [0 .. 7] of Byte absolute Result;
begin
  pd[0] := pv[7];
  pd[1] := pv[6];
  pd[2] := pv[5];
  pd[3] := pv[4];
  pd[4] := pv[3];
  pd[5] := pv[2];
  pd[6] := pv[1];
  pd[7] := pv[0];
end;

function ExchangeByteOrder(V: Single): Single;
var
  pv: array [0 .. 3] of Byte absolute V;
  pd: array [0 .. 3] of Byte absolute Result;
begin
  pd[0] := pv[3];
  pd[1] := pv[2];
  pd[2] := pv[1];
  pd[3] := pv[0];
end;

function ExchangeByteOrder(V: Double): Double;
var
  pv: array [0 .. 7] of Byte absolute V;
  pd: array [0 .. 7] of Byte absolute Result;
begin
  pd[0] := pv[7];
  pd[1] := pv[6];
  pd[2] := pv[5];
  pd[3] := pv[4];
  pd[4] := pv[3];
  pd[5] := pv[2];
  pd[6] := pv[1];
  pd[7] := pv[0];
end;

function LoadTextA(AStream: TStream; AEncoding: TTextEncoding): QStringA;
var
  ASize: Integer;
  ABuffer: TBytes;
  ABomExists: Boolean;
begin
  ASize := AStream.Size - AStream.Position;
  if ASize > 0 then
  begin
    SetLength(ABuffer, ASize);
    AStream.ReadBuffer((@ABuffer[0])^, ASize);
    if AEncoding in [teUnknown, teAuto] then
      AEncoding := DetectTextEncoding(@ABuffer[0], ASize, ABomExists)
    else if ASize >= 2 then
    begin
      case AEncoding of
        teUnicode16LE:
          ABomExists := (ABuffer[0] = $FF) and (ABuffer[1] = $FE);
        teUnicode16BE:
          ABomExists := (ABuffer[1] = $FE) and (ABuffer[1] = $FF);
        teUTF8:
          begin
            if ASize >= 3 then
              ABomExists := (ABuffer[0] = $EF) and (ABuffer[1] = $BB) and
                (ABuffer[2] = $BF)
            else
              ABomExists := false;
          end;
      end;
    end
    else
      ABomExists := false;
    if AEncoding = teAnsi then
      Result := ABuffer
    else if AEncoding = teUTF8 then
    begin
      if ABomExists then
      begin
        if ASize > 3 then
          Result := AnsiEncode(Utf8Decode(@ABuffer[3], ASize - 3))
        else
          Result.Length := 0;
      end
      else
        Result := AnsiEncode(Utf8Decode(@ABuffer[0], ASize));
    end
    else
    begin
      if AEncoding = teUnicode16BE then
        ExchangeByteOrder(@ABuffer[0], ASize);
      if ABomExists then
        Result := AnsiEncode(PQCharW(@ABuffer[2]), (ASize - 2) shr 1)
      else
        Result := AnsiEncode(PQCharW(@ABuffer[0]), ASize shr 1);
    end;
  end
  else
    Result.Length := 0;
end;

function LoadTextU(const AFileName: String; AEncoding: TTextEncoding): QStringA;
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadTextU(AStream, AEncoding);
  finally
    AStream.Free;
  end;
end;

function LoadTextU(AStream: TStream; AEncoding: TTextEncoding): QStringA;
var
  ASize: Integer;
  ABuffer: TBytes;
  ABomExists: Boolean;
begin
  ASize := AStream.Size - AStream.Position;
  if ASize > 0 then
  begin
    SetLength(ABuffer, ASize);
    AStream.ReadBuffer((@ABuffer[0])^, ASize);
    if AEncoding in [teUnknown, teAuto] then
      AEncoding := DetectTextEncoding(@ABuffer[0], ASize, ABomExists)
    else if ASize >= 2 then
    begin
      case AEncoding of
        teUnicode16LE:
          ABomExists := (ABuffer[0] = $FF) and (ABuffer[1] = $FE);
        teUnicode16BE:
          ABomExists := (ABuffer[1] = $FE) and (ABuffer[1] = $FF);
        teUTF8:
          begin
            if ASize > 3 then
              ABomExists := (ABuffer[0] = $EF) and (ABuffer[1] = $BB) and
                (ABuffer[2] = $BF)
            else
              ABomExists := false;
          end;
      end;
    end
    else
      ABomExists := false;
    if AEncoding = teAnsi then
      Result := qstring.Utf8Encode(AnsiDecode(@ABuffer[0], ASize))
    else if AEncoding = teUTF8 then
    begin
      if ABomExists then
      begin
        Dec(ASize, 3);
        Result.From(@ABuffer[0], 3, ASize);
      end
      else
        Result := ABuffer;
      if ASize > 0 then
        Result.FValue[0] := 1; // UTF-8
    end
    else
    begin
      if AEncoding = teUnicode16BE then
        ExchangeByteOrder(@ABuffer[0], ASize);
      if ABomExists then
        Result := qstring.Utf8Encode(PQCharW(@ABuffer[2]), (ASize - 2) shr 1)
      else
        Result := qstring.Utf8Encode(PQCharW(@ABuffer[0]), ASize shr 1);
    end;
  end
  else
  begin
    Result.Length := 0;
    Result.FValue[0] := 1;
  end;
end;

function LoadTextW(const AFileName: String; AEncoding: TTextEncoding): QStringW;
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadTextW(AStream, AEncoding);
  finally
    AStream.Free;
  end;
end;

function DecodeText(p: Pointer; ASize: Integer; AEncoding: TTextEncoding)
  : QStringW;
var
  ABomExists: Boolean;
  pb: PByte;
  pe: PQCharA;
  function ByteOf(AOffset: Integer): Byte;
  begin
    Result := PByte(IntPtr(pb) + AOffset)^;
  end;

begin
  pb := p;
  if ASize >= 2 then
  begin
    // �����Ƿ�ָ�����룬ǿ�Ƽ��BOMͷ���������ڱ���ָ�������������
    if (ByteOf(0) = $FF) and (ByteOf(1) = $FE) then
    begin
      AEncoding := teUnicode16LE;
      Inc(pb, 2);
      Dec(ASize, 2);
    end
    else if (ByteOf(0) = $FE) and (ByteOf(1) = $FF) then
    begin
      AEncoding := teUnicode16BE;
      Inc(pb, 2);
      Dec(ASize, 2);
    end
    else if (ASize > 2) and (ByteOf(0) = $EF) and (ByteOf(1) = $BB) and
      (ByteOf(2) = $BF) then
    begin
      AEncoding := teUTF8;
      Inc(pb, 3);
      Dec(ASize, 3);
    end
    else if AEncoding in [teUnknown, teAuto] then // No BOM
      AEncoding := DetectTextEncoding(pb, ASize, ABomExists);
    if ASize > 0 then
    begin
      if AEncoding = teAnsi then
        Result := AnsiDecode(PQCharA(pb), ASize)
      else if AEncoding = teUTF8 then
      begin
        if not Utf8Decode(PQCharA(pb), ASize, Result, pe) then
          Result := AnsiDecode(PQCharA(pb), ASize);
      end
      else
      begin
        if AEncoding = teUnicode16BE then
          ExchangeByteOrder(PQCharA(pb), ASize);
        SetLength(Result, ASize shr 1);
        Move(pb^, PQCharW(Result)^, ASize);
      end;
    end
    else
      SetLength(Result, 0);
  end
  else if ASize > 0 then
    Result := WideChar(pb^)
  else
    SetLength(Result, 0);
end;

function LoadTextW(AStream: TStream; AEncoding: TTextEncoding)
  : QStringW; overload;
var
  AReaded, ASize: Int64;
  ANeedRead: Integer;
  ABuffer: TBytes;
begin
  ASize := AStream.Size - AStream.Position;
  if ASize > 0 then
  begin
    SetLength(ABuffer, ASize);
    AReaded := 0;
    repeat
      if ASize - AReaded > MaxInt then
        ANeedRead := MaxInt
      else
        ANeedRead := ASize - AReaded;
      AStream.ReadBuffer((@ABuffer[AReaded])^, ANeedRead);
      Inc(AReaded, ANeedRead);
    until AReaded = ASize;
    Result := DecodeText(@ABuffer[0], ASize, AEncoding);
  end
  else
    SetLength(Result, 0);
end;

procedure SaveTextA(const AFileName: String; const S: QStringA);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveTextA(AStream, S);
  finally
    AStream.Free;
  end;
end;

procedure SaveTextA(AStream: TStream; const S: QStringA);
  procedure Utf8Save;
  var
    T: QStringA;
  begin
    T := AnsiEncode(Utf8Decode(S));
    AStream.WriteBuffer(PQCharA(T)^, T.Length);
  end;

begin
  if not S.IsUtf8 then
    AStream.WriteBuffer(PQCharA(S)^, S.Length)
  else
    Utf8Save;
end;

procedure SaveTextU(const AFileName: String; const S: QStringA;
  AWriteBom: Boolean);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveTextU(AStream, S, AWriteBom);
  finally
    AStream.Free;
  end;
end;

procedure SaveTextU(const AFileName: String; const S: QStringW;
  AWriteBom: Boolean); overload;
begin
  SaveTextU(AFileName, qstring.Utf8Encode(S), AWriteBom);
end;

procedure SaveTextU(AStream: TStream; const S: QStringA; AWriteBom: Boolean);
  procedure WriteBom;
  var
    ABom: TBytes;
  begin
    SetLength(ABom, 3);
    ABom[0] := $EF;
    ABom[1] := $BB;
    ABom[2] := $BF;
    AStream.WriteBuffer(ABom[0], 3);
  end;
  procedure SaveAnsi;
  var
    T: QStringA;
  begin
    T := qstring.Utf8Encode(AnsiDecode(S));
    AStream.WriteBuffer(PQCharA(T)^, T.Length);
  end;

begin
  if AWriteBom then
    WriteBom;
  if S.IsUtf8 then
    AStream.WriteBuffer(PQCharA(S)^, S.Length)
  else
    SaveAnsi;
end;

procedure SaveTextU(AStream: TStream; const S: QStringW;
  AWriteBom: Boolean); overload;
begin
  SaveTextU(AStream, qstring.Utf8Encode(S), AWriteBom);
end;

procedure SaveTextW(const AFileName: String; const S: QStringW;
  AWriteBom: Boolean);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveTextW(AStream, S, AWriteBom);
  finally
    AStream.Free;
  end;
end;

procedure SaveTextW(AStream: TStream; const S: QStringW; AWriteBom: Boolean);
  procedure WriteBom;
  var
    bom: Word;
  begin
    bom := $FEFF;
    AStream.WriteBuffer(bom, 2);
  end;

begin
  if AWriteBom then
    WriteBom;
  AStream.WriteBuffer(PQCharW(S)^, System.Length(S) shl 1);
end;

procedure SaveTextWBE(AStream: TStream; const S: QStringW; AWriteBom: Boolean);
var
  pw, pe: PWord;
  w: Word;
  ABuilder: TQStringCatHelperW;
begin
  pw := PWord(PQCharW(S));
  pe := pw;
  Inc(pe, Length(S));
  ABuilder := TQStringCatHelperW.Create(IntPtr(pe) - IntPtr(pw));
  try
    while IntPtr(pw) < IntPtr(pe) do
    begin
      w := (pw^ shr 8) or (pw^ shl 8);
      ABuilder.Cat(@w, 1);
      Inc(pw);
    end;
    if AWriteBom then
      AStream.WriteBuffer(#$FE#$FF, 2);
    AStream.WriteBuffer(ABuilder.FStart^, Length(S) shl 1);
  finally
    FreeObject(ABuilder);
  end;
end;

function StrStrA(s1, s2: PQCharA): PQCharA;
  function DoSearch: PQCharA;
  var
    ps1, ps2: PQCharA;
  begin
    ps1 := s1;
    ps2 := s2;
    Inc(ps1);
    Inc(ps2);
    while ps2^ <> 0 do
    begin
      if ps1^ = ps2^ then
      begin
        Inc(ps1);
        Inc(ps2);
      end
      else
        Break;
    end;
    if ps2^ = 0 then
      Result := s1
    else
      Result := nil;
  end;

begin
{$IFDEF MSWINDOWS}
  if Assigned(VCStrStr) then
  begin
    Result := VCStrStr(s1, s2);
    Exit;
  end;
{$ENDIF}
  Result := nil;
  if (s1 <> nil) and (s2 <> nil) then
  begin
    while s1^ <> 0 do
    begin
      if s1^ = s2^ then
      begin
        Result := DoSearch;
        if Result <> nil then
          Exit;
      end;
      Inc(s1);
    end;
  end;
end;

function StrIStrA(s1, s2: PQCharA): PQCharA;
var
  ws2: QStringA;
  function DoSearch: PQCharA;
  var
    ps1, ps2: PQCharA;
  begin
    ps1 := s1;
    ps2 := PQCharA(ws2);
    Inc(ps1);
    Inc(ps2);
    while ps2^ <> 0 do
    begin
      if CharUpperA(ps1^) = ps2^ then
      begin
        Inc(ps1);
        Inc(ps2);
      end
      else
        Break;
    end;
    if ps2^ = 0 then
      Result := s1
    else
      Result := nil;
  end;

begin
  Result := nil;
  if (s1 <> nil) and (s2 <> nil) then
  begin
    ws2 := QStringA.UpperCase(s2);
    while s1^ <> 0 do
    begin
      if s1^ = s2^ then
      begin
        Result := DoSearch;
        if Result <> nil then
          Exit;
      end;
      Inc(s1);
    end;
  end;
end;

function StrStrU(s1, s2: PQCharA): PQCharA;
begin
  Result := StrStrA(s1, s2);
end;

function StrIStrU(s1, s2: PQCharA): PQCharA;
begin
  Result := StrIStrA(s1, s2);
end;

function StrStrW(s1, s2: PQCharW): PQCharW;
var
  I: Integer;
begin
{$IFDEF MSWINDOWS}
  if Assigned(VCStrStrW) then
  begin
    Result := VCStrStrW(s1, s2);
    Exit;
  end;
{$ENDIF}
  if (s2 = nil) or (s2^ = #0) then
    Result := s1
  else
  begin
    Result := nil;
    while s1^ <> #0 do
    begin
      if s1^ = s2^ then
      begin
        I := 1;
        while s2[I] <> #0 do
        begin
          if s1[I] = s2[I] then
            Inc(I)
          else
            Break;
        end;
        if s2[I] = #0 then
        begin
          Result := s1;
          Break;
        end;
      end;
      Inc(s1);
    end;
  end;
end;

function StrIStrW(s1, s2: PQCharW): PQCharW;
var
  I: Integer;
  ws2: QStringW;
begin
  Result := nil;
  if (s1 = nil) or (s2 = nil) then
    Exit;
  ws2 := UpperCase(s2);
  s2 := PWideChar(ws2);
  while s1^ <> #0 do
  begin
    if CharUpperW(s1^) = s2^ then
    begin
      I := 1;
      while s2[I] <> #0 do
      begin
        if CharUpperW(s1[I]) = s2[I] then
          Inc(I)
        else
          Break;
      end;
      if s2[I] = #0 then
      begin
        Result := s1;
        Break;
      end;
    end;
    Inc(s1);
  end;
end;

function PosA(sub, S: PQCharA; AIgnoreCase: Boolean;
  AStartPos: Integer): Integer;
begin
  if AStartPos > 0 then
    Inc(S, AStartPos - 1);
  if AIgnoreCase then
    sub := StrIStrA(S, sub)
  else
    sub := StrStrA(S, sub);
  if Assigned(sub) then
    Result := (IntPtr(sub) - IntPtr(S)) + AStartPos
  else
    Result := 0;
end;

function PosA(sub, S: QStringA; AIgnoreCase: Boolean;
  AStartPos: Integer): Integer;
begin
  Result := PosA(PQCharA(sub), PQCharA(S), AIgnoreCase, AStartPos);
end;

function PosW(sub, S: PQCharW; AIgnoreCase: Boolean;
  AStartPos: Integer): Integer;
begin
  if AStartPos > 0 then
    Inc(S, AStartPos - 1);
  if AIgnoreCase then
    sub := StrIStrW(S, sub)
  else
    sub := StrStrW(S, sub);
  if Assigned(sub) then
    Result := ((IntPtr(sub) - IntPtr(S)) shr 1) + AStartPos
  else
    Result := 0;
end;

function PosW(sub, S: QStringW; AIgnoreCase: Boolean; AStartPos: Integer)
  : Integer; overload;
begin
  Result := PosW(PQCharW(sub), PQCharW(S), AIgnoreCase, AStartPos);
end;

function StrDupX(const S: PQCharW; ACount: Integer): QStringW;
begin
  Result := Copy(S, 0, ACount);
  // SetLength(Result, ACount);
  // Move(S^, PQCharW(Result)^, ACount shl 1);
end;

function StrDupW(const S: PQCharW; AOffset: Integer; const ACount: Integer)
  : QStringW;
var
  c, ACharSize: Integer;
  p, pds, pd: PQCharW;
begin
  c := 0;
  p := S + AOffset;
  SetLength(Result, 16384);
  pd := PQCharW(Result);
  pds := pd;
  while (p^ <> #0) and (c < ACount) do
  begin
    ACharSize := CharSizeW(p);
    AOffset := pd - pds;
    if AOffset + ACharSize = Length(Result) then
    begin
      SetLength(Result, Length(Result) shl 1);
      pds := PQCharW(Result);
      pd := pds + AOffset;
    end;
    Inc(c);
    pd^ := p^;
    if ACharSize = 2 then
      pd[1] := p[1];
    Inc(pd, ACharSize);
    Inc(p, ACharSize);
  end;
  SetLength(Result, pd - pds);
end;

function StrCmpA(const s1, s2: PQCharA; AIgnoreCase: Boolean): Integer;
var
  p1, p2: PQCharA;
  c1, c2: QCharA;
begin
  p1 := s1;
  p2 := s2;
  if AIgnoreCase then
  begin
    while (p1^ <> 0) and (p2^ <> 0) do
    begin
      if p1^ <> p2^ then
      begin
        if (p1^ >= Ord('a')) and (p1^ <= Ord('z')) then
          c1 := p1^ xor $20
        else
          c1 := p1^;
        if (p2^ >= Ord('a')) and (p2^ <= Ord('z')) then
          c2 := p2^ xor $20
        else
          c2 := p2^;
        Result := Ord(c1) - Ord(c2);
        if Result <> 0 then
          Exit;
      end;
      Inc(p1);
      Inc(p2);
    end;
    Result := Ord(p1^) - Ord(p2^);
  end
  else
  begin
    while (p1^ <> 0) and (p2^ <> 0) do
    begin
      Result := p1^ - p2^;
      if Result <> 0 then
        Exit;
      Inc(p1);
      Inc(p2);
    end;
    Result := Ord(p1^) - Ord(p2^);
  end;
end;

function StrCmpW(const s1, s2: PQCharW; AIgnoreCase: Boolean): Integer;
var
  p1, p2: PQCharW;
  c1, c2: QCharW;
begin
  p1 := s1;
  p2 := s2;
  if AIgnoreCase then
  begin
    while (p1^ <> #0) and (p2^ <> #0) do
    begin
      if p1^ <> p2^ then
      begin
        if (p1^ >= 'a') and (p1^ <= 'z') then
          c1 := WideChar(Word(p1^) xor $20)
        else
          c1 := p1^;
        if (p2^ >= 'a') and (p2^ <= 'z') then
          c2 := WideChar(Word(p2^) xor $20)
        else
          c2 := p2^;
        Result := Ord(c1) - Ord(c2);
        if Result <> 0 then
          Exit;
      end;
      Inc(p1);
      Inc(p2);
    end;
    Result := Ord(p1^) - Ord(p2^);
  end
  else
  begin
    while (p1^ <> #0) and (p2^ <> #0) do
    begin
      if p1^ <> p2^ then
      begin
        Result := Ord(p1^) - Ord(p2^);
        if Result <> 0 then
          Exit;
      end;
      Inc(p1);
      Inc(p2);
    end;
    Result := Ord(p1^) - Ord(p2^);
  end;
end;

function StrNCmpW(const s1, s2: PQCharW; AIgnoreCase: Boolean;
  ALength: Integer): Integer;
var
  p1, p2: PQCharW;
  c1, c2: QCharW;
begin
  p1 := s1;
  p2 := s2;
  if AIgnoreCase then
  begin
    while ALength > 0 do
    begin
      if p1^ <> p2^ then
      begin
        if (p1^ >= 'a') and (p1^ <= 'z') then
          c1 := WideChar(Word(p1^) xor $20)
        else
          c1 := p1^;
        if (p2^ >= 'a') and (p2^ <= 'z') then
          c2 := WideChar(Word(p2^) xor $20)
        else
          c2 := p2^;
        Result := Ord(c1) - Ord(c2);
        if Result <> 0 then
          Exit;
      end;
      Inc(p1);
      Inc(p2);
      Dec(ALength);
    end;
  end
  else
  begin
    while ALength > 0 do
    begin
      if p1^ <> p2^ then
      begin
        Result := Ord(p1^) - Ord(p2^);
        if Result <> 0 then
          Exit;
      end;
      Inc(p1);
      Inc(p2);
      Dec(ALength);
    end;
  end;
  if ALength = 0 then
    Result := 0
  else
    Result := Ord(p1^) - Ord(p2^);
end;

/// <summary>ʹ����Ȼ���Թ���Ƚ��ַ���</summary>
/// <param name="s1">��һ��Ҫ�Ƚϵ��ַ���</param>
/// <param name="s2">�ڶ���Ҫ�Ƚϵ��ַ���</param>
/// <param name="AIgnoreCase">�Ƚ�ʱ�Ƿ���Դ�Сд</param>
/// <param name="AIgnoreSpace">�Ƚ�ʱ�Ƿ���Կհ��ַ�</param>
/// <remarks>���ȽϿ�������ȫ�ǵ��������Ϊ����ȫ�Ƿ��źͶ�Ӧ�İ�Ƿ�������ȵ�ֵ</remarks>
function NaturalCompareW(s1, s2: PQCharW;
  AIgnoreCase, AIgnoreSpace: Boolean): Integer;
var
  N1, N2: Int64;
  L1, L2: Integer;
  c1, c2: QCharW;
  function FetchNumeric(p: PQCharW; var AResult: Int64;
    var ALen: Integer): Boolean;
  var
    ps: PQCharW;
  const
    Full0: WideChar = #65296; // ȫ��0
    Full9: WideChar = #65305; // ȫ��9
  begin
    AResult := 0;
    ps := p;
    while p^ <> #0 do
    begin
      while IsSpaceW(p) do
        Inc(p);
      if (p^ >= '0') and (p^ <= '9') then // �������
        AResult := AResult * 10 + Ord(p^) - Ord('0')
      else if (p^ >= Full0) and (p^ <= Full9) then // ȫ������
        AResult := AResult * 10 + Ord(p^) - Ord(Full0)
      else
        Break;
      Inc(p);
    end;
    Result := ps <> p;
    ALen := (IntPtr(p) - IntPtr(ps)) shr 1;
  end;
  function FullToHalfChar(c: Word): QCharW;
  begin
    if (c = $3000) then
      // ȫ�ǿո�'��'
      Result := QCharW($20)
    else if (c >= $FF01) and (c <= $FF5E) then
      Result := QCharW($21 + (c - $FF01))
    else
      Result := QCharW(c);
  end;
  function CompareChar: Integer;
  begin
    if AIgnoreCase then
    begin
      c1 := CharUpperW(FullToHalfChar(Ord(s1^)));
      c2 := CharUpperW(FullToHalfChar(Ord(s2^)));
    end
    else
    begin
      c1 := FullToHalfChar(Ord(s1^));
      c2 := FullToHalfChar(Ord(s2^));
    end;
    Result := Ord(c1) - Ord(c2);
  end;

begin
  if Assigned(s1) then
  begin
    if not Assigned(s2) then
    begin
      Result := 1;
      Exit;
    end;
    while (s1^ <> #0) and (s2^ <> #0) do
    begin
      if s1^ <> s2^ then
      begin
        while IsSpaceW(s1) do
          Inc(s1);
        while IsSpaceW(s1) do
          Inc(s2);
        // ����Ƿ�������
        L1 := 0;
        L2 := 0;
        if FetchNumeric(s1, N1, L1) and FetchNumeric(s2, N2, L2) then
        begin
          if N1 > N2 then
            Exit(1)
          else if N1 < N2 then
            Exit(-1)
          else
          begin
            Inc(s1, L1);
            Inc(s2, L2);
          end;
        end
        else
        begin
          Result := CompareChar;
          if Result = 0 then
          begin
            Inc(s1);
            Inc(s2);
          end
          else
            Exit;
        end;
      end
      else // �����ȣ���ʹ�����֣��϶�Ҳ����ȵ�
      begin
        Inc(s1);
        Inc(s2);
      end;
    end;
    Result := CompareChar;
  end
  else if Assigned(s2) then
    Result := -1
  else
    Result := 0;
end;

function IsHexChar(c: QCharW): Boolean; inline;
begin
  Result := ((c >= '0') and (c <= '9')) or ((c >= 'a') and (c <= 'f')) or
    ((c >= 'A') and (c <= 'F'));
end;

function IsOctChar(c: WideChar): Boolean; inline;
begin
  Result := (c >= '0') and (c <= '7');
end;

function HexValue(c: QCharW): Integer;
begin
  if (c >= '0') and (c <= '9') then
    Result := Ord(c) - Ord('0')
  else if (c >= 'a') and (c <= 'f') then
    Result := 10 + Ord(c) - Ord('a')
  else if (c >= 'A') and (c <= 'F') then
    Result := 10 + Ord(c) - Ord('A')
  else
    Result := -1;
end;

function HexChar(V: Byte): QCharW;
begin
  Result := HexChars[V];
end;

function TryStrToGuid(const S: QStringW; var AGuid: TGuid): Boolean;
var
  p, ps: PQCharW;
  l: Int64;
begin
  l := Length(S);
  p := PWideChar(S);
  if (l = 38) or (l = 36) then
  begin
    // {0BCBAAFF-15E6-451D-A8E8-0D98AC48C364}
    ps := p;
    if p^ = '{' then
      Inc(p);
    if (ParseHex(p, l) <> 8) or (p^ <> '-') then
    begin
      Result := false;
      Exit;
    end;
    AGuid.D1 := l;
    Inc(p);
    if (ParseHex(p, l) <> 4) or (p^ <> '-') then
    begin
      Result := false;
      Exit;
    end;
    AGuid.D2 := l;
    Inc(p);
    if (ParseHex(p, l) <> 4) or (p^ <> '-') then
    begin
      Result := false;
      Exit;
    end;
    AGuid.D3 := l;
    Inc(p);
    // 0102-030405060708
    // ʣ�µ�16���ַ�
    l := 0;
    while IsHexChar(p[0]) do
    begin
      if IsHexChar(p[1]) then
      begin
        AGuid.D4[l] := (HexValue(p[0]) shl 4) + HexValue(p[1]);
        Inc(l);
        Inc(p, 2);
      end
      else
      begin
        Result := false;
        Exit;
      end;
    end;
    if (l <> 2) or (p^ <> '-') then
    begin
      Result := false;
      Exit;
    end;
    Inc(p);
    while IsHexChar(p[0]) do
    begin
      if IsHexChar(p[1]) then
      begin
        AGuid.D4[l] := (HexValue(p[0]) shl 4) + HexValue(p[1]);
        Inc(l);
        Inc(p, 2);
      end
      else
      begin
        Result := false;
        Exit;
      end;
    end;
    if (l = 8) then
    begin
      if ps^ = '{' then
        Result := (p[0] = '}') and (p[1] = #0)
      else
        Result := (p[0] = #0);
    end
    else
      Result := false;
  end
  else
    Result := false;
end;

function TryStrToIPV4(const S: QStringW; var AIPV4:
{$IFDEF MSWINDOWS}Integer{$ELSE}Cardinal{$ENDIF}): Boolean;
var
  p: PQCharW;
  dc: Integer;
  pd: PByte;
begin
  dc := 0;
  AIPV4 := 0;
  p := PQCharW(S);
  pd := PByte(@AIPV4);
  while p^ <> #0 do
  begin
    if (p^ >= '0') and (p^ <= '9') then
      pd^ := pd^ * 10 + Ord(p^) - Ord('0')
    else if p^ = '.' then
    begin
      Inc(dc);
      if dc > 3 then
        Break;
      Inc(pd);
    end
    else
      Break;
    Inc(p);
  end;
  Result := (dc = 3) and (p^ = #0);
end;

procedure InlineMove(var d, S: Pointer; l: Integer); inline;
begin
  if l >= 16 then
  begin
    Move(S^, d^, l);
    Inc(PByte(d), l);
    Inc(PByte(S), l);
  end
  else
  begin
    if l >= 8 then
    begin
      PInt64(d)^ := PInt64(S)^;
      Inc(PInt64(d));
      Inc(PInt64(S));
      Dec(l, 8);
    end;
    if l >= 4 then
    begin
      PInteger(d)^ := PInteger(S)^;
      Inc(PInteger(d));
      Inc(PInteger(S));
      Dec(l, 4);
    end;
    if l >= 2 then
    begin
      PSmallint(d)^ := PSmallint(S)^;
      Inc(PSmallint(d));
      Inc(PSmallint(S));
      Dec(l, 2);
    end;
    if l = 1 then
    begin
      PByte(d)^ := PByte(S)^;
      Inc(PByte(d));
      Inc(PByte(S));
    end;
  end;
end;

function StringReplaceWX(const S, Old, New: QStringW; AFlags: TReplaceFlags)
  : QStringW;
var
  ps, pse, pr, pd, po, pn, pns: PQCharW;
  LO, LN, LS, I, ACount: Integer;
  SS, SOld: QStringW;
  AFounds: array of Integer;
  AReplaceOnce: Boolean;
begin
  LO := Length(Old);
  LS := Length(S);
  if (LO = 0) or (LS = 0) or (Old = New) then
  begin
    Result := S;
    Exit;
  end;
  LN := Length(New);
  if rfIgnoreCase in AFlags then
  begin
    SOld := UpperCase(Old);
    if SOld = Old then // ��Сдһ�£�����Ҫ������д�дת��
      SS := S
    else
    begin
      SS := UpperCase(S);
      LS := Length(SS);
    end;
  end
  else
  begin
    SOld := Old;
    SS := S;
  end;
  ps := Pointer(SS);
  pn := ps;
  po := Pointer(SOld);
  ACount := 0;
  AReplaceOnce := not(rfReplaceAll in AFlags);
  repeat
    pr := StrStrW(pn, po);
    if Assigned(pr) then
    begin
      if ACount = 0 then
        SetLength(AFounds, 32)
      else
        SetLength(AFounds, ACount shl 1);
      AFounds[ACount] := IntPtr(pr) - IntPtr(pn);
      Inc(ACount);
      pn := pr;
      Inc(pn, LO);
    end
    else
      Break;
  until AReplaceOnce or (pn^ = #0);
  if ACount = 0 then // û���ҵ���Ҫ�滻�����ݣ�ֱ�ӷ���ԭʼ�ַ���
    Result := S
  else
  begin
    // ������Ҫ�����Ŀ���ڴ�
    SetLength(Result, LS + (LN - LO) * ACount);
    pd := Pointer(Result);
    pn := Pointer(New);
    pns := pn;
    ps := Pointer(S);
    pse := ps;
    Inc(pse, LS);
    LN := LN shl 1;
    for I := 0 to ACount - 1 do
    begin
      InlineMove(Pointer(pd), Pointer(ps), AFounds[I]);
      InlineMove(Pointer(pd), Pointer(pn), LN);
      Inc(ps, LO);
      pn := pns;
    end;
    InlineMove(Pointer(pd), Pointer(ps), IntPtr(pse) - IntPtr(ps));
  end;
end;

function StringReplaceW(const S, Old, New: QStringW; AFlags: TReplaceFlags)
  : QStringW;
{$IF RTLVersion>30}// Berlin ��ʼֱ��ʹ��ϵͳ�Դ����滻����
begin
  Result := StringReplace(S, Old, New, AFlags);
end;
{$ELSE}

var
  ps, pse, pds, pr, pd, po, pn: PQCharW;
  l, LO, LN, LS, LR: Integer;
  AReplaceOnce: Boolean;
begin
  LO := Length(Old);
  LN := Length(New);
  if LO = LN then
  begin
    if Old = New then
    begin
      Result := S;
      Exit;
    end;
  end;
  LS := Length(S);
  if (LO > 0) and (LS >= LO) then
  begin
    AReplaceOnce := not(rfReplaceAll in AFlags);
    // LO=LN���򲻱�LR=LS������ȫ�滻��Ҳ������ԭ����
    // LO<LN����LR=LS+(LS*LN)/LO������ȫ�滻�ĳ���
    // LO>LN����LR=LS������һ�ζ����滻��Ҳ������ԭ����
    if LO >= LN then
      LR := LS
    else if AReplaceOnce then
      LR := LS + (LN - LO)
    else
      LR := LS + 1 + LS * LN div LO;
    SetLength(Result, LR);
    ps := PQCharW(S);
    pse := ps + LS;
    pd := PQCharW(Result);
    pds := pd;
    po := PQCharW(Old);
    pn := PQCharW(New);
    repeat
      if rfIgnoreCase in AFlags then
        pr := StrIStrW(ps, po)
      else
        pr := StrStrW(ps, po);
      if pr <> nil then
      begin
        l := IntPtr(pr) - IntPtr(ps);
        Move(ps^, pd^, l);
        Inc(pd, l shr 1);
        Inc(pr, LO);
        Move(pn^, pd^, LN shl 1);
        Inc(pd, LN);
        ps := pr;
      end;
    until (pr = nil) or AReplaceOnce;
    // ��ʣ�ಿ�ֺϲ���Ŀ��
    l := IntPtr(pse) - IntPtr(ps);
    Move(ps^, pd^, l);
    Inc(pd, l shr 1);
    SetLength(Result, pd - pds);
  end
  else
    Result := S;
end;
{$IFEND}

function StringReplaceW(const S: QStringW; const AChar: QCharW;
  AFrom, ACount: Integer): QStringW;
var
  p, pd: PQCharW;
  l: Integer;
begin
  l := Length(S);
  SetLength(Result, l);
  if (l > 0) and (l > AFrom + 1) then
  begin
    p := PQCharW(S);
    pd := PQCharW(Result);
    while (p^ <> #0) and (AFrom > 0) do
    begin
      pd^ := p^;
      if (p^ > #$D800) and (p^ <= #$DFFF) then
      begin
        Inc(pd);
        Inc(p);
        pd^ := p^;
      end;
      Inc(p);
      Inc(pd);
      Dec(AFrom);
    end;
    while (p^ <> #0) and (ACount > 0) do
    begin
      pd^ := AChar;
      if (p^ > #$D800) and (p^ <= #$DFFF) then
        Inc(p);
      Inc(p);
      Inc(pd);
      Dec(ACount);
    end;
    while p^ <> #0 do
    begin
      pd^ := p^;
      Inc(p);
      Inc(pd);
    end;
  end;
end;

function StringReplaceWithW(const S, AStartTag, AEndTag, AReplaced: QStringW;
  AWithTag, AIgnoreCase: Boolean; AMaxTimes: Cardinal): QStringW;
var
  po, pe, pws, pwe, pd, pStart, pEnd, pReplaced: PQCharW;
  l, dl, LS, LE, LR: Integer;
  StrStrFunc: TStrStrFunction;
begin
  l := Length(S);
  LS := Length(AStartTag);
  LE := Length(AEndTag);
  if (l >= LS + LE) and (AMaxTimes > 0) then
  begin
    LR := Length(AReplaced);
    po := PQCharW(S);
    pe := po + l;
    pStart := PQCharW(AStartTag);
    pEnd := PQCharW(AEndTag);
    pReplaced := PQCharW(AReplaced);
    if LR > l then
      SetLength(Result, l * LR) // �����������ÿ�������滻ΪĿ��,��Ȼ�ⲻ����
    else
      SetLength(Result, l);
    pd := PQCharW(Result);
    if AIgnoreCase then
      StrStrFunc := StrIStrW
    else
      StrStrFunc := StrStrW;
    repeat
      pws := StrStrFunc(po, pStart);
      if pws = nil then
      begin
        dl := (pe - po);
        Move(po^, pd^, dl shl 1);
        SetLength(Result, pd - PQCharW(Result) + dl);
        Exit;
      end
      else
      begin
        pwe := StrStrFunc(pws + LS, pEnd);
        if pwe = nil then
        // û�ҵ���β
        begin
          dl := pe - po;
          Move(po^, pd^, dl shl 1);
          SetLength(Result, pd - PQCharW(Result) + dl);
          Exit;
        end
        else
        begin
          dl := pws - po;
          if AWithTag then
          begin
            Move(po^, pd^, (LS + dl) shl 1);
            Inc(pd, LS + dl);
            Move(pReplaced^, pd^, LR shl 1);
            Inc(pd, LR);
            Move(pwe^, pd^, LE shl 1);
            Inc(pd, LE);
          end
          else
          begin
            Move(po^, pd^, dl shl 1);
            Inc(pd, dl);
            Move(pReplaced^, pd^, LR shl 1);
            Inc(pd, LR);
          end;
          po := pwe + LE;
          Dec(AMaxTimes);
        end;
      end;
    until (AMaxTimes = 0) and (IntPtr(po) < IntPtr(pe));
    if IntPtr(po) < IntPtr(pe) then
    begin
      dl := pe - po;
      Move(po^, pd^, dl shl 1);
      Inc(pd, dl);
      SetLength(Result, pd - PQCharW(Result));
    end;
  end
  else
    Result := S;
end;

function StringReplicateW(const S: QStringW; ACount: Integer): QStringW;
var
  l: Integer;
  p, ps, pd: PQCharW;
begin
  l := Length(S);
  if (l > 0) and (ACount > 0) then
  begin
    SetLength(Result, ACount * l);
    ps := PQCharW(S);
    pd := PQCharW(Result);
    for l := 0 to ACount - 1 do
    begin
      p := ps;
      while p^ <> #0 do
      begin
        pd^ := p^;
        Inc(pd);
        Inc(p);
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

function StringReplicateW(const S, AChar: QStringW; AExpectLength: Integer)
  : QStringW;
begin
  if Length(S) < AExpectLength then
    Result := S + StringReplicateW(AChar, AExpectLength - Length(S))
  else
    Result := S;
end;

function Translate(const S, AToReplace, AReplacement: QStringW): QStringW;
var
  I: Integer;
  pd, pp, pr, ps: PQCharW;

  function CharIndex(c: QCharW): Integer;
  var
    pt: PQCharW;
  begin
    pt := pp;
    Result := -1;
    while pt^ <> #0 do
    begin
      if pt^ <> c then
        Inc(pt)
      else
      begin
        Result := (IntPtr(pt) - IntPtr(pp));
        Break;
      end;
    end;
  end;

begin
  if Length(AToReplace) <> Length(AReplacement) then
    raise Exception.CreateFmt(SMismatchReplacement, [AToReplace, AReplacement]);
  SetLength(Result, Length(S));
  pd := PQCharW(Result);
  ps := PQCharW(S);
  pp := PQCharW(AToReplace);
  pr := PQCharW(AReplacement);
  while ps^ <> #0 do
  begin
    I := CharIndex(ps^);
    if I <> -1 then
      pd^ := PQCharW(IntPtr(pr) + I)^
    else
      pd^ := ps^;
    Inc(ps);
    Inc(pd);
  end;
end;

function FilterCharW(const S: QStringW; AcceptChars: QStringW)
  : QStringW; overload;
var
  ps, pd, pc, pds: PQCharW;
  l: Integer;
begin
  SetLength(Result, Length(S));
  if Length(S) > 0 then
  begin
    ps := PQCharW(S);
    pd := PQCharW(Result);
    pds := pd;
    pc := PQCharW(AcceptChars);
    while ps^ <> #0 do
    begin
      if CharInW(ps, pc, @l) then
      begin
        pd^ := ps^;
        Inc(ps);
        Inc(pd);
        if l > 1 then
        begin
          pd^ := ps^;
          Inc(ps);
          Inc(pd);
        end;
      end
      else
        Inc(ps);
    end;
    SetLength(Result, (IntPtr(pd) - IntPtr(pds)) shr 1);
  end;
end;

function FilterCharW(const S: QStringW; AOnValidate: TQFilterCharEvent;
  ATag: Pointer): QStringW; overload;
var
  ps, pd, pds: PQCharW;
  l, I: Integer;
  Accept: Boolean;
begin
  if (Length(S) > 0) and Assigned(AOnValidate) then
  begin
    SetLength(Result, Length(S));
    ps := PQCharW(S);
    pd := PQCharW(Result);
    pds := pd;
    I := 0;
    while ps^ <> #0 do
    begin
      Accept := True;
      if CharSizeW(ps) = 2 then
      begin
        l := Ord(ps^);
        Inc(ps);
        l := (l shl 16) or Ord(ps^);
        AOnValidate(l, I, Accept, ATag);
      end
      else
        AOnValidate(Ord(ps^), I, Accept, ATag);
      if Accept then
      begin
        pd^ := ps^;
        Inc(pd);
      end;
      Inc(ps);
      Inc(I);
    end;
    SetLength(Result, (IntPtr(pd) - IntPtr(pds)) shr 1);
  end
  else
    SetLength(Result, 0);
end;
{$IFDEF UNICODE}

function FilterCharW(const S: QStringW; AOnValidate: TQFilterCharEventA;
  ATag: Pointer): QStringW; overload;
var
  ps, pd, pds: PQCharW;
  l, I: Integer;
  Accept: Boolean;
begin
  if (Length(S) > 0) and Assigned(AOnValidate) then
  begin
    SetLength(Result, Length(S));
    ps := PQCharW(S);
    pd := PQCharW(Result);
    pds := pd;
    I := 0;
    while ps^ <> #0 do
    begin
      Accept := True;
      if CharSizeW(ps) = 2 then
      begin
        l := Ord(ps^);
        Inc(ps);
        l := (l shl 16) or Ord(ps^);
        AOnValidate(l, I, Accept, ATag);
      end
      else
        AOnValidate(Ord(ps^), I, Accept, ATag);
      Inc(I);
      if Accept then
      begin
        pd^ := ps^;
        Inc(pd);
      end;
      Inc(ps);
    end;
    SetLength(Result, (IntPtr(pd) - IntPtr(pds)) shr 1);
  end
  else
    SetLength(Result, 0);
end;
{$ENDIF}

function FilterNoNumberW(const S: QStringW; Accepts: TQNumberTypes): QStringW;
var
  p, pd, pds: PQCharW;
  d, e: Integer;
  AIsHex: Boolean;
  procedure NegPosCheck;
  begin
    if ((p^ = '+') and (nftPositive in Accepts)) or
      ((p^ = '-') and (nftNegative in Accepts)) then
    begin
      pd^ := p^;
      Inc(p);
      Inc(pd);
    end;
  end;

begin
  SetLength(Result, Length(S));
  p := PQCharW(S);
  pd := PQCharW(Result);
  pds := pd;
  AIsHex := false;
  NegPosCheck;
  if nftHexPrec in Accepts then
  // Check Hex prec
  begin
    if (p^ = '0') and (nftCHex in Accepts) then // C Style
    begin
      Inc(p);
      if (p^ = 'x') or (p^ = 'X') then
      begin
        pd^ := '0';
        Inc(pd);
        pd^ := p^;
        Inc(pd);
        Inc(p);
        AIsHex := True;
      end
      else
        Dec(p);
    end
    else if (p^ = '$') and (nftDelphiHex in Accepts) then
    begin
      pd^ := p^;
      Inc(p);
      Inc(pd);
      AIsHex := True;
    end
    else if (p^ = '&') and (nftBasicHex in Accepts) then
    begin
      Inc(p);
      if Ord(p^) in [Ord('h'), Ord('H')] then
      begin
        pd^ := '&';
        Inc(pd);
        pd^ := p^;
        Inc(pd);
        Inc(p);
        AIsHex := True;
      end
      else
        Dec(p);
    end;
  end;
  d := 0;
  e := 0;
  while p^ <> #0 do
  begin
    if Ord(p^) in [Ord('0') .. Ord('9')] then
    begin
      pd^ := p^;
      Inc(pd);
    end
    else if (p^ = '.') and (not AIsHex) then
    begin
      Inc(d);
      if (d = 1) and (nftFloat in Accepts) then
      begin
        pd^ := p^;
        Inc(pd);
      end;
    end
    else if (Ord(p^) in [Ord('e'), Ord('E')]) and (not AIsHex) then
    begin
      Inc(e);
      if (e = 1) and (nftFloat in Accepts) then
      begin
        if d <= 1 then
        begin
          pd^ := p^;
          Inc(pd);
          d := 0;
          NegPosCheck;
        end;
      end;
    end
    else if AIsHex and ((Ord(p^) in [Ord('a') .. Ord('f')]) or
      (Ord(p^) in [Ord('A') .. Ord('F')])) then
    begin
      pd^ := p^;
      Inc(pd);
    end;
    Inc(p);
  end;
  SetLength(Result, (IntPtr(pd) - IntPtr(pds)) shr 1);
end;

function MemScan(S: Pointer; len_s: Integer; sub: Pointer;
  len_sub: Integer): Pointer;
var
  pb_s, pb_sub, pc_sub, pc_s: PByte;
  remain: Integer;
begin
  if len_s > len_sub then
  begin
    pb_s := S;
    pb_sub := sub;
    Result := nil;
    while len_s >= len_sub do
    begin
      if pb_s^ = pb_sub^ then
      begin
        remain := len_sub - 1;
        pc_sub := pb_sub;
        pc_s := pb_s;
        Inc(pc_s);
        Inc(pc_sub);
        if BinaryCmp(pc_s, pc_sub, remain) = 0 then
        begin
          Result := pb_s;
          Break;
        end;
      end;
      Inc(pb_s);
      Dec(len_s);
    end;
  end
  else if len_s = len_sub then
  begin
    if CompareMem(S, sub, len_s) then
      Result := S
    else
      Result := nil;
  end
  else
    Result := nil;
end;

function MemCompPascal(p1, p2: Pointer; L1, L2: Integer): Integer;
var
  l: Integer;
  ps1: PByte absolute p1;
  ps2: PByte absolute p2;
begin
  if L1 > L2 then
    l := L2
  else
    l := L1;
  while l > 4 do
  begin
    if PInteger(ps1)^ = PInteger(ps2)^ then
    begin
      Inc(ps1, 4);
      Inc(ps2, 4);
    end
    else
      Break;
  end;
  if l > 0 then
  begin
    Result := ps1^ - ps2^;
    if (Result = 0) and (l > 1) then
    begin
      Inc(ps1);
      Inc(ps2);
      Result := ps1^ - ps2^;
      if (Result = 0) and (L1 > 2) then
      begin
        Inc(ps1);
        Inc(ps2);
        Result := ps1^ - ps2^;
        if (Result = 0) and (L1 > 3) then
        begin
          Inc(ps1);
          Inc(ps2);
          Result := ps1^ - ps2^;
        end;
      end;
    end;
  end
  else // ==0
    Result := L1 - L2;
end;
{$IFDEF WIN32}

function MemCompAsm(p1, p2: Pointer; L1, L2: Integer): Integer;
label AssignL1, AdjustEnd, DoComp, ByBytes, ByLen, PopReg, C4, C3, c2, c1;
// EAX Temp 1
// EBX Temp 2
// ECX Min(L1,L2)
// EDX EndOf(P1)
// ESI P1
// EDI P2
begin
  asm
    push esi
    push edi
    push ebx
    mov esi,P1
    mov edi,p2
    mov eax,L1
    mov ebx,L2
    cmp eax,ebx
    jle AssignL1
    mov ecx,ebx
    jmp AdjustEnd

    AssignL1:// L1<=L2
    mov ecx,eax
    jmp AdjustEnd

    // ����edx��ֵΪ��Ҫ�ȽϵĽ���λ��
    AdjustEnd:
    mov edx,esi
    add edx,ecx
    and edx,$FFFFFFFC
    and ecx,3

    DoComp:
    cmp esi,edx
    jge ByBytes
    mov eax,[esi]
    mov ebx,[edi]
    cmp eax,ebx
    jnz C4
    add esi,4
    add edi,4
    jmp DoComp

    C4: // ʣ��>=4���ֽ�ʱ��ֱ�Ӽ������4���ֽ�
    bswap eax
    bswap ebx
    sub eax,ebx
    jmp PopReg

    ByBytes:
    cmp ecx,0// û�пɱȵ������ˣ�˭������˭��
    je ByLen
    cmp ecx,1// ʣ��1���ֽ�
    je C1
    cmp ecx,2// ʣ��2���ֽ�
    je C2
    // ʣ��3���ֽ�
    C3:
    xor eax,eax// eax����
    xor ebx,ebx// ebx����
    mov ax,WORD PTR [esi]
    mov bx,WORD PTR [edi]
    add esi,2
    add edi,2
    cmp eax,ebx
    je C1// ʣ��һ����Ҫ�Ƚϵ��ֽڣ�����C1
    bswap eax
    bswap ebx
    sub eax,ebx
    jmp PopReg
    // ʣ�������ֽ�
    C2:
    xor eax,eax// eax����
    xor ebx,ebx// ebx����
    mov ax,WORD PTR [esi]
    mov bx,WORD PTR [edi]
    cmp eax,ebx
    je ByLen// �ܱȽϵĶ���ȣ���������
    bswap eax
    bswap ebx
    shr eax,16
    shr ebx,16
    sub eax,ebx
    jmp PopReg

    // ʣ��һ���ֽ�
    C1:
    xor eax,eax// eax����
    xor ebx,ebx// ebx����
    mov al, BYTE PTR [esi]
    mov bl, BYTE PTR [edi]
    cmp eax,ebx
    je ByLen// �ܱȽϵĶ���ȣ���������
    sub eax,ebx
    jmp PopReg;

    // �����ȱȽ�
    ByLen:
    mov eax,L1
    sub eax,L2

    // �ָ������edi��esiֵ
    PopReg:
    pop ebx
    pop edi
    pop esi
    mov Result,eax
    // lea ebx,[ebp-10]
  end;
end;
{$ENDIF}

function BinaryCmp(const p1, p2: Pointer; len: Integer): Integer;
begin
{$IFDEF MSWINDOWS}
{$IFDEF WIN32}
  Result := MemComp(p1, p2, len, len);
{$ELSE}
  if Assigned(VCMemCmp) then
    Result := VCMemCmp(p1, p2, len)
  else
    Result := MemComp(p1, p2, len, len)
{$ENDIF}
{$ELSE}
    Result := memcmp(p1, p2, len);
{$ENDIF}
end;

procedure SkipHex(var S: PQCharW);
begin
  while ((S^ >= '0') and (S^ <= '9')) or ((S^ >= 'a') and (S^ <= 'f')) or
    ((S^ >= 'A') and (S^ <= 'F')) do
    Inc(S);
end;

procedure SkipDec(var S: PQCharW);
begin
  while (S^ >= '0') and (S^ <= '9') do
    Inc(S);
end;

function ParseHex(var p: PQCharW; var Value: Int64): Integer;
var
  ps: PQCharW;
begin
  Value := 0;
  ps := p;
  while IsHexChar(p^) do
  begin
    Value := (Value shl 4) + HexValue(p^);
    Inc(p);
  end;
  Result := p - ps;
end;

function LeftStrCount(const S: QStringW; const sub: QStringW;
  AIgnoreCase: Boolean): Integer;
var
  ps, psub: PQCharW;
  l: Integer;
begin
  l := Length(sub);
  Result := 0;
  if (l > 0) and (Length(S) >= l) then
  begin
    ps := PQCharW(S);
    psub := PQCharW(sub);
    if AIgnoreCase then
    begin
      repeat
        ps := StrIStrW(ps, psub);
        if ps <> nil then
        begin
          Inc(Result);
          Inc(ps, l);
        end;
      until ps = nil;
    end
    else
    begin
      repeat
        ps := StrStrW(ps, psub);
        if ps <> nil then
        begin
          Inc(Result);
          Inc(ps, l);
        end;
      until ps = nil;
    end;
  end;
end;

function RightPosW(const S: QStringW; const sub: QStringW;
  AIgnoreCase: Boolean): Integer;
var
  ps, pe, psub, psube, pc, pt: PQCharW;
  LS, lsub: Integer;
begin
  lsub := Length(sub);
  LS := Length(S);
  Result := 0;
  if LS >= lsub then
  begin
    ps := Pointer(S);
    pe := ps + LS - 1;
    psub := Pointer(sub);
    psube := psub + lsub - 1;
    if AIgnoreCase then
    begin
      while pe - ps >= lsub - 1 do
      begin
        if (pe^ = psube^) or (CharUpperW(pe^) = CharUpperW(psube^)) then
        begin
          pt := psube - 1;
          pc := pe - 1;
          while (pt >= psub) and
            ((pc^ = pt^) or (CharUpperW(pc^) = CharUpperW(pt^))) do
          begin
            Dec(pt);
            Dec(pc);
          end;
          if pt < psub then
          begin
            Dec(pe, lsub);
            Result := pe - ps + 2;
            Exit;
          end;
        end;
        Dec(pe);
      end;
    end
    else
    begin
      while pe - ps >= lsub - 1 do
      begin
        if pe^ = psube^ then
        begin
          pt := psube - 1;
          pc := pe - 1;
          while (pt >= psub) and (pc^ = pt^) do
          begin
            Dec(pt);
            Dec(pc);
          end;
          if pt < psub then
          begin
            Dec(pe, lsub);
            Result := pe - ps + 2;
            Exit;
          end;
        end;
        Dec(pe);
      end;
    end;
  end;
end;

function ParseInt(var S: PQCharW; var ANum: Int64): Integer;
var
  ps: PQCharW;
  ANeg: Boolean;
  ALastVal: Int64;
begin
  ps := S;
  // ����16���ƿ�ʼ�ַ�
  if S[0] = '$' then
  begin
    Inc(S);
    Result := ParseHex(S, ANum);
  end
  else if (S[0] = '0') and ((S[1] = 'x') or (S[1] = 'X')) then
  begin
    Inc(S, 2);
    Result := ParseHex(S, ANum);
  end
  else
  begin
    if (S^ = '-') then
    begin
      ANeg := True;
      Inc(S);
    end
    else
    begin
      ANeg := false;
      if S^ = '+' then
      begin
        Inc(S);
        if (S^ < '0') or (S^ > '9') then // +����������
        begin
          Result := 0;
          Exit;
        end;
      end;
    end;
    ANum := 0;
    ALastVal := 0;
    while (S^ >= '0') and (S^ <= '9') do
    begin
      ANum := ANum * 10 + Ord(S^) - Ord('0');
      if (ANum div 10) <> ALastVal then // �����
      begin
        Result := 0;
        S := ps;
        Exit;
      end;
      ALastVal := ANum;
      Inc(S);
    end;
    if ANeg then
      ANum := -ANum;
    Result := S - ps;
  end;
end;

function ParseNumeric(var S: PQCharW; var ANum: Extended;
  var AIsFloat: Boolean): Boolean;
var
  ps: PQCharW;
  function ParseHexInt: Boolean;
  var
    iVal: Int64;
  begin
    iVal := 0;
    while IsHexChar(S^) do
    begin
      iVal := (iVal shl 4) + HexValue(S^);
      Inc(S);
    end;
    Result := (S <> ps);
    ANum := iVal;
  end;

  function ParseDec: Boolean;
  var
    ACount: Integer;
    iVal: Int64;
    APow: Extended;
    ANeg: Boolean;
  begin
    try
      ANeg := S^ = '-';
      if ANeg then
        Inc(S);
      Result := ParseInt(S, iVal) > 0;
      if not Result then
        Exit;
      if ANeg then
        ANum := -iVal
      else
        ANum := iVal;
      if S^ = '.' then // С������
      begin
        AIsFloat := True;
        Inc(S);
        ACount := ParseInt(S, iVal);
        if ACount > 0 then
        begin
          if (ANum < 0) or ANeg then
            ANum := ANum - iVal / IntPower(10, ACount)
          else
            ANum := ANum + iVal / IntPower(10, ACount);
        end;
      end;
      if (S^ = 'e') or (S^ = 'E') then
      begin
        AIsFloat := True;
        Inc(S);
        if ParseNumeric(S, APow) then
          ANum := ANum * Power(10, APow)
        else
          S := ps;
      end;
      Result := (S <> ps);
    except
      on e: EOverflow do
        Result := false;
    end;
  end;

begin
  ps := S;
  AIsFloat := false;
  if (S^ = '$') or (S^ = '&') then
  begin
    Inc(S);
    Result := ParseHexInt;
    Exit;
  end
  else if (S[0] = '0') and ((S[1] = 'x') or (S[1] = 'X')) then
  begin
    Inc(S, 2);
    Result := ParseHexInt;
    Exit;
  end
  else
    Result := ParseDec;
  if not Result then
    S := ps;
end;

function ParseNumeric(var S: PQCharW; var ANum: Extended): Boolean;
var
  AIsFloat: Boolean;
begin
  Result := ParseNumeric(S, ANum, AIsFloat);
end;

function NameOfW(const S: QStringW; ASpliter: QCharW; AEmptyIfMissed: Boolean)
  : QStringW;
var
  p: PQCharW;
begin
  if Length(S) > 0 then
  begin
    p := PQCharW(S);
    Result := DecodeTokenW(p, [ASpliter], WideChar(0), false, false);
    if (p^ = #0) and AEmptyIfMissed then
      Result := '';
  end
  else
    Result := S;
end;

function ValueOfW(const S: QStringW; ASpliter: QCharW; AEmptyIfMissed: Boolean)
  : QStringW;
var
  p: PQCharW;
  l: Integer;
begin
  if Length(S) > 0 then
  begin
    p := PQCharW(S);
    if p^ = ASpliter then
    begin
      l := Length(S);
      Dec(l);
      SetLength(Result, l);
      Inc(p);
      Move(p^, PQCharW(Result)^, l shl 1);
    end
    else
    begin
      DecodeTokenW(p, [ASpliter], WideChar(0), false);
      if p^ <> #0 then
        Result := p
      else if AEmptyIfMissed then
        SetLength(Result, 0)
      else
        Result := S;
    end;
  end
  else
    Result := S;
end;

function IndexOfNameW(AList: TStrings; const AName: QStringW;
  ASpliter: QCharW): Integer;
var
  I: Integer;
  function DoCompareName(const AValue: String): Boolean;
  begin
    if TStringList(AList).CaseSensitive then
      Result := CompareStr(AName, AValue) = 0
    else
      Result := CompareText(AName, AValue) = 0;
  end;

begin
  if (AList is TStringList) and TStringList(AList).Sorted then
  begin
    // ������Ѿ������TStringListʵ�������ö��ַ�����
    if not TStringList(AList).Find(AName, Result) then
    begin
      if Result < AList.count then
      begin
        if DoCompareName(AList.Names[Result]) then
          Exit
        else if (Result > 0) and DoCompareName(AList.Names[Result - 1]) then
          Dec(Result)
        else
          Result := -1;
      end;
    end
  end
  else
  begin
    Result := -1;
    for I := 0 to AList.count - 1 do
    begin
      if NameOfW(AList[I], ASpliter) = AName then
      begin
        Result := I;
        Break;
      end;
    end;
  end;
end;

function IndexOfValueW(AList: TStrings; const AValue: QStringW;
  ASpliter: QCharW): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to AList.count - 1 do
  begin
    if ValueOfW(AList[I], ASpliter) = AValue then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function DeleteCharW(const ASource, ADeletes: QStringW): QStringW;
var
  ps, pd: PQCharW;
  l, ACharLen: Integer;
begin
  l := Length(ASource);
  if (l > 0) and (Length(ADeletes) > 0) then
  begin
    SetLength(Result, l);
    ps := PQCharW(ASource);
    pd := PQCharW(Result);
    while l > 0 do
    begin
      if not CharInW(ps, PQCharW(ADeletes), @ACharLen) then
      begin
        pd^ := ps^;
        Inc(pd);
        ACharLen := CharSizeW(ps);
      end;
      Inc(ps, ACharLen);
      Dec(l, ACharLen);
    end;
    SetLength(Result, pd - PQCharW(Result));
  end
  else
    Result := ASource;
end;

function DeleteSideCharsW(const ASource: QStringW; ADeletes: QStringW;
  AIgnoreCase: Boolean): QStringW;
var
  ps, pd, pe: PQCharW;
  ATemp: QStringW;
begin
  if Length(ADeletes) = 0 then
    Result := ASource
  else
  begin
    if AIgnoreCase then
    begin
      ATemp := UpperCase(ASource);
      ADeletes := UpperCase(ADeletes);
      ps := PQCharW(ATemp);
      pe := ps + Length(ATemp);
    end
    else
    begin
      ps := PQCharW(ASource);
      pe := ps + Length(ASource);
    end;
    pd := PQCharW(ADeletes);
    while ps < pe do
    begin
      if CharInW(ps, pd) then
        Inc(ps, CharSizeW(ps))
      else
        Break;
    end;
    while pe > ps do
    begin
      Dec(pe);
      if (pe^ >= #$DB00) and (pe^ <= #$DFFF) then
        Dec(pe);
      if not CharInW(pe, pd) then
      begin
        Inc(pe, CharSizeW(pe));
        Break;
      end;
    end;
    Result := StrDupX(ps, pe - ps);
  end;
end;

function DeleteRightW(const S, ADelete: QStringW; AIgnoreCase: Boolean = false;
  ACount: Integer = MaxInt): QStringW;
var
  ps, pd, pe: PQCharW;
  LS, LD: Integer;
begin
  LS := Length(S);
  LD := Length(ADelete);
  if LS < LD then
    Result := S
  else if LD > 0 then
  begin
    pe := PQCharW(S) + Length(S);
    pd := PQCharW(ADelete);
    if AIgnoreCase then
    begin
      while LS >= LD do
      begin
        ps := pe - LD;
        if StrIStrW(ps, pd) = ps then
        begin
          pe := ps;
          Dec(LS, LD);
        end
        else
          Break;
      end;
    end
    else
    begin
      while LS >= LD do
      begin
        ps := pe - LD;
        if CompareMem(ps, pd, LD shl 1) then
        begin
          pe := ps;
          Dec(LS, LD);
        end
        else
          Break;
      end;
    end;
    SetLength(Result, LS);
    if LS > 0 then
      Move(PWideChar(S)^, PQCharW(Result)^, LS shl 1);
  end
  else
    Result := S;
end;

function DeleteLeftW(const S, ADelete: QStringW; AIgnoreCase: Boolean = false;
  ACount: Integer = MaxInt): QStringW;
var
  ps, pd: PQCharW;
  LS, LD: Integer;
begin
  LS := Length(S);
  LD := Length(ADelete);
  if LS < LD then
    Result := S
  else if LD > 0 then
  begin
    ps := PQCharW(S);
    pd := PQCharW(ADelete);
    if AIgnoreCase then
    begin
      while LS >= LD do
      begin
        if StartWithW(ps, pd, True) then
        begin
          Inc(ps, LD);
          Dec(LS, LD);
        end
        else
          Break;
      end;
    end
    else
    begin
      while LS >= LD do
      begin
        if CompareMem(ps, pd, LD shl 1) then
        begin
          Inc(ps, LD);
          Dec(LS, LD);
        end
        else
          Break;
      end;
    end;
    SetLength(Result, LS);
    if LS > 0 then
      Move(ps^, PQCharW(Result)^, LS shl 1);
  end
  else
    Result := S;
end;

function ContainsCharW(const S, ACharList: QStringW): Boolean;
var
  ps: PQCharW;
  l: Integer;
begin
  l := Length(S);
  Result := false;
  if (l > 0) then
  begin
    if Length(ACharList) > 0 then
    begin
      ps := PQCharW(S);
      while l > 0 do
      begin
        if CharInW(ps, PQCharW(ACharList)) then
        begin
          Result := True;
          Break;
        end;
        Inc(ps);
        Dec(l);
      end;
    end;
  end;
end;

procedure StrCpyW(d: PQCharW; S: PQCharW; ACount: Integer);
begin
  while (S^ <> #0) and (ACount <> 0) do
  begin
    d^ := S^;
    Inc(d);
    Inc(S);
    Dec(ACount);
  end;
end;

function JavaEscape(const S: QStringW; ADoEscape: Boolean): QStringW;
var
  ASize: Integer;
  p, ps, pd, pe: PWideChar;
begin
  ASize := Length(S);
  if ASize > 0 then
  begin
    p := Pointer(S);
    ps := p;
    pe := ps + ASize;
    while p < pe do
    begin
      if p^ < ' ' then // �����ַ�
      begin
        if (p^ >= #7) and (p^ <= #13) then
          Inc(ASize)
        else
          Inc(ASize, 5);
      end
      else if p^ >= '~' then // �ǿɴ�ӡ�ַ���ת��Ļ�ʹ�� \uxxxx
      begin
        if ADoEscape then
          Inc(ASize, 5);
      end
      else
      begin
        if (p^ = '\') or (p^ = '"') then // \->\\
          Inc(ASize);
      end;
      Inc(p);
    end;
    if ASize = Length(S) then
      Result := S
    else
    begin
      SetLength(Result, ASize);
      pd := Pointer(Result);
      p := ps;
      while p < pe do
      begin
        if p^ < ' ' then // �����ַ�
        begin
          case p^ of
            #0: // \u0080
              begin
                PInteger(pd)^ := $0075005C; // \u
                Inc(pd, 2);
                pd^ := '0';
                Inc(pd);
                pd^ := '0';
                Inc(pd);
                pd^ := '0';
                Inc(pd);
                pd^ := '0';
                Inc(pd);
              end;
            #7:
              begin
                PInteger(pd)^ := $0061005C; // \a
                Inc(pd, 2);
              end;
            #8:
              begin
                PInteger(pd)^ := $0062005C; // \b
                Inc(pd, 2);
              end;
            #9:
              begin
                PInteger(pd)^ := $0074005C; // \t
                Inc(pd, 2);
              end;
            #10:
              begin
                PInteger(pd)^ := $006E005C; // \n
                Inc(pd, 2);
              end;
            #11:
              begin
                PInteger(pd)^ := $0076005C; // \v
                Inc(pd, 2);
              end;
            #12:
              begin
                PInteger(pd)^ := $0066005C; // \f
                Inc(pd, 2);
              end;
            #13:
              begin
                PInteger(pd)^ := $0072005C; // \r
                Inc(pd, 2);
              end
          else
            begin
              PInteger(pd)^ := $0075005C; // \u
              Inc(pd, 2);
              pd^ := '0';
              Inc(pd);
              pd^ := '0';
              Inc(pd);
              pd^ := '0';
              Inc(pd);
              pd^ := p^;
              Inc(pd);
            end;
          end;
        end
        else if p^ >= '~' then // �ǿɴ�ӡ�ַ���ת��Ļ�ʹ�� \uxxxx
        begin
          if ADoEscape then // \uxxxx
          begin
            PInteger(pd)^ := $0075005C; // \u
            Inc(pd, 2);
            pd^ := LowerHexChars[(Ord(p^) shr 12) and $0F];
            Inc(pd);
            pd^ := LowerHexChars[(Ord(p^) shr 8) and $0F];
            Inc(pd);
            pd^ := LowerHexChars[(Ord(p^) shr 4) and $0F];
            Inc(pd);
            pd^ := LowerHexChars[Ord(p^) and $0F];
            Inc(pd);
          end
          else
          begin
            pd^ := p^;
            Inc(pd);
          end;
        end
        else
        begin
          case p^ of
            '\':
              begin
                PInteger(pd)^ := $005C005C; // \\
                Inc(pd, 2);
              end;
            '''':
              begin
                PInteger(pd)^ := $0027005C; // \'
                Inc(pd, 2);
              end;
            '"':
              begin
                PInteger(pd)^ := $0022005C; // \"
                Inc(pd, 2);
              end
          else
            begin
              pd^ := p^;
              Inc(pd);
            end;
          end;
        end;
        Inc(p);
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

function JavaUnescape(const S: QStringW; AStrictEscape: Boolean): QStringW;
var
  ps, p, pd: PWideChar;
  ASize: Integer;
begin
  ASize := Length(S);
  if ASize > 0 then
  begin
    p := Pointer(S);
    ps := p;
    while p^ <> #0 do
    begin
      if p^ = '\' then
      begin
        Inc(p);
        case p^ of
          'a', 'b', 'f', 'n', 'r', 't', 'v', '''', '"', '\', '?':
            begin
              Dec(ASize);
              Inc(p);
            end;
          'x': // \xNN
            begin
              Dec(ASize, 2);
              Inc(p, 3);
            end;
          'u': // \uxxxx
            begin
              if IsHexChar(p[1]) and IsHexChar(p[2]) and IsHexChar(p[3]) and
                IsHexChar(p[4]) then
              begin
                Dec(ASize, 5);
                Inc(p, 5);
              end
              else
                raise Exception.CreateFmt(SBadJavaEscape, [Copy(p, 0, 6)]);
            end;
          'U': // \Uxxxxxxxx
            begin
              if IsHexChar(p[1]) and IsHexChar(p[2]) and IsHexChar(p[3]) and
                IsHexChar(p[4]) and IsHexChar(p[5]) and IsHexChar(p[6]) and
                IsHexChar(p[7]) and IsHexChar(p[8]) then
              begin
                Dec(ASize, 9);
                Inc(p, 9);
              end
              else
                raise Exception.CreateFmt(SBadJavaEscape, [Copy(p, 0, 10)]);
            end
        else
          begin
            if IsOctChar(p[0]) then
            begin
              if IsOctChar(p[1]) then
              begin
                if IsOctChar(p[2]) then
                begin
                  Dec(ASize, 3);
                  Inc(p, 3);
                end
                else
                begin
                  Dec(ASize, 2);
                  Inc(p, 2);
                end;
              end
              else
              begin
                Dec(ASize, 1);
                Inc(p, 1);
              end;
            end
            else if AStrictEscape then
            begin
              raise Exception.CreateFmt(SBadJavaEscape, [Copy(p, 0, 6)]);
            end;
          end;
        end;
      end
      else
        Inc(p);
    end;
    if Length(S) = ASize then // �ߴ���ȣ�û����Ҫ�����ת��
      Result := S
    else
    begin
      SetLength(Result, ASize);
      pd := Pointer(Result);
      p := ps;
      while p^ <> #0 do
      begin
        if p^ = '\' then
        begin
          Inc(p);
          case p^ of
            'a':
              pd^ := #7;
            'b':
              pd^ := #8;
            'f':
              pd^ := #12;
            'n':
              pd^ := #10;
            'r':
              pd^ := #13;
            't':
              pd^ := #9;
            'v':
              pd^ := #11;
            '''':
              pd^ := '''';
            '"':
              pd^ := '"';
            '\':
              pd^ := '\';
            '?':
              pd^ := '?';
            'x': // \xNN
              begin
                pd^ := WideChar((HexValue(p[1]) shl 4) or HexValue(p[2]));
                Inc(p, 2);
              end;
            'u': // \uxxxx
              begin
                pd^ := WideChar((HexValue(p[1]) shl 12) or
                  (HexValue(p[2]) shl 8) or (HexValue(p[3]) shl 4) or
                  HexValue(p[4]));
                Inc(p, 4);
              end;
            'U':
              // \Uxxxxxxxx
              begin
                pd^ := WideChar((HexValue(p[1]) shl 12) or
                  (HexValue(p[2]) shl 8) or (HexValue(p[3]) shl 4) or
                  HexValue(p[4]));
                Inc(pd);
                pd^ := WideChar((HexValue(p[5]) shl 12) or
                  (HexValue(p[6]) shl 8) or (HexValue(p[7]) shl 4) or
                  HexValue(p[8]));
                Inc(p, 8);
              end
          else
            begin
              if IsOctChar(p[0]) then
              begin
                ASize := HexValue(p[0]);
                if IsOctChar(p[1]) then
                begin
                  ASize := (ASize shl 3) + HexValue(p[1]);
                  if IsOctChar(p[2]) then
                  begin
                    pd^ := WideChar((ASize shl 3) + HexValue(p[2]));
                    Inc(p, 2);
                  end
                  else
                  begin
                    pd^ := WideChar(ASize);
                    Inc(p);
                  end;
                end
                else
                  pd^ := WideChar(ASize);
              end
              else
                pd^ := p^;
            end;
          end;
          Inc(pd);
        end
        else
        begin
          pd^ := p^;
          Inc(pd);
        end;
        Inc(p);
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

function HtmlEscape(const S: QStringW): QStringW;
var
  p, pd: PQCharW;
  AFound: Boolean;
  pw: PWord absolute p;
begin
  if Length(S) > 0 then
  begin
    System.SetLength(Result, Length(S) shl 3);
    // ת�崮�������8���ַ�������*8�϶�����
    p := PWideChar(S);
    pd := PWideChar(Result);
    while p^ <> #0 do
    begin
      AFound := false;
      if (pw^ >= 32) and (pw^ <= 255) then
      begin
        AFound := True;
        StrCpyW(pd, PQCharW(HtmlEscapeChars[pw^]));
        Inc(pd, Length(HtmlEscapeChars[pw^]));
      end;
      if not AFound then
      begin
        pd^ := p^;
        Inc(pd);
      end; // end if
      Inc(p);
    end; // end while
    SetLength(Result, pd - PQCharW(Result));
  end // end if
  else
    Result := '';
end;

type
  THTMLEscapeHashItem = record
    Hash: Integer;
    Char: Word;
    Next: Byte;
  end;

function UnescapeHtmlChar(var p: PQCharW): QCharW;
const
  HtmlUnescapeTable: array [0 .. 94] of THTMLEscapeHashItem =
    ((Hash: 1667591796; Char: 162; Next: 255), // 0:0:&cent;
    (Hash: 1768257635; Char: 161; Next: 10), // 1:15:&iexcl;
    (Hash: 1886352750; Char: 163; Next: 34), // 2:55:&pound;
    (Hash: 1869900140; Char: 245; Next: 255), // 3:3:&otilde;
    (Hash: 1853122924; Char: 241; Next: 255), // 4:4:&ntilde;
    (Hash: 1936226560; Char: 173; Next: 66), // 5:54:&shy;
    (Hash: 1684367104; Char: 176; Next: 64), // 6:31:&deg;
    (Hash: 1769043301; Char: 191; Next: 255), // 7:78:&iquest;
    (Hash: 1096901493; Char: 193; Next: 255), // 8:79:&Aacute;
    (Hash: 1095068777; Char: 198; Next: 12), // 9:81:&AElig;
    (Hash: 1130587492; Char: 199; Next: 84), // 10:15:&Ccedil;
    (Hash: 1651668578; Char: 166; Next: 89), // 11:11:&brvbar;
    (Hash: 1164142962; Char: 202; Next: 255), // 12:81:&Ecirc;
    (Hash: 1634562048; Char: 38; Next: 18), // 13:13:&amp;
    (Hash: 1231516257; Char: 204; Next: 255), // 14:86:&Igrave;
    (Hash: 1851945840; Char: 32; Next: 1), // 15:15:&nbsp;
    (Hash: 1231119221; Char: 205; Next: 24), // 16:71:&Iacute;
    (Hash: 1919248128; Char: 174; Next: 40), // 17:17:&reg;
    (Hash: 1163151360; Char: 208; Next: 255), // 18:13:&ETH;
    (Hash: 1316252012; Char: 209; Next: 255), // 19:36:&Ntilde;
    (Hash: 1869835361; Char: 248; Next: 255), // 20:20:&oslash;
    (Hash: 1869966700; Char: 246; Next: 255), // 21:21:&ouml;
    (Hash: 1919512167; Char: 197; Next: 255), // 22:22:&ring;
    (Hash: 1633908084; Char: 180; Next: 85), // 23:23:&acute;
    (Hash: 1331915122; Char: 212; Next: 255), // 24:71:&Ocirc;
    (Hash: 1918988661; Char: 187; Next: 255), // 25:25:&raquo;
    (Hash: 1333029228; Char: 213; Next: 41), // 26:35:&Otilde;
    (Hash: 1769303404; Char: 239; Next: 76), // 27:27:&iuml;
    (Hash: 1953066341; Char: 215; Next: 255), // 28:53:&times;
    (Hash: 1432445813; Char: 218; Next: 255), // 29:59:&Uacute;
    (Hash: 1432578418; Char: 219; Next: 255), // 30:65:&Ucirc;
    (Hash: 1818325365; Char: 171; Next: 6), // 31:31:&laquo;
    (Hash: 1835098994; Char: 175; Next: 88), // 32:32:&macr;
    (Hash: 1868653429; Char: 243; Next: 82), // 33:33:&oacute;
    (Hash: 1499554677; Char: 221; Next: 255), // 34:55:&Yacute;
    (Hash: 1835623282; Char: 181; Next: 26), // 35:35:&micro;
    (Hash: 1970105344; Char: 168; Next: 19), // 36:36:&uml;
    (Hash: 1937402985; Char: 223; Next: 67), // 37:63:&szlig;
    (Hash: 1633772405; Char: 225; Next: 255), // 38:47:&aacute;
    (Hash: 1767990133; Char: 237; Next: 70), // 39:39:&iacute;
    (Hash: 1635019116; Char: 227; Next: 255), // 40:17:&atilde;
    (Hash: 1635085676; Char: 228; Next: 255), // 41:35:&auml;
    (Hash: 1969713761; Char: 249; Next: 255), // 42:42:&ugrave;
    (Hash: 1700881269; Char: 233; Next: 255), // 43:43:&eacute;
    (Hash: 1667458404; Char: 231; Next: 255), // 44:80:&ccedil;
    (Hash: 1768122738; Char: 238; Next: 255), // 45:45:&icirc;
    (Hash: 1701278305; Char: 232; Next: 255), // 46:58:&egrave;
    (Hash: 1433759084; Char: 220; Next: 38), // 47:47:&Uuml;
    (Hash: 1667589225; Char: 184; Next: 68), // 48:48:&cedil;
    (Hash: 1098148204; Char: 195; Next: 51), // 49:49:&Atilde;
    (Hash: 1869767782; Char: 170; Next: 255), // 50:50:&ordf;
    (Hash: 1701013874; Char: 234; Next: 72), // 51:49:&ecirc;
    (Hash: 1332964449; Char: 216; Next: 255), // 52:52:&Oslash;
    (Hash: 1333095788; Char: 214; Next: 28), // 53:53:&Ouml;
    (Hash: 1903521652; Char: 34; Next: 5), // 54:54:&quot;
    (Hash: 1634758515; Char: 39; Next: 2), // 55:55:&apos;
    (Hash: 2036690432; Char: 165; Next: 255), // 56:56:&yen;
    (Hash: 1869767789; Char: 186; Next: 255), // 57:57:&ordm;
    (Hash: 1668641394; Char: 164; Next: 46), // 58:58:&curren;
    (Hash: 1232432492; Char: 207; Next: 29), // 59:59:&Iuml;
    (Hash: 1668247673; Char: 169; Next: 255), // 60:60:&copy;
    (Hash: 1634036841; Char: 230; Next: 255), // 61:61:&aelig;
    (Hash: 1634169441; Char: 224; Next: 255), // 62:62:&agrave;
    (Hash: 1165323628; Char: 203; Next: 37), // 63:63:&Euml;
    (Hash: 1702194540; Char: 235; Next: 255), // 64:31:&euml;
    (Hash: 1331782517; Char: 211; Next: 30), // 65:65:&Oacute;
    (Hash: 1768387169; Char: 236; Next: 255), // 66:54:&igrave;
    (Hash: 1768256616; Char: 240; Next: 255), // 67:63:&ieth;
    (Hash: 1869050465; Char: 242; Next: 255), // 68:48:&ograve;
    (Hash: 1885434465; Char: 182; Next: 255), // 69:69:&para;
    (Hash: 1868786034; Char: 244; Next: 255), // 70:39:&ocirc;
    (Hash: 1886156147; Char: 177; Next: 16), // 71:71:&plusmn;
    (Hash: 1684633193; Char: 247; Next: 255), // 72:49:&divide;
    (Hash: 1414025042; Char: 222; Next: 255), // 73:73:&THORN;
    (Hash: 1432842849; Char: 217; Next: 255), // 74:74:&Ugrave;
    (Hash: 1164010357; Char: 201; Next: 255), // 75:75:&Eacute;
    (Hash: 1969316725; Char: 250; Next: 255), // 76:27:&uacute;
    (Hash: 1231251826; Char: 206; Next: 255), // 77:77:&Icirc;
    (Hash: 1936024436; Char: 167; Next: 7), // 78:78:&sect;
    (Hash: 1852797952; Char: 172; Next: 8), // 79:79:&not;
    (Hash: 1332179553; Char: 210; Next: 44), // 80:80:&Ograve;
    (Hash: 1819541504; Char: 60; Next: 9), // 81:81:&lt;
    (Hash: 1969449330; Char: 251; Next: 255), // 82:33:&ucirc;
    (Hash: 1835623524; Char: 183; Next: 255), // 83:83:&middot;
    (Hash: 1970629996; Char: 252; Next: 255), // 84:15:&uuml;
    (Hash: 2036425589; Char: 253; Next: 255), // 85:23:&yacute;
    (Hash: 1735655424; Char: 62; Next: 14), // 86:86:&gt;
    (Hash: 1667854947; Char: 194; Next: 255), // 87:87:&circ;
    (Hash: 1953001330; Char: 254; Next: 255), // 88:32:&thorn;
    (Hash: 2037738860; Char: 255; Next: 255), // 89:11:&yuml;
    (Hash: 1164407393; Char: 200; Next: 255), // 90:90:&Egrave;
    (Hash: 1634888046; Char: 229; Next: 255), // 91:91:&aring;
    (Hash: 0; Char: 0; Next: 255), // 92:Not Used
    (Hash: 0; Char: 0; Next: 255), // 93:Not Used
    (Hash: 1097298529; Char: 192; Next: 255) // 94:94:&Agrave;
    );
  function HashOfEscape: Integer;
  var
    c: Integer;
    R: array [0 .. 3] of Byte absolute Result;
  begin
    Inc(p); // Skip #
    c := 3;
    Result := 0;
    while (p^ <> #0) and (c >= 0) do
    begin
      if p^ = ';' then
        Exit;
      R[c] := Ord(p^);
      Inc(p);
      Dec(c);
    end;
    while p^ <> #0 do
    begin
      if p^ = ';' then
        Exit
      else
        Inc(p);
    end;
    Result := 0;
  end;

var
  AHash, ANext: Integer;
begin
  AHash := HashOfEscape;
  Result := #0;
  if AHash <> 0 then
  begin
    ANext := AHash mod 97;
    while ANext <> 255 do
    begin
      if HtmlUnescapeTable[ANext].Hash = AHash then
      begin
        Result := QCharW(HtmlUnescapeTable[ANext].Char);
        Break;
      end
      else
        ANext := HtmlUnescapeTable[ANext].Next;
    end;
  end;
end;

function HtmlUnescape(const S: QStringW): QStringW;
var
  p, pd, ps: PQCharW;
  l: Integer;
begin
  if Length(S) > 0 then
  begin
    System.SetLength(Result, Length(S));
    p := PQCharW(S);
    pd := PQCharW(Result);
    while p^ <> #0 do
    begin
      if p^ = '&' then
      begin
        if p[1] = '#' then
        begin
          ps := p;
          Inc(p, 2);
          l := 0;
          if (p^ = 'x') or (p^ = 'X') then
          begin
            Inc(p);
            while IsHexChar(p^) do
            begin
              l := l shl 4 + HexValue(p^);
              Inc(p);
            end;
          end
          else
          begin
            while (p^ >= '0') and (p^ <= '9') do
            begin
              l := l * 10 + Ord(p^) - Ord('0');
              Inc(p);
            end;
          end;
          if p^ = ';' then
          begin
            pd^ := QCharW(l);
            Inc(pd);
          end
          else
          begin
            pd^ := ps^;
            Inc(pd);
            p := ps;
          end;
        end
        else
        begin
          pd^ := UnescapeHtmlChar(p);
          if pd^ = #0 then
            pd^ := p^;
          Inc(pd);
        end; // end else
      end // end else
      else
      begin
        pd^ := p^;
        Inc(pd);
      end;
      Inc(p);
    end; // end while
    SetLength(Result, pd - PWideChar(Result));
  end // end if
  else
    Result := '';
end;

function HtmlTrimText(const S: QStringW): QStringW;
var
  ps, pe: PQCharW;
  l: Integer;
begin
  if Length(S) > 0 then
  begin
    ps := PQCharW(S);
    pe := ps + System.Length(S) - 1;
    while IsSpaceW(ps) do
      Inc(ps);
    while IsSpaceW(pe) do
      Dec(pe);
    l := pe - ps + 1;
    SetLength(Result, l);
    Move(ps^, PQCharW(Result)^, l shl 1);
  end
  else
    Result := '';
end;

function IsUrl(const S: QStringW): Boolean;
begin
  Result := StrIStrW(PWideChar(S), '://') <> nil;
end;

function UrlEncode(const ABytes: PByte; l: Integer;
  ASpacesAsPlus, AEncodePercent: Boolean; ABookmarkEncode: TUrlBookmarkEncode)
  : QStringW; overload;
const
  SafeChars: array [33 .. 127] of Byte = ( //
    0, 0, 0, 0, 0, 0, 0, 0, //
    0, 0, 0, 0, 1, 1, 0, 1, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 0, 0, 0, 0, 0, 0, 0, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 1, 0, 0, 0, 0, 1, 0, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 1, 1, 1, 1, 1, 1, 1, //
    1, 1, 0, 0, 0, 1, 0);
  HexChars: array [0 .. 15] of QCharW = ('0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var
  c: Integer;
  ABookmarkCount: Integer;
  ps, pe: PByte;
  pd: PQCharW;
begin

  // ����ʵ�ʵĳ���
  ps := PByte(ABytes);
  pe := PByte(IntPtr(ps) + l);

  c := 0;
  ABookmarkCount := 0;
  { while IntPtr(ps) < IntPtr(pe) do
    begin
    if (not AEncodePercent) and (ps^ = Ord('%')) and
    (IntPtr(pe) - IntPtr(ps) > 2) and
    (PByte(IntPtr(ps) + 1)^ in [Ord('a') .. Ord('f'), Ord('A') .. Ord('F'),
    Ord('0') .. Ord('9')]) and
    (PByte(IntPtr(ps) + 2)^ in [Ord('a') .. Ord('f'), Ord('A') .. Ord('F'),
    Ord('0') .. Ord('9')]) then
    // ԭ������%xx?     %09%32
    Inc(ps, 3)
    else
    begin
    if (ps^ = Ord('%')) and (not AEncodePercent) then
    // �з�%xx���֣�˵��δ�����%����Ҫǿ�Ʊ���
    begin
    Result := UrlEncode(ABytes, l, ASpacesAsPlus, True, ABookmarkEncode);
    Exit;
    end;
    if (ps^ = 32) and ASpacesAsPlus then
    Inc(ps)
    else if ps^ = Ord('#') then
    begin
    Inc(ps);
    Inc(ABookmarkCount);
    end
    else
    begin
    if (ps^ <= 32) or (ps^ > 127) or (SafeChars[ps^] = 0) then
    Inc(c,2);
    Inc(ps);
    end;
    end;
    end;
    if ABookmarkCount > 0 then
    begin
    if ABookmarkEncode = ubeAll then
    Inc(c, ABookmarkCount)
    else if ABookmarkEncode = ubeOnlyLast then
    Inc(c);
    end;
    SetLength(Result, l + c); }
  SetLength(Result, l * 3);
  pd := PQCharW(Result);
  ps := ABytes;
  while IntPtr(ps) < IntPtr(pe) do
  begin
    if (not AEncodePercent) and (ps^ = Ord('%')) and
      (IntPtr(pe) - IntPtr(ps) > 2) and
      (PByte(IntPtr(ps) + 1)^ in [Ord('a') .. Ord('f'), Ord('A') .. Ord('F'),
      Ord('0') .. Ord('9')]) and
      (PByte(IntPtr(ps) + 2)^ in [Ord('a') .. Ord('f'), Ord('A') .. Ord('F'),
      Ord('0') .. Ord('9')]) then // ԭ������%xx?
    begin
      pd^ := '%';
      Inc(pd);
      Inc(ps);
      pd^ := QCharW(ps^);
      Inc(pd);
      Inc(ps);
      pd^ := QCharW(ps^);
      Inc(pd);
      Inc(ps);
    end
    else
    begin
      if (ABookmarkEncode <> ubeNone) and (ps^ = Ord('#')) then
      begin
        if (ABookmarkCount = 1) or (ABookmarkEncode = ubeAll) then
        begin
          pd^ := '%';
          Inc(pd);
          pd^ := HexChars[(ps^ shr 4) and $0F];
          Inc(pd);
          pd^ := HexChars[ps^ and $0F];
        end;
        Dec(ABookmarkCount);
      end
      else if (ps^ in [33 .. 127]) and (SafeChars[ps^] <> 0) then
        pd^ := QCharW(ps^)
      else if (ps^ = 32) and ASpacesAsPlus then
        pd^ := '+'
      else
      begin
        pd^ := '%';
        Inc(pd);
        pd^ := HexChars[(ps^ shr 4) and $0F];
        Inc(pd);
        pd^ := HexChars[ps^ and $0F];
      end;
      Inc(pd);
      Inc(ps);
    end;
  end;
  SetLength(Result, pd - PQCharW(Result));
end;

function UrlEncode(const ABytes: TBytes; ASpacesAsPlus, AEncodePercent: Boolean;
  ABookmarkEncode: TUrlBookmarkEncode): QStringW; overload;
begin
  if Length(ABytes) > 0 then
    Result := UrlEncode(@ABytes[0], Length(ABytes), ASpacesAsPlus,
      AEncodePercent, ABookmarkEncode)
  else
    SetLength(Result, 0);
end;

function UrlEncode(const S: QStringW; ASpacesAsPlus, AUtf8Encode,
  AEncodePercent: Boolean; ABookmarkEncode: TUrlBookmarkEncode)
  : QStringW; overload;
var
  ABytes: QStringA;
begin
  if Length(S) > 0 then
  begin
    if AUtf8Encode then
      ABytes := qstring.Utf8Encode(S)
    else
      ABytes := AnsiEncode(S);
    Result := UrlEncode(PByte(PQCharA(ABytes)), ABytes.Length, ASpacesAsPlus,
      AEncodePercent, ABookmarkEncode);
  end
  else
    Result := S;
end;

function UrlEncodeString(const S: QStringW): QStringW;
begin
  Result := UrlEncode(S, false, True, True, ubeAll);
end;

function UrlDecode(const AValue: QStringW; var AResult: QStringW;
  AUtf8Encode: Boolean = True): Boolean;
var
  pd, pds, pb: PQCharA;
  ps: PQCharW;
  ADoUnescape: Boolean;
  ABuf: TBytes;
begin
  Result := True;
  ps := PQCharW(AValue);
  ADoUnescape := false;
  while ps^ <> #0 do
  begin
    if (ps^ = '%') or (ps^ = '+') then
    begin
      ADoUnescape := True;
      Break;
    end
    else
      Inc(ps);
  end;
  if ADoUnescape then
  begin
    SetLength(ABuf, Length(AValue));
    pd := PQCharA(@ABuf[0]);
    ps := PQCharW(AValue);
    pds := pd;
    while ps^ <> #0 do
    begin
      if ps^ = '%' then
      begin
        Inc(ps);
        if IsHexChar(ps^) then
        begin
          pd^ := HexValue(ps^) shl 4;
          Inc(ps);
          if IsHexChar(ps^) then
          begin
            pd^ := pd^ or HexValue(ps^);
            Inc(ps);
          end
          else
          begin
            Result := false;
            Break;
          end;
        end
        else
        begin
          pd^ := QCharA('%');
          Inc(pd);
          pd^ := QCharA(ps^);
          Inc(ps);
        end;
      end
      else if ps^ = '+' then
      begin
        pd^ := 32;
        Inc(ps);
      end
      else
      begin
        pd^ := QCharA(ps^);
        Inc(ps);
      end;
      Inc(pd);
    end;
    if AUtf8Encode then
    begin
      if not Utf8Decode(pds, IntPtr(pd) - IntPtr(pds), AResult, pb) then
        AResult := AnsiDecode(pds, IntPtr(pd) - IntPtr(pds));
    end
    else
      AResult := AnsiDecode(pds, IntPtr(pd) - IntPtr(pds));
  end
  else
    AResult := AValue;
end;

function UrlDecode(const AUrl: QStringW;
  var AScheme, AHost, ADocument: QStringW; var APort: Word; AParams: TStrings;
  AUtf8Encode: Boolean): Boolean;
var
  p, ps: PQCharW;
  V, N: QStringW;
  iV: Int64;

  procedure DecodePort;
  var
    ph, pp, pl: PQCharW;
  begin
    // ��Host��������˿ں�
    ph := PQCharW(AHost);
    pp := ph + Length(AHost);
    APort := 0;
    while pp > ph do
    begin
      if pp^ = ':' then
      begin
        pl := pp;
        Inc(pp);
        if ParseInt(pp, iV) <> 0 then
        begin
          APort := Word(iV);
          SetLength(AHost, pl - ph);
          Break;
        end
        else
          Break;
      end
      else
        APort := 0;
      Dec(pp);
    end
  end;

const
  HostEnd: PQCharW = '/';
  DocEnd: PQCharW = '?';
  ParamDelimiter: PQCharW = '&';
begin
  Result := True;
  p := PQCharW(AUrl);
  SkipSpaceW(p);
  ps := p;
  p := StrStrW(ps, '://');
  if p <> nil then
  begin
    AScheme := StrDupX(ps, p - ps);
    Inc(p, 3);
    ps := p;
  end
  else
    AScheme := '';
  p := ps;
  SkipUntilW(p, HostEnd);
  AHost := StrDupX(ps, p - ps);
  DecodePort;
  if Assigned(AParams) then
  begin
    ps := p;
    SkipUntilW(p, DocEnd);
    if p^ = '?' then
    begin
      if not UrlDecode(StrDupX(ps, p - ps), ADocument, AUtf8Encode) then
        ADocument := StrDupX(ps, p - ps);
      Inc(p);
      AParams.BeginUpdate;
      try
        while p^ <> #0 do
        begin
          V := DecodeTokenW(p, ParamDelimiter, QCharW(0), false, True);
          if UrlDecode(NameOfW(V, '='), N, AUtf8Encode) and
            UrlDecode(ValueOfW(V, '=', True), V, AUtf8Encode) then
          begin
            if Length(N) > 0 then
              AParams.Add(N + '=' + V)
          end
          else
          begin
            Result := false;
            Break;
          end;
        end;
      finally
        AParams.EndUpdate;
      end;
    end
    else
    begin
      if not UrlDecode(ps, ADocument, AUtf8Encode) then
        ADocument := ps;
      AParams.Clear;
    end;
  end;
end;

function DateTimeFromString(AStr: QStringW; var AResult: TDateTime;
  AFormat: String): Boolean; overload;
// ����ʱ���ʽ
  function DecodeTagValue(var pf, ps: PWideChar; cl, cu: WideChar;
    var AValue, ACount: Integer; AMaxOnOne: Integer): Boolean;
  begin
    AValue := 0;
    ACount := 0;
    Result := True;
    while (pf^ = cl) or (pf^ = cu) do
    begin
      if (ps^ >= '0') and (ps^ <= '9') then
      begin
        AValue := AValue * 10 + Ord(ps^) - Ord('0');
        Inc(ps);
        Inc(pf);
        Inc(ACount);
      end
      else
      begin
        Result := false;
        Exit;
      end;
    end;
    if (ACount = 1) and (ACount < AMaxOnOne) then
    begin
      while (ACount < AMaxOnOne) and (ps^ >= '0') and (ps^ <= '9') do
      begin
        AValue := AValue * 10 + Ord(ps^) - Ord('0');
        Inc(ACount);
        Inc(ps);
      end;
    end;
  end;
  function DecodeAsFormat(fmt: QStringW): Boolean;
  var
    pf, ps, pl: PWideChar;
    c, Y, M, d, H, N, S, MS: Integer;
    ADate, ATime: TDateTime;
  begin
    pf := PWideChar(fmt);
    ps := PWideChar(AStr);
    c := 0;
    Y := 0;
    M := 0;
    d := 0;
    H := 0;
    N := 0;
    S := 0;
    MS := 0;
    Result := True;
    while (pf^ <> #0) and Result do
    begin
      if (pf^ = 'y') or (pf^ = 'Y') then
      // ������ݵĲ���
      begin
        Result := DecodeTagValue(pf, ps, 'y', 'Y', Y, c, 4) and (c <> 3);
        if Result then
        begin
          if c = 2 then // ��λ��ʱ
          begin
            if Y < 50 then
              Y := 2000 + Y
            else
              Y := 1900 + Y;
          end
        end;
      end
      else if (pf^ = 'm') or (pf^ = 'M') then
        Result := DecodeTagValue(pf, ps, 'm', 'M', M, c, 2)
      else if (pf^ = 'd') or (pf^ = 'D') then
        Result := DecodeTagValue(pf, ps, 'd', 'D', d, c, 2)
      else if (pf^ = 'h') or (pf^ = 'H') then
        Result := DecodeTagValue(pf, ps, 'h', 'H', H, c, 2)
      else if (pf^ = 'n') or (pf^ = 'N') then
        Result := DecodeTagValue(pf, ps, 'n', 'N', N, c, 2)
      else if (pf^ = 's') or (pf^ = 'S') then
        Result := DecodeTagValue(pf, ps, 's', 'S', S, c, 2)
      else if (pf^ = 'z') or (pf^ = 'Z') then
        Result := DecodeTagValue(pf, ps, 'z', 'Z', MS, c, 3)
      else if (pf^ = '"') or (pf^ = '''') then
      begin
        pl := pf;
        Inc(pf);
        while ps^ = pf^ do
        begin
          Inc(pf);
          Inc(ps);
        end;
        if pf^ = pl^ then
          Inc(pf);
      end
      else if pf^ = ' ' then
      begin
        Inc(pf);
        while ps^ = ' ' do
          Inc(ps);
      end
      else if pf^ = ps^ then
      begin
        Inc(pf);
        Inc(ps);
      end
      else
        Result := false;
    end;
    Result := Result and ((ps^ = #0) or (ps^ = '+'));
    if Result then
    begin
      if M = 0 then
        M := 1;
      if d = 0 then
        d := 1;
      Result := TryEncodeDate(Y, M, d, ADate);
      Result := Result and TryEncodeTime(H, N, S, MS, ATime);
      if Result then
        AResult := ADate + ATime;
    end;
  end;
  procedure SmartDetect;
  var
    V: Int64;
    l: Integer;
    ps, p, tz: PWideChar;
    I, AOffset: Integer;
  const
    KnownFormats: array [0 .. 15] of String = ('y-m-d h:n:s.z', 'y-m-d h:n:s',
      'y-m-d', 'h:n:s.z', 'h:n:s', 'y-m-d"T"h:n:s.z', 'y-m-d"T"h:n:s',
      'd/m/y h:n:s.z', 'd/m/y h:n:s', 'd/m/y', 'm/d/y h:n:s.z', 'm/d/y h:n:s',
      'm/d/y', 'y/m/d h:n:s.z', 'y/m/d h:n:s', 'y/m/d');
  begin
    ps := PWideChar(AStr);
    tz := StrStrW(ps, '+'); // +xxyy
    AOffset := 0;
    if tz <> nil then
    begin
      l := (IntPtr(tz) - IntPtr(ps)) shr 1;
      Inc(tz);
      while tz^ <> #0 do
      begin
        AOffset := AOffset * 10 + Ord(tz^) - Ord('0');
        Inc(tz);
      end;
      // Todo:Timezone����������
    end
    else
      l := Length(AStr);
    Result := True;
    if (l = 5) and DecodeAsFormat('h:n:s') then
      Exit
    else if l = 6 then
    begin
      if TryStrToInt64(AStr, V) then
      begin
        if V > 235959 then
        // ��������Ŀ϶�����ʱ�䣬��ô������yymmdd
        begin
          if not DecodeAsFormat('yymmdd') then
            Result := false;
        end
        else if ((V mod 10000) > 1231) or ((V mod 100) > 31) then
        // �·�+������ϲ����ܴ���1231
        begin
          if not DecodeAsFormat('hhnnss') then
            Result := false;
        end
        else if not DecodeAsFormat('yymmdd') then
          Result := false;
      end;
    end
    // ������������ָ�ʽ
    else if (l = 8) and (DecodeAsFormat('hh:nn:ss') or
      DecodeAsFormat('yy-mm-dd') or DecodeAsFormat('yyyymmdd')) then
      Exit
    else if (l = 9) and DecodeAsFormat('hhnnsszzz') then
      Exit
    else if l = 10 then
    // yyyy-mm-dd yyyy/mm/dd mm/dd/yyyy dd.mm.yyyy dd/mm/yy
    begin
      p := ps;
      Inc(p, 2);
      if (p^ < '0') or (p^ > '9') then
      // mm?dd?yyyy or dd?mm?yyyy
      begin
        // dd mm yyyy �Ĺ��ҾӶ࣬����ʶ��Ϊ����
        if DecodeAsFormat('dd' + p^ + 'mm' + p^ + 'yyyy') or
          DecodeAsFormat('mm' + p^ + 'dd' + p^ + 'yyyy') then
          Exit;
      end
      else if DecodeAsFormat('yyyy-mm-dd') then // ������ʽ����100�ƶ���
        Exit;
    end
    else if (l = 12) and (DecodeAsFormat('yymmddhhnnss') or
      DecodeAsFormat('hh:nn:ss.zzz')) then
      Exit
    else if (l = 14) and DecodeAsFormat('yyyymmddhhnnss') then
      Exit
    else if (l = 17) and DecodeAsFormat('yyyymmddhhnnsszzz') then
      Exit
    else if (l = 19) and (DecodeAsFormat('yyyy-mm-dd hh:nn:ss') or
      DecodeAsFormat('yyyy-mm-dd"T"hh:nn:ss')) then
      Exit
    else if (l = 23) and (DecodeAsFormat('yyyy-mm-dd hh:nn:ss.zzz') or
      DecodeAsFormat('yyyy-mm-dd"T"hh:nn:ss.zzz')) then
      Exit;
    for I := Low(KnownFormats) to High(KnownFormats) do
    begin
      if DecodeAsFormat(KnownFormats[I]) then
        Exit;
    end;
    if not ParseWebTime(ps, AResult) then
      Result := false;
  end;

begin
  AStr := Trim(AStr);
  if Length(AFormat) > 0 then
    Result := DecodeAsFormat(AFormat)
  else
    // �������ʱ�����͸�ʽ
    SmartDetect;
end;

function DateTimeFromString(Str: QStringW; AFormat: QStringW; ADef: TDateTime)
  : TDateTime; overload;
begin
  if not DateTimeFromString(Str, Result, AFormat) then
    Result := ADef;
end;

function ParseDateTime(S: PWideChar; var AResult: TDateTime): Boolean;
var
  Y, M, d, H, N, Sec, MS: Cardinal;
  AQuoter: WideChar;
  ADate: TDateTime;
  function ParseNum(var N: Cardinal): Boolean;
  var
    neg: Boolean;
    ps: PQCharW;
  begin
    N := 0;
    ps := S;
    if S^ = '-' then
    begin
      neg := True;
      Inc(S);
    end
    else
      neg := false;
    while S^ <> #0 do
    begin
      if (S^ >= '0') and (S^ <= '9') then
      begin
        N := N * 10 + Ord(S^) - 48;
        if N >= 10000 then
        begin
          Result := false;
          Exit;
        end;
        Inc(S);
      end
      else
        Break;
    end;
    if neg then
      N := -N;
    Result := ps <> S;
  end;

begin
  if (S^ = '"') or (S^ = '''') then
  begin
    AQuoter := S^;
    Inc(S);
  end
  else
    AQuoter := #0;
  Result := ParseNum(Y);
  if not Result then
    Exit;
  if (S^ = '-') or (S^ = '/') then
  begin
    Inc(S);
    Result := ParseNum(M);
    if (not Result) or ((S^ <> '-') and (S^ <> '/')) then
    begin
      Result := false;
      Exit;
    end;
    Inc(S);
    Result := ParseNum(d);
    if (not Result) or ((S^ <> 'T') and (S^ <> ' ') and (S^ <> #0)) then
    begin
      Result := false;
      Exit;
    end;
    if S^ <> #0 then
      Inc(S);
    if d > 31 then // D -> Y
    begin
      if M > 12 then // M/D/Y M -> D, D->Y, Y->M
        Result := TryEncodeDate(d, Y, M, ADate)
      else // D/M/Y
        Result := TryEncodeDate(d, M, Y, ADate);
    end
    else
      Result := TryEncodeDate(Y, M, d, ADate);
    if not Result then
      Exit;
    SkipSpaceW(S);
    if S^ <> #0 then
    begin
      if not ParseNum(H) then // û��ʱ��ֵ
      begin
        AResult := ADate;
        Exit;
      end;
      if S^ <> ':' then
      begin
        if H in [0 .. 23] then
          AResult := ADate + EncodeTime(H, 0, 0, 0)
        else
          Result := false;
        Exit;
      end;
      Inc(S);
    end
    else
    begin
      AResult := ADate;
      Exit;
    end;
  end
  else if S^ = ':' then
  begin
    ADate := 0;
    H := Y;
    Inc(S);
  end
  else
  begin
    Result := false;
    Exit;
  end;
  if H > 23 then
  begin
    Result := false;
    Exit;
  end;
  if not ParseNum(N) then
  begin
    if AQuoter <> #0 then
    begin
      if S^ = AQuoter then
        AResult := ADate + EncodeTime(H, 0, 0, 0)
      else
        Result := false;
    end
    else
      AResult := ADate + EncodeTime(H, 0, 0, 0);
    Exit;
  end
  else if N > 59 then
  begin
    Result := false;
    Exit;
  end;
  Sec := 0;
  MS := 0;
  if S^ = ':' then
  begin
    Inc(S);
    if not ParseNum(Sec) then
    begin
      if AQuoter <> #0 then
      begin
        if S^ = AQuoter then
          AResult := ADate + EncodeTime(H, N, 0, 0)
        else
          Result := false;
      end
      else
        AResult := ADate + EncodeTime(H, N, 0, 0);
      Exit;
    end
    else if Sec > 59 then
    begin
      Result := false;
      Exit;
    end;
    if S^ = '.' then
    begin
      Inc(S);
      if not ParseNum(MS) then
      begin
        if AQuoter <> #0 then
        begin
          if AQuoter = S^ then
            AResult := ADate + EncodeTime(H, N, Sec, 0)
          else
            Result := false;
        end
        else
          AResult := ADate + EncodeTime(H, N, Sec, 0);
        Exit;
      end
      else if MS >= 1000 then // ����1000����΢��Ϊ��λ��ʱ�ģ�ת��Ϊ����
      begin
        while MS >= 1000 do
          MS := MS div 10;
      end;
      if AQuoter <> #0 then
      begin
        if AQuoter = S^ then
          AResult := ADate + EncodeTime(H, N, Sec, MS)
        else
          Result := false;
        Exit;
      end
      else
        AResult := ADate + EncodeTime(H, N, Sec, MS);
    end
    else
    begin
      if AQuoter <> #0 then
      begin
        if AQuoter = S^ then
          AResult := ADate + EncodeTime(H, N, Sec, 0)
        else
          Result := false;
      end
      else
        AResult := ADate + EncodeTime(H, N, Sec, 0)
    end;
  end
  else
  begin
    if AQuoter <> #0 then
    begin
      if AQuoter = S^ then
        AResult := ADate + EncodeTime(H, N, 0, 0)
      else
        Result := false;
    end
    else
      AResult := ADate + EncodeTime(H, N, 0, 0);
  end;
end;

function ParseWebTime(p: PWideChar; var AResult: TDateTime): Boolean;
var
  I: Integer;
  Y, M, d, H, N, S, tz: Integer;
const
  MonthNames: array [0 .. 11] of QStringW = ('Jan', 'Feb', 'Mar', 'Apr', 'May',
    'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  WeekNames: array [0 .. 6] of QStringW = ('Mon', 'Tue', 'Wed', 'Thu', 'Fri',
    'Sat', 'Sun');
  Comma: WideChar = ',';
  Digits: PWideChar = '0123456789';
  // Web ���ڸ�ʽ������, �� �� �� ʱ:��:�� GMT
begin
  // �������ڣ��������ֱ��ͨ�����ڼ������������Ҫ
  SkipSpaceW(p);
  for I := 0 to High(WeekNames) do
  begin
    if StartWithW(p, PQCharW(WeekNames[I]), True) then
    begin
      Inc(p, Length(WeekNames[I]));
      SkipSpaceW(p);
      Break;
    end;
  end;
  if p^ = Comma then
    Inc(p);
  SkipSpaceW(p);
  d := 0;
  // ����
  while (p^ >= '0') and (p^ <= '9') do
  begin
    d := d * 10 + Ord(p^) - Ord('0');
    Inc(p);
  end;
  if (not(IsSpaceW(p) or (p^ = '-'))) or (d < 1) or (d > 31) then
  begin
    Result := false;
    Exit;
  end;
  if p^ = '-' then
    Inc(p);
  SkipSpaceW(p);
  M := 0;
  for I := 0 to 11 do
  begin
    if StartWithW(p, PWideChar(MonthNames[I]), True) then
    begin
      M := I + 1;
      Inc(p, Length(MonthNames[I]));
      Break;
    end;
  end;
  if (not(IsSpaceW(p) or (p^ = '-'))) or (M < 1) or (M > 12) then
  begin
    Result := false;
    Exit;
  end;
  if p^ = '-' then
    Inc(p);
  SkipSpaceW(p);
  Y := 0;
  while (p^ >= '0') and (p^ <= '9') do
  begin
    Y := Y * 10 + Ord(p^) - Ord('0');
    Inc(p);
  end;
  if not(IsSpaceW(p) or (p^ = '-')) then
  begin
    Result := false;
    Exit;
  end;
  SkipSpaceW(p);
  if p^ <> #0 then
  begin
    H := 0;
    while (p^ >= '0') and (p^ <= '9') do
    begin
      H := H * 10 + Ord(p^) - Ord('0');
      Inc(p);
    end;
    if p^ <> ':' then
    begin
      Result := false;
      Exit;
    end;
    Inc(p);
    N := 0;
    while (p^ >= '0') and (p^ <= '9') do
    begin
      N := N * 10 + Ord(p^) - Ord('0');
      Inc(p);
    end;
    if p^ <> ':' then
    begin
      Result := false;
      Exit;
    end;
    Inc(p);
    S := 0;
    while (p^ >= '0') and (p^ <= '9') do
    begin
      S := S * 10 + Ord(p^) - Ord('0');
      Inc(p);
    end;
    SkipSpaceW(p);
    tz := 0;
    if StartWithW(p, 'GMT', True) then
    begin
      Inc(p, 3);
      if p^ = '-' then
      begin
        Inc(p);
        I := -1;
      end
      else
      begin
        if p^ = '+' then
          Inc(p);
        I := 1;
      end;
      SkipSpaceW(p);
      while (p^ >= '0') and (p^ <= '9') do
      begin
        tz := tz * 10 + Ord(p^) - Ord('0');
        Inc(p);
      end;
      tz := tz * 60;
      if p^ = ':' then
        Inc(p);
      while (p^ >= '0') and (p^ <= '9') do
      begin
        tz := tz * 10 + Ord(p^) - Ord('0');
        Inc(p);
      end;
      tz := tz * I;
    end;
  end
  else
  begin
    H := 0;
    N := 0;
    S := 0;
    tz := 0;
  end;
  Result := TryEncodeDateTime(Y, M, d, H, N, S, 0, AResult);
  if Result and (tz <> 0) then
    AResult := IncMinute(AResult, -tz);
end;

function GetTimeZone: Integer;
var
{$IFDEF MSWindows}
  TimeZone: TTimeZoneInformation;
{$ELSE}
  tmLocal: TM;
  t1: time_t;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  GetTimeZoneInformation(TimeZone);
  Result := -TimeZone.Bias;
{$ELSE}
  t1 := 0;
  localtime_r(t1, tmLocal);
  Result := tmLocal.tm_gmtoff div 60;
{$ENDIF}
end;

function GetTimezoneText: QStringW;
var
  ATz: Integer;
begin
  ATz := GetTimeZone;
  if ATz > 0 then
    Result := Format('+%.2d%.2d', [ATz div 60, ATz mod 60])
  else
  begin
    ATz := -ATz;
    Result := Format('-%.2d%.2d', [ATz div 60, ATz mod 60]);
  end;
end;

function EncodeWebTime(ATime: TDateTime): QStringW;
var
  Y, M, d, H, N, S, MS: Word;
  ATimeZone: QStringW;
const
  DefShortMonthNames: array [1 .. 12] of String = ('Jan', 'Feb', 'Mar', 'Apr',
    'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
  DefShortDayNames: array [1 .. 7] of String = ('Sun', 'Mon', 'Tue', 'Wed',
    'Thu', 'Fri', 'Sat');
begin
  if (ATime < MinDateTime) or (ATime > MaxDateTime) then
    Result := ''
  else
  begin
    DecodeDateTime(ATime, Y, M, d, H, N, S, MS);
    Result := DefShortDayNames[DayOfWeek(ATime)] + ',' + IntToStr(d) + ' ' +
      DefShortMonthNames[M] + ' ' + IntToStr(Y) + ' ' + IntToStr(H) + ':' +
      IntToStr(N) + ':' + IntToStr(S);
    ATimeZone := GetTimezoneText;
    if Length(ATimeZone) > 0 then
      Result := Result + ' GMT ' + ATimeZone;
  end;
end;

function RollupSize(ASize: Int64): QStringW;
var
  AIdx, R1, s1: Int64;
  AIsNeg: Boolean;
const
  Units: array [0 .. 5] of QStringW = ('EB', 'TB', 'GB', 'MB', 'KB', 'B');
begin
  AIsNeg := (ASize < 0);
  AIdx := High(Units);
  R1 := 0;
  if AIsNeg then
    ASize := -ASize;
  Result := '';
  while (AIdx >= 0) do
  begin
    s1 := ASize mod 1024;
    ASize := ASize shr 10;
    if (ASize = 0) or (AIdx = 0) then
    begin
      R1 := R1 * 100 div 1024;
      if R1 > 0 then
      begin
        if R1 >= 10 then
          Result := IntToStr(s1) + '.' + IntToStr(R1) + Units[AIdx]
        else
          Result := IntToStr(s1) + '.' + '0' + IntToStr(R1) + Units[AIdx];
      end
      else
        Result := IntToStr(s1) + Units[AIdx];
      Break;
    end;
    R1 := s1;
    Dec(AIdx);
  end;
  if AIsNeg then
    Result := '-' + Result;
end;

function RollupTime(ASeconds: Int64; AHideZero: Boolean): QStringW;
var
  H, N, d: Integer;
begin
  if ASeconds = 0 then
  begin
    if AHideZero then
      Result := ''
    else
      Result := '0' + SSecondName;
  end
  else
  begin
    Result := '';
    d := ASeconds div 86400;
    ASeconds := ASeconds mod 86400;
    H := ASeconds div 3600;
    ASeconds := ASeconds mod 3600;
    N := ASeconds div 60;
    ASeconds := ASeconds mod 60;
    if d > 0 then
      Result := IntToStr(d) + SDayName
    else
      Result := '';
    if H > 0 then
      Result := Result + IntToStr(H) + SHourName;
    if N > 0 then
      Result := Result + IntToStr(N) + SMinuteName;
    if ASeconds > 0 then
      Result := Result + IntToStr(ASeconds) + SSecondName;
  end;
end;
{ QStringA }

function QStringA.From(p: PQCharA; AOffset, ALen: Integer): PQStringA;
begin
  SetLength(ALen);
  Inc(p, AOffset);
  Move(p^, PQCharA(@FValue[1])^, ALen);
  Result := @Self;
end;

function QStringA.From(const S: QStringA; AOffset: Integer): PQStringA;
begin
  Result := From(PQCharA(S), AOffset, S.Length);
end;

function QStringA.GetChars(AIndex: Integer): QCharA;
begin
  if (AIndex < 0) or (AIndex >= Length) then
    raise Exception.CreateFmt(SOutOfIndex, [AIndex, 0, Length - 1]);
  Result := FValue[AIndex + 1];
end;

function QStringA.GetData: PByte;
begin
  Result := @FValue[1];
end;

class operator QStringA.Implicit(const S: QStringW): QStringA;
begin
  Result := qstring.AnsiEncode(S);
end;

class operator QStringA.Implicit(const S: QStringA): PQCharA;
begin
  Result := PQCharA(@S.FValue[1]);
end;

function QStringA.GetIsUtf8: Boolean;
begin
  if System.Length(FValue) > 0 then
    Result := (FValue[0] = 1)
  else
    Result := false;
end;

function QStringA.GetLength: Integer;
begin
  // QStringA.FValue[0]�����������ͣ�0-ANSI,1-UTF8��ĩβ�����ַ�����\0������
  Result := System.Length(FValue);
  if Result >= 2 then
    Dec(Result, 2)
  else
    Result := 0;
end;

class operator QStringA.Implicit(const S: QStringA): TBytes;
var
  l: Integer;
begin
  l := System.Length(S.FValue) - 1;
  System.SetLength(Result, l);
  if l > 0 then
    Move(S.FValue[1], Result[0], l);
end;

procedure QStringA.SetChars(AIndex: Integer; const Value: QCharA);
begin
  if (AIndex < 0) or (AIndex >= Length) then
    raise Exception.CreateFmt(SOutOfIndex, [AIndex, 0, Length - 1]);
  FValue[AIndex + 1] := Value;
end;

procedure QStringA.SetIsUtf8(const Value: Boolean);
begin
  if System.Length(FValue) = 0 then
    System.SetLength(FValue, 1);
  FValue[0] := Byte(Value);
end;

procedure QStringA.SetLength(const Value: Integer);
begin
  if Value < 0 then
  begin
    if System.Length(FValue) > 0 then
      System.SetLength(FValue, 1)
    else
    begin
      System.SetLength(FValue, 1);
      FValue[0] := 0; // ANSI
    end;
  end
  else
  begin
    System.SetLength(FValue, Value + 2);
    FValue[Value + 1] := 0;
  end;
end;

class function QStringA.UpperCase(S: PQCharA): QStringA;
var
  l: Integer;
  ps: PQCharA;
begin
  if Assigned(S) then
  begin
    ps := S;
    while S^ <> 0 do
    begin
      Inc(S)
    end;
    l := IntPtr(S) - IntPtr(ps);
    Result.SetLength(l);
    S := ps;
    ps := PQCharA(Result);
    while S^ <> 0 do
    begin
      ps^ := CharUpperA(S^);
      Inc(ps);
      Inc(S);
    end;
  end
  else
    Result.SetLength(0);
end;

function QStringA.UpperCase: QStringA;
var
  l: Integer;
  pd, ps: PQCharA;
begin
  l := System.Length(FValue);
  System.SetLength(Result.FValue, l);
  if l > 0 then
  begin
    Result.FValue[0] := FValue[0];
    Dec(l);
    pd := PQCharA(Result);
    ps := PQCharA(Self);
    while l > 0 do
    begin
      pd^ := CharUpperA(ps^);
      Inc(pd);
      Inc(ps);
      Dec(l);
    end;
  end;
end;

class operator QStringA.Implicit(const ABytes: TBytes): QStringA;
var
  l: Integer;
begin
  l := System.Length(ABytes);
  Result.Length := l;
  if l > 0 then
    Move(ABytes[0], Result.FValue[1], l);
end;

class operator QStringA.Implicit(const S: QStringA): QStringW;
begin
  Result := AnsiDecode(S);
end;

function BinToHex(p: Pointer; l: Integer; ALowerCase: Boolean): QStringW;
const
  B2HConvert: array [0 .. 15] of QCharW = ('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
  B2HConvertL: array [0 .. 15] of QCharW = ('0', '1', '2', '3', '4', '5', '6',
    '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
var
  pd: PQCharW;
  pb: PByte;
begin
  SetLength(Result, l shl 1);
  pd := PQCharW(Result);
  pb := p;
  if ALowerCase then
  begin
    while l > 0 do
    begin
      pd^ := B2HConvertL[pb^ shr 4];
      Inc(pd);
      pd^ := B2HConvertL[pb^ and $0F];
      Inc(pd);
      Inc(pb);
      Dec(l);
    end;
  end
  else
  begin
    while l > 0 do
    begin
      pd^ := B2HConvert[pb^ shr 4];
      Inc(pd);
      pd^ := B2HConvert[pb^ and $0F];
      Inc(pd);
      Inc(pb);
      Dec(l);
    end;
  end;
end;

function BinToHex(const ABytes: TBytes; ALowerCase: Boolean): QStringW;
begin
  Result := BinToHex(@ABytes[0], Length(ABytes), ALowerCase);
end;

procedure HexToBin(const S: QStringW; var AResult: TBytes);
var
  l: Integer;
  p, ps: PQCharW;
  pd: PByte;
begin
  l := System.Length(S);
  SetLength(AResult, l shr 1);
  p := PQCharW(S);
  ps := p;
  pd := @AResult[0];
  while p - ps < l do
  begin
    if IsHexChar(p[0]) and IsHexChar(p[1]) then
    begin
      pd^ := (HexValue(p[0]) shl 4) + HexValue(p[1]);
      Inc(pd);
      Inc(p, 2);
    end
    else
    begin
      SetLength(AResult, 0);
      Exit;
    end;
  end;
end;

function HexToBin(const S: QStringW): TBytes;
begin
  HexToBin(S, Result);
end;

procedure FreeObject(AObject: TObject);
begin
{$IFDEF AUTOREFCOUNT}
  AObject.DisposeOf;
{$ELSE}
  AObject.Free;
{$ENDIF}
end;

procedure FreeAndNilObject(var AObject);
var
  ATemp: TObject;
begin
  ATemp := TObject(AObject);
  Pointer(AObject) := nil;
  FreeObject(ATemp);
end;
{$Q-}

function HashOf(p: Pointer; l: Integer): Cardinal;
{$IFDEF WIN32}
label A00, A01;
begin
  asm
    push ebx
    mov eax,l
    mov ebx,0
    cmp eax,ebx
    jz A01
    xor    eax, eax
    mov    edx, p
    mov    ebx,edx
    add    ebx,l
    A00:
    imul   eax,131
    movzx  ecx, BYTE ptr [edx]
    inc    edx
    add    eax, ecx
    cmp   ebx, edx
    jne    A00
    A01:
    pop ebx
    mov Result,eax
  end;
{$ELSE}
var
  pe: PByte;
  ps: PByte absolute p;
const
  seed = 131;
  // 31 131 1313 13131 131313 etc..
begin
  pe := p;
  Inc(pe, l);
  Result := 0;
  while IntPtr(ps) < IntPtr(pe) do
  begin
    Result := Result * seed + ps^;
    Inc(ps);
  end;
  Result := Result and $7FFFFFFF;
{$ENDIF}
end;
{$Q+}

class operator QStringA.Implicit(const S: PQCharA): QStringA;
var
  p: PQCharA;
begin
  if S <> nil then
  begin
    p := S;
    while p^ <> 0 do
      Inc(p);
    Result.Length := IntPtr(p) - IntPtr(S);
    Move(S^, PQCharA(Result)^, Result.Length);
  end
  else
    Result.Length := 0;
end;
{$IFNDEF NEXTGEN}

class operator QStringA.Implicit(const S: AnsiString): QStringA;
begin
  Result.From(PQCharA(S), 0, System.Length(S));
end;

class operator QStringA.Implicit(const S: QStringA): AnsiString;
begin
  System.SetLength(Result, S.Length);
  if S.Length > 0 then
    Move(PQCharA(S)^, PAnsiChar(Result)^, S.Length);
end;

{$ENDIF}

class function QStringA.LowerCase(S: PQCharA): QStringA;
var
  l: Integer;
  ps: PQCharA;
begin
  if Assigned(S) then
  begin
    ps := S;
    while S^ <> 0 do
    begin
      Inc(S)
    end;
    l := IntPtr(S) - IntPtr(ps);
    Result.SetLength(l);
    S := ps;
    ps := PQCharA(Result);
    while S^ <> 0 do
    begin
      ps^ := CharLowerA(S^);
      Inc(ps);
      Inc(S);
    end;
  end
  else
    Result.SetLength(0);
end;

function QStringA.LowerCase: QStringA;
var
  l: Integer;
  pd, ps: PQCharA;
begin
  l := System.Length(FValue);
  System.SetLength(Result.FValue, l);
  if l > 0 then
  begin
    Result.FValue[0] := FValue[0];
    Dec(l);
    pd := PQCharA(Result);
    ps := PQCharA(Self);
    while l > 0 do
    begin
      pd^ := CharLowerA(ps^);
      Inc(pd);
      Inc(ps);
      Dec(l);
    end;
  end;
end;

function QStringA.Cat(p: PQCharA; ALen: Integer): PQStringA;
var
  l: Integer;
begin
  l := Length;
  SetLength(l + ALen);
  Move(p^, FValue[1 + l], ALen);
  Result := @Self;
end;

function QStringA.Cat(const S: QStringA): PQStringA;
begin
  Result := Cat(PQCharA(S), S.Length);
end;

class function QStringA.Create(const p: PQCharA; AIsUtf8: Boolean): QStringA;
var
  pe: PQCharA;
begin
  pe := p;
  while pe^ <> 0 do
    Inc(pe);
  Result.Cat(p, IntPtr(pe) - IntPtr(p));
  Result.SetIsUtf8(AIsUtf8);
end;

{ TQStringCatHelperW }

function TQStringCatHelperW.Back(ALen: Integer): TQStringCatHelperW;
begin
  Result := Self;
  Dec(FDest, ALen);
  if FDest < FStart then
    FDest := FStart;
end;

function TQStringCatHelperW.BackIf(const S: PQCharW): TQStringCatHelperW;
var
  ps: PQCharW;
begin
  Result := Self;
  ps := FStart;
  while FDest > ps do
  begin
    if (FDest[-1] >= #$DC00) and (FDest[-1] <= #$DFFF) then
    begin
      if CharInW(FDest - 2, S) then
        Dec(FDest, 2)
      else
        Break;
    end
    else if CharInW(FDest - 1, S) then
      Dec(FDest)
    else
      Break;
  end;
end;

function TQStringCatHelperW.Cat(const S: QStringW; AQuoter: QCharW)
  : TQStringCatHelperW;
begin
  Result := Cat(PQCharW(S), Length(S), AQuoter);
end;

function TQStringCatHelperW.Cat(p: PQCharW; len: Integer; AQuoter: QCharW)
  : TQStringCatHelperW;
var
  ps: PQCharW;
  ACount: Integer;
  procedure DirectMove;
  begin
    Move(p^, FDest^, len shl 1);
    Inc(FDest, len);
  end;

begin
  Result := Self;
  if (len < 0) or (AQuoter <> #0) then
  begin
    ps := p;
    len := 0;
    ACount := 0;
    // �ȼ��㳤�ȣ�һ�η����ڴ�
    while ps^ <> #0 do
    begin
      if ps^ = AQuoter then
        Inc(ACount);
      Inc(len);
      Inc(ps);
    end;
    if AQuoter <> #0 then
      NeedSize(-len - ACount - 2)
    else
      NeedSize(-len);
    if AQuoter <> #0 then
    begin
      begin
        FDest^ := AQuoter;
        Inc(FDest);
        // �����������Ϊ0��ֱ�Ӹ��ƣ�����ѭ��
        if ACount = 0 then
          DirectMove
        else
        begin
          while p^ <> #0 do
          begin
            FDest^ := p^;
            Inc(FDest);
            if p^ = AQuoter then
            begin
              FDest^ := p^;
              Inc(FDest);
            end;
            Inc(p);
          end;
        end;
        FDest^ := AQuoter;
        Inc(FDest);
      end;
    end
    else
      DirectMove;
  end
  else
  begin
    NeedSize(-len);
    DirectMove;
  end;
end;

function TQStringCatHelperW.Cat(c: QCharW): TQStringCatHelperW;
begin
  if Position >= FSize then
    NeedSize(-1);
  FDest^ := c;
  Inc(FDest);
  Result := Self;
end;

function TQStringCatHelperW.Cat(const V: Double): TQStringCatHelperW;
begin
  Result := Cat(FloatToStr(V));
end;

function TQStringCatHelperW.Cat(const V: Int64;const AsHexStr:Boolean): TQStringCatHelperW;
begin
  if AsHexStr then
    Result:=Cat(IntToHex(V,SizeOf(Pointer)*2))
  else
    Result := Cat(IntToStr(V));
end;

function TQStringCatHelperW.Cat(const V: Boolean): TQStringCatHelperW;
begin
  Result := Cat(BoolToStr(V, True));
end;

function TQStringCatHelperW.Cat(const V: TGuid): TQStringCatHelperW;
begin
  Result := Cat(GuidToString(V));
end;

function TQStringCatHelperW.Cat(const V: Currency): TQStringCatHelperW;
begin
  Result := Cat(CurrToStr(V));
end;

constructor TQStringCatHelperW.Create(ASize: Integer);
begin
  inherited Create;
  if ASize < 8192 then
    ASize := 8192
  else if (ASize and $3FF) <> 0 then
    ASize := ((ASize shr 10) + 1) shr 1;
  FBlockSize := ASize;
  NeedSize(FBlockSize);
end;

function TQStringCatHelperW.EndWith(const S: QStringW;
  AIgnoreCase: Boolean): Boolean;
var
  p: PQCharW;
begin
  p := FDest;
  Dec(p, Length(S));
  if p >= FStart then
    Result := StrNCmpW(p, PQCharW(S), AIgnoreCase, Length(S)) = 0
  else
    Result := false;
end;

constructor TQStringCatHelperW.Create;
begin
  inherited Create;
  FBlockSize := 8192;
  NeedSize(FBlockSize);
end;

function TQStringCatHelperW.GetChars(AIndex: Integer): QCharW;
begin
  Result := FStart[AIndex];
end;

function TQStringCatHelperW.GetIsEmpty: Boolean;
begin
  Result := FDest <> FStart;
end;

function TQStringCatHelperW.GetPosition: Integer;
begin
  Result := FDest - FStart;
end;

function TQStringCatHelperW.GetValue: QStringW;
var
  l: Integer;
begin
  l := Position;
  SetLength(Result, l);
  Move(FStart^, PQCharW(Result)^, l shl 1);
end;

procedure TQStringCatHelperW.IncSize(ADelta: Integer);
begin
  NeedSize(-ADelta);
end;

procedure TQStringCatHelperW.LoadFromFile(const AFileName: QStringW);
begin
  Reset;
  Cat(LoadTextW(AFileName));
end;

procedure TQStringCatHelperW.LoadFromStream(const AStream: TStream);
begin
  Reset;
  Cat(LoadTextW(AStream));
end;

procedure TQStringCatHelperW.NeedSize(ASize: Integer);
var
  Offset: Integer;
begin
  Offset := FDest - FStart;
  if ASize < 0 then
    ASize := Offset - ASize;
  if ASize > FSize then
  begin
{$IFDEF DEBUG}
    Inc(FAllocTimes);
{$ENDIF}
    FSize := ((ASize + FBlockSize) div FBlockSize) * FBlockSize;
    SetLength(FValue, FSize);
    FStart := PQCharW(@FValue[0]);
    FDest := FStart + Offset;
    FLast := FStart + FSize;
  end;
end;

function TQStringCatHelperW.Replicate(const S: QStringW; count: Integer)
  : TQStringCatHelperW;
var
  ps: PQCharW;
  l: Integer;
begin
  Result := Self;
  if count > 0 then
  begin
    ps := PQCharW(S);
    l := Length(S);
    while count > 0 do
    begin
      Cat(ps, l);
      Dec(count);
    end;
  end;
end;

procedure TQStringCatHelperW.Reset;
begin
  FDest := FStart;
end;

procedure TQStringCatHelperW.SetDest(const Value: PQCharW);
begin
  if Value < FStart then
    FDest := FStart
  else if Value > FLast then
    FDest := FLast
  else
    FDest := Value;
end;

procedure TQStringCatHelperW.SetPosition(const Value: Integer);
begin
  if Value <= 0 then
    FDest := FStart
  else if Value > Length(FValue) then
  begin
    NeedSize(Value);
    FDest := FStart + Value;
  end
  else
    FDest := FStart + Value;
end;

function TQStringCatHelperW.ToString: QStringW;
begin
  Result := Value;
end;

procedure TQStringCatHelperW.TrimRight;
var
  pd: PQCharW;
begin
  pd := FDest;
  Dec(pd);
  while FStart < pd do
  begin
    if IsSpaceW(pd) then
      Dec(pd)
    else
      Break;
  end;
  Inc(pd);
  FDest := pd;
end;

function TQStringCatHelperW.Cat(const V: Variant): TQStringCatHelperW;
begin
  Result := Cat(VarToStr(V));
end;

function TQStringCatHelperW.Cat(const V: TDateTime; const AFormat: String;
  AQuoter: QCharW): TQStringCatHelperW;
begin
  if Length(AFormat) > 0 then
    Result := Cat(FormatDateTime(AFormat, V), AQuoter)
  else if V < 1 then
    Result := Cat(FormatDateTime('hh:nn:ss', V), AQuoter)
  else if IsZero(V - Trunc(V)) then
    Result := Cat(FormatDateTime('yyyy-mm-dd', V), AQuoter)
  else
    Result := Cat(FormatDateTime('yyyy-mm-dd hh:nn:ss', V), AQuoter);
end;

{ TQPtr }

class function TQPtr.Bind(AObject: TObject): IQPtr;
begin
  Result := TQPtr.Create(AObject);
end;

class function TQPtr.Bind(AData: Pointer; AOnFree: TQPtrFreeEventG): IQPtr;
var
  ATemp: TQPtr;
begin
  ATemp := TQPtr.Create(AData);
  ATemp.FOnFree.Method.Data := nil;
  ATemp.FOnFree.OnFreeG := AOnFree;
  Result := ATemp;
end;

class function TQPtr.Bind(AData: Pointer; AOnFree: TQPtrFreeEvent): IQPtr;
var
  ATemp: TQPtr;
begin
  ATemp := TQPtr.Create(AData);
{$IFDEF NEXTGEN}
  PQPtrFreeEvent(@ATemp.FOnFree.OnFree)^ := AOnFree;
{$ELSE}
  ATemp.FOnFree.OnFree := AOnFree;
{$ENDIF}
  Result := ATemp;
end;

{$IFDEF UNICODE}

class function TQPtr.Bind(AData: Pointer; AOnFree: TQPtrFreeEventA): IQPtr;
var
  ATemp: TQPtr;
begin
  ATemp := TQPtr.Create(AData);
  ATemp.FOnFree.Method.Data := Pointer(-1);
  PQPtrFreeEventA(@ATemp.FOnFree.OnFreeA)^ := AOnFree;
  Result := ATemp;
end;
{$ENDIF}

constructor TQPtr.Create(AObject: Pointer);
begin
  inherited Create;
  FObject := AObject;
end;

destructor TQPtr.Destroy;
begin
  if Assigned(FObject) then
  begin
    if FOnFree.Method.Code <> nil then
    begin
      if FOnFree.Method.Data = nil then
        FOnFree.OnFreeG(FObject)
{$IFDEF UNICODE}
      else if FOnFree.Method.Data = Pointer(-1) then
        TQPtrFreeEventA(FOnFree.OnFreeA)(FObject)
{$ENDIF}
      else
{$IFDEF NEXTGEN}
      begin
        PQPtrFreeEvent(FOnFree.OnFree)^(FObject);
        PQPtrFreeEvent(FOnFree.OnFree)^ := nil;
      end;
{$ELSE}
      FOnFree.OnFree(FObject);
{$ENDIF}
    end
    else
      FreeAndNil(FObject);
  end;
  inherited;
end;

function TQPtr.Get: Pointer;
begin
  Result := FObject;
end;

// ����2007���ԭ�Ӳ����ӿ�
{$IF RTLVersion<24}

function AtomicCmpExchange(var Target: Integer; Value: Integer;
  Comparand: Integer): Integer; inline;
begin
{$IFDEF MSWINDOWS}
  Result := InterlockedCompareExchange(Target, Value, Comparand);
{$ELSE}
  Result := TInterlocked.CompareExchange(Target, Value, Comparand);
{$ENDIF}
end;

function AtomicCmpExchange(var Target: Pointer; Value: Pointer;
  Comparand: Pointer): Pointer; inline;
begin
{$IFDEF MSWINDOWS}
  Result := Pointer(InterlockedCompareExchange(PInteger(@Target)^,
    Integer(Value), Integer(Comparand)));
{$ELSE}
  Result := TInterlocked.CompareExchange(Target, Value, Comparand);
{$ENDIF}
end;

function AtomicIncrement(var Target: Integer; const Value: Integer)
  : Integer; inline;
begin
{$IFDEF MSWINDOWS}
  if Value = 1 then
    Result := InterlockedIncrement(Target)
  else if Value = -1 then
    Result := InterlockedDecrement(Target)
  else
    Result := InterlockedExchangeAdd(Target, Value);
{$ELSE}
  if Value = 1 then
    Result := TInterlocked.Increment(Target)
  else if Value = -1 then
    Result := TInterlocked.Decrement(Target)
  else
    Result := TInterlocked.Add(Target, Value);
{$ENDIF}
end;

function AtomicDecrement(var Target: Integer): Integer; inline;
begin
  // Result := InterlockedDecrement(Target);
  Result := AtomicIncrement(Target, -1);
end;

function AtomicExchange(var Target: Integer; Value: Integer): Integer;
begin
{$IFDEF MSWINDOWS}
  Result := InterlockedExchange(Target, Value);
{$ELSE}
  Result := TInterlocked.Exchange(Target, Value);
{$ENDIF}
end;

function AtomicExchange(var Target: Pointer; Value: Pointer): Pointer;
begin
{$IFDEF MSWINDOWS}
{$IF RTLVersion>19}
  Result := InterlockedExchangePointer(Target, Value);
{$ELSE}
  Result := Pointer(IntPtr(InterlockedExchange(IntPtr(Target), IntPtr(Value))));
{$IFEND}
{$ELSE}
  Result := TInterlocked.Exchange(Target, Value);
{$ENDIF}
end;
{$IFEND <XE5}

// λ�룬����ԭֵ
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  I: Integer;
begin
  repeat
    Result := Dest;
    I := Result and AMask;
  until AtomicCmpExchange(Dest, I, Result) = Result;
end;

// λ�򣬷���ԭֵ
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  I: Integer;
begin
  repeat
    Result := Dest;
    I := Result or AMask;
  until AtomicCmpExchange(Dest, I, Result) = Result;
end;

{ TQBytesCatHelper }

function TQBytesCatHelper.Back(ALen: Integer): TQBytesCatHelper;
begin
  Result := Self;
  Dec(FDest, ALen);
  if IntPtr(FDest) < IntPtr(FStart) then
    FDest := FStart;
end;

function TQBytesCatHelper.Cat(const V: Double): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Double));
end;

function TQBytesCatHelper.Cat(const V: Currency): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Currency));
end;

function TQBytesCatHelper.Cat(const V: Boolean): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Boolean));
end;

function TQBytesCatHelper.Cat(const S: QStringW): TQBytesCatHelper;
begin
  Result := Cat(PQCharW(S), System.Length(S) shl 1);
end;

function TQBytesCatHelper.Cat(const V: Byte): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Byte));
end;

function TQBytesCatHelper.Cat(const V: Int64): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Int64));
end;

function TQBytesCatHelper.Cat(const c: QCharW): TQBytesCatHelper;
begin
  Result := Cat(@c, SizeOf(QCharW));
end;

function TQBytesCatHelper.Cat(const V: Variant): TQBytesCatHelper;
begin
  // ??����һ���������ʵ�֣���ʱ����������ͷ��ո�
  Result := Cat(@V, SizeOf(Variant));
end;

function TQBytesCatHelper.Cat(const V: QStringA; ACStyle: Boolean)
  : TQBytesCatHelper;
begin
  if ACStyle then
    Result := Cat(PQCharA(V), V.Length + 1)
  else
    Result := Cat(PQCharA(V), V.Length);
end;

{$IFNDEF NEXTGEN}

function TQBytesCatHelper.Cat(const V: AnsiChar): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(AnsiChar));
end;

function TQBytesCatHelper.Cat(const V: AnsiString): TQBytesCatHelper;
begin
  Result := Cat(PAnsiChar(V), System.Length(V));
end;
{$ENDIF}

function TQBytesCatHelper.Cat(const V: Single): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Single));
end;

function TQBytesCatHelper.Cat(const V: Cardinal): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Cardinal));
end;

function TQBytesCatHelper.Cat(const V: Smallint): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Smallint));
end;

function TQBytesCatHelper.Cat(const V: Word): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Word));
end;

function TQBytesCatHelper.Cat(const V: Shortint): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Shortint));
end;

function TQBytesCatHelper.Cat(const V: Integer): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(Integer));
end;

function TQBytesCatHelper.Cat(const ABytes: TBytes): TQBytesCatHelper;
begin
  if Length(ABytes) > 0 then
    Result := Cat(@ABytes[0], Length(ABytes))
  else
    Result := Self;
end;

function TQBytesCatHelper.Cat(const AData: Pointer; const ALen: Integer)
  : TQBytesCatHelper;
begin
  Result := Self;
  NeedSize(-ALen);
  Move(AData^, FDest^, ALen);
  Inc(FDest, ALen);
end;

function TQBytesCatHelper.Cat(const V: TGuid): TQBytesCatHelper;
begin
  Result := Cat(@V, SizeOf(TGuid));
end;

constructor TQBytesCatHelper.Create(ASize: Integer);
begin
  inherited Create;
  FBlockSize := ASize;
  NeedSize(FBlockSize);
end;

function TQBytesCatHelper.Delete(AStart: Integer; ACount: Cardinal)
  : TQBytesCatHelper;
var
  ATotal: Integer;
  pDeleteStart, pDeleteEnd: PByte;
begin
  Result := Self;
  if AStart < 0 then // ����ɾ��ָ���ĸ���
  begin
    pDeleteStart := FDest;
    Inc(pDeleteStart, AStart);
    if IntPtr(pDeleteStart) < IntPtr(FStart) then
    begin
      Dec(ACount, IntPtr(FStart) - IntPtr(pDeleteStart));
      pDeleteStart := FStart;
    end;
  end
  else
  begin
    pDeleteStart := FStart;
    Inc(pDeleteStart, AStart);
    if IntPtr(pDeleteStart) >= IntPtr(FDest) then // û�п���ɾ��������
      Exit;
  end;
  pDeleteEnd := pDeleteStart;
  Inc(pDeleteEnd, ACount);
  if (IntPtr(pDeleteEnd) >= IntPtr(FDest)) or
    (IntPtr(pDeleteEnd) <= IntPtr(FStart)) then
    FDest := pDeleteStart
  else
  begin
    ATotal := IntPtr(FDest) - IntPtr(pDeleteEnd);
    Move(pDeleteEnd^, pDeleteStart^, ATotal);
    FDest := pDeleteStart;
    Inc(FDest, ATotal);
  end;
end;

constructor TQBytesCatHelper.Create;
begin
  inherited Create;
  FBlockSize := 8192;
  NeedSize(FBlockSize);
end;

function TQBytesCatHelper.GetBytes(AIndex: Integer): Byte;
begin
  Result := FValue[AIndex];
end;

function TQBytesCatHelper.GetPosition: Integer;
begin
  Result := IntPtr(FDest) - IntPtr(FStart);
end;

function TQBytesCatHelper.GetValue: TBytes;
var
  ALen: Integer;
begin
  ALen := Position;
  SetLength(Result, ALen);
  if ALen > 0 then
    Move(FValue[0], Result[0], ALen);
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Int64)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Int64));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Integer)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Integer));
end;
{$IFNDEF NEXTGEN}

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: AnsiString)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, PAnsiChar(V), Length(V));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: AnsiChar)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, 1);
end;
{$ENDIF}

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Cardinal)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Cardinal));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Shortint)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Shortint));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Byte)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, 1);
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Smallint)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Smallint));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Word)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Word));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: QStringA;
  ACStyle: Boolean): TQBytesCatHelper;
begin
  if ACStyle then
    Result := Insert(AIndex, PQCharA(V), V.Length + 1)
  else
    Result := Insert(AIndex, PQCharA(V), V.Length);
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Currency)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Currency));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Boolean)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(Boolean));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Variant)
  : TQBytesCatHelper;
begin
  // ??����һ���������ʵ�֣���ʱ����������ͷ��ո�
  Result := Insert(AIndex, @V, SizeOf(Variant));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: TGuid)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(V));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Double)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(V));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const S: QStringW)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, PQCharW(S), Length(S) shl 1);
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const c: QCharW)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @c, SizeOf(c));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const V: Single)
  : TQBytesCatHelper;
begin
  Result := Insert(AIndex, @V, SizeOf(V));
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const ABytes: TBytes)
  : TQBytesCatHelper;
begin
  if Length(ABytes) > 0 then
    Result := Insert(AIndex, @ABytes[0], Length(ABytes))
  else
    Result := Self;
end;

function TQBytesCatHelper.Insert(AIndex: Cardinal; const AData: Pointer;
  const ALen: Integer): TQBytesCatHelper;
begin
  if AIndex >= Cardinal(Position) then
    Result := Cat(AData, ALen)
  else
  begin
    NeedSize(-ALen);
    Move(PByte(UIntPtr(FStart) + AIndex)^,
      PByte(IntPtr(FStart) + ALen + Integer(AIndex))^, ALen);
    Move(AData^, PByte(UIntPtr(FStart) + AIndex)^, ALen);
    Inc(FDest, ALen);
    Result := Self;
  end;
end;

procedure TQBytesCatHelper.NeedSize(ASize: Integer);
var
  Offset: Integer;
begin
  Offset := IntPtr(FDest) - IntPtr(FStart);
  if ASize < 0 then
    ASize := Offset - ASize;
  if ASize > FSize then
  begin
    FSize := ((ASize + FBlockSize) div FBlockSize) * FBlockSize;
    SetLength(FValue, FSize);
    FStart := @FValue[0];
    FDest := PByte(IntPtr(FStart) + Offset);
  end;
end;

function TQBytesCatHelper.Replicate(const ABytes: TBytes; ACount: Integer)
  : TQBytesCatHelper;
var
  l: Integer;
begin
  Result := Self;
  l := Length(ABytes);
  if l > 0 then
  begin
    NeedSize(-l * ACount);
    while ACount > 0 do
    begin
      Move(ABytes[0], FDest^, l);
      Inc(FDest, l);
      Dec(ACount);
    end;
  end;
end;

procedure TQBytesCatHelper.Reset;
begin
  FDest := FStart;
end;

procedure TQBytesCatHelper.SetCapacity(const Value: Integer);
begin
  if FSize <> Value then
    NeedSize(Value);
end;

procedure TQBytesCatHelper.SetPosition(const Value: Integer);
begin
  if Value <= 0 then
    FDest := FStart
  else if Value > Length(FValue) then
  begin
    NeedSize(Value);
    FDest := Pointer(IntPtr(FStart) + Value);
  end
  else
    FDest := Pointer(IntPtr(FStart) + Value);
end;

function NewId: TGuid;
begin
  CreateGUID(Result);
end;

function SameId(const V1, V2: TGuid): Boolean;
var
  I1: array [0 .. 1] of Int64 absolute V1;
  I2: array [0 .. 1] of Int64 absolute V2;
begin
  Result := (I1[0] = I2[0]) and (I1[1] = I2[1]);
end;

function StrLikeX(var S: PQCharW; pat: PQCharW; AIgnoreCase: Boolean): PQCharW;
const
  CHAR_DIGITS = -1;
  CHAR_NODIGITS = -2;
  CHAR_SPACES = -3;
  CHAR_NOSPACES = -4;
var
  Accept: Boolean;
  ACharCode, AEndCode: Integer;
  AToken: QStringW;
  ps, pt, os: PQCharW;
  // >0 �������ַ�����
  // <0 ���ⷶΧ
  function Unescape(var T: PQCharW): Integer;
  begin
    if T^ = '\' then
    begin
      Inc(T);
      case T^ of
        'b':
          begin
            Inc(T);
            Result := 7;
          end;
        'd':
          begin
            Inc(T);
            Result := CHAR_DIGITS;
          end;
        'D':
          begin
            Inc(T);
            Result := CHAR_NODIGITS;
          end;
        'r':
          begin
            Inc(T);
            Result := 13;
          end;
        'n':
          begin
            Inc(T);
            Result := 10;
          end;
        't':
          begin
            Inc(T);
            Result := 9;
          end;
        'f': // \f
          begin
            Inc(T);
            Result := 12;
          end;
        'v': // \v
          begin
            Inc(T);
            Result := 11;
          end;
        's': // �հ��ַ�
          begin
            Inc(T);
            Result := CHAR_SPACES;
          end;
        'S': // �ǿհ�
          begin
            Inc(T);
            Result := CHAR_NOSPACES;
          end;
        'u': // Unicode�ַ�
          begin
            if IsHexChar(T[1]) and IsHexChar(T[2]) and IsHexChar(T[3]) and
              IsHexChar(T[4]) then
            begin
              Result := (HexValue(T[1]) shl 12) or (HexValue(T[2]) shl 8) or
                (HexValue(T[3]) shl 4) or HexValue(T[4]);
              Inc(T, 5);
            end
            else
              raise Exception.CreateFmt(SCharNeeded,
                ['0-9A-Fa-f', StrDupW(T, 0, 4)]);
          end
      else
        begin
          Inc(T);
          Result := Ord(S^);
        end;
      end;
    end
    else
    begin
      Result := Ord(T^);
    end
  end;

  function IsDigit: Boolean;
  begin
    Result := ((S^ >= '0') and (S^ <= '9')) or
      ((S^ >= #65296) and (S^ <= #65305));
  end;
  function IsMatch(AStart, AEnd: Integer): Boolean;
  var
    ACode: Integer;
  begin
    case AStart of
      CHAR_DIGITS:
        Result := IsDigit;
      CHAR_NODIGITS:
        Result := not IsDigit;
      CHAR_SPACES:
        Result := IsSpaceW(S);
      CHAR_NOSPACES:
        Result := not IsSpaceW(S)
    else
      begin
        ACode := Ord(S^);
        Result := (ACode >= AStart) and (ACode <= AEnd);
        if (not Result) and AIgnoreCase then
        begin
          ACode := Ord(CharUpperW(S^));
          AStart := Ord(CharUpperW(QCharW(AStart)));
          AEnd := Ord(CharUpperW(QCharW(AEnd)));
          Result := (ACode >= AStart) and (ACode <= AEnd);
        end;
        // �������չ���ַ�����Ҫ����������ת��
        if Result and ((ACode >= $D800) and (ACode <= $DFFF)) then
        begin
          Inc(S);
          if pat^ = '\' then
          begin
            ACode := Unescape(pat);
            Result := Ord(S^) = ACode;
          end
          else
            Result := false;
        end;
      end;
    end;
  end;

  function IsIn: Boolean;
  const
    SetEndChar: PQCharW = ']';
  begin
    Result := false;
    while (pat^ <> #0) and (pat^ <> ']') do
    begin
      ACharCode := Unescape(pat);
      if pat^ = '-' then // a-z���ַ�Χ
      begin
        Inc(pat);
        if pat^ <> ']' then
          AEndCode := Unescape(pat)
        else
        begin
          raise Exception.Create(SRangeEndNeeded);
        end;
      end
      else
        AEndCode := ACharCode;
      Result := IsMatch(ACharCode, AEndCode);
      if Result then // �����еĻ������Ե�������ж�
      begin
        Inc(S);
        SkipUntilW(pat, SetEndChar);
        if pat^ <> ']' then
          raise Exception.CreateFmt(SCharNeeded, [']']);
      end
      else
        Inc(pat);
    end;
  end;

begin
  // SQL Like �﷨��
  // _ ����һ���ַ�
  // % * ���������ַ�
  // [�ַ��б�] �б��������ַ�
  // [^�ַ��б�]/[!�ַ��б�] ���б��������ַ�
  // ����ΪQDAC��չ
  // \ ת��
  // \d ���֣�ȫ�ǺͰ�ǣ�
  // \D �����֣���ȫ�ǣ�
  // \s �հ��ַ�
  // \S �ǿհ��ַ�
  os := S;
  Result := nil;
  while (pat^ <> #0) and (S^ <> #0) do
  begin
    case pat^ of
      '_':
        begin
          Inc(S, CharSizeW(S));
          Inc(pat);
        end;
      '[': // �ַ��б�
        begin
          Inc(pat);
          if (pat^ = '!') or (pat^ = '^') then
          begin
            Inc(pat);
            Accept := not IsIn;
          end
          else
            Accept := IsIn;
          if pat^ = ']' then
          begin
            Inc(pat);
          end;
          if not Accept then
            Exit;
        end;
      '\':
        begin
          ACharCode := Unescape(pat);
          if not IsMatch(ACharCode, ACharCode) then
            Exit
          else
            Inc(S);
        end;
      '*', '%':
        begin
          Inc(pat);
          // ƥ�����ⳤ�ȵ������ַ�
          if pat^ = #0 then
          begin
            Result := os;
            while S^ <> #0 do
              Inc(S);
            Exit;
          end
          else
          begin
            // ���������*��%����Ϊ
            while (pat^ = '%') or (pat^ = '*') do
              Inc(pat);
            ps := pat;
            // �ҵ���һ������ƥ�����߽�
            while (pat^ <> #0) and (pat^ <> '*') do
              Inc(pat);
            // ƥ���Ӵ���ʣ�ಿ��
            AToken := StrDupX(ps, (IntPtr(pat) - IntPtr(ps)) shr 1);
            repeat
              pt := S;
              ps := StrLikeX(S, PQCharW(AToken), AIgnoreCase);
              if ps <> nil then
              begin
                if (pat^ <> #0) and (StrLikeX(S, pat, AIgnoreCase) = nil) then
                begin
                  Inc(pt);
                  S := pt;
                end
                else
                begin
                  Result := os;
                  while S^ <> #0 do
                    Inc(S);
                  Exit;
                end;
              end
              else
              begin
                Inc(pt);
                S := pt;
              end;
            until (S^ = #0);
            // �������û��ƥ�䵽��˵��ʧ����
            Exit;
          end;
        end
    else // ��ͨ�ַ��ıȽ�
      begin
        if not IsMatch(Ord(pat^), Ord(pat^)) then
          Exit;
        Inc(S);
        Inc(pat);
      end;
    end;
  end;
  if (pat^ = '%') or (pat^ = '*') then // ģʽƥ��
    Inc(pat);
  if pat^ = #0 then
    Result := os;
end;

function StrLikeW(S, pat: PQCharW; AIgnoreCase: Boolean): Boolean;
var
  ps: PQCharW;
begin
  ps := S;
  Result := (StrLikeX(S, pat, AIgnoreCase) = ps) and (S^ = #0);
end;

{ TQPagedList }

function TQPagedList.Add(const p: Pointer): Integer;
begin
  Result := FCount;
  Insert(Result, p);
end;
{$IF RTLVersion<26}

procedure TQPagedList.Assign(ListA: TList; AOperator: TListAssignOp;
  ListB: TList);
var
  I: Integer;
  LTemp: TQPagedList;
  LSource: TList;
begin
  // ListB given?
  if ListB <> nil then
  begin
    LSource := ListB;
    Assign(ListA);
  end
  else
    LSource := ListA;

  // on with the show
  case AOperator of

    // 12345, 346 = 346 : only those in the new list
    laCopy:
      begin
        Clear;
        for I := 0 to LSource.count - 1 do
          Add(LSource[I]);
      end;

    // 12345, 346 = 34 : intersection of the two lists
    laAnd:
      for I := count - 1 downto 0 do
        if LSource.IndexOf(Items[I]) = -1 then
          Delete(I);

    // 12345, 346 = 123456 : union of the two lists
    laOr:
      for I := 0 to LSource.count - 1 do
        if IndexOf(LSource[I]) = -1 then
          Add(LSource[I]);

    // 12345, 346 = 1256 : only those not in both lists
    laXor:
      begin
        LTemp := TQPagedList.Create; // Temp holder of 4 byte values
        try
          for I := 0 to LSource.count - 1 do
            if IndexOf(LSource[I]) = -1 then
              LTemp.Add(LSource[I]);
          for I := count - 1 downto 0 do
            if LSource.IndexOf(Items[I]) <> -1 then
              Delete(I);
          I := count + LTemp.count;
          if Capacity < I then
            Capacity := I;
          for I := 0 to LTemp.count - 1 do
            Add(LTemp[I]);
        finally
          LTemp.Free;
        end;
      end;

    // 12345, 346 = 125 : only those unique to source
    laSrcUnique:
      for I := count - 1 downto 0 do
        if LSource.IndexOf(Items[I]) <> -1 then
          Delete(I);

    // 12345, 346 = 6 : only those unique to dest
    laDestUnique:
      begin
        LTemp := TQPagedList.Create;
        try
          for I := LSource.count - 1 downto 0 do
            if IndexOf(LSource[I]) = -1 then
              LTemp.Add(LSource[I]);
          Assign(LTemp);
        finally
          LTemp.Free;
        end;
      end;
  end;
end;
{$IFEND}

procedure TQPagedList.BatchAdd(pp: PPointer; ACount: Integer);
begin
  BatchInsert(FCount, pp, ACount);
end;

procedure TQPagedList.BatchAdd(AList: TPointerList);
begin
  if Length(AList) > 0 then
    BatchInsert(FCount, @AList[0], Length(AList));
end;

procedure TQPagedList.Assign(ListA: TQPagedList; AOperator: TListAssignOp;
  ListB: TQPagedList);
var
  I: Integer;
  LTemp, LSource: TQPagedList;
begin
  // ListB given?
  if ListB <> nil then
  begin
    LSource := ListB;
    Assign(ListA);
  end
  else
    LSource := ListA;
  case AOperator of
    // 12345, 346 = 346 : only those in the new list
    laCopy:
      begin
        Clear;
        for I := 0 to LSource.count - 1 do
          Add(LSource[I]);
      end;
    // 12345, 346 = 34 : intersection of the two lists
    laAnd:
      for I := count - 1 downto 0 do
        if LSource.IndexOf(Items[I]) = -1 then
          Delete(I);
    // 12345, 346 = 123456 : union of the two lists
    laOr:
      for I := 0 to LSource.count - 1 do
        if IndexOf(LSource[I]) = -1 then
          Add(LSource[I]);
    // 12345, 346 = 1256 : only those not in both lists
    laXor:
      begin
        LTemp := TQPagedList.Create; // Temp holder of 4 byte values
        try
          for I := 0 to LSource.count - 1 do
            if IndexOf(LSource[I]) = -1 then
              LTemp.Add(LSource[I]);
          for I := count - 1 downto 0 do
            if LSource.IndexOf(Items[I]) <> -1 then
              Delete(I);
          I := count + LTemp.count;
          if Capacity < I then
            Capacity := I;
          for I := 0 to LTemp.count - 1 do
            Add(LTemp[I]);
        finally
          LTemp.Free;
        end;
      end;

    // 12345, 346 = 125 : only those unique to source
    laSrcUnique:
      for I := count - 1 downto 0 do
        if LSource.IndexOf(Items[I]) <> -1 then
          Delete(I);

    // 12345, 346 = 6 : only those unique to dest
    laDestUnique:
      begin
        LTemp := TQPagedList.Create;
        try
          for I := LSource.count - 1 downto 0 do
            if IndexOf(LSource[I]) = -1 then
              LTemp.Add(LSource[I]);
          Assign(LTemp);
        finally
          LTemp.Free;
        end;
      end;
  end;
end;

procedure TQPagedList.CheckLastPage;
begin
  while (FLastUsedPage > 0) and (FPages[FLastUsedPage].FUsedCount = 0) do
    Dec(FLastUsedPage);
end;

procedure TQPagedList.Clear;
var
  I: Integer;
  J: Integer;
begin
  for I := 0 to High(FPages) do
  begin
    for J := 0 to FPages[I].FUsedCount - 1 do
      DoDelete(FPages[I].FItems[J]);
    FPages[I].FUsedCount := 0;
  end;
  FFirstDirtyPage := 1;
  if Length(FPages) > 0 then
  begin
    FLastUsedPage := 0;
    FPages[0].FUsedCount := 0;
  end
  else
    FLastUsedPage := -1;
  FCount := 0;
end;

procedure TQPagedList.Pack;
var
  ASource, ADest, AStartMove, AToMove, APageCount: Integer;
  ADestPage, ASourcePage: TQListPage;
  procedure PackPages(AStartPage: Integer);
  var
    I: Integer;
  begin
    if AStartPage < APageCount then
    begin
      I := AStartPage;
      while I < APageCount do
      begin
        FreeAndNil(FPages[I]);
        Inc(I);
      end;
      SetLength(FPages, AStartPage);
      FLastUsedPage := AStartPage - 1;
      FFirstDirtyPage := AStartPage + 1;
    end;
  end;

  procedure NextDest;
  var
    APriorPage: TQListPage;
    ANewDest: Integer;
  begin
    ANewDest := ADest;
    repeat
      ADestPage := FPages[ANewDest];
      if ADestPage.FUsedCount = FPageSize then
        Inc(ANewDest)
      else
      begin
        if (ADest <> ANewDest) then
        begin
          ADest := ANewDest;
          if ASource <> ADest then
          begin
            APriorPage := FPages[ADest - 1];
            ADestPage.FStartIndex := APriorPage.FStartIndex +
              APriorPage.FUsedCount;
          end;
        end;
        Break;
      end;
    until ADest = ASource;
  end;

  function NextSource: Boolean;
  begin
    Inc(ASource);
    Result := false;
    while ASource <= FLastUsedPage do
    begin
      ASourcePage := FPages[ASource];
      if (ASourcePage.FUsedCount > 0) then
      begin
        Result := True;
        Break;
      end
      else
        Inc(ASource);
    end;
  end;

  procedure CleanPages;
  var
    I: Integer;
  begin
    I := FFirstDirtyPage;
    while I < APageCount do
    begin
      FPages[I].FStartIndex := FPages[I - 1].FStartIndex + FPages[I - 1]
        .FUsedCount;
      Inc(I);
    end;
  end;

begin
  APageCount := Length(FPages);
  if count > 0 then
  begin
    ADest := 0;
    ASource := 0;
    CleanPages;
    while NextSource do
    begin
      AStartMove := 0;
      NextDest;
      if ADestPage <> ASourcePage then
      begin
        while (ADestPage <> ASourcePage) do
        begin
          AToMove := ASourcePage.FUsedCount - AStartMove;
          if AToMove > FPageSize - ADestPage.FUsedCount then
            AToMove := FPageSize - ADestPage.FUsedCount;
          System.Move(ASourcePage.FItems[AStartMove],
            ADestPage.FItems[ADestPage.FUsedCount], AToMove * SizeOf(Pointer));
          Inc(AStartMove, AToMove);
          Inc(ADestPage.FUsedCount, AToMove);
          if ASourcePage.FUsedCount = AStartMove then
          begin
            ASourcePage.FStartIndex := ADestPage.FStartIndex +
              ADestPage.FUsedCount;
            ASourcePage.FUsedCount := 0;
            Break;
          end;
          if ADestPage.FUsedCount = FPageSize then
          begin
            System.Move(ASourcePage.FItems[AStartMove], ASourcePage.FItems[0],
              (ASourcePage.FUsedCount - AStartMove) * SizeOf(Pointer));
            Dec(ASourcePage.FUsedCount, AStartMove);
            Inc(ASourcePage.FStartIndex, AStartMove);
            AStartMove := 0;
            NextDest;
          end;
        end;
      end;
    end;
    if ADestPage.FUsedCount = 0 then
      PackPages(ADest)
    else
      PackPages(ADest + 1);
  end
  else
    PackPages(0);
end;

constructor TQPagedList.Create(APageSize: Integer);
begin
  inherited Create;
  if APageSize <= 0 then
    APageSize := 512;
  FPageSize := APageSize;
  FLastUsedPage := -1;
  FFirstDirtyPage := 1;
end;

constructor TQPagedList.Create;
begin
  Create(512);
end;

procedure TQPagedList.Delete(AIndex: Integer);
var
  APage: Integer;
  ATemp: TQListPage;
begin
  APage := FindPage(AIndex);
  if APage >= 0 then
  begin
    ATemp := FPages[APage];
    Dec(AIndex, ATemp.FStartIndex);
    DoDelete(ATemp.FItems[AIndex]);
    System.Move(ATemp.FItems[AIndex + 1], ATemp.FItems[AIndex],
      SizeOf(Pointer) * (ATemp.FUsedCount - AIndex - 1));
    Dec(ATemp.FUsedCount);
    CheckLastPage;
    Dec(FCount);
    Dirty(APage + 1);
  end;
end;

destructor TQPagedList.Destroy;
var
  I: Integer;
begin
  Clear;
  for I := 0 to High(FPages) do
    FreeObject(FPages[I]);
{$IFDEF UNICODE}
  if (TMethod(FOnCompare).Code <> nil) and
    (TMethod(FOnCompare).Data = Pointer(-1)) then
    TQPagedListSortCompareA(TMethod(FOnCompare).Code) := nil;
{$ENDIF}
  inherited;
end;

procedure TQPagedList.Dirty(APage: Integer);
begin
  if APage < FFirstDirtyPage then
    FFirstDirtyPage := APage;
end;

function TQPagedList.DoCompare(p1, p2: Pointer): Integer;
begin
  case IntPtr(TMethod(FOnCompare).Data) of
    0: // ȫ�ֺ���
      TQPagedListSortCompareG(TMethod(FOnCompare).Code)(p1, p2, Result);
{$IFDEF UNICODE}
    -1: // ��������
      TQPagedListSortCompareA(TMethod(FOnCompare).Code)(p1, p2, Result)
{$ENDIF}
  else
    FOnCompare(p1, p2, Result);
  end;
end;

procedure TQPagedList.DoDelete(const p: Pointer);
begin
  if (p <> nil) and (ClassType <> TQPagedList) then
    Notify(p, lnDeleted);
end;

procedure TQPagedList.Exchange(AIndex1, AIndex2: Integer);
var
  p1, p2: TQListPage;
  T: Pointer;
begin
  p1 := GetPage(AIndex1);
  p2 := GetPage(AIndex2);
  if (p1 <> nil) and (p2 <> nil) then
  begin
    Dec(AIndex1, p1.FStartIndex);
    Dec(AIndex2, p2.FStartIndex);
    T := p1.FItems[AIndex1];
    p1.FItems[AIndex1] := p2.FItems[AIndex2];
    p2.FItems[AIndex2] := T;
  end;
end;

function TQPagedList.Expand: TQPagedList;
begin
  // �������ֻ��Ϊ����TList�ӿڱ�����TQPagedList����Ҫ
  Result := Self;
end;

function TQPagedList.Extract(Item: Pointer): Pointer;
begin
  Result := ExtractItem(Item, FromBeginning);
end;

function TQPagedList.ExtractItem(Item: Pointer; Direction: TDirection): Pointer;
var
  I: Integer;
begin
  Result := nil;
  I := IndexOfItem(Item, Direction);
  if I >= 0 then
  begin
    Result := Item;
    Remove(I);
    if ClassType <> TQPagedList then
      Notify(Result, lnExtracted);
  end;
end;

function TQPagedList.Find(const p: Pointer; var AIdx: Integer): Boolean;
var
  l, H, I, c: Integer;
begin
  Result := false;
  l := 0;
  H := FCount - 1;
  while l <= H do
  begin
    I := (l + H) shr 1;
    c := DoCompare(Items[I], p);
    if c < 0 then
      l := I + 1
    else
    begin
      H := I - 1;
      if c = 0 then
        Result := True;
    end;
  end;
  AIdx := l;
end;

function TQPagedList.FindPage(AIndex: Integer): Integer;
var
  l, H, I, AMax, c: Integer;
  ATemp: TQListPage;
begin
  c := Length(FPages);
  ATemp := FPages[FFirstDirtyPage - 1];
  if (FFirstDirtyPage < c) and (AIndex >= ATemp.FStartIndex + ATemp.FUsedCount)
  then
  begin
    I := FFirstDirtyPage;
    while I < c do
    begin
      ATemp := FPages[I - 1];
      FPages[I].FStartIndex := ATemp.FStartIndex + ATemp.FUsedCount;
      if FPages[I].FStartIndex > AIndex then
      begin
        Result := I - 1;
        FFirstDirtyPage := I + 1;
        Exit;
      end
      else if FPages[I].FStartIndex = AIndex then
      begin
        Result := I;
        FFirstDirtyPage := I + 1;
        Exit;
      end;
      Inc(I);
    end;
    H := c - 1;
  end
  else
    H := FFirstDirtyPage - 1;
  l := AIndex div FPageSize;
  while l <= H do
  begin
    I := (l + H) shr 1;
    ATemp := FPages[I];
    AMax := ATemp.FStartIndex + ATemp.FUsedCount - 1; // ����������
    if AIndex > AMax then
      l := I + 1
    else
    begin
      H := I - 1;
      if (AIndex >= ATemp.FStartIndex) and (AIndex <= AMax) then
      begin
        Result := I;
        Exit;
      end;
    end;
  end;
  Result := -1;
end;

function TQPagedList.First: Pointer;
begin
  Result := Items[0];
end;

function TQPagedList.GetCapacity: Integer;
begin
  Result := Length(FPages) * FPageSize;
end;

function TQPagedList.GetEnumerator: TQPagedListEnumerator;
begin
  Result := TQPagedListEnumerator.Create(Self);
end;

function TQPagedList.GetItems(AIndex: Integer): Pointer;
var
  APage: TQListPage;
begin
  APage := GetPage(AIndex);
  if APage <> nil then
  begin
    Dec(AIndex, APage.FStartIndex);
    Result := APage.FItems[AIndex];
  end
  else
    raise Exception.Create('����Խ��:' + IntToStr(AIndex));
end;

function TQPagedList.GetList: TPointerList;
var
  I, K: Integer;
  APage: TQListPage;
begin
  SetLength(Result, count);
  K := 0;
  for I := 0 to High(FPages) do
  begin
    APage := FPages[I];
    if APage.FUsedCount > 0 then
    begin
      System.Move(APage.FItems[0], Result[K],
        APage.FUsedCount * SizeOf(Pointer));
      Inc(K, APage.FUsedCount);
    end;
  end;
end;

function TQPagedList.GetPage(AIndex: Integer): TQListPage;
var
  l, H, I, AMax, c: Integer;
  ATemp: TQListPage;
begin
  Result := nil;
  c := Length(FPages);
  ATemp := FPages[FFirstDirtyPage - 1];
  if (FFirstDirtyPage < c) and (AIndex >= ATemp.FStartIndex + ATemp.FUsedCount)
  then
  begin
    I := FFirstDirtyPage;
    while I < c do
    begin
      ATemp := FPages[I - 1];
      FPages[I].FStartIndex := ATemp.FStartIndex + ATemp.FUsedCount;
      if FPages[I].FStartIndex > AIndex then
      begin
        Result := ATemp;
        FFirstDirtyPage := I + 1;
        Exit;
      end
      else if FPages[I].FStartIndex = AIndex then
      begin
        Result := FPages[I];
        FFirstDirtyPage := I + 1;
        Exit;
      end;
      Inc(I);
    end;
    H := c - 1;
  end
  else
    H := FFirstDirtyPage - 1;
  // ��������˵������ÿҳ���������������λ��ΪAIndex div Page
  l := AIndex div FPageSize;
  while l <= H do
  begin
    I := (l + H) shr 1;
    ATemp := FPages[I];
    AMax := ATemp.FStartIndex + ATemp.FUsedCount - 1;
    // ����������
    if AIndex > AMax then
      l := I + 1
    else
    begin
      H := I - 1;
      if (AIndex >= ATemp.FStartIndex) and (AIndex <= AMax) then
      begin
        Result := ATemp;
        Exit;
      end;
    end;
  end;
end;

function TQPagedList.GetPageCount: Integer;
begin
  Result := Length(FPages);
end;

function TQPagedList.IndexOf(Item: Pointer): Integer;
var
  I, J: Integer;
begin
  if TMethod(FOnCompare).Code <> nil then
  begin
    if not Find(Item, Result) then
      Result := -1;
  end
  else
  begin
    Result := -1;
    for I := 0 to High(FPages) do
    begin
      for J := 0 to FPages[I].FUsedCount do
      begin
        if FPages[I].FItems[J] = Item then
        begin
          Result := FPages[I].FStartIndex + J;
          Exit;
        end;
      end;
    end;
  end;
end;

function TQPagedList.IndexOfItem(Item: Pointer; Direction: TDirection): Integer;
var
  I, J: Integer;
begin
  if Direction = FromBeginning then
    Result := IndexOf(Item)
  else
  begin
    Result := -1;
    for I := High(FPages) downto 0 do
    begin
      for J := FPages[I].FUsedCount - 1 downto 0 do
      begin
        if FPages[I].FItems[J] = Item then
        begin
          Result := FPages[I].FStartIndex + J;
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TQPagedList.BatchInsert(AIndex: Integer; pp: PPointer;
  ACount: Integer);
var
  APage, ANeedPages, APageCount, AOffset, ARemain, AToMove: Integer;
  ASourcePage, ADestPage: TQListPage;
  ASplitNeeded: Boolean;
  procedure SplitPage;
  begin
    ADestPage := FPages[APage];
    ADestPage.FStartIndex := ASourcePage.FStartIndex;
    ADestPage.FUsedCount := AIndex - ASourcePage.FStartIndex;
    System.Move(ASourcePage.FItems[0], ADestPage.FItems[0],
      ADestPage.FUsedCount * SizeOf(Pointer));
    Dec(ASourcePage.FUsedCount, ADestPage.FUsedCount);
    System.Move(ASourcePage.FItems[ADestPage.FUsedCount], ASourcePage.FItems[0],
      ASourcePage.FUsedCount * SizeOf(Pointer));
    Inc(APage);
    Dec(ANeedPages);
  end;
  procedure NewPages;
  var
    ATempList: TPointerList;
    AEmptyPages: Integer;
  begin
    APageCount := Length(FPages);
    // ������Ҫ��ҳ��
    ANeedPages := ACount div FPageSize;
    if (ACount mod FPageSize) <> 0 then
      Inc(ANeedPages);
    AEmptyPages := APageCount;
    if FLastUsedPage >= 0 then
    begin
      if FPages[FLastUsedPage].FUsedCount = 0 then
        Dec(FLastUsedPage);
      Dec(AEmptyPages, FLastUsedPage + 1);
    end;
    if AIndex = 0 then
      APage := 0
    else if AIndex = FCount then
      APage := FLastUsedPage + 1
    else
    begin
      APage := FindPage(AIndex);
      ASourcePage := FPages[APage];
      ASplitNeeded := AIndex > ASourcePage.FStartIndex;
      if ASplitNeeded then
        // ��������λ����ҳ�м䣬��Ҫ����һҳ������ǰ���Ԫ��
        Inc(ANeedPages);
    end;
    if AEmptyPages >= ANeedPages then // ���е�ҳ�㹻�Ļ�
    begin
      if FCount = 0 then // û���κμ�¼����ʱAIndex=0,ֱ��Ԥ��ҳ�Ϳ�����
      begin
        FLastUsedPage := ANeedPages - 1;
        FFirstDirtyPage := ANeedPages;
      end
      else
      begin
        SetLength(ATempList, ANeedPages);
        System.Move(ATempList[0], FPages[APage], ANeedPages * SizeOf(Pointer));
        System.Move(FPages[APage], FPages[APage + ANeedPages],
          (FLastUsedPage - APage + 1) * SizeOf(Pointer));
        System.Move(ATempList[0], FPages[APage], ANeedPages * SizeOf(Pointer));
        if ASplitNeeded then
          SplitPage;
        Inc(FLastUsedPage, ANeedPages);
      end;
      Exit;
    end
    else // ����ҳ����
    begin
      SetLength(FPages, APageCount + ANeedPages - AEmptyPages);
      if FLastUsedPage >= APage then
      begin
        SetLength(ATempList, AEmptyPages);
        if AEmptyPages > 0 then
          System.Move(FPages[FLastUsedPage + 1], ATempList[0],
            AEmptyPages * SizeOf(Pointer));
        System.Move(FPages[APage], FPages[APage + ANeedPages],
          (FLastUsedPage - APage + 1) * SizeOf(Pointer));
        if AEmptyPages > 0 then
          System.Move(ATempList[0], FPages[APage],
            AEmptyPages * SizeOf(Pointer));
      end;
      AOffset := APage + AEmptyPages;
      AToMove := ANeedPages - AEmptyPages;
      while AToMove > 0 do
      begin
        FPages[AOffset] := TQListPage.Create(FPageSize);
        Inc(AOffset);
        Dec(AToMove);
      end;
      if ASplitNeeded then
        SplitPage;
      FLastUsedPage := High(FPages);
    end;
  end;

begin
  if AIndex < 0 then
    AIndex := 0
  else if AIndex > FCount then
    AIndex := FCount;
  NewPages;
  ARemain := ACount;
  while ARemain > 0 do
  begin
    ADestPage := FPages[APage];
    ADestPage.FStartIndex := AIndex;
    AToMove := ARemain;
    if AToMove >= FPageSize then
      AToMove := FPageSize;
    System.Move(pp^, ADestPage.FItems[0], AToMove * SizeOf(Pointer));
    ADestPage.FUsedCount := AToMove;
    Inc(pp, AToMove);
    Inc(AIndex, AToMove);
    Dec(ARemain, AToMove);
    Inc(APage);
  end;
  Inc(FCount, ACount);
  Dirty(APage + ANeedPages);
end;

procedure TQPagedList.BatchInsert(AIndex: Integer; const AList: TPointerList);
begin
  if Length(AList) > 0 then
    BatchInsert(AIndex, @AList[0], Length(AList));
end;

procedure TQPagedList.Insert(AIndex: Integer; const p: Pointer);
var
  APage, ANewPage, AMoved: Integer;
  ADestPage, ATemp: TQListPage;
begin
  if AIndex < 0 then
    AIndex := 0;
  if TMethod(FOnCompare).Code <> nil then
    Find(p, AIndex);
  if AIndex >= count then // ����ĩβ
  begin
    APage := FLastUsedPage;
    if (APage < 0) or (FPages[APage].FUsedCount = FPageSize) then
    begin
      Inc(APage);
      if APage >= Length(FPages) then
      begin
        SetLength(FPages, Length(FPages) + 1);
        ADestPage := TQListPage.Create(FPageSize);
        ADestPage.FStartIndex := count;
        FPages[APage] := ADestPage;
      end
      else
        ADestPage := FPages[APage];
      Inc(FLastUsedPage);
      if APage = 0 then
        FFirstDirtyPage := 1;
    end
    else
      ADestPage := FPages[APage];
    ADestPage.FItems[ADestPage.FUsedCount] := p;
    Inc(ADestPage.FUsedCount);
  end
  else if AIndex <= 0 then // ������ǰ��
  begin
    ADestPage := FPages[0];
    if ADestPage.FUsedCount < FPageSize then
    begin
      System.Move(ADestPage.FItems[0], ADestPage.FItems[1],
        ADestPage.FUsedCount * SizeOf(Pointer));
      ADestPage.FItems[0] := p;
      Inc(ADestPage.FUsedCount);
    end
    else // ��ǰҳ���ˣ���Ҫ������ҳ
    begin
      if FLastUsedPage < High(FPages) then
      begin
        Inc(FLastUsedPage);
        ADestPage := FPages[FLastUsedPage];
        System.Move(FPages[0], FPages[1], SizeOf(TQListPage) * FLastUsedPage);
        FPages[0] := ADestPage;
        ADestPage.FStartIndex := 0;
      end
      else
      begin
        ANewPage := Length(FPages);
        SetLength(FPages, ANewPage + 1);
        FLastUsedPage := ANewPage;
        System.Move(FPages[0], FPages[1], SizeOf(TQListPage) * FLastUsedPage);
        FPages[0] := TQListPage.Create(FPageSize);
        ADestPage := FPages[0];
      end;
      ADestPage.FUsedCount := 1;
      ADestPage.FItems[0] := p;
    end;
    Dirty(1);
  end
  else
  // �����м�
  begin
    APage := FindPage(AIndex);
    ADestPage := FPages[APage];
    if (ADestPage.FUsedCount = FPageSize) then // Ŀ��ҳ����
    begin
      ANewPage := APage + 1;
      if (FLastUsedPage = APage) or (FPages[ANewPage].FUsedCount = FPageSize)
      then
      // ��һҳҲ����
      begin
        Inc(FLastUsedPage);
        if FLastUsedPage = Length(FPages) then
        begin
          SetLength(FPages, FLastUsedPage + 1);
          System.Move(FPages[ANewPage], FPages[ANewPage + 1],
            SizeOf(TQListPage) * (FLastUsedPage - ANewPage));
          ATemp := TQListPage.Create(FPageSize);;
          FPages[ANewPage] := ATemp;
        end
        else if ANewPage = FLastUsedPage then
          ATemp := FPages[ANewPage]
        else
        begin
          ATemp := FPages[FLastUsedPage];
          System.Move(FPages[ANewPage], FPages[ANewPage + 1],
            SizeOf(TQListPage) * (FLastUsedPage - ANewPage));
          FPages[ANewPage] := ATemp;
        end;
        ATemp.FStartIndex := AIndex + 1;
        Dec(AIndex, ADestPage.FStartIndex);
        AMoved := ADestPage.FUsedCount - AIndex;
        System.Move(ADestPage.FItems[AIndex], ATemp.FItems[0],
          AMoved * SizeOf(Pointer));
        Dec(ADestPage.FUsedCount, AMoved - 1);
        ATemp.FUsedCount := AMoved;
        ADestPage.FItems[AIndex] := p;
        Dirty(ANewPage + 1);
      end
      else // ����ǰҳ������������һҳ
      begin
        ATemp := FPages[ANewPage];
        System.Move(ATemp.FItems[0], ATemp.FItems[1],
          ATemp.FUsedCount * SizeOf(Pointer));
        ATemp.FItems[0] := ADestPage.FItems[FPageSize - 1];
        Inc(ATemp.FUsedCount);
        Dirty(ANewPage);
        Dec(AIndex, ADestPage.FStartIndex);
        AMoved := ADestPage.FUsedCount - AIndex - 1;
        System.Move(ADestPage.FItems[AIndex], ADestPage.FItems[AIndex + 1],
          AMoved * SizeOf(Pointer));
        ADestPage.FItems[AIndex] := p;
      end;
    end
    else
    begin
      Dec(AIndex, ADestPage.FStartIndex);
      if AIndex < ADestPage.FUsedCount then
      begin
        AMoved := (ADestPage.FUsedCount - AIndex);
        System.Move(ADestPage.FItems[AIndex], ADestPage.FItems[AIndex + 1],
          AMoved * SizeOf(TQListPage));
      end;
      ADestPage.FItems[AIndex] := p;
      Inc(ADestPage.FUsedCount);
      Dirty(APage + 1);
    end;
  end;
  Inc(FCount);
  if (p <> nil) and (ClassType <> TQPagedList) then
    Notify(p, lnAdded);
end;

function TQPagedList.Last: Pointer;
begin
  Result := Items[count - 1];
end;

procedure TQPagedList.Move(AFrom, ATo: Integer);
begin
  MoveTo(AFrom, ATo);
end;

procedure TQPagedList.MoveTo(AFrom, ATo: Integer);
var
  ATemp: Pointer;
begin
  if AFrom <> ATo then
  begin
    ATemp := Items[AFrom];
    Remove(AFrom);
    Insert(ATo, ATemp);
  end;
end;

procedure TQPagedList.Notify(Ptr: Pointer; Action: TListNotification);
begin

end;

function TQPagedList.Remove(Item: Pointer): Integer;
begin
  Result := RemoveItem(Item, FromBeginning);
end;

procedure TQPagedList.Remove(AIndex: Integer);
var
  APage: Integer;
begin
  APage := FindPage(AIndex);
  if APage >= 0 then
  begin
    Dec(AIndex, FPages[APage].FStartIndex);
    System.Move(FPages[APage].FItems[AIndex + 1], FPages[APage].FItems[AIndex],
      SizeOf(Pointer) * (FPages[APage].FUsedCount - AIndex - 1));
    Dec(FPages[APage].FUsedCount);
    CheckLastPage;
    Assert(FPages[APage].FUsedCount >= 0);
    Dirty(APage + 1);
  end;
end;
{$IFDEF UNICODE}

procedure TQPagedList.Sort(AOnCompare: TQPagedListSortCompareA);
begin
  TMethod(FOnCompare).Code := nil;
  PQPagedListSortCompareA(@TMethod(FOnCompare).Code)^ := AOnCompare;
  TMethod(FOnCompare).Data := Pointer(-1);
  Sort;
end;
{$ENDIF}

procedure TQPagedList.SetCapacity(const Value: Integer);
begin
  // ��Ϊ���ݱ�����ʵ�ʲ����κ�����
end;

procedure TQPagedList.SetItems(AIndex: Integer; const Value: Pointer);
var
  APage: TQListPage;
begin
  APage := GetPage(AIndex);
  if APage <> nil then
  begin
    Dec(AIndex, APage.FStartIndex);
    APage.FItems[AIndex] := Value;
  end
  else
    raise Exception.Create('����Խ��:' + IntToStr(AIndex));
end;

procedure TQPagedList.SetOnCompare(const Value: TQPagedListSortCompare);
begin
  if (TMethod(FOnCompare).Code <> TMethod(Value).Code) or
    (TMethod(FOnCompare).Data <> TMethod(Value).Data) then
  begin
    FOnCompare := Value;
    if Assigned(Value) then
      Sort;
  end;
end;

procedure TQPagedList.Sort(AOnCompare: TQPagedListSortCompareG);
begin
  TMethod(FOnCompare).Code := @AOnCompare;
  TMethod(FOnCompare).Data := nil;
  Sort;
end;

procedure TQPagedList.Sort;
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
            Exchange(I, J);
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

begin
  if TMethod(FOnCompare).Code = nil then
    raise Exception.Create('δָ���������');
  if count > 0 then
    QuickSort(0, count - 1);
end;

function TQPagedList.RemoveItem(Item: Pointer; Direction: TDirection): Integer;
begin
  Result := IndexOfItem(Item, Direction);
  if Result > 0 then
    Remove(Result);
end;

{ TQListPage }

constructor TQListPage.Create(APageSize: Integer);
begin
  SetLength(FItems, APageSize);
  // OutputDebugString(PChar(IntToHex(IntPtr(Self), 8) + ' Created'));
end;

destructor TQListPage.Destroy;
begin
  // OutputDebugString(PChar(IntToHex(IntPtr(Self), 8) + ' Freed'));
  inherited;
end;

{ TQPagedListEnumerator }

constructor TQPagedListEnumerator.Create(AList: TQPagedList);
begin
  inherited Create;
  FList := AList;
  FIndex := -1;
end;

function TQPagedListEnumerator.GetCurrent: Pointer;
begin
  Result := FList[FIndex];
end;

function TQPagedListEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.count - 1;
  if Result then
    Inc(FIndex);
end;

{ TQPagedStream }
constructor TQPagedStream.Create;
begin
  Create(8192);
end;

function TQPagedStream.ActiveOffset: Integer;
begin
  Result := FPosition mod FPageSize;
end;

function TQPagedStream.ActivePage: Integer;
begin
  Result := FPosition div FPageSize;
end;

procedure TQPagedStream.Clear;
var
  I: Integer;
begin
  for I := 0 to High(FPages) do
    FreeMem(FPages[I]);
  SetLength(FPages, 0);
  FSize := 0;
  FPosition := 0;
end;

constructor TQPagedStream.Create(APageSize: Integer);
begin
  inherited Create;
  if APageSize <= 0 then
    APageSize := 8192;
  FPageSize := APageSize;
end;

destructor TQPagedStream.Destroy;
begin
  Clear;
  inherited;
end;

function TQPagedStream.GetAsBytes: TBytes;
begin
  if Size > 0 then
  begin
    SetLength(Result, FSize);
    FPosition := 0;
    Read(Result[0], FSize);
  end
  else
    SetLength(Result, 0);
end;

function TQPagedStream.GetBytes(AIndex: Int64): Byte;
begin
  if AIndex + 1 > FSize then
    Result := 0
  else
    Result := PByte(IntPtr(FPages[AIndex div FPageSize]) +
      (AIndex mod FPageSize))^;
end;

function TQPagedStream.GetSize: Int64;
begin
  Result := FSize;
end;

procedure TQPagedStream.LoadFromFile(const FileName: string);
var
  AStream: TStream;
begin
  AStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQPagedStream.LoadFromStream(Stream: TStream);
var
  ACount: Int64;
begin
  ACount := Stream.Size - Stream.Position;
  Capacity := ACount;
  CopyFrom(Stream, ACount);
end;

procedure TQPagedStream.PageNeeded(APageIndex: Integer);
begin
  if High(FPages) < APageIndex then
    Capacity := (APageIndex + 1) * FPageSize - 1;
end;

function TQPagedStream.Read(var Buffer; count: Longint): Longint;
var
  ACanRead: Int64;
  pBuf: PByte;
  APage, APageSpace, APageOffset, AToRead: Integer;
begin
  ACanRead := FSize - FPosition;
  Result := 0;
  if ACanRead >= count then
  begin
    if ACanRead < count then
      count := ACanRead;
    pBuf := @Buffer;
    while count > 0 do
    begin
      APage := ActivePage;
      APageOffset := ActiveOffset;
      APageSpace := FPageSize - ActiveOffset;
      if count > APageSpace then
        AToRead := APageSpace
      else
        AToRead := count;
      Dec(count, AToRead);
      Move(PByte(IntPtr(FPages[APage]) + APageOffset)^, pBuf^, AToRead);
      Inc(pBuf, AToRead);
      Inc(Result, AToRead);
      Inc(FPosition, AToRead);
    end;
  end;
end;

function TQPagedStream.Read(Buffer: TBytes; Offset, count: Longint): Longint;
begin
  if count > 0 then
    Result := Read(Buffer[Offset], count)
  else
    Result := 0;
end;

procedure TQPagedStream.SaveToFile(const FileName: string);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQPagedStream.SaveToStream(Stream: TStream);
begin
  Stream.CopyFrom(Self, 0);
end;

function TQPagedStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning:
      Result := Offset;
    soCurrent:
      Result := FPosition + Offset;
    soEnd:
      Result := FSize - Offset
  else
    Result := 0;
  end;
  if Result > FSize then
    Result := FSize
  else if Result < 0 then
    Result := 0;
  FPosition := Result;
end;

procedure TQPagedStream.SetSize(const NewSize: Int64);
begin
  Capacity := NewSize;
end;

procedure TQPagedStream.SetAsBytes(const Value: TBytes);
begin
  Size := Length(Value);
  if Size > 0 then
    WriteBuffer(Value[0], Size);
end;

procedure TQPagedStream.SetBytes(AIndex: Int64; const Value: Byte);
begin
  if FSize < AIndex + 1 then
    Size := AIndex + 1;
  PByte(IntPtr(FPages[AIndex div FPageSize]) + (AIndex mod FPageSize))^
    := Value;
end;

procedure TQPagedStream.SetCapacity(Value: Int64);
var
  APageNum: Int64;
  I: Integer;
begin
  if Value < 0 then
    Value := 0;
  APageNum := (Value div FPageSize);
  if (Value mod FPageSize) <> 0 then
    Inc(APageNum);
  if FCapacity <> APageNum * FPageSize then
  begin
    FCapacity := APageNum * FPageSize;
    if Length(FPages) > APageNum then
    begin
      I := High(FPages);
      while I >= APageNum do
      begin
        FreeMem(FPages[I]);
        Dec(I);
      end;
      SetLength(FPages, APageNum);
    end
    else
    begin
      I := Length(FPages);
      SetLength(FPages, APageNum);
      while I < APageNum do
      begin
        GetMem(FPages[I], FPageSize);
        Inc(I);
      end;
    end;
  end;
end;

procedure TQPagedStream.SetSize(NewSize: Longint);
begin
  Capacity := NewSize;
end;

function TQPagedStream.Write(const Buffer: TBytes;
  Offset, count: Longint): Longint;
begin
  if count > 0 then
    Result := Write(Buffer[Offset], count)
  else
    Result := 0;
end;

function TQPagedStream.Write(const Buffer; count: Longint): Longint;
var
  ADest: PByte;
  APageIndex, APageOffset, APageSpace: Integer;
  AOffset: Int64;
  pBuf: PByte;
begin
  Result := 0;
  if count > 0 then
  begin
    AOffset := FPosition + count;
    PageNeeded(AOffset div FPageSize);
    APageIndex := ActivePage;
    APageOffset := ActiveOffset;
    APageSpace := FPageSize - APageOffset;
    pBuf := @Buffer;
    while count > 0 do
    begin
      ADest := PByte(IntPtr(FPages[APageIndex]) + APageOffset);
      if APageSpace < count then
      begin
        Move(pBuf^, ADest^, APageSpace);
        Inc(APageIndex);
        Dec(count, APageSpace);
        Inc(Result, APageSpace);
        Inc(pBuf, APageSpace);
        APageOffset := 0;
        APageSpace := FPageSize;
      end
      else
      begin
        Move(pBuf^, ADest^, count);
        Inc(Result, count);
        Break;
      end;
    end;
    Inc(FPosition, Result);
    if FSize < FPosition then
      FSize := FPosition;
  end;
end;

const
  PR_ORDERED = 9; // �������˳������ʱ����12345����ʱÿ���ظ��ַ���С��Ȩֵ
  PR_REPEAT = 5; // ��������ظ�������ʱ����aaaa����ʱÿ���ظ����ٵ�Ȩֵ
  PR_CHARTYPE = 20; // ÿ����һ����ͬ���͵��ַ�ʱ�����ӵ�Ȩֵ
  PR_LENGTH = 10; // ÿ����һ���ַ�ʱ�����ӵ�Ȩֵ
  PR_CHART = 20; // ���������ֺ���ĸ�Ŀ����ַ�ʱ���������ӵ�Ȩֵ
  PR_UNICODE = 40; // ����Unicode�ַ�ʱ���������ӵ�Ȩֵ

function PasswordScale(const S: QStringW; var ARules: TPasswordRules): Integer;
var
  p: PQCharW;
  AMaxOrder, AMaxRepeat, ACharTypes: Integer;
  function RepeatCount: Integer;
  var
    T: PQCharW;
  begin
    T := p;
    Inc(T);
    Result := 0;
    while T^ = p^ do
    begin
      Inc(Result);
      Inc(T);
    end;
    if Result > AMaxRepeat then
      AMaxRepeat := Result;
  end;

  function OrderCount: Integer;
  var
    T, tl: PQCharW;
    AStep: Integer;
  begin
    T := p;
    tl := p;
    Inc(T);
    AStep := Ord(T^) - Ord(p^);
    Result := 0;
    while Ord(T^) - Ord(tl^) = AStep do
    begin
      Inc(Result);
      tl := T;
      Inc(T);
    end;
    if Result > AMaxOrder then
      AMaxOrder := Result;
  end;

begin
  if LowerCase(S) = 'password' then
    Result := 0
  else
  begin
    Result := Length(S) * PR_LENGTH;
    p := PQCharW(S);
    ARules := [];
    AMaxOrder := 0;
    AMaxRepeat := 0;
    while p^ <> #0 do
    begin
      if (p^ >= '0') and (p^ <= '9') then
        ARules := ARules + [prIncNumber]
      else if (p^ >= 'a') and (p^ <= 'z') then
        ARules := ARules + [prIncLowerCase]
      else if (p^ >= 'A') and (p^ <= 'Z') then
        ARules := ARules + [prIncUpperCase]
      else if p^ > #$7F then
        ARules := ARules + [prIncUnicode]
      else
        ARules := ARules + [prIncChart];
      if RepeatCount > 2 then
        ARules := ARules + [prRepeat];
      if OrderCount > 2 then
        ARules := ARules + [prSimpleOrder];
      Inc(p);
    end;
    if prSimpleOrder in ARules then
      Result := Result - AMaxOrder * PR_ORDERED;
    if prRepeat in ARules then
      Result := Result - AMaxRepeat * PR_REPEAT;
    ACharTypes := 0;
    if prIncNumber in ARules then
      Inc(ACharTypes);
    if prIncLowerCase in ARules then
      Inc(ACharTypes);
    if prIncUpperCase in ARules then
      Inc(ACharTypes);
    if prIncChart in ARules then
    begin
      Inc(ACharTypes);
      Result := Result + PR_CHART;
    end;
    if prIncUnicode in ARules then
    begin
      Inc(ACharTypes);
      Result := Result + PR_UNICODE;
    end;
    Result := Result + (ACharTypes - 1) * PR_CHARTYPE;
    // ����ǿ�ȵ�ȡֵ��Χ��<0
    if Result < 0 then
      Result := 0;
  end;
end;

function PasswordScale(const S: QStringW): Integer;
var
  ARules: TPasswordRules;
begin
  Result := PasswordScale(S, ARules);
end;

function CheckPassword(const AScale: Integer): TPasswordStrongLevel; overload;
begin
  if AScale < 60 then
    Result := pslLowest
  else if AScale < 100 then
    Result := pslLower
  else if AScale < 150 then
    Result := pslNormal
  else if AScale < 200 then
    Result := pslHigher
  else
    Result := pslHighest;
end;

function CheckPassword(const S: QStringW): TPasswordStrongLevel; overload;
begin
  Result := CheckPassword(PasswordScale(S));
end;

function PasswordCharTypes(const S: QStringW): TRandCharTypes;
var
  p: PQCharW;
begin
  Result := [];
  p := PQCharW(S);
  while p^ <> #0 do
  begin
    if ((p^ >= '0') and (p^ <= '9')) or ((p^ >= '��') and (p^ <= '��')) then
      Result := Result + [rctNum]
    else if ((p^ >= 'a') and (p^ <= 'z')) or ((p^ >= '��') and (p^ <= '��')) then
      Result := Result + [rctAlpha, rctLowerCase]
    else if ((p^ >= 'A') and (p^ <= 'Z')) or ((p^ >= '��') and (p^ <= '��')) then
      Result := Result + [rctAlpha, rctUpperCase]
    else if (p^ >= #$4E00) and (p^ <= #$9FA5) then
      Result := Result + [rctChinese]
    else if (p^ = ' ') or (p^ = #9) or (p^ = #10) or (p^ = #13) or (p^ = #$00A0)
      or (p^ = #$3000) then
      Result := Result + [rctSpace]
    else
      Result := Result + [rctSymbol];
    if Result = [rctChinese, rctAlpha, rctLowerCase, rctUpperCase, rctNum,
      rctSymbol, rctSpace] then
      Break;
    Inc(p);
  end;
end;

function PasswordRules(const S: QStringW): TPasswordRules;
begin
  Result := [];
  PasswordScale(S, Result);
end;

function SimpleChineseToTraditional(S: QStringW): QStringW;
begin
{$IFDEF MSWINDOWS}
  SetLength(Result, Length(S) shl 1);
  SetLength(Result, LCMapStringW(2052, LCMAP_TRADITIONAL_CHINESE, PWideChar(S),
    Length(S), PWideChar(Result), Length(Result)));
{$ELSE}
  raise Exception.CreateFmt(SUnsupportNow, ['SimpleChineseToTraditional']);
{$ENDIF}
end;

function TraditionalChineseToSimple(S: QStringW): QStringW;
begin
{$IFDEF MSWINDOWS}
  SetLength(Result, Length(S) shl 1);
  SetLength(Result, LCMapStringW(2052, LCMAP_SIMPLIFIED_CHINESE, PWideChar(S),
    Length(S), PWideChar(Result), Length(Result)));
{$ELSE}
  raise Exception.CreateFmt(SUnsupportNow, ['TraditionalChineseToSimple']);
{$ENDIF}
end;

function MoneyRound(const AVal: Currency; ARoundMethod: TMoneyRoundMethod)
  : Currency;
var
  V, R: Int64;
begin
  if ARoundMethod = mrmNone then
  begin
    Result := AVal;
    Exit;
  end;
  V := PInt64(@AVal)^;
  R := V mod 100;
  if ARoundMethod = mrmSimple then
  begin
    if R >= 50 then
      PInt64(@Result)^ := ((V div 100) + 1) * 100
    else
      PInt64(@Result)^ := (V div 100) * 100;
  end
  else
  begin
    {
      ���������忼�ǣ�
      ������ͽ�һ��
      �����㿴��ż��
      ��ǰΪżӦ��ȥ��
      ��ǰΪ��Ҫ��һ�� }
    if R > 50 then // ����
      PInt64(@Result)^ := ((V div 100) + 1) * 100
    else if R = 50 then //
    begin
      if (((V div 100)) and $1) <> 0 then // ����
        PInt64(@Result)^ := ((V div 100) + 1) * 100
      else
        PInt64(@Result)^ := (V div 100) * 100;
    end
    else
      PInt64(@Result)^ := (V div 100) * 100;
  end;
end;
{
  ������ֵת��Ϊ���ִ�д
  Parameters
  AVal : ����ֵ
  AFlags : ��־λ��ϣ��Ծ����������ĸ�ʽ
  ANegText : ������ֵΪ����ʱ����ʾ��ǰ׺
  AStartText : ǰ���ַ������硰����ң���
  AEndText : �����ַ������硰����
  AGroupNum : ������ÿ���������䵥λ����һ�����飬AGroupNumָ��Ҫ�����������
  ��Ϊ0ʱ������Ա�־λ�е�MC_HIDE_ZERO��MC_MERGE_ZERO
  ARoundMethod : ������뵽��ʱ���㷨
  AEndDigts : С������λ����-16~4 ֮��
  Returns
  ���ظ�ʽ������ַ���
  Examples
  CapMoney(1.235,MC_READ,L"",L"",L"",0)=ҼԪ��������
  CapMoney(1.235,MC_READ,L"",L"",L"",4)=��ʰҼԪ��������
  CapMoney(100.24,MC_READ,L"",L"",L"",4)=Ҽ��Ԫ�㷡������
  CapMoney(-10012.235,MC_READ,L"��",L"��",L"",0)=����Ҽ����Ҽʰ��Ԫ��������
  CapMoney(101005,MC_READ,L"��",L"",L"",0)=Ҽʰ��ҼǪ����Ԫ
}

function CapMoney(AVal: Currency; AFlags: Integer;
  ANegText, AStartText, AEndText: QStringW; AGroupNum: Integer;
  ARoundMethod: TMoneyRoundMethod; AEndDigits: Integer = 2): QStringW;
const
  Nums: array [0 .. 9] of WideChar = (#$96F6 { �� } , #$58F9 { Ҽ } ,
    #$8D30 { �� } , #$53C1 { �� } , #$8086 { �� } , #$4F0D { �� } , #$9646 { ½ } ,
    #$67D2 { �� } , #$634C { �� } , #$7396 { �� } );
  Units: array [0 .. 19] of WideChar = (#$94B1 { Ǯ } , #$5398 { �� } ,
    #$5206 { �� } , #$89D2 { �� } , #$5706 { Բ } , #$62FE { ʰ } , #$4F70 { �� } ,
    #$4EDF { Ǫ } , #$4E07 { �� } , #$62FE { ʰ } , #$4F70 { �� } , #$4EDF { Ǫ } ,
    #$4EBF { �� } , #$62FE { ʰ } , #$4F70 { �� } , #$4EDF { Ǫ } , #$4E07 { �� } ,
    #$5146 { �� } , #$62FE { ʰ } , #$4F70 { �� } );
  Levels: array [0 .. 5] of WideChar = (#$62FE { ʰ } , #$4F70 { �� } ,
    #$4EDF { Ǫ } , #$4E07 { �� } , #$4EBF { �� } , #$5146 { �� } );

  function UnitLevel(const AUnit: WideChar): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to High(Levels) do
    begin
      if Levels[I] = AUnit then
      begin
        Result := I;
        Break;
      end;
    end;
  end;

var
  R, V: Int64;
  I: Integer;
  ATemp: QStringW;
  pd, pe, p, pu: PWideChar;
  APreLevel, ALevel: Integer;
begin
  AVal := MoneyRound(AVal, ARoundMethod);
  { -922,337,203,685,477.5808 ~ 922,337,203,685,477.5807 }
  V := PInt64(@AVal)^; // ��ȷ����
  if V < 0 then
    V := -V
  else
    SetLength(ANegText, 0);
  if (AFlags and MC_END_PATCH) <> 0 then // ���Ҫ����AEndText������������λ
    AFlags := AFlags or MC_UNIT;
  if AGroupNum > 0 then // ���Ҫ����
  begin
    AFlags := AFlags and (not(MC_MERGE_ZERO or MC_HIDE_ZERO));
    if AGroupNum > 20 then
      AGroupNum := 20;
  end;
  if AEndDigits < -16 then
    AEndDigits := -16
  else if AEndDigits > 4 then
    AEndDigits := 4;
  SetLength(ATemp, 40); // ��󳤶�Ϊ40
  pd := PWideChar(ATemp) + 39;
  // ����ʵ�ʵķ���������ע���ʱ����Ǯ���壬�������ʵ�ʵ���ʾ��Ҫ�ض�
  I := 0;
  while V > 0 do
  begin
    R := V mod 10;
    V := V div 10;
    pd^ := Units[I];
    Dec(pd);
    pd^ := Nums[R];
    Dec(pd);
    Inc(I);
  end;
  if AGroupNum > 0 then
  begin
    if I > AGroupNum then
      raise Exception.CreateFmt(STooSmallCapMoneyGroup, [AGroupNum, I]);
    while AGroupNum > I do
    // Ҫ��ķ�������
    begin
      pd^ := Units[I];
      Dec(pd);
      pd^ := Nums[0];
      Dec(pd);
      Inc(I);
    end;
  end;
  Inc(pd);
  if (AFlags and MC_HIDE_ZERO) <> 0 then // �������������ֵ��������
  begin
    while pd^ <> #0 do
    begin
      if pd^ = Nums[0] then
        Inc(pd, 2)
      else
        Break;
    end;
  end;

  SetLength(Result, PWideChar(ATemp) + 40 - pd);
  p := PWideChar(Result);
  pe := PWideChar(ATemp) + 32 + AEndDigits * 2;
  APreLevel := -1;
  while pd < pe do
  begin
    if (AFlags and MC_NUM) <> 0 then
    begin
      p^ := pd^;
      Inc(p);
      if ((AFlags and MC_MERGE_ZERO) <> 0) and (pd^ = Nums[0]) then
      begin
        pu := pd;
        Inc(pu);
        while pd^ = Nums[0] do
        begin
          Inc(pd);
          ALevel := UnitLevel(pd^);
          if ALevel > APreLevel then // ��
          begin
            APreLevel := ALevel;
            Dec(p);
            p^ := pd^;
            Inc(p);
            Inc(pd);
            Break;
          end
          else
            Inc(pd);
        end;
        if pd^ = #0 then
        begin
          Dec(p);
          if (AFlags and MC_UNIT) <> 0 then
          begin
            if pu^ = Units[4] then
            begin
              p^ := Units[4];
              Inc(p);
            end;
          end;
        end;
        continue;
      end;
    end;
    Inc(pd);
    if (AFlags and MC_UNIT) <> 0 then
    begin
      APreLevel := UnitLevel(pd^);
      p^ := pd^;
      Inc(p);
    end;
    Inc(pd);
  end;
  SetLength(Result, p - PWideChar(Result));
  if (AFlags and MC_UNIT) <> 0 then
  begin
    if Length(Result) = 0 then
      Result := '��Բ';
    if (AFlags and MC_END_PATCH) <> 0 then
    begin
      if PWideChar(Result)[Length(Result) - 1] = Units[2] then // ��
        Result := AStartText + ANegText + Result
      else
        Result := AStartText + ANegText + Result + AEndText;
    end
    else
      Result := AStartText + ANegText + Result;
  end
  else
  begin
    if Length(Result) = 0 then
      Result := '��';
    Result := AStartText + ANegText + Result;
  end;
end;

function IsHumanName(S: QStringW; AllowChars: TNameCharSet; AMinLen: Integer;
  AMaxLen: Integer; AOnTest: TQCustomNameCharTest): Boolean;
var
  p: PWideChar;
  c, ACharCode, ATypeIndex: Integer;
  AHandled: Boolean;
  function TypeIndex: Integer;
  var
    l, H, M, c: Integer;
  begin
    l := 0;
    H := High(CharRanges);
    Result := -1;
    l := 0;
    while l <= H do
    begin
      M := (l + H) shr 1;
      if ACharCode < CharRanges[M].Start then
        c := 1
      else if ACharCode > CharRanges[M].Stop then
        c := -1
      else
        c := 0;
      if c < 0 then
        l := M + 1
      else
      begin
        if c = 0 then
          Exit(M);
        H := M - 1;
      end;
    end;
  end;
begin
  S := Trim(CNFullToHalf(S)); // ��ȫ��ת��Ϊ���
  c := CharCountW(S);
  Result := (c >= AMinLen) and (c <= AMaxLen);
  // �������ַ�����ע�ⲻ���ֽ�����Ӧ����С����󳤶�֮��
  if not Result then
    Exit;
  p := PWideChar(S);
  while Result and (p^ <> #0) do
  begin
    if Assigned(AOnTest) then
    begin
      AHandled := false;
      AOnTest(qstring.CharCodeW(p), Result, AHandled);
      if AHandled then
      begin
        if (p^ >= #$D800) and (p^ <= #$DBFF) then
          Inc(p, 2)
        else
          Inc(p);
        continue;
      end;
    end;
    ACharCode := CharCodeW(p);
    if ACharCode >= $10000 then
      Inc(p, 2)
      else
      Inc(p, 1);
    ATypeIndex := TypeIndex;
    if ATypeIndex = -1 then
      Result := nctOther in AllowChars
    else
      Result := CharRanges[ATypeIndex].CharType in AllowChars;
  end;
end;

function IsChineseName(S: QStringW): Boolean;
begin
  Result := IsHumanName(S, [nctChinese, nctDot], 2, 50);
end;

function IsNoChineseName(S: QStringW): Boolean;
begin
  Result := IsHumanName(S, [nctAlpha, nctDot, nctSpace, nctOther], 2, 50);
end;

procedure AddrCharTest(AChar: Cardinal; var Accept, AHandled: Boolean);
begin
  if AChar = Ord('-') then
  begin
    Accept := True;
    AHandled := True;
  end;
end;

function IsChineseAddr(S: QStringW; AMinLength: Integer): Boolean;
begin
  Result := IsHumanName(S, [nctChinese, nctAlpha, nctSymbol, nctDot, nctSpace,
    nctNum], AMinLength, 128, AddrCharTest);
end;

function IsNoChineseAddr(S: QStringW; AMinLength: Integer): Boolean;
begin
  Result := IsHumanName(S, [nctAlpha, nctDot, nctSymbol, nctSpace, nctNum],
    AMinLength, 128, AddrCharTest);
end;

{ TQBits }

function TQBits.GetIsSet(AIndex: Integer): Boolean;
begin
  if (AIndex < 0) or (AIndex >= Size) then
    Result := false
  else
    Result := (FBits[AIndex shr 3] and ($80 shr (AIndex and $7))) <> 0;
end;

function TQBits.GetSize: Integer;
begin
  Result := Length(FBits) shl 3;
end;

procedure TQBits.SetIsSet(AIndex: Integer; const Value: Boolean);
var
  AByteIdx: Integer;
begin
  if (AIndex < 0) or (AIndex >= Size) then
    raise QException.CreateFmt(SOutOfIndex, [AIndex, 0, Size - 1]);
  AByteIdx := AIndex shr 3;
  if Value then
    FBits[AByteIdx] := FBits[AByteIdx] or ($80 shr (AIndex and $7))
  else
    FBits[AByteIdx] := FBits[AByteIdx] and (not($80 shr (AIndex and $7)));
end;

procedure TQBits.SetSize(const Value: Integer);
begin
  if (Value and $7) <> 0 then
    SetLength(FBits, (Value shr 3) + 1)
  else
    SetLength(FBits, Value shr 3);
end;

function CheckChineseId18(CardNo: QStringW): QCharW;
var
  Sum, Idx: Integer;
const
  Weight: array [1 .. 17] of Integer = (7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10,
    5, 8, 4, 2);
  Checksums: array [0 .. 10] of WideChar = ('1', '0', 'X', '9', '8', '7', '6',
    '5', '4', '3', '2');
begin
  if (Length(CardNo) >= 17) then
  begin
    Sum := 0;
    for Idx := 1 to 17 do
      Sum := Sum + (Ord(CardNo[Idx{$IFDEF NEXTGEN} - 1{$ENDIF}]) - Ord('0')) *
        Weight[Idx];
    Result := Checksums[Sum mod 11];
  end
  else
    Result := #0;
end;

function ChineseId15To18(CardNo: QStringW): QStringW;
begin
  if (Length(CardNo) <> 15) then
    raise Exception.Create('15λת18λ����Ҫ�����֤�ű���Ϊ15λ��');
  CardNo := LeftStrW(CardNo, 6, false) + '19' + RightStrW(CardNo, 9, false);
  Result := CardNo + CheckChineseId18(CardNo);
end;

function DecodeChineseId(CardNo: QStringW; var AreaCode: QStringW;
  var Birthday: TDateTime; var IsFemale: Boolean): Boolean;
var
  len: Integer;
  Y, M, d: Integer;
  p: PQCharW;
begin
  len := Length(CardNo);
  Result := false;
  if (len in [15, 18]) then
  // ���ȼ��
  begin
    if (Length(CardNo) = 15) then
      CardNo := ChineseId15To18(CardNo);
    if CheckChineseId18(CardNo) <>
      CharUpperW(CardNo[{$IFDEF NEXTGEN}17{$ELSE}18{$ENDIF}]) then // ���֤��У������
      Exit;
    p := PQCharW(CardNo);
    AreaCode := StrDupX(p, 6);
    Inc(p, 6);
    if not TryStrToInt(StrDupX(p, 4), Y) then // ��
      Exit;
    Inc(p, 4);
    if not TryStrToInt(StrDupX(p, 2), M) then // ��
      Exit;
    Inc(p, 2);
    if not TryStrToInt(StrDupX(p, 2), d) then // ��
      Exit;
    Inc(p, 2);
    if not TryEncodeDate(Y, M, d, Birthday) then
      Exit;
    if Birthday > Now then
      Exit;
    if TryStrToInt(StrDupX(p, 3), Y) then
    begin
      Result := True;
      if (Y mod 2) = 0 then
        IsFemale := True
      else
        IsFemale := false;
    end
  end
  else
    Result := false;
end;

function AreaCodeOfChineseId(CardNo: QStringW): QStringW;
var
  ABirthday: TDateTime;
  AIsFemale: Boolean;
begin
  if not DecodeChineseId(CardNo, Result, ABirthday, AIsFemale) then
    SetLength(Result, 0);
end;

function AgeOfChineseId(CardNo: QStringW; ACalcDate: TDateTime): Integer;
var
  ACode: QStringW;
  AIsFemale: Boolean;
  ABirthday: TDateTime;
begin
  if DecodeChineseId(CardNo, ACode, ABirthday, AIsFemale) then
  begin
    if IsZero(ACalcDate) then
      Result := YearsBetween(Now, ABirthday)
    else
      Result := YearsBetween(ACalcDate, ABirthday);
  end
  else
    Result := -1;
end;

function BirthdayOfChineseId(CardNo: QStringW): TDateTime;
var
  ACode: QStringW;
  AIsFemale: Boolean;
begin
  if not DecodeChineseId(CardNo, ACode, Result, AIsFemale) then
    Result := 0;
end;

function SexOfChineseId(CardNo: QStringW): TQHumanSex;
var
  ACode: QStringW;
  AIsFemale: Boolean;
  ABirthday: TDateTime;
begin
  if DecodeChineseId(CardNo, ACode, ABirthday, AIsFemale) then
  begin
    if AIsFemale then
      Result := hsFemale
    else
      Result := hsMale;
  end
  else
    Result := hsUnknown;
end;

function IsChineseIdNo(CardNo: QStringW): Boolean;
var
  AreaCode: QStringW;
  Birthday: TDateTime;
  IsFemale: Boolean;
begin
  Result := DecodeChineseId(CardNo, AreaCode, Birthday, IsFemale);
end;

function IsEmailAddr(S: QStringW): Boolean;
var
  p: PQCharW;
  At: Integer;
  Dot: Integer;
begin
  p := PQCharW(S);
  At := 0;
  Dot := 0;
  while p^ <> #0 do
  begin
    if p^ = '@' then
      Inc(At)
    else if p^ = '.' then
      Inc(Dot);
    Inc(p);
  end;
  Result := (At = 1) and (Dot > 0);
end;

function IsChinesePhone(S: QStringW): Boolean;
var
  p, ps: PQCharW;
  l, APart: Integer;
const
  PP_COUNTY = 0;
  PP_AREA = 1;
  PP_MAIN = 2;
  PP_SUB = 3;
  PP_400800 = 4;
begin
  p := PQCharW(S);
  if p^ = '+' then
  begin
    Inc(p);
    while (p^ >= '0') and (p^ <= '9') do
      Inc(p);
    // ��������
  end;
  l := 0;
  if p^ = '0' then // ������020-109119191��0201929292
    APart := PP_AREA
  else if StartWithW(p, '400', false) or StartWithW(p, '800', false) then
  begin
    Inc(p, 3);
    if (p^ = '-') or (p^ = ' ') then
      Inc(p);
    APart := PP_400800;
  end
  else
    APart := PP_MAIN;
  ps := p;
  while ((p^ >= '0') and (p^ <= '9')) or (p^ = '-') or (p^ = ' ') or
    (p^ = '#') do
  begin
    if p^ = '-' then
    begin
      if APart = PP_AREA then
      begin
        APart := PP_MAIN;
        l := 0;
      end
      else if APart = PP_MAIN then
        APart := PP_SUB
      else if (APart = PP_400800) and (l = 7) then // 400800����Ϊ400/800+7λ
        APart := PP_SUB;
    end
    else if p^ = '#' then
      APart := PP_SUB
    else if (APart in [PP_AREA, PP_MAIN, PP_400800]) and (p^ <> ' ') then
      Inc(l);
    Inc(p);
  end;
  Result := (p^ = #0) and
    ((l >= 6) and (((ps^ <> '0') and (l <= 8)) or ((ps^ = '0') and (l <= 12))));
  if Result then
  begin
    Dec(p);
    Result := p^ <> '-';
  end;
end;

function IsChineseMobile(S: QStringW; ACheckNumericOnly: Boolean): Boolean;
var
  p: PQCharW;
  ACount: Integer;
const
  Delimiters: PWideChar = ' -';
begin
  ACount := Length(S);
  Result := false;
  if ACount >= 11 then
  begin
    p := PQCharW(S);
    if p^ = '+' then // +86
    begin
      Inc(p);
      if p^ <> '8' then
        Exit;
      Inc(p);
      if p^ <> '6' then
        Exit;
      Inc(p);
      SkipCharW(p, Delimiters);
    end;
    if (p^ = '1') or ACheckNumericOnly then // �й��ֻ�����1��ͷ��
    begin
      ACount := 0;
      while p^ <> #0 do
      begin
        if (p^ >= '0') and (p^ <= '9') then
        begin
          Inc(p);
          Inc(ACount);
        end
        else if (p^ = '-') or (p^ = ' ') then
        begin
          if (p^ = '-') and (ACount = 11) then // ����ţ�
            Exit(True);
          Inc(p)
        end
        else
          Exit;
      end;
      Result := (ACount = 11);
    end;
  end;
end;

function SizeOfFile(const S: QStringW): Int64;
var
  sr: TSearchRec;
begin
  if FindFirst(S, 0, sr) = 0 then
  begin
    Result := sr.Size;
    sysutils.FindClose(sr);
  end
  else
    Result := -1;
end;

function MethodEqual(const Left, Right: TMethod): Boolean;
begin
  Result := (Left.Data = Right.Data) and (Left.Code = Right.Code);
end;

function MethodAssigned(var AMethod): Boolean;
begin
  Result := Assigned(TMethod(AMethod).Code);
end;

function UrlMerge(const ABase, ARel: QStringW): QStringW;
var
  p, pBase, pRel: PQCharW;
  ASchema: QStringW;
  function BasePath: String;
  var
    LP, sp: PQCharW;
  begin
    p := pBase;
    if StartWithW(p, 'http://', True) then
      ASchema := StrDupX(p, 7)
    else if StartWithW(p, 'https://', True) then
      ASchema := StrDupX(p, 8);
    Inc(p, Length(ASchema));
    LP := p;
    sp := p;
    while p^ <> #0 do
    begin
      if p^ = '/' then
        LP := p;
      Inc(p);
    end;
    if LP = sp then
      Result := ABase + '/'
    else
      Result := StrDupX(pBase, ((IntPtr(LP) - IntPtr(pBase)) shr 1) + 1);
  end;

  function RootPath: String;
  begin
    p := pBase;
    if StartWithW(p, 'http://', True) then
      ASchema := StrDupX(p, 7)
    else if StartWithW(p, 'https://', True) then
      ASchema := StrDupX(p, 8);
    Inc(p, Length(ASchema));
    while p^ <> #0 do
    begin
      if p^ = '/' then
      begin
        Result := StrDupX(pBase, ((IntPtr(p) - IntPtr(pBase)) shr 1) + 1);
        Exit;
      end;
      Inc(p);
    end;
    Result := ABase + '/'
  end;

begin
  pRel := PQCharW(ARel);
  pBase := PQCharW(ABase);
  if StartWithW(pRel, 'http', True) then // ����·����
  begin
    p := pRel;
    Inc(pRel, 4);
    if (pRel^ = 's') or (pRel^ = 'S') then
      // https?
      Inc(pRel);
    if StartWithW(pRel, '://', false) then // ʹ�õľ���·����ֱ�ӷ���
    begin
      Result := ARel;
      Exit;
    end;
  end
  else if StartWithW(pRel, '//', True) then // ����ABase��ͬ��Э��ľ���·��
  begin
    if StartWithW(pBase, 'https', True) then
      Result := 'https:' + ARel
    else
      Result := 'http:' + ARel;
  end
  else
  begin
    if pRel^ = '/' then
      Result := RootPath + StrDupW(pRel, 1)
    else
      Result := BasePath + ARel;
  end;
end;

procedure Debugout(const AMsg: QStringW);
begin
{$IFDEF MSWINDOWS}
  OutputDebugStringW(PQCharW(AMsg));
{$ENDIF}
{$IFDEF ANDROID}
  __android_log_write(ANDROID_LOG_DEBUG, 'debug',
    Pointer(PQCharA(qstring.Utf8Encode(AMsg))));
{$ENDIF}
{$IFDEF IOS}
  NSLog(((StrToNSStr(AMsg)) as ILocalObject).GetObjectID);
{$ENDIF}
{$IFDEF OSX}
  WriteLn(ErrOutput, AMsg);
{$ENDIF}
end;

procedure Debugout(const AFmt: QStringW; const AParams: array of const);
begin
  Debugout(Format(AFmt, AParams));
end;

function RandomString(ALen: Cardinal; ACharTypes: TRandCharTypes;
  AllTypesNeeded: Boolean): QStringW;
var
  p: PQCharW;
  K, M: Integer;
  V: TRandCharType;
  ARemainTypes: TRandCharTypes;
const
  SpaceChars: array [0 .. 3] of QCharW = (#9, #10, #13, #32);
begin
  if ACharTypes = [] then // ���δ���ã���Ĭ��Ϊ��Сд��ĸ
    ACharTypes := [rctAlpha];
  SetLength(Result, ALen);
  p := PQCharW(Result);
  ARemainTypes := ACharTypes;
  M := Ord(High(TRandCharType)) + 1;
  while ALen > 0 do
  begin
    V := TRandCharType(random(M));
    if AllTypesNeeded and (ARemainTypes <> []) then
    begin
      while not(V in ARemainTypes) do
        V := TRandCharType(random(M));
      ARemainTypes := ARemainTypes - [V];
    end;
    if V in ACharTypes then
    begin
      case V of
        rctChinese:
          p^ := QCharW($4E00 + random($9FA5 - $4E00));
        rctAlpha:
          begin
            K := random(52);
            if K < 26 then
              p^ := QCharW(Ord('A') + K)
            else
              p^ := QCharW(Ord('a') + K - 26);
          end;
        rctLowerCase:
          p^ := QCharW(Ord('a') + random(26));
        rctUpperCase:
          p^ := QCharW(Ord('A') + random(26));
        rctNum:
          p^ := QCharW(Ord('0') + random(10));
        rctSymbol: // ֻ��Ӣ�ķ���
          begin
            // $21~$2F,$3A~$40,$5B-$60,$7B~$7E
            case random(4) of
              0: // !->/
                p^ := QCharW($21 + random(16));
              1: // :->@
                p^ := QCharW($3A + random(7));
              2: // [->`
                p^ := QCharW($5B + random(6));
              3: // {->~
                p^ := QCharW($7B + random(4));
            end;
          end;
        rctSpace:
          p^ := SpaceChars[random(4)];
      end;
      Dec(ALen);
      Inc(p);
    end;
  end;
end;

function FindSwitchValue(ASwitch: QStringW; ANameValueSperator: QCharW;
  AIgnoreCase: Boolean; var ASwitchChar: QCharW): QStringW;
var
  I: Integer;
  S, SW: QStringW;
  ps, p: PQCharW;
const
  SwitchChars: PWideChar = '+-/';
begin
  SW := ASwitch + ANameValueSperator;
  for I := 1 to ParamCount do
  begin
    S := ParamStr(I);
    ps := PQCharW(S);
    p := ps;
    SkipCharW(p, SwitchChars);
    if StartWithW(PQCharW(p), PQCharW(SW), AIgnoreCase) then
    begin
      if p <> ps then
        ASwitchChar := ps^
      else
        ASwitchChar := #0;
      Result := ValueOfW(S, ANameValueSperator);
      Exit;
    end
  end;
  Result := '';
end;

function FindSwitchValue(ASwitch: QStringW; ANameValueSperator: QCharW)
  : QStringW;
var
  c: QCharW;
begin
  Result := FindSwitchValue(ASwitch, ANameValueSperator, True, c);
end;

{ TQSingleton<T> }

function TQSingleton{$IFDEF UNICODE}<T>{$ENDIF}.Instance
  (ACallback: TGetInstanceCallback):
{$IFDEF UNICODE}T{$ELSE}Pointer{$ENDIF};
begin
  if not Assigned(InitToNull) then
  begin
    GlobalNameSpace.BeginWrite;
    try
      if not Assigned(InitToNull) then
        InitToNull := ACallback;
    finally
      GlobalNameSpace.EndWrite;
    end;
  end;
  Result := InitToNull;
end;

{ TQReadOnlyMemoryStream }

constructor TQReadOnlyMemoryStream.Create(AData: Pointer; ASize: Integer);
begin
  inherited Create;
  SetPointer(AData, ASize);
end;

constructor TQReadOnlyMemoryStream.Create;
begin
  inherited;
  // ������캯����ɱ����ģ��Ա����ⲿ����
end;

function TQReadOnlyMemoryStream.Write(const Buffer; count: Longint): Longint;
begin
  raise EStreamError.Create(SStreamReadOnly);
end;

function MonthFirstDay(ADate: TDateTime): TDateTime;
var
  Y, M, d: Word;
begin
  DecodeDate(ADate, Y, M, d);
  Result := EncodeDate(Y, M, 1);
end;

function MergeAddr(const AProv, ACity, ACounty, ATownship, AVillage,
  ADetail: QStringW; AIgnoreCityIfSameEnding: Boolean): QStringW;
var
  p: PWideChar;
  procedure Cat(S: QStringW);
  begin
    if (Length(S) > 0) and (not EndWithW(PWideChar(Result), PWideChar(S), false))
    then
    begin
      Result := Result + S;
      if StartWithW(p, PWideChar(S), false) then
        Inc(p, Length(S));
    end;
  end;

begin
  Result := '';
  p := PWideChar(ADetail);
  Cat(AProv);
  if ACity <> '��Ͻ��' then
  begin
    if (Length(ACity) > 0) and (Length(ACounty) > 0) then
    begin
      if RightStrW(ACity, 1, false) = RightStrW(ACounty, 1, false) then
      begin
        if not AIgnoreCityIfSameEnding then
          Cat(LeftStrW(ACity, Length(ACity) - 1, false))
        else if StartWithW(p, PWideChar(ACity), false) then
          Inc(p, Length(ACity));
      end
      else
        Cat(ACity);
    end;
  end;
  Cat(ACounty);
  Cat(ATownship);
  Cat(AVillage);
  Result := Result + p;
end;

function MaskText(const S: QStringW; ALeft, ARight: Integer; AMaskChar: QCharW)
  : QStringW;
var
  l: Integer;
begin
  l := Length(S);
  if l > 0 then
  begin
    if ALeft + ARight >= l then
    begin
      ARight := 0;
      if ALeft > l then
        ALeft := l - 1;
    end;
    Result := LeftStrW(S, ALeft, false) + StringReplicateW(AMaskChar,
      l - ALeft - ARight) + RightStrW(S, ARight, false);
  end
  else
    Result := S;
end;

function CountOfChar(p: PQCharW; const c: QCharW): Integer;
begin
  Result := 0;
  while p^ <> #0 do
  begin
    if p^ = c then
      Inc(Result);
    Inc(p);
  end;
end;

function StrCatW(const S: array of QStringW; AIgnoreZeroLength: Boolean;
  const AStartOffset, ACount: Integer; const ADelimiter: QCharW;
  const AQuoter: QCharW): QStringW;
var
  I, l, ASize, ADelimSize, ARealStart, ARealStop: Integer;
  pd: PQCharW;
  AValue: QStringW;

begin
  ASize := 0;
  if ADelimiter <> #0 then
    ADelimSize := 1
  else
    ADelimSize := 0;
  if AStartOffset > 0 then
    ARealStart := AStartOffset
  else if ACount <= Length(S) then
    ARealStart := Length(S) - ACount
  else
    ARealStart := 0;
  if ARealStart < 0 then
    ARealStart := 0;
  if ACount > Length(S) then
    ARealStop := Length(S)
  else if ARealStart + ACount > Length(S) then
    ARealStop := Length(S)
  else
    ARealStop := ARealStart + ACount;
  if ARealStart < ARealStop then
  begin
    for I := ARealStart to ARealStop - 1 do
    begin
      l := Length(S[I]);
      if l = 0 then
      begin
        if AIgnoreZeroLength then
          continue;
      end
      else if AQuoter <> #0 then
        Inc(ASize, l + 2 + CountOfChar(PQCharW(S[I]), AQuoter))
      else
        Inc(ASize, l);
      Inc(ASize, ADelimSize);
    end;
    Dec(ASize);
    if ASize > 0 then
    begin
      SetLength(Result, ASize);
      pd := PQCharW(Result);
      for I := ARealStart to ARealStop - 1 do
      begin
        l := Length(S[I]);
        if l = 0 then
        begin
          if AIgnoreZeroLength then
            continue
          else if AQuoter<>#0 then
          begin
            pd^:=AQuoter;
            Inc(pd);
            pd^:=AQuoter;
            Inc(pd);
          end;
        end
        else
        begin
          if AQuoter <> #0 then
            AValue := QuotedStrW(S[I], AQuoter)
          else
            AValue := S[I];
          l := Length(AValue);
          Move(PQCharW(AValue)^, pd^, l * SizeOf(QCharW));
          Inc(pd, l);
        end;
        if (ADelimSize <> 0) and (I + 1 < ARealStop) then
        begin
          pd^ := ADelimiter;
          Inc(pd);
        end;
      end;
    end;
  end
  else
    SetLength(Result, 0);
end;

function ReplaceLineBreak(const S, ALineBreak: QStringW): QStringW;
var
  ps, pd: PQCharW;
  ALen, ADelta: Integer;
begin
  if Length(S) > 0 then
  begin
    ps := PQCharW(S);
    ALen := Length(ALineBreak);
    ADelta := 0;
    while ps^ <> #0 do
    begin
      if ps^ = #13 then
      begin
        Inc(ps);
        if ps^ = #10 then
        begin
          Inc(ps);
          Inc(ADelta, ALen - 2);
        end;
      end
      else if ps^ = #10 then
      begin
        Inc(ps);
        Inc(ADelta, ALen - 1);
      end
      else
        Inc(ps);
    end;
    if ADelta = 0 then
      Result := S
    else
    begin
      SetLength(Result, Length(S) + ADelta);
      ps := PQCharW(S);
      pd := PQCharW(Result);
      ALen := ALen * SizeOf(QCharW);
      while ps^ <> #0 do
      begin
        if ps^ = #13 then
        begin
          Inc(ps);
          if ps^ = #10 then
          begin
            Inc(ps);
            Move(PQCharW(ALineBreak)^, pd^, ALen);
            Inc(pd, Length(ALineBreak));
          end;
        end
        else if ps^ = #10 then
        begin
          Inc(ps);
          Move(PQCharW(ALineBreak)^, pd^, ALen);
          Inc(pd, Length(ALineBreak));
        end
        else
        begin
          pd^ := ps^;
          Inc(ps);
          Inc(pd);
        end;
      end;
    end;
  end
  else
    Result := S;
end;

function IsFMXApp: Boolean;
begin
  if AppType = 0 then
  begin
    if GetClass('TFmxObject') <> nil then
      AppType := 1
    else
      AppType := 2;
  end;
  Result := AppType = 1;
end;

// https://www.doc88.com/p-6435058878866.html
function IsBankNo(ABankNo: QStringW): Boolean;
var
  ps: PQCharW;
  I, AChecksum, V, ACount, AExistsSum: Integer;
begin
  ps := PQCharW(ABankNo);
  AChecksum := 0;
  Result := false;
  // ������֤����У����Ƿ���ȷ
  ACount := Length(ABankNo);
  if (ACount < 8) or (ACount > 19) then
    Exit;
  Dec(ACount, 1);
  AExistsSum := Ord(PQCharW(ps + ACount)^) - Ord('0');
  if AExistsSum in [0 .. 9] then
  begin
    // ���Ե�У��λ
    Dec(ACount);
    for I := ACount downto 0 do
    begin
      V := Ord(PQCharW(ps + I)^) - Ord('0');
      if V in [0 .. 9] then
      begin
        if ((ACount - I) mod 2) = 0 then
        begin
          if V >= 5 then
            Inc(AChecksum);
          V := (V shl 1) mod 10;
        end;
        Inc(AChecksum, V);
      end
      else
        Exit;
    end;
    Result := ((10 - AExistsSum) mod 10) = (AChecksum mod 10);
  end;
end;

// ��������ƽ̨:open.unionapy.com
// IIN ������6λ��8λ��2017 ISO 7812 �涨Ϊ 8 λ����ǰΪ6λ������Ĭ�ϰ�8λ��
function DecodeBankNo(const ABankNo: QStringW;
  var ABankIdent, APersonIdent: QStringW): Boolean;
var
  p: PQCharW;
  S: QStringW;
begin
  S := DeleteCharW(CNFullToHalf(ABankNo), ' ');
  Result := IsBankNo(S);
  if Result then
  begin
    p := PQCharW(S);
    ABankIdent := Copy(p, 0, 8);
    APersonIdent := Copy(p, 9, Length(ABankNo) - 9);
  end;
end;

function StrPrefixW(const AFixedLength: Integer; const AValue: String;
  const APrefixChar: QCharW): QStringW;
begin
  if Length(AValue) < AFixedLength then
    Result := StringReplicateW(APrefixChar, AFixedLength - Length(AValue)
      ) + AValue
  else
    Result := AValue;
end;
initialization

{$IFDEF WIN32}
  MemComp := MemCompAsm;
{$ELSE}
  MemComp := MemCompPascal;
{$ENDIF}
{$IFDEF MSWINDOWS}
hMsvcrtl := LoadLibrary('msvcrt.dll');
if hMsvcrtl <> 0 then
begin
  VCStrStr := TMSVCStrStr(GetProcAddress(hMsvcrtl, 'strstr'));
  VCStrStrW := TMSVCStrStrW(GetProcAddress(hMsvcrtl, 'wcsstr'));
{$IFDEF WIN64}
  VCMemCmp := TMSVCMemCmp(GetProcAddress(hMsvcrtl, 'memcmp'));
{$ENDIF}
end
else
begin
  VCStrStr := nil;
  VCStrStrW := nil;
{$IFDEF WIN64}
  VCMemCmp := nil;
{$ENDIF}
end;
{$ENDIF}
AppType := 0;

finalization

{$IFDEF MSWINDOWS}
if hMsvcrtl <> 0 then
  FreeLibrary(hMsvcrtl);
{$ENDIF}

end.

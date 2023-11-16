unit qplugins_base;

interface

uses classes, sysutils, {$IFDEF UNICODE}System.Types{$ELSE}types{$ENDIF}, syncobjs;

const
  SQPluginsVersion = '3.1'; { �汾�ţ���ǰΪ3.1�� }
  { ��־���𣺽��� }
  LOG_EMERGENCY: BYTE = 0;
  /// <summary>
  /// ��־����-����
  /// </summary>
  LOG_ALERT = 1;
  /// <summary>
  /// ��־����-��������
  /// </summary>
  LOG_FATAL = 2;
  /// <summary>
  /// ��־����-����
  /// </summary>
  LOG_ERROR = 3;
  /// <summary>
  /// ��־����-����
  /// </summary>
  LOG_WARN = 4;
  /// <summary>
  /// ��־����-��ʾ
  /// </summary>
  LOG_HINT = 5;
  /// <summary>
  /// ��־����-��Ϣ
  /// </summary>
  LOG_MESSAGE = 6;
  /// <summary>
  /// ��־����-������Ϣ
  /// </summary>
  LOG_DEBUG = 7;

  /// <summary>
  /// Ԥ����֪ͨ��ID-������������滻�����ֻ֪ͨ��Ҫ�����ڲ����Ӧ�� <br />
  /// </summary>
  NID_MANAGER_REPLACED = 0;
  /// <summary>
  /// Ԥ����֪ͨ��ID
  /// </summary>
  NID_MANAGER_FREE = 1; // �����������Ҫ�������ͷ�
  /// <summary>
  /// Ԥ����֪ͨ��ID-��������������
  /// </summary>
  NID_LOADERS_STARTING = 2; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-�������������
  /// </summary>
  NID_LOADERS_STARTED = 3; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-������ֹͣ��
  /// </summary>
  NID_LOADERS_STOPPING = 4;
  /// <summary>
  /// Ԥ����֪ͨ��ID-��������ֹͣ
  /// </summary>
  NID_LOADERS_STOPPED = 5;
  /// <summary>
  /// Ԥ����֪ͨ��ID-����������/ֹͣ����
  /// </summary>
  NID_LOADERS_PROGRESS = 6;
  /// <summary>
  /// Ԥ����֪ͨ��ID-���������س���
  /// </summary>
  NID_LOADER_ERROR = 7; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-���ڼ��ز��
  /// </summary>
  NID_PLUGIN_LOADING = 8; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-���ز�����
  /// </summary>
  NID_PLUGIN_LOADED = 9; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-����׼��ж��
  /// </summary>
  NID_PLUGIN_UNLOADING = 10; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-����ж�����
  /// </summary>
  NID_PLUGIN_UNLOADED = 11; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-֪ͨ��Ҫ������
  /// </summary>
  NID_NOTIFY_PROCESSING = 12; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-֪ͨ�Ѿ��������
  /// </summary>
  NID_NOTIFY_PROCESSED = 13; //
  /// <summary>
  /// Ԥ����֪ͨ��ID-�ȴ��ķ����Ѿ�ע�����
  /// </summary>
  NID_SERVICE_READY = 14; //

type
  /// <summary>
  /// ��׼�ӿڽ�����壬�����Ϊ�����������Լ��ݼ���ʱʹ�ã�Delphi ������Ҫʹ�ô˰汾�ӿ�
  /// </summary>
  StandInterfaceResult = Pointer;
  /// <summary>
  /// �첽ִ�лص�ȫ�ֺ����ӿڶ���
  /// </summary>
  TQAsynProcG = procedure(AParams: IInterface); stdcall;
  /// <summary>
  /// �첽�ص��¼����壬�������� Delphi
  /// </summary>
  TQAsynProc = procedure(AParasm: IInterface) of object; // Delphi only

  /// <summary>
  /// ��̬�ֽ�����ӿ�
  /// </summary>
  /// <remarks>
  /// ��̬�ֽ��������ڶ��������ݵĴ����򻺳�������
  /// </remarks>
  IQBytes = interface
    ['{8C570D86-517F-4729-8C5F-427F3F6A414B}']
    /// <summary>
    /// �����ֽ����鳤��
    /// </summary>
    procedure SetLength(const len: DWORD); stdcall;
    /// <summary>
    /// ��ȡ�ֽ����鳤��
    /// </summary>
    function GetLength: DWORD; stdcall;
    /// <summary>
    /// ��ȡָ�����ֽڵ�ֵ
    /// </summary>
    /// <param name="idx">
    /// Ҫ��ȡ���ֽڵ�0��������λ��
    /// </param>
    /// <param name="value">
    /// �ֽ�ֵ
    /// </param>
    /// <returns>
    /// �������λ����Ч������true�������� value ��ֵ�����򷵻�false
    /// </returns>
    function GetByte(const idx: DWORD; var value: BYTE): Boolean; stdcall;
    /// <summary>
    /// ����ָ��λ�õ��ֽ�����
    /// </summary>
    /// <param name="idx">
    /// Ҫ���õ��ֽڵ�0��������λ��
    /// </param>
    /// <param name="value">
    /// Ҫ���õ��ֽ�ֵ
    /// </param>
    /// <returns>
    /// �������λ����Ч�滻������true���������λ����Ч���򷵻�false
    /// </returns>
    function SetByte(const idx: DWORD; const value: BYTE): Boolean; stdcall;
    /// <summary>
    /// ��ȡ�ڲ��������ݵ��׵�ַ
    /// </summary>
    /// <returns>
    /// ���������������ݵ��׵�ַ
    /// </returns>
    function GetData: Pointer; stdcall;
    /// <summary>
    /// �����ڲ����������
    /// </summary>
    /// <param name="len">
    /// ���״�С�����ֽڼ���
    /// </param>
    /// <remarks>
    /// ע������Length������Length ��ʵ�ʴ�������Ч�������ݴ�С��Capacity
    /// �Ǵ�������ռ�õ��ڴ��С��Lengthʼ��С�ڵ���Capacity��
    /// </remarks>
    procedure SetCapacity(const len: DWORD); stdcall;
    /// <summary>
    /// ��ȡ�ڲ����������
    /// </summary>
    /// <returns>
    /// ���ص�ǰ�����ʵ���ڴ��С
    /// </returns>
    function GetCapcacity: DWORD; stdcall;
    /// <summary>
    /// ׷��ָ�����ȵ�����
    /// </summary>
    /// <param name="src">
    /// Դ���ݵ�ַ
    /// </param>
    /// <param name="len">
    /// Ҫ���Ƶ��������ݳ���
    /// </param>
    procedure Append(const src: Pointer; const len: DWORD); stdcall;
    /// <summary>
    /// ��ָ����λ�ÿ�ʼ������ָ�����ȵ�����
    /// </summary>
    /// <param name="idx">
    /// 0������ʼλ��
    /// </param>
    /// <param name="src">
    /// Դ��ַ
    /// </param>
    /// <param name="len">
    /// Ҫ��������ݳ���
    /// </param>
    procedure Insert(const idx: DWORD; const src: Pointer;
      const len: DWORD); stdcall;
    /// <summary>
    /// ��ָ����λ�ÿ�ʼ���滻ָ�����ȵ�����
    /// </summary>
    /// <param name="idx">
    /// 0������ʼλ��
    /// </param>
    /// <param name="src">
    /// Դ��ַ
    /// </param>
    /// <param name="len">
    /// Ҫ�滻�����ݳ���
    /// </param>
    procedure Replace(const idx: DWORD; const src: Pointer;
      const len: DWORD); stdcall;
    /// <summary>
    /// ��ָ����λ�ÿ�ʼ��ɾ���ض����ȵ�����
    /// </summary>
    /// <param name="idx">
    /// 0������ʼλ��
    /// </param>
    /// <param name="Count">
    /// Ҫɾ�������ݳ���
    /// </param>
    procedure Delete(const idx: DWORD; const Count: DWORD); stdcall;
    /// <summary>
    /// ����ָ�������ݵ�Ŀ�껺����
    /// </summary>
    /// <param name="dest">
    /// Ŀ�껺��������ȷ��Ŀ��λ���������㹻�������Ŀ������
    /// </param>
    /// <param name="idx">
    /// ��ʼλ��
    /// </param>
    /// <param name="Count">
    /// Ҫ���Ƶ����ݳ���
    /// </param>
    /// <returns>
    /// ����ʵ�ʸ��Ƶ����ݳ���
    /// </returns>
    function CopyTo(dest: Pointer; const idx, Count: DWORD): DWORD; stdcall;
    /// <summary>
    /// ���ļ��м�����������
    /// </summary>
    /// <param name="fileName">
    /// Դ�ļ���
    /// </param>
    procedure LoadFromFile(const fileName: PWideChar); stdcall;
    /// <summary>
    /// �������ݵ��ļ���
    /// </summary>
    /// <param name="fileName">
    /// Ŀ���ļ���
    /// </param>
    procedure SaveToFile(const fileName: PWideChar); stdcall;
    /// <summary>
    /// ׷�ӵ�Ŀ���ļ���
    /// </summary>
    /// <param name="fileName">
    /// Ŀ���ļ���
    /// </param>
    procedure AppendToFile(const fileName: PWideChar); stdcall;
  end;

  // �������Ͷ���
  // ��
  /// <summary>
  /// ���ӿ�
  /// </summary>
  IQStream = interface
    ['{BCFD2F69-CCB8-4E0B-9FE9-A7D58797D1B8}']
    /// <summary>
    /// �����ж�ȡָ���ֽڵ�����
    /// </summary>
    /// <param name="pv">
    /// Ҫ��Ŷ�ȡ���ݵ�Ŀ���ַ
    /// </param>
    /// <param name="cb">
    /// Ҫ��ȡ���ֽ���
    /// </param>
    /// <returns>
    /// ʵ�ʶ�ȡ���ֽ���
    /// </returns>
    function Read(pv: Pointer; cb: Cardinal): Cardinal; stdcall;
    /// <summary>
    /// д��ָ�����ȵ����ݵ�����
    /// </summary>
    /// <param name="pv">
    /// Ҫд���Դ���ݵ�ַ
    /// </param>
    /// <param name="cb">
    /// Ҫд������ݳ���
    /// </param>
    /// <returns>
    /// ����ʵ��д����ֽ���
    /// </returns>
    function Write(pv: Pointer; cb: Cardinal): Cardinal; stdcall;
    /// <summary>
    /// ��λ����������ָ��λ��
    /// </summary>
    /// <param name="AOffset">
    /// ƫ����
    /// </param>
    /// <param name="AFrom">
    /// ƫ�����ֵ
    /// </param>
    /// <returns>
    /// ���ض�λ���ʵ��λ��
    /// </returns>
    function Seek(AOffset: Int64; AFrom: BYTE): Int64; stdcall;
    /// <summary>
    /// �������Ĵ�С
    /// </summary>
    /// <param name="ANewSize">
    /// �µĴ�С
    /// </param>
    procedure SetSize(ANewSize: UInt64); stdcall;
    /// <summary>
    /// ����һ�����и���ָ�����ȵ����ݵ���ǰ���ĵ�ǰλ��
    /// </summary>
    /// <param name="AStream">
    /// Դ������
    /// </param>
    /// <param name="ACount">
    /// Ҫ���Ƶ����ݳ��ȣ����Ϊ0����������������
    /// </param>
    /// <returns>
    /// ����ʵ�ʸ��Ƶ��ֽ���
    /// </returns>
    function CopyFrom(AStream: IQStream; ACount: Int64): Int64; stdcall;
  end;

  /// <summary>
  /// ������񻯣�����ʹ�ò�ͬ����֮�佻��
  /// </summary>
  TQParamType = (
    /// <summary>
    /// δ֪����
    /// </summary>
    ptUnknown,
    // Integer Types
    /// <summary>
    /// 8λ����
    /// </summary>
    ptInt8,
    /// <summary>
    /// 8λ�޷�������
    /// </summary>
    ptUInt8,
    /// <summary>
    /// 16λ����
    /// </summary>
    ptInt16,
    /// <summary>
    /// 16λ�޷�������
    /// </summary>
    ptUInt16,
    /// <summary>
    /// 32λ��
    /// </summary>
    ptInt32,
    /// <summary>
    /// 32λ�޷�������
    /// </summary>
    ptUInt32,
    /// <summary>
    /// 64λ����
    /// </summary>
    ptInt64,
    /// <summary>
    /// 64λ�޷�������
    /// </summary>
    ptUInt64,
    /// <summary>
    /// ������
    /// </summary>
    ptFloat4,
    /// <summary>
    /// ˫���ȸ�����
    /// </summary>
    ptFloat8, // Float types
    /// <summary>
    /// ����ʱ��
    /// </summary>
    ptDateTime,
    /// <summary>
    /// ʱ����
    /// </summary>
    ptInterval, // DateTime types
    /// <summary>
    /// Ansi ������ַ���
    /// </summary>
    ptAnsiString,
    /// <summary>
    /// UTF8 �����ַ���
    /// </summary>
    ptUtf8String,
    /// <summary>
    /// Unicode 16 LE �����ַ���
    /// </summary>
    ptUnicodeString, // String types
    /// <summary>
    /// ����
    /// </summary>
    ptBoolean, // Boolean
    /// <summary>
    /// ȫ��Ψһ����
    /// </summary>
    ptGuid, // Guid
    /// <summary>
    /// �ֽ���
    /// </summary>
    ptBytes, // Binary
    /// <summary>
    /// ��
    /// </summary>
    ptStream, // ��
    /// <summary>
    /// ����
    /// </summary>
    ptArray, // Array
    /// <summary>
    /// �ӿ�
    /// </summary>
    ptInterface);
  IQParams = interface;

  /// <summary>
  /// �ַ����ӿڣ�����һЩ���ʺ�ֱ��ʹ���ַ���ָ��ĳ���ʹ��
  /// </summary>
  IQString = interface
    ['{B2FB1524-A06D-47F6-AA85-87C2251F2FCF}']
    /// <summary>
    /// �����ַ�������
    /// </summary>
    /// <param name="S">
    /// Դ�ַ���
    /// </param>
    procedure SetValue(const S: PWideChar); stdcall;
    /// <summary>
    /// ��ȡ�ַ�������
    /// </summary>
    /// <returns>
    /// ����Unicode 16 LE ������ַ�������
    /// </returns>
    function GetValue: PWideChar; stdcall;
    /// <summary>
    /// ��ȡ�ַ�������
    /// </summary>
    /// <returns>
    /// ���ص�ǰ���ݳ��ȣ�ע����չ���ַ�ÿ�����س���Ϊ2
    /// </returns>
    function GetLength: Integer; stdcall;
    /// <summary>
    /// �����ַ������ȣ�ע������ǰ�����չ���ַ���ÿ����չ���ַ�����Ϊ2
    /// </summary>
    /// <param name="ALen">
    /// �³���
    /// </param>
    /// <remarks>
    /// ������õĳ��ȴ��ڵ�ǰ���ȣ�����Ĳ��ֽ������Ϊ0����֮�ᱻֱ�ӽض�
    /// </remarks>
    procedure SetLength(ALen: Integer); stdcall;
    property value: PWideChar read GetValue write SetValue;
    property Length: Integer read GetLength write SetLength;
  end;

  /// <summary>
  /// IQString ����չ֧�֣���δȫ��ʵ�֣�����������Ҫʵ��
  /// </summary>
  IQStringEx = interface(IQString)
    ['{54BF45E6-0D9F-4E66-9AA3-87974FB50893}']
    function Left(const AMaxCount: Cardinal; const ACheckExt: Boolean)
      : IQString; stdcall;
    function Right(const AMaxCount: Cardinal; const ACheckExt: Boolean)
      : IQString; stdcall;
    function SubString(const AStart, ACount: Cardinal; const ACheckExt: Boolean)
      : IQString; stdcall;
    function Replace(const oldpat, newpat: PWideChar; AFlags: Integer)
      : Cardinal;
    // Todo:Add more function
  end;

  // ��������
  IQParam = interface
    ['{8641FD44-1BC3-4F04-B730-B5406CDA17E3}']
    /// <summary>
    /// ��ȡ����������
    /// </summary>
    function GetName: PWideChar; stdcall;
    /// <summary>
    /// ��32λ������ʽ��ȡ��ǰ������ֵ
    /// </summary>
    function GetAsInteger: Integer; stdcall;
    /// <summary>
    /// ��32λ������ʽ���õ�ǰ��ֵ
    /// </summary>
    procedure SetAsInteger(const AValue: Integer); stdcall;
    /// <summary>
    /// ��64λ�����ķ�ʽ����ȡ��ǰ������ֵ
    /// </summary>
    function GetAsInt64: Int64; stdcall;
    /// <summary>
    /// ��64λ������ʽ���õ�ǰ������ֵ
    /// </summary>
    procedure SetAsInt64(const AValue: Int64); stdcall;
    /// <summary>
    /// �Բ���ֵ��ȡ��ǰ������ֵ
    /// </summary>
    function GetAsBoolean: Boolean; stdcall;
    /// <summary>
    /// �Բ���ֵ�������õ�ǰ������ֵ
    /// </summary>
    procedure SetAsBoolean(const AValue: Boolean); stdcall;
    /// <summary>
    /// �Ե����ȸ�������������ȡ��ǰ������ֵ
    /// </summary>
    function GetAsSingle: Single; stdcall;
    /// <summary>
    /// �Ե����ȸ��������������õ�ǰ������ֵ
    /// </summary>
    procedure SetAsSingle(const AValue: Single); stdcall;
    /// <summary>
    /// ��˫���ȸ���������ȡ��ǰ������ֵ
    /// </summary>
    function GetAsFloat: Double; stdcall;
    /// <summary>
    /// ��˫���ȸ����������õ�ǰ������ֵ
    /// </summary>
    procedure SetAsFloat(const AValue: Double); stdcall;
    /// <summary>
    /// ���ַ�����ʽ����ȡ��ǰ������ֵ
    /// </summary>
    function GetAsString: IQString; stdcall;
    /// <summary>
    /// ���ַ�����ʽ���õ�ǰ������ֵ
    /// </summary>
    procedure SetAsString(const AValue: IQString); stdcall;
    /// <summary>
    /// ��GUID��������ȡ��ǰ������ֵ
    /// </summary>
    function GetAsGuid: TGuid; stdcall;
    /// <summary>
    /// ��GUID�������õ�ǰ������ֵ
    /// </summary>
    procedure SetAsGuid(const value: TGuid); stdcall;
    /// <summary>
    /// ��ȡ�ֽ����͵��������ݵ�Ŀ�껺������
    /// </summary>
    /// <param name="ABuf">
    /// ��������ַ
    /// </param>
    /// <param name="ABufLen">
    /// ��������С
    /// </param>
    /// <returns>
    /// ����ʵ�������ֽ���
    /// </returns>
    function GetAsBytes(ABuf: PByte; ABufLen: Cardinal): Cardinal;
      overload; stdcall;
    /// <summary>
    /// ��ָ���ĵ�ַ�����ֽ����͵���������
    /// </summary>
    /// <param name="ABuf">
    /// Դ������
    /// </param>
    /// <param name="ABufLen">
    /// ���ݳ���
    /// </param>
    procedure SetAsBytes(ABuf: PByte; ABufLen: Cardinal); overload; stdcall;
    /// <summary>
    /// �жϵ�ǰ���������Ƿ��ǿգ�δ����ֵ��
    /// </summary>
    function GetIsNull: Boolean; stdcall;
    /// <summary>
    /// ���õ�ǰ��������Ϊ��
    /// </summary>
    procedure SetNull; stdcall;
    /// <summary>
    /// �����鷽ʽ����ȡ�Ӳ����б����
    /// </summary>
    /// <remarks>
    /// ���������ͱ�����ptArray
    /// </remarks>
    function GetAsArray: IQParams; stdcall;
    /// <summary>
    /// �����ķ�ʽ��ȡ��ǰ������ֵ
    /// </summary>
    /// <returns>
    /// ���ع�����������
    /// </returns>
    function GetAsStream: IQStream; stdcall;
    /// <summary>
    /// ���õ�ǰ����������������
    /// </summary>
    procedure SetAsStream(AStream: IQStream); stdcall;
    /// <summary>
    /// ��ȡ��ǰ�����������ĸ��б�
    /// </summary>
    function GetParent: IQParams; overload; stdcall;
    /// <summary>
    /// ��ȡ��ǰ����������
    /// </summary>
    function GetType: TQParamType; stdcall;
    /// <summary>
    /// �޸ĵ�ǰ����������
    /// </summary>
    procedure SetType(const AType: TQParamType); stdcall;
    /// <summary>
    /// ��ȡ��ǰ�����Ľӿ����͵�ֵ
    /// </summary>
    function GetAsInterface: IInterface; overload; stdcall;
    /// <summary>
    /// ���õ�ǰ�����Ľӿ����͵�ֵ
    /// </summary>
    procedure SetAsInterface(const AIntf: IInterface); stdcall;
    /// <summary>
    /// ��ȡ��ǰ�����ڸ��б��е�����
    /// </summary>
    function GetIndex: Integer; stdcall;
    /// <summary>
    /// ��ȡ��ǰ�ֽ��������͵�����
    /// </summary>
    function GetAsBytes: IQBytes; overload; stdcall;
    /// <summary>
    /// ���õ�ǰ�ֽ��������͵Ĳ�������
    /// </summary>
    procedure SetAsBytes(const ABytes: IQBytes); overload; stdcall;
    // ����Ĵ���Ϊ�˼����������Լ���
    function _GetAsArray: StandInterfaceResult; stdcall;
    function _GetAsStream: StandInterfaceResult; stdcall;
    function _GetParent: StandInterfaceResult; overload; stdcall;
    function _GetAsInterface: StandInterfaceResult; overload; stdcall;
    function _GetAsBytes: StandInterfaceResult; overload; stdcall;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsGuid: TGuid read GetAsGuid write SetAsGuid;
    property IsNull: Boolean read GetIsNull;
    property Name: PWideChar read GetName;
    property AsArray: IQParams read GetAsArray;
    property AsStream: IQStream read GetAsStream write SetAsStream;
    property AsString: IQString read GetAsString write SetAsString;
    property Parent: IQParams read GetParent;
    property ParamType: TQParamType read GetType;
    property AsInterface: IInterface read GetAsInterface write SetAsInterface;
    property Index: Integer read GetIndex;
  end;

  /// <summary>
  /// �����б�ӿڣ����ڹ���������
  /// </summary>
  IQParams = interface
    ['{B5746B65-7586-4DED-AE20-D4FF9B6ECD9E}']
    /// <summary>
    /// ��ȡָ�������Ĳ���
    /// </summary>
    /// <param name="AIndex">
    /// Ҫ��ȡ�Ĳ�������
    /// </param>
    function GetItems(AIndex: Integer): IQParam; overload; stdcall;
    /// <summary>
    /// ��ȡ�б��еĲ�������
    /// </summary>
    function GetCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ�����ƵĲ���
    /// </summary>
    /// <param name="AName">
    /// Ҫ��ȡ�Ĳ������ƣ����ִ�Сд
    /// </param>
    /// <returns>
    /// �ҵ������ظ�ʵ����δ�ҵ������ؿ�
    /// </returns>
    function ByName(const AName: PWideChar): IQParam; stdcall;
    /// <summary>
    /// ��ȡָ��·���Ĳ���
    /// </summary>
    /// <param name="APath">
    /// ����·��������֮��ͨ��/�ָ���ע���������ִ�Сд
    /// </param>
    function ByPath(APath: PWideChar): IQParam; stdcall;
    /// <summary>
    /// ���һ������
    /// </summary>
    /// <param name="AName">
    /// ��������
    /// </param>
    /// <param name="AParamType">
    /// ��������
    /// </param>
    function Add(const AName: PWideChar; AParamType: TQParamType): IQParam;
      overload; stdcall;
    /// <summary>
    /// ���һ���б���Ϊ����
    /// </summary>
    /// <param name="AName">
    /// ��������
    /// </param>
    /// <param name="AChildren">
    /// Ҫ���ƵĲ�����Դ
    /// </param>
    /// <remarks>

    /// �������������ֱ�ӽ�AChildren��Ϊ�ӽ�㣬���Ǵ������ĸ���Ʒ������AChildren��ʹ����ɺ���Լ��ͷš�������������������ӿڵ����͵Ĳ��������ֱ��ʹ����Ӧ�Ľӿڡ�
    /// </remarks>
    function Add(const AName: PWideChar; AChildren: IQParams): IQParam;
      overload; stdcall;
    /// <summary>
    /// �������б����ַ���������
    /// </summary>
    /// <remarks>
    /// ���ص��ַ�������ΪJSON��ʽ
    /// </remarks>
    function GetAsString: IQString; stdcall;
    /// <summary>
    /// ɾ��ָ�������Ĳ���
    /// </summary>
    /// <param name="AIndex">
    /// Ҫɾ���Ĳ���������
    /// </param>
    procedure Delete(AIndex: Integer); stdcall;
    /// <summary>
    /// ������еĲ���
    /// </summary>
    procedure Clear; stdcall;
    /// <summary>
    /// ����ָ������������
    /// </summary>
    /// <param name="AParam">
    /// Ҫ���Ĳ���
    /// </param>
    /// <returns>
    /// ����ʵ�ʵ�����ֵ�����δ�ҵ�����-1
    /// </returns>
    function IndexOf(const AParam: IQParam): Integer; stdcall;
    /// <summary>
    /// ���������浽���� <br />
    /// </summary>
    /// <param name="AStream">
    /// Ŀ��������
    /// </param>
    procedure SaveToStream(AStream: IQStream); stdcall;
    /// <summary>
    /// �����м��ز����б�
    /// </summary>
    /// <param name="AStream">
    /// ����Դ��
    /// </param>
    procedure LoadFromStream(AStream: IQStream); stdcall;
    /// <summary>
    /// ��������б����ݵ��ļ�
    /// </summary>
    /// <param name="AFileName">
    /// Ŀ���ļ���
    /// </param>
    procedure SaveToFile(const AFileName: PWideChar); stdcall;
    /// <summary>
    /// ���ļ��м��ز����б�
    /// </summary>
    /// <param name="AFileName">
    /// Դ�ļ���
    /// </param>
    procedure LoadFromFile(const AFileName: PWideChar); stdcall;

    function _GetItems(AIndex: Integer): StandInterfaceResult;
      overload; stdcall;
    function _ByName(const AName: PWideChar): StandInterfaceResult; stdcall;
    function _ByPath(APath: PWideChar): StandInterfaceResult; stdcall;
    function _Add(const AName: PWideChar; AParamType: TQParamType)
      : StandInterfaceResult; overload; stdcall;
    function _Add(const AName: PWideChar; AChildren: IQParams)
      : StandInterfaceResult; overload; stdcall;
    function _GetAsString: StandInterfaceResult; stdcall;

    property Items[AIndex: Integer]: IQParam read GetItems; default;
    property Count: Integer read GetCount;
    property AsString: IQString read GetAsString;
  end;

  /// <summary>
  /// �汾��Ϣ,Major Ϊ���汾�ţ�MinorΪ���汾�ţ�ReleaseΪ�����汾�ţ�BuildΪ�����汾�ţ�ÿ�������ܴ���255
  /// </summary>
  TQShortVersion = packed record
    case Integer of
      0:
        (Major, Minor, Release, Build: BYTE
        ); // �������������������İ汾��
      1:
        (value: Integer);
  end;
{$IF RTLVersion>=21}
{$M+}
{$IFEND}

  /// <summary>
  /// �����Ĳ���汾��Ϣ�ṹ
  /// </summary>
  TQVersion = packed record
    /// <summary>
    /// �汾
    /// </summary>
    Version: TQShortVersion; //
    /// <summary>
    /// �ṩ����Ĺ�˾��
    /// </summary>
    Company: array [0 .. 63] of WideChar; //
    /// <summary>
    /// ģ������
    /// </summary>
    Name: array [0 .. 63] of WideChar; //
    /// <summary>
    /// ����
    /// </summary>
    Description: array [0 .. 255] of WideChar; //
    /// <summary>
    /// ԭʼ�ļ���
    /// </summary>
    FileName: array [0 .. 259] of WideChar; //
  end;

  //
  /// <summary>
  /// �汾��Ϣ�ӿ�
  /// </summary>
  IQVersion = interface
    ['{4AD82500-4148-45D1-B0F8-F6B6FB8B7F1C}']
    /// <summary>
    /// ��ȡ�汾��Ϣ
    /// </summary>
    /// <param name="AVerInfo">
    /// ���ڷ��ذ汾��Ϣ�Ľṹ��
    /// </param>
    /// <returns>
    /// ���������а汾��Ϣ���򷵻�true�����򷵻�false
    /// </returns>
    function GetVersion(var AVerInfo: TQVersion): Boolean; stdcall;
  end;

  IQServices = interface;
  IQLoader = interface;

  /// <summary>
  /// ������չ��ʵ���ӿ�
  /// </summary>
  /// <remarks>
  /// �������һ��������ӿڱ������GetInstance����������Ϊ�������չ����ֻҪ��̳���IUnknown(Ҳ��IInterface)��������Ҫ������ж���ȷ���Ƿ�ֱ�ӷ�������ʵ������
  /// </remarks>
  IQMultiInstanceExtension = interface
    ['{A13CADF7-96EE-4B95-B3CA-1476EBC19A41}']
    function GetInstance(var AResult: IInterface): Boolean; stdcall;
  end;

  /// <summary>
  /// ��ͨ����ӿڶ���
  /// </summary>
  /// <remarks>
  /// ��ͨ�����������ĳ���ض��Ĺ��ܡ�һ���������ע�� n ������n&gt;=0����ÿ����������Ҫ�ṩ IQService
  /// ��ص���Ϣ���Ա���й���
  /// </remarks>
  IQService = interface
    ['{0DA5CBAC-6AB0-49FA-B845-FDF493D9E639}']
    /// <summary>
    /// ��ȡ�����ṩ�����ʵ��
    /// </summary>
    /// <returns>
    /// ���������ṩ�����ʵ��������ǵ�ʵ�������򷵻���������Ƕ�ʵ��������ᴴ��һ���µ�ʵ�������ṩʵ�ʵķ���
    /// </returns>
    function GetInstance: IQService; stdcall;
    /// <summary>
    /// ��ȡ�����ṩ��ģ����
    /// </summary>
    /// <returns>
    /// ����ģ������ͬһ�����������ͬһ������ṩ�ķ���
    /// </returns>
    /// <remarks>

    /// �������ľ��庬��ȡ���ڶ�Ӧ�ļ��������������DLL/SO���͵Ĳ���������ǵ���LoadLibrary���صľ��������BPL��������LoadPackage���صľ��
    /// </remarks>
    function GetOwnerInstance: THandle; stdcall;
    /// <summary>
    /// ִ�з��񲢽�������ص�AResult��
    /// </summary>
    /// <param name="AParams">
    /// ���ݸ�����Ĳ���
    /// </param>
    /// <param name="AResult">
    /// ����ķ���ֵ
    /// </param>
    /// <returns>
    /// ִ�гɹ�������true��ִ��ʧ�ܣ�����false
    /// </returns>
    /// <remarks>
    /// ʵ�ʷ��񲢲�һ����ͨ������ӿ����ṩ����ķ��񣬶��ڲ�֧�ֵķ��񣬻�ֱ�ӷ���false�����ǻ�ͨ��ֱ��֧�������ӿڵķ�ʽ���ṩ����ķ���
    /// </remarks>
    function Execute(AParams: IQParams; AResult: IQParams): Boolean; stdcall;
    /// <summary>
    /// ��ͣ����
    /// </summary>
    /// <param name="AParams">
    /// ��ͣ�������
    /// </param>
    /// <returns>
    /// �ɹ������� true��ʧ�ܻ���֧�֣�����false
    /// </returns>
    function Suspended(AParams: IQParams): Boolean; stdcall;
    /// <summary>
    /// �ָ���ǰ����ִ��
    /// </summary>
    /// <param name="AParams">
    /// �ָ��������
    /// </param>
    /// <returns>
    /// ���������ɺ������ִ��״̬���򷵻�true�����򷵻�false
    /// </returns>
    function Resume(AParams: IQParams): Boolean; stdcall;
    /// <summary>
    /// ��ȡ�����������ĸ������б�ӿ�ʵ��
    /// </summary>
    function GetParent: IQServices; stdcall;
    /// <summary>
    /// ��ȡ����Ĵ����߷���ӿ�ʵ��
    /// </summary>
    /// <returns>
    /// ���ط���Ĵ����߷���
    /// </returns>
    /// <remarks>

    /// ���ڶ�ʵ�������䴴���߱�ע�ᵽQPlugins��һ���������ʱ��
    /// ͨ��GetInstance�ᴴ��һ����ʵ���������ʵ���ķ��񴴽��߾���ע�ᵽ
    /// QPlugins�еķ��񴴽��߽ӿ�ʵ��
    /// </remarks>
    function GetInstanceCreator: IQService; stdcall;
    /// <summary>
    /// Ϊ�������һ��������չ
    /// </summary>
    /// <param name="AInterface">
    /// Ҫ��ӵ��·���ӿ�ʵ��
    /// </param>
    /// <remarks>
    /// 1��������չ��ҪΪ������չ�¹��ܣ����Ҫ֧�ֶ�ʵ������Ҫʵ��IQMultiInstanceExtension�ӿڣ� <br />
    /// 2�����Ҫͨ����չʵ�ַ�������滻��������QueryInterface ʵ��Ӧ���ȼ����չ���Ƿ��ṩ����Ӧ�ӿڵ�ʵ�֣� <br />
    /// 3����������滻�������滻����ִ�еķ��񣬶�ֻ�Ժ���������Ч��Ҫ�Ե�ǰʹ���з�����Ч������Ҫ������֧�֣�
    /// </remarks>
    procedure AddExtension(AInterface: IInterface); stdcall;

    /// <summary>
    /// �Ƴ�һ���Ѿ�ע�����չ
    /// </summary>
    procedure RemoveExtension(AInterface: IInterface); stdcall;
    /// <summary>
    /// ���÷���ĸ������б�
    /// </summary>
    procedure SetParent(AParent: IQServices); stdcall;
    /// <summary>
    /// ��ȡ��������
    /// </summary>
    function GetName: PWideChar; stdcall;
    /// <summary>
    /// ��ȡ�������չ����
    /// </summary>
    function GetAttrs: IQParams; stdcall;
    /// <summary>
    /// ��ȡĩ�δ�����Ϣ����
    /// </summary>
    function GetLastErrorMsg: PWideChar; stdcall;
    /// <summary>
    /// ��ȡĩ�δ������
    /// </summary>
    function GetLastErrorCode: Cardinal; stdcall;
    /// <summary>
    /// ��ȡ�����ID
    /// </summary>
    function GetId: TGuid; stdcall;
    /// <summary>
    /// �������ļ�����
    /// </summary>
    /// <remarks>
    /// ����δ����ͨ��������ע��ģ�����������ǣ���ôҲ��û�м�������GetLoader��ʱ���ؿգ�
    /// </remarks>
    function GetLoader: IQLoader; stdcall;
    /// <summary>
    /// ��ȡ�����ʵ��ԭ�������ַ
    /// </summary>
    function GetOriginObject: Pointer; stdcall;
    /// <summary>
    /// �жϵ�ǰ�����Ƿ���ָ����ģ���ṩ
    /// </summary>
    function IsInModule(AModule: THandle): Boolean; stdcall;
    procedure _GetId(AId: PGuid); stdcall;
    function _GetInstance: StandInterfaceResult; stdcall;
    function _GetParent: StandInterfaceResult; stdcall;
    function _GetInstanceCreator: StandInterfaceResult; stdcall;
    function _GetAttrs: StandInterfaceResult; stdcall;

    property Parent: IQServices read GetParent write SetParent;
    property Name: PWideChar read GetName;
    property Attrs: IQParams read GetAttrs;
    property LastError: Cardinal read GetLastErrorCode;
    property LastErrorMsg: PWideChar read GetLastErrorMsg;
    property Loader: IQLoader read GetLoader;
    property Creator: IQService read GetInstanceCreator;
  end;

  //
  /// <summary>
  /// �����б�ӿڣ����ڹ������������̳���IQService�������˹�����صĹ���
  /// </summary>
  IQServices = interface(IQService)
    ['{7325DF17-BC83-4163-BB72-0AE0208352ED}']
    /// <summary>
    /// ��ȡָ�������ķ���ӿ�ʵ��
    /// </summary>
    function GetItems(AIndex: Integer): IQService; stdcall;
    /// <summary>
    /// ��ȡ�б����ܵķ�������
    /// </summary>
    function GetCount: Integer; stdcall;
    /// <summary>
    /// ͨ��·����ȡָ���ķ���ӿ�ʵ��
    /// </summary>
    /// <param name="APath">
    /// ����·�����м���/�ָ��������ִ�Сд
    /// </param>
    /// <returns>
    /// ���ؿ��������ṩ�����ʵ����Ҳ���������Ϊ�գ�������÷����GetInstance����ȡ�����ṩ�����ʵ��
    /// </returns>
    function ByPath(APath: PWideChar): IQService; stdcall;
    /// <summary>
    /// ͨ������ӿ�ID��ȡ����ӿ�ʵ��
    /// </summary>
    /// <param name="AId">
    /// ����ӿ�ID
    /// </param>
    /// <param name="ADoGetInstance">
    /// �Ƿ���÷����GetInstance����ȡ��ʵ��
    /// </param>
    /// <returns>
    /// ���ؽӿڷ���ʵ��������Ƕ�ʵ������ADoGetInstanceΪtrue���򷵻�һ����ʵ��
    /// </returns>
    function ById(const AId: TGuid; ADoGetInstance: Boolean = true)
      : IQService; stdcall;
    /// <summary>
    /// ���һ���ӷ���ӿ�ʵ��
    /// </summary>
    /// <param name="AItem">
    /// Ҫ����ӷ���
    /// </param>
    /// <returns>
    /// ������ӵķ���ӿڵ�����
    /// </returns>
    function Add(AItem: IQService): Integer; stdcall;
    /// <summary>
    /// ��ȡָ�������ڸ��е�����
    /// </summary>
    /// <param name="AItem">
    /// Ҫ��ѯ�ķ���ӿ�ʵ��
    /// </param>
    /// <returns>
    /// �ҵ�������ʵ�ʵ�������δ�ҵ�����-1
    /// </returns>
    function IndexOf(AItem: IQService): Integer; stdcall;
    /// <summary>
    /// ɾ��ָ�������ķ���ӿ�ʵ��
    /// </summary>
    /// <param name="AIndex">
    /// ����ӿ�ʵ������
    /// </param>
    procedure Delete(AIndex: Integer); stdcall;
    /// <summary>
    /// �Ӹ����Ƴ�ָ���ķ���ӿ�ʵ��
    /// </summary>
    /// <param name="AItem">
    /// Ҫ�Ƴ��ķ���ӿ�ʵ��
    /// </param>
    procedure Remove(AItem: IQService); stdcall;
    /// <summary>
    /// �������ָ��������λ���ƶ�����λ��
    /// </summary>
    /// <param name="AIndex">
    /// ԭλ��
    /// </param>
    /// <param name="ANewIndex">
    /// ��λ��
    /// </param>
    /// <returns>
    /// �ɹ�������true��λ����Ч���� false
    /// </returns>
    function MoveTo(AIndex, ANewIndex: Integer): Boolean; stdcall;
    /// <summary>
    /// ������еĽӿ�ʵ��
    /// </summary>
    procedure Clear; stdcall;
    //
    function _GetItems(AIndex: Integer): StandInterfaceResult; stdcall;
    function _ByPath(APath: PWideChar): StandInterfaceResult; stdcall;
    function _ById(const AId: TGuid; ADoGetInstance: Boolean = true)
      : StandInterfaceResult; stdcall;

    property Name: PWideChar read GetName;
    property Parent: IQServices read GetParent;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: IQService read GetItems; default;
  end;

  /// <summary>
  /// ֪ͨ��Ӧ�ӿڣ���עĳ��֪ͨʱ��Ӧʵ��IQNotify�ӿڣ��Ա������ص�֪ͨ
  /// </summary>
  IQNotify = interface
    ['{00C7F80F-44BF-4E60-AA58-5992B2B71754}']

    /// <summary>
    /// ��֪ͨ����ʱ��֪ͨ��Ӧ�����ӿ�
    /// </summary>
    /// <param name="AId">
    /// ֪ͨID
    /// </param>
    /// <param name="AParams">
    /// ֪ͨ����
    /// </param>
    /// <param name="AFireNext">
    /// �Ƿ����������һ��֪ͨ
    /// </param>
    procedure Notify(const AId: Cardinal; AParams: IQParams;
      var AFireNext: Boolean); stdcall;
  end;

  /// <summary>
  /// ö�ٶ����߻ص�����
  /// </summary>
  /// <remarks>
  /// ANotify�Ƕ����ߣ�AParam�ǵ���ʱ������û��Զ��������AContinue �����Ƿ����ö��
  /// </remarks>
  TQSubscribeEnumCallback = procedure(ANotify: IQNotify; AParam: Int64;
    var AContinue: Boolean); stdcall;

  /// <summary>
  /// ֪ͨ�㲥�ӿڣ����ڹ㲥ĳ���̶�ID��֪ͨ
  /// </summary>
  IQNotifyBroadcast = interface
    ['{3AE4FD5D-7F13-479D-94C2-4813CD283F82}']
    /// <summary>
    /// ���һ����Ӧ��
    /// </summary>
    /// <param name="ANotify">
    /// Ҫ��ӵ���Ӧ��
    /// </param>
    function Add(ANotify: IQNotify): Integer; stdcall;
    /// <summary>
    /// �Ƴ�һ����Ӧ��
    /// </summary>
    /// <param name="ANotify">
    /// Ҫ�Ƴ�����Ӧ��
    /// </param>
    procedure Remove(ANotify: IQNotify); stdcall;
    /// <summary>
    /// ������е���Ӧ��
    /// </summary>
    procedure Clear; stdcall;
    /// <summary>
    /// ����֪ͨ���ȴ�֪ͨ�������
    /// </summary>
    /// <param name="AParams">
    /// ֪ͨ����
    /// </param>
    procedure Send(AParams: IQParams); stdcall;
    /// <summary>
    /// Ͷ��һ��֪ͨ
    /// </summary>
    /// <param name="AParams">
    /// ֪ͨ����
    /// </param>
    procedure Post(AParams: IQParams); stdcall;
    /// <summary>
    /// ö��ָ��֪ͨ�����ж�����
    /// </summary>
    /// <param name="ACallback">
    /// �ص�����
    /// </param>
    /// <param name="AParam">
    /// ������û��Զ���������ᴫ�ݸ�ACallback��AParam
    /// </param>
    /// <returns>
    /// ����ö�ٵĶ���������
    /// </returns>
    /// <remarks>
    /// ע�ⷵ�ص���������һ����ʵ�ʵĶ�������������� ACallback ������ʱ��AContinue ����������Ϊ
    /// false�������ֹö�٣���ʱ���ص���ʵ���Ѿ�ö�ٵ�������
    /// </remarks>
    function EnumSubscribe(ACallback: TQSubscribeEnumCallback; AParam: Int64)
      : Integer; stdcall;
  end;

  IQNotifyBroadcast2 = interface(IQNotifyBroadcast)
    ['{A6D51A69-6588-4513-B9F9-45314840FF3D}']
    /// <summary>
    /// ���һ����Ӧ�߲���������Ϊ�׸���Ӧ��
    /// </summary>
    /// <param name="ANotify">
    /// Ҫ��ӵ���Ӧ��
    /// </param>
    function AddFirst(ANotify: IQNotify): Integer; stdcall;
    function GetNotifyId: Integer; stdcall;
  end;

  //
  /// <summary>
  /// ֪ͨ�����������ڲ�ά�����֪ͨ�Ͷ����߶���
  /// </summary>
  IQNotifyManager = interface
    ['{037DCCD1-6877-4917-A315-120CD3E403F4}']
    /// <summary>
    /// ����һ��֪ͨ
    /// </summary>
    /// <param name="ANotifyId">
    /// ֪ͨ��ID
    /// </param>
    /// <param name="AHandler">
    /// ֪ͨ������
    /// </param>
    /// <returns>
    /// ���ĳɹ������� true������ʧ�ܣ�����false
    /// </returns>
    function Subscribe(ANotifyId: Cardinal; AHandler: IQNotify)
      : Boolean; stdcall;
    /// <summary>
    /// ȡ��һ������
    /// </summary>
    /// <param name="ANotifyId">
    /// ֪ͨID
    /// </param>
    /// <param name="AHandler">
    /// ֪ͨ������
    /// </param>
    procedure Unsubscribe(ANotifyId: Cardinal; AHandler: IQNotify); stdcall;
    /// <summary>
    /// ����ָ�����Ƶ�֪ͨID
    /// </summary>
    /// <param name="AName">
    /// ֪ͨ����
    /// </param>
    /// <returns>
    /// ����֪ͨID
    /// </returns>
    /// <remarks>
    /// ���ָ����֪ͨ����û�ж��壬���Զ����һ�������Ʋ�����ID�����ָ�����Ƶ�ID�Ѿ����ڣ��򷵻�ԭ����ID
    /// </remarks>
    function IdByName(const AName: PWideChar): Cardinal; stdcall;
    /// <summary>
    /// ��ȡָ��֪ͨID������
    /// </summary>
    /// <param name="AId">
    /// ֪ͨID
    /// </param>
    /// <returns>
    /// ����֪ͨ������
    /// </returns>
    function NameOfId(const AId: Cardinal): PWideChar; stdcall;
    /// <summary>
    /// Ͷ��һ��֪ͨ���ȴ������������
    /// </summary>
    /// <param name="AId">
    /// ֪ͨID
    /// </param>
    /// <param name="AParams">
    /// ֪ͨ�ĸ��Ӳ���
    /// </param>
    procedure Send(AId: Cardinal; AParams: IQParams); stdcall;
    /// <summary>
    /// Ͷ��һ��֪ͨ
    /// </summary>
    /// <param name="AId">
    /// ֪ͨID
    /// </param>
    /// <param name="AParams">
    /// ֪ͨ�ĸ��Ӳ���
    /// </param>
    procedure Post(AId: Cardinal; AParams: IQParams); stdcall;
    /// <summary>
    /// ������е�֪ͨ������
    /// </summary>
    procedure Clear;

    /// <summary>
    /// ö��ָ��֪ͨ�����ж�����
    /// </summary>
    /// <param name="ANotifyId">
    /// ֪ͨID
    /// </param>
    /// <param name="ACallback">
    /// ֪ͨö�ٻص�����
    /// </param>
    /// <param name="AParam">
    /// �û���ӵĶ��⸽�Ӳ������ᴫ�� ACallback ��AParam
    /// </param>
    function EnumSubscribe(ANotifyId: Cardinal;
      ACallback: TQSubscribeEnumCallback; AParam: Int64): Integer; stdcall;
    /// <summary>
    /// �Ѿ�ע���֪ͨ����
    /// </summary>
    function GetCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ��������֪ͨID
    /// </summary>
    function GetId(const AIndex: Integer): Cardinal; stdcall;
    /// <summary>
    /// ��ȡָ��������֪ͨ������
    /// </summary>
    function GetName(const AIndex: Integer): PWideChar; stdcall;
    /// <summary>
    /// �ж�ָ��ID��֪ͨ�Ƿ��ж�����
    /// </summary>
    /// <param name="AId">
    /// ֪ͨID
    /// </param>
    function HasSubscriber(const AId: Cardinal): Boolean; stdcall;
    property Count: Integer read GetCount;
    property Id[const AIndex: Integer]: Cardinal read GetId;
    property Name[const AIndex: Integer]: PWideChar read GetName;
  end;

  /// <summary>
  /// ģ��״̬
  /// </summary>
  TQModuleState = (
    /// <summary>
    /// ״̬δ֪
    /// </summary>
    msUnknown,
    /// <summary>
    /// ���ڼ�����
    /// </summary>
    msLoading,
    /// <summary>
    /// �Ѿ��������
    /// </summary>
    msLoaded,
    /// <summary>
    /// ����ж��
    /// </summary>
    msUnloading);
  /// <summary>
  /// ������״̬
  /// </summary>
  TQLoaderState = (
    /// <summary>
    /// ����
    /// </summary>
    lsIdle,
    /// <summary>
    /// ���ڼ���
    /// </summary>
    lsLoading,
    /// <summary>
    /// ����ж��
    /// </summary>
    lsUnloading);

  /// <summary>
  /// �������ӿڣ�����ʵ�ּ��ز�ͬ���͵ķ���
  /// </summary>
  IQLoader = interface(IQService)
    ['{3F576A14-D251-47C4-AB6E-0F89B849B71F}']
    /// <summary>
    /// ��ȡ�������Դ
    /// </summary>
    /// <param name="AService">
    /// ����ʵ��
    /// </param>
    /// <param name="ABuf">
    /// ���ڴ����Դ�Ļ�����
    /// </param>
    /// <param name="ALen">
    /// ��������С
    /// </param>
    /// <returns>
    /// ����ʵ��ʹ�õĻ�������С
    /// </returns>
    function GetServiceSource(AService: IQService; ABuf: PWideChar;
      ALen: Integer): Integer; stdcall;
    /// <summary>
    /// ��ʼ��������֧�ֵĲ��
    /// </summary>
    procedure Start; stdcall;
    /// <summary>
    /// ж�������Ѿ����صĲ��
    /// </summary>
    procedure Stop; stdcall;
    /// <summary>
    /// ����ָ���ļ����Ĳ���ṩ�����з���
    /// </summary>
    /// <param name="AFileName">
    /// ����ļ���
    /// </param>
    /// <returns>
    /// �����ļ�����Ӧ��ģ����
    /// </returns>
    function LoadServices(const AFileName: PWideChar): THandle;
      stdcall; overload;
    /// <summary>
    /// �����м��ز��
    /// </summary>
    /// <param name="AStream">
    /// ������ڵ�������
    /// </param>
    /// <returns>
    /// ���������غ��ģ����
    /// </returns>
    function LoadServices(const AStream: IQStream): THandle; stdcall; overload;
    /// <summary>
    /// ж��ָ���Ĳ��
    /// </summary>
    /// <param name="AHandle">
    /// Ҫж�صĲ�����
    /// </param>
    /// <param name="AWaitDone">
    /// �Ƿ�ȴ����ж�����
    /// </param>
    /// <returns>
    /// �ɹ������� true��ʧ�ܣ����� false
    /// </returns>
    /// <remarks>
    /// �����һ��������ṩ�ķ�����ж�ز������AWaitDone ������������Ϊ false���Ա������� <br />
    /// </remarks>
    function UnloadServices(const AHandle: THandle; AWaitDone: Boolean = true)
      : Boolean; stdcall;
    /// <summary>
    /// ��ȡ���ص�ģ������
    /// </summary>
    function GetModuleCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ��������ģ������
    /// </summary>
    function GetModuleName(AIndex: Integer): PWideChar; stdcall;
    /// <summary>
    /// ��ȡָ��������ģ����
    /// </summary>
    function GetModules(AIndex: Integer): HMODULE; stdcall;
    /// <summary>
    /// ��ȡģ���״̬
    /// </summary>
    function GetModuleState(AInstance: HINST): TQModuleState; stdcall;
    /// <summary>
    /// ���õ�ǰ���ص�ģ��
    /// </summary>
    procedure SetLoadingModule(AInstance: HINST); stdcall;
    /// <summary>
    /// ��ȡ���ڼ��ص�ģ���ļ���
    /// </summary>
    function GetLoadingFileName: PWideChar; stdcall;
    /// <summary>
    /// ��ȡ���ڼ��ص�ģ����
    /// </summary>
    function GetLoadingModule: HINST; stdcall;
    /// <summary>
    /// ��ȡ��ǰ������״̬
    /// </summary>
    function GetState: TQLoaderState; stdcall;
  end;

  /// <summary>
  /// ��־�ӿڣ�һ���������ṩ���������ֻ��ͨ�� Post �ӿ�Ͷ����־��
  /// </summary>
  /// <remarks>
  /// QPlugins Ĭ�ϲ�û��ʵ����־�ӿڣ� �����ֱ���� QLog ʵ�ָýӿڲ�ע��Ϊ��־����
  /// </remarks>
  IQLog = interface(IQService)
    ['{14F4C543-2D43-4AAD-BAFE-B25784BC917D}']
    /// <summary>
    /// Ͷ��һ����־
    /// </summary>
    /// <param name="ALevel">
    /// ��־��¼����
    /// </param>
    /// <param name="AMsg">
    /// ��־��Ϣ����
    /// </param>
    procedure Post(ALevel: BYTE; AMsg: PWideChar); stdcall;
    /// <summary>
    /// ǿ����־д��
    /// </summary>
    procedure Flush; stdcall;
  end;

  // QWorker�ӿڷ�װ
  /// <summary>
  /// QWorker ��ҵ����ɻص��ӿ�
  /// </summary>
  IQNotifyCallback = interface
    ['{8039F16A-0D0C-42C9-B891-454935371ACE}']
    /// <summary>
    /// ֪ͨ��Ӧ�¼�
    /// </summary>
    /// <param name="ASender">
    /// ֪ͨ�����ߣ�һ��Ϊ��Ӧ��JobGroup�ӿ�ʵ��
    /// </param>
    procedure DoNotify(ASender: IInterface); stdcall;
  end;

  /// <summary>
  /// QWorker ��ҵ�ص��ӿ�
  /// </summary>
  IQJobCallback = interface
    ['{886BE1F7-3365-4F81-9CEA-742EBD833584}']
    /// <summary>
    /// ��ҵʵ��ִ�нӿ�
    /// </summary>
    /// <param name="AParams">
    /// ���ݸ���ҵ�Ĳ���
    /// </param>
    procedure DoJob(AParams: IQParams); stdcall;
    /// <summary>
    /// ��ҵ���ʱ�����õĽӿ�
    /// </summary>
    procedure AfterDone; stdcall;
    /// <summary>
    /// ����ҵȡ��֮ǰ����
    /// </summary>
    procedure BeforeCancel; stdcall;
  end;

  /// <summary>
  /// For ������ҵ����ӿ�
  /// </summary>
  IQForJobManager = interface
    ['{F67881A5-92C6-4656-8073-C58E4DA43BF7}']
    /// <summary>
    /// �ж�ѭ��
    /// </summary>
    procedure BreakIt; stdcall;
    /// <summary>
    /// ��ȡ��ʼ����
    /// </summary>
    function GetStartIndex: Int64; stdcall;
    /// <summary>
    /// ��ȡ��������
    /// </summary>
    function GetStopIndex: Int64; stdcall;
    /// <summary>
    /// �ж��Ƿ��ж�
    /// </summary>
    function GetBreaked: Boolean; stdcall;
    /// <summary>
    /// ��ȡʵ�����еĴ���
    /// </summary>
    function GetRuns: Int64; stdcall;
    /// <summary>
    /// ��ȡ������ʱ�䣬����Ϊ0.1ms
    /// </summary>
    function GetTotalTime: Int64; stdcall;
    /// <summary>
    /// ��ȡƽ������ʱ�䣬����Ϊ0.1ms
    /// </summary>
    function GetAvgTime: Int64; stdcall;
  end;

  /// <summary>
  /// For ������ҵ�ص�����
  /// </summary>
  IQForJobCallback = interface
    ['{9A29AC85-2A57-4C01-8313-E7D3A7C29904}']
    /// <summary>
    /// For ���лص���ҵ������
    /// </summary>
    /// <param name="AMgr">
    /// FOR ������ҵ�������
    /// </param>
    /// <param name="AIndex">
    /// ��ǰ��ҵҪ�����ѭ������
    /// </param>
    /// <param name="AParams">
    /// ���ݸ���ҵ�������ĸ��Ӳ���
    /// </param>
    procedure DoJob(AMgr: IQForJobManager; AIndex: Int64;
      AParams: IQParams); stdcall;
  end;

  /// <summary>
  /// ��ҵ�����ӿ�
  /// </summary>
  IQJobGroup = interface
    ['{061C27B2-1D09-42FA-8A80-B738E8CFA5F3}']
    /// <summary>
    /// ȡ��������ҵ��ִ��
    /// </summary>
    /// <param name="AWaitRunningDone">
    /// �Ƿ�ȴ�����ִ�е���ҵ����
    /// </param>
    /// <remarks>
    /// ���Ҫ����ҵ�����ҵ��ȡ����ҵ��AWaitRunningDone ��������Ϊ False �Ա���������
    /// </remarks>
    procedure Cancel(AWaitRunningDone: Boolean = true); stdcall;
    /// <summary>
    /// ׼����ʼ������ӷ�����ҵ
    /// </summary>
    procedure Prepare; stdcall;
    /// <summary>
    /// ���� Prepare ����ӵ��б��е���ҵ
    /// </summary>
    /// <param name="ATimeout">
    /// ��ҵ��ɳ�ʱ�������ָ����ʱ���ڣ���ҵ���ڵ���ҵû����ɣ������δ��ʼִ�е���ҵ����ȡ��ִ�У������� AfterDone����������ˣ�
    /// </param>
    procedure Run(ATimeout: Cardinal = INFINITE); stdcall;
    /// <summary>
    /// ����һ���µ���ҵ
    /// </summary>
    /// <param name="AIndex">
    /// Ҫ�������ҵλ��
    /// </param>
    /// <param name="AJob">
    /// Ҫ��ӵ���ҵ
    /// </param>
    /// <param name="AParams">
    /// ������ҵ�Ķ������
    /// </param>
    /// <param name="ARunInMainThread">
    /// �Ƿ���ҵ��Ҫ���������߳���
    /// </param>
    /// <returns>
    /// �ɹ������� true��ʧ�ܣ����� false
    /// </returns>
    function Insert(AIndex: Integer; AJob: IQJobCallback; AParams: IQParams;
      ARunInMainThread: Boolean): Boolean; stdcall;
    /// <summary>
    /// ׷��һ���µ���ҵ
    /// </summary>
    /// <param name="AJob">
    /// Ҫ��ӵ���ҵ
    /// </param>
    /// <param name="AParams">
    /// ������ҵ�Ķ������
    /// </param>
    /// <param name="ARunInMainThread">
    /// �Ƿ���ҵ��Ҫ���������߳���
    /// </param>
    /// <returns>
    /// �ɹ������� true��ʧ�ܣ����� false
    /// </returns>
    function Add(AJob: IQJobCallback; AParams: IQParams; AInMainThread: Boolean)
      : Boolean; stdcall;
    /// <summary>
    /// �ȴ�������������ҵ���
    /// </summary>
    /// <param name="ABlockMessage">
    /// �Ƿ�������Ϣѭ��
    /// </param>
    /// <param name="ATimeout">
    /// �ȴ���ʱ
    /// </param>
    /// <returns>
    /// ���صȴ����������� ATimeout ��ʱ֮ǰ������ҵ��ִ������ˣ��򷵻� wrSignaled�������ʱ������ wrTimeout
    /// </returns>
    function Wait(ABlockMessage: Boolean; ATimeout: Cardinal = INFINITE)
      : TWaitResult; overload;
    /// <summary>
    /// ��ҵ����������ҵ������
    /// </summary>
    function GetCount: Integer; stdcall;
    /// <summary>
    /// ���� AfterDone ��֪ͨ�ص�
    /// </summary>
    procedure SetAfterDone(AValue: IQNotifyCallback); stdcall;
    /// <summary>
    /// ��ȡ��ҵ������� AfterDone ��֪ͨ�ص�
    /// </summary>
    function GetAfterDone: IQNotifyCallback; stdcall;
    /// <summary>
    /// ��ȡ��ҵ�Ƿ���˳��ִ�е�
    /// </summary>
    function GetByOrder: Boolean; stdcall;
    /// <summary>
    /// ��ȡ�Ѿ�ִ�е���ҵ����
    /// </summary>
    function GetRuns: Integer; stdcall;
    /// <summary>
    /// ���÷����������ʹ�õĹ���������
    /// </summary>
    function GetMaxWorkers: Integer; stdcall;
    /// <summary>
    /// ���÷����������ʹ�õĹ���������
    /// </summary>
    procedure SetMaxWorkers(const AValue: Integer); stdcall;
    property Count: Integer read GetCount;
    function _GetAfterDone: StandInterfaceResult; stdcall;
    property AfterDone: IQNotifyCallback read GetAfterDone write SetAfterDone;
    property ByOrder: Boolean read GetByOrder;
    property Runs: Integer read GetRuns;
    property MaxWorkers: Integer read GetMaxWorkers write SetMaxWorkers;
  end;

  /// <summary>
  /// ȫ�� QWorker ��ҵ�������ӿڶ���
  /// </summary>
  IQWorkers = interface
    ['{94B6F5B4-1C16-448F-927C-DD8772DDAA78}']
    /// <summary>
    /// Ͷ��һ���µ���ͨ��ҵ
    /// </summary>
    /// <param name="AJob">
    /// ��ҵ
    /// </param>
    /// <param name="AParams">
    /// �ṩ����ҵ�Ĳ���
    /// </param>
    /// <param name="ARunInMainThread">
    /// ��ҵ�Ƿ���Ҫ���������߳�
    /// </param>
    /// <returns>
    /// ������ҵ��������ʧ�ܣ�����0
    /// </returns>
    function Post(AJob: IQJobCallback; AParams: IQParams;
      ARunInMainThread: Boolean): Int64; stdcall;
    /// <summary>
    /// Ͷ��һ����ʱ��ҵ
    /// </summary>
    /// <param name="AJob">
    /// ��ҵ
    /// </param>
    /// <param name="AInterval">
    /// ʱ��������λΪ0.1ms
    /// </param>
    /// <param name="AParams">
    /// �ṩ����ҵ�Ķ������
    /// </param>
    /// <param name="ARunInMainThread">
    /// ��ҵ�Ƿ���Ҫ���������߳�
    /// </param>
    /// <returns>
    /// ������ҵ��������ʧ�ܷ���0
    /// </returns>
    /// <remarks>
    /// ��ʱ��ҵ������ȴ���һ����ɣ�ֻҪ��ʱ���ͻᴥ�������Զ�ʱ��ҵ����ҵ���豣֤����һ����ҵ����֮ǰ��ɡ�
    /// </remarks>
    function Timer(AJob: IQJobCallback; AInterval: Cardinal; AParams: IQParams;
      ARunInMainThread: Boolean): Int64; stdcall;
    /// <summary>
    /// �ӳ�ָ����ʱ����ִ����ҵ
    /// </summary>
    /// <param name="AJob">
    /// Ҫִ�е���ҵ
    /// </param>
    /// <param name="AParams">
    /// ��ҵ����
    /// </param>
    /// <param name="ADelay">
    /// �ӳ�ʱ�䣬��λΪ0.1ms
    /// </param>
    /// <param name="ARunInMainThread">
    /// �Ƿ�Ҫ�����������߳�
    /// </param>
    /// <param name="AIsRepeat">
    /// �Ƿ��ظ�ִ��
    /// </param>
    /// <returns>
    /// ������ҵ��������ʧ�ܣ�����0
    /// </returns>
    /// <remarks>
    /// ��� AIsRepeat ����Ϊ true���Ǹ�����һ����ʱ��ҵ������ Timer ��ͬ��Delay
    /// ��һ���������ҵ����һ����ҵ����������һ����ҵִ����ɺ�� AInterval ����ָ����ʱ��㴥����
    /// </remarks>
    function Delay(AJob: IQJobCallback; AParams: IQParams; ADelay: Int64;
      ARunInMainThread, AIsRepeat: Boolean): Int64; stdcall;
    /// <summary>
    /// ��ָ����ʱ�������ָ������ҵ
    /// </summary>
    /// <param name="AJob">
    /// ��ҵ
    /// </param>
    /// <param name="AParams">
    /// ��ҵ����
    /// </param>
    /// <param name="ATime">
    /// Ҫִ�е�ʱ���
    /// </param>
    /// <param name="AInterval">
    /// ��ҵ�ظ�ִ��ʱ���������Ϊ0�������ظ�ִ��
    /// </param>
    /// <param name="ARunInMainThread">
    /// �Ƿ���Ҫ�����߳���ִ��
    /// </param>
    /// <returns>
    /// ������ҵ��������ʧ�ܣ��򷵻�0
    /// </returns>
    function At(AJob: IQJobCallback; AParams: IQParams; ATime: TDateTime;
      AInterval: Cardinal; ARunInMainThread: Boolean): Int64; stdcall;
    /// <summary>
    /// ����һ����Linux Cron ��ʽ�ļƻ�������ҵ
    /// </summary>
    /// <param name="AJob">
    /// ��ҵ
    /// </param>
    /// <param name="AParams">
    /// ����
    /// </param>
    /// <param name="APlan">
    /// ִ�мƻ�
    /// </param>
    /// <param name="ARunInMainThread">
    /// �Ƿ���Ҫ�����߳���ִ��
    /// </param>
    /// <returns>
    /// �ɹ���������ҵ���
    /// </returns>
    /// <remarks>
    /// ��������ҵ��ͬ���ƻ�������ҵ����ϵͳʱ�ӵ�Ӱ�죬���������͵���ҵ��ϵͳʱ���޹ء�
    /// </remarks>
    function Plan(AJob: IQJobCallback; AParams: IQParams; APlan: PWideChar;
      ARunInMainThread: Boolean): Int64; stdcall;
    /// <summary>
    /// ִ��һ��For������ҵ
    /// </summary>
    /// <param name="AJob">
    /// ��ҵ
    /// </param>
    /// <param name="AParams">
    /// ��ҵ����
    /// </param>
    /// <param name="AStart">
    /// ��ʼ����
    /// </param>
    /// <param name="AStop">
    /// ֹͣ����
    /// </param>
    /// <param name="AMsgWait">
    /// �ȴ���ҵ��ɹ����У��Ƿ�������Ϣ����
    /// </param>
    procedure &For(AJob: IQForJobCallback; AParams: IQParams;
      AStart, AStop: Int64; AMsgWait: Boolean); stdcall;
    /// <summary>
    /// ���ָ���������ҵ
    /// </summary>
    /// <param name="AHandle">
    /// Ҫ�������ҵ���
    /// </param>
    /// <param name="AWaitRunningDone">
    /// �����ҵ����ִ�У��Ƿ�ȴ������
    /// </param>
    procedure Clear(AHandle: Int64; AWaitRunningDone: Boolean); stdcall;
    /// <summary>
    /// ����һ����ҵ����
    /// </summary>
    /// <param name="AByOrder">
    /// �����ڵ���ҵ�Ƿ�Ҫ��˳��ִ��
    /// </param>
    function CreateJobGroup(AByOrder: Boolean): IQJobGroup; stdcall;
    /// <summary>
    /// ���ù���������
    /// </summary>
    /// <param name="AMinWorkers">
    /// ��С����������������С��2
    /// </param>
    /// <param name="AMaxWorkers">
    /// ����������������� &gt;=AMinWorkers
    /// </param>
    procedure SetWorkers(const AMinWorkers, AMaxWorkers: Integer); stdcall;
    /// <summary>
    /// ��ȡ��ǰ������״̬ͳ������
    /// </summary>
    /// <param name="ATotal">
    /// ��ǰ���ܹ���������
    /// </param>
    /// <param name="AIdle">
    /// ��ǰ���еĹ���������
    /// </param>
    /// <param name="ABusy">
    /// ��ǰæµ�Ĺ���������
    /// </param>
    procedure PeekCurrentWorkers(var ATotal, AIdle, ABusy: Integer); stdcall;
    /// <summary>
    /// ע��һ���ź�
    /// </summary>
    /// <param name="ASignal">
    /// Ҫע����ź�����
    /// </param>
    function RegisterSignal(const ASignal: PWideChar): Integer; stdcall;
    /// <summary>
    /// ����һ���ȴ��źŴ�������ҵ
    /// </summary>
    /// <param name="ASignal">
    /// Ҫ�ȴ����ź�����
    /// </param>
    /// <param name="AJob">
    /// �źŴ���ʱ��Ҫִ�е���ҵ
    /// </param>
    /// <param name="ARunInMainThread">
    /// ��ҵ�Ƿ���Ҫ�����߳���ִ��
    /// </param>
    /// <returns>
    /// ������ҵ��������ʧ�ܣ�����0
    /// </returns>
    function WaitSignal(const ASignal: PWideChar; AJob: IQJobCallback;
      ARunInMainThread: Boolean): Int64; stdcall;
    /// <summary>
    /// �����ź�
    /// </summary>
    /// <param name="ASignal">
    /// �ź�����
    /// </param>
    /// <param name="AParams">
    /// ���ݸ��źŴ������Ĳ���
    /// </param>
    procedure Signal(const ASignal: PWideChar; AParams: IQParams);
    //
    function _CreateJobGroup(AByOrder: Boolean): StandInterfaceResult; stdcall;
  end;
  //����ע�����ӿ�
  IQServiceRegister = interface
    ['{F0CED863-3AC0-40A3-BDA7-38B4F26692AB}']
    function NewService(const AId: TGuid; const AName: PWideChar;
      const AInstance: IInterface): IQService; stdcall; overload;
    function NewService(const AId: TGuid; const AName: PWideChar;
      const AInstance: IQMultiInstanceExtension): IQService; stdcall; overload;
    procedure Register(const AParentPath: PWideChar;
      const AService: IQService); overload;
    procedure Register(const AParentPath: PWideChar;
      const AServices: array of IQService); overload;
    procedure Unregister(const AParentPath, AServiceName: PWideChar);stdcall;
  end;

  /// <summary>
  /// ����ص��ӿڶ��壬AService �ǻص��ķ������
  /// </summary>
  TQServiceCallback = procedure(const AService: IQService); stdcall;

  /// <summary>
  /// ��������������ڹ������в��������
  /// </summary>
  IQPluginsManager = interface(IQServices)
    ['{BDE6247B-87AD-4105-BDC9-1EA345A9E4B0}']
    /// <summary>
    /// ���еļ���������ĸ����
    /// </summary>
    /// <remarks>
    /// �ý���µ��ӷ���Ӧʵ�� IQLoader �ӿڡ�ʵ��·��Ϊ /Loaders
    /// </remarks>
    function GetLoaders: IQServices; stdcall;
    /// <summary>
    /// ����·�����ӿڷ���ĸ����
    /// </summary>
    /// <remarks>
    /// 1���˽���µ����з������ʵ�� IQServices �ӿڣ��Ա������ ByPath �� ById ��ȡ��ȷ�ķ���ʵ�� <br />
    /// 2���˽���ʵ��·��Ϊ /Routers
    /// </remarks>
    function GetRouters: IQServices; stdcall;
    /// <summary>
    /// �û��Զ����������ͷ���ĸ���㣬��ʵ��·��Ϊ /Services
    /// </summary>
    /// <remarks>
    /// �û��Զ�����������ͷ������ע���Լ��ĸ���㣬���Ƽ�ͳһ�ŵ� /Services ������Ŀ¼�£��Ա��ڹ���
    /// </remarks>
    function GetServices: IQServices; stdcall;
    /// <summary>
    /// ȷ��ָ��·���ķ����б����
    /// </summary>
    /// <param name="APath">
    /// ����·����·��֮���� ��/�� �ָ�
    /// </param>
    /// <returns>
    /// ����ɹ������ط����б�������ʧ�ܣ����ؿգ�����·����ע��Ϊ�������͵ķ���
    /// </returns>
    function ForcePath(APath: PWideChar): IQServices; stdcall;
    /// <summary>
    /// ��ȡ��ǰ�Ļ������
    /// </summary>
    function GetActiveLoader: IQLoader; stdcall;
    /// <summary>
    /// ���õ�ǰ�Ļ������
    /// </summary>
    procedure SetActiveLoader(ALoader: IQLoader); stdcall;
    /// <summary>
    /// �������еļ���������֧�ֵĲ��
    /// </summary>
    procedure Start; stdcall;
    /// <summary>
    /// ���ָ����ģ�鴦��׼��ж��״̬
    /// </summary>
    procedure ModuleUnloading(AInstance: HINST); stdcall;
    /// <summary>
    /// �����߳����첽����ָ���ĺ���
    /// </summary>
    /// <param name="AProc">
    /// Ҫִ�е��첽��ҵ����
    /// </param>
    /// <param name="AParams">
    /// ���ݸ��첽��ҵ�����Ĳ���
    /// </param>
    procedure AsynCall(AProc: TQAsynProc; AParams: IQParams); stdcall;
    /// <summary>
    /// ������ӵ��첽��ҵ
    /// </summary>
    procedure ProcessQueuedCalls; stdcall;
    /// <summary>
    /// ж�����еĲ��
    /// </summary>
    function Stop: Boolean; stdcall;
    /// <summary>
    /// �滻��ǰ�Ĺ���������
    /// </summary>
    function Replace(ANewManager: IQPluginsManager): Boolean; stdcall;
    /// <summary>
    /// �ȴ�ָ���ķ���ע��
    /// </summary>
    /// <param name="AService">
    /// Ҫ�ȴ��ķ���·��
    /// </param>
    /// <param name="ANotify">
    /// ����ע�����ʱ��֪ͨ�ص�
    /// </param>
    function WaitService(const AService: PWideChar; ANotify: TQServiceCallback)
      : Boolean; overload; stdcall;
    /// <summary>
    /// �ȴ�ָ���ķ���ע��
    /// </summary>
    /// <param name="AId">
    /// Ҫ�ȴ��ķ����ID
    /// </param>
    /// <param name="ANotify">
    /// ����ע�����ʱ��֪ͨ�ص�
    /// </param>
    function WaitService(const AId: TGuid; ANotify: TQServiceCallback): Boolean;
      overload; stdcall;
    /// <summary>
    /// �Ƴ�����ע��ȴ�
    /// </summary>
    /// <param name="ANotify">
    /// Ҫ�Ƴ���֪ͨ�ص������й���������ص��ĵȴ����ᱻ�Ƴ�
    /// </param>
    procedure RemoveServiceWait(ANotify: TQServiceCallback); overload; stdcall;
    /// <summary>
    /// �Ƴ�ָ�������ע��ȴ�
    /// </summary>
    /// <param name="AService">
    /// Ҫ�ȴ��ķ���·��
    /// </param>
    /// <param name="ANotify">
    /// Ҫ�Ƴ���֪ͨ�ص�
    /// </param>
    procedure RemoveServiceWait(const AService: PWideChar;
      ANotify: TQServiceCallback); overload; stdcall;
    /// <summary>
    /// �Ƴ�ָ�������ע��ȴ�
    /// </summary>
    /// <param name="AService">
    /// Ҫ�ȴ��ķ���ID
    /// </param>
    /// <param name="ANotify">
    /// Ҫ�Ƴ���֪ͨ�ص�
    /// </param>
    procedure RemoveServiceWait(const AId: TGuid; ANotify: TQServiceCallback);
      overload; stdcall;
    /// <summary>
    /// ����ָ���ķ����Ѿ�ע�����֪ͨ
    /// </summary>
    /// <param name="AService">
    /// Ҫ֪ͨ�ķ���ӿ�ʵ��
    /// </param>
    procedure ServiceReady(AService: IQService); stdcall;
    /// <summary>
    /// ����һ���µĲ����б�
    /// </summary>
    function NewParams: IQParams; stdcall;
    /// <summary>
    /// ����һ���µ�IQString�ӿ�
    /// </summary>
    function NewString: IQString; overload; stdcall;
    /// <summary>
    /// ����һ���µ� IQString �ӿڣ������ó�ʼ����
    /// </summary>
    function NewString(const ASource: PWideChar): IQString; overload; stdcall;
    /// <summary>
    /// ����һ���µĹ㲥ͨ��
    /// </summary>
    function NewBroadcast(const AId: Cardinal): IQNotifyBroadcast; stdcall;

    function _GetLoaders: StandInterfaceResult; stdcall;
    function _GetRouters: StandInterfaceResult; stdcall;
    function _GetServices: StandInterfaceResult; stdcall;
    function _ForcePath(APath: PWideChar): StandInterfaceResult; stdcall;
    function _GetActiveLoader: StandInterfaceResult; stdcall;
    function _NewParams: StandInterfaceResult; stdcall;
    function _NewString: StandInterfaceResult; overload; stdcall;
    function _NewString(const ASource: PWideChar): StandInterfaceResult;
      overload; stdcall;
    procedure _AsynCall(AProc: TQAsynProcG; AParams: IQParams); stdcall;
    function _NewBroadcast(const AId: Cardinal): Pointer; stdcall;
    property Services: IQServices read GetServices;
    property Routers: IQServices read GetRouters;
    property Loaders: IQServices read GetLoaders;
    property ActiveLoader: IQLoader read GetActiveLoader write SetActiveLoader;
  end;

  IQMemoryManager = interface
    ['{5E0A379E-3B4F-4267-A44A-4E964D82E46D}']
    function GetMem(const ASize: Cardinal): Pointer; stdcall;
    function FreeMem(p: Pointer): Integer; stdcall;
    function Realloc(p: Pointer; const ANewSize: Cardinal): Pointer; stdcall;
    function AllocMem(const ASize: Cardinal): Pointer; stdcall;
    function RegisterExpectedMemoryLeak(p: Pointer): Boolean; stdcall;
    function UnregisterExpectedMemoryLeak(p: Pointer): Boolean; stdcall;
    function NewBytes: IQBytes; stdcall;
    function NewStream(const AFileName: String; Mode: Word): IQStream; stdcall;
    function NewMemoryStream: IQStream; stdcall;
    function NewString(const S: PWideChar): IQString; stdcall;
  end;

  /// <summary>
  /// ȫ������������ QPlugins ����ڲ��ӿ�ʱ�����߳�ͬ��
  /// </summary>
  IQLocker = interface
    ['{5008B5D4-EE67-419D-80CB-E5C62FA95243}']
    /// <summary>
    /// ����
    /// </summary>
    procedure Lock; stdcall;
    /// <summary>
    /// ����
    /// </summary>
    procedure Unlock; stdcall;
  end;

  /// <summary>�½��ַ�������ӿ�</summary>
  IQStringService = interface
    ['{9B9384C6-8E8C-4E32-B07B-3F60A7D0A595}']
    /// <summary>
    /// ����һ���µ� IQString �ӿڣ������ó�ʼ����
    /// </summary>
    /// <remarks>
    /// �Ƽ�ʹ��PluginsManager.NewString ����˽ӿ�
    /// </remarks>
    function NewString(const S: PWideChar): IQString; stdcall;
  end;

implementation

end.

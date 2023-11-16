unit qsocket_base;

interface

uses classes, sysutils, qstring, qworker, syncobjs;

type
  {
    ���ݴ�����̣�
    ���������ݡ�
    ���������� -> ��װΪ IQBaseSession �Ự -> ͨ�� IQBaseDispatcher.Transmit �ӿڶԻỰ���ݽ��б���
    ->ѭ��ͨ�� IQBaseTransport.SendBuffer �ӿڷ�������
    ���������ݡ�
    ���յ�����->���Ự�Ƿ���ڣ��������򴴽� IQBaseSession �Ự->���ջỰ��ɵ��� IQBaseDispatcher.Dispatch �ӿ��ɷ�
    ->�����Ҫ��Ӧ���ɷ��������� IQBaseDispatcher.NewReplySession �����ظ��Ự��Ȼ�󰴷����������̷��ͻ�Ӧ
    ���㲥���ݡ�
    �㲥�������� IQBaseDispatcher.NewSession ������һ�����㲥�õĻỰ��Ȼ����� IQBaseTransport.Broadcast ���������ݵ�ȫ������
    ���鲥���ݡ�
    �鲥ǰ��Ҫ�� IQBaseTransport.NewGroup ������һ�����飬Ȼ����� IQBaseDispatch.NewSession ������һ���Ự��Ȼ�����
    IQBaseGroup.Broadcast �������㲥�������ݵ�����ȫ������

    !!! Ƶ���㲥���鲥���ݿ�������������������Ҫ���� !!!
  }
  TQBaseConnection = class;

  TQConnectionNotifyEvent = procedure(ASender: TQBaseConnection) of object;
  TQConnectionCallback = procedure(ASender: TQBaseConnection; AParam: IntPtr)
    of object;

  IQBaseTransport = interface;

  // ����
  IQBaseConnection = interface
    ['{82DE0DD9-48A9-49CD-A798-C3B37BD89810}']
    function GetTransport: IQBaseTransport;
    function Connect: Boolean;
    procedure Disconnect;
    function GetRemoteAddr: QStringW;
    procedure SetRemoteAddr(const AValue: QStringW);
    function GetLocalAddr: QStringW;
    function GetConnected: Boolean;
    procedure SetLocalAddr(const AValue: QStringW);
    property Transport: IQBaseTransport read GetTransport;
    property RemoteAddr: QStringW read GetRemoteAddr write SetRemoteAddr;
    property LocalAddr: QStringW read GetLocalAddr write SetLocalAddr;
    property Connected: Boolean read GetConnected;
  end;

  TQConnectionEnumCallback = reference to procedure(ASender: IQBaseTransport;
    AConnection: IQBaseConnection; var AContinue: Boolean);

  IQBaseConnections = interface
    ['{B1906599-B938-4447-9A96-D8670AD87A37}']
    function GetTransport: IQBaseTransport;
    function GetCount: Integer;
    function Find(const Addr: QStringW): IQBaseConnection;
    // ��Ϊ�ڲ����Ӳ�һ�����б���������Բ�ʹ���б�ʽ��ʽ
    procedure ForEach(ACallback: TQConnectionEnumCallback);
    property Transport: IQBaseTransport read GetTransport;
    property Count: Integer read GetCount;
  end;

  IQBaseConnectionGroup = interface
    ['{B509CDDB-E0C2-42C5-82E1-B4111F49A334}']
    procedure Join(AConnection: IQBaseConnection);
    procedure Leave(AConnection: IQBaseConnection);
    function GetCount: Integer;
    procedure ForEach(ACallback: TQConnectionEnumCallback);
    property Count: Integer read GetCount;
  end;

  TQSessionState = (ssRecving, ssSending, ssReply, ssDone, ssCanceled,
    ssMustArrive);
  TQSessionStates = set of TQSessionState;

  IQBaseSession = interface
    ['{DCAC7533-B793-4B46-A8AC-EBC3B65FEA12}']
    function GetId: Int64;
    function GetRefId: Int64;
    function GetRequestStream: TStream;
    function GetReplyStream: TStream;
    function GetConnection: IQBaseConnection;
    function GetStates: TQSessionStates;
    procedure SetStates(const AStates: TQSessionStates);
    property Id: Int64 read GetId;
    property RequestStream: TStream read GetRequestStream;
    property ReplyStream: TStream read GetReplyStream;
    property Connection: IQBaseConnection read GetConnection;
    property States: TQSessionStates read GetStates write SetStates;
  end;

  TQDispatchHandler = procedure(ASession: IQBaseSession; var AHandled: Boolean)
    of object;

  IQBaseDispatcher = interface
    ['{0A49A4F8-3620-49BF-943A-4EDC8A8ED5A3}']
    // ʵ����BaseDispatch������֪������ɷ������԰ѻỰ���ݴ���ȥ�����ˣ���ô�������ϲ����
    procedure Dispatch(ASession: IQBaseSession);
    // �ӻỰ���н������Ự������������� ACmdBuf �У�����ʵ�ʵ��������ݳ��ȣ�ʧ�ܷ��� 0
    function DecodeCmd(ASession: IQBaseSession; ACmdBuf: PByte): Integer;
    // ����ָ���ĻỰ��Զ��
    procedure Transmit(ASession: IQBaseSession);

    // ע��һ���¼�����������Ϊ����һ���治֪����������ͣ����Դ����ǵ�ַ�ͳ���
    procedure RegisterHandler(ACmd: Pointer; ACmdLen: Integer;
      AHandler: TQDispatchHandler);
    // ��ѯһ���Ự��Ҫ�ɷ��������Ӧ���ɷ�����
    function FindHandler(ACmd: Pointer; ACmdLen: Integer): TQDispatchHandler;
    // ע��Ĭ�ϵ��¼������������û���κ���֪���ɷ������ߴ��ɺ�������
    procedure RegisterDefaultHandler(AHandler: TQDispatchHandler);
    procedure UnregisterHandler(ACmd: Pointer; ACmdLen: Integer;
      AHandler: TQDispatchHandler);
    procedure UnregisterDefaultHandler(AHandler: TQDispatchHandler);
    // �½��Ự�����û��AReplyStreamΪ�գ����ڲ�����Ҫʱ�Զ������ڴ������ջ�Ӧ���
    // �ڴ����������ʱ����Ҫͨ���ļ��������Ự���������Ҫ����AReplyStream
    function NewSession(AConnection: IQBaseConnection;
      ARequestStream, AReplyStream: TStream): IQBaseSession;
    function NewReplySession(ARequest: IQBaseSession; AReplyStream: TStream)
      : IQBaseSession;
    // �ɷ�ָ������ֽڳ��ȣ�DecodeCmdʱ����ȥ��ACmdBuf����Ϊ�ô�С
    function GetMaxCommandLength: Integer;
    property MaxCommandLength: Integer read GetMaxCommandLength;
  end;

  // �ڰ��������������ƴ�ĳһ��ַ���������ӣ�ֱ��������һ�����ͷ��������Ա������Ŀ�����
  // ע����������ȣ�һ����ַ����ں�������򲻹����Ƿ��ڰ����������ֹ����
  IQAddrList = interface;

  TQAddrListEnumCallback = reference to procedure(ASender: IQAddrList;
    const Addr: QStringW; var AContinue: Boolean);

  IQAddrList = interface
    ['{9E56EFC2-720C-4ED6-96EE-A1F7F36294F2}']
    function GetTransport: IQBaseTransport;
    procedure Add(const Addr: QStringW);
    procedure Remove(const Addr: QStringW);
    function Contains(const Addr: QStringW): Boolean;
    function ForEach(ACallback: TQAddrListEnumCallback): Integer;
    function GetCount: Integer;
    property Transport: IQBaseTransport read GetTransport;
    property Count: Integer read GetCount;
  end;

  TQTransportState = (tsEnableBlackList, tsEnableWhiteList, tsListening);

  TQTransportStates = set of TQTransportState;

  IQBaseTransport = interface
    ['{0D149B26-02C7-4E12-AE85-F0DE6A1672D1}']
    function GetSchema: String;
    function GetVersion: String;
    function Startup: Boolean;
    procedure Cleanup;
    function Listen: Boolean;
    procedure Accept;
    function NewConnection(const ARemoteAddr: QStringW): IQBaseConnection;
    function NewGroup: IQBaseConnectionGroup;
    procedure Broadcast(ASession: IQBaseSession);
    function Bind(Addr: QStringW): Boolean;
    function GetConnections: IQBaseConnections;
    function GetDispatcher: IQBaseDispatcher;
    procedure SetDispatcher(const ADispatcher: IQBaseDispatcher);
    function GetBlackList: IQAddrList;
    function GetWhiteList: IQAddrList;
    function GetStates: TQTransportStates;
    property Schema: String read GetSchema;
    property Version: String read GetVersion;
    property Connections: IQBaseConnections read GetConnections;
    property Dispatcher: IQBaseDispatcher read GetDispatcher
      write SetDispatcher;
    property BlackList: IQAddrList read GetBlackList;
    property WhiteList: IQAddrList read GetWhiteList;
    property States: TQTransportStates read GetStates;
  end;

  TQBaseConnection = class
  protected
    FLocalAddr, FRemoteAddr: QStringW;
    FTag: IntPtr;
    FConnected: Boolean;
  public
  end;

  procedure RegisterTransport(ATransport:IQBaseTransport);

implementation

resourcestring
  SCantConnectToRemote = '�޷����ӵ�Զ�̵�ַ:%s��';
  SCantCreateHandle = '�޷��������Ӿ����';
  SAsynWaitNotSupport = '���Ӳ�֧���첽�ȴ����ݡ�';

procedure RegisterTransport(ATransport:IQBaseTransport);
begin
 //Todo:�������ע��
end;

end.

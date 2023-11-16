unit qhttprequest;

interface

{ QHttpRequest 3.0.2
  ����Ԫ���ڷ�װ HTTP �첽���ʣ���ʹ�� TQWebRequests ����������
  ����Ԫ�ṩ����Web�������棺
  TQSysHttpClient ʹ���°� Delphi �Դ��� THttpClient ����ɾ����������
  TQCurlHttpClient ʹ�� libcurl ����ɾ������������Ҫ��Ӧ�� dll �ṩ֧��
  TQNativeHttpClient ֱ��ͨ��Socket ʵ�ֵ�ԭ�� HTTP �ͻ��ˣ�Ŀǰ�ݲ��ȶ������Ƽ�ʹ��
  �������ʹ�� Indy ����������������� HTTP/HTTPS ���棬���Լ̳� TQBaseHttpClient��
  Ȼ��ʵ�� InternalExecute ������
}
{$IF RTLVersion>=28}
{$DEFINE SYSHTTP }
{$IFEND}
{ .$DEFINE DEBUG_LOG }

uses Classes, Sysutils, Types, SyncObjs, QString, QDigest, QJson, QXML,
  DateUtils, Math,
  QSimplePool, QWorker{$IFDEF DEBUG_LOG}, QLog{$ENDIF}{$IFDEF SYSHTTP},
  System.Net.HttpClient, System.NetConsts,
  System.Net.UrlClient
{$IFDEF MSWINDOWS}
    , WinHttp, System.Net.HttpClient.Win
{$ENDIF}
{$ENDIF}
{$IFDEF UNICODE}, System.Generics.Collections{$ELSE}, Contnrs{$ENDIF};
{$I 'qdac.inc'}

type
  TQUrl = class;
  IQHttpClient = interface;
  TQHttpRecvProgressEvent = procedure(const Sender: TObject;
    AContentLength: Int64; AReadCount: Int64; var Abort: Boolean) of object;
  TQHttpErrorEvent = procedure(ASender: TObject; AError: Exception) of object;
  TQHttpRedirectEvent = procedure(ASender: TObject; ANewUrl: QStringW;
    var Allow: Boolean) of object;
  TQUrlRedirectEvent = procedure(ASender: TObject; var Allow: Boolean)
    of object;
  TQHttpRequestClientBoundEvent = procedure(ASender: TObject;
    AClient: IQHttpClient) of object;
  TQHttpDNSLookupEvent = procedure(Sender: TObject; const AHost: QStringW;
    var Addr: QStringW) of object;
  TQHttpRequestRetryNotify = procedure(Sender: TObject;
    const AClient: IQHttpClient; ATryTimes: Integer; var AContinue: Boolean)
    of object;
  TQHttpGetSSLProtocolEvent = procedure(Sender: TObject;
    const AClient: IQHttpClient; const AHost: String;
    var AProtocol: THTTPSecureProtocol) of object;
  IQCertificate = interface;
  TQCertificateValidEvent = procedure(Sender: TObject;
    const ACertificate: IQCertificate; var Accepted: Boolean) of object;

  // TQUrl ��һ���򵥵� URL �����࣬ע����������Ҫ����Ч�Ĳ�������Ϊ���������й淶�Լ��
  // �������㴫�Ĳ������ǺϷ���Ч��
  TQUrl = class
  private
    function GetOriginNames: QStringW;
    function GetOriginValues: QStringW;
    function GetUrlWithoutParams: QStringW;
    procedure SetFullParams(const Value: QStringW);

  protected
    FUrl: QStringW;
    FUserName, FPassword: QStringW;
    FScheme, FHost, FDocument: QStringW;
    FBookmark: QStringW;
    FPort: Word;
    FParams: TStringList;
    FChanged: Boolean;
    FSpaceAsPlus, FCheckBookmark: Boolean;
    function GetParams: TStrings;
    function GetUrl: QStringW;
    procedure SetUrl(const Value: QStringW);
    procedure DoParamsChanged(ASender: TObject);
    procedure SetBookmark(const Value: QStringW);
    procedure SetDocument(const Value: QStringW);
    procedure SetHost(const Value: QStringW);
    procedure SetPort(const Value: Word);
    procedure SetScheme(const Value: QStringW);
    function GetSchemePort: Word;
    function GetPort: Word;
    function GetHostAddr: QStringW;
    function GetIPAddr: Cardinal;
    function GetDocumentWithParams: QStringW;
    function GetRequestHost: QStringW;
    function GetDocumentFullPath: QStringW;
    function GetFullParams: QStringW;
    function GetOriginParams: QStringW;
  public
    constructor Create; overload;
    constructor Create(AUrl: QStringW;
      ACheckbookmark: Boolean = false); overload;
    destructor Destroy; override;
    procedure Assign(ASource: TQUrl);
    procedure DecodeParams(const AParams: QStringW);
    procedure SortParams(ACaseSensitive: Boolean = false;
      AUseLocale: Boolean = false; Compare: TStringListSortCompare = nil);
    procedure RandSortParams;
    property SchemePort: Word read GetSchemePort;
    property Scheme: QStringW read FScheme write SetScheme;
    property Host: QStringW read FHost write SetHost;
    property Port: Word read GetPort write SetPort;
    property Document: QStringW read FDocument write SetDocument;
    property FullDocument: QStringW read GetDocumentWithParams;
    property FullPath: QStringW read GetDocumentFullPath;
    property RequestHost: QStringW read GetRequestHost;
    property Bookmark: QStringW read FBookmark write SetBookmark;
    property Params: TStrings read GetParams;
    property FullParams: QStringW read GetFullParams write SetFullParams;
    property OriginParams: QStringW read GetOriginParams;
    property OriginNames: QStringW read GetOriginNames;
    property OriginValues: QStringW read GetOriginValues;
    property Url: QStringW read GetUrl write SetUrl;
    property UrlWithoutParams: QStringW read GetUrlWithoutParams;
    property SpaceAsPlus: Boolean read FSpaceAsPlus write FSpaceAsPlus;
    property HostAddr: QStringW read GetHostAddr;
    property IPAddr: Cardinal read GetIPAddr;
  end;

  IQHttpHeaders = interface
    ['{8A15352D-6CDE-4D0A-90B6-2A70AC7657A0}']
    function GetHeaderValue(const AName: QStringW): QStringW;
    procedure SetHeaderValue(const AName, AValue: QStringW);
    function HeaderIndex(AName: QStringW): Integer;
    function HeaderValue(AName, ADefVal: QStringW): QStringW;
    procedure RemoveHeader(AName: QStringW);
    procedure ReplaceHeader(AName, AValue: QStringW);
    procedure NeedExists(const AName, ADefVal: QStringW);
    function GetText: QStringW;
    procedure SetText(const S: QStringW);
    function GetNames(const AIndex: Integer): QStringW;
    function GetValueFromIndex(const AIndex: Integer): QStringW;
    function GetCount: Integer;
    procedure Replace(AHeaders: IQHttpHeaders);
    procedure Merge(AHeaders: IQHttpHeaders);
    procedure Assign(ASource: IQHttpHeaders);
    function GetLines(const AIndex: Integer): QStringW;
    procedure SetLines(const AIndex: Integer; const AValue: QStringW);
    procedure Add(const S: QStringW);
    procedure Clear;
    property Values[const AName: QStringW]: QStringW read GetHeaderValue
      write SetHeaderValue; default;
    property Text: QStringW read GetText write SetText;
    property Names[const AIndex: Integer]: QStringW read GetNames;
    property ValueFromIndex[const AIndex: Integer]: QStringW
      read GetValueFromIndex;
    property Lines[const AIndex: Integer]: QStringW read GetLines
      write SetLines;
    property Count: Integer read GetCount;
  end;

  TQHttpClientAction = (reqUnknown, reqGet, reqPost, reqHead, reqPut, reqDelete,
    reqTrace, reqOptions);
  TQDownloadProgressEvent = procedure(const Sender: TObject;
    AContentLength: Int64; AReadCount: Int64; var Aborted: Boolean) of object;

  IQHttpCookie = interface
    ['{13B94F0B-10CB-42C0-93D0-D33F56F485CC}']
    function GetName: QStringW;
    function GetValue: QStringW;
    function GetExpires: TDateTime;
    function GetDomain: QStringW;
    function GetPath: QStringW;
    function GetSecure: Boolean;
    function GetHttpOnly: Boolean;
    function ToString: QStringW;
    procedure FromString(const AValue: QStringW);
    property Name: QStringW read GetName;
    property Value: QStringW read GetValue;
    property Expires: TDateTime read GetExpires;
    property Domain: QStringW read GetDomain;
    property Path: QStringW read GetPath;
    property Secure: Boolean read GetSecure;
    property HttpOnly: Boolean read GetHttpOnly;
    property AsString: QStringW read ToString write FromString;
  end;

  IQHttpCookies = interface
    ['{49E27E66-D23B-408C-9B26-AB7E45D8B71A}']
    function AddCookie(const AUrl, AValue: QStringW): IQHttpCookie;
    procedure SetUrlCookies(const AUrl, ACookies: QStringW);
    function GetUrlCookies(const AUrl: QStringW): QStringW;
    function GetCookies(const AIndex: Integer): IQHttpCookie;
    function GetCount: Integer;
    procedure Clear(const ADomain: QStringW);
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(const AFileName: String);
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(const AFileName: String);
    property UrlCookie[const AUrl: QStringW]: QStringW read GetUrlCookies
      write SetUrlCookies;
    property Cookies[const AIndex: Integer]: IQHttpCookie
      read GetCookies; default;
    property Count: Integer read GetCount;
  end;

  // hcfReady - ׼������һ��������
  TQHttpClientFlag = (hcfReady, hcfAllowRedirect, hcfAllowCookie,
    hcfOwnRequestStream, hcfOwnResponseStream, hcfVerifyPeer, hcfExecuting,
    hcfExecuted, hcfAsyn);
  TQHttpClientFlags = set of TQHttpClientFlag;

  IQHttpClient = interface
    ['{2354DCFE-2CA9-4A8E-9BDA-EE6A912F4B19}']
    function GetRequestHeaders: IQHttpHeaders;
    function GetResponseHeaders: IQHttpHeaders;
    function GetCookieManager: IQHttpCookies;
    procedure SetCookieManager(const AManager: IQHttpCookies);
    function GetRequestStream: TStream;
    procedure SetRequestStream(const AStream: TStream);
    function GetResponseStream: TStream;
    procedure SetResponseStream(const AStream: TStream);
    function GetStatusCode: Integer;
    function GetStatusText: QStringW;
    function GetMaxRedirects: Integer;
    procedure SetMaxRedirects(const AValue: Integer);
    function GetFlags: TQHttpClientFlags;
    procedure SetFlags(const AValue: TQHttpClientFlags);
    function GetConnectTimeout: Cardinal;
    procedure SetConnectTimeout(const AValue: Cardinal);
    function GetMaxRequestTimeout: Cardinal;
    procedure SetMaxRequestTimeout(const AValue: Cardinal);
    function GetAfterDone: TNotifyEvent;
    procedure SetAfterDone(const AValue: TNotifyEvent);
    function GetOnProgress: TQDownloadProgressEvent;
    procedure SetOnProgress(const AValue: TQDownloadProgressEvent);
    function GetOnRedirect: TQHttpRedirectEvent;
    procedure SetOnRedirect(const AValue: TQHttpRedirectEvent);
    function GetOnDnsLookup: TQHttpDNSLookupEvent;
    procedure SetOnDnsLookup(const AValue: TQHttpDNSLookupEvent);
    function GetOnRetry: TQHttpRequestRetryNotify;
    procedure SetOnRetry(const AValue: TQHttpRequestRetryNotify);
    function GetOnGetSSLProtocol: TQHttpGetSSLProtocolEvent;
    procedure SetOnGetSSLProtocol(const AValue: TQHttpGetSSLProtocolEvent);
    function GetOnVerifyCertificate: TQCertificateValidEvent;
    procedure SetOnVeriftyCertificate(const AValue: TQCertificateValidEvent);
    function GetUrl: QStringW;
    function GetFinalUrl: QStringW;
    function GetErrorCode: Integer;
    function GetErrorMessage: QStringW;
    procedure Reset;
    function Get(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function Post(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function Head(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function Put(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function Delete(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function Options(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function Trace(const AUrl: QStringW; AfterDone: TNotifyEvent): Integer;
    function GetContentAsString: QStringW;
    procedure Cancel;
    property RequestHeaders: IQHttpHeaders read GetRequestHeaders;
    property RequestStream: TStream read GetRequestStream
      write SetRequestStream;
    property ResponseHeaders: IQHttpHeaders read GetResponseHeaders;
    property ResponseStream: TStream read GetResponseStream
      write SetResponseStream;
    property StatusCode: Integer read GetStatusCode;
    property StatusText: QStringW read GetStatusText;
    property Url: QStringW read GetUrl;
    property FinalUrl: QStringW read GetFinalUrl;
    property ErrorMessage: QStringW read GetErrorMessage;
    property ErrorCode: Integer read GetErrorCode;
    property ContentAsString: QStringW read GetContentAsString;
    property CookieManager: IQHttpCookies read GetCookieManager
      write SetCookieManager;
    property MaxRedirects: Integer read GetMaxRedirects write SetMaxRedirects;
    property Flags: TQHttpClientFlags read GetFlags write SetFlags;
    property ConnectTimeout: Cardinal read GetConnectTimeout
      write SetConnectTimeout;
    property MaxRequestTimeout: Cardinal read GetMaxRequestTimeout
      write SetMaxRequestTimeout;
    property AfterDone: TNotifyEvent read GetAfterDone write SetAfterDone;
    property OnProgress: TQDownloadProgressEvent read GetOnProgress
      write SetOnProgress;
    property OnRedirect: TQHttpRedirectEvent read GetOnRedirect
      write SetOnRedirect;
    property OnDnsLookup: TQHttpDNSLookupEvent read GetOnDnsLookup
      write SetOnDnsLookup;
    property OnRetry: TQHttpRequestRetryNotify read GetOnRetry write SetOnRetry;
    property OnGetSSLProtocol: TQHttpGetSSLProtocolEvent
      read GetOnGetSSLProtocol write SetOnGetSSLProtocol;
    property onVerifyCertificate: TQCertificateValidEvent
      read GetOnVerifyCertificate write SetOnVeriftyCertificate;
  end;

  IQCertificate = interface
    ['{EC28B115-E72D-40FB-9945-1D40BF1082B6}']
    function GetStartDate: TDateTime;
    function GetExpireDate: TDateTime;
    function GetSubject: QStringW;
    function GetIssuer: QStringW;
    function GetProtocol: QStringW;
    function GetSignature: QStringW;
    function GetEncryption: QStringW;
    function GetKeySize: Integer;
    property StartDate: TDateTime read GetStartDate;
    property ExpireDate: TDateTime read GetExpireDate;
    property Subject: QStringW read GetSubject;
    property Issuer: QStringW read GetIssuer;
    property Protocol: QStringW read GetProtocol;
    property Signature: QStringW read GetSignature;
    property Encryption: QStringW read GetEncryption;
    property KeySize: Integer read GetKeySize;
  end;

  TQCertificate = class(TInterfacedObject, IQCertificate)
  protected
    FStartDate, FExpireDate: TDateTime;
    FSubject, FIssuer, FProtocol, FSignature, FEncryption: String;
    FKeySize: Integer;
    function GetStartDate: TDateTime;
    function GetExpireDate: TDateTime;
    function GetSubject: QStringW;
    function GetIssuer: QStringW;
    function GetProtocol: QStringW;
    function GetSignature: QStringW;
    function GetEncryption: QStringW;
    function GetKeySize: Integer;
  public
    property StartDate: TDateTime read FStartDate write FStartDate;
    property ExpireDate: TDateTime read FExpireDate write FExpireDate;
    property Subject: QStringW read FSubject write FSubject;
    property Issuer: QStringW read FIssuer write FIssuer;
    property Protocol: QStringW read FProtocol write FProtocol;
    property Signature: QStringW read FSignature write FSignature;
    property Encryption: QStringW read FEncryption write FEncryption;
    property KeySize: Integer read FKeySize write FKeySize;
  end;

  IQHttpsClient = interface(IQHttpClient)
    ['{3621B9B2-20D6-4E90-897A-AE3DF61A8838}']
    function GetPeerCertificate: IQCertificate;
    function GetVerifyPeer: Boolean;
    procedure SetVerifyPeer(const AValue: Boolean);
    property VerifyPeer: Boolean read GetVerifyPeer write SetVerifyPeer;
    property PeerCertificate: IQCertificate read GetPeerCertificate;
  end;

  TQHttpRequests = class;

  IQHttpRequestItem = interface
    ['{3137B0A2-B422-447D-B5D3-B3DA338E19CB}']
    function WaitFor(ATimeout: Cardinal): TWaitResult;
    function NeedRequestStream: TStream;
    function GetUrl: QStringW;
    procedure SetUrl(const AUrl: QStringW);
    function GetResultUrl: QStringW;
    function GetAction: TQHttpClientAction;
    function GetSender: TObject;
    procedure SetAction(const AValue: TQHttpClientAction);
    function GetRequestStream: TStream;
    procedure SetRequestStream(AStream: TStream);
    function GetResponseStream: TStream;
    procedure SetResponseStream(const AStream: TStream);
    function GetRequestHeaders: IQHttpHeaders;
    function GetStatusCode: Integer;
    function GetStatusText: QStringW;
    function GetResponseHeaders: IQHttpHeaders;
    function GetMainThreadNotify: Boolean;
    procedure SetMainThreadNotify(const AValue: Boolean);
    function GetResponseCharset: QStringW;
    function GetMaxRedirectTimes: Integer;
    procedure SetMaxRedirectTimes(const AValue: Integer);
    function GetProgressInterval: Cardinal;
    procedure SetProgressInterval(const AValue: Cardinal);
    function GetRedirectTimes: Integer;
    function GetContentAsString: QStringW;
    function GetStartTime: TDateTime;
    function GetStopTime: TDateTime;
    function GetSentBytes: Int64;
    function GetRecvBytes: Int64;
    function GetTotalBytes: Int64;
    function GetUserAgent: QStringW;
    procedure SetUserAgent(const Agent: QStringW);
    function GetCanStart: Boolean;
    function GetConnectionTimeout: Cardinal;
    procedure SetConnectionTimeout(const AValue: Cardinal);
    function GetTag: Int64;
    procedure SetTag(const AValue: Int64);
    function GetOnRecvData: TQDownloadProgressEvent;
    procedure SetOnRecvData(AValue: TQDownloadProgressEvent);
    function GetAfterDone: TNotifyEvent;
    procedure SetAfterDone(AValue: TNotifyEvent);
    function GetOnError: TQHttpErrorEvent;
    procedure SetOnError(AValue: TQHttpErrorEvent);
    function GetBeforeUrlRedirect: TQUrlRedirectEvent;
    procedure SetBeforeUrlRedirect(AValue: TQUrlRedirectEvent);
    function GetOnClientBound: TQHttpRequestClientBoundEvent;
    procedure SetOnClientBound(AValue: TQHttpRequestClientBoundEvent);
    function GetIsAborted: Boolean;
    procedure SetIsAborted(AValue: Boolean);
    procedure BeforePush;
    procedure AfterPush;
    function GetHttpClient: IQHttpClient;
    property Url: QStringW read GetUrl write SetUrl;
    property ResultUrl: QStringW read GetResultUrl;
    property Action: TQHttpClientAction read GetAction write SetAction;
    property Sender: TObject read GetSender;
    property RequestStream: TStream read GetRequestStream
      write SetRequestStream;
    property ResponseStream: TStream read GetResponseStream
      write SetResponseStream;
    // ContentStream��Ϊ ResponseStream�ı���
    property ContentStream: TStream read GetResponseStream
      write SetResponseStream;
    property RequestHeaders: IQHttpHeaders read GetRequestHeaders;
    property StatusCode: Integer read GetStatusCode;
    property StatusText: QStringW read GetStatusText;
    property ResponseHeaders: IQHttpHeaders read GetResponseHeaders;
    property MainThreadNotify: Boolean read GetMainThreadNotify
      write SetMainThreadNotify;
    property ResponseCharset: QStringW read GetResponseCharset;
    property MaxRedirectTimes: Integer read GetMaxRedirectTimes
      write SetMaxRedirectTimes;
    property RedirectTimes: Integer read GetRedirectTimes;
    property ProgressInterval: Cardinal read GetProgressInterval
      write SetProgressInterval;
    property ContentAsString: QStringW read GetContentAsString;
    property StartTime: TDateTime read GetStartTime;
    property StopTime: TDateTime read GetStopTime;
    property SentBytes: Int64 read GetSentBytes;
    property RecvBytes: Int64 read GetRecvBytes;
    property ContentLength: Int64 read GetTotalBytes;
    property TotalBytes: Int64 read GetTotalBytes;
    property UserAgent: QStringW read GetUserAgent write SetUserAgent;
    property CanStart: Boolean read GetCanStart;
    property ConnectionTimeut: Cardinal read GetConnectionTimeout
      write SetConnectionTimeout;
    property Tag: Int64 read GetTag write SetTag;
    property HttpClient: IQHttpClient read GetHttpClient;
    property OnRecvData: TQDownloadProgressEvent read GetOnRecvData
      write SetOnRecvData;
    property AfterDone: TNotifyEvent read GetAfterDone write SetAfterDone;
    property OnError: TQHttpErrorEvent read GetOnError write SetOnError;
    property BeforeUrlRedirect: TQUrlRedirectEvent read GetBeforeUrlRedirect
      write SetBeforeUrlRedirect;
    property OnClientBound: TQHttpRequestClientBoundEvent read GetOnClientBound
      write SetOnClientBound;
    property IsAborted: Boolean read GetIsAborted write SetIsAborted;
  end;

  TQHttpMemoryStream = class(TMemoryStream)
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TQHttpRequestItem = class(TInterfacedObject, IQHttpRequestItem)
  protected
    FUrl: QStringW;
    FQueue: TQHttpRequests;
    FResultUrl: QStringW;
    FRequestStream, FResponseStream: TStream;
    FAction: TQHttpClientAction;
    FSender: TObject;
    FAfterDone: TNotifyEvent;
    FHttpClient: IQHttpClient;
    FRequestHeaders: IQHttpHeaders;
    FResponseHeaders: IQHttpHeaders;
    FStatusCode: Integer;
    FStatusText: QStringW;
    FResponseStreamOwner, FRequestStreamOwner: Boolean;
    FResponse: IInterface;
    FMainThreadNotify: Boolean;
    FLastProgressTick: Cardinal;
    FOnRecvData: TQDownloadProgressEvent;
    FOnError: TQHttpErrorEvent;
    FProgressInterval: Cardinal;
    FLastIOTick: Cardinal;
    FSentBytes: Int64;
    FRecvBytes: Int64;
    FTotalBytes: Int64;
    FStopTime: TDateTime;
    FStartTime: TDateTime;
    FRedirectTimes: Integer;
    FMaxRedirectTimes: Integer;
    FLastException: Exception;
    FTag: Int64;
    FAbort: Boolean;
    FIsDone: Boolean;
    FFreeRequestStream: Boolean;
    // FFreeAfterDone: Boolean;
    FRequestHeaderReady: Boolean;
    FAllowRedirect: Boolean;
    FBeforeUrlRedirect: TQUrlRedirectEvent;
    FConnectionTimeout: Cardinal;
    FOnClientBound: TQHttpRequestClientBoundEvent;
    FSyncEvent: TEvent;
    procedure DoAfterDone(ASender: TObject);
    procedure DoError;
    procedure DoProgress(const Sender: TObject; AContentLength: Int64;
      AReadCount: Int64; var Abort: Boolean); overload;
    function DoProgress: Boolean; overload;
    procedure DoRedirect;
    procedure DoClientRedirect(ASender: TObject; ANewUrl: QStringW;
      var Allow: Boolean);
    procedure DoMainThreadAfterDone;
    procedure DoMainThreadRecvProgress;
    function GetResponseStream: TStream;
    procedure SetResponseStream(const Value: TStream);
    function GetContentAsString: QStringW;
    function GetResponseCharset: QStringW;
    function GetResultUrl: QStringW;
    function StartWith(AHttpClient: IQHttpClient): Boolean;
    function GetUserAgent: QStringW;
    procedure SetUserAgent(const Value: QStringW);
    procedure DoClientBound;
  private
    FMaxRequestTimeout: Cardinal;
    procedure SetHttpClient(const Value: IQHttpClient);

  protected
    procedure BeforePush; virtual;
    procedure AfterPush; virtual;
    function GetCanStart: Boolean; virtual;
    function CreateInternalStream: TStream; virtual;
    procedure InternalCreate(ASender: TObject; AIsSyncMode: Boolean);
    function GetUrl: QStringW;
    procedure SetUrl(const AUrl: QStringW);
    function GetAction: TQHttpClientAction;
    function GetSender: TObject;
    procedure SetAction(const AValue: TQHttpClientAction);
    function GetRequestStream: TStream;
    procedure SetRequestStream(AStream: TStream);
    function GetRequestHeaders: IQHttpHeaders;
    function GetStatusCode: Integer;
    function GetStatusText: QStringW;
    function GetResponseHeaders: IQHttpHeaders;
    function GetMainThreadNotify: Boolean;
    procedure SetMainThreadNotify(const AValue: Boolean);
    function GetMaxRedirectTimes: Integer;
    procedure SetMaxRedirectTimes(const AValue: Integer);
    function GetProgressInterval: Cardinal;
    procedure SetProgressInterval(const AValue: Cardinal);
    function GetRedirectTimes: Integer;
    function GetStartTime: TDateTime;
    function GetStopTime: TDateTime;
    function GetSentBytes: Int64;
    function GetRecvBytes: Int64;
    function GetTotalBytes: Int64;
    function GetConnectionTimeout: Cardinal;
    procedure SetConnectionTimeout(const AValue: Cardinal);
    function GetTag: Int64;
    procedure SetTag(const AValue: Int64);
    function GetOnRecvData: TQDownloadProgressEvent;
    procedure SetOnRecvData(AValue: TQDownloadProgressEvent);
    function GetAfterDone: TNotifyEvent;
    procedure SetAfterDone(AValue: TNotifyEvent);
    function GetOnError: TQHttpErrorEvent;
    procedure SetOnError(AValue: TQHttpErrorEvent);
    function GetBeforeUrlRedirect: TQUrlRedirectEvent;
    procedure SetBeforeUrlRedirect(AValue: TQUrlRedirectEvent);
    function GetOnClientBound: TQHttpRequestClientBoundEvent;
    procedure SetOnClientBound(AValue: TQHttpRequestClientBoundEvent);
    function GetIsAborted: Boolean;
    procedure SetIsAborted(AValue: Boolean);
    function GetHttpClient: IQHttpClient;
    property HttpClient: IQHttpClient read FHttpClient write SetHttpClient;
  public
    constructor Create(ASender: TObject; AIsSyncMode: Boolean); overload;
    constructor Create(ASender: TObject); overload;
    destructor Destroy; override;
    function WaitFor(ATimeout: Cardinal): TWaitResult;
    function NeedRequestStream: TStream;
    property MaxRequestTimeout: Cardinal read FMaxRequestTimeout
      write FMaxRequestTimeout;
    property Url: QStringW read FUrl write FUrl;
    property ResultUrl: QStringW read GetResultUrl;
    property Action: TQHttpClientAction read FAction write FAction;
    property Sender: TObject read FSender;
    property RequestStream: TStream read FRequestStream write FRequestStream;
    property ResponseStream: TStream read GetResponseStream
      write SetResponseStream;
    // ContentStream��Ϊ ResponseStream�ı���
    property ContentStream: TStream read GetResponseStream
      write SetResponseStream;
    property RequestHeaders: IQHttpHeaders read FRequestHeaders;
    property StatusCode: Integer read FStatusCode;
    property StatusText: QStringW read FStatusText;
    property ResponseHeaders: IQHttpHeaders read FResponseHeaders;
    property MainThreadNotify: Boolean read FMainThreadNotify
      write FMainThreadNotify;
    property ResponseCharset: QStringW read GetResponseCharset;
    property MaxRedirectTimes: Integer read FMaxRedirectTimes
      write FMaxRedirectTimes;
    property RedirectTimes: Integer read FRedirectTimes write FRedirectTimes;
    property ProgressInterval: Cardinal read FProgressInterval
      write FProgressInterval default 1000;
    property ContentAsString: QStringW read GetContentAsString;
    property StartTime: TDateTime read FStartTime;
    property StopTime: TDateTime read FStopTime;
    property SentBytes: Int64 read FSentBytes;
    property RecvBytes: Int64 read FRecvBytes;
    property ContentLength: Int64 read FTotalBytes;
    property TotalBytes: Int64 read FTotalBytes;
    property UserAgent: QStringW read GetUserAgent write SetUserAgent;
    property CanStart: Boolean read GetCanStart;
    property ConnectionTimeut: Cardinal read FConnectionTimeout
      write FConnectionTimeout;
    property Tag: Int64 read FTag write FTag;
    // property FreeAfterDone: Boolean read FFreeAfterDone write FFreeAfterDone;
    property OnRecvData: TQDownloadProgressEvent read FOnRecvData
      write FOnRecvData;
    property AfterDone: TNotifyEvent read FAfterDone write FAfterDone;
    property OnError: TQHttpErrorEvent read FOnError write FOnError;
    property BeforeUrlRedirect: TQUrlRedirectEvent read FBeforeUrlRedirect
      write FBeforeUrlRedirect;
    property OnClientBound: TQHttpRequestClientBoundEvent read FOnClientBound
      write FOnClientBound;
    property IsAborted: Boolean read FAbort write FAbort;
  end;

  TQRequestList = class
  private
    FItems: TList;
    function GetCount: Integer;
    function GetItems(const AIndex: Integer): IQHttpRequestItem;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function Add(const ARequest: IQHttpRequestItem): Integer;
    procedure Remove(const ARequest: IQHttpRequestItem);
    procedure Delete(AIndex: Integer);
    procedure Clear;
    function IndexOf(const ARequest: IQHttpRequestItem): Integer;
    property Items[const AIndex: Integer]: IQHttpRequestItem
      read GetItems; default;
    property Count: Integer read GetCount;
  end;

  TQHttpClientEngine = (hceSystem, hceCurl, hceNative);

  TQHttpRequestNotifyEvent = procedure(Sender: TObject;
    ARequest: IQHttpRequestItem) of object;

  PQDnsEntryItem = ^TQDnsEntryItem;

  TQDnsEntryItem = record
    Next: PQDnsEntryItem;
    ExpireTick: Cardinal; //
    case Integer of
      0:
        (LongAddr: Cardinal;);
      1:
        (ByteAddr: array [0 .. 15] of Byte;
          Family: Byte;
        );
  end;

  TQDnsLookupOrder = (dloSystemFirst, dloEventFirst);

  TQDnsEntry = class(TObject)
  protected
    FFirst, FLast, FActive: PQDnsEntryItem;
  public
    constructor Create(const AValue: QStringW; DnsTTL: Cardinal); overload;
    destructor Destroy; override;
    procedure Clean;
    function First: PQDnsEntryItem; inline;
    function Last: PQDnsEntryItem; inline;
    function Next: PQDnsEntryItem;
    property Active: PQDnsEntryItem read FActive;
  end;

  // IQStreamOwner=interface
  // ['{F07DE00B-72AF-4827-A482-5AD76C442B9C}']
  // function LockRead(AOffset:Int64;ABuffer:Pointer;ACount:Integer):Integer;
  // function LockWrite(AOffset:Int64;ABuffer:Pointer;ACount:Integer):Integer;
  // end;
  // TQStreamOwner=class(TInterfacedObject,IQStreamOwner)
  //
  // end;
  // TQRangeStream=class(TStream)
  // protected
  // FStart,FCount:Int64;
  // F
  // end;
  TQHttpRequests = class
  private
    class var CurlInitialized: Boolean;
    procedure SetMaxClients(const Value: Integer);

  protected
    FRequests: TQRequestList;
    FHttpClients: TQSimplePool;
    FMaxClients, FBusyClients: Integer;
    FMaxRequestTimeout: Cardinal;
    FDefaultHeaders: IQHttpHeaders;
    FAfterRequestDone: TQHttpRequestNotifyEvent;
    FOnDnsLookup: TQHttpDNSLookupEvent;
    FOnClientRetry: TQHttpRequestRetryNotify;
    FCS: TCriticalSection;
    FCookieManager: IQHttpCookies;
    FDNSCaches: TStringList;
    FEngine: TQHttpClientEngine;
    FDnsLookupOrder: TQDnsLookupOrder;
    FOnGetSSLProtocol: TQHttpGetSSLProtocolEvent;
    FOnVerifyCertificate: TQCertificateValidEvent;
    FDnsTTL: Cardinal;
    procedure Start(ARequest: IQHttpRequestItem);
    procedure RequestDone(ARequest: IQHttpRequestItem);
    procedure DoEventReqDone(ASender: TObject);
    procedure Lock; inline;
    procedure Unlock; inline;
    procedure DoNewHttpClient(ASender: TQSimplePool; var AData: Pointer);
    procedure DoFreeHttpClient(ASender: TQSimplePool; AData: Pointer);
    procedure SetEngine(const Value: TQHttpClientEngine);
    procedure CheckCurlInitialized;
    function DnsLookup(AHost: String): Cardinal;
    procedure DoClientDnsLookup(Sender: TObject; const AHost: QStringW;
      var Addr: QStringW);
    procedure DoClientRetry(Sender: TObject; const AClient: IQHttpClient;
      ATryTimes: Integer; var AContinue: Boolean);
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure Push(ARequest: IQHttpRequestItem); virtual;
    procedure Clear(AExclude: IQHttpRequestItem = nil);
    function Get(const AUrl: QStringW; var AResult: QStringW;
      AHeaders: IQHttpHeaders = nil; AHttpStatusText: PQStringW = nil)
      : Integer; overload;
    function Get(const AUrl: QStringW; AReplyStream: TStream;
      AHeaders: IQHttpHeaders = nil; AHttpStatusText: PQStringW = nil;
      AOnProgress: TQDownloadProgressEvent = nil): Integer; overload;
    function Post(const AUrl: QStringW; var AResult: QStringW;
      AHeaders: IQHttpHeaders = nil; AHttpStatusText: PQStringW = nil)
      : Integer; overload;
    function Post(const AUrl: QStringW; AReplyStream: TStream;
      AHeaders: IQHttpHeaders = nil; AHttpStatusText: PQStringW = nil)
      : Integer; overload;
    function Post(const AUrl: QStringW; AFormParams: TStrings;
      AReplyStream: TStream; AfterDone: TNotifyEvent = nil;
      AHeaders: IQHttpHeaders = nil; AHttpStatusText: PQStringW = nil)
      : Integer; overload;
    function Post(const AUrl: QStringW; AFormParams: TStrings;
      var AReply: QStringW; AHttpStatusText: PQStringW = nil): Integer;
      overload;
    function Post(const AUrl: QStringW; AContent: TStrings;
      AReplyStream: TStream; AContentType: QStringW = 'text/plain';
      AfterDone: TNotifyEvent = nil; AHeaders: IQHttpHeaders = nil;
      AHttpStatusText: PQStringW = nil): Integer; overload;
    function Post(const AUrl: QStringW; AContent: QStringW;
      var AReply: QStringW; AContentType: QStringW = 'text/plain';
      AHttpStatusText: PQStringW = nil): Integer; overload;
    function Post(const AUrl: QStringW; AContent, AReplyStream: TStream;
      AContentType: QStringW = 'application/octet-stream';
      AfterDone: TNotifyEvent = nil; AHeaders: IQHttpHeaders = nil;
      AHttpStatusText: PQStringW = nil): Integer; overload;
    function Rest(const AUrl: QStringW; ASource, AResult: TQJson;
      AHeaders: IQHttpHeaders = nil; AfterDone: TNotifyEvent = nil;
      Action: TQHttpClientAction = reqUnknown; AHttpStatusText: PQStringW = nil)
      : Integer; overload; virtual;
    function Rest(const AUrl: QStringW; AContent: QStringW; AResult: TQJson;
      AHeaders: IQHttpHeaders = nil; AfterDone: TNotifyEvent = nil;
      Action: TQHttpClientAction = reqUnknown; AHttpStatusText: PQStringW = nil)
      : Integer; overload; virtual;
    function Rest(const AUrl: QStringW; AParams: TStrings; AResult: TQJson;
      AHeaders: IQHttpHeaders = nil; AfterDone: TNotifyEvent = nil;
      Action: TQHttpClientAction = reqUnknown; AHttpStatusText: PQStringW = nil)
      : Integer; overload; virtual;
    function Soap(const AUrl, Action, ARequestBody: QStringW;
      var AResult: QStringW; AHttpStatusText: PQStringW = nil)
      : Integer; virtual;
    function NewHeaders: IQHttpHeaders;
    property MaxClients: Integer read FMaxClients write SetMaxClients;
    property MaxRequestTimeout: Cardinal read FMaxRequestTimeout
      write FMaxRequestTimeout;
    property DefaultHeaders: IQHttpHeaders read FDefaultHeaders;
    property DnsTTL: Cardinal read FDnsTTL write FDnsTTL;
    property AfterRequestDone: TQHttpRequestNotifyEvent read FAfterRequestDone
      write FAfterRequestDone;
    property OnDnsLookup: TQHttpDNSLookupEvent read FOnDnsLookup
      write FOnDnsLookup;
    property Engine: TQHttpClientEngine read FEngine write SetEngine;
    property DnsLookupOrder: TQDnsLookupOrder read FDnsLookupOrder
      write FDnsLookupOrder;
    property OnClientRetry: TQHttpRequestRetryNotify read FOnClientRetry
      write FOnClientRetry;
    property OnGetSSLProtocol: TQHttpGetSSLProtocolEvent read FOnGetSSLProtocol
      write FOnGetSSLProtocol;
    property onVerifyCertificate: TQCertificateValidEvent
      read FOnVerifyCertificate write FOnVerifyCertificate;
  end;

  TQHttpFileDownloadEvent = procedure(ASender: TObject; AHeaders: IQHttpHeaders;
    var AContinue: Boolean) of object;

  TQHttpFileRequestItem = class(TQHttpRequestItem)
  protected
    FFileName: QStringW;
    FPath: QStringW;
    FBeforeDownload: TQHttpFileDownloadEvent;
    FResumeBroken: Boolean;
    FFileSize: Int64;
    FHeadReady: Boolean;
    function GetFilePath: QStringW;
    procedure DoHeadReady(ASender: TObject);
  protected
    procedure BeforePush; override;
    function GetCanStart: Boolean; override;
    function CreateInternalStream: TStream; override;
    procedure DoError(ASender: TObject; AError: Exception);
  public
    property Path: QStringW read FPath write FPath;
    property FileName: QStringW read FFileName write FFileName;
    property FilePath: QStringW read GetFilePath;
    property ResumeBroken: Boolean read FResumeBroken write FResumeBroken;
    property BeforeDownload: TQHttpFileDownloadEvent read FBeforeDownload
      write FBeforeDownload;
    property FileSize: Int64 read FFileSize;
  end;

  TQHttpHeaders = class(TStringList, IQHttpHeaders, IInterface)
  private
    FRefCount: Integer;
  public
    constructor Create; overload;
    function HeaderIndex(AName: QStringW): Integer;
    function HeaderValue(AName, ADefVal: QStringW): QStringW;
    procedure RemoveHeader(AName: QStringW);
    procedure ReplaceHeader(AName, AValue: QStringW);
    function GetHeaderValue(const AName: QStringW): QStringW;
    procedure SetHeaderValue(const AName, AValue: QStringW);
    function GetText: QStringW;
    procedure SetText(const S: QStringW);
    function GetNames(const AIndex: Integer): QStringW;
    function GetValueFromIndex(const AIndex: Integer): QStringW;
    procedure Replace(AHeaders: IQHttpHeaders);
    procedure Merge(AHeaders: IQHttpHeaders);
    procedure Assign(ASource: IQHttpHeaders); overload;
    procedure NeedExists(const AName, ADefVal: QStringW);
    function GetLines(const AIndex: Integer): QStringW;
    procedure SetLines(const AIndex: Integer; const AValue: QStringW);
    procedure Add(const S: QStringW);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  end;

function DNSLookupV4(const AHost: QStringW): Cardinal; overload;
function DNSLookupV4(const AHost: QStringW; var Addr: QStringW)
  : Boolean; overload;
function NewHttpClient(AType: TQHttpClientEngine): IQHttpClient;
function HttpParamValue(const AUrl: QStringW; const AParamName: QStringW;
  AUtfEncoding: Boolean = true): QStringW;

implementation

uses zlib, libcurl{$IFDEF NATIVE_SSL_ENABLED}, qdac_ssl, qdac_ssl_ics{$ENDIF}
{$IFDEF MSWINDOWS} , windows, messages, winsock{$ENDIF}
{$IFDEF POSIX}, System.Net.Socket, Posix.Base, Posix.Stdio, Posix.Pthread,
  Posix.UniStd, IOUtils, Posix.NetDB, Posix.SysSocket, Posix.Fcntl,
  Posix.StrOpts, Posix.NetinetIn, Posix.arpainet, Posix.SysSelect,
  Posix.Systime{$ENDIF};

resourcestring
  SBadHttpFormat = '��Ч��HTTP���ݸ�ʽ';
  SRequestInProcess = '��ǰ�������ڴ�����';
  SZlibError = '���ݽ�ѹʧ��:%s';
  SCantWaitResponseWithNotify = '���������߳��еȴ���������ɵ�ͬʱ��Ӧ���֪ͨ';
  SHttpSupportOnly = 'TQHttpClient ��ǰ��֧�� HTTP Э��.';
  SRedirectToNoHttp = '���� %s �ض����˷� HTTP Э����ַ %s����Э�鵱ǰ����֧��';
  SUserCanceled = '�û�ȡ����ָ���Ĳ���';
  SContnetIsNotJson = '��ǰ���ݲ�����Ч�� Json ��ʽ:'#13#10'%s';
  SDnsLookupFailed = 'DNS ����ʧ�ܣ�����ǰ�����������Ӧ�ñ���ֹ���ӻ�������';

const
  NullQuoter: WideChar = #0;
  SCookie = 'Cookie';
  SCookieSet = 'Set-Cookie';
  DefaultUserAgent = 'Mozilla/5.0 (' +
{$IFDEF MSWINDOWS}'Windows NT 10.0; WOW64' + {$ENDIF}
{$IFDEF ANDROID}'Android 5.0' + {$ENDIF}
{$IFDEF LINUX}'Linux X86_64' + {$ENDIF}
{$IFDEF IOS}'iPhone; CPU iPhone OS 8_4 like Mac OS X' + {$ELSE}
{$IFDEF MACOS}
    'Macintosh; U; Intel Mac OS X 10_6_2' +
{$ENDIF}
{$ENDIF}
    ') AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36 QDAC/3.0';
{$IFDEF POSIX}
  INVALID_SOCKET = IntPtr(not 0);
  SOCKET_ERROR = -1;
  NO_ERROR = 0;
{$ENDIF}

type

{$IFDEF MSWINDOWS}
  TSocketHandle = TSocket;
  SockAddr = TSockAddr;
{$ENDIF}

  TQHttpCookie = class(TInterfacedObject, IQHttpCookie)
  private
    FName, FValue, FDomain, FPath: QStringW;
    FExpires: TDateTime;
    FIsSecure, FIsHttpOnly: Boolean;
    function GetName: QStringW;
    function GetValue: QStringW;
    function GetExpires: TDateTime;
    function GetDomain: QStringW;
    function GetPath: QStringW;
    function GetSecure: Boolean;
    function GetHttpOnly: Boolean;
    function ToString: QStringW; {$IFDEF UNICODE}override; {$ENDIF}
    procedure FromString(const AValue: QStringW);
  public
    constructor Create(const AUrl: TQUrl; const AData: QStringW); overload;
    constructor Create; overload;
  end;

  TQHttpCookies = class(TInterfacedObject, IQHttpCookies)
  protected
    FCookies: TStringList;
    FLocker: TCriticalSection;
    function FirstDomain(const ADomain: QStringW): Integer;
    function Add(AHelper: TQUrl; AValue: QStringW): IQHttpCookie;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear(const ADomain: QStringW = '');
    function AddCookie(const AUrl, AValue: QStringW): IQHttpCookie;
    procedure SetUrlCookies(const AUrl, ACookies: QStringW);
    function GetUrlCookies(const AUrl: QStringW): QStringW;
    function GetCookies(const AIndex: Integer): IQHttpCookie;
    function GetCount: Integer;
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(const AFileName: String);
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(const AFileName: String);
    procedure Lock;
    procedure Unlock;
  end;

  TQBaseHttpClient = class(TInterfacedObject, IQHttpClient, IQHttpsClient)
  private

  protected
    FCookieManager: IQHttpCookies;
    FRequestStream, FResponseStream: TStream;
    FRequestHeaders, FResponseHeaders: IQHttpHeaders;
    FPeerCertificate: IQCertificate;
    FJob: PQJob;
    FAfterDone: TNotifyEvent;
    FOnProgress: TQDownloadProgressEvent;
    FOnRedirect: TQHttpRedirectEvent;
    FOnDnsLookup: TQHttpDNSLookupEvent;
    FOnRetry: TQHttpRequestRetryNotify;
    FOnGetSSLProtocol: TQHttpGetSSLProtocolEvent;
    FOnVerifyCertificate: TQCertificateValidEvent;
    FRedirectTimes, FMaxRedirects, FErrorCode: Integer;
    FConnectTimeout: Cardinal;
    FMaxRequestTimeout: Cardinal;
    FFlags: TQHttpClientFlags;
    FUrl, FFinalUrl, FReplacedUrl, FErrorMessage: QStringW;
    FStatusCode, FRetryTimes: Integer;
    FStatusText: QStringW;
    FStartTime, FStopTime: Cardinal;
    FAction: TQHttpClientAction;

    function GetCookieManager: IQHttpCookies;
    procedure SetCookieManager(const AManager: IQHttpCookies);

    function GetRequestHeaders: IQHttpHeaders; virtual;
    function GetResponseHeaders: IQHttpHeaders; virtual;
    function GetRequestStream: TStream; virtual;
    procedure SetRequestStream(const AStream: TStream); virtual;
    function GetResponseStream: TStream; virtual;
    procedure SetResponseStream(const AStream: TStream); virtual;
    function GetStatusCode: Integer; virtual;
    function GetStatusText: QStringW; virtual;
    function GetPeerCertificate: IQCertificate; virtual;

    function GetFlags: TQHttpClientFlags;
    procedure SetFlags(const AValue: TQHttpClientFlags);
    function GetMaxRedirects: Integer;
    procedure SetMaxRedirects(const AValue: Integer);
    function GetConnectTimeout: Cardinal;
    procedure SetConnectTimeout(const AValue: Cardinal);
    function GetMaxRequestTimeout: Cardinal;
    procedure SetMaxRequestTimeout(const AValue: Cardinal);
    function GetAfterDone: TNotifyEvent;
    procedure SetAfterDone(const AValue: TNotifyEvent);
    function GetOnProgress: TQDownloadProgressEvent;
    procedure SetOnProgress(const AValue: TQDownloadProgressEvent);
    function GetOnRedirect: TQHttpRedirectEvent;
    procedure SetOnRedirect(const AValue: TQHttpRedirectEvent);
    function GetVerifyPeer: Boolean;
    procedure SetVerifyPeer(const AValue: Boolean);
    function GetUrl: QStringW;
    function GetFinalUrl: QStringW;
    procedure DoAsynCall(AJob: PQJob);
    procedure DoAfterDone(AJob: PQJob);
    procedure InternalExecute; virtual; abstract;
    procedure DoExecute;
    function ExecuteRequest: Integer;
    function DoRedirect: Boolean;
    function DecodeStatus(const S: QStringW; var AText: QStringW)
      : Integer; overload;
    procedure DecodeStatus; overload; virtual;
    procedure DoProgress(const Sender: TObject; AContentLength: Int64;
      AReadCount: Int64; var Aborted: Boolean);
    function GetErrorCode: Integer;
    function GetErrorMessage: QStringW;
    function DoError(E: Exception): Boolean; virtual;
    function GetContentAsString: QStringW;
    function GetResponseCharset: QStringW;
    function NeedResponseStream(AReset: Boolean = true): TStream;
    procedure ReplaceHostIfNeeded;
    function GetOnDnsLookup: TQHttpDNSLookupEvent;
    procedure SetOnDnsLookup(const AValue: TQHttpDNSLookupEvent);
    function GetOnRetry: TQHttpRequestRetryNotify;
    procedure SetOnRetry(const AValue: TQHttpRequestRetryNotify);
    function GetOnGetSSLProtocol: TQHttpGetSSLProtocolEvent;
    procedure SetOnGetSSLProtocol(const AValue: TQHttpGetSSLProtocolEvent);
    function GetOnVerifyCertificate: TQCertificateValidEvent;
    procedure SetOnVeriftyCertificate(const AValue: TQCertificateValidEvent);
    function ValidCertificate(ACert: IQCertificate): Boolean;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function Get(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    function Post(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    function Head(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    function Put(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    function Delete(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    function Options(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    function Trace(const AUrl: QStringW; AfterDone: TNotifyEvent)
      : Integer; virtual;
    procedure Reset;
    procedure Cancel;
    property CookieManager: IQHttpCookies read FCookieManager
      write FCookieManager;
    property MaxRequestTimeout: Cardinal read FMaxRequestTimeout
      write FMaxRequestTimeout;
    property onVerifyCertificate: TQCertificateValidEvent
      read FOnVerifyCertificate write FOnVerifyCertificate;
  end;

  TQSysCertificate = class(TQCertificate)
  public
    constructor Create(ACert: TCertificate); overload;
  end;

  TQSysHttpClient = class(TQBaseHttpClient)
  protected
    FClient: THttpClient;
    FResponse: IHttpResponse;
    FActiveHttpsProtocol: Integer;
    function ConvertHeaders(ASource: IQHttpHeaders): TNetHeaders; overload;
    procedure ConvertHeaders(ASource: TNetHeaders;
      ATarget: IQHttpHeaders); overload;
    procedure InternalExecute; override;
    procedure DecodeStatus; override;
    function DoError(E: Exception): Boolean; override;
    procedure DoValidateCertificate(const Sender: TObject;
      const ARequest: TURLRequest; const Certificate: TCertificate;
      var Accepted: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TQNativeHttpClient = class(TQBaseHttpClient)
  protected
    FHandle: THandle;
    FSentBytes, FRecvBytes: Int64;
{$IFDEF NATIVE_SSL_ENABLED}
    FSSL: IQSSLItem;
{$ENDIF}
    procedure InternalExecute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;


  TQCurlHttpClient = class(TQBaseHttpClient)
  protected
    FHandle: THandle;
    procedure InternalExecute; override;
    function DoError(E: Exception): Boolean; override;
    function CheckCurlCode(ACode: TCurlCode;
      ARaiseException: Boolean = true): Boolean;
    class function DoCurlProgress(clientp: Pointer;
      dltotal, dlnow, ultotal, ulnow: Double): Integer; cdecl; static;
    class function DoCurlWriteToStream(buffer: PAnsiChar; Size, nItems: Integer;
      outstream: Pointer): Integer; cdecl; static;
    class function DoCurlReadFromStream(buffer: PAnsiChar; Size, nitem: Integer;
      instream: Pointer): Integer; cdecl; static;
    class function DoCurlSeekInStream(instream: Pointer; offset: Int64;
      origin: Integer): Integer; cdecl; static;
    class function DoCurlResponseHeader(ABuffer: PByte; Size, nItems: Integer;
      userData: Pointer): Integer; cdecl; static;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{$IFDEF POSIX}

  TSockAddrIn = sockaddr_in;
{$ENDIF}
{$IF RTLVersion=18}

const
  ObjCastGUID: TGUID = '{CEDF24DE-80A4-447D-8C75-EB871DC121FD}';

type
  TinflateInit2_ = function(var strm: TZStreamRec; windowBits: Integer;
    version: PAnsiChar; stream_size: Integer): Integer; cdecl;

var
  inflateInit2_: TinflateInit2_ = nil;
  ZLibHandle: HINST;

function ObjectOf(AIntf: IInterface): TObject;
begin
  if not Supports(AIntf, ObjCastGUID, Result) then
    Result := nil;
end;
{$IFEND}

function TryAsAddr(const AHost: QStringW; var AResult: Cardinal): Boolean;
var
  p: PQCharW;
  I, V: Integer;
  B: array [0 .. 3] of Byte absolute AResult;
begin
  p := PQCharW(AHost);
  V := 0;
  I := 0;
  while p^ <> #0 do
  begin
    if (p^ >= '0') and (p^ <= '9') then
      V := V * 10 + Ord(p^) - Ord('0')
    else if p^ = '.' then
    begin
      if V > 255 then
      begin
        Result := false;
        Exit;
      end;
      B[I] := Byte(V);
      Inc(I);
      V := 0;
    end
    else
    begin
      Result := false;
      Exit;
    end;
    Inc(p);
  end;
  Result := (p^ = #0) and (I = 3) and (V < 256);
  if Result then
    B[I] := V;
end;

// IPv4 DNS ����֧�֣���֧�� IPv6
function DNSLookupV4(const AHost: QStringW): Cardinal;
var
  Utf8Host: QStringA;
  AEntry: PHostEnt;

begin
  if not TryAsAddr(AHost, Result) then
  begin
    Result := 0;
    Utf8Host := QString.Utf8Encode(AHost);
    AEntry := gethostbyname
      ({$IFDEF UNICODE}MarshaledAString{$ELSE}PAnsiChar{$ENDIF}(PQCharA(Utf8Host)));
    if Assigned(AEntry) then
    begin
      if AEntry.h_addrtype = AF_INET then
      begin
        if AEntry.h_addr_list^ <> nil then
          Result := PCardinal(AEntry.h_addr_list^)^;
      end;
    end;
  end;
end;

function DNSLookupV4(const AHost: QStringW; var Addr: QStringW): Boolean;
var
  v4addr: Cardinal;
  v4bytes: array [0 .. 3] of Byte absolute v4addr;
begin
  v4addr := DNSLookupV4(AHost);
  Addr := IntToStr(v4bytes[0]) + '.' + IntToStr(v4bytes[1]) + '.' +
    IntToStr(v4bytes[2]) + '.' + IntToStr(v4bytes[3]);
  Result := v4addr <> 0;
end;

function NewHttpClient(AType: TQHttpClientEngine): IQHttpClient;
begin
  case AType of
    hceSystem:
      Result := TQSysHttpClient.Create;
    hceCurl:
      Result := TQCurlHttpClient.Create;
    hceNative:
      Result := TQNativeHttpClient.Create;
  end;
end;

function HttpParamValue(const AUrl: QStringW; const AParamName: QStringW;
  AUtfEncoding: Boolean): QStringW;
var
  p: PQCharW;
  AName: String;
begin
  p := PQCharW(AUrl);
  SkipUntilW(p, '?');
  if p^ = #0 then
    Exit('');
  Inc(p);
  repeat
    AName := DecodeTokenW(p, '=&', #0, false, false);
    if CompareText(AName, AParamName) = 0 then
    begin
      if p^ = '&' then
        SetLength(Result, 0)
      else
      begin
        Inc(p);
        UrlDecode(DecodeTokenW(p, '&', #0, false, false), Result, AUtfEncoding);
      end;
      break;
    end
    else
    begin
      SkipUntilW(p, '&');
      if p^ = '&' then
        Inc(p);
    end;
  until p^ = #0;
end;

function DecodeContentCharset(ARespHeaders: IQHttpHeaders; AStream: TStream)
  : QStringW;
var
  AValue: QStringW;
  APair: QStringW;
const
  ValueDelimiter: PWideChar = ';';

  NullQuoter: WideChar = #0;
  function DequotedValue(S: QStringW): QStringW;
  var
    p: PQCharW;
  begin
    p := PQCharW(S);
    if p^ = '''' then
      Result := DequotedStrW(S)
    else if p^ = '"' then
      Result := DequotedStrW(S, '"')
    else
      Result := S;
  end;
  function DecodeContentType(AValue: QStringW): QStringW;
  begin
    Result := '';
    repeat
      APair := DecodeTokenW(AValue, ValueDelimiter, NullQuoter, false, true);
      if Trim(NameOfW(APair, '=')) = 'charset' then
      begin
        Result := LowerCase(Trim(ValueOfW(APair, '=')));
        break;
      end;
    until Length(AValue) = 0;
  end;
  function CharsetFromHtml: QStringW;
  var
    ABuf: array [0 .. 8191] of Byte; // ��ǰ8K���������������ڣ�����Ϊ������
    AReaded: Integer;
    AText, ALine, AName, APair, AContent: QStringW;
    p, ps: PQCharW;
    AIsContentType: Boolean;
  const
    SpaceChars: PWideChar = ' '#9#13#10;
    TagEnd: PWideChar = '>';
  begin
    AStream.Position := 0;
    AReaded := AStream.read(ABuf[0], 8192);
    // ����ΪAnsi����
    AText := LowerCase(AnsiDecode(PQCharA(@ABuf[0]), AReaded));
    p := PQCharW(AText);
    p := StrStrW(p, '<head>');
    if Assigned(p) then
    begin
      ps := p;
      p := StrStrW(p, '</head>');
      if Assigned(p) then // ֻ���� Header ����
      begin
        AText := StrDupX(ps, (IntPtr(p) - IntPtr(ps)) shr 1);
        p := PQCharW(AText);
      end;
      while Assigned(p) and (p^ <> #0) do
      begin
        p := StrStrW(p, '<meta');
        if Assigned(p) then
        begin
          Inc(p, 5);
          if IsSpaceW(p) then
          begin
            SkipSpaceW(p);
            ps := p;
            SkipUntilW(p, TagEnd);
            ALine := StrDupX(ps, (IntPtr(p) - IntPtr(ps)) shr 1 - 1);
            // />����������
            // <meta charset=xxx> �� <meta http-equiv="content-type" content="text/html; charset=XXX">
            while Length(ALine) > 0 do
            begin
              APair := DecodeTokenW(ALine, SpaceChars, NullQuoter, false, true);
              AName := Trim(NameOfW(APair, '='));
              if AName = 'charset' then
              begin
                Result := DequotedValue(ValueOfW(APair, '='));
                Exit;
              end
              else
              begin
                AContent := '';
                AIsContentType := false;
                repeat
                  if AName = 'content' then
                    AContent := DequotedValue(ValueOfW(APair, '='))
                  else if (AName = 'http-equiv') and
                    (DequotedValue(ValueOfW(APair, '=')) = 'content-type') then
                    AIsContentType := true;
                  APair := DecodeTokenW(ALine, SpaceChars, NullQuoter,
                    false, true);
                  AName := Trim(NameOfW(APair, '='));
                until Length(ALine) = 0;
                if AIsContentType then
                begin
                  Result := DecodeContentType(AContent);
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    Result := '';
  end;

  function CharsetByDetect: QStringW;
  var
    ABuf: array [0 .. 8191] of Byte;
    AReaded: Integer;
    ABom: Boolean;
  begin
    AStream.Position := 0;
    AReaded := AStream.read(ABuf[0], 8192);
    case DetectTextEncoding(@ABuf[0], AReaded, ABom) of
      teUTF8:
        Result := 'utf-8';
      teUnicode16LE:
        Result := 'utf-16';
      teUnicode16BE:
        Result := 'utf-16be'
    else // Unknown,treat as ascii
      Result := 'iso-8859-1';
    end;

  end;
  function CharsetFromStream: QStringW;
  begin
    // ������HTML
    Result := CharsetFromHtml;
    if Length(Result) = 0 then
      Result := CharsetByDetect;
  end;

begin
  Result := DecodeContentType(ARespHeaders.HeaderValue('content-type', ''));
  if Length(Result) = 0 then
    Result := CharsetFromStream;
end;

function DecodeContentText(ARespHeaders: IQHttpHeaders; AStream: TStream)
  : QStringW;
var
  ACharset: QStringW;
  AEncoding: TEncoding;
  function StreamToBytes: TBytes;
  begin
{$IFDEF UNICODE}
    if AStream is TBytesStream then
      Result := (AStream as TBytesStream).Bytes
    else
    begin
{$ENDIF}
      SetLength(Result, AStream.Size);
      AStream.ReadBuffer(Result[0], Length(Result));
{$IFDEF UNICODE}
    end;
{$ENDIF}
  end;

begin
  if AStream.Size > 0 then
  begin
    ACharset := DecodeContentCharset(ARespHeaders, AStream);
    AStream.Position := 0;
    if Length(ACharset) > 0 then
    begin
      if (ACharset = 'utf-8') or (ACharset = 'utf8') then
        // utf8�Ǵ����д������Ϊ�˼��ݼ���
        Result := LoadTextW(AStream, teUTF8)
      else if ACharset = 'utf-16' then
        Result := LoadTextW(AStream, teUnicode16LE)
      else
      begin
{$IFDEF UNICODE}
        begin
          if ACharset = 'gbk' then // GBK��CP936��һ������ҳ
            ACharset := 'cp936';
          AEncoding := TEncoding.GetEncoding(ACharset);
          try
            Result := AEncoding.GetString(StreamToBytes);
          finally
            FreeAndNil(AEncoding);
          end;
        end;
{$ELSE}
        Result := LoadTextW(AStream);
{$ENDIF}
      end;
    end
    else
      Result := LoadTextW(AStream);
  end
  else
    Result := '';
end;

{$IFDEF POSIX}

function closesocket(Socket: TSocketHandle): Integer; inline;
begin
  Result := Posix.UniStd.__close(Socket);
end;

function ioctlsocket(Socket: TSocketHandle; Request: Integer; var Data)
  : Integer; inline;
begin
  Result := ioctl(Socket, Request, @Data);
end;
{$ENDIF}
{$IFDEF MSWINDOWS}

procedure StartSocket;
var
  AData: WSAData;
begin
  if WSAStartup($202, &AData) <> NO_ERROR then
    RaiseLastOSError();
end;

procedure CleanSocket;
begin
  WSACleanup;
end;
{$ELSE}

procedure StartSocket; inline;
begin
end;

procedure CleanSocket; inline;
begin
end;
{$ENDIF}
{ TQUrl }

constructor TQUrl.Create;
begin
  inherited;
end;

procedure TQUrl.Assign(ASource: TQUrl);
begin
  FUrl := ASource.FUrl;
  FUserName := ASource.FUserName;
  FPassword := ASource.FPassword;
  FScheme := ASource.FScheme;
  FHost := ASource.FHost;
  FDocument := ASource.FDocument;
  FBookmark := ASource.FBookmark;
  FPort := ASource.FPort;
  if Assigned(ASource.FParams) then
    Params.Assign(ASource.FParams);
  FChanged := ASource.FChanged;
  FSpaceAsPlus := ASource.SpaceAsPlus;
end;

constructor TQUrl.Create(AUrl: QStringW; ACheckbookmark: Boolean);
begin
  inherited Create;
  FCheckBookmark := ACheckbookmark;
  Url := AUrl;
end;

procedure TQUrl.DecodeParams(const AParams: QStringW);
var
  AName, AValue: QStringW;
  p: PQCharW;
begin
  p := PQCharW(AParams);
  GetParams;
  FParams.BeginUpdate;
  try
    while p^ <> #0 do
    begin
      AValue := DecodeTokenW(p, '&', #0, false, true);
      UrlDecode(NameOfW(AValue, '='), AName);
      UrlDecode(ValueOfW(AValue, '='), AValue);
      FParams.AddPair(AName, AValue);
    end;
  finally
    FParams.EndUpdate;
  end;
end;

destructor TQUrl.Destroy;
begin
  if Assigned(FParams) then
    FreeAndNil(FParams);
  inherited;
end;

procedure TQUrl.DoParamsChanged(ASender: TObject);
begin
  FChanged := true;
end;

function TQUrl.GetDocumentFullPath: QStringW;
  function ExtractPath: QStringW;
  var
    p, ps, pl: PQCharW;
  begin
    p := PQCharW(FDocument);
    pl := p;
    ps := p;
    while p^ <> #0 do
    begin
      if p^ = '/' then
        pl := p;
      Inc(p);
    end;
    Result := StrDupX(ps, (IntPtr(pl) - IntPtr(ps)) shr 1);
  end;

begin
  if Length(FScheme) = 0 then
    Result := 'http'
  else
    Result := LowerCase(FScheme);
  Result := Result + '://';
  if Length(FUserName) > 0 then
  begin
    Result := Result + UrlEncode(FUserName, SpaceAsPlus, true, true, ubeAll);
    if Length(FPassword) > 0 then
      Result := Result + ':' + UrlEncode(FPassword, SpaceAsPlus, true,
        true, ubeAll);
    Result := Result + '@';
  end;
  Result := Result + RequestHost;
  if Length(FDocument) = 0 then
    Result := Result + '/'
  else
    Result := Result + ExtractPath + '/';
end;

function TQUrl.GetDocumentWithParams: QStringW;
begin
  if Length(FDocument) = 0 then
    Result := '/'
  else
    Result := FDocument;
  if Assigned(FParams) and (FParams.Count > 0) then
    Result := Result + '?' + FullParams;
  if Length(FBookmark) > 0 then
    Result := Result + '#' + UrlEncode(FBookmark, SpaceAsPlus, true,
      true, ubeAll);
end;

function TQUrl.GetFullParams: QStringW;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FParams.Count - 1 do
  begin
    if I = 0 then
      Result := Result + UrlEncode(FParams.Names[I], SpaceAsPlus, true, true,
        ubeAll) + '=' + UrlEncode(FParams.ValueFromIndex[I], SpaceAsPlus, true,
        true, ubeAll)
    else
      Result := Result + '&' + UrlEncode(FParams.Names[I], SpaceAsPlus, true,
        true, ubeAll) + '=' + UrlEncode(FParams.ValueFromIndex[I], SpaceAsPlus,
        true, true, ubeAll);
  end;
end;

function TQUrl.GetHostAddr: QStringW;
begin
  DNSLookupV4(Host, Result);
end;

function TQUrl.GetIPAddr: Cardinal;
begin
  Result := DNSLookupV4(Host);
end;

function TQUrl.GetOriginNames: QStringW;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FParams.Count - 1 do
  begin
    if I = 0 then
      Result := FParams.Names[I]
    else
      Result := Result + ',' + FParams.Names[I];
  end;
end;

function TQUrl.GetOriginParams: QStringW;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FParams.Count - 1 do
  begin
    if I = 0 then
      Result := Result + FParams.Names[I] + '=' + FParams.ValueFromIndex[I]
    else
      Result := Result + '&' + FParams.Names[I] + '=' +
        FParams.ValueFromIndex[I];
  end;
end;

function TQUrl.GetOriginValues: QStringW;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to FParams.Count - 1 do
  begin
    if I = 0 then
      Result := FParams.ValueFromIndex[I]
    else
      Result := Result + ',' + FParams.ValueFromIndex[I];
  end;
end;

function TQUrl.GetParams: TStrings;
begin
  if not Assigned(FParams) then
  begin
    FParams := TStringList.Create;
    FParams.OnChange := DoParamsChanged;
  end;
  Result := FParams;
end;

function TQUrl.GetPort: Word;
begin
  if FPort = 0 then
    Result := SchemePort
  else
    Result := FPort;
end;

function TQUrl.GetRequestHost: QStringW;
var
  ADefPort: Word;
begin
  Result := FHost;
  ADefPort := GetSchemePort;
  if FPort = 0 then
    FPort := ADefPort
  else if (FPort <> ADefPort) or (FPort = 0) then
    Result := Result + ':' + IntToStr(FPort);
end;

function TQUrl.GetSchemePort: Word;
var
  S: QStringW;
begin
  S := LowerCase(FScheme);
  if (Length(S) = 0) or (S = 'http') then
    Result := 80
  else if S = 'https' then
    Result := 443
  else if S = 'ftp' then
    Result := 21
  else if S = 'ssh' then
    Result := 22
  else
    Result := 0;
end;

function TQUrl.GetUrl: QStringW;

// Format:scheme://username:password@host:port/documentpath?param1=value1[&param_n=value_n]#Bookmark
  procedure DoEncode;
  begin
    if Length(FScheme) = 0 then
      FUrl := 'http'
    else
      FUrl := LowerCase(FScheme);
    FUrl := FUrl + '://';
    if Length(FUserName) > 0 then
    begin
      FUrl := FUrl + UrlEncode(FUserName, SpaceAsPlus, true, true, ubeAll);
      if Length(FPassword) > 0 then
        FUrl := FUrl + ':' + UrlEncode(FPassword, SpaceAsPlus, true,
          true, ubeAll);
      FUrl := FUrl + '@';
    end;
    FUrl := FUrl + RequestHost;
    FUrl := FUrl + FullDocument;
    FChanged := false;
  end;

begin
  if FChanged then
    DoEncode;
  Result := FUrl;
end;

function TQUrl.GetUrlWithoutParams: QStringW;
begin
  Result := '';
  if Length(FScheme) = 0 then
    Result := 'http'
  else
    Result := LowerCase(FScheme);
  Result := Result + '://';
  if Length(FUserName) > 0 then
  begin
    Result := Result + UrlEncode(FUserName, SpaceAsPlus, true, true, ubeAll);
    if Length(FPassword) > 0 then
      Result := Result + ':' + UrlEncode(FPassword, SpaceAsPlus, true,
        true, ubeAll);
    Result := Result + '@';
  end;
  Result := Result + RequestHost;
  Result := Result + Document;
end;

procedure TQUrl.RandSortParams;
// �˺�����������˳����������,�Ա����û��Ӳ���˳���Ʋ�ǩ��һ��Ĺ���
var
  I, L, R: Integer;
begin
  for I := 0 to FParams.Count - 1 do
  begin
    L := Random(FParams.Count);
    R := Random(FParams.Count);
    if L <> R then
      FParams.Exchange(L, R);
  end;
end;

procedure TQUrl.SetBookmark(const Value: QStringW);
begin
  if FBookmark <> Value then
  begin
    FBookmark := Value;
    FChanged := true;
  end;
end;

procedure TQUrl.SetDocument(const Value: QStringW);
begin
  if FDocument <> Value then
  begin
    if Length(Value) > 0 then
    begin
      if PQCharW(Value)^ <> '/' then
        FDocument := '/' + Value
      else
        FDocument := Value;
    end
    else
      FDocument := '/';

    FChanged := true;
  end;
end;

procedure TQUrl.SetFullParams(const Value: QStringW);
begin
  FParams.Clear;
  DecodeParams(Value);
end;

procedure TQUrl.SetHost(const Value: QStringW);
begin
  if FHost <> Value then
  begin
    FHost := Value;
    FChanged := true;
  end;
end;

procedure TQUrl.SetPort(const Value: Word);
begin
  if FPort <> Value then
  begin
    FPort := Value;
    FChanged := true;
  end;
end;

procedure TQUrl.SetScheme(const Value: QStringW);
begin
  if FScheme <> Value then
  begin
    FScheme := Value;
    FChanged := true;
  end;
end;

procedure TQUrl.SetUrl(const Value: QStringW);
const
  NamePasswordDelimiter: PWideChar = ':';
  NameHostDelimiter: PWideChar = '@';
  BookmarkDelimiter: PWideChar = '#';
var
  AParams: TStringList;
  ADoc: QStringW;
  procedure DecodeNamePassword;
  var
    p, ps, pl: PQCharW;
  begin
    p := PQCharW(FHost);
    ps := p;
    pl := nil;
    while p^ <> #0 do
    begin
      if p^ = '@' then
        pl := p;
      Inc(p);
    end;
    if Assigned(pl) then
    begin
      Inc(pl);
      FHost := pl;
      FPassword := StrDupX(ps, pl - ps - 1);
      FUserName := DecodeTokenW(FPassword, NamePasswordDelimiter, NullQuoter,
        true, true);
    end
    else
    begin
      SetLength(FPassword, 0);
      SetLength(FUserName, 0);
    end;
  end;

begin
  if FUrl <> Value then
  begin
    FUrl := Value;
    AParams := TStringList.Create;
    try
      if UrlDecode(Value, FScheme, FHost, ADoc, FPort, AParams, true) then
      begin
        Document := ADoc;
        if AParams.Count > 0 then
        begin
          if FCheckBookmark then
          begin
            // ����Bookmark
            FBookmark := AParams.ValueFromIndex[AParams.Count - 1];
            AParams.ValueFromIndex[AParams.Count - 1] :=
              DecodeTokenW(FBookmark, BookmarkDelimiter, NullQuoter,
              true, true);
          end;
          Params.Assign(AParams);
        end
        else
          FBookmark := '';
        // UrlDecode �������������п��ܰ����û�����������Ҫ���ж���Ĵ�����UserName:Password@��������
        DecodeNamePassword;
      end
      else
      begin
        FScheme := '';
        FHost := '';
        FDocument := '';
        FUserName := '';
        FPassword := '';
        FBookmark := '';
        FPort := 0;
        if Assigned(FParams) then
          FParams.Clear;
      end;
    finally
      FreeAndNil(AParams);
      FChanged := false;
    end;
  end;
end;

function SortByName(List: TStringList; Index1, Index2: Integer): Integer;
begin
{$IF RTLVersion>=31}
  if List.UseLocale then
  begin
    if List.CaseSensitive then
      Result := AnsiCompareStr(List.Names[Index1], List.Names[Index2])
    else
      Result := AnsiCompareText(List.Names[Index1], List.Names[Index2])
  end
  else
{$IFEND}
  begin
    if List.CaseSensitive then
      Result := CompareStr(List.Names[Index1], List.Names[Index2])
    else
      Result := CompareText(List.Names[Index1], List.Names[Index2]);
  end;
end;

procedure TQUrl.SortParams(ACaseSensitive, AUseLocale: Boolean;
  Compare: TStringListSortCompare);
begin
  FParams.CaseSensitive := ACaseSensitive;
{$IF RTLVersion>=31}
  FParams.UseLocale := AUseLocale;
{$IFEND}
  if Assigned(Compare) then
    FParams.CustomSort(Compare)
  else
    FParams.CustomSort(SortByName);
end;

{ TQHttpHeaders }

procedure TQHttpHeaders.Add(const S: QStringW);
begin
  inherited Add(S);
end;

procedure TQHttpHeaders.Assign(ASource: IQHttpHeaders);
begin
  if ASource is TQHttpHeaders then
    inherited Assign(ASource as TQHttpHeaders)
  else
  begin
    Clear;
    Merge(ASource);
  end;
end;

constructor TQHttpHeaders.Create;
begin
  inherited;
  NameValueSeparator := ':';
end;

function TQHttpHeaders.GetHeaderValue(const AName: QStringW): QStringW;
begin
  Result := Values[AName];
end;

function TQHttpHeaders.GetLines(const AIndex: Integer): QStringW;
begin
  Result := Get(AIndex);
end;

procedure TQHttpHeaders.SetLines(const AIndex: Integer; const AValue: QStringW);
begin
  Put(AIndex, AValue);
end;

function TQHttpHeaders.GetNames(const AIndex: Integer): QStringW;
begin
  Result := Names[AIndex];
end;

function TQHttpHeaders.GetText: QStringW;
begin
  Result := inherited GetText;
end;

function TQHttpHeaders.GetValueFromIndex(const AIndex: Integer): QStringW;
begin
  Result := inherited ValueFromIndex[AIndex];
end;

function TQHttpHeaders.HeaderIndex(AName: QStringW): Integer;
var
  I: Integer;
begin
  Result := -1;
  AName := LowerCase(AName);
  for I := 0 to Count - 1 do
  begin
    if SameText(NameOfW(Strings[I], ':'), AName) then
    begin
      Result := I;
      break;
    end;
  end;
end;

function TQHttpHeaders.HeaderValue(AName, ADefVal: QStringW): QStringW;
var
  AIdx: Integer;
begin
  AIdx := HeaderIndex(AName);
  if AIdx <> -1 then
    Result := Trim(ValueOfW(Strings[AIdx], ':'))
  else
    Result := ADefVal;
end;

procedure TQHttpHeaders.Merge(AHeaders: IQHttpHeaders);
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    Values[AHeaders.Names[I]] := AHeaders.ValueFromIndex[I];
end;

procedure TQHttpHeaders.NeedExists(const AName, ADefVal: QStringW);
begin
  if HeaderIndex(AName) = -1 then
    Values[AName] := ADefVal;
end;

function TQHttpHeaders.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
{$IF RTLVersion=18}
  if SameId(IID, ObjCastGUID) then
  begin
    Pointer(Obj) := Pointer(Self);
    Result := S_OK;
  end
  else
{$IFEND}
  begin
    if GetInterface(IID, Obj) then
      Result := S_OK
    else
      Result := E_NOINTERFACE;
  end;
end;

procedure TQHttpHeaders.RemoveHeader(AName: QStringW);
var
  AIdx: Integer;
begin
  AIdx := HeaderIndex(AName);
  if AIdx <> -1 then
    Delete(AIdx);
end;

procedure TQHttpHeaders.Replace(AHeaders: IQHttpHeaders);
var
  I: Integer;
begin
  for I := 0 to AHeaders.Count - 1 do
    ReplaceHeader(AHeaders.Names[I], AHeaders.ValueFromIndex[I]);
end;

procedure TQHttpHeaders.ReplaceHeader(AName, AValue: QStringW);
var
  AIdx: Integer;
begin
  AIdx := HeaderIndex(AName);
  if AIdx <> -1 then
    Strings[AIdx] := AName + ':' + AValue
  else
    Add(AName + ':' + AValue);
end;

procedure TQHttpHeaders.SetHeaderValue(const AName, AValue: QStringW);
begin
  Values[AName] := AValue;
end;

procedure TQHttpHeaders.SetText(const S: QStringW);
begin
  inherited SetTextStr(S);
end;

function TQHttpHeaders._AddRef: Integer;
begin
{$IFNDEF AUTOREFCOUNT}
  Result := AtomicIncrement(FRefCount);
{$ELSE}
  Result := __ObjAddRef;
{$ENDIF}
end;

function TQHttpHeaders._Release: Integer;
var
  LRef: Integer;
const
  objDestroyingFlag = Integer($80000000);
begin
{$IFNDEF AUTOREFCOUNT}
  Result := AtomicDecrement(FRefCount);
  if Result = 0 then
  begin
    repeat
      LRef := FRefCount;
    until AtomicCmpExchange(FRefCount, LRef or objDestroyingFlag, LRef) = LRef;
    Destroy;
  end;
{$ELSE}
  Result := __ObjRelease;
{$ENDIF}
end;

{ TQHttpRequestItem }

procedure TQHttpRequestItem.AfterPush;
begin

end;

procedure TQHttpRequestItem.BeforePush;
begin

end;

constructor TQHttpRequestItem.Create(ASender: TObject; AIsSyncMode: Boolean);
begin
  inherited Create;
  InternalCreate(ASender, AIsSyncMode);
end;

constructor TQHttpRequestItem.Create(ASender: TObject);
begin
  inherited Create;
  InternalCreate(ASender, false);
end;

function TQHttpRequestItem.CreateInternalStream: TStream;
begin
  Result := TQHttpMemoryStream.Create;
end;

destructor TQHttpRequestItem.Destroy;
begin
{$IFDEF DEBUG_LOG}
  DebugOut('Request %x free', [IntPtr(Self)]);
  // PostLog(llDebug, 'Request %x free', [IntPtr(Self)]);
{$ENDIF}
  if Assigned(FResponseStream) and FResponseStreamOwner then
    FreeAndNil(FResponseStream);
  if Assigned(FRequestStream) and FRequestStreamOwner then
  begin
    // DebugOut('Free request stream %x', [IntPtr(FRequestStream)]);
    FreeAndNil(FRequestStream);

  end;
  if Assigned(FSyncEvent) then
    FreeAndNil(FSyncEvent);
  inherited;
end;

procedure TQHttpRequestItem.DoAfterDone(ASender: TObject);
begin
  FStopTime := Now;
  if Assigned(HttpClient) then
  begin
    FResponseHeaders.Assign(HttpClient.ResponseHeaders);
    if HttpClient.ErrorCode <> 0 then
    begin
      FStatusCode := 1000 + HttpClient.ErrorCode;
      FStatusText := HttpClient.ErrorMessage;
    end
    else
    begin
      FStatusCode := HttpClient.StatusCode;
      FStatusText := HttpClient.StatusText;
    end;
    FResultUrl := HttpClient.FinalUrl;
  end;
  if not FAbort then
    DoProgress;
  if MainThreadNotify then
    TThread.Synchronize(nil, DoMainThreadAfterDone)
  else
    DoMainThreadAfterDone;
end;

procedure TQHttpRequestItem.DoClientBound;
begin
  if Assigned(FOnClientBound) then
    FOnClientBound(Self, FHttpClient);
end;

procedure TQHttpRequestItem.DoClientRedirect(ASender: TObject;
  ANewUrl: QStringW; var Allow: Boolean);
begin
  FResultUrl := ANewUrl;
  if MainThreadNotify then
    TThread.Synchronize(nil, DoRedirect)
  else
    DoRedirect;
  Allow := FAllowRedirect;
end;

procedure TQHttpRequestItem.DoError;
begin
  if Assigned(OnError) then
    OnError(Self, FLastException);
  FLastException := nil;
end;

procedure TQHttpRequestItem.DoMainThreadAfterDone;
var
  AHelper: IInterface;
begin
  AHelper := Self;
  try
    if Assigned(FAfterDone) then
      FAfterDone(Self);
  finally
    if Assigned(FQueue) then
      FQueue.RequestDone(Self);
    if Assigned(FSyncEvent) and (not Assigned(FAfterDone)) then
      FSyncEvent.SetEvent;
  end;
  AHelper := nil;
end;

procedure TQHttpRequestItem.DoMainThreadRecvProgress;
begin
  if Assigned(FOnRecvData) then
    FOnRecvData(Self, FTotalBytes, FRecvBytes, FAbort);
end;

function TQHttpRequestItem.DoProgress: Boolean;
begin
  if Assigned(FOnRecvData) then
  begin
    if MainThreadNotify then
      TThread.Synchronize(nil, DoMainThreadRecvProgress)
    else
      FOnRecvData(Self, FTotalBytes, FRecvBytes, FAbort);
  end;
  Result := FAbort;
  if FAbort then
  begin
    FStatusCode := 1223;
    // Windows Error code of ERROR_CANCELLED;
    FStatusText := SUserCanceled;
  end;
end;

procedure TQHttpRequestItem.DoRedirect;
begin
  FAllowRedirect := true;
  Inc(FRedirectTimes);
  if Assigned(FBeforeUrlRedirect) then
    FBeforeUrlRedirect(Self, FAllowRedirect);
end;

procedure TQHttpRequestItem.DoProgress(const Sender: TObject;
  AContentLength, AReadCount: Int64; var Abort: Boolean);
begin
  FRecvBytes := AReadCount;
  FTotalBytes := AContentLength;
  FLastIOTick := GetTickCount;
{$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount;
  if Assigned(FOnRecvData) then
  begin
    if FLastIOTick - FLastProgressTick > FProgressInterval then
    begin
      FLastProgressTick := FLastIOTick;
      Abort := DoProgress;
    end;
  end;
end;

function TQHttpRequestItem.GetAction: TQHttpClientAction;
begin
  Result := FAction;
end;

function TQHttpRequestItem.GetAfterDone: TNotifyEvent;
begin
  Result := AfterDone;
end;

function TQHttpRequestItem.GetBeforeUrlRedirect: TQUrlRedirectEvent;
begin
  Result := BeforeUrlRedirect;
end;

function TQHttpRequestItem.GetCanStart: Boolean;
begin
  if not IsAppTerminated then
    Result := not Assigned(FHttpClient)
  else
    Result := false;
end;

function TQHttpRequestItem.GetConnectionTimeout: Cardinal;
begin
  Result := FConnectionTimeout;
end;

function TQHttpRequestItem.GetContentAsString: QStringW;
begin
  Result := DecodeContentText(ResponseHeaders, ResponseStream);
end;

function TQHttpRequestItem.GetHttpClient: IQHttpClient;
begin
  Result := FHttpClient;
end;

function TQHttpRequestItem.GetIsAborted: Boolean;
begin
  Result := FAbort;
end;

function TQHttpRequestItem.GetMainThreadNotify: Boolean;
begin
  Result := FMainThreadNotify;
end;

function TQHttpRequestItem.GetMaxRedirectTimes: Integer;
begin
  Result := FMaxRedirectTimes;
end;

function TQHttpRequestItem.GetOnClientBound: TQHttpRequestClientBoundEvent;
begin
  Result := FOnClientBound;
end;

function TQHttpRequestItem.GetOnError: TQHttpErrorEvent;
begin
  Result := FOnError;
end;

function TQHttpRequestItem.GetOnRecvData: TQDownloadProgressEvent;
begin
  Result := FOnRecvData;
end;

function TQHttpRequestItem.GetProgressInterval: Cardinal;
begin
  Result := FProgressInterval;
end;

function TQHttpRequestItem.GetResponseStream: TStream;
begin
  if not Assigned(FResponseStream) then
  begin
    if not FAbort then
    begin
      FResponseStream := CreateInternalStream;
      FResponseStreamOwner := true;
    end;
  end;
  Result := FResponseStream;
end;

function TQHttpRequestItem.GetRecvBytes: Int64;
begin
  Result := FRecvBytes;
end;

function TQHttpRequestItem.GetRedirectTimes: Integer;
begin
  Result := FRedirectTimes;
end;

function TQHttpRequestItem.GetRequestHeaders: IQHttpHeaders;
begin
  Result := FRequestHeaders;
end;

function TQHttpRequestItem.GetRequestStream: TStream;
begin
  Result := FRequestStream;
end;

function TQHttpRequestItem.GetResponseCharset: QStringW;
begin
  DecodeContentCharset(ResponseHeaders, ResponseStream);
end;

function TQHttpRequestItem.GetResponseHeaders: IQHttpHeaders;
begin
  Result := FResponseHeaders;
end;

function TQHttpRequestItem.GetResultUrl: QStringW;
begin
  if Length(FResultUrl) = 0 then
    Result := FUrl
  else
    Result := FResultUrl;
end;

function TQHttpRequestItem.GetSender: TObject;
begin
  Result := FSender;
end;

function TQHttpRequestItem.GetSentBytes: Int64;
begin
  Result := FSentBytes;
end;

function TQHttpRequestItem.GetStartTime: TDateTime;
begin
  Result := FStartTime;
end;

function TQHttpRequestItem.GetStatusCode: Integer;
begin
  Result := FStatusCode;
end;

function TQHttpRequestItem.GetStatusText: QStringW;
begin
  Result := FStatusText;
end;

function TQHttpRequestItem.GetStopTime: TDateTime;
begin
  Result := FStopTime;
end;

function TQHttpRequestItem.GetTag: Int64;
begin
  Result := FTag;
end;

function TQHttpRequestItem.GetTotalBytes: Int64;
begin
  Result := FTotalBytes;
end;

function TQHttpRequestItem.GetUrl: QStringW;
begin
  Result := FUrl;
end;

function TQHttpRequestItem.GetUserAgent: QStringW;
begin
  Result := RequestHeaders.HeaderValue('user-agent', DefaultUserAgent)
end;

procedure TQHttpRequestItem.InternalCreate(ASender: TObject;
  AIsSyncMode: Boolean);
begin
  FSender := ASender;
  FRequestHeaders := TQHttpHeaders.Create;
  FResponseHeaders := TQHttpHeaders.Create;
  FMaxRedirectTimes := 3;
  FProgressInterval := 1000;
  FConnectionTimeout := 60000;
  if Sender is TQHttpRequests then
    FMaxRequestTimeout := TQHttpRequests(Sender).MaxRequestTimeout
  else
    FMaxRequestTimeout := 60;
  FAction := reqGet;
  if AIsSyncMode then
    FSyncEvent := TEvent.Create(nil, false, false, '', false);
{$IFDEF DEBUG_LOG}
  DebugOut('Request %x created', [IntPtr(Self)]);
  // PostLog(llDebug, 'Request %x created', [IntPtr(Self)]);
{$ENDIF}
end;

function TQHttpRequestItem.NeedRequestStream: TStream;
begin
  if not Assigned(FRequestStream) then
  begin
    FRequestStream := TQHttpMemoryStream.Create;
    FRequestStreamOwner := true;
{$IFDEF DEBUG_LOG}
    DebugOut('Request %x create stream %x',
      [IntPtr(Self), IntPtr(FRequestStream)]);
    // PostLog(llDebug, 'Request %x create stream %x',
    // [IntPtr(Self), IntPtr(FRequestStream)]);
{$ENDIF}
  end;
  Result := FRequestStream;
end;

procedure TQHttpRequestItem.SetAction(const AValue: TQHttpClientAction);
begin
  FAction := AValue;
end;

procedure TQHttpRequestItem.SetAfterDone(AValue: TNotifyEvent);
begin
  FAfterDone := AValue;
end;

procedure TQHttpRequestItem.SetBeforeUrlRedirect(AValue: TQUrlRedirectEvent);
begin
  FBeforeUrlRedirect := AValue;
end;

procedure TQHttpRequestItem.SetConnectionTimeout(const AValue: Cardinal);
begin
  FConnectionTimeout := AValue;
end;

procedure TQHttpRequestItem.SetHttpClient(const Value: IQHttpClient);
begin
  if FHttpClient <> Value then
  begin
    FHttpClient := Value;
    Assert((Value = nil) or (hcfReady in Value.Flags));
    if Assigned(Value) and Assigned(OnClientBound) then
    begin
      if MainThreadNotify then
        TThread.Synchronize(nil, DoClientBound)
      else
        DoClientBound;
    end;
  end;
end;

procedure TQHttpRequestItem.SetIsAborted(AValue: Boolean);
begin
  FAbort := AValue;
end;

procedure TQHttpRequestItem.SetMainThreadNotify(const AValue: Boolean);
begin
  FMainThreadNotify := AValue;
end;

procedure TQHttpRequestItem.SetMaxRedirectTimes(const AValue: Integer);
begin
  FMaxRedirectTimes := AValue;
  if AValue > 0 then
    FAllowRedirect := true;
end;

procedure TQHttpRequestItem.SetOnClientBound
  (AValue: TQHttpRequestClientBoundEvent);
begin
  FOnClientBound := AValue;
end;

procedure TQHttpRequestItem.SetOnError(AValue: TQHttpErrorEvent);
begin
  FOnError := AValue;
end;

procedure TQHttpRequestItem.SetOnRecvData(AValue: TQDownloadProgressEvent);
begin
  FOnRecvData := AValue;
end;

procedure TQHttpRequestItem.SetProgressInterval(const AValue: Cardinal);
begin
  FProgressInterval := AValue;
end;

procedure TQHttpRequestItem.SetRequestStream(AStream: TStream);
begin
  FRequestStream := AStream;
end;

procedure TQHttpRequestItem.SetResponseStream(const Value: TStream);
begin
  if Value <> FResponseStream then
  begin
    if Assigned(FResponseStream) and FResponseStreamOwner then
      FreeAndNil(FResponseStream);
    FResponseStreamOwner := false;
    FResponseStream := Value;
  end;
end;

procedure TQHttpRequestItem.SetTag(const AValue: Int64);
begin
  FTag := AValue;
end;

procedure TQHttpRequestItem.SetUrl(const AUrl: QStringW);
begin
  FUrl := AUrl;
end;

procedure TQHttpRequestItem.SetUserAgent(const Value: QStringW);
begin
  RequestHeaders.Values['user-agent'] := Value;
end;

function DecodeExceptionErrorCode(AMsg: QStringW): Integer;
var
  p: PQCharW;
begin
  p := PQCharW(AMsg);
  Result := StrToIntDef(StrBetween(p, '(', ')', false), 0);
end;

function TQHttpRequestItem.StartWith(AHttpClient: IQHttpClient): Boolean;
var
  AClient: IQHttpClient;
begin
  // �����ǰ������������ֱ�ӷ���
  Result := CanStart;
  if not Result then
    Exit;
{$IFDEF DEBUG_LOG}
  DebugOut('Request %x start with client %x',
    [IntPtr(Self), IntPtr(AHttpClient as TObject)]);
{$ENDIF}
  HttpClient := AHttpClient;
  FStartTime := Now;
  FRequestHeaderReady := false;
  FStatusCode := 0;
  FStatusText := '';
  FResponse := nil;
  AClient := AHttpClient;
  AClient.OnProgress := DoProgress;
  AClient.ConnectTimeout := FConnectionTimeout;
  AClient.RequestHeaders.Assign(RequestHeaders);
  AClient.RequestHeaders.Values['User-Agent'] := UserAgent;
  AClient.OnRedirect := DoClientRedirect;
  AClient.ResponseStream := ResponseStream;
  AClient.RequestStream := RequestStream;
  AClient.MaxRequestTimeout := MaxRequestTimeout;
  AClient.MaxRedirects := FMaxRedirectTimes;
  AtomicIncrement(FQueue.FBusyClients);
  // AClient.OnVerifyCertificate:=
  case Action of
    reqGet:
      AClient.Get(Url, DoAfterDone);
    reqPost:
      AClient.Post(Url, DoAfterDone);
    reqHead:
      AClient.Head(Url, DoAfterDone);
    reqDelete:
      AClient.Delete(Url, DoAfterDone);
    reqPut:
      AClient.Put(Url, DoAfterDone);
    reqTrace:
      AClient.Trace(Url, DoAfterDone);
    reqOptions:
      AClient.Options(Url, DoAfterDone);
  end;
end;

function TQHttpRequestItem.WaitFor(ATimeout: Cardinal): TWaitResult;
var
  ATick: Cardinal;
  AClient: IQHttpClient;
begin
  if Assigned(FSyncEvent) then
  begin
    Result := wrIOCompletion;
    ATick := {$IFNDEF MSWINDOWS}TThread.{$ENDIF}GetTickCount;
    while IsZero(FStartTime) do
    begin
      if IsAppTerminated then
      begin
        Result := wrAbandoned;
        Exit;
      end;
      MsgSleep(10);
      if {$IFNDEF MSWINDOWS}TThread.{$ENDIF}GetTickCount - ATick >= ATimeout
      then
      begin
        Result := wrTimeout;
        break;
      end;
    end;
    if not IsZero(FStartTime) then
    begin
      repeat
        Result := MsgWaitForEvent(FSyncEvent, ATimeout, true);
        if Result = wrTimeout then
        begin
          if (GetTickCount - FLastIOTick) < ATimeout then
            Result := wrIOCompletion;
        end
        else if Result = wrAbandoned then
          break;
      until Result <> wrIOCompletion;
    end;
  end
  else
    Result := wrError;
  if Result <> wrSignaled then
  begin
    AClient := HttpClient;
    if Assigned(AClient) then
      AClient.Cancel;
    case Result of
      wrTimeout:
        FStatusCode := 12002;
      wrAbandoned:
        FStatusCode := 1223; // ERROR_PROCESS_ABORTED
      wrError:
        FStatusCode := 10014; // WSAEFAULT
    end;
    FStatusText := SysErrorMessage(FStatusCode);
  end;
end;

{ TQHttpRequests }

procedure TQHttpRequests.Clear(AExclude: IQHttpRequestItem);
var
  AReq: IQHttpRequestItem;
  I, C: Integer;
  AEvent: TEvent;
  ATick: Cardinal;
  ABusyClients: array of IQHttpClient;
begin
  AEvent := TEvent.Create;
  SetLength(ABusyClients, FBusyClients);
  C := 0;
  Lock;
  try
    for I := 0 to FRequests.Count - 1 do
    begin
      AReq := FRequests[I];
      if Assigned(AReq.HttpClient) then
      begin
        if C = Length(ABusyClients) then
          SetLength(ABusyClients, C + 4);
        ABusyClients[C] := AReq.HttpClient;
        AReq.HttpClient.Cancel;
        Inc(C);
      end;
    end;
    for I := 0 to FDNSCaches.Count - 1 do
      FreeObject(FDNSCaches.Objects[I]);
    FDNSCaches.Clear;
  finally
    Unlock;
  end;
  // �ȴ����5��
  ATick := {$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount;
  while (FBusyClients > 0) and ({$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount -
    ATick < 5000) do
    MsgWaitForEvent(AEvent, 10);
  FreeAndNil(AEvent);
  Lock;
  try
    I := 0;
    while I < FRequests.Count do
    begin
      AReq := FRequests[I];
      if AReq <> AExclude then
      begin
        with AReq as TQHttpRequestItem do
        begin
          FStatusCode := 1223;
          // Windows Error code of ERROR_CANCELLED;
          FStatusText := SUserCanceled;
          FAbort := true;
          if not Assigned(AReq.HttpClient) then
            RequestDone(AReq)
          else
            Inc(I);
        end;
      end
      else
        Inc(I);
    end;
  finally
    Unlock;
  end;
end;

constructor TQHttpRequests.Create;
begin
  inherited Create;
  FCS := TCriticalSection.Create;
  FRequests := TQRequestList.Create;
  FDNSCaches := TStringList.Create;
  FDNSCaches.Sorted := true;
  FCookieManager := TQHttpCookies.Create;
  FMaxClients := 1; // Ĭ��ֻ��һ������
  FMaxRequestTimeout := 60;
  FHttpClients := TQSimplePool.Create(FMaxClients, SizeOf(Pointer));
  FHttpClients.OnNewItem := DoNewHttpClient;
  FHttpClients.OnFree := DoFreeHttpClient;
  FDefaultHeaders := TQHttpHeaders.Create;
  FDefaultHeaders.Values['User-Agent'] := DefaultUserAgent;
end;

destructor TQHttpRequests.Destroy;
begin
  Clear;
  FreeAndNil(FHttpClients);
  FreeAndNil(FRequests);
  FreeAndNil(FDNSCaches);
  FCookieManager := nil;
  FreeAndNil(FCS);
  inherited;
end;

function TQHttpRequests.DnsLookup(AHost: String): Cardinal;
var
  AEntry, AExistsEntry: TQDnsEntry;
  AItem: PQDnsEntryItem;
  I: Integer;
  Addrs: QStringW;
  function ActiveAddr: Cardinal;
  begin
    Result := 0;
    AItem := AExistsEntry.Active;
    if Assigned(AItem) then
    begin
      repeat
        if AExistsEntry.Active.Family = AF_INET then
        begin
          Result := AExistsEntry.Active.LongAddr;
          Exit;
        end
        else
          AExistsEntry.Next;
      until AItem = AExistsEntry.Active;
    end;
  end;
  procedure DefaultLookup;
  var
    AEntry: PHostEnt;
    pAddr: MarshaledAStringList;
    AValue: in_addr;
  begin
    AEntry := gethostbyname
      ({$IFDEF UNICODE}MarshaledAString{$ELSE}PAnsiChar{$ENDIF}(PQCharA(QString.Utf8Encode(AHost))));
    if Assigned(AEntry) then
    begin
      if AEntry.h_addrtype = AF_INET then
      begin
        pAddr := AEntry.h_addr_list;
        while pAddr^ <> nil do
        begin
          AValue := in_addr(PCardinal(pAddr^)^);
          if (AValue.S_addr <> 0) and (AValue.S_addr <> -1) then
            Addrs := Addrs + inet_ntoa(AValue) + ',';
          Inc(pAddr);
        end;
        if Length(Addrs) > 0 then
          SetLength(Addrs, Length(Addrs) - 1);
      end;
    end;
  end;

begin
  Result := 0;
  AHost := LowerCase(AHost);
  FCS.Enter;
  try
    if FDNSCaches.Find(AHost, I) then
    begin
      AExistsEntry := TQDnsEntry(FDNSCaches.Objects[I]);
      AExistsEntry.Clean;
      Result := ActiveAddr;
      if Result <> 0 then
        Exit;
    end;
  finally
    FCS.Leave;
  end;
  Addrs := '';
  if FDnsLookupOrder = dloSystemFirst then
  begin
    DefaultLookup;
    if Length(Addrs) = 0 then
    begin
      if Assigned(OnDnsLookup) then
        OnDnsLookup(Self, AHost, Addrs);
    end;
  end
  else
  begin
    if Assigned(OnDnsLookup) then
      OnDnsLookup(Self, AHost, Addrs);
    if Length(Addrs) = 0 then
      DefaultLookup;
  end;
  if Length(Addrs) > 0 then
  begin
    AEntry := TQDnsEntry.Create(Addrs, DnsTTL);
    FCS.Enter;
    try
      I := FDNSCaches.AddObject(AHost, AEntry);
      AExistsEntry := TQDnsEntry(FDNSCaches.Objects[I]);
    finally
      FCS.Leave;
      if AExistsEntry <> AEntry then
        FreeAndNil(AEntry);
    end;
    Result := ActiveAddr;
  end;
end;

procedure TQHttpRequests.DoClientDnsLookup(Sender: TObject;
  const AHost: QStringW; var Addr: QStringW);
begin
  Addr := inet_ntoa(in_addr(DnsLookup(AHost)));
end;

procedure TQHttpRequests.DoClientRetry(Sender: TObject;
  const AClient: IQHttpClient; ATryTimes: Integer; var AContinue: Boolean);
begin
  if Assigned(FOnClientRetry) then
    FOnClientRetry(Self, AClient, ATryTimes, AContinue);
end;

procedure TQHttpRequests.DoEventReqDone(ASender: TObject);
var
  AReq: TQHttpRequestItem;
begin
  AReq := ASender as TQHttpRequestItem;
  if Assigned(AReq.FSyncEvent) then
    AReq.FSyncEvent.SetEvent;
end;

procedure TQHttpRequests.DoFreeHttpClient(ASender: TQSimplePool;
  AData: Pointer);
begin
  IQHttpClient(AData) := nil;
end;

procedure TQHttpRequests.DoNewHttpClient(ASender: TQSimplePool;
  var AData: Pointer);
var
  AClient: IQHttpClient;
begin
  AData := nil;
  AClient := NewHttpClient(FEngine);
  IQHttpClient(AData) := AClient;
  AClient.OnDnsLookup := DoClientDnsLookup;
  AClient.OnGetSSLProtocol := OnGetSSLProtocol;
  AClient.onVerifyCertificate := onVerifyCertificate;
end;

function TQHttpRequests.Get(const AUrl: QStringW; var AResult: QStringW;
  AHeaders: IQHttpHeaders; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, true);
  AReq.Url := AUrl;
  AReq.Action := reqGet;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  AReq.AfterDone := DoEventReqDone;
  Push(AReq);
  AReq.WaitFor(MaxRequestTimeout * 1000);
  AResult := AReq.ContentAsString;
  Result := AReq.StatusCode;
  if Assigned(AHttpStatusText) then
    AHttpStatusText^ := AReq.StatusText;
end;

function TQHttpRequests.Get(const AUrl: QStringW; AReplyStream: TStream;
  AHeaders: IQHttpHeaders; AHttpStatusText: PQStringW;
  AOnProgress: TQDownloadProgressEvent): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, true);
  AReq.Url := AUrl;
  AReq.Action := reqGet;
  AReq.ResponseStream := AReplyStream;
  AReq.AfterDone := DoEventReqDone;
  AReq.OnRecvData := AOnProgress;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  AReq.WaitFor(MaxRequestTimeout * 1000);
  Result := AReq.StatusCode;
  if Assigned(AHttpStatusText) then
    AHttpStatusText^ := AReq.StatusText;
end;

procedure TQHttpRequests.Lock;
begin
  FCS.Enter;
end;

function TQHttpRequests.NewHeaders: IQHttpHeaders;
begin
  Result := TQHttpHeaders.Create;
end;

function TQHttpRequests.Post(const AUrl: QStringW; var AResult: QStringW;
  AHeaders: IQHttpHeaders; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, true);
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  AReq.AfterDone := DoEventReqDone;
  Push(AReq);
  AReq.WaitFor(MaxRequestTimeout * 1000);
  AResult := AReq.ContentAsString;
  Result := AReq.StatusCode;
  if Assigned(AHttpStatusText) then
    AHttpStatusText^ := AReq.StatusText;
end;

function TQHttpRequests.Post(const AUrl: QStringW; AReplyStream: TStream;
  AHeaders: IQHttpHeaders; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, true);
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  AReq.ResponseStream := AReplyStream;
  AReq.AfterDone := DoEventReqDone;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  AReq.WaitFor(MaxRequestTimeout * 1000);
  Result := AReq.StatusCode;
  if Assigned(AHttpStatusText) then
    AHttpStatusText^ := AReq.StatusText;
end;

function TQHttpRequests.Post(const AUrl: QStringW; AFormParams: TStrings;
  AReplyStream: TStream; AfterDone: TNotifyEvent; AHeaders: IQHttpHeaders;
  AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
  I: Integer;
  AParams: QStringW;
begin
  AReq := TQHttpRequestItem.Create(Self, not Assigned(AfterDone));
  if not Assigned(AfterDone) then
    AReq.AfterDone := DoEventReqDone
  else
  begin
    AReq.AfterDone := AfterDone;
  end;
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  if Assigned(AFormParams) and (AFormParams.Count > 0) then
  begin
    AReq.Action := reqPost;
    AReq.RequestHeaders.Values['Content-Type'] :=
      'application/x-www-form-urlencoded;charset=UTF-8';
    AParams := '';
    for I := 0 to AFormParams.Count - 1 do
      AParams := AParams + UrlEncode(AFormParams.Names[I], true, true, true,
        ubeAll) + '=' + UrlEncode(AFormParams.ValueFromIndex[I], true, true,
        true, ubeAll) + '&';
    SetLength(AParams, Length(AParams) - 1);
    SaveTextU(AReq.NeedRequestStream, AParams, false);
    AReq.RequestStream.Position := 0;
  end;
  if Assigned(AReplyStream) then
    AReq.ResponseStream := AReplyStream;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  if Assigned(AfterDone) then
    Result := 200
  else
  begin
    AReq.WaitFor(MaxRequestTimeout * 1000);
    Result := AReq.StatusCode;
    if Assigned(AHttpStatusText) then
      AHttpStatusText^ := AReq.StatusText;
  end;
end;

function TQHttpRequests.Post(const AUrl: QStringW; AFormParams: TStrings;
  var AReply: QStringW; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
  I: Integer;
  AParams: QStringW;
begin
  AReq := TQHttpRequestItem.Create(Self, true);
  AReq.AfterDone := DoEventReqDone;
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  if Assigned(AFormParams) and (AFormParams.Count > 0) then
  begin
    AReq.Action := reqPost;
    AReq.RequestHeaders.Values['Content-Type'] :=
      'application/x-www-form-urlencoded;charset=UTF-8';
    AParams := '';
    for I := 0 to AFormParams.Count - 1 do
      AParams := AParams + UrlEncode(AFormParams.Names[I], true, true, true,
        ubeAll) + '=' + UrlEncode(AFormParams.ValueFromIndex[I], true, true,
        true, ubeAll) + '&';
    SetLength(AParams, Length(AParams) - 1);
    SaveTextU(AReq.NeedRequestStream, AParams, false);
    AReq.RequestStream.Position := 0;
  end;
  Push(AReq);
  AReq.WaitFor(MaxRequestTimeout * 1000);
  Result := AReq.StatusCode;
  if Assigned(AHttpStatusText) then
    AHttpStatusText^ := AReq.StatusText;
  if Result = 200 then
    AReply := AReq.ContentAsString
  else
    SetLength(AReply, 0);
end;

function TQHttpRequests.Post(const AUrl: QStringW; AContent: TStrings;
  AReplyStream: TStream; AContentType: QStringW; AfterDone: TNotifyEvent;
  AHeaders: IQHttpHeaders; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, not Assigned(AfterDone));
  if not Assigned(AfterDone) then
    AReq.AfterDone := DoEventReqDone
  else
  begin
    AReq.AfterDone := AfterDone;
  end;
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  if Assigned(AContent) and (AContent.Count > 0) then
  begin
    AReq.Action := reqPost;
    AReq.RequestHeaders.Values['Content-Type'] := AContentType;

    SaveTextU(AReq.NeedRequestStream, AContent.DelimitedText, false);
    AReq.RequestStream.Position := 0;
  end;
  if Assigned(AReplyStream) then
    AReq.ResponseStream := AReplyStream;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  if Assigned(AfterDone) then
    Result := 200
  else
  begin
    AReq.WaitFor(MaxRequestTimeout * 1000);
    Result := AReq.StatusCode;
    if Assigned(AHttpStatusText) then
      AHttpStatusText^ := AReq.StatusText;
  end;
end;

function TQHttpRequests.Post(const AUrl: QStringW; AContent: QStringW;
  var AReply: QStringW; AContentType: QStringW;
  AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, true);
  AReq.AfterDone := DoEventReqDone;
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  if Length(AContent) > 0 then
  begin
    AReq.Action := reqPost;
    AReq.RequestHeaders.Values['Content-Type'] := AContentType;
    SaveTextU(AReq.NeedRequestStream, AContent, false);
    AReq.RequestStream.Position := 0;
  end;
  Push(AReq);
  AReq.WaitFor(MaxRequestTimeout * 1000);
  Result := AReq.StatusCode;
  if Assigned(AHttpStatusText) then
    AHttpStatusText^ := AReq.StatusText;
  if Result = 200 then
    AReply := AReq.ContentAsString
  else
    SetLength(AReply, 0);
end;

function TQHttpRequests.Post(const AUrl: QStringW;
  AContent, AReplyStream: TStream; AContentType: QStringW;
  AfterDone: TNotifyEvent; AHeaders: IQHttpHeaders;
  AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, not Assigned(AfterDone));
  if not Assigned(AfterDone) then
    AReq.AfterDone := DoEventReqDone
  else
  begin
    AReq.AfterDone := AfterDone;
  end;
  AReq.Url := AUrl;
  AReq.Action := reqPost;
  if Assigned(AContent) then
  begin
    AReq.RequestHeaders.Values['Content-Type'] := AContentType;
    AReq.RequestStream := AContent;
  end;
  if Assigned(AReplyStream) then
    AReq.ResponseStream := AReplyStream;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  if Assigned(AfterDone) then
    Result := 200
  else
  begin
    AReq.WaitFor(MaxRequestTimeout * 1000);
    Result := AReq.StatusCode;
    if Assigned(AHttpStatusText) then
      AHttpStatusText^ := AReq.StatusText;
  end;
end;

procedure TQHttpRequests.Push(ARequest: IQHttpRequestItem);
begin
  with ARequest as TQHttpRequestItem do
  begin
    RequestHeaders.Merge(DefaultHeaders);
    FQueue := Self;
    if not(Action in [reqGet, reqHead, reqPost]) then
      // ������ͳһ��Get������֧����������
      Action := reqGet;
    BeforePush;
  end;
  Lock;
  try
    FRequests.Add(ARequest);
  finally
    Unlock;
    ARequest.AfterPush;
  end;
  Start(ARequest);
end;

procedure TQHttpRequests.RequestDone(ARequest: IQHttpRequestItem);
var
  I: Integer;
  AClient: IQHttpClient;
  ATemp: TQHttpRequestItem;
begin
  if Assigned(ARequest) then
  begin
    with ARequest as TQHttpRequestItem do
    begin
      AClient := HttpClient;
      if Assigned(AClient) then
      begin
        HttpClient.Reset;
        AtomicDecrement(FBusyClients);
      end;
      FIsDone := true;
      Lock;
      try
        FRequests.Remove(ARequest);
        if Assigned(AClient) then
        begin
          // DebugOut('%s done,%d client busy', [ATemp.Url, FBusyClients]);
          for I := 0 to FRequests.Count - 1 do
          begin
            ATemp := FRequests[I] as TQHttpRequestItem;
            if not Assigned(ATemp.HttpClient) then
            begin
              if ATemp.StartWith(AClient) then
                Exit;
            end;
          end;
          // û����Ҫ����������ˣ����Լ����Ϊ����
          FHttpClients.Push(AClient);
        end
        // else
        // DebugOut('Request not process by client');
      finally
        Unlock;
        if Assigned(AfterRequestDone) then
          AfterRequestDone(Self, ARequest);
      end;
    end;
  end
  // else
  // DebugOut('!!!!Request done with no request object!!!');
end;

// AReq ���ü������ԣ���Ҫ����
function TQHttpRequests.Rest(const AUrl: QStringW; AContent: QStringW;
  AResult: TQJson; AHeaders: IQHttpHeaders; AfterDone: TNotifyEvent;
  Action: TQHttpClientAction; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin

  AReq := TQHttpRequestItem.Create(Self, not Assigned(AfterDone));
  if not Assigned(AfterDone) then
    AReq.AfterDone := DoEventReqDone
  else
  begin
    AReq.AfterDone := AfterDone;
  end;
  AReq.Url := AUrl;
  if Length(AContent) > 0 then
  begin
    AReq.Action := reqPost;
    AReq.RequestHeaders.Values['Content-Type'] :=
      'application/x-www-form-urlencoded;charset=UTF-8';
    SaveTextU(AReq.NeedRequestStream, AContent, false);
    AReq.RequestStream.Position := 0;
  end
  else if Action = reqUnknown then
    AReq.Action := reqGet
  else
    AReq.Action := Action;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  if Assigned(AfterDone) then
    Result := 200
  else
  begin
    AReq.WaitFor(MaxRequestTimeout * 1000);
    Result := AReq.StatusCode;
    if Assigned(AHttpStatusText) then
      AHttpStatusText^ := AReq.StatusText;
    if Assigned(AResult) and (Result = 200) then
    begin
      if not AResult.TryParse(AReq.ContentAsString) then
        raise Exception.CreateFmt(SContnetIsNotJson, [AReq.ContentAsString]);
    end;
  end;
end;

function TQHttpRequests.Rest(const AUrl: QStringW; ASource, AResult: TQJson;
  AHeaders: IQHttpHeaders; AfterDone: TNotifyEvent; Action: TQHttpClientAction;
  AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
begin
  AReq := TQHttpRequestItem.Create(Self, not Assigned(AfterDone));
  if not Assigned(AfterDone) then
    AReq.AfterDone := DoEventReqDone
  else
  begin
    AReq.AfterDone := AfterDone;
  end;
  AReq.Url := AUrl;
  if Assigned(ASource) then
  begin
    AReq.Action := reqPost;
    AReq.RequestHeaders.Values['Content-Type'] :=
      'application/json;charset=UTF-8';
    ASource.SaveToStream(AReq.NeedRequestStream, teUTF8, false, false);
    AReq.RequestStream.Position := 0;
  end
  else if Action = reqUnknown then
    AReq.Action := reqGet
  else
  begin
    AReq.Action := Action;
  end;
  if Assigned(AHeaders) then
    AReq.RequestHeaders.Replace(AHeaders);
  Push(AReq);
  if Assigned(AfterDone) then
    Result := 200
  else
  begin
    AReq.WaitFor(MaxRequestTimeout * 1000);
    Result := AReq.StatusCode;
    if Assigned(AHttpStatusText) then
      AHttpStatusText^ := AReq.StatusText;
    if Assigned(AResult) and (Result = 200) then
    begin
      if not AResult.TryParse(AReq.ContentAsString) then
        raise Exception.CreateFmt(SContnetIsNotJson, [AReq.ContentAsString]);
    end;
  end;
end;

function TQHttpRequests.Rest(const AUrl: QStringW; AParams: TStrings;
  AResult: TQJson; AHeaders: IQHttpHeaders; AfterDone: TNotifyEvent;
  Action: TQHttpClientAction; AHttpStatusText: PQStringW): Integer;
var
  AContent: QStringW;
  I: Integer;
begin
  AContent := '';
  if Assigned(AParams) then
  begin
    for I := 0 to AParams.Count - 1 do
      AContent := AContent + UrlEncode(AParams.Names[I], true, true, true,
        ubeAll) + '=' + UrlEncode(AParams.ValueFromIndex[I], true, true, true,
        ubeAll) + '&';
  end;
  SetLength(AContent, Length(AContent) - 1);
  Result := Rest(AUrl, AContent, AResult, AHeaders, AfterDone, Action,
    AHttpStatusText);
end;

procedure TQHttpRequests.CheckCurlInitialized;
begin
  if not CurlInitialized then
    curl_global_init(CURL_GLOBAL_ALL);
end;

procedure TQHttpRequests.SetEngine(const Value: TQHttpClientEngine);
var
  AClient: IQHttpClient;
begin
  if FEngine <> Value then
  begin
    Lock;
    try
      FEngine := Value;
      FHttpClients.Clear;
      CheckCurlInitialized;
    finally
      Unlock;
    end;
  end;
end;

procedure TQHttpRequests.SetMaxClients(const Value: Integer);
begin
  if FMaxClients <> Value then
  begin
    if Value > 1 then
      FMaxClients := Value
    else
      FMaxClients := 1;
    FHttpClients.Size := FMaxClients;
  end;
end;

function TQHttpRequests.Soap(const AUrl, Action, ARequestBody: QStringW;
  var AResult: QStringW; AHttpStatusText: PQStringW): Integer;
var
  AReq: IQHttpRequestItem;
  AXML: TQXML;
  p: PQCharW;
begin
  AXML := nil;
  AReq := TQHttpRequestItem.Create(Self, true);
  try
    AReq.AfterDone := DoEventReqDone;
    AReq.Url := AUrl;
    AReq.Action := reqGet;
    Push(AReq);
    AReq.WaitFor(MaxRequestTimeout * 1000);
    if AReq.StatusCode = 200 then
    begin
      AXML := TQXML.Create;
      AXML.Parse(AReq.ContentAsString);

      p := PQCharW(AUrl);
      AReq.Url := DecodeTokenW(p, '?', #0, false, false);
      AReq.Action := reqPost;
      if Length(Action) = 0 then
        AReq.RequestHeaders.Values['SOAPAction'] := '""'
      else
        AReq.RequestHeaders.Values['SOAPAction'] := Action;
      if Length(ARequestBody) > 0 then
      begin
        AReq.Action := reqPost;
        if not StartWithW(PQCharW(ARequestBody), '<?xml', false) then
          SaveTextU(AReq.NeedRequestStream, '<?xml verision="1.0"?>'#13#10 +
            ARequestBody, false)
        else
          SaveTextU(AReq.NeedRequestStream, ARequestBody, false);
        AReq.RequestStream.Position := 0;
        AReq.RequestHeaders.Values['Content-Type'] := 'text/xml; charset=utf-8';
        AReq.RequestHeaders.Values['Content-Length'] :=
          IntToStr(AReq.NeedRequestStream.Size);
      end;
      Push(AReq);
      AReq.WaitFor(MaxRequestTimeout * 1000);
      Result := AReq.StatusCode;
      if Assigned(AHttpStatusText) then
        AHttpStatusText^ := AReq.StatusText;
      if Result = 200 then
        AResult := AReq.ContentAsString
      else
        SetLength(AResult, 0);
    end
    else
      Result := AReq.StatusCode;
  finally
    AReq._Release;
    if Assigned(AXML) then
      FreeAndNil(AXML);
  end;
end;

procedure TQHttpRequests.Start(ARequest: IQHttpRequestItem);
var
  AClient: IQHttpClient;
begin
  Lock;
  try
    if (FBusyClients < FMaxClients) or (FBusyClients = 0) then
    begin
      if ARequest.CanStart then
      begin
        AClient := IQHttpClient(FHttpClients.Pop);
        AClient.CookieManager := FCookieManager;
        (ARequest as TQHttpRequestItem).StartWith(AClient);
      end;
    end
  finally
    Unlock;
  end;
end;

procedure TQHttpRequests.Unlock;
begin
  FCS.Leave;
end;

{ TQHttpDownloader }

function TQHttpFileRequestItem.CreateInternalStream: TStream;
var
  AFileName: QStringW;
begin
  AFileName := FilePath;
  if ResumeBroken then
  begin
    if FileExists(AFileName) then
    begin
      Result := TFileStream.Create(AFileName, fmOpenReadWrite or
        fmShareDenyWrite);
      Result.Seek(0, soFromEnd);
    end
    else
      Result := TFileStream.Create(AFileName, fmCreate);
  end
  else
    Result := TFileStream.Create(AFileName, fmCreate);
end;

procedure TQHttpFileRequestItem.DoError(ASender: TObject; AError: Exception);
begin
  if Assigned(FOnError) then
    FOnError(Self, AError);
end;

procedure TQHttpFileRequestItem.DoHeadReady(ASender: TObject);
var
  AHead: TQHttpRequestItem;
  AFileSize: Int64;
  AContinue: Boolean;
  function DecodeFileName: QStringW;
  var
    Value: QStringW;
  const
    ItemDelimiter: PWideChar = ';';
    NullChar: WideChar = #0;
  begin
    // ����Content-disposition�е��ļ���Լ��
    Value := AHead.ResponseHeaders['content-disposition'];
    while Length(Value) > 0 do
    begin
      Result := Trim(DecodeTokenW(Value, ItemDelimiter, NullChar, false, true));
      if LowerCase(NameOfW(Result, '=')) = 'filename' then
        Result := DequotedStrW(ValueOfW(Result, '='), '"')
      else
        Result := '';
    end;
    // ���û�У���URL�ĵ���Ϊ��
    if Length(Result) = 0 then
    begin
      Result := StrBetweenTimes(AHead.ResultUrl, '/', false, 0, -1);
      Result := StrBeforeW(Result, '?', false, false);
      // �����û�У���URLΪ·��Ϊ��
      if Length(Result) = 0 then
        Result := DeleteCharW(AHead.ResultUrl, ',:/\#@');
    end;
  end;

  procedure CheckHTST;
  var
    AUrl: TQUrl;
  begin
    if Length(AHead.ResponseHeaders['Strict-Transport-Security']) > 0 then
    begin
      AUrl := TQUrl.Create(FUrl);
      try
        if AUrl.Scheme = 'http' then
          AUrl.Scheme := 'https';
        FResultUrl := AUrl.Url;
      finally
        FreeAndNil(AUrl);
      end;
    end;
  end;

begin
  AHead := ASender as TQHttpRequestItem;
  if AHead.StatusCode = 200 then
  begin
    CheckHTST;
    AContinue := true;
    FFileSize := StrToInt64Def(AHead.ResponseHeaders['content-length'], 0);
    if Length(FileName) = 0 then
    begin
      if Length(FileName) = 0 then
        FileName := DecodeFileName;
      if AHead.ResponseHeaders['accept-ranges'] <> 'bytes' then
        // �����������֧�ֶϵ�������������ResumeBrokeΪFalse���Ա������öϵ�����
        ResumeBroken := false
    end;
    AFileSize := SizeOfFile(FilePath);
    if AFileSize > 0 then
    begin
      if AFileSize > FFileSize then
        ResumeBroken := false
      else if AFileSize = FFileSize then
      begin
        AContinue := false;
        FStatusCode := 304;
        FStatusText := 'Not Modified';
        ResumeBroken := false;
      end;
      if ResumeBroken then
        RequestHeaders['Range'] := 'bytes=' + IntToStr(AFileSize) + '-';
    end;
    if AContinue and Assigned(BeforeDownload) then
    begin
      BeforeDownload(Self, AHead.ResponseHeaders, AContinue);
      if not AContinue then
      begin
        FStatusCode := 1223;
        // Windows Error code of ERROR_CANCELLED;
        FStatusText := SUserCanceled;
      end;
    end;
    FHeadReady := true;
  end
  else
  begin
    FStatusCode := AHead.StatusCode;
    FStatusText := AHead.StatusText;
    AContinue := false;
  end;
  if not AContinue then
  begin
    FAbort := true;
    DoAfterDone(Self);
  end;
end;

{ TQHttpFileRequestItem }

procedure TQHttpFileRequestItem.BeforePush;
var
  AHeadReq: TQHttpRequestItem;
begin
  // ����������ļ�������������Head����
  AHeadReq := TQHttpRequestItem.Create(Self, false);
  AHeadReq.Url := Url;
  AHeadReq.Action := reqHead;
  AHeadReq.AfterDone := DoHeadReady;
  AHeadReq.OnError := DoError;
  FQueue.Push(AHeadReq);
  inherited;
end;

function TQHttpFileRequestItem.GetCanStart: Boolean;
begin
  Result := FHeadReady and (Length(FFileName) > 0);
end;

function TQHttpFileRequestItem.GetFilePath: QStringW;
const
  PathDelimiter: QStringW =
{$IFDEF MSWINDOWS}'\'{$ELSE}'/'{$ENDIF};
begin
  if Length(FPath) > 0 then
  begin
    if not EndWithW(FPath, PathDelimiter, false) then
      FPath := FPath + PathDelimiter;
  end;
  Result := FPath + FFileName;
end;

{ TQRequestList }

function TQRequestList.Add(const ARequest: IQHttpRequestItem): Integer;
begin
  ARequest._AddRef;
  Result := FItems.Add(Pointer(ARequest));
end;

procedure TQRequestList.Clear;
var
  I: Integer;
begin
  for I := 0 to FItems.Count - 1 do
    IQHttpRequestItem(FItems[I])._Release;
  FItems.Clear;
end;

constructor TQRequestList.Create;
begin
  inherited;
  FItems := TList.Create;
end;

procedure TQRequestList.Delete(AIndex: Integer);
var
  AItem: IQHttpRequestItem;
begin
  AItem := Items[AIndex];
  AItem._Release;
  FItems.Delete(AIndex);
end;

destructor TQRequestList.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TQRequestList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQRequestList.GetItems(const AIndex: Integer): IQHttpRequestItem;
begin
  Result := IQHttpRequestItem(FItems[AIndex]);
end;

function TQRequestList.IndexOf(const ARequest: IQHttpRequestItem): Integer;
begin
  Result := FItems.IndexOf(Pointer(ARequest));
end;

procedure TQRequestList.Remove(const ARequest: IQHttpRequestItem);
var
  AIdx: Integer;
begin
  AIdx := FItems.IndexOf(Pointer(ARequest));
  if AIdx <> -1 then
    Delete(AIdx);
end;

{ TQHttpCookie }

constructor TQHttpCookie.Create(const AUrl: TQUrl; const AData: QStringW);
begin
  inherited Create;
  FDomain := '.' + AUrl.Host;
  FPath := '/';
  FromString(AData);
end;

constructor TQHttpCookie.Create;
begin
  inherited;
end;

procedure TQHttpCookie.FromString(const AValue: QStringW);
var
  AVal, AName: QStringW;
  p: PQCharW;
begin
  p := PQCharW(AValue);
  SetLength(FName, 0);
  SetLength(FValue, 0);
  FIsHttpOnly := false;
  FIsSecure := false;
  FExpires := 0;
  while p^ <> #0 do
  begin
    AVal := DecodeTokenW(p, ';', #0, false);
    AName := DecodeTokenW(AVal, '=', #0, false, true);
    AVal := DequotedStrW(AVal, '"');
    if Length(FName) = 0 then
    begin
      FName := AName;
      FValue := AVal;
    end
    else if SameText(AName, 'Max-Age') then
      // Do not translate
      FExpires := IncSecond(Now, StrToIntDef(AVal, 0))
    else if SameText(AName, 'Expires') then // Do not translate
      FExpires := DateTimeFromString(AVal)
    else if SameText(AName, 'Path') then // Do not translate
    begin
      if EndWithW(AValue, '/', false) then
        FPath := AVal
      else
        FPath := AVal + '/';
    end
    else if SameText(AName, 'Domain') then // Do not translate
    begin
      if StartWithW(PQCharW(AVal), '.', false) then
        FDomain := AVal
      else
        FDomain := '.' + AVal;
    end
    else if SameText(AName, 'HttpOnly') then // Do not translate
      FIsHttpOnly := true
    else if SameText(AName, 'Secure') then // Do not translate
      FIsSecure := true;
  end;
end;

function TQHttpCookie.GetDomain: QStringW;
begin
  Result := FDomain;
end;

function TQHttpCookie.GetExpires: TDateTime;
begin
  Result := FExpires;
end;

function TQHttpCookie.GetHttpOnly: Boolean;
begin
  Result := FIsHttpOnly;
end;

function TQHttpCookie.GetName: QStringW;
begin
  Result := FName;
end;

function TQHttpCookie.GetPath: QStringW;
begin
  Result := FPath;
end;

function TQHttpCookie.GetSecure: Boolean;
begin
  Result := FIsSecure;
end;

function TQHttpCookie.GetValue: QStringW;
begin
  Result := FValue;
end;

function TQHttpCookie.ToString: QStringW;
begin
  Result := FName + '=' + FValue;
end;

{ TQHttpCookies }

function TQHttpCookies.Add(AHelper: TQUrl; AValue: QStringW): IQHttpCookie;
var
  ACookie, AItem: TQHttpCookie;
  AFound: Boolean;
  I: Integer;
begin
  ACookie := TQHttpCookie.Create(AHelper, AValue);
  Result := ACookie;
  if (ACookie.FDomain = '.' + AHelper.Host) and
    StartWithW(PQCharW(AHelper.Document), PQCharW(ACookie.FPath), true) then
  begin
    FLocker.Enter;
    try
      I := 0;
      AFound := false;
      while I < FCookies.Count do
      begin
        AItem := TQHttpCookie(FCookies.Objects[I]);
        if AItem.FExpires > 0 then
        begin
          if SameText(AItem.FName, ACookie.FName) and
            SameText(AItem.FDomain, ACookie.FDomain) and
            SameText(AItem.FPath, ACookie.FPath) then
          begin
            AFound := true;
            FCookies.Objects[I] := ACookie;
            AItem._Release;
            break;
          end;
          Inc(I);
        end
        else
        begin
          FCookies.Delete(I);
          AItem._Release;
        end;
      end;
      if (not AFound) and (IsZero(ACookie.FExpires) or (ACookie.FExpires > Now))
      then
      begin
        FCookies.AddObject(ACookie.FDomain, ACookie);
        ACookie._AddRef;
      end;
    finally
      FLocker.Leave;
    end;
  end
  else
    Result := nil;
end;

function TQHttpCookies.AddCookie(const AUrl, AValue: QStringW): IQHttpCookie;
var
  AHelper: TQUrl;
begin
  AHelper := TQUrl.Create(AUrl);
  try
    Add(AHelper, AValue);
  finally
    FreeAndNil(AHelper);
  end;
end;

procedure TQHttpCookies.Clear(const ADomain: QStringW);
var
  I: Integer;
begin
  FLocker.Enter;
  try
    I := 0;
    if Length(ADomain) > 0 then
    begin
      while I < FCookies.Count do
      begin
        with TQHttpCookie(FCookies.Objects[I]) do
        begin
          if (Length(ADomain) > 0) and EndWithW(FDomain, ADomain, true) then
          begin
            _Release;
            FCookies.Delete(I);
          end
          else
            Inc(I);
        end;
      end;
    end
    else
    begin
      for I := 0 to FCookies.Count - 1 do
        TQHttpCookie(FCookies.Objects[I])._Release;
      FCookies.Clear;
    end;
  finally
    FLocker.Leave;
  end;
end;

constructor TQHttpCookies.Create;
begin
  FCookies := TStringList.Create;
  FCookies.Duplicates := dupAccept;
  FCookies.Sorted := true;
  FLocker := TCriticalSection.Create;
end;

destructor TQHttpCookies.Destroy;
begin
  Clear;
  FreeAndNil(FCookies);
  FreeAndNil(FLocker);
  inherited;
end;

function TQHttpCookies.GetCookies(const AIndex: Integer): IQHttpCookie;
begin
  Result := TQHttpCookie(FCookies.Objects[AIndex]);
end;

function TQHttpCookies.GetCount: Integer;
begin
  Result := FCookies.Count;
end;

function TQHttpCookies.GetUrlCookies(const AUrl: QStringW): QStringW;
var
  AHelper: TQUrl;
  L: Integer;
  ADomain: String;
begin
  Result := '';
  AHelper := TQUrl.Create(AUrl);
  ADomain := '.' + AHelper.Host;
  Lock;
  try
    L := FirstDomain(ADomain);
    if L >= 0 then
    begin
      while L < FCookies.Count do
      begin
        with TQHttpCookie(FCookies.Objects[L]) do
        begin
          if EndWithW(FDomain, ADomain, true) and
            ((not FIsSecure) or SameText(AHelper.Scheme, 'https')) then
            Result := Result + ToString + '; ';
        end;
        Inc(L);
      end;
    end;
  finally
    Unlock;
    FreeAndNil(AHelper);
    if Length(Result) > 0 then
      SetLength(Result, Length(Result) - 2);
  end;
end;

function TQHttpCookies.FirstDomain(const ADomain: QStringW): Integer;
var
  L, H, I, C: Integer;
begin
  Result := -1;
  if FCookies.Count > 0 then
  begin
    L := 0;
    H := FCookies.Count - 1;
    repeat
      I := (L + H) shr 1;
      C := CompareText(ADomain, FCookies[I]);
      if C > 0 then
        L := I + 1
      else if C < 0 then
        H := I - 1
      else
      begin
        Result := I;
        H := I;
      end;
    until L >= H;
  end;
end;

procedure TQHttpCookies.LoadFromFile(const AFileName: String);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    LoadFromStream(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQHttpCookies.LoadFromStream(AStream: TStream);
var
  ACookie: TQHttpCookie;
  AItem, AJson: TQJson;
  I: Integer;
  AHelper: TQUrl;
begin
  AJson := TQJson.Create;
  AJson.LoadFromStream(AStream);
  AHelper := TQUrl.Create;
  Lock;
  try
    for I := 0 to FCookies.Count - 1 do
      TQHttpCookie(FCookies.Objects[I])._Release;
    FCookies.Clear;
    AJson.LoadFromStream(AStream);
    for I := 0 to AJson.Count - 1 do
    begin
      AItem := AJson[I];
      ACookie := TQHttpCookie.Create;
      ACookie.FName := AItem.ValueByName('name', '');
      ACookie.FDomain := AItem.ValueByName('domain', '');
      ACookie.FValue := AItem.ValueByName('value', '');
      ACookie.FPath := AItem.ValueByName('path', '');
      ACookie.FExpires := AItem.DateTimeByName('expires', 0);
      ACookie.FIsSecure := AItem.BoolByName('secure', false);
      ACookie.FIsHttpOnly := AItem.BoolByName('httpOnly', false);
      ACookie._AddRef;
      FCookies.AddObject(ACookie.FDomain, ACookie);
    end;
  finally
    Unlock;
    FreeAndNil(AHelper);
    FreeAndNil(AJson);
  end;
end;

procedure TQHttpCookies.Lock;
begin
  FLocker.Enter;
end;

procedure TQHttpCookies.SaveToFile(const AFileName: String);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveToStream(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQHttpCookies.SaveToStream(AStream: TStream);
var
  AJson, AItem: TQJson;
  I: Integer;
begin
  AJson := TQJson.Create;
  AJson.DataType := jdtArray;
  Lock;
  try
    for I := 0 to FCookies.Count - 1 do
    begin
      with TQHttpCookie(FCookies.Objects[I]) do
      begin
        AItem := AJson.Add;
        AItem.Add('name').AsString := FName;
        AItem.Add('domain').AsString := FDomain;
        AItem.Add('value').AsString := FValue;
        AItem.Add('path').AsString := FPath;
        AItem.Add('expires').AsDateTime := FExpires;
        AItem.Add('secure').AsBoolean := FIsSecure;
        AItem.Add('httpOnly').AsBoolean := FIsHttpOnly;
      end;
    end;
  finally
    Unlock;
    AJson.SaveToStream(AStream);
    FreeAndNil(AJson);
  end;
end;

procedure TQHttpCookies.SetUrlCookies(const AUrl, ACookies: QStringW);
var
  AHelper: TQUrl;
  AValue: String;
  p: PQCharW;
begin
  p := PQCharW(ACookies);
  AHelper := TQUrl.Create(AUrl);
  try
    while p^ <> #0 do
    begin
      AValue := DecodeTokenW(p, ',', '"', true);
      if Length(AValue) > 0 then
        Add(AHelper, AValue);
    end;
  finally
    FreeAndNil(AHelper);
  end;
end;

procedure TQHttpCookies.Unlock;
begin
  FLocker.Leave;
end;

{ TQCertificate }

function TQCertificate.GetEncryption: QStringW;
begin
  Result := FEncryption;
end;

function TQCertificate.GetExpireDate: TDateTime;
begin
  Result := FExpireDate;
end;

function TQCertificate.GetIssuer: QStringW;
begin
  Result := FIssuer;
end;

function TQCertificate.GetKeySize: Integer;
begin
  Result := FKeySize;
end;

function TQCertificate.GetProtocol: QStringW;
begin
  Result := FProtocol;
end;

function TQCertificate.GetSignature: QStringW;
begin
  Result := FSignature;
end;

function TQCertificate.GetStartDate: TDateTime;
begin
  Result := FStartDate;
end;

function TQCertificate.GetSubject: QStringW;
begin
  Result := FSubject;
end;

{ TQBaseHttpClient }

procedure TQBaseHttpClient.Cancel;
begin
  FErrorCode := 1223;
  FErrorMessage := '�û�ȡ��������';
  if hcfAsyn in FFlags then
    Workers.Clear(DoAsynCall, INVALID_JOB_DATA);
  while hcfExecuting in FFlags do
    Sleep(50);
  if not(hcfExecuted in FFlags) then
    DoAfterDone(nil);
end;

constructor TQBaseHttpClient.Create;
begin
  inherited;
  FMaxRedirects := 5;
  FRequestHeaders := TQHttpHeaders.Create;
  FResponseHeaders := TQHttpHeaders.Create;
  FConnectTimeout := 15;
  FMaxRequestTimeout := 60;
  FFlags := [hcfAllowRedirect, hcfAllowCookie, hcfReady];
{$IFDEF DEBUG_LOG}
  DebugOut('HTTP Client %x created', [IntPtr(Self)]);
  // PostLog(llDebug, 'HTTP Client %x created', [IntPtr(Self)]);
{$ENDIF}
end;

function TQBaseHttpClient.DecodeStatus(const S: QStringW;
  var AText: QStringW): Integer;
var
  p: PQCharW;
  V: Int64;
begin
  // HTTP/1.1 200 OK
  AText := '';
  p := PQCharW(S);
  SkipUntilW(p, ' ');
  SkipSpaceW(p);
  if ParseInt(p, V) > 0 then
  begin
    Result := V;
    SkipSpaceW(p);
    AText := p;
  end;
end;

procedure TQBaseHttpClient.DecodeStatus;
begin
  if FResponseHeaders.Count > 0 then
    FStatusCode := DecodeStatus(FResponseHeaders.Lines[0], FStatusText)
  else
  begin
    FStatusCode := 0;
    FStatusText := '';
  end;
end;

function TQBaseHttpClient.Delete(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqDelete;
  Result := ExecuteRequest;
end;

destructor TQBaseHttpClient.Destroy;
begin
{$IFDEF DEBUG_LOG}
  DebugOut('HTTP Client %x Free', [IntPtr(Self)]);
  // PostLog(llDebug, 'HTTP Client %x Free', [IntPtr(Self)]);
{$ENDIF}
  inherited;
end;

procedure TQBaseHttpClient.DoAfterDone(AJob: PQJob);
var
  I: Integer;
  AEvent: TNotifyEvent;
begin
  try
    // DebugOut('Do after done');
    AEvent := FAfterDone;
    FAfterDone := nil;
    if (hcfAllowCookie in FFlags) and Assigned(FCookieManager) and
      (GetStatusCode = 200) and (FResponseHeaders.Count > 0) then
    begin
      for I := 0 to FResponseHeaders.Count - 1 do
      begin
        if SameText(FResponseHeaders.Names[I], SCookieSet) then
          FCookieManager.UrlCookie[FFinalUrl] :=
            FResponseHeaders.ValueFromIndex[I];
      end;
    end;
    if Assigned(AEvent) then
      AEvent(Self)
      // else
      // DebugOut('Error:After done not set');
  finally
    FFlags := [hcfAllowRedirect, hcfAllowCookie, hcfReady];
  end;
end;

procedure TQBaseHttpClient.DoAsynCall(AJob: PQJob);
begin
  FJob := AJob;
  try
    FRetryTimes := 0;
    DoExecute;
    if Assigned(Workers) then
    begin
      // DebugOut('Fire after done');
      Workers.Post(DoAfterDone, Pointer(Self as IQHttpClient), true,
        jdfFreeAsInterface);
    end
    else
      DoAfterDone(nil);
  finally
    FJob := nil;
  end;
end;

function TQBaseHttpClient.DoError(E: Exception): Boolean;
begin
  Result := false;
  FErrorMessage := E.Message;
  if E is EInOutError then
    FErrorCode := EInOutError(E).ErrorCode
  else if E is EOSError then
    FErrorCode := EOSError(E).ErrorCode
  else
    FErrorCode := -1;
end;

procedure TQBaseHttpClient.DoExecute;
var
  AContinue: Boolean;
begin
  FErrorMessage := '';
  FErrorCode := 0;
  FFlags := FFlags + [hcfExecuting];
  FStartTime := {$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount;
  try
    repeat
      if Assigned(FRequestStream) then
        FRequestStream.Position := 0;
      ReplaceHostIfNeeded;
      if Assigned(FJob) and (FJob.IsTerminated) then
        break;
      InternalExecute;
    until not DoRedirect;
  except
    on E: Exception do
    begin
      if DoError(E) and (not IsAppTerminated) then
      begin
        Inc(FRetryTimes);
        AContinue := FRetryTimes < 3;
        if Assigned(FOnRetry) then
          FOnRetry(nil, Self, FRetryTimes, AContinue);
        if AContinue then
          DoExecute;
      end;
    end;
  end;
  FStopTime := {$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount;
  FFlags := FFlags - [hcfAsyn, hcfExecuting] + [hcfExecuted];
end;

procedure TQBaseHttpClient.DoProgress(const Sender: TObject;
  AContentLength, AReadCount: Int64; var Aborted: Boolean);
begin
  if IsAppTerminated then
    Aborted := true
  else if Assigned(FOnProgress) then
    FOnProgress(Self, AContentLength, AReadCount, Aborted);
end;

function TQBaseHttpClient.DoRedirect: Boolean;
var
  ANewUrl: QStringW;
  function IsRedirect(ACode: Integer): Boolean;
  begin
    Result := ((ACode >= 300) and (ACode <= 303)) or (ACode = 307) or
      (ACode = 308);
  end;

begin
  if FErrorCode = 1223 then // �û�ȡ������
    Exit(false);
  DecodeStatus;
  Result := (hcfAllowRedirect in FFlags) and IsRedirect(FStatusCode) and
    (FRedirectTimes < FMaxRedirects);
  if Result then
  begin
    ANewUrl := FResponseHeaders.Values['Location'];
    if Assigned(FOnRedirect) then
      FOnRedirect(Self, ANewUrl, Result);
    if not Result then
      Exit;
    Inc(FRedirectTimes);
    FFinalUrl := ANewUrl;
    Result := Length(FFinalUrl) > 0;
  end;
end;

function TQBaseHttpClient.ExecuteRequest: Integer;
begin
  if not(hcfReady in FFlags) then
    raise Exception.Create(SRequestInProcess)
  else
  begin
    Result := 0; // ����ʧ��
    FErrorMessage := '';
    FErrorCode := 0;
    FRedirectTimes := 0;
    FRetryTimes := 0;
    FFlags := FFlags - [hcfReady];
    if Assigned(FAfterDone) then
    begin
      FFlags := FFlags + [hcfAsyn];
      Result := 200;
      Workers.Post(DoAsynCall, Pointer(Self as IQHttpClient), false,
        jdfFreeAsInterface);
    end
    else
    begin
      DoExecute;
      Result := FStatusCode;
    end;
  end;
end;

function TQBaseHttpClient.Get(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqGet;
  Result := ExecuteRequest;
end;

function TQBaseHttpClient.GetAfterDone: TNotifyEvent;
begin
  Result := FAfterDone;
end;

function TQBaseHttpClient.GetConnectTimeout: Cardinal;
begin
  Result := FConnectTimeout;
end;

function TQBaseHttpClient.GetContentAsString: QStringW;
begin
  Result := DecodeContentText(FResponseHeaders, FResponseStream);
end;

function TQBaseHttpClient.GetCookieManager: IQHttpCookies;
begin
  Result := FCookieManager;
end;

function TQBaseHttpClient.GetErrorCode: Integer;
begin
  Result := FErrorCode;
end;

function TQBaseHttpClient.GetErrorMessage: QStringW;
begin
  Result := FErrorMessage;
end;

function TQBaseHttpClient.GetFinalUrl: QStringW;
begin
  Result := FFinalUrl;
end;

function TQBaseHttpClient.GetFlags: TQHttpClientFlags;
begin
  Result := FFlags;
end;

function TQBaseHttpClient.GetMaxRedirects: Integer;
begin
  Result := FMaxRedirects;
end;

function TQBaseHttpClient.GetOnDnsLookup: TQHttpDNSLookupEvent;
begin
  Result := FOnDnsLookup;
end;

function TQBaseHttpClient.GetOnGetSSLProtocol: TQHttpGetSSLProtocolEvent;
begin
  Result := FOnGetSSLProtocol;
end;

function TQBaseHttpClient.GetOnProgress: TQDownloadProgressEvent;
begin
  Result := FOnProgress;
end;

function TQBaseHttpClient.GetOnRedirect: TQHttpRedirectEvent;
begin
  Result := FOnRedirect;
end;

function TQBaseHttpClient.GetOnRetry: TQHttpRequestRetryNotify;
begin
  Result := FOnRetry;
end;

function TQBaseHttpClient.GetOnVerifyCertificate: TQCertificateValidEvent;
begin
  Result := FOnVerifyCertificate;
end;

function TQBaseHttpClient.GetPeerCertificate: IQCertificate;
begin
  Result := FPeerCertificate;
end;

function TQBaseHttpClient.GetRequestHeaders: IQHttpHeaders;
begin
  Result := FRequestHeaders;
end;

function TQBaseHttpClient.GetRequestStream: TStream;
begin
  Result := FRequestStream;
end;

function TQBaseHttpClient.GetResponseCharset: QStringW;
begin
  Result := DecodeContentCharset(FResponseHeaders, FResponseStream);
end;

function TQBaseHttpClient.GetResponseHeaders: IQHttpHeaders;
begin
  Result := FResponseHeaders;
end;

function TQBaseHttpClient.GetResponseStream: TStream;
begin
  Result := FResponseStream;
end;

function TQBaseHttpClient.GetMaxRequestTimeout: Cardinal;
begin
  Result := FMaxRequestTimeout;
end;

function TQBaseHttpClient.GetStatusCode: Integer;
begin
  Result := FStatusCode;
end;

function TQBaseHttpClient.GetStatusText: QStringW;
begin
  Result := FStatusText;
end;

function TQBaseHttpClient.GetUrl: QStringW;
begin
  Result := FUrl;
end;

function TQBaseHttpClient.GetVerifyPeer: Boolean;
begin
  Result := hcfVerifyPeer in FFlags;
end;

function TQBaseHttpClient.Head(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqHead;
  Result := ExecuteRequest;
end;

function TQBaseHttpClient.NeedResponseStream(AReset: Boolean): TStream;
begin
  if not Assigned(FResponseStream) then
  begin
    FResponseStream := TQHttpMemoryStream.Create;
    FFlags := FFlags + [hcfOwnResponseStream];
  end;
  if AReset then
    FResponseStream.Size := 0;
  Result := FResponseStream;
end;

function TQBaseHttpClient.Options(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqOptions;
  Result := ExecuteRequest;
end;

function TQBaseHttpClient.Post(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqPost;
  Result := ExecuteRequest;
end;

function TQBaseHttpClient.Put(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqPut;
  Result := ExecuteRequest;
end;

procedure TQBaseHttpClient.ReplaceHostIfNeeded;
var
  AUrl: TQUrl;
  Addr: Cardinal;
  AddrText: QStringW;
begin
  if not StartWithW(PQCharW(FFinalUrl), 'https://', true) then
  begin
    if Assigned(FOnDnsLookup) then
    begin
      AUrl := TQUrl.Create(FFinalUrl);
      try
        if TryAsAddr(AUrl.Host, Addr) then
          FReplacedUrl := FFinalUrl
        else
        begin
          AddrText := '';
          FOnDnsLookup(Self, AUrl.Host, AddrText);
          AddrText := NameOfW(AddrText, ',');
          if (not TryAsAddr(AddrText, Addr)) or (Addr = 0) then // ȡ�׸���ַ
            raise Exception.Create(SDnsLookupFailed)
          else
          begin
            if AUrl.SchemePort <> AUrl.Port then
              FRequestHeaders.Values['Host'] := AUrl.Host + ':' +
                IntToStr(AUrl.Port)
            else
              FRequestHeaders.Values['Host'] := AUrl.Host;
            AUrl.Host := AddrText;
            FReplacedUrl := AUrl.Url;
          end;
        end;
      finally
        FreeAndNil(AUrl);
      end;
    end
    else
      FReplacedUrl := FFinalUrl;
  end
  else
    FReplacedUrl := FFinalUrl;
end;

procedure TQBaseHttpClient.Reset;
begin
  SetRequestStream(nil);
  SetResponseStream(nil);
  FFlags := [hcfAllowRedirect, hcfAllowCookie, hcfReady];
end;

procedure TQBaseHttpClient.SetAfterDone(const AValue: TNotifyEvent);
begin
  FAfterDone := AValue;
end;

procedure TQBaseHttpClient.SetConnectTimeout(const AValue: Cardinal);
begin
  FConnectTimeout := AValue;
end;

procedure TQBaseHttpClient.SetCookieManager(const AManager: IQHttpCookies);
begin
  FCookieManager := AManager;
end;

procedure TQBaseHttpClient.SetFlags(const AValue: TQHttpClientFlags);
begin
  FFlags := AValue;
end;

procedure TQBaseHttpClient.SetMaxRedirects(const AValue: Integer);
begin
  FMaxRedirects := AValue;
end;

procedure TQBaseHttpClient.SetOnDnsLookup(const AValue: TQHttpDNSLookupEvent);
begin
  FOnDnsLookup := AValue;
end;

procedure TQBaseHttpClient.SetOnGetSSLProtocol(const AValue
  : TQHttpGetSSLProtocolEvent);
begin
  FOnGetSSLProtocol := AValue;
end;

procedure TQBaseHttpClient.SetOnProgress(const AValue: TQDownloadProgressEvent);
begin
  FOnProgress := AValue;
end;

procedure TQBaseHttpClient.SetOnRedirect(const AValue: TQHttpRedirectEvent);
begin
  FOnRedirect := AValue;
end;

procedure TQBaseHttpClient.SetOnRetry(const AValue: TQHttpRequestRetryNotify);
begin
  FOnRetry := AValue;
end;

procedure TQBaseHttpClient.SetOnVeriftyCertificate(const AValue
  : TQCertificateValidEvent);
begin
  FOnVerifyCertificate := AValue;
end;

procedure TQBaseHttpClient.SetRequestStream(const AStream: TStream);
begin
  if Assigned(FRequestStream) then
  begin
    if hcfOwnRequestStream in FFlags then
    begin
      FreeAndNil(FRequestStream);
      FFlags := FFlags - [hcfOwnRequestStream];
    end;
  end;
  FRequestStream := AStream;
{$IFDEF DEBUG_LOG}
  if Assigned(AStream) then
    DebugOut('HTTP Client %x bind request stream %x',
      [IntPtr(Self), IntPtr(AStream)]);
  // PostLog(llDebug, 'HTTP Client %x bind request stream %x',
  // [IntPtr(Self), IntPtr(AStream)]);
{$ENDIF}
end;

procedure TQBaseHttpClient.SetResponseStream(const AStream: TStream);
begin
  if Assigned(FResponseStream) then
  begin
    if hcfOwnResponseStream in FFlags then
    begin
      FreeAndNil(FResponseStream);
      FFlags := FFlags - [hcfOwnResponseStream];
    end;
  end;
  FResponseStream := AStream;
end;

procedure TQBaseHttpClient.SetMaxRequestTimeout(const AValue: Cardinal);
begin
  FMaxRequestTimeout := AValue;
end;

procedure TQBaseHttpClient.SetVerifyPeer(const AValue: Boolean);
begin
  if AValue then
    FFlags := FFlags + [hcfVerifyPeer]
  else
    FFlags := FFlags - [hcfVerifyPeer];
end;

function TQBaseHttpClient.Trace(const AUrl: QStringW;
  AfterDone: TNotifyEvent): Integer;
begin
  FFinalUrl := AUrl;
  FAfterDone := AfterDone;
  FUrl := AUrl;
  FAction := reqTrace;
  Result := ExecuteRequest;
end;

function TQBaseHttpClient.ValidCertificate(ACert: IQCertificate): Boolean;
begin
  Result := true;
  if Assigned(onVerifyCertificate) then
    onVerifyCertificate(Self, ACert, Result);
end;

{ TQSysHttpClient }
{$IFDEF MSWINDOWS}

type
  WINHTTP_EXTEND_HEADER = record
    Name, Value: PWideChar;
  end;

  PWINHTTP_EXTENDED_HEADER = ^WINHTTP_EXTEND_HEADER;

  TFakeWinHTTPResponse = class(THTTPResponse)
  private
    // �����TWinHttpResponse�����Ա����FWRequest��ֵ��ע���System.Net.HttpClient.Win�еĲ��ֲٳ�һ��
    FWRequest: HINTERNET;
  end;
{$ENDIF}

procedure TQSysHttpClient.ConvertHeaders(ASource: TNetHeaders;
  ATarget: IQHttpHeaders);
var
  I: Integer;
  function CheckValueEncoding(const AValue: QStringW): QStringW;
  var
    p: PQCharW;
  begin
    p := PQCharW(AValue);
    while p^ <> #0 do
    begin
      if Ord(p^) > 127 then
      begin
        break;
      end;
      Inc(p);
    end;
    if p^ = #0 then
      Result := AValue
    else
      Result := QString.Utf8Decode(PQCharA(QString.AnsiEncode(AValue)), -1);
  end;

begin
  // Windows Ĭ�ϵĽӿ�û����ȷ����Header�а��� UTF8�����ַ������⣬����Ӹ���鴦��
  ATarget.Clear;
  for I := 0 to High(ASource) do
  begin
    ATarget.Values[ASource[I].Name] := CheckValueEncoding(ASource[I].Value);
  end;
end;

function TQSysHttpClient.ConvertHeaders(ASource: IQHttpHeaders): TNetHeaders;
var
  I: Integer;
begin
  SetLength(Result, ASource.Count);
  for I := 0 to ASource.Count - 1 do
  begin
    Result[I].Name := ASource.Names[I];
    Result[I].Value := ASource.ValueFromIndex[I];
  end;
end;

constructor TQSysHttpClient.Create;
begin
  inherited Create;
  FClient := THttpClient.Create;
  FClient.HandleRedirects := false;
  FClient.OnReceiveData := DoProgress;
  FClient.OnValidateServerCertificate := DoValidateCertificate;
  FActiveHttpsProtocol := 0;
end;

procedure TQSysHttpClient.DecodeStatus;
begin
  if Assigned(FResponse) then
  begin
    FStatusCode := FResponse.StatusCode;
    FStatusText := FResponse.StatusText;
  end
  else
    inherited;
end;

destructor TQSysHttpClient.Destroy;
begin
  FreeAndNil(FClient);
  inherited;
end;

function TQSysHttpClient.DoError(E: Exception): Boolean;
  procedure DecodeNetError(AMsg: QStringW);
  var
    p, ps: PQCharW;
    C: Integer;
    V: Int64;
  begin
    ps := PQCharW(AMsg);
    p := ps;
    {
      SNetHttpClientErrorAccessing = 'Error %d accessing to %s: %s';
      SNetHttpHeadersError = 'Error querying headers: (%d) %s';
      SNetHttpClientSendError = 'Error sending data: (%d) %s';
      SNetHttpClientReceiveError = 'Error receiving data: (%d) %s';
      SNetHttpRequestOpenError = 'Error opening request: (%d) %s';
      SNetHttpRequestAddHeaderError = 'Error adding header: (%d) %s';
      SNetHttpRequestRemoveHeaderError = 'Error removing header: (%d) %s';
      SNetHttpRequestQueryDataError = 'Error querying data available: (%d) %s';
      SNetHttpRequestReadDataError = 'Error reading data: (%d) %s';
      SNetHttpRequestSetTimeoutError = 'Error setting timeout for the request: (%d) %s';
    }
    // ��ΪENetException������û�д���������룬����ֻ���Լ���취�������ҵ��ĵ�һ����ֵ����
    SkipUntilW(p, '0123456789');
    C := p - ps;
    if ParseInt(p, V) > 0 then
    begin
      // ���յ㻹��Ӧ��ƥ��һ��
      if (StrLComp(PQCharW(SNetHttpClientErrorAccessing), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpHeadersError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpClientSendError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpClientReceiveError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpRequestOpenError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpRequestAddHeaderError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpRequestRemoveHeaderError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpRequestQueryDataError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpRequestReadDataError), ps, C) = 0) or
        (StrLComp(PQCharW(SNetHttpRequestSetTimeoutError), ps, C) = 0) then
        FErrorCode := V;
    end;
  end;

begin
  if FErrorCode = 0 then
  begin
    Result := inherited;
{$IFDEF MSWINDOWS}
    if (FErrorCode = -1) and (E is ENetException) then
    // �ⲻ��һ������ļ�ⷽʽ����Ŀǰû�и��õİ취
      DecodeNetError(E.Message);
    if not Result then
    begin
      // wininet
      case FErrorCode of
        12030, 12031, 12152:
          // ERROR_INTERNET_CONNECTION_ABORTED,ERROR_INTERNET_CONNECTION_RESET,ERROR_HTTP_INVALID_SERVER_RESPONSE
          Result := true;
        12175: // ERROR_WINHTTP_SECURE_FAILURE����� HTTPS ����ʧ�ܣ����Ը��ͼ���Э��
          begin
            Inc(FActiveHttpsProtocol);
            Result := FActiveHttpsProtocol <= Ord(High(THTTPSecureProtocol));
          end;
        12002: // ���ճ�ʱ
          begin
            // DebugOut('���շ��ؽ����ʱ����ʱ��%d ms', [GetTickCount - FStartTime]);
            Result := true;
          end;
      end;
    end;
{$ENDIF}
  end
  else if FErrorCode = 1223 then
    Result := false;
end;

procedure TQSysHttpClient.DoValidateCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := ValidCertificate(TQSysCertificate.Create(Certificate));
end;

procedure TQSysHttpClient.InternalExecute;
var
  ACookie: String;
  I: Integer;
  AProtocol: THTTPSecureProtocol;
  ARequestStream: TStream;
const
  // ���� TLS 1.2
  HttpProtocols: array [0 .. 4] of THTTPSecureProtocol =
    (THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS11,
    THTTPSecureProtocol.TLS1, THTTPSecureProtocol.SSL3,
    THTTPSecureProtocol.SSL2);
  function GetHost: QStringW;
  var
    ps, p: PQCharW;
  begin
    ps := PQCharW(FReplacedUrl);
    SkipUntilW(ps, '/');
    SkipCharW(ps, '/');
    p := ps;
    SkipUntilW(p, '/');
    Result := StrDupX(ps, p - ps);
  end;

begin
  FResponse := nil;
  if FReplacedUrl.StartsWith('https://', true) then
  begin
    if FRetryTimes = 0 then
    begin
      AProtocol := THTTPSecureProtocol.TLS12;
      FActiveHttpsProtocol := 0;
      if Assigned(FOnGetSSLProtocol) then
      begin
        FOnGetSSLProtocol(Self, Self, GetHost, AProtocol);
        for I := 0 to High(HttpProtocols) do
        begin
          if HttpProtocols[I] = AProtocol then
          begin
            FActiveHttpsProtocol := I;
            break;
          end;
        end;
      end;
    end
    else
      AProtocol := HttpProtocols
        [FActiveHttpsProtocol mod Length(HttpProtocols)];
    FClient.SecureProtocols := [AProtocol];
  end;
  FClient.ResponseTimeout := MaxRequestTimeout * 1000;
  if Assigned(FCookieManager) then
  begin
    ACookie := FCookieManager.UrlCookie[FFinalUrl];
    if Length(ACookie) > 0 then
      FRequestHeaders.Values[SCookie] := ACookie
    else
      FRequestHeaders.Values[SCookie] := '';
  end;
  if Assigned(FRequestStream) then
  begin
    TMonitor.Enter(FRequestStream);
    Assert(FRequestStream.Position = 0);
  end;
  case FAction of
    reqGet:
      FResponse := FClient.Get(FReplacedUrl, NeedResponseStream(true),
        ConvertHeaders(FRequestHeaders));
    reqPost:
      begin
        if Assigned(FRequestStream) then
        begin
          // DebugOut'RequestStream=%x', [IntPtr(FRequestStream)]);
          FResponse := FClient.Post(FReplacedUrl, FRequestStream,
            NeedResponseStream, ConvertHeaders(FRequestHeaders))
        end
        else
        begin
          // DebugOut('ErrorCode=%d', [FErrorCode]);
          Exit;
        end;
      end;
    reqHead:
      FResponse := FClient.Head(FReplacedUrl, ConvertHeaders(FRequestHeaders));
    reqPut:
      FResponse := FClient.Put(FReplacedUrl, FRequestStream, NeedResponseStream,
        ConvertHeaders(FRequestHeaders));
    reqDelete:
      FResponse := FClient.Delete(FReplacedUrl, NeedResponseStream,
        ConvertHeaders(FRequestHeaders));
    reqTrace:
      FResponse := FClient.Trace(FReplacedUrl, NeedResponseStream,
        ConvertHeaders(FRequestHeaders));
    reqOptions:
      FResponse := FClient.Options(FReplacedUrl, NeedResponseStream,
        ConvertHeaders(FRequestHeaders));
  end;
  ConvertHeaders(FResponse.Headers, FResponseHeaders);
  if Assigned(FRequestStream) then
    TMonitor.Exit(FRequestStream);
end;

{ TQCurlHttpClient }

function TQCurlHttpClient.CheckCurlCode(ACode: TCurlCode;
  ARaiseException: Boolean): Boolean;
var
  E: EInOutError;
begin
  Result := (ACode = CURLE_OK);
  if (not Result) and ARaiseException then
  begin
    FStatusCode := 599;
    FStatusText := curl_easy_strerror(ACode);
    E := EInOutError.Create(FStatusText);
    E.ErrorCode := Ord(ACode);
    raise E;
  end;
end;

constructor TQCurlHttpClient.Create;
begin
  inherited;
end;

destructor TQCurlHttpClient.Destroy;
begin
  inherited;
end;

class function TQCurlHttpClient.DoCurlProgress(clientp: Pointer;
  dltotal, dlnow, ultotal, ulnow: Double): Integer;
var
  ADoAbort: Boolean;
begin
  ADoAbort := false;
  TQCurlHttpClient(clientp).DoProgress(clientp, Trunc(dltotal), Trunc(dlnow),
    ADoAbort);
  if ADoAbort then
    Result := Ord(CURLE_ABORTED_BY_CALLBACK)
  else
    Result := Ord(CURLE_OK);
end;

class function TQCurlHttpClient.DoCurlReadFromStream(buffer: PAnsiChar;
  Size, nitem: Integer; instream: Pointer): Integer;
begin
  Result := TStream(instream).read(buffer^, Size * nitem);
end;

class function TQCurlHttpClient.DoCurlResponseHeader(ABuffer: PByte;
  Size, nItems: Integer; userData: Pointer): Integer;
var
  AClient: TQCurlHttpClient;
  AText: QStringW;
begin
  AClient := userData;
  AText := Utf8Decode(PQCharA(ABuffer), -1);
  AClient.FResponseHeaders.Values[Trim(NameOfW(AText, ':'))] :=
    Trim(ValueOfW(AText, ':'));
  Result := nItems * Size;
end;

class function TQCurlHttpClient.DoCurlSeekInStream(instream: Pointer;
  offset: Int64; origin: Integer): Integer;
begin
  TStream(instream).Seek(offset, origin);
  Result := CURL_SEEKFUNC_OK;
end;

class function TQCurlHttpClient.DoCurlWriteToStream(buffer: PAnsiChar;
  Size, nItems: Integer; outstream: Pointer): Integer;
begin
  Result := TStream(outstream).Write(buffer^, Size * nItems);
end;

function TQCurlHttpClient.DoError(E: Exception): Boolean;
begin
  Result := inherited;
  if not Result then
  begin
    Result := (TCurlCode(FErrorCode) = CURLE_COULDNT_CONNECT) or
      (TCurlCode(FErrorCode) = CURLE_HTTP_RETURNED_ERROR) or
      (TCurlCode(FErrorCode) = CURLE_NO_CONNECTION_AVAILABLE);
  end;
end;

procedure TQCurlHttpClient.InternalExecute;
var
  S: QStringA;
  ACookie: QStringW;
  AHeaders: PCurlSList;
  I: LongInt;
  AIsHttps: Boolean;
const
  sDelete: array [0 .. 6] of Byte = (Ord('D'), Ord('E'), Ord('L'), Ord('E'),
    Ord('T'), Ord('E'), 0);
  sTrace: array [0 .. 5] of Byte = (Ord('T'), Ord('R'), Ord('A'), Ord('C'),
    Ord('E'), 0);
  sOptions: array [0 .. 7] of Byte = (Ord('O'), Ord('P'), Ord('T'), Ord('I'),
    Ord('O'), Ord('N'), Ord('S'), 0);
begin
  FHandle := curl_easy_init;
  try
    Assert(FHandle <> 0);
    FResponseHeaders.Clear;
    FStatusCode := 0;
    FStatusText := '';

    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_PROGRESSFUNCTION,
      @DoCurlProgress));
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_PROGRESSDATA, Self));
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_WRITEFUNCTION,
      @DoCurlWriteToStream));
    if Assigned(FRequestStream) then
    begin
      FRequestStream.Position := 0;
      CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_READDATA,
        FRequestStream));
      CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_READFUNCTION,
        @DoCurlReadFromStream));
    end;
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_SEEKFUNCTION,
      @DoCurlSeekInStream));
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_HEADERFUNCTION,
      @DoCurlResponseHeader));
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_HEADERDATA, Pointer(Self)));
    // �����Լ�������ת�����õײ㴦��
    I := 0;
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_FOLLOWLOCATION, I));
    NeedResponseStream;
    FResponseStream.Size := 0;
    S := QString.Utf8Encode(FReplacedUrl);
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_URL, PQCharA(S)));
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_WRITEDATA,
      FResponseStream));
    AIsHttps := StartWithW(PQCharW(FFinalUrl), 'https://', true);
    if AIsHttps then
    begin
      if hcfVerifyPeer in FFlags then
        I := 1
      else
        I := 0;
      CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_SSL_VERIFYPEER, I));
      CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_SSL_VERIFYHOST, I));
      CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_CERTINFO, 1));
    end;
    if Assigned(FCookieManager) then
    begin
      S := QString.Utf8Encode(FCookieManager.UrlCookie[FFinalUrl]);
      if Length(S) > 0 then
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_COOKIE, PQCharA(S)));
    end;
    AHeaders := nil;
    if Assigned(FRequestStream) then
      FRequestHeaders.Values['Content-Length'] := IntToStr(FRequestStream.Size)
    else
      FRequestHeaders.Values['Content-Length'] := '0';
    if Assigned(FCookieManager) then
    begin
      ACookie := FCookieManager.UrlCookie[FFinalUrl];
      if Length(ACookie) > 0 then
        FRequestHeaders.Values[SCookie] := ACookie
      else
        FRequestHeaders.Values[SCookie] := '';
    end;
    for I := 0 to FRequestHeaders.Count - 1 do
    begin
      S := QString.Utf8Encode(FRequestHeaders.Lines[I]);
      AHeaders := curl_slist_append(AHeaders, Pointer(PQCharA(S)));
    end;
    // ��ֹ POST ʱ��CURL ���� Expect�� 100-continue
    S := 'Expect:';
    AHeaders := curl_slist_append(AHeaders, Pointer(PQCharA(S)));
    CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_HTTPHEADER, AHeaders));
    I := 1;
    case FAction of
      reqGet:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_HTTPGET, I));
      reqPost:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_POST, I));
      reqHead:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_NOBODY, I));
      reqPut:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_PUT, I));
      reqDelete:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_CUSTOMREQUEST,
          @sDelete[0]));
      reqTrace:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_CUSTOMREQUEST,
          @sTrace[0]));
      reqOptions:
        CheckCurlCode(curl_easy_setopt(FHandle, CURLOPT_CUSTOMREQUEST,
          @sOptions[0]));
    end;
    CheckCurlCode(curl_easy_perform(FHandle));
//    if AIsHttps then
//    begin
//      if not ValidCertificate(TQCurlCertificate.Create(FHandle)) then
//      begin
//        FStatusCode := 403;
//        FStatusText := 'Server Certificate not accepted.';
//        Exit;
//      end;
//    end;
    if FResponseHeaders.Count > 0 then
    begin
      FStatusCode := DecodeStatus(FResponseHeaders.Lines[0], FStatusText);
    end
    else
    begin
      FStatusCode := 0;
      FStatusText := '';
    end;
  finally
    if Assigned(AHeaders) then
      curl_slist_free_all(AHeaders);
    curl_easy_cleanup(FHandle);
    FHandle := 0;
  end;
end;

{ TQNativeHttpClient }

constructor TQNativeHttpClient.Create;
begin
  inherited Create;
end;

destructor TQNativeHttpClient.Destroy;
begin

  inherited;
end;

procedure TQNativeHttpClient.InternalExecute;
var
  AUrl: TQUrl;
  AIsGZip, AIsDeflate: Boolean;
  procedure DoConnect;
  var
    tm: timeval;
    mode: Integer;
    fdWrite, fdError: TFdSet;
    Addr: TSockAddrIn;
  begin
    FHandle := Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if FHandle = THandle(INVALID_SOCKET) then
      RaiseLastOSError;
    Addr.sin_family := AF_INET;
    // FillChar(Addr.sin_zero,8,0);
    Addr.sin_port := htons(AUrl.Port);
    Addr.sin_addr.S_addr := DNSLookupV4(AUrl.Host);
    if Addr.sin_addr.S_addr = 0 then
      RaiseLastOSError;
    tm.tv_sec := FConnectTimeout;
    tm.tv_usec := 0;
    mode := 1;
    if ioctlsocket(FHandle, FIONBIO, mode) <> NO_ERROR then
      RaiseLastOSError;
    connect(FHandle, SockAddr(Addr), SizeOf(Addr));
    FD_ZERO(fdWrite);
    FD_ZERO(fdError);
    FD_SET(FHandle, fdWrite);
    FD_SET(FHandle, fdError);
    select(0, nil, @fdWrite, @fdError, @tm);
    if not FD_ISSET(FHandle, fdWrite) then
      RaiseLastOSError;
    mode := 0;
    if ioctlsocket(FHandle, FIONBIO, mode) <> NO_ERROR then
      RaiseLastOSError;
  end;

  function SendData(p: Pointer; ASize: Integer): Boolean;
  var
    ASent: Integer;
  begin
    while ASize > 0 do
    begin
{$IFDEF NATIVE_SSL_ENABLED}
      if Assigned(FSSL) then
        ASent := FSSL.Write(p^, ASize)
      else
{$ENDIF}
        ASent := send(FHandle, p^, ASize, 0);
      if ASent <> SOCKET_ERROR then
      begin
        Dec(ASize, ASent);
        Inc(FSentBytes, ASent);
      end
      else
        break;
    end;
    Result := ASize = 0;
  end;
  function RecvData(p: Pointer; ACount: Integer): Integer;
  begin
{$IFDEF NATIVE_SSL_ENABLED}
    if Assigned(FSSL) then
      Result := FSSL.read(p^, ACount)
    else
{$ENDIF}
      Result := recv(FHandle, p^, ACount, 0);
  end;
  procedure SendRequest;
  const
    HttpLineBreak = #13#10;
    NameDelimiter: PWideChar = ':';
    HttpActions: array [TQHttpClientAction] of QStringW = ('', 'GET', 'POST',
      'HEAD', 'PUT', 'DELETE', 'TRACE', 'OPTIONS');
  var
    I: Integer;
    AName, AValue: QStringW;
    AHelper: TQStringCatHelperW;
    AStartPos, AStreamSize: Int64;
    AHeader: QStringA;
  begin
    AHelper := TQStringCatHelperW.Create;
    try
      AHelper.Cat(HttpActions[FAction]).Cat(' ').Cat(AUrl.FullDocument)
        .Cat(' HTTP/1.1').Cat(HttpLineBreak);
      FRequestHeaders.NeedExists('Accept', '*/*');
      FRequestHeaders.NeedExists('Accept-Encoding', 'gzip, deflate');
      if AUrl.SchemePort <> AUrl.Port then
        FRequestHeaders.Values['Host'] := AUrl.Host + ':' + IntToStr(AUrl.Port)
      else
        FRequestHeaders.Values['Host'] := AUrl.Host;
      FRequestHeaders.NeedExists('User-Agent', DefaultUserAgent);
      FRequestHeaders.NeedExists('Connection', 'keep-alive');
      if Assigned(FRequestStream) then
      begin
        AStartPos := FRequestStream.Position;
        AStreamSize := FRequestStream.Size - FRequestStream.Position;
      end
      else
      begin
        AStartPos := 0;
        AStreamSize := 0;
      end;
      FRequestHeaders.Values['Content-Length'] := IntToStr(AStreamSize);
      for I := 0 to FRequestHeaders.Count - 1 do
        AHelper.Cat(FRequestHeaders.Names[I]).Cat(': ')
          .Cat(FRequestHeaders.ValueFromIndex[I]).Cat(HttpLineBreak);
      AHelper.Cat(HttpLineBreak);
      AHeader := QString.Utf8Encode(AHelper.Value);
      if SendData(PQCharA(AHeader), AHeader.Length) then
      begin
        if Assigned(FRequestStream) then
        begin
          // ֱ������������������64KB
          AHelper.Position := 32768;
          repeat
            I := FRequestStream.read(AHelper.Start^, 65536);
          until (I = 0) or (not SendData(AHelper.Start, I));
        end;
      end
      else
        RaiseLastOSError;
    finally
      FreeAndNil(AHelper);
      if Assigned(FRequestStream) then
        FRequestStream.Position := AStartPos;
    end;
  end;

  function ParseChunkSize(p: PByte): Integer;
  begin
    Result := 0;
    while IsHexChar(WideChar(p^)) do
    begin
      Result := (Result shl 4) + HexValue(WideChar(p^));
      Inc(p);
    end;
  end;

{$IF RTLVERSION=18}
  function InflateInit(var strm: TZStreamRec): Integer;
  begin
    Result := inflateInit_(strm, ZLIB_VERSION, SizeOf(TZStreamRec));
  end;
  function inflateInit2(var strm: TZStreamRec; windowBits: Integer): Integer;
  begin
    Result := inflateInit2_(strm, windowBits, ZLIB_VERSION,
      SizeOf(TZStreamRec));
  end;
{$IFEND}
  procedure FlushChunk(ABlock: PByte; ASize: Integer);
  var
    ARetVal: Integer;
    AHave: Cardinal;
    AStrm: TZStreamRec;
    ABuf: TBytes;
  begin
    if AIsGZip or AIsDeflate then
    begin
      AStrm.zalloc := nil;
      AStrm.zfree := nil;
{$IF RTLVersion>18}
      AStrm.opaque := nil;
{$IFEND}
      AStrm.avail_in := 0;
      AStrm.next_in := nil;
      if AIsGZip then
        ARetVal := inflateInit2(AStrm, 47)
      else
        ARetVal := InflateInit(AStrm);
      if ARetVal <> Z_OK then
        raise Exception.Create(SZlibError);
      SetLength(ABuf, 65536);
      AStrm.avail_in := ASize;
      AStrm.next_in := Pointer(ABlock);
      repeat
        AStrm.avail_out := 65536;
        AStrm.next_out := @ABuf[0];
        ARetVal := inflate(AStrm, Z_NO_FLUSH);
        if (ARetVal = Z_STREAM_END) or (ARetVal = Z_OK) then
        begin
          AHave := 65536 - AStrm.avail_out;
          FResponseStream.WriteBuffer(ABuf[0], AHave);
          if ARetVal = Z_STREAM_END then
          begin
            inflateEnd(AStrm);
            break;
          end;
        end
        else
        begin
          inflateEnd(AStrm);
          raise Exception.CreateFmt(SZlibError, [AStrm.msg]);
        end;
      until AStrm.avail_out <> 0;
    end
    else
    begin
      FResponseStream.WriteBuffer(ABlock, ASize);
      Inc(FRecvBytes, ASize);
    end;
    // DoProgress(Self
  end;

  procedure RecvChunks(AHelper: TQBytesCatHelper);
  var
    AChunkSize: Integer;
    I, ARecvBytes, ASize: Integer;
    ps: PByte;
  begin
    // Todo:��������ݴ�С����ȷ
    AChunkSize := -1;
    repeat
      if AChunkSize < 0 then
      begin
        ps := AHelper.Start;
        ASize := 0;
        while ps < AHelper.Current do
        begin
          if IsHexChar(Char(ps^)) then
          begin
            ASize := (ASize shl 4) + HexValue(Char(ps^));
          end
          else if ps^ = $D then
          begin
            Inc(ps);
            if (ps < AHelper.Current) and (ps^ = $A) then
            begin
              AChunkSize := ASize + 2;
              AHelper.Delete(0, ps - AHelper.Start + 1);
              if AHelper.Capacity < AChunkSize then
                AHelper.Capacity := AChunkSize;
              break;
            end;
          end
          else // ???Bad
            Exit;
          Inc(ps);
        end;
      end;
      if AChunkSize > 0 then
      begin
        if (AHelper.Position < AChunkSize) then
        begin
          if AHelper.Position + 4096 > AHelper.Capacity then
            AHelper.Capacity := AHelper.Capacity + 4096;
          ARecvBytes := RecvData(AHelper.Current,
            AHelper.Capacity - AHelper.Position);
          if ARecvBytes = SOCKET_ERROR then
            RaiseLastOSError;
          AHelper.Position := AHelper.Position + ARecvBytes;
        end;
        if (AChunkSize > 2) and (AHelper.Position >= AChunkSize) then
        begin
          FlushChunk(AHelper.Start, AChunkSize - 2);
          AHelper.Delete(0, AChunkSize);
          AChunkSize := -1;
        end;
      end
      else
      begin
        if AHelper.Position + 4096 > AHelper.Capacity then
          AHelper.Capacity := AHelper.Capacity + 4096;
        ARecvBytes := RecvData(AHelper.Current,
          AHelper.Capacity - AHelper.Position);
        if ARecvBytes = SOCKET_ERROR then
          RaiseLastOSError;
        AHelper.Position := AHelper.Position + ARecvBytes;
      end;
    until (AChunkSize = 2);
  end;

  procedure RecvHeaders(AHelper: TQBytesCatHelper);
  var
    ARecv, I: Integer;
    p, ps, pl: PByte;
  begin
    FResponseHeaders.Clear;
    repeat
      if AHelper.Position + 4096 > AHelper.Capacity then
        AHelper.Capacity := AHelper.Capacity + 4096;
      ARecv := RecvData(AHelper.Current, AHelper.Capacity - AHelper.Position);
      if ARecv = SOCKET_ERROR then
        RaiseLastOSError;
      AHelper.Position := AHelper.Position + ARecv;
      if AHelper.Position > 4 then
      begin
        p := AHelper.Start;
        while p < AHelper.Current do
        begin
          if PInteger(p)^ = $0A0D0A0D then
          begin
            I := 0;
            ps := AHelper.Start;
            while ps < p do
            begin
              pl := ps;
              while pl^ <> $A do
                Inc(pl);
              FResponseHeaders.Add(HtmlUnescape(Utf8Decode(PQCharA(ps),
                pl - ps - 1)));
              while (pl^ = $A) or (pl^ = $D) do
                Inc(pl);
              ps := pl;
            end;
            Inc(p, 4);
            AHelper.Delete(0, p - AHelper.Start);
            Exit;
          end
          else
            Inc(p);
        end;
      end;
    until 1 > 2;
  end;

  procedure RecvResponse;
  var
    AHelper: TQBytesCatHelper;
    S: QStringW;
    L: Int64;
    ARecv: Integer;
  begin
    // ���ջ�Ӧͷ
    AHelper := TQBytesCatHelper.Create;
    try
      RecvHeaders(AHelper);
      if FAction <> reqHead then // ���շ��ص�����
      begin
        S := FResponseHeaders.HeaderValue('content-encoding', '');
        AIsGZip := SameText(S, 'gzip');
        AIsDeflate := SameText(S, 'deflate');
        if SameText(FResponseHeaders.HeaderValue('transfer-encoding', ''),
          'chunked') then
          RecvChunks(AHelper)
        else
        begin
          L := StrToInt64Def(FResponseHeaders.HeaderValue
            ('content-length', '0'), 0);
          if Assigned(FResponseStream) then
          begin
            FResponseStream.WriteBuffer(AHelper.Start^, AHelper.Position);
            Dec(L, AHelper.Position);
            while L > 0 do
            begin
              ARecv := RecvData(AHelper.Start, AHelper.Capacity);
              if ARecv = SOCKET_ERROR then
                RaiseLastOSError;
              FResponseStream.WriteBuffer(AHelper.Start^, ARecv);
              Dec(L, ARecv);
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(AHelper);
    end;
  end;
  procedure DoSetCookies;
  var
    I: Integer;
  begin
    if Assigned(FCookieManager) then
    begin
      for I := 0 to FResponseHeaders.Count - 1 do
      begin
        if SameText(FResponseHeaders.Names[I], SCookieSet) then
          FCookieManager.AddCookie(FFinalUrl,
            FResponseHeaders.ValueFromIndex[I]);
      end;
    end;
  end;

begin
  NeedResponseStream;
  AUrl := TQUrl.Create;
  try
    AUrl.Url := FReplacedUrl;
    DoConnect;
{$IFDEF NATIVE_SSL_ENABLED}
    if SameText(AUrl.Scheme, 'https') then
    begin
      FSSL := TQSSLManager.ActiveFactory.NewItem;
      FSSL.Handle := FHandle;
      if not FSSL.connect then
        raise Exception.Create(FSSL.GetFactory.LastErrorMsg);
    end
    else
      FSSL := nil;
{$ENDIF}
    SendRequest;
    RecvResponse;
    if FResponseHeaders.Count > 0 then
    begin
      FStatusCode := DecodeStatus(FResponseHeaders.Lines[0], FStatusText);
      DoSetCookies;
    end
    else
    begin
      FStatusCode := 0;
      FStatusText := '';
    end;
  finally
    FreeAndNil(AUrl);
    if FHandle <> 0 then
    begin
{$IFDEF NATIVE_SSL_ENABLED}
      FSSL := nil;
{$ENDIF}
      closesocket(FHandle);
      FHandle := 0;
    end;
  end;
end;

{ TQDnsEntry }

procedure TQDnsEntry.Clean;
var
  T: Cardinal;
  AItem, APrior: PQDnsEntryItem;
begin
  T := {$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount;
  AItem := FFirst;
  APrior := nil;
  while Assigned(AItem) do
  begin
    if AItem.ExpireTick < T then // ������
    begin
      if Assigned(APrior) then
      begin
        APrior.Next := AItem.Next;
        if AItem = FLast then
          FLast := APrior;
      end
      else
      begin
        FFirst := AItem.Next;
        if FLast = AItem then
          FLast := FFirst;
      end;
      Dispose(AItem);
      if Assigned(APrior) then
      begin
        if AItem = FActive then
          FActive := APrior.Next;
        AItem := APrior.Next;
      end
      else
      begin
        if AItem = FActive then
          FActive := FFirst;
        AItem := FFirst;
      end;
    end
    else
      AItem := AItem.Next;
  end;
end;

constructor TQDnsEntry.Create(const AValue: QStringW; DnsTTL: Cardinal);
var
  p: PQCharW;
  AIdx: Integer;
  AItem: QStringA;
  ATick: Cardinal;
  AEntry: PQDnsEntryItem;
begin
  p := PQCharW(AValue);
  ATick := {$IFDEF UNICODE}TThread.{$ENDIF}GetTickCount;
  // IPv6��ʱ��֧��
  while p^ <> #0 do
  begin
    AItem := DecodeTokenW(p, ',', #0, true);
    New(AEntry);
    AEntry.Family := AF_INET;
    AEntry.LongAddr :=
      Cardinal(inet_addr({$IFDEF UNICODE}MarshaledAString{$ELSE}PAnsiChar{$ENDIF}(PQCharA(AItem))));
    AEntry.Next := nil;
    if DnsTTL > 0 then
      AEntry.ExpireTick := ATick + DnsTTL
    else
      AEntry.ExpireTick := INFINITE;
    if not Assigned(FFirst) then
      FFirst := AEntry;
    if Assigned(FLast) then
      FLast.Next := AEntry;
    FLast := AEntry;
  end;
  FActive := FFirst;
end;

destructor TQDnsEntry.Destroy;
begin
  FActive := FFirst;
  while Assigned(FActive) do
  begin
    FFirst := FActive.Next;
    Dispose(FActive);
    FActive := FFirst;
  end;
  inherited;
end;

function TQDnsEntry.First: PQDnsEntryItem;
begin
  Result := FFirst;
end;

function TQDnsEntry.Last: PQDnsEntryItem;
begin
  Result := FLast;
end;

function TQDnsEntry.Next: PQDnsEntryItem;
begin
  if Assigned(FActive) then
  begin
    if Assigned(FActive.Next) then
      FActive := FActive.Next
    else
      FActive := FFirst;
  end;
end;

{ TQHttpMemoryStream }

constructor TQHttpMemoryStream.Create;
begin
  inherited;
{$IFDEF DEBUG_LOG}
  // PostLog(llDebug, 'Stream %x allocated', [IntPtr(Self)]);
{$ENDIF}
end;

destructor TQHttpMemoryStream.Destroy;
begin
{$IFDEF DEBUG_LOG}
  // PostLog(llDebug, 'Stream %x Freed', [IntPtr(Self)]);
{$ENDIF}
  inherited;
end;

{ TQSysCertificate }

constructor TQSysCertificate.Create(ACert: TCertificate);
begin
  inherited Create;
  FExpireDate := ACert.Expiry;
  FStartDate := ACert.Start;
  FSubject := ACert.Subject;
  FIssuer := ACert.Issuer;
  FProtocol := ACert.ProtocolName;
  FSignature := ACert.AlgSignature;
  KeySize := ACert.KeySize;
end;


initialization

StartSocket;
{$IF RTLVersion=18}
ZLibHandle := LoadLibrary('zlib1.dll');
if ZLibHandle <> 0 then
  inflateInit2_ := GetProcAddress(ZLibHandle, 'inflateInit2_');
{$IFEND}
TQHttpRequests.CurlInitialized := false;

finalization

if TQHttpRequests.CurlInitialized then
  curl_global_cleanup;
CleanSocket;
{$IF RTLVersion=18}
if ZLibHandle <> 0 then
  FreeLibrary(ZLibHandle);
{$IFEND}

end.

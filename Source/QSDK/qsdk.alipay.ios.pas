unit qsdk.alipay.ios;

interface

uses
  Classes, Sysutils, System.ZLib {libz.dylib} ,
  System.Sqlite {libsqlite3.0.dylib} ,
  iOSapi.Foundation, Macapi.ObjectiveC, iOSapi.UIKit, Macapi.Helpers,
  FMX.Platform.ios, iOSapi.Security, iOSapi.CoreMotion, iOSapi.CoreTelephony,
  iOSapi.SystemConfiguration;
{$M+}

type
  // APayAuthInfo.h
  {
    @interface APayAuthInfo : NSObject

    @property(nonatomic, copy)NSString *appID;
    @property(nonatomic, copy)NSString *pid;
    @property(nonatomic, copy)NSString *redirectUri;

    /**
    *  ��ʼ��AuthInfo
    *
    *  @param appIDStr     Ӧ��ID
    *  @param productIDStr ��Ʒ�� ���̻���abossǩԼ�Ĳ�Ʒ,�û���ȡpid��ȡ�Ĳ���
    *  @param pidStr       �̻�ID   �ɲ���
    *  @param uriStr       ��Ȩ��Ӧ�ûص���ַ  ���磺alidemo://auth
    *
    *  @return authinfoʵ��
    */
    - (id)initWithAppID:(NSString *)appIDStr
    pid:(NSString *)pidStr
    redirectUri:(NSString *)uriStr;

    - (NSString *)description;
    - (NSString *)wapDescription;
    @end
  }
  APayAuthInfoClass = interface(NSObjectClass)
    ['{C8335BFC-50DB-49E6-8BEF-C7F64A9812E7}']

  end;

  APayAuthInfo = interface(NSObject)
    ['{244AA8B5-074B-4ECA-B50B-660392B6399D}']
    function appID: NSString; cdecl;
    procedure setAppID(Value: NSString); cdecl;
    function pid: NSString; cdecl;
    procedure setPid(Value: NSString); cdecl;
    function redirectUri: NSString; cdecl;
    procedure setRedirectUri(Value: NSString); cdecl;
    [MethodName('initWithAppID:pid:redirectUri:')]
    function initWithAppIDPidRedirectUri(appIDStr, pidStr,
      redirectUri: NSString): Pointer; cdecl;
    function description: NSString; cdecl;
    function wapDescription: NSString; cdecl;
  end;

  TAPayAuthInfo = class(TOCGenericImport<APayAuthInfoClass, APayAuthInfo>)
  end;

  // AlipaySDK.h
  AlipayTidFactor = (ALIPAY_TIDFACTOR_IMEI, ALIPAY_TIDFACTOR_IMSI,
    ALIPAY_TIDFACTOR_TID, ALIPAY_TIDFACTOR_CLIENTKEY, ALIPAY_TIDFACTOR_VIMEI,
    ALIPAY_TIDFACTOR_VIMSI, ALIPAY_TIDFACTOR_CLIENTID, ALIPAY_TIDFACTOR_APDID,
    ALIPAY_TIDFACTOR_MAX);
  TAlipayTidFactor = AlipayTidFactor;

  // typedef void(^CompletionBlock)(NSDictionary *resultDic);
  CompletionBlock = procedure(resultDic: NSDictionary) of object; // cdecl;
  TCompletionBlock = CompletionBlock;

  AlipaySDK = interface;

  AlipaySDKClass = interface(NSObjectClass)
    ['{087F1862-DA2C-43BD-9FFA-E6EBEE9B17D6}']
    {
      *  ����֧����������
      *  @return ���ص�������
      + (AlipaySDK *)defaultService;
    }
    //
    function defaultService: AlipaySDK; cdecl;
  end;

  AlipaySDK = interface(NSObject)
    ['{41F28044-7B8F-41BD-8DE3-F74B9BAD3835}']
    { *
      *  ��������SDKʹ�õ�window�����û�����д���window�������ô˽ӿ�
      @property (nonatomic, weak) UIWindow *targetWindow;
    }
    function targetWindow: UIWindow; cdecl;
    procedure setTargetWindow(wnd: UIWindow); cdecl;
    { *
      *  ֧���ӿ�
      *
      *  @param orderStr       ������Ϣ
      *  @param schemeStr      ����֧����appע����info.plist�е�scheme
      *  @param compltionBlock ֧������ص�Block������wap֧������ص�������תǮ��֧����
      - (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
      callback:(CompletionBlock)completionBlock;
    }
    [MethodName('payOrder:fromScheme:callback:')]
    procedure PayOrderFromSchemeCallback(orderStr: NSString;
      schemeStr: NSString; AcompletionBlock: TCompletionBlock); cdecl;
    {
      *  ����Ǯ�����߶������app֧�������̻�appЯ����֧�����Url
      *
      *  @param resultUrl        ֧�����url
      *  @param completionBlock  ֧������ص�
    }
    [MethodName('processOrderWithPayment:standbyCallback:')]
    procedure processOrderWithPaymentResultStandbyCallback(resultUrl: NSURL;
      AcompletionBlock: TCompletionBlock); cdecl;

    {
      *  ��ȡ����token��
      *
      *  @return ����token��������Ϊ�ա�
      - (NSString *)fetchTradeToken;
    }
    function fetchTradeToken: NSString; cdecl;
    {
      *  �Ƿ��Ѿ�ʹ�ù�
      *
      *  @return YESΪ�Ѿ�ʹ�ù���NO��֮
      - (BOOL)isLogined;
    }
    function isLogined: Boolean; cdecl;
    { *
      *  ��ǰ�汾��
      *
      *  @return ��ǰ�汾�ַ���
      - (NSString *)currentVersion;
    }
    function currentVersion: NSString; cdecl;
    { *
      *  ��ǰ�汾��
      *
      *  @return tid�����Ϣ
      - (NSString*)queryTidFactor:(AlipayTidFactor)factor;
    }
    [MethodName('queryTidFactor:')]
    function queryTidFactor(factor: TAlipayTidFactor): NSString; cdecl;
    { *
      *  �yԇ���ã�realse����Ч
      *
      *  @param url  ���Ի���
      - (void)setUrl:(NSString *)url;
    }
    [MethodName('setUrl:')]
    procedure setUrl(url: NSString); cdecl;
    { *
      *  url order ��ȡ�ӿ�
      *
      *  @param urlStr     ���ص� url string
      *
      *  @return ��ȡ����url order info
      - (NSString*)fetchOrderInfoFromH5PayUrl:(NSString*)urlStr;
    }
    [MethodName('fetchOrderInfoFromH5PayUrl:')]
    function fetchOrderInfoFromH5PayUrl(urlStr: NSString): NSString; cdecl;

    {
      *  url֧���ӿ�
      *
      *  @param orderStr       ������Ϣ
      *  @param schemeStr      ����֧����appע����info.plist�е�scheme
      *  @param compltionBlock ֧������ص�Block
      - (void)payUrlOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
      callback:(CompletionBlock)completionBlock;
    }
    [MethodName('payUrlOrder:fromScheme:callback:')]
    procedure payUrlOrderFromSchemeCallback(orderStr, schemeStr: NSString;
      AcompletionBlock: TCompletionBlock); cdecl;

    /// ///////////////////////////////////////////////////////////////////////////////////////////
    /// ///////////////////////��Ȩ1.0//////////////////////////////////////////////////////////////
    /// ///////////////////////////////////////////////////////////////////////////////////////////

    {
      *  �����Ȩ
      *  @param authInfo         ����Ȩ��Ϣ
      *  @param completionBlock  ��Ȩ����ص���������Ȩ�����У����÷�Ӧ�ñ�ϵͳ��ֹ�����block��Ч��
      ��Ҫ���÷���appDelegate�е���processAuthResult:standbyCallback:������ȡ��Ȩ���
      - (void)authWithInfo:(APayAuthInfo *)authInfo
      callback:(CompletionBlock)completionBlock;
    }
    [MethodName('authWithInfo:callback:')]
    procedure authWithInfoCallback(authInfo: APayAuthInfo;
      callback: TCompletionBlock); cdecl;

    {
      *  ������Ȩ��ϢUrl
      *
      *  @param resultUrl        Ǯ�����ص���Ȩ���url
      *  @param completionBlock  ��Ȩ����ص�
      - (void)processAuthResult:(NSURL *)resultUrl
      standbyCallback:(CompletionBlock)completionBlock;
    }
    /// ///////////////////////////////////////////////////////////////////////////////////////////
    /// ///////////////////////��Ȩ2.0//////////////////////////////////////////////////////////////
    /// ///////////////////////////////////////////////////////////////////////////////////////////

    {
      *  �����Ȩ2.0
      *
      *  @param infoStr          ��Ȩ������Ϣ�ַ���
      *  @param schemeStr        ������Ȩ��appע����info.plist�е�scheme
      *  @param completionBlock  ��Ȩ����ص���������Ȩ�����У����÷�Ӧ�ñ�ϵͳ��ֹ�����block��Ч��
      ��Ҫ���÷���appDelegate�е���processAuth_V2Result:standbyCallback:������ȡ��Ȩ���
      - (void)auth_V2WithInfo:(NSString *)infoStr
      fromScheme:(NSString *)schemeStr
      callback:(CompletionBlock)completionBlock;
    }
    [MethodName('auth_V2WithInfo:fromScheme:callback:')]
    procedure auth_V2WithInfoFromSchemeCallback(infostr, schemeStr: NSString;
      callback: TCompletionBlock); cdecl;

    {
      *  ������Ȩ��ϢUrl
      *
      *  @param resultUrl        Ǯ�����ص���Ȩ���url
      *  @param completionBlock  ��Ȩ����ص�
      - (void)processAuth_V2Result:(NSURL *)resultUrl
      standbyCallback:(CompletionBlock)completionBlock;
    }
    [MethodName('processAuth_V2Result:standbyCallback:')]
    procedure processAuth_V2ResultStandbyCallback(resultUrl: NSString;
      AcompletionBlock: TCompletionBlock); cdecl;
  end;

  TAlipaySDK = class(TOCGenericImport<AlipaySDKClass, AlipaySDK>)
  end;

procedure RegisterAlipayService;

implementation

uses qsdk.alipay, FMX.Platform, qstring, syncobjs;

const
  CoreTelephonyFwk =
    '/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony';
  LibCMMotion = '/System/Library/Frameworks/CoreMotion.framework/CoreMotion';
function CoreTelephonyFakeLoader: NSString; cdecl;
  external CoreTelephonyFwk name 'OBJC_CLASS_$_CTTelephonyNetworkInfo';
function CMotionFakeLoader: CMMotionManager; cdecl;
  external LibCMMotion name 'OBJC_CLASS_$_CMMotionManager';
procedure nothrow; cdecl; external '/usr/lib/libc++.dylib' name '_ZSt7nothrow';
{$IFDEF IOS}
{$O-}
function AlipaySDK_FakeLoader: AlipaySDK; cdecl;
  external 'AlipaySDK' name 'OBJC_CLASS_$_AlipaySDK';
{$O+}
{$ENDIF}

type
  TAlipayiOSService = class(TInterfacedObject, IAlipayService)
  protected
    FInSandbox: Boolean;
    FScheme: String;
    FPayResult: String;
    FEvent: TEvent;
    function getInSandbox: Boolean;
    procedure setInSandbox(const AVal: Boolean);
    function getInstalled: Boolean; // �ж�֧�����Ƿ�װ
    function pay(AOrder: String): String; // ����֧���ӿ�
    function getScheme: String;
    procedure setScheme(const AValue: String);
    procedure DoPayDone(resultDic: NSDictionary);
  public
    constructor Create; overload;
    destructor Destroy; override;
  end;

procedure RegisterAlipayService;
begin
  TPlatformServices.Current.AddPlatformService(IAlipayService,
    TAlipayiOSService.Create);
end;

{ TAlipayiOSService }

constructor TAlipayiOSService.Create;
begin
  FEvent := TEvent.Create(nil,false,false,'');
end;

destructor TAlipayiOSService.Destroy;
begin
  FreeAndNil(FEvent);
  inherited;
end;

procedure TAlipayiOSService.DoPayDone(resultDic: NSDictionary);
var
  AKeys: NSArray;
  AValues: NSArray;
  I: Integer;
begin
  // ��ʽ����Androidһ���ĸ�ʽ
  AKeys := resultDic.allKeys;
  AValues := resultDic.allValues;
  SetLength(FPayResult, 0);
  for I := 0 to resultDic.count - 1 do
  begin
    FPayResult := FPayResult + NSStrToStr(TNSString.Wrap(AKeys.objectAtIndex(I))
      ) + '={' + JavaEscape(NSStrToStr(TNSString.Wrap(AValues.objectAtIndex(I))
      ), false) + '};';
  end;
  FPayResult := StrDupX(PQCharW(FPayResult), Length(FPayResult) - 1);
  FEvent.SetEvent;
end;

function TAlipayiOSService.getInSandbox: Boolean;
begin
  Result := FInSandbox;
end;

function TAlipayiOSService.getInstalled: Boolean;
begin
  Result := true; // ֧�����ӿڻ��Լ��жϣ�������л����Web֧��������ʼ�շ���tru
end;

function TAlipayiOSService.getScheme: String;
begin
  Result := FScheme;
end;

function TAlipayiOSService.pay(AOrder: String): String;
begin
  SetLength(FPayResult, 0);
  TAlipaySDK.OCClass.defaultService.PayOrderFromSchemeCallback
    (StrToNSStr(AOrder), StrToNSStr(FScheme), DoPayDone);
  FEvent.WaitFor(INFINITE);
  Result := FPayResult;
end;

procedure TAlipayiOSService.setInSandbox(const AVal: Boolean);
begin
  FInSandbox := AVal;
end;

procedure TAlipayiOSService.setScheme(const AValue: String);
begin
  FScheme := AValue;
end;

END.

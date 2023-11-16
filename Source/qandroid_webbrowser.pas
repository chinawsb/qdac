unit qandroid_webbrowser;

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
  ������У�
  ��������ʤ��
  �˺ţ�6226 6208 0391 5552
  �����У�������г���������֧��
}
{ QAndroid_WebBrowser �Ƕ�Android��TWebBrowser��������ӣ������˶�ԭ����WebView�ӿ�
  ��ֱ�ӷ��ʣ�ͬʱ�ṩ�˶���ĺ�����װ��

  �޶���־��
  ========
  2016.5.7
  ========
  + ��һ���汾���ṩ��Eval��������ȡJS�ķ���ֵ��ͬʱ�ṩ��ԭ����WebView���Խӿ�
}
uses classes, sysutils, syncobjs, system.Rtti, FMX.WebBrowser,
  FMX.WebBrowser.Android,
  Androidapi.JNI.Webkit, Androidapi.JNI.Embarcadero, Androidapi.Helpers,
  FMX.Helpers.Android, Androidapi.JNI.JavaTypes, Androidapi.JNIBridge;

type
  EAndroidHelperError = class(Exception)
  end;

  TQAndroidBrowserHelper = class helper for TWebBrowser
  private
    function GetWebView: JWebBrowser;
  public
    function Eval(S: String): String;
    procedure RegisterClass(AClass: TClass);
    procedure UnregisterClass(AClass: TClass);
    procedure RegisterObject(AObject: TObject; const AName: String);
    procedure UnregisterObject(AObject: TObject; const AName: String);
    property WebView: JWebBrowser read GetWebView;
  end;

implementation

resourcestring
  SMethodNotImplemented = 'Method %s not implemented';

type
  TQJSWaitableResult = class(TJavaLocal, JValueCallback)
  private
    FEvent: TEvent;
    FResultValue: String;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure onReceiveValue(value: JObject); cdecl;
    function Wait(ATimeout: Cardinal): TWaitResult;
    property ResultValue: String read FResultValue;
  end;

  TQJavaClass = class;

  TQJavaLocalObject = class(TJavaLocal, JObject)
  private
    FJavaClass: JLang_Class;
  public
    constructor Create; overload;
    function equals(o: JObject): Boolean; cdecl;
    function getClass: JLang_Class; cdecl;
    function hashCode: Integer; cdecl;
    procedure notify; cdecl;
    procedure notifyAll; cdecl;
    function toString: JString; cdecl;
    procedure Wait; overload; cdecl;
    procedure Wait(millis: Int64); overload; cdecl;
    procedure Wait(millis: Int64; nanos: Integer); overload; cdecl;
  end;

  TQJavaClass = class(TQJavaLocalObject, JLang_Class)
  private
    FClassType: TClass;
  public
    constructor Create(AClass: TClass);
    function asSubclass(c: JLang_Class): JLang_Class; cdecl;
    function cast(obj: JObject): JObject; cdecl;
    function desiredAssertionStatus: Boolean; cdecl;
    function getAnnotation(annotationType: JLang_Class): JAnnotation; cdecl;
    function getAnnotations: TJavaObjectArray<JAnnotation>; cdecl;
    function getCanonicalName: JString; cdecl;
    function getClassLoader: JClassLoader; cdecl;
    function getClasses: TJavaObjectArray<JLang_Class>; cdecl;
    function getComponentType: JLang_Class; cdecl;
    function getConstructors: TJavaObjectArray<JConstructor>; cdecl;
    function getDeclaredAnnotations: TJavaObjectArray<JAnnotation>; cdecl;
    function getDeclaredClasses: TJavaObjectArray<JLang_Class>; cdecl;
    function getDeclaredConstructors: TJavaObjectArray<JConstructor>; cdecl;
    function getDeclaredField(name: JString): JField; cdecl;
    function getDeclaredFields: TJavaObjectArray<JField>; cdecl;
    function getDeclaredMethods: TJavaObjectArray<JMethod>; cdecl;
    function getDeclaringClass: JLang_Class; cdecl;
    function getEnclosingClass: JLang_Class; cdecl;
    function getEnclosingConstructor: JConstructor; cdecl;
    function getEnclosingMethod: JMethod; cdecl;
    function getEnumConstants: TJavaObjectArray<JObject>; cdecl;
    function getField(name: JString): JField; cdecl;
    function getFields: TJavaObjectArray<JField>; cdecl;
    function getGenericInterfaces: TJavaObjectArray<Jreflect_Type>; cdecl;
    function getGenericSuperclass: Jreflect_Type; cdecl;
    function getInterfaces: TJavaObjectArray<JLang_Class>; cdecl;
    function getMethods: TJavaObjectArray<JMethod>; cdecl;
    function getModifiers: Integer; cdecl;
    function getName: JString; cdecl;
    function getPackage: JPackage; cdecl;
    function getResourceAsStream(resourceName: JString): JInputStream; cdecl;
    function getSigners: TJavaObjectArray<JObject>; cdecl;
    function getSimpleName: JString; cdecl;
    function getSuperclass: JLang_Class; cdecl;
    function getTypeParameters: TJavaObjectArray<JTypeVariable>; cdecl;
    function isAnnotation: Boolean; cdecl;
    function isAnnotationPresent(annotationType: JLang_Class): Boolean; cdecl;
    function isAnonymousClass: Boolean; cdecl;
    function isArray: Boolean; cdecl;
    function isAssignableFrom(c: JLang_Class): Boolean; cdecl;
    function isEnum: Boolean; cdecl;
    function isInstance(object_: JObject): Boolean; cdecl;
    function isInterface: Boolean; cdecl;
    function isLocalClass: Boolean; cdecl;
    function isMemberClass: Boolean; cdecl;
    function isPrimitive: Boolean; cdecl;
    function isSynthetic: Boolean; cdecl;
    function newInstance: JObject; cdecl;
    function toString: JString; cdecl;
  end;
  { TQAndroidBrowserHelper }

function TQAndroidBrowserHelper.Eval(S: String): String;
var
  AWaiter: TQJSWaitableResult;
begin
  AWaiter := TQJSWaitableResult.Create();
  AWaiter._AddRef;
  CallInUIThreadAndWaitFinishing(
    procedure
    begin
      WebView.evaluateJavascript(StringToJString(S), AWaiter);
    end);
  AWaiter.Wait(INFINITE);
  Result := AWaiter.ResultValue;
  AWaiter._Release;
end;

function TQAndroidBrowserHelper.GetWebView: JWebBrowser;
var
  AContext: TRttiContext;
  AType: TRttiType;
  AField: TRttiField;
  AInst: TObject;
  AService: IFMXWBService;
begin
  AContext := TRttiContext.Create;
  AType := AContext.GetType(TWebBrowser);
  AField := AType.getField('FWeb');
  AInst := AField.GetValue(Self).AsInterface as TObject;
  AType := AContext.GetType(AInst.ClassType);
  if Assigned(AType) then
  begin
    AField := AType.getField('FJWebBrowser');
    Result := AField.GetValue(AInst).AsInterface as JWebBrowser;
  end
  else
    Result := nil;
end;

procedure TQAndroidBrowserHelper.RegisterClass(AClass: TClass);
begin
  raise EAndroidHelperError.CreateFmt(SMethodNotImplemented, ['RegisterClass']);
end;

procedure TQAndroidBrowserHelper.RegisterObject(AObject: TObject;
const AName: String);
begin
  raise EAndroidHelperError.CreateFmt(SMethodNotImplemented,
    ['RegisterObject']);
end;

procedure TQAndroidBrowserHelper.UnregisterClass(AClass: TClass);
begin
  WebView.removeJavascriptInterface(StringToJString(AClass.ClassName));
end;

procedure TQAndroidBrowserHelper.UnregisterObject(AObject: TObject;
const AName: String);
begin
  WebView.removeJavascriptInterface(StringToJString(AName));
end;

{ TQJSWaitableResult }

constructor TQJSWaitableResult.Create;
begin
  inherited;
  FEvent := TEvent.Create(nil, false, false, '');
end;

destructor TQJSWaitableResult.Destroy;
begin
  FreeAndNil(FEvent);
  inherited;
end;

procedure TQJSWaitableResult.onReceiveValue(value: JObject);
begin
  FResultValue := JStringToString(value.toString);
  FEvent.SetEvent;
end;

function TQJSWaitableResult.Wait(ATimeout: Cardinal): TWaitResult;
begin
  Result := FEvent.WaitFor(ATimeout);
end;

{ TQJavaLocalObject }

constructor TQJavaLocalObject.Create;
begin
end;

function TQJavaLocalObject.equals(o: JObject): Boolean;
begin
  Result := inherited equals(Pointer(o));
end;

function TQJavaLocalObject.getClass: JLang_Class;
begin
  Result := TQJavaClass.Create(ClassType)
end;

function TQJavaLocalObject.hashCode: Integer;
begin
  Result := Integer(Self);
end;

procedure TQJavaLocalObject.notify;
begin
  TMonitor.Pulse(Self);
end;

procedure TQJavaLocalObject.notifyAll;
begin
  TMonitor.PulseAll(Self);
end;

function TQJavaLocalObject.toString: JString;
begin
  Result := StringToJString(ClassName);
end;

procedure TQJavaLocalObject.Wait;
begin
  TMonitor.Wait(Self, INFINITE);
end;

procedure TQJavaLocalObject.Wait(millis: Int64);
begin
  TMonitor.Wait(Self, millis);
end;

procedure TQJavaLocalObject.Wait(millis: Int64; nanos: Integer);
begin
  TMonitor.Wait(Self, millis); // ��������뱻����
end;

{ TQJavaClass }

function TQJavaClass.asSubclass(c: JLang_Class): JLang_Class;
var
  AInst: TClass;
begin
  Result := nil;
  AInst := (c as ILocalObject).GetObjectID;
  if AInst.InheritsFrom(FClassType) then
    Result := Self;
end;

function TQJavaClass.cast(obj: JObject): JObject;
begin
  Result := obj;
end;

constructor TQJavaClass.Create(AClass: TClass);
begin
  inherited Create;
  FClassType := AClass;
end;

function TQJavaClass.desiredAssertionStatus: Boolean;
begin
  Result := false;
end;

function TQJavaClass.getAnnotation(annotationType: JLang_Class): JAnnotation;
begin

end;

function TQJavaClass.getAnnotations: TJavaObjectArray<JAnnotation>;
begin

end;

function TQJavaClass.getCanonicalName: JString;
begin

end;

function TQJavaClass.getClasses: TJavaObjectArray<JLang_Class>;
begin

end;

function TQJavaClass.getClassLoader: JClassLoader;
begin

end;

function TQJavaClass.getComponentType: JLang_Class;
begin

end;

function TQJavaClass.getConstructors: TJavaObjectArray<JConstructor>;
begin

end;

function TQJavaClass.getDeclaredAnnotations: TJavaObjectArray<JAnnotation>;
begin

end;

function TQJavaClass.getDeclaredClasses: TJavaObjectArray<JLang_Class>;
begin

end;

function TQJavaClass.getDeclaredConstructors: TJavaObjectArray<JConstructor>;
begin

end;

function TQJavaClass.getDeclaredField(name: JString): JField;
begin

end;

function TQJavaClass.getDeclaredFields: TJavaObjectArray<JField>;
begin

end;

function TQJavaClass.getDeclaredMethods: TJavaObjectArray<JMethod>;
begin

end;

function TQJavaClass.getDeclaringClass: JLang_Class;
begin

end;

function TQJavaClass.getEnclosingClass: JLang_Class;
begin

end;

function TQJavaClass.getEnclosingConstructor: JConstructor;
begin

end;

function TQJavaClass.getEnclosingMethod: JMethod;
begin

end;

function TQJavaClass.getEnumConstants: TJavaObjectArray<JObject>;
begin

end;

function TQJavaClass.getField(name: JString): JField;
begin

end;

function TQJavaClass.getFields: TJavaObjectArray<JField>;
begin

end;

function TQJavaClass.getGenericInterfaces: TJavaObjectArray<Jreflect_Type>;
begin

end;

function TQJavaClass.getGenericSuperclass: Jreflect_Type;
begin

end;

function TQJavaClass.getInterfaces: TJavaObjectArray<JLang_Class>;
begin

end;

function TQJavaClass.getMethods: TJavaObjectArray<JMethod>;
begin

end;

function TQJavaClass.getModifiers: Integer;
begin

end;

function TQJavaClass.getName: JString;
begin

end;

function TQJavaClass.getPackage: JPackage;
begin

end;

function TQJavaClass.getResourceAsStream(resourceName: JString): JInputStream;
begin

end;

function TQJavaClass.getSigners: TJavaObjectArray<JObject>;
begin

end;

function TQJavaClass.getSimpleName: JString;
begin

end;

function TQJavaClass.getSuperclass: JLang_Class;
begin

end;

function TQJavaClass.getTypeParameters: TJavaObjectArray<JTypeVariable>;
begin

end;

function TQJavaClass.isAnnotation: Boolean;
begin

end;

function TQJavaClass.isAnnotationPresent(annotationType: JLang_Class): Boolean;
begin

end;

function TQJavaClass.isAnonymousClass: Boolean;
begin

end;

function TQJavaClass.isArray: Boolean;
begin

end;

function TQJavaClass.isAssignableFrom(c: JLang_Class): Boolean;
begin

end;

function TQJavaClass.isEnum: Boolean;
begin

end;

function TQJavaClass.isInstance(object_: JObject): Boolean;
begin

end;

function TQJavaClass.isInterface: Boolean;
begin

end;

function TQJavaClass.isLocalClass: Boolean;
begin

end;

function TQJavaClass.isMemberClass: Boolean;
begin

end;

function TQJavaClass.isPrimitive: Boolean;
begin

end;

function TQJavaClass.isSynthetic: Boolean;
begin

end;

function TQJavaClass.newInstance: JObject;
begin

end;

function TQJavaClass.toString: JString;
begin

end;

end.

unit qplugins_formsvc;

interface

{$I 'qdac.inc'}

uses classes, sysutils, types, qstring, qplugins,qplugins_base,
  qplugins_params{$IF RTLVERSION<23}, controls, forms{$ELSE}, uitypes{$IFEND};
{$HPPEMIT '#pragma link "qplugins_formsvc"'}

type
  // ����Ԫֻ֧�� Delphi/C++ Builder
  IQFormService = interface;

  /// <summary>
  /// ������ʾģ̬�Ի���ʱ�Ļص�����
  /// </summary>
  TQFormModalResultHandler = procedure(ASender: IQFormService; ATag: IQParams)
    of object;

  /// <summary>
  /// ����CanClose�¼��Ľӿڰ�
  /// </summary>
  TQFormCloseQueryEvent = procedure(ASender: IQFormService;
    var ACanClose: Boolean) of object;
  /// <summary>
  /// ����OnClose�¼��Ľӿڰ�
  /// </summary>
  TQFormCloseEvent = procedure(ASender: IQFormService; var Action: TCloseAction)
    of object;
  /// <summary>
  /// ����֪ͨ�¼��Ľӿڰ�
  /// </summary>
  TQFormNotifyEvent = procedure(ASender: IQFormService) of object;

  /// <summary>
  /// ���̰���״̬
  /// </summary>
  TQKeyState = record
  private
    FFlags: Byte;
    function GetFlags(const Index: Integer): Boolean;
    procedure SetFlags(const Index: Integer; const Value: Boolean);
  public
    property LeftShiftDown: Boolean index 0 read GetFlags write SetFlags;
    property RightShiftDown: Boolean index 1 read GetFlags write SetFlags;
    property LeftCtrlDown: Boolean index 2 read GetFlags write SetFlags;
    property RightCtrlDown: Boolean index 3 read GetFlags write SetFlags;
    property LeftAltDown: Boolean index 4 read GetFlags write SetFlags;
    property RightAltDown: Boolean index 5 read GetFlags write SetFlags;
    property LeftWinDown: Boolean index 2 read GetFlags write SetFlags;
    property RightWinDown: Boolean index 2 read GetFlags write SetFlags;
  end;

  /// <summary>
  /// ��������
  /// </summary>
  TQKeyData = record
    IsDown: Boolean;
    Key: Byte;
  end;

  /// <summary>
  /// ��갴ť
  /// </summary>
  TQMouseButton = (
    /// <summary>
    /// ���
    /// </summary>
    vmbLeft,
    /// <summary>
    /// �Ҽ�
    /// </summary>
    vmbRight,
    /// <summary>
    /// �м��
    /// </summary>
    vmbMiddle,
    /// <summary>
    /// X��
    /// </summary>
    vmbX);

  /// <summary>
  /// �����������
  /// </summary>
  TQMouseData = record
    Pos: TSmallPoint; // ���λ��
    WheelData: Cardinal; // ��������
    Events: Word;
  end;

  /// <summary>
  /// ģ���������͵��¼�����
  /// </summary>
  TQInputEventType = (
    /// <summary>
    /// ���
    /// </summary>
    ietMouse,
    /// <summary>
    /// ����
    /// </summary>
    ietKeyboad);

  /// <summary>
  /// �����¼�����
  /// </summary>
  TQInputEvent = record
    Shifts: TQKeyState;
    EventType: TQInputEventType;
    case Integer of
      0:
        (Mouse: TQMouseData);
      1:
        (Key: TQKeyData);
  end;

  // ��ʱ�ȹ����⼸���¼�
  TQFormEvents = record
    CanClose: TQFormCloseQueryEvent;
    OnClose: TQFormCloseEvent;
    OnFree: TQFormNotifyEvent;
    OnActivate: TQFormNotifyEvent;
    OnDeactivate: TQFormNotifyEvent;
    OnResize: TQFormNotifyEvent;
    OnShow: TQFormNotifyEvent;
    OnHide: TQFormNotifyEvent;
  end;

  TQFormNotifyProc = procedure(AData: Pointer) of object;

  /// <summary>
  /// ���������������������ͷ�֪ͨ����ӿ�
  /// </summary>
  IQFreeNotifyService = interface
    ['{375027FB-185B-44C4-B3C5-1ABAE344ABBE}']
    procedure RegisterFreeNotify(AHandle: THandle; AOnFree: TQFormNotifyProc;
      AData: Pointer);
    procedure RegisterSizeNotify(AHandle: THandle; AOnResize: TQFormNotifyProc;
      AData: Pointer);
    procedure Unregister(AOnFree: TQFormNotifyProc);
    function InSameInstance(AHandle: THandle): Boolean;
    procedure ParentSizeChanged(AParent: THandle);
    procedure Clear;
  end;

  /// <summary>
  /// �û��Զ�����������ӿڣ�����ͨ�������÷�����Զ��巽��
  /// </summary>
  IQCustomAction = interface
    ['{E367142F-B866-4419-9AC1-A29F0D43DA5F}']
    function DoAction(AParams: IQParams; AResult: IQParams = nil): Boolean;
  end;

  /// <summary>
  /// ������Dockʱ�Ķ��뷽ʽ
  /// </summary>
  TFormAlign = (
    /// <summary>
    /// ���������
    /// </summary>
    faNone,
    /// <summary>
    /// ����Ĭ�϶��壬ȡ������Align���Ե�ֵ
    /// </summary>
    faDefault,
    /// <summary>
    /// ˮƽ���󣬴�ֱ����
    /// </summary>
    faLeftTop,
    /// <summary>
    /// ˮƽ���У���ֱ����
    /// </summary>
    faCenterTop,
    /// <summary>
    /// ˮƽ��䣬 ��ֱ����
    /// </summary>
    faTop,
    /// <summary>
    /// ˮ�¾��ң���ֱ����
    /// </summary>
    faRightTop,
    /// <summary>
    /// ˮƽ���ң���ֱ����
    /// </summary>
    faRightCenter,
    /// <summary>
    /// ˮƽ���У���ֱ���
    /// </summary>
    faRight,
    /// <summary>
    /// ˮƽ���ң���ֱ����
    /// </summary>
    faRightBottom,
    /// <summary>
    /// ˮƽ���У���ֱ����
    /// </summary>
    faCenterBottom,
    /// <summary>
    /// ˮƽ��䣬��ֱ����
    /// </summary>
    faBottom,
    /// <summary>
    /// ˮƽ���󣬴�ֱ����
    /// </summary>
    faLeftBottom,
    /// <summary>
    /// ˮƽ���󣬴�ֱ���
    /// </summary>
    faLeft,
    /// <summary>
    /// ˮƽ���󣬴�ֱ����
    /// </summary>
    faLeftCenter,
    /// <summary>
    /// ���������
    /// </summary>
    faContent,
    /// <summary>
    /// ����
    /// </summary>
    faCenter,
    /// <summary>
    /// ˮƽ��䣬��ֱ����
    /// </summary>
    faHoriz,
    /// <summary>
    /// ��ֱ��䣬ˮƽ����
    /// </summary>
    faVert,
    /// <summary>
    /// �û��Զ���
    /// </summary>
    faCustom);

  /// <summary>
  /// �������Ľӿ�
  /// </summary>
  IQFormService = interface
    ['{8B1FC131-122E-4961-9A85-833DF892AC1A}']
    /// <summary>
    /// ��ʾһ��ģ̬�Ի���
    /// </summary>
    /// <param name="AOnModalResult">
    /// ���رմ���ʱ�Ļص�����
    /// </param>
    /// <param name="ATag">
    /// �û����ӵĶ����������AOnModalResultʱ�ᴫ�ݸ��û�����
    /// </param>
    procedure ShowModal(AOnModalResult: TQFormModalResultHandler = nil;
      ATag: IQParams = nil);
    /// <summary>
    /// ��ʾһ����ģ̬�Ի���
    /// </summary>
    procedure Show;

    /// <summary>
    /// ��ǰ����
    /// </summary>
    procedure BringToFront;
    /// <summary>
    /// ���ô���
    /// </summary>
    procedure SendToBack;
    /// <summary>
    /// ���ô���λ�ô�С
    /// </summary>
    procedure SetBounds(L, T, W, H: Integer);
    /// <summary>
    /// ��ȡ����λ�ü���С
    /// </summary>
    procedure GetBounds(var R: TRect);
    /// <summary>
    /// Ƕ�봰�嵽�����ڵ��ض���λ��
    /// </summary>
    /// <param name="AHandle">
    /// ���ؼ��Ĵ��ھ��
    /// </param>
    /// <param name="ARect">
    /// Ҫ�󶨵�λ������
    /// </param>
    procedure DockTo(AHandle: THandle; const ARect: TRect); overload;
    /// <summary>
    /// Ƕ�봰�嵽�����ڵ��ض���λ��
    /// </summary>
    /// <param name="AHandle">
    /// ���ؼ��Ĵ��ھ��
    /// </param>
    /// <param name="Align">
    /// ���뷽ʽ
    /// </param>
    procedure DockTo(AHandle: THandle; Align: TFormAlign); overload;
    /// <summary>
    /// ȡ�������Ƕ��
    /// </summary>
    procedure Undock;
    /// <summary>
    /// ����ģ�����밴������궯������ǰ�Ĵ���
    /// </summary>
    procedure SendInput(var AInput: TQInputEvent);
    /// <summary>
    /// �ҽӷ�������Ĵ����¼�
    /// </summary>
    procedure HookEvents(const AEvents: TQFormEvents);
    /// <summary>
    /// �Ƴ�����������¼��ļ���
    /// </summary>
    procedure UnhookEvents;
    /// <summary>
    /// ���ô����ModalResltֵ
    /// </summary>
    function GetModalResult: TModalResult;
    /// <summary>
    /// ���ô����ModalResultֵ
    /// </summary>
    procedure SetModalResult(const AValue: TModalResult);
    /// <summary>
    /// �Ƿ��Ƕ�ʵ������
    /// </summary>
    function IsMultiInstance: Boolean;
    /// <summary>
    /// ��ȡ����Ŀ��
    /// </summary>
    function GetWidth: Integer;
    /// <summary>
    /// ���ô���Ŀ��
    /// </summary>
    procedure SetWidth(const AValue: Integer);
    /// <summary>
    /// ��ȡ����ĸ߶�
    /// </summary>
    function GetHeight: Integer;
    /// <summary>
    /// ���ô���ĸ߶�
    /// </summary>
    procedure SetHeight(const AValue: Integer);
    /// <summary>
    /// ��ȡ����Ķ��뷽ʽ
    /// </summary>
    function GetFormAlign: TFormAlign;
    /// <summary>
    /// ���ô���Ķ��뷽ʽ
    /// </summary>
    procedure SetFormAlign(const AValue: TFormAlign);

    /// <summary>
    /// Dockʱ���������С����ʱ����
    /// </summary>
    procedure ParentResized;
    /// <summary>
    /// ��ִ�н�һ������ǰ��ȷ��Form�Ƿ񴴽�
    /// </summary>
    function FormNeeded: Boolean;
    /// <summary>
    /// ��ȡ DockTo ʱ�ĸ����
    /// </summary>
    function GetDockParent: THandle;
    ///<summary>
    ///  �رմ���
    ///</summary>
    procedure Close;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Align: TFormAlign read GetFormAlign write SetFormAlign;
    property DockParent: THandle read GetDockParent;
  end;

  /// <summary>

  /// IQFormService��ʵ�ֻ��࣬VCL��FMX�ֱ�ʵ���˾�������͡�VCL����������qplugins.vcl.formsvc��Ԫ��FMX����������qplugins.fmx.formsvc��Ȼ�����RegisterFormService��ע�����ķ���
  /// </summary>
  /// <remarks>
  /// ��Ҫ��ͼ���� TQFormService���͵�ʵ������������Abstract Error��
  /// </remarks>
  TQFormService = class(TQService, IQFormService)
  protected
    procedure InternalModalResult(ASender: IQFormService; ATag: IQParams);
    function GetWidth: Integer; virtual; abstract;
    procedure SetWidth(const AValue: Integer); virtual; abstract;
    function GetHeight: Integer; virtual; abstract;
    procedure SetHeight(const AValue: Integer); virtual; abstract;
    function GetFormAlign: TFormAlign; virtual; abstract;
    procedure SetFormAlign(const AValue: TFormAlign); virtual; abstract;
    procedure ParentResized; virtual; abstract;
    function FormNeeded: Boolean; virtual; abstract;
    function GetDockParent: THandle; virtual; abstract;
  public
    function Execute(AParams: IQParams; AResult: IQParams): Boolean; override;
    procedure ShowModal(AOnModalResult: TQFormModalResultHandler;
      ATag: IQParams); virtual; abstract;
    procedure Show; virtual; abstract;
    procedure BringToFront; virtual; abstract;
    procedure SendToBack; virtual; abstract;
    procedure SetBounds(L, T, W, H: Integer); virtual; abstract;
    procedure GetBounds(var R: TRect); virtual; abstract;
    procedure DockTo(AHandle: THandle; const ARect: TRect); overload;
      virtual; abstract;
    procedure DockTo(AHandle: THandle; Align: TFormAlign); overload;
      virtual; abstract;
    procedure Undock; virtual; abstract;
    procedure SendInput(var AInput: TQInputEvent); virtual; abstract;
    procedure HookEvents(const AEvents: TQFormEvents); virtual; abstract;
    procedure UnhookEvents; virtual; abstract;
    procedure Close; virtual;abstract;
    function IsMultiInstance: Boolean; virtual; abstract;
    function GetModalResult: TModalResult; virtual; abstract;
    procedure SetModalResult(const AValue: TModalResult); virtual; abstract;
  end;

implementation
{$IFDEF MSWINDOWS}
var
  hGdiPlus:HMODULE;

{$ENDIF}
{ TQFormService }


function TQFormService.Execute(AParams, AResult: IQParams): Boolean;
var
  AName: QStringW;
  procedure DoGetBounds;
  var
    R: TRect;
  begin
    if Assigned(AResult) then
    begin
      GetBounds(R);
      AResult.Add('Left', ptInt32).AsInteger := R.Left;
      AResult.Add('Top', ptInt32).AsInteger := R.Top;
      AResult.Add('Right', ptInt32).AsInteger := R.Right;
      AResult.Add('Bottom', ptInt32).AsInteger := R.Bottom;
    end;
  end;
  procedure DoCustomAction;
  var
    ATemp: TQParams;
    ACustomAction: IQCustomAction;
  begin
    if Supports(Self, IQCustomAction, ACustomAction) then
    begin
      ATemp := TQParams.Create;
      ATemp.AddRange(AParams, 1, AParams.Count - 1);
      ACustomAction.DoAction(ATemp, AResult);
    end;
  end;

begin
  Result := False;
  AName := ParamAsString(AParams[0]);
  if StrCmpW(PQCharW(AName), 'ShowModal', True) = 0 then // Show Modal
  begin
    ShowModal(InternalModalResult, AResult);
    Result := True;
  end
  else if StrCmpW(PQCharW(AName), 'Show', True) = 0 then
  begin
    Show;
    Result := True;
  end
  else if StrCmpW(PQCharW(AName), 'BringToFront', True) = 0 then
  begin
    BringToFront;
    Result := True;
  end
  else if StrCmpW(PQCharW(AName), 'SendToBack', True) = 0 then
  begin
    SendToBack;
    Result := True;
  end
  else if StrCmpW(PQCharW(AName), 'SetBounds', True) = 0 then
  begin
    if AParams.Count = 5 then
    begin
      SetBounds(AParams[1].AsInteger, AParams[2].AsInteger,
        AParams[3].AsInteger, AParams[4].AsInteger);
      Result := True;
    end
  end
  else if StrCmpW(PQCharW(AName), 'GetBounds', True) = 0 then
  begin
    DoGetBounds;
    Result := True;
  end
  else if StrCmpW(PQCharW(AName), 'DockTo', True) = 0 then
  begin
    if AParams.Count = 6 then // Name,Handle,Left,Top,Right,Bottom
    begin
      DockTo(AParams[1].AsInt64, Rect(AParams[2].AsInteger,
        AParams[3].AsInteger, AParams[4].AsInteger, AParams[5].AsInteger));
      Result := True;
    end
  end
  else if StrCmpW(PQCharW(AName), 'Undock', True) = 0 then
  begin
    Undock;
    Result := True;
  end
  else if StrCmpW(PQCharW(AName), 'IsMultiInstance', True) = 0 then
  begin
    if Assigned(AResult) then
    begin
      AResult.Add('IsMultiInstance', ptBoolean).AsBoolean := IsMultiInstance;
      Result := True;
    end
  end
  else if StrCmpW(PQCharW(AName), 'GetModalResult', True) = 0 then
  begin
    if Assigned(AResult) then
    begin
      AResult.Add('ModalResult', ptInt32).AsInteger := GetModalResult;
      Result := True;
    end
  end
  else if StrCmpW(PQCharW(AName), 'SetModalResult', True) = 0 then
  begin
    if AParams.Count = 2 then // Name,ModalResult
    begin
      SetModalResult(AParams[1].AsInteger);
      Result := True;
    end
  end
  else if StrCmpW(PQCharW(AName), 'CustomAction', True) = 0 then
  begin
    DoCustomAction;
    Result := True;
  end
  else // ��֧����������
    Result := False;
end;

procedure TQFormService.InternalModalResult(ASender: IQFormService;
  ATag: IQParams);
begin
  if Assigned(ATag) then
    ATag.Add('ModalResult', ptInt32).AsInteger := Integer(ASender.ModalResult);
end;

{ TQKeyState }

function TQKeyState.GetFlags(const Index: Integer): Boolean;
begin
  Result := (FFlags and (1 shl Index)) <> 0;
end;

procedure TQKeyState.SetFlags(const Index: Integer; const Value: Boolean);
begin
  if Value then
    FFlags := FFlags or (1 shl Index)
  else
    FFlags := FFlags and (not(1 shl Index));
end;
{$IFDEF MSWINDOWS}
function GdipAlloc: pointer; stdcall; external 'gdiplus.dll' name 'GdipAlloc';

{$ENDIF}

end.

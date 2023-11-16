unit qdialog_builder;

interface

{
  QDialogBuilder VCL �棬FMX �汾��ʱû�����ṩ
  ===============================================
  QDialogBuilder ���ڹ����Զ���ĶԻ��������� QJson ���ṩ JSON ��ʽ������֧�֡�
  1��ʹ�ý̳̣�http://blog.qdac.cc/?p=4959
  2��
}
uses classes, sysutils, types, controls, stdctrls, extctrls, graphics, forms,
  windows, messages, AppEvnts;

const
  CDF_ALWAYS_CLOSABLE = $80000000; // �Ƿ�����������ʾ�رհ�ť
  CDF_TIMEOUT = $40000000; // ����ʱ�ر�
  CDF_DISPLAY_REMAIN_TIME = $20000000; // �Ƿ��ڱ�������ʾ����ʱ
  CDF_MASK_TIMEOUT = $FFFF; //
  CDF_MASK_DEFBUTTON = $FF0000;
  CDF_DEFAULT_BTN_1 = $000000;
  CDF_DEFAULT_BTN_2 = $010000;
  CDF_DEFAULT_BTN_3 = $020000;
  CDF_DEFAULT_BTN_4 = $030000;
  CDF_DEFAULT_BTN_5 = $040000;
  CDF_DEFAULT_BTN_6 = $050000;
  CDF_DEFAULT_BTN_7 = $060000;
  CDF_DEFAULT_BTN_8 = $070000;
  CDF_DEFAULT_BTN_FIRST = CDF_DEFAULT_BTN_1;
  CDF_DEFAULT_BTN_LAST = CDF_MASK_DEFBUTTON;

type
  IBaseDialogItem = interface;
  IDialogBuilder = interface;
  IDialogContainer = interface;
  // �Ի���֪ͨ�¼����ֱ��Ӧ������ӡ�����ɾ��������������Ŀ���
  TDialogNotifyEvent = (dneItemAdded, dneItemRemoved, dneParentChanged,
    dneItemChanged);
  // ������뷽ʽ�����о��ϣ����о��У����о��£����о��󣬰��о��У����о���
  TDialogItemAlignMode = (amVertTop, amVertCenter, amVertBottom, amHorizLeft,
    amHorizCenter, amHorizRight);
{$IFDEF UNICODE}
  // TNotifyEvent �������汾
  TNotifyCallback = reference to procedure(Sender: TObject);
  TDialogNotifyCallback = reference to procedure(ADialog: IDialogBuilder);
{$ENDIF}

  // ��Ŀ�����б�ӿڣ�ֻ֧��ö�٣���Ӻ��Ƴ���ͨ�����ö�Ӧ�� GroupName �Զ���ɵ�
  IDialogItemGroup = interface
    ['{299F037F-2EDB-4677-A950-A05B9CCE3137}']
    // ��Ŀ����
    function GetCount: Integer;
    // ��ȡ����
    function GetItems(const AIndex: Integer): IBaseDialogItem;
    property Count: Integer read GetCount;
    property Items[const AIndex: Integer]: IBaseDialogItem
      read GetItems; default;
  end;

  // ������Ŀ����
  IBaseDialogItem = interface
    ['{3C247227-5BF6-4DE8-BB4D-A4A574FE929B}']
    // ��Ŀλ����Ϣ
    function GetBounds: TRect;
    procedure SetBounds(const R: TRect);
    // ������Ŀ��С
    function CalcSize: TSize;
    // ��������д
    function GetGroupName: String;
    procedure SetGroupName(const Value: String);
    // ����Ŀ����
    function GetParent: IDialogContainer;
    procedure SetParent(const Value: IDialogContainer);
    // ����֪ͨ����
    procedure Notify(ASender: IBaseDialogItem; AEvent: TDialogNotifyEvent);
    // ������ IDialogBuilder ����
    function GetBuilder: IDialogBuilder;
    // �����ķ���
    function GetGroup: IDialogItemGroup;
    // �ߴ���Ϣ
    function GetWidth: Integer;
    procedure SetWidth(const AValue: Integer);
    function GetHeight: Integer;
    procedure SetHeight(const AValue: Integer);
    function GetTags: TStrings;
    property Bounds: TRect read GetBounds write SetBounds;
    property GroupName: String read GetGroupName write SetGroupName;
    property Parent: IDialogContainer read GetParent write SetParent;
    property Builder: IDialogBuilder read GetBuilder;
    property Group: IDialogItemGroup read GetGroup;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Tags: TStrings read GetTags;
  end;

  // �����ؼ��ĶԻ�����Ŀ��ͨ�������� AddControl ���
  IControlDialogItem = interface(IBaseDialogItem)
    ['{44E207B3-080C-4A45-BFE0-286D9B8222D5}']
    // �����ؼ�
    function GetControl: TControl;
    // OnClick �¼���Ӧ �������¼���Ӧ��ֱ������Control������¼�
    function GetOnClick: TNotifyEvent;
    procedure SetOnClick(const AValue: TNotifyEvent);
    // ����JSON�����Զ���
    function GetPropText: String;
    procedure SetPropText(const AValue: String);
    property PropText: String read GetPropText write SetPropText;
    property Control: TControl read GetControl;
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

  // �����ؼ������ӿ�
  IDialogContainer = interface(IControlDialogItem)
    ['{91EBE933-1AA0-45E0-8C1D-7B57578FA2B8}']
    // �����Ŀ
    function Add(const AItem: IBaseDialogItem): IDialogContainer;
    // ���һ�¿ؼ���Ŀ��ע����Щ�ؼ��������Զ��������ʵĴ�С����Ҫ��ֵ
    function AddControl(AClass: TControlClass; APropText: String = '')
      : IControlDialogItem; overload;
{$IFDEF UNICODE}
    function AddControl(AClass: TControlClass; AOnClick: TNotifyCallback;
      APropText: String = ''): IControlDialogItem; overload;
{$ENDIF}
    // ���һ��������
    function AddContainer(AlignMode: TDialogItemAlignMode): IDialogContainer;
    // ɾ��ĳһ����
    procedure Delete(const AIndex: Integer);
    // �����������
    procedure Clear;
    // ��ȡ����
    function GetItems(const AIndex: Integer): IBaseDialogItem;
    // ��ȡ������
    function GetCount: Integer;
    // ���뷽ʽ
    function GetAlignMode: TDialogItemAlignMode;
    procedure SetAlignMode(AMode: TDialogItemAlignMode);
    // ���¶���
    procedure Realign;
    // �Զ�������С
    function GetAutoSize: Boolean;
    procedure SetAutoSize(const AValue: Boolean);
    // ��������С
    function GetItemSpace: Integer;
    procedure SetItemSpace(const V: Integer);
    property AlignMode: TDialogItemAlignMode read GetAlignMode
      write SetAlignMode;
    property AutoSize: Boolean read GetAutoSize write SetAutoSize;
    property Count: Integer read GetCount;
    property Items[const AIndex: Integer]: IBaseDialogItem
      read GetItems; default;
    property ItemSpace: Integer read GetItemSpace write SetItemSpace;

  end;
  // �Ի���ر�ʱ��֪ͨ�¼�
{$IFDEF UNICODE}

  TDialogResultCallback = reference to procedure(ABuilder: IDialogBuilder);
{$ENDIF}
  TDialogResultEvent = procedure(ABuilder: IDialogBuilder) of object;
  TQDialogPopupPosition = (dppDefault, dppLeftTop, dppCenterTop, dppRightTop,
    dppLeftCenter, dppCenter, dppRightCenter, dppLeftBottom, dppCenterBottom,
    dppRightBottom);

  // �Ի��򹹽�����
  IDialogBuilder = interface(IDialogContainer)
    ['{3E33A340-A664-4110-B257-061F2B8B4E3C}']
    // ModalResult
    function GetModalResult: TModalResult;
    procedure SetModalResult(const AModalResult: TModalResult);
    // �������Ϊ������
    procedure ChangeGroup(AItem: IBaseDialogItem; ANewName: String);
    // ���ڹ㲥�¼�
    procedure GroupCast(ASender: IBaseDialogItem; AEvent: TDialogNotifyEvent);
    // ��ȡָ�����Ʒ���
    function GroupByName(const AName: String): IDialogItemGroup;
    // ��ʾģ̬�Ի���
    procedure ShowModal(); overload;
    // ��ָ���Ŀؼ�λ�õ����������Ȳ��������ķ�ʽ���ܿ��ؼ����������
    procedure Popup(AControl: TControl); overload;
    // ��ָ����λ�õ���
    procedure Popup(APos: TPoint); overload;
    // ��ʾǰ��Ҫ���¶���
    procedure RequestAlign;
    // �����Ĵ������
    function GetDialog: TForm;
    // �ر�֪ͨ�¼�
    function GetOnResult: TDialogResultEvent;
    procedure SetOnResult(AEvent: TDialogResultEvent);
{$IFDEF UNICODE}
    procedure Popup(AControl: TControl;
      ACallback: TDialogResultCallback); overload;
    procedure Popup(APos: TPoint; ACallback: TDialogResultCallback); overload;
    procedure ShowModal(ACallback: TDialogResultCallback); overload;
    procedure FixupRefCount(AFix: Integer);
{$ENDIF}
    // Dialog��PropText���壬ע�� Position ������Ч���� ShowModal �ʼ����poScreenCenter
    function GetPropText: String;
    procedure SetPropText(const AValue: String);
    function GetCanClose: Boolean;
    procedure SetCanClose(const AValue: Boolean);
    function GetCloseDelay: Word;
    procedure SetCloseDelay(const ASeconds: Word);
    function GetDisplayRemainTime: Boolean;
    procedure SetDisplayRemainTime(const AValue: Boolean);
    function GetPopupPosition: TQDialogPopupPosition;
    procedure SetPopupPosition(const Value: TQDialogPopupPosition);
    function GetPopupMonitor: TMonitor;
    procedure SetPopupMonitor(const Value: TMonitor);
    property PropText: String read GetPropText write SetPropText;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property OnResult: TDialogResultEvent read GetOnResult write SetOnResult;
    property Dialog: TForm read GetDialog;
    property CanClose: Boolean read GetCanClose write SetCanClose;
    property CloseDelay: Word read GetCloseDelay write SetCloseDelay;
    property DisplayRemainTime: Boolean read GetDisplayRemainTime
      write SetDisplayRemainTime;
    property PopupPosition: TQDialogPopupPosition read GetPopupPosition
      write SetPopupPosition;
    property PopupMonitor: TMonitor read GetPopupMonitor write SetPopupMonitor;
  end;

  TDialogIcon = (diNone, diWarning, diHelp, diError, diInformation, diShield);
  TInputType = (itNormal, itPhone, itMobile, itEMail, itUrl, itFile, itNumeric,
    itInteger);

  TInputItem = record
    Hint: String;
    DefVal: String;
    Value: String;
    &Type: TInputType;
    UseTextHint, AllowEmpty: Boolean;
    procedure Construct(AType: TInputType; AHint, ADefVal: String;
      AUseTextHint: Boolean);
    class function Create(AType: TInputType; AHint, ADefVal: String;
      AUseTextHint: Boolean): TInputItem; static;
  end;

  TInputItems = array of TInputItem;
  TStringArray = array of String;

  // �½�һ���Ի���ӿڣ������ָ�����⣬��ΪApplication.Title
function NewDialog(ACaption: String = ''): IDialogBuilder; overload;
function NewDialog(AClass: TFormClass): IDialogBuilder; overload;
function LoadDialogIcon(APicture: TPicture; const AIcon: TDialogIcon;
  ASize: TSize): Boolean; overload;
function LoadDialogIcon(APicture: TPicture; const AIconREsFile: String;
  const AIconResId: Integer; ASize: TSize): Boolean; overload;
function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIcon: TDialogIcon; AFlags: Integer = 0;
  const ACustomProps: String = ''): Integer; overload;
function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIconResId: Integer; AIconREsFile: String;
  AIconSize: TSize; AFlags: Integer = 0; const ACustomProps: String = '')
  : Integer; overload;
function CustomInput(const ACaption, AHint, ADefVal: String; var AValue: String;
  ABeforeAddEditors: TDialogNotifyCallback = nil;
  AfterAddEditors: TDialogNotifyCallback = nil): Boolean; overload;
function CustomInput(const ACaption: String;
  const AHints, ADefVals: TStringArray; var AValues: TStringArray;
  ABeforeAddEditors: TDialogNotifyCallback = nil;
  AfterAddEditors: TDialogNotifyCallback = nil): Boolean; overload;
function CustomInput(const ACaption: String; AItems: TInputItems;
  ABeforeAddEditors: TDialogNotifyCallback = nil;
  AfterAddEditors: TDialogNotifyCallback = nil): Boolean; overload;

implementation

uses qstring, qjson, typinfo;

type
  TDialogGroup = class(TInterfaceList, IDialogItemGroup)
    function GetItems(const AIndex: Integer): IBaseDialogItem;
  end;

  TBaseDialogItem = class(TInterfacedObject, IBaseDialogItem)
  protected
    FParent: IDialogContainer;
    FGroupName: String;
    FBuilder: IDialogBuilder;
    FTags: TStrings;
    function GetBounds: TRect; virtual; abstract;
    procedure SetBounds(const R: TRect); virtual; abstract;
    function CalcSize: TSize; virtual;
    function GetGroupName: String;
    procedure SetGroupName(const Value: String);
    function GetParent: IDialogContainer;
    procedure SetParent(const Value: IDialogContainer);
    procedure Notify(ASender: IBaseDialogItem;
      AEvent: TDialogNotifyEvent); virtual;
    function GetBuilder: IDialogBuilder;
    function GetGroup: IDialogItemGroup;
    function GetWidth: Integer;
    procedure SetWidth(const AValue: Integer);
    function GetHeight: Integer;
    procedure SetHeight(const AValue: Integer);
    function GetTags: TStrings;
  public
    constructor Create(ABuilder: IDialogBuilder); virtual;
    destructor Destroy; override;
    property Parent: IDialogContainer read FParent write SetParent;
    property Bounds: TRect read GetBounds write SetBounds;
    property GroupName: String read FGroupName write SetGroupName;
    property Builder: IDialogBuilder read FBuilder;
  end;

  TControlDialogItem = class(TBaseDialogItem, IControlDialogItem)
  protected
    FControl: TControl;
    FOnClick: TNotifyEvent;
    FPropText: String;
    procedure SetOnClick(const Value: TNotifyEvent);
    function GetBounds: TRect; override;
    procedure SetBounds(const R: TRect); override;
    function CalcSize: TSize; override;
    procedure Notify(ASender: IBaseDialogItem;
      AEvent: TDialogNotifyEvent); override;
    constructor Create(ABuilder: IDialogBuilder;
      ACtrlClass: TControlClass); overload;
    function GetControl: TControl;
    procedure DoClick(Sender: TObject);
    function GetOnClick: TNotifyEvent;
    function GetPropText: String;
    procedure SetPropText(const AValue: String);
  public
    constructor Create(ABuilder: IDialogBuilder); overload; override;
    destructor Destroy; override;
    property Control: TControl read FControl write FControl;
    property PropText: String read FPropText write SetPropText;
    property OnClick: TNotifyEvent read FOnClick write SetOnClick;
  end;

  TDialogContainer = class(TControlDialogItem, IDialogContainer)
  protected
    FItems: TList;
    FAlignMode: TDialogItemAlignMode;
    FAutoSize: Boolean;
    FItemSpace: Integer;
    function GetItems(const AIndex: Integer): IBaseDialogItem;
    function GetCount: Integer;
    function GetAlignMode: TDialogItemAlignMode;
    procedure SetAlignMode(AMode: TDialogItemAlignMode);
    function GetAutoSize: Boolean;
    procedure SetAutoSize(const AValue: Boolean);
    constructor Create(ABuilder: IDialogBuilder;
      ACtrlClass: TControlClass); overload;
    function GetItemSpace: Integer;
    procedure SetItemSpace(const V: Integer);
    function ItemSize: TSize;
  public
    constructor Create(ABuilder: IDialogBuilder); overload; override;
    destructor Destroy; override;
    function Add(const AItem: IBaseDialogItem): IDialogContainer;
    function AddControl(AClass: TControlClass; APropText: String = '')
      : IControlDialogItem; overload;
{$IFDEF UNICODE}
    function AddControl(AClass: TControlClass; AOnClick: TNotifyCallback;
      APropText: String = ''): IControlDialogItem; overload;
{$ENDIF}
    function AddContainer(AlignMode: TDialogItemAlignMode): IDialogContainer;
    procedure Delete(const AIndex: Integer);
    procedure Clear;
    procedure Realign; virtual;
    function CalcSize: TSize; override;
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property AlignMode: TDialogItemAlignMode read FAlignMode write FAlignMode;
    property Bounds: TRect read GetBounds write SetBounds;
    property ItemSpace: Integer read FItemSpace write FItemSpace;
  end;

  TDialogBuilderState = (dbsAlignRequest, dbsAligning, dbsPopuping, dbsPopup,
    dbsModal);
  TDialogBuilderStates = set of TDialogBuilderState;

  TDialogPopupHelper = class(TComponent)
  private
    FControl: TControl;
    FBuilder: IDialogBuilder;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetBuilder(const Value: IDialogBuilder);
    procedure SetControl(const Value: TControl);
  public
    destructor Destroy; override;
    property Builder: IDialogBuilder read FBuilder write SetBuilder;
    property Control: TControl read FControl write SetControl;
  end;

  TDialogBuilder = class;

  PDialogLink = ^TDialogLink;

  TDialogLink = record
    Dialog: TDialogBuilder;
    Next: PDialogLink;
  end;

  TDialogAppEvents = class
  private
    class var FCurrent: TDialogAppEvents;
    class function GetCurrent: TDialogAppEvents; static;

  var
    FFirstDialog, FLastDialog: PDialogLink;
    FAppEvents: TApplicationEvents;
    procedure DoAppMessage(var Msg: tagMSG; var Handled: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ADialog: TDialogBuilder);
    procedure Remove(ADialog: TDialogBuilder);
    class property Current: TDialogAppEvents read GetCurrent;
  end;

  TDialogBuilder = class(TDialogContainer, IDialogBuilder)
  private
    class var Dialogs: TDialogAppEvents;
  protected
    FDialog: TForm;
    FScrollBox: TScrollBox;
    FGroups: TStringList;
    FTimer: TTimer;
    FOnResult: TDialogResultEvent;
    FStates: TDialogBuilderStates;
    FLastDialogWndProc: TWndMethod;
    FPopupHelper: TDialogPopupHelper;
    FLastActiveWnd: THandle;
    FRefCountFix: Integer;
    FPopupPosition: TQDialogPopupPosition;
    FCloseDelay: Word;
    FCanClose: Boolean;
    FDisplayRemainTime: Boolean;
    FInitializeCaption: String;
    FPopupMonitor: TMonitor;
    function GetGroups: TStrings;
    procedure ChangeGroup(AItem: IBaseDialogItem; ANewName: String);
    procedure GroupCast(ASender: IBaseDialogItem; AEvent: TDialogNotifyEvent);
    function GroupByName(const AName: String): IDialogItemGroup;
    procedure RemoveFromGroup(AItem: TBaseDialogItem);
    procedure AddToGroup(AItem: TBaseDialogItem);
    function GetBounds: TRect; override;
    procedure SetBounds(const R: TRect); override;
    function GetModalResult: TModalResult;
    procedure SetModalResult(const AModalResult: TModalResult);
    function GetOnResult: TDialogResultEvent;
    procedure SetOnResult(AEvent: TDialogResultEvent);
    function GetDialog: TForm;
    procedure DoClosePopup(ASender: TObject);
    procedure DoResult;
    procedure DoPopupMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure DoDialogWndProc(var AMsg: TMessage);
    procedure DoDialogClose(Sender: TObject; var Action: TCloseAction);
    function GetCanClose: Boolean;
    procedure SetCanClose(const AValue: Boolean);
    function GetCloseDelay: Word;
    procedure SetCloseDelay(const Value: Word);
    function GetDisplayRemainTime: Boolean;
    procedure SetDisplayRemainTime(const AValue: Boolean);
    procedure TimerNeeded;
    procedure DoCloseTimer(ASender: TObject);
    function CalcControlPopupPos(AControl: TControl): TPoint;
    function GetPopupPosition: TQDialogPopupPosition;
    procedure SetPopupPosition(const Value: TQDialogPopupPosition);
    function GetPopupMonitor: TMonitor;
    procedure SetPopupMonitor(const Value: TMonitor);
{$IFDEF UNICODE}
    procedure SetOnResultCallback(ACallback: TDialogResultCallback);
    procedure FixupRefCount(ADelta: Integer);
    procedure ApplyRefCountFix;
{$ENDIF}
    function IsAppVisible(ABringToFrontIfVisible: Boolean): Boolean;
    procedure BeforePopup;
    procedure AfterPopup;
  public
    constructor Create(const ACaption: String); overload;
    constructor Create(const AClass: TFormClass); overload;
    destructor Destroy; override;
    procedure ShowModal(); overload;
    procedure Popup(AControl: TControl); overload;
    procedure Popup(APos: TPoint); overload;
    procedure RequestAlign;
    procedure Realign; override;
{$IFDEF UNICODE}
    procedure Popup(AControl: TControl;
      ACallback: TDialogResultCallback); overload;
    procedure Popup(APos: TPoint; ACallback: TDialogResultCallback); overload;
    procedure ShowModal(ACallback: TDialogResultCallback); overload;
{$ENDIF}
    property Dialog: TForm read FDialog;
    property Groups: TStrings read GetGroups;
    property PopupPosition: TQDialogPopupPosition read GetPopupPosition
      write SetPopupPosition;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property OnResult: TDialogResultEvent read FOnResult write SetOnResult;
    property CanClose: Boolean read FCanClose write SetCanClose;
    property CloseDelay: Word read FCloseDelay write SetCloseDelay;
    property DisplayRemainTime: Boolean read FDisplayRemainTime
      write FDisplayRemainTime;
    property PopupMonitor: TMonitor read GetPopupMonitor write SetPopupMonitor;
  end;

  IInputHelper = interface
    ['{639ED5D3-DBEE-435E-94EA-2C75A4DD7A57}']
    function ShowModal: TModalResult;
  end;

  TInputHelper = class(TInterfacedObject, IInputHelper)
  protected
    FBuilder: IDialogBuilder;
    FItems: TInputItems;
    FEditors: array of TEdit;
    FOkButton: TButton;
    procedure DoEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoOkClick(Sender: TObject);
  public
    constructor Create(ACaption: String; AItems: TInputItems;
      ABeforeAddEditors: TDialogNotifyCallback;
      AfterAddEditors: TDialogNotifyCallback);
    function ShowModal: TModalResult;
  end;

function NewDialog(ACaption: String): IDialogBuilder;
begin
  if Length(ACaption) = 0 then
    Result := TDialogBuilder.Create(Application.Title)
  else
    Result := TDialogBuilder.Create(ACaption);
end;

function NewDialog(AClass: TFormClass): IDialogBuilder;
begin
  Result := TDialogBuilder.Create(AClass);
end;

function LoadDialogIcon(APicture: TPicture; const AIconREsFile: String;
  const AIconResId: Integer; ASize: TSize): Boolean;
var
  AIcon: TIcon;
begin
  AIcon := TIcon.Create;
  try
    AIcon.SetSize(ASize.cx, ASize.cy);
    AIcon.Handle := LoadImage(GetModuleHandle(PChar(AIconREsFile)),
      MAKEINTRESOURCE(AIconResId), IMAGE_ICON, ASize.cx, ASize.cy, 0);
    Result := AIcon.HandleAllocated;
    if Result then
      APicture.Assign(AIcon);
  finally
    FreeAndNil(AIcon);
  end;
end;

function LoadDialogIcon(APicture: TPicture; const AIcon: TDialogIcon;
  ASize: TSize): Boolean;
const
  IconResId: array [TDialogIcon] of Integer = (0, 101, 102, 103, 104, 106);
begin
  Result := LoadDialogIcon(APicture, user32, IconResId[AIcon], ASize);
end;

function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIcon: TDialogIcon; AFlags: Integer;
  const ACustomProps: String): Integer;
var
  AIconSize: TSize;
const
  IconResId: array [TDialogIcon] of Integer = (0, 101, 102, 103, 104, 106);
begin
  AIconSize.cx := 32;
  AIconSize.cy := 32;
  Result := CustomDialog(ACaption, ATitle, AMessage, AButtons, IconResId[AIcon],
    user32, AIconSize, AFlags, ACustomProps);
end;

function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIconResId: Integer; AIconREsFile: String;
  AIconSize: TSize; AFlags: Integer; const ACustomProps: String): Integer;
var
  AIcon: TIcon;
  ABuilder: IDialogBuilder;
  I, ADefBtnIndex: Integer;
  AIconImage: TImage;
begin
  ABuilder := NewDialog(ACaption);
  ABuilder.ItemSpace := 10;
  ABuilder.AutoSize := True;
  ABuilder.Dialog.FormStyle := fsStayOnTop;
  ADefBtnIndex := (AFlags and CDF_MASK_DEFBUTTON) shr 16;
  // ABuilder.Dialog.Padding.SetBounds(5, 10, 5, 5);
  // ABuilder.Dialog.Color := clWhite;
  // ���У������Ǳ��⣬ͼ��+���⣬ͼ��+��Ϣ����Ϣ
  with ABuilder.AddContainer(amVertTop) do
  begin
    AutoSize := True;
    with TPanel(Control) do
    begin
      Padding.Left := ABuilder.ItemSpace;
      Padding.Right := ABuilder.ItemSpace;
      Padding.Top := ABuilder.ItemSpace;
      ParentBackground := false;
      Color := clWhite;
    end;
    with AddContainer(amHorizLeft) do
    begin
      AutoSize := True;
      if (Length(AIconREsFile) > 0) and (AIconResId > 0) then
      begin
        AIconImage := TImage(AddControl(TImage).Control);
        with AIconImage do
        begin
          AutoSize := True;
          AlignWithMargins := True;
          LoadDialogIcon(Picture, AIconREsFile, AIconResId, AIconSize);
        end;
      end;
      if Length(ATitle) > 0 then
      begin
        with TLabel(AddControl(TLabel).Control) do
        begin
          // �Ͱ汾�� Delphi ��Ҫ���ú�������ȡ��ǰ����ϵͳ�汾
          if TOSVersion.Major > 5 then
            Font.Name := 'Microsoft YaHei'
          else
            Font.Name := 'SimHei';
          Font.Size := 12;
          Layout := tlCenter;
          Caption := ATitle;
        end;
      end
      else if Length(AMessage) > 0 then
      begin
        with TLabel(AddControl(TLabel).Control) do
        begin
          AlignWithMargins := True;
          Layout := tlCenter;
          Caption := AMessage;
        end;
      end;;
    end;
    if (Length(ATitle) > 0) and (Length(AMessage) > 0) then
    begin
      with TLabel(AddControl(TLabel).Control) do
      begin
        AlignWithMargins := True;
        Margins.Left := AIconImage.Left + ABuilder.ItemSpace + AIconImage.Width;
        Margins.Right := Margins.Left;
        Caption := AMessage;
      end;
    end;
  end;
  if Length(AButtons) > 0 then
  begin
    with ABuilder.AddContainer(amHorizRight) do
    begin
      Height := 32;
      Width := Length(AButtons) * 100;
      with TPanel(Control) do
      begin
        ParentBackground := false;
        Padding.Right := ABuilder.ItemSpace div 2;
      end;
      for I := 0 to High(AButtons) do
      begin
        with AddControl(TButton) do
        begin
          TButton(Control).Caption := AButtons[I];
          TButton(Control).ModalResult := 100 + I;
          if ((ADefBtnIndex - 1) = I) or
            ((ADefBtnIndex = CDF_DEFAULT_BTN_LAST) and (I = High(AButtons)))
          then
            ABuilder.Dialog.ActiveControl := TButton(Control);
        end;
      end;
      if (AFlags and CDF_ALWAYS_CLOSABLE) = 0 then
        ABuilder.CanClose := Length(AButtons) <= 1;
    end;
  end;
  ABuilder.CloseDelay := AFlags and CDF_MASK_TIMEOUT;
  ABuilder.DisplayRemainTime := (AFlags and CDF_DISPLAY_REMAIN_TIME) <> 0;
  ABuilder.Realign;
  ABuilder.PropText := ACustomProps;
  ABuilder.ShowModal;
  if ABuilder.ModalResult >= 100 then
    Result := ABuilder.ModalResult - 100
  else // �û�ֱ�ӹر��˴��ڣ�û��ѡ���κΰ�ť
    Result := -1;
end;

function CustomInput(const ACaption, AHint, ADefVal: String; var AValue: String;
  ABeforeAddEditors, AfterAddEditors: TDialogNotifyCallback): Boolean;
var
  AItems: TInputItems;
begin
  SetLength(AItems, 1);
  AItems[0].Construct(itNormal, AHint, ADefVal, false);
  Result := CustomInput(ACaption, AItems, ABeforeAddEditors, AfterAddEditors);
  if Result then
    AValue := AItems[0].Value;
end;

function CustomInput(const ACaption: String;
  const AHints, ADefVals: TStringArray; var AValues: TStringArray;
  ABeforeAddEditors, AfterAddEditors: TDialogNotifyCallback): Boolean;
var
  AItems: TInputItems;
  I: Integer;
begin
  SetLength(AItems, Length(AHints));
  for I := 0 to High(AItems) do
  begin
    if I < Length(ADefVals) then
      AItems[I].Construct(itNormal, AHints[I], ADefVals[I], false)
    else
      AItems[I].Construct(itNormal, AHints[I], '', false);
  end;
  Result := CustomInput(ACaption, AItems, ABeforeAddEditors, AfterAddEditors);
  if Result then
  begin
    SetLength(AValues, Length(AHints));
    for I := 0 to High(AItems) do
      AValues[I] := AItems[I].Value;
  end;
end;

function CustomInput(const ACaption: String; AItems: TInputItems;
  ABeforeAddEditors, AfterAddEditors: TDialogNotifyCallback): Boolean;
var
  AHelper: IInputHelper;
begin
  AHelper := TInputHelper.Create(ACaption, AItems, ABeforeAddEditors,
    AfterAddEditors);
  Result := AHelper.ShowModal = mrOk;
end;
{ TDialogContainer }

function TDialogContainer.Add(const AItem: IBaseDialogItem): IDialogContainer;
begin
  AItem._AddRef;
  FItems.Add(AItem);
  AItem.Parent := Self;
  Result := Self;
  Builder.RequestAlign;
  Builder.GroupCast(Self, dneItemAdded);
end;

function TDialogContainer.AddContainer(AlignMode: TDialogItemAlignMode)
  : IDialogContainer;
var
  AItem: TDialogContainer;
begin
  AItem := TDialogContainer.Create(Builder);
  AItem.AlignMode := AlignMode;
  Add(AItem);
  Result := AItem;
end;

{$IFDEF UNICODE}

function TDialogContainer.AddControl(AClass: TControlClass;
  AOnClick: TNotifyCallback; APropText: String): IControlDialogItem;
var
  AEvent: TNotifyEvent;
begin
  AEvent := nil;
  if Assigned(AOnClick) then
  begin
    with TMethod(AEvent) do
    begin
      TNotifyCallback(Code) := AOnClick;
      Data := Pointer(-1);
    end;
    // �������������ĵ��ã�Delphi ����ջ��ΪBuilder�������Ӹ����ü�����������Ҫ����Ӧ�ļ���ȥ
    Builder.FixupRefCount(1);
  end;
  Result := AddControl(AClass, APropText);
  Result.OnClick := AEvent;
end;
{$ENDIF}

function TDialogContainer.AddControl(AClass: TControlClass;
  APropText: String = ''): IControlDialogItem;
var
  AItem: TControlDialogItem;
begin
  AItem := TControlDialogItem.Create(Builder, AClass);
  Add(AItem);
  AItem.PropText := APropText;
  Result := AItem;
end;

function TDialogContainer.CalcSize: TSize;
var
  AItemSize: TSize;
  I: Integer;
begin
  if AutoSize then
    Result := ItemSize
  else
  begin
    with Bounds do
      Result := TSize.Create(Right - Left, Bottom - Top);
  end;
end;

procedure TDialogContainer.Clear;
var
  I: Integer;
  AObj: IBaseDialogItem;
begin
  for I := 0 to FItems.Count - 1 do
  begin
    AObj := IBaseDialogItem(FItems[I]);
    AObj._Release;
  end;
  FItems.Clear;
  Builder.GroupCast(Self, dneItemChanged);
end;

constructor TDialogContainer.Create(ABuilder: IDialogBuilder;
  ACtrlClass: TControlClass);
begin
  inherited;
  FItems := TList.Create;
  FItemSpace := 3;
end;

constructor TDialogContainer.Create(ABuilder: IDialogBuilder);
begin
  Create(ABuilder, TPanel);
  with TPanel(Control) do
  begin
    BevelOuter := bvNone;
    BevelInner := bvNone;
  end;
end;

procedure TDialogContainer.Delete(const AIndex: Integer);
var
  AObj: TBaseDialogItem;
begin
  AObj := FItems[AIndex];
  FItems.Delete(AIndex);
  AObj._Release;
  Builder.GroupCast(Self, dneItemRemoved);
end;

destructor TDialogContainer.Destroy;
begin
  Clear;
  FreeAndNil(FItems);
  inherited;
end;

function TDialogContainer.GetAlignMode: TDialogItemAlignMode;
begin
  Result := FAlignMode;
end;

function TDialogContainer.GetAutoSize: Boolean;
begin
  Result := FAutoSize;
end;

function TDialogContainer.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TDialogContainer.GetItems(const AIndex: Integer): IBaseDialogItem;
begin
  Result := IBaseDialogItem(FItems[AIndex]);
end;

function TDialogContainer.GetItemSpace: Integer;
begin
  Result := FItemSpace;
end;

function TDialogContainer.ItemSize: TSize;
var
  I: Integer;
  AItemSize: TSize;
begin
  Result.cx := 0;
  Result.cy := 0;
  for I := 0 to FItems.Count - 1 do
  begin
    AItemSize := IBaseDialogItem(FItems[I]).CalcSize;
    case AlignMode of
      amVertTop, amVertCenter, amVertBottom: // ��ֱ����
        begin
          Inc(Result.cy, AItemSize.cy + ItemSpace);
          if Result.cx < AItemSize.cx then
            Result.cx := AItemSize.cx;
        end;
      amHorizLeft, amHorizCenter, amHorizRight:
        begin
          Inc(Result.cx, AItemSize.cx + ItemSpace);
          if Result.cy < AItemSize.cy then
            Result.cy := AItemSize.cy;
        end;
    end;
  end;
  if Control is TWinControl then
  begin
    with TWinControl(Control) do
    begin
      Inc(Result.cx, Padding.Left + Padding.Right);
      Inc(Result.cy, Padding.Top + Padding.Bottom);
    end;
  end;
  if Control.AlignWithMargins then
  begin
    Inc(Result.cx, Control.Margins.Left + Control.Margins.Right);
    Inc(Result.cy, Control.Margins.Top + Control.Margins.Bottom);
  end;
end;

procedure TDialogContainer.Realign;
var
  ASize, AItemSize: TSize;
  I: Integer;
  R: TRect;
  AItem: IBaseDialogItem;
  AContainer: IDialogContainer;
begin
  R := GetBounds;
  if AutoSize then
  begin
    ASize := ItemSize;
    if not Assigned(Parent) then
    begin
      R.Right := R.Left + ASize.cx;
      R.Bottom := R.Top + ASize.cy;
      SetBounds(R);
    end;
  end;
  OffsetRect(R, -R.Left, -R.Top);
  if Control is TWinControl then
  begin
    with TWinControl(Control) do
    begin
      R.Left := R.Left + Padding.Left;
      R.Top := R.Top + Padding.Top;
      R.Right := R.Right - Padding.Right;
      R.Bottom := R.Bottom - Padding.Bottom;
    end;
  end;
  case AlignMode of
    amVertCenter:
      R.Top := R.Top + (R.Bottom - R.Top - ItemSize.cy) shr 1;
    amVertBottom:
      R.Top := R.Bottom - ItemSize.cy;
    amHorizCenter:
      R.Left := R.Left + (R.Right - R.Left - ItemSize.cx) shr 1;
    amHorizRight:
      R.Left := R.Right - ItemSize.cx;
  end;
  for I := 0 to FItems.Count - 1 do
  begin
    AItem := IBaseDialogItem(FItems[I]);
    AItemSize := AItem.CalcSize;
    case AlignMode of
      amVertTop, amVertCenter, amVertBottom:
        begin
          AItem.SetBounds(Rect(R.Left, R.Top, R.Right, R.Top + AItemSize.cy));
          R.Top := R.Top + AItemSize.cy + ItemSpace;
        end;
      amHorizLeft, amHorizCenter, amHorizRight:
        begin
          AItem.SetBounds(Rect(R.Left, R.Top, R.Left + AItemSize.cx, R.Bottom));
          R.Left := R.Left + AItemSize.cx + ItemSpace;
        end;
    end;
    if Supports(AItem, IDialogContainer, AContainer) then
      AContainer.Realign;
  end;
end;

procedure TDialogContainer.SetAlignMode(AMode: TDialogItemAlignMode);
begin
  if FAlignMode <> AMode then
  begin
    FAlignMode := AMode;
    Builder.RequestAlign;
  end;
end;

procedure TDialogContainer.SetAutoSize(const AValue: Boolean);
begin
  if FAutoSize <> AValue then
  begin
    FAutoSize := AValue;
    Builder.RequestAlign;
  end;
end;

procedure TDialogContainer.SetItemSpace(const V: Integer);
begin
  if FItemSpace <> V then
  begin
    FItemSpace := V;
    Builder.RequestAlign;
  end;
end;

{ TBaseDialogItem }

function TBaseDialogItem.CalcSize: TSize;
begin
  Result.cx := 0;
  Result.cy := 0;
end;

constructor TBaseDialogItem.Create(ABuilder: IDialogBuilder);
begin
  inherited Create;
  Pointer(FBuilder) := Pointer(ABuilder);
end;

destructor TBaseDialogItem.Destroy;
begin
  if Length(GroupName) > 0 then
    Builder.ChangeGroup(Self, '');
  Pointer(FParent) := nil;
  if Assigned(FTags) then
    FreeAndNil(FTags);
  inherited;
end;

function TBaseDialogItem.GetBuilder: IDialogBuilder;
begin
  Result := FBuilder;
end;

function TBaseDialogItem.GetGroup: IDialogItemGroup;
begin
  if Length(FGroupName) > 0 then
    Result := Builder.GroupByName(FGroupName)
  else
    Result := nil;
end;

function TBaseDialogItem.GetGroupName: String;
begin
  Result := FGroupName;
end;

function TBaseDialogItem.GetHeight: Integer;
begin
  with Bounds do
    Result := Bottom - Top;
end;

function TBaseDialogItem.GetParent: IDialogContainer;
begin
  Result := FParent;
end;

function TBaseDialogItem.GetTags: TStrings;
begin
  if not Assigned(FTags) then
    FTags := TStringList.Create;
  Result := FTags;
end;

function TBaseDialogItem.GetWidth: Integer;
begin
  with Bounds do
    Result := Right - Left;
end;

procedure TBaseDialogItem.Notify(ASender: IBaseDialogItem;
  AEvent: TDialogNotifyEvent);
begin

end;

procedure TBaseDialogItem.SetGroupName(const Value: String);
begin
  Builder.ChangeGroup(Self, Value);
end;

procedure TBaseDialogItem.SetHeight(const AValue: Integer);
var
  R: TRect;
begin
  R := Bounds;
  R.Bottom := R.Top + AValue;
  Bounds := R;
end;

procedure TBaseDialogItem.SetParent(const Value: IDialogContainer);
begin
  Pointer(FParent) := Pointer(Value);
  Notify(Self, dneParentChanged);
end;

procedure TBaseDialogItem.SetWidth(const AValue: Integer);
var
  R: TRect;
begin
  R := Bounds;
  R.Right := R.Left + AValue;
  Bounds := R;
end;

{ TDialogBuilder }

procedure TDialogBuilder.AddToGroup(AItem: TBaseDialogItem);
var
  AGroup: TDialogGroup;
  AIdx: Integer;
begin
  if Length(AItem.GroupName) > 0 then
  begin
    AIdx := FGroups.IndexOf(AItem.GroupName);
    if AIdx <> -1 then
      AGroup := FGroups.Objects[AIdx] as TDialogGroup
    else
    begin
      AGroup := TDialogGroup.Create;
      AGroup._AddRef;
      FGroups.AddObject(AItem.GroupName, AGroup);
    end;
    if AGroup.IndexOf(AItem) = -1 then
      AGroup.Add(AItem);
  end;
end;
{$IFDEF UNICODE}

procedure TDialogBuilder.AfterPopup;
begin
  FStates := FStates - [dbsPopuping];
end;

procedure TDialogBuilder.ApplyRefCountFix;
begin
  AtomicDecrement(FRefCount, FRefCountFix);
  FRefCountFix := 0;
end;

procedure TDialogBuilder.BeforePopup;
begin
  if dbsPopuping in FStates then
    Exit;
  FStates := FStates + [dbsPopuping];
  if not(dbsPopup in FStates) then // ����Ա����ظ�����ʱ���ּ�������
  begin
    FStates := FStates + [dbsPopup];
    _AddRef;
  end;
  Dialog.BorderStyle := bsNone;
  if Dialog.BorderStyle <> bsNone then
    RequestAlign;
  IsAppVisible(True);
  Dialog.BorderStyle := bsNone;
  Dialog.Position := poDesigned;
  Dialog.ModalResult := mrNone;
  if dbsAlignRequest in FStates then
    Realign;
  Dialog.FormStyle := fsStayOnTop;
end;

{$ENDIF}

function TDialogBuilder.CalcControlPopupPos(AControl: TControl): TPoint;
var
  R: TRect;
  ASize: TSize;
  AMonitor: TMonitor;
begin
  ASize := ItemSize;
  if Assigned(AControl) then
  begin
    R := AControl.ClientRect;
    R.Offset(AControl.ClientOrigin);
    FLastActiveWnd := GetParentForm(AControl).Handle;
    AMonitor := Screen.MonitorFromRect(R);
  end
  else
  begin
    FLastActiveWnd := 0;
    AMonitor := PopupMonitor;
    R := AMonitor.WorkareaRect;
  end;
  // if ASize.cx >= AMonitor.WorkareaRect.Width then
  // ASize.cx := AMonitor.WorkareaRect.Width - 10;
  // if ASize.cy >= AMonitor.WorkareaRect.Height then
  // ASize.cy := AMonitor.WorkareaRect.Height - 10;
  case PopupPosition of
    dppDefault:
      begin
        if Assigned(AControl) then
        begin
          Result.X := R.Left;
          Result.Y := R.Top + R.Height;
          if Result.X + ASize.cx > AMonitor.BoundsRect.Right then
            Result.X := AMonitor.BoundsRect.Right - ASize.cx;
          if Result.Y + ASize.cy > AMonitor.BoundsRect.Bottom then
          begin
            if Result.Y - AControl.Height - ASize.cy > AMonitor.BoundsRect.Top
            then
              Result.Y := Result.Y - AControl.Height - ASize.cy
            else
              Result.Y := AMonitor.BoundsRect.Bottom - ASize.cy;
          end;
        end
        else
        begin
          Result.X := R.Left + (R.Width - ASize.cx) shr 1;
          Result.Y := R.Top + (R.Height - ASize.cy) shr 1;
        end;
      end;
    dppLeftTop:
      begin
        Result.X := R.Left;
        Result.Y := R.Top;
      end;
    dppCenterTop:
      begin
        Result.X := R.Left + (R.Width - ASize.cx) shr 1;
        Result.Y := R.Top;
      end;
    dppRightTop:
      begin
        Result.X := R.Left + R.Width - ASize.cy;
        Result.Y := R.Top;
      end;
    dppLeftCenter:
      begin
        Result.X := R.Left;
        Result.Y := R.Top + (R.Height - ASize.cy) shr 1;
      end;
    dppCenter:
      begin
        Result.X := R.Left + (R.Width - ASize.cx) shr 1;
        Result.Y := R.Top + (R.Height - ASize.cy) shr 1;
      end;
    dppRightCenter:
      begin
        Result.X := R.Left + R.Width - ASize.cx;
        Result.Y := R.Top + (R.Height - ASize.cy) shr 1;
      end;
    dppLeftBottom:
      begin
        Result.X := R.Left;
        Result.Y := R.Top + R.Height - ASize.cy;
      end;
    dppCenterBottom:
      begin
        Result.X := R.Left + (R.Width - ASize.cx) shr 1;
        Result.Y := R.Top + R.Height - ASize.cy;
      end;
    dppRightBottom:
      begin
        Result.X := R.Left + R.Width - ASize.cx;
        Result.Y := R.Top + R.Height - ASize.cy;
      end;
  end;
end;

procedure TDialogBuilder.ChangeGroup(AItem: IBaseDialogItem; ANewName: String);
var
  ATemp: TBaseDialogItem;
begin
  ATemp := AItem as TBaseDialogItem;
  if ATemp.GroupName <> ANewName then
  begin
    if Length(ATemp.GroupName) > 0 then
      RemoveFromGroup(ATemp);
    ATemp.FGroupName := ANewName;
    if Length(ANewName) > 0 then
      AddToGroup(ATemp);
  end;
end;

constructor TDialogBuilder.Create(const AClass: TFormClass);
begin
  inherited Create(Self, TScrollBox);
  FGroups := TStringList.Create;
  FDialog := AClass.Create(nil);
  FDialog.BorderStyle := bsDialog;
  FDialog.Position := poScreenCenter;
  FLastDialogWndProc := FDialog.WindowProc;
  FDialog.WindowProc := DoDialogWndProc;
  FDialog.OnClose := DoDialogClose;
  if AClass = TForm then
  begin
    FScrollBox := Control as TScrollBox;
    FScrollBox.Parent := FDialog;
    FScrollBox.Align := TAlign.alClient;
    FScrollBox.BorderStyle := bsNone;
    FScrollBox.BevelKind := bkNone;
    FScrollBox.VertScrollBar.Style := ssHotTrack;
  end;
  FStates := [dbsAlignRequest];
  FCanClose := True;
end;

constructor TDialogBuilder.Create(const ACaption: String);
begin
  Create(TForm);
  FDialog.Caption := ACaption;
end;

destructor TDialogBuilder.Destroy;
var
  I: Integer;
  AObj: TDialogGroup;
begin
  // if Assigned(FAppEvents) then
  // begin
  // FAppEvents.OnMessage := nil;
  // FreeAndNil(FAppEvents);
  // end;
  if Assigned(FPopupHelper) then
    FreeAndNil(FPopupHelper);
  Clear;
  for I := 0 to FGroups.Count - 1 do
  begin
    AObj := FGroups.Objects[I] as TDialogGroup;
    AObj._Release;
  end;
  FreeAndNil(FGroups);
  FreeAndNil(FDialog);
  inherited;
end;

procedure TDialogBuilder.DoClosePopup(ASender: TObject);
begin
  Dialog.Close;
  if not Dialog.Visible then
  begin
    FStates := FStates - [dbsPopup];
    TDialogAppEvents.Current.Remove(Self);
    DoResult;
    _Release;
  end;
end;

procedure TDialogBuilder.DoCloseTimer(ASender: TObject);
begin
  FTimer.Tag := FTimer.Tag + 1;
  if FTimer.Tag >= CloseDelay then
  begin
    FTimer.Enabled := false;
    CanClose := True;
    Dialog.Close;
  end
  else if DisplayRemainTime then
  begin
    Dialog.Caption := FInitializeCaption + '-' +
      RollupTime(CloseDelay - FTimer.Tag);
  end;
end;

procedure TDialogBuilder.DoDialogClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not CanClose then
  begin
    if ModalResult < 100 then
      Action := caNone;
  end;
  if (dbsPopup in FStates) and (Action <> caNone) then
    PostMessage(Dialog.Handle, WM_APP, 0, 0);
end;

procedure TDialogBuilder.DoDialogWndProc(var AMsg: TMessage);
  procedure DrawFrames;
  var
    R: TRect;
  begin
    // ������������ʱ������һ���߽磬�Ա�ͱ��������������Ч��
    R := Dialog.ClientRect;
    Frame3D(Dialog.Canvas, R, clBtnHighlight, clBtnShadow, 1);
  end;

begin
  if dbsPopup in FStates then
  begin
    if AMsg.Msg = WM_NCACTIVATE then
    begin
      if FLastActiveWnd <> 0 then
        SendMessage(FLastActiveWnd, WM_NCACTIVATE, 1, -1);
    end
    else if AMsg.Msg = WM_APP then
      DoClosePopup(Self);
  end;
  FLastDialogWndProc(AMsg);
  if dbsPopup in FStates then
  begin
    if AMsg.Msg = WM_PAINT then
      DrawFrames;
  end;
end;

procedure TDialogBuilder.DoPopupMessage(var Msg: tagMSG; var Handled: Boolean);
  procedure FollowControl;
  var
    pt: TPoint;
  begin
    if Application.Active then
    begin
      pt := CalcControlPopupPos(FPopupHelper.Control);
      if (pt.X <> Dialog.Left) or (pt.Y <> Dialog.Top) then
        Dialog.SetBounds(pt.X, pt.Y, Dialog.Width, Dialog.Height);
    end
    else
      DoClosePopup(Self);
  end;
  function IsDropDown: Boolean;
  begin
    if (Screen.ActiveControl is TComboBox) then
      Result := SendMessage(TComboBox(Screen.ActiveControl).Handle,
        CB_GETDROPPEDSTATE, 0, 0) <> 0
    else
      Result := false;
  end;

begin
  case Msg.message of
    WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_MBUTTONDOWN, WM_XBUTTONDOWN:
      begin
        if not PtInRect(Dialog.BoundsRect, Mouse.CursorPos) then
        begin
          if (dbsPopup in FStates) and (not IsDropDown) then
          begin
            DoClosePopup(Self);
            Exit;
          end;
        end;
      end;
  end;
  if Assigned(FPopupHelper) and (FPopupHelper.Control <> nil) then
    FollowControl;
  if (dbsPopup in FStates) and (Dialog.ModalResult <> mrNone) then
    DoClosePopup(Self);
end;

procedure TDialogBuilder.DoResult;
begin
  FLastActiveWnd := 0;
  if Assigned(FPopupHelper) then
    FPopupHelper.Control := nil;
  if Assigned(FOnResult) then
  begin
{$IFDEF UNICODE}
    with TMethod(FOnResult) do
    begin
      if Data = Pointer(-1) then
        TDialogResultCallback(Code)(Self)
      else
        FOnResult(Self);
    end;
{$ELSE}
    FOnResult(Self);
{$ENDIF}
  end;
  ApplyRefCountFix;
end;

procedure TDialogBuilder.FixupRefCount(ADelta: Integer);
begin
  // Inc(FRefCountFix, ADelta);
end;

function TDialogBuilder.GetBounds: TRect;
begin
  Result := FDialog.ClientRect;
end;

function TDialogBuilder.GetCanClose: Boolean;
begin
  Result := FCanClose;
end;

function TDialogBuilder.GetCloseDelay: Word;
begin
  Result := FCloseDelay;
end;

function TDialogBuilder.GetDialog: TForm;
begin
  Result := FDialog;
end;

function TDialogBuilder.GetDisplayRemainTime: Boolean;
begin
  Result := FDisplayRemainTime;
end;

function TDialogBuilder.GetGroups: TStrings;
begin
  Result := FGroups;
end;

function TDialogBuilder.GetModalResult: TModalResult;
begin
  Result := FDialog.ModalResult;
end;

function TDialogBuilder.GetOnResult: TDialogResultEvent;
begin
  Result := FOnResult;
end;

function TDialogBuilder.GetPopupMonitor: TMonitor;
begin
  Result := FPopupMonitor;
  if not Assigned(Result) then
    Result := Screen.PrimaryMonitor;
end;

function TDialogBuilder.GetPopupPosition: TQDialogPopupPosition;
begin
  Result := FPopupPosition;
end;

function TDialogBuilder.GroupByName(const AName: String): IDialogItemGroup;
var
  AIdx: Integer;
begin
  Result := nil;
  if Length(AName) > 0 then
  begin
    AIdx := FGroups.IndexOf(AName);
    if AIdx <> -1 then
      Result := FGroups.Objects[AIdx] as TDialogGroup;
  end;
end;

procedure TDialogBuilder.GroupCast(ASender: IBaseDialogItem;
  AEvent: TDialogNotifyEvent);
var
  AGroup: IDialogItemGroup;
  AIdx: Integer;
  AItem: IBaseDialogItem;
begin
  AGroup := GroupByName(ASender.GroupName);
  if Assigned(AGroup) then
  begin
    for AIdx := 0 to AGroup.Count - 1 do
    begin
      AItem := AGroup[AIdx];
      AItem.Notify(AItem, AEvent);
    end;
  end;
end;

function TDialogBuilder.IsAppVisible(ABringToFrontIfVisible: Boolean): Boolean;
var
  AppHandle: HWND;
  AForm: TForm;
  APos: TPoint;
begin
  Result := True;
  if Application.MainFormOnTaskBar and Assigned(Application.MainForm) then
    AppHandle := Application.MainForm.Handle
  else
    AppHandle := Application.Handle;
  if IsWindowVisible(AppHandle) then
  begin
    if IsIconic(AppHandle) then
    begin
      if ABringToFrontIfVisible then
        Application.Restore
      else
        Result := false;
    end;
  end
  else
    Result := false;
end;

procedure TDialogBuilder.Popup(APos: TPoint);
var
  R: TRect;
begin
  if dbsPopup in FStates then
    Exit;
  // �����ÿؼ���λ��
  BeforePopup;
  try
    Dialog.SetBounds(APos.X, APos.Y, Dialog.Width, Dialog.Height);
    {
      VCL ����û�����÷ǻ���ڵ���ʾ����������� Show/Visible�������õ�ǰ���ڱ�Ϊ
      ����ڣ�ԭ���Ĵ��ڻ�ʧȥ���㣬����Ҫ�������£�
      1������ SetWindowPos �Էǻ״̬��ʾ������
      2��ǿ���޸Ĵ��ڵ� Visible ����Ϊ True
      3������ CM_VISIBLECHANGED ��Ϣ����֪ͨ��ؿؼ�
      ͬʱ��Ϊ�˱������Ի����еĿؼ�ʱ��ԭ���Ĵ�����ʾΪʧȥ�����״̬��ҲҪ������
      ��Ϣ�����忴 DoDialogWndProc ���롣
      �����ĶԻ������û��������λ��ʱ��Ӧ�Զ���ʧ�����Ի�Ҫ��������Ϣ�������û���
      ���ǵ�ǰλ��ʱ�Զ���ʧ��
    }
    if FLastActiveWnd = 0 then
      FLastActiveWnd := GetActiveWindow;
    SetClassLong(Dialog.Handle, GCL_STYLE, GetClassLong(Dialog.Handle,
      GCL_STYLE) or CS_DROPSHADOW);
    FInitializeCaption := Dialog.Caption;
    SetWindowPos(Dialog.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE OR
      SWP_NOSIZE OR SWP_NOMOVE OR SWP_SHOWWINDOW);
    PBoolean(@Dialog.Visible)^ := True;
    Dialog.Perform(CM_VISIBLECHANGED, 0, 0);
    TDialogAppEvents.Current.Add(Self);
    if CloseDelay > 0 then
      FTimer.Enabled := True;
  finally
    AfterPopup;
  end;
end;

procedure TDialogBuilder.Popup(AControl: TControl);
var
  APos: TPoint;
begin
  if IsAppVisible(True) then
    APos := CalcControlPopupPos(AControl)
  else
    APos := CalcControlPopupPos(nil);
  if not Assigned(FPopupHelper) then
  begin
    FPopupHelper := TDialogPopupHelper.Create(nil);
    FPopupHelper.Builder := Self;
  end;
  FPopupHelper.Control := AControl;
  Popup(APos);
end;

procedure TDialogBuilder.Realign;
begin
  FStates := FStates + [dbsAligning] - [dbsAlignRequest];
  try
    inherited;
  finally
    FStates := FStates - [dbsAligning];
  end;
end;

procedure TDialogBuilder.RemoveFromGroup(AItem: TBaseDialogItem);
var
  AGroup: TDialogGroup;
  AIdx: Integer;
begin
  if Length(AItem.GroupName) > 0 then
  begin
    AIdx := FGroups.IndexOf(AItem.GroupName);
    if AIdx <> -1 then
    begin
      AGroup := FGroups.Objects[AIdx] as TDialogGroup;
      AGroup.Remove(AItem);
      if AGroup.Count = 0 then
      begin
        FGroups.Delete(AIdx);
        AGroup._Release;
      end;
    end;
  end;
end;

procedure TDialogBuilder.RequestAlign;
begin
  if not(dbsAligning in FStates) then
    FStates := FStates + [dbsAlignRequest];
end;

procedure TDialogBuilder.SetBounds(const R: TRect);
var
  ADelta, ASize: TSize;
  AWorkArea: TRect;
begin
  if Assigned(FScrollBox) then
  begin
    ASize.cx := R.Width;
    ASize.cy := R.Height;
    AWorkArea := FDialog.Monitor.WorkareaRect;
    if R.Width > FDialog.Monitor.WorkareaRect.Width then
    begin
      // ��Ҫˮƽ������
      FScrollBox.HorzScrollBar.Visible := True;
      ADelta.cy := FScrollBox.HorzScrollBar.Size;
      if ADelta.cy = 0 then
        ADelta.cy := GetSystemMetrics(SM_CXHSCROLL) + FDialog.Padding.Top +
          FDialog.Padding.Bottom
      else
        ADelta.cy := FDialog.Padding.Top + FDialog.Padding.Bottom;
    end
    else
    begin
      ADelta.cy := FDialog.Padding.Top + FDialog.Padding.Bottom;
      FScrollBox.HorzScrollBar.Visible := false;
    end;
    if R.Height > FDialog.Monitor.WorkareaRect.Height then
    begin
      // ��Ҫ��ֱ������
      FScrollBox.VertScrollBar.Visible := True;
      ADelta.cx := FScrollBox.VertScrollBar.Size;
      if ADelta.cx = 0 then
        ADelta.cx := GetSystemMetrics(SM_CYVSCROLL) + FDialog.Padding.Left +
          FDialog.Padding.Right
      else
        ADelta.cx := FDialog.Padding.Left + FDialog.Padding.Right;
    end
    else
    begin
      ADelta.cx := FDialog.Padding.Left + FDialog.Padding.Right;
      FScrollBox.VertScrollBar.Visible := false;
    end;
    if ASize.cx + ADelta.cx > AWorkArea.Width then
      FDialog.ClientWidth := AWorkArea.Width - FDialog.Padding.Left -
        FDialog.Padding.Right
    else
      FDialog.ClientWidth := R.Width + ADelta.cx;
    if ASize.cy + ADelta.cy > AWorkArea.Height then
      FDialog.ClientHeight := AWorkArea.Height - FDialog.Padding.Top -
        FDialog.Padding.Bottom
    else
      FDialog.ClientHeight := R.Height + ADelta.cy;
  end
  else
  begin
    FDialog.ClientWidth := R.Width;
    FDialog.ClientHeight := R.Height;
  end;
end;

procedure TDialogBuilder.SetCanClose(const AValue: Boolean);
begin
  if FCanClose <> AValue then
  begin
    FCanClose := AValue;
    if AValue then
      EnableMenuItem(GetSystemMenu(Dialog.Handle, false), SC_CLOSE,
        MF_BYCOMMAND)
    else
      EnableMenuItem(GetSystemMenu(Dialog.Handle, false), SC_CLOSE,
        MF_DISABLED or MF_GRAYED or MF_BYCOMMAND);
  end;
end;

procedure TDialogBuilder.SetModalResult(const AModalResult: TModalResult);
begin
  FDialog.ModalResult := AModalResult;
end;

procedure TDialogBuilder.SetOnResult(AEvent: TDialogResultEvent);
begin
{$IFDEF UNICODE}
  with TMethod(FOnResult) do
  begin
    if Data = Pointer(-1) then
    begin
      FixupRefCount(-1);
      TDialogResultCallback(Code) := nil;
      Data := nil;
    end;
  end;
{$ENDIF}
  FOnResult := AEvent;
end;

{$IFDEF UNICODE}

procedure TDialogBuilder.SetOnResultCallback(ACallback: TDialogResultCallback);
var
  AEvent: TDialogResultEvent;
begin
  AEvent := nil;
  if Assigned(ACallback) then
  begin
    with TMethod(AEvent) do
    begin
      Data := Pointer(-1);
      TDialogResultCallback(Code) := ACallback;
    end;
    FixupRefCount(1);
  end;
  SetOnResult(AEvent);
end;

procedure TDialogBuilder.SetPopupMonitor(const Value: TMonitor);
begin
  FPopupMonitor := Value;
end;

procedure TDialogBuilder.SetPopupPosition(const Value: TQDialogPopupPosition);
begin
  FPopupPosition := Value;
end;

procedure TDialogBuilder.SetCloseDelay(const Value: Word);
begin
  if FCloseDelay <> Value then
  begin
    FCloseDelay := Value;
    if Value > 0 then
      TimerNeeded;
  end;
end;

procedure TDialogBuilder.SetDisplayRemainTime(const AValue: Boolean);
begin
  FDisplayRemainTime := AValue;
end;

procedure TDialogBuilder.ShowModal(ACallback: TDialogResultCallback);
begin
  SetOnResultCallback(ACallback);
  ShowModal;
end;

procedure TDialogBuilder.TimerNeeded;
begin
  if not Assigned(FTimer) then
  begin
    FTimer := TTimer.Create(Dialog);
    FTimer.OnTimer := DoCloseTimer;
    FTimer.Enabled := Dialog.Visible;
  end;
  FTimer.Tag := 0; // ��������
end;

{$ENDIF}

procedure TDialogBuilder.ShowModal;
begin
  if FDialog.BorderStyle <> bsDialog then
  begin
    FDialog.BorderStyle := bsDialog;
    RequestAlign;
  end;
  FDialog.Position := poScreenCenter;
  if dbsAlignRequest in FStates then
    Realign;
  if CloseDelay > 0 then
    FTimer.Enabled := True;
  FInitializeCaption := Dialog.Caption;
  SetClassLong(Dialog.Handle, GCL_STYLE, GetClassLong(Dialog.Handle, GCL_STYLE)
    and (not CS_DROPSHADOW));
  FDialog.ShowModal;
  DoResult;
end;

procedure TDialogBuilder.Popup(APos: TPoint; ACallback: TDialogResultCallback);
begin
  SetOnResultCallback(ACallback);
  Popup(APos);
end;

procedure TDialogBuilder.Popup(AControl: TControl;
  ACallback: TDialogResultCallback);
begin
  SetOnResultCallback(ACallback);
  Popup(AControl);
end;

{ TControlDialogItem }

function TControlDialogItem.CalcSize: TSize;
begin
  Result.cx := FControl.Width;
  Result.cy := FControl.Height;
  if FControl.AlignWithMargins then
  begin
    Inc(Result.cx, FControl.Margins.Left + FControl.Margins.Right);
    Inc(Result.cy, FControl.Margins.Top + FControl.Margins.Bottom);
  end;
end;

constructor TControlDialogItem.Create(ABuilder: IDialogBuilder;
  ACtrlClass: TControlClass);
var
  AProp: PPropInfo;
  AEvent: TNotifyEvent;
begin
  inherited Create(ABuilder);
  FControl := ACtrlClass.Create(ABuilder.Dialog);
  AProp := GetPropInfo(FControl, 'OnClick');
  if Assigned(AProp) and (AProp.PropType^.Kind = tkMethod) then
  begin
    AEvent := DoClick;
    SetMethodProp(FControl, AProp, TMethod(AEvent));
  end;
end;

constructor TControlDialogItem.Create(ABuilder: IDialogBuilder);
begin
  inherited;
end;

destructor TControlDialogItem.Destroy;
begin
  if Assigned(FOnClick) then
  begin
    with TMethod(FOnClick) do
    begin
      if Data = Pointer(-1) then
      begin
        TNotifyCallback(Code) := nil;
        Data := nil;
      end;
    end;
  end;
  inherited;
end;

procedure TControlDialogItem.DoClick(Sender: TObject);
begin
  if Assigned(FOnClick) then
  begin
{$IFDEF UNICODE}
    with TMethod(FOnClick) do
    begin
      if Data = Pointer(-1) then
        TNotifyCallback(Code)(FControl)
      else
        FOnClick(FControl);
    end;
{$ELSE}
    FOnClick(FControl);
{$ENDIF}
  end;
end;

function TControlDialogItem.GetBounds: TRect;
begin
  Result := FControl.BoundsRect;
  // if FControl.ClassName = 'TEdit' then
  // begin
  // Notify(Self, dneItemChanged);
  // end;
  // if FControl.AlignWithMargins then
  // begin
  // Result.Left := Result.Left + FControl.Margins.Left;
  // Result.Top := Result.Top + FControl.Margins.Top;
  // Result.Right := Result.Right + FControl.Margins.Right;
  // Result.Bottom := Result.Bottom + FControl.Margins.Bottom;
  // end;
end;

function TControlDialogItem.GetControl: TControl;
begin
  Result := FControl;
end;

function TControlDialogItem.GetOnClick: TNotifyEvent;
begin
  Result := FOnClick;
end;

function TControlDialogItem.GetPropText: String;
begin
  Result := FPropText;
end;

procedure TControlDialogItem.Notify(ASender: IBaseDialogItem;
  AEvent: TDialogNotifyEvent);
var
  AContainer: TDialogContainer;
begin
  inherited;
  if AEvent = dneParentChanged then
  begin
    AContainer := Parent as TDialogContainer;
    if Assigned(AContainer) then
      FControl.Parent := AContainer.Control as TWinControl;
  end;
end;

procedure TControlDialogItem.SetBounds(const R: TRect);
begin
  if FControl.AlignWithMargins then
    FControl.BoundsRect := Rect(R.Left + FControl.Margins.Left,
      R.Top + FControl.Margins.Top, R.Right - FControl.Margins.Right,
      R.Bottom - FControl.Margins.Bottom)
  else
    FControl.BoundsRect := R;
end;

procedure TControlDialogItem.SetOnClick(const Value: TNotifyEvent);
begin
{$IFDEF UNICODE}
  with TMethod(FOnClick) do
  begin
    if Data = Pointer(-1) then
    begin
      TNotifyCallback(Code) := nil;
      Data := nil;
    end;
  end;
{$ENDIF}
  FOnClick := Value;
end;

procedure TControlDialogItem.SetPropText(const AValue: String);
var
  AProps: TQJson;
begin
  if FPropText <> AValue then
  begin
    FPropText := AValue;
    AProps := TQJson.Create;
    try
      if AProps.TryParse(AValue) then
      begin
        AProps.ToRtti(FControl);
      end;
    finally
      FreeAndNil(AProps);
    end;
  end;
end;

{ TDialogGroup }

function TDialogGroup.GetItems(const AIndex: Integer): IBaseDialogItem;
begin
  Result := IBaseDialogItem(Items[AIndex]);
end;

{ TDialogPopupHelper }

destructor TDialogPopupHelper.Destroy;
begin
  Builder := nil;
  if Assigned(Control) then
    Control.RemoveFreeNotification(Self);
  inherited;
end;

procedure TDialogPopupHelper.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
  begin
    if AComponent = FControl then
    begin
      FControl := nil;
      Builder.Dialog.Close;
    end;
  end;
end;

procedure TDialogPopupHelper.SetBuilder(const Value: IDialogBuilder);
begin
  Pointer(FBuilder) := Pointer(Value);
end;

procedure TDialogPopupHelper.SetControl(const Value: TControl);
begin
  if Assigned(FControl) then
    FControl.RemoveFreeNotification(Self);
  FControl := Value;
  if Value <> nil then
    Value.FreeNotification(Self);
end;

{ TInputItem }

procedure TInputItem.Construct(AType: TInputType; AHint, ADefVal: String;
  AUseTextHint: Boolean);
begin
  &Type := AType;
  Hint := AHint;
  DefVal := ADefVal;
  Value := '';
  UseTextHint := AUseTextHint;
  AllowEmpty := false;
end;

class function TInputItem.Create(AType: TInputType; AHint, ADefVal: String;
  AUseTextHint: Boolean): TInputItem;
begin
  Result.Construct(AType, AHint, ADefVal, AUseTextHint);
end;

{ TInputHelper }

constructor TInputHelper.Create(ACaption: String; AItems: TInputItems;
  ABeforeAddEditors: TDialogNotifyCallback;
  AfterAddEditors: TDialogNotifyCallback);
var
  I: Integer;
begin
  FItems := AItems;
  FBuilder := NewDialog(ACaption);
  FBuilder.ItemSpace := 5;
  FBuilder.AutoSize := True;
  with FBuilder.Dialog.Padding do
  begin
    Left := 10;
    Top := 10;
    Right := 10;
    Bottom := 10;
  end;
  SetLength(FEditors, Length(AItems));
  if Assigned(ABeforeAddEditors) then
    ABeforeAddEditors(FBuilder);
  for I := 0 to High(AItems) do
  begin
    with TLabel(FBuilder.AddControl(TLabel).Control) do
    begin
      Layout := tlCenter;
      AlignWithMargins := True;
      Caption := AItems[I].Hint;
    end;
    FEditors[I] := TEdit(FBuilder.AddControl(TEdit).Control);
    with FEditors[I] do
    begin
      Tag := I;
      Width := 200;
      AlignWithMargins := True;
      Text := FItems[I].DefVal;
      OnKeyDown := DoEditKeyDown;
    end
  end;
  with TBevel(FBuilder.AddControl(TBevel).Control) do
  begin
    Height := 2;
    Shape := bsTopLine;
  end;
  with FBuilder.AddContainer(amHorizRight) do
  begin
    AutoSize := True;
    FOkButton := TButton(AddControl(TButton).Control);
    with FOkButton do
    begin
      Caption := 'ȷ��';
      Default := True;
      Width := 75;
      OnClick := DoOkClick;
    end;
    with TButton(AddControl(TButton).Control) do
    begin
      Caption := 'ȡ��';
      ModalResult := mrCancel;
    end;
  end;
  if Assigned(AfterAddEditors) then
    AfterAddEditors(FBuilder);
end;

procedure TInputHelper.DoEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  AEdit: TEdit;
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    AEdit := TEdit(Sender);
    if AEdit.Tag = High(FItems) then
      FOkButton.Click
    else
      FEditors[AEdit.Tag + 1].SetFocus;
  end;
end;

procedure TInputHelper.DoOkClick(Sender: TObject);
var
  I: Integer;
  IVal: Int64;
  FVal: Double;
  procedure DoError(AMsg: String);
  var
    ADialog: IDialogBuilder;
  begin
    ADialog := NewDialog;
    ADialog.AutoSize := True;
    ADialog.PopupPosition := TQDialogPopupPosition.dppCenter;
    with TLabel(ADialog.AddControl(TLabel).Control) do
    begin
      AlignWithMargins := True;
      Caption := AMsg;
      Font.Color := clRed;
      Color := clWhite;
      Transparent := false;
    end;
    ADialog.CloseDelay := 5;
    ADialog.Popup(Sender as TControl);
  end;

  function IsFileName(const S: QStringW): Boolean;
  var
    p, ps: PQCharW;
  begin
    Result := True;
    p := PQCharW(S);
    if StartWithW(p, 'file://', True) then
      Inc(p, 7);
    ps := p;
    while p^ <> #0 do
    begin
      if (p^ = ':') and (ps - p > 1) then
      begin
        Result := false;
        Exit;
      end
      else if not CharInW(p, '/\*"><') then
      begin
        Result := false;
        Break;
      end;
    end;
  end;

begin
  for I := 0 to High(FItems) do
  begin
    FItems[I].Value := Trim(FEditors[I].Text);
    if (Length(FItems[I].Value) = 0) and (not FItems[I].AllowEmpty) then
    begin
      DoError('����Ŀֵ����Ϊ��');
      Exit;
    end;
    case FItems[I].&Type of
      itPhone:
        if not IsChinesePhone(FItems[I].Value) then
        begin
          DoError(FItems[I].Value + ' ������Ч�ĵ绰���롣');
          Exit;
        end;
      itMobile:
        if not IsChineseMobile(FItems[I].Value, True) then
        begin
          DoError(FItems[I].Value + ' ������Ч���ֻ�����');
          Exit;
        end;
      itEMail:
        begin
          if not IsEmailAddr(FItems[I].Value) then
          begin
            DoError(FItems[I].Value + ' ������Ч�ĵ��������ַ');
            Exit;
          end;
        end;
      itUrl:
        begin
          if StrStrW(PQCharW(FItems[I].Value), '://') = nil then
          begin
            DoError(FItems[I].Value + ' ������Ч�ĵ��������ַ');
            Exit;
          end;
        end;
      itFile:
        begin
          if not IsFileName(FItems[I].Value) then
          begin
            DoError(FItems[I].Value + ' ������Ч���ļ���');
            Exit;
          end;
        end;
      itNumeric:
        begin
          FItems[I].Value := CnFullToHalf(FItems[I].Value);
          if not TryStrToFloat(FItems[I].Value, FVal) then
          begin
            DoError(FItems[I].Value + ' ������Ч�ĸ�����');
            Exit;
          end;
        end;
      itInteger:
        begin
          FItems[I].Value := CnFullToHalf(FItems[I].Value);
          if not TryStrToInt64(FItems[I].Value, IVal) then
          begin
            DoError(FItems[I].Value + ' ������Ч������ֵ');
            Exit;
          end;
        end;
    end;
  end;
  FBuilder.ModalResult := mrOk;
end;

function TInputHelper.ShowModal: TModalResult;
begin
  FBuilder.ShowModal;
  Result := FBuilder.ModalResult;
end;

{ TDialogAppEvents }

procedure TDialogAppEvents.Add(ADialog: TDialogBuilder);
var
  ALink: PDialogLink;
begin
  New(ALink);
  ALink.Dialog := ADialog;
  ALink.Next := nil;
  if Assigned(FLastDialog) then
    FLastDialog.Next := ALink
  else
    FFirstDialog := ALink;
  FLastDialog := ALink;
end;

constructor TDialogAppEvents.Create;
begin
  inherited;
  FAppEvents := TApplicationEvents.Create(Application);
  FAppEvents.OnMessage := DoAppMessage;
end;

destructor TDialogAppEvents.Destroy;
var
  ALink: PDialogLink;
begin
  while Assigned(FFirstDialog) do
  begin
    ALink := FFirstDialog.Next;
    Dispose(FFirstDialog);
    FFirstDialog := ALink;
  end;
  FLastDialog := nil;
  inherited;
end;

procedure TDialogAppEvents.DoAppMessage(var Msg: tagMSG; var Handled: Boolean);
var
  ALink, ANext: PDialogLink;
begin
  ALink := FFirstDialog;
  while Assigned(ALink) do
  begin
    ANext := ALink.Next;
    try
      ALink.Dialog.DoPopupMessage(Msg, Handled);
    except

    end;
    ALink := ANext;
  end;
end;

class function TDialogAppEvents.GetCurrent: TDialogAppEvents;
begin
  if not Assigned(FCurrent) then
    FCurrent := TDialogAppEvents.Create;
  Result := FCurrent;
end;

procedure TDialogAppEvents.Remove(ADialog: TDialogBuilder);
var
  ALink, APrior: PDialogLink;
begin
  APrior := nil;
  ALink := FFirstDialog;
  while Assigned(ALink) do
  begin
    if ALink.Dialog = ADialog then
    begin
      if Assigned(APrior) then
        APrior.Next := ALink.Next
      else
      begin
        FFirstDialog := ALink.Next;
        if not Assigned(FFirstDialog) then
          FLastDialog := nil;
      end;
      Break;
    end;
    ALink := ALink.Next;
  end;
end;

end.

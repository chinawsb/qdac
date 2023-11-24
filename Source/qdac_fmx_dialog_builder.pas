unit qdac_fmx_dialog_builder;

interface

{ QDialogBuilder for FMX
  这个单元的接口与 VCL 版一致，具体示例参考VCL版，另外，由
}
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Generics.Collections, System.Variants, System.Messaging, FMX.Platform,
  FMX.Objects, FMX.StdCtrls, FMX.Types, FMX.Controls, FMX.Forms, FMX.Layouts,
  FMX.Edit, FMX.Graphics, FMX.Dialogs;

const
  CDF_ALWAYS_CLOSABLE = $80000000; // 是否总是允许显示关闭按钮
  CDF_TIMEOUT = $40000000; // 倒计时关闭
  CDF_DISPLAY_REMAIN_TIME = $20000000; // 是否在标题栏显示倒计时
  CDF_MASK_TIMEOUT = $FFFF; //

type
  IBaseDialogItem = interface;
  IDialogBuilder = interface;
  IDialogContainer = interface;
  // 对话框通知事件，分别对应子项添加、子项删除、父项变更、项目变更
  TDialogNotifyEvent = (dneItemAdded, dneItemRemoved, dneParentChanged,
    dneItemChanged);
  // 子项对齐方式：按行居上，按行居中，按行居下，按列居左，按列居中，按列居右
  TDialogItemAlignMode = (amVertTop, amVertCenter, amVertBottom, amHorizLeft,
    amHorizCenter, amHorizRight);
  TNotifyCallback = reference to procedure(Sender: TObject);
  TControlClass = class of TFmxObject;

  // 项目分组列表接口，只支持枚举，添加和移除是通过设置对应的 GroupName 自动完成的
  IDialogItemGroup = interface
    ['{299F037F-2EDB-4677-A950-A05B9CCE3137}']
    // 项目数量
    function GetCount: Integer;
    // 获取单项
    function GetItems(const AIndex: Integer): IBaseDialogItem;
    property Count: Integer read GetCount;
    property Items[const AIndex: Integer]: IBaseDialogItem
      read GetItems; default;
  end;

  INamedExt = interface
    ['{78787785-3DE5-43FA-BDDE-9F9A39607546}']
    function GetName: String;
    property Name: String read GetName;
  end;

  IExtendable = interface
    ['{984368F3-B4D4-4D20-96E4-7E8C4DCA7133}']
    function ExtByType(const IID: TGUID; var AValue): Boolean; overload;
    function ExtByType(const AClass: TClass): TObject; overload;
    function ExtByType(const AClass: TClass; var AValue): Boolean; overload;
    function ExtByName(const AName: String): INamedExt;
    function GetExts: TList<IInterface>;
    function HasExts: Boolean;
    property Exts: TList<IInterface> read GetExts;
  end;

  // 基本项目定义
  IBaseDialogItem = interface(IExtendable)
    ['{3C247227-5BF6-4DE8-BB4D-A4A574FE929B}']
    // 项目位置信息
    function GetBounds: TRect;
    procedure SetBounds(const R: TRect);
    // 计算项目大小
    function CalcSize: TSize;
    // 分组名读写
    function GetGroupName: String;
    procedure SetGroupName(const Value: String);
    // 父项目容器
    function GetParent: IDialogContainer;
    procedure SetParent(const Value: IDialogContainer);
    // 接受通知处理
    procedure Notify(ASender: IBaseDialogItem; AEvent: TDialogNotifyEvent);
    // 关联的 IDialogBuilder 对象
    function GetBuilder: IDialogBuilder;
    // 关联的分组
    function GetGroup: IDialogItemGroup;
    // 尺寸信息
    function GetWidth: Integer;
    procedure SetWidth(const AValue: Integer);
    function GetHeight: Integer;
    function GetMargins: TRectF;
    procedure SetMargins(const AValue: TRectF);
    function GetPaddings: TRectF;
    procedure SetPaddings(const AValue: TRectF);
    procedure SetHeight(const AValue: Integer);
    property Bounds: TRect read GetBounds write SetBounds;
    property GroupName: String read GetGroupName write SetGroupName;
    property Parent: IDialogContainer read GetParent write SetParent;
    property Builder: IDialogBuilder read GetBuilder;
    property Group: IDialogItemGroup read GetGroup;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
    property Margins: TRectF read GetMargins write SetMargins;
    property Paddings: TRectF read GetPaddings write SetPaddings;
  end;

  // 关联控件的对话框项目，通过容器的 AddControl 添加
  IControlDialogItem = interface(IBaseDialogItem)
    ['{44E207B3-080C-4A45-BFE0-286D9B8222D5}']
    // 关联控件
    function GetControl: TFmxObject;
    // OnClick 事件响应 ，其它事件响应请直接设置Control的相关事件
    function GetOnClick: TNotifyEvent;
    procedure SetOnClick(const AValue: TNotifyEvent);
    // 基于JSON的属性定义
    function GetPropText: String;
    procedure SetPropText(const AValue: String);
    property PropText: String read GetPropText write SetPropText;
    property Control: TFmxObject read GetControl;
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

  // 关联控件容器接口
  IDialogContainer = interface(IControlDialogItem)
    ['{91EBE933-1AA0-45E0-8C1D-7B57578FA2B8}']
    // 添加项目
    function Add(const AItem: IBaseDialogItem): IDialogContainer;
    // 添加一下控件项目，注意有些控件并不能自动调整合适的大小，需要赋值
    function AddControl(AClass: TControlClass; APropText: String = '')
      : IControlDialogItem; overload;
    function AddLabel(AText: String): IControlDialogItem;
    function AddEdit(APrompt, AText: String): IControlDialogItem;
    function AddButton(AText: String; AModalResult: Integer)
      : IControlDialogItem;
{$IFDEF UNICODE}
    function AddControl(AClass: TControlClass; AOnClick: TNotifyCallback;
      APropText: String = ''): IControlDialogItem; overload;
{$ENDIF}
    // 添加一个子容器
    function AddContainer(AlignMode: TDialogItemAlignMode): IDialogContainer;
    // 删除某一子项
    procedure Delete(const AIndex: Integer);
    // 清空所有子项
    procedure Clear;
    // 获取子项
    function GetItems(const AIndex: Integer): IBaseDialogItem;
    // 获取子项数
    function GetCount: Integer;
    // 对齐方式
    function GetAlignMode: TDialogItemAlignMode;
    procedure SetAlignMode(AMode: TDialogItemAlignMode);
    // 重新对齐
    procedure Realign;
    // 自动调整大小
    function GetAutoSize: Boolean;
    procedure SetAutoSize(const AValue: Boolean);
    // 子项间隔大小
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
  // 对话框关闭时的通知事件
{$IFDEF UNICODE}

  TDialogResultCallback = reference to procedure(ABuilder: IDialogBuilder);
{$ENDIF}
  TDialogResultEvent = procedure(ABuilder: IDialogBuilder) of object;

  // 对话框构建工具
  IDialogBuilder = interface(IDialogContainer)
    ['{3E33A340-A664-4110-B257-061F2B8B4E3C}']
    // ModalResult
    function GetModalResult: TModalResult;
    procedure SetModalResult(const AModalResult: TModalResult);
    // 变更分组为新名称
    procedure ChangeGroup(AItem: IBaseDialogItem; ANewName: String);
    // 组内广播事件
    procedure GroupCast(ASender: IBaseDialogItem; AEvent: TDialogNotifyEvent);
    // 获取指定名称分组
    function GroupByName(const AName: String): IDialogItemGroup;
    // 显示模态对话框
    procedure ShowModal(); overload;
    // 在指定的控件位置弹出，会优先采用下拉的方式，避开控件本身的区域
    procedure Popup(AControl: TControl); overload;
    // 在指定的位置弹出
    procedure Popup(APos: TPoint); overload;
    // 显示前需要重新对齐
    procedure RequestAlign;
    // 关联的窗体对象
    function GetDialog: TCommonCustomForm;
    // 关闭通知事件
    function GetOnResult: TDialogResultEvent;
    procedure SetOnResult(AEvent: TDialogResultEvent);
{$IFDEF UNICODE}
    procedure Popup(AControl: TControl;
      ACallback: TDialogResultCallback); overload;
    procedure Popup(APos: TPoint; ACallback: TDialogResultCallback); overload;
    procedure ShowModal(ACallback: TDialogResultCallback); overload;
{$ENDIF}
    // Dialog的PropText定义，注意 Position 属性无效，在 ShowModal 里，始终是poScreenCenter
    function GetPropText: String;
    procedure SetPropText(const AValue: String);
    function GetCanClose: Boolean;
    procedure SetCanClose(const AValue: Boolean);
    function GetCloseDelay: Word;
    procedure SetCloseDelay(const ASeconds: Word);
    function GetDisplayRemainTime: Boolean;
    procedure SetDisplayRemainTime(const AValue: Boolean);
    property PropText: String read GetPropText write SetPropText;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property OnResult: TDialogResultEvent read GetOnResult write SetOnResult;
    property Dialog: TCommonCustomForm read GetDialog;
    property CanClose: Boolean read GetCanClose write SetCanClose;
    property CloseDelay: Word read GetCloseDelay write SetCloseDelay;
    property DisplayRemainTime: Boolean read GetDisplayRemainTime
      write SetDisplayRemainTime;
  end;

  TDialogIcon = (diNone, diWarning, diHelp, diError, diInformation, diShield);
  // 新建一个对话框接口，如果不指定标题，则为Application.Title
function NewDialog(ACaption: String = ''): IDialogBuilder;
function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIcon: TDialogIcon; AFlags: Integer = 0;
  const ACustomProps: String = ''): Integer; overload;
function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIconResId: Integer; AIconResFile: String;
  AIconSize: TSize; AFlags: Integer = 0; const ACustomProps: String = '')
  : Integer; overload;

implementation

uses qstring, qjson, typinfo, qdac_postqueue{$IFDEF MSWINDOWS},
  winapi.Windows, Vcl.Graphics, Vcl.Imaging.pngImage{$ENDIF};

type
  TDialogGroup = class(TInterfaceList, IDialogItemGroup)
    function GetItems(const AIndex: Integer): IBaseDialogItem;
  end;

  TBaseDialogItem = class(TInterfacedObject, IBaseDialogItem)
  protected
    FParent: IDialogContainer;
    FGroupName: String;
    FBuilder: IDialogBuilder;
    FExts: TList<IInterface>;
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
    function GetMargins: TRectF; virtual;
    procedure SetMargins(const AValue: TRectF); virtual;
    function GetPaddings: TRectF; virtual;
    procedure SetPaddings(const AValue: TRectF); virtual;
    function ExtByType(const IID: TGUID; var AValue): Boolean; overload;
    function ExtByType(const AClass: TClass): TObject; overload;
    function ExtByType(const AClass: TClass; var AValue): Boolean; overload;
    function ExtByName(const AName: String): INamedExt;
    function GetExts: TList<IInterface>;
    function HasExts: Boolean;
  public
    constructor Create(ABuilder: IDialogBuilder); virtual;
    destructor Destroy; override;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    property Parent: IDialogContainer read FParent write SetParent;
    property Bounds: TRect read GetBounds write SetBounds;
    property GroupName: String read FGroupName write SetGroupName;
    property Builder: IDialogBuilder read FBuilder;

  end;

  TControlDialogItem = class(TBaseDialogItem, IControlDialogItem)
  protected
    FControl: TFmxObject;
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
    function GetControl: TFmxObject;
    procedure DoClick(Sender: TObject);
    function GetOnClick: TNotifyEvent;
    function GetPropText: String;
    procedure SetPropText(const AValue: String);
    function GetMargins: TRectF; override;
    procedure SetMargins(const AValue: TRectF); override;
    function GetPaddings: TRectF; override;
    procedure SetPaddings(const AValue: TRectF); override;
  public
    constructor Create(ABuilder: IDialogBuilder); overload; override;
    destructor Destroy; override;
    property Control: TFmxObject read FControl write FControl;
    property PropText: String read FPropText write SetPropText;
    property OnClick: TNotifyEvent read FOnClick write SetOnClick;
    property Margins: TRectF read GetMargins write SetMargins;
    property Paddings: TRectF read GetPaddings write SetPaddings;
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
    function AddLabel(AText: String): IControlDialogItem;
    function AddEdit(APrompt, AText: String): IControlDialogItem;
    function AddButton(AText: String; AModalResult: Integer)
      : IControlDialogItem;
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

  TDialogBuilderState = (dbsAlignRequest, dbsAligning, dbsPopup, dbsModal);
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

  TDialogBuilder = class(TDialogContainer, IDialogBuilder)
  protected
    FDialog: TCommonCustomForm;
    FGroups: TStringList;
    FTimer: TTimer;
    FOnResult: TDialogResultEvent;
    FStates: TDialogBuilderStates;
    FLastDialogWndProc: TWndMethod;
    FPopupHelper: TDialogPopupHelper;
    FLastActiveWnd: THandle;
    FCloseDelay: Word;
    FCanClose: Boolean;
    FDisplayRemainTime: Boolean;
    FInitializeCaption: String;
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
    function GetDialog: TCommonCustomForm;
    procedure DoClosePopup(ASender: TObject);
    procedure DoResult;
    // procedure DoPopupMessage(var Msg: tagMSG; var Handled: Boolean);
    // procedure DoDialogWndProc(var AMsg: TMessage);
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
{$IFDEF UNICODE}
    procedure SetOnResultCallback(ACallback: TDialogResultCallback);
{$ENDIF}
  public
    constructor Create(const ACaption: String); overload;
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
    property Dialog: TCommonCustomForm read FDialog;
    property Groups: TStrings read GetGroups;
    property ModalResult: TModalResult read GetModalResult write SetModalResult;
    property OnResult: TDialogResultEvent read FOnResult write SetOnResult;
    property CanClose: Boolean read FCanClose write SetCanClose;
    property CloseDelay: Word read FCloseDelay write SetCloseDelay;
    property DisplayRemainTime: Boolean read FDisplayRemainTime
      write FDisplayRemainTime;
  end;

  TFakeControl = class(TControl)

  end;

function NewDialog(ACaption: String = ''): IDialogBuilder;
begin
  if Length(ACaption) = 0 then
    Result := TDialogBuilder.Create(Application.Title)
  else
    Result := TDialogBuilder.Create(ACaption);
end;

function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIcon: TDialogIcon; AFlags: Integer = 0;
  const ACustomProps: String = ''): Integer; overload;
var
  AIconSize: TSize;
const
  IconResId: array [TDialogIcon] of Integer = (0, 101, 102, 103, 104, 106);
begin
  AIconSize.cx := 32;
  AIconSize.cy := 32;
  Result := CustomDialog(ACaption, ATitle, AMessage, AButtons, IconResId[AIcon],
    'user32.dll', AIconSize, AFlags, ACustomProps);
end;

function CustomDialog(const ACaption, ATitle, AMessage: String;
  AButtons: array of String; AIconResId: Integer; AIconResFile: String;
  AIconSize: TSize; AFlags: Integer = 0; const ACustomProps: String = '')
  : Integer; overload;
var
  //
  ABuilder: IDialogBuilder;
  I: Integer;
  AIconImage: TImage;
  R: TRectF;
  procedure DumpDFM;
  var
    AStream: TMemoryStream;
    AString: TStringStream;
  begin
    AStream := TMemoryStream.Create;
    AStream.WriteComponent(ABuilder.Dialog);
    AStream.Position := 0;
    AString := TStringStream.Create('', TEncoding.UTF8);
    ObjectBinaryToText(AStream, AString);
    AString.SaveToFile('c:\test.txt');
    ShowMessage(AString.DataString);
    FreeAndNil(AString);
    FreeAndNil(AStream);
  end;
  procedure LoadIcon;
  var
    AIcon: TIcon;
    APng: TPngImage;
    AStream: TMemoryStream;
  begin
    { 这个函数只是临时这么写，正确的做法是直接做格式转换，不过Icon文件小，这样先凑合吧 }
    AIcon := TIcon.Create;
    APng := TPngImage.CreateBlank(COLOR_RGB, 8, AIconSize.cx, AIconSize.cy);
    AStream := TMemoryStream.Create;
    try
      AIcon.SetSize(AIconSize.cx, AIconSize.cy);
      AIcon.Handle := LoadImage(GetModuleHandle(PChar(AIconResFile)),
        MAKEINTRESOURCE(AIconResId), IMAGE_ICON, AIconSize.cx, AIconSize.cy, 0);
      AIcon.Transparent := True;
      APng.Canvas.Brush.Color := clNone;
      APng.Canvas.FillRect(Rect(0, 0, AIconSize.cx, AIconSize.cy));
      APng.Canvas.Draw(0, 0, AIcon);
      APng.SaveToStream(AStream);
      AStream.Position := 0;
      AIconImage.Bitmap.LoadFromStream(AStream);
    finally
      FreeAndNil(AIcon);
      FreeAndNil(APng);
      FreeAndNil(AStream);
    end;
  end;

begin
  ABuilder := NewDialog(ACaption);
  ABuilder.ItemSpace := 10;
  ABuilder.AutoSize := True;
  AIconImage := nil;
  // 首行，可能是标题，图标+标题，图标+消息，消息
  with ABuilder.AddContainer(amVertTop) do
  begin
    AutoSize := True;
    with TRectangle(Control) do
    begin
      Fill.Color := TAlphaColors.White;
      Fill.Kind := TBrushKind.Solid;
      Stroke.Kind := TBrushKind.None;
    end;
    with AddContainer(amVertTop) do
    begin
      AutoSize := True;
      Paddings := RectF(ABuilder.ItemSpace, 0, ABuilder.ItemSpace, 0);
      with AddContainer(amHorizLeft) do
      begin
        AutoSize := True;
        if (Length(AIconResFile) > 0) and (AIconResId > 0) then
        begin
          AIconImage := TImage(AddControl(TImage).Control);
          with AIconImage do
          begin
            Size.Size := TSizeF.Create(AIconSize.cx + 3, AIconSize.cy + 3);
            Margins.Rect := Rect(3, 3, 3, 3);
          end;
{$IFDEF MSWINDOWS}
          LoadIcon;
{$ENDIF}
        end;
        if Length(ATitle) > 0 then
        begin
          with TLabel(AddControl(TLabel).Control) do
          begin
            // 低版本的 Delphi 需要调用函数来获取当前操作系统版本
{$IFDEF MSWINDOWS}
            if TOSVersion.Major > 5 then
              TextSettings.Font.Family := 'Microsoft YaHei'
            else
              TextSettings.Font.Family := 'SimHei';
            TextSettings.Font.Size := TextSettings.Font.Size + 4;
{$ENDIF}
            AutoSize := True;
            TextSettings.VertAlign := TTextAlign.Center;
            Text := ATitle;
          end;
        end
        else if Length(AMessage) > 0 then
        begin
          Margins := RectF(3, 3, 3, 3);
          with TLabel(AddControl(TLabel).Control) do
          begin
            AutoSize := True;
            TextSettings.VertAlign := TTextAlign.Center;
            Text := AMessage;
          end;
        end;;
      end;
      if (Length(ATitle) > 0) and (Length(AMessage) > 0) then
      begin
        with TLabel(AddControl(TLabel).Control) do
        begin
          AutoSize := True;
          if Assigned(AIconImage) then
          begin
            Margins.Rect := RectF(AIconImage.Position.X + ABuilder.ItemSpace +
              AIconImage.Width, 3, AIconImage.Position.X + ABuilder.ItemSpace +
              AIconImage.Width, 3);
          end
          else
            Margins.Rect := RectF(ABuilder.ItemSpace, 3, ABuilder.ItemSpace, 3);
          Text := AMessage;
        end;
      end;
    end;
  end;
  if Length(AButtons) > 0 then
  begin
    with ABuilder.AddContainer(amHorizRight) do
    begin
      // Control.Name := 'ButtonContainer';
      Height := 32;
      Paddings := RectF(3, 3, 3, 3);
      Width := 85 * Length(AButtons);
      with TRectangle(Control) do
      begin
        Fill.Color := $FFF0F0F0;
        Fill.Kind := TBrushKind.Solid;
        Stroke.Kind := TBrushKind.None;
        Padding.Right := ABuilder.ItemSpace div 2;
      end;
      for I := 0 to High(AButtons) do
      begin
        with TButton(AddControl(TButton).Control) do
        begin
          // Margins.Rect := Rect(3, 3, 3, 3);
          Text := AButtons[I];
          ModalResult := 100 + I;
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
  R := TRectF.Create(Screen.WorkAreaRect.TopLeft, Screen.WorkAreaRect.Width,
    Screen.WorkAreaRect.Height);
  ABuilder.Dialog.SetBounds(Round(R.Left + (R.Width - ABuilder.Dialog.Width) /
    2), Round(R.Top + (R.Height - ABuilder.Dialog.Height) / 2),
    ABuilder.Dialog.Width, ABuilder.Dialog.Height);
  ABuilder.ShowModal;
  DumpDFM;
  if ABuilder.ModalResult >= 100 then
    Result := ABuilder.ModalResult - 100
  else // 用户直接关闭了窗口，没有选择任何按钮
    Result := -1;
end;

{ TDialogGroup }

function TDialogGroup.GetItems(const AIndex: Integer): IBaseDialogItem;
begin
  Result := IBaseDialogItem(Items[AIndex]);
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
  if Assigned(FExts) then
    FreeAndNil(FExts);
  inherited;
end;

function TBaseDialogItem.ExtByName(const AName: String): INamedExt;
var
  I: Integer;
  AExt: INamedExt;
begin
  Result := nil;
  if Assigned(FExts) then
  begin
    for I := 0 to FExts.Count - 1 do
    begin
      if Supports(FExts[I], INamedExt, AExt) and (AExt.Name = AName) then
      begin
        Result := AExt;
        Exit;
      end;
    end;
  end;
end;

function TBaseDialogItem.ExtByType(const IID: TGUID; var AValue): Boolean;
var
  I: Integer;
begin
  Result := false;
  Pointer(AValue) := nil;
  if Assigned(FExts) then
  begin
    for I := 0 to FExts.Count - 1 do
    begin
      Result := Supports(FExts[I], IID, AValue);
      if Result then
        Exit;
    end;
  end;
end;

function TBaseDialogItem.ExtByType(const AClass: TClass): TObject;
var
  I: Integer;
  AExt: IInterface;
begin
  Result := nil;
  if Assigned(FExts) then
  begin
    for I := 0 to FExts.Count - 1 do
    begin
      AExt := FExts[I];
      if AExt is AClass then
      begin
        Result := AExt as AClass;
        Exit;
      end;
    end;
  end;
end;

function TBaseDialogItem.ExtByType(const AClass: TClass; var AValue): Boolean;
begin
  TObject(AValue) := ExtByType(AClass);
  Result := TObject(AValue) <> nil;
end;

function TBaseDialogItem.GetBuilder: IDialogBuilder;
begin
  Result := FBuilder;
end;

function TBaseDialogItem.GetExts: TList<IInterface>;
begin
  if not Assigned(FExts) then
    FExts := TList<IInterface>.Create;
  Result := FExts;
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

function TBaseDialogItem.GetMargins: TRectF;
begin
  Result := TRectF.Empty;
end;

function TBaseDialogItem.GetPaddings: TRectF;
begin
  Result := TRectF.Empty;
end;

function TBaseDialogItem.GetParent: IDialogContainer;
begin
  Result := FParent;
end;

function TBaseDialogItem.GetWidth: Integer;
begin
  with Bounds do
    Result := Right - Left;
end;

function TBaseDialogItem.HasExts: Boolean;
begin
  Result := Assigned(FExts) and (FExts.Count > 0);
end;

procedure TBaseDialogItem.Notify(ASender: IBaseDialogItem;
  AEvent: TDialogNotifyEvent);
begin

end;

function TBaseDialogItem.QueryInterface(const IID: TGUID; out Obj): HResult;
var
  I: Integer;
begin
  Result := inherited;
  if (Result = E_NOINTERFACE) and Assigned(FExts) then
  begin
    for I := 0 to FExts.Count - 1 do
    begin
      Result := FExts[I].QueryInterface(IID, Obj);
      if Result = S_OK then
        Break;
    end;
  end;
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

procedure TBaseDialogItem.SetMargins(const AValue: TRectF);
begin
  // Do nothing
end;

procedure TBaseDialogItem.SetPaddings(const AValue: TRectF);
begin
  // Do nothing
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

function TDialogBuilder.CalcControlPopupPos(AControl: TControl): TPoint;
var
  ASize: TSize;
  ACtrl: IControl;
  Align: IAlignableObject;
  AMonitorRect: TRectF;
  function GetMonitorRect: TRectF;
  var
    ASvc: IFMXMultiDisplayService;
  begin
    if TPlatformServices.Current.SupportsPlatformService
      (IFMXMultiDisplayService, ASvc) then
    begin
      Result := ASvc.DisplayFromWindow((AControl.Root as TCommonCustomForm)
        .Handle).BoundsRect;
    end
    else
      AMonitorRect := Screen.WorkAreaRect;
  end;

begin
  if Supports(AControl, IControl, ACtrl) then
  begin
    Result := ACtrl.LocalToScreen(Point(0, Trunc(AControl.Height))).Truncate;
    ASize := ItemSize;
    AMonitorRect := GetMonitorRect;
    if Result.X + ASize.cx > AMonitorRect.Right then
      Result.X := Trunc(AMonitorRect.Right - ASize.cx);
    if Result.Y + ASize.cy > AMonitorRect.Bottom then
    begin
      if Result.Y - Align.Height - ASize.cy > AMonitorRect.Top then
        Result.Y := Trunc(Result.Y - AControl.Height - ASize.cy)
      else
        Result.Y := Trunc(AMonitorRect.Bottom - ASize.cy);
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

constructor TDialogBuilder.Create(const ACaption: String);
begin
  inherited Create(Self, nil);
  FControl := TForm.CreateNew(nil, 0);
  FGroups := TStringList.Create;
  FDialog := TCommonCustomForm(Control);
  FDialog.BorderStyle := TFmxFormBorderStyle.ToolWindow;
  FDialog.Position := TFormPosition.ScreenCenter;
  FDialog.Caption := ACaption;
  FDialog.OnClose := DoDialogClose;
  FStates := [dbsAlignRequest];
  FCanClose := True;
end;

destructor TDialogBuilder.Destroy;
var
  I: Integer;
  AObj: TDialogGroup;
begin
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
  FStates := FStates - [dbsPopup];
  Dialog.Close;
  DoResult;
  // 减少弹出时增加的引用计数
  _Release;
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
    if Length(FInitializeCaption) = 0 then
      FInitializeCaption := Dialog.Caption;
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
      Action := TCloseAction.caNone;
  end;
  if (dbsPopup in FStates) and (Action <> TCloseAction.caNone) then
    AsynCall(
      procedure(AParams: IInterface)
      begin
        DoClosePopup(Self);
      end, nil);
end;

procedure TDialogBuilder.DoResult;
begin
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
end;

function TDialogBuilder.GetBounds: TRect;
begin
  Result := FDialog.ClientRect.Truncate;
  OffsetRect(Result, FDialog.Left, FDialog.Top);
  // FMX Bug fix
  Result.Width := Result.Width + 10;
end;

function TDialogBuilder.GetCanClose: Boolean;
begin
  Result := FCanClose;
end;

function TDialogBuilder.GetCloseDelay: Word;
begin
  Result := FCloseDelay;
end;

function TDialogBuilder.GetDialog: TCommonCustomForm;
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

procedure TDialogBuilder.Popup(APos: TPoint; ACallback: TDialogResultCallback);
begin
  SetOnResultCallback(ACallback);
  Popup(APos);
end;

procedure TDialogBuilder.Popup(APos: TPoint);
begin
  // 调整好控件的位置
  if not(dbsPopup in FStates) then // 检测以避免重复调用时出现计数问题
  begin
    FStates := FStates + [dbsPopup];
    _AddRef;
  end;
  if Dialog.BorderStyle <> TFmxFormBorderStyle.None then
    RequestAlign;
  Dialog.BorderStyle := TFmxFormBorderStyle.None;
  Dialog.Position := TFormPosition.Designed;
  if dbsAlignRequest in FStates then
    Realign;
  Dialog.SetBounds(APos.X, APos.Y, Dialog.Width, Dialog.Height);
  Dialog.FormStyle := TFormStyle.StayOnTop;
  Dialog.Show;
end;

procedure TDialogBuilder.Popup(AControl: TControl);
begin
  if not Assigned(FPopupHelper) then
  begin
    FPopupHelper := TDialogPopupHelper.Create(nil);
    FPopupHelper.Builder := Self;
  end;
  FPopupHelper.Control := AControl;
  Popup(CalcControlPopupPos(AControl));
end;

procedure TDialogBuilder.Popup(AControl: TControl;
ACallback: TDialogResultCallback);
begin
  SetOnResultCallback(ACallback);
  Popup(AControl);
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
  ASvc: IFMXWindowService;
  CR: TRectF;
const
  MinWidth: Integer = 200;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXWindowService, ASvc)
  then
  begin
    CR := R;
    if CR.Width < MinWidth then
      CR.Width := MinWidth;
    // 已知FMX Bug，toolWindows时宽度差10
    CR.Width := CR.Width - 10;
    ASvc.SetClientSize(FDialog, PointF(CR.Width, CR.Height));
    CR.Left := Screen.WorkAreaLeft +
      (Screen.WorkAreaWidth - FDialog.Width) / 2;
    CR.Width := FDialog.Width;
    CR.Top := Screen.WorkAreaTop +
      (Screen.WorkAreaHeight - FDialog.Height) / 2;
    CR.Height := FDialog.Height;
    FDialog.SetBoundsF(CR.Left, CR.Top, CR.Width, CR.Height);
  end;
end;

procedure TDialogBuilder.SetCanClose(const AValue: Boolean);
begin
  if FCanClose <> AValue then
  begin
    FCanClose := AValue;
    // if AValue then
    // EnableMenuItem(GetSystemMenu(Dialog.Handle, false), SC_CLOSE,
    // MF_BYCOMMAND)
    // else
    // EnableMenuItem(GetSystemMenu(Dialog.Handle, false), SC_CLOSE,
    // MF_DISABLED or MF_GRAYED or MF_BYCOMMAND);
  end;
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
      TDialogResultCallback(Code) := nil;
      Data := nil;
    end;
  end;
{$ENDIF}
  FOnResult := AEvent;
end;

procedure TDialogBuilder.SetOnResultCallback(ACallback: TDialogResultCallback);
var
  AEvent: TDialogResultEvent;
begin
  AEvent := nil;
  with TMethod(AEvent) do
  begin
    Data := Pointer(-1);
    TDialogResultCallback(Code) := ACallback;
  end;
  SetOnResult(AEvent);
end;

procedure TDialogBuilder.ShowModal(ACallback: TDialogResultCallback);
begin
  SetOnResultCallback(ACallback);
  ShowModal;
end;

procedure TDialogBuilder.ShowModal;
begin
  if FDialog.BorderStyle <> TFmxFormBorderStyle.ToolWindow then
  begin
    FDialog.BorderStyle := TFmxFormBorderStyle.ToolWindow;
    RequestAlign;
  end;
  FDialog.Position := TFormPosition.ScreenCenter;
  if dbsAlignRequest in FStates then
    Realign;
  if CloseDelay > 0 then
    FTimer.Enabled := True;
  ShowMessage(IntToStr(FDialog.ClientWidth));
  FDialog.ShowModal(
    procedure(AModalResult: TModalResult)
    begin
      DoResult;
    end);
end;

procedure TDialogBuilder.TimerNeeded;
begin
  if not Assigned(FTimer) then
  begin
    FTimer := TTimer.Create(Dialog);
    FTimer.OnTimer := DoCloseTimer;
    FTimer.Enabled := Dialog.Visible;
  end;
  FTimer.Tag := 0; // 计数清零
end;

{ TControlDialogItem }

function TControlDialogItem.CalcSize: TSize;
begin
  if FControl is TControl then
  begin
    with TFakeControl(FControl) do
    begin
      Result := Size.Size.Truncate;
      Inc(Result.cx, Trunc(Margins.Left + Margins.Right));
      Inc(Result.cy, Trunc(Margins.Top + Margins.Top));
    end;
  end
  else if FControl is TCommonCustomForm then
  begin
    with TCommonCustomForm(FControl) do
      Result := TSize.Create(Width, Height);
  end;
end;

constructor TControlDialogItem.Create(ABuilder: IDialogBuilder;
ACtrlClass: TControlClass);
var
  AProp: PPropInfo;
  AEvent: TNotifyEvent;
begin
  inherited Create(ABuilder);
  if Assigned(ACtrlClass) then
  begin
    FControl := ACtrlClass.Create(ABuilder.Dialog);
    AProp := GetPropInfo(FControl, 'OnClick');
    if Assigned(AProp) and (AProp.PropType^.Kind = tkMethod) then
    begin
      AEvent := DoClick;
      SetMethodProp(FControl, AProp, TMethod(AEvent));
    end;
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
        TNotifyCallback(Code)(Self)
      else
        FOnClick(Self);
    end;
{$ELSE}
    FOnClick(Self);
{$ENDIF}
  end;
end;

function TControlDialogItem.GetBounds: TRect;
begin
  if FControl is TControl then
  begin
    with TControl(FControl) do
    begin
      Result.Left := Trunc(BoundsRect.Left - Margins.Left);
      Result.Top := Trunc(BoundsRect.Top - Margins.Top);
      Result.Right := Trunc(BoundsRect.Right + Margins.Right);
      Result.Bottom := Trunc(BoundsRect.Bottom + Margins.Bottom);
    end;
  end;
end;

function TControlDialogItem.GetControl: TFmxObject;
begin
  Result := FControl;
end;

function TControlDialogItem.GetMargins: TRectF;
begin
  if FControl is TControl then
    Result := TControl(FControl).Margins.Rect
  else
    Result := inherited;
end;

function TControlDialogItem.GetOnClick: TNotifyEvent;
begin
  Result := FOnClick;
end;

function TControlDialogItem.GetPaddings: TRectF;
begin
  if FControl is TControl then
    Result := TControl(FControl).Padding.Rect
  else if FControl is TCommonCustomForm then
    Result := TCommonCustomForm(FControl).Padding.Rect
  else
    Result := inherited;
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
      FControl.Parent := AContainer.Control;
  end;
end;

procedure TControlDialogItem.SetBounds(const R: TRect);
begin
  // DebugOut('%s.Bounds %d,%d-%d,%d', [Control.Name, R.Left, R.Top, R.Right,
  // R.Bottom]);
  if FControl is TControl then
  begin
    with TControl(FControl) do
      BoundsRect := RectF(R.Left + Margins.Left, R.Top + Margins.Top,
        R.Right - Margins.Right, R.Bottom - Margins.Bottom)
  end;
end;

procedure TControlDialogItem.SetMargins(const AValue: TRectF);
begin
  if FControl is TControl then
    TControl(FControl).Margins.Rect := AValue
  else
    inherited;
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

procedure TControlDialogItem.SetPaddings(const AValue: TRectF);
begin
  if FControl is TControl then
    TControl(FControl).Padding.Rect := AValue
  else if FControl is TCommonCustomForm then
    TCommonCustomForm(FControl).Padding.Rect := AValue
  else
    inherited;
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

function TDialogContainer.AddButton(AText: String; AModalResult: Integer)
  : IControlDialogItem;
begin
  Result := AddControl(TButton);
  with TButton(Result.Control) do
  begin
    ModalResult := AModalResult;
    Text := AText;
  end;
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

function TDialogContainer.AddControl(AClass: TControlClass;
AOnClick: TNotifyCallback; APropText: String): IControlDialogItem;
var
  AEvent: TNotifyEvent;
begin
  AEvent := nil;
  with TMethod(AEvent) do
  begin
    TNotifyCallback(Code) := AOnClick;
    Data := Pointer(-1);
  end;
  Result := AddControl(AClass, APropText);
  Result.OnClick := AEvent;
end;

function TDialogContainer.AddEdit(APrompt, AText: String): IControlDialogItem;
begin
  Result := AddControl(TEdit);
  with TEdit(Result.Control) do
  begin
    TextPrompt := APrompt;
    Text := AText;
  end;
end;

function TDialogContainer.AddLabel(AText: String): IControlDialogItem;
begin
  Result := AddControl(TEdit);
  with TLabel(Result.Control) do
    Text := AText;
end;

function TDialogContainer.AddControl(AClass: TControlClass; APropText: String)
  : IControlDialogItem;
var
  AItem: TControlDialogItem;
begin
  AItem := TControlDialogItem.Create(Builder, AClass);
  Add(AItem);
  AItem.PropText := APropText;
  Result := AItem;
end;

function TDialogContainer.CalcSize: TSize;
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

constructor TDialogContainer.Create(ABuilder: IDialogBuilder);
begin
  Create(ABuilder, TRectangle);
  with TRectangle(Control) do
  begin
    Fill.Color := $FFF0F0F0;
    Fill.Kind := TBrushKind.None;
    Stroke.Kind := TBrushKind.None;
  end;
end;

constructor TDialogContainer.Create(ABuilder: IDialogBuilder;
ACtrlClass: TControlClass);
begin
  inherited;
  FItems := TList.Create;
  FItemSpace := 3;
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
  Result.cx := Trunc(Margins.Left + Margins.Right);
  Result.cy := Trunc(Margins.Top + Margins.Bottom);
  for I := 0 to FItems.Count - 1 do
  begin
    AItemSize := IBaseDialogItem(FItems[I]).CalcSize;
    case AlignMode of
      amVertTop, amVertCenter, amVertBottom: // 垂直布局
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
  case AlignMode of
    amHorizLeft, amHorizCenter, amHorizRight:
      begin
        if Result.cx > ItemSpace then
          Dec(Result.cx, ItemSpace);
      end;
    amVertTop, amVertCenter, amVertBottom:
      begin
        if Result.cy > ItemSpace then
          Dec(Result.cy, ItemSpace);
      end;
  end;
  Inc(Result.cx, Trunc(Paddings.Left + Paddings.Right));
  Inc(Result.cy, Trunc(Paddings.Top + Paddings.Bottom));
end;

procedure TDialogContainer.Realign;
var
  ASize, AItemSize: TSize;
  I: Integer;
  R: TRectF;
  AItem: IBaseDialogItem;
  AContainer: IDialogContainer;
begin
  R := GetBounds;
  ASize := ItemSize;
  if AutoSize then
  begin
    if not Assigned(Parent) then
    begin
      R.Right := R.Left + ASize.cx;
      R.Bottom := R.Top + ASize.cy;
      SetBounds(R.Truncate);
      R := GetBounds;
    end;
  end;
  // DebugOut('%s.Bounds %f,%f-%f,%f', [Control.Name, R.Left, R.Top, R.Right,
  // R.Bottom]);
  R.Offset(-R.Left + Paddings.Left, -R.Top + Paddings.Top);
  case AlignMode of
    amVertCenter:
      R.Top := R.Top + (R.Bottom - R.Top - ASize.cy) / 2;
    amVertBottom:
      R.Top := R.Bottom - ASize.cy;
    amHorizCenter:
      R.Left := R.Left + (R.Right - R.Left - ASize.cx) / 2;
    amHorizRight:
      R.Left := R.Right - ASize.cx;
  end;

  for I := 0 to FItems.Count - 1 do
  begin
    AItem := IBaseDialogItem(FItems[I]);
    AItemSize := AItem.CalcSize;
    case AlignMode of
      amVertTop, amVertCenter, amVertBottom:
        begin
          AItem.SetBounds(RectF(R.Left, R.Top, R.Right, R.Top + AItemSize.cy)
            .Truncate);
          R.Top := R.Top + AItemSize.cy + ItemSpace;
        end;
      amHorizLeft, amHorizCenter, amHorizRight:
        begin
          AItem.SetBounds(RectF(R.Left, R.Top, R.Left + AItemSize.cx, R.Bottom)
            .Truncate);
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

end.

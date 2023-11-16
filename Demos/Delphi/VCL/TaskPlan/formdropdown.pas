unit formdropdown;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, ToolWin;
(*
(C)2013,swish,����ʡ��ۼ�����������޹�˾
����Ԫ����ʵ���������ڵ�Ч�����û�����̳�TfrmDropDownBase���ڣ�Ȼ�����DropDownForm
�����Ϳ�����ָ���Ŀؼ�λ�����������ڣ�����λ�û��Զ����ʵ�������
2014.7.30
==========
  * �������л��������������л�����ʱ������Application.Activeֵ��ΪFalse����޷�����
������ʾ������
2013.6.19
==========
  + ����HIDE_WHEN_IDEѡ��Ծ����ڵ���ģʽʱ���Ƿ񲻹رմ���
  + ����HIDE_WHEN_DRAGѡ��Ծ������϶����������ǣ��Ƿ�����ƶ�
  * ��������ģ̬��������ʾ����
  * ��������ӦWM_NCLBUTTONUP�¼�ʱ�����ָ���Ƿ�Ϊ�յ���
  * ���������Ǽ���Թ����ؼ���FreeNotificationע����Ƴ�������
  * ������AWaitΪTrueʱ��������������ڲ���ʱ�����������ڿ�����ɷ�����Ч��ַ������
*)
{.$DEFINE HIDE_WHEN_IDE}
{.$DEFINE HIDE_WHEN_DRAG}
type

  TDropDownFormClass=class of TfrmDropDownBase;

  TfrmDropDownBase = class(TForm)
  private
    FDropDownParam: Integer;
    FFreeAfterClosed: Boolean;
    procedure SetLinkedControl(const Value: TControl);
    { Private declarations }
  protected
    FHookedForm:TForm;
    FLinkedControl:TControl;
    FOriginWndProc:TWndMethod;
    FCtrlOriginWndProc:TWndMethod;
    FNCPainting:Boolean;
    FInWait:Boolean;
    FActiveCheckNeeded:Boolean;
    procedure HookedWndProc(var AMsg:TMessage);virtual;
    procedure CtrlWndProc(var AMsg:TMessage);virtual;
    procedure AdjustPosition;virtual;
    procedure AddHook;
    procedure RemoveHook;
    procedure WndProc(var AMsg:TMessage);override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoClose(var Action: TCloseAction);override;
    procedure DoDestroy;override;
    procedure DoShow;override;
    procedure CheckActive;
    procedure Notification(AComponent: TComponent;Operation: TOperation);override;
  public
    { Public declarations }
    procedure DropDown(ACtrl:TControl;AWait:Boolean;AParam:Integer);
    property LinkedControl:TControl read FLinkedControl write SetLinkedControl;//�����Ŀؼ�
    property DropDownParam:Integer read FDropDownParam write FDropDownParam;//�û����ø��ӵĶ��������������δ������ദ��
    property InWait:Boolean read FInWait;
    property FreeAfterClosed:Boolean read FFreeAfterClosed write FFreeAfterClosed;
  end;

var
  FormInDropDown:TfrmDropDownBase;//ȫ�ֵĵ�ǰ�������������
{
��ָ���Ŀؼ�λ����ʾ��������
Parameters
  AFormClass : �����Ĵ�������
  ACtrl : ���������ڵ�λ��
  AWait : �Ƿ�ȴ��������ڹر�
  AParam : �û��Զ���Ĳ���
  AfterCreate : �ڴ��ڴ�����ɺ󴥷����¼����Է����û����ö���Ŀ���
Remarks
  1.�����Ĵ�����AFormClassָ��������ʵ��������Ĭ������£������ڹر�ʱ���Զ��ͷţ�
���Ҫ���Զ��ͷţ���Ӧ����OnClose�¼����á�
  2.���ָ��AWaitΪFalse����Ӧ��֤�������������ڲ��ᵯ���������ڣ���������Զ��رգ�
����һ���Ƽ�����ΪTrue
}
procedure DropDownForm(AFormClass:TDropDownFormClass;ACtrl:TControl;AWait:Boolean;AParam:Integer;AfterCreate:TNotifyEvent=nil);overload;
procedure DropDownForm(AForm:TfrmDropDownBase;ACtrl:TControl;AWait:Boolean;AParam:Integer;AFreeAfterClosed:Boolean);overload;
implementation
function IsDebuggerPresent:Boolean;stdcall;external kernel32;
{$R *.dfm}
function IsAppActive:Boolean;
  var
    AWnd:HWND;
    APId:Cardinal;
  begin
  AWnd:=GetForegroundWindow;
  if AWnd<>0 then
    begin
    GetWindowThreadProcessId(AWnd,APId);
    Result:=(APId=GetCurrentProcessId);
    end
  else
    Result:=False;
  end;
{ TfrmDropDownBase }
{������Ϣ�ҹ�}
procedure TfrmDropDownBase.AddHook;
begin
FHookedForm:=GetParentForm(FLinkedControl,True) as TForm;
if Assigned(FHookedForm) then
  begin
  FOriginWndProc:=FHookedForm.WindowProc;
  FHookedForm.WindowProc:=HookedWndProc;
  if FHookedForm.FormStyle=fsStayOnTop then
    FormStyle:=fsStayOnTop;
  FHookedForm.FreeNotification(Self);
  end;
FCtrlOriginWndProc:=FLinkedControl.WindowProc;
FLinkedControl.WindowProc:=CtrlWndProc;
FLinkedControl.FreeNotification(Self);
end;
{�����������λ��}
procedure TfrmDropDownBase.AdjustPosition;
var
  APos:TPoint;
begin
if Assigned(LinkedControl) then
  begin
  APos:=LinkedControl.ClientOrigin;
  if APos.X<FHookedForm.Monitor.Left then
    APos.X:=FHookedForm.Monitor.Left;
  if APos.Y<FHookedForm.Monitor.Top then
    APos.Y:=FHookedForm.Monitor.Top;
  if APos.X+Width>FHookedForm.Monitor.Width then
    APos.X:=FHookedForm.Monitor.Width-Width;
  if APos.Y+LinkedControl.Height+Height>FHookedForm.Monitor.Height then
    begin
    if APos.Y-Height>0 then
      Dec(APos.Y,Height)
    else
      APos.Y:=FHookedForm.Monitor.Height-Height;
    end
  else
    Inc(APos.Y,LinkedControl.Height);
  SetWindowPos(Handle,0,APos.X,APos.Y,0,0,SWP_NOZORDER + SWP_NOACTIVATE+SWP_NOSIZE);
  end;
end;
{����CreateParams����֤����WS_BORDER����}
procedure TfrmDropDownBase.CheckActive;
begin
if InWait then
  FActiveCheckNeeded:=True
else
  Close;
end;

procedure TfrmDropDownBase.CreateParams(var Params: TCreateParams);
begin
  inherited;
//BugFix : AlphaControls֧�ֵĴ���Ҫ�������WS_BORDER���ԣ���Ĭ�ϵ�bsNoneû�У�ǿ�Ƽ���  
Params.Style:=(Params.Style or WS_BORDER) and (not WS_DLGFRAME);
end;
procedure TfrmDropDownBase.CtrlWndProc(var AMsg: TMessage);
begin
FCtrlOriginWndProc(AMsg);
if AMsg.Msg=CM_EXIT then
  CheckActive;
end;

{���عرղ���}
procedure TfrmDropDownBase.DoClose(var Action: TCloseAction);
begin
if (not FInWait) and FreeAfterClosed then
  Action:=caFree
else
  Action:=caHide;
RemoveHook;
if FormInDropDown=Self then
  FormInDropDown:=nil;
inherited DoClose(Action);
end;
{�����ͷŲ���,��Ӧ��ֱ��Free����û�е���Close�����}
procedure TfrmDropDownBase.DoDestroy;
begin
RemoveHook;
if FormInDropDown=Self then
  FormInDropDown:=nil;
inherited;
end;
{������ʾ����������������ʾǰ������ʾλ��}
procedure TfrmDropDownBase.DoShow;
begin
inherited;
AdjustPosition;
end;
procedure TfrmDropDownBase.DropDown(ACtrl: TControl; AWait: Boolean;
  AParam: Integer);
begin
DropDownForm(Self,ACtrl,AWait,AParam,FreeAfterClosed);
end;

{��ҵ���Ϣ�������}
procedure TfrmDropDownBase.HookedWndProc(var AMsg: TMessage);
var
  AMethod:TWndMethod;
begin
AMethod:=HookedWndProc;
if AMsg.Msg=WM_NCPAINT then
  begin
  if not FNCPainting then
    begin
    FNCPainting:=True;
    FHookedForm.Perform(WM_NCACTIVATE,1,-1);//ǿ�ƽ������״̬��Ϊ����,Ȼ���ٽ���ԭ���Ĺ��̻���
    FOriginWndProc(AMsg);
    FNCPainting:=False;
    end;
  end
else if (AMsg.Msg=WM_MOVE) or (AMsg.Msg=WM_SIZE) then  //������λ���ƶ����߳ߴ緢�����ʱ�����µ���λ��
  begin
  //δ����LinkedControl�ߴ���ʱ������������Ҫ���ٹҹ��ؼ��Ĺ��̼���
  FOriginWndProc(AMsg);
  {$IFNDEF HIDE_WHEN_DRAG}
  PostMessage(Handle,WM_MOVE,1,0);
  {$ENDIF}
  end
else if (AMsg.Msg>=WM_MOUSEFIRST) and (AMsg.Msg<=WM_MOUSELAST) then//�����������Ϣ
  begin
  if (AMsg.Msg=WM_LBUTTONDOWN) or (AMsg.Msg=WM_RBUTTONDOWN) or (AMsg.Msg=WM_MBUTTONDOWN) then
    CheckActive;
  FOriginWndProc(AMsg);
  end
else if AMsg.Msg=WM_NCLBUTTONDOWN then//����ڱ���������ʱ�����ô���ʼ����ǰ�����ⱻ����
  begin
  FormStyle:=fsStayOnTop;
  FOriginWndProc(AMsg);
  {$IFDEF HIDE_WHEN_DRAG}
  SetBounds(-32767,-32767,Width,Height);
  {$ENDIF}
  end
else if AMsg.Msg=WM_NCLBUTTONUP then
  begin
  FOriginWndProc(AMsg);
  if Assigned(FHookedForm) then
    FormStyle:=FHookedForm.FormStyle
  else if FormStyle=fsStayOnTop then
    FormStyle:=fsNormal;
  end
else if AMsg.Msg=WM_WINDOWPOSCHANGED then//�϶����ʱ���ָ�ԭʼ״̬
  begin
  FOriginWndProc(AMsg);
  {$IFDEF HIDE_WHEN_DRAG}
  CheckActive;
  {$ELSE}
  if (PWindowPos(AMsg.LParam).flags and SWP_NOMOVE)=0 then
    begin
    FormStyle:=FHookedForm.FormStyle;
    BringToFront;
    end;
  {$ENDIF}
  end
else if AMsg.Msg=WM_SYSCOMMAND then
  begin
  FOriginWndProc(AMsg);
  if (AMsg.WParam=SC_CLOSE) or (AMsg.WParam=SC_MINIMIZE) or (AMsg.WParam=SC_TASKLIST) then
    CheckActive;
  end
else
  FOriginWndProc(AMsg);
if (not InWait) and (not IsAppActive ) then
  PostMessage(Handle,WM_SYSCOMMAND,SC_CLOSE,0);
end;
//�����Ա����������ڻ�ؼ��ͷ�ʱ���ر��Լ�
procedure TfrmDropDownBase.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
if Operation=opRemove then
  begin
  if (AComponent=FHookedForm) or (AComponent=FLinkedControl) then
    begin
    RemoveHook;
    Close;
    end;
  end;
end;

{�Ƴ��ҹ�}
procedure TfrmDropDownBase.RemoveHook;
begin
if Assigned(FHookedForm) then
  begin
  FHookedForm.WindowProc:=FOriginWndProc;
  FHookedForm.RemoveFreeNotification(Self);
  FHookedForm:=nil;
  end;
if Assigned(FLinkedControl) then
  begin
  FLinkedControl.RemoveFreeNotification(Self);
  FLinkedControl.WindowProc:=FCtrlOriginWndProc;
  end;
FLinkedControl:=nil;
end;
{���ù����Ŀؼ�}
procedure TfrmDropDownBase.SetLinkedControl(const Value: TControl);
begin
if Value<>FLinkedControl then
  begin
  if Assigned(FLinkedControl) then
    RemoveHook;
  FLinkedControl := Value;
  if Assigned(Value) then
    AddHook;
  end;
end;
{���ص���Ϣ�������}
procedure TfrmDropDownBase.WndProc(var AMsg: TMessage);
  function MouseInLinkedControl:Boolean;
  var
    R:TRect;
  begin
  R.TopLeft:=LinkedControl.ClientOrigin;
  R.Right:=R.Left+LinkedControl.Width;
  R.Bottom:=R.Top+LinkedControl.Height;
  Result:=PtInRect(R,Mouse.CursorPos);
  end;
begin
if (AMsg.Msg=WM_MOVE)  then
  begin
  if AMsg.WParam<>0 then//Ĭ��WM_MOVE��WParamδʹ�ã�ʼ��Ϊ�����˴���Ϊ������ζ�����Լ����͵�λ�õ�����Ϣ
    AdjustPosition
  else
    Inherited WndProc(AMsg);
  end
else if AMsg.Msg=WM_SIZE then //�Լ��ߴ���ε����ˣ���Ҫ���µ���λ��
  AdjustPosition
else
  inherited WndProc(AMsg);
if Assigned(FHookedForm) then
  begin
  if AMsg.Msg=WM_SYSCOMMAND then
    begin
    if (AMsg.WParam=SC_CLOSE) or (AMsg.WParam=SC_MINIMIZE) or (AMsg.WParam=SC_TASKLIST) then
      RemoveHook;
    end
  else if AMsg.Msg=WM_ACTIVATE then
    begin
    if (AMsg.WParam=WA_INACTIVE) then
      begin
      if (AMsg.LParam<>Longint(FHookedForm.Handle)) then
        CheckActive
      else if FHookedForm.ActiveControl<>FLinkedControl then
        begin
        if not MouseInLinkedControl then
          CheckActive;
        end;
      end;
    end;
  end;
end;
{�ⲿ�ӿں���}
procedure DropDownForm(AFormClass:TDropDownFormClass;ACtrl:TControl;AWait:Boolean;AParam:Integer;AfterCreate:TNotifyEvent);
var
  F:TfrmDropDownBase;
begin
if Assigned(FormInDropDown) then
  begin
  if (FormInDropDown.ClassType=AFormClass) and (FormInDropDown.LinkedControl=ACtrl) and (FormInDropDown.DropDownParam=AParam) then
    begin
    FormInDropDown.BringToFront;
    Exit;
    end;
  FormInDropDown.Close;
  end;
F:=AFormClass.Create(Application);
try
  if Assigned(AfterCreate) then
    AfterCreate(F);
  DropDownForm(F,ACtrl,AWait,AParam,true);
finally
  if AWait then
    F.Free;
end;
end;

procedure DropDownForm(AForm:TfrmDropDownBase;ACtrl:TControl;AWait:Boolean;AParam:Integer;AFreeAfterClosed:Boolean);
begin
AForm.Position:=poDefault;
AForm.DropDownParam:=AParam;
FormInDropDown:=AForm;
AForm.LinkedControl:=ACtrl;
AForm.FreeAfterClosed:=AFreeAfterClosed;
AForm.Show;
AForm.Update;
if AWait then
  begin
  AForm.FInWait:=True;
  try
    while WaitMessage do
      begin
      Application.ProcessMessages;
      //�������ʱ�Զ��ر�
      if Application.Terminated or ((not IsAppActive)
          {$IFNDEF HIDE_WHEN_IDE}
          and (not IsDebuggerPresent)
          {$ENDIF}
          )
          then
          AForm.Close
      else if AForm.FActiveCheckNeeded then
        begin
        if Screen.ActiveForm<>AForm then
          AForm.Close;
        end;
      if not (Assigned(FormInDropDown) and FormInDropDown.Visible) then
        Break;
      end;
  finally
    AForm.FInWait:=False;
  end;
  end;
end;
end.

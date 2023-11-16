unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  qdialog_builder, Vcl.ComCtrls, Vcl.Samples.Gauges;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    Button13: TButton;
    Button14: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
  private
    { Private declarations }
    FBuilder: IDialogBuilder;
    FEditor: TEdit;
    procedure DoDialogResult(ABuilder: IDialogBuilder);
    procedure ValidBuilder;
    procedure LoadUser32Icon(APicture: TPicture; AResId: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button10Click(Sender: TObject);
begin
  CustomDialog('�Զ��رմ���', '������ڽ���5���ر�', 'AFlags ������16λΪ����ʱ����', ['�����ر�'], diInformation, CDF_DISPLAY_REMAIN_TIME or 5);
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
  AHint: TLabel;
  AProgress: TProgressBar;
  I: Integer;
  T: Cardinal;
begin
  ABuilder := NewDialog('���ȴ���');
  ABuilder.ItemSpace := 10;
  ABuilder.AutoSize := True;
  ABuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
  AHint := TLabel(ABuilder.AddControl(TLabel).Control);
  AHint.Caption := '���ڴ��������0%...';
  AHint.AlignWithMargins := True;
  AProgress := TProgressBar(ABuilder.AddControl(TProgressBar).Control);
  AProgress.AlignWithMargins := True;
  with ABuilder.AddContainer(amHorizCenter) do
  begin
    Height := 24;
    with TButton(AddControl(TButton).Control) do
    begin
      Caption := 'ȡ��';
      ModalResult := mrCancel;
    end;
  end;
  ABuilder.CanClose := False;
  ABuilder.Realign;
  ABuilder.Popup(Button11);
  for I := 0 to 100 do
  begin
    AHint.Caption := '���ڴ��������' + IntToStr(I) + '%';
    AProgress.Position := I;
    T := GetTickCount;
    while GetTickCount - T < 100 do
    begin
      Application.ProcessMessages;
      if ABuilder.Dialog.ModalResult = mrCancel then
        Break;
    end;
  end;
  ABuilder._Release;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
  I, T, ADelta: Integer;
  AGauges: array [0 .. 5] of TGauge;
  J: Integer;
begin
  ABuilder := NewDialog;
  ABuilder.AutoSize := True;
  ABuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
  for I := 0 to 5 do
  begin
    with ABuilder.AddContainer(amHorizLeft) do
    begin
      AutoSize := True;
      with TLabel(AddControl(TLabel).Control) do
      begin
        Caption := '���� ' + IntToStr(I);
        Layout := tlCenter;
      end;
      AGauges[I] := TGauge(AddControl(TGauge).Control);
      with AGauges[I] do
      begin
        Progress := random(100);
        Height := 10;
      end;
    end;
  end;
  ABuilder.Popup(Button12);
  T := Button12.Top;
  for I := 0 to 99 do
  begin
    Application.ProcessMessages;
    Sleep(10);
    if (I mod 10) = 0 then
    begin
      for J := 0 to 5 do
        AGauges[J].Progress := random(100);
    end;
    if I < 50 then
      Button12.Top := Button12.Top + 1
    else
      Button12.Top := Button12.Top - 1;
  end;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  ValidBuilder;
  FBuilder.PopupPosition := TQDialogPopupPosition(RadioGroup1.ItemIndex);
  FBuilder.Popup(GroupBox1);
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  ValidBuilder;
  FBuilder.PopupPosition := TQDialogPopupPosition(RadioGroup1.ItemIndex);
  FBuilder.Popup(nil);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ValidBuilder;
  FBuilder.Popup(Button1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ValidBuilder;
  FBuilder.ShowModal;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
  I: Integer;
  ACtrl: IControlDialogItem;
begin
  // ��ʾ����ʾͨ��PropText�������Լ��û������С��ѡ�б��������
  ABuilder := NewDialog('��ѡ��Ŀ');
  ABuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
  ABuilder.PropText := '{"Width":300,"Height":150}';
  ABuilder.AddControl(TRadioButton, '{"Caption":"�������Ŀһ","AlignWithMargins":True,"Margins":{"Left":10},"Height":30}');
  ABuilder.AddControl(TRadioButton, '{"Caption":"�������Ŀ��","AlignWithMargins":True,"Margins":{"Left":10},"Height":30}');
  with ABuilder.AddContainer(amHorizRight) do
  begin
    Height := 32;
    AddControl(TButton, '{"Caption":"ȷ��","ModalResult":1}');
    AddControl(TButton, '{"Caption":"ȡ��","ModalResult":2}');
  end;
  ABuilder.ShowModal;
  if ABuilder.ModalResult = 1 then
  begin
    for I := 0 to ABuilder.Count - 1 do
    begin
      if Supports(ABuilder[I], IControlDialogItem, ACtrl) then
      begin
        if (ACtrl.Control is TRadioButton) and (TRadioButton(ACtrl.Control).Checked) then
        begin
          ShowMessage(TRadioButton(ACtrl.Control).Caption + ' ��ѡ��');
          Break;
        end;
      end;
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
begin
  ABuilder := NewDialog('����ʾ��');
  ABuilder.ItemSpace := 10;
  ABuilder.AutoSize := True;
  ABuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
  with TLabel(ABuilder.AddControl(TLabel).Control) do
  begin
    Caption := '�𴲻��·��ˣ�����';
    Font.Color := clWhite;
    Font.Name := '΢���ź�';
    Font.Size := 12;
    Alignment := taCenter;
    Transparent := False;
    Color := clGray;
  end;
  with TLabel(ABuilder.AddControl(TLabel).Control) do
  begin
    Caption := '����һ���������糿���㻹��˯������'#13#10 + //
      '��ô��������������'#13#10 + //
      '�𴲻��·���~~~~';
    WordWrap := True;
    Font.Color := clGray;
    AlignWithMargins := True;
  end;
  ABuilder.Popup(Button4);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
  AGroup: IDialogItemGroup;
  I: Integer;
begin
  // ��ʾ����ʾ������÷�
  ABuilder := NewDialog('����ʾ��');
  ABuilder.AutoSize := True;
  ABuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
  // ��ӵ�һ��RadioButton
  with ABuilder.AddContainer(amVertTop) do
  begin
    ItemSpace := 10;
    AutoSize := True;
    AddControl(TLabel, '{"Caption":"��һ��","Color":"clGray","Transparent":False,"Font":{"Color":"clWhite","Size":11}}');
    AddControl(TRadioButton, '{"Caption":"����ǵ�һ��ĵ�һ��","AlignWithMargins":True,"Margins":{"Left":10},"Height":30}').GroupName
      := 'Group1';
    AddControl(TRadioButton, '{"Caption":"����ǵ�һ��ĵڶ���","AlignWithMargins":True,"Margins":{"Left":10},"Height":30}').GroupName
      := 'Group1';
  end;
  // ��ӵڶ���RadioButton
  with ABuilder.AddContainer(amVertTop) do
  begin
    AutoSize := True;
    ItemSpace := 10;
    AddControl(TLabel, '{"Caption":"�ڶ���","Color":"clGray","Transparent":False,"Font":{"Color":"clWhite","Size":11}}');
    AddControl(TRadioButton, '{"Caption":"����ǵڶ���ĵ�һ��","AlignWithMargins":True,"Margins":{"Left":10},"Height":30}').GroupName
      := 'Group2';
    AddControl(TRadioButton, '{"Caption":"����ǵڶ���ĵڶ���","AlignWithMargins":True,"Margins":{"Left":10},"Height":30}').GroupName
      := 'Group2';
  end;
  with ABuilder.AddContainer(amHorizRight) do
  begin
    AutoSize := True;
    Height := 32;
    AddControl(TButton, '{"Caption":"ȷ��","ModalResult":1}');
    AddControl(TButton, '{"Caption":"ȡ��","ModalResult":2}');
  end;
  ABuilder.ShowModal;
  if ABuilder.ModalResult = 1 then
  begin
    AGroup := ABuilder.GroupByName('Group1');
    for I := 0 to AGroup.Count - 1 do
    begin
      with TRadioButton((AGroup[I] as IControlDialogItem).Control) do
      begin
        if Checked then
          ShowMessage('����һѡ�����Ŀ�ǣ�' + Caption);
      end;
    end;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  pt: TPoint;
begin
  ValidBuilder;
  pt := ClientToScreen(Point(0, 0));
  FBuilder.Popup(pt);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  ABuilder: IDialogBuilder;
begin
  ABuilder := NewDialog('����');
  ABuilder.AutoSize := True;
  ABuilder.ItemSpace := 5;
  ABuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
  with ABuilder.AddContainer(amHorizLeft) do
  begin
    AutoSize := True;
    with TImage(AddControl(TImage).Control) do
    begin
      AlignWithMargins := True;
      AutoSize := True;
      LoadUser32Icon(Picture, 101);
    end;
    with TLabel(AddControl(TLabel).Control) do
    begin
      AlignWithMargins := True;
      Caption := '�������ɾ����ǰ��¼��'#13#10'�� -  ɾ��'#13#10'�� - ȡ������';
    end;
  end;
  with ABuilder.AddContainer(amHorizRight) do
  begin
    AutoSize := True;
    with TButton(AddControl(TButton).Control) do
    begin
      Caption := '��(&Y)';
      ModalResult := mrYes;
    end;
    with TButton(AddControl(TButton).Control) do
    begin
      Caption := '��(&N)';
      ModalResult := mrNo;
    end;
  end;
  ABuilder.ShowModal;
  if ABuilder.ModalResult = mrYes then
    ShowMessage('ɾ����¼')
  else
    ShowMessage('ɾ��������ȡ��');
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  case CustomDialog('��������', '�����ƵĴ����Ѿ������������ˣ�', 'ѡ���������Ҫ���еĲ�����'#13#10#13#10'������ - �������أ�Ҳ����ʧ��'#13#10'���� - �����ɣ��ܿ��ԣ����ٻ�������������',
    ['������', '����'], diWarning) of
    0:
      ShowMessage('��ʿ�����ɶԷ��Ѿ��Ѵ����յ���');
    1:
      ShowMessage('ų��ѽ������ô���������ͷ���');
    -1:
      ShowMessage('�ж�����������л����Ѿ�������');
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  CustomDialog('����ͼ��', '���ͼ��������shell32.dll', '', ['ȷ��'], 48, 'shell32', TSize.Create(64, 64));
end;

procedure TForm1.DoDialogResult(ABuilder: IDialogBuilder);
begin
  Label1.Caption := '�༭�����' + FEditor.Text;
  if ABuilder=FBuilder then
    FBuilder:=nil;
end;

procedure TForm1.LoadUser32Icon(APicture: TPicture; AResId: Integer);
var
  AIcon: TIcon;
begin
  AIcon := TIcon.Create;
  try
    AIcon.LoadFromResourceID(GetModuleHandle(user32), AResId);
    APicture.Assign(AIcon);
  finally
    FreeAndNil(AIcon);
  end;
end;

procedure TForm1.ValidBuilder;
begin
  if not Assigned(FBuilder) then
  begin
    FBuilder := NewDialog('DialogBuilder ʾ��');
    FBuilder.AutoSize := True;
    FBuilder.Dialog.Padding.SetBounds(5, 5, 5, 5);
    with FBuilder.AddContainer(amHorizLeft) do
    begin
      Height := 32;
      AutoSize := True;
      // ʾ����ֱ�ӷ��ʿؼ�������
      with TImage(AddControl(TImage).Control) do
      begin
        AutoSize := True;
        LoadUser32Icon(Picture, 101);
      end;
      with TLabel(AddControl(TLabel).Control) do
      begin
        Font.Color := clRed;
        Font.Size := 12;
        Font.Name := '΢���ź�';
        Layout := tlCenter;
        Caption := '��������д���˶ԣ��Ա������';
      end;
    end;
    // ʾ����ʹ�û��� JSON �����Զ���
    FBuilder.AddControl(TLabel, '{"AlignWithMargins":True,"Caption":"��������������.","Font":{"Color":"clGray"}}');
    with FBuilder.AddControl(TEdit, '{"AlignWithMargins":true}') do
    begin
      FEditor := TEdit(Control);
      GroupName := 'Edit';
    end;
    with FBuilder.AddContainer(amHorizRight) do
    begin
      Height := 32;
      AddControl(TButton,
        procedure(ASender: TObject)
        var
          ACtrl: IControlDialogItem;
        begin
          if Supports(ASender, IControlDialogItem, ACtrl) then
          begin
            ACtrl.Builder.Dialog.Close;
            ShowMessage('�û������ֵΪ:' + FEditor.Text);
          end;
        end, '{"Caption":"ȷ��","ModalResult":1}');
      AddControl(TButton,
        procedure(ASender: TObject)
        var
          ACtrl: IControlDialogItem;
        begin
          if Supports(ASender, IControlDialogItem, ACtrl) then
            ACtrl.Builder.Dialog.Close;
        end, '{"Caption":"ȡ��","ModalResult":2}');
    end;
    FBuilder.OnResult := DoDialogResult;
  end;
end;

end.

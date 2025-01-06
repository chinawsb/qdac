object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 618
    Height = 394
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 48
    ExplicitWidth = 609
    ExplicitHeight = 385
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 368
    ExplicitTop = 24
    ExplicitWidth = 185
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 145
      Height = 25
      Caption = 'profile in main threads'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 488
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Show Profiles'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 168
      Top = 8
      Width = 145
      Height = 25
      Caption = 'profile in muti-threads'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 328
      Top = 8
      Width = 145
      Height = 25
      Caption = 'Profile cost'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
end

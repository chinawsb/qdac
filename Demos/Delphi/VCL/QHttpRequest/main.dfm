object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 721
  ClientWidth = 849
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 849
    Height = 680
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 849
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    OnClick = Panel1Click
    object Button1: TButton
      AlignWithMargins = True
      Left = 609
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'GET'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 3
      Top = 8
      Width = 438
      Height = 25
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alClient
      TabOrder = 1
      Text = 'http://115.159.146.113/qdac.tar.gz'
      ExplicitHeight = 21
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 528
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'HEAD'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 447
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'DOWLOAD'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 690
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'GET Text'
      TabOrder = 4
      OnClick = Button4Click
    end
    object Button5: TButton
      AlignWithMargins = True
      Left = 771
      Top = 3
      Width = 75
      Height = 35
      Align = alRight
      Caption = 'REST'
      TabOrder = 5
      OnClick = Button5Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 416
    Top = 368
  end
end

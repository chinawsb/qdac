object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'QProfile demo'
  ClientHeight = 570
  ClientWidth = 1040
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
    Width = 1034
    Height = 523
    Align = alClient
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1040
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Async reference #1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 676
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Show Profiles'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 342
      Top = 8
      Width = 150
      Height = 25
      Caption = 'profile in muti-threads'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 509
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Profile cost'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 175
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Async reference #2'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 844
      Top = 8
      Width = 150
      Height = 25
      Caption = 'Show Diagrams'
      TabOrder = 5
      OnClick = Button6Click
    end
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    DefaultPort = 8090
    OnCommandGet = IdHTTPServer1CommandGet
    Left = 512
    Top = 192
  end
end

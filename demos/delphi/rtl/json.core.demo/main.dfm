object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'QJson Demos'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    Color = clInfoBk
    ParentBackground = False
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 9
      Width = 100
      Height = 25
      Caption = 'Speed compare'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 130
      Top = 9
      Width = 100
      Height = 25
      Caption = 'Cache test'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 253
      Top = 8
      Width = 100
      Height = 25
      Caption = 'Hash compare'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button5: TButton
      Left = 376
      Top = 8
      Width = 100
      Height = 25
      Caption = 'Manual write'
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button4: TButton
      Left = 496
      Top = 8
      Width = 75
      Height = 25
      Caption = 'RTTI'
      TabOrder = 4
      OnClick = Button4Click
    end
    object Button6: TButton
      Left = 8
      Top = 40
      Width = 100
      Height = 25
      Caption = 'TStrings'
      TabOrder = 5
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 130
      Top = 40
      Width = 100
      Height = 25
      Caption = 'Generics'
      TabOrder = 6
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 253
      Top = 40
      Width = 100
      Height = 25
      Caption = 'Collection'
      TabOrder = 7
      OnClick = Button8Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 89
    Width = 624
    Height = 352
    Align = alClient
    TabOrder = 1
  end
end

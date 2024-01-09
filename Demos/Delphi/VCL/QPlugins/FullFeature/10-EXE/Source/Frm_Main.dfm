object Form_Main: TForm_Main
  Left = 0
  Top = 0
  Caption = #20027#31383#21475
  ClientHeight = 574
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 744
    Height = 69
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 738
    object Button1: TButton
      Left = 48
      Top = 23
      Width = 75
      Height = 25
      Caption = #21152#36733
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 23
      Width = 75
      Height = 25
      Caption = #21368#36733
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 69
    Width = 744
    Height = 505
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitWidth = 738
    ExplicitHeight = 488
  end
end

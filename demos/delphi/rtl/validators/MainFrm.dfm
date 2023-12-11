object MainForm: TMainForm
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
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 744
    Height = 57
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 32
      Top = 16
      Width = 75
      Height = 25
      Caption = #26657#39564'1'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 128
      Top = 16
      Width = 75
      Height = 25
      Caption = #26657#39564'2'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 57
    Width = 744
    Height = 517
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitTop = 75
    ExplicitHeight = 499
  end
end

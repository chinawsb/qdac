object Form_Dll: TForm_Dll
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
    Height = 69
    Align = alTop
    TabOrder = 0
    object LabeledEdit1: TLabeledEdit
      Left = 72
      Top = 24
      Width = 169
      Height = 23
      EditLabel.Width = 39
      EditLabel.Height = 23
      EditLabel.Caption = #36755#20837#65306
      LabelPosition = lpLeft
      TabOrder = 0
      Text = ''
      OnKeyPress = LabeledEdit1KeyPress
    end
    object Button1: TButton
      Left = 264
      Top = 23
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 1
      OnClick = Button1Click
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
  end
end

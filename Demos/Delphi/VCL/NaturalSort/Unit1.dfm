object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Natural Compare Demo'
  ClientHeight = 416
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 12
    Width = 129
    Height = 25
    Caption = #33258#28982#25490#24207'(Sort)'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 55
    Width = 257
    Height = 346
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    Lines.Strings = (
      'DBC1'
      'DBC2'
      'DBC07'
      'DBC11'
      'DBC101'
      'DBC12'
      'DBC20'
      'DBC21'
      'DBC102'
      'DBC13'
      'DBC104'
      'DBC201'
      'DBC22'
      'DBC29'
      'DBC301'
      'DBC404')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 280
    Top = 55
    Width = 257
    Height = 346
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    Lines.Strings = (
      'Memo2')
    TabOrder = 2
  end
  object CheckBox1: TCheckBox
    Left = 168
    Top = 16
    Width = 177
    Height = 17
    Caption = #24573#30053#22823#23567#20889'(Case insensitive)'
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 376
    Top = 16
    Width = 180
    Height = 17
    Caption = #24573#30053#31354#30333#23383#31526'(Ignore spaces)'
    TabOrder = 4
  end
end

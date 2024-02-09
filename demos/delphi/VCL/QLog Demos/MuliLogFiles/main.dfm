object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Multi log files'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 240
    ExplicitTop = 48
    ExplicitWidth = 185
    object sbPostLogs: TSpeedButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 81
      Height = 35
      Align = alLeft
      Caption = 'Post Logs'
      OnClick = sbPostLogsClick
      ExplicitLeft = -32
      ExplicitTop = 0
    end
    object sbLogs0: TSpeedButton
      AlignWithMargins = True
      Left = 90
      Top = 3
      Width = 81
      Height = 35
      Align = alLeft
      Caption = 'Logs 0'
      OnClick = sbLogs0Click
      ExplicitLeft = 57
      ExplicitTop = 6
    end
    object sbLogs2_9: TSpeedButton
      AlignWithMargins = True
      Left = 264
      Top = 3
      Width = 81
      Height = 35
      Align = alLeft
      Caption = 'Logs 2-9'
      OnClick = sbLogs2_9Click
      ExplicitLeft = 24
      ExplicitTop = -8
      ExplicitHeight = 49
    end
    object sbCustomLogs: TSpeedButton
      AlignWithMargins = True
      Left = 351
      Top = 3
      Width = 81
      Height = 35
      Align = alLeft
      Caption = 'Others'
      OnClick = sbCustomLogsClick
      ExplicitTop = 0
    end
    object SpeedButton1: TSpeedButton
      AlignWithMargins = True
      Left = 177
      Top = 3
      Width = 81
      Height = 35
      Align = alLeft
      Caption = 'Logs 1'
      OnClick = SpeedButton1Click
      ExplicitTop = 0
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 624
    Height = 400
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
  end
end

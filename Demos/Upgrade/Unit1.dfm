object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 294
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 253
    Width = 503
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitLeft = 96
    ExplicitTop = 240
    ExplicitWidth = 185
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 0
      Width = 503
      Height = 41
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 176
      ExplicitTop = 16
      ExplicitWidth = 150
      ExplicitHeight = 17
    end
  end
  object MainMenu1: TMainMenu
    Left = 128
    Top = 56
    object miTools: TMenuItem
      Caption = 'Tools'
    end
  end
end

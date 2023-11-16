object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'QDB PostgreSQL '#28436#31034'(Demo)'
  ClientHeight = 403
  ClientWidth = 763
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
  object Splitter1: TSplitter
    Left = 281
    Top = 49
    Height = 354
    ExplicitLeft = 336
    ExplicitTop = 168
    ExplicitHeight = 100
  end
  object Memo1: TMemo
    Left = 0
    Top = 49
    Width = 281
    Height = 354
    Align = alLeft
    ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 49
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 128
      Top = 17
      Width = 48
      Height = 13
      Caption = #26368#22823#34892#25968
    end
    object Button1: TButton
      Left = 279
      Top = 11
      Width = 99
      Height = 25
      Caption = #25171#24320#25968#25454#38598
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 384
      Top = 11
      Width = 99
      Height = 25
      Caption = #25171#24320#25968#25454#27969
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 489
      Top = 10
      Width = 99
      Height = 25
      Caption = #25191#34892#33050#26412
      TabOrder = 2
      OnClick = Button3Click
    end
    object btnConnect: TButton
      Left = 15
      Top = 11
      Width = 99
      Height = 25
      Caption = #36830#25509
      TabOrder = 3
      OnClick = btnConnectClick
    end
    object SpinEdit1: TSpinEdit
      Left = 182
      Top = 12
      Width = 91
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 1000
    end
    object Button4: TButton
      Left = 687
      Top = 10
      Width = 75
      Height = 25
      Caption = #21442#25968#21270#25191#34892
      TabOrder = 5
      Visible = False
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 594
      Top = 10
      Width = 99
      Height = 25
      Caption = #22810#25968#25454#38598
      TabOrder = 6
      OnClick = Button5Click
    end
  end
  object Panel2: TPanel
    Left = 284
    Top = 49
    Width = 479
    Height = 354
    Align = alClient
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 359
      Height = 352
      Align = alClient
      DataSource = DataSource1
      ImeName = #20013#25991' - QQ'#20116#31508#36755#20837#27861
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object Panel3: TPanel
      Left = 360
      Top = 1
      Width = 118
      Height = 352
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object Button6: TButton
        Left = 16
        Top = 16
        Width = 75
        Height = 25
        Caption = #19978#19968#25968#25454#38598
        TabOrder = 0
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 16
        Top = 47
        Width = 75
        Height = 25
        Caption = #19979#19968#25968#25454#38598
        TabOrder = 1
        OnClick = Button7Click
      end
    end
  end
  object DataSource1: TDataSource
    Left = 160
    Top = 128
  end
  object UniConnection1: TUniConnection
    ProviderName = 'PostgreSQL'
    Port = 5432
    Database = 'postgres'
    Username = 'postgres'
    Server = '127.0.0.1'
    LoginPrompt = False
    Left = 56
    Top = 128
    EncryptedPassword = 'C8FFC8FFCFFFCCFFCDFFC7FF'
  end
  object PostgreSQLUniProvider1: TPostgreSQLUniProvider
    Left = 56
    Top = 192
  end
  object UniQuery1: TUniQuery
    Connection = UniConnection1
    CachedUpdates = True
    Left = 64
    Top = 264
  end
  object UniScript1: TUniScript
    Connection = UniConnection1
    Left = 128
    Top = 264
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 320
    Top = 208
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=postgres'
      'User_Name=postgres'
      'Password=770328'
      'Server=127.0.0.1'
      'CharacterSet=UTF8'
      'OidAsBlob=No'
      'DriverID=Pg9.4.1')
    ResourceOptions.AssignedValues = [rvDirectExecute]
    ResourceOptions.DirectExecute = True
    Left = 424
    Top = 160
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    DriverID = 'Pg9.4.1'
    VendorHome = 'D:\pgAdmin III\'
    Left = 384
    Top = 112
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 440
    Top = 296
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 392
    Top = 224
  end
  object UniSQL1: TUniSQL
    Connection = UniConnection1
    Left = 376
    Top = 208
  end
end

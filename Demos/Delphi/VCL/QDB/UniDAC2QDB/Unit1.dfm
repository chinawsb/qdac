object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'UniDAC/ADO <-> QDB'
  ClientHeight = 428
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 329
    Top = 162
    Height = 178
    ExplicitTop = 65
    ExplicitHeight = 136
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 728
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -322
    ExplicitWidth = 769
    object Label3: TLabel
      Left = 16
      Top = 45
      Width = 36
      Height = 13
      Caption = #36716#25442#22120
    end
    object Button3: TButton
      Left = 135
      Top = 10
      Width = 114
      Height = 25
      Caption = #36716#25442#21040' QDataSet'
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button1: TButton
      Left = 15
      Top = 10
      Width = 114
      Height = 25
      Caption = #25171#24320#21407#22987#25968#25454#38598
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 255
      Top = 10
      Width = 98
      Height = 25
      Caption = #36716#25442#21040' UniDAC'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 368
      Top = 10
      Width = 75
      Height = 25
      Caption = #25552#20132#26356#26032
      TabOrder = 3
    end
    object chkDeleted: TCheckBox
      Left = 456
      Top = 16
      Width = 57
      Height = 17
      Caption = #24050#21024#38500
      TabOrder = 4
    end
    object chkUnchange: TCheckBox
      Left = 514
      Top = 16
      Width = 57
      Height = 17
      Caption = #26410#21464#26356
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object chkModified: TCheckBox
      Left = 573
      Top = 16
      Width = 57
      Height = 17
      Caption = #24050#20462#25913
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
    object chkInserted: TCheckBox
      Left = 632
      Top = 16
      Width = 57
      Height = 17
      Caption = #26032#25554#20837
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object cbxConverterType: TComboBox
      Left = 64
      Top = 41
      Width = 185
      Height = 21
      ItemIndex = 0
      TabOrder = 8
      Text = 'FireDAC<->QDB '#20108#36827#21046#36716#25442#22120
      Items.Strings = (
        'FireDAC<->QDB '#20108#36827#21046#36716#25442#22120
        'FireDAC<->QDB JSON '#36716#25442#22120
        'FireDAC<->QDB XML '#36716#25442#22120)
    end
    object Button5: TButton
      Left = 255
      Top = 34
      Width = 75
      Height = 25
      Caption = 'Button5'
      TabOrder = 9
      OnClick = Button5Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 162
    Width = 329
    Height = 178
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    ExplicitTop = 65
    ExplicitHeight = 136
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 323
      Height = 13
      Align = alTop
      Caption = 'FireDAC '#26597#35810#32467#26524
      ExplicitWidth = 90
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 19
      Width = 329
      Height = 159
      Align = alClient
      Ctl3D = False
      DataSource = DataSource1
      ParentCtl3D = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel4: TPanel
    Left = 332
    Top = 162
    Width = 396
    Height = 178
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 10
    ExplicitTop = 65
    ExplicitWidth = 437
    ExplicitHeight = 136
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 390
      Height = 13
      Align = alTop
      Caption = 'QDB '#36716#25442#32467#26524
      ExplicitWidth = 72
    end
    object DBGrid2: TDBGrid
      Left = 0
      Top = 19
      Width = 396
      Height = 159
      Align = alClient
      Ctl3D = False
      DataSource = DataSource2
      ParentCtl3D = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 65
    Width = 728
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = -322
    ExplicitWidth = 769
    object mmSQL: TMemo
      Left = 0
      Top = 0
      Width = 728
      Height = 97
      Align = alClient
      Lines.Strings = (
        'select id,char_d from dbtypes')
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      ExplicitWidth = 769
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 340
    Width = 728
    Height = 88
    Align = alBottom
    TabOrder = 4
    ExplicitLeft = -322
    ExplicitTop = 113
    ExplicitWidth = 769
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 105
      Height = 86
      Align = alLeft
      ExplicitLeft = 224
      ExplicitTop = -17
      ExplicitHeight = 105
    end
    object Image2: TImage
      Left = 622
      Top = 1
      Width = 105
      Height = 86
      Align = alRight
      ExplicitLeft = 224
      ExplicitTop = -17
      ExplicitHeight = 105
    end
    object Memo1: TMemo
      Left = 106
      Top = 1
      Width = 185
      Height = 86
      Align = alLeft
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 437
      Top = 1
      Width = 185
      Height = 86
      Align = alRight
      TabOrder = 1
      ExplicitLeft = 478
    end
    object Button6: TButton
      Left = 335
      Top = 37
      Width = 75
      Height = 25
      Caption = 'Button6'
      TabOrder = 2
    end
    object Button7: TButton
      Left = 290
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Button6'
      TabOrder = 3
    end
  end
  object DataSource2: TDataSource
    Left = 419
    Top = 56
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 344
    Top = 173
  end
  object OpenDialog1: TOpenDialog
    Left = 408
    Top = 168
  end
  object DataSource1: TDataSource
    DataSet = UniQuery1
    Left = 272
    Top = 80
  end
  object ucPgSQL: TUniConnection
    ProviderName = 'PostgreSQL'
    Port = 15432
    Database = 'QDAC_Demo'
    Username = 'qdac'
    Server = 'www.qdac.cc'
    Connected = True
    LoginPrompt = False
    Left = 192
    Top = 80
    EncryptedPassword = 'AEFF9BFF9EFF9CFFD1FFBBFF9AFF92FF90FF'
  end
  object UniQuery1: TUniQuery
    Connection = ucPgSQL
    Left = 344
    Top = 80
  end
  object PostgreSQLUniProvider1: TPostgreSQLUniProvider
    Left = 96
    Top = 80
  end
  object VirtualTable1: TVirtualTable
    Options = [voPersistentData, voStored, voSkipUnSupportedFieldTypes]
    Left = 424
    Top = 145
    Data = {03000000000000000000}
  end
end

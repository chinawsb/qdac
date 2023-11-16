unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, QString,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Db, QDB, qconverter_stds, qconverter_fdac, qconverter_csv,
  qconverter_adoxml,
  qsp_zlib, qaes,
  qsp_aes, zlib,
  DateUtils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    chkSaveUnmodified: TCheckBox;
    chkSaveInserted: TCheckBox;
    chkSaveModified: TCheckBox;
    chkSaveDeleted: TCheckBox;
    chkSaveMeta: TCheckBox;
    DataSource1: TDataSource;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel2: TPanel;
    Button5: TButton;
    Button6: TButton;
    GroupBox2: TGroupBox;
    chkCompress: TCheckBox;
    chkEncrypt: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cbxKeyType: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edtKey: TEdit;
    Label4: TLabel;
    edtInitVector: TEdit;
    Label5: TLabel;
    cbxCompressLevel: TComboBox;
    Label6: TLabel;
    cbxEncryptMode: TComboBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure GroupBox2Click(Sender: TObject);
  private
    { Private declarations }
    FDataSet: TQDataSet;
    FZLibProcessor: TQZlibStreamProcessor;
    FAESProcessor: TQAESStreamProcessor;
    procedure UpdateButtonStates;
    function CreateConverter(ATypeIndex: Integer): TQConverter;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qconverter_sql;
{$R *.dfm}

function GetHumanName: String;
const
  // �й��ټ��� (Chinese Last Names)
  FirstNames: array [0 .. 503] of String = ('��', 'Ǯ', '��', '��', '��', '��', '֣',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    'ʩ', '��', '��', '��', '��', '��', '��', 'κ', '��', '��', '��', 'л', '��', '��', '��',
    'ˮ', '�', '��', '��', '��', '��', '��', '��', '��', '��', '��', '³', 'Τ', '��', '��',
    '��', '��', '��', '��', '��', '��', 'Ԭ', '��', 'ۺ', '��', 'ʷ', '��', '��', '��', '�',
    'Ѧ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    'ʱ', '��', 'Ƥ', '��', '��', '��', '��', '��', 'Ԫ', '��', '��', '��', 'ƽ', '��', '��',
    '��', '��', '��', 'Ҧ', '��', '��', '��', '��', 'ë', '��', '��', '��', '��', '��', '�',
    '��', '��', '��', '��', '̸', '��', 'é', '��', '��', '��', '��', '��', '��', 'ף', '��',
    '��', '��', '��', '��', '��', 'ϯ', '��', '��', 'ǿ', '��', '·', '¦', 'Σ', '��', 'ͯ',
    '��', '��', '÷', 'ʢ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '֧', '��', '��', '��', '¬', 'Ī', '��', '��', '��', '��',
    '��', '��', 'Ӧ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    'ʯ', '��', '��', 'ť', '��', '��', '��', '��', '��', '��', '½', '��', '��', '��', '��',
    '�', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', 'ɽ', '��', '��', '��', '�', '��',
    'ȫ', 'ۭ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', 'ղ', '��', '��', 'Ҷ', '��', '˾', '��', '۬', '��',
    '��', '��', 'ӡ', '��', '��', '��', '��', 'ۢ', '��', '��', '��', '��', '��', '��', '׿',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '˫', '��', 'ݷ', '��', '��',
    '̷', '��', '��', '��', '��', '��', '��', '��', 'Ƚ', '��', '۪', 'Ӻ', '��', '�', 'ɣ',
    '��', '�', 'ţ', '��', 'ͨ', '��', '��', '��', '��', 'ۣ', '��', '��', 'ũ', '��', '��',
    'ׯ', '��', '��', '��', '��', '��', 'Ľ', '��', '��', 'ϰ', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '»', '��', '��', 'Ź', '�', '��', '��', 'ε', 'Խ', '��',
    '¡', 'ʦ', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', 'ɳ', 'ؿ', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', 'Ȩ', '��', '��', '��', '��', '��', '��ٹ', '˾��', '�Ϲ�',
    'ŷ��', '�ĺ�', '���', '����', '����', '����', '�ʸ�', 'ξ��', '����', '�̨', '��ұ', '����',
    '���', '����', '����', '̫��', '����', '����', '����', '��ԯ', '���', '����', '����', '����',
    'Ľ��', '����', '����', '˾ͽ', '˾��', '����', '˾��', '��', '��', '�ӳ�', '���', '��ľ', '����',
    '����', '���', '����', '����', '����', '�ذ�', '�й�', '�׸�', '����', '��', '��', '��', '��',
    '��', '۳', 'Ϳ', '��', '�θ�', '����', '����', '����', '����', '��', '��', '����', '΢��', '��',
    '˧', '��', '��', '��', '��', '��', '��', '����', '����', '����', '����', '��', 'Ĳ', '��',
    '٦', '��', '��', '�Ϲ�', 'ī', '��', '��', '��', '��', '��', '��', '١', '����',
    '��', '��');
var
  I, L: Integer;
begin
  L := 1 + Random(2);
  Result := '';
  for I := 0 to L - 1 do
    Result := Result + WideChar($4E00 + Random(20902));
  Result := FirstNames[Random(Length(FirstNames))] + Result;
end;

function CreateDemoDataSet(AOwner: TComponent; ARecordCount: Integer)
  : TQDataSet;
var
  AFdId, AFdAge, AFdBirthday, AFdName, AFdSex, AFdScale, AFdComment: TField;
  I: Integer;
begin
  Result := TQDataSet.Create(AOwner);
  Result.FieldDefs.Add('Id', ftString, 10);
  Result.FieldDefs.Add('Age', ftInteger);
  Result.FieldDefs.Add('Birthday', ftDateTime);
  Result.FieldDefs.Add('Name', ftWideString, 30);
  Result.FieldDefs.Add('Sex', ftBoolean);
  Result.FieldDefs.Add('Scale', ftFloat);
  Result.FieldDefs.Add('Comment', ftWideMemo);
  Result.CreateDataSet;
  Result.DisableControls;
  try
    AFdId := Result.FieldByName('Id');
    AFdAge := Result.FieldByName('Age');
    AFdName := Result.FieldByName('Name');
    AFdSex := Result.FieldByName('Sex');
    AFdScale := Result.FieldByName('Scale');
    AFdBirthday := Result.FieldByName('Birthday');
    AFdComment := Result.FieldByName('Comment');
    for I := 1 to ARecordCount do
    begin
      Result.Append;
      AFdId.AsString := 'CC_' + IntToStr(I);
      AFdName.AsString := GetHumanName;
      AFdBirthday.AsDateTime := IncYear(IncDay(Now, -Random(50)), -Random(5));
      AFdAge.AsInteger := YearsBetween(Now, AFdBirthday.AsDateTime) + 1;
      AFdSex.AsBoolean := Random(10) > 5;
      AFdScale.AsFloat := Random(1000) / 10;
      AFdComment.AsString := 'Comment for ' + AFdName.AsString;
      Result.Post;
    end;
    Result.ApplyChanges;
  finally
    Result.EnableControls;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  AConverter: TQConverter;
begin
  if OpenDialog1.Execute then
  begin
    AConverter := CreateConverter(OpenDialog1.FilterIndex);
    if AConverter <> nil then
    begin
      FDataSet.LoadFromFile(OpenDialog1.FileName, AConverter);
      UpdateButtonStates;
      FreeAndNil(AConverter);
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ARange: TQExportRanges;
  AConverter: TQConverter;
  T: DWORD;
begin
  ARange := [];
  if chkSaveMeta.Checked then
    ARange := [merMeta];
  if chkSaveInserted.Checked then
    ARange := ARange + [merInserted];
  if chkSaveUnmodified.Checked then
    ARange := ARange + [merUnmodified];
  if chkSaveDeleted.Checked then
    ARange := ARange + [merDeleted];
  if chkSaveModified.Checked then
    ARange := ARange + [merModified];
  if SaveDialog1.Execute then
  begin
    AConverter := CreateConverter(SaveDialog1.FilterIndex);
    if AConverter <> nil then
    begin
      AConverter.ExportRanges := ARange;
      T := GetTickCount;
      FDataSet.SaveToFile(SaveDialog1.FileName, AConverter);
      T := GetTickCount - T;
      ShowMessage('���浽������ʱ��' + IntToStr(T) + 'ms');
      FreeAndNil(AConverter);
    end;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Assigned(FDataSet) then
    FreeAndNil(FDataSet);
  FDataSet := CreateDemoDataSet(Self, 1000);
  DataSource1.DataSet := FDataSet;
  UpdateButtonStates;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  ATemp: TQDataSet;
  I: Integer;
begin
  if Assigned(FDataSet) then
    FDataSet.Active := False;
  FDataSet.AddDataSet(CreateDemoDataSet(FDataSet, 1000));
  ATemp := TQDataSet.Create(FDataSet);
  ATemp.FieldDefs.Add('Year', ftInteger);
  ATemp.FieldDefs.Add('Animal', ftWideString, 20);
  ATemp.FieldDefs.Add('Total', ftFloat);
  ATemp.CreateDataSet;
  for I := 2000 to 2014 do
  begin
    ATemp.Append;
    ATemp.Fields[0].AsInteger := I;
    ATemp.Fields[1].AsString := 'Mouse';
    ATemp.Fields[2].AsFloat := Random(10000) / 10;
    ATemp.Post;
  end;
  for I := 2000 to 2014 do
  begin
    ATemp.Append;
    ATemp.Fields[0].AsInteger := I;
    ATemp.Fields[1].AsString := 'Dog';
    ATemp.Fields[2].AsFloat := Random(10000) / 10;
    ATemp.Post;
  end;
  for I := 2000 to 2014 do
  begin
    ATemp.Append;
    ATemp.Fields[0].AsInteger := I;
    ATemp.Fields[1].AsString := 'Cat';
    ATemp.Fields[2].AsFloat := Random(10000) / 10;
    ATemp.Post;
  end;
  FDataSet.AddDataSet(ATemp);
  FDataSet.AddDataSet(CreateDemoDataSet(FDataSet, 10));
  DataSource1.DataSet := FDataSet;
  UpdateButtonStates;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if FDataSet.ActiveRecordset > 0 then
    FDataSet.ActiveRecordset := FDataSet.ActiveRecordset - 1;
  UpdateButtonStates;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  if FDataSet.ActiveRecordset + 1 < FDataSet.RecordsetCount then
    FDataSet.ActiveRecordset := FDataSet.ActiveRecordset + 1;
  UpdateButtonStates;
end;

function TForm1.CreateConverter(ATypeIndex: Integer): TQConverter;
var
  I: Integer;
begin
  Result := nil;
  case ATypeIndex of
    1:
      Result := TQBinaryConverter.Create(nil);
    2:
      Result := TQMsgPackConverter.Create(nil);
    3:
      Result := TQJsonConverter.Create(nil);
    4:
      Result := TQFDBinaryConverter.Create(nil);
    5:
      Result := TQFDJsonConverter.Create(nil);
    6:
      Result := TQADOXMLConverter.Create(nil);
      //TQFDXMLConverter.Create(nil);
    7:
      Result := TQTextConverter.Create(nil);
    8:
      Result := TQMSSQLConverter.Create(nil);
    9:
      Result := TQPgSQLConverter.Create(nil);
    10:
      Result := TQMySQLConverter.Create(nil);
  end;
  if ATypeIndex in [8, 9, 10] then
  begin
    TQSQLConverter(Result).AllAsInsert := True;
    for I := 0 to FDataSet.FieldDefs.Count - 1 do
      (FDataSet.FieldDefs[I] as TQFieldDef).Table := 'asc';
  end;
  if chkCompress.Checked then
  begin
    if not Assigned(FZLibProcessor) then
      FZLibProcessor := TQZlibStreamProcessor.Create(Self);
    FZLibProcessor.CompressionLevel :=
      TZCompressionLevel(cbxCompressLevel.ItemIndex);
    Result.StreamProcessors.Add.Processor := FZLibProcessor;
  end;
  if chkEncrypt.Checked then
  begin
    if not Assigned(FAESProcessor) then
    begin
      FAESProcessor := TQAESStreamProcessor.Create(Self);
      // ��ʾ��������ֱ��Ӳ�����˳�ʼ����������
      FAESProcessor.InitVector := edtInitVector.Text;
      if cbxEncryptMode.ItemIndex = 0 then
        FAESProcessor.EncryptMode := emECB
      else
        FAESProcessor.EncryptMode := emCBC;
      FAESProcessor.KeyType := TQAESKeyType(cbxKeyType.ItemIndex);
      FAESProcessor.Password := edtKey.Text;
      FAESProcessor.EncryptMode := emCBC;
    end;
    Result.StreamProcessors.Add.Processor := FAESProcessor;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Button3Click(Sender);
end;

procedure TForm1.GroupBox1Click(Sender: TObject);
var
  ADataSet: TQDataSet;
begin
  ADataSet := TQDataSet.Create(nil);
  try
    ADataSet.LoadFromFile('E:\Tencent\QQ\Data\109867294\FileRecv\adoxml.xml',
      TQADOXMLConverter);
  finally
    FreeObject(ADataSet);
  end;
end;

procedure TForm1.GroupBox2Click(Sender: TObject);
var
  AConverter:TQJsonConverter;
begin
  AConverter:=TQJsonConverter.Create(nil);
  try
    AConverter.DataSet:=FDataSet;
    AConverter.ExportRanges:=[merMeta];//

    ShowMessage(AConverter.AsJson);
  finally
    FreeAndNil(AConverter);
  end;
end;

procedure TForm1.UpdateButtonStates;
begin
  Button5.Enabled := FDataSet.ActiveRecordset > 0;
  Button6.Enabled := FDataSet.ActiveRecordset + 1 < FDataSet.RecordsetCount;
end;

end.

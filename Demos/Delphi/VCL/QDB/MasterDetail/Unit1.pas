unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, dateutils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, QDB;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FMasterDataSet, FDetailDataSet: TQDataSet;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

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
      AFdBirthday.AsDateTime := IncYear(IncDay(Now, -Random(50)),
        -10 - Random(50));
      AFdAge.AsInteger := YearsBetween(Now, AFdBirthday.AsDateTime) + 1;
      AFdSex.AsBoolean := Random(10) > 5;
      AFdScale.AsFloat := Random(1000) / 10;
      AFdComment.AsString := 'Comment for ' + AFdName.AsString;
      Result.Post;
    end;
  finally
    Result.EnableControls;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I, J: Integer;
  AId: String;
  AFdId, AFdName, AFdScore: TField;
const
  ALessonNames: array [0 .. 2] of String = ('����', '��ѧ', 'Ӣ��');
begin
  FMasterDataSet := CreateDemoDataSet(Self, 100);
  FDetailDataSet := TQDataSet.Create(Self);
  DataSource1.DataSet := FMasterDataSet;
  DataSource2.DataSet := FDetailDataSet;
  FDetailDataSet.MasterSource := DataSource1;
  FDetailDataSet.FieldDefs.Add('StudentId', ftString, 10);
  FDetailDataSet.FieldDefs.Add('Lesson', ftString, 20);
  FDetailDataSet.FieldDefs.Add('Score', ftFloat);
  FDetailDataSet.CreateDataSet();
  AFdId := FDetailDataSet.FieldByName('StudentId');
  AFdName := FDetailDataSet.FieldByName('Lesson');
  AFdScore := FDetailDataSet.FieldByName('Score');
  FDetailDataSet.DisableControls;
  try
    for I := 1 to 100 do
    begin
      AId := 'CC_' + IntToStr(I);
      for J := 0 to 2 do
      begin
        FDetailDataSet.Append;
        AFdId.AsString := AId;
        AFdName.AsString := ALessonNames[J];
        AFdScore.AsFloat := Random(1000) / 10;
        FDetailDataSet.Post;
      end;
    end;
    FDetailDataSet.MasterFields := 'id=StudentId';
  finally
    FDetailDataSet.EnableControls;
    FMasterDataSet.First;
  end;
end;

end.

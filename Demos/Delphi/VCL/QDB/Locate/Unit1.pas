unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,QString, QValue, QDB,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    Panel2: TPanel;
    DataSource1: TDataSource;
    ComboBox2: TComboBox;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    CheckBox3: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    FDataSet: TQDataSet;
    function GetFilterOptions: TFilterOptions;
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
  AFdId, AFdAge, AFdName, AFdSex, AFdScale, AFdComment: TField;
  I: Integer;
begin
Result := TQDataSet.Create(AOwner);
Result.FieldDefs.Add('Id', ftString, 10);
Result.FieldDefs.Add('Age', ftInteger);
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
  AFdComment := Result.FieldByName('Comment');
  for I := 1 to ARecordCount do
    begin
    Result.Append;
    AFdId.AsString := 'CC_' + IntToStr(I);
    AFdName.AsString := GetHumanName;
    AFdAge.AsInteger := 10 + Random(50);
    AFdSex.AsBoolean := Random(10) > 5;
    AFdScale.AsFloat := Random(1000) / 10;
    AFdComment.AsString := 'Comment for ' + AFdName.AsString;
    Result.Post;
    end;
finally
  Result.EnableControls;
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if CheckBox3.Checked then
  begin
  if CheckBox1.Checked then
    FDataSet.Filter := ComboBox2.Text + ' like ''%' + StringReplaceW(ComboBox1.Text,'''','''''',[rfReplaceAll])+'%'''
  else
    FDataSet.Filter := ComboBox2.Text + ' = ' + QuotedStrW(ComboBox1.Text);
  FDataSet.FilterOptions := GetFilterOptions;
  FDataSet.FindNext;
  end
else
  FDataSet.LocateNext(ComboBox2.Text,ComboBox1.Text,[loCaseInsensitive, loPartialKey]);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if CheckBox3.Checked then
  begin
  if CheckBox1.Checked then
    FDataSet.Filter := ComboBox2.Text + ' like ''%' + StringReplaceW(ComboBox1.Text,'''','''''',[rfReplaceAll])+'%'''
  else
    FDataSet.Filter := ComboBox2.Text + ' = ' + QuotedStrW(ComboBox1.Text);
  FDataSet.FilterOptions := GetFilterOptions;
  FDataSet.FindPrior;
  end
else
  FDataSet.LocatePrior(ComboBox2.Text,ComboBox1.Text,[loCaseInsensitive, loPartialKey]);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if CheckBox3.Checked then
  begin
  if CheckBox1.Checked then
    FDataSet.Filter := ComboBox2.Text + ' like ''%' + StringReplaceW(ComboBox1.Text,'''','''''',[rfReplaceAll])+'%'''
  else
    FDataSet.Filter := ComboBox2.Text + ' = ' + QuotedStrW(ComboBox1.Text);
  FDataSet.FilterOptions := GetFilterOptions;
  FDataSet.FindFirst;
  end
else
  FDataSet.LocateFirst(ComboBox2.Text,ComboBox1.Text,[loCaseInsensitive, loPartialKey]);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
if CheckBox3.Checked then
  begin
  if CheckBox1.Checked then
    FDataSet.Filter := ComboBox2.Text + ' like ''%' + StringReplaceW(ComboBox1.Text,'''','''''',[rfReplaceAll])+'%'''
  else
    FDataSet.Filter := ComboBox2.Text + ' = ' + QuotedStrW(ComboBox1.Text);
  FDataSet.FilterOptions := GetFilterOptions;
  FDataSet.FindLast;
  end
else
  FDataSet.LocateLast(ComboBox2.Text,ComboBox1.Text,[loCaseInsensitive, loPartialKey]);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
Application.MessageBox('�⽫��λ����һ�� Id ���� CC����������Ϊ 29 �ļ�¼��','���ֶζ�λ',MB_OK or MB_ICONINFORMATION);
FDataSet.LocateFirst('Id,Age',VarArrayOf(['CC',29]),[loPartialKey]);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
if FDataSet.Exists('Id * "CC_2790%"',[]) then
  ShowMessage('ָ���ļ�¼����(Found)');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
FDataSet := CreateDemoDataSet(Self, 10000);
FDataSet.ApplyChanges;
DataSource1.DataSet := FDataSet;
end;

function TForm1.GetFilterOptions: TFilterOptions;
begin
Result := [];
if not CheckBox1.Checked then
  Result := Result + [foNoPartialCompare];
if CheckBox2.Checked then
  Result := Result + [foCaseInsensitive];
end;

end.

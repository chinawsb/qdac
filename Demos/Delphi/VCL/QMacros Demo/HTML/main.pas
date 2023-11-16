unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.OleCtrls, SHDocVw, qmacros, qstring, Data.DB, Data.Win.ADODB;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    Button1: TButton;
    adsData: TADODataSet;
    adsDataId: TIntegerField;
    adsDataName: TStringField;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoOddMacro(AMacro: TQMacroItem; const AQuoter: QCharW);
    procedure DoEvenMacro(AMacro: TQMacroItem; const AQuoter: QCharW);
    procedure DoPrintInfo(AMacro: TQMacroItem; const AQuoter: QCharW);
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

procedure TForm1.Button1Click(Sender: TObject);
const
  STableTemplate: QStringW = '<html><head><title><%Title%></title></head>' + //
    '<body>����һ�����<table border="1"  cellspacing="0" cellpadding="0" bordercolor="#000000" style="BORDER-COLLAPSE: collapse">'
    + //
    '<th><tr><td>��¼��</td><td>���</td><td>���</td><td>����</td></tr></th>' + //
    '%adsData.@Rows("<tr><td>%adsData.@RecNo%</td><td>%adsData.@Rows.@Index%<td>%Id%</td><td>%Name%</td></tr>","%","%")%'
    + //
    '</table></body>';
var
  AMacros: TQMacroManager;
  AHtmlFile, AHtmlText, ATag: String;
begin
  AMacros := TQMacroManager.Create;
  try
    AMacros.Push(adsData, '');
    AMacros.Push('Title', 'QMacros HTML Tag �滻');
    AHtmlText := AMacros.Replace(STableTemplate, '%', '%', MRF_PARSE_PARAMS);
    AHtmlFile := ExtractFilePath(Application.ExeName) + 'index.html';
    SaveTextW(AHtmlFile, AHtmlText);
    WebBrowser1.Navigate('file:///' + StringReplaceW(AHtmlFile, '\', '/',
      [rfReplaceAll]));
    AMacros.Pop(adsData, '');
  finally
    FreeAndNil(AMacros);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  STemplate: QStringW = '<html><head><title><%Title%></title></head>' + //
    '<body>�����滻ʾ��<p>' + //
    '<%IsOdd("%Number% ������")%><%IsEven("%Number% ��ż��")%>' + '</body>';
var
  AMacros: TQMacroManager;
  AHtmlFile: String;
begin
  AMacros := TQMacroManager.Create;
  try
    AMacros.Push('Title', 'QMacros HTML ģ��ʾ��');
    AMacros.Push('Number', IntToStr(Random(100)));
    AMacros.Push('IsOdd', DoOddMacro);
    AMacros.Push('IsEven', DoEvenMacro);
    AHtmlFile := ExtractFilePath(Application.ExeName) + 'index.html';
    SaveTextW(AHtmlFile, AMacros.Replace(STemplate, '<%', '%>',
      MRF_PARSE_PARAMS));
    WebBrowser1.Navigate('file:///' + StringReplaceW(AHtmlFile, '\', '/',
      [rfReplaceAll]));
  finally
    FreeAndNil(AMacros);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
const
  STemplate: QStringW = '<html><head><title><%Title%></title></head>' + //
    '<body>�������ת��ʾ��<p>' + //
    '<%Info({"name":"QDAC","version":1.28,"copyright":"&copy;QDAC team\t2016"},3.0)%>'
    + '</body>';
var
  AMacros: TQMacroManager;
  AHtmlFile: String;
begin
  AMacros := TQMacroManager.Create;
  try
    AMacros.Push('Title', 'QMacros HTML ģ��ʾ��');
    AMacros.Push('Info', DoPrintInfo);
    AHtmlFile := ExtractFilePath(Application.ExeName) + 'index.html';
    SaveTextW(AHtmlFile, AMacros.Replace(STemplate, '<%', '%>',
      MRF_PARSE_PARAMS));
    WebBrowser1.Navigate('file:///' + StringReplaceW(AHtmlFile, '\', '/',
      [rfReplaceAll]));
  finally
    FreeAndNil(AMacros);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
const
  STemplate: QStringW = '<html><head><title>�ַ����б�ʾ��</title></head>' + //
    '<body>' + //
    '%List("<p>Welcome %List.Value%,you are %List.@Index% of our friends","%","%")%'
    + '</body>';
var
  AList: TStringList;
  AMacros: TQMacroManager;
  AHtmlFile: String;
  AIterator: IQMacroIterator ;
begin
  AList := TStringList.Create;
  AList.Text := 'Joson'#13#10'Mikelin';
  AMacros := TQMacroManager.Create;
  try
    AIterator := TQMacroStringsIterator.Create(AList);
    AMacros.Push('List', AIterator);
    AMacros.Push('List.Value',
      procedure(AMacro: TQMacroItem; const AQuoter: QCharW)
      begin
        AMacro.Value.Value := AList[AIterator.GetItemIndex];
      end);
    AHtmlFile := ExtractFilePath(Application.ExeName) + 'index.html';
    SaveTextW(AHtmlFile, AMacros.Replace(STemplate, '%', '%',
      MRF_PARSE_PARAMS));
    WebBrowser1.Navigate('file:///' + StringReplaceW(AHtmlFile, '\', '/',
      [rfReplaceAll]));
  finally
    FreeAndNil(AMacros);
    FreeAndNil(AList);
  end;
end;

procedure TForm1.DoEvenMacro(AMacro: TQMacroItem; const AQuoter: QCharW);
var
  AValue: Integer;
begin
  if TryStrToInt(AMacro.Owner.Values['Number'], AValue) and ((AValue mod 2) = 0)
  then
    AMacro.Value.Value := AMacro.Owner.Replace
      (AMacro.Params[0].AsString, '%', '%')
  else
    AMacro.Value.Value := '';
end;

procedure TForm1.DoOddMacro(AMacro: TQMacroItem; const AQuoter: QCharW);
var
  AValue: Integer;
begin
  if TryStrToInt(AMacro.Owner.Values['Number'], AValue) and ((AValue mod 2) <> 0)
  then
    AMacro.Value.Value := AMacro.Owner.Replace
      (AMacro.Params[0].AsString, '%', '%')
  else
    AMacro.Value.Value := '';
end;

procedure TForm1.DoPrintInfo(AMacro: TQMacroItem; const AQuoter: QCharW);
begin
  AMacro.Value.Value := 'QMacros ' + AMacro.Params[1].AsString + '<BR/>';
  with AMacro.Params[0] do
  begin
    AMacro.Value.Value := AMacro.Value.Value + '��������:' + ValueByName('name', '')
      + '<BR/>' + '�汾��:' + ValueByName('version', '') + '<BR/>' + '��Ȩ��' +
      ValueByName('copyright', '');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  adsData.CreateDataSet;
  adsData.DisableControls;
  try
    for I := 0 to 9 do
    begin
      adsData.Append;
      adsDataId.AsInteger := I;
      adsDataName.AsString := GetHumanName;
      adsData.Post;
    end;
  finally
    adsData.EnableControls;
  end;
  WebBrowser1.Navigate('about:blank');
end;

end.

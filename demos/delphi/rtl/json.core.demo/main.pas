unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Generics.Collections,
  System.Classes, Vcl.Graphics, System.JSON, System.Diagnostics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, qdac.serialize.core, qdac.JSON.core,
  Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button5: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
const
  // AText: String = '{"a":null,"b":123,"c":"string value","d":true,"e":false}';
  // ,"c":"string value","d":true,"e":false}';
  Count: Integer = 1000000;
  procedure DoTest(const AText: String);
  var
    ANode: TQJsonNode;
    D1, D2, D3: Int64;
    AJson: TJsonObject;
  begin
    Memo1.Lines.Add('Start parse ' + AText);
    Memo1.Update;
    var
    ABytes := TEncoding.Utf8.GetBytes(AText);
    D2 := TThread.GetTickCount64;
    for var I := 0 to Count - 1 do
    begin
      AJson := TJsonObject.Create;
      AJson.Parse(ABytes, 0);
      FreeAndNil(AJson);
    end;
    D2 := Int64(TThread.GetTickCount64) - D2;
    Memo1.Lines.Add('  System.JSON:' + D2.ToString + 'ms(100%)');

    ANode := TQJsonNode.Create;
    D1 := TThread.GetTickCount64;
    for var I := 0 to Count - 1 do
      ANode.AsJson := AText;
    D1 := Int64(TThread.GetTickCount64) - D1;
    Memo1.Lines.Add('  QJSON(Normal):' + D1.ToString + 'ms(' +
      FormatFloat('0.00', D1 * 100 / D2) + '%)');
    Memo1.Lines.Add('    Compare result:' + FormatFloat('0.00',
      (D2 - D1) * 100 / D2) + '%');

    D3 := Int64(TThread.GetTickCount64);
    for var I := 0 to Count - 1 do
      ANode.TryParse(AText, jsmForwardOnly);
    D3 := Int64(TThread.GetTickCount64) - D3;

    Memo1.Lines.Add('  QJSON(FowardOnly):' + D3.ToString + 'ms(' +
      FormatFloat('0.00', D3 * 100 / D2) + '%)');
    Memo1.Lines.Add('    Compare result:' + FormatFloat('0.00',
      (D2 - D3) * 100 / D2) + '%');

    Memo1.Update;
    ANode.Reset;
  end;

begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Start speed test...');
  DoTest('{"a":null}');
  DoTest('{"b":123456}');
  DoTest('{"c":true}');
  DoTest('{"d":false}');
  DoTest('{"a":null,"b":123,"c":"string value","d":true,"e":false}');
  Memo1.Lines.Add('Speed test done.');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AJson: TQJsonNode;
  D1, D2, D3: Cardinal;
const
  Count = 1000000;
  AJsonText =
    '[{"tid":"123456","name":"jone sim"},{"tid":"567890","name":"jone sim"}]';
begin
  AJson := TQJsonNode.Create;
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Before parse Cached Items =' +
    TQJsonStringCaches.Current.Count.ToString);
  Memo1.Update;
  TQJsonStringCaches.Current.KeepCaches := true;

  D2 := TThread.GetTickCount;
  for var I := 0 to Count - 1 do
    AJson.TryParse(AJsonText, jsmNormal);
  D2 := TThread.GetTickCount - D2;
  Memo1.Lines.Add('  Normal used time ' + D2.ToString + 'ms(100%)');
  Memo1.Update;
  D1 := TThread.GetTickCount;
  for var I := 0 to Count - 1 do
    AJson.TryParse(AJsonText, jsmCacheStrings);
  D1 := TThread.GetTickCount - D1;
  Memo1.Lines.Add('  CacheStrings used time ' + D1.ToString + 'ms(' +
    FormatFloat('0.00', D1 * 100 / D2) + '%)');
  Memo1.Update;
  var
    AData: TBytes := TEncoding.Utf8.GetBytes(AJsonText);
  D3 := TThread.GetTickCount;
  for var I := 0 to Count - 1 do
    TJsonValue.ParseJSONValue(AData, 0).Free;
  D3 := TThread.GetTickCount - D3;
  Memo1.Lines.Add('  System.JSON used time ' + D3.ToString + 'ms(' +
    FormatFloat('0.00', D3 * 100 / D2) + '%)');
  Memo1.Lines.Add('After parse Cached Items =' +
    TQJsonStringCaches.Current.Count.ToString);
  Memo1.Lines.Add(AJson.AsJson);
  AJson.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  AList: TArray<String>;
  D1, D2: Cardinal;
  function RandStr(L: Integer): String;
  begin
    SetLength(Result, L);
    while L > 0 do
    begin
      Result[L] := WideChar($20 + random(96));
      Dec(L);
    end;
  end;

begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Prepare 100,0000 test strings...');
  Memo1.Update;
  SetLength(AList, 1000000);
  for var I := 0 to High(AList) do
  begin
    AList[I] := RandStr(3 + random(100));
  end;
  Memo1.Lines.Add('System.Hashset testing...');
  Memo1.Update;
  var
  ASet := THashSet<String>.Create;
  D1 := TThread.GetTickCount;
  for var I := 0 to High(AList) do
    ASet.Add(AList[I]);
  D1 := TThread.GetTickCount - D1;
  FreeAndNil(ASet);
  Memo1.Lines.Add('System.Hashset used ' + D1.ToString + 'ms(100%)');
  Memo1.Lines.Add('QJsonStringCaches testing...');
  Memo1.Update;
  TQJsonStringCaches.Current.Clear;
  D2 := TThread.GetTickCount;
  for var I := 0 to High(AList) do
  begin
    TQJsonStringCaches.Current.AddRef(@AList[I]);
  end;
  D2 := TThread.GetTickCount - D2;
  Memo1.Lines.Add('FashHash used ' + D2.ToString + 'ms(' + FormatFloat('0.00',
    D2 * 100 / D1) + '%)');
  TQJsonStringCaches.Current.Clear;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  AJson: TQJsonNode;
  S: AnsiString;
begin
  S := '{"name":"吉林长春CBD中心A120室'#$A0'+"}';
  AJson := TQJsonNode.Create;
  AJson.TryParse(S);
  Memo1.Lines.Add(AJson.AsJson);
  AJson.Reset;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  AStream: TStream;
  AWriter: TQJsonEncoder;
begin
  Memo1.Lines.Clear;
  AStream := TBytesStream.Create;
  AWriter := TQJsonEncoder.Create(AStream, true, TQJsonEncoder.DefaultFormat,
    TEncoding.Utf8, 0);
  try
    AWriter.StartObject;
    AWriter.WritePair('allow', true);
    AWriter.WritePair('tid', 1920345);
    AWriter.WritePair('name', 'chelly');
    AWriter.StartArrayPair('cpu');
    AWriter.WriteValue(1978);
    AWriter.WriteValue(1979);
    AWriter.EndArray;
    AWriter.EndObject;
    AStream.Position := 0;
    Memo1.Lines.Add('Encoded json:');
    Memo1.Lines.Add(TEncoding.Utf8.GetString(TBytesStream(AStream).Bytes));
    var
      AJson: TQJsonNode;
    AStream.Position := 0;
    AJson := Default (TQJsonNode);
    AJson.LoadFromStream(AStream, jsmNormal, nil);
    Memo1.Lines.Add(AJson.AsJson);
    AJson.Reset;
  finally
    FreeAndNil(AWriter);
    FreeAndNil(AStream);
  end;
end;

end.

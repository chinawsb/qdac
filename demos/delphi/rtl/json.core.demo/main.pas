unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.TypInfo, System.Rtti,
  System.Generics.Collections, System.DateUtils, System.VarCmplx, Data.FMTBcd,
  System.Classes, Vcl.Graphics, System.JSON, System.Diagnostics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, qdac.attribute, qdac.serialize.core,
  qdac.JSON.core,
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
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TOrderStatus = (osUnknown, osBeforePay, osAfterPay, osPrinted, osSent,
    osSigned, osReject);
  [Prefix('ob')]
  TOrderBookmark = (obStep, obVip, obRefund, obBlocked);
  TOrderBookmarks = set of TOrderBookmark;
  TOrderFlags = set of 0 .. 5;

  [NameFormat(LowerCamel)]
  TSubscribeItem = record
    Code: String;
    Quantity: Integer;
  end;

  [NameFormat(LowerCamel), IncludeProps]
  TSubscribeOrder = record
  private
    function GetCount: Integer;
    procedure SetCount(const Value: Integer);
  public
    PackageId: Int64;
    Tid: String;
    Price: Currency;
    PackageWeight: Double;
    [FloatFormat('0.###')]
    PackageVolume: Single;
    CreateTime: TDateTime;
    [DateTimeFormat(UnixTimeStamp)]
    ConfirmTime: TDateTime;
    [Prefix('os')]
    Status: TOrderStatus;
    Paid: Boolean;
    [Alias('orderBookmarks')]
    Bookmarks: TOrderBookmarks;
    // Flags 这种定义不存在类型信息，序列化时会被忽略掉
    Flags: TOrderFlags;
    [Prefix('cl'), IdentFormatAttribute(LowerCamel)]
    Color: TColor;
    AsBcd: TBcd;
    Items: TArray<TSubscribeItem>;
    // IncludeProps 声明包含属性，但下面的 Exclude 排除 Count 属性，所以 Count 属性最终不会保存
    [Exclude]
    property Count: Integer read GetCount write SetCount;
  end;

  [IncludeProps]
  TDemoCollectionItem = class(TCollectionItem)
  private
    FName: String;
  public
    property Name: String read FName write FName;
  end;

  TDemoCollection = class(TOwnedCollection)
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);
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
  AOrders: TArray<TSubscribeOrder>;
  ATime: TDateTime;
const
  KnownColors: array [0 .. 5] of TColor = (clBlack, clRed, clYellow, clPurple,
    clBlue, clWhite);
begin
  SetLength(AOrders, 10);
  ATime := Now;
  for var I := 0 to High(AOrders) do
  begin
    AOrders[I].PackageId := 100000 + I * 1000 + random(100);
    AOrders[I].Tid := FormatDateTime('yymmdd-', ATime) +
      TStopWatch.GetTimeStamp.ToString;
    AOrders[I].Price := random(10000) / 100;
    AOrders[I].PackageWeight := random(100000) / 1000;
    AOrders[I].PackageVolume := random(10000) / 1000;
    AOrders[I].CreateTime := ATime - random(1000) / 1000;
    AOrders[I].ConfirmTime := ATime + (ATime - AOrders[I].CreateTime) *
      random(100) / 100;
    AOrders[I].Status := TOrderStatus(random(Ord(High(TOrderStatus)) + 1));
    AOrders[I].Paid := AOrders[I].Status >= TOrderStatus.osAfterPay;
    AOrders[I].Bookmarks := [obRefund, obVip];
    AOrders[I].Flags := [0, 4];
    AOrders[I].Color := KnownColors[random(6)];
    AOrders[I].AsBcd := random(MaxInt);
    SetLength(AOrders[I].Items, 1 + random(10));
    for var J := 0 to High(AOrders[I].Items) do
    begin
      AOrders[I].Items[J].Code := 'C' + Char(Ord('A') + random(25));
      AOrders[I].Items[J].Quantity := 1 + random(10);
    end;
  end;
  var
  AStream := TBytesStream.Create;
  // Use default format settings
  TQSerializer.Current.SaveToStream < TArray < TSubscribeOrder >>
    (AOrders, AStream, 'json');
  // More settings create new encoder and setup properties
  // var
  // AEncoder := TQJsonEncoder.Create(AStream, true, TQJsonEncoder.DefaultFormat,
  // TEncoding.Utf8, 0);
  // Caption := Length(AOrders).ToString;
  // TQSerializer.Current.FromRtti < TArray < TSubscribeOrder >>
  // (AEncoder, AOrders);
  AStream.Position := 0;
  Memo1.Lines.Add(TEncoding.Utf8.GetString(AStream.Bytes));
  FreeAndNil(AStream);
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  AStream: TStream;
  AWriter: TQJsonEncoder;
begin
  Memo1.Lines.Clear;
  AStream := TBytesStream.Create;
  var
  AFormat := TQJsonEncoder.DefaultFormat;
  AFormat.Settings := AFormat.Settings + [jesDoFormat];
  AWriter := TQJsonEncoder.Create(AStream, true, AFormat, TEncoding.Utf8, 0);
  try
    AWriter.StartObject;
    AWriter.WritePair('allow', true);
    AWriter.WritePair('tid', 1920345);
    AWriter.WritePair('name', 'chelly');
    AWriter.StartArrayPair('cpu');
    AWriter.WriteValue(1978);
    AWriter.WriteValue(1979);
    AWriter.WriteComment('this is a block comment'#13#10'auto created.');
    AWriter.WriteValue(1980);
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

procedure TForm1.Button6Click(Sender: TObject);
var
  AStream: TBytesStream;
  AList: TStringList;
begin
  AStream := TBytesStream.Create;
  AList := TStringList.Create;
  AList.AddStrings(['abc', 'def']);
  TQSerializer.Current.SaveToStream<TStrings>(AList, AStream, 'json');
  FreeAndNil(AList);
  AStream.Position := 0;
  Memo1.Lines.Add(TEncoding.Utf8.GetString(AStream.Bytes));
  FreeAndNil(AStream);
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  AStream: TBytesStream;
  AList: TList<String>;
begin
  AStream := TBytesStream.Create;
  AList := TList<String>.Create(['abc', 'def']);
  TQSerializer.Current.SaveToStream < TList < String >>
    (AList, AStream, 'json');
  FreeAndNil(AList);
  AStream.Position := 0;
  Memo1.Lines.Add(TEncoding.Utf8.GetString(AStream.Bytes));
  FreeAndNil(AStream);
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  ACollection: TDemoCollection;
  AStream: TBytesStream;
begin
  AStream := TBytesStream.Create;
  ACollection := TDemoCollection.Create(Self, TDemoCollectionItem);
  (ACollection.Add as TDemoCollectionItem).Name := 'abc';
  (ACollection.Add as TDemoCollectionItem).Name := 'def';
  TQSerializer.Current.SaveToStream<TDemoCollection>(ACollection,
    AStream, 'json');
  FreeAndNil(ACollection);
  AStream.Position := 0;
  Memo1.Lines.Add(TEncoding.Utf8.GetString(AStream.Bytes));
  FreeAndNil(AStream);
end;

{ TSubscribeOrder }

function TSubscribeOrder.GetCount: Integer;
begin
  Result := Length(Items);
end;

procedure TSubscribeOrder.SetCount(const Value: Integer);
begin
  SetLength(Items, Value);
end;

{ TDemoCollection }

constructor TDemoCollection.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass);
begin
  inherited;
end;

end.

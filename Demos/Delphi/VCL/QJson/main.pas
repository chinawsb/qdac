unit main;

interface

{$I 'qdac.inc'}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, NetEncoding,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, qstring, qjson;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    mmResult: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button9: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Invoke: TButton;
    Button17: TButton;
    Button19: TButton;
    Button18: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoCopyIf(ASender, AItem: TQJson; var Accept: Boolean;
      ATag: Pointer);
    procedure DoDeleteIf(ASender, AChild: TQJson; var Accept: Boolean;
      ATag: Pointer);
    procedure DoFindIf(ASender, AChild: TQJson; var Accept: Boolean;
      ATag: Pointer);
    procedure PrintRegexMatchResult(AItem: TQJson; ATag: Pointer);
  public
    { Public declarations }
    function Add(X, Y: Integer): Integer;
    function ObjectCall(AObject: TObject): String;
    procedure CharCall(s: PAnsiChar);
  end;

type
  TRttiTestSubRecord = record
    Int64Val: Int64;
    UInt64Val: UInt64;
    UStr: String;
    AStr: AnsiString;
    SStr: ShortString;
    IntVal: Integer;
    MethodVal: TNotifyEvent;
    SetVal: TBorderIcons;
    WordVal: Word;
    ByteVal: Byte;
    ObjVal: TObject;
    DtValue: TDateTime;
    tmValue: TTime;
    dValue: TDate;
    CardinalVal: Cardinal;
    ShortVal: Smallint;
    CurrVal: Currency;
    EnumVal: TAlign;
    CharVal: Char;
    VarVal: Variant;
    ArrayVal: TBytes;
{$IFDEF UNICODE}
    IntArray: TArray<Integer>;
{$ENDIF}
  end;

  TRttiUnionRecord = record
    case Integer of
      0:
        (iVal: Integer);
    // 1:(bVal:Boolean);
  end;

  TRttiTestRecord = record
    Name: QStringW;
    Id: Integer;
    SubRecord: TRttiTestSubRecord;
    UnionRecord: TRttiUnionRecord;
  end;

  // Test for user
  TTitleRecord = packed record
    Title: TFileName;
    Date: TDateTime;
  end;

  TTitleRecords = packed record
    Len: Integer;
    TitleRecord: array [0 .. 100] of TTitleRecord;
  end;

  TFixedRecordArray = array [0 .. 1] of TRttiUnionRecord;

  TRttiObjectRecord = record
    Obj: TStringList;
  end;

  TDeviceType = (dtSM3000, dtSM6000, dtSM6100, dtSM7000, dtSM8000);

  // ��λ����������
  TRCU_Cmd = record
    Id: string; // ����ID Ϊ����������豸����+.+INDEX
    DevcType: TDeviceType; // �豸���ͣ����� SM-6000
    Rcu_Kind: Integer; // �������
    Name: string; // �������ƣ�����̵���
    KEY_IDX: Integer; // ������������˫����ϼ���ֵ����255
    SHOW_IDX: Integer; // ��ʾ˳��
    Cmds: TArray<TArray<Byte>>; // �����ֽ�,�п����Ƕ��ģʽ
    // ����ֵ����
    ResultValue: string; // ����ֵ����Ĺ�ʽ��json���ʽ
    RCU_Type_ID: string; // ��������ID
    RCU_Type_Name: string; // �����������ƣ����� �� SM-6000
    // procedure Clear;
  end;

  // ������Ϣ����һ����ϵ�����
  TSence = record
    Name: string; // ��������
    Cmds: TArray<string>; // TArray<TPlc_Cmd>;
  end;

  // ÿ���ͷ���Ϣ
  TRoom = record
    Hotel_ID: string; // �Ƶ�ID
    Hotel_Code: string; // �Ƶ����
    Room_ID: string; // �ͷ�ID
    ROOM_Name: string; // ��ʵ�Ŀͷ�����
    // �ͷ���ţ�X��X��X��X�� = X.X.X.X
    Room_Code: string; // �ͷ��� Ϊ�˱��ڿͻ��˵��ã�Room_Code������
    RCU_Type_ID: string; // ���������豸
    RCU_Type_Name: string; // RCU����
    RCU_HOST: string;
    RCU_Port: string;
    Cmds: TArray<TRCU_Cmd>; // ԭʼ��������Ϣ
    // �ͷ�����豸��Ϣ�Լ��豸����
    // Cmd_Name_Ids:TNameValueRow;  // ID�����ƶ�Ӧ ������������ԭ��������
    // �Ƶ�ͷ���ĳ�����Ϣ��һ��������Ӧ��������
    Sences: TArray<TSence>;
    // procedure Clear;
  end;

type
  TUserInfo = record
    openid: string;
    nickname: string; // �û����ǳ�
    subscribe: Integer; // �û��Ƿ��ĸù��ںű�ʶ��ֵΪ0ʱ��������û�û�й�ע�ù��ںţ���ȡ����������Ϣ��
    sex: Integer; // �û����Ա�ֵΪ1ʱ�����ԣ�ֵΪ2ʱ��Ů�ԣ�ֵΪ0ʱ��δ֪
    city: string; // �û����ڳ���
    country: string; // �û����ڹ���
    province: string; // �û�����ʡ��
    language: string; // �û������ԣ���������Ϊzh_CN
    { �û�ͷ�����һ����ֵ����������ͷ���С����0��46��64��96��132��ֵ��ѡ��
      0����640*640������ͷ�񣩣��û�û��ͷ��ʱ����Ϊ�ա�
      ���û�����ͷ��ԭ��ͷ��URL��ʧЧ�� }
    headimgurl: string;
    subscribe_time: TDateTime; // �û���עʱ�䣬Ϊʱ���������û�����ι�ע����ȡ����עʱ��
    unionid: string; // ֻ�����û������ںŰ󶨵�΢�ſ���ƽ̨�ʺź󣬲Ż���ָ��ֶΡ�
    remark: string; // ���ں���Ӫ�߶Է�˿�ı�ע�����ں���Ӫ�߿���΢�Ź���ƽ̨�û��������Է�˿��ӱ�ע
    groupid: string; // �û����ڵķ���ID�����ݾɵ��û�����ӿڣ�
    tagid_list: string; // �û������ϵı�ǩID�б�
  end;

  TUserInfos = record
    user_info_list: TArray<TUserInfo>;
  end;

type
  Ta = record
    A: Integer;
    B: Integer;
  end;

  TTaArray = TArray<Ta>;

  TRe = record
    Id: Integer;
    Name: string;
    aryt: array of Ta; // TTaArray;
  end;

var
  Form1: TForm1;

implementation

uses typinfo{$IFDEF UNICODE}, rtti{$ENDIF};
{$R *.dfm}

function GetFileSize(AFileName: String): Int64;
var
  sr: TSearchRec;
  AHandle: Integer;
begin
  AHandle := FindFirst(AFileName, faAnyFile, sr);
  if AHandle = 0 then
  begin
    Result := sr.Size;
    FindClose(sr);
  end
  else
    Result := 0;
end;

function TForm1.Add(X, Y: Integer): Integer;
begin
  Result := X + Y;
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  AJson, AItem: TQJson;
  s: String;
begin
  AJson := TQJson.Create;
  try
    AJson.Add('Item1', 0);
    AJson.Add('Item2', true);
    AJson.Add('Item3', 1.23);
    for AItem in AJson do
    begin
      s := s + AItem.Name + ' => ' + AItem.AsString + #13#10;
    end;
    mmResult.Lines.Add(s);
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button11Click(Sender: TObject);
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  try
    // ǿ��·�����ʣ����·�������ڣ���ᴴ��·����·���ָ���������./\֮һ
    AJson.ForcePath('demo1.item[0].name').AsString := '1';
    AJson.ForcePath('demo1.item[1].name').AsString := '100';
    try
      ShowMessage('�����������׳�һ���쳣');
      AJson.ForcePath('demo1[0].item[1]').AsString := '200';
    except
      // ���Ӧ���׳��쳣��demo1�Ƕ��������飬�����Ǵ��
    end;
    // ���ʵ�6��Ԫ�أ�ǰ5��Ԫ�ػ��Զ�����Ϊnull
    AJson.ForcePath('demo2[5]').AsInteger := 103;
    // ǿ�ƴ���һ�����������Ȼ�����Add��������ӳ�Ա���������ƻᱻ���ԣ�����ʵ����demo3:[1.23]
    AJson.ForcePath('demo3[]').Add('Value', 1.23);
    // ����Ĵ��뽫����"demo4":[{"Name":"demo4"}]�Ľ��
    AJson.ForcePath('demo4[].Name').AsString := 'demo4';
    // ֱ��ǿ��·������
    AJson.ForcePath('demo5[0]').AsString := 'demo5';
    mmResult.Text := AJson.AsJson;
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
  AJson: TQJson;
  AList: TQJsonItemList;
begin
  AJson := TQJson.Create;
  try
    AJson.Parse('{' + '"object":{' + ' "name":"object_1",' + ' "subobj":{' +
      '   "name":"subobj_1"' + '   },' + ' "subarray":[1,3,4]' + ' },' +
      '"array":[100,200,300,{"name":"object"}]' + '}');
    mmResult.Lines.Add('[ԭʼJson����]');
    mmResult.Lines.Add(AJson.AsJson);
    mmResult.Lines.Add(#13#10 + '[���ҽ��]');
    AList := TQJsonItemList.Create;
    AJson.ItemByRegex('sub.+', AList, true);
    mmResult.Lines.Add('ItemByRegex�ҵ�' + IntToStr(AList.Count) + '�����');
    AList.Free;
    mmResult.Lines.Add('ItemByPath(''object\subobj\name'')=' +
      AJson.ItemByPath('object\subobj\name').AsString);
    mmResult.Lines.Add('ItemByPath(''object\subarray[1]'')=' +
      AJson.ItemByPath('object\subarray[1]').AsString);
    mmResult.Lines.Add('ItemByPath(''array[1]'')=' +
      AJson.ItemByPath('array[1]').AsString);
    mmResult.Lines.Add('ItemByPath(''array[3].name'')=' +
      AJson.ItemByPath('array[3].name').AsString);
    mmResult.Lines.Add('ItemByPath(''object[0]'')=' +
      AJson.ItemByPath('object[0]').AsString);
    mmResult.Lines.Add('ItemByName(''array[3][0]'')=' +
      AJson.ItemByPath('array[3][0]').AsString);
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button13Click(Sender: TObject);
{$IFNDEF UNICODE}
begin
  ShowMessage('��֧�ֵĹ���');
{$ELSE}
var
  AJson: TQJson;
  AValue: TValue;
begin
  AJson := TQJson.Create;
  try
    with AJson.Add('Add') do
    begin
      Add('X').AsInteger := 100;
      Add('Y').AsInteger := 200;
    end;
    AValue := AJson.ItemByName('Add').Invoke(Self);
    mmResult.Lines.Add(AJson.AsJson);
    mmResult.Lines.Add('.Invoke=' + IntToStr(AValue.AsInteger));
  finally
    AJson.Free;
  end;
{$ENDIF}
end;

procedure TForm1.Button15Click(Sender: TObject);
var
  AJson: TQJson;
  s: String;
begin
  AJson := TQJson.Create;
  try
    AJson.Add('Text').AsString := 'Hello,�й�';
    ShowMessage(AJson.Encode(true, true));
    AJson.Parse(AJson.Encode(true, true));
    ShowMessage(AJson.AsJson);
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button16Click(Sender: TObject);
var
  AJson: TQJson;
  procedure DoTry(s: QStringW);
  begin
    if AJson.TryParse(s) then
      ShowMessage(AJson.AsString)
    else
      ShowMessage('����ʧ��'#13#10 + s);
  end;

begin
  AJson := TQJson.Create;
  try
    DoTry('{aaa}');
    DoTry('{"aaa":100}');
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button17Click(Sender: TObject);
var
  AJson, AChild: TQJson;
  B: TBytes;
begin
  AJson := TQJson.Create;
  AJson.ForcePath('a.b.c[].d').AsString := 'OK';
  if AJson.HasChild('a.b.c[0].d', AChild) then
    mmResult.Text := AJson.AsJson + #13#10 + '�ӽ�� a.b.c[0].d ���ڣ�ֵΪ��' +
      AChild.AsString
  else
    mmResult.Text := AJson.AsJson + #13#10 + '�ӽ�� a.b.c[0].d ������';
  AJson.Free;
end;

procedure TForm1.Button18Click(Sender: TObject);
var
  AJson: TQJson;
  s: String;
  AStream: TMemoryStream;
  I: Integer;
begin
  AStream := TMemoryStream.Create;
  for I := 0 to 99 do
    AStream.Write(I, SizeOf(I));
  EncodeJsonBinaryAsBase64;
  AJson := TQJson.Create;
  AJson.Add('stream').ValueFromStream(AStream, 0);
  AJson.Add('code').AsInteger := 0;
  AJson.Add('message').AsString := '��ʹ�ÿͻ��˵�¼��';
  s := AJson.AsJson;
  mmResult.Clear;
  mmResult.Lines.Add('������ʹ�� Base64 �����С ' + IntToStr(s.Length) + ' ���ַ�');
  mmResult.Lines.Add(s);
  EncodeJsonBinaryAsHex;
  AJson.ItemByName('stream').ValueFromStream(AStream, 0);
  s := AJson.AsJson;
  mmResult.Lines.Add('������ʹ��16���Ʊ����С ' + IntToStr(s.Length) + ' ���ַ�');
  mmResult.Lines.Add(s);
  AJson.Free;
  AStream.Free;
end;

procedure TForm1.Button19Click(Sender: TObject);
var
  AJson: TQJson;
  s: String;
begin
  // ����Ĵ�����豣֤StrictJsonΪFalse����������ڲ�֧��ע�Ͷ�����
  AJson := TQJson.Create;
  s := '//This is demo'#13#10 + '{//Json Start'#13#10 +
    '"A"/*Name*/:/*Value Start*/"B"//Value End'#13#10 + '}'#13#10 +
    '//Json End'#13#10;
  AJson.Parse(s);
  mmResult.Text := '[ԭʼ����]'#13#10 + s + #13#10'[�������]'#13#10 + AJson.AsJson;
  AJson.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  AJson: TQJson;
  I: Integer;
  T: Cardinal;
begin
  AJson := TQJson.Create;
  try
    T := GetTickCount;
    for I := 0 to 100000 do
      AJson.Add('_' + IntToStr(I), Now);
    T := GetTickCount - T;
    mmResult.Clear;
    mmResult.Lines.Add('���100,000�������ʱ:' + IntToStr(T) + 'ms');
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button20Click(Sender: TObject);
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  try
    AJson.Add('name').AsString := 'id_1';
    AJson.Add('id').AsInteger := 100;
    with AJson.Add('object') do
    begin
      Add('color2').AsInteger := 1536;
      Add('color1').AsInteger := 1234;
    end;
    AJson.Add('price').AsFloat := 12.45;
    if AJson.ContainsName('color1', true) then
      ShowMessage('Contains color1');
    if AJson.ContainsValue('1536', true, true) then
      ShowMessage('Contains 1536');
    // AJson.Sort(False,True,jdtUnknown,nil);
    // AJson.RevertOrder(True);
    ShowMessage(AJson.AsString);
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button21Click(Sender: TObject);
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  try
    AJson.Parse
      ('//���ǿ�ע��'#13#10'{"id":1/*Object Id*/,"name":"objectname"//Object Name'#13#10',"array":[/*First*/1,2/*Second*/]}');
    ShowMessage(AJson.AsJson);
    AJson.CommentStyle := jcsBeforeName;
    ShowMessage(AJson.AsJson);
    AJson.CommentStyle := jcsAfterValue;
    ShowMessage(AJson.AsJson);
  finally
    FreeAndNil(AJson);
  end;

end;

procedure TForm1.Button22Click(Sender: TObject);
var
  AJson1, AJson2, AJson3: TQJson;
begin
  AJson1 := TQJson.Create;
  AJson2 := TQJson.Create;
  try
    AJson1.Parse('{a:100,b:20,c:"id"}');
    AJson2.Parse('{d:400,e:70,a:"from2"}');
    mmResult.Lines.Add('Json 1');
    mmResult.Lines.Add(AJson1.AsJson);
    mmResult.Lines.Add('Json 2');
    mmResult.Lines.Add(AJson2.AsJson);
    AJson3 := AJson1.Copy;
    AJson3.Merge(AJson2, jmmIgnore);
    mmResult.Lines.Add('Json1.Merge(Json2,jmmIgnore)');
    mmResult.Lines.Add(AJson3.AsJson);
    FreeAndNil(AJson3);
    AJson3 := AJson1.Copy;
    AJson3.Merge(AJson2, jmmAppend);
    mmResult.Lines.Add('Json1.Merge(Json2,jmmAppend)');
    mmResult.Lines.Add(AJson3.AsJson);
    FreeAndNil(AJson3);
    AJson3 := AJson1.Copy;
    AJson3.Merge(AJson2, jmmAsSource);
    mmResult.Lines.Add('Json1.Merge(Json2,jmmAsSource)');
    mmResult.Lines.Add(AJson3.AsJson);
    AJson3 := AJson1.Copy;
    AJson3.Merge(AJson2, jmmReplace);
    mmResult.Lines.Add('Json1.Merge(Json2,jmmReplace)');
    mmResult.Lines.Add(AJson3.AsJson);
    FreeAndNil(AJson3);
  finally
    FreeAndNil(AJson1);
    FreeAndNil(AJson2);
  end;
end;

procedure TForm1.Button23Click(Sender: TObject);
var
  AJson1, AJson2, AJson3: TQJson;
begin
  AJson1 := TQJson.Create;
  AJson2 := TQJson.Create;
  try
    AJson1.Parse('{a:100,b:20,c:"id"}');
    AJson2.Parse('{d:400,e:70,a:100}');
    mmResult.Lines.Add('Json 1');
    mmResult.Lines.Add(AJson1.AsJson);
    mmResult.Lines.Add('Json 2');
    mmResult.Lines.Add(AJson2.AsJson);
    AJson3 := AJson1.Intersect(AJson2);
    mmResult.Lines.Add('Result');
    mmResult.Lines.Add(AJson3.AsJson);
    FreeAndNil(AJson3);
  finally
    FreeAndNil(AJson1);
    FreeAndNil(AJson2);
  end;
end;

procedure TForm1.Button24Click(Sender: TObject);
var
  AJson1, AJson2, AJson3: TQJson;
begin
  AJson1 := TQJson.Create;
  AJson2 := TQJson.Create;
  try
    AJson1.Parse('{a:100,b:20,c:"id"}');
    AJson2.Parse('{d:400,e:70,a:100}');
    mmResult.Lines.Add('Json 1');
    mmResult.Lines.Add(AJson1.AsJson);
    mmResult.Lines.Add('Json 2');
    mmResult.Lines.Add(AJson2.AsJson);
    AJson3 := AJson1.Diff(AJson2);
    mmResult.Lines.Add('Result');
    mmResult.Lines.Add(AJson3.AsJson);
    FreeAndNil(AJson3);
  finally
    FreeAndNil(AJson1);
    FreeAndNil(AJson2);
  end;

end;

procedure TForm1.Button25Click(Sender: TObject);
var
  AJson:TQJson;
begin
  AJson:=AcquireJson;
  AJson.Parse('{"A":-3E2,"B":-2}');
  mmResult.Lines.Add('A='+AJson.Items[0].AsString+',B='+AJson.Items[1].AsString);
  ReleaseJson(AJson);
  // if DecodeBankNo('6212835005000180534',ABank,AId) then
  // ShowMessage('���д��룺'+ABank+' ���˴���:'+AId)
  // else
  // ShowMessage('��Ч�Ŀ���');
  // if DecodeBankNo('6226 6208 0391 5552',ABank,AId) then
  // ShowMessage('���д��룺'+ABank+' ���˴���:'+AId)
  // else
  // ShowMessage('��Ч�Ŀ���');
  // if DecodeBankNo('4367 4209 4324 0179 731',ABank,AId) then
  // ShowMessage('���д��룺'+ABank+' ���˴���:'+AId)
  // else
  // ShowMessage('��Ч�Ŀ���');
end;

procedure TForm1.Button26Click(Sender: TObject);
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  AJson.Parse('[1,2,true,false,''str'']');
  mmResult.Lines.Add('Index of Value 2=' + IntToStr(AJson.IndexOfValue(2)));
  mmResult.Lines.Add('Index of Value true=' +
    IntToStr(AJson.IndexOfValue(true, true)));
  mmResult.Lines.Add('Index of Value str=' +
    IntToStr(AJson.IndexOfValue('str')));
  FreeAndNil(AJson);
end;

procedure TForm1.Button27Click(Sender: TObject);
var
  J1, J2: TQJson;
begin
  J1 := TQJson.Create;
  J2 := TQJson.Create;
  try
    with J1.ForcePath('T1') do
    begin
      Add('T11').AsInteger := 100;
      Add('T12').AsString := 'T12';
    end;
    with J2.ForcePath('T1') do
    begin
      Add('T11').AsInteger := 200;
      Add('T22').AsString := 'T12';
    end;
    J1.Merge(J2, TQJsonMergeMethod.jmmReplace);
    ShowMessage(J1.AsJson);
  finally
    FreeAndNil(J1);
    FreeAndNil(J2);
  end;
end;

procedure TForm1.Button28Click(Sender: TObject);
var
  AJson, AItem: TQJson;
begin
  AJson := TQJson.Create;
  try
    AJson.Parse
      ('[{"code":"GTO","name":"��ͨ"},{"code":"STO","name":"��ͨ"},{"code":"YTO","name":"�ϴ�"}]');
    mmResult.Lines.Add(AJson.AsJson);
    mmResult.Lines.Add('���ҷ���Ҫ��Ľ��:');
{$IFDEF UNICODE}
    mmResult.Lines.Add('ForEach ģʽ');
    AJson.Match('.+ͨ', [jmsMatchValue, jmsNest]).ForEach(
      procedure(AItem: TQJson)
      begin
        mmResult.Lines.Add(AItem.Path + '=>' + AItem.AsString);
      end);
    mmResult.Lines.Add('For..In ģʽ');
    for AItem in AJson.Match('.+ͨ', [jmsMatchValue, jmsNest]) do
    begin
      mmResult.Lines.Add(AItem.Path + '=>' + AItem.AsString);
    end

{$ELSE}
    AJson.Match('.+ͨ', [jmsMatchValue, jmsNest])
      .ForEach(PrintRegexMatchResult, nil);
{$ENDIF}
  finally
    FreeAndNil(AJson);
  end;

end;

procedure TForm1.Button29Click(Sender: TObject);
var
  AJson: TQJson;
begin
  AJson := AcquireJson;
  try
    AJson.DataType := jdtArray;
    AJson.Add.AsString := 'First Item';
    AJson.Add.AsString := 'Second Item';
    AJson.Add.AsString := 'Third Item';
    AJson.Add.AsString := '';
    AJson.Add;
    AJson.Add.AsString := 'First Item';
    AJson.Add.AsInteger := 100;
    mmResult.Lines.Add('Ĭ����� :' + AJson.CatValues('"', ',', []));
    mmResult.Lines.Add('�����ظ� :' + AJson.CatValues('"', ',',
      [coIgnoreDuplicates]));
    mmResult.Lines.Add('���Կհ� :' + AJson.CatValues('"', ',', [coIgnoreEmpty]));
    mmResult.Lines.Add('�����ظ�+�հ� :' + AJson.CatValues('"', ',',
      [coIgnoreDuplicates, coIgnoreEmpty]));
    mmResult.Lines.Add
      ('�����÷����ο� TQJson �� CatValues,CateNames,FlatNames,FlatValues,NameToStrings,ValueToStrings ����');

  finally
    ReleaseJson(AJson);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  AJson: TQJson;
  TestRecord: TRttiTestRecord;
begin
  AJson := TQJson.Create;
  try
    TestRecord.Id := 10001;
    TestRecord.Name := 'Complex Record';
    TestRecord.UnionRecord.iVal := 100;
    TestRecord.SubRecord.Int64Val := 1;
    TestRecord.SubRecord.UInt64Val := 2;
    TestRecord.SubRecord.UStr := 'Test String';
    TestRecord.SubRecord.IntVal := 3;
    TestRecord.SubRecord.MethodVal := Button2Click;
    TestRecord.SubRecord.SetVal :=
      [{$IFDEF UNICODE}TBorderIcon.{$ENDIF}biSystemMenu];
    TestRecord.SubRecord.WordVal := 4;
    TestRecord.SubRecord.ByteVal := 5;
    TestRecord.SubRecord.ObjVal := Button2;
    TestRecord.SubRecord.DtValue := Now;
    TestRecord.SubRecord.tmValue := Time;
    TestRecord.SubRecord.dValue := Now;
    TestRecord.SubRecord.CardinalVal := 6;
    TestRecord.SubRecord.ShortVal := 7;
    TestRecord.SubRecord.CurrVal := 8.9;
    TestRecord.SubRecord.EnumVal := {$IFDEF UNICODE}TAlign.{$ENDIF}alTop;
    TestRecord.SubRecord.CharVal := 'A';
    TestRecord.SubRecord.VarVal :=
      VarArrayOf(['VariantArray', 1, 2.5, true, false]);
    SetLength(TestRecord.SubRecord.ArrayVal, 3);
    TestRecord.SubRecord.ArrayVal[0] := 100;
    TestRecord.SubRecord.ArrayVal[1] := 101;
    TestRecord.SubRecord.ArrayVal[2] := 102;
    AJson.Add('IP', '192.168.1.1', jdtString);
    with AJson.Add('FixedTypes') do
    begin
      AddDateTime('DateTime', Now);
      Add('Integer', 1000);
      Add('Boolean', true);
      Add('Float', 1.23);
      Add('Array', [1, 'goods', true, 3.4]);
{$IFDEF UNICODE}
      Add('RTTIObject').FromRtti(Button2);
      Add('RTTIRecord').FromRecord(TestRecord);
{$ENDIF}
    end;
    with AJson.Add('AutoTypes') do
    begin
      Add('Integer', '-100', jdtUnknown);
      Add('Float', '-12.3', jdtUnknown);
      Add('Array', '[2,''goods'',true,4.5]', jdtUnknown);
      Add('Object', '{"Name":"Object_Name","Value":"Object_Value"}',
        jdtUnknown);
      Add('ForceArrayAsString', '[2,''goods'',true,4.5]', jdtString);
      Add('ForceObjectAsString',
        '{"Name":"Object_Name","Value":"Object_Value"}', jdtString);
    end;
    with AJson.Add('AsTypes') do
    begin
      Add('Integer').AsInteger := 123;
      Add('Float').AsFloat := 5.6;
      Add('Boolean').AsBoolean := false;
      Add('VarArray').AsVariant := VarArrayOf([9, 10, 11, 2]);
      Add('Array').AsArray := '[10,3,22,99]';
      Add('Object').AsObject := '{"Name":"Object_2","Value":"Value_2"}';
    end;
    mmResult.Clear;
    mmResult.Lines.Add('��Ӳ��Խ��:');
    mmResult.Lines.Add(AJson.Encode(true));
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button30Click(Sender: TObject);
var
  AJson:TQJson;
begin
  AJson:=AcquireJson;
  try
    AJson.ValuesFromStrings(['Hello,world','Helow,earth','Hello,me'],true,0,MaxInt);//��������������Ĭ��ֵ
    mmResult.Text:=AJson.AsJson;
    AJson.ValuesFromIntegers([1,3,4,5]);
    mmResult.Lines.Add(AJson.AsJson);
  finally
    ReleaseJson(AJson);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  AJson: TQJson;
  T: Cardinal;
  Speed: Cardinal;
  procedure PreCache;
  var
    AStream: TMemoryStream;
  begin
    AStream := TMemoryStream.Create;
    try
      AStream.LoadFromFile(OpenDialog1.FileName);
    finally
      AStream.Free;
    end;
  end;

begin
  if OpenDialog1.Execute then
  begin
    // uJsonTest;
    AJson := TQJson.Create;
    try
      T := GetTickCount;
      AJson.LoadFromFile(OpenDialog1.FileName);
      T := GetTickCount - T;
      if T > 0 then
        Speed := (GetFileSize(OpenDialog1.FileName) * 1000 div T)
      else
        Speed := 0;
      mmResult.Clear;
      // mmResult.Lines.Add('���ص�JSON�ļ����ݣ�');
      mmResult.Lines.Add(AJson.Encode(true));
      mmResult.Lines.Add('QJson������ʱ:' + IntToStr(T) + 'ms���ٶ�:' +
        RollupSize(Speed));
    finally
      AJson.Free;
    end;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  AJson: TQJson;
  J: Integer;
  T1, T2: Cardinal;
  Speed: Cardinal;
begin
  if SaveDialog1.Execute then
  begin
    AJson := TQJson.Create;
    try
      mmResult.Clear;
      T1 := GetTickCount;
      with AJson.Add('Integers', jdtObject) do
      begin
        for J := 0 to 2000000 do
          Add('Node' + IntToStr(J)).AsInteger := J;
      end;
      T1 := GetTickCount - T1;
      T2 := GetTickCount;
      AJson.SaveToFile(SaveDialog1.FileName, teAnsi, false);
      T2 := GetTickCount - T2;
      if T2 > 0 then
        Speed := (GetFileSize(SaveDialog1.FileName) * 1000 div T2)
      else
        Speed := 0;
      mmResult.Lines.Add('����200������ʱ' + IntToStr(T1) + 'ms,������ʱ:' + IntToStr(T2)
        + 'ms���ٶȣ�' + RollupSize(Speed));
    finally
      AJson.Free;
    end;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  AJson: TQJson;
begin
  AJson := TQJson.Create;
  try
    AJson.Parse(mmResult.Text);
    ShowMessage(AJson.Encode(true));
  finally
    AJson.Free;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  ARec: TRttiTestSubRecord;
  AJson, ACopy: TQJson;
begin
{$IFNDEF UNICODE}
  ShowMessage('�������ڵ�ǰIDE�в���֧��.');
{$ELSE}
  ARec.Int64Val := 1;
  ARec.UInt64Val := 2;
  ARec.UStr := 'Test String';
  ARec.AStr := 'AnsiString';
  ARec.SStr := 'ShortString';
  ARec.IntVal := 3;
  ARec.MethodVal := Button2Click;
  ARec.SetVal := [{$IFDEF UNICODE}TBorderIcon.{$ENDIF}biSystemMenu];
  ARec.WordVal := 4;
  ARec.ByteVal := 5;
  ARec.ObjVal := Button2;
  ARec.DtValue := Now;
  ARec.tmValue := Time;
  ARec.dValue := Now;
  ARec.CardinalVal := 6;
  ARec.ShortVal := 7;
  ARec.CurrVal := 8.9;
  ARec.EnumVal := {$IFDEF UNICODE}TAlign.{$ENDIF}alTop;
  ARec.CharVal := 'A';
  ARec.VarVal := VarArrayOf(['VariantArray', 1, 2.5, true, false]);
  SetLength(ARec.ArrayVal, 3);
  ARec.ArrayVal[0] := 100;
  ARec.ArrayVal[1] := 101;
  ARec.ArrayVal[2] := 102;
  SetLength(ARec.IntArray, 2);
  ARec.IntArray[0] := 300;
  ARec.IntArray[1] := 200;
  AJson := TQJson.Create;
  try
{$IFDEF UNICODE}
    AJson.Add('Record').FromRecord(ARec);
    ACopy := AJson.ItemByName('Record').Copy;
    ACopy.ItemByName('Int64Val').AsInt64 := 100;
    ACopy.ItemByPath('UStr').AsString := 'UnicodeString-ByJson';
    ACopy.ItemByPath('AStr').AsString := 'AnsiString-ByJson';
    ACopy.ItemByPath('SStr').AsString := 'ShortString-ByJson';
    ACopy.ItemByPath('EnumVal').AsString := 'alBottom';
    ACopy.ItemByPath('SetVal').AsString := '[biHelp]';
    ACopy.ItemByPath('ArrayVal').AsJson := '[10,30,15]';
    ACopy.ItemByPath('VarVal').AsVariant :=
      VarArrayOf(['By Json', 3, 4, false, true]);
    ACopy.ToRecord<TRttiTestSubRecord>(ARec);
    ACopy.Free;
    AJson.Add('NewRecord').FromRecord(ARec);
{$ENDIF}
    mmResult.Lines.Add(AJson.AsJson);
  finally
    AJson.Free;
  end;
{$ENDIF}
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  AStream: TMemoryStream;
  AJson: TQJson;
  s: QStringW;
  AEncode: TTextEncoding;
begin
  AStream := TMemoryStream.Create;
  AJson := TQJson.Create;
  try
    AJson.DataType := jdtObject;
    s := '{"record1":{"id":100,"name":"name1"}}'#13#10 +
      '{"record2":{"id":200,"name":"name2"}}'#13#10 +
      '{"record3":{"id":300,"name":"name3"}}'#13#10;
    // UCS2
    mmResult.Lines.Add('Unicode 16 LE����:');
    AEncode := teUnicode16LE;
    AStream.Size := 0;
    SaveTextW(AStream, s, false);
    AStream.Position := 0;
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add('��һ�ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�����ν������:');
    mmResult.Lines.Add(AJson.AsJson);
    // UTF-8
    mmResult.Lines.Add('UTF8����:');
    AEncode := teUtf8;
    AStream.Size := 0;
    SaveTextU(AStream, qstring.Utf8Encode(s), false);
    AStream.Position := 0;
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'��һ�ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�����ν������:');
    mmResult.Lines.Add(AJson.AsJson);
    // ANSI
    mmResult.Lines.Add(#13#10'ANSI����:');
    AEncode := teAnsi;
    AStream.Size := 0;
    SaveTextA(AStream, qstring.AnsiEncode(s));
    AStream.Position := 0;
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add('��һ�ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�����ν������:');
    mmResult.Lines.Add(AJson.AsJson);
    // UCS2BE
    mmResult.Lines.Add(#13#10'Unicode16BE����:');
    AEncode := teUnicode16BE;
    AStream.Size := 0;
    SaveTextWBE(AStream, s, false);
    AStream.Position := 0;
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add('��һ�ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�ڶ��ν������:'#13#10);
    mmResult.Lines.Add(AJson.AsJson);
    AJson.Clear;
    AJson.ParseBlock(AStream, AEncode);
    mmResult.Lines.Add(#13#10'�����ν������:');
    mmResult.Lines.Add(AJson.AsJson);
  finally
    AStream.Free;
    AJson.Free;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  AJson, AItem: TQJson;
  J: Integer;
  DynArray: array of Integer;
  RecordArray: array of TRttiUnionRecord;
begin
  AJson := TQJson.Create;
  try
    // �������Ԫ�ص�N�ַ�ʽ��ʾ
    // 1. ֱ�ӵ���Add����Ԫ���ı��ķ�ʽ
    AJson.Add('AddArrayText', '["Item1",100,null,true,false,123.4]', jdtArray);
    // jdtArray���ʡ�Ի��Զ����ԣ������ȷ֪�����Ͳ�Ҫ�����ж����ӿ���
    // 2. ֱ���������
    AJson.Add('AddArray', ['Item1', 100, Null, true, false, 123.4]);
    // 3. ֱ����VarArrayOf��ֵ
    AJson.Add('AsVariant').AsVariant :=
      VarArrayOf(['Item1', 100, Null, true, false, 123.4]);
    // ���ڶ�̬���飬����
    SetLength(DynArray, 5);
    DynArray[0] := 100;
    DynArray[1] := 200;
    DynArray[2] := 300;
    DynArray[3] := 400;
    DynArray[4] := 500;
    AJson.Add('DynArray').AsVariant := DynArray;
{$IFDEF UNICODE}
    SetLength(RecordArray, 2);
    RecordArray[0].iVal := 1;
    RecordArray[1].iVal := 2;
    with AJson.Add('RecordArray', jdtArray) do
    begin
      for J := 0 to High(RecordArray) do
        Add.FromRecord(RecordArray[J]);
    end;
{$ENDIF}
    // AJson.Add('RecordArray').AsVariant:=RecordArray;
    // 4. ֱ����AsArray�����������ļ�
    AJson.Add('AsArray').AsArray := '["Item1",100,null,true,false,123.4]';
    // 5. �ֶ�������Ԫ��
    with AJson.Add('Manul') do
    begin
      DataType := jdtArray;
      Add.AsString := 'Item1';
      Add.AsInteger := 100;
      Add;
      Add.AsBoolean := true;
      Add.AsBoolean := false;
      Add.AsFloat := 123.4;
    end;
    // ��Ӷ���������������ͣ�ֻ���ӽ�㻻���Ƕ���Ϳ�����
    AJson.Add('Object', [TQJson.Create.Add('Item1', 100).Parent,
      TQJson.Create.Add('Item2', true).Parent]);
    mmResult.Lines.Add(AJson.AsJson);
    // ���������е�Ԫ��
    mmResult.Lines.Add('ʹ��for inö������Manul��Ԫ��ֵ');
    J := 0;
    for AItem in AJson.ItemByName('Manul') do
    begin
      mmResult.Lines.Add('Manul[' + IntToStr(J) + ']=' + AItem.AsString);
      Inc(J);
    end;
    mmResult.Lines.Add('ʹ����ͨforѭ��ö������Manul��Ԫ��ֵ');
    AItem := AJson.ItemByName('Manul');
    for J := 0 to AItem.Count - 1 do
      mmResult.Lines.Add('Manul[' + IntToStr(J) + ']=' + AItem[J].AsString);
  finally
    FreeObject(AJson);
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  AJson, AItem: TQJson;
begin
  AJson := TQJson.Create;
  try
    AJson.Parse('{' + '"object":{' + ' "name":"object_1",' + ' "subobj":{' +
      '   "name":"subobj_1"' + '   },' + ' "subarray":[1,3,4]' + ' },' +
      '"array":[100,200,300,{"name":"object"}]' + '}');
{$IFDEF UNICODE}
    AItem := AJson.CopyIf(nil,
      procedure(ASender, AChild: TQJson; var Accept: Boolean; ATag: Pointer)
      begin
        Accept := (AChild.DataType <> jdtArray);
      end);
{$ELSE}
    AItem := AJson.CopyIf(nil, DoCopyIf);
{$ENDIF}
    mmResult.Lines.Add('CopyIf�����Ƴ�����������������н��');
    mmResult.Lines.Add(AItem.AsJson);
    mmResult.Lines.Add('FindIf������ָ���Ľ��');
{$IFDEF UNICODE}
    mmResult.Lines.Add(AItem.FindIf(nil, true,
      procedure(ASender, AChild: TQJson; var Accept: Boolean; ATag: Pointer)
      begin
        Accept := (AChild.Name = 'subobj');
      end).AsJson);
{$ELSE}
    mmResult.Lines.Add(AItem.FindIf(nil, true, DoFindIf).AsJson);
{$ENDIF}
    mmResult.Lines.Add('ɾ���������е�subobj���');
{$IFDEF UNICODE}
    AItem.DeleteIf(nil, true,
      procedure(ASender, AChild: TQJson; var Accept: Boolean; ATag: Pointer)
      begin
        Accept := (AChild.Name = 'subobj');
      end);
{$ELSE}
    AItem.DeleteIf(nil, true, DoDeleteIf);
{$ENDIF}
    mmResult.Lines.Add(AItem.AsJson);
  finally
    FreeObject(AItem);
    FreeObject(AJson);
  end;
end;

procedure TForm1.CharCall(s: PAnsiChar);
begin
  ShowMessage(s);
end;

procedure TForm1.DoCopyIf(ASender, AItem: TQJson; var Accept: Boolean;
ATag: Pointer);
begin
  Accept := (AItem.DataType <> jdtArray);
end;

procedure TForm1.DoDeleteIf(ASender, AChild: TQJson; var Accept: Boolean;
ATag: Pointer);
begin
  Accept := (AChild.Name = 'subobj');
end;

procedure TForm1.DoFindIf(ASender, AChild: TQJson; var Accept: Boolean;
ATag: Pointer);
begin
  Accept := (AChild.Name = 'subobj');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := true;
end;

function TForm1.ObjectCall(AObject: TObject): String;
begin
  Result := AObject.ToString;
end;

procedure TForm1.Panel1Click(Sender: TObject);
var
  AJson: TQJson;
begin
  // StrictJson:=True;
  AJson := TQJson.Create;
  try
    AJson.Parse('{"value":1.0}');
    ShowMessage(AJson.IntByName('value', 0).ToString);
  finally
    AJson.Free;
  end;
end;

procedure TForm1.PrintRegexMatchResult(AItem: TQJson; ATag: Pointer);
begin
  mmResult.Lines.Add(AItem.Path + '=>' + AItem.AsString);
end;

end.

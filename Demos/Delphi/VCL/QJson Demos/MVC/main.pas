unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, typinfo,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Rtti,
  System.Generics.Collections, qstring, QJson;

type
  TForm3 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
{$M+}

  TQMVCSerializeAttr = (NeedInclude, NeedExclude { 将指定的内容排除在序列化之列 } ,
    MustExists { 反序列化时，指定的属性值不允许缺失 } );

  TQMVCSerializeAttrs = set of TQMVCSerializeAttr;

  TQMVCAttrType = (Alias, Default, Excludes, Includes, Custom);

  QMVCAttribute = class(TCustomAttribute)
  private
    FName: String;
    FValue: Variant;
    FAttrType: TQMVCAttrType;
    FAttrs: TQMVCSerializeAttrs;
  public
    constructor Create(AName, AValue: String); overload;
    constructor Create(AType: TQMVCAttrType; AValue: String); overload;
    constructor Create(Attrs: TQMVCSerializeAttrs); overload;
    function ToInt(ADef: Integer): Integer;
    function ToInt64(ADef: Int64): Int64;
    function ToFloat(ADef: Double): Double;
    function ToBool(ADef: Boolean): Boolean;
    function ToEnum(AType: PTypeInfo; ADef: Integer): Integer;
    function ToSet(AType: PTypeInfo; AVal: Integer): Integer;
    property Name: String read FName;
    property Value: Variant read FValue;
    property Attrs: TQMVCSerializeAttrs read FAttrs;
    property AttrType: TQMVCAttrType read FAttrType;
  end;

  // 要求包含TypeId这个只读的属性值
  [QMVC(Includes, 'TypeId')]
  TChildObject = class
  private
    FName: String;
    // 要求将私有的成员导出到JSON
    [QMVC(Alias, 'State'), QMVC(Default, '0')]
    FState: Integer;
    FType: Integer;
  public
    //保存到JSON时使用ObjName为名称，而不是Name
    [QMVC(Alias, 'ObjName')]
    property Name: String read FName write FName;
    property TypeId: Integer read FType;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

type
  TQSerializeItem = record
    Alias: String;
    Member: TRttiMember;
    Attrs: TQMVCSerializeAttrs;
  end;

  // 保存信息到JSON中，基于RTTI
procedure SaveToJson(AInstance: Pointer; AType: PTypeInfo; AJson: TQJson);
var
  AItems: TArray<TQSerializeItem>;
  ARttiCtx: TRttiContext;
  ARttiType: TRttiType;
  AFields: TArray<TRttiField>;
  AProps: TArray<TRttiProperty>;
  procedure Prepare;
  var
    AExcludes: String;
    AIncludes: String;
    Attrs: TArray<TCustomAttribute>;
    I, J, C: Integer;
    AIncluded: Boolean;
  begin
    ARttiCtx := TRttiContext.Create;
    ARttiType := ARttiCtx.GetType(AType);
    if Assigned(ARttiType) then
    begin
      Attrs := ARttiType.GetAttributes;
      // 找到它的属性定义，看看有没有要明确排除和明确包含的值列表
      for I := 0 to High(Attrs) do
      begin
        if Attrs[I] is QMVCAttribute then
        begin
          with Attrs[I] as QMVCAttribute do
          begin
            if AttrType = Includes then
              AIncludes := AIncludes + Value + ','
            else if AttrType = Excludes then
              AExcludes := AExcludes + Value + ',';
          end;
        end;
      end;
      AFields := ARttiType.GetFields;
      AProps := ARttiType.GetProperties;
      C := 0;
      SetLength(AItems, Length(AFields) + Length(AProps));
      // 检查需要序列化的非属性字段
      for I := 0 to High(AFields) do
      begin
        if StrStrW(PQCharW(AExcludes), PQCharW(AFields[I].Name + ',')) <> nil
        then
          continue
        else
        begin
          AIncluded := false;
          if (Length(AIncludes) > 0) and
            (StrStrW(PQCharW(AIncludes), PQCharW(AFields[I].Name + ',')) <> nil)
          then
            AIncluded := true;
        end;
        Attrs := AFields[I].GetAttributes;
        if Length(Attrs) > 0 then
        begin
          for J := 0 to High(Attrs) do
          begin
            if Attrs[J] is QMVCAttribute then
            begin
              with Attrs[J] as QMVCAttribute do
              begin
                if NeedInclude in Attrs then
                  AIncluded := true;
                if AttrType = Alias then
                begin
                  AItems[C].Alias := Value;
                  AIncluded := true;
                end;
                if AIncluded then
                  AItems[C].Attrs := AItems[C].Attrs + Attrs;
              end;
            end;
          end;
          if AIncluded then
          begin
            AItems[C].Member := AFields[I];
            Inc(C);
          end;
        end;
      end;
      // 检查需要非序列化的可读写属性字段
      for I := 0 to High(AProps) do
      begin
        if AProps[I].IsReadable then
        begin
          Attrs := AProps[I].GetAttributes;
          if StrStrW(PQCharW(AExcludes), PQCharW(AProps[I].Name + ',')) <> nil
          then
            continue
          else
          begin
            AIncluded := AProps[I].IsWritable;;
            if (Length(AIncludes) > 0) and
              (StrStrW(PQCharW(AIncludes), PQCharW(AProps[I].Name + ',')) <> nil)
            then
              AIncluded := true;
          end;
          if Length(Attrs) > 0 then
          begin
            for J := 0 to High(Attrs) do
            begin
              if Attrs[J] is QMVCAttribute then
              begin
                with Attrs[J] as QMVCAttribute do
                begin
                  if NeedExclude in Attrs then
                  begin
                    AIncluded := false;
                    break;
                  end;
                  if AttrType = Alias then
                    AItems[C].Alias := Value;
                  if AIncluded then
                    AItems[C].Attrs := AItems[C].Attrs + Attrs;
                end;
              end;
            end;
          end;
          if AIncluded then
          begin
            AItems[C].Member := AProps[I];
            Inc(C);
          end;
        end;
      end;
    end;
    SetLength(AItems, C);
  end;

  procedure DoSerialize;
  var
    I, J, C: Integer;
    AName: String;
    ANode: TQJson;
    AField: TRttiField;
    AProp: TRttiProperty;
    AValue: TValue;
    AKind: TTypeKind;
  begin
    for I := 0 to High(AItems) do
    begin
      with AItems[I] do
      begin
        if Length(Alias) > 0 then
          ANode := AJson.Add(Alias)
        else
          ANode := AJson.Add(Member.Name);
        if Member is TRttiField then
        begin
          with Member as TRttiField do
          begin
            AValue := GetValue(AInstance);
            AKind := FieldType.TypeKind;
          end;
        end
        else
        begin
          with Member as TRttiProperty do
          begin
            AValue := GetValue(AInstance);
            AKind := PropertyType.TypeKind;
          end;
        end;
      end;
      case AKind of
        tkInteger:
          ANode.AsInteger := AValue.AsInteger;
        tkChar:
          ANode.AsString := AValue.AsString;
        tkEnumeration:
          ANode.AsString := AValue.AsString;
        tkFloat:
          ANode.AsFloat := AValue.AsExtended;
        tkString:
          ANode.AsString := AValue.AsString;
        tkSet:
          ANode.AsString := AValue.AsString;
        tkClass:
          SaveToJson(AValue.AsObject, AValue.AsObject.ClassInfo, ANode);
        tkWChar:
          ANode.AsString := AValue.AsString;
        tkLString:
          ANode.AsString := AValue.AsString;
        tkWString:
          ANode.AsString := AValue.AsString;
        tkVariant:
          ANode.AsVariant := AValue.AsVariant;
        tkArray:
          begin
            ANode.DataType := jdtArray;
            C := AValue.GetArrayLength;
            for J := 0 to C - 1 do
            begin
              // SaveToJson(AValue.get
            end;
            // Do nothing now
          end;
        tkRecord:
          SaveToJson(AValue.GetReferenceToRawData, AValue.TypeInfo, ANode);
        tkInterface:
          ;
        tkInt64:
          ANode.AsInt64 := AValue.AsInt64;
        tkDynArray:
          ;
        tkUString:
          ANode.AsString := AValue.AsString;
        tkClassRef:
          ;
        tkPointer:
          ;
        tkProcedure:
          ;
      end;
    end;
  end;

begin
  Prepare;
  DoSerialize;
end;

procedure SaveObject(AObj: TObject; AJson: TQJson);
begin
  // 默认规则：默认published中读写的属性会序列化，除非被标记为Exclude或包含在类型的Excludes里
  SaveToJson(AObj, AObj.ClassInfo, AJson);
end;

procedure TForm3.Button1Click(Sender: TObject);
var
  AJson: TQJson;
  AObj: TChildObject;
begin
  AObj := TChildObject.Create;
  AObj.FName := 'Good';
  AObj.FType := 100;
  AJson := TQJson.Create;
  SaveToJson(AObj, AObj.ClassInfo, AJson);
  ShowMessage(AJson.AsJson);
  FreeAndNil(AJson);
  FreeAndNil(AObj);
end;

{ QMVCAttr }

constructor QMVCAttribute.Create(AName, AValue: String);
begin
  inherited Create;
  FName := LowerCase(AName);
  if FName = 'name' then
    FAttrType := Alias
  else if FName = 'default' then
    FAttrType := Default
  else if FName = 'excludes' then
    FAttrType := Excludes
  else if FName = 'includes' then
    FAttrType := Includes;
  FValue := AValue;
  FAttrs := [NeedInclude];
end;

constructor QMVCAttribute.Create(Attrs: TQMVCSerializeAttrs);
begin
  inherited Create;
  FAttrs := Attrs;
end;

function QMVCAttribute.ToBool(ADef: Boolean): Boolean;
begin

end;

function QMVCAttribute.ToEnum(AType: PTypeInfo; ADef: Integer): Integer;
begin

end;

function QMVCAttribute.ToFloat(ADef: Double): Double;
begin
  Result := StrToFloatDef(Value, ADef);
end;

function QMVCAttribute.ToInt(ADef: Integer): Integer;
begin
  Result := StrToIntDef(Value, ADef);
end;

function QMVCAttribute.ToInt64(ADef: Int64): Int64;
begin
  Result := StrToInt64Def(Value, ADef);
end;

function QMVCAttribute.ToSet(AType: PTypeInfo; AVal: Integer): Integer;
begin

end;

constructor QMVCAttribute.Create(AType: TQMVCAttrType; AValue: String);
begin
  inherited Create;
  FAttrType := AType;
  FValue := AValue;
  case AType of
    Alias:
      FName := 'name';
    Default:
      FName := 'default';
    Excludes:
      FName := 'excludes';
    Includes:
      FName := 'includes';
    Custom:
      FName := 'custom';
  end;
end;

end.

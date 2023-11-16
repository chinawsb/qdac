/// <summary>
/// һ���򵥵�ͨ�ý���ת����Ԫ����Ȼ����һЩЧ���Ż������϶���Ҫָ����ר�õĴ����ƴЧ�ʡ�������2007����ǰ�İ汾��ӳ���ַ���Ҫʹ�ö��ֽ��ַ��� <br />
/// �÷��� <br />1������ CreateBinaryConverter ����ת��������������������ֵ��ַ���ӳ�䣬���磺 <br />
/// ʮ����:CreateBinaryConverter('0123456789') ��
/// TQBinaryConverter.NewSimple('0123456789') <br />
/// ʮ�����ƣ�CreateBinaryConverter('0123456789ABCDEF') ��
/// TQBinaryConverter.NewSimple('0123456789ABCDEF') <br />
/// ���Ҫ���������ַ���֮��˫��ת����ע�Ᵽ֤�����ӳ��������ĺõģ�������Ҫ�� <br />2������ʵ���� ToString
/// ��һ��ֵת��Ϊ�ַ��������� FromString ��һ���ַ���ת��Ϊ������ע�ⲻҪ�������ǰ׺���׺��
/// </summary>
unit qbinary_system;

interface

uses classes, sysutils, math;

type
  /// <summary>
  /// ����ת���ӿڣ������ṩ���û�������Ӧ��ת������
  /// </summary>
  IQBinaryConverter = interface
    ['{20144EA6-2001-4E87-84F7-9D814B310701}']
    /// <summary>
    /// ��һ��64λ�޷�������ת��Ϊ�ַ�����������з�������������ǿת����ת��
    /// </summary>
    /// <param name="AValue">
    /// Ҫת����ԭʼֵ
    /// </param>
    /// <example>
    /// AConverter.ToString(2000); <br />AConverter.ToString(UInt64(-2000));
    /// </example>
    function ToString(AValue: UInt64): String;
    /// <summary>
    /// ��һ����Ч���ַ�����ת����ԭʼ����ֵ
    /// </summary>
    /// <param name="AValue">
    /// �ַ������ʽ
    /// </param>
    /// <returns>
    /// ����ת�����
    /// </returns>
    /// <exception cref="EConvertError">
    /// ԭʼ�ַ���Ϊ�ջ������Ч�ַ�ʱ����
    /// </exception>
    function FromString(AValue: String): UInt64; overload;
    /// <summary>
    /// ��һ����Ч���ַ�����ת����ԭʼ����ֵ
    /// </summary>
    /// <param name="AValue">
    /// �ַ������ʽ
    /// </param>
    /// <param name="ADefVal">
    /// ת��ʧ��ʱ���ص�Ĭ��ֵ
    /// </param>
    /// <returns>
    /// ����ת�����
    /// </returns>
    function FromString(AValue: String; ADefVal: UInt64): UInt64; overload;

    /// <summary>
    /// ��һ��ֵת��Ϊ��Ӧ���ַ�
    /// </summary>
    /// <param name="V">
    /// ԭʼֵ
    /// </param>
    /// <returns>
    /// ���ض�Ӧ���ַ�
    /// </returns>
    /// <remarks>
    /// �������ֵ��Ч���򷵻� EAssertError
    /// </remarks>
    function ToChar(V: Cardinal): Char;
    /// <summary>
    /// ��ָ�����ַ�ת��Ϊ���Ӧ������ֵ
    /// </summary>
    /// <param name="C">
    /// ԭʼ�ַ�
    /// </param>
    /// <exception cref="EConvertError">
    /// ָ�����ַ�������Ч���ַ�ʱ�׳�
    /// </exception>
    function FromChar(C: Char): Cardinal;
    /// <summary>
    /// ��ָ�����ַ������н���ת��Ϊ��Ӧ���ֽ���
    /// </summary>
    /// <param name="S">ԭʼ�ַ���</param>
    /// <returns>����ת�����ֽ���</returns>
    function StringToBytes(S: String): TBytes;
    /// <summary>
    /// ��ָ�����ַ������н���ת��Ϊ��Ӧ���ֽ���
    /// </summary>
    /// <param name="AData">ԭʼ�ֽ���</param>
    /// <returns>���ؽ������ַ���</returns>
    function BytesToString(const AData: TBytes): String;
  end;

  /// <summary>
  /// ����ת������
  /// </summary>
  TQBinaryConverter = class(TInterfacedObject, IQBinaryConverter)
  protected
    /// <summary>
    /// ���ƣ�������ڵ���2
    /// </summary>
    FSystem: Cardinal;
    function ToChar(V: Cardinal): Char; virtual; abstract;
    function FromChar(C: Char): Cardinal; virtual; abstract;
    function StringToBytes(S: String): TBytes;
    function BytesToString(const AData: TBytes): String;
  public
    function ToString(AValue: UInt64): String; overload;
    function FromString(AValue: String): UInt64; overload;
    function FromString(AValue: String; ADefVal: UInt64): UInt64; overload;
    /// <summary>
    /// ����һ���µļ򵥽���ת����
    /// </summary>
    /// <param name="AMaps">
    /// ����ӳ���ַ��б��ڿ��ܵ�����£�Ӧ����ʹ�ð�����������ַ����У���ΪFromString/FromChar �ṩ���õ�Ч���Ż�
    /// </param>
    class function NewSimple(const AMaps: String): IQBinaryConverter; overload;
    /// <summary>
    /// ����һ���µļ򵥽���ת����
    /// </summary>
    /// <param name="AMaps">
    /// ����ӳ���ַ��б��ڿ��ܵ�����£�Ӧ����ʹ�ð�����������ַ����У���ΪFromString/FromChar �ṩ���õ�Ч���Ż�
    /// </param>
    class function NewSimple(const AMaps: array of Char)
      : IQBinaryConverter; overload;
  end;

  TQCharRange = record
    Min, Max: Char;
    class function Create(const AMin, AMax: Char): TQCharRange; static;
  end;

  TQCharRanges = array of TQCharRange;
  TQMapChars = array of Char;
  /// <summary>
  /// TQBinaryConverter.CreateSimple ��ȫ�ֺ����汾
  /// </summary>
  /// <param name="AMaps">
  /// ����ӳ���ַ��б��ڿ��ܵ�����£�Ӧ����ʹ�ð�����������ַ����У���ΪFromString/FromChar �ṩ���õ�Ч���Ż�
  /// </param>
function CreateBinaryConverter(AMaps: String): IQBinaryConverter; overload;

/// <summary>
/// TQBinaryConverter.CreateSimple ��ȫ�ֺ����汾
/// </summary>
/// <param name="AMaps">
/// ����ӳ���ַ��б��ڿ��ܵ�����£�Ӧ����ʹ�ð�����������ַ����У���ΪFromString/FromChar �ṩ���õ�Ч���Ż�
/// </param>
function CreateBinaryConverter(const AMaps: TQMapChars)
  : IQBinaryConverter; overload;
function CreateBinaryConverter(const ARanges: TQCharRanges)
  : IQBinaryConverter; overload;
function CharRange(const AMin, AMax: Char): TQCharRange;

implementation

resourcestring
  SInvalidChar = '%s ����һ����Ч�� %d �����ַ�';
  SConvertSourceEmpty = '�޷���һ�����ַ���ת��Ϊ����';
  SBadBytes = '�ֽ���ת��Ϊ�ַ���ʱ��ԭʼ�ֽ������谴8�ֽڶ���';

type
  TQSimpleBinaryConverter = class(TQBinaryConverter)
  protected
    FValueMaps: TQMapChars;
    FSorted: Boolean;
    function ToChar(V: Cardinal): Char; override;
    function FromChar(C: Char): Cardinal; override;
    procedure CheckSorted;
  public
    constructor Create(const AMaps: TQMapChars); overload;
    constructor Create(const AMaps: String); overload;
  end;

function CharRange(const AMin, AMax: Char): TQCharRange;
begin
  Result.Min := AMin;
  Result.Max := AMax;
end;

function CreateBinaryConverter(AMaps: String): IQBinaryConverter;
begin
  Result := TQSimpleBinaryConverter.Create(AMaps);
end;

function CreateBinaryConverter(const AMaps: TQMapChars): IQBinaryConverter;
begin
  Result := TQSimpleBinaryConverter.Create(AMaps);
end;

function CreateBinaryConverter(const ARanges: TQCharRanges): IQBinaryConverter;
var
  AMaps: TQMapChars;
  I, L: Integer;
  J: Integer;
begin
  L := 0;
  for I := 0 to High(ARanges) do
    Inc(L, Ord(ARanges[I].Max) - Ord(ARanges[I].Min));
  SetLength(AMaps, L);
  L := 0;
  for I := 0 to High(ARanges) do
  begin
    for J := Ord(ARanges[I].Min) to Ord(ARanges[I].Max) do
    begin
      AMaps[L] := Char(J);
      Inc(L);
    end;
  end;
  Result := TQSimpleBinaryConverter.Create(AMaps);
end;

{ TQBinaryConverter }

function TQBinaryConverter.BytesToString(const AData: TBytes): String;
var
  p: PInt64;
  ATemp: TBytes;
begin
  if (Length(AData) and $7) <> 0 then
  begin
    SetLength(ATemp, (Length(AData) + 7) and $FFFFFFF8);
    Move(AData[0], ATemp[0], Length(AData));
    p := PInt64(@ATemp[0]);
  end
  else
    p := PInt64(@AData[0]);

end;

class function TQBinaryConverter.NewSimple(const AMaps: array of Char)
  : IQBinaryConverter;
begin
  Result := TQSimpleBinaryConverter.Create(AMaps);
end;

function TQBinaryConverter.StringToBytes(S: String): TBytes;
begin

end;

class function TQBinaryConverter.NewSimple(const AMaps: String)
  : IQBinaryConverter;
begin
  Result := TQSimpleBinaryConverter.Create(AMaps);
end;

function TQBinaryConverter.FromString(AValue: String): UInt64;
var
  p: PChar;
begin
  if Length(AValue) = 0 then
    raise EConvertError.Create(SConvertSourceEmpty);
  p := PChar(AValue);
  Result := 0;
  while p^ <> #0 do
  begin
    Result := Result * FSystem + FromChar(p^);
    Inc(p);
  end;
end;

function TQBinaryConverter.FromString(AValue: String; ADefVal: UInt64): UInt64;
begin
  try
    Result := FromString(AValue);
  except
    on E: EConvertError do
      Result := ADefVal;
  end;
end;

function TQBinaryConverter.ToString(AValue: UInt64): String;
var
  V, L, I: Cardinal;
  pd: PChar;
begin
  if AValue = 0 then
    Result := ToChar(0)
  else
  begin
    L := Trunc(LogN(FSystem, AValue)) + 1;
    SetLength(Result, L);
    pd := PChar(Result) + L - 1;
    I := 0;
    while AValue > 0 do
    begin
      V := AValue mod FSystem;
      pd^ := ToChar(V);
      Dec(pd);
      AValue := AValue div FSystem;
    end;
    if pd = PChar(Result) then
    begin
      Inc(pd);
      Result := pd;
    end;
  end;
end;

{ TSimpleBinaryConverter }

constructor TQSimpleBinaryConverter.Create(const AMaps: TQMapChars);
begin
  inherited Create;
  Assert(Length(AMaps) > 1);
  FSystem := Length(AMaps);
  SetLength(FValueMaps, Length(AMaps));
  Move(AMaps[0], FValueMaps[0], Length(AMaps) * SizeOf(Char));
  CheckSorted;
end;

procedure TQSimpleBinaryConverter.CheckSorted;
var
  I: Integer;
begin
  FSorted := true;
  for I := 1 to High(FValueMaps) do
  begin
    if FValueMaps[I] <= FValueMaps[I - 1] then
    begin
      FSorted := false;
      Break;
    end;
  end;
end;

constructor TQSimpleBinaryConverter.Create(const AMaps: String);
begin
  inherited Create;
  Assert(Length(AMaps) > 1);
  FSystem := Length(AMaps);
  SetLength(FValueMaps, Length(AMaps));
  Move(PChar(AMaps)^, FValueMaps[0], Length(AMaps) * SizeOf(Char));
  CheckSorted;
end;

function TQSimpleBinaryConverter.FromChar(C: Char): Cardinal;
var
  I, L, H, D: Integer;
begin
  if not FSorted then // ����������б�ֻ�ܰ������ˣ���Ȼ�����ڴ�ʵ�֣�
  begin
    for I := 0 to FSystem - 1 do
    begin
      if FValueMaps[I] = C then
      begin
        Result := I;
        Exit;
      end;
    end;
  end
  else
  begin
    L := 0;
    H := FSystem - 1;
    // �����ַ�λ��˳����������ֱ�ӾͿ����ҵ���Ӧ����Ŀ������ 16����ʱ��0-9 ����ֱ�Ӷ�λ��
    I := (Ord(C) - Ord(FValueMaps[L])) *
      FSystem div (Ord(FValueMaps[H]) - Ord(FValueMaps[L]));
    if I > H then
      I := H;
    repeat
      D := Ord(FValueMaps[I]) - Ord(C);
      if D = 0 then
      begin
        Result := I;
        Exit;
      end
      else if D > 0 then
        H := I - 1
      else
        L := I + 1;
      I := (L + H) shr 1;
    until L > H;
  end;
  raise EConvertError.CreateFmt(SInvalidChar, [C, FSystem]);
end;

function TQSimpleBinaryConverter.ToChar(V: Cardinal): Char;
begin
  Assert(V < Length(FValueMaps));
  Result := FValueMaps[V];
end;

{ TQCharRange }

{ TQCharRange }

class function TQCharRange.Create(const AMin, AMax: Char): TQCharRange;
begin
  Result := CharRange(AMin, AMax);
end;

initialization

end.

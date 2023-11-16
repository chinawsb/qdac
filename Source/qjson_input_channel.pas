unit qjson_input_channel;

interface

uses classes, sysutils, qstring, qjson;

{
  本源码来自QDAC项目，版权归swish(QQ:109867294)所有。
  (1)、使用许可及限制
  您可以自由复制、分发、修改本源码，但您的修改应该反馈给作者，并允许作者在必要时，
  合并到本项目中以供使用，合并后的源码同样遵循QDAC版权声明限制。
  您的产品的关于中，应包含以下的版本声明:
  本产品使用的JSON解析器来自QDAC项目中的QJSON，版权归作者所有。
  (2)、技术支持
  有技术问题，您可以加入QDAC官方QQ群250530692共同探讨。
  (3)、赞助
  您可以自由使用本源码而不需要支付任何费用。如果您觉得本源码对您有帮助，您可以赞
  助本项目（非强制），以使作者不为生活所迫，有更多的精力为您呈现更好的作品：
  赞助方式：
  支付宝： guansonghuan@sina.com 姓名：管耸寰
  建设银行：
  户名：管耸寰
  账号：4367 4209 4324 0179 731
  开户行：建设银行长春团风储蓄所
}
{ 修订日志
  2021.12.14
  ==========
  + 初始版本
}
type
  TQJsonBytesNotifyEvent = procedure(Sender: TObject; AJson: TQJson) of object;
  TQJsonBytesErrorEvent = procedure(Sender: TObject; E: Exception) of object;
  TQNextChar = function: WideChar of object;

  IQJsonDecoder = interface
    ['{EE28268C-57E4-4C99-9A6F-8BADAE9FC91B}']
    procedure Push(const AData: Pointer; ACount: Cardinal); overload;
    procedure Push(const AData: QStringW); overload;
    procedure Push(const AData: TBytes); overload;
    procedure Push(AStream: TStream); overload;
    // LoadFromStream 是 Push(AStream) 的壳，两个等价
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(const AFileName: QStringW);
    procedure Reset(AResetBuffer: Boolean = false);
  end;

  TQJsonInputChannel = class
  public
    class function CreateDecoder(const AEncoding: TTextEncoding;
      AOnJsonReady: TQJsonBytesNotifyEvent;
      AOnError: TQJsonBytesErrorEvent = nil; ABufSize: Integer = 4096)
      : IQJsonDecoder;
  end;

implementation

const
  CharSize: array [TTextEncoding] of Integer = (0, 0, 1, 2, 2, 1);

type
  TQJsonDecoder = class(TInterfacedObject, IQJsonDecoder)
  private
    FBuffer: TBytes;
    FStartChar, FStopChar: Char;
    FStartCount, FStopCount, FQuotedCount: NativeInt;
    FCharOffset, FByteOffset, FEscapeOffset: NativeInt;
    FEncoding: TTextEncoding;
    FOnJsonReady: TQJsonBytesNotifyEvent;
    FOnParseError: TQJsonBytesErrorEvent;
    FNextChar: TQNextChar;
    procedure JsonDetect;
    procedure DoJsonReady(const AText: QStringW);
    function AnsiNextChar: WideChar;
    function UTF16LENextChar: WideChar;
    function UtF16BENextChar: WideChar;
    function DecodeText: QStringW;
    procedure SetEncoding(const AEncoding: TTextEncoding);
  public
    constructor Create(AEncoding: TTextEncoding; ABufSize: Cardinal = 4096);
    procedure Push(const AData: Pointer; ACount: Cardinal); overload;
    procedure Push(const AData: QStringW); overload;
    procedure Push(const AData: TBytes); overload;
    procedure Push(AStream: TStream); overload;
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(const AFileName: QStringW);
    procedure Reset(AResetBuffer: Boolean = false);
    property OnJsonReady: TQJsonBytesNotifyEvent read FOnJsonReady
      write FOnJsonReady;
    property OnParseError: TQJsonBytesErrorEvent read FOnParseError
      write FOnParseError;
  end;
  { TQJsonDecoder }

function TQJsonDecoder.AnsiNextChar: WideChar;
begin
  // 实际字符这里并不关心，因为需要特殊处理的都是在ANSI编码范围的，所以直接剩下的不管
  Result := WideChar(FBuffer[FCharOffset]);
end;

constructor TQJsonDecoder.Create(AEncoding: TTextEncoding; ABufSize: Cardinal);
begin
  inherited Create;
  SetEncoding(AEncoding);
end;

function TQJsonDecoder.DecodeText: QStringW;
begin
  case FEncoding of
    teAnsi:
      Result := AnsiDecode(PQCharA(@FBuffer[0]), FCharOffset);
    teUnicode16LE:
      Result := StrDupX(PWideChar(@FBuffer[0]), FCharOffset shr 1);
    teUnicode16BE:
      begin
        ExchangeByteOrder(PQCharA(@FBuffer[0]), FCharOffset);
        Result := StrDupX(PWideChar(@FBuffer[0]), FCharOffset shr 1);
      end;
    teUtf8:
      Result := Utf8Decode(PQCharA(@FBuffer[0]), FCharOffset)
  else
    raise Exception.Create('不支持的字符编码');
  end;
end;

procedure TQJsonDecoder.DoJsonReady(const AText: QStringW);
var
  AJson: TQJson;
begin
  Move(FBuffer[FCharOffset], FBuffer[0], FByteOffset - FCharOffset);
  Dec(FByteOffset, FCharOffset);
  FCharOffset := 0;
  FEscapeOffset := 0;
  FStartChar := #0;
  FStopChar := #0;
  FStartCount := 0;
  FStopCount := 0;
  if Assigned(FOnJsonReady) then
  begin
    AJson := AcquireJson;
    try
      if PQCharW(AText)^ = ',' then
        AJson.Parse(PQCharW(AText) + 1, Length(AText) - 1)
      else
        AJson.Parse(AText);
      if Assigned(FOnJsonReady) then
        FOnJsonReady(Self, AJson);
    finally
      ReleaseJson(AJson);
    end;
  end;
end;

procedure TQJsonDecoder.JsonDetect;
var
  c: QCharW;
  function TestKeyword(const S: QStringW): Boolean;
  var
    wc: QCharW;
    p: PQCharW;
  begin
    wc := c;
    p := PQCharW(S);
    if FCharOffset + Length(S) * CharSize[FEncoding] <= FByteOffset then
    begin
      while p^ <> #0 do
      begin
        if wc = p^ then
        begin
          Inc(p);
          Inc(FCharOffset, CharSize[FEncoding]);
          wc := FNextChar;
        end
        else
          raise Exception.CreateFmt('%s 不是一个有效的JSON起始字符', [c]);
      end;
      DoJsonReady(S);
      Result := true;
    end
    else
      Result := false;
  end;

begin
  try
    while FCharOffset < FByteOffset - CharSize[FEncoding] + 1 do
    begin
      c := FNextChar;
      if FQuotedCount > 0 then
      begin
        // 当前字符位置位于字符串内，检查是否处于转义中，如果处于，则要先完成转义
        if FEscapeOffset > 0 then
        begin
          // 转义起始位置\uxxxx，及常用的转义符需要处理
          if Ord(c) = $75 then // \u
          begin
            if FEscapeOffset + CharSize[FEncoding] * 4 < FByteOffset then
              Inc(FCharOffset, CharSize[FEncoding] * 4)
            else // 转义字符序列长度不够,不再处理
              Exit;
          end
          else
            // \a\b\t\n\v\f\r\"或者\后直接跟非预定字符时，直接呈现原字符而不是抛出错误
            Inc(FCharOffset, CharSize[FEncoding]);
          FEscapeOffset := 0; // 转义结束
        end
        // 当前未处于转义状态，那么只检查双引号
        else if c = '"' then
        begin
          FQuotedCount := (FQuotedCount + 1) mod 2;
          Inc(FCharOffset, CharSize[FEncoding]);
          if (FQuotedCount = 0) and (FStopChar = '"') then
          begin
            DoJsonReady(DecodeText);
            continue;
          end;
        end
        else if c = '\' then
        begin
          FEscapeOffset := FCharOffset;
          Inc(FCharOffset, CharSize[FEncoding]);
        end
        else // 其它双引号内的字符直接跳
          Inc(FCharOffset, CharSize[FEncoding]);
      end
      else
      // 不在引号内，那么一个有效的JSON值可以是对象、数组、字符串、null、true、false和数字，这里只判断对象和数组，其它值不去考虑
      // 如果那种特殊情况，请自行特殊处理吧，毕竟上帝也不知道一个数字啥时候结束
      begin
        if FStopChar = #0 then
        begin
          if not(Ord(c) in [9, 10, 13, 32, Ord(',')]) then // 空白字符，直接跳
          begin
            FStartChar := c;
            case c of
              '{':
                begin
                  FStopChar := '}';
                end;
              '[':
                FStopChar := ']';
              't': // true?
                begin
                  if TestKeyword('true') then
                    continue
                  else
                    Exit;
                end;
              'f': // false?
                begin
                  if TestKeyword('false') then
                    continue
                  else
                    Exit;
                end;
              'n': // null?
                begin
                  if TestKeyword('null') then
                    continue
                  else
                    Exit;
                end;
              '"': // string?
                begin
                  FStopChar := '"';
                  Inc(FQuotedCount);
                end
            else
              raise Exception.CreateFmt('%s 不是支持的流式JSON序列化起始字符', [c]);
            end;
            FStartCount := 1;
          end;
        end
        else if c = FStartChar then
          Inc(FStartCount)
        else if c = FStopChar then
        begin
          Inc(FStopCount);
          if FStartCount = FStopCount then
          begin
            // 匹配完成，解析JSON
            Inc(FCharOffset, CharSize[FEncoding]);
            DoJsonReady(DecodeText);
            continue;
          end;
        end
        else if c = '"' then
          Inc(FQuotedCount);
        Inc(FCharOffset, CharSize[FEncoding]);
      end;
    end;
  except
    on E: Exception do
    begin
      if Assigned(FOnParseError) then
        FOnParseError(Self, E);
    end;
  end;
end;

procedure TQJsonDecoder.LoadFromFile(const AFileName: QStringW);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Push(AStream);
  finally
    FreeAndNil(AStream);
  end;
end;

procedure TQJsonDecoder.LoadFromStream(AStream: TStream);
begin
  Push(AStream);
end;

procedure TQJsonDecoder.Push(AStream: TStream);
var
  ABuf: array [0 .. 65535] of Byte;
  ACount, APasscount: Integer;
begin
  APasscount := 0;
  repeat
    ACount := AStream.Read(ABuf, 65536);
    if ACount > 0 then
    begin
      if APasscount = 0 then
      begin
        if (ABuf[0] = $FF) and (ABuf[1] = $FE) then
        begin
          SetEncoding(teUnicode16LE);
          Push(@ABuf[2], ACount - 2);
        end
        else if (ABuf[0] = $FE) and (ABuf[1] = $FF) then
        begin
          SetEncoding(teUnicode16BE);
          Push(@ABuf[2], ACount - 2);
        end
        else if (ABuf[0] = $EF) and (ABuf[1] = $BB) and (ABuf[2] = $BF) then
        begin
          SetEncoding(teUtf8);
          Push(@ABuf[3], ACount - 3);
        end
        else
          Push(@ABuf[0], ACount);
      end
      else
        Push(@ABuf[0], ACount);
    end
    else
      Break;
  until 1 > 2;
end;

procedure TQJsonDecoder.Push(const AData: TBytes);
begin
  if Length(AData) > 0 then
    Push(@AData[0], Length(AData));
end;

procedure TQJsonDecoder.Push(const AData: QStringW);
var
  T: QStringA;
begin
  if FEncoding = teUnicode16LE then
    Push(PWideChar(AData), Length(AData) shl 1)
  else if FEncoding = teUnicode16BE then
  begin
    T.Length := Length(AData) shl 1;
    Move(PWideChar(AData)^, T.Data^, T.Length);
    ExchangeByteOrder(PQCharA(T.Data), T.Length);
    Push(T.Data, T.Length);
  end
  else if FEncoding = teUtf8 then
  begin
    T := qstring.Utf8Encode(AData);
    Push(PQCharA(T), T.Length);
  end
  else if FEncoding = teAnsi then
  begin
    T := qstring.AnsiEncode(AData);
    Push(PQCharA(T), T.Length);
  end;
end;
{$WARN COMBINING_SIGNED_UNSIGNED OFF}

procedure TQJsonDecoder.Push(const AData: Pointer; ACount: Cardinal);
begin
  if FByteOffset + ACount > Length(FBuffer) then
    SetLength(FBuffer, Length(FBuffer) + ((FByteOffset + ACount) -
      Length(FBuffer) + 4096) div 4096 * 4096);
  if ACount > 0 then
  begin
    Move(AData^, FBuffer[FByteOffset], ACount);
    Inc(FByteOffset, ACount);
    JsonDetect;
  end;
end;
{$WARN COMBINING_SIGNED_UNSIGNED ON}

procedure TQJsonDecoder.Reset(AResetBuffer: Boolean);
begin
  FByteOffset := 0;
  FCharOffset := 0;
  FEscapeOffset := 0;
  FStartChar := #0;
  FStopChar := #0;
  FStartCount := 0;
  FStopCount := 0;
  if AResetBuffer then // 重置为4K
    SetLength(FBuffer, 4096);
end;

procedure TQJsonDecoder.SetEncoding(const AEncoding: TTextEncoding);
begin
  FEncoding := AEncoding;
  case FEncoding of
    teAnsi, teUtf8:
      FNextChar := AnsiNextChar;
    teUnicode16LE:
      FNextChar := UTF16LENextChar;
    teUnicode16BE:
      FNextChar := UtF16BENextChar;
  end;
end;

function TQJsonDecoder.UtF16BENextChar: WideChar;
begin
  Result := WideChar(ExchangeByteOrder(PWord(@FBuffer[FCharOffset])^));
end;

function TQJsonDecoder.UTF16LENextChar: WideChar;
begin
  Result := PWideChar(@FBuffer[FCharOffset])^;
end;

{ TQJsonInputChannel }

class function TQJsonInputChannel.CreateDecoder(const AEncoding: TTextEncoding;
  AOnJsonReady: TQJsonBytesNotifyEvent; AOnError: TQJsonBytesErrorEvent;
  ABufSize: Integer): IQJsonDecoder;
var
  R: TQJsonDecoder;
begin
  R := TQJsonDecoder.Create(AEncoding, ABufSize);
  R.OnJsonReady := AOnJsonReady;
  R.OnParseError := AOnError;
  Result := R;
end;

end.

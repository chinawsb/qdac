unit qdigest;

interface

{
  MD5��SHA��ϣ����Ԫ
  ����Ԫ�����Լ����뷨�Խӿ���ʽ�ʹ�������˵������Ա�����á�
  MD5�㷨������ϵͳ�Դ�System.Hash.pas
  SHA�㷨����DCPcrypt��dcpSHA1.pas,dcpSHA256.pas,dcpSHA512.pas
  DCPCrpt��Ȩ��http://www.cityinthesky.co.uk/����
}
{ �޶���־
  2015.7.15
  ==========
  * ������MD5Hashһ����ʱ�����ʹ�ûص���������Ϊ��ʱ�����ֶ�ջ��������⣨��л�ഺ��
  * ������MD5Hash��SHAXXHash�����ļ�ʱ�����ǽ�������⣨��л�ഺ��
  2015.4.26
  ==========
  * ������SHA 384/512�ڹ�ϣ���ļ�ʱ���ɵĹ�ϣ�������ȷ�����⣨��л�ֺ룩
  2015.4.24
  =========
  * ������SHAHashStreamʱ��������������δ��ȷ���ؽ�������⣨��л�ֺ룩
  * ������SHA384��512���ɵĹ�ϣժҪֵ����ȷ�����⣨��л�Ƕ��ͻֺ룩
  2015.4.23
  =========
  * ������MD5ֵ�����ݳ���64Bʱ����������ȷ�����⣨��лetarelecca��
  2015.2.26
  =========
  * ��������2007�µı�����󣨸�л�����ٷʣ�
  2014.12.9
  =========
  * �޸���MD5Init���򻯴������Ч�ʣ�����С�׽��飩
  + ����MD5QuickHash�����������ټ��������ļ���һ���򻯰��MD5ֵ��ע���MD5Hash/MD5HashFile�������һ�£�
  2014.8.5
  * �޸���MD5Initʱ����ʼ������������
  2014.8.2
  * ������һ��Move�������ݴ���
}
uses classes, sysutils, qstring{$IFDEF MSWINDOWS}, windows{$ENDIF};

type
{$HPPEMIT '#pragma link "qdigest"'}
  // ������������
{$Q-}
  TQMD5Digest = record
    case Integer of
      0:
        (Value: array [0 .. 15] of Byte);
      1:
        (Id: TGuid);
      2:
        (Low, High: Int64);
  end;

  TQSHADigestType = (sdt160, sdt256, sdt384, sdt512);

  TQSHADigest = record
    HashType: TQSHADigestType;
    case Integer of
      0:
        (SHA160: array [0 .. 19] of Byte);
      1:
        (SHA256: array [0 .. 31] of Byte);
      2:
        (SHA384: array [0 .. 47] of Byte);
      3:
        (SHA512: array [0 .. 63] of Byte);
      4:
        (I32: array [0 .. 15] of Cardinal);
      5:
        (I64: array [0 .. 7] of UInt64);
  end;

  TQHashProgressNotify = procedure(AHashed, ATotal: Int64) of object;
{$IFDEF UNICODE}
  TQHashProgressNotifyA = reference to procedure(AHashed, ATotal: Int64);
  PQHashProgressNotifyA = ^TQHashProgressNotifyA;
{$ENDIF}
function MD5Hash(const p: Pointer; len: Integer): TQMD5Digest; overload;
function MD5Hash(const S: QStringW): TQMD5Digest; overload;
function MD5Hash(AStream: TStream; AOnProgress: TQHashProgressNotify = nil)
  : TQMD5Digest; overload;
{$IFDEF UNICODE}
function MD5Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQMD5Digest; overload;
{$ENDIF}
function MD5File(AFile: QStringW; AOnProgress: TQHashProgressNotify = nil)
  : TQMD5Digest; overload;
{$IFDEF UNICODE}
function MD5File(AFile: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQMD5Digest; overload;
{$ENDIF}
function MD5QuickHash(AStream: TStream; ASampleSize: Integer = 4096)
  : TQMD5Digest; overload;
function MD5QuickHash(AFile: QStringW; ASampleSize: Integer = 4096)
  : TQMD5Digest; overload;
function MD5Equal(const AFirst, ASecond: TQMD5Digest): Boolean;
function SHA160Hash(const p: Pointer; len: Integer): TQSHADigest; overload;
function SHA160Hash(const S: QStringW): TQSHADigest; overload;
function SHA160Hash(AStream: TStream; AOnProgress: TQHashProgressNotify = nil)
  : TQSHADigest; overload;
function SHA160File(AFileName: QStringW;
  AOnProgress: TQHashProgressNotify = nil): TQSHADigest; overload;
{$IFDEF UNICODE}
function SHA160Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
function SHA160File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
{$ENDIF}
function SHA256Hash(const p: Pointer; len: Integer): TQSHADigest; overload;
function SHA256Hash(const S: QStringW): TQSHADigest; overload;
function SHA256Hash(AStream: TStream; AOnProgress: TQHashProgressNotify = nil)
  : TQSHADigest; overload;
function SHA256File(AFileName: QStringW;
  AOnProgress: TQHashProgressNotify = nil): TQSHADigest; overload;
{$IFDEF UNICODE}
function SHA256Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
function SHA256File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
{$ENDIF}
function SHA384Hash(const p: Pointer; len: Integer): TQSHADigest; overload;
function SHA384Hash(const S: QStringW): TQSHADigest; overload;
function SHA384Hash(AStream: TStream; AOnProgress: TQHashProgressNotify = nil)
  : TQSHADigest; overload;
function SHA384File(AFileName: QStringW;
  AOnProgress: TQHashProgressNotify = nil): TQSHADigest; overload;
{$IFDEF UNICODE}
function SHA384Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
function SHA384File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
{$ENDIF}
function SHA512Hash(const p: Pointer; len: Integer): TQSHADigest; overload;
function SHA512Hash(const S: QStringW): TQSHADigest; overload;
function SHA512Hash(AStream: TStream; AOnProgress: TQHashProgressNotify = nil)
  : TQSHADigest; overload;
function SHA512File(AFileName: QStringW;
  AOnProgress: TQHashProgressNotify = nil): TQSHADigest; overload;
{$IFDEF UNICODE}
function SHA512Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
function SHA512File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
{$ENDIF}
function DigestToString(const ADigest: TQMD5Digest; ALowerCase: Boolean = False)
  : QStringW; overload;
function DigestToString(const ADigest: TQSHADigest; ALowerCase: Boolean = False)
  : QStringW; overload;
function DigestEqual(AHash1, AHash2: TQMD5Digest): Boolean; overload;
function DigestEqual(AHash1, AHash2: TQSHADigest): Boolean; overload;

implementation

resourcestring
  SHashCanNotUpdateMD5 = '���ܶ��Ѿ�ȡֵ�Ĺ�ϣ�����������';

  // Copy from System.Hash
type
  TContextState = array [0 .. 15] of Cardinal;
  TContextBuffer = array [0 .. 63] of Byte;

  TQHashMD5 = record
  private
    FPadding: TContextBuffer;
    FContextState: array [0 .. 3] of Cardinal;
    FContextCount: array [0 .. 1] of Cardinal;
    FContextBuffer: TContextBuffer;
    FFinalized: Boolean;
    procedure Transform(const ABlock: PByte; AShift: Integer);
    procedure Decode(Dst: PCardinal; Src: PByte; len: Integer; AShift: Integer);
    procedure Encode(Dst: PByte; Src: PCardinal; len: Integer);
    procedure FinalizeHash;
    procedure Update(AData: PByte; ALength: Cardinal); overload;

    function GetDigest: TQMD5Digest;

  public

    /// <summary> Creates an instance to generate MD5 hashes</summary>
    class function Create: TQHashMD5; static;
    /// <summary> Puts the state machine of the generator in it's initial state.</summary>
    procedure Reset;
    /// <summary> Update the Hash with the provided bytes</summary>
    procedure Update(const AData; ALength: Cardinal); overload;
    procedure Update(const AData: TBytes; ALength: Cardinal = 0); overload;
    procedure Update(const Input: QStringW); overload;

    /// <summary> Returns the hash value as a TBytes</summary>
    function HashAsBytes: TBytes;
    /// <summary> Returns the hash value as string</summary>
    function HashAsString: QStringW;

    /// <summary> Hash the given string and returns it's hash value as integer</summary>
    class function GetHashBytes(const AData: QStringW): TBytes; static;
    /// <summary> Hash the given string and returns it's hash value as string</summary>
    class function GetHashString(const AString: QStringW): QStringW; static;

    /// <summary>Gets the string associated to the HMAC authentication</summary>
    class function GetHMAC(const AData, AKey: QStringW): QStringW;
      static; inline;
    /// <summary>Gets the Digest associated to the HMAC authentication</summary>
    class function GetHMACAsBytes(const AData, AKey: QStringW)
      : TQMD5Digest; static;
  end;

  TQSHAContext = record
    CurrentHash: TQSHADigest;
    Index: Cardinal;
    HashBuffer: array [0 .. 127] of Byte;
    case Integer of
      0:
        (LenHi, LenLo: LongWord);
      1:
        (LenHi64, LenLo64: Int64);
  end;

function DigestEqual(AHash1, AHash2: TQMD5Digest): Boolean;
begin
  Result := (AHash1.Low = AHash2.Low) and (AHash1.High = AHash2.High);
end;

function DigestEqual(AHash1, AHash2: TQSHADigest): Boolean;
var
  I, C: Integer;
begin
  Result := (AHash1.HashType = AHash2.HashType);
  if Result then
  begin
    case AHash1.HashType of
      sdt160:
        C := 5;
      sdt256:
        C := 8;
      sdt384:
        C := 12;
      sdt512:
        C := 16
    else
      Exit;
    end;
    for I := 0 to C - 1 do
    begin
      if AHash1.I32[I] <> AHash2.I32[I] then
      begin
        Result := False;
        Break;
      end;
    end;
  end;
end;

function MD5Hash(const p: Pointer; len: Integer): TQMD5Digest;
var
  AContext: TQHashMD5;
begin
  AContext.Reset;
  AContext.Update(PByte(p), len);
  Result := AContext.GetDigest;
end;

function MD5Hash(const S: QStringW): TQMD5Digest;
var
  T: QStringA;
begin
  T := qstring.Utf8Encode(S);
  Result := MD5Hash(PQCharA(T), T.Length);
end;

function MD5Hash(AStream: TStream; AOnProgress: TQHashProgressNotify)
  : TQMD5Digest;
var
  ABuf: array [0 .. 65535] of Byte;
  AReaded: Integer;
  AContext: TQHashMD5;
  ALastNotify: Int64;
  procedure DoProgress(AForce: Boolean);
  begin
    if (AStream.Position - ALastNotify > 10485760) or AForce then
    begin
      if TMethod(AOnProgress).Code <> nil then
      begin
{$IFDEF UNICODE}
        if TMethod(AOnProgress).Data = Pointer(-1) then
          TQHashProgressNotifyA(TMethod(AOnProgress).Code)
            (AStream.Position, AStream.Size)
        else
{$ENDIF}
          AOnProgress(AStream.Position, AStream.Size);
      end;
      ALastNotify := AStream.Position;
    end;
  end;

begin
  AContext.Reset;
  AStream.Position := 0;
  ALastNotify := 0;
  repeat
    AReaded := AStream.Read(ABuf, 65536);
    if AReaded > 0 then
      AContext.Update(PByte(@ABuf[0]), AReaded);
    DoProgress(False);
  until AReaded = 0;
  Result := AContext.GetDigest;
  DoProgress(True);
end;
{$IFDEF UNICODE}

function MD5Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQMD5Digest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := MD5Hash(AStream, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := MD5Hash(AStream, TQHashProgressNotify(nil));
end;
{$ENDIF}

function MD5File(AFile: QStringW; AOnProgress: TQHashProgressNotify)
  : TQMD5Digest;
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := MD5Hash(AStream, AOnProgress);
  finally
    FreeObject(AStream);
  end;
end;
{$IFDEF UNICODE}

function MD5File(AFile: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQMD5Digest; overload;
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := MD5Hash(AStream, AOnProgress);
  finally
    FreeObject(AStream);
  end;
end;
{$ENDIF}

// QuickHashͳ��ʱ����ǰ���ȡ16KB������,�м�ȡ32KB�����㣬���С��64K����ȫ������
function MD5QuickHash(AStream: TStream; ASampleSize: Integer): TQMD5Digest;
var
  ABuf: array [0 .. 65543] of Byte; // 65535+8�ֽڳ�����Ϣ
  pBuf: PByte;
  ASize: Int64;
  ABlockSize: Integer;
begin
  if ASampleSize < 4096 then
    ASampleSize := 4096
  else if ASampleSize > 65536 then
    ASampleSize := 65536;
  ASize := AStream.Size;
  Move(ASize, ABuf[0], 8);
  AStream.Position := 0;
  if ASize <= ASampleSize then
    ASize := AStream.Read(ABuf[8], ASampleSize)
  else
  begin
    pBuf := @ABuf[0];
    Inc(pBuf, 8);
    ABlockSize := ASampleSize shr 2;
    AStream.Read(pBuf^, ABlockSize);
    Inc(pBuf, ABlockSize);
    AStream.Position := (ASize div 2) - ABlockSize;
    AStream.Read(pBuf^, ABlockSize shl 1);
    Inc(pBuf, ABlockSize shl 1);
    AStream.Position := ASize - ABlockSize;
    AStream.Read(pBuf^, ABlockSize);
    ASize := ASampleSize;
  end;
  Result := MD5Hash(@ABuf[0], ASize + 8);
end;

function MD5QuickHash(AFile: QStringW; ASampleSize: Integer): TQMD5Digest;
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := MD5QuickHash(AStream, ASampleSize);
  finally
    FreeObject(AStream);
  end;
end;

function MD5Equal(const AFirst, ASecond: TQMD5Digest): Boolean;
begin
  Result := (AFirst.Low = ASecond.Low) and (AFirst.High = ASecond.High);
end;

function DigestToString(const ADigest: TQMD5Digest; ALowerCase: Boolean)
  : QStringW;
begin
  Result := qstring.BinToHex(@ADigest, SizeOf(TQMD5Digest), ALowerCase);
end;

// SHA����
// SHA����
procedure SHAInit(var AContext: TQSHAContext; AType: TQSHADigestType);
begin
  FillChar(AContext, SizeOf(AContext), 0);
  AContext.CurrentHash.HashType := AType;
  case AType of
    sdt160:
      begin
        AContext.CurrentHash.I32[0] := $67452301;
        AContext.CurrentHash.I32[1] := $EFCDAB89;
        AContext.CurrentHash.I32[2] := $98BADCFE;
        AContext.CurrentHash.I32[3] := $10325476;
        AContext.CurrentHash.I32[4] := $C3D2E1F0;
      end;
    sdt256:
      begin
        AContext.CurrentHash.I32[0] := $6A09E667;
        AContext.CurrentHash.I32[1] := $BB67AE85;
        AContext.CurrentHash.I32[2] := $3C6EF372;
        AContext.CurrentHash.I32[3] := $A54FF53A;
        AContext.CurrentHash.I32[4] := $510E527F;
        AContext.CurrentHash.I32[5] := $9B05688C;
        AContext.CurrentHash.I32[6] := $1F83D9AB;
        AContext.CurrentHash.I32[7] := $5BE0CD19;
      end;
    sdt384:
      begin
        AContext.CurrentHash.I64[0] := UInt64($CBBB9D5DC1059ED8);
        AContext.CurrentHash.I64[1] := UInt64($629A292A367CD507);
        AContext.CurrentHash.I64[2] := UInt64($9159015A3070DD17);
        AContext.CurrentHash.I64[3] := UInt64($152FECD8F70E5939);
        AContext.CurrentHash.I64[4] := UInt64($67332667FFC00B31);
        AContext.CurrentHash.I64[5] := UInt64($8EB44A8768581511);
        AContext.CurrentHash.I64[6] := UInt64($DB0C2E0D64F98FA7);
        AContext.CurrentHash.I64[7] := UInt64($47B5481DBEFA4FA4);
      end;
    sdt512:
      begin
        AContext.CurrentHash.I64[0] := UInt64($6A09E667F3BCC908);
        AContext.CurrentHash.I64[1] := UInt64($BB67AE8584CAA73B);
        AContext.CurrentHash.I64[2] := UInt64($3C6EF372FE94F82B);
        AContext.CurrentHash.I64[3] := UInt64($A54FF53A5F1D36F1);
        AContext.CurrentHash.I64[4] := UInt64($510E527FADE682D1);
        AContext.CurrentHash.I64[5] := UInt64($9B05688C2B3E6C1F);
        AContext.CurrentHash.I64[6] := UInt64($1F83D9ABFB41BD6B);
        AContext.CurrentHash.I64[7] := UInt64($5BE0CD19137E2179);
      end;
  end;
end;

function SwapDWord(a: LongWord): LongWord; inline;
begin
  Result := ((a and $FF) shl 24) or ((a and $FF00) shl 8) or
    ((a and $FF0000) shr 8) or ((a and $FF000000) shr 24);
end;

function SwapQWord(a: Int64): Int64; inline;
begin
  Result := ((a and $FF) shl 56) or ((a and $FF00) shl 40) or
    ((a and $FF0000) shl 24) or ((a and $FF000000) shl 8) or
    ((a and $FF00000000) shr 8) or ((a and $FF0000000000) shr 24) or
    ((a and $FF000000000000) shr 40) or ((a and $FF00000000000000) shr 56);
end;

procedure SHACompress(var AContext: TQSHAContext);
  procedure SHA160Compress;
  var
    a, b, C, d, E: LongWord;
    W: array [0 .. 79] of LongWord;
    I: LongWord;
  begin
    AContext.Index := 0;
    FillChar(W, SizeOf(W), 0);
    Move(AContext.HashBuffer, W, 64);
    for I := 0 to 15 do
      W[I] := SwapDWord(W[I]);
    for I := 16 to 79 do
      W[I] := ((W[I - 3] xor W[I - 8] xor W[I - 14] xor W[I - 16]) shl 1) or
        ((W[I - 3] xor W[I - 8] xor W[I - 14] xor W[I - 16]) shr 31);
    a := AContext.CurrentHash.I32[0];
    b := AContext.CurrentHash.I32[1];
    C := AContext.CurrentHash.I32[2];
    d := AContext.CurrentHash.I32[3];
    E := AContext.CurrentHash.I32[4];
    Inc(E, ((a shl 5) or (a shr 27)) + (d xor (b and (C xor d))) +
      $5A827999 + W[0]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (C xor (a and (b xor C))) +
      $5A827999 + W[1]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (b xor (E and (a xor b))) +
      $5A827999 + W[2]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (a xor (d and (E xor a))) +
      $5A827999 + W[3]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (E xor (C and (d xor E))) +
      $5A827999 + W[4]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (d xor (b and (C xor d))) +
      $5A827999 + W[5]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (C xor (a and (b xor C))) +
      $5A827999 + W[6]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (b xor (E and (a xor b))) +
      $5A827999 + W[7]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (a xor (d and (E xor a))) +
      $5A827999 + W[8]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (E xor (C and (d xor E))) +
      $5A827999 + W[9]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (d xor (b and (C xor d))) +
      $5A827999 + W[10]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (C xor (a and (b xor C))) +
      $5A827999 + W[11]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (b xor (E and (a xor b))) +
      $5A827999 + W[12]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (a xor (d and (E xor a))) +
      $5A827999 + W[13]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (E xor (C and (d xor E))) +
      $5A827999 + W[14]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (d xor (b and (C xor d))) +
      $5A827999 + W[15]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (C xor (a and (b xor C))) +
      $5A827999 + W[16]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (b xor (E and (a xor b))) +
      $5A827999 + W[17]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (a xor (d and (E xor a))) +
      $5A827999 + W[18]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (E xor (C and (d xor E))) +
      $5A827999 + W[19]);
    C := (C shl 30) or (C shr 2);

    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $6ED9EBA1 + W[20]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $6ED9EBA1 + W[21]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $6ED9EBA1 + W[22]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $6ED9EBA1 + W[23]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $6ED9EBA1 + W[24]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $6ED9EBA1 + W[25]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $6ED9EBA1 + W[26]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $6ED9EBA1 + W[27]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $6ED9EBA1 + W[28]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $6ED9EBA1 + W[29]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $6ED9EBA1 + W[30]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $6ED9EBA1 + W[31]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $6ED9EBA1 + W[32]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $6ED9EBA1 + W[33]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $6ED9EBA1 + W[34]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $6ED9EBA1 + W[35]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $6ED9EBA1 + W[36]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $6ED9EBA1 + W[37]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $6ED9EBA1 + W[38]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $6ED9EBA1 + W[39]);
    C := (C shl 30) or (C shr 2);

    Inc(E, ((a shl 5) or (a shr 27)) + ((b and C) or (d and (b or C))) +
      $8F1BBCDC + W[40]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + ((a and b) or (C and (a or b))) +
      $8F1BBCDC + W[41]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + ((E and a) or (b and (E or a))) +
      $8F1BBCDC + W[42]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + ((d and E) or (a and (d or E))) +
      $8F1BBCDC + W[43]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + ((C and d) or (E and (C or d))) +
      $8F1BBCDC + W[44]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + ((b and C) or (d and (b or C))) +
      $8F1BBCDC + W[45]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + ((a and b) or (C and (a or b))) +
      $8F1BBCDC + W[46]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + ((E and a) or (b and (E or a))) +
      $8F1BBCDC + W[47]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + ((d and E) or (a and (d or E))) +
      $8F1BBCDC + W[48]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + ((C and d) or (E and (C or d))) +
      $8F1BBCDC + W[49]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + ((b and C) or (d and (b or C))) +
      $8F1BBCDC + W[50]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + ((a and b) or (C and (a or b))) +
      $8F1BBCDC + W[51]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + ((E and a) or (b and (E or a))) +
      $8F1BBCDC + W[52]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + ((d and E) or (a and (d or E))) +
      $8F1BBCDC + W[53]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + ((C and d) or (E and (C or d))) +
      $8F1BBCDC + W[54]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + ((b and C) or (d and (b or C))) +
      $8F1BBCDC + W[55]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + ((a and b) or (C and (a or b))) +
      $8F1BBCDC + W[56]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + ((E and a) or (b and (E or a))) +
      $8F1BBCDC + W[57]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + ((d and E) or (a and (d or E))) +
      $8F1BBCDC + W[58]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + ((C and d) or (E and (C or d))) +
      $8F1BBCDC + W[59]);
    C := (C shl 30) or (C shr 2);

    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $CA62C1D6 + W[60]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $CA62C1D6 + W[61]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $CA62C1D6 + W[62]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $CA62C1D6 + W[63]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $CA62C1D6 + W[64]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $CA62C1D6 + W[65]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $CA62C1D6 + W[66]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $CA62C1D6 + W[67]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $CA62C1D6 + W[68]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $CA62C1D6 + W[69]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $CA62C1D6 + W[70]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $CA62C1D6 + W[71]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $CA62C1D6 + W[72]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $CA62C1D6 + W[73]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $CA62C1D6 + W[74]);
    C := (C shl 30) or (C shr 2);
    Inc(E, ((a shl 5) or (a shr 27)) + (b xor C xor d) + $CA62C1D6 + W[75]);
    b := (b shl 30) or (b shr 2);
    Inc(d, ((E shl 5) or (E shr 27)) + (a xor b xor C) + $CA62C1D6 + W[76]);
    a := (a shl 30) or (a shr 2);
    Inc(C, ((d shl 5) or (d shr 27)) + (E xor a xor b) + $CA62C1D6 + W[77]);
    E := (E shl 30) or (E shr 2);
    Inc(b, ((C shl 5) or (C shr 27)) + (d xor E xor a) + $CA62C1D6 + W[78]);
    d := (d shl 30) or (d shr 2);
    Inc(a, ((b shl 5) or (b shr 27)) + (C xor d xor E) + $CA62C1D6 + W[79]);
    C := (C shl 30) or (C shr 2);
    AContext.CurrentHash.I32[0] := AContext.CurrentHash.I32[0] + a;
    AContext.CurrentHash.I32[1] := AContext.CurrentHash.I32[1] + b;
    AContext.CurrentHash.I32[2] := AContext.CurrentHash.I32[2] + C;
    AContext.CurrentHash.I32[3] := AContext.CurrentHash.I32[3] + d;
    AContext.CurrentHash.I32[4] := AContext.CurrentHash.I32[4] + E;
    FillChar(AContext.HashBuffer, 64, 0);
  end;
  procedure SHA256Compress;
  var
    a, b, C, d, E, F, G, H, t1, t2: LongWord;
    W: array [0 .. 63] of LongWord;
    I: LongWord;
  begin
    AContext.Index := 0;
    FillChar(W, SizeOf(W), 0);
    a := AContext.CurrentHash.I32[0];
    b := AContext.CurrentHash.I32[1];
    C := AContext.CurrentHash.I32[2];
    d := AContext.CurrentHash.I32[3];
    E := AContext.CurrentHash.I32[4];
    F := AContext.CurrentHash.I32[5];
    G := AContext.CurrentHash.I32[6];
    H := AContext.CurrentHash.I32[7];
    Move(AContext.HashBuffer, W, 64);
    for I := 0 to 15 do
      W[I] := SwapDWord(W[I]);
    for I := 16 to 63 do
      W[I] := (((W[I - 2] shr 17) or (W[I - 2] shl 15))
        xor ((W[I - 2] shr 19) or (W[I - 2] shl 13)) xor (W[I - 2] shr 10)) +
        W[I - 7] + (((W[I - 15] shr 7) or (W[I - 15] shl 25))
        xor ((W[I - 15] shr 18) or (W[I - 15] shl 14)) xor (W[I - 15] shr 3)) +
        W[I - 16];
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $428A2F98 + W[0];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $71374491 + W[1];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $B5C0FBCF + W[2];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $E9B5DBA5 + W[3];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $3956C25B + W[4];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $59F111F1 + W[5];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $923F82A4 + W[6];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $AB1C5ED5 + W[7];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $D807AA98 + W[8];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $12835B01 + W[9];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $243185BE + W[10];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $550C7DC3 + W[11];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $72BE5D74 + W[12];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $80DEB1FE + W[13];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $9BDC06A7 + W[14];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $C19BF174 + W[15];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $E49B69C1 + W[16];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $EFBE4786 + W[17];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $0FC19DC6 + W[18];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $240CA1CC + W[19];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $2DE92C6F + W[20];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $4A7484AA + W[21];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $5CB0A9DC + W[22];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $76F988DA + W[23];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $983E5152 + W[24];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $A831C66D + W[25];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $B00327C8 + W[26];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $BF597FC7 + W[27];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $C6E00BF3 + W[28];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $D5A79147 + W[29];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $06CA6351 + W[30];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $14292967 + W[31];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $27B70A85 + W[32];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $2E1B2138 + W[33];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $4D2C6DFC + W[34];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $53380D13 + W[35];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $650A7354 + W[36];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $766A0ABB + W[37];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $81C2C92E + W[38];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $92722C85 + W[39];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $A2BFE8A1 + W[40];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $A81A664B + W[41];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $C24B8B70 + W[42];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $C76C51A3 + W[43];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $D192E819 + W[44];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $D6990624 + W[45];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $F40E3585 + W[46];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $106AA070 + W[47];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $19A4C116 + W[48];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $1E376C08 + W[49];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $2748774C + W[50];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $34B0BCB5 + W[51];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $391C0CB3 + W[52];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $4ED8AA4A + W[53];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $5B9CCA4F + W[54];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $682E6FF3 + W[55];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    t1 := H + (((E shr 6) or (E shl 26)) xor ((E shr 11) or (E shl 21))
      xor ((E shr 25) or (E shl 7))) + ((E and F) xor (not E and G)) +
      $748F82EE + W[56];
    t2 := (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19))
      xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and C) xor (b and C));
    H := t1 + t2;
    d := d + t1;
    t1 := G + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21))
      xor ((d shr 25) or (d shl 7))) + ((d and E) xor (not d and F)) +
      $78A5636F + W[57];
    t2 := (((H shr 2) or (H shl 30)) xor ((H shr 13) or (H shl 19))
      xor ((H shr 22) xor (H shl 10))) +
      ((H and a) xor (H and b) xor (a and b));
    G := t1 + t2;
    C := C + t1;
    t1 := F + (((C shr 6) or (C shl 26)) xor ((C shr 11) or (C shl 21))
      xor ((C shr 25) or (C shl 7))) + ((C and d) xor (not C and E)) +
      $84C87814 + W[58];
    t2 := (((G shr 2) or (G shl 30)) xor ((G shr 13) or (G shl 19))
      xor ((G shr 22) xor (G shl 10))) +
      ((G and H) xor (G and a) xor (H and a));
    F := t1 + t2;
    b := b + t1;
    t1 := E + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21))
      xor ((b shr 25) or (b shl 7))) + ((b and C) xor (not b and d)) +
      $8CC70208 + W[59];
    t2 := (((F shr 2) or (F shl 30)) xor ((F shr 13) or (F shl 19))
      xor ((F shr 22) xor (F shl 10))) +
      ((F and G) xor (F and H) xor (G and H));
    E := t1 + t2;
    a := a + t1;
    t1 := d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21))
      xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and C)) +
      $90BEFFFA + W[60];
    t2 := (((E shr 2) or (E shl 30)) xor ((E shr 13) or (E shl 19))
      xor ((E shr 22) xor (E shl 10))) +
      ((E and F) xor (E and G) xor (F and G));
    d := t1 + t2;
    H := H + t1;
    t1 := C + (((H shr 6) or (H shl 26)) xor ((H shr 11) or (H shl 21))
      xor ((H shr 25) or (H shl 7))) + ((H and a) xor (not H and b)) +
      $A4506CEB + W[61];
    t2 := (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19))
      xor ((d shr 22) xor (d shl 10))) +
      ((d and E) xor (d and F) xor (E and F));
    C := t1 + t2;
    G := G + t1;
    t1 := b + (((G shr 6) or (G shl 26)) xor ((G shr 11) or (G shl 21))
      xor ((G shr 25) or (G shl 7))) + ((G and H) xor (not G and a)) +
      $BEF9A3F7 + W[62];
    t2 := (((C shr 2) or (C shl 30)) xor ((C shr 13) or (C shl 19))
      xor ((C shr 22) xor (C shl 10))) +
      ((C and d) xor (C and E) xor (d and E));
    b := t1 + t2;
    F := F + t1;
    t1 := a + (((F shr 6) or (F shl 26)) xor ((F shr 11) or (F shl 21))
      xor ((F shr 25) or (F shl 7))) + ((F and G) xor (not F and H)) +
      $C67178F2 + W[63];
    t2 := (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19))
      xor ((b shr 22) xor (b shl 10))) +
      ((b and C) xor (b and d) xor (C and d));
    a := t1 + t2;
    E := E + t1;
    AContext.CurrentHash.I32[0] := AContext.CurrentHash.I32[0] + a;
    AContext.CurrentHash.I32[1] := AContext.CurrentHash.I32[1] + b;
    AContext.CurrentHash.I32[2] := AContext.CurrentHash.I32[2] + C;
    AContext.CurrentHash.I32[3] := AContext.CurrentHash.I32[3] + d;
    AContext.CurrentHash.I32[4] := AContext.CurrentHash.I32[4] + E;
    AContext.CurrentHash.I32[5] := AContext.CurrentHash.I32[5] + F;
    AContext.CurrentHash.I32[6] := AContext.CurrentHash.I32[6] + G;
    AContext.CurrentHash.I32[7] := AContext.CurrentHash.I32[7] + H;
    FillChar(AContext.HashBuffer, 64, 0);
  end;
  procedure SHA384Compress;
  var
    a, b, C, d, E, F, G, H, t1, t2: UInt64;
    W: array [0 .. 79] of UInt64;
    I: LongWord;
  begin
    AContext.Index := 0;
    FillChar(W, SizeOf(W), 0);
    a := AContext.CurrentHash.I64[0];
    b := AContext.CurrentHash.I64[1];
    C := AContext.CurrentHash.I64[2];
    d := AContext.CurrentHash.I64[3];
    E := AContext.CurrentHash.I64[4];
    F := AContext.CurrentHash.I64[5];
    G := AContext.CurrentHash.I64[6];
    H := AContext.CurrentHash.I64[7];
    Move(AContext.HashBuffer, W, 128);
    for I := 0 to 15 do
      W[I] := SwapQWord(W[I]);
    for I := 16 to 79 do
      W[I] := (((W[I - 2] shr 19) or (W[I - 2] shl 45))
        xor ((W[I - 2] shr 61) or (W[I - 2] shl 3)) xor (W[I - 2] shr 6)) +
        W[I - 7] + (((W[I - 15] shr 1) or (W[I - 15] shl 63))
        xor ((W[I - 15] shr 8) or (W[I - 15] shl 56)) xor (W[I - 15] shr 7)) +
        W[I - 16];
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($428A2F98D728AE22) + W[0];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($7137449123EF65CD) + W[1];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($B5C0FBCFEC4D3B2F) + W[2];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($E9B5DBA58189DBBC) + W[3];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($3956C25BF348B538) + W[4];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($59F111F1B605D019) + W[5];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($923F82A4AF194F9B) + W[6];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($AB1C5ED5DA6D8118) + W[7];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($D807AA98A3030242) + W[8];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($12835B0145706FBE) + W[9];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($243185BE4EE4B28C) + W[10];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($550C7DC3D5FFB4E2) + W[11];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($72BE5D74F27B896F) + W[12];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($80DEB1FE3B1696B1) + W[13];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($9BDC06A725C71235) + W[14];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($C19BF174CF692694) + W[15];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($E49B69C19EF14AD2) + W[16];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($EFBE4786384F25E3) + W[17];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($0FC19DC68B8CD5B5) + W[18];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($240CA1CC77AC9C65) + W[19];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($2DE92C6F592B0275) + W[20];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($4A7484AA6EA6E483) + W[21];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($5CB0A9DCBD41FBD4) + W[22];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($76F988DA831153B5) + W[23];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($983E5152EE66DFAB) + W[24];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($A831C66D2DB43210) + W[25];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($B00327C898FB213F) + W[26];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($BF597FC7BEEF0EE4) + W[27];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($C6E00BF33DA88FC2) + W[28];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($D5A79147930AA725) + W[29];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($06CA6351E003826F) + W[30];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($142929670A0E6E70) + W[31];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($27B70A8546D22FFC) + W[32];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($2E1B21385C26C926) + W[33];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($4D2C6DFC5AC42AED) + W[34];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($53380D139D95B3DF) + W[35];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($650A73548BAF63DE) + W[36];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($766A0ABB3C77B2A8) + W[37];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($81C2C92E47EDAEE6) + W[38];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($92722C851482353B) + W[39];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($A2BFE8A14CF10364) + W[40];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($A81A664BBC423001) + W[41];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($C24B8B70D0F89791) + W[42];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($C76C51A30654BE30) + W[43];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($D192E819D6EF5218) + W[44];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($D69906245565A910) + W[45];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($F40E35855771202A) + W[46];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($106AA07032BBD1B8) + W[47];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($19A4C116B8D2D0C8) + W[48];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($1E376C085141AB53) + W[49];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($2748774CDF8EEB99) + W[50];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($34B0BCB5E19B48A8) + W[51];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($391C0CB3C5C95A63) + W[52];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($4ED8AA4AE3418ACB) + W[53];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($5B9CCA4F7763E373) + W[54];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($682E6FF3D6B2B8A3) + W[55];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($748F82EE5DEFB2FC) + W[56];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($78A5636F43172F60) + W[57];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($84C87814A1F0AB72) + W[58];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($8CC702081A6439EC) + W[59];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($90BEFFFA23631E28) + W[60];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($A4506CEBDE82BDE9) + W[61];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($BEF9A3F7B2C67915) + W[62];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($C67178F2E372532B) + W[63];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($CA273ECEEA26619C) + W[64];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($D186B8C721C0C207) + W[65];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($EADA7DD6CDE0EB1E) + W[66];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($F57D4F7FEE6ED178) + W[67];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($06F067AA72176FBA) + W[68];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($0A637DC5A2C898A6) + W[69];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($113F9804BEF90DAE) + W[70];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($1B710B35131C471B) + W[71];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    t1 := H + (((E shr 14) or (E shl 50)) xor ((E shr 18) or (E shl 46))
      xor ((E shr 41) or (E shl 23))) + ((E and F) xor (not E and G)) +
      UInt64($28DB77F523047D84) + W[72];
    t2 := (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30))
      xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and C) xor (b and C));
    d := d + t1;
    H := t1 + t2;
    t1 := G + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46))
      xor ((d shr 41) or (d shl 23))) + ((d and E) xor (not d and F)) +
      UInt64($32CAAB7B40C72493) + W[73];
    t2 := (((H shr 28) or (H shl 36)) xor ((H shr 34) or (H shl 30))
      xor ((H shr 39) or (H shl 25))) + ((H and a) xor (H and b) xor (a and b));
    C := C + t1;
    G := t1 + t2;
    t1 := F + (((C shr 14) or (C shl 50)) xor ((C shr 18) or (C shl 46))
      xor ((C shr 41) or (C shl 23))) + ((C and d) xor (not C and E)) +
      UInt64($3C9EBE0A15C9BEBC) + W[74];
    t2 := (((G shr 28) or (G shl 36)) xor ((G shr 34) or (G shl 30))
      xor ((G shr 39) or (G shl 25))) + ((G and H) xor (G and a) xor (H and a));
    b := b + t1;
    F := t1 + t2;
    t1 := E + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46))
      xor ((b shr 41) or (b shl 23))) + ((b and C) xor (not b and d)) +
      UInt64($431D67C49C100D4C) + W[75];
    t2 := (((F shr 28) or (F shl 36)) xor ((F shr 34) or (F shl 30))
      xor ((F shr 39) or (F shl 25))) + ((F and G) xor (F and H) xor (G and H));
    a := a + t1;
    E := t1 + t2;
    t1 := d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46))
      xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and C)) +
      UInt64($4CC5D4BECB3E42B6) + W[76];
    t2 := (((E shr 28) or (E shl 36)) xor ((E shr 34) or (E shl 30))
      xor ((E shr 39) or (E shl 25))) + ((E and F) xor (E and G) xor (F and G));
    H := H + t1;
    d := t1 + t2;
    t1 := C + (((H shr 14) or (H shl 50)) xor ((H shr 18) or (H shl 46))
      xor ((H shr 41) or (H shl 23))) + ((H and a) xor (not H and b)) +
      UInt64($597F299CFC657E2A) + W[77];
    t2 := (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30))
      xor ((d shr 39) or (d shl 25))) + ((d and E) xor (d and F) xor (E and F));
    G := G + t1;
    C := t1 + t2;
    t1 := b + (((G shr 14) or (G shl 50)) xor ((G shr 18) or (G shl 46))
      xor ((G shr 41) or (G shl 23))) + ((G and H) xor (not G and a)) +
      UInt64($5FCB6FAB3AD6FAEC) + W[78];
    t2 := (((C shr 28) or (C shl 36)) xor ((C shr 34) or (C shl 30))
      xor ((C shr 39) or (C shl 25))) + ((C and d) xor (C and E) xor (d and E));
    F := F + t1;
    b := t1 + t2;
    t1 := a + (((F shr 14) or (F shl 50)) xor ((F shr 18) or (F shl 46))
      xor ((F shr 41) or (F shl 23))) + ((F and G) xor (not F and H)) +
      UInt64($6C44198C4A475817) + W[79];
    t2 := (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30))
      xor ((b shr 39) or (b shl 25))) + ((b and C) xor (b and d) xor (C and d));
    E := E + t1;
    a := t1 + t2;
    AContext.CurrentHash.I64[0] := AContext.CurrentHash.I64[0] + a;
    AContext.CurrentHash.I64[1] := AContext.CurrentHash.I64[1] + b;
    AContext.CurrentHash.I64[2] := AContext.CurrentHash.I64[2] + C;
    AContext.CurrentHash.I64[3] := AContext.CurrentHash.I64[3] + d;
    AContext.CurrentHash.I64[4] := AContext.CurrentHash.I64[4] + E;
    AContext.CurrentHash.I64[5] := AContext.CurrentHash.I64[5] + F;
    AContext.CurrentHash.I64[6] := AContext.CurrentHash.I64[6] + G;
    AContext.CurrentHash.I64[7] := AContext.CurrentHash.I64[7] + H;
    FillChar(AContext.HashBuffer, 128, 0);
  end;
  procedure SHA512Compress;
  begin
    SHA384Compress;
  end;

begin
  case AContext.CurrentHash.HashType of
    sdt160:
      SHA160Compress;
    sdt256:
      SHA256Compress;
    sdt384:
      SHA384Compress;
    sdt512:
      SHA512Compress;
  end;
end;

procedure SHAUpdate(var AContext: TQSHAContext; const p: Pointer;
  ASize: LongWord);
var
  pBuf: PByte;
  procedure SHA160Update;
  begin
    Inc(AContext.LenHi, ASize shr 29);
    Inc(AContext.LenLo, ASize shl 3);
    if AContext.LenLo < (ASize shl 3) then
      Inc(AContext.LenHi);
    pBuf := p;
    while ASize > 0 do
    begin
      if (64 - AContext.Index) <= ASize then
      begin
        Move(pBuf^, AContext.HashBuffer[AContext.Index], 64 - AContext.Index);
        Dec(ASize, 64 - AContext.Index);
        Inc(pBuf, 64 - AContext.Index);
        SHACompress(AContext);
      end
      else
      begin
        Move(pBuf^, AContext.HashBuffer[AContext.Index], ASize);
        Inc(AContext.Index, ASize);
        ASize := 0;
      end;
    end;
  end;
  procedure SHA256Update;
  begin
    Inc(AContext.LenHi, ASize shr 29);
    Inc(AContext.LenLo, ASize shl 3);
    if AContext.LenLo < (ASize shl 3) then
      Inc(AContext.LenHi);
    pBuf := p;
    while ASize > 0 do
    begin
      if (64 - AContext.Index) <= ASize then
      begin
        Move(pBuf^, AContext.HashBuffer[AContext.Index], 64 - AContext.Index);
        Dec(ASize, 64 - AContext.Index);
        Inc(pBuf, 64 - AContext.Index);
        SHACompress(AContext);
      end
      else
      begin
        Move(pBuf^, AContext.HashBuffer[AContext.Index], ASize);
        Inc(AContext.Index, ASize);
        ASize := 0;
      end;
    end;
  end;
  procedure SHA384Update;
  begin
    Inc(AContext.LenLo64, ASize * 8);
    if AContext.LenLo64 < (ASize * 8) then
      Inc(AContext.LenHi64);
    pBuf := p;
    while ASize > 0 do
    begin
      if (128 - AContext.Index) <= ASize then
      begin
        Move(pBuf^, AContext.HashBuffer[AContext.Index], 128 - AContext.Index);
        Dec(ASize, 128 - AContext.Index);
        Inc(pBuf, 128 - AContext.Index);
        SHACompress(AContext);
      end
      else
      begin
        Move(pBuf^, AContext.HashBuffer[AContext.Index], ASize);
        Inc(AContext.Index, ASize);
        ASize := 0;
      end;
    end;
  end;

  procedure SHA512Update;
  begin
    SHA384Update;
  end;

begin
  case AContext.CurrentHash.HashType of
    sdt160:
      SHA160Update;
    sdt256:
      SHA256Update;
    sdt384:
      SHA384Update;
    sdt512:
      SHA512Update;
  end;
end;

procedure SHAFinal(var AContext: TQSHAContext);
  procedure SHA160Final;
  begin
    AContext.HashBuffer[AContext.Index] := $80;
    if AContext.Index >= 56 then
      SHACompress(AContext);
    PLongWord(@AContext.HashBuffer[56])^ := SwapDWord(AContext.LenHi);
    PLongWord(@AContext.HashBuffer[60])^ := SwapDWord(AContext.LenLo);
    SHACompress(AContext);
    AContext.CurrentHash.I32[0] := SwapDWord(AContext.CurrentHash.I32[0]);
    AContext.CurrentHash.I32[1] := SwapDWord(AContext.CurrentHash.I32[1]);
    AContext.CurrentHash.I32[2] := SwapDWord(AContext.CurrentHash.I32[2]);
    AContext.CurrentHash.I32[3] := SwapDWord(AContext.CurrentHash.I32[3]);
    AContext.CurrentHash.I32[4] := SwapDWord(AContext.CurrentHash.I32[4]);
  end;
  procedure SHA256Final;
  begin
    AContext.HashBuffer[AContext.Index] := $80;
    if AContext.Index >= 56 then
      SHACompress(AContext);
    PLongWord(@AContext.HashBuffer[56])^ := SwapDWord(AContext.LenHi);
    PLongWord(@AContext.HashBuffer[60])^ := SwapDWord(AContext.LenLo);
    SHACompress(AContext);
    AContext.CurrentHash.I32[0] := SwapDWord(AContext.CurrentHash.I32[0]);
    AContext.CurrentHash.I32[1] := SwapDWord(AContext.CurrentHash.I32[1]);
    AContext.CurrentHash.I32[2] := SwapDWord(AContext.CurrentHash.I32[2]);
    AContext.CurrentHash.I32[3] := SwapDWord(AContext.CurrentHash.I32[3]);
    AContext.CurrentHash.I32[4] := SwapDWord(AContext.CurrentHash.I32[4]);
    AContext.CurrentHash.I32[5] := SwapDWord(AContext.CurrentHash.I32[5]);
    AContext.CurrentHash.I32[6] := SwapDWord(AContext.CurrentHash.I32[6]);
    AContext.CurrentHash.I32[7] := SwapDWord(AContext.CurrentHash.I32[7]);
  end;

  procedure SHA384Final;
  begin
    AContext.HashBuffer[AContext.Index] := $80;
    if AContext.Index >= 112 then
      SHACompress(AContext);
    PInt64(@AContext.HashBuffer[112])^ := SwapQWord(AContext.LenHi64);
    PInt64(@AContext.HashBuffer[120])^ := SwapQWord(AContext.LenLo64);
    SHACompress(AContext);
    AContext.CurrentHash.I64[0] := SwapQWord(AContext.CurrentHash.I64[0]);
    AContext.CurrentHash.I64[1] := SwapQWord(AContext.CurrentHash.I64[1]);
    AContext.CurrentHash.I64[2] := SwapQWord(AContext.CurrentHash.I64[2]);
    AContext.CurrentHash.I64[3] := SwapQWord(AContext.CurrentHash.I64[3]);
    AContext.CurrentHash.I64[4] := SwapQWord(AContext.CurrentHash.I64[4]);
    AContext.CurrentHash.I64[5] := SwapQWord(AContext.CurrentHash.I64[5]);
  end;
  procedure SHA512Final;
  begin
    AContext.HashBuffer[AContext.Index] := $80;
    if AContext.Index >= 112 then
      SHACompress(AContext);
    PInt64(@AContext.HashBuffer[112])^ := SwapQWord(AContext.LenHi64);
    PInt64(@AContext.HashBuffer[120])^ := SwapQWord(AContext.LenLo64);
    SHACompress(AContext);
    AContext.CurrentHash.I64[0] := SwapQWord(AContext.CurrentHash.I64[0]);
    AContext.CurrentHash.I64[1] := SwapQWord(AContext.CurrentHash.I64[1]);
    AContext.CurrentHash.I64[2] := SwapQWord(AContext.CurrentHash.I64[2]);
    AContext.CurrentHash.I64[3] := SwapQWord(AContext.CurrentHash.I64[3]);
    AContext.CurrentHash.I64[4] := SwapQWord(AContext.CurrentHash.I64[4]);
    AContext.CurrentHash.I64[5] := SwapQWord(AContext.CurrentHash.I64[5]);
    AContext.CurrentHash.I64[6] := SwapQWord(AContext.CurrentHash.I64[6]);
    AContext.CurrentHash.I64[7] := SwapQWord(AContext.CurrentHash.I64[7]);
  end;

begin
  case AContext.CurrentHash.HashType of
    sdt160:
      SHA160Final;
    sdt256:
      SHA256Final;
    sdt384:
      SHA384Final;
    sdt512:
      SHA512Final;
  end;
end;

procedure SHAHash(var ADigest: TQSHADigest; const p: Pointer; len: Integer;
  AType: TQSHADigestType); inline;
var
  AContext: TQSHAContext;
begin
  SHAInit(AContext, AType);
  SHAUpdate(AContext, p, len);
  SHAFinal(AContext);
  ADigest := AContext.CurrentHash;
end;

function SHA160Hash(const p: Pointer; len: Integer): TQSHADigest;
begin
  SHAHash(Result, p, len, sdt160);
end;

procedure SHAHashString(const S: QStringW; AType: TQSHADigestType;
  var ADigest: TQSHADigest);
var
  a: QStringA;
begin
  a := qstring.Utf8Encode(S);
  SHAHash(ADigest, PQCharA(a), a.Length, AType);
end;

procedure SHAHashStream(AStream: TStream; AType: TQSHADigestType;
  var ADigest: TQSHADigest; AOnProgress: TQHashProgressNotify);
var
  AContext: TQSHAContext;
  ABuf: array [0 .. 65535] of Byte;
  AReaded: Integer;
  ALastNotify: Int64;
  procedure DoProgress(AForce: Boolean);
  begin
    if (AStream.Position - ALastNotify > 10485760) or AForce then
    begin
      if TMethod(AOnProgress).Code <> nil then
      begin
{$IFDEF UNICODE}
        if TMethod(AOnProgress).Data = Pointer(-1) then
          TQHashProgressNotifyA(TMethod(AOnProgress).Code)
            (AStream.Position, AStream.Size)
        else
{$ENDIF}
          AOnProgress(AStream.Position, AStream.Size);
      end;
      ALastNotify := AStream.Position;
    end;
  end;

begin
  SHAInit(AContext, AType);
  AStream.Position := 0;
  ALastNotify := 0;
  repeat
    AReaded := AStream.Read(ABuf, 65536);
    if AReaded > 0 then
      SHAUpdate(AContext, @ABuf[0], AReaded);
    DoProgress(False);
  until AReaded = 0;
  SHAFinal(AContext);
  DoProgress(True);
  ADigest := AContext.CurrentHash;
end;

procedure SHAHashFile(AFile: QStringW; AType: TQSHADigestType;
  var ADigest: TQSHADigest; AOnProgress: TQHashProgressNotify);
var
  AStream: TFileStream;
begin
  AStream := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    SHAHashStream(AStream, AType, ADigest, AOnProgress);
  finally
    FreeObject(AStream);
  end;
end;

function SHA160Hash(const S: QStringW): TQSHADigest;
begin
  SHAHashString(S, sdt160, Result);
end;

function SHA160Hash(AStream: TStream; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashStream(AStream, sdt160, Result, AOnProgress);
end;

function SHA160File(AFileName: QStringW;
  AOnProgress: TQHashProgressNotify = nil): TQSHADigest;
begin
  SHAHashFile(AFileName, sdt160, Result, AOnProgress);
end;

{$IFDEF UNICODE}

function SHA160Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA160Hash(AStream, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA160Hash(AStream, TQHashProgressNotify(nil));
end;

function SHA160File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA160File(AFileName, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA160File(AFileName, nil);
end;
{$ENDIF}

function SHA256Hash(const p: Pointer; len: Integer): TQSHADigest;
begin
  SHAHash(Result, p, len, sdt256);
end;

function SHA256Hash(const S: QStringW): TQSHADigest;
begin
  SHAHashString(S, sdt256, Result);
end;

function SHA256Hash(AStream: TStream; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashStream(AStream, sdt256, Result, AOnProgress);
end;

function SHA256File(AFileName: QStringW; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashFile(AFileName, sdt256, Result, AOnProgress);
end;
{$IFDEF UNICODE}

function SHA256Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA256Hash(AStream, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA256Hash(AStream, TQHashProgressNotify(nil));
end;

function SHA256File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA256File(AFileName, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA256File(AFileName, nil);
end;
{$ENDIF}

function SHA384Hash(const p: Pointer; len: Integer): TQSHADigest;
begin
  SHAHash(Result, p, len, sdt384);
end;

function SHA384Hash(const S: QStringW): TQSHADigest;
begin
  SHAHashString(S, sdt384, Result);
end;

function SHA384Hash(AStream: TStream; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashStream(AStream, sdt384, Result, AOnProgress);
end;

function SHA384File(AFileName: QStringW; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashFile(AFileName, sdt384, Result, AOnProgress);
end;

{$IFDEF UNICODE}

function SHA384Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA384Hash(AStream, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA384Hash(AStream, TQHashProgressNotify(nil));
end;

function SHA384File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA384File(AFileName, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA384File(AFileName, TQHashProgressNotify(nil));
end;
{$ENDIF}

function SHA512Hash(const p: Pointer; len: Integer): TQSHADigest;
begin
  SHAHash(Result, p, len, sdt512);
end;

function SHA512Hash(const S: QStringW): TQSHADigest;
begin
  SHAHashString(S, sdt512, Result);
end;

function SHA512Hash(AStream: TStream; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashStream(AStream, sdt512, Result, AOnProgress);
end;

function SHA512File(AFileName: QStringW; AOnProgress: TQHashProgressNotify)
  : TQSHADigest;
begin
  SHAHashFile(AFileName, sdt512, Result, AOnProgress);
end;

{$IFDEF UNICODE}

function SHA512Hash(AStream: TStream; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA512Hash(AStream, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA512Hash(AStream, TQHashProgressNotify(nil));
end;

function SHA512File(AFileName: QStringW; AOnProgress: TQHashProgressNotifyA)
  : TQSHADigest; overload;
var
  AEvent: TQHashProgressNotify;
begin
  if Assigned(AOnProgress) then
  begin
    AEvent := nil;
    try
      PQHashProgressNotifyA(@TMethod(AEvent).Code)^ := AOnProgress;
      TMethod(AEvent).Data := Pointer(-1);
      Result := SHA512File(AFileName, AEvent);
    finally
      TQHashProgressNotifyA(TMethod(AEvent).Code) := nil;
    end;
  end
  else
    Result := SHA512File(AFileName, TQHashProgressNotify(nil));
end;
{$ENDIF}

function DigestToString(const ADigest: TQSHADigest; ALowerCase: Boolean)
  : QStringW;
begin
  case ADigest.HashType of
    sdt160:
      Result := qstring.BinToHex(@ADigest.SHA160[0], 20, ALowerCase);
    sdt256:
      Result := qstring.BinToHex(@ADigest.SHA256[0], 32, ALowerCase);
    sdt384:
      Result := qstring.BinToHex(@ADigest.SHA256[0], 48, ALowerCase);
    sdt512:
      Result := qstring.BinToHex(@ADigest.SHA256[0], 64, ALowerCase)
  else
    SetLength(Result, 0);
  end;
end;
{ TQHashMD5 }

class function TQHashMD5.Create: TQHashMD5;
begin
  Result.Reset;
end;

procedure TQHashMD5.Decode(Dst: PCardinal; Src: PByte; len, AShift: Integer);
var
  J: Integer;
  a, b, C, d: Byte;
begin
  J := 0;
  Inc(Src, AShift);
  while (J < len) do
  begin
    a := Src^;
    Inc(Src);
    b := Src^;
    Inc(Src);
    C := Src^;
    Inc(Src);
    d := Src^;
    Inc(Src);
    Dst^ := Cardinal(a and $FF) or (Cardinal(b and $FF) shl 8) or
      (Cardinal(C and $FF) shl 16) or (Cardinal(d and $FF) shl 24);
    Inc(J, 4);
    Inc(Dst);
  end;
end;

procedure TQHashMD5.Encode(Dst: PByte; Src: PCardinal; len: Integer);
var
  J: Integer;
begin
  J := 0;
  while J < len do
  begin
    Dst^ := Byte((Src^) and $FF);
    Inc(Dst);
    Dst^ := Byte((Src^ shr 8) and $FF);
    Inc(Dst);
    Dst^ := Byte((Src^ shr 16) and $FF);
    Inc(Dst);
    Dst^ := Byte((Src^ shr 24) and $FF);
    Inc(Dst);
    Inc(J, 4);
    Inc(Src);
  end;
end;

procedure TQHashMD5.FinalizeHash;
var
  Bits: TContextBuffer;
  Index: Integer;
  PadLen: Cardinal;
begin
  { Save number of bits }
  Encode(PByte(@Bits[0]), PCardinal(@FContextCount[0]), 8);
  { Pad out to 56 mod 64 }
  Index := (FContextCount[0] shr 3) and $3F;
  if Index < 56 then
    PadLen := 56 - Index
  else
    PadLen := 120 - Index;
  Update(PByte(@FPadding[0]), PadLen);
  { Append length (before padding) }
  Update(PByte(@Bits[0]), 8);
end;

function TQHashMD5.GetDigest: TQMD5Digest;
begin
  if not FFinalized then
    FinalizeHash;
  { Store state in digest }
  Encode(PByte(@Result), PCardinal(@FContextState[0]), 16);
end;

class function TQHashMD5.GetHashBytes(const AData: QStringW): TBytes;
var
  LMD5: TQHashMD5;
  ADigest: TQMD5Digest;
begin
  LMD5 := TQHashMD5.Create;
  LMD5.Update(AData);
  SetLength(Result, 16);
  ADigest := LMD5.GetDigest;
  Move(ADigest, Result[0], 16);
end;

class function TQHashMD5.GetHashString(const AString: QStringW): QStringW;
var
  LMD5: TQHashMD5;
begin
  LMD5 := TQHashMD5.Create;
  LMD5.Update(AString);
  Result := LMD5.HashAsString;
end;

class function TQHashMD5.GetHMAC(const AData, AKey: QStringW): QStringW;
begin
  Result := DigestToString(GetHMACAsBytes(AData, AKey));
end;

class function TQHashMD5.GetHMACAsBytes(const AData, AKey: QStringW)
  : TQMD5Digest;
const
  CInnerPad: Byte = $36;
  COuterPad: Byte = $5C;
  FHashSize: Integer = 16;
  FBlockSize: Integer = 64;
var
  TempBuffer1: TBytes;
  TempBuffer2: TBytes;
  FKey: TBytes;
  LKey: TBytes;
  I: Integer;
  FHash: TQHashMD5;
  LBuffer: TBytes;
begin
  FHash := TQHashMD5.Create;

  LBuffer := qstring.Utf8Encode(AData);
  FKey := qstring.Utf8Encode(AKey);
  if Length(FKey) > FBlockSize then
  begin
    FHash.Update(FKey);
    FKey := FHash.HashAsBytes
  end;

  LKey := Copy(FKey, 0, MaxInt);
  SetLength(LKey, FBlockSize);
  SetLength(TempBuffer1, FBlockSize + Length(LBuffer));
  for I := Low(LKey) to High(LKey) do
  begin
    TempBuffer1[I] := LKey[I] xor CInnerPad;
  end;
  if Length(LBuffer) > 0 then
    Move(LBuffer[0], TempBuffer1[Length(LKey)], Length(LBuffer));

  FHash.Reset;
  FHash.Update(TempBuffer1);
  TempBuffer2 := FHash.HashAsBytes;

  SetLength(TempBuffer1, FBlockSize + FHashSize);
  for I := Low(LKey) to High(LKey) do
  begin
    TempBuffer1[I] := LKey[I] xor COuterPad;
  end;
  Move(TempBuffer2[0], TempBuffer1[Length(LKey)], Length(TempBuffer2));

  FHash.Reset;
  FHash.Update(TempBuffer1);
  Result := FHash.GetDigest;
end;

function TQHashMD5.HashAsBytes: TBytes;
var
  ADigest: TQMD5Digest;
begin
  SetLength(Result, 16);
  ADigest := GetDigest;
  Move(ADigest, Result[0], 16);
end;

function TQHashMD5.HashAsString: QStringW;
begin
  Result := DigestToString(GetDigest);
end;

procedure TQHashMD5.Reset;
begin
  FillChar(FPadding, 64, 0);
  FPadding[0] := $80;
  FContextCount[0] := 0;
  FContextCount[1] := 0;
  FContextState[0] := $67452301;
  FContextState[1] := $EFCDAB89;
  FContextState[2] := $98BADCFE;
  FContextState[3] := $10325476;
  FillChar(FContextBuffer, 64, 0);
  FFinalized := False;
end;

procedure TQHashMD5.Transform(const ABlock: PByte; AShift: Integer);

  function F(x, y, z: Cardinal): Cardinal; inline;
  begin
    Result := (x and y) or ((not x) and z);
  end;

  function G(x, y, z: Cardinal): Cardinal; inline;
  begin
    Result := (x and z) or (y and (not z));
  end;

  function H(x, y, z: Cardinal): Cardinal; inline;
  begin
    Result := x xor y xor z;
  end;

  function I(x, y, z: Cardinal): Cardinal; inline;
  begin
    Result := y xor (x or (not z));
  end;

  procedure RL(var x: Cardinal; n: Byte); inline;
  begin
    x := (x shl n) or (x shr (32 - n));
  end;

  procedure FF(var a: Cardinal; b, C, d, x: Cardinal; S: Byte; ac: Cardinal);
  begin
    Inc(a, F(b, C, d) + x + ac);
    RL(a, S);
    Inc(a, b);
  end;

  procedure GG(var a: Cardinal; b, C, d, x: Cardinal; S: Byte; ac: Cardinal);
  begin
    Inc(a, G(b, C, d) + x + ac);
    RL(a, S);
    Inc(a, b);
  end;

  procedure HH(var a: Cardinal; b, C, d, x: Cardinal; S: Byte; ac: Cardinal);
  begin
    Inc(a, H(b, C, d) + x + ac);
    RL(a, S);
    Inc(a, b);
  end;

  procedure II(var a: Cardinal; b, C, d, x: Cardinal; S: Byte; ac: Cardinal);
  begin
    Inc(a, I(b, C, d) + x + ac);
    RL(a, S);
    Inc(a, b);
  end;

const
  S11 = 7;
  S12 = 12;
  S13 = 17;
  S14 = 22;

  S21 = 5;
  S22 = 9;
  S23 = 14;
  S24 = 20;

  S31 = 4;
  S32 = 11;
  S33 = 16;
  S34 = 23;

  S41 = 6;
  S42 = 10;
  S43 = 15;
  S44 = 21;

var
  a, b, C, d: Cardinal;
  x: TContextState;
begin
  a := FContextState[0];
  b := FContextState[1];
  C := FContextState[2];
  d := FContextState[3];

  Decode(PCardinal(@x[0]), ABlock, 64, AShift);

  { Round 1 }
  FF(a, b, C, d, x[0], S11, $D76AA478); { 1 }
  FF(d, a, b, C, x[1], S12, $E8C7B756); { 2 }
  FF(C, d, a, b, x[2], S13, $242070DB); { 3 }
  FF(b, C, d, a, x[3], S14, $C1BDCEEE); { 4 }
  FF(a, b, C, d, x[4], S11, $F57C0FAF); { 5 }
  FF(d, a, b, C, x[5], S12, $4787C62A); { 6 }
  FF(C, d, a, b, x[6], S13, $A8304613); { 7 }
  FF(b, C, d, a, x[7], S14, $FD469501); { 8 }
  FF(a, b, C, d, x[8], S11, $698098D8); { 9 }
  FF(d, a, b, C, x[9], S12, $8B44F7AF); { 10 }
  FF(C, d, a, b, x[10], S13, $FFFF5BB1); { 11 }
  FF(b, C, d, a, x[11], S14, $895CD7BE); { 12 }
  FF(a, b, C, d, x[12], S11, $6B901122); { 13 }
  FF(d, a, b, C, x[13], S12, $FD987193); { 14 }
  FF(C, d, a, b, x[14], S13, $A679438E); { 15 }
  FF(b, C, d, a, x[15], S14, $49B40821); { 16 }

  { Round 2 }
  GG(a, b, C, d, x[1], S21, $F61E2562); { 17 }
  GG(d, a, b, C, x[6], S22, $C040B340); { 18 }
  GG(C, d, a, b, x[11], S23, $265E5A51); { 19 }
  GG(b, C, d, a, x[0], S24, $E9B6C7AA); { 20 }
  GG(a, b, C, d, x[5], S21, $D62F105D); { 21 }
  GG(d, a, b, C, x[10], S22, $2441453); { 22 }
  GG(C, d, a, b, x[15], S23, $D8A1E681); { 23 }
  GG(b, C, d, a, x[4], S24, $E7D3FBC8); { 24 }
  GG(a, b, C, d, x[9], S21, $21E1CDE6); { 25 }
  GG(d, a, b, C, x[14], S22, $C33707D6); { 26 }
  GG(C, d, a, b, x[3], S23, $F4D50D87); { 27 }
  GG(b, C, d, a, x[8], S24, $455A14ED); { 28 }
  GG(a, b, C, d, x[13], S21, $A9E3E905); { 29 }
  GG(d, a, b, C, x[2], S22, $FCEFA3F8); { 30 }
  GG(C, d, a, b, x[7], S23, $676F02D9); { 31 }
  GG(b, C, d, a, x[12], S24, $8D2A4C8A); { 32 }

  { Round 3 }
  HH(a, b, C, d, x[5], S31, $FFFA3942); { 33 }
  HH(d, a, b, C, x[8], S32, $8771F681); { 34 }
  HH(C, d, a, b, x[11], S33, $6D9D6122); { 35 }
  HH(b, C, d, a, x[14], S34, $FDE5380C); { 36 }
  HH(a, b, C, d, x[1], S31, $A4BEEA44); { 37 }
  HH(d, a, b, C, x[4], S32, $4BDECFA9); { 38 }
  HH(C, d, a, b, x[7], S33, $F6BB4B60); { 39 }
  HH(b, C, d, a, x[10], S34, $BEBFBC70); { 40 }
  HH(a, b, C, d, x[13], S31, $289B7EC6); { 41 }
  HH(d, a, b, C, x[0], S32, $EAA127FA); { 42 }
  HH(C, d, a, b, x[3], S33, $D4EF3085); { 43 }
  HH(b, C, d, a, x[6], S34, $4881D05); { 44 }
  HH(a, b, C, d, x[9], S31, $D9D4D039); { 45 }
  HH(d, a, b, C, x[12], S32, $E6DB99E5); { 46 }
  HH(C, d, a, b, x[15], S33, $1FA27CF8); { 47 }
  HH(b, C, d, a, x[2], S34, $C4AC5665); { 48 }

  { Round 4 }
  II(a, b, C, d, x[0], S41, $F4292244); { 49 }
  II(d, a, b, C, x[7], S42, $432AFF97); { 50 }
  II(C, d, a, b, x[14], S43, $AB9423A7); { 51 }
  II(b, C, d, a, x[5], S44, $FC93A039); { 52 }
  II(a, b, C, d, x[12], S41, $655B59C3); { 53 }
  II(d, a, b, C, x[3], S42, $8F0CCC92); { 54 }
  II(C, d, a, b, x[10], S43, $FFEFF47D); { 55 }
  II(b, C, d, a, x[1], S44, $85845DD1); { 56 }
  II(a, b, C, d, x[8], S41, $6FA87E4F); { 57 }
  II(d, a, b, C, x[15], S42, $FE2CE6E0); { 58 }
  II(C, d, a, b, x[6], S43, $A3014314); { 59 }
  II(b, C, d, a, x[13], S44, $4E0811A1); { 60 }
  II(a, b, C, d, x[4], S41, $F7537E82); { 61 }
  II(d, a, b, C, x[11], S42, $BD3AF235); { 62 }
  II(C, d, a, b, x[2], S43, $2AD7D2BB); { 63 }
  II(b, C, d, a, x[9], S44, $EB86D391); { 64 }

  Inc(FContextState[0], a);
  Inc(FContextState[1], b);
  Inc(FContextState[2], C);
  Inc(FContextState[3], d);
end;

procedure TQHashMD5.Update(const AData; ALength: Cardinal);
begin
  Update(PByte(AData), ALength);
end;

procedure TQHashMD5.Update(AData: PByte; ALength: Cardinal);
var
  Index, PartLen, I: Cardinal;
begin
  if FFinalized then
    raise Exception.Create(SHashCanNotUpdateMD5);

  { Compute number of bytes mod 64 }
  Index := (FContextCount[0] shr 3) and $3F;
  { Update number of bits }
  Inc(FContextCount[0], ALength shl 3);
  if FContextCount[0] < (ALength shl 3) then
    Inc(FContextCount[1]);
  Inc(FContextCount[1], ALength shr 29);
  PartLen := 64 - Index;

  { Transform (as many times as possible) }
  if ALength >= PartLen then
  begin
    Move(AData^, FContextBuffer[Index], PartLen);
    Transform(PByte(@FContextBuffer[0]), 0);
    I := PartLen;
    while (I + 63) < ALength do
    begin
      Transform(AData, I);
      Inc(I, 64);
    end;
    Index := 0;
  end
  else
    I := 0;

  { Input remaining input }
  if I < ALength then
  begin
    Inc(AData, I);
    Move(AData^, FContextBuffer[Index], ALength - I);
  end;
end;

procedure TQHashMD5.Update(const Input: QStringW);
var
  AUtf8: QStringA;
begin
  AUtf8 := qstring.Utf8Encode(Input);
  Update(AUtf8.Data, AUtf8.Length);
end;

procedure TQHashMD5.Update(const AData: TBytes; ALength: Cardinal);
var
  LLen: Cardinal;
begin
  LLen := ALength;
  if LLen = 0 then
    LLen := Length(AData);
  Update(PByte(AData), LLen);
end;

end.

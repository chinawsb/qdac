program serdestest;
{$APPTYPE CONSOLE}
uses System.SysUtils, System.Classes, System.DateUtils, System.Math, Winapi.Windows, qdac.common in 'C:\temp\qdac-4.0\source\qdac.common.pas', qdac.json.core in 'C:\temp\qdac-4.0\source\qdac.json.core.pas', qdac.serialize.core in 'C:\temp\qdac-4.0\source\qdac.serialize.core.pas';

type
  TSerEnum = (seA, seB, seC);
  TSerFlags = set of (sfX, sfY, sfZ);
  TSerSimple = record
    IntVal: Integer;
    FloatVal: Double;
    StrVal: string;
    BoolVal: Boolean;
    EnumVal: TSerEnum;
    SetVal: TSerFlags;
  end;
  TSerInner = record
    Name: string;
    Value: Integer;
  end;
  TSerNested = record
    Title: string;
    Child: TSerInner;
    Ratio: Double;
  end;

var
  S: TBytesStream;
  Err: Integer;
procedure C(Cond: Boolean; const Msg: string);
begin
  if not Cond then begin
    Inc(Err);
    Writeln('FAIL: ', Msg);
  end
  else
    Write('.');
end;

begin
  // T1: Simple + Set + Enum
  var R1: TSerSimple;
  R1.IntVal := -42;
  R1.FloatVal := 3.14;
  R1.StrVal := 'hi';
  R1.BoolVal := True;
  R1.EnumVal := seB;
  R1.SetVal := [sfX, sfZ];
  S := TBytesStream.Create;
  TQSerializer.Current.SaveToStream<TSerSimple>(R1, S, 'json');
  S.Position := 0;
  var R2: TSerSimple := Default(TSerSimple);
  TQSerializer.Current.LoadFromStream<TSerSimple>(R2, S);
  C(R2.IntVal = -42, 'Int');
  C(Abs(R2.FloatVal - 3.14) < 0.001, 'Flt');
  C(R2.StrVal = 'hi', 'Str');
  C(R2.BoolVal = True, 'Bool');
  C(R2.EnumVal = seB, 'Enum');
  C(sfX in R2.SetVal, 'SetX');
  FreeAndNil(S);

  // T2: Nested record (tkMRecord)
  var N1: TSerNested;
  N1.Title := 'P';
  N1.Child.Name := 'C1';
  N1.Child.Value := 42;
  N1.Ratio := 0.5;
  S := TBytesStream.Create;
  TQSerializer.Current.SaveToStream<TSerNested>(N1, S, 'json');
  S.Position := 0;
  var N2: TSerNested := Default(TSerNested);
  TQSerializer.Current.LoadFromStream<TSerNested>(N2, S);
  C(N2.Title = 'P', 'Tit');
  C(N2.Child.Name = 'C1', 'CN');
  C(N2.Child.Value = 42, 'CV');
  C(Abs(N2.Ratio - 0.5) < 0.001, 'Rat');
  FreeAndNil(S);

  Writeln;
  if Err = 0 then
    Writeln('ALL PASSED')
  else
    Writeln(Err, ' FAILED');
end.

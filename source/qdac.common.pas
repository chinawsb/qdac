unit qdac.common;

interface
uses System.Classes,System.SysUtils,System.Generics.Collections;

{$I qdac.inc}
type
  SizeInt=NativeUInt;
  TUnicodeStringArray=TArray<UnicodeString>;
  TStringArray=TUnicodeStringArray;

const
  {$IFDEF NEXTGEN}
  STRING_FIRST_INDEX=0;
  {$ELSE}
  STRING_FIRST_INDEX=1;
  {$ENDIF}
implementation

end.

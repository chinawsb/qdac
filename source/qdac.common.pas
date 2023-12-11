unit qdac.common;

interface
uses System.Classes,System.SysUtils,System.Generics.Collections;

{$I qdac.inc}
type
  SizeInt=NativeUInt;
  TUnicodeStringArray=TArray<UnicodeString>;
  TStringArray=TUnicodeStringArray;

const
  //NEXTGEN是XE3加入的编译器选项，10.4Sydney开始NEXTGEN已被移除
  {$IFDEF NEXTGEN}
  STRING_FIRST_INDEX=0;
  {$ELSE}
  STRING_FIRST_INDEX=1;
  {$ENDIF}
implementation

end.

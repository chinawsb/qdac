{
QDAC 4.0
=========
This file used for feather set by compiler version.
If a feather only support special version,define it in this file.
}

{$IFDEF FPC}

  {$MESSAGE 'Compile with Free Pascal'}
  //FPC Ĭ��ʹ�� UTF-8 ���룬�����л�Ϊ Unicode
  {$MODE DELPHIUNICODE}

  {$IF DEFINED(FPC_FULLVERSION) AND (FPC_FULLVERSION < 30301) }

    {$ERROR 'At least FPC 3.3.1 needed.'}

  {$ENDIF}

{$ELSE}

  {$MESSAGE 'Compile with Delphi'}

  {$IF RTLVersion<24}

    {$ERROR 'At least XE 3 + needed.'}

  {$ENDIF}

{$ENDIF}

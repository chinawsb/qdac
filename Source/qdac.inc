{
QDAC 4.0
=========
This file used for feather set by compiler version.
If a feather only support special version,define it in this file.
}

{$IFDEF FPC_FULLVERSION}

//Free Pascal

  {$IF FPC_FULLVERSION<30301}
    {$ERROR At least FPC 3.3.1 needed.}
  {$ENDIF}

{$ELSE}

//Delphi/C++ Builder

  {$IF RTLVersion<24}
    {$ERROR At least XE 3 + needed.}
  {$ENDIF}

{$ENDIF}


unit qdac.serialize.base;

interface

uses System.Classes, System.Sysutils, System.TypInfo;

type
  IQSerialize = interface
    ['{569BD7DF-BB0C-47E0-B6B2-A593CCEF2730}']
    function GetType: PTypeInfo;
    function ToValue(const ASource: Pointer; AInstance: Pointer): Boolean;
    function FromValue(ATarget: Pointer; AInstance: Pointer): Boolean;
  end;

  IQTextSerialize = interface(IQSerialize)
    ['{290F060A-499A-4615-AE73-B16E3A613CAD}']
    function ToText(const ASource: String; AInstance: Pointer): Boolean;
    function FromText(var ATarget: String; AInstance: Pointer): Boolean;
  end;

  TQSerializes = TArray<IQSerialize>;

  TQBaseSerialize = class(TInterfacedObject, IQSerialize)
  protected
    FType: PTypeInfo;
    function GetType: PTypeInfo;
    function ToValue(const ASource: Pointer; AInstance: Pointer): Boolean; virtual; abstract;
    function FromValue(ATarget: Pointer; AInstance: Pointer): Boolean; virtual; abstract;
  end;

  TQTextSerialize = class(TQBaseSerialize, IQTextSerialize)
  protected
    function ToValue(const ASource: Pointer; AInstance: Pointer): Boolean; override;
    function FromValue(ATarget: Pointer; AInstance: Pointer): Boolean; override;
    function ToText(const ASource: String; AInstance: Pointer): Boolean; virtual;
    function FromText(var ATarget: String; AInstance: Pointer): Boolean; virtual;
  end;
  
implementation

{ TQBaseSerialize }

function TQBaseSerialize.GetType: PTypeInfo;
begin
  Result := FType;
end;

{ TQTextSerialize }

function TQTextSerialize.FromText(var ATarget: String; AInstance: Pointer): Boolean;
begin
  Result := false;
end;

function TQTextSerialize.FromValue(ATarget, AInstance: Pointer): Boolean;
begin
  Result := FromText(PString(ATarget)^, AInstance);
end;

function TQTextSerialize.ToText(const ASource: String; AInstance: Pointer): Boolean;
begin
  Result := false;
end;

function TQTextSerialize.ToValue(const ASource: Pointer; AInstance: Pointer): Boolean;
begin
  Result := ToText(PString(ASource)^, AInstance);
end;

end.

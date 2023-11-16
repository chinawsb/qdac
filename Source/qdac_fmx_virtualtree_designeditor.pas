unit qdac_fmx_virtualtree_designeditor;

interface

uses classes, sysutils, VCLEditors, DesignEditors, DesignIntf,
  qdac_fmx_virtualtree;

type
  TVTDefaultEditor = class(TComponentEditor)
  public
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;

implementation

uses ColnEdit;
{ TVTDefaultEditor }

procedure TVTDefaultEditor.Edit;
begin
  inherited;

end;

procedure TVTDefaultEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
      ShowCollectionEditor(Designer, Component, TQVirtualTreeView(Component)
        .Header.Columns, 'Header.Columns')
  else
    inherited;
  end;

end;

function TVTDefaultEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit &Header Columns';
end;

function TVTDefaultEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure Register;
begin
  RegisterComponentEditor(TQVirtualTreeView, TVTDefaultEditor);
end;

end.

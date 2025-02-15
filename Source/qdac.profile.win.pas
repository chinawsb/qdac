unit qdac.profile.win;

interface

uses System.Classes, System.SysUtils, qdac.profile, JclDebug, JclSysInfo,
  JclFileUtils;

implementation

// Windows 平台我们使用 Jcl 来将地址转换为函数名，以避免重写相关函数
function JclAddressName(const Addr: Pointer): String;
var
  Info, StartProcInfo: TJclLocationInfo;
  OffsetStr, StartProcOffsetStr, FixedProcedureName,
    UnitNameWithoutUnitscope: string;
  Module: HMODULE;
begin
  OffsetStr := '';
  if GetLocationInfo(Addr, Info) then
    with Info do
    begin
      FixedProcedureName := ProcedureName;
      if Pos(UnitName + '.', FixedProcedureName) = 1 then
        FixedProcedureName := Copy(FixedProcedureName, Length(UnitName) + 2,
          Length(FixedProcedureName) - Length(UnitName) - 1)
      else if Pos('.', UnitName) > 1 then
      begin
        UnitNameWithoutUnitscope := UnitName;
        Delete(UnitNameWithoutUnitscope, 1, Pos('.', UnitNameWithoutUnitscope));
        if Pos(LowerCase(UnitNameWithoutUnitscope) + '.',
          LowerCase(FixedProcedureName)) = 1 then
          FixedProcedureName := Copy(FixedProcedureName,
            Length(UnitNameWithoutUnitscope) + 2, Length(FixedProcedureName) -
            Length(UnitNameWithoutUnitscope) - 1);
      end;

      if LineNumber > 0 then
        Result := Format('%s.%s+L%u', [UnitName, FixedProcedureName,
          LineNumber])
      else
      begin
        if UnitName <> '' then
          Result := Format('%s.%s%s', [UnitName, FixedProcedureName, OffsetStr])
        else
          Result := Format('%s%s', [Addr, FixedProcedureName, OffsetStr]);
      end;
    end
  else
  begin
    Module := ModuleFromAddr(Addr);
    Result := Format('%s.%p', [ExtractFileName(GetModulePath(Module)), Addr]);
  end;
end;

initialization

TQProfile.AddressName := JclAddressName;

end.

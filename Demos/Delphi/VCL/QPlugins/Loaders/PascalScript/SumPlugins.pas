unit SumPlugins;

function Sum1Vs2(X,Y:Integer):Integer;
begin
Result:=X+Y;
end;

procedure RegisterServices;
begin
  RegisterService('{334E47E0-E0FB-4101-9936-2EA638721C6E}','Services','����1+2��ֵ','Sum1Vs2')
end;

end.

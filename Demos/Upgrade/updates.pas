unit updates;

interface

uses classes, sysutils, forms, qstring, qworker, qjson, system.Net.HttpClient;

type
  TAppUpdate = class
  protected
    FHttpClient: THttpClient;
    FDownloadJob: IntPtr;
    procedure DoDownloadFile(AJob: PQJob);
    procedure DoMenuClick(ASender: TObject);
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure BeginUpgrade;
  end;

implementation

uses dialogs, windows, Unit1, menus;

var
  AppUpdate: TAppUpdate;

procedure DoStarting(AJob: PQJob);
var
  AMenuItem: TMenuItem;
begin
  AMenuItem := TMenuItem.Create(Application);
  AMenuItem.Caption := '在线更新';
  AMenuItem.OnClick := AppUpdate.DoMenuClick;
  Form1.miTools.Add(AMenuItem);
  OutputDebugString('Starting');
end;

procedure DoStarted(AJob: PQJob);
begin
  if not Assigned(AppUpdate) then
  begin
    AppUpdate := TAppUpdate.Create;
    AppUpdate.BeginUpgrade;
  end;
end;

procedure DoStopping(AJob: PQJob);
begin
  if Assigned(AppUpdate) then
    Workers.ClearSingleJob(AppUpdate.FDownloadJob);
  // OutputDebugString('Stopping');
end;

{ TAppUpdate }

procedure TAppUpdate.BeginUpgrade;
var
  AResponse: IHttpResponse;
  AJson: TQJson;
begin
  // AResponse := FHttpClient.Get('http://www.qdac.cc/qlang/update?ver=' +
  // GetFileVersion(Application.ExeName) + '&langid' +
  // IntToStr(TLanguages.UserDefaultLocale));
  // if Assigned(AResponse) and (AResponse.StatusCode = 200) then
  // begin
  AJson := TQJson.Create;
  try
    AJson.Add('result').AsInteger := 0;
    AJson.Add('version').AsString := '2.1.2';
    AJson.Add('desc').AsString := '这是一个新版本';
    AJson.Add('url').AsString := 'http://www.qdac.cc/abc.php';
    // if AJson.TryParse(AResponse.ContentAsString()) then
    begin
      RunInMainThread(
        procedure
        var
          AText: String;
        begin
          if AJson.IntByName('result', -1) = 0 then
          begin
            AText := Format('服务器发现新版本：%s,更新说明如下：'#13#10'%s'#13#10'是否下载更新？',
              [AJson.ValueByName('version', ''),
              AJson.ValueByName('desc', '')]);
            if Application.MessageBox(PChar(AText), PChar(Application.Title),
              MB_YESNO or MB_ICONQUESTION) = IDYES then
            begin
              FDownloadJob := Workers.Post(DoDownloadFile, AJson);
              // Workers.Post(DoDownloadUpdate,
              // TQJobExtData.Create(AJson.ValueByName('url', '')), False,
              // jdfFreeAsObject);
            end
            else
              Workers.Post(
                procedure(AJob: PQJob)
                begin
                  FreeAndNil(AppUpdate);
                end,nil);
          end;
        end);
    end;
  finally
    FreeObject(AJson);
  end;
  // end
  // else
  // RunInMainThread(
  // procedure
  // begin
  // Application.MessageBox(PChar(_('无法从服务器获取新版本，服务器不可用或者网络故障')),
  // PChar(Application.Title), MB_OK or MB_ICONSTOP);
  // end);
end;

constructor TAppUpdate.Create;
begin
  FHttpClient := THttpClient.Create;
end;

destructor TAppUpdate.Destroy;
begin
  FreeAndNil(FHttpClient);
  inherited;
end;

procedure TAppUpdate.DoDownloadFile(AJob: PQJob);
var
  AProgress: Integer;
begin
  AProgress := 0;
  while (AProgress < 100) and (not AJob.IsTerminated) do
  begin
    Inc(AProgress, 10);
    Sleep(100);
    Workers.Signal('Progress.Update', Pointer(AProgress));
  end;
end;

procedure TAppUpdate.DoMenuClick(ASender: TObject);
begin
  if not Assigned(AppUpdate) then
    DoStarted(nil);
end;

initialization

Workers.Wait(DoStarting, Workers.RegisterSignal('Application.Starting'), true);
Workers.Wait(DoStarted, Workers.RegisterSignal('Application.Started'), False);
Workers.Wait(DoStopping, Workers.RegisterSignal('Application.Stopping'), False);

end.

unit main;

interface

{ ʾ��˵��
  ����ʾ������Ҫ��Ϊ����ʾ QWorker ����ع��ܵ��÷�����Ȼʵ�ʹ���Ҳ�ǿ��õġ�
  ����ʾ������Ҫ����ʾ��������߳���ʹ�� For ���м��㡣
}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Types,
  System.Classes, Vcl.Graphics, Masks,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, QString, QWorker,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TCommentToken = record
    Line: QStringW;
    BlockStart: QStringW;
    BlockEnd: QStringW;
  end;

  TFileItem = record
    FileName: QStringW;
    Lines: Integer;
    FileSize: Int64;
  end;

  PFileItem = ^TFileItem;

  TForm1 = class(TForm)
    Label1: TLabel;
    edtFolder: TEdit;
    btnBrowse: TButton;
    Label2: TLabel;
    edtMask: TEdit;
    cbxMaskStyles: TComboBox;
    Label3: TLabel;
    edtLineComment: TEdit;
    Label4: TLabel;
    edtBlockCommentStart: TEdit;
    Label5: TLabel;
    edtBlockCommentStop: TEdit;
    chkIgnoreComments: TCheckBox;
    mmResult: TMemo;
    Label6: TLabel;
    btnStart: TButton;
    chkIncludeSubDir: TCheckBox;
    Image1: TImage;
    Label7: TLabel;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbxMaskStylesChange(Sender: TObject);
    procedure Label7Click(Sender: TObject);
  private
    { Private declarations }
    FFiles: TList;
    FComment: TCommentToken;
    FIgnoreComments: Boolean;
    FTotalLines: Integer;
    FMasks: TList;
    procedure DoScanLines(ALoopMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt);
    function BreakScan: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses shlobj, shellapi;
{$R *.dfm}

function TForm1.BreakScan: Boolean;
begin
Result := application.Terminated or (btnStart.Tag <> 1);
end;

procedure TForm1.btnBrowseClick(Sender: TObject);
var
  S: QStringW;
  function BrowseForFolder(const ATitle: string): String;
  var
    Info: TBrowseInfo;
    IDList: pItemIDList;
    Buffer: PChar;
  begin
  Result := '';
  Buffer := StrAlloc(MAX_PATH);
  with Info do
    begin
    hwndOwner := Handle; { Ŀ¼�Ի��������Ĵ��ھ�� }
    pidlRoot := nil; { ��ʼλ�ã�ȱʡΪ�ҵĵ��� }
    pszDisplayName := Buffer; { ���ڴ��ѡ��Ŀ¼��ָ�� }
    lpszTitle := PChar(ATitle);
    ulFlags := BIF_RETURNONLYFSDIRS;
    lpfn := nil; { ָ���ص�����ָ�� }
    lParam := 0; { ���ݸ��ص��������� }
    IDList := SHBrowseForFolder(Info); { ��ȡĿ¼��Ϣ }
    end;
  if IDList <> nil then
    begin
    SHGetPathFromIDList(IDList, Buffer); { ��Ŀ¼��Ϣת��Ϊ·���ַ��� }
    Result := strpas(Buffer);
    end;
  StrDispose(Buffer);
  end;

begin
S := BrowseForFolder('����ļ�����Ŀ¼');
if Length(S) > 0 then
  begin
  edtFolder.Text := S;
  end;
end;

procedure TForm1.btnStartClick(Sender: TObject);
var
  T: Cardinal;
  I: Integer;
  AItem: PFileItem;
  procedure BuildMasks;
  var
    AMask: TMask;
    S, AMasks: QStringW;
    p: PQCharW;
  begin
  if not Assigned(FMasks) then
    FMasks := TList.Create;
  AMasks := edtMask.Text;
  p := PQCharW(AMasks);
  while p^ <> #0 do
    begin
    S := DecodeTokenW(p, ';', #0, True);
    AMask := TMask.Create(S);
    FMasks.Add(AMask);
    end;
  end;
  procedure ClearMasks;
  var
    I: Integer;
  begin
  for I := 0 to FMasks.Count - 1 do
    FreeObject(FMasks[I]);
  FreeAndNil(FMasks);
  end;

  function IsMatch(const AFileName: QStringW): Boolean;
  var
    I: Integer;
  begin
  Result := False;
  for I := 0 to FMasks.Count - 1 do
    begin
    if TMask(FMasks[I]).Matches(AFileName) then
      begin
      Result := True;
      Break;
      end;
    end;
  end;

  procedure ScanFiles(APath: QStringW);
  var
    wfd: WIN32_FIND_DATAW;
    hFind: THandle;
    AFilter: QStringW;
  begin
  if Copy(APath, Length(APath), 1) <> '\' then
    APath := APath + '\';
  AFilter := APath + '*.*';
  hFind := FindFirstFileW(PQCharW(AFilter), wfd);
  if hFind <> INVALID_HANDLE_VALUE then
    begin
    repeat
      if (wfd.cFileName[0] = '.') and
        ((wfd.cFileName[1] = #0) or ((wfd.cFileName[1] = '.') and
        (wfd.cFileName[2] = #0))) then
        Continue
      else
        begin
        if (wfd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then // Ŀ¼
          begin
          if chkIncludeSubDir.Checked then
            ScanFiles(APath + wfd.cFileName);
          end
        else if (wfd.dwFileAttributes and (FILE_ATTRIBUTE_TEMPORARY or
          FILE_ATTRIBUTE_REPARSE_POINT)) = 0 then // ���Ƿ������Ӻ���ʱ�ļ�
          begin
          if IsMatch(wfd.cFileName) then
            begin
            New(AItem);
            AItem.FileName := APath + wfd.cFileName;
            AItem.Lines := 0;
            AItem.FileSize := Int64(wfd.nFileSizeHigh) shl 32 +
              wfd.nFileSizeLow;
            FFiles.Add(AItem);
            end;
          end;
        end;
    until (not FindNextFileW(hFind, wfd)) or BreakScan;
    end;
  end;

begin
if btnStart.Tag = 0 then
  begin
  T := GetTickCount;
  mmResult.Lines.BeginUpdate;
  try
    FFiles := TList.Create;
    btnStart.Caption := 'ֹͣ';
    btnStart.Tag := 1;
    FTotalLines := 0;
    FIgnoreComments := chkIgnoreComments.Checked;
    FComment.Line := edtLineComment.Text;
    FComment.BlockStart := edtBlockCommentStart.Text;
    FComment.BlockEnd := edtBlockCommentStop.Text;
    mmResult.Lines.Clear;
    BuildMasks;
    ScanFiles(edtFolder.Text);
    ClearMasks;
    mmResult.Lines.Add(Format('���ҵ� %d ���ļ�.', [FFiles.Count]));
    Workers.&For(0, FFiles.Count - 1, DoScanLines, True);
    for I := 0 to FFiles.Count - 1 do
      begin
      AItem := FFiles[I];
      mmResult.Lines.Add(Format('%d : %s ��С:%s , ������: %d', [I+1, AItem.FileName,
        RollupSize(AItem.FileSize), AItem.Lines]));
      Dispose(AItem);
      end;
    mmResult.Lines.Add(Format('������ : %d', [FTotalLines]));
    btnStart.Tag := 0;
    btnStart.Caption := '��ʼ';
  finally
    mmResult.Lines.Add(Format('����������ʱ %d ms', [GetTickCount - T]));
    mmResult.Lines.EndUpdate;
  end
  end
else
  btnStart.Tag := 1;
end;

procedure TForm1.cbxMaskStylesChange(Sender: TObject);
begin
case cbxMaskStyles.ItemIndex of
  0:
    begin
    edtMask.Text := '*.inc;*.pas';
    edtLineComment.Text := '//';
    edtBlockCommentStart.Text := '{';
    edtBlockCommentStop.Text := '}';
    end;
  1:
    begin
    edtMask.Text := '*.c;*.cpp;*.h;*.hpp;*.cc;*.hh';
    edtLineComment.Text := '//';
    edtBlockCommentStart.Text := '/*';
    edtBlockCommentStop.Text := '*/';
    end;
  2:
    begin
    edtMask.Text := '*.java';
    edtLineComment.Text := '//';
    edtBlockCommentStart.Text := '/*';
    edtBlockCommentStop.Text := '*/';
    end;
end;
end;

procedure TForm1.DoScanLines(ALoopMgr: TQForJobs; AJob: PQJob;
  AIndex: NativeInt);
var
  S: QStringW;
  p, pl, pbs, pbe: PQCharW;
  AItem:PFileItem;
begin
AItem:=PFileItem(FFiles[AIndex]);
S := LoadTextW(AItem.FileName);
p := PQCharW(S);
pl := PQCharW(FComment.Line);
pbs := PQCharW(FComment.BlockStart);
pbe := PQCharW(FComment.BlockEnd);
while (p^ <> #0) and (not BreakScan) do
  begin
  SkipSpaceW(p);
  if StartWithW(p, pl, False) then
    begin
    SkipUntilW(p, #10);
    if not FIgnoreComments then
      Inc(AItem.Lines);
    end
  else if StartWithW(p, pbs, False) then
    begin
    p := StrStrW(p, pbe);
    if p = nil then
      Break;
    if not FIgnoreComments then
      Inc(AItem.Lines);
    end
  else
    begin
    SkipUntilW(p, #10);
    Inc(AItem.Lines);
    end;
  end;
AtomicIncrement(FTotalLines, AItem.Lines);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
if Assigned(FFiles) then
  FreeObject(FFiles);
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
ShellExecute(0,nil,'http://blog.qdac.cc/?p=1571',nil,nil,SW_SHOWNORMAL);
end;

end.

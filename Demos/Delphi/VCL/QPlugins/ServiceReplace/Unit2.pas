unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, qplugins_base, qplugins, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses HotReplace, qplugins_loader_lib;
{$R *.dfm}

type
  TFileEnumCallback = reference to procedure(AFileName: String);

procedure EnumFiles(APath, AFilter: String; AIncludeSubDir: Boolean;
  ACallback: TFileEnumCallback);
var
  sr: TSearchRec;
begin
  if not APath.EndsWith('\') then
    APath := APath + '\';
  if Length(AFilter) = 0 then
    AFilter := '*.*';
  if System.SysUtils.FindFirst(APath + AFilter, faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Attr and faDirectory) <> 0 then
      begin
        if AIncludeSubDir and (sr.Name <> '.') and (sr.Name <> '..') then
          EnumFiles(APath + sr.Name + '\', AFilter, AIncludeSubDir, ACallback);
      end
      else if sr.Attr <> faInvalid then // �ļ�
      begin
        ACallback(APath + sr.Name);
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
  AService: IReplaceDemoService;
begin
  AService := PluginsManager.ById(IReplaceDemoService) as IReplaceDemoService;
  if Assigned(AService) then
    Memo1.Lines.Add(AService.GetDescription);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  ALoader: IQLoader;
begin
  ALoader := PluginsManager.ById(LID_DLL) as IQLoader;
  if Assigned(ALoader) then
  begin
    ALoader.LoadServices('dll_replace_on_run.hotpatch');
    // ע��˴����ɵķ�����Ϊɾ�����Ա����������DoUpgrade���Լ�ɾ���ϵĲ��������Ϊ�µ�
    // �˴�ע�͵����Ա�ʾ�������ܹ�������ʾ
    // RenameFile('dll_origin.dll', 'dll_origin.delete');
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  APath: String;

  // ����ʱɾ���������ļ�����չ��Ϊ .delete���������º���ļ�����Ϊ��������չ��

  procedure DoUpgrade;
  begin
    EnumFiles(APath, '*.delete', false,
      procedure(AFileName: String)
      begin
        DeleteFile(AFileName);
      end);

    EnumFiles(APath, '*.hotpatch', false,
      procedure(AFileName: String)
      begin
        RenameFile(AFileName, StringReplace(AFileName, '.hotpatch', '.dll',
          [rfIgnoreCase]));
      end);
  end;

begin
  APath := ExtractFilePath(Application.ExeName);
  // Ϊ�˲����滻���������ע�ͣ�ʵ�ʸ����ڲ������ǰִ�У��Ա�֤�ȸ��¹̻���ɾ���ɵĲ��
  // DoUpgrade;
  PluginsManager.Loaders.Add(TQDLLLoader.Create(APath, '.dll'));
  PluginsManager.Start;
end;

end.

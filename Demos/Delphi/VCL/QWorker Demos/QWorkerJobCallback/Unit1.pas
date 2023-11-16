unit Unit1;

interface

{ Inline Job Demo
  ���ʾ��������QWorker��һ������չ����ʾ��������ڴ�����ͬʱ������ҵ����ҵ����¼�
}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QWorker, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  TQInlineJob = class
  protected
    FJobProc: TQJobProcA;
    FJobCompleteProc: TQJobProcA;
    FData: Pointer;
    FFreeType: TQJobDataFreeType;
    procedure DoJob(AJob: PQJob);
    procedure DoJobDone(AJob: PQJob);
  public
    constructor Create(AJobProc, ACompleteProc: TQJobProcA; AData: Pointer;
      ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType); overload;
    destructor Destroy; override;
  end;
  { TQInlineJob }

constructor TQInlineJob.Create(AJobProc, ACompleteProc: TQJobProcA;
  AData: Pointer; ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType);
begin
  inherited Create;
  FJobProc := AJobProc;
  FJobCompleteProc := ACompleteProc;
  case AFreeType of
    jdfFreeAsObject:
      TObject(FData) := AData;
    jdfFreeAsInterface:
      begin
        FData := AData;
        IUnknown(AData)._AddRef;
      end
  else
    FData := AData;
  end;
  FFreeType := AFreeType;
  Workers.Post(DoJob, Self, ARunInMainThread, jdfFreeAsObject);
end;

destructor TQInlineJob.Destroy;
begin
  if Assigned(FData) and (FFreeType <> jdfFreeByUser) then
  begin
    case FFreeType of
      jdfFreeAsObject:
        TObject(FData) := nil;
      jdfFreeAsSimpleRecord:
        Dispose(FData);
      jdfFreeAsInterface:
        IInterface(FData)._Release;
    else
      Workers.OnCustomFreeData(Workers, FFreeType, FData);
    end;
  end;
  inherited;
end;

procedure TQInlineJob.DoJob(AJob: PQJob);
begin
  try
    AJob.Data := FData;
    if Assigned(FJobProc) then
      FJobProc(AJob);
    DoJobDone(AJob);
  except
    on E: Exception do
      DoJobDone(AJob);
  end;
  AJob.Data := Self;
end;

procedure TQInlineJob.DoJobDone(AJob: PQJob);
begin
  if Assigned(FJobCompleteProc) then
    FJobCompleteProc(AJob);
end;

procedure InlineJob(AJobProc, ACompleteProc: TQJobProcA; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType);
begin
  TQInlineJob.Create(AJobProc, ACompleteProc, AData, ARunInMainThread,
    AFreeType);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  InlineJob(
    procedure(AJob: PQJob)
    begin
      Memo1.Lines.Add('Job Executed,Data:' + IntToStr(IntPtr(AJob.Data)));
    end,
    procedure(AJob: PQJob)
    begin
      Memo1.Lines.Add('Job has done' + IntToStr(IntPtr(AJob.Data)));
    end, Pointer(100), True, jdfFreeByUser);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Workers.Post(
    procedure(AJob: PQJob)
    begin
      Memo1.Lines.Add('Button 2 Click');
    end, nil, True);
end;

end.

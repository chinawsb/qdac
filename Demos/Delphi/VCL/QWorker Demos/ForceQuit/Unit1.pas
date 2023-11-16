unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QWorker, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoFrozen(AJob: PQJob);
    procedure DoFrozenWithLocalData(AJob: PQJob);
    procedure DoJobFrozen(AJob: PQJob);

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type
  // ��ʾ�����ڰ����û����� ForceQuit ʱ�ڲ�����ľֲ���Ҫ�ͷŵ�ʵ�����Ծ��������ڴ�й¶

  TQDataFreeEvent = procedure(AInstance: Pointer; AReleaseCount: Integer)
    of object;
  PQJobLocalItem = ^TQJobLocalItem;

  TQJobLocalItem = record
    Instance: Pointer;
    ReleaseCount: Integer;
    OnFree: TQDataFreeEvent;
    Prior: PQJobLocalItem;
  end;

  TQJobLocalData = class
  private
    FLast: PQJobLocalItem;
    FTag: Pointer;
    procedure DoFreeObject(AInstance: Pointer; AReleaseCount: Integer);
    procedure DoFreeInterface(AInstance: Pointer; AReleaseCount: Integer);
    procedure InternalAdd(AInstance: Pointer; AOnFree: TQDataFreeEvent;
      AReleaseCount: Integer = MaxInt);
  public
    constructor Create(ATag: Pointer); overload;
    destructor Destroy; override;
    procedure Add(AObject: TObject); overload;
    procedure Add(AInterface: IInterface;
      AReleaseCount: Integer = MaxInt); overload;
    procedure Add(AData: Pointer; AOnFree: TQDataFreeEvent); overload;
    property Tag: Pointer read FTag;
  end;

  TSimpleObject = class
  public
    destructor Destroy; override;
  end;

  TSimpleInterface = class(TInterfacedObject)
  public
    destructor Destroy; override;
  end;

procedure TForm1.Button1Click(Sender: TObject);
var
  I, ADelay: Integer;
begin
  for I := 0 to 19 do
  begin
    ADelay := random(20);
    Memo1.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ��ҵ ' + IntToStr(I) +
      ' �� ' + IntToStr(ADelay + 10) + ' ��󽫱�ǿ���˳�');
    Workers.Delay(DoFrozen, ADelay * Q1Second, Pointer(I));
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I, ADelay: Integer;
begin
  for I := 0 to 19 do
  begin
    ADelay := random(20);
    Memo1.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ��ҵ ' + IntToStr(I) +
      ' �� ' + IntToStr(ADelay + 10) + ' ��󽫱�ǿ���˳�');
    Workers.Delay(DoFrozenWithLocalData, ADelay * Q1Second, TQJobLocalData.Create(Pointer(I)
      ), false, jdfFreeAsObject);
  end;
end;

procedure TForm1.DoFrozen(AJob: PQJob);
begin
  Sleep(MaxInt);
end;

procedure TForm1.DoFrozenWithLocalData(AJob: PQJob);
var
  AObj: TObject;
  AIntf: IInterface;
begin
  with TQJobLocalData(AJob.Data) do
  begin
    AObj := TSimpleObject.Create;
    Add(AObj);
    AIntf := TSimpleInterface.Create;
    Add(AIntf);
  end;
  // ���뽩��״̬����ʱ���ͷ�AObj��AIntfʵ��
  Sleep(MaxInt);
end;

procedure TForm1.DoJobFrozen(AJob: PQJob);
begin
  RunInMainThread(
    procedure
    begin
      if not AJob.InMainThread then
      begin
        if IntPtr(AJob.Data)<20 then
          Memo1.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ��ҵ ' +
            IntToStr(IntPtr(AJob.Data)) + ' ��ʱ����Ӧ��ǿ���˳���')
        else
          Memo1.Lines.Add(FormatDateTime('hh:nn:ss', Now) + ' ��ҵ ' +
            IntToStr(IntPtr(TQJobLocalData(AJob.Data).Tag)) + ' ��ʱ����Ӧ��ǿ���˳���');
        AJob.Worker.ForceQuit;
      end
      else
      begin
        // ������߳���������ô����Ǵ���alertģʽ������ͨ�� QueueUserApc ��ģ�⸴�������ɶ��ȡ�İ취����������
      end;
    end);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Workers.MaxWorkers := 10;
  Workers.JobFrozenTime := 10;
  Workers.OnJobFrozen := DoJobFrozen;
end;

{ TQJobLocalData }

procedure TQJobLocalData.Add(AObject: TObject);
begin
  if Assigned(AObject) then
    InternalAdd(AObject, DoFreeObject, MaxInt);
end;

procedure TQJobLocalData.Add(AInterface: IInterface; AReleaseCount: Integer);
begin
  if Assigned(AInterface) then
  begin
    AInterface._AddRef;
    InternalAdd(Pointer(AInterface), DoFreeInterface, AReleaseCount);
  end;
end;

procedure TQJobLocalData.Add(AData: Pointer; AOnFree: TQDataFreeEvent);
begin
  InternalAdd(AData, AOnFree);
end;

constructor TQJobLocalData.Create(ATag: Pointer);
begin
  inherited Create;
  FTag := ATag;
end;

destructor TQJobLocalData.Destroy;
var
  AItem: PQJobLocalItem;
  ATemp: TQJobLocalItem;
begin
  while Assigned(FLast) do
  begin
    try
      AItem := FLast;
      FLast := AItem.Prior;
      ATemp := AItem^;
      Dispose(AItem);
      if Assigned(ATemp.OnFree) then
        AItem.OnFree(ATemp.Instance, ATemp.ReleaseCount);
    except
    end;
  end;
  inherited;
end;

procedure TQJobLocalData.DoFreeInterface(AInstance: Pointer;
AReleaseCount: Integer);
begin
  with IInterface(AInstance) do
  begin
    // ������Ҫ�û�����ʵ��������д����������������ǿ�Ʊ�֤�ӿڱ��ͷŵ�
    if _Release <> 0 then
    begin
      while (_Release <> 0) and (AReleaseCount > 0) do
        Dec(AReleaseCount);
    end;
  end;
end;

procedure TQJobLocalData.DoFreeObject(AInstance: Pointer;
AReleaseCount: Integer);
begin
  // ����AUTO_REFCOUNTƽ̨�����Ӧ���ǵ���_ObjRelease �ͽӿ�һ��������֤�����ͷ�
  FreeAndNil(AInstance);
end;

procedure TQJobLocalData.InternalAdd(AInstance: Pointer;
AOnFree: TQDataFreeEvent; AReleaseCount: Integer);
var
  AItem: PQJobLocalItem;
begin
  New(AItem);
  AItem.Instance := AInstance;
  AItem.OnFree := AOnFree;
  AItem.Prior := FLast;
  AItem.ReleaseCount := AReleaseCount;
  FLast := AItem;
end;

{ TSimpleObject }

destructor TSimpleObject.Destroy;
begin
  RunInMainThread(
    procedure
    begin
      TForm1(Application.MainForm).Memo1.Lines.Add('TSimpleObject �����ͷ�');
    end);
  inherited;
end;

{ TSimpleInterface }

destructor TSimpleInterface.Destroy;
begin
  RunInMainThread(
    procedure
    begin
      TForm1(Application.MainForm).Memo1.Lines.Add('TSimpleInterface �����ͷ�');
    end);
  inherited;
end;

end.

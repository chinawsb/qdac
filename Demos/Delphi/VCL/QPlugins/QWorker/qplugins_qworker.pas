unit qplugins_qworker;

interface

uses classes, syncobjs,qworker, qstring, qplugins_params;

type
  IQForJobs=interface
    ['{17C9A0C5-07AD-4F38-A713-96C581CFAE45}']
  end;
  TQJobProc = procedure(AJob: PQJob) of object;
  PQJobProc = ^TQJobProc;
  TQJobProcG = procedure(AJob: PQJob);
  TQForJobProc = procedure(ALoopMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt)
    of object;
  PQForJobProc = ^TQForJobProc;
  TQForJobProcG = procedure(ALoopMgr: IQForJobs; AJob: PQJob;
    AIndex: NativeInt);
{$IFDEF UNICODE}
  TQJobProcA = reference to procedure(AJob: PQJob);
  TQForJobProcA = reference to procedure(ALoopMgr: TQForJobs; AJob: PQJob;
    AIndex: NativeInt);
{$ENDIF}

  IQWorker = interface
    ['{2A75F8D3-3625-449C-A5C4-EF781206A735}']
    function Post(AProc: TQJobProc; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Post(AProc: TQJobProcG; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    function Post(AProc: TQJobProcA; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    function Post(AProc: TQJobProc; AInterval: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Post(AProc: TQJobProcG; AInterval: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    function Post(AProc: TQJobProcA; AInterval: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    function Delay(AProc: TQJobProc; ADelay: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false; ARepeat: Boolean = false)
      : IntPtr; overload;
    function Delay(AProc: TQJobProcG; ADelay: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false; ARepeat: Boolean = false)
      : IntPtr; overload;
{$IFDEF UNICODE}
    function Delay(AProc: TQJobProcA; ADelay: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false; ARepeat: Boolean = false)
      : IntPtr; overload;
{$ENDIF}
    function Wait(AProc: TQJobProc; ASignalId: Integer;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Wait(AProc: TQJobProc; const ASignalName: QStringW;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Wait(AProc: TQJobProcG; ASignalId: Integer;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Wait(AProc: TQJobProcG; const ASignalName: QStringW;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    function Wait(AProc: TQJobProcA; ASignalId: Integer;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Wait(AProc: TQJobProcA; const ASignalName: QStringW;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    function At(AProc: TQJobProc; const ADelay, AInterval: Int64;
      AParams: IQParams; ARunInMainThread: Boolean = false): IntPtr; overload;
    function At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
      AParams: IQParams; ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    function At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
      AParams: IQParams; ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    function At(AProc: TQJobProc; const ATime: TDateTime;
      const AInterval: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function At(AProc: TQJobProcG; const ATime: TDateTime;
      const AInterval: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    function At(AProc: TQJobProcA; const ATime: TDateTime;
      const AInterval: Int64; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    function Plan(AProc: TQJobProc; const APlan: QStringW; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
    function Plan(AProc: TQJobProcG; const APlan: QStringW; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$IFDEF UNICODE}
    function Plan(AProc: TQJobProcA; const APlan: QStringW; AParams: IQParams;
      ARunInMainThread: Boolean = false): IntPtr; overload;
{$ENDIF}
    function LongtimeJob(AProc: TQJobProc; AParams: IQParams): IntPtr; overload;
    function LongtimeJob(AProc: TQJobProcG; AParams: IQParams): IntPtr; overload;
{$IFDEF UNICODE}
    function LongtimeJob(AProc: TQJobProcA; AParams: IQParams): IntPtr; overload;
{$ENDIF}
    procedure Clear(AWaitRunningDone: Boolean = True); overload;
    function Clear(AObject: Pointer; AMaxTimes: Integer = -1;
      AWaitRunningDone: Boolean = True): Integer; overload;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer = -1;
      AWaitRunningDone: Boolean = True): Integer; overload;
    function Clear(ASignalName: QStringW; AWaitRunningDone: Boolean = True)
      : Integer; overload;
    function Clear(ASignalId: Integer; AWaitRunningDone: Boolean = True)
      : Integer; overload;
    procedure ClearSingleJob(AHandle: IntPtr;
      AWaitRunningDone: Boolean = True); overload;
    function ClearJobs(AHandles: PIntPtr; ACount: Integer;
      AWaitRunningDone: Boolean = True): Integer; overload;
    function Signal(AId: Integer; AParams: IQParams;AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    function Signal(const AName: QStringW; AParams: IQParams;AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    function SendSignal(AId: Integer; AParams: IQParams;AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    function SendSignal(const AName: QStringW; AParams: IQParams; AWaitTimeout: Cardinal = 0)
      : TWaitResult; overload; inline;
    function PostSignal(AId: Integer; AParams: IQParams): Boolean; overload; inline;
    function PostSignal(const AName: QStringW; AParams: IQParams): Boolean; overload; inline;
    function RegisterSignal(const AName: QStringW): Integer; // ע��һ���ź�����
    procedure EnableWorkers;
    procedure DisableWorkers;
    function EnumWorkerStatus: TQWorkerStatus;
    function PeekJobState(AHandle: IntPtr; var AResult: TQJobState): Boolean;
    function EnumJobStates: TQJobStateArray;
    function WaitJob(AHandle: IntPtr; ATimeout: Cardinal; AMsgWait: Boolean)
      : TWaitResult;
    function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProc; AMsgWait: Boolean = false;
      AParams: IQParams)
      : TWaitResult; overload; static; inline;
{$IFDEF UNICODE}
    function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcA; AMsgWait: Boolean = false;
      AParams: IQParams)
      : TWaitResult; overload; static; inline;
{$ENDIF}
    function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcG; AMsgWait: Boolean = false;
      AParams: IQParams)
      : TWaitResult; overload; static; inline;

//    /// <summary>���������������������С��2</summary>
//    property MaxWorkers: Integer read FMaxWorkers write SetMaxWorkers;
//    /// <summary>��С����������������С��2<summary>
//    property MinWorkers: Integer read FMinWorkers write SetMinWorkers;
//    /// <summary>�������ĳ�ʱ����ҵ�������������ȼ�������ʼ�ĳ�ʱ����ҵ����</summary>
//    property MaxLongtimeWorkers: Integer read FMaxLongtimeWorkers
//      write SetMaxLongtimeWorkers;
//    /// <summary>�Ƿ�����ʼ��ҵ�����Ϊfalse����Ͷ�ĵ���ҵ�����ᱻִ�У�ֱ���ָ�ΪTrue</summary>
//    /// <remarks>EnabledΪFalseʱ�Ѿ����е���ҵ����Ȼ���У���ֻӰ����δִ�е�����</remarks>
//    property Enabled: Boolean read GetEnabled write SetEnabled;
//    /// <summary>�Ƿ������ͷ�TQWorkers��������</summary>
//    property Terminating: Boolean read GetTerminating;
//    /// <summary>��ǰ����������</summary>
//    property Workers: Integer read FWorkerCount;
//    /// <summary>��ǰæµ����������</summary>
//    property BusyWorkers: Integer read GetBusyCount;
//    /// <summary>��ǰ���й���������</summary>
//    property IdleWorkers: Integer read GetIdleWorkers;
//    /// <summary>�Ƿ��Ѿ����������������</summary>
//    property OutOfWorker: Boolean read GetOutWorkers;
//    /// <summary>Ĭ�Ͻ�͹����ߵĳ�ʱʱ��</summary>
//    property FireTimeout: Cardinal read FFireTimeout write SetFireTimeout;
//    /// <summary>�û�ָ������ҵ��Data�����ͷŷ�ʽ</summary>
//    property OnCustomFreeData: TQCustomFreeDataEvent read FOnCustomFreeData
//      write FOnCustomFreeData;
//    /// <summary>��һ���ظ���ҵ����ʱ��</summary>
//    property NextRepeatJobTime: Int64 read GetNextRepeatJobTime;
//    /// <summary>��ִ����ҵ����ʱ�������Ա㴦���쳣</summayr>
//    property OnError: TWorkerErrorNotify read FOnError write FOnError;
//    property BeforeExecute: TQJobNotifyEvent read FBeforeExecute
//      write FBeforeExecute;
//    property AfterExecute: TQJobNotifyEvent read FAfterExecute
//      write FAfterExecute;
//    property BeforeCancel: TQJobNotifyEvent read FBeforeCancel
//      write FBeforeCancel;
//    property SignalQueue: TQSignalQueue read FSignalQueue;
  end;

implementation

end.

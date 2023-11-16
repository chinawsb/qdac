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
    function RegisterSignal(const AName: QStringW): Integer; // 注册一个信号名称
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

//    /// <summary>最大允许工作者数量，不能小于2</summary>
//    property MaxWorkers: Integer read FMaxWorkers write SetMaxWorkers;
//    /// <summary>最小工作者数量，不能小于2<summary>
//    property MinWorkers: Integer read FMinWorkers write SetMinWorkers;
//    /// <summary>最大允许的长时间作业工作者数量，等价于允许开始的长时间作业数量</summary>
//    property MaxLongtimeWorkers: Integer read FMaxLongtimeWorkers
//      write SetMaxLongtimeWorkers;
//    /// <summary>是否允许开始作业，如果为false，则投寄的作业都不会被执行，直到恢复为True</summary>
//    /// <remarks>Enabled为False时已经运行的作业将仍然运行，它只影响尚未执行的作来</remarks>
//    property Enabled: Boolean read GetEnabled write SetEnabled;
//    /// <summary>是否正在释放TQWorkers对象自身</summary>
//    property Terminating: Boolean read GetTerminating;
//    /// <summary>当前工作者数量</summary>
//    property Workers: Integer read FWorkerCount;
//    /// <summary>当前忙碌工作者数量</summary>
//    property BusyWorkers: Integer read GetBusyCount;
//    /// <summary>当前空闲工作者数量</summary>
//    property IdleWorkers: Integer read GetIdleWorkers;
//    /// <summary>是否已经到达最大工作者数量</summary>
//    property OutOfWorker: Boolean read GetOutWorkers;
//    /// <summary>默认解雇工作者的超时时间</summary>
//    property FireTimeout: Cardinal read FFireTimeout write SetFireTimeout;
//    /// <summary>用户指定的作业的Data对象释放方式</summary>
//    property OnCustomFreeData: TQCustomFreeDataEvent read FOnCustomFreeData
//      write FOnCustomFreeData;
//    /// <summary>下一次重复作业触发时间</summary>
//    property NextRepeatJobTime: Int64 read GetNextRepeatJobTime;
//    /// <summary>在执行作业出错时触发，以便处理异常</summayr>
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

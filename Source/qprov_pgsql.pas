unit qprov_pgsql;

interface

{$I 'qdac.inc'}

uses classes, sysutils, db, qstring, qrbtree, fmtbcd, qvalue, qdb, qworker,
  qdigest, qlog, syncobjs, math{$IFDEF UNICODE}, ZLib{$ENDIF}
{$IFDEF POSIX}
    , Posix.Base, Posix.Stdio, Posix.Pthread, Posix.UniStd, System.IOUtils,
{$WARN UNIT_PLATFORM OFF}Posix.StrOpts, {$WARN UNIT_PLATFORM ON}
  Posix.NetDB, Posix.SysSocket, Posix.NetinetIn, Posix.arpainet,
  Posix.SysSelect,
  Posix.Systime
{$ELSE}
    , Windows, winsock
{$ENDIF};

// ���ȣ���������ѯ֧�ִ�����
{
  2017.3.26
  ==========
  * �����˷ǿ�����Ĭ��ֵδ��ֵʱ�޷���������⣨layeka���棩
  2015.9.25
  ==========
  * �����˵�¼����δ��ɾͿ��Կ�ʼ��ѯ������

  2015.9.10
  ========
  * ���������ݿ����Ӳ�������ȷʱ���޷�������ȷ�Ĵ�����Ϣ������
  * �������ύ����ʱ�������ֶ��п�ֵʱ�޷���ȷ�ύ������
  * �����˷���������������ʱ���ٴ�����ʱ����ʾĩ�δ��������
}
const
  PG_PROTOCOL_V3 = $00030000; // ֻ֧��3.0���ϵ�Э�飬PostgreSQL 7.4���ϰ汾
{$IFDEF POSIX}
  ERROR_TIMEOUT = 1460;
  SOCKET_ERROR = -1;
{$ENDIF}

type
  // PQArgBlock���Ͷ��� src\include\libpq\libpq.h
  TPQArgBlock = record
    Len, IsInt: Integer;
    case Boolean of
      False:
        (Ptr: PInteger);
      True:
        (Int: Integer);
  end;

  // TPQClientMsg�ӿͻ��˷����������˵���Ϣ����
  TPQClientMsg = (cmSSL = $08, { 'SSLRequest' }
    cmCancelRequest = $10, { 16 }
    cmBind = $42, { 'B' }
    cmClose = $43, { 'C' }
    cmDescribe = $44, { 'D' }
    cmExecute = $45, { 'E' }
    cmFunction = $46, { 'F',�ѷ���,�ٷ��Ƽ��滻Ϊselect function(...)���� }
    cmFlush = $48, { 'H' }
    cmParse = $50, { 'P' }
    cmQuery = $51, { 'Q' }
    cmSync = $53, { 'S' }
    cmTerminte = $58, { 'X' }
    cmCopyDone = $63, { 'c' }
    cmCopyData = $64, { 'd' }
    cmCopyFail = $65, { 'f' }
    cmPassword = $70 { 'p' }
    );
  TPQDecribeType = (dtStatementName = $73, { s }
    dtPortalName = $50);
  // TQServerMsg�ӷ��������͵��ͻ��˵���Ϣ����
  TQPServerMsg = (smUnknown = $00, { δ֪ }
    smParsed = $31, { '1' }
    smBound = $32, { '2',BindComplete }
    smClosed = $33, { '3',CloseComplete }
    smNotification = $41, { 'A' }
    smCommandDone = $43, { 'C' }
    smDataRow = $44, { 'D' }
    smError = $45, { 'E',ErrorResponse }
    smStartCopyIn = $47, { 'G',CopyInResponse }
    smStartCopyOut = $48, { 'H',CopyOutResponse }
    smEmpty = $49, { 'I',EmptyQueryResponse }
    smKeyData = $4B, { 'K' }
    smNotice = $4E, { 'N' }
    smAuth = $52, { 'R' }
    smParamStatus = $53, { 'S' }
    smRowDesc = $54, { 'T' }
    svFunction = $56, { 'V'���ѷ��� }
    smReady = $5A, { 'Z',ReadyForQuery }
    smCopyDone = $63, { 'c' }
    smCopyData = $64, { 'd' }
    smNoData = $6E, { 'n' }
    smSuspended = $73, { 's',PortalSuspended }
    smParamDesc = $74 { 't' }
    );

  { ���ȷ�����һ��SSLRequest����

  }
  TPQSSLRequest = packed record
    MsgType: Integer; // �̶�Ϊ8
    RequestCode: Integer; // �̶�Ϊ80877103
  end;

  // KerberosV4,paKerberosV5,paCryptPassword�Ѿ�����֧��
  TPQAuth = (paNone, paKerberosV4, paKerberosV5, paClearTextPassword,
    paCryptPassword, paMD5Password, paScmCreds, paGSS, paGSSContinue, paSSPI);
  // ReadyForQuery
  TPGQueryStatus = (qsUnknown, qsAuth, qsBusy, qsIdle, qsInTransaction,
    qsError);
  TPGErrorType = (peSeverity = $53 { S } , peCode = $43 { C } ,
    peMessage = $4D { M } , peDetail = $44 { D } , peHint = $48 { H } ,
    peCursorPos = $50 { P } , peInternalCursorPos = $70 { p } ,
    peQuery = $71 { Q } , peWhere = $57 { W } , peFile = $46 { F } ,
    peLine = $4C { L } , peCategory = $52 { R } , peSchemaName = $73 { s } ,
    peTableName = $74 { 't' } , peDataType = $64 { d } ,
    peConstraint = $6E { n }
    );

  // StringInfoData src\include\lib\stringinfo.h
  TPQStringInfoData = record
    Data: PByte;
    Len: Integer;
    MaxLen: Integer;
    Cursor: Integer;
  end;

  TPQMsg = packed record
    Msg: TQPServerMsg;
    DataSize: Integer;
    Data: array [0 .. 0] of Byte;
  end;

  PPQMsg = ^TPQMsg;

  TPQAuthMsg = packed record
    Msg: TQPServerMsg;
    DataSize: Integer;
    AuthType: Integer;
    Salt: Integer;
  end;

  PPQAuthMsg = ^TPQAuthMsg;

  TPgFieldData = record
    TableId: Integer;
    ColId: Smallint;
    TypeId: Integer;
    TypeMod: Integer;
    Size: Smallint;
    IsBinary: Boolean;
  end;

  TQPgInformation = record
    Severity: QStringW;
    ErrorLevel: TQNoticeLevel;
    Code: QStringW;
    ErrorCode: Cardinal;
    Text: QStringW;
    Detail: QStringW;
    Hint: QStringW;
    CursorPos: QStringW;
    InternalCursorPos: QStringW;
    SQL: QStringW;
    Where: QStringW;
    SourceFile: QStringW;
    SourceLine: QStringW;
    Routine: QStringW;
    Schema: QStringW;
    Table: QStringW;
    Column: QStringW;
    DataType: QStringW;
    Constraint: QStringW;
  end;

  TQPgFieldDesc = packed record
    // String �ֶ����֣��ԣ�
    TableId: Cardinal; // ����ֶο��Ա�ʶΪһ���ض�����ֶΣ���ô���Ǳ�Ķ��� ID�� ��������㡣
    ColId: Smallint; // ������ֶο��Ա�ʶΪһ���ض�����ֶΣ���ô���Ǹñ��ֶε����Ժţ���������㡣
    ColType: Integer; // �ֶ��������͵Ķ��� ID��
    ColSize: Smallint; // �������ͳߴ磨����pg_type.typlen���� ��ע�⸺����ʾ������͡�
    TypeMod: Integer; // �������δ�(����pg_attribut.atttypmod)�� ���δʵĺ�����������صġ�
    Format: Smallint;
    // ���ڸ��ֶεĸ�ʽ�롣Ŀǰ�����㣨�ı�������һ�������ƣ��� �������� Describe ���ص� RowDescription ���ʽ�뻹��δ֪�ģ���������㡣
  end;

  PQPgFieldDesc = ^TQPgFieldDesc;

  TQPgSQLWaitAction = (pwaHandshake, pwaAuth, pwaExecute);
{$IF RTLVersion>=23}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64{$IF RTLVersion>=24} or
    pidOSX32{$IFEND}{$IF RTLVersion>=25} or pidiOSSimulator or
    pidiOSDevice{$IFEND}{$IF RTLVersion>=26} or
    pidAndroid{$IFEND}{$IF RTLVersion>=29} or pidiOSDevice32 or
    pidiOSDevice64{$IFEND})]
{$IFEND}

  TQPgPreparedData = class
    ParamTypes: array of Integer;
  end;

  TQPgSQLProvider = class(TQSocketProvider)
  protected
    FPId: Integer;
    FSecurityKey: Integer;
    FQueryStatus: TPGQueryStatus;
    FNotifyEvent: TEvent;
    FAuthType: TPQAuth;
    FAuthSalt: Integer;
    FStatementCounter: Integer;
    FResultSetCount: Integer;
    FDelayBindTables: array of Cardinal;
    FFetchMeta: Boolean;
    procedure Login; override;
    procedure Handshake; override;
    procedure DispatchData; override;
    procedure DispatchPgMessage(AMsg: PPQMsg);
    procedure CloseHandle(AHandle: THandle); override;
    function DecodePgString(var p: PByte): QStringW;
    function InternalExecute(var ARequest: TQSQLRequest): Boolean; override;
    procedure InternalApplyChanges(AFields: TFieldDefs;
      ARecords: TQRecords); override;
    { ִ��ʵ�ʵĹر����Ӷ��� }
    procedure InternalClose; override;
    { ִ��ʵ�ʵĽ������Ӷ��� }
    procedure InternalOpen; override;
    function ValueType2Pg(AType: TQValueDataType): Integer;
    function Pg2ValueType(AType: Integer): TQValueDataType;
    function NewStatementId: QStringW;
    procedure ClosePortal(AStatementId: QStringW);
    function FindType(APgType: Word): Cardinal;
    procedure SendCmd(AValue: TPQClientMsg); inline;
    procedure SendByte(AValue: Byte); inline;
    procedure SendBool(AValue: Boolean); inline;
    procedure SendWord(AValue: Word); inline;
    procedure SendInt(AValue: Integer); inline;
    procedure SendInt64(AValue: Int64); inline;
    procedure SendFloat(AValue: Double); inline;
    procedure SendString(const S: QStringA; ACStyle: Boolean); inline;
    procedure SendStringWithLength(const S: QStringW); inline;
    procedure SendBytes(ABytes: PByte; ALen: Integer); inline;
    procedure SendAndWait(Action: TQPgSQLWaitAction);
    function PortalName(const AId: QStringW): QStringA; inline;
    function StatementName(const AId: QStringW): QStringA; inline;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Prepare(var AResult: TQCommand; ACmdText: QStringW;
      AId: QStringW = ''): Boolean; override;
  end;

implementation

resourcestring
  SHandshakeTimeout = '�޷���ʼ��������� %s:%d �����ӣ���ʱ�ѹ���';
  SAuthTimeout = '��������֤��ʱ�ѹ���';
  SExecuteTimeout = '�޷�ִ�нű�����ʱ�ѹ���';
  SUnsupportAuthProtocol = 'ֱ���ͻ��˲�֧�ֵ�ǰ��������֤Э�����͡�';
  SUnexpectReply = '�����Э�����������������жϡ�';
  SErrorLineCol = '�� %d �е� %d �У�%s';
  STooManyTable = '���ݼ���Դ�ڲ�ֻһ�����޷��Զ�����( %s �� %s ��)��';
  SNoTableFound = '���ݼ�û�и���Ŀ���Ԫ������Ϣ���޷��Զ����¡�';
  STooManyAffectedRows = '���²���Ӱ�����������Ҫ���������������ݿ����Ѿ�ɾ��������';

type
  TQPgType = record
    OID: Word;
    Name: String;
    DBType: Cardinal;
    Size: Smallint;
    BaseOID: Word;
    Delimiter: QCharW;
  end;

const
  PgTypes: array [0 .. 125] of TQPgType = ( //
    (OID: 16; Name: 'bool'; DBType: SQL_BOOLEAN; Size: 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 17; Name: 'bytea'; DBType: SQL_LARGEOBJECT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 18; Name: 'char'; DBType: SQL_WIDECHAR; Size: 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 19; Name: 'name'; DBType: SQL_WIDECHAR; Size: 64; BaseOID: 18;
    Delimiter: ',';),
    //
    (OID: 20; Name: 'int8'; DBType: SQL_INT64; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 21; Name: 'int2'; DBType: SQL_SMALLINT; Size: 2; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 22; Name: 'int2vector'; DBType: SQL_SMALLINT OR SQL_ARRAY; Size: - 1;
    BaseOID: 21; Delimiter: ',';),
    //
    (OID: 23; Name: 'int4'; DBType: SQL_INTEGER; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 24; Name: 'regproc'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 25; Name: 'text'; DBType: SQL_WIDETEXT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 26; Name: 'oid'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 27; Name: 'tid'; DBType: SQL_BYTES; Size: 6; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 28; Name: 'xid'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 29; Name: 'cid'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 30; Name: 'oidvector'; DBType: SQL_PG_OID OR SQL_ARRAY; Size: - 1;
    BaseOID: 26; Delimiter: ',';),
    //
    (OID: 114; Name: 'json'; DBType: SQL_JSON; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 142; Name: 'xml'; DBType: SQL_XML; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 143; Name: '_xml'; DBType: SQL_XML OR SQL_ARRAY; Size: - 1;
    BaseOID: 142; Delimiter: ',';),
    //
    (OID: 194; Name: 'pg_node_tree'; DBType: SQL_TREE; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 199; Name: '_json'; DBType: SQL_JSON or SQL_ARRAY; Size: - 1;
    BaseOID: 114; Delimiter: ',';),
    //
    (OID: 210; Name: 'smgr'; DBType: SQL_SMALLINT; Size: 2; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 600; Name: 'point'; DBType: SQL_PG_POINT; Size: 16; BaseOID: 701;
    Delimiter: ',';),
    //
    (OID: 601; Name: 'lseg'; DBType: SQL_PG_LSEG; Size: 32; BaseOID: 600;
    Delimiter: ',';),
    //
    (OID: 602; Name: 'path'; DBType: SQL_PG_PATH; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 603; Name: 'box'; DBType: SQL_PG_BOX; Size: 32; BaseOID: 600;
    Delimiter: ';';),
    //
    (OID: 604; Name: 'polygon'; DBType: SQL_PG_POLYGON; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 628; Name: 'line'; DBType: SQL_PG_LINE; Size: 24; BaseOID: 701;
    Delimiter: ',';),
    //
    (OID: 629; Name: '_line'; DBType: SQL_PG_LINE or SQL_ARRAY; Size: - 1;
    BaseOID: 628; Delimiter: ',';),
    //
    (OID: 650; Name: 'cidr'; DBType: SQL_PG_CIDR; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 651; Name: '_cidr'; DBType: SQL_PG_CIDR or SQL_ARRAY; Size: - 1;
    BaseOID: 650; Delimiter: ',';),
    //
    (OID: 700; Name: 'float4'; DBType: SQL_SINGLE; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 701; Name: 'float8'; DBType: SQL_FLOAT; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 702; Name: 'abstime'; DBType: SQL_DATETIME; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 703; Name: 'reltime'; DBType: SQL_DATETIME; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 704; Name: 'tinterval'; DBType: SQL_INTERVAL; Size: 12; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 705; Name: 'unknown'; DBType: SQL_UNKNOWN; Size: - 2; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 718; Name: 'circle'; DBType: SQL_PG_CIRCLE; Size: 24; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 719; Name: '_circle'; DBType: SQL_PG_CIRCLE or SQL_ARRAY; Size: - 1;
    BaseOID: 718; Delimiter: ',';),
    //
    (OID: 790; Name: 'money'; DBType: SQL_MONEY; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 791; Name: '_money'; DBType: SQL_MONEY or SQL_ARRAY; Size: - 1;
    BaseOID: 790; Delimiter: ',';),
    //
    (OID: 829; Name: 'macaddr'; DBType: SQL_PG_MACADDR; Size: 6; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 869; Name: 'inet'; DBType: SQL_PG_INET; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1000; Name: '_bool'; DBType: SQL_BOOLEAN or SQL_ARRAY; Size: - 1;
    BaseOID: 16; Delimiter: ',';),
    //
    (OID: 1001; Name: '_bytea'; DBType: SQL_LARGEOBJECT or SQL_ARRAY; Size: - 1;
    BaseOID: 17; Delimiter: ',';),
    //
    (OID: 1002; Name: '_char'; DBType: SQL_WIDECHAR; Size: - 1; BaseOID: 18;
    Delimiter: ',';),
    //
    (OID: 1003; Name: '_name'; DBType: SQL_WIDECHAR or SQL_ARRAY; Size: - 1;
    BaseOID: 19; Delimiter: ',';),
    //
    (OID: 1005; Name: '_int2'; DBType: SQL_SMALLINT or SQL_ARRAY; Size: - 1;
    BaseOID: 21; Delimiter: ',';),
    //
    (OID: 1006; Name: '_int2vector'; DBType: SQL_SMALLINT or SQL_ARRAY;
    Size: - 1; BaseOID: 22; Delimiter: ',';),
    //
    (OID: 1007; Name: '_int4'; DBType: SQL_INTEGER or SQL_ARRAY; Size: - 1;
    BaseOID: 23; Delimiter: ',';),
    //
    (OID: 1008; Name: '_regproc'; DBType: SQL_DWORD or SQL_ARRAY; Size: - 1;
    BaseOID: 24; Delimiter: ',';),
    //
    (OID: 1009; Name: '_text'; DBType: SQL_TEXT or SQL_ARRAY; Size: - 1;
    BaseOID: 25; Delimiter: ',';),
    //
    (OID: 1010; Name: '_tid'; DBType: SQL_BYTES or SQL_ARRAY; Size: - 1;
    BaseOID: 27; Delimiter: ',';),
    //
    (OID: 1011; Name: '_xid'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 28; Delimiter: ',';),
    //
    (OID: 1012; Name: '_cid'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 29; Delimiter: ',';),
    //
    (OID: 1013; Name: '_oidvector'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 30; Delimiter: ',';),
    //
    (OID: 1014; Name: '_bpchar'; DBType: SQL_WIDEVARCHAR or SQL_ARRAY;
    Size: - 1; BaseOID: 1042; Delimiter: ',';),
    //
    (OID: 1015; Name: '_varchar'; DBType: SQL_WIDEVARCHAR or SQL_ARRAY;
    Size: - 1; BaseOID: 1043; Delimiter: ',';),
    //
    (OID: 1016; Name: '_int8'; DBType: SQL_TINYINT or SQL_ARRAY; Size: - 1;
    BaseOID: 20; Delimiter: ',';),
    //
    (OID: 1017; Name: '_point'; DBType: SQL_PG_POINT or SQL_ARRAY; Size: - 1;
    BaseOID: 600; Delimiter: ',';),
    //
    (OID: 1018; Name: '_lseg'; DBType: SQL_PG_LSEG or SQL_ARRAY; Size: - 1;
    BaseOID: 601; Delimiter: ',';),
    //
    (OID: 1019; Name: '_path'; DBType: SQL_PG_PATH or SQL_ARRAY; Size: - 1;
    BaseOID: 602; Delimiter: ',';),
    //
    (OID: 1020; Name: '_box'; DBType: SQL_PG_BOX or SQL_ARRAY; Size: - 1;
    BaseOID: 603; Delimiter: ';';),
    //
    (OID: 1021; Name: '_float4'; DBType: SQL_SINGLE or SQL_ARRAY; Size: - 1;
    BaseOID: 700; Delimiter: ',';),
    //
    (OID: 1022; Name: '_float8'; DBType: SQL_FLOAT or SQL_ARRAY; Size: - 1;
    BaseOID: 701; Delimiter: ',';),
    //
    (OID: 1023; Name: '_abstime'; DBType: SQL_DATETIME or SQL_ARRAY; Size: - 1;
    BaseOID: 702; Delimiter: ',';),
    //
    (OID: 1024; Name: '_reltime'; DBType: SQL_DATETIME or SQL_ARRAY; Size: - 1;
    BaseOID: 703; Delimiter: ',';),
    //
    (OID: 1025; Name: '_tinterval'; DBType: SQL_INTERVAL or SQL_ARRAY;
    Size: - 1; BaseOID: 704; Delimiter: ',';),
    //
    (OID: 1027; Name: '_polygon'; DBType: SQL_PG_POLYGON or SQL_ARRAY;
    Size: - 1; BaseOID: 604; Delimiter: ',';),
    //
    (OID: 1028; Name: '_oid'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 26; Delimiter: ',';),
    //
    (OID: 1033; Name: 'aclitem'; DBType: SQL_PG_ACL; Size: 12; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1034; Name: '_aclitem'; DBType: SQL_PG_ACL or SQL_ARRAY; Size: - 1;
    BaseOID: 1033; Delimiter: ',';),
    //
    (OID: 1040; Name: '_macaddr'; DBType: SQL_PG_MACADDR or SQL_ARRAY;
    Size: - 1; BaseOID: 829; Delimiter: ',';),
    //
    (OID: 1041; Name: '_inet'; DBType: SQL_PG_INET or SQL_ARRAY; Size: - 1;
    BaseOID: 869; Delimiter: ',';),
    //
    (OID: 1042; Name: 'bpchar'; DBType: SQL_WIDEVARCHAR; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1043; Name: 'varchar'; DBType: SQL_WIDEVARCHAR; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1082; Name: 'date'; DBType: SQL_DATE; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1083; Name: 'time'; DBType: SQL_TIME; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1114; Name: 'timestamp'; DBType: SQL_DATETIME; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1115; Name: '_timestamp'; DBType: SQL_DATETIME or SQL_ARRAY;
    Size: - 1; BaseOID: 1114; Delimiter: ',';),
    //
    (OID: 1182; Name: '_date'; DBType: SQL_DATE or SQL_ARRAY; Size: - 1;
    BaseOID: 1082; Delimiter: ',';),
    //
    (OID: 1183; Name: '_time'; DBType: SQL_TIME or SQL_ARRAY; Size: - 1;
    BaseOID: 1083; Delimiter: ',';),
    //
    (OID: 1184; Name: 'timestamptz'; DBType: SQL_DATETIME; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1185; Name: '_timestamptz'; DBType: SQL_DATETIME or SQL_ARRAY;
    Size: - 1; BaseOID: 1184; Delimiter: ',';),
    //
    (OID: 1186; Name: 'interval'; DBType: SQL_INTERVAL; Size: 16; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1187; Name: '_interval'; DBType: SQL_INTERVAL or SQL_ARRAY; Size: - 1;
    BaseOID: 1186; Delimiter: ',';),
    //
    (OID: 1231; Name: '_numeric'; DBType: SQL_BCD or SQL_ARRAY; Size: - 1;
    BaseOID: 1700; Delimiter: ',';),
    //
    (OID: 1263; Name: '_cstring'; DBType: SQL_WIDEVARCHAR or SQL_ARRAY;
    Size: - 1; BaseOID: 2275; Delimiter: ',';),
    //
    (OID: 1266; Name: 'timetz'; DBType: SQL_TIME; Size: 12; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1270; Name: '_timetz'; DBType: SQL_TIME or SQL_ARRAY; Size: - 1;
    BaseOID: 1266; Delimiter: ',';),
    //
    (OID: 1560; Name: 'bit'; DBType: SQL_BIT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1561; Name: '_bit'; DBType: SQL_BIT or SQL_ARRAY; Size: - 1;
    BaseOID: 1560; Delimiter: ',';),
    //
    (OID: 1562; Name: 'varbit'; DBType: SQL_VARBIT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1563; Name: '_varbit'; DBType: SQL_VARBIT or SQL_ARRAY; Size: - 1;
    BaseOID: 1562; Delimiter: ',';),
    //
    (OID: 1700; Name: 'numeric'; DBType: SQL_BCD; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 1790; Name: 'refcursor'; DBType: SQL_CURSOR; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2201; Name: '_refcursor'; DBType: SQL_CURSOR or SQL_ARRAY; Size: - 1;
    BaseOID: 1790; Delimiter: ',';),
    //
    (OID: 2202; Name: 'regprocedure'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2203; Name: 'regoper'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2204; Name: 'regoperator'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2205; Name: 'regclass'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2206; Name: 'regtype'; DBType: SQL_PG_OID; Size: 4; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2207; Name: '_regprocedure'; DBType: SQL_PG_OID or SQL_ARRAY;
    Size: - 1; BaseOID: 2202; Delimiter: ',';),
    //
    (OID: 2208; Name: '_regoper'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 2203; Delimiter: ',';),
    //
    (OID: 2209; Name: '_regoperator'; DBType: SQL_PG_OID or SQL_ARRAY;
    Size: - 1; BaseOID: 2204; Delimiter: ',';),
    //
    (OID: 2210; Name: '_regclass'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 2205; Delimiter: ',';),
    //
    (OID: 2211; Name: '_regtype'; DBType: SQL_PG_OID or SQL_ARRAY; Size: - 1;
    BaseOID: 2206; Delimiter: ',';),
    //
    (OID: 2949; Name: '_txid_snapshot'; DBType: SQL_DWORD or SQL_ARRAY;
    Size: - 1; BaseOID: 2970; Delimiter: ',';),
    //
    (OID: 2950; Name: 'uuid'; DBType: SQL_UUID; Size: 16; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 2951; Name: '_uuid'; DBType: SQL_UUID or SQL_ARRAY; Size: - 1;
    BaseOID: 2950; Delimiter: ',';),
    //
    (OID: 2970; Name: 'txid_snapshot'; DBType: SQL_DWORD; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 3220; Name: 'pg_lsn'; DBType: SQL_INT64; Size: 8; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 3221; Name: '_pg_lsn'; DBType: SQL_INT64 or SQL_ARRAY; Size: - 1;
    BaseOID: 3220; Delimiter: ',';),
    //
    (OID: 3614; Name: 'tsvector'; DBType: SQL_WIDETEXT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 3615; Name: 'tsquery'; DBType: SQL_WIDETEXT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 3642; Name: 'gtsvector'; DBType: SQL_WIDETEXT; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 3643; Name: '_tsvector'; DBType: SQL_WIDETEXT or SQL_ARRAY; Size: - 1;
    BaseOID: 3614; Delimiter: ',';),
    //
    (OID: 3644; Name: '_gtsvector'; DBType: SQL_WIDETEXT or SQL_ARRAY;
    Size: - 1; BaseOID: 3642; Delimiter: ',';),
    //
    (OID: 3645; Name: '_tsquery'; DBType: SQL_WIDETEXT or SQL_ARRAY; Size: - 1;
    BaseOID: 3615; Delimiter: ',';),
    //
    (OID: 3802; Name: 'jsonb'; DBType: SQL_JSON; Size: - 1; BaseOID: 0;
    Delimiter: ',';),
    //
    (OID: 3807; Name: '_jsonb'; DBType: SQL_JSON or SQL_ARRAY; Size: - 1;
    BaseOID: 3802; Delimiter: ',';),
    //
    (OID: 3905; Name: '_int4range'; DBType: SQL_INTEGER or SQL_ARRAY; Size: - 1;
    BaseOID: 3904; Delimiter: ',';),
    //
    (OID: 3907; Name: '_numrange'; DBType: SQL_BCD or SQL_ARRAY; Size: - 1;
    BaseOID: 3906; Delimiter: ',';),
    //
    (OID: 3909; Name: '_tsrange'; DBType: SQL_WIDETEXT OR SQL_ARRAY; Size: - 1;
    BaseOID: 3908; Delimiter: ',';),
    //
    (OID: 3911; Name: '_tstzrange'; DBType: SQL_WIDETEXT or SQL_ARRAY;
    Size: - 1; BaseOID: 3910; Delimiter: ',';),
    //
    (OID: 3913; Name: '_daterange'; DBType: SQL_DATE or SQL_ARRAY; Size: - 1;
    BaseOID: 3912; Delimiter: ',';),
    //
    (OID: 3927; Name: '_int8range'; DBType: SQL_TINYINT or SQL_ARRAY; Size: - 1;
    BaseOID: 3926; Delimiter: ',';));

function PQServerMsgName(const AType: TQPServerMsg): QStringW;
begin
  case AType of
    smParsed:
      Result := 'PARSED';
    smBound:
      Result := 'BINDCOMPLETE';
    smClosed:
      Result := 'CLOSECOMPLETE';
    smNotification:
      Result := 'NOTIFICATION';
    smCommandDone:
      Result := 'COMMANDCOMPLETE';
    smDataRow:
      Result := 'DATAROW';
    smError:
      Result := 'ERROR';
    smStartCopyIn:
      Result := 'COPYINRESPONSE';
    smStartCopyOut:
      Result := 'COPYOUTINRESPONSE';
    smEmpty:
      Result := 'EMPTY';
    smKeyData:
      Result := 'KEYDATA';
    smNotice:
      Result := 'NOTICE';
    smAuth:
      Result := 'AUTH';
    smParamStatus:
      Result := 'PARAMSTATUS';
    smRowDesc:
      Result := 'ROWDESCRIPTION';
    svFunction:
      Result := 'FUNCTIONCALL';
    smReady:
      Result := 'READYFORQUERY';
    smCopyDone:
      Result := 'COPYDONE';
    smCopyData:
      Result := 'COPYDATA';
    smNoData:
      Result := 'NODATA';
    smSuspended:
      Result := 'SUSPENDED';
    smParamDesc:
      Result := 'PARAMDESCRIPTION'
  else
    Result := 'UNKNOWN';
  end;
end;

function TQPgSQLProvider.Pg2ValueType(AType: Integer): TQValueDataType;
begin
  case AType of
    0:
      Result := vdtNull;
    16:
      Result := vdtBoolean;
    17:
      Result := vdtStream;
    18:
      Result := vdtString;
    20:
      Result := vdtInt64;
    23:
      Result := vdtInteger;
    701:
      Result := vdtFloat;
    704:
      Result := vdtInterval;
    790:
      Result := vdtCurrency;
    1700:
      Result := vdtBcd;
    1114:
      Result := vdtDateTime;
    2950:
      Result := vdtGuid
  else
    Result := vdtString;
  end;
end;

function TQPgSQLProvider.PortalName(const AId: QStringW): QStringA;
begin
  Result := qstring.Utf8Encode('PTN_' + AId);
end;

function TQPgSQLProvider.Prepare(var AResult: TQCommand; ACmdText: QStringW;
  AId: QStringW): Boolean;
begin
  ClosePortal(AId);
  if Length(AId) = 0 then
    AId := NewStatementId;
  Result := inherited Prepare(AResult, ACmdText, AId);
end;

{ TQPgSQLProvider }

procedure TQPgSQLProvider.CloseHandle(AHandle: THandle);
begin
  inherited;

end;

procedure TQPgSQLProvider.ClosePortal(AStatementId: QStringW);
var
  AName: QStringA;
begin
  AName := PortalName(AStatementId);
  SendBuffer.Cat(Byte(cmClose)).Cat(ExchangeByteOrder(6 + AName.Length))
    .Cat(Byte(Ord('P'))).Cat(AName, True);
  SendData;
end;

constructor TQPgSQLProvider.Create(AOwner: TComponent);
begin
  inherited;
  DefaultPort := 5432;
  FNotifyEvent := TEvent.Create(nil, False, False, '');
end;

function TQPgSQLProvider.DecodePgString(var p: PByte): QStringW;
var
  ps: PByte;
begin
  ps := p;
  while p^ <> 0 do
    Inc(p);
  Result := qstring.Utf8Decode(PQCharA(ps), IntPtr(p) - IntPtr(ps));
  Inc(p);
end;

destructor TQPgSQLProvider.Destroy;
begin
  FreeObject(FNotifyEvent);
  inherited;
end;

procedure TQPgSQLProvider.DispatchData;
var
  pMsg, ANext: PPQMsg;
  ARemain, ADataSize, AOffset: Integer;
  procedure MoveBuffer;
  begin
    ARemain := RecvBuffer.Position + IntPtr(RecvBuffer.Start) - IntPtr(pMsg);
    if ARemain > 0 then
    begin
      Move(pMsg^, RecvBuffer.Start^, ARemain);
      RecvBuffer.Position := ARemain;
    end
    else
      RecvBuffer.Reset;
  end;

begin
  pMsg := PPQMsg(RecvBuffer.Start);
  repeat
    ADataSize := ExchangeByteOrder(pMsg.DataSize);
    ANext := Pointer(IntPtr(pMsg) + 1 + ADataSize);
    AOffset := IntPtr(ANext) - IntPtr(RecvBuffer.Start);
    if AOffset <= RecvBuffer.Position then
    begin
      pMsg.DataSize := ADataSize;
      DispatchPgMessage(pMsg);
      pMsg := Pointer(ANext);
      if AOffset + 5 > RecvBuffer.Position then
      begin
        MoveBuffer;
        Break;
      end;
    end
    else
    begin
      MoveBuffer;
      Break;
    end;
  until 1 > 2;
end;

procedure TQPgSQLProvider.DispatchPgMessage(AMsg: PPQMsg);

  procedure DoAuthMsg(AInfo: PPQAuthMsg);
  begin
    FAuthType := TPQAuth(ExchangeByteOrder(AInfo.AuthType));
    FAuthSalt := AInfo.Salt;
    FQueryStatus := qsAuth;
    FNotifyEvent.SetEvent;
  end;

  procedure DoParamStatus;
  var
    AName, AValue: QStringW;
    p: PByte;
  begin
    p := @AMsg.Data;
    AName := DecodePgString(p);
    AValue := DecodePgString(p);
    Params.Values[AName] := AValue;
    // OutputDebugString(PChar('[PARAM]' + AName + '=' + AValue));
  end;

  procedure DoKeyData;
  var
    p: PInteger;
  begin
    p := PInteger(@AMsg.Data);
    FPId := ExchangeByteOrder(p^);
    Inc(p);
    FSecurityKey := ExchangeByteOrder(p^);
  end;

  procedure DoReadyForQuery;
  begin
    case AMsg.Data[0] of
      $49: // Idle
        FQueryStatus := qsIdle;
      $54: // Transaction
        FQueryStatus := qsInTransaction;
      $45: // Error
        FQueryStatus := qsError
    else
      FQueryStatus := qsUnknown;
    end;
    FNotifyEvent.SetEvent;
  end;
  procedure AddFieldDef(const AName: QStringW; const ADesc: PQPgFieldDesc);
  var
    ADef: TQFieldDef;
    I: Integer;
    AFound: Boolean;
    AType: Cardinal;
  begin
    ADef := FActiveFieldDefs.AddFieldDef as TQFieldDef;
    ADef.Name := AName;
    if ADesc.TableId <> 0 then
    begin
      ADef.Table := IntToStr(ADesc.TableId);
      AFound := False;
      for I := 0 to High(FDelayBindTables) do
      begin
        if FDelayBindTables[I] = ADesc.TableId then
        begin
          AFound := True;
          Break;
        end;
      end;
      if not AFound then // ��Ҫ��ȡ���Ԫ������Ϣ
      begin
        SetLength(FDelayBindTables, Length(FDelayBindTables) + 1);
        FDelayBindTables[High(FDelayBindTables)] := ADesc.TableId;
      end;
    end
    else
      ADef.InternalCalcField := True;
    AType := FindType(ADesc.ColType);
    ADef.DBType := AType;
    ADef.DBNo := ADesc.ColId;
    ADef.IsFixed := (ADef.DBType and SQL_MASK_FIXEDSIZE) <> 0;
    ADef.IsArray := (ADef.DBType and SQL_MASK_ARRAY) <> 0;
    if not ADef.IsFixed then
    begin
      // ���ڶ��������Ǹ������ڲ�������ʽ���ֽ���Ŀ
      // ���ڱ䳤�����Ǹ�����-1 ��ʾһ��"�䳤"����(�г��������Ե�����)��
      // -2 ��ʾ����һ�� NULL ��β�� C �ַ�����
      if ADesc.ColSize > 0 then
        ADef.Size := ADesc.ColSize
      else
        ADef.Size := MaxInt;
    end;
    if ADesc.TypeMod <> -1 then
    begin
      case ADef.DBType of
        SQL_BIT, SQL_VARBIT:
          begin
            ADef.Size := ADesc.TypeMod shr 3; // λ��ӳ��ΪBYTES�����Գ��ȳ���8������3λ��
            if ADef.Size = 0 then
              ADef.Size := 1;
          end;
        SQL_CHAR, SQL_VARCHAR, SQL_WIDECHAR, SQL_WIDEVARCHAR,
          Integer(SQL_CHAR OR SQL_ARRAY), Integer(SQL_VARCHAR OR SQL_ARRAY),
          Integer(SQL_WIDECHAR OR SQL_ARRAY),
          Integer(SQL_WIDEVARCHAR OR SQL_ARRAY):
          ADef.Size := (ADesc.TypeMod - 4);
        SQL_NUMERIC, Integer(SQL_NUMERIC OR SQL_ARRAY):
          begin
            Dec(ADesc.TypeMod, 4);
            ADef.Precision := (ADesc.TypeMod shr 16) and $FFFF;
            ADef.Scale := ADesc.TypeMod and $FFFF;
          end;
        // SQL_TIME/SQL_DATETIME/SQL_DATE ����ӳ�䵽�����TDateTime���ͣ����Ծͺ�������
      end;
    end;
  end;

  procedure DoRowDescription;
  var
    p: PByte;
    I, AColCount: Word;
    ADesc: PQPgFieldDesc;
    AName: QStringW;
  begin
    if (FResultSetCount > 0) and (not FFetchMeta) then
      AddResultSet;
    if Assigned(FActiveRequest) then
    begin
      p := @AMsg.Data;
      AColCount := ExchangeByteOrder(PWord(p)^);
      Inc(p, sizeof(Word));
      // OutputDebugString(PChar('�����ֶ���:' + IntToStr(AColCount)));
      // ��������Ϣ�е�������Ϣ
      FActiveRequest.Result.Statics.AffectRows := 0;
      if Assigned(FActiveFieldDefs) then
      begin
        // Todo:Add Converter Support
        // else
        // AFieldDefs:=TQConverter(FActiveRequest.Command.DataObject).;
        // ��ͷ�����ֶε��ӳٰ�
        FActiveFieldDefs.BeginUpdate;
        try
          FActiveFieldDefs.Clear;
          I := 0;
          while I < AColCount do
          begin
            AName := DecodePgString(p);
            ADesc := PQPgFieldDesc(p);
            ADesc.TableId := ExchangeByteOrder(ADesc.TableId);
            ADesc.ColId := ExchangeByteOrder(ADesc.ColId);
            ADesc.ColType := ExchangeByteOrder(ADesc.ColType);
            ADesc.ColSize := ExchangeByteOrder(ADesc.ColSize);
            ADesc.TypeMod := ExchangeByteOrder(ADesc.TypeMod);
            AddFieldDef(AName, ADesc);
            Inc(p, sizeof(TQPgFieldDesc));
            Inc(I);
          end;
        finally
          FActiveFieldDefs.EndUpdate;
        end;
      end;
    end
    else
    // û�л���󣬺��Է��ص���������Ϣ���߼��ϲ�Ӧ��ִ�е����
    begin
    end;
  end;

  procedure DoDataRow;
  var
    p: PByte;
    I, AColCount: Smallint;
    ASize: Integer;
    AStream: TMemoryStream;
  begin
    if Assigned(FActiveRequest.Command.DataObject) then
    begin
      p := @AMsg.Data;
      AColCount := ExchangeByteOrder(PSmallint(p)^);
      Inc(p, sizeof(Smallint));
      I := 0;
      FActiveRecord := AllocRecord;
      while I < AColCount do
      begin
        ASize := ExchangeByteOrder(PInteger(p)^);
        Inc(p, sizeof(Integer));
        if ASize = -1 then
          FActiveRecord.Values[I].OldValue.TypeNeeded(vdtNull)
        else
        begin
          FActiveRecord.Values[I].OldValue.TypeNeeded
            (TQFieldDef(FActiveFieldDefs[I]).ValueType);
          if FActiveFieldDefs[I].DataType in [ftMemo, ftFmtMemo] then
          begin
            AStream := FActiveRecord.Values[I].OldValue.Value.AsStream;
            AStream.Size := ASize;
            AStream.Position := 0;
            Move(p^, AStream.Memory^, ASize);
            // FActiveRecord.Values[I].OldValue.Value.AsStream.WriteBuffer();
            // SaveTextU(FActiveRecord.Values[I].OldValue.Value.AsStream,
            // qstring.Utf8Decode(PQCharA(p), ASize))
          end
          else if FActiveFieldDefs[I].DataType = ftWideMemo then
          begin
            TQValueStream(FActiveRecord.Values[I].OldValue.Value.AsStream)
              .Size := 0;
            SaveTextW(TQValueStream(FActiveRecord.Values[I]
              .OldValue.Value.AsStream), qstring.Utf8Decode(PQCharA(p),
              ASize), False)
          end
          else if FActiveRecord.Values[I].OldValue.ValueType = vdtStream then
          begin
            // Todo:Blob type support
          end
          else
            FActiveRecord.Values[I].OldValue.AsString :=
              qstring.Utf8Decode(PQCharA(p), ASize);
          Inc(p, ASize);
        end;
        Inc(I);
      end;
      AddResultRecord(FActiveRecord);
    end;
    Inc(FActiveRequest.Result.Statics.AffectRows);
  end;

  procedure FetchInformation(var AInfo: TQPgInformation);
  var
    p: PByte;
    ACode: QStringW;
  const
    CodeDelimiter: PWideChar = 'P';
    NullChar: WideChar = #0;
  begin
    p := @AMsg.Data[0];
    AInfo.ErrorCode := 0;
    repeat
      case TPGErrorType(p^) of
        peSeverity:
          // 'S' �����ԣ����ֶε�������ERROR��FATAL�� ���� PANIC����һ��������Ϣ������� WARNING�� NOTICE��DEBUG��INFO �� LOG ����һ��֪ͨ��Ϣ�����������Щ��ĳ�ֱ��ػ�������ִ������ǻ���֡�
          begin
            Inc(p);
            AInfo.Severity := DecodePgString(p);
            if AInfo.Severity = 'ERROR' then
              AInfo.ErrorLevel := nlError
            else if AInfo.Severity = 'FATAL' then
              AInfo.ErrorLevel := nlFatal
            else if AInfo.Severity = 'PANIC' then
              AInfo.ErrorLevel := nlPanic
            else if AInfo.Severity = 'WARNING' then
              AInfo.ErrorLevel := nlWarning
            else if AInfo.Severity = 'NOTICE' then
              AInfo.ErrorLevel := nlNotice
            else if AInfo.Severity = 'DEBUG' then
              AInfo.ErrorLevel := nlDebug
            else if AInfo.Severity = 'INFO' then
              AInfo.ErrorLevel := nlInfo
            else if AInfo.Severity = 'LOG' then
              AInfo.ErrorLevel := nlLog;
          end;
        peCode: // 'C' ���룺����� SQLSTATE ���루���� Appendix A���� ���ܱ��ػ������ǳ��֡�
          begin
            Inc(p);
            ACode := DecodePgString(p);
            AInfo.Code := ACode;
            AInfo.ErrorCode :=
              Cardinal(StrToIntDef('0x' + DecodeTokenW(ACode, CodeDelimiter,
              NullChar, True, True), 0) shl 16) +
              Cardinal(StrToIntDef(ACode, 0));
          end;
        peMessage: // M ��Ϣ������ɶ��Ĵ�����Ϣ�����塣��Щ��ϢӦ��׼ȷ���Ҽ�ࣨͨ����һ�У������ǳ��֡�
          begin
            Inc(p);
            AInfo.Text := DecodePgString(p);
          end;
        peDetail:
          // D ϸ�ڣ�һ����ѡ�Ĵ���������Ϣ�������й�����ĸ��������Ϣ�� �����Ƕ��С�
          begin
            Inc(p);
            AInfo.Detail := DecodePgString(p);
          end;
        peHint:
          // H ��ʾ��һ����ѡ���й���δ�������Ľ��顣����ϸ�ڲ�ͬ�ĵط���������˽��飨���ܲ������ʣ�������������ʵ�������Ƕ��С�
          begin
            Inc(p);
            AInfo.Hint := DecodePgString(p);
          end;
        peCursorPos:
          // P λ�ã�����ֶ�ֵ��һ��ʮ���� ASCII ��������ʾһ�������α��λ�ã� ����һ��ָ��ԭʼ��ѯ�ִ�����������һ���ַ��������� 1��λ�������ַ���������ֽڼ���ġ�
          begin
            Inc(p);
            AInfo.CursorPos := DecodePgString(p);
          end;
        peInternalCursorPos:
          // p �ڲ�λ�ã������� P ������ͬ�������������α��λ��ָ��һ���ڲ����ɵ���� ���������ڿͻ����ύ���������ֶγ��ֵ�ʱ�����ǻ���� q �ֶΡ�
          begin
            Inc(p);
            AInfo.InternalCursorPos := DecodePgString(p);
          end;
        peQuery: // q �ڲ���ѯ��ʧЧ���ڲ����ɵ�������ı��� ���磬��������һ�� PL/pgSQL ���������� SQL ��ѯ��
          begin
            Inc(p);
            AInfo.SQL := DecodePgString(p);
          end;
        // Todo:�ֽ����Ĵ������,W����δ���Է�����������δ֪
        peWhere: // W ���һ��ָʾ�������Ļ�����ָʾ����Ŀǰ�� �����������һ����Ծ�Ĺ������Ժ����ĵ��ö�ջ��׷�ݺ��ڲ����ɵĲ�ѯ�� ���׷��ÿ����¼һ�У����µ��������档
          begin
            Inc(p);
            AInfo.Where := DecodePgString(p);
          end;
        peFile:
          // F�ļ��������������Դ�����е�λ�á�
          begin
            Inc(p);
            AInfo.SourceFile := DecodePgString(p);
          end;
        peLine:
          // Line�У�����Ĵ������ڵ�Դ�����λ�õ��кš�
          begin
            Inc(p);
            AInfo.SourceLine := DecodePgString(p);
          end;
        peCategory:
          // Routine���̣��������Ĺ�����Դ�����е����֡�
          begin
            Inc(p);
            AInfo.Routine := DecodePgString(p);
          end;
        peSchemaName:
          begin
            Inc(p);
            AInfo.Schema := DecodePgString(p);
          end;
        peTableName:
          begin
            Inc(p);
            AInfo.Table := DecodePgString(p);
          end;
        peDataType:
          begin
            Inc(p);
            AInfo.DataType := DecodePgString(p);
          end;
        peConstraint:
          begin
            Inc(p);
            AInfo.Constraint := DecodePgString(p);
          end;
      end;
    until p^ = 0;
  end;

  procedure DoNotice;
  var
    AInfo: TQPgInformation;
  begin
    FetchInformation(AInfo);
    ServerNotice(AInfo.ErrorLevel, AInfo.Text);
  end;

  procedure DoErrorMsg;
  var
    AInfo: TQPgInformation;
    S, ALine: QStringW;
    p, pe: PQCharW;
    APos, ACol, ARow: Integer;
  begin
    FetchInformation(AInfo);
    if AInfo.ErrorCode <> 0 then
    begin
      if Length(AInfo.Severity) > 0 then
        S := AInfo.Severity + #13#10;
      if Length(AInfo.Text) > 0 then
        S := S + AInfo.Text + #13#10;
      if Length(AInfo.Detail) > 0 then
        S := S + AInfo.Detail + #13#10;
      if Length(AInfo.Hint) > 0 then
        S := S + AInfo.Hint + #13#10;
      if Length(AInfo.Where) > 0 then
        S := S + AInfo.Where + #13#10;
      if Length(AInfo.SQL) > 0 then
        S := S + AInfo.SQL + #13#10;
      if (Length(AInfo.CursorPos) > 0) and TryStrToInt(AInfo.CursorPos, APos)
      then
      begin
        pe := PQCharW(FActiveRequest.Command.SQL);
        p := pe;
        Inc(pe, APos);
        pe := StrPosW(p, pe, ACol, ARow);
        while IntPtr(pe) > IntPtr(p) do
        begin
          Dec(pe);
          if (pe^ = ';') or (pe^ = #10) then
          begin
            Inc(pe);
            Break;
          end;
        end;
        ALine := DecodeLineW(pe);
        S := S + Format(SErrorLineCol, [ARow, ACol, ALine]) + #13#10;
      end;
      if Assigned(FActiveRequest) then
      begin
        FActiveRequest.Result.ErrorCode := AInfo.ErrorCode;
        FActiveRequest.Result.ErrorMsg := StrDupX(PWideChar(S), Length(S) - 2);
      end
      else
        SetError(AInfo.ErrorCode, StrDupX(PWideChar(S), Length(S) - 2));
    end;
    ServerNotice(AInfo.ErrorLevel, AInfo.Text);
    FQueryStatus := qsError;
    FNotifyEvent.SetEvent;
    // OutputDebugString(PChar('[ERROR]' + S));
  end;

  procedure DoParsed;
  begin
    // ֻ��һ����Ϣ���ȣ����߽�����ɣ�����Ҫ�κδ���
    // OutputDebugString('Parse complete');
  end;

  procedure DoCommandDone;
  var
    S, Action: QStringW;
    ARows: Integer;
  const
    CommandSpace: PWideChar = ' ';
    NullChar: WideChar = #0;
  begin
    S := qstring.Utf8Decode(PQCharA(@AMsg.Data[0]), AMsg.DataSize);
    Action := DecodeTokenW(S, CommandSpace, NullChar, True, True);
    if Action = 'INSERT' then
    begin
      Action := DecodeTokenW(S, CommandSpace, NullChar, True, True);
      FLastOID := StrToInt(Action);
    end;
    if TryStrToInt(S, ARows) then
      Inc(FActiveRequest.Result.Statics.AffectRows, ARows);
    if (FActiveRequest.Command.Action in [caFetchRecords, caFetchStream]) then
      Inc(FResultSetCount);
    FActiveRecord := nil;
    // OutputDebugString(PChar(S));
  end;

  procedure DoClosed;
  begin
    // FQueryStatus := qsError;
    // FActiveRequest.Result.ErrorCode := Cardinal(-1);
    // FActiveRequest.Result.ErrorMsg := SUnexpectReply;
    // FNotifyEvent.SetEvent;
  end;

  procedure DoParamDesc;
  var
    AParamCount: Word;
    ATypeOId: Cardinal;
    I: Integer;
    ADBParams: TQPgPreparedData;
  begin
    AParamCount := ExchangeByteOrder(PWord(@AMsg.Data[0])^);
    SetLength(FActiveRequest.Command.Params, AParamCount);
    if not Assigned(FActiveRequest.Command.PreparedData) then
    begin
      ADBParams := TQPgPreparedData.Create;
      FActiveRequest.Command.PreparedData := ADBParams;
    end
    else
      ADBParams := FActiveRequest.Command.PreparedData as TQPgPreparedData;
    SetLength(ADBParams.ParamTypes, AParamCount);
    // OutputDebugString(PChar('Param count=' + IntToStr(AParamCount)));
    for I := 0 to AParamCount - 1 do
    begin
      ATypeOId := ExchangeByteOrder(PInteger(@AMsg.Data[2 + I * 4])^);
      ADBParams.ParamTypes[I] := FindType(ATypeOId);
      FActiveRequest.Command.Params[I].TypeNeeded(Pg2ValueType(ATypeOId));
      // OutputDebugString(PChar(IntToStr(I) + '.Type=' +
      // IntToStr(ExchangeByteOrder(PInteger(@AMsg.Data[2 + I * 4])^))));
    end;
  end;

begin
  // OutputDebugString(PChar('Recv Message ' + PQServerMsgName(AMsg.Msg) + '(' +
  // IntToStr(Integer(AMsg.Msg)) + ',0x' + IntToHex(Integer(AMsg.Msg),
  // 4) + ')'));
  case AMsg.Msg of
    smParsed:
      DoParsed;
    smBound:
      ;
    smClosed:
      DoClosed;
    smNotification:
      ;
    smCommandDone:
      DoCommandDone;
    smDataRow:
      DoDataRow;
    smError:
      DoErrorMsg;
    smStartCopyIn:
      ;
    smStartCopyOut:
      ;
    smEmpty: // ��������⵽һ���յĲ�ѯ������Ҫ������Ĵ���ֱ�Ӻ��Ծͺ���
      ;
    smKeyData:
      DoKeyData;
    smNotice:
      DoNotice;
    smAuth:
      DoAuthMsg(PPQAuthMsg(AMsg));
    smParamStatus:
      DoParamStatus;
    smRowDesc:
      DoRowDescription;
    svFunction:
      ;
    smReady:
      DoReadyForQuery;
    smCopyDone:
      begin
      end;
    smCopyData:
      ;
    smNoData:
      ;
    smSuspended:
      ;
    smParamDesc:
      DoParamDesc;
  else
    begin
      DoClosed;
    end;
  end;
end;

function TQPgSQLProvider.FindType(APgType: Word): Cardinal;
var
  AIndex: Integer;
  function InternalFind(L, R: Integer): Integer;
  var
    M: Integer;
  begin
    Result := -1;
    while L <= R do
    begin
      M := (L + R) shr 1;
      if APgType > PgTypes[M].OID then
        L := M + 1
      else if APgType < PgTypes[M].OID then
        R := M - 1
      else
      begin
        Result := M;
        Exit;
      end;
    end;
  end;

begin
  AIndex := InternalFind(0, High(PgTypes));
  if AIndex = -1 then
    Result := SQL_TEXT
  else
    Result := PgTypes[AIndex].DBType;
end;

function TQPgSQLProvider.NewStatementId: QStringW;
begin
  Result := IntToHex(IntPtr(Self), sizeof(Pointer) shl 1) + '_' +
    IntToStr(AtomicIncrement(FStatementCounter));
end;

procedure TQPgSQLProvider.Handshake;
var
  S: QStringW;
  procedure AddParam(N, V: QStringW);
  begin
    SendBuffer.Cat(qstring.Utf8Encode(N), True)
      .Cat(qstring.Utf8Encode(V), True);
  end;
  procedure SetupParams;
  begin
    S := Params.Values['application_name'];
    if Length(S) = 0 then
      S := Params.Values['app_name'];
    if Length(S) = 0 then
      S := ExtractFileName(GetModuleName(MainInstance));
    if Length(S) > 0 then
      AddParam('application_name', S);
    AddParam('user', UserName);
    AddParam('database', Database);
  end;

begin
  // ��ʼ������
  SendBuffer.Position := sizeof(Integer); // ������ʼ�����ֽ���
  SendBuffer.Cat(ExchangeByteOrder(PG_PROTOCOL_V3));
  SetupParams;
  SendBuffer.Cat(Byte(0));
  PInteger(SendBuffer.Start)^ :=
    ExchangeByteOrder(Integer(SendBuffer.Position));
  SendAndWait(pwaHandshake);
  if FErrorCode <> 0 then
  begin
    InternalClose;
    DatabaseError(LastErrorMsg);
  end;
end;

procedure TQPgSQLProvider.InternalApplyChanges(AFields: TFieldDefs;
  ARecords: TQRecords);
var
  I: Integer;
  ARequest: TQSQLRequest;
  ARec: TQRecord;
  ASQLBuilder: TQStringCatHelperW;
  ATableName: String;
  AWhereFields: array of TQFieldDef;
  function QuotedIdent(const S: QStringW): QStringW;
  begin
    if ContainsCharW(S, ' ') then
      Result := QuotedStrW(S, '"')
    else
      Result := S;
  end;
  procedure CheckTable;
  var
    ADef: TQFieldDef;
    ACount, J: Integer;
    Added: Boolean;
    ADefTable: QStringW;
  begin
    I := 0;
    ACount := 0;
    SetLength(AWhereFields, AFields.Count);
    while I < AFields.Count do
    begin
      ADef := AFields[I] as TQFieldDef;
      if (Length(ADef.BaseName) > 0) and ADef.InWhere then
      // �����ֶΡ����������ݺ�Blob�ֶβ�����Ϊwhere����
      begin
        if ACount > 0 then
        begin
          Added := False;
          if ADef.IsPrimary then
          begin
            Move(AWhereFields[0], AWhereFields[1], ACount * sizeof(TQFieldDef));
            AWhereFields[0] := ADef;
            Added := True;
            Inc(ACount);
          end
          else if ADef.IsUnique then // Ψһ,Ų������������Ϊֵ
          begin
            for J := 0 to ACount - 1 do
            begin
              if not AWhereFields[J].IsPrimary then
              begin
                Move(AWhereFields[J], AWhereFields[J + 1],
                  (ACount - J) * sizeof(TQFieldDef));
                AWhereFields[J] := ADef;
                Added := True;
                Inc(ACount);
                Break;
              end;
            end;
          end
          else if ADef.IsIndex then // �����ֶηŵ���ͨ�ֶε�ǰ�棬��������Ψһ��������
          begin
            for J := 0 to ACount - 1 do
            begin
              if not(AWhereFields[J].IsPrimary or AWhereFields[J].IsUnique or
                AWhereFields[J].IsIndex) then
              begin
                Move(AWhereFields[J], AWhereFields[J + 1],
                  (ACount - J) * sizeof(TQFieldDef));
                AWhereFields[J] := ADef;
                Added := True;
                Inc(ACount);
                Break;
              end;
            end;
          end;
          if not Added then
          begin
            AWhereFields[ACount] := ADef;
            Inc(ACount);
          end;
        end
        else
        begin
          AWhereFields[ACount] := ADef;
          Inc(ACount);
        end;
      end;
      if Length(ADef.Table) > 0 then
      begin
        if Length(ADef.Schema) > 0 then
          ADefTable := QuotedIdent(ADef.Schema) + '.' + QuotedIdent(ADef.Table)
        else
          ADefTable := QuotedIdent(ADef.Table);
        if Length(ATableName) = 0 then
        begin
          if Length(ADef.Schema) > 0 then
            ATableName := QuotedIdent(ADef.Schema) + '.' +
              QuotedIdent(ADef.Table)
          else
            ATableName := QuotedIdent(ADef.Table);
        end
        else if ATableName <> ADefTable then
          raise QException.CreateFmt(STooManyTable, [ATableName, ADef.Table]);
      end;
      Inc(I);
    end;
    SetLength(AWhereFields, ACount);
    if ACount = 0 then
      raise QException.Create(SNoTableFound);
  end;

  function DateTimeValue(Value: TDateTime): String;
  var
    iVal: Integer;
  begin
    iVal := Trunc(Value);
    if IsZero(Value - iVal) then
      Result := FormatDateTime('yyyy-mm-dd', Value)
    else if iVal = 0 then
      Result := FormatDateTime('hh:nn:ss.zzz', Value)
    else
      Result := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Value);
  end;
  function ToPgString(const AValue: TQValue; AllowNull: Boolean): QStringW;
  var
    I: Integer;
  begin
    case AValue.ValueType of
      vdtUnset, vdtNull:
        begin
          if AllowNull then
            Result := 'null'
          else
            Result := 'default';
        end;
      vdtBoolean:
        begin
          if AValue.Value.AsBoolean then
            Result := 'true'
          else
            Result := 'false';
        end;
      vdtSingle:
        Result := FloatToStr(AValue.Value.AsSingle);
      vdtFloat:
        Result := FloatToStr(AValue.Value.AsFloat);
      vdtInteger:
        Result := IntToStr(AValue.Value.AsInteger);
      vdtInt64:
        Result := IntToStr(AValue.Value.AsInt64);
      vdtCurrency:
        Result := CurrToStr(AValue.Value.AsCurrency);
      vdtBcd:
        Result := BcdToStr(AValue.Value.AsBcd^);
      vdtGuid:
        Result := '''' + GuidToString(AValue.Value.AsGuid^) + '''';
      vdtDateTime:
        Result := '''' + DateTimeValue(AValue.AsDateTime) + '''';
      vdtInterval:
        Result := '''' + AValue.Value.AsInterval.AsPgString + '''';
      vdtString:
        Result := QuotedStrW(AValue.Value.AsString^, '''');
      vdtStream: // Todo:������봦��
        Result := 'E''\\x' + BinToHex(TQValueStream(AValue.Value.AsStream)
          .Memory, TQValueStream(AValue.Value.AsStream).Size) + '''';
      vdtArray:
        begin
          Result := '{';
          for I := 0 to AValue.Value.Size - 1 do
            Result := Result + ToPgString(AValue.Items[I]^, AllowNull) + ',';
          SetLength(Result, Length(Result) - 1);
          Result := Result + '}';
        end;
    end;
  end;

  procedure AppendSQL;
  var
    J: Integer;
    AField: TQFieldDef;
  begin
    case ARec.Status of
      usModified:
        begin
          ASQLBuilder.Cat('update ').Cat(ATableName).Cat(' set ');
          for J := 0 to AFields.Count - 1 do
          begin
            AField := AFields[J] as TQFieldDef;
            if Length(AField.BaseName) > 0 then
            begin
              if ARec.Values[J].Changed then
                ASQLBuilder.Cat(QuotedIdent(AField.BaseName)).Cat('=')
                  .Cat(ToPgString(ARec.Values[J].NewValue, AField.Nullable)
                  ).Cat(',');
            end;
          end;
          ASQLBuilder.Back(1);
          ASQLBuilder.Cat(' where ');
          for J := 0 to High(AWhereFields) do
          begin
            AField := AWhereFields[J];
            if ARec.Values[AField.FieldNo - 1].OldValue.IsNull then
              ASQLBuilder.Cat(QuotedIdent(AField.BaseName)).Cat(' is null')
            else
              ASQLBuilder.Cat(QuotedIdent(AField.BaseName)).Cat('=')
                .Cat(ToPgString(ARec.Values[AField.FieldNo - 1].OldValue,
                AField.Nullable));
            ASQLBuilder.Cat(' and ');
          end;
          ASQLBuilder.Back(5);
          ASQLBuilder.Cat(';'#13#10);
        end;
      usInserted:
        begin
          ASQLBuilder.Cat('insert into ').Cat(ATableName).Cat(' (');
          for J := 0 to AFields.Count - 1 do
          begin
            AField := AFields[J] as TQFieldDef;
            ASQLBuilder.Cat(QuotedIdent(AField.BaseName)).Cat(',');
          end;
          ASQLBuilder.Back(1);
          ASQLBuilder.Cat(') values (');
          for J := 0 to AFields.Count - 1 do
            begin
            AField := AFields[J] as TQFieldDef;
            ASQLBuilder.Cat(ToPgString(ARec.Values[J].NewValue, AField.Nullable)
              ).Cat(',');
            end;
          ASQLBuilder.Back(1);
          ASQLBuilder.Cat(');'#13#10);
        end;
      usDeleted:
        begin
          ASQLBuilder.Cat('delete from ').Cat(ATableName).Cat(' where ');
          for J := 0 to High(AWhereFields) do
          begin
            AField := AWhereFields[J];
            ASQLBuilder.Cat(QuotedIdent(AField.BaseName)).Cat('=')
              .Cat(ToPgString(ARec.Values[AField.FieldNo - 1].OldValue,
              AField.Nullable)).Cat(' and ');
          end;
          ASQLBuilder.Back(5);
          ASQLBuilder.Cat(';'#13#10);
        end;
    end;
  end;

begin
  CheckTable;
  ARequest.Command.Action := caExecute;
  ARequest.Command.Prepared := False;
  ARequest.Command.FieldDefs := AFields as TQFieldDefs;
  ARequest.Command.DataObject := nil;
  ARequest.WaitResult := True;
  FillChar(ARequest.Result.Statics, sizeof(ARequest.Result.Statics), 0);
  ARequest.Result.ErrorCode := 0;
  ASQLBuilder := TQStringCatHelperW.Create;
  try
    ASQLBuilder.Cat('begin;'#13#10);
    for I := 0 to ARecords.Count - 1 do
    begin
      ARec := ARecords[I];
      if ARec.Status <> usUnmodified then
        AppendSQL;
    end;
    ARequest.Command.SQL := ASQLBuilder.Value;
    FActiveRequest := @ARequest;
    FActiveFieldDefs := ARequest.Command.FieldDefs;

    PostLog(llHint, ARequest.Command.SQL);
    if not InternalExecute(ARequest) then
    begin
      ExecuteCmd('rollback;');
      raise QException.Create(ARequest.Result.ErrorMsg);
    end
    else if ARequest.Result.Statics.AffectRows <> ARecords.Count then
    begin
      ExecuteCmd('rollback;');
      raise QException.Create(STooManyAffectedRows);
    end
    else
    begin
      ARequest.Command.SQL := 'commit;';
      InternalExecute(ARequest);
    end;
  finally
    FreeAndNil(ASQLBuilder);
    FActiveRequest := nil;
    FActiveFieldDefs := nil;
  end;
end;

procedure TQPgSQLProvider.InternalClose;
begin
  SendBuffer.Cat(Byte(cmTerminte)).Cat(Integer(0));
  SendData;
  inherited;
end;

function TQPgSQLProvider.InternalExecute(var ARequest: TQSQLRequest): Boolean;
var
  S: QStringA;

  procedure DoSync;
  begin
    SendCmd(cmSync);
    SendInt(4);
    SendAndWait(pwaExecute);
  end;

  procedure DoPrepare;
  var
    I, L: Integer;
    AName: QStringA;
  begin
    S := qstring.Utf8Encode(ARequest.Command.SQL);
    if not Assigned(ARequest.Command.FieldDefs) then
      ARequest.Command.FieldDefs := CreateDefaultDefs;
    FActiveFieldDefs := ARequest.Command.FieldDefs;
    // ����Parse����
    if Length(ARequest.Command.Id) = 0 then
      ARequest.Command.Id := NewStatementId;
    AName := StatementName(ARequest.Command.Id);
    L := 8 + AName.Length + S.Length + Length(ARequest.Command.Params) *
      sizeof(Integer);
    SendCmd(cmParse);
    SendInt(L);
    SendString(AName, True);
    SendString(S, True);
    SendWord(Length(ARequest.Command.Params));
    L := High(ARequest.Command.Params);
    for I := 0 to L do
      SendWord(ValueType2Pg(ARequest.Command.Params[I].ValueType));
    // ���� Describe ����
    SendCmd(cmDescribe);
    SendInt(6 + AName.Length);
    SendByte(Ord('S'));
    SendString(AName, True);
    // ���� Sync ����
    DoSync;
    FActiveRequest.Command.Prepared := (FActiveRequest.Result.ErrorCode = 0);
  end;

  procedure DoUnprepare;
  var
    AName: QStringA;
  begin
    AName := StatementName(ARequest.Command.Id);
    SendCmd(cmClose);
    SendInt(6 + AName.Length);
    SendByte(Ord('S'));
    SendString(AName, True);
    DoSync;
  end;

  procedure SendParamFormats;
  var
    I, C: Integer;
    AHasTextFormat: Boolean;
    APreparedData: TQPgPreparedData;
  begin
    APreparedData := ARequest.Command.PreparedData as TQPgPreparedData;
    AHasTextFormat := False;
    C := High(ARequest.Command.Params);
    for I := 0 to C do
    begin
      if ARequest.Command.Params[I].ValueType in [vdtCurrency, vdtBcd, vdtGuid,
        vdtDateTime, vdtInterval, vdtString] then
      begin
        AHasTextFormat := True;
        Break;
      end;
    end;
    if AHasTextFormat then
    begin
      SendBuffer.Cat(ExchangeByteOrder(Word(Length(ARequest.Command.Params))));
      for I := 0 to High(ARequest.Command.Params) do
      begin
        if ARequest.Command.Params[I].ValueType
          in [vdtCurrency, vdtBcd, vdtGuid, vdtDateTime, vdtInterval, vdtString]
        then
          SendWord(1)
        else
          SendWord(0);
      end;
    end
    else
    begin
      SendWord(1);
      SendWord(1);
    end;
  end;

  procedure Bind;
  var
    S, I: Integer;
    APortalName, AStatName: QStringA;
  begin
    // Message,Size,PortalName,StatementName,ParamFormatNum,ParamFormats,ValueCount,Values
    APortalName := PortalName(ARequest.Command.Id);
    AStatName := StatementName(ARequest.Command.Id);
    ClosePortal(ARequest.Command.Id);
    // �ر�ǰһ�ε�����
    // SendCmd(cmClose);
    // SendInt(6 + APortalName.Length);
    // SendByte(Ord('P'));
    // SendString(APortalName, True);
    // ͷ��
    SendCmd(cmBind);
    SendInt(0);
    SendString(APortalName, True);
    SendString(AStatName, True);
    // ������ʽ
    SendParamFormats;
    SendWord(Length(ARequest.Command.Params));
    // Values:Length(Int32),Byte
    for I := 0 to High(ARequest.Command.Params) do
    begin
      case ARequest.Command.Params[I].ValueType of
        vdtUnset, vdtNull:
          SendInt(-1);
        vdtBoolean:
          begin
            SendInt(1);
            SendBool(ARequest.Command.Params[I].Value.AsBoolean);
          end;
        vdtFloat, vdtInt64:
          begin
            SendInt(sizeof(Int64));
            SendInt64(ARequest.Command.Params[I].Value.AsInt64);
          end;
        vdtInteger:
          begin
            SendInt(sizeof(Integer));
            SendInt(ARequest.Command.Params[I].Value.AsInteger);
          end;
        vdtCurrency, vdtBcd, vdtGuid, vdtDateTime, vdtInterval, vdtString:
          SendStringWithLength(ARequest.Command.Params[I].AsString);
        vdtStream:
          SendBytes(ARequest.Command.Params[I].AsStream.Memory,
            ARequest.Command.Params[I].AsStream.Size);
        vdtArray:
          ;
        // Todo:֧���������͵Ĳ���
      end;
    end;
    // if Assigned(ARequest.Command.FieldDefs) then
    // begin
    // SendWord(ARequest.Command.FieldDefs.Count);
    // for I := 0 to ARequest.Command.FieldDefs.Count - 1 do
    // begin
    // if ARequest.Command.FieldDefs[I].FieldClass.InheritsFrom(TStringField)
    // then
    // SendWord(0)
    // else
    // SendWord(1);
    // end;
    // end
    // else
    // ��ʱֻ֧��Text��ʽ�ķ���ֵ��Raw��ʽ�ķ���ֵ��Ҫͬʱ����DoDataRow��������֧�֣���ʱ����
    SendWord(1);
    SendWord(0);
    S := SendBuffer.Position;
    SendBuffer.Position := 1;
    SendInt(S - 1);
    SendBuffer.Position := S;
  end;

  procedure ExecutePrepared;
  var
    AName: QStringA;
    L: Integer;
  begin
    AName := PortalName(ARequest.Command.Id);
    L := Length(AName) + 6;
    SendCmd(cmDescribe);
    SendInt(L);
    SendByte(Ord('P'));
    SendString(AName, True);
    SendCmd(cmExecute);
    SendInt(AName.Length + 9);
    SendString(AName, True);
    SendInt(Integer(0));
    if Assigned(FActiveFieldDefs) and
      (FActiveFieldDefs <> ARequest.Command.FieldDefs) then
      FActiveFieldDefs.Assign(ARequest.Command.FieldDefs);
    DoSync;
  end;

  procedure SimpleQuery(const ASQL: QStringW);
  begin
    S := qstring.Utf8Encode(ASQL);
    SendCmd(cmQuery);
    SendInt(S.Length + 5);
    SendString(S, True);
    SendAndWait(pwaExecute);
  end;

  procedure BindAndExecute;
  begin
    Bind;
    ExecutePrepared;
  end;

  function InternalFetchMeta(ASQL: QStringW; ADataSet: TQDataSet): Boolean;
  var
    ARequest: TQSQLRequest;
    ALastRequest: PQSQLRequest;
    ALastFields: TQFieldDefs;
    ALastRecords: TQRecords;
  begin
    ALastRequest := FActiveRequest;
    ALastFields := FActiveFieldDefs;
    ALastRecords := FActiveRecords;
    try
      ADataSet.Close;
      ARequest.Command.SQL := ASQL;
      ARequest.Command.Action := caFetchRecords;
      ARequest.Command.DataObject := ADataSet;
      ARequest.Command.FieldDefs := ADataSet.FieldDefs as TQFieldDefs;
      ARequest.WaitResult := True;
      FActiveRequest := @ARequest;
      FResultSetCount := 0;
      SetFetching(ADataSet);
      ARequest.Result.ErrorCode := 0;
      SimpleQuery(ARequest.Command.SQL);
      Result := ARequest.Result.ErrorCode = 0;
      if Result then
      begin
        ADataSet.Provider := Self;
        ADataSet.Open;
      end;
    finally
      FActiveRequest := ALastRequest;
      FActiveFieldDefs := ALastFields;
      FActiveRecords := ALastRecords;
    end;
  end;

  procedure FetchColumnMeta(ADataSet: TQDataSet; AIdList: QStringW);
  var
    ASQL, S: QStringW;
    AFdDatabase, AFdSchema, AFdTable, AFdOid, AFdName, AFdNo, AFdNullable,
      AFdDefVal, AFdIsIndex, AFdIsUnique, AFdIsPrimary: TField;
    ATableId, ALastTableId, AColId: Cardinal;
    I: Integer;
    ADef: TQFieldDef;
  begin
    ASQL := 'select current_database() AS TABLE_CATALOG, n.nspname AS TABLE_SCHEMA, c.relname AS TABLE_NAME, c.oid AS TABLE_OID, a.attname AS COLUMN_NAME, a.attnum AS POSITION, '
      + 'a.atttypid AS DATA_TYPE, a.attlen AS DATA_LENGTH,a.atttypmod AS TYPE_MODIFIER, '
      + 'case when a.attnotnull then false else true end AS NULLABLE,pg_get_expr(ad.adbin, ad.adrelid) AS DEFAULT_VALUE, '
      + 'idx.indexrelid INDEX_ID, ' +
      'case when idx.indexrelid is null then false else true end as IS_INDEX, '
      + 'case when idx.indisunique is null then false else true end as IS_UNIQUE, '
      + 'case when idx.indisprimary is null then false else true end as IS_PRIMARY '
      + 'FROM pg_class c ' +
      'INNER JOIN pg_namespace n ON n.oid = c.relnamespace ' +
      'INNER JOIN pg_attribute a ON a.attrelid = c.oid ' +
      'LEFT JOIN pg_attrdef ad ON a.attrelid = ad.adrelid and a.attnum = ad.adnum '
      + 'LEFT JOIN pg_index idx on idx.indrelid=c.oid and a.attnum=any(idx.indkey) '
      + 'where c.oid in (' + AIdList +
      ') and a.attnum > 0 AND not a.attisdropped ' +
      'ORDER BY n.nspname, c.relname, a.attnum ';
    if not InternalFetchMeta(ASQL, ADataSet) then
      Exit;
    AFdDatabase := ADataSet.Fields[0];
    AFdSchema := ADataSet.Fields[1];
    AFdTable := ADataSet.Fields[2];
    AFdOid := ADataSet.Fields[3];
    AFdName := ADataSet.Fields[4];
    AFdNo := ADataSet.Fields[5];
    // AFdType := ADataSet.Fields[6];
    // AFdLen := ADataSet.Fields[7];
    // AFdMod := ADataSet.Fields[8];
    AFdNullable := ADataSet.Fields[9];
    AFdDefVal := ADataSet.Fields[10];
    // AFdIndexId := ADataSet.Fields[11];
    AFdIsIndex := ADataSet.Fields[12];
    AFdIsUnique := ADataSet.Fields[13];
    AFdIsPrimary := ADataSet.Fields[14];
    ALastTableId := 0;
    while not ADataSet.Eof do
    begin
      ATableId := Cardinal(AFdOid.AsInteger);
      if ALastTableId <> ATableId then
      begin
        ALastTableId := ATableId;
        S := IntToStr(ATableId);
      end;
      AColId := Cardinal(AFdNo.AsInteger);

      for I := 0 to FActiveFieldDefs.Count - 1 do
      begin
        ADef := FActiveFieldDefs[I] as TQFieldDef;
        if ADef.Table = S then
        begin
          if ADef.DBNo = AColId then
          begin
            ADef.Table := AFdTable.AsString;
            ADef.Schema := AFdSchema.AsString;
            ADef.Database := AFdDatabase.AsString;
            ADef.BaseName := AFdName.AsString;
            ADef.IsPrimary := AFdIsPrimary.AsBoolean;
            ADef.IsIndex := AFdIsIndex.AsBoolean;
            ADef.IsUnique := AFdIsUnique.AsBoolean;
            ADef.IsAutoInc := StrIStrW(PWideChar(QStringW(AFdDefVal.AsString)),
              'nextval') <> nil;
            ADef.Nullable := AFdNullable.AsBoolean;
            ADef.HasDefault := not AFdDefVal.IsNull;
            ADef.InWhere := True;
            Break;
          end;
        end;
      end;
      ADataSet.Next;
    end;
  end;

  procedure FetchMetas;
  var
    I: Integer;
    ADataSet: TQDataSet;
    AIdList: String;
  begin
    AIdList := '';
    for I := 0 to High(FDelayBindTables) do
      AIdList := IntToStr(FDelayBindTables[I]) + ',';
    SetLength(AIdList, Length(AIdList) - 1);
    FFetchMeta := True;
    ADataSet := AcquireDataSet;
    ADataSet.DisableControls;
    try
      FetchColumnMeta(ADataSet, AIdList);
    finally
      ADataSet.EnableControls;
      ReleaseDataSet(ADataSet);
      SetLength(FDelayBindTables, 0);
    end;
  end;

begin
  FResultSetCount := 0;
  FFetchMeta := False;
  case ARequest.Command.Action of
    caPrepare:
      DoPrepare;
    caFetchStream, caFetchRecords, caExecute:
      begin
        if ARequest.Command.Prepared then
          BindAndExecute
        else
          SimpleQuery(ARequest.Command.SQL);
      end;
    caUnprepare:
      DoUnprepare;
  end;
  Result := FActiveRequest.Result.ErrorCode = 0;
  if Result then
  begin
    if Length(FDelayBindTables) <> 0 then
      FetchMetas;
  end
  else if not(Connected or Connecting) then
  begin
    InternalOpen; // �������´�
    if Connected then // ����������ӳɹ�����������ִ������
      Result := InternalExecute(ARequest);
  end;
end;

procedure TQPgSQLProvider.InternalOpen;
begin
  inherited;
end;

procedure TQPgSQLProvider.Login;

  procedure SendClearTextPassword;
  var
    APassword, AUser: QStringA;
  begin
    APassword := qstring.Utf8Encode(DequotedStrW(Password, '"'));
    AUser := qstring.Utf8Encode(DequotedStrW(UserName, '"'));
    SendCmd(cmPassword);
    SendInt(5 + APassword.Length);
    SendString(APassword, True);
    SendAndWait(pwaAuth);
  end;
  procedure SendMD5Password;
  var
    ADigest: TQMD5Digest;
    APassword, AUser: QStringA;
  begin
    SetError(0, '');
    // ��һ����������+�û�����Ϊ��һ��MD5��ϣ������
    APassword := qstring.Utf8Encode(Password);
    AUser := qstring.Utf8Encode(UserName);
    SendBuffer.Cat(APassword, False).Cat(AUser);
    ADigest := MD5Hash(SendBuffer.Start, SendBuffer.Position);
    SendBuffer.Reset;
    // �ڶ���������һ���Ĺ�ϣ�����Saltֵ��ϲ������еڶ��ι�ϣ
    SendBuffer.Cat(qstring.Utf8Encode(qstring.BinToHex(@ADigest,
      sizeof(TQMD5Digest), True))).Cat(FAuthSalt);
    ADigest := MD5Hash(SendBuffer.Start, 36);
    SendBuffer.Reset;
    // p:1+Length:4+md5:3+hash:32+zero:1
    SendBuffer.Cat(Byte(cmPassword)).Cat(ExchangeByteOrder(Integer(40)))
      .Cat(QStringA('md5'), False)
      .Cat(qstring.Utf8Encode(qstring.BinToHex(@ADigest, sizeof(TQMD5Digest),
      True))).Cat(Byte(0));
    SendAndWait(pwaAuth);
  end;

begin
  case FAuthType of
    paNone:
      begin
        // Login OK
        SetError(0, '');
        Exit;
      end;
    paKerberosV4, paKerberosV5, paCryptPassword { �ݲ�֧�ֲ��� } , paScmCreds, paGSS,
      paGSSContinue, paSSPI:
      SetError($80000001, SUnsupportAuthProtocol);
    paClearTextPassword:
      SendClearTextPassword;
    paMD5Password:
      SendMD5Password;
  end;
  if LastError <> 0 then
  begin
    InternalClose;
    DatabaseError(LastErrorMsg);
  end;
end;

procedure TQPgSQLProvider.SendAndWait(Action: TQPgSQLWaitAction);
var
  ATimeout: Cardinal;
  AIdleStatus: set of TPGQueryStatus;
begin
  AIdleStatus := [qsIdle, qsError, qsInTransaction];
  ATimeout := CommandTimeout * 1000;
  if Action in [pwaHandshake, pwaAuth] then
    ATimeout := ConnectTimeout * 1000;
  if Action = pwaHandshake then
    AIdleStatus := AIdleStatus + [qsAuth];
  FQueryStatus := qsBusy;
  if SendData then
  begin
    while not(FQueryStatus in AIdleStatus) do
    begin
      if FNotifyEvent.WaitFor(ATimeout) = wrTimeout then
      begin
        case Action of
          pwaHandshake:
            SetError(ERROR_TIMEOUT, Format(SHandshakeTimeout,
              [ServerHost, Integer(ServerPort)]));
          pwaAuth:
            SetError(ERROR_TIMEOUT, SAuthTimeout);
          pwaExecute:
            SetError(ERROR_TIMEOUT, SExecuteTimeout);
        end;
        Break;
      end;
    end
  end
  else
    FQueryStatus := qsError;
end;

procedure TQPgSQLProvider.SendBool(AValue: Boolean);
begin
  SendBuffer.Cat(AValue);
end;

procedure TQPgSQLProvider.SendByte(AValue: Byte);
begin
  SendBuffer.Cat(AValue);
end;

procedure TQPgSQLProvider.SendBytes(ABytes: PByte; ALen: Integer);
begin
  SendBuffer.Cat(ABytes, ALen);
end;

procedure TQPgSQLProvider.SendCmd(AValue: TPQClientMsg);
begin
  SendBuffer.Cat(Byte(AValue));
end;

procedure TQPgSQLProvider.SendFloat(AValue: Double);
var
  T: Int64 absolute AValue;
begin
  SendBuffer.Cat(ExchangeByteOrder(T));
end;

procedure TQPgSQLProvider.SendInt(AValue: Integer);
begin
  SendBuffer.Cat(ExchangeByteOrder(AValue));
end;

procedure TQPgSQLProvider.SendInt64(AValue: Int64);
begin
  SendBuffer.Cat(ExchangeByteOrder(AValue));
end;

procedure TQPgSQLProvider.SendString(const S: QStringA; ACStyle: Boolean);
begin
  SendBuffer.Cat(S, ACStyle);
end;

procedure TQPgSQLProvider.SendStringWithLength(const S: QStringW);
var
  T: QStringA;
begin
  T := qstring.Utf8Encode(S);
  SendInt(T.Length);
  SendString(T, False);
end;

procedure TQPgSQLProvider.SendWord(AValue: Word);
begin
  SendBuffer.Cat(ExchangeByteOrder(AValue));
end;

function TQPgSQLProvider.StatementName(const AId: QStringW): QStringA;
begin
  Result := qstring.Utf8Encode('ST_' + AId);
end;

function TQPgSQLProvider.ValueType2Pg(AType: TQValueDataType): Integer;
begin
  case AType of
    vdtUnset, vdtNull:
      Result := 0;
    vdtBoolean:
      Result := 16;
    vdtFloat:
      Result := 701;
    vdtInteger:
      Result := 23;
    vdtInt64:
      Result := 20;
    vdtCurrency:
      Result := 790;
    vdtBcd:
      Result := 1700;
    vdtGuid:
      Result := 2950;
    vdtDateTime:
      Result := 1114;
    vdtInterval:
      Result := 704;
    vdtString:
      Result := 18;
    vdtStream:
      Result := 17;
  else
    Result := 25; // AsText
  end;
end;

end.

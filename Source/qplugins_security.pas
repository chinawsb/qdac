/// <summary>
/// <para>
/// IQSecurityService ������ʵ���û��˺ż�Ȩ�޹���ķ��� ���������ڴ�ģ��ķ������ͨ���˷���
/// ��ȡ��ǰ�û�����Ϣ���Լ���ǰ�û��Ƿ���Ȩ����ָ��Ȩ�޶�����Ϣ��
/// </para>
/// <para>
/// IQSecurityService ��ע�����·��Ϊ
/// /Services/Security������ͨ����·�������ID��ȡ���÷���Ĺ���ʵ����
/// </para>
/// <para>
/// IQSecurityService ���ṩ�˺ŵ���ӡ�ɾ���˺ż���ɫ�ȷ���Ҫִ�и����͵Ĳ��������� IQSecurityService
/// �� Config �������˺ż�Ȩ�޹�����棬���û��ֶ�������
/// </para>
/// <para>
/// ����Ԫ��������Ȩ����ӿڡ��û��˺š� �û���ɫ�����ǵĸ��ӿڵĶ��壬��������ʵ��ʵ�֡�
/// </para>
/// </summary>
unit qplugins_security;

interface

uses classes, sysutils, types, qplugins_base;

const
  // ��ɫ��Ȩ�޹������ID
  SID_SECURITY_GROUP: TGuid = '{110CA18E-4B52-4D75-B3F3-9C99DC2B76FE}';
  // �鿴�����û��˺ż�Ȩ��
  SID_SECURITY_VIEW: TGuid = '{B02A4134-3563-42A0-825E-C90BB5DD031E}'; //
  // �޸������û��˺ż�Ȩ�޵�����
  SID_SECURITY_EDIT: TGuid = '{800896A0-E733-48BB-8CB4-857EC83F6F89}';
  // ֪ͨ���Ự����
  SNotify_SessionDead = 'Security.Session.Dead';
  // ֪ͨ���Ự����
  SNotify_SessionReady = 'Security.Session.Ready';
  // ֪ͨ����ǰ�˺�Ȩ�޷����䶯
  SNotify_RightsChanged = 'Security.Session.RightsChanged';
  // ֪ͨ����ǰ��¼������ȡ��
  SNotify_LoginCanceled = 'Security.Login.Cancel';

type
  IQSecurityUserBase = interface;
  IQSecurityGroup = interface;

  IQObjectInterface = interface
    ['{C1E8B65C-9BAD-4F33-B97A-88BDCB768EF7}']
    /// <summary>
    /// ��ȡ��ǰʵ��ԭʼ�����ַ
    /// </summary>
    function GetObjectPointer: Pointer; stdcall;
  end;

  /// <summary>
  /// ��ȫ�������Ļ����ӿڣ����еİ�ȫ���󶼼̳��Դ˽ӿ�
  /// </summary>
  /// <remarks>
  /// ��ȫ�ӿ������ṩ���������ģ�飬�Ա�����ģ���ܹ�����û�Ȩ�޲������¼�����ˡ�
  /// </remarks>
  IQSecurityBase = interface(IQObjectInterface)
    ['{BA55D0A8-CC00-40A5-8FD6-0743DD1145A7}']
    /// <summary>
    /// ��ȡ��ȫ���������
    /// </summary>
    function GetName: PWideChar; stdcall;
    /// <summary>
    /// ��ȡ��ȫ����ı��룬��ȫ�������̶�ΪGUID���ͣ��Ա㷽����������Լ������Լ���ID�����������������ܶ����ظ�
    /// </summary>
    /// <param name="AId">
    /// ���ڴ�����ȫ����ı���
    /// </param>
    procedure GetId(AId: PGuid); stdcall;
    /// <summary>
    /// ��ȡ��ȫ����ĸ�����
    /// </summary>
    function GetParent: Pointer; stdcall;
    /// <summary>
    /// ��ȡ��ǰ��ȫ�����ע��
    /// </summary>
    function GetComment: PWideChar; stdcall;
    /// <summary>
    /// ��ȡ��ǰ��ȫ����չ��Ϣ����Щ��Ϣ������������ݿ��У�ֻ������ʱ��ʱ���ú�ɾ����ʵ������ΪIQParams
    /// </summary>
    function GetExts: Pointer; stdcall;
    /// <summary>
    /// ��ȡ��ǰ�Ƿ���ĳ�������ӽ��
    /// </summary>
    function IsChildOf(AParent: IQSecurityGroup): Boolean; stdcall;
    /// <summary>
    /// ��ȡ��ǰ�Ƿ���ĳ���ӵĸ����
    /// </summary>
    function IsParentOf(AChild: IQSecurityBase): Boolean; stdcall;
    /// <summary>
    /// ����
    /// </summary>
    property Name: PWideChar read GetName;
    /// <summary>
    /// ע��
    /// </summary>
    property Comment: PWideChar read GetComment;
    /// <summary>
    /// ����ȫ����(IQSecurityGroup)
    /// </summary>
    property Parent: Pointer read GetParent; // IQSecurityGroup
    /// <summary>
    /// ��չ
    /// </summary>
    property Exts: Pointer read GetExts;
  end;

  /// <summary>
  /// ��ɫ��Ȩ�޶���ĸ��ӿڣ�
  /// </summary>
  IQSecurityGroup = interface(IQSecurityBase)
    ['{18712A8C-6152-45C9-B7AE-9265A62D8E36}']
    /// <summary>
    /// ��ȡָ����ID��Ӧ���Ӱ�ȫ��������
    /// </summary>
    /// <param name="AId">
    /// �Ӷ���ID
    /// </param>
    function IndexOf(const AId: PGuid): Integer; overload; stdcall;
    /// <summary>
    /// ��ȡָ�����Ƶ��Ӱ�ȫ��������
    /// </summary>
    /// <param name="AName">
    /// �Ӷ������ƣ�ע�����ִ�Сд
    /// </param>
    function IndexOf(const AName: PWideChar): Integer; overload; stdcall;
    /// <summary>
    /// ��ȡָ�����Ӱ�ȫ���������
    /// </summary>
    /// <param name="AItem">
    /// Ҫ��ȡ�������Ӱ�ȫ����
    /// </param>
    function IndexOf(const AItem: IQSecurityBase): Integer; overload; stdcall;
    /// <summary>
    /// �ж��Ƿ����Ӱ�ȫ����
    /// </summary>
    function HasChildren: Boolean; stdcall;
    /// <summary>
    /// ��ȡ�Ӱ�ȫ����ĸ���
    /// </summary>
    function GetCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ���������Ӱ�ȫ������������0��ʼ
    /// </summary>
    /// <param name="AIndex">
    /// �Ӷ�������
    /// </param>
    function GetItems(const AIndex: Integer): Pointer; stdcall;
    /// <summary>
    /// �Ӱ�ȫ�������
    /// </summary>
    property Count: Integer read GetCount;
    /// <summary>
    /// ����ָ���������Ӱ�ȫ����
    /// </summary>
    property Items[const AIndex: Integer]: Pointer read GetItems; default;
  end;

  /// <summary>
  /// ����Ȩ��ö������
  /// </summary>
  TQAccessRight = (
    /// <summary>
    /// �̳�ȫ�����ã�ȫ������ͨ��IQSecurityService �� GetDefaultRight ��ȡ��ֻ��
    /// </summary>
    arGlobal,
    /// <summary>
    /// �̳и�Ȩ��
    /// </summary>
    arInherited,
    /// <summary>
    /// �ܾ�����
    /// </summary>
    arDeny,
    /// <summary>
    /// �������
    /// </summary>
    arAllow);

  IQDependencyList = interface
    ['{2E5ACC3C-EA93-4E82-B703-AC141823698F}']
    function Add(const AId: TGuid): Integer; stdcall;
    procedure Delete(const AId: TGuid); overload; stdcall;
    procedure Delete(const AIndex: Integer); overload; stdcall;
    procedure Clear; stdcall;
    function GetCount: Integer; stdcall;
    function GetItems(const AIndex: Integer): Pointer; overload; stdcall;
    function GetItems(const AIndex: Integer; var AId: TGuid): Boolean;
      overload; stdcall;
    function Contains(const AId:TGuid):Boolean;stdcall;
    property Count: Integer read GetCount;
  end;
  /// <summary>
  /// Ȩ�޶���ӿڶ���
  /// </summary>
  IQSecurityRight = interface(IQSecurityBase)
    ['{0DF2B05C-F070-4DD1-98E5-44C4625ED8BA}']
    /// <summary>
    /// ��Ȩ�޶���Ĭ�ϵķ���Ȩ�ޣ���ʼֵһ���Ǽ̳У�arInherited����ע��Ȩ�޶���ʱ����Ĭ�������Ȩ�ޡ�
    /// </summary>
    function GetDefaultRight: TQAccessRight; stdcall;
    /// <summary>
    /// �ж�ָ�����û����ɫ�Ƿ��ܹ����ʵ�ǰ����
    /// </summary>
    /// <param name="AUser">
    /// Ҫ�ж����û����ɫ
    /// </param>
    /// <returns>
    /// ������ʣ����� true����������ʣ����� false
    /// </returns>
    function CanAccess(AUser: IQSecurityUserBase): Boolean; stdcall;
  end;

  /// <summary>
  /// Ȩ�޷���ӿڶ���
  /// </summary>
  IQSecurityRights = interface(IQSecurityRight)
    ['{67839552-6648-4271-987A-187511777E7C}']
    /// <summary>���һ���µ�Ȩ�޷���</summary>
    /// <param name="AId">����ID��ȫ��Ψһ</param>
    /// <param name="AName">�������ƣ���������Ȩ������</param>
    /// <param name="ADefaultRight">���û�ж���Ȩ�޻���Ȩ�޳�ͻʱ�����ȫ��Ĭ��Ȩ��ΪarInheritedʱ�ķ���ֵ</param>
    /// <returns>���� IQSecurityRights ���͵�Ȩ�޷���ӿ�</returns>
    /// <remarks>���ָ����ID�Ѵ��ڣ����ֱ�ӷ���ԭ���ķ���ӿڣ�������AName��ADefaultRight����</remarks>
    function AddGroup(const AId: TGuid; const AName: PWideChar;
      ADefaultRight: TQAccessRight): Pointer; // IQSecurityRights;
    /// <summary>�ڵ�ǰ���������һ���µ�Ȩ�޶���</summary>
    /// <param name="AId">Ȩ��ID��ȫ��Ψһ</param>
    /// <param name="AName">Ȩ�����ƣ���������Ȩ������</param>
    /// <param name="ADefaultRight">���û�ж���Ȩ�޻���Ȩ�޳�ͻʱ�����ȫ��Ĭ��Ȩ��ΪarInheritedʱ�ķ���ֵ</param>
    /// <returns>���� IQSecurityRight ���͵�Ȩ�޷���ӿ�</returns>
    /// <remarks>���ָ����ID�Ѵ��ڣ����ֱ�ӷ���ԭ���ķ���ӿڣ�������AName��ADefaultRight����</remarks>
    function AddRight(const AId: TGuid; const AName: PWideChar;
      ADefaultRight: TQAccessRight): Pointer; // IQSecurityRight;
  end;

  /// <summary>
  /// ����������Ŀ�ӿڶ���
  /// </summary>
  /// <remarks>
  /// �����������ڿ����û��Ƿ��ܹ���¼������ʱ�����ƿ��������û��Ƿ�������ָ����ʱ����¼��IP��ַ���ƿ��������û��Ƿ��ָ����IP��ַ�ε�¼
  /// </remarks>
  IQSecurityLimit = interface(IQSecurityBase)
    ['{32DF2C09-06D9-47E1-BAC3-585C23503F7F}']
    /// <summary>
    /// �ж��Ƿ������¼�������ǰ���ƽ�ֹ���û���¼���򷵻�false�����򷵻�true
    /// </summary>
    /// <param name="AUser">
    /// Ҫ�ж����û��˺Ż��ɫ
    /// </param>
    /// <param name="AParams">
    /// �û���¼����
    /// </param>
    function CanLogin(AUser: IQSecurityUserBase; AParams: IQParams): Boolean;
  end;

  /// <summary>
  /// �û��ͽ�ɫ�Ļ���ӿڣ��ṩ�û��ͽ�ɫ�Ĺ����ӿڶ���
  /// </summary>
  IQSecurityUserBase = interface
    ['{476748D4-675C-45BA-B636-3592BAE77F3D}']
    /// <summary>
    /// �ж��Ƿ��ܹ�����ָ���İ�ȫ����
    /// </summary>
    /// <param name="ARight">
    /// Ҫ�ж��İ�ȫ����
    /// </param>
    /// <remarks>
    /// <para>
    /// �ж�����˳��
    /// </para>
    /// <para>
    /// 1����ǰ�û����ɫ��ָ���İ�ȫ������ȷ�����ܾ��ģ����ظ�Ȩ�ޣ�
    /// </para>
    /// <para>
    /// 2����ǰ�û����ɫ��ָ���İ�ȫ����ĸ���������ȷ�������ܾ��ģ����ظ�Ȩ�ޣ�
    /// </para>
    /// <para>
    /// 3���Ը���ɫ�ظ�1��2���������û�������ͬ����������ɫû���໥��ͻ�ģ����ظ�Ȩ�ޣ�
    /// </para>
    /// <para>
    /// 4������ɫȨ�޳�ͻʱ������Ȩ�޶����Ĭ��Ȩ�ޣ������ arInherited �� arGlobal���򷵻�
    /// IQSecurityService �� GetDefaultRight ���صĽ�������Ϊ arDeny ��
    /// arAllow����ֱ�ӷ��ظ�Ȩ�ޡ�
    /// </para>
    /// </remarks>
    /// <seealso cref="IQSecurityRight">
    /// ��ȫ����ӿڶ���
    /// </seealso>
    function CanAccess(ARight: IQSecurityRight): Boolean; overload; stdcall;
    /// <summary>
    /// �ж��Ƿ��������ָ��ID��Ӧ�İ�ȫ����
    /// </summary>
    /// <param name="ARightId">
    /// ��ȫ����ID
    /// </param>
    /// <returns>
    /// ������true���ܾ�����false
    /// </returns>
    /// <seealso cref="IQSecurityRight">
    /// ��ȫ����ӿڶ���
    /// </seealso>
    function CanAccess(const ARightId: PGuid): Boolean; overload; stdcall;
    /// <summary>
    /// ��ȡָ�����˺Ż��ɫ�Ƿ�����
    /// </summary>
    function GetEnabled: Boolean; stdcall;
    /// <summary>
    /// ��ȡ�����ܾ���Ȩ�޶�������
    /// </summary>
    function GetDenyCount: Integer; stdcall;
    /// <summary>
    /// ��ȡ�����ܾ���Ȩ�޶����б�
    /// </summary>
    /// <param name="AIndex">
    /// Ҫ��ȡ��Ȩ�޶�������
    /// </param>
    /// <returns>
    /// ʵ������ΪIQSecurityRight
    /// </returns>
    function GetDenyItems(const AIndex: Integer): Pointer; stdcall;
    /// <summary>
    /// ��ȡ���������Ȩ�޶�������
    /// </summary>
    function GetAllowCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ�������ı����ܾ���Ȩ�޶���
    /// </summary>
    /// <param name="AIndex">
    /// Ҫ��ȡ��Ȩ�޶�������
    /// </param>
    /// <returns>
    /// ʵ������ΪIQSecurityRight
    /// </returns>
    function GetAllowItems(const AIndex: Integer): Pointer; stdcall;
    /// <summary>
    /// ��ȡ�󶨵������û����ɫ����������
    /// </summary>
    function GetLimitCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ�����������ƶ���
    /// </summary>
    /// <param name="AIndex">
    /// Ҫ���ʵĶ�������
    /// </param>
    /// <returns>
    /// ʵ������ΪIQSecurityLimit
    /// </returns>
    function GetLimits(const AIndex: Integer): Pointer; stdcall;
    /// <summary>
    /// �����ܾ�Ȩ�޶�������
    /// </summary>
    property DenyCount: Integer read GetDenyCount;
    /// <summary>
    /// �����ܾ�Ȩ�޶����б�
    /// </summary>
    property DenyItems[const AIndex: Integer]: Pointer read GetDenyItems;
    /// <summary>
    /// ��������Ȩ�޶�������
    /// </summary>
    property AllowCount: Integer read GetAllowCount;
    /// <summary>
    /// ���������Ȩ�޶����б�
    /// </summary>
    property AllowItems[const AIndex: Integer]: Pointer read GetAllowItems;
    /// <summary>
    /// �����󶨵���������
    /// </summary>
    property LimitCount: Integer read GetLimitCount;
    /// <summary>
    /// ������д�������б�
    /// </summary>
    property Limits[const AIndex: Integer]: Pointer read GetLimits;
  end;

  /// <summary>
  /// �û��˺Žӿڶ���
  /// </summary>
  IQSecurityUser = interface(IQSecurityBase)
    ['{8B4EBC08-9C48-47E5-BA66-70D4F1A77345}']
    /// <summary>
    /// ���ָ���������Ƿ���ȷ
    /// </summary>
    /// <param name="APassword">
    /// Ҫ��֤������
    /// </param>
    function CheckPassword(const APassword: PWideChar): Boolean; stdcall;
    /// <summary>��ȡ����ɫ����</summary>
    function GetParentCount: Integer; stdcall;
    /// <summary>��ø���ɫ�б�</summary>
    /// <param name="AIndex">Ҫ��ȡ�ĸ���ɫ����</param>
    function GetParents(const AIndex: Integer): Pointer; stdcall;
  end;

  /// <summary>
  /// ��ɫ�ӿڶ���
  /// </summary>
  IQSecurityRole = interface(IQSecurityGroup)
    ['{893FD6E7-452B-4B3F-99C6-F6820EB32D55}']
    /// <summary>��ȡ��ǰ��ɫ��ֱ�����û�����</summary>
    function GetUserCount: Integer; stdcall;
    /// <summary>��ȡ��ǰ��ɫ��ֱ���ӽ�ɫ����</summary>
    function GetRoleCount: Integer; stdcall;
    /// <summary>��ȡָ��������ֱ���û�</summary>
    /// <param name="AIndex">Ҫ��ȡ���û�����</param>
    /// <returns>���� IQSecurityUser �ӿڵ�ʵ����ַ</returns>
    function GetUsers(const AIndex: Integer): Pointer; stdcall;
    /// <summary>��ȡָ��������ֱ����ɫ</summary>
    /// <param name="AIndex">Ҫ��ȡ�Ľ�ɫ����</param>
    /// <returns>���� IQSecurityRole �ӿڵ�ʵ����ַ</returns>
    function GetRoles(const AIndex: Integer): Pointer; stdcall;
  end;

  /// <summary>
  /// ��ȫ�������ӿڶ���
  /// </summary>
  IQSecurityService = interface
    ['{C0F91FA3-EB95-4B7A-9E78-4F8F233BAD96}']
    /// <summary>
    /// ��ȡ����ɫ���������н�ɫ�ĸ����
    /// </summary>
    function GetRootRole: Pointer; stdcall; // IQSecurityRole
    /// <summary>
    /// ��ȡ��Ȩ�޶�����������Ȩ�޶���ĸ����
    /// </summary>
    function GetRootRight: Pointer; stdcall; // IQSecurityRight
    /// <summary>
    /// Ҫ���û������ѵ�¼�� ���δ��¼���򵯳���¼�Ի������û����е�¼��
    /// </summary>
    /// <returns>����Ѿ���¼��ɹ����߳ɹ������¼���棬�򷵻�true�����򷵻�false</returns>
    /// <remarks>ע�ⷵ��ֵ���������¼�ɹ���Ҫ�жϵ�¼�Ƿ�ɹ���ʹ��IsLogined����</remarks>
    function LoginNeeded: Boolean; stdcall;
    /// <summary>
    /// �˳���ǰ�˺Ų����µ�¼
    /// </summary>
    /// <param name="AMustLogin">�Ƿ������ɵ�¼�����Ϊtrue�����¼ʧ��ȡ����¼ʱ�����˳����򣬷�����ԭ��¼</param>
    /// <returns>�ɹ�������true��ʧ�ܣ�����false</returns>
    function Relogin(const AMustLogin: Boolean): Boolean; stdcall;
    /// <summary>�жϵ�ǰ�Ƿ��Ѿ���¼</summary>
    /// <returns>��ǰ�Ѿ���¼������True��δ��¼����false</returns>
    function IsLoggedIn: Boolean; stdcall;
    /// <summary>��ȡ��ǰ��¼�ĻỰ����</summary>
    /// <returns>���ص�ǰ�Ѿ���¼�ĻỰ���룬δ��¼���ؿ�</returns>
    function GetSessionId: PWideChar; stdcall;
    /// <summary>
    /// �����˺Ž�ɫ��Ȩ�޹���Ի����������û������Ȩ��
    /// </summary>
    function Config: Boolean; stdcall;
    /// <summary>
    /// �����޸ĵ�ǰ�˺�����
    /// </summary>
    /// <returns>
    /// �޸���ɷ��� true���û�ȡ������ false
    /// </returns>
    function ChangePassword: Boolean; stdcall;
    /// <summary>�жϵ�ǰ�˺��Ƿ���Ȩ�޷���ָ���Ķ���</summary>
    /// <param name="ARightId">Ȩ�޶���ID</param>
    /// <returns>��������true����ֹ������false</returns>
    function CanAccess(const AId: PGuid): Boolean;
    /// <summary>
    /// ѡ��һ���û��˺�
    /// </summary>
    /// <param name="AParent">
    /// ��ѡ�˺������ĸ���ɫ
    /// </param>
    /// <param name="AcceptRole">
    /// �Ƿ���Է��ؽ�ɫ����������ԣ���ֻ��ѡ�������û�������ѡ���ɫ
    /// </param>
    /// <returns>����ѡ����û����ɫ����������ΪIQSecurityBase</returns>
    function SelectUser(AParent: IQSecurityRole; AcceptRole: Boolean)
      : Pointer; stdcall;
    /// <summary>
    /// ѡ��һ����ɫ
    /// </summary>
    /// <param name="AParent">
    /// ��ѡ��ɫ�ĸ���ɫ
    /// </param>
    /// <returns>
    /// ����ѡ��Ľ�ɫ(IQSecurityRole)
    /// </returns>
    function SelectRole(AParent: IQSecurityRole): Pointer; stdcall;
    /// <summary>
    /// ��ȡȫ��Ĭ�Ϸ���Ȩ�ޣ�ֻ����arAllow��arDeny
    /// </summary>
    function GetDefaultRight: TQAccessRight; stdcall;
  end;

implementation

end.

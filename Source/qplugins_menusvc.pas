unit qplugins_menusvc;

interface

uses classes, sysutils, qplugins_base;

const
  MC_CAPTION = $01;
  MC_ICON = $02;
  MC_VISIBLE = $04;
  MC_ENABLED = $08;
  MC_EXTS = $10;
  MC_ALIGN = $20;
  MC_CHILDREN = $40;

type

  IQMenuCategory = interface;

  // ͼƬ֧��
  /// <summary>
  /// ͼƬ֧�ֽӿڣ����ڿ�����֧��ͼƬ��ʾ
  /// </summary>
  /// <remarks>
  /// IQImage ֧�ֵĳ�����λͼ�ļ���ʽ����PNG/JPG��������֧�ֱ༭������ԭ���ݸ�ʽ��ɶ��ʽ������ʱ���ᰴPNG��ʽ���档 Ҫ����һ��
  /// IQImage �ӿڵ�ʵ����ʹ��·�� /Services/Images �µķ��񣬵��� NewImage �ӿڴ����µĶ���
  /// ע�⣺����Ԫֻ�����ӿ�������������ʵ��ʵ��
  /// </remarks>
  IQImage = interface
    ['{013129AD-B177-4D9F-818A-45E09ADDC2ED}']
    /// <summary>
    /// �����м���ͼƬ
    /// </summary>
    /// <param name="AStream">
    /// ����ͼƬ������������
    /// </param>
    procedure LoadFromStream(AStream: IQStream); stdcall;

    /// <summary>
    /// �� PNG ��ʽ����ͼƬ������
    /// </summary>
    /// <param name="AStream">
    /// Ŀ��������
    /// </param>
    procedure SaveToStream(AStream: IQStream); stdcall;
    /// <summary>
    /// ���ļ��м���ͼƬ
    /// </summary>
    /// <param name="AFileName">
    /// ͼƬ�ļ���
    /// </param>
    /// <remarks>
    /// ���ļ��м���ͼƬʱ����ͨ����չ����ȷ���ļ���ʽ�ģ������뱣֤��չ����ʵ�ʸ�ʽһ�¡�
    /// </remarks>
    procedure LoadFromFile(const AFileName: PWideChar); stdcall;
    /// <summary>
    /// ����ͼƬ���ݵ�PNG�ļ���
    /// </summary>
    /// <param name="AFileName">
    /// Ŀ���ļ���
    /// </param>
    /// <remarks>
    /// ��ȷ��Ŀ��Ŀ¼��д��Ȩ�ޣ�������޷�����
    /// </remarks>
    procedure SaveToFile(const AFileName: PWideChar); stdcall;
    /// <summary>
    /// �� Base64 �����ַ���
    /// </summary>
    /// <param name="ABase64Data">
    /// �� Base 64 �����ͼƬ����
    /// </param>
    procedure LoadFromBase64(const ABase64Data: IQString); stdcall;
    /// <summary>
    /// ����Ϊ PNG ��ʽ�� Base64 �ַ���
    /// </summary>
    /// <returns>
    /// ����ֵʵ������ΪIQString��Ϊ���ݷ� Delphi ���ԣ���Ϊ���� Pointer���û���Ҫ���м�С���ü���
    /// </returns>
    function SaveToBase64: Pointer; stdcall;
    /// <summary>
    /// ��ȡ�ڲ�ͼ���ʵ�ʿ��
    /// </summary>
    function GetWidth: Integer; stdcall;
    /// <summary>
    /// ��ȡ�ڲ�ͼ���ʵ�ʸ߶�
    /// </summary>
    function GetHeight: Integer; stdcall;
    /// <summary>
    /// �� IQBytes �ӿڻ�ȡPNG��ʽ������
    /// </summary>
    /// <param name="AData">
    /// ���ڴ���������ݵĻ���������
    /// </param>
    function GetData(AData: IQBytes): Integer; stdcall;
    /// <summary>
    /// ��ȡͼ�����ĩ�α����Id��ÿ����һ��ͼƬ����ID���һ�Σ��Ա��ϲ���ͼƬ�����Ƿ����䶯
    /// </summary>
    function GetLastChangeId: Integer; stdcall;
    /// <summary>
    /// ����һ��ͼƬ�и���һ�ݿ���
    /// </summary>
    procedure Assign(ASource: IQImage); stdcall;
    /// <summary>
    /// ͼƬĩ�α��ID
    /// </summary>
    property LastChangeId: Integer read GetLastChangeId;
  end;

  /// <summary>
  /// �˵���IQMenuItem�� �ͷ��� ��IQMenuCategory ���Ļ��࣬���ڹ���˵�������Ŀ�Ĺ��г�Ա
  /// </summary>
  IQMenuBase = interface
    /// <summary>
    /// �˵��ڲ�Id��ÿ���˵���Ŀӵ��Ψһ�ı���
    /// </summary>
    function GetId: Integer; stdcall;
    /// <summary>
    /// ��ȡ�˵����ڲ����ƣ�
    /// </summary>
    function GetName: PWideChar; stdcall;
    /// <summary>
    /// ���ò˵�����
    /// </summary>
    /// <param name="AName">
    /// �˵�������
    /// </param>
    /// <remarks>
    /// ������ʵ������һ���ڲ���־��������Ӧ�����ظ�
    /// </remarks>
    procedure SetName(AName: PWideChar); stdcall;

    /// <summary>
    /// ��ȡ�˵���ʾ����
    /// </summary>
    /// <remarks>
    /// ���Ҫ֧�ֶ����ԣ�����Ҫ��Ӧ Language.Changed ֪ͨ���� SetCaption �������ñ���
    /// </remarks>
    function GetCaption: PWideChar; stdcall;
    /// <summary>
    /// ���ò˵�����
    /// </summary>
    /// <param name="S">
    /// ��������
    /// </param>
    procedure SetCaption(const S: PWideChar); stdcall;

    /// <summary>
    /// ��ȡ�˵�������״̬
    /// </summary>
    function GetEnabled: Boolean; stdcall;
    /// <summary>
    /// ���ò˵���Ŀ������״̬
    /// </summary>
    /// <param name="val">
    /// true -&gt; ���� false-&gt;����
    /// </param>
    procedure SetEnabled(const val: Boolean); stdcall;

    /// <summary>
    /// ��ȡ�˵���Ŀ�Ƿ�ɼ�
    /// </summary>
    function GetVisible: Boolean; stdcall;
    /// <summary>
    /// ���ò˵���Ŀ�Ƿ�ɼ�
    /// </summary>
    /// <param name="val">
    /// true-&gt;�ɼ���false-&gt;���ɼ�
    /// </param>
    procedure SetVisible(const val: Boolean); stdcall;

    /// <summary>
    /// �ж��Ƿ������չ�����б�
    /// </summary>
    function HasExtParams: Boolean; stdcall;

    /// <summary>
    /// ��ȡ��չ�����б�
    /// </summary>
    /// <remarks>
    /// ��չ�����б��ṩ�˲��޸�ϵͳ���������£���Ӷ������ݳ�Ա�İ취������ģ��������ڲ�����Լ��Ĳ�����־���Խ���������
    /// </remarks>
    function GetExtParams: Pointer; stdcall;

    /// <summary>
    /// �˵���ǰ״̬�������ʱ���ᴥ���ýӿڡ�
    /// </summary>
    /// <remarks>
    /// Invalidate �������� MenuService.Validate ֪ͨ��������Զ��ĸ�֪ͨ�Ա���д�����֪ͨ�� @Sender
    /// ����Ϊ�˵�ʵ���� IQMenuBase �ӿڵ�ַ������Ϊ 64 λ������
    /// </remarks>
    procedure Invalidate; stdcall;
    /// <summary>
    /// ��ȡ�˵�ĩ�����ݵ�ID���Ա�����жϲ˵������Ƿ����˱䶯
    /// </summary>
    function GetLastChangeId: Integer; stdcall;
    /// <summary>
    /// ��ȡ�Լ��ڸ��е�����
    /// </summary>
    /// <remarks>
    /// ������ΪIQMenuCategory����
    /// </remarks>
    function GetItemIndex: Integer; stdcall;
    /// <summary>
    /// ��ȡ���������ӿ�ʵ��������Ǹ����࣬��Ϊ��
    /// </summary>
    /// <returns>
    /// ʵ������ΪIQMenuCategory��ע��ʹ�����Ҫ��С�ӿڵ����ü���
    /// </returns>
    /// <seealso cref="IQMenuCategory">
    /// ���ӿ�����
    /// </seealso>
    function GetParent: Pointer; stdcall; // IQMenuCategory

    /// <summary>
    /// ��ȡ��Ŀ������ͼƬ�ӿ�ʵ��
    /// </summary>
    /// <returns>
    /// ���� IQImage �ӿ�ʵ����ע��ʹ����ɽӿ�Ҫ�������ü���
    /// </returns>
    /// <seealso cref="IQImage">
    /// ͼ��ӿ�
    /// </seealso>
    function GetImage: Pointer; stdcall; // IQImage
    /// <summary>
    /// ���ù���ͼƬʵ��
    /// </summary>
    /// <param name="AImage">
    /// �µ�ͼƬʵ��
    /// </param>
    /// <remarks>
    /// ����ڹ�����ֱ���޸�ʵ����ͼƬ���ݣ������ᴥ��ˢ�£���Ҫ�ֶ����ò˵����Invalidate��֪ͨ�˵����������Ӧ��ͼ�ꡣ������ܻ�ʹ�þ�ͼ����ʾ��
    /// </remarks>
    /// <seealso cref="IQImage">
    /// ͼ��ӿ�
    /// </seealso>
    procedure SetImage(AImage: IQImage); stdcall;

    function GetTag: Pointer; stdcall;
    procedure SetTag(const V: Pointer); stdcall;
    function GetChanges: Integer; stdcall;
    procedure BeginUpdate; stdcall;
    procedure EndUpdate; stdcall;
    /// <summary>
    /// ��Ŀ����
    /// </summary>
    property Caption: PWideChar read GetCaption write SetCaption;
    /// <summary>
    /// �Ƿ�����
    /// </summary>
    property Enabled: Boolean read GetEnabled write SetEnabled;
    /// <summary>
    /// �Ƿ���ʾ
    /// </summary>
    property Visible: Boolean read GetVisible write SetVisible;
    /// <summary>
    /// ������ӿ�
    /// </summary>
    property Parent: Pointer read GetParent;
    /// <summary>
    /// ��Ŀ����
    /// </summary>
    property Name: PWideChar read GetName write SetName;
    /// <summary>
    /// ��չ����
    /// </summary>
    property ExtParams: Pointer read GetExtParams;
    /// <summary>
    /// ��Ŀ����
    /// </summary>
    property ItemIndex: Integer read GetItemIndex;
    /// <summary>
    /// ĩ�α��ID
    /// </summary>
    property LastChangeId: Integer read GetLastChangeId;
    property Tag: Pointer read GetTag write SetTag;
    property Changes: Integer read GetChanges;
  end;

  /// <summary>
  /// �˵�����
  /// </summary>
  TQMenuCheckType = (
    /// <summary>
    /// ��ͨ�˵�
    /// </summary>
    None,
    /// <summary>
    /// ��ѡ�˵���ͬһ�����µĵ�ѡ�˵��У�ֻ����һ����ѡ��
    /// </summary>
    Radio,
    /// <summary>
    /// ��ѡ�˵�
    /// </summary>
    CheckBox);
  TImageAlignLayout = (alNone, alTop, alLeft, alRight, alBottom, alMostTop,
    alMostBottom, alMostLeft, alMostRight, alClient, alContents, alCenter,
    alVertCenter, alHorzCenter, alHorizontal, alVertical, alScale, alFit,
    alFitLeft, alFitRight);

  /// <summary>
  /// �˵���Ŀ�ӿ�
  /// </summary>
  IQMenuItem = interface(IQMenuBase)
    ['{6C53B06C-EA0E-4020-A303-1DBE74755E42}']
    /// <summary>
    /// ͼƬ���뷽ʽ ��Ĭ�������
    /// </summary>
    /// <returns>
    /// TAlignLayout ��ֵ����Ϊ{None=0, Top, Left, Right, Bottom, MostTop,
    /// MostBottom, MostLeft, MostRight, Client, Contents, Center,
    /// VertCenter, HorzCenter, Horizontal, Vertical, Scale, Fit, FitLeft,
    /// FitRight}��Ĭ��ΪLeft
    /// </returns>
    function GetImageAlign: TImageAlignLayout; stdcall;

    /// <summary>
    /// ����ͼƬ�Ķ��뷽ʽ
    /// </summary>
    /// <param name="Align">
    /// �µĶ��뷽ʽ
    /// </param>
    /// <remarks>
    /// ����ǵ�ѡ��ѡ�˵���Ĭ�ϲ�����ѡ��ѡ��������࣬Ȼ����ͼƬ����������֡�����ͨ����������������ͼƬ��λ�á�
    /// </remarks>
    procedure SetImageAlign(const Align: TImageAlignLayout); stdcall;
    /// <summary>
    /// ��ȡ�˵���Ŀ��������Ӧ�㲥 IQNotifyBroadcast �ӿ�ʵ��
    /// </summary>
    /// <returns>
    /// ʵ��Ϊ IQNotifyBroadcast ���͵Ľӿڵ�ַ���û����Ե����� Add ���������Ӧ���� Remove �Ƴ���Ӧ
    /// </returns>
    /// <remarks>
    /// Click ��������ô˽ӿڣ�ͨ�� Send ������֪ͨ�����е���Ӧ��
    /// </remarks>
    /// <seealso cref="IQNotifyBroadcast">
    /// QPlugins ��֪ͨ�㲥�ӿ�
    /// </seealso>
    function GetOnClick: Pointer; stdcall; // IQNotifyBroadcastor
    /// <summary>
    /// ģ����ָ���Ĳ˵���Ŀ
    /// </summary>
    /// <param name="AParams">
    /// ���ݸ���Ӧ�ӿڵĲ���
    /// </param>
    procedure Click(AParams: IQParams); stdcall;
    /// <summary>
    /// ��ȡ��ǰ�˵���Ŀ�Ƿ��Ѿ�ѡ��
    /// </summary>
    function GetIsChecked: Boolean; stdcall;
    /// <summary>
    /// ���õ�ǰ�˵���Ŀ�Ƿ�ѡ��
    /// </summary>
    procedure SetIsChecked(const Value: Boolean); stdcall;
    /// <summary>
    /// ��ȡ�˵���Ŀ����
    /// </summary>
    /// <seealso cref="TQMenuCheckType">
    /// �˵���Ŀ����
    /// </seealso>
    function GetCheckType: TQMenuCheckType; stdcall;
    /// <summary>
    /// ���ò˵���Ŀ����
    /// </summary>
    /// <param name="AType">
    /// �µ�����
    /// </param>
    procedure SetCheckType(const AType: TQMenuCheckType); stdcall;
    /// <summary>
    /// �˵�ͼ����뷽ʽ
    /// </summary>
    property ImageAlign: TImageAlignLayout read GetImageAlign
      write SetImageAlign;
    /// <summary>
    /// ��ǰ �˵���Ŀ����
    /// </summary>
    /// <exception cref="TQMenuCheckType">
    /// �˵���Ŀ����
    /// </exception>
    property CheckType: TQMenuCheckType read GetCheckType write SetCheckType;
    /// <summary>
    /// �Ƿ�ѡ��
    /// </summary>
    property IsChecked: Boolean read GetIsChecked write SetIsChecked;
  end;

  /// <summary>
  /// �˵���Ŀ���࣬���ڹ������˵����ӷ���
  /// </summary>
  /// <remarks>
  /// �˵�����һ�㲻�Ƽ�̫�༶����һ��˵���Ŀ��ʾ�������ޣ�ÿһ�����඼��Ҫ����һ���ľ��룬�Ա�֤�Ӿ�Ч����
  /// </remarks>
  IQMenuCategory = interface(IQMenuBase)
    ['{FC2909CF-7AD2-450F-B02A-7372886BA43E}']
    /// <summary>
    /// ��ȡ�����Ƿ���չ����״̬
    /// </summary>
    function GetIsExpanded: Boolean; stdcall;
    /// <summary>
    /// ���÷����Ƿ�չ��
    /// </summary>
    procedure SetIsExpanded(const val: Boolean); stdcall;
    /// <summary>
    /// Ϊ��������Ӳ˵���Ŀ
    /// </summary>
    /// <returns>
    /// ���ص�ʵ�ʽӿ�������IQMenuItem��ע������Ҫ�������ü���
    /// </returns>
    function AddMenu(const AName, ACaption: PWidechar): Pointer; stdcall;
    /// <summary>
    /// ���һ���ӷ���
    /// </summary>
    /// <returns>
    /// ���ص�ʵ�ʽӿ������� IQMenuCategory��ע������Ҫ�������ü���
    /// </returns>
    function AddCategory(const AName, ACaption: PWidechar): Pointer; stdcall;
    /// <summary>
    /// ɾ��ָ������������
    /// </summary>
    /// <param name="AIndex">
    /// Ҫɾ������������
    /// </param>
    procedure Delete(AIndex: Integer); stdcall;
    /// <summary>
    /// ������е�����
    /// </summary>
    procedure Clear; stdcall;
    /// <summary>
    /// ����ָ����������������
    /// </summary>
    /// <returns>
    /// �ɹ����� &gt;=0 ��������ţ�ʧ�ܣ�����-1
    /// </returns>
    function IndexOf(AItem: IQMenuBase): Integer; overload; stdcall;
    /// <summary>
    /// ����ָ�����Ƶ�����Ŀ�������
    /// </summary>
    /// <param name="AName">
    /// Ҫ���ҵ���Ŀ�����ƣ�ע�����ִ�Сд
    /// </param>
    /// <returns>
    /// �ɹ����� &amp;gt;=0 ��������ţ�ʧ�ܣ�����-1
    /// </returns>
    function IndexOf(AName: PWideChar): Integer; overload; stdcall;
    /// <summary>
    /// ��ȡ�ܵ���������
    /// </summary>
    function GetCount: Integer; stdcall;

    /// <summary>
    /// ��ȡָ������������ӿ�ʵ����ַ
    /// </summary>
    /// <param name="AIndex">
    /// Ҫ��ȡ������ӿ�����
    /// </param>
    /// <returns>
    /// ���صĽӿ�ʵ��Ϊ IQMenuBase �ӿڣ�ע�ⲻҪֱ��ת��Ϊ IQMenuItem ��
    /// IQMenuCategory��Ӧ����Ӧ�Ĺ淶���á�
    /// </returns>
    function GetItems(const AIndex: Integer): Pointer; stdcall;
    /// <summary>
    /// ����������ֻ��
    /// </summary>
    property Count: Integer read GetCount;
    /// <summary>
    /// �Ƿ���չ��״̬
    /// </summary>
    property IsExpanded: Boolean read GetIsExpanded write SetIsExpanded;
    /// <summary>
    /// �����б�
    /// </summary>
    /// <param name="AIndex">
    /// ��������
    /// </param>
    /// <value>
    /// ���صĽӿ�ʵ��Ϊ IQMenuBase �ӿڣ�ע�ⲻҪֱ��ת��Ϊ IQMenuItem ��
    /// IQMenuCategory��Ӧ����Ӧ�Ĺ淶���á�
    /// </value>
    property Items[const AIndex: Integer]: Pointer read GetItems; default;
  end;

  /// <summary>
  /// �˵������ṩ�߽ӿ�
  /// </summary>
  /// <remarks>
  /// <para>
  /// �ڲ˵���Ŀ�����䶯�򱻵������ʱ��������һϵ��֪ͨ��������
  /// </para>
  /// <list type="bullet">
  /// <item>
  /// MenuService.ItemClicked �� �˵���Ŀ�����,@Sender ����Ϊ������Ĳ˵���Ŀ
  /// </item>
  /// <item>
  /// MenuService.ItemAdded �� ����Ŀ���룬@Sender ����Ϊ�¼ӵĲ˵���Ŀ
  /// </item>
  /// <item>
  /// MenuService.ItemDeleted ������Ŀ��ɾ����@Sender ���ѱ�ɾ������Ŀ
  /// </item>
  /// <item>
  /// MenuService.ItemCleared �� ���е������������ˣ�@sender �����Ǳ�����ķ������
  /// </item>
  /// <item>
  /// MenuService.ItemExpand ����һ�����౻չ��ʱ������@Sender ����Ϊ�������
  /// </item>
  /// <item>
  /// MenuService.Validate����һ���˵���Ŀ��Чʱ��������@Sender ����ΪʧЧ�Ĳ˵���ʵ����
  /// </item>
  /// <item>
  /// MenuService.Iconic���������˵���ͼ�������״̬�л�ʱ������IsIconic ����ָ�����µ�״̬
  /// </item>
  /// </list>
  /// <para>
  /// ����֪ͨ�У�@Sender ������Ϊ64λ������ָ����� IQMenuBase ���͵Ľӿڵĵ�ַ��
  /// </para>
  /// </remarks>
  IQMenuService = interface
    ['{EDAE42E6-C53E-4407-862C-AFB4AA910336}']
    /// <summary>
    /// ���һ������
    /// </summary>
    /// <returns>
    /// ʵ�ʷ��صĽӿ�����Ϊ IQMenuCategory��ע��ʹ�������Ҫ��С���ü���
    /// </returns>
    function AddCategory(const AName, ACaption: PWidechar): Pointer; stdcall;
    /// <summary>
    /// ɾ��ָ����������Ŀ
    /// </summary>
    /// <param name="AIndex">
    /// Ҫɾ���Ľӿ�����
    /// </param>
    procedure Delete(AIndex: Integer); stdcall;
    /// <summary>
    /// ������е���Ŀ
    /// </summary>
    procedure Clear; stdcall;
    /// <summary>��ȡָ��·������Ŀ��ַ��·���ָ�����/�ָ�</summary>
    /// <returns>���ض�Ӧ��·����IQMenuBaseʵ����ַ</returns>
    function ItemByPath(APath: PWideChar): Pointer; stdcall; // IQMenuBase
    /// <summary>ǿ�ƴ���ָ������·����·���ָ�����/�ָ�</summary>
    /// <returns>���ض�Ӧ��·����IQMenuBaseʵ����ַ</returns>
    function ForceCategories(APath: PWideChar): Pointer; stdcall;
    // IQMenuCategory
    /// <summary>
    /// ��ȡָ�����������
    /// </summary>
    /// <param name="ACategory">
    /// Ҫ��ȡ���ӷ���ӿ�
    /// </param>
    function IndexOf(ACategory: IQMenuCategory): Integer; stdcall;
    /// <summary>
    /// ��ȡ�ӷ�������
    /// </summary>
    function GetCount: Integer; stdcall;
    /// <summary>
    /// ��ȡָ���������ӷ���ӿ�ʵ����ַ
    /// </summary>
    /// <param name="AIndex">
    /// �ӷ�������
    /// </param>
    /// <returns>
    /// ʵ�ʷ��صĽӿ�����ΪIQMenuCategory��ע��ʹ����ɺ��ͷŽӿ����ü���
    /// </returns>
    function GetItems(const AIndex: Integer): Pointer; stdcall;
    /// <summary>
    /// ��ȡ��ǰ�Ƿ���ͼ��״̬
    /// </summary>
    /// <remarks>
    /// ͼ��״̬�£����е�����ᱻ����ֻ��ʾ�������ͼ���б�
    /// </remarks>
    function GetIsIconic: Boolean; stdcall;
    /// <summary>
    /// ���õ�ǰ�Ƿ���ͼ��״̬
    /// </summary>
    procedure SetIsIconic(const value: Boolean); stdcall;
    /// <summary>
    /// �ӷ�������
    /// </summary>
    property Count: Integer read GetCount;
    /// <summary>
    /// �ӷ�����Ŀ
    /// </summary>
    /// <param name="AIndex">
    /// �ӷ�����Ŀ����
    /// </param>
    property Items[const AIndex: Integer]: Pointer read GetItems; default;
    /// <summary>
    /// �Ƿ���ͼ��״̬
    /// </summary>
    property IsIconic: Boolean read GetIsIconic write SetIsIconic;
  end;

  /// <summary>
  /// ͼƬ����ע��·��Ϊ /Services/Images
  /// </summary>
  IQImageService = interface(IQService)
    ['{4C44E9DD-14A2-4FFF-9003-FC88F4EBA291}']
    /// <summary>
    /// ��ȡһ���µ�IQImageʵ��
    /// </summary>
    /// <returns>
    /// ���ص��� IQImage ���͵Ľӿڵ�ַ��ע��ʹ����ɼ������ü���
    /// </returns>
    function NewImage: Pointer; stdcall;
  end;

const
  MenuServiceRoot: PWideChar = '\Services\Menus';
  ImageServiceRoot: PWideChar = '\Services\Images';

implementation

end.

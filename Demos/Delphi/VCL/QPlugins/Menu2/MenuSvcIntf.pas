unit MenuSvcIntf;

interface
uses
  windows,qstring, qplugins, qplugins_params;

const

  MN_CLICK = 0;

type
  // ����ֻʵ���˲˵�����Ĳ��ֽӿڣ����Ҫʵ�ָ���Ľӿڣ����Լ���չʵ��
  IQMenuItem = interface
    ['{83323919-93DE-4D40-87FB-7266AE804D6C}']
    function GetCaption: PWideChar;
    procedure SetCaption(const S: PWideChar);
    function GetHint: PWideChar;
    procedure SetHint(const S: PWideChar);

    function getParams: IQParams;
    procedure setParams(AParams: IQParams);

    function SetImage(AHandle: HBITMAP): Boolean;

    function GetParentMenu: IQMenuItem;

    property Caption: PWideChar read GetCaption write SetCaption;
    property Hint: PWideChar read GetHint write SetHint;
    property ParentMenu: IQMenuItem read GetParentMenu;
    property Params: IQParams read getParams write setParams;
  end;

  IQMenuService = interface
    ['{667BD198-2F9A-445C-8A7D-B85C4B222DFC}']
    function RegisterMenu(const APath: PWideChar; AOnEvent: IQNotify;
      ADelimitor: WideChar = '/'): IQMenuItem;
    procedure UnregisterMenu(const APath: PWideChar; AOnEvent: IQNotify;
      ADelimitor: WideChar = '/');
  end;


implementation

end.

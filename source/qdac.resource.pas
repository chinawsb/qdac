unit qdac.resource;

interface

resourcestring
  SDefaultRangeError = '[Value] 不在 [MinValue] 和 [MaxValue] 之间，取值无效.';
  SDefaultLengthError = '长度 [Size] 不在 [MinSize] 和 [MaxSize] 之间，取值无效.';
  SLengthOnlySupportStringAndArray = '长度验证只支持字符串和数组类型';
  SAssertSizeError = 'AMaxSize 必需 >= AMinSize 并表 AMinSize must >= 0';
  SValueTypeError = '[Value] 不是一个有效的[ValueType]值';
  SRegExpressionError = '%s 不是一个有效的正则表达式';
  SValidatorNotExists = '找不到名为 %s 的验证规则';
  SChineseMobile = '中国大陆手机号码';
  SChineseId = '中国大陆居民身份证号';
  SIPV4 = 'IPV4';
  SIPV6 = 'IPV6';
implementation

end.

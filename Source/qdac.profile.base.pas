unit qdac.profile.base;

{ QDAC 4.0 性能测量工具 — 抽象基类
  提供所有 profiler 的统一接口（Report / ReportJson / SaveToFile / Reset）
  以及共享的状态管理（Enabled / FileName）和文件保存实现。 }

interface

uses System.Classes, System.SysUtils;

type
  /// <summary>所有 profiler 的抽象基类</summary>
  TQProfileBase = class
  public
    // ── 报告接口 ──
    /// <summary>获取文本格式报告</summary>
    class function Report: string; virtual; abstract;
    /// <summary>获取 JSON 格式报告（基类默认返回 '{}'）</summary>
    class function ReportJson: string; virtual;
    /// <summary>
    ///   保存 JSON 报告到文件。
    ///   若 AFileName 为空则使用 GetFileName 返回的路径。
    /// </summary>
    class procedure SaveToFile(const AFileName: string = ''); virtual;
    /// <summary>重置所有统计数据</summary>
    class procedure Reset; virtual; abstract;

    // ── 公共状态访问器（每个子类各自管理自己的 class var） ──
    /// <summary>是否已启用分析</summary>
    class function GetEnabled: Boolean; virtual; abstract;
    /// <summary>默认输出文件名</summary>
    class function GetFileName: string; virtual; abstract;
  end;

implementation

{ TQProfileBase }

class function TQProfileBase.ReportJson: string;
begin
  Result := '{}';
end;

class procedure TQProfileBase.SaveToFile(const AFileName: string = '');
var
  LFileName: string;
  AStream: TStringStream;
begin
  if not GetEnabled then
    Exit;
  LFileName := AFileName;
  if LFileName = '' then begin
    LFileName := GetFileName;
    if LFileName = '' then
      LFileName := ExtractFilePath(ParamStr(0)) + 'profile_report.json';
  end;
  AStream := TStringStream.Create(ReportJson, TEncoding.UTF8);
  try
    AStream.SaveToFile(LFileName);
  finally
    AStream.Free;
  end;
end;

end.

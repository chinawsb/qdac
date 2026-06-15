# QDAC 4.0 性能分析框架 (qdac.profile)

## 架构总览

性能分析框架包含 **3 种分析模式** 和 **1 个抽象基类**：

```
TQProfileBase (qdac.profile.base.pas)
  │ 抽象基类，定义统一接口
  │
  ├── TQProfile (qdac.profile.pas)
  │    标签式（手动打点）分析
  │
  ├── TQDetourProfiler (qdac.profile.detour.pas)
  │    Hook 式（API 拦截）分析
  │
  └── TQSamplingProfiler (qdac.profile.sampling.pas)
       采样式（定时挂起线程）分析
```

### 基类 `TQProfileBase` 统一接口

所有 profiler 共享以下方法：

| 方法 | 说明 |
|------|------|
| `Report: string` | 获取文本格式报告 |
| `ReportJson: string` | 获取 JSON 格式报告 |
| `SaveToFile(const AFileName: string = '')` | 保存 JSON 报告到文件（自动调用 ReportJson） |
| `Reset` | 重置所有统计数据 |
| `GetEnabled: Boolean` | 是否启用 |
| `GetFileName: string` | 默认输出文件名 |

每个子类在退出时（`AddExitProc`）自动调用 `SaveToFile` 保存报告。

---

## 模式一：TQProfile（标签式）

### 原理

在需要测量的函数入口调用 `TQProfile.Calc('函数名')`，返回一个 `IQProfileHelper` 接口。当接口变量离开作用域（函数返回）时，自动记录执行耗时和调用链。

### 使用方法

```pascal
uses qdac.profile.base, qdac.profile;

procedure MyFunction;
var
  H: IQProfileHelper;   // 或 IInterface
begin
  H := TQProfile.Calc('MyFunction');
  // ... 业务代码 ...
end;  // H 释放 → 自动记录耗时
```

### 嵌套调用

```pascal
procedure Inner;
var H: IInterface;
begin
  H := TQProfile.Calc('Inner');
  Sleep(5);
end;

procedure Outer;
var H: IInterface;
begin
  H := TQProfile.Calc('Outer');
  Inner;
  Inner;
  Sleep(8);
end;
```

### 异步/回调

```pascal
type
  TMyThread = class(TThread)
    procedure Execute; override;
  end;

procedure TMyThread.Execute;
var H: IInterface;
begin
  H := TQProfile.Calc('ThreadWork');
  // ... 线程业务 ...
end;
```

### 输出格式 (JSON via `AsString` / `ReportJson`)

```json
{
  "mainThreadId": 3668,
  "freq": 10000000,
  "timeUnit": "default",
  "threads": [
    {
      "threadId": 3668,
      "chains": [
        {
          "name": "MyFunction",
          "runs": 5,
          "minTime": 154268,
          "maxTime": 616824,
          "totalTime": 1522616,
          "avgTime": 253769
        },
        {
          "name": "Outer",
          "runs": 4,
          "maxNestLevel": 1,
          "children": [
            {
              "name": "Inner",
              "runs": 8,
              "minTime": 5000,
              "maxTime": 5100,
              "totalTime": 40400,
              "avgTime": 5050
            }
          ]
        }
      ]
    }
  ]
}
```

### 关键属性

| 属性 | 类型 | 说明 |
|------|------|------|
| `Enabled` | `Boolean` (只读) | Debug 默认 true；Release 需命令行 `EnableProfile` 开关 |
| `FileName` | `string` | 输出文件路径，默认 `profiles.json` |
| `TimeUnit` | `TQProfileTimeUnit` | 时间单位（default/ms/us/ns） |

### 自动保存

程序退出时通过 `AddExitProc` 自动保存到 `FileName`。

---

## 模式二：TQDetourProfiler（Hook 式）

### 原理

通过改写目标函数的前几个字节为 JMP 指令，将所有调用重定向到 Trampoline，在 Trampoline 中记录函数进入/退出时间。**无需在函数体内添加任何代码**。

### 使用方法

```pascal
uses qdac.profile.base, qdac.profile.detour;

// 1. 注册需要 Hook 的函数
TQDetourProfiler.RegisterFunction('FuncA', @FuncA);
TQDetourProfiler.RegisterFunction('FuncB', @FuncB);

// 2. 启用
TQDetourProfiler.Enabled := True;

// 3. 执行业务（函数调用自动被拦截）
for I := 1 to 100 do
  FuncA;

// 4. 停止
TQDetourProfiler.Enabled := False;

// 5. 获取报告
WriteLn(TQDetourProfiler.Report);
// 或 JSON
var Json := TQDetourProfiler.ReportJson;
```

### 输出格式

**文本报告** (`.Report`)：
```
=== TQDetourProfiler ===
  totalCalls: 15

--- Call Chains ---
  ├─ FuncA  (10 calls, 0.00 ms)
  └─ FuncB  (5 calls, 0.00 ms)

--- Flat Profile (by total time) ---
  Calls  Avg(us)  Tot(ms)  Function
  ----------------------------------------------------------------------
     10     0.06      0.00  FuncA
      5     0.06      0.00  FuncB
```

**JSON 报告** (`.ReportJson`)：
```json
{
  "totalCalls": 15,
  "callChains": [
    {
      "name": "FuncA",
      "addr": "009DE0A4",
      "calls": 10,
      "totalTicks": 6,
      "minTicks": 0,
      "maxTicks": 2,
      "avgTicks": 0,
      "children": []
    }
  ],
  "hotFunctions": [
    {
      "name": "FuncA",
      "calls": 10,
      "pct": 66.67
    }
  ]
}
```

### 关键属性

| 属性 | 说明 |
|------|------|
| `Enabled: Boolean` | 启用/停用 Hook（读写） |
| `FileName: string` | 输出文件路径，默认 `detour_profile.json` |

### 自动保存

通过 `AddExitProc` 在退出时自动保存到文件。

---

## 模式三：TQSamplingProfiler（采样式）

### 原理

启动一个后台线程，定时（默认 10ms）挂起所有其他线程，抓取它们的调用栈，统计每个地址出现的频率。**完全无侵入，不需要修改任何代码**。

### 使用方法

```pascal
uses qdac.profile.base, qdac.profile.sampling;

// 配置采样间隔（可选，默认 10ms）
TQSamplingProfiler.SampleIntervalMs := 5;

// 启动
TQSamplingProfiler.Enabled := True;

// 执行业务...
HeavyWork;

// 停止
TQSamplingProfiler.Enabled := False;

// 获取报告
WriteLn(TQSamplingProfiler.Report);
var Json := TQSamplingProfiler.ReportJson;
```

### 输出格式

**文本报告** (`.Report`)：
```
=== TQSamplingProfiler Report ===
Total unique addresses: 5, total samples: 156

Top functions by hit count:
  Hits   %     Function
  ------------------------------------------------------------
     23   60.5%  qprofile_test_phase3.exe+$C093A9
      8   21.1%  qprofile_test_phase3.exe+$C093AC
      7   18.4%  qprofile_test_phase3.exe+$C0939D
```

**JSON 报告** (`.ReportJson`)：
```json
{
  "filterSystemModules": true,
  "mainModuleBase": "00B30000",
  "mainModuleSize": 5095424,
  "sampleIntervalMs": 10,
  "totalSamples": 156,
  "totalFunctions": 3,
  "totalHits": 38,
  "functions": [
    {
      "addr": "00C093A9",
      "name": "qprofile_test_phase3.exe+$C093A9",
      "hits": 23,
      "pct": 60.53
    }
  ]
}
```

### 关键属性

| 属性 | 说明 |
|------|------|
| `Enabled: Boolean` | 启动/停止采样线程 |
| `FilterSystemModules: Boolean` | 默认 True，只显示主 EXE 模块的地址 |
| `SampleIntervalMs: Cardinal` | 采样间隔（毫秒），默认 10ms |
| `MaxFrames: Integer` | 每次采样抓取的调用栈深度，默认 32 |
| `AutoStart: Boolean` | 是否在单元初始化时自动启动，默认 False |
| `AutoSave: Boolean` | 退出时是否自动保存，默认 False |

### 关于符号解析

采样器默认通过 `dbghelp.dll` 的 `SymFromAddr` 解析地址为函数名。如果：

1. **有 `.map` 文件** — 在 exe 同目录下放 `.map` 文件，`dbghelp.dll` 会自动加载符号，输出显示为 `HeavyWork` 等源码函数名
2. **无 `.map` 文件** — 输出显示为 `模块名+$地址`，如 `qprofile_test_phase3.exe+$C093A9`

---

## 三种模式对比

| 特性 | TQProfile | TQDetourProfiler | TQSamplingProfiler |
|------|-----------|------------------|--------------------|
| **侵入性** | 需手动加 `Calc` | 注册一次即可 | **完全无侵入** |
| **精度** | ✅ 精确计时 | ✅ 精确计时 | ⚠️ 统计采样 |
| **调用链** | ✅ 完整嵌套 | ✅ 独立级别 | ❌ 无 |
| **线程支持** | ✅ 每个线程独立记录 | ✅ 跨线程拦截 | ✅ 采集所有线程 |
| **函数名** | ✅ 直接传字符串 | ✅ 注册时指定 | ⚠️ 需 dbghelp + .map |
| **自动保存** | ✅ 退出自动 | ✅ 退出自动 | ⚠️ 需设 `AutoSave=True` |
| **开发效率** | ❌ 每个函数手动加 | ✅ 一次注册全部拦截 | ✅ 无需修改代码 |
| **适用场景** | 关键路径精确测量 | 模块级自动追踪 | 全局热点发现 |

---

## 使用限制

### TQProfile
- Release 构建需传 `EnableProfile` 命令行参数
- 必须手动在函数入口调用 `Calc`，漏加则无法测量

### TQDetourProfiler
- **仅 Windows x86/x64**（因内联机器码）
- **嵌套调用限制**：当两个被 Hook 的函数存在调用关系（如 FuncC 调用 FuncA）时，x86 的 `CALL rel32` 指令在 trampoline 中偏移量不会自动修正，导致内层函数无法触发 Hook。建议对嵌套场景使用 TQProfile.Calc 做精确追踪
- 需考虑 Hook 的开销（每次调用额外 ~0.05μs）
- `FindMapFile` / `ParseMapFile` / `LoadMap` 尚未实现（空函数存根）

### TQSamplingProfiler
- **统计采样，非精确计时**（分辨率取决于采样间隔）
- 依赖 `CreateToolhelp32Snapshot` 和 `StackWalk64`，在受限环境中可能无法获取线程快照
- 需要 `.map` 文件才能显示源码级函数名
- 采样线程本身也会被采集到快照中（会跳过自身）

### 已知问题
- **单元冲突**：`qdac.profile.detour` 和 `qdac.profile` 同时使用时，TQProfile 的 `Calc` 方法在高版本 Delphi 中可能出现访问冲突。建议分进程测试不同模式

---

## AI Agent 使用指南

### 何时使用哪种模式

```
场景                          推荐模式
─────────────────────────────────────────────
"看看哪段代码最慢"             → TQSamplingProfiler
"精确测量这个函数的耗时"       → TQProfile.Calc
"给整个模块自动打点"           → TQDetourProfiler
"多线程下每个线程的耗时分布"   → TQProfile（多线程 Calc）
"程序启动慢，查初始化热点"     → TQSamplingProfiler（设 AutoStart=True）
```

### 解读报告要点

**TQProfile JSON**：
- `runs` → 函数被调了多少次
- `avgTime = totalTime / runs` → 平均每次耗时（周期数，除以 `freq` 得秒数）
- `children` → 调用链层次，看谁调了谁
- 按 `threadId` 分开，不同线程分别统计

**TQDetourProfiler**：
- `callChains` → 根级别调用树（不含嵌套 Hook 的调用链）
- `hotFunctions` → 按 `totalTicks` 降序，最耗时的排最前
- `pct` → 调用次数占比（非耗时占比）

**TQSamplingProfiler**：
- `totalSamples` → 总采样次数
- `hits` → 该地址被命中的次数
- `pct` → 命中占比 = `hits / totalHits * 100`
- 占比越高 = 该函数占用 CPU 越多
- `filterSystemModules=true` 时只显示 EXE 内的地址

### 性能开销

| 模式 | 对被测代码的影响 |
|------|-----------------|
| TQProfile | ~0.1μs/次（接口创建+释放） |
| TQDetourProfiler | ~0.05μs/次（额外的 CALL/RET） |
| TQSamplingProfiler | 采样时所有线程挂起 ~1ms，对实时性有影响 |

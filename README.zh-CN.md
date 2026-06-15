# QDAC 4.0 — Quick Data Access Components

**QDAC** 是由吉林省左右软件开发有限公司开发的 Delphi/C++Builder 跨平台开源组件库，名称取自 **Quick Data Access Components** 的首字母。

> ⚠️ 当前为 `next` 开发分支，API 尚未稳定，不适合在生产环境中使用。

---

## 环境要求

| 编译器 | 最低版本 |
|--------|---------|
| Delphi | XE3 (RTLVersion 24) |
| Free Pascal | 3.3.1+ |
| C++ Builder | XE3+ |

---

## 模块架构

```
Source/
├── qdac.inc                    编译器版本检测与特性开关
├── qdac.common.pas             公共基础类型和接口（编解码器基类）
├── qdac.attribute.pas          注解系统（Name/Path/MethodName 等）
│
├── qdac.serialize.core.pas     序列化核心引擎（DOM 节点、读写器框架）
├── qdac.serialize.core.origin.pas  序列化引擎原始备份版本
│
├── qdac.json.core.pas          JSON 解析/生成（4414 行，核心模块）
├── qdac.xml.core.pas           XML 解析/生成（基于 serialize.core）
├── qdac.msgpack.core.pas       MessagePack 解析/生成（基于 serialize.core）
│
├── qdac.validator.pas          数据验证框架（泛型验证器链）
├── qdac.resource.pas           资源字符串（错误消息等）
│
├── qdac.profile.base.pas       性能分析抽象基类
├── qdac.profile.pas            性能分析 — 标签式（TQProfile.Calc）
├── qdac.profile.detour.pas     性能分析 — Hook 式（TQDetourProfiler）
├── qdac.profile.sampling.pas   性能分析 — 采样式（TQSamplingProfiler）
├── qdac.profile.win.pas        性能分析 — Windows 平台支持
└── qdac.profile.posix.pas      性能分析 — POSIX 平台支持
```

### 模块依赖关系

```
                     qdac.common
                    /     |      \
          qdac.attribute   |    qdac.validator
                   \      |      /
               qdac.serialize.core
               /        |         \
     qdac.json.core  qdac.xml.core  qdac.msgpack.core

         qdac.profile.base
          /        |        \
   qdac.profile  qdac.profile.detour  qdac.profile.sampling
         |        |        |
   qdac.profile.win  /  qdac.profile.posix
```

---

## 各模块说明

### 基础模块

#### `qdac.common` — 公共基础
- 类型别名：`SizeInt`、`TStringArray`、`TStringPair`
- 编解码器接口：`IQTextCodec`（文本编解码）、`IQStreamCodec`（流编解码）
- 流式编解码基类 `TBaseStreamCodec`
- 工具方法

#### `qdac.attribute` — 注解系统
基于 Delphi `TCustomAttribute` 的注解体系：
- `NameAttribute` — 序列化名称映射
- `PathAttribute` — 路径映射
- `MethodNameAttribute` — 方法名映射
- `IgnoreAttribute` — 忽略字段标记
- `DateFormatAttribute` / `NumberFormatAttribute` — 格式控制
- `EnumerableAttribute` / `DictionaryAttribute` — 集合类型标记

#### `qdac.validator` — 数据验证框架
泛型驱动的声明式验证器链：
- `TQValidator` — 验证器基类，支持链式组合
- 内置验证器：范围、长度、正则表达式、枚举值等
- 通过 `TQValueTransform<T>` 支持自定义值转换
- 验证错误消息通过 `qdac.resource` 提供多语言支持

### 序列化核心

#### `qdac.serialize.core` — 序列化引擎
统一的序列化/反序列化框架：
- **DOM 节点系统** — `TQNodeBase` 通用节点，支持 `ForEach`、`Find`、`ItemByPath`、`XPath` 遍历
- **读写器接口** — `IQSerializeReader` / `IQSerializeWriter`，支持属性名格式命名、日期格式、枚举转整数等配置
- **反射序列化** — 基于 RTTI 将 Delphi 对象/记录自动序列化为 DOM 树，支持嵌套对象、集合、字典等
- **`TQSerializeTypeData`** — 类型元数据结构，描述字段名格式、日期格式、元素类型等

### 数据格式

#### `qdac.json.core` — JSON（4414 行，核心模块）
- 完整的 JSON 解析/生成（支持 RFC 8259）
- 数据类型：`null`、`Boolean`、`Integer`、`Float`、`DateTime`、`String`、`Array`、`Object`
- 流式读取（缓冲区可配，默认 8KB）
- 格式化输出（缩进可选）
- Unicode 支持
- **TODO**：JSON Schema 支持

#### `qdac.xml.core` — XML（基于 serialize.core 共享 DOM）
- XML 节点类型：Element、Attribute、Text、Comment、CDATA、Processing Instruction、Document
- 共享 `TQNodeBase` 遍历逻辑（`ForEach`/`Find`/`ItemByPath`/`XPath`）
- 格式化/压缩输出
- 属性管理

#### `qdac.msgpack.core` — MessagePack（基于 serialize.core 共享 DOM）
- 完整的 MessagePack 格式支持（`nil`、`Boolean`、`Int`、`UInt`、`Float`、`String`、`Binary`、`Array`、`Map`、`Ext`）
- 共享 `TQNodeBase` 遍历逻辑
- 编码设置：`RawString`、`SortMapKeys`、`WriteTimestamp`

### 性能分析（qprofile）

三个分析模式，共享 `TQProfileBase` 抽象基类，支持 `Report`、`ReportJson`、`SaveToFile`、`Reset` 统一接口。

| 模式 | 类 | 原理 | 侵入性 |
|------|-----|------|--------|
| 标签式 | `TQProfile` | 手动在函数入口调 `Calc`，接口释放时记录耗时 | 高 |
| Hook 式 | `TQDetourProfiler` | 通过改写函数机器码自动拦截所有调用 | 中 |
| 采样式 | `TQSamplingProfiler` | 定时挂起线程抓调用栈统计热点 | 无 |

> 详细文档见 [Source/README.qdac.profile.md](Source/README.qdac.profile.md)

---

## 示例项目

```
Demos/Delphi/rtl/
├── json.core.demo/        JSON 解析/生成演示
├── json.core.test/        JSON 单元测试（含 edge_test、serdestest、t）
├── profile/               性能分析演示（三种模式）
│   ├── profile.demo/      TQProfile 标签式演示
│   ├── profile_stress_test/  Hook + 采样压力测试
│   ├── test_min/          最小 TQProfile 测试
│   ├── test_detour_only/ 仅 Hook 式测试
│   └── test_minimal/      最小采样测试
├── serialization/         序列化演示
└── validators/            数据验证器演示
```

---

## 编译说明

1. 在 Delphi IDE 中打开任一 `.dproj` 项目文件
2. 确保 `Source/` 目录在项目的 Unit search path 中

### 编译器版本

`qdac.inc` 文件中定义了编译器版本检测：

```pascal
{$IFDEF FPC}
  // Free Pascal 3.3.1+
  {$MODE DELPHIUNICODE}
{$ELSE}
  // Delphi XE3 (RTLVersion 24) +
  {$IF RTLVersion<24}
    {$ERROR 'At least XE 3 + needed.'}
  {$ENDIF}
{$ENDIF}
```

---

## 许可

本项目基于 [MIT License](LICENSE) 开源。

版权所有 © 2023 eqbrm.com / 吉林省左右软件开发有限公司

---

## 仓库地址

| 地址 | 说明 |
|------|------|
| https://code.qdac.cc:3000 | 主库 |
| https://gitee.com/z-proj/qdac | 国内镜像 |
| https://github.com/chinawsb/qdac | GitHub 镜像 |

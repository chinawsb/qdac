# QDAC 4.0 Knowledge Base

**Generated:** 2026-05-30 10:44
**Branch:** dev (4.0-next)

## Overview

QDAC (Quick Data Access Components) — Delphi/C++Builder open-source component library. Serialization (JSON/XML/MessagePack), data validation, performance profiling. RAD Studio XE3+ / Free Pascal 3.3.1+.

## Structure

```
qdac-4.0/
├── Source/           # Core library (15 .pas, ~15K lines)
├── Demos/Delphi/rtl/ # Demo apps + unit tests per module
├── packages/         # .dpk component packages (rtl/vcl/fmx/lcl)
├── doc/              # Documents
└── contribute/       # Contribution guide
```

## Where to Look

| Task | Go to | Notes |
|------|-------|-------|
| JSON impl | `Source/qdac.json.core.pas` | 4322 lines, core module |
| XML impl | `Source/qdac.xml.core.pas` | Shares DOM with serialize.core |
| MessagePack | `Source/qdac.msgpack.core.pas` | Shares DOM with serialize.core |
| Serialization engine | `Source/qdac.serialize.core.pas` | DOM nodes, reader/writer, RTTI reflection |
| Validation | `Source/qdac.validator.pas` | Generic validator chain |
| Attributes/annotations | `Source/qdac.attribute.pas` | Custom attributes for serialization config |
| Performance profiling | `Source/qdac.profile*.pas` | 3 modes: label/hook/sampling |
| Common types | `Source/qdac.common.pas` | Codec interfaces, type aliases |
| Compiler detection | `Source/qdac.inc` | Version checks, feature defines |
| JSON demo | `Demos/Delphi/rtl/json.core.demo/` | VCL demo app |
| JSON tests | `Demos/Delphi/rtl/json.core.test/` | Multiple test suites |
| Profiler demos | `Demos/Delphi/rtl/profile/` | All 3 modes demoed |
| Resource strings | `Source/qdac.resource.pas` | Error messages |
| Profiler docs | `Source/README.qdac.profile.md` | Detailed usage guide |

## Conventions

### Naming
- **Units**: `qdac.<module>.pas` (lowercase, dot-separated)
- **Classes**: `TQ<Name>` (e.g. `TBaseStreamCodec`, `TQProfile`)
- **Interfaces**: `IQ<Name>` (e.g. `IQTextCodec`, `IQSerializeReader`)
- **Attributes**: `<Name>Attribute` suffix (e.g. `NameAttribute`, `IgnoreAttribute`)
- **Parameters**: Prefix `A` (e.g. `AValue`, `ACount`, `AFileName`)
- **Fields**: Prefix `F` (e.g. `FStream`, `FText`)
- **Constants**: Prefix `S` for resource strings (e.g. `SSerializeFormatNotSupport`)
- **HTTP methods**: `SHttpGet`, `SHttpPost`, `SHttpPut`, `SHttpDelete`

### Formatting
- Uses `{$I qdac.inc}` for compiler version detection
- Uses `UnicodeString` for text types throughout
- Interface GUIDs in standard `['{...}']` format
- `resourcestring` for user-facing messages (Chinese locale)
- `TArray<T>` and `TPair<T1,T2>` for generic collections

### Compiler Support
- Delphi XE3+ (RTLVersion 24+)
- Free Pascal 3.3.1+ (`{$MODE DELPHIUNICODE}`)
- `{$DEFINE FAST_HASH_CODE}` on both
- `STRING_FIRST_INDEX` constant handles `NEXTGEN` zero-vs-one-based strings

## Anti-Patterns (This Project)

- **No JSON Schema support yet** — documented TODO in qdac.json.core
- **No `.map` file symbol resolution in detour profiler** — `FindMapFile`/`ParseMapFile` are empty stubs
- **Unit conflict warning**: `qdac.profile.detour` + `qdac.profile` together may cause AV in high Delphi versions — test modes in separate processes
- **Nested Hook limitation**: TQDetourProfiler cannot correctly hook nested calls (CALL rel32 offset not adjusted in trampoline)

## Commands

```bash
# Build via IDE: open any .dproj, ensure Source/ in unit search path
# No CLI build scripts configured yet
```

## Notes

- Development branch (4.0-next), API unstable
- Authors: @siwsh (eqbrm.com), @KngStr, @biznow
- Repos: code.qdac.cc:3000 (main) | gitee.com/z-proj/qdac (CN mirror) | github.com/chinawsb/qdac

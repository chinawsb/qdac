# QDAC 4.0 — Source

**Generated:** 2026-05-30
**Path:** `Source/` — core library (15 .pas, ~15K lines, flat structure)

## File Map

| File | Lines | Role |
|------|-------|------|
| `qdac.inc` | 34 | Compiler version detection (XE3+/FPC 3.3.1+), `FAST_HASH_CODE` define |
| `qdac.common.pas` | 133 | Codec interfaces (`IQTextCodec`/`IQStreamCodec`), type aliases, `STRING_FIRST_INDEX` |
| `qdac.attribute.pas` | 268 | Custom attributes: `Name`, `Path`, `Ignore`, `DateFormat`, `Enumerable` etc. |
| `qdac.validator.pas` | 1127 | Generic validator chain (`TQValidator`), range/length/regex/enum validators |
| `qdac.resource.pas` | 19 | `resourcestring` error messages (Chinese locale) |
| `qdac.serialize.core.pas` | 2651 | DOM node system (`TQNodeBase`), reader/writer interfaces, RTTI reflection engine |
| `qdac.serialize.core.origin.pas` | 2245 | Original backup of serialize.core (reference only) |
| `qdac.json.core.pas` | 4322 | JSON parser/generator (RFC 8259) — largest module |
| `qdac.xml.core.pas` | 788 | XML parser/generator — shares DOM with serialize.core |
| `qdac.msgpack.core.pas` | 953 | MessagePack parser/generator — shares DOM with serialize.core |
| `qdac.profile.base.pas` | 52 | Abstract profiler base class (`TQProfileBase`) |
| `qdac.profile.pas` | 1137 | Label-based profiler (`TQProfile.Calc`) |
| `qdac.profile.detour.pas` | 849 | Hook-based profiler (machine code detour) |
| `qdac.profile.sampling.pas` | 557 | Sampling profiler (timer-based stack walk) |
| `qdac.profile.win.pas` | 126 | Windows platform support (TLS, thread enumeration) |
| `qdac.profile.posix.pas` | 66 | POSIX platform support |

## Module Dependency

```
qdac.common  ──→  qdac.attribute, qdac.validator
                       ↕
                    qdac.serialize.core
                   ↙    ↓    ↘
  qdac.json.core  qdac.xml.core  qdac.msgpack.core

     qdac.profile.base
    ↙    ↓    ↘
profile  detour  sampling
    ↓    ↓
win / posix
```

## Key Patterns

- **DOM sharing**: JSON/XML/MessagePack all use `TQNodeBase` from serialize.core for traversal (`ForEach`/`Find`/`ItemByPath`/`XPath`)
- **Reader/Writer pattern**: `IQSerializeReader` / `IQSerializeWriter` interface abstraction for format-agnostic serialization
- **RTTI reflection**: `TQSerializeTypeData` + RTTI-based object↔DOM serialization (supports nested objects, collections, dictionaries, enumerations)
- **All units** include `{$I qdac.inc}` for cross-compiler compatibility
- **Profiler plugins**: 3 modes sharing `TQProfileBase`, all auto-save via `AddExitProc`
- **Profiler limitation**: `FindMapFile`/`ParseMapFile` are empty stubs (no .map symbol resolution)

## Best Practices

### Adding QDAC to a Project

```pascal
// 1. Add Source/ to Project > Options > Delphi Compiler > Unit search path
// 2. Add desired units to uses clause:
uses
  qdac.common, qdac.attribute, qdac.json.core;
```

**Package users**: Install via `packages/qdac.rtl.dpk` first, then framework-specific (`qdac.vcl.dpk`, `qdac.fmx.dpk`, `qdac.lcl.dpk`).

### Serialization — Typical Workflow

```pascal
// 1. Annotate your class/record with attributes
type
  [Name('person')]
  TPerson = class
  private
    [Name('id')]
    FId: Integer;
    [Name('name')]
    FName: string;
    [Ignore]
    FTemp: string;
  published
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
  end;

// 2. Serialize to JSON
var
  Json: string;
  Person: TPerson;
begin
  Person := TPerson.Create;
  Json := TQJSON.ObjectToJson(Person);  // → '{"id":1,"name":"Alice"}'

// 3. Deserialize from JSON
  TQJSON.JsonToObject(Person, '{"id":2,"name":"Bob"}');
```

### Streaming — Read/Write via TStream

For large payloads or piping data over network/file, use stream-based APIs to avoid holding the entire payload in memory.

#### DOM-Level Streaming (Full Tree in Memory)

```pascal
// Load JSON from a file stream into a DOM tree for random access
var
  Node: TQJsonNode;
  AStream: TFileStream;
begin
  Node := TQJsonNode.Create;
  AStream := TFileStream.Create('data.json', fmOpenRead);
  try
    Node.LoadFromStream(AStream, jsmNormal);     // ← 流式读取，构建完整 DOM
    WriteLn(Node.ItemByName('name').AsString);
  finally
    AStream.Free;
  end;

// Save DOM tree back to stream
  Node.SaveToStream(AStream, TEncoding.UTF8, TQJsonEncoder.DefaultFormat, True);
```

#### Object Serialization Streaming (RTTI-Based)

```pascal
// Save object to stream
var
  AStream: TFileStream;
  Person: TPerson;
begin
  Person := TPerson.Create;
  AStream := TFileStream.Create('person.json', fmCreate);
  try
    TQSerializer.Current.SaveToStream(Person, AStream, 'json');
  finally
    AStream.Free;
  end;

// Load object from stream
  AStream := TFileStream.Create('person.json', fmOpenRead);
  try
    TQSerializer.Current.LoadFromStream(Person, AStream, 'json');
  finally
    AStream.Free;
  end;
```

#### Stdin/Stdout Pipeline

```pascal
// Read JSON from stdin (pipe), parse forward-only, write result to stdout
var
  AIn, AOut: THandleStream;
begin
  AIn := THandleStream.Create(GetStdHandle(STD_INPUT_HANDLE));
  AOut := THandleStream.Create(GetStdHandle(STD_OUTPUT_HANDLE));
  try
    // Read from stdin via streaming decoder (forward-only, low memory)
    TQSerializer.Current.LoadFromStream(MyObj, AIn, 'json');
    // Process...
    // Write to stdout via streaming encoder
    TQSerializer.Current.SaveToStream(MyObj, AOut, 'json');
  finally
    AIn.Free;
    AOut.Free;
  end;
end;
```

Useful for CLI tools, pipe chains (`app1 | qdac-tool | app2`), and CGI-style processing where the entire payload never sits in memory at once.

| Scenario | API | Memory |
|----------|-----|--------|
| Need random access to parsed data | `TQJsonNode.LoadFromStream` (jsmNormal) | Holds full DOM tree |
| Object ↔ serialized format via RTTI | `TQSerializer.LoadFromStream<T>` / `SaveToStream<T>` | Internal streaming, no full DOM |
| Stdin/stdout pipeline | `THandleStream` + `TQSerializer.SaveToStream/LoadFromStream` | Streaming per-item |
| Binary payload encoding (Base64 etc.) | `TBaseStreamCodec` / `IQStreamCodec` | Stream codec pattern |

#### When to Use Streaming

- **Loading large files** (>10 MB) — avoid `StringToJson`/`JsonToString`, use `LoadFromStream`/`SaveToStream`
- **Network communication** — pipe `TStream` directly from `TIdTCPClient` or `THTTPClient`
- **Database BLOB fields** — read/write JSON/XML/MSGPack directly from `TStream`
- **CLI pipe chains** — stdin → parse → process → stdout, never buffer full payload
- **Memory-constrained environments** — streaming avoids duplicating the buffer

### Forward-Only Mode (jsmForwardOnly) — Low Memory, No DOM

Forward-only mode parses JSON in a single pass **without building the DOM tree**. It uses a callback (`TQJsonParseCallback`) to notify you about each node as it is encountered — you choose what to keep and what to skip.

```pascal
// Forward-only: parse a huge JSON without building the DOM
var
  Parser: TQJsonParser;
  AStream: TFileStream;
begin
  Parser := TQJsonParser.Create(TQJsonStoreMode.jsmForwardOnly);
  try
    AStream := TFileStream.Create('huge_data.json', fmOpenRead);
    try
      Parser.TryParseStream(nil, AStream, nil,
        function(AParser: TQJsonParser; AItem: PQJsonNode;
            AStage: TQJsonParseStage; var AParseAction: TQJsonParseAction): Boolean
        begin
          case AStage of
            jpsStartItem:
              if AItem.Name = 'target_field' then
                WriteLn('Found: ', AItem.AsString);  // ← 只取需要的字段
              else
                AParseAction := jpaSkipCurrent;       // ← 跳过不关心的子树
            jpsStartArray:  AParseAction := jpaSkipCurrent; // ← 跳过整个数组
            jpsStartObject: ; // 进入对象
          end;
          Result := True;
        end
      );
    finally
      AStream.Free;
    end;
  finally
    Parser.Free;
  end;
```

**Key callbacks and actions:**

| Stage | When It Fires |
|-------|------|
| `jpsStartItem` | A new value/object/array is about to be parsed |
| `jpsEndItem` | Parsing of the current item completed |
| `jpsStartArray` | Array started |
| `jpsEndArray` | Array ended |
| `jpsStartObject` | Object started |
| `jpsEndObject` | Object ended |

| Action | Effect |
|--------|--------|
| `jpaContinue` | Parse children normally |
| `jpaSkipCurrent` | Skip this item's subtree (fast-forward) |
| `jpaSkipSiblings` | Skip remaining siblings at this level |
| `jpaStop` | Abort parsing entirely |

The `TQJsonDecoder` uses `jsmForwardOnly` internally — this is how `TQSerializer.LoadFromStream<T>` works efficiently. The RTTI reader only reads the fields it needs, skipping everything else.

#### When to Use Forward-Only

| Scenario | Why |
|----------|-----|
| **Huge JSON files** (100 MB+) | No DOM = memory usage is just the parse buffer (~8 KB) |
| **Only need a few fields** | Skip irrelevant subtrees with `jpaSkipCurrent` |
| **Streaming pipeline** | Parse one item, process it, discard, move to next |
| **Real-time parsing** | Low latency — first item available before entire file is read |

#### Forward-Only vs Streaming vs DOM

| Mode | DOM Built? | Memory | Random Access | Use Case |
|------|-----------|--------|---------------|----------|
| `jsmNormal` | Full tree | High (entire payload) | ✅ Yes | Small files, need XPath/navigation |
| `LoadFromStream` (jsmNormal) | Full tree | High | ✅ Yes | File-based DOM access |
| `jsmForwardOnly` | None | ~8 KB buffer | ❌ No | Huge files, known fields |

### When to Use Which Format

| Format | Best For | Notes |
|--------|----------|-------|
| **JSON** | Web APIs, config files, general data exchange | Most mature module (4322 lines) |
| **XML** | Legacy systems, SOAP, XPath queries | Heavier than JSON, supports comments/CDATA |
| **MessagePack** | Binary protocols, performance-critical, compact payload | Smaller than JSON, supports binary data |

### Attribute Quick Reference

| Attribute | Use |
|-----------|-----|
| `[Name('alias')]` | Override serialized field name |
| `[Ignore]` | Skip field during serialization |
| `[Path('/root/item')]` | Map field to a specific JSON/XML path |
| `[DateFormat('yyyy-MM-dd')]` | Custom date format |
| `[Enumerable]` | Mark collection type for serialization |
| `[Dictionary]` | Mark dictionary type |
| `[NumberFormat('#,##0.00')]` | Custom number format |

### Validation — Setup Chain

```pascal
var
  Validator: TQValidator;
begin
  Validator := TQValidator.Create;
  // Chain validators: value must be between 1 and 100 AND match regex
  Validator.AddRange(1, 100);
  Validator.AddRegex('^\d+$');
  if Validator.Validate(SomeValue) then
    // valid
  else
    // Validator.LastError has the message (from qdac.resource)
```

### Profiler — When to Use Which Mode

| Your Goal | Mode | Effort |
|-----------|------|--------|
| "Which function is slowest?" | Sampling (`qdac.profile.sampling`) | Zero code changes |
| "Exactly how long does this function take?" | Label (`qdac.profile`) | Add one `Calc` call |
| "Profile an entire module automatically" | Hook (`qdac.profile.detour`) | Register functions once |

```pascal
// Quick label profiling
var H: IInterface;
begin
  H := TQProfile.Calc('MyFunction');
  // ... your code ...
end; // auto-records on exit

// Quick sampling (no code changes needed)
// Just set: TQSamplingProfiler.Enabled := True;
```

### Compiler Compatibility Notes

- **Delphi XE3+**: Full support
- **Free Pascal 3.3.1+**: Use `{$MODE DELPHIUNICODE}` (enforced by `qdac.inc`)
- **NEXTGEN**: Removed since 10.4 Sydney — `STRING_FIRST_INDEX` handles backward compat
- **Platforms**: Windows (Win32/Win64) primary; POSIX (Linux/macOS) for profiling subset

### Anti-Patterns to Avoid

- ❌ Don't use `qdac.profile.detour` + `qdac.profile` in same process (AV risk in high Delphi versions)
- ❌ Don't expect `.map` file symbol resolution in detour profiler — `FindMapFile` is a stub
- ❌ Don't rely on nested Hook profiling — `CALL rel32` offsets not corrected in trampoline
- ❌ Don't use serialization without published properties — RTTI requires them

## Where to Look

| Need | File |
|------|------|
| JSON parsing/generation | `qdac.json.core.pas` |
| XML parsing/generation | `qdac.xml.core.pas` |
| MessagePack | `qdac.msgpack.core.pas` |
| DOM node tree | `qdac.serialize.core.pas` (`TQNodeBase`) |
| Validation chain | `qdac.validator.pas` |
| Custom attributes | `qdac.attribute.pas` |
| Label profiling | `qdac.profile.pas` |
| Hook profiling | `qdac.profile.detour.pas` |
| Sampling profiling | `qdac.profile.sampling.pas` |
| Error messages | `qdac.resource.pas` |
| Common types | `qdac.common.pas` |

# QDAC 4.0 — Demos / Tests

**Generated:** 2026-05-30
**Path:** `Demos/Delphi/rtl/` — 7 demo/test projects (203 files)

## Structure

```
rtl/
├── json.core.demo/       VCL JSON demo (main.pas, 469 lines, 10 buttons)
├── json.core.test/       JSON DUnit test suite (7 .dpr + .inc shared suites)
├── msgpack.core.test/    MessagePack console tests
├── xml.core.test/        XML console tests
├── profile/              Profiler demos (9 .dpr) + mermaid charting
├── serialization/        VCL serialization demo (stub — main form only)
└── validators/           VCL validator test
```

## Demo Patterns (json.core.demo/main.pas)

| Button | Pattern | Key Code |
|--------|---------|----------|
| Btn1 | **Parse speed benchmark** — Normal vs ForwardOnly vs System.JSON | `ANode.TryParse(AText, jsmForwardOnly)` |
| Btn2 | **CacheStrings mode** — vs Normal vs System.JSON | `TQJsonStringCaches.Current.KeepCaches := true; AJson.TryParse(AJsonText, jsmCacheStrings)` |
| Btn3 | **String cache benchmark** — TQJsonStringCaches vs TDictionary | `TQJsonStringCaches.Current.AddRef(@AList[I])` |
| Btn4 | **RTTI serialization** — record array with attributes → JSON stream → load back | `TQSerializer.Current.SaveToStream<TSubscribeOrders>(...)` / `LoadFromStream<T>(...)` |
| Btn5 | **Manual encoder** — TQJsonEncoder writing raw JSON (StartObject, WritePair, StartArrayPair, WriteValue, WriteComment), then LoadFromStream back to DOM | `TQJsonEncoder.Create(AStream, true, AFormat, TEncoding.utf8, 0)` |
| Btn6 | **Serialize TStrings** → JSON | `TQSerializer.Current.SaveToStream<TStrings>(AList, AStream, 'json')` |
| Btn7 | **Serialize TList<string>** → JSON | `TQSerializer.Current.SaveToStream<TList<string>>(AList, AStream, 'json')` |
| Btn8 | **Serialize TCollection** → JSON | `TQSerializer.Current.SaveToStream<TDemoCollection>(ACollection, AStream, 'json')` |
| Btn9 | **Custom record serializer** — IQCustomSerializer + RegisterType | `TQSerializer.Current.RegisterType(TypeInfo(TCustomRecord), TCustomRecordWriter.Create)` |
| Btn10 | **Base64 stream codec** — binary as stream value in JSON | `ANode.SetStreamCodec(TBase64StreamCodec); ANode.AsStream.LoadFromBuffer(ABytes, 0, Length(ABytes))` |

## Key Usage Examples

### Forward-Only Parsing (Btn1 — no DOM tree, ~8KB buffer)
```pascal
var ANode: TQJsonNode;
ANode := TQJsonNode.Create;
ANode.TryParse(AJsonText, jsmForwardOnly);  // callback-driven, no tree built
// jsmNormal       → full DOM tree
// jsmForwardOnly  → streaming parse (faster, less memory)
// jsmCacheStrings → DOM + string dedup pool
```

### Manual Encoder (Btn5 — write JSON without DOM)
```pascal
var AStream: TStream; AWriter: TQJsonEncoder;
AFormat := TQJsonEncoder.DefaultFormat;
AFormat.Settings := AFormat.Settings + [jesDoFormat];  // pretty-print
AWriter := TQJsonEncoder.Create(AStream, true, AFormat, TEncoding.utf8, 0);
AWriter.StartObject;
AWriter.WritePair('allow', true);
AWriter.WritePair('tid', 1920345);
AWriter.WritePair('name', 'chelly');
AWriter.StartArrayPair('cpu');
AWriter.WriteValue(1978);
AWriter.WriteComment('auto created.');
AWriter.EndArray;
AWriter.EndObject;
```

### DOM + Stream (Btn5)
```pascal
var AJson: TQJsonNode;
AJson := Default(TQJsonNode);
AJson.LoadFromStream(AStream, jsmNormal, nil);
// Now use AJson.AsJson, AJson.AsString, etc.
AJson.Reset;
```

### RTTI Serialization with Attributes (Btn4)
```pascal
type
  [NameFormat(LowerCamel)]
  TSubscribeItem = record
    Code: string;
    Quantity: Integer;
  end;

  [NameFormat(LowerCamel), IncludeProps]
  TSubscribeOrder = record
    [Alias('orderBookmarks')]
    Bookmarks: TOrderBookmarks;
    [Prefix('cl'), IdentFormatAttribute(LowerCamel)]
    Color: TColor;
    [DateTimeFormat(UnixTimeStamp)]
    ConfirmTime: TDateTime;
  end;

var AOrders: TArray<TSubscribeOrder>; AStream: TBytesStream;
AStream := TBytesStream.Create;
TQSerializer.Current.SaveToStream<TSubscribeOrders>(AOrders, AStream, 'json');
AStream.Position := 0;
TQSerializer.Current.LoadFromStream<TSubscribeOrders>(AOrders, AStream);
```

### Custom Record Serializer (Btn9 + FormCreate)
```pascal
// 1. Register a custom reader/writer
TQSerializer.Current.RegisterType(TypeInfo(TCustomRecord), TCustomRecordWriter.Create);

// 2. Implement IQCustomSerializer
TCustomRecordWriter = class(TInterfacedObject, IQCustomSerializer)
  procedure Write(AWriter: IQSerializeWriter; AStack: PQSerializeStackItem; AField: PQSerializeField);
  procedure Read(AReader: IQSerializeReader; AStack: PQSerializeStackItem; AField: PQSerializeField);
end;
```

### Base64 Binary Stream (Btn10)
```pascal
var ANode: TQJsonNode; ABytes: TBytes;
ANode := Default(TQJsonNode);
ANode.SetStreamCodec(TBase64StreamCodec);
ABytes := TEncoding.utf8.GetBytes('This is a demo of Utf8 String');
ANode.AsStream.LoadFromBuffer(ABytes, 0, Length(ABytes));
var S := ANode.AsString;  // "VGhpcyBpcyBhIGRlbW8gb2YgVXRmOCBTdHJpbmc="
ANode.Reset;
```

## Test Patterns

- **Framework**: Delphi DUnit (`TTestCase`) — standalone console test runners per module
- **Shared suites**: `.inc` files — `json.core.normal_test.inc`, `json.core.edge_test.inc` used by 4+ test .dpr projects
- **Validators test**: `TQValidators.Custom<T>('ipv4').Check('1.2.4.8')`, SetDefaultValidator<T>, exception-based error reporting
- **Profile demos**: 9 separate .dpr per mode — label/hook/sampling + stress test + comprehensive test

## Where to Look

| What | File | Lines |
|------|------|-------|
| Speed benchmark (3 modes) | `json.core.demo/main.pas` Btn1 | 134-186 |
| CacheStrings mode | `json.core.demo/main.pas` Btn2 | 188-223 |
| Manual JSON encoder | `json.core.demo/main.pas` Btn5 | 315-350 |
| RTTI serialization | `json.core.demo/main.pas` Btn4,6-8 | 267-395 |
| Custom record serializer | `json.core.demo/main.pas` Btn9+FormCreate | 397-468 |
| Base64 stream codec | `json.core.demo/main.pas` Btn10 | 120-132 |
| JSON normal test suite | `json.core.test/json.core.t.dpr` | ~500 tests |
| JSON serdes test | `json.core.test/json.core.serdestest.dpr` | RTTI roundtrip |
| JSON benchmarks | `json.core.test/json_benchmark.dpr` | Performance |
| Profile: TQProfile.Calc | `profile/test_min_profile.dpr` | Label profiling |
| Profile: Detour | `profile/test_detour_only.dpr` | Hook profiling |
| Profile: Sampling | `profile/qprofile_test_phase3.dpr` | Sampling profiler |
| Profile: Comprehensive | `profile/qprofile_comprehensive_test.dpr` | All modes |
| Validators | `validators/validators.test_main.pas` | Validation chains |

## Notes

- All demos use VCL framework; no FMX or LCL demos present yet
- `serialization/` is a stub (empty form, no button handlers) — good place to add new RTTI serialization demos
- Profile HTML output renders via `mermaid.esm.min/` in `profile/` directory
- `json.core.demo` shows both `AsJson` property setter (DOM parse) and `TryParse` method (mode selection)

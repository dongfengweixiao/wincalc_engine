# wincalc_engine

Dart FFI bindings to the Windows Calculator engine, providing a full-featured calculator library for Dart and Flutter applications.

## Features

- ✅ **Standard Calculator**: Basic arithmetic operations (add, subtract, multiply, divide)
- ✅ **Scientific Calculator**: Advanced functions including trigonometry, logarithms, exponentials
- **Programmer Calculator**: Number base conversions (hex, decimal, octal, binary) and bitwise operations
- **Memory Operations**: Store, recall, add, subtract values in memory slots
- ✅ **History Management**: Track and retrieve calculation history per mode
- **Unit Converter**: Built-in support for various unit conversions
- ✅ **Cross-platform**: Works on Linux, macOS（No Tested）, Windows, Android（No Tested）, and iOS(No Tested)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  wincalc_engine: ^0.0.1
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Calculator

```dart
import 'package:wincalc_engine/wincalc_engine.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

void main() {
  // Create a calculator instance
  final calc = calculator_create();
  calculator_set_standard_mode(calc);

  // Send commands: 5 + 3 =
  calculator_send_command(calc, CMD_5);
  calculator_send_command(calc, CMD_ADD);
  calculator_send_command(calc, CMD_3);
  calculator_send_command(calc, CMD_EQUALS);

  // Get the result
  final buffer = calloc<Char>(256);
  calculator_get_primary_display(calc, buffer, 256);
  final result = buffer.cast<Utf8>().toDartString();
  print('Result: $result'); // Result: 8

  // Clean up
  calloc.free(buffer);
  calculator_destroy(calc);
}
```

### Scientific Functions

```dart
// Square root: √25
calculator_send_command(calc, CMD_2);
calculator_send_command(calc, CMD_5);
calculator_send_command(calc, CMD_SQRT);
calculator_send_command(calc, CMD_EQUALS);
// Result: 5
```

### Memory Operations

```dart
// Store current value to memory
calculator_memory_store(calc);

// Add to memory
calculator_memory_add(calc);

// Recall from memory
calculator_memory_recall(calc);

// Clear memory
calculator_memory_clear(calc);
```

### History Management

```dart
// Get history count
final count = calculator_history_get_count(calc);

// Get history items
for (int i = 0; i < count; i++) {
  final exprBuffer = calloc<Char>(256);
  final resultBuffer = calloc<Char>(256);

  calculator_history_get_expression_at(calc, i, exprBuffer, 256);
  calculator_history_get_result_at(calc, i, resultBuffer, 256);

  final expression = exprBuffer.cast<Utf8>().toDartString();
  final result = resultBuffer.cast<Utf8>().toDartString();
  print('$expression = $result');

  calloc.free(exprBuffer);
  calloc.free(resultBuffer);
}
```

### Programmer Mode

```dart
// Set to programmer mode
calculator_set_programmer_mode(calc);

// Set radix to hexadecimal
calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);

// Get result in different bases
final hexBuffer = calloc<Char>(256);
final decBuffer = calloc<Char>(256);

calculator_get_result_hex(calc, hexBuffer, 256);
calculator_get_result_dec(calc, decBuffer, 256);

print('Hex: ${hexBuffer.cast<Utf8>().toDartString()}');
print('Dec: ${decBuffer.cast<Utf8>().toDartString()}');

calloc.free(hexBuffer);
calloc.free(decBuffer);
```

## Constants and Commands

The library provides named constants for all calculator commands:

- **Digits**: `CMD_0` through `CMD_9`, `CMD_A` through `CMD_F` (hex)
- **Operations**: `CMD_ADD`, `CMD_SUBTRACT`, `CMD_MULTIPLY`, `CMD_DIVIDE`
- **Scientific**: `CMD_SIN`, `CMD_COS`, `CMD_TAN`, `CMD_LN`, `CMD_LOG`, `CMD_SQRT`, `CMD_SQUARE`
- **Memory**: `CMD_MC`, `CMD_MR`, `CMD_MS`, `CMD_MPLUS`, `CMD_MMINUS`
- **And many more...**

## Platform Support

This package uses native C++ libraries that are compiled automatically when you build your application. The underlying calculator engine is based on the open-source Windows Calculator.

### Supported Platforms

- ✅ Linux
- ✅ macOS（No Tested）
- ✅ Windows
- ✅ Android（No Tested）
- ✅ iOS（No Tested）

## Additional Information

This library provides FFI bindings to the [Windows Calculator](https://github.com/microsoft/calculator) engine, offering the same calculation reliability and features used by millions of Windows users.

For issues, feature requests, or contributions, please visit our [GitHub repository](https://github.com/dongfengweixiao/wincalc_engine).

## License

MIT License - see [LICENSE](LICENSE) for details.

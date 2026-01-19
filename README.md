# wincalc_engine

Dart FFI bindings to the Windows Calculator engine, providing a full-featured calculator library for Dart and Flutter applications.

## Features

- ✅ **Standard Calculator**: Basic arithmetic operations (add, subtract, multiply, divide)
- ✅ **Scientific Calculator**: Advanced functions including trigonometry, logarithms, exponentials
- ✅ **Programmer Calculator**: Number base conversions (hex, decimal, octal, binary) and bitwise operations
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

### Android Setup

**Important**: This package requires `libc++_shared.so` to run on Android. You need to configure your Android app to include this library.

#### Step 1: Set ANDROID_NDK_HOME Environment Variable

Set the `ANDROID_NDK_HOME` environment variable to point to your NDK directory.

**Windows**:
```powershell
# Temporary (current session only)
$env:ANDROID_NDK_HOME="C:\Users\{YOUR_USERNAME}\AppData\Local\Android\Sdk\ndk\28.2.13676358"

# Permanent (add to system environment variables)
# 1. Press Win+R, type "sysdm.cpl", press Enter
# 2. Go to Advanced > Environment Variables
# 3. Add new system variable:
#    Variable name: ANDROID_NDK_HOME
#    Variable value: C:\Users\{YOUR_USERNAME}\AppData\Local\Android\Sdk\ndk\28.2.13676358
```

**Linux/macOS**:
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANDROID_NDK_HOME=~/Android/Sdk/ndk/28.2.13676358

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

#### Step 2: Configure build.gradle.kts

Add the following configuration to your `android/app/build.gradle.kts`:

```kotlin
android {
  sourceSets {
    named("main") {
      jniLibs.srcDir("src/jniLibs")
    }
  }
}

// Task: Automatically copy libc++_shared.so from the NDK directory
tasks.register("copyNdkLibs") {
    val jniLibsDir = file("src/main/jniLibs")

    doFirst {
        val abis = listOf("armeabi-v7a", "arm64-v8a", "riscv64", "x86", "x86_64")
        val abiToLibDir = mapOf(
            "armeabi-v7a" to "arm-linux-androideabi",
            "arm64-v8a" to "aarch64-linux-android",
            "x86" to "i686-linux-android",
            "x86_64" to "x86_64-linux-android",
            "riscv64" to "riscv64-linux-android"
        )

        val ndkDir: String? = System.getenv("ANDROID_NDK_HOME")
            ?: System.getenv("NDK_HOME")
            ?: run {
                val propsFile = rootProject.file("local.properties")
                if (propsFile.exists()) {
                    val properties = java.util.Properties()
                    propsFile.inputStream().use { properties.load(it) }
                    properties.getProperty("ndk.dir")
                } else null
            }

        if (ndkDir == null || !file(ndkDir).exists()) {
            println("Warning: NDK directory not found.")
            return@doFirst
        }

        val toolchainDir = file("${ndkDir}/toolchains/llvm/prebuilt")
            .listFiles()?.firstOrNull {
                it.name.contains("linux") || it.name.contains("darwin") || it.name.contains("windows")
            }

        if (toolchainDir == null) {
            println("Warning: Cannot find NDK toolchain directory")
            return@doFirst
        }

        abis.forEach { abi ->
            val libDir = abiToLibDir[abi] ?: abi
            val sourceDir = file("${toolchainDir}/sysroot/usr/lib/${libDir}")
            val targetDir = file("${jniLibsDir}/${abi}")

            val libcxx = file("${sourceDir}/libc++_shared.so")
            if (libcxx.exists()) {
                targetDir.mkdirs()
                copy {
                    from(libcxx)
                    into(targetDir)
                }
            }
        }
    }
}

// Task: Clean up copied NDK library files
tasks.register("cleanCopiedNdkLibs") {
    val jniLibsDir = file("src/main/jniLibs")

    doLast {
        if (jniLibsDir.exists()) {
            val abis = listOf("armeabi-v7a", "arm64-v8a", "riscv64", "x86", "x86_64")
            var deletedCount = 0

            abis.forEach { abi ->
                val libcxx = file("${jniLibsDir}/${abi}/libc++_shared.so")
                if (libcxx.exists()) {
                    libcxx.delete()
                    println("Deleted: ${libcxx.absolutePath}")
                    deletedCount++

                    // If the directory is empty, delete it.
                    val abiDir = file("${jniLibsDir}/${abi}")
                    if (abiDir.listFiles()?.isEmpty() == true) {
                        abiDir.delete()
                        println("Deleted empty directory: ${abiDir.absolutePath}")
                    }
                }
            }

            // If the jniLibs directory is empty, remove it.
            if (jniLibsDir.listFiles()?.isEmpty() == true) {
                jniLibsDir.delete()
                println("Deleted empty jniLibs directory: ${jniLibsDir.absolutePath}")
            }

            if (deletedCount > 0) {
                println("Cleaned $deletedCount copied NDK library file(s)")
            }
        }
    }
}

// Make sure the clean task also removes the duplicated NDK libraries.
tasks.named("clean") {
    dependsOn("cleanCopiedNdkLibs")
}

// Ensure that it is executed before the pre-build task
tasks.named("preBuild") {
    dependsOn("copyNdkLibs")
}
```

This configuration will automatically copy `libc++_shared.so` from your Android NDK to your app's jniLibs directory during the build process.

## Additional Information

This library provides FFI bindings to the [Windows Calculator](https://github.com/microsoft/calculator) engine, offering the same calculation reliability and features used by millions of Windows users.

For issues, feature requests, or contributions, please visit our [GitHub repository](https://github.com/dongfengweixiao/wincalc_engine).

## License

MIT License - see [LICENSE](LICENSE) for details.

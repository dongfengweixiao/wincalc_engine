import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

/// Helper function to get primary display result from native buffer
String getDisplayResult(Pointer<CalculatorInstance> instance) {
  const bufferSize = 256;
  final buffer = calloc<Char>(bufferSize);
  try {
    calculator_get_primary_display(instance, buffer, bufferSize);
    return buffer.cast<Utf8>().toDartString();
  } finally {
    calloc.free(buffer);
  }
}

/// Helper function to get expression string
String getExpression(Pointer<CalculatorInstance> instance) {
  const bufferSize = 256;
  final buffer = calloc<Char>(bufferSize);
  try {
    calculator_get_expression(instance, buffer, bufferSize);
    return buffer.cast<Utf8>().toDartString();
  } finally {
    calloc.free(buffer);
  }
}

/// Helper function to get result in specific radix
String getResultInRadix(Pointer<CalculatorInstance> instance, int radix) {
  const bufferSize = 256;
  final buffer = calloc<Char>(bufferSize);
  try {
    switch (radix) {
      case 16:
        calculator_get_result_hex(instance, buffer, bufferSize);
        break;
      case 10:
        calculator_get_result_dec(instance, buffer, bufferSize);
        break;
      case 8:
        calculator_get_result_oct(instance, buffer, bufferSize);
        break;
      case 2:
        calculator_get_result_bin(instance, buffer, bufferSize);
        break;
      default:
        throw ArgumentError('Invalid radix: $radix');
    }
    return buffer.cast<Utf8>().toDartString();
  } finally {
    calloc.free(buffer);
  }
}

/// Helper function to get binary display (64-bit)
String getBinaryDisplay(Pointer<CalculatorInstance> instance) {
  const bufferSize = 65;
  final buffer = calloc<Char>(bufferSize);
  try {
    calculator_get_binary_display(instance, buffer, bufferSize);
    return buffer.cast<Utf8>().toDartString();
  } finally {
    calloc.free(buffer);
  }
}

/// Helper function to send a digit command (0-9)
void sendDigit(Pointer<CalculatorInstance> instance, int digit) {
  final command = switch (digit) {
    0 => CMD_0,
    1 => CMD_1,
    2 => CMD_2,
    3 => CMD_3,
    4 => CMD_4,
    5 => CMD_5,
    6 => CMD_6,
    7 => CMD_7,
    8 => CMD_8,
    9 => CMD_9,
    _ => throw ArgumentError('Invalid digit: $digit'),
  };
  calculator_send_command(instance, command);
}

/// Helper function to send a number as individual digits
void sendNumber(Pointer<CalculatorInstance> instance, num number) {
  final str = number.toString();
  for (int i = 0; i < str.length; i++) {
    final char = str[i];
    if (char == '.') {
      calculator_send_command(instance, CMD_DECIMAL);
    } else if (char == '-') {
      calculator_send_command(instance, CMD_NEGATE);
    } else {
      sendDigit(instance, int.parse(char));
    }
  }
}

/// Helper function to send a hex digit (0-F)
void sendHexDigit(Pointer<CalculatorInstance> instance, int digit) {
  final command = switch (digit) {
    0 => CMD_0,
    1 => CMD_1,
    2 => CMD_2,
    3 => CMD_3,
    4 => CMD_4,
    5 => CMD_5,
    6 => CMD_6,
    7 => CMD_7,
    8 => CMD_8,
    9 => CMD_9,
    10 => CMD_A,
    11 => CMD_B,
    12 => CMD_C,
    13 => CMD_D,
    14 => CMD_E,
    15 => CMD_F,
    _ => throw ArgumentError('Invalid hex digit: $digit'),
  };
  calculator_send_command(instance, command);
}

/// Helper function to send a hex number
void sendHexNumber(Pointer<CalculatorInstance> instance, int number) {
  final hexStr = number.toRadixString(16).toUpperCase();
  for (int i = 0; i < hexStr.length; i++) {
    final digit = int.parse(hexStr[i], radix: 16);
    sendHexDigit(instance, digit);
  }
}

/// Helper function to calculate CMD_BINPOS value
int CMD_BINPOS(int n) => 700 + n;

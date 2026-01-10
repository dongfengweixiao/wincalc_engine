import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

/// Helper function to get string result from native buffer
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

/// Helper function to send a digit command
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

void main() {
  late Pointer<CalculatorInstance> calc;

  setUp(() {
    calc = calculator_create();
    calculator_set_programmer_mode(calc);
  });

  tearDown(() {
    calculator_destroy(calc);
  });

  group('CalcWordType Enum', () {
    test('CalcWordType enum values are correct', () {
      expect(CalcWordType.CALC_WORD_QWORD.value, equals(0));
      expect(CalcWordType.CALC_WORD_DWORD.value, equals(1));
      expect(CalcWordType.CALC_WORD_WORD.value, equals(2));
      expect(CalcWordType.CALC_WORD_BYTE.value, equals(3));
    });

    test('CalcWordType fromValue converts correctly', () {
      expect(CalcWordType.fromValue(0), equals(CalcWordType.CALC_WORD_QWORD));
      expect(CalcWordType.fromValue(1), equals(CalcWordType.CALC_WORD_DWORD));
      expect(CalcWordType.fromValue(2), equals(CalcWordType.CALC_WORD_WORD));
      expect(CalcWordType.fromValue(3), equals(CalcWordType.CALC_WORD_BYTE));
    });

    test('CalcWordType fromValue throws on invalid value', () {
      expect(() => CalcWordType.fromValue(4), throwsArgumentError);
      expect(() => CalcWordType.fromValue(-1), throwsArgumentError);
    });
  });

  group('Word Width Management', () {
    test('default word width is QWORD', () {
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_QWORD.value));
    });

    test('set word width to DWORD', () {
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_DWORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_DWORD.value));
    });

    test('set word width to WORD', () {
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_WORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_WORD.value));
    });

    test('set word width to BYTE', () {
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_BYTE.value));
    });

    test('can switch between different word widths', () {
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_DWORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_DWORD.value));

      calculator_set_word_width(calc, CalcWordType.CALC_WORD_QWORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_QWORD.value));

      calculator_set_word_width(calc, CalcWordType.CALC_WORD_WORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_WORD.value));

      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_BYTE.value));
    });

    test('word width commands work via send_command', () {
      calculator_send_command(calc, CMD_DWORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_DWORD.value));

      calculator_send_command(calc, CMD_WORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_WORD.value));

      calculator_send_command(calc, CMD_BYTE);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_BYTE.value));

      calculator_send_command(calc, CMD_QWORD);
      expect(calculator_get_word_width(calc), equals(CalcWordType.CALC_WORD_QWORD.value));
    });
  });

  group('Carry Flag Management', () {
    test('default carry flag is 0', () {
      expect(calculator_get_carry_flag(calc), equals(0));
    });

    test('set carry flag to 1', () {
      calculator_set_carry_flag(calc, 1);
      expect(calculator_get_carry_flag(calc), equals(1));
    });

    test('set carry flag to 0', () {
      calculator_set_carry_flag(calc, 1);
      expect(calculator_get_carry_flag(calc), equals(1));

      calculator_set_carry_flag(calc, 0);
      expect(calculator_get_carry_flag(calc), equals(0));
    });

    test('carry flag is clamped to 0 or 1', () {
      calculator_set_carry_flag(calc, 5);
      expect(calculator_get_carry_flag(calc), equals(1));

      calculator_set_carry_flag(calc, 100);
      expect(calculator_get_carry_flag(calc), equals(1));

      calculator_set_carry_flag(calc, 0);
      expect(calculator_get_carry_flag(calc), equals(0));
    });
  });

  group('Bitwise AND Operation', () {
    test('0xFF & 0x0F = 0x0F', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0xFF);
      calculator_send_command(calc, CMD_AND);
      sendHexNumber(calc, 0x0F);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('F'));
    });

    test('0b1010 & 0b1100 = 0b1000', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_BINARY);
      sendNumber(calc, 1010);
      calculator_send_command(calc, CMD_AND);
      sendNumber(calc, 1100);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 2), equals('1000'));
    });

    test('255 & 15 = 15', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);
      sendNumber(calc, 255);
      calculator_send_command(calc, CMD_AND);
      sendNumber(calc, 15);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), equals('15'));
    });
  });

  group('Bitwise OR Operation', () {
    test('0xF0 | 0x0F = 0xFF', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0xF0);
      calculator_send_command(calc, CMD_OR);
      sendHexNumber(calc, 0x0F);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('FF'));
    });

    test('0b1010 | 0b1100 = 0b1110', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_BINARY);
      sendNumber(calc, 1010);
      calculator_send_command(calc, CMD_OR);
      sendNumber(calc, 1100);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 2), equals('1110'));
    });
  });

  group('Bitwise XOR Operation', () {
    test('0xFF ^ 0xFF = 0', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0xFF);
      calculator_send_command(calc, CMD_XOR);
      sendHexNumber(calc, 0xFF);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('0'));
    });

    test('0b1010 ^ 0b1100 = 0b0110', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_BINARY);
      sendNumber(calc, 1010);
      calculator_send_command(calc, CMD_XOR);
      sendNumber(calc, 1100);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 2), equals('110'));
    });
  });

  group('Bitwise NOT Operation', () {
    test('NOT 0x0F = 0xFFFFFFF0 (in DWORD mode)', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_DWORD);
      sendHexNumber(calc, 0x0F);
      calculator_send_command(calc, CMD_NOT);

      final result = getResultInRadix(calc, 16).toUpperCase();
      // Should be FFFFF0 or similar (32-bit complement)
      expect(result, contains('F0'));
      expect(result, isNot(contains('E')));
    });

    test('NOT 0b1010 = 0b...11110101', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_BINARY);
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      sendNumber(calc, 1010);
      calculator_send_command(calc, CMD_NOT);

      final result = getResultInRadix(calc, 2);
      // Remove spaces for comparison
      final resultNoSpaces = result.replaceAll(' ', '');
      expect(resultNoSpaces, endsWith('11110101'));
    });
  });

  group('Bit Shift Operations', () {
    test('Left shift: 8 << 2 = 32', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);
      sendNumber(calc, 8);
      calculator_send_command(calc, CMD_LSH);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), equals('32'));
    });

    test('Right shift: 32 >> 3 = 4', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);
      sendNumber(calc, 32);
      calculator_send_command(calc, CMD_RSH);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), equals('4'));
    });

    test('Left shift in hex: 0x10 << 4 = 0x100', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0x10);
      calculator_send_command(calc, CMD_LSH);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('100'));
    });
  });

  group('Rotate Operations', () {
    test('Rotate left operation exists', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_ROL);
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_EQUALS);

      // ROL operation should execute without error
      expect(calculator_has_error(calc), equals(0));
    });

    test('Rotate right operation exists', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_ROR);
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_EQUALS);

      // ROR operation should execute without error
      expect(calculator_has_error(calc), equals(0));
    });
  });

  group('Radix Display', () {
    test('display result in different radices', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);
      sendNumber(calc, 255);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 10), contains('255'));
      expect(getResultInRadix(calc, 16).toUpperCase(), contains('FF'));
      expect(getResultInRadix(calc, 8), contains('377'));

      final binResult = getResultInRadix(calc, 2);
      final binResultNoSpaces = binResult.replaceAll(' ', '');
      expect(binResultNoSpaces, contains('11111111'));
    });

    test('hexadecimal input with letters A-F', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexDigit(calc, 1); // 1
      sendHexDigit(calc, 10); // A
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), contains('1A'));
    });

    test('hexadecimal calculation', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0xA); // 10
      calculator_send_command(calc, CMD_ADD);
      sendHexNumber(calc, 0xB); // 11
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('15')); // 21 decimal
    });
  });

  group('Binary Display for Bit Panel', () {
    test('binary display returns 64 characters', () {
      sendNumber(calc, 255);
      calculator_send_command(calc, CMD_EQUALS);

      final binary = getBinaryDisplay(calc);
      expect(binary.length, equals(64));
      expect(binary, matches(RegExp(r'^[01]{64}$')));
    });

    test('binary display shows correct bits for 255', () {
      sendNumber(calc, 255);
      calculator_send_command(calc, CMD_EQUALS);

      final binary = getBinaryDisplay(calc);
      // Last 8 bits should be 11111111
      expect(binary.substring(56), equals('11111111'));
    });

    test('binary display shows correct bits for 1', () {
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_EQUALS);

      final binary = getBinaryDisplay(calc);
      // Last bit should be 1
      expect(binary.substring(63), equals('1'));
      expect(binary.substring(0, 63), contains('0'));
    });
  });

  group('Word Width Impact on Calculations', () {
    test('BYTE mode limits max value to 255', () {
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);

      sendNumber(calc, 255); // 0xFF - max value for BYTE
      calculator_send_command(calc, CMD_EQUALS);

      final result = getDisplayResult(calc);
      // In BYTE mode, 255 should display correctly
      expect(int.tryParse(result?.replaceAll(',', '') ?? '0'), greaterThanOrEqualTo(0));
      expect(int.tryParse(result?.replaceAll(',', '') ?? '0'), lessThanOrEqualTo(255));
    });

    test('WORD mode limits max value to 65535', () {
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_WORD);
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_DECIMAL);

      sendNumber(calc, 65535); // 0xFFFF - max value for WORD
      calculator_send_command(calc, CMD_EQUALS);

      final result = getDisplayResult(calc);
      // In WORD mode, 65535 should display correctly
      expect(int.tryParse(result?.replaceAll(',', '') ?? '0'), greaterThanOrEqualTo(0));
      expect(int.tryParse(result?.replaceAll(',', '') ?? '0'), lessThanOrEqualTo(65535));
    });
  });

  group('Bit Position Commands', () {
    test('toggle bit position 0', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_BINPOS(0)); // Toggle LSB

      final result = getDisplayResult(calc);
      expect(result, equals('1'));
    });

    test('toggle bit position 3', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_BINPOS(3)); // Toggle bit 3 (value 8)

      final result = getDisplayResult(calc);
      expect(result, equals('8'));
    });

    test('multiple bit toggles', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_BINPOS(0)); // Set bit 0 -> 1
      calculator_send_command(calc, CMD_BINPOS(2)); // Set bit 2 -> 4
      calculator_send_command(calc, CMD_BINPOS(3)); // Set bit 3 -> 8

      final result = getDisplayResult(calc);
      expect(result, equals('13')); // 1 + 4 + 8 = 13
    });
  });

  group('Combined Bitwise Operations', () {
    test('(0xFF & 0xF0) | 0x0F = 0xFF', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0xFF);
      calculator_send_command(calc, CMD_AND);
      sendHexNumber(calc, 0xF0);
      calculator_send_command(calc, CMD_OR);
      sendHexNumber(calc, 0x0F);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('FF'));
    });

    test('~0x0F & 0xFF = 0xF0', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      calculator_set_word_width(calc, CalcWordType.CALC_WORD_BYTE);
      sendHexNumber(calc, 0x0F);
      calculator_send_command(calc, CMD_NOT);
      calculator_send_command(calc, CMD_AND);
      sendHexNumber(calc, 0xFF);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), equals('F0'));
    });

    test('(0x55 << 2) & 0xFF = 0x54', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);
      sendHexNumber(calc, 0x55);
      calculator_send_command(calc, CMD_LSH);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_AND);
      sendHexNumber(calc, 0xFF);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getResultInRadix(calc, 16).toUpperCase(), contains('54'));
    });
  });

  group('Radix Type Enum', () {
    test('CalcRadixType enum values are correct', () {
      expect(CalcRadixType.CALC_RADIX_DECIMAL.value, equals(10));
      expect(CalcRadixType.CALC_RADIX_HEX.value, equals(16));
      expect(CalcRadixType.CALC_RADIX_OCTAL.value, equals(8));
      expect(CalcRadixType.CALC_RADIX_BINARY.value, equals(2));
    });

    test('CalcRadixType fromValue converts correctly', () {
      expect(CalcRadixType.fromValue(10), equals(CalcRadixType.CALC_RADIX_DECIMAL));
      expect(CalcRadixType.fromValue(16), equals(CalcRadixType.CALC_RADIX_HEX));
      expect(CalcRadixType.fromValue(8), equals(CalcRadixType.CALC_RADIX_OCTAL));
      expect(CalcRadixType.fromValue(2), equals(CalcRadixType.CALC_RADIX_BINARY));
    });
  });
}

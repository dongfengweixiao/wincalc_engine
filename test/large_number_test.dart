import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

/// Helper function to get string result from native buffer
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

void main() {
  late Pointer<CalculatorInstance> calc;

  setUp(() {
    calc = calculator_create();
    calculator_set_programmer_mode(calc);
  });

  tearDown(() {
    calculator_destroy(calc);
  });

  group('Large Number Test - Issue Report', () {
    test('0xFFFFFFFFFFFFFFFF (64-bit max) should not return scientific notation', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);

      // Input: FFFF FFFF FFFF FFFF (16 F's = 64 bits)
      for (int i = 0; i < 16; i++) {
        sendHexDigit(calc, 15); // F
      }

      final hexResult = getResultInRadix(calc, 16);
      print('HEX: "$hexResult"');

      final decResult = getResultInRadix(calc, 10);
      print('DEC: "$decResult"');

      final octResult = getResultInRadix(calc, 8);
      print('OCT: "$octResult"');

      final binResult = getResultInRadix(calc, 2);
      print('BIN: "$binResult"');

      // Check for scientific notation indicators
      expect(decResult, isNot(contains('e')));
      expect(decResult, isNot(contains('E')));
      expect(decResult, isNot(contains('^')));

      expect(octResult, isNot(contains('e')));
      expect(octResult, isNot(contains('E')));
      expect(octResult, isNot(contains('^')));

      expect(binResult, isNot(contains('e')));
      expect(binResult, isNot(contains('E')));
      expect(binResult, isNot(contains('^')));
    });

    test('0x7FFFFFFFFFFFFFFF (max positive signed 64-bit)', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);

      // Input: 7FFF FFFF FFFF FFFF
      sendHexDigit(calc, 7);
      for (int i = 0; i < 15; i++) {
        sendHexDigit(calc, 15); // F
      }

      final decResult = getResultInRadix(calc, 10);
      print('DEC (max positive): "$decResult"');

      // Should not be scientific notation
      expect(decResult, isNot(contains('e')));
      expect(decResult, isNot(contains('E')));

      // Expected value: 9,223,372,036,854,775,807
      expect(decResult, contains('9223372036854775807'));
    });

    test('0x8000000000000000 (min negative signed 64-bit)', () {
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);

      // Input: 8000 0000 0000 0000
      sendHexDigit(calc, 8);
      for (int i = 0; i < 15; i++) {
        sendHexDigit(calc, 0);
      }

      final decResult = getResultInRadix(calc, 10);
      print('DEC (min negative): "$decResult"');

      // In programmer mode, this should display as negative
      // Expected: -9,223,372,036,854,775,808
      expect(decResult, contains('-'));
      expect(decResult, contains('9223372036854775808'));
    });
  });
}

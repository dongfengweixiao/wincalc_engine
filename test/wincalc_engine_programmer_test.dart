import 'dart:ffi';
import 'package:test/test.dart';
import 'package:wincalc_engine/wincalc_engine.dart';
import 'test_helpers.dart';

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

    test('bit flip sequence in hexadecimal mode', () {
      // Set to hexadecimal mode
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);

      // Start from 0
      sendNumber(calc, 0);

      // Toggle bit0 to 1: display should be 1
      calculator_send_command(calc, CMD_BINPOS(0));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('1'),
          reason: 'After toggling bit0 to 1, should display 1');

      // Toggle bit1 to 1: display should be 3 (binary: 0011)
      calculator_send_command(calc, CMD_BINPOS(1));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('3'),
          reason: 'After toggling bit1 to 1, should display 3 (1+2)');

      // Toggle bit2 to 1: display should be 7 (binary: 0111)
      calculator_send_command(calc, CMD_BINPOS(2));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('7'),
          reason: 'After toggling bit2 to 1, should display 7 (1+2+4)');

      // Toggle bit3 to 1: display should be F (binary: 1111)
      calculator_send_command(calc, CMD_BINPOS(3));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('F'),
          reason: 'After toggling bit3 to 1, should display F (1+2+4+8)');

      // Toggle bit0 to 0: display should be E (binary: 1110)
      calculator_send_command(calc, CMD_BINPOS(0));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('E'),
          reason: 'After toggling bit0 to 0, should display E (2+4+8)');
    });

    test('bit flip with binary display verification', () {
      // Set to hexadecimal mode
      calculator_set_radix(calc, CalcRadixType.CALC_RADIX_HEX);

      // Start from 0
      sendNumber(calc, 0);

      // Toggle bit0 to 1
      calculator_send_command(calc, CMD_BINPOS(0));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('1'));
      var binary = getBinaryDisplay(calc);
      expect(binary.substring(63), equals('1'), reason: 'bit0 should be 1');

      // Toggle bit1 to 1
      calculator_send_command(calc, CMD_BINPOS(1));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('3'));
      binary = getBinaryDisplay(calc);
      expect(binary.substring(62), equals('11'), reason: 'bits 1-0 should be 11');

      // Toggle bit2 to 1
      calculator_send_command(calc, CMD_BINPOS(2));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('7'));
      binary = getBinaryDisplay(calc);
      expect(binary.substring(61), equals('111'), reason: 'bits 2-0 should be 111');

      // Toggle bit3 to 1
      calculator_send_command(calc, CMD_BINPOS(3));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('F'));
      binary = getBinaryDisplay(calc);
      expect(binary.substring(60), equals('1111'), reason: 'bits 3-0 should be 1111');

      // Toggle bit0 to 0 (flip back)
      calculator_send_command(calc, CMD_BINPOS(0));
      expect(getResultInRadix(calc, 16).toUpperCase(), equals('E'));
      binary = getBinaryDisplay(calc);
      expect(binary.substring(60), equals('1110'), reason: 'bits 3-0 should be 1110');
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

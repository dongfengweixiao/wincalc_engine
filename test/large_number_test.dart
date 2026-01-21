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
      expect(decResult, contains('9,223,372,036,854,775,807'));
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
      expect(decResult, contains('9,223,372,036,854,775,808'));
    });
  });
}

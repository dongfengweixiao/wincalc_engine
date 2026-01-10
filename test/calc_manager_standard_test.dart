import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';
import 'package:calc_manager/calc_manager.dart';

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

void main() {
  late Pointer<CalculatorInstance> calc;

  setUp(() {
    calc = calculator_create();
    calculator_set_standard_mode(calc);
  });

  tearDown(() {
    calculator_destroy(calc);
  });

  group('Basic Arithmetic - Addition', () {
    test('5 + 3 = 8', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '8');
    });

    test('0 + 0 = 0', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '0');
    });

    test('100 + 200 = 300', () {
      sendNumber(calc, 100);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 200);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '300');
    });

    test('(-5) + 3 = -2', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '-2');
    });

    test('chained additions: 1 + 2 + 3 + 4 = 10', () {
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '10');
    });
  });

  group('Basic Arithmetic - Subtraction', () {
    test('10 - 4 = 6', () {
      sendNumber(calc, 10);
      calculator_send_command(calc, CMD_SUBTRACT);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '6');
    });

    test('5 - 7 = -2', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_SUBTRACT);
      sendNumber(calc, 7);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '-2');
    });

    test('0 - 5 = -5', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_SUBTRACT);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '-5');
    });

    test('(-5) - (-3) = -2', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_SUBTRACT);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '-2');
    });

    test('chained subtractions: 20 - 5 - 3 = 12', () {
      sendNumber(calc, 20);
      calculator_send_command(calc, CMD_SUBTRACT);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_SUBTRACT);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '12');
    });
  });

  group('Basic Arithmetic - Multiplication', () {
    test('7 * 6 = 42', () {
      sendNumber(calc, 7);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 6);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '42');
    });

    test('0 * 100 = 0', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 100);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '0');
    });

    test('(-5) * 4 = -20', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '-20');
    });

    test('(-3) * (-4) = 12', () {
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '12');
    });

    test('chained multiplications: 2 * 3 * 4 = 24', () {
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '24');
    });
  });

  group('Basic Arithmetic - Division', () {
    test('15 / 3 = 5', () {
      sendNumber(calc, 15);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '5');
    });

    test('1 / 2 = 0.5', () {
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '0.5');
    });

    test('10 / 4 = 2.5', () {
      sendNumber(calc, 10);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '2.5');
    });

    test('(-8) / 2 = -4', () {
      sendNumber(calc, 8);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '-4');
    });

    test('0 / 5 = 0', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '0');
    });

    test('chained divisions: 100 / 2 / 5 = 10', () {
      sendNumber(calc, 100);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '10');
    });
  });

  group('Reciprocal (1/x)', () {
    test('reciprocal of 4 = 0.25', () {
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), '0.25');
    });

    test('reciprocal of 2 = 0.5', () {
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), '0.5');
    });

    test('reciprocal of 1 = 1', () {
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), '1');
    });

    test('reciprocal of 0.5 = 2', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), '2');
    });

    test('reciprocal of -5 = -0.2', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), contains('-0.2'));
    });

    test('double reciprocal: reciprocal(reciprocal(5)) = 5', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_RECIPROCAL);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), contains('5'));
    });

    test('reciprocal with expression: (2 + 3) reciprocal = 0.2', () {
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), '0.2');
    });
  });

  group('Square (x²)', () {
    test('5² = 25', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '25');
    });

    test('10² = 100', () {
      sendNumber(calc, 10);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '100');
    });

    test('0² = 0', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '0');
    });

    test('(-5)² = 25', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '25');
    });

    test('0.5² = 0.25', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '0.25');
    });

    test('square with expression: (3 + 4)² = 49', () {
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '49');
    });
  });

  group('Square Root (√x)', () {
    test('√9 = 3', () {
      sendNumber(calc, 9);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '3');
    });

    test('√25 = 5', () {
      sendNumber(calc, 25);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '5');
    });

    test('√0 = 0', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '0');
    });

    test('√1 = 1', () {
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '1');
    });

    test('√0.25 = 0.5', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 2);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '0.5');
    });

    test('√2 ≈ 1.41421356', () {
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_SQRT);

      final result = getDisplayResult(calc);
      expect(double.tryParse(result), closeTo(1.41421356, 0.00001));
    });

    test('double sqrt: √(√16) = 2', () {
      sendNumber(calc, 16);
      calculator_send_command(calc, CMD_SQRT);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '2');
    });

    test('sqrt and square are inverse: √(5²) = 5', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_SQUARE);
      calculator_send_command(calc, CMD_SQRT);

      expect(getDisplayResult(calc), '5');
    });

    test('square and sqrt are inverse: (√9)² = 9', () {
      sendNumber(calc, 9);
      calculator_send_command(calc, CMD_SQRT);
      calculator_send_command(calc, CMD_SQUARE);

      expect(getDisplayResult(calc), '9');
    });
  });

  group('Combined Operations', () {
    test('(5 + 3) * 2 = 16', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '16');
    });

    test('10 / 2 + 3 = 8', () {
      sendNumber(calc, 10);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '8');
    });

    test('(√16 + √9) = 7', () {
      sendNumber(calc, 16);
      calculator_send_command(calc, CMD_SQRT);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 9);
      calculator_send_command(calc, CMD_SQRT);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '7');
    });

    test('(3 + 4)² / √49 = 7', () {
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_EQUALS);
      calculator_send_command(calc, CMD_SQUARE);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 49);
      calculator_send_command(calc, CMD_SQRT);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '7');
    });

    test('1/(2+3) = 0.2', () {
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_EQUALS);
      calculator_send_command(calc, CMD_RECIPROCAL);

      expect(getDisplayResult(calc), '0.2');
    });
  });

  group('Decimal Numbers', () {
    test('3.14 + 2.86 = 6', () {
      sendNumber(calc, 3);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 1);
      sendNumber(calc, 4);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 8);
      sendNumber(calc, 6);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '6');
    });

    test('0.1 * 0.2 = 0.02', () {
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_MULTIPLY);
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_EQUALS);

      final result = getDisplayResult(calc);
      expect(double.tryParse(result), closeTo(0.02, 0.0001));
    });

    test('10.5 / 2.5 = 4.2', () {
      sendNumber(calc, 10);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 2);
      calculator_send_command(calc, CMD_DECIMAL);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_EQUALS);

      final result = getDisplayResult(calc);
      expect(double.tryParse(result), closeTo(4.2, 0.0001));
    });
  });

  group('Clear Functionality', () {
    test('clear after entry', () {
      sendNumber(calc, 123);
      calculator_send_command(calc, CMD_CLEAR);
      expect(getDisplayResult(calc), '0');
    });

    test('clear and new calculation', () {
      sendNumber(calc, 10);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_CLEAR);
      sendNumber(calc, 20);
      calculator_send_command(calc, CMD_ADD);
      sendNumber(calc, 30);
      calculator_send_command(calc, CMD_EQUALS);

      expect(getDisplayResult(calc), '50');
    });
  });

  group('Error States', () {
    test('division by zero should show error', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_EQUALS);

      expect(calculator_has_error(calc) != 0, isTrue);
    });

    test('clear error state with clear entry', () {
      sendNumber(calc, 5);
      calculator_send_command(calc, CMD_DIVIDE);
      sendNumber(calc, 0);
      calculator_send_command(calc, CMD_EQUALS);

      expect(calculator_has_error(calc) != 0, isTrue);

      calculator_send_command(calc, CMD_CENTR);
      expect(calculator_has_error(calc) != 0, isFalse);
    });

    test('√(-1) should show error', () {
      sendNumber(calc, 1);
      calculator_send_command(calc, CMD_NEGATE);
      calculator_send_command(calc, CMD_SQRT);

      expect(calculator_has_error(calc) != 0, isTrue);
    });
  });

  group('Input Validation', () {
    test('isInputEmpty returns true initially', () {
      expect(calculator_is_input_empty(calc) != 0, isTrue);
    });

    test('isInputEmpty returns false after entering digit', () {
      sendDigit(calc, 5);
      expect(calculator_is_input_empty(calc) != 0, isFalse);
    });

    test('isInputEmpty returns true after clear', () {
      sendDigit(calc, 5);
      calculator_send_command(calc, CMD_CLEAR);
      expect(calculator_is_input_empty(calc) != 0, isTrue);
    });
  });
}

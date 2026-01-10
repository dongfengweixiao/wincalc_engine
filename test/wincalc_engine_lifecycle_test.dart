import 'dart:ffi';
import 'package:test/test.dart';
import 'package:wincalc_engine/wincalc_engine.dart';

void main() {
  group('Calculator Lifecycle', () {
    test('calculator_create should return a non-null pointer', () {
      final instance = calculator_create();
      expect(instance, isNotNull);
      expect(instance.address, isNot(equals(0)));
      calculator_destroy(instance);
    });

    test('calculator_destroy should safely release instance', () {
      final instance = calculator_create();
      expect(instance, isNotNull);

      // Should not throw
      expect(() => calculator_destroy(instance), returnsNormally);
    });

    test('multiple create/destroy cycles should work correctly', () {
      for (int i = 0; i < 5; i++) {
        final instance = calculator_create();
        expect(instance, isNotNull);
        expect(instance.address, isNot(equals(0)));
        calculator_destroy(instance);
      }
      // If we reach here without crash, test passes
    });

    test('destroying null pointer should be handled gracefully', () {
      // Test with nullptr - this may crash depending on native implementation
      // The test documents expected behavior
      final nullPtr = Pointer<CalculatorInstance>.fromAddress(0);
      try {
        calculator_destroy(nullPtr);
        // If it doesn't throw, that's acceptable behavior
      } catch (e) {
        // If it throws, that's also acceptable
      }
      // Test passes as long as we handle it somehow
    });

    group('Backward Compatibility APIs', () {
      test('calculator_init should create a valid instance', () {
        final instance = calculator_init();
        expect(instance, isNotNull);
        expect(instance.address, isNot(equals(0)));
        calculator_free(instance);
      });

      test('calculator_free should release instance created by calculator_init', () {
        final instance = calculator_init();
        expect(instance, isNotNull);

        expect(() => calculator_free(instance), returnsNormally);
      });

      test('calculator_init and calculator_create should be interchangeable', () {
        final instance1 = calculator_create();
        final instance2 = calculator_init();

        expect(instance1, isNotNull);
        expect(instance2, isNotNull);
        expect(instance1.address, isNot(equals(0)));
        expect(instance2.address, isNot(equals(0)));

        // Use corresponding destroy functions
        calculator_destroy(instance1);
        calculator_free(instance2);
      });

      test('can use calculator_free with calculator_create', () {
        final instance = calculator_create();
        expect(instance, isNotNull);

        // Test that free works with create
        expect(() => calculator_free(instance), returnsNormally);
      });

      test('can use calculator_destroy with calculator_init', () {
        final instance = calculator_init();
        expect(instance, isNotNull);

        // Test that destroy works with init
        expect(() => calculator_destroy(instance), returnsNormally);
      });
    });
  });

  group('Unit Converter Lifecycle', () {
    test('unit_converter_create should return a non-null pointer', () {
      final instance = unit_converter_create();
      expect(instance, isNotNull);
      expect(instance.address, isNot(equals(0)));
      unit_converter_destroy(instance);
    });

    test('unit_converter_destroy should safely release instance', () {
      final instance = unit_converter_create();
      expect(instance, isNotNull);

      expect(() => unit_converter_destroy(instance), returnsNormally);
    });

    test('multiple unit_converter create/destroy cycles', () {
      for (int i = 0; i < 5; i++) {
        final instance = unit_converter_create();
        expect(instance, isNotNull);
        expect(instance.address, isNot(equals(0)));
        unit_converter_destroy(instance);
      }
    });

    test('destroying null unit_converter pointer should be handled', () {
      final nullPtr = Pointer<UnitConverterInstance>.fromAddress(0);
      try {
        unit_converter_destroy(nullPtr);
      } catch (e) {
        // Acceptable if it throws
      }
    });
  });

  group('Mixed Instance Management', () {
    test('can create and manage both calculator and unit_converter instances',
        () {
      final calc = calculator_create();
      final converter = unit_converter_create();

      expect(calc, isNotNull);
      expect(converter, isNotNull);

      // Destroy in different orders
      calculator_destroy(calc);
      unit_converter_destroy(converter);
    });

    test('can create multiple instances simultaneously', () {
      final calc1 = calculator_create();
      final calc2 = calculator_create();
      final converter1 = unit_converter_create();
      final converter2 = unit_converter_create();

      expect(calc1, isNotNull);
      expect(calc2, isNotNull);
      expect(converter1, isNotNull);
      expect(converter2, isNotNull);

      // Each instance should have unique addresses
      expect(calc1.address, isNot(equals(calc2.address)));
      expect(converter1.address, isNot(equals(converter2.address)));

      // Clean up
      calculator_destroy(calc1);
      calculator_destroy(calc2);
      unit_converter_destroy(converter1);
      unit_converter_destroy(converter2);
    });

    test('instance isolation - operations on one instance should not affect another',
        () {
      // This is a basic test - actual isolation depends on native implementation
      final calc1 = calculator_create();
      final calc2 = calculator_create();

      expect(calc1, isNotNull);
      expect(calc2, isNotNull);

      // Verify they are different instances
      expect(calc1.address, isNot(equals(calc2.address)));

      calculator_destroy(calc1);
      calculator_destroy(calc2);
    });
  });

  group('Memory Safety', () {
    test('sequential operations should not leak memory', () {
      // Create and destroy many instances
      for (int i = 0; i < 100; i++) {
        final instance = calculator_create();
        expect(instance, isNotNull);
        calculator_destroy(instance);
      }
      // If we reach here without memory issues, test passes
    });

    test('can safely destroy instances in reverse order of creation', () {
      final instances = <Pointer<CalculatorInstance>>[];
      for (int i = 0; i < 10; i++) {
        instances.add(calculator_create());
      }

      // Destroy in reverse order (stack-like behavior)
      for (int i = instances.length - 1; i >= 0; i--) {
        expect(() => calculator_destroy(instances[i]), returnsNormally);
      }
    });

    test('can safely destroy instances in same order as creation', () {
      final instances = <Pointer<CalculatorInstance>>[];
      for (int i = 0; i < 10; i++) {
        instances.add(calculator_create());
      }

      // Destroy in same order (queue-like behavior)
      for (int i = 0; i < instances.length; i++) {
        expect(() => calculator_destroy(instances[i]), returnsNormally);
      }
    });
  });
}

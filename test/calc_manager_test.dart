import 'dart:ffi';

import 'package:calc_manager/calc_manager_wrapper.dart';
import 'package:ffi/ffi.dart';
import 'package:test/test.dart';

void main() {
  group('计算器基本功能测试', () {
    late Pointer<CalculatorInstance> calculator;

    setUp(() {
      // 每个测试前初始化计算器实例
      calculator = calculator_init();
      // 设置为标准模式
      calculator_set_standard_mode(calculator);
    });

    tearDown(() {
      // 每个测试后释放计算器实例，避免内存泄漏
      calculator_free(calculator);
    });

    String getCalculatorResult(
      Pointer<CalculatorInstance> calc, [
      int bufferSize = 256,
    ]) {
      final buffer = calloc<Char>(bufferSize);
      try {
        final result = calculator_get_result(calc, buffer, bufferSize);
        if (result <= 0) {
          if (result == -1) {
            throw Exception('获取结果失败：无效参数');
          } else if (result == -2) {
            throw Exception('获取结果失败：缓冲区太小');
          } else {
            throw Exception('获取结果失败：未知错误');
          }
        }
        return buffer.cast<Utf8>().toDartString();
      } finally {
        calloc.free(buffer);
      }
    }

    test('初始化和基本显示', () {
      // 验证初始状态下没有错误
      expect(calculator_has_error(calculator), 0);
      // 获取初始显示结果（可能是空字符串或"0"，取决于实现）
      final result = getCalculatorResult(calculator);
      expect(result.isNotEmpty, true);
    });

    test('输入数字', () {
      // 输入数字 "123"
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_2);
      calculator_send_command(calculator, CMD_3);
      final result = getCalculatorResult(calculator);
      expect(result, "123");
    });

    test('基本加法运算', () {
      // 执行 12 + 34 =
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_2);
      calculator_send_command(calculator, CMD_ADD);
      calculator_send_command(calculator, CMD_3);
      calculator_send_command(calculator, CMD_4);
      calculator_send_command(calculator, CMD_EQUALS);

      final result = getCalculatorResult(calculator);
      expect(result, "46");
    });

    test('基本减法运算', () {
      // 执行 50 - 25 =
      calculator_send_command(calculator, CMD_5);
      calculator_send_command(calculator, CMD_0);
      calculator_send_command(calculator, CMD_SUBTRACT);
      calculator_send_command(calculator, CMD_2);
      calculator_send_command(calculator, CMD_5);
      calculator_send_command(calculator, CMD_EQUALS);

      final result = getCalculatorResult(calculator);
      expect(result, "25");
    });

    test('基本乘法运算', () {
      // 执行 6 * 7 =
      calculator_send_command(calculator, CMD_6);
      calculator_send_command(calculator, CMD_MULTIPLY);
      calculator_send_command(calculator, CMD_7);
      calculator_send_command(calculator, CMD_EQUALS);

      final result = getCalculatorResult(calculator);
      expect(result, "42");
    });

    test('基本除法运算', () {
      // 执行 100 / 4 =
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_0);
      calculator_send_command(calculator, CMD_0);
      calculator_send_command(calculator, CMD_DIVIDE);
      calculator_send_command(calculator, CMD_4);
      calculator_send_command(calculator, CMD_EQUALS);

      final result = getCalculatorResult(calculator);
      expect(result, "25");
    });

    test('小数点输入', () {
      // 输入 "3.14"
      calculator_send_command(calculator, CMD_3);
      calculator_send_command(calculator, CMD_DECIMAL);
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_4);

      final result = getCalculatorResult(calculator);
      expect(result, "3.14");
    });

    test('正负号切换', () {
      // 输入 "-7"
      calculator_send_command(calculator, CMD_7);
      calculator_send_command(calculator, CMD_NEGATE);

      final result = getCalculatorResult(calculator);
      expect(result, "-7");

      // 切换回正数
      calculator_send_command(calculator, CMD_NEGATE);
      final positiveResult = getCalculatorResult(calculator);
      expect(positiveResult, "7");
    });

    test('清除功能', () {
      // 输入后清除
      calculator_send_command(calculator, CMD_9);
      calculator_send_command(calculator, CMD_8);
      calculator_send_command(calculator, CMD_CLEAR);

      // 清除后应该回到初始状态
      final result = getCalculatorResult(calculator);
      expect(result, isNot("98"));
    });

    test('退格功能', () {
      // 输入 "5678" 后删除最后一位
      calculator_send_command(calculator, CMD_5);
      calculator_send_command(calculator, CMD_6);
      calculator_send_command(calculator, CMD_7);
      calculator_send_command(calculator, CMD_8);
      calculator_send_command(calculator, CMD_BACKSPACE);

      final result = getCalculatorResult(calculator);
      expect(result, "567");
    });

    test('平方计算', () {
      // 计算 9 的平方
      calculator_send_command(calculator, CMD_9);
      calculator_send_command(calculator, CMD_SQUARE);

      final result = getCalculatorResult(calculator);
      expect(result, "81");
    });

    test('平方根计算', () {
      // 计算 144 的平方根
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_4);
      calculator_send_command(calculator, CMD_4);
      calculator_send_command(calculator, CMD_SQUARE_ROOT);

      final result = getCalculatorResult(calculator);
      expect(result, "12");
    });

    test('倒数计算', () {
      // 计算 2 的倒数
      calculator_send_command(calculator, CMD_2);
      calculator_send_command(calculator, CMD_RECIPROCAL);

      final result = getCalculatorResult(calculator);
      expect(result, "0.5");
    });

    test('百分比计算', () {
      // 计算 50% 的 100
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_0);
      calculator_send_command(calculator, CMD_0);
      calculator_send_command(calculator, CMD_MULTIPLY);
      calculator_send_command(calculator, CMD_5);
      calculator_send_command(calculator, CMD_0);
      calculator_send_command(calculator, CMD_PERCENT);
      calculator_send_command(calculator, CMD_EQUALS);

      final result = getCalculatorResult(calculator);
      expect(result, "50");
    });

    test('重置功能', () {
      // 输入后重置
      calculator_send_command(calculator, CMD_1);
      calculator_send_command(calculator, CMD_2);
      calculator_reset(calculator);

      // 重置后应该回到初始状态
      final result = getCalculatorResult(calculator);
      expect(result, isNot("12"));
    });

    test('科学模式切换', () {
      // 切换到科学模式
      calculator_set_scientific_mode(calculator);

      // 验证切换模式后能正常工作
      calculator_send_command(calculator, CMD_3);
      calculator_send_command(calculator, CMD_SQUARE);

      final result = getCalculatorResult(calculator);
      expect(result, "9");

      // 切回标准模式
      calculator_set_standard_mode(calculator);
    });
  });
}

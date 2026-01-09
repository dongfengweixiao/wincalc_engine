import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_icons.dart';
import 'calculator_button.dart';

/// Standard calculator button panel
class StandardButtonPanel extends ConsumerWidget {
  const StandardButtonPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);

    return Container(
      color: theme.surface,
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          // Memory row
          _buildMemoryRow(calculator),

          // Clear row: %, CE, C, ⌫
          _buildClearRow(calculator),

          // Function row: 1/x, x², √x, ÷
          _buildFunctionRow(calculator),

          // Number rows
          Expanded(child: _buildNumberRow7(calculator)),
          Expanded(child: _buildNumberRow4(calculator)),
          Expanded(child: _buildNumberRow1(calculator)),
          Expanded(child: _buildLastRow(calculator)),
        ],
      ),
    );
  }

  Widget _buildMemoryRow(CalculatorNotifier calculator) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          CalculatorButton(
            text: 'MC',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryClear,
          ),
          CalculatorButton(
            text: 'MR',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryRecall,
          ),
          CalculatorButton(
            text: 'M+',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryAdd,
          ),
          CalculatorButton(
            text: 'M-',
            type: CalcButtonType.memory,
            onPressed: calculator.memorySubtract,
          ),
          CalculatorButton(
            text: 'MS',
            type: CalcButtonType.memory,
            onPressed: calculator.memoryStore,
          ),
        ],
      ),
    );
  }

  Widget _buildClearRow(CalculatorNotifier calculator) {
    return Expanded(
      child: Row(
        children: [
          CalculatorButton(
            icon: CalculatorIcons.percent,
            type: CalcButtonType.operator,
            onPressed: calculator.percent,
          ),
          CalculatorButton(
            text: 'CE',
            type: CalcButtonType.operator,
            fontSize: CalculatorFontSizes.numeric16,
            onPressed: calculator.clearEntry,
          ),
          CalculatorButton(
            text: 'C',
            type: CalcButtonType.operator,
            fontSize: CalculatorFontSizes.numeric16,
            onPressed: calculator.clear,
          ),
          CalculatorButton(
            icon: CalculatorIcons.backspace,
            type: CalcButtonType.operator,
            onPressed: calculator.backspace,
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionRow(CalculatorNotifier calculator) {
    return Expanded(
      child: Row(
        children: [
          CalculatorButton(
            icon: CalculatorIcons.reciprocal,
            type: CalcButtonType.operator,
            onPressed: calculator.reciprocal,
          ),
          CalculatorButton(
            icon: CalculatorIcons.square,
            type: CalcButtonType.operator,
            onPressed: calculator.square,
          ),
          CalculatorButton(
            icon: CalculatorIcons.squareRoot,
            type: CalcButtonType.operator,
            onPressed: calculator.squareRoot,
          ),
          CalculatorButton(
            icon: CalculatorIcons.divide,
            type: CalcButtonType.operator,
            onPressed: calculator.divide,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow7(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalculatorButton(
          text: '7',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(7),
        ),
        CalculatorButton(
          text: '8',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(8),
        ),
        CalculatorButton(
          text: '9',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(9),
        ),
        CalculatorButton(
          icon: CalculatorIcons.multiply,
          type: CalcButtonType.operator,
          onPressed: calculator.multiply,
        ),
      ],
    );
  }

  Widget _buildNumberRow4(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalculatorButton(
          text: '4',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(4),
        ),
        CalculatorButton(
          text: '5',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(5),
        ),
        CalculatorButton(
          text: '6',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(6),
        ),
        CalculatorButton(
          icon: CalculatorIcons.minus,
          type: CalcButtonType.operator,
          onPressed: calculator.subtract,
        ),
      ],
    );
  }

  Widget _buildNumberRow1(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalculatorButton(
          text: '1',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(1),
        ),
        CalculatorButton(
          text: '2',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(2),
        ),
        CalculatorButton(
          text: '3',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(3),
        ),
        CalculatorButton(
          icon: CalculatorIcons.plus,
          type: CalcButtonType.operator,
          onPressed: calculator.add,
        ),
      ],
    );
  }

  Widget _buildLastRow(CalculatorNotifier calculator) {
    return Row(
      children: [
        CalculatorButton(
          icon: CalculatorIcons.negate,
          type: CalcButtonType.number,
          onPressed: calculator.inputNegate,
        ),
        CalculatorButton(
          text: '0',
          type: CalcButtonType.number,
          onPressed: () => calculator.inputDigit(0),
        ),
        CalculatorButton(
          text: '.',
          type: CalcButtonType.number,
          onPressed: calculator.inputDecimal,
        ),
        CalculatorButton(
          icon: CalculatorIcons.equals,
          type: CalcButtonType.emphasized,
          onPressed: calculator.equals,
        ),
      ],
    );
  }
}

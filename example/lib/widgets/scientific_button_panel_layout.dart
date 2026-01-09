import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/scientific_mode_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_icons.dart';
import 'scientific_button_providers.dart';
import 'scientific_button_components.dart';
import 'scientific_button_flyouts.dart';

/// Scientific calculator button panel - Microsoft Calculator layout
/// Grid: 5 columns × 10 rows
class ScientificButtonPanelLayout extends ConsumerWidget {
  const ScientificButtonPanelLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculator = ref.read(calculatorProvider.notifier);
    final theme = ref.watch(calculatorThemeProvider);
    final isShifted = ref.watch(scientificShiftProvider);

    return Container(
      color: theme.surface,
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          // Row 0: DEG and F-E buttons
          Expanded(flex: 1, child: _buildAngleAndFERow(ref, calculator, theme)),

          // Row 1: Memory buttons (MC, MR, M+, M-, MS, M)
          Expanded(flex: 1, child: _buildMemoryButtonsRow(calculator, theme)),

          // Row 2: Operator Panel - Trig and Func buttons
          Expanded(
            flex: 1,
            child: _buildOperatorPanelRow(ref, calculator, theme),
          ),

          // Row 3: Shift, π, e, CE/C, ⌫
          Expanded(flex: 1, child: _buildRow1(ref, calculator, theme)),

          // Rows 4-9: Main grid with scientific functions, operators, and number pad
          Expanded(
            flex: 6,
            child: _buildMainGrid(ref, calculator, theme, isShifted),
          ),
        ],
      ),
    );
  }

  /// Row 1: Operator Panel - Trig and Func flyout buttons
  Widget _buildOperatorPanelRow(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Row(
      children: [
        // Trig flyout
        Expanded(
          child: TrigFlyoutButton(
            ref: ref,
            calculator: calculator,
            theme: theme,
          ),
        ),
        const SizedBox(width: 2),
        // Func flyout
        Expanded(
          child: FuncFlyoutButton(calculator: calculator, theme: theme),
        ),
        const SizedBox(width: 2),
        // Empty space (3 columns to align with row 1)
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  /// Row 2: Shift, π, e, CE/C, ⌫
  /// Note: CE and C share the same position (like Microsoft Calculator)
  Widget _buildRow1(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final isShifted = ref.watch(scientificShiftProvider);
    final calcState = ref.watch(calculatorProvider);
    // Show CE when there's input, show C when display is just "0"
    final showCE = calcState.display != '0' || calcState.expression.isNotEmpty;

    return Row(
      children: [
        // Shift button (2nd)
        Expanded(
          child: ScientificToggleIconButton(
            icon: CalculatorIcons.shift,
            isSelected: isShifted,
            theme: theme,
            onPressed: () {
              ref.read(scientificShiftProvider.notifier).toggle();
            },
          ),
        ),
        // π
        Expanded(
          child: ScientificIconButton(
            icon: CalculatorIcons.pi,
            theme: theme,
            onPressed: calculator.pi,
            type: CalcButtonType.operator,
          ),
        ),
        // e (Euler) - uses text, not icon
        Expanded(
          child: ScientificTextButton(
            text: 'e',
            theme: theme,
            onPressed: calculator.euler,
            type: CalcButtonType.operator,
          ),
        ),
        // CE or C (shared position)
        Expanded(
          child: ScientificTextButton(
            text: showCE ? 'CE' : 'C',
            theme: theme,
            onPressed: showCE ? calculator.clearEntry : calculator.clear,
            type: CalcButtonType.operator,
          ),
        ),
        // Backspace
        Expanded(
          child: ScientificIconButton(
            icon: CalculatorIcons.backspace,
            theme: theme,
            onPressed: calculator.backspace,
            type: CalcButtonType.operator,
          ),
        ),
      ],
    );
  }

  /// Row 0: DEG and F-E buttons
  Widget _buildAngleAndFERow(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    final scientificMode = ref.watch(scientificModeProvider);

    return Row(
      children: [
        // DEG button (cycles through DEG/RAD/GRAD)
        Expanded(
          child: ScientificAngleButton(
            label: scientificMode.angleType.label,
            theme: theme,
            onPressed: () {
              final notifier = ref.read(scientificModeProvider.notifier);
              notifier.toggleAngleType();
              calculator.setAngleType(scientificMode.angleType.value);
            },
          ),
        ),
        const SizedBox(width: 2),
        // F-E button (toggle scientific notation)
        Expanded(
          child: ScientificToggleButton(
            label: 'F-E',
            isSelected: scientificMode.isFEChecked,
            theme: theme,
            onPressed: () {
              final notifier = ref.read(scientificModeProvider.notifier);
              notifier.toggleFE();
              calculator.toggleFE();
            },
          ),
        ),
        const SizedBox(width: 2),
        // Empty space (3 columns to align with memory row)
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
        const SizedBox(width: 2),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  /// Row 1: Memory buttons (MC, MR, M+, M-, MS, M)
  Widget _buildMemoryButtonsRow(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Row(
      children: [
        // MC (Memory Clear)
        Expanded(
          child: ScientificMemoryButton(
            icon: CalculatorIcons.memoryClear,
            theme: theme,
            onPressed: calculator.memoryClear,
          ),
        ),
        const SizedBox(width: 2),
        // MR (Memory Recall)
        Expanded(
          child: ScientificMemoryButton(
            icon: CalculatorIcons.memoryRecall,
            theme: theme,
            onPressed: calculator.memoryRecall,
          ),
        ),
        const SizedBox(width: 2),
        // M+ (Memory Add)
        Expanded(
          child: ScientificMemoryButton(
            icon: CalculatorIcons.memoryAdd,
            theme: theme,
            onPressed: calculator.memoryAdd,
          ),
        ),
        const SizedBox(width: 2),
        // M- (Memory Subtract)
        Expanded(
          child: ScientificMemoryButton(
            icon: CalculatorIcons.memorySubtract,
            theme: theme,
            onPressed: calculator.memorySubtract,
          ),
        ),
        const SizedBox(width: 2),
        // MS (Memory Store)
        Expanded(
          child: ScientificMemoryButton(
            icon: CalculatorIcons.memoryStore,
            theme: theme,
            onPressed: calculator.memoryStore,
          ),
        ),
      ],
    );
  }

  /// Main grid: Rows 3-8
  /// Col 0: Scientific functions (vertical strip) - 1 column
  /// Col 1-4: Middle section (operators + number pad + operators) - 4 columns total
  ///   - Row 3: 1/x, |x|, exp, mod (spans all 4 columns)
  ///   - Rows 4-8: Buttons in columns 1-3, operators in column 4
  Widget _buildMainGrid(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
    bool isShifted,
  ) {
    return Row(
      children: [
        // Column 0: Scientific functions (x², √, ^, 10^x, log, ln)
        Expanded(
          child: _buildScientificFunctionsColumn(calculator, theme, isShifted),
        ),

        // Columns 1-4: Middle section (operators + number pad + standard operators)
        Expanded(
          flex: 4,
          child: _buildMiddleSectionWithOperators(calculator, theme),
        ),
      ],
    );
  }

  /// Column 0: Scientific functions vertical strip
  Widget _buildScientificFunctionsColumn(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
    bool isShifted,
  ) {
    if (!isShifted) {
      return Column(
        children: [
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.square,
              theme: theme,
              onPressed: calculator.square,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.squareRoot,
              theme: theme,
              onPressed: calculator.squareRoot,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.power,
              theme: theme,
              onPressed: calculator.power,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.powerOf10,
              theme: theme,
              onPressed: calculator.pow10,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificFunctionTextButton(
              text: 'log',
              theme: theme,
              onPressed: calculator.log,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificFunctionTextButton(
              text: 'ln',
              theme: theme,
              onPressed: calculator.ln,
              type: CalcButtonType.operator,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.cube,
              theme: theme,
              onPressed: calculator.cube,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.cubeRoot,
              theme: theme,
              onPressed: calculator.cubeRoot,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.yRoot,
              theme: theme,
              onPressed: calculator.yRoot,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.powerOf2,
              theme: theme,
              onPressed: calculator.pow2,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificFunctionTextButton(
              text: 'logᵧ',
              theme: theme,
              onPressed: calculator.logBaseY,
              type: CalcButtonType.operator,
            ),
          ),
          Expanded(
            child: ScientificIconButton(
              icon: CalculatorIcons.powerOfE,
              theme: theme,
              onPressed: calculator.powE,
              type: CalcButtonType.operator,
            ),
          ),
        ],
      );
    }
  }

  /// Middle section: Rows 2-7, Columns 1-4 with standard operators in column 4
  /// Important: All columns have equal width (1:1:1:1 ratio)
  Widget _buildMiddleSectionWithOperators(
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Column(
      children: [
        // Row 2: 1/x, |x|, exp, mod (4 buttons, all 4 columns)
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.reciprocal,
                  theme: theme,
                  onPressed: calculator.reciprocal,
                  type: CalcButtonType.operator,
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.absoluteValue,
                  theme: theme,
                  onPressed: calculator.abs,
                  type: CalcButtonType.operator,
                ),
              ),
              Expanded(
                child: ScientificFunctionTextButton(
                  text: 'exp',
                  theme: theme,
                  onPressed: calculator.exp,
                  type: CalcButtonType.operator,
                ),
              ),
              Expanded(
                child: ScientificFunctionTextButton(
                  text: 'mod',
                  theme: theme,
                  onPressed: calculator.mod,
                  type: CalcButtonType.operator,
                ),
              ),
            ],
          ),
        ),

        // Row 3: (, ), n!, ÷
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ScientificFunctionTextButton(
                  text: '(',
                  theme: theme,
                  onPressed: calculator.openParen,
                  type: CalcButtonType.operator,
                ),
              ),
              Expanded(
                child: ScientificFunctionTextButton(
                  text: ')',
                  theme: theme,
                  onPressed: calculator.closeParen,
                  type: CalcButtonType.operator,
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.factorial,
                  theme: theme,
                  onPressed: calculator.factorial,
                  type: CalcButtonType.operator,
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.divide,
                  theme: theme,
                  onPressed: calculator.divide,
                  type: CalcButtonType.operator,
                ),
              ),
            ],
          ),
        ),

        // Row 4: 7, 8, 9, ×
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ScientificNumberButton(
                  text: '7',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(7),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '8',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(8),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '9',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(9),
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.multiply,
                  theme: theme,
                  onPressed: calculator.multiply,
                  type: CalcButtonType.operator,
                ),
              ),
            ],
          ),
        ),

        // Row 5: 4, 5, 6, -
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ScientificNumberButton(
                  text: '4',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(4),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '5',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(5),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '6',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(6),
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.minus,
                  theme: theme,
                  onPressed: calculator.subtract,
                  type: CalcButtonType.operator,
                ),
              ),
            ],
          ),
        ),

        // Row 6: 1, 2, 3, +
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ScientificNumberButton(
                  text: '1',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(1),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '2',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(2),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '3',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(3),
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.plus,
                  theme: theme,
                  onPressed: calculator.add,
                  type: CalcButtonType.operator,
                ),
              ),
            ],
          ),
        ),

        // Row 7: ±, 0, ., =
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.negate,
                  theme: theme,
                  onPressed: calculator.inputNegate,
                  type: CalcButtonType.number,
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '0',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(0),
                ),
              ),
              Expanded(
                child: ScientificNumberButton(
                  text: '.',
                  theme: theme,
                  onPressed: calculator.inputDecimal,
                ),
              ),
              Expanded(
                child: ScientificIconButton(
                  icon: CalculatorIcons.equals,
                  theme: theme,
                  onPressed: calculator.equals,
                  type: CalcButtonType.emphasized,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

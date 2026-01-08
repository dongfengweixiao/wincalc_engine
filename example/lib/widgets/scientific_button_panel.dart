import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_icons.dart';

/// Scientific calculator shift state provider
final scientificShiftProvider = StateProvider<bool>((ref) => false);

/// Angle type provider (DEG, RAD, GRAD)
final angleTypeProvider = StateProvider<AngleType>((ref) => AngleType.degrees);

/// Trigonometric mode provider (normal, hyperbolic)
final trigModeProvider = StateProvider<TrigMode>((ref) => TrigMode.normal);

/// Trig shift (inverse) provider
final trigShiftProvider = StateProvider<bool>((ref) => false);

/// Angle type enum
enum AngleType { degrees, radians, gradians }

/// Trig mode enum
enum TrigMode { normal, hyperbolic }

/// Scientific calculator button panel - Microsoft Calculator layout
/// Grid: 5 columns × 8 rows
class ScientificButtonPanel extends ConsumerWidget {
  const ScientificButtonPanel({super.key});

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
          // Operator Panel Row: Trig and Func buttons
          SizedBox(
            height: 36,
            child: _buildOperatorPanelRow(ref, calculator, theme),
          ),

          // Row 1: Shift, π, e, CE/C, ⌫
          SizedBox(height: 36, child: _buildRow1(ref, calculator, theme)),

          // Rows 2-7: Main grid with scientific functions, operators, and number pad
          Expanded(child: _buildMainGrid(ref, calculator, theme, isShifted)),
        ],
      ),
    );
  }

  /// Operator Panel Row: Trig and Func flyout buttons
  Widget _buildOperatorPanelRow(
    WidgetRef ref,
    CalculatorNotifier calculator,
    CalculatorTheme theme,
  ) {
    return Row(
      children: [
        // Trig flyout (takes ~40% of space)
        Expanded(
          flex: 2,
          child: _TrigFlyoutButton(
            ref: ref,
            calculator: calculator,
            theme: theme,
          ),
        ),
        const SizedBox(width: 2),
        // Func flyout (takes ~40% of space)
        Expanded(
          flex: 2,
          child: _FuncFlyoutButton(calculator: calculator, theme: theme),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  /// Row 1: Shift, π, e, CE/C, ⌫
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
          child: _ToggleIconButton(
            icon: CalculatorIcons.shift,
            isSelected: isShifted,
            theme: theme,
            onPressed: () {
              ref.read(scientificShiftProvider.notifier).state = !isShifted;
            },
          ),
        ),
        // π
        Expanded(
          child: _IconButton(
            icon: CalculatorIcons.pi,
            theme: theme,
            onPressed: calculator.pi,
          ),
        ),
        // e (Euler) - uses text, not icon
        Expanded(
          child: _TextButton(
            text: 'e',
            theme: theme,
            onPressed: calculator.euler,
          ),
        ),
        // CE or C (shared position)
        Expanded(
          child: _TextButton(
            text: showCE ? 'CE' : 'C',
            theme: theme,
            onPressed: showCE ? calculator.clearEntry : calculator.clear,
          ),
        ),
        // Backspace
        Expanded(
          child: _IconButton(
            icon: CalculatorIcons.backspace,
            theme: theme,
            onPressed: calculator.backspace,
          ),
        ),
      ],
    );
  }

  /// Main grid: Rows 2-7
  /// Col 0: Scientific functions (vertical strip) - 1 column
  /// Col 1-4: Middle section (operators + number pad + operators) - 4 columns total
  ///   - Row 2: 1/x, |x|, exp, mod (spans all 4 columns)
  ///   - Rows 3-7: Buttons in columns 1-3, operators in column 4
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
            child: _IconButton(
              icon: CalculatorIcons.square,
              theme: theme,
              onPressed: calculator.square,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.squareRoot,
              theme: theme,
              onPressed: calculator.squareRoot,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.power,
              theme: theme,
              onPressed: calculator.power,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.powerOf10,
              theme: theme,
              onPressed: calculator.pow10,
            ),
          ),
          Expanded(
            child: _FunctionTextButton(
              text: 'log',
              theme: theme,
              onPressed: calculator.log,
            ),
          ),
          Expanded(
            child: _FunctionTextButton(
              text: 'ln',
              theme: theme,
              onPressed: calculator.ln,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.cube,
              theme: theme,
              onPressed: calculator.cube,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.cubeRoot,
              theme: theme,
              onPressed: calculator.cubeRoot,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.yRoot,
              theme: theme,
              onPressed: calculator.yRoot,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.powerOf2,
              theme: theme,
              onPressed: calculator.pow2,
            ),
          ),
          Expanded(
            child: _FunctionTextButton(
              text: 'logᵧ',
              theme: theme,
              onPressed: calculator.logBaseY,
            ),
          ),
          Expanded(
            child: _IconButton(
              icon: CalculatorIcons.powerOfE,
              theme: theme,
              onPressed: calculator.powE,
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
                child: _IconButton(
                  icon: CalculatorIcons.reciprocal,
                  theme: theme,
                  onPressed: calculator.reciprocal,
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: CalculatorIcons.absoluteValue,
                  theme: theme,
                  onPressed: calculator.abs,
                ),
              ),
              Expanded(
                child: _FunctionTextButton(
                  text: 'exp',
                  theme: theme,
                  onPressed: calculator.exp,
                ),
              ),
              Expanded(
                child: _FunctionTextButton(
                  text: 'mod',
                  theme: theme,
                  onPressed: calculator.mod,
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
                child: _FunctionTextButton(
                  text: '(',
                  theme: theme,
                  onPressed: calculator.openParen,
                ),
              ),
              Expanded(
                child: _FunctionTextButton(
                  text: ')',
                  theme: theme,
                  onPressed: calculator.closeParen,
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: CalculatorIcons.factorial,
                  theme: theme,
                  onPressed: calculator.factorial,
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: CalculatorIcons.divide,
                  theme: theme,
                  onPressed: calculator.divide,
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
                child: _NumberButton(
                  text: '7',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(7),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '8',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(8),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '9',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(9),
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: CalculatorIcons.multiply,
                  theme: theme,
                  onPressed: calculator.multiply,
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
                child: _NumberButton(
                  text: '4',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(4),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '5',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(5),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '6',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(6),
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: CalculatorIcons.minus,
                  theme: theme,
                  onPressed: calculator.subtract,
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
                child: _NumberButton(
                  text: '1',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(1),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '2',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(2),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '3',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(3),
                ),
              ),
              Expanded(
                child: _IconButton(
                  icon: CalculatorIcons.plus,
                  theme: theme,
                  onPressed: calculator.add,
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
                child: _IconButton(
                  icon: CalculatorIcons.negate,
                  theme: theme,
                  onPressed: calculator.inputNegate,
                  type: CalcButtonType.number,
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '0',
                  theme: theme,
                  onPressed: () => calculator.inputDigit(0),
                ),
              ),
              Expanded(
                child: _NumberButton(
                  text: '.',
                  theme: theme,
                  onPressed: calculator.inputDecimal,
                ),
              ),
              Expanded(
                child: _IconButton(
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

// =============================================================================
// Button Widgets
// =============================================================================

/// Icon button with calculator styling
class _IconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;
  final CalcButtonType type;

  const _IconButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
    this.type = CalcButtonType.function,
  });

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      widget.type,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      widget.type,
      _buttonState,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                String.fromCharCode(widget.icon.codePoint),
                style: TextStyle(
                  fontFamily: widget.icon.fontFamily,
                  fontSize: 16,
                  color: foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Toggle icon button (for 2nd/shift)
class _ToggleIconButton extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _ToggleIconButton({
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_ToggleIconButton> createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<_ToggleIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    if (widget.isSelected) {
      backgroundColor = widget.theme.accentColor.withValues(alpha: 0.3);
      foregroundColor = widget.theme.accentColor;
    } else if (_isHovered) {
      backgroundColor = widget.theme.buttonAltHover;
      foregroundColor = widget.theme.textPrimary;
    } else {
      backgroundColor = widget.theme.buttonAltDefault;
      foregroundColor = widget.theme.textPrimary;
    }

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: widget.isSelected
                  ? Border.all(color: widget.theme.accentColor, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                String.fromCharCode(widget.icon.codePoint),
                style: TextStyle(
                  fontFamily: widget.icon.fontFamily,
                  fontSize: 16,
                  color: foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text button
class _TextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _TextButton({
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_TextButton> createState() => _TextButtonState();
}

class _TextButtonState extends State<_TextButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      CalcButtonType.function,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      CalcButtonType.function,
      _buttonState,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 14, color: foregroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Function text button (for log, ln, exp, mod)
class _FunctionTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _FunctionTextButton({
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_FunctionTextButton> createState() => _FunctionTextButtonState();
}

class _FunctionTextButtonState extends State<_FunctionTextButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      CalcButtonType.function,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      CalcButtonType.function,
      _buttonState,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 14, color: foregroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Number button
class _NumberButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _NumberButton({
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_NumberButton> createState() => _NumberButtonState();
}

class _NumberButtonState extends State<_NumberButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.theme.getButtonBackground(
      CalcButtonType.number,
      _buttonState,
    );
    final foregroundColor = widget.theme.getButtonForeground(
      CalcButtonType.number,
      _buttonState,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 20, color: foregroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small button (for angle mode, F-E)
class _SmallButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _SmallButton({
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<_SmallButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.theme.buttonAltHover
                  : widget.theme.buttonAltDefault,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(fontSize: 11, color: widget.theme.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Angle mode button
class _AngleButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _AngleButton({
    required this.text,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_AngleButton> createState() => _AngleButtonState();
}

class _AngleButtonState extends State<_AngleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;

    if (widget.isSelected) {
      backgroundColor = widget.theme.accentColor;
      foregroundColor = widget.theme.brightness == Brightness.dark
          ? Colors.black
          : Colors.white;
    } else if (_isHovered) {
      backgroundColor = widget.theme.buttonAltHover;
      foregroundColor = widget.theme.textPrimary;
    } else {
      backgroundColor = widget.theme.buttonAltDefault;
      foregroundColor = widget.theme.textPrimary;
    }

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 44,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: foregroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Flyout Menus
// =============================================================================

/// Trig functions flyout button
class _TrigFlyoutButton extends StatefulWidget {
  final WidgetRef ref;
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;

  const _TrigFlyoutButton({
    required this.ref,
    required this.calculator,
    required this.theme,
  });

  @override
  State<_TrigFlyoutButton> createState() => _TrigFlyoutButtonState();
}

class _TrigFlyoutButtonState extends State<_TrigFlyoutButton> {
  bool _isHovered = false;

  void _showTrigMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _TrigFlyoutMenu(
        ref: widget.ref,
        calculator: widget.calculator,
        theme: widget.theme,
        position: position,
        buttonSize: button.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => _showTrigMenu(context),
          child: Container(
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.theme.buttonAltHover
                  : widget.theme.buttonAltDefault,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Trig',
                  style: TextStyle(
                    color: widget.theme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.theme.textPrimary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Trig flyout menu
class _TrigFlyoutMenu extends ConsumerWidget {
  final WidgetRef ref;
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;
  final Offset position;
  final Size buttonSize;

  const _TrigFlyoutMenu({
    required this.ref,
    required this.calculator,
    required this.theme,
    required this.position,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trigShift = ref.watch(trigShiftProvider);
    final trigMode = ref.watch(trigModeProvider);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy + buttonSize.height + 4,
          child: Material(
            color: theme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 260,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Controls row
                  Row(
                    children: [
                      _MenuToggle(
                        icon: CalculatorIcons.shift,
                        isSelected: trigShift,
                        theme: theme,
                        onPressed: () {
                          ref.read(trigShiftProvider.notifier).state =
                              !trigShift;
                        },
                      ),
                      const SizedBox(width: 8),
                      _MenuTextToggle(
                        text: 'hyp',
                        isSelected: trigMode == TrigMode.hyperbolic,
                        theme: theme,
                        onPressed: () {
                          ref
                              .read(trigModeProvider.notifier)
                              .state = trigMode == TrigMode.hyperbolic
                              ? TrigMode.normal
                              : TrigMode.hyperbolic;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTrigButtons(context, trigShift, trigMode),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrigButtons(
    BuildContext context,
    bool isInverse,
    TrigMode mode,
  ) {
    if (mode == TrigMode.normal) {
      if (!isInverse) {
        return Column(
          children: [
            Row(
              children: [
                _TrigTextButton(
                  text: 'sin',
                  theme: theme,
                  onPressed: () {
                    calculator.sin();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'cos',
                  theme: theme,
                  onPressed: () {
                    calculator.cos();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'tan',
                  theme: theme,
                  onPressed: () {
                    calculator.tan();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _TrigTextButton(
                  text: 'sec',
                  theme: theme,
                  onPressed: () {
                    calculator.sec();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'csc',
                  theme: theme,
                  onPressed: () {
                    calculator.csc();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'cot',
                  theme: theme,
                  onPressed: () {
                    calculator.cot();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Row(
              children: [
                _TrigTextButton(
                  text: 'sin⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.asin();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'cos⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.acos();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'tan⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.atan();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _TrigTextButton(
                  text: 'sec⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.asec();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'csc⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.acsc();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'cot⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.acot();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      }
    } else {
      // Hyperbolic
      if (!isInverse) {
        return Column(
          children: [
            Row(
              children: [
                _TrigTextButton(
                  text: 'sinh',
                  theme: theme,
                  onPressed: () {
                    calculator.sinh();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'cosh',
                  theme: theme,
                  onPressed: () {
                    calculator.cosh();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'tanh',
                  theme: theme,
                  onPressed: () {
                    calculator.tanh();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _TrigTextButton(
                  text: 'sech',
                  theme: theme,
                  onPressed: () {
                    calculator.sech();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'csch',
                  theme: theme,
                  onPressed: () {
                    calculator.csch();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'coth',
                  theme: theme,
                  onPressed: () {
                    calculator.coth();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Row(
              children: [
                _TrigTextButton(
                  text: 'sinh⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.asinh();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'cosh⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.acosh();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'tanh⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.atanh();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _TrigTextButton(
                  text: 'sech⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.asech();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'csch⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.acsch();
                    Navigator.pop(context);
                  },
                ),
                _TrigTextButton(
                  text: 'coth⁻¹',
                  theme: theme,
                  onPressed: () {
                    calculator.acoth();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      }
    }
  }
}

/// Menu toggle with icon
class _MenuToggle extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _MenuToggle({
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_MenuToggle> createState() => _MenuToggleState();
}

class _MenuToggleState extends State<_MenuToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 44,
          height: 32,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.theme.accentColor.withValues(alpha: 0.3)
                : (_isHovered
                      ? widget.theme.buttonAltHover
                      : widget.theme.buttonAltDefault),
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border.all(color: widget.theme.accentColor, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              String.fromCharCode(widget.icon.codePoint),
              style: TextStyle(
                fontFamily: widget.icon.fontFamily,
                fontSize: 14,
                color: widget.isSelected
                    ? widget.theme.accentColor
                    : widget.theme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu toggle with text
class _MenuTextToggle extends StatefulWidget {
  final String text;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _MenuTextToggle({
    required this.text,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_MenuTextToggle> createState() => _MenuTextToggleState();
}

class _MenuTextToggleState extends State<_MenuTextToggle> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 44,
          height: 32,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.theme.accentColor.withValues(alpha: 0.3)
                : (_isHovered
                      ? widget.theme.buttonAltHover
                      : widget.theme.buttonAltDefault),
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border.all(color: widget.theme.accentColor, width: 1)
                : null,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 12,
                color: widget.isSelected
                    ? widget.theme.accentColor
                    : widget.theme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Trig button in flyout (with icon)
/// Icon button in func flyout
class _FuncIconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _FuncIconButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_FuncIconButton> createState() => _FuncIconButtonState();
}

class _FuncIconButtonState extends State<_FuncIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.theme.buttonAltHover
                    : widget.theme.buttonAltDefault,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(widget.icon.codePoint),
                  style: TextStyle(
                    fontFamily: widget.icon.fontFamily,
                    fontSize: 16,
                    color: widget.theme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Trig button in flyout (with text)
class _TrigTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _TrigTextButton({
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_TrigTextButton> createState() => _TrigTextButtonState();
}

class _TrigTextButtonState extends State<_TrigTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.theme.buttonAltHover
                    : widget.theme.buttonAltDefault,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.theme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text button in func flyout
class _FuncTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _FuncTextButton({
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_FuncTextButton> createState() => _FuncTextButtonState();
}

class _FuncTextButtonState extends State<_FuncTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.theme.buttonAltHover
                    : widget.theme.buttonAltDefault,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.theme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Func flyout button
class _FuncFlyoutButton extends StatefulWidget {
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;

  const _FuncFlyoutButton({required this.calculator, required this.theme});

  @override
  State<_FuncFlyoutButton> createState() => _FuncFlyoutButtonState();
}

class _FuncFlyoutButtonState extends State<_FuncFlyoutButton> {
  bool _isHovered = false;

  void _showFuncMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => _FuncFlyoutMenu(
        calculator: widget.calculator,
        theme: widget.theme,
        position: position,
        buttonSize: button.size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => _showFuncMenu(context),
          child: Container(
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.theme.buttonAltHover
                  : widget.theme.buttonAltDefault,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Func',
                  style: TextStyle(
                    color: widget.theme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.theme.textPrimary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Func flyout menu
class _FuncFlyoutMenu extends StatelessWidget {
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;
  final Offset position;
  final Size buttonSize;

  const _FuncFlyoutMenu({
    required this.calculator,
    required this.theme,
    required this.position,
    required this.buttonSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy + buttonSize.height + 4,
          child: Material(
            color: theme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      _FuncIconButton(
                        icon: CalculatorIcons.absoluteValue,
                        theme: theme,
                        onPressed: () {
                          calculator.abs();
                          Navigator.pop(context);
                        },
                      ),
                      _FuncIconButton(
                        icon: CalculatorIcons.floor,
                        theme: theme,
                        onPressed: () {
                          calculator.floor();
                          Navigator.pop(context);
                        },
                      ),
                      _FuncIconButton(
                        icon: CalculatorIcons.ceiling,
                        theme: theme,
                        onPressed: () {
                          calculator.ceil();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _FuncTextButton(
                        text: 'rand',
                        theme: theme,
                        onPressed: () {
                          calculator.rand();
                          Navigator.pop(context);
                        },
                      ),
                      _FuncIconButton(
                        icon: CalculatorIcons.dms,
                        theme: theme,
                        onPressed: () {
                          calculator.dms();
                          Navigator.pop(context);
                        },
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

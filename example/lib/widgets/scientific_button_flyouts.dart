import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_icons.dart';
import 'scientific_button_providers.dart';

/// Trig functions flyout button
class TrigFlyoutButton extends StatefulWidget {
  final WidgetRef ref;
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;

  const TrigFlyoutButton({
    super.key,
    required this.ref,
    required this.calculator,
    required this.theme,
  });

  @override
  State<TrigFlyoutButton> createState() => _TrigFlyoutButtonState();
}

class _TrigFlyoutButtonState extends State<TrigFlyoutButton> {
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
      builder: (context) => TrigFlyoutMenu(
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
                  ? widget.theme.buttonSubtleHover
                  : widget.theme.buttonSubtleDefault,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    String.fromCharCode(CalculatorIcons.trigButton.codePoint),
                    style: TextStyle(
                      fontFamily: CalculatorIcons.trigButton.fontFamily,
                      fontSize: 14,
                      color: widget.theme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '三角学',
                    style: TextStyle(
                      color: widget.theme.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 2),
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
      ),
    );
  }
}

/// Trig flyout menu
class TrigFlyoutMenu extends ConsumerWidget {
  final WidgetRef ref;
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;
  final Offset position;
  final Size buttonSize;

  const TrigFlyoutMenu({
    super.key,
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
              width: 280,
              child: _buildTrigButtons(context, trigShift, trigMode),
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
    // Determine button labels based on mode
    String row1Col2, row1Col3, row1Col4;
    String row2Col2, row2Col3, row2Col4;
    VoidCallback row1Col2Fn, row1Col3Fn, row1Col4Fn;
    VoidCallback row2Col2Fn, row2Col3Fn, row2Col4Fn;

    if (mode == TrigMode.normal) {
      if (!isInverse) {
        // Normal mode: sin, cos, tan / sec, csc, cot
        row1Col2 = 'sin';
        row1Col3 = 'cos';
        row1Col4 = 'tan';
        row2Col2 = 'sec';
        row2Col3 = 'csc';
        row2Col4 = 'cot';
        row1Col2Fn = () {
          calculator.sin();
          Navigator.pop(context);
        };
        row1Col3Fn = () {
          calculator.cos();
          Navigator.pop(context);
        };
        row1Col4Fn = () {
          calculator.tan();
          Navigator.pop(context);
        };
        row2Col2Fn = () {
          calculator.sec();
          Navigator.pop(context);
        };
        row2Col3Fn = () {
          calculator.csc();
          Navigator.pop(context);
        };
        row2Col4Fn = () {
          calculator.cot();
          Navigator.pop(context);
        };
      } else {
        // Inverse mode: sin⁻¹, cos⁻¹, tan⁻¹ / sec⁻¹, csc⁻¹, cot⁻¹
        row1Col2 = 'sin⁻¹';
        row1Col3 = 'cos⁻¹';
        row1Col4 = 'tan⁻¹';
        row2Col2 = 'sec⁻¹';
        row2Col3 = 'csc⁻¹';
        row2Col4 = 'cot⁻¹';
        row1Col2Fn = () {
          calculator.asin();
          Navigator.pop(context);
        };
        row1Col3Fn = () {
          calculator.acos();
          Navigator.pop(context);
        };
        row1Col4Fn = () {
          calculator.atan();
          Navigator.pop(context);
        };
        row2Col2Fn = () {
          calculator.asec();
          Navigator.pop(context);
        };
        row2Col3Fn = () {
          calculator.acsc();
          Navigator.pop(context);
        };
        row2Col4Fn = () {
          calculator.acot();
          Navigator.pop(context);
        };
      }
    } else {
      // Hyperbolic mode
      if (!isInverse) {
        row1Col2 = 'sinh';
        row1Col3 = 'cosh';
        row1Col4 = 'tanh';
        row2Col2 = 'sech';
        row2Col3 = 'csch';
        row2Col4 = 'coth';
        row1Col2Fn = () {
          calculator.sinh();
          Navigator.pop(context);
        };
        row1Col3Fn = () {
          calculator.cosh();
          Navigator.pop(context);
        };
        row1Col4Fn = () {
          calculator.tanh();
          Navigator.pop(context);
        };
        row2Col2Fn = () {
          calculator.sech();
          Navigator.pop(context);
        };
        row2Col3Fn = () {
          calculator.csch();
          Navigator.pop(context);
        };
        row2Col4Fn = () {
          calculator.coth();
          Navigator.pop(context);
        };
      } else {
        row1Col2 = 'sinh⁻¹';
        row1Col3 = 'cosh⁻¹';
        row1Col4 = 'tanh⁻¹';
        row2Col2 = 'sech⁻¹';
        row2Col3 = 'csch⁻¹';
        row2Col4 = 'coth⁻¹';
        row1Col2Fn = () {
          calculator.asinh();
          Navigator.pop(context);
        };
        row1Col3Fn = () {
          calculator.acosh();
          Navigator.pop(context);
        };
        row1Col4Fn = () {
          calculator.atanh();
          Navigator.pop(context);
        };
        row2Col2Fn = () {
          calculator.asech();
          Navigator.pop(context);
        };
        row2Col3Fn = () {
          calculator.acsch();
          Navigator.pop(context);
        };
        row2Col4Fn = () {
          calculator.acoth();
          Navigator.pop(context);
        };
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: 2nd | sin | cos | tan
        Row(
          children: [
            MenuToggle(
              icon: CalculatorIcons.shift,
              isSelected: isInverse,
              theme: theme,
              onPressed: () {
                ref.read(trigShiftProvider.notifier).toggle();
              },
            ),
            TrigTextButton(text: row1Col2, theme: theme, onPressed: row1Col2Fn),
            TrigTextButton(text: row1Col3, theme: theme, onPressed: row1Col3Fn),
            TrigTextButton(text: row1Col4, theme: theme, onPressed: row1Col4Fn),
          ],
        ),
        const SizedBox(height: 4),
        // Row 2: hyp | sec | csc | cot
        Row(
          children: [
            MenuTextToggle(
              text: 'hyp',
              isSelected: mode == TrigMode.hyperbolic,
              theme: theme,
              onPressed: () {
                final newMode = mode == TrigMode.hyperbolic
                    ? TrigMode.normal
                    : TrigMode.hyperbolic;
                ref.read(trigModeProvider.notifier).setTrigMode(newMode);
              },
            ),
            TrigTextButton(text: row2Col2, theme: theme, onPressed: row2Col2Fn),
            TrigTextButton(text: row2Col3, theme: theme, onPressed: row2Col3Fn),
            TrigTextButton(text: row2Col4, theme: theme, onPressed: row2Col4Fn),
          ],
        ),
      ],
    );
  }
}

/// Menu toggle with icon
class MenuToggle extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const MenuToggle({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<MenuToggle> createState() => _MenuToggleState();
}

class _MenuToggleState extends State<MenuToggle> {
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
        ),
      ),
    );
  }
}

/// Menu toggle with text
class MenuTextToggle extends StatefulWidget {
  final String text;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const MenuTextToggle({
    super.key,
    required this.text,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<MenuTextToggle> createState() => _MenuTextToggleState();
}

class _MenuTextToggleState extends State<MenuTextToggle> {
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
        ),
      ),
    );
  }
}

/// Trig button in flyout (with text)
class TrigTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const TrigTextButton({
    super.key,
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<TrigTextButton> createState() => _TrigTextButtonState();
}

class _TrigTextButtonState extends State<TrigTextButton> {
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
class FuncFlyoutButton extends StatefulWidget {
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;

  const FuncFlyoutButton({
    super.key,
    required this.calculator,
    required this.theme,
  });

  @override
  State<FuncFlyoutButton> createState() => _FuncFlyoutButtonState();
}

class _FuncFlyoutButtonState extends State<FuncFlyoutButton> {
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
      builder: (context) => FuncFlyoutMenu(
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
                  ? widget.theme.buttonSubtleHover
                  : widget.theme.buttonSubtleDefault,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    String.fromCharCode(CalculatorIcons.funcButton.codePoint),
                    style: TextStyle(
                      fontFamily: CalculatorIcons.funcButton.fontFamily,
                      fontSize: 14,
                      color: widget.theme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '函数',
                    style: TextStyle(
                      color: widget.theme.textPrimary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 2),
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
      ),
    );
  }
}

/// Func flyout menu
class FuncFlyoutMenu extends StatelessWidget {
  final CalculatorNotifier calculator;
  final CalculatorTheme theme;
  final Offset position;
  final Size buttonSize;

  const FuncFlyoutMenu({
    super.key,
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
                      FuncIconButton(
                        icon: CalculatorIcons.absoluteValue,
                        theme: theme,
                        onPressed: () {
                          calculator.abs();
                          Navigator.pop(context);
                        },
                      ),
                      FuncIconButton(
                        icon: CalculatorIcons.floor,
                        theme: theme,
                        onPressed: () {
                          calculator.floor();
                          Navigator.pop(context);
                        },
                      ),
                      FuncIconButton(
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
                      FuncTextButton(
                        text: 'rand',
                        theme: theme,
                        onPressed: () {
                          calculator.rand();
                          Navigator.pop(context);
                        },
                      ),
                      FuncIconButton(
                        icon: CalculatorIcons.dms,
                        theme: theme,
                        onPressed: () {
                          calculator.dms();
                          Navigator.pop(context);
                        },
                      ),
                      FuncIconButton(
                        icon: CalculatorIcons.degrees,
                        theme: theme,
                        onPressed: () {
                          calculator.degrees();
                          Navigator.pop(context);
                        },
                      ),
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

/// Icon button in func flyout
class FuncIconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const FuncIconButton({
    super.key,
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<FuncIconButton> createState() => _FuncIconButtonState();
}

class _FuncIconButtonState extends State<FuncIconButton> {
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

/// Text button in func flyout
class FuncTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const FuncTextButton({
    super.key,
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<FuncTextButton> createState() => _FuncTextButtonState();
}

class _FuncTextButtonState extends State<FuncTextButton> {
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

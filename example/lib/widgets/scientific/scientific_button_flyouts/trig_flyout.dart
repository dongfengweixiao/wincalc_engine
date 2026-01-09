import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/calculator_provider.dart';
import '../../../providers/scientific_provider.dart';
import '../../../theme/calculator_theme.dart';
import '../../../theme/calculator_icons.dart';
import 'button_state.dart';
import 'menu_buttons.dart';

/// Trigonometric functions flyout button
/// Displays a button that opens a menu with trig functions when clicked
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
    final backgroundColor = widget.theme.getButtonColor(
      isSelected: false,
      isHovered: _isHovered,
      isPressed: false,
      defaultColor: widget.theme.buttonSubtleDefault,
      hoverColor: widget.theme.buttonSubtleHover,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => _showTrigMenu(context),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
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
                    Icon(
                      Icons.arrow_drop_down,
                      size: 10,
                      color: widget.theme.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Trigonometric functions flyout menu
/// Displays a grid of trig function buttons with modes (normal/hyperbolic, inverse)
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
    // Get button configuration based on mode
    final config = _TrigButtonConfig.getConfig(isInverse, mode);

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
            FlyoutTextButton(
              text: config.row1Col2,
              theme: theme,
              onPressed: () {
                config.row1Col2Fn(calculator);
                Navigator.pop(context);
              },
            ),
            FlyoutTextButton(
              text: config.row1Col3,
              theme: theme,
              onPressed: () {
                config.row1Col3Fn(calculator);
                Navigator.pop(context);
              },
            ),
            FlyoutTextButton(
              text: config.row1Col4,
              theme: theme,
              onPressed: () {
                config.row1Col4Fn(calculator);
                Navigator.pop(context);
              },
            ),
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
            FlyoutTextButton(
              text: config.row2Col2,
              theme: theme,
              onPressed: () {
                config.row2Col2Fn(calculator);
                Navigator.pop(context);
              },
            ),
            FlyoutTextButton(
              text: config.row2Col3,
              theme: theme,
              onPressed: () {
                config.row2Col3Fn(calculator);
                Navigator.pop(context);
              },
            ),
            FlyoutTextButton(
              text: config.row2Col4,
              theme: theme,
              onPressed: () {
                config.row2Col4Fn(calculator);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Configuration for trig button labels and callbacks
class _TrigButtonConfig {
  final String row1Col2;
  final String row1Col3;
  final String row1Col4;
  final String row2Col2;
  final String row2Col3;
  final String row2Col4;

  final void Function(CalculatorNotifier) row1Col2Fn;
  final void Function(CalculatorNotifier) row1Col3Fn;
  final void Function(CalculatorNotifier) row1Col4Fn;
  final void Function(CalculatorNotifier) row2Col2Fn;
  final void Function(CalculatorNotifier) row2Col3Fn;
  final void Function(CalculatorNotifier) row2Col4Fn;

  _TrigButtonConfig({
    required this.row1Col2,
    required this.row1Col3,
    required this.row1Col4,
    required this.row2Col2,
    required this.row2Col3,
    required this.row2Col4,
    required this.row1Col2Fn,
    required this.row1Col3Fn,
    required this.row1Col4Fn,
    required this.row2Col2Fn,
    required this.row2Col3Fn,
    required this.row2Col4Fn,
  });

  static _TrigButtonConfig getConfig(bool isInverse, TrigMode mode) {
    if (mode == TrigMode.normal) {
      return isInverse ? _inverseNormal : _normal;
    } else {
      return isInverse ? _inverseHyperbolic : _hyperbolic;
    }
  }

  static final _TrigButtonConfig _normal = _TrigButtonConfig(
    row1Col2: 'sin',
    row1Col3: 'cos',
    row1Col4: 'tan',
    row2Col2: 'sec',
    row2Col3: 'csc',
    row2Col4: 'cot',
    row1Col2Fn: (c) => c.sin(),
    row1Col3Fn: (c) => c.cos(),
    row1Col4Fn: (c) => c.tan(),
    row2Col2Fn: (c) => c.sec(),
    row2Col3Fn: (c) => c.csc(),
    row2Col4Fn: (c) => c.cot(),
  );

  static final _TrigButtonConfig _inverseNormal = _TrigButtonConfig(
    row1Col2: 'sin⁻¹',
    row1Col3: 'cos⁻¹',
    row1Col4: 'tan⁻¹',
    row2Col2: 'sec⁻¹',
    row2Col3: 'csc⁻¹',
    row2Col4: 'cot⁻¹',
    row1Col2Fn: (c) => c.asin(),
    row1Col3Fn: (c) => c.acos(),
    row1Col4Fn: (c) => c.atan(),
    row2Col2Fn: (c) => c.asec(),
    row2Col3Fn: (c) => c.acsc(),
    row2Col4Fn: (c) => c.acot(),
  );

  static final _TrigButtonConfig _hyperbolic = _TrigButtonConfig(
    row1Col2: 'sinh',
    row1Col3: 'cosh',
    row1Col4: 'tanh',
    row2Col2: 'sech',
    row2Col3: 'csch',
    row2Col4: 'coth',
    row1Col2Fn: (c) => c.sinh(),
    row1Col3Fn: (c) => c.cosh(),
    row1Col4Fn: (c) => c.tanh(),
    row2Col2Fn: (c) => c.sech(),
    row2Col3Fn: (c) => c.csch(),
    row2Col4Fn: (c) => c.coth(),
  );

  static final _TrigButtonConfig _inverseHyperbolic = _TrigButtonConfig(
    row1Col2: 'sinh⁻¹',
    row1Col3: 'cosh⁻¹',
    row1Col4: 'tanh⁻¹',
    row2Col2: 'sech⁻¹',
    row2Col3: 'csch⁻¹',
    row2Col4: 'coth⁻¹',
    row1Col2Fn: (c) => c.asinh(),
    row1Col3Fn: (c) => c.acosh(),
    row1Col4Fn: (c) => c.atanh(),
    row2Col2Fn: (c) => c.asech(),
    row2Col3Fn: (c) => c.acsch(),
    row2Col4Fn: (c) => c.acoth(),
  );
}

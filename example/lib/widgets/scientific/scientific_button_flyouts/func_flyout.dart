import 'package:flutter/material.dart';
import '../../../providers/calculator_provider.dart';
import '../../../theme/calculator_theme.dart';
import '../../../theme/calculator_icons.dart';
import 'button_state.dart';
import 'menu_buttons.dart';

/// Function flyout button
/// Displays a button that opens a menu with common functions when clicked
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
          onTap: () => _showFuncMenu(context),
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
      ),
    );
  }
}

/// Function flyout menu
/// Displays a grid of common function buttons
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
                  // Row 1: |x|, floor, ceil
                  Row(
                    children: [
                      FlyoutIconButton(
                        icon: CalculatorIcons.absoluteValue,
                        theme: theme,
                        onPressed: () {
                          calculator.abs();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutIconButton(
                        icon: CalculatorIcons.floor,
                        theme: theme,
                        onPressed: () {
                          calculator.floor();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutIconButton(
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
                  // Row 2: rand, dms, degrees
                  Row(
                    children: [
                      FlyoutTextButton(
                        text: 'rand',
                        theme: theme,
                        onPressed: () {
                          calculator.rand();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutIconButton(
                        icon: CalculatorIcons.dms,
                        theme: theme,
                        onPressed: () {
                          calculator.dms();
                          Navigator.pop(context);
                        },
                      ),
                      FlyoutIconButton(
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

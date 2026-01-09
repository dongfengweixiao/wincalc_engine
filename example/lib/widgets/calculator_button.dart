import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_font_sizes.dart';
import '../theme/calculator_dimensions.dart';
import '../providers/theme_provider.dart';

/// Calculator button widget
class CalculatorButton extends ConsumerStatefulWidget {
  /// Text content (for buttons without icons)
  final String? text;

  /// Icon data (for buttons with calculator font icons)
  final IconData? icon;

  /// Button type for styling
  final CalcButtonType type;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Custom font size
  final double? fontSize;

  /// Flex value for layout
  final int flex;

  const CalculatorButton({
    super.key,
    this.text,
    this.icon,
    this.type = CalcButtonType.number,
    this.onPressed,
    this.fontSize,
    this.flex = 1,
  }) : assert(
         text != null || icon != null,
         'Either text or icon must be provided',
       );

  @override
  ConsumerState<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends ConsumerState<CalculatorButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (widget.onPressed == null) return CalcButtonState.disabled;
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final backgroundColor = theme.getButtonBackground(
      widget.type,
      _buttonState,
    );
    final foregroundColor = theme.getButtonForeground(
      widget.type,
      _buttonState,
    );

    // Determine font size based on button type
    double fontSize = widget.fontSize ?? _getDefaultFontSize();

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(CalculatorDimensions.buttonMargin),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
            onTapCancel: () => setState(() => _isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(
                  CalculatorDimensions.controlCornerRadius,
                ),
              ),
              constraints: const BoxConstraints(
                minWidth: CalculatorDimensions.buttonMinWidth,
                minHeight: CalculatorDimensions.buttonMinHeight,
              ),
              child: Center(child: _buildContent(foregroundColor, fontSize)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color foregroundColor, double fontSize) {
    if (widget.icon != null) {
      // Use icon font
      return Text(
        String.fromCharCode(widget.icon!.codePoint),
        style: TextStyle(
          fontFamily: widget.icon!.fontFamily,
          fontSize: fontSize,
          color: foregroundColor,
        ),
      );
    } else {
      // Use regular text
      return Text(
        widget.text!,
        style: TextStyle(
          color: foregroundColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }

  double _getDefaultFontSize() {
    switch (widget.type) {
      case CalcButtonType.number:
        return CalculatorFontSizes.numeric24;
      case CalcButtonType.operator:
        return CalculatorFontSizes.numeric24;
      case CalcButtonType.function:
        return CalculatorFontSizes.numeric18;
      case CalcButtonType.emphasized:
        return CalculatorFontSizes.numeric24;
      case CalcButtonType.memory:
        return CalculatorFontSizes.numeric14;
    }
  }
}

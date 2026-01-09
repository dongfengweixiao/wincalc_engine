import 'package:flutter/material.dart';
import '../../../theme/calculator_theme.dart';

/// Button hover and press state controller
/// Separates state management logic from UI components
class ButtonStateController extends ChangeNotifier {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get isHovered => _isHovered;
  bool get isPressed => _isPressed;

  void setHovered(bool hovered) {
    if (_isHovered != hovered) {
      _isHovered = hovered;
      notifyListeners();
    }
  }

  void setPressed(bool pressed) {
    if (_isPressed != pressed) {
      _isPressed = pressed;
      notifyListeners();
    }
  }

  void reset() {
    if (_isHovered || _isPressed) {
      _isHovered = false;
      _isPressed = false;
      notifyListeners();
    }
  }
}

/// Extension to get button background color based on state
extension ButtonStateColor on CalculatorTheme {
  Color getButtonColor({
    required bool isSelected,
    required bool isHovered,
    required bool isPressed,
    required Color defaultColor,
    Color? hoverColor,
    Color? pressedColor,
    Color? selectedColor,
  }) {
    if (isSelected && selectedColor != null) {
      return selectedColor;
    }
    if (isPressed && pressedColor != null) {
      return pressedColor;
    }
    if (isHovered && hoverColor != null) {
      return hoverColor;
    }
    return defaultColor;
  }
}

/// Mixin for button state management
mixin ButtonStateMixin<T extends StatefulWidget> on State<T> {
  final ButtonStateController buttonState = ButtonStateController();

  @override
  void dispose() {
    buttonState.dispose();
    super.dispose();
  }

  MouseRegion createMouseRegion({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onTapDown,
    VoidCallback? onTapUp,
  }) {
    return MouseRegion(
      onEnter: (_) => buttonState.setHovered(true),
      onExit: (_) => buttonState.reset(),
      child: GestureDetector(
        onTap: onTap,
        onTapDown: onTapDown != null
            ? (_) => onTapDown()
            : (_) => buttonState.setPressed(true),
        onTapUp: onTapUp != null
            ? (_) => onTapUp()
            : (_) => buttonState.setPressed(false),
        onTapCancel: () => buttonState.reset(),
        child: child,
      ),
    );
  }
}

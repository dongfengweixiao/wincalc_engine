import 'package:flutter/material.dart';
import '../theme/calculator_theme.dart';

/// Icon button with calculator styling
class ScientificIconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;
  final CalcButtonType type;

  const ScientificIconButton({
    super.key,
    required this.icon,
    required this.theme,
    required this.onPressed,
    this.type = CalcButtonType.function,
  });

  @override
  State<ScientificIconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<ScientificIconButton> {
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
class ScientificToggleIconButton extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const ScientificToggleIconButton({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<ScientificToggleIconButton> createState() => _ToggleIconButtonState();
}

class _ToggleIconButtonState extends State<ScientificToggleIconButton> {
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
class ScientificTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;
  final CalcButtonType type;

  const ScientificTextButton({
    super.key,
    required this.text,
    required this.theme,
    required this.onPressed,
    this.type = CalcButtonType.function,
  });

  @override
  State<ScientificTextButton> createState() => _ScientificTextButtonState();
}

class _ScientificTextButtonState extends State<ScientificTextButton> {
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

/// Function text button (for log, ln, exp, mod, parentheses)
class ScientificFunctionTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;
  final CalcButtonType type;

  const ScientificFunctionTextButton({
    super.key,
    required this.text,
    required this.theme,
    required this.onPressed,
    this.type = CalcButtonType.function,
  });

  @override
  State<ScientificFunctionTextButton> createState() =>
      _ScientificFunctionTextButtonState();
}

class _ScientificFunctionTextButtonState
    extends State<ScientificFunctionTextButton> {
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
class ScientificNumberButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const ScientificNumberButton({
    super.key,
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<ScientificNumberButton> createState() => _ScientificNumberButtonState();
}

class _ScientificNumberButtonState extends State<ScientificNumberButton> {
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

/// Memory button with icon only (no text label)
class ScientificMemoryButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const ScientificMemoryButton({
    super.key,
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<ScientificMemoryButton> createState() => _ScientificMemoryButtonState();
}

class _ScientificMemoryButtonState extends State<ScientificMemoryButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
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
              color: widget.theme.getButtonBackground(
                CalcButtonType.memory,
                _buttonState,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                String.fromCharCode(widget.icon.codePoint),
                style: TextStyle(
                  fontFamily: widget.icon.fontFamily,
                  fontSize: 14,
                  color: widget.theme.getButtonForeground(
                    CalcButtonType.memory,
                    _buttonState,
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

/// Angle type button (DEG/RAD/GRAD)
class ScientificAngleButton extends StatefulWidget {
  final String label;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const ScientificAngleButton({
    super.key,
    required this.label,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<ScientificAngleButton> createState() => _ScientificAngleButtonState();
}

class _ScientificAngleButtonState extends State<ScientificAngleButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
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
              color: widget.theme.getButtonBackground(
                CalcButtonType.memory,
                _buttonState,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: widget.theme.getButtonForeground(
                    CalcButtonType.memory,
                    _buttonState,
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

/// Toggle button (F-E)
class ScientificToggleButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const ScientificToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<ScientificToggleButton> createState() => _ScientificToggleButtonState();
}

class _ScientificToggleButtonState extends State<ScientificToggleButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  CalcButtonState get _buttonState {
    if (_isPressed) return CalcButtonState.pressed;
    if (_isHovered) return CalcButtonState.hover;
    return CalcButtonState.normal;
  }

  @override
  Widget build(BuildContext context) {
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
              color: widget.isSelected
                  ? widget.theme.accentColor.withValues(alpha: 0.3)
                  : widget.theme.getButtonBackground(
                      CalcButtonType.memory,
                      _buttonState,
                    ),
              borderRadius: BorderRadius.circular(4),
              border: widget.isSelected
                  ? Border.all(color: widget.theme.accentColor, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.getButtonForeground(
                          CalcButtonType.memory,
                          _buttonState,
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

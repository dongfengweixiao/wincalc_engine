import 'package:flutter/material.dart';
import '../../../theme/calculator_theme.dart';
import 'button_state.dart';

/// Menu toggle button with icon
/// Used in flyout menus for toggling states (e.g., inv, hyp)
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
    final backgroundColor = widget.theme.getButtonColor(
      isSelected: widget.isSelected,
      isHovered: _isHovered,
      isPressed: false,
      defaultColor: widget.theme.buttonAltDefault,
      hoverColor: widget.theme.buttonAltHover,
      selectedColor: widget.theme.accentColor.withValues(alpha: 0.3),
    );

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

/// Menu toggle button with text
/// Used in flyout menus for toggling states with text labels
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
    final backgroundColor = widget.theme.getButtonColor(
      isSelected: widget.isSelected,
      isHovered: _isHovered,
      isPressed: false,
      defaultColor: widget.theme.buttonAltDefault,
      hoverColor: widget.theme.buttonAltHover,
      selectedColor: widget.theme.accentColor.withValues(alpha: 0.3),
    );

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
                color: backgroundColor,
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

/// Text button for flyout menus
/// Used for menu items with text labels
class FlyoutTextButton extends StatefulWidget {
  final String text;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const FlyoutTextButton({
    super.key,
    required this.text,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<FlyoutTextButton> createState() => _FlyoutTextButtonState();
}

class _FlyoutTextButtonState extends State<FlyoutTextButton> {
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

/// Icon button for flyout menus
/// Used for menu items with calculator icons
class FlyoutIconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const FlyoutIconButton({
    super.key,
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<FlyoutIconButton> createState() => _FlyoutIconButtonState();
}

class _FlyoutIconButtonState extends State<FlyoutIconButton> {
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

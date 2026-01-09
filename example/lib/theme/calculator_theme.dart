import 'package:flutter/material.dart';
import 'calculator_colors.dart';
import 'calculator_font_sizes.dart';

/// Calculator button state for styling
enum CalcButtonState { normal, hover, pressed, disabled }

/// Calculator button type
enum CalcButtonType {
  /// Number buttons (0-9, decimal, negate)
  number,

  /// Operator buttons (+, -, *, /, etc.)
  operator,

  /// Function buttons (sqrt, square, etc.)
  function,

  /// Emphasized button (equals)
  emphasized,

  /// Memory buttons
  memory,
}

/// Calculator theme data for Flutter
class CalculatorTheme {
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color accent;
  final Color accentHighlight;
  final Color accentHover;
  final Color divider;
  final Color buttonDefault;
  final Color buttonHover;
  final Color buttonPressed;
  final Color buttonDisabled;
  final Color buttonAltDefault;
  final Color buttonAltHover;
  final Color buttonAltPressed;
  final Color buttonAltDisabled;
  final Color buttonSubtleDefault;
  final Color buttonSubtleHover;
  final Color buttonSubtlePressed;
  final Color buttonSubtleDisabled;
  final Color backgroundSmoke;
  final Color navPaneBackground;
  final Color historyPaneBackground;
  final List<Color> equationColors;

  const CalculatorTheme({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.accent,
    required this.accentHighlight,
    required this.accentHover,
    required this.divider,
    required this.buttonDefault,
    required this.buttonHover,
    required this.buttonPressed,
    required this.buttonDisabled,
    required this.buttonAltDefault,
    required this.buttonAltHover,
    required this.buttonAltPressed,
    required this.buttonAltDisabled,
    required this.buttonSubtleDefault,
    required this.buttonSubtleHover,
    required this.buttonSubtlePressed,
    required this.buttonSubtleDisabled,
    required this.backgroundSmoke,
    required this.navPaneBackground,
    required this.historyPaneBackground,
    required this.equationColors,
  });

  /// Alias for accent color
  Color get accentColor => accent;

  /// Dark theme (default Windows Calculator theme)
  static const CalculatorTheme dark = CalculatorTheme(
    brightness: Brightness.dark,
    background: CalculatorDarkColors.background,
    surface: CalculatorDarkColors.chromeMediumLow,
    surfaceVariant: CalculatorDarkColors.operatorFlyoutBackground,
    textPrimary: CalculatorDarkColors.textPrimary,
    textSecondary: CalculatorDarkColors.textSecondary,
    textDisabled: CalculatorDarkColors.textDisabled,
    accent: CalculatorDarkColors.accent,
    accentHighlight: CalculatorDarkColors.accentHighlight,
    accentHover: CalculatorDarkColors.accentHover,
    divider: CalculatorDarkColors.dividerStroke,
    buttonDefault: CalculatorDarkColors.buttonDefault,
    buttonHover: CalculatorDarkColors.buttonHover,
    buttonPressed: CalculatorDarkColors.buttonPressed,
    buttonDisabled: CalculatorDarkColors.buttonDisabled,
    buttonAltDefault: CalculatorDarkColors.buttonAltDefault,
    buttonAltHover: CalculatorDarkColors.buttonAltHover,
    buttonAltPressed: CalculatorDarkColors.buttonAltPressed,
    buttonAltDisabled: CalculatorDarkColors.buttonAltDisabled,
    buttonSubtleDefault: CalculatorDarkColors.buttonSubtleDefault,
    buttonSubtleHover: CalculatorDarkColors.buttonSubtleHover,
    buttonSubtlePressed: CalculatorDarkColors.buttonSubtlePressed,
    buttonSubtleDisabled: CalculatorDarkColors.buttonSubtleDisabled,
    backgroundSmoke: CalculatorDarkColors.backgroundSmoke,
    navPaneBackground: CalculatorDarkColors.chromeMediumLow,
    historyPaneBackground: Color(0xFF1F1F1F),
    equationColors: CalculatorDarkColors.equationColors,
  );

  /// Light theme
  static const CalculatorTheme light = CalculatorTheme(
    brightness: Brightness.light,
    background: CalculatorLightColors.background,
    surface: CalculatorLightColors.chromeMediumLow,
    surfaceVariant: CalculatorLightColors.chromeMediumLow,
    textPrimary: CalculatorLightColors.textPrimary,
    textSecondary: CalculatorLightColors.textSecondary,
    textDisabled: CalculatorLightColors.textDisabled,
    accent: CalculatorLightColors.accent,
    accentHighlight: CalculatorLightColors.accentHighlight,
    accentHover: CalculatorLightColors.accentHover,
    divider: CalculatorLightColors.dividerStroke,
    buttonDefault: CalculatorLightColors.buttonDefault,
    buttonHover: CalculatorLightColors.buttonHover,
    buttonPressed: CalculatorLightColors.buttonPressed,
    buttonDisabled: CalculatorLightColors.buttonDisabled,
    buttonAltDefault: CalculatorLightColors.buttonAltDefault,
    buttonAltHover: CalculatorLightColors.buttonAltHover,
    buttonAltPressed: CalculatorLightColors.buttonAltPressed,
    buttonAltDisabled: CalculatorLightColors.buttonAltDisabled,
    buttonSubtleDefault: CalculatorLightColors.buttonSubtleDefault,
    buttonSubtleHover: CalculatorLightColors.buttonSubtleHover,
    buttonSubtlePressed: CalculatorLightColors.buttonSubtlePressed,
    buttonSubtleDisabled: CalculatorLightColors.buttonSubtleDisabled,
    backgroundSmoke: CalculatorLightColors.backgroundSmoke,
    navPaneBackground: Color(0xFFE6E6E6),
    historyPaneBackground: Color(0xFFEAEAEA),
    equationColors: CalculatorLightColors.equationColors,
  );

  /// Get button background color based on type and state
  Color getButtonBackground(CalcButtonType type, CalcButtonState state) {
    // Memory and trig/func buttons use subtle colors
    if (type == CalcButtonType.memory || type == CalcButtonType.function) {
      switch (state) {
        case CalcButtonState.normal:
          return buttonSubtleDefault;
        case CalcButtonState.hover:
          return buttonSubtleHover;
        case CalcButtonState.pressed:
          return buttonSubtlePressed;
        case CalcButtonState.disabled:
          return buttonSubtleDisabled;
      }
    }

    if (type == CalcButtonType.emphasized) {
      switch (state) {
        case CalcButtonState.normal:
          return accent;
        case CalcButtonState.hover:
          return accentHover;
        case CalcButtonState.pressed:
          return accent.withValues(alpha: 0.8);
        case CalcButtonState.disabled:
          return accent.withValues(alpha: 0.4);
      }
    }

    if (type == CalcButtonType.operator) {
      switch (state) {
        case CalcButtonState.normal:
          return buttonAltDefault;
        case CalcButtonState.hover:
          return buttonAltHover;
        case CalcButtonState.pressed:
          return buttonAltPressed;
        case CalcButtonState.disabled:
          return buttonAltDisabled;
      }
    }

    switch (state) {
      case CalcButtonState.normal:
        return buttonDefault;
      case CalcButtonState.hover:
        return buttonHover;
      case CalcButtonState.pressed:
        return buttonPressed;
      case CalcButtonState.disabled:
        return buttonDisabled;
    }
  }

  /// Get button text color based on type and state
  Color getButtonForeground(CalcButtonType type, CalcButtonState state) {
    if (type == CalcButtonType.emphasized) {
      return brightness == Brightness.dark
          ? const Color(0xFF000000)
          : const Color(0xFFFFFFFF);
    }

    switch (state) {
      case CalcButtonState.normal:
      case CalcButtonState.hover:
        return textPrimary;
      case CalcButtonState.pressed:
        return textSecondary;
      case CalcButtonState.disabled:
        return textDisabled;
    }
  }

  /// Convert to Flutter ThemeData
  ThemeData toThemeData() {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: accent,
        onPrimary: brightness == Brightness.dark ? Colors.black : Colors.white,
        secondary: accent,
        onSecondary: brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        error: CalculatorDarkColors.textError,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
      ),
      dividerColor: divider,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: CalculatorFontSizes.operatorCaptionExtraLarge,
          fontWeight: FontWeight.w300,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: CalculatorFontSizes.buttonCaption,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: CalculatorFontSizes.body,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: CalculatorFontSizes.caption,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: CalculatorFontSizes.operatorButtonCaption,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
      ),
    );
  }
}

/// InheritedWidget to provide calculator theme down the widget tree
class CalculatorThemeProvider extends InheritedWidget {
  final CalculatorTheme theme;

  const CalculatorThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static CalculatorTheme of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<CalculatorThemeProvider>();
    return provider?.theme ?? CalculatorTheme.dark;
  }

  @override
  bool updateShouldNotify(CalculatorThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}

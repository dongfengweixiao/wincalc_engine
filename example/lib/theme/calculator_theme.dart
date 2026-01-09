import 'package:flutter/material.dart';

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

/// Dark theme colors (Default theme in Windows Calculator)
class CalculatorDarkColors {
  CalculatorDarkColors._();

  // ============================================================================
  // Background Colors
  // ============================================================================

  /// Main background color
  static const Color background = Color(0xFF000000);

  /// Alt high color for surfaces
  static const Color altHigh = Color(0xFF000000);

  /// Chrome medium low - used for operator panel
  static const Color chromeMediumLow = Color(0xFF2B2B2B);

  /// Operator flyout background
  static const Color operatorFlyoutBackground = Color(0xFF2F2F2F);

  /// Smoke/overlay background (42% opacity)
  static const Color backgroundSmoke = Color(0x6B000000);

  // ============================================================================
  // Calculator Button Colors - Standard (Number Buttons)
  // ============================================================================

  /// Base fill color for calculator buttons
  static const Color buttonBaseFill = Color(0xFFFFFFFF);

  /// Number button - default state (12.5% opacity white)
  static const Color buttonDefault = Color(0x20FFFFFF);

  /// Number button - hover state (8.52% opacity white)
  static const Color buttonHover = Color(0x16FFFFFF);

  /// Number button - pressed state (3.59% opacity white)
  static const Color buttonPressed = Color(0x09FFFFFF);

  /// Number button - disabled state (3.59% opacity white)
  static const Color buttonDisabled = Color(0x09FFFFFF);

  // ============================================================================
  // Calculator Button Colors - Alt (Operator/Function Buttons)
  // ============================================================================

  /// Operator button - default state (8.52% opacity white)
  static const Color buttonAltDefault = Color(0x16FFFFFF);

  /// Operator button - hover state (12.56% opacity white)
  static const Color buttonAltHover = Color(0x20FFFFFF);

  /// Operator button - pressed state (8.52% opacity white)
  static const Color buttonAltPressed = Color(0x16FFFFFF);

  /// Operator button - disabled state (3.59% opacity white)
  static const Color buttonAltDisabled = Color(0x09FFFFFF);

  // ============================================================================
  // Calculator Button Colors - Subtle (Memory, Trig, Func Buttons)
  // ============================================================================

  /// Subtle button - default state (transparent)
  static const Color buttonSubtleDefault = Color(0x00FFFFFF);

  /// Subtle button - hover state (subtle fill secondary)
  static const Color buttonSubtleHover = Color(0x0FFFFFFF);

  /// Subtle button - pressed state (subtle fill tertiary)
  static const Color buttonSubtlePressed = Color(0x0AFFFFFF);

  /// Subtle button - disabled state (3.59% opacity white)
  static const Color buttonSubtleDisabled = Color(0x09FFFFFF);

  // ============================================================================
  // Text Colors
  // ============================================================================

  /// Primary text color
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text color
  static const Color textSecondary = Color(0xB3FFFFFF); // ~70% white

  /// Disabled text color
  static const Color textDisabled = Color(0x4DFFFFFF); // ~30% white

  /// Error text color
  static const Color textError = Color(0xFFFF0000);

  // ============================================================================
  // Accent Colors (System accent - default blue)
  // ============================================================================

  /// System accent color (default Windows blue)
  static const Color accent = Color(0xFF0078D4);

  /// Accent with 40% opacity for button highlight
  static const Color accentHighlight = Color(0x660078D4);

  /// Accent with 90% opacity for hover
  static const Color accentHover = Color(0xE60078D4);

  // ============================================================================
  // Control/Subtle Fill Colors
  // ============================================================================

  /// Hover button face (18% white)
  static const Color hoverButtonFace = Color(0x2EFFFFFF);

  /// Pressed button face (30% white)
  static const Color pressedButtonFace = Color(0x4DFFFFFF);

  /// Subtle fill secondary
  static const Color subtleFillSecondary = Color(0x0FFFFFFF);

  /// Subtle fill tertiary
  static const Color subtleFillTertiary = Color(0x0AFFFFFF);

  // ============================================================================
  // Divider/Border Colors
  // ============================================================================

  /// Divider stroke color
  static const Color dividerStroke = Color(0x14FFFFFF);

  /// Operator panel scroll button background
  static const Color operatorScrollButton = Color(0xFF858585);

  // ============================================================================
  // Equation Colors (for graphing calculator)
  // ============================================================================

  static const List<Color> equationColors = [
    Color(0xFF4D92C8), // Blue
    Color(0xFF4DCDD5), // Cyan
    Color(0xFFA366E0), // Purple
    Color(0xFF58A358), // Green
    Color(0xFF4DDB97), // Light Green
    Color(0xFF4DA688), // Teal
    Color(0xFF8A8B8C), // Gray
    Color(0xFFEF5865), // Red
    Color(0xFFEB4DAF), // Pink
    Color(0xFFCA5B93), // Rose
    Color(0xFFFFCE4D), // Yellow
    Color(0xFFF99255), // Orange
    Color(0xFFB0896D), // Brown
    Color(0xFFFFFFFF), // White
  ];
}

/// Light theme colors
class CalculatorLightColors {
  CalculatorLightColors._();

  // ============================================================================
  // Background Colors
  // ============================================================================

  /// Main background color
  static const Color background = Color(0xFFF2F2F2);

  /// Alt high color
  static const Color altHigh = Color(0xFFF2F2F2);

  /// Chrome medium low - operator panel
  static const Color chromeMediumLow = Color(0xFFE0E0E0);

  /// Smoke/overlay background (30% opacity)
  static const Color backgroundSmoke = Color(0x4D000000);

  // ============================================================================
  // Calculator Button Colors - Standard (Number Buttons)
  // ============================================================================

  /// Base fill color for calculator buttons
  static const Color buttonBaseFill = Color(0xFFFFFFFF);

  /// Number button - default state (100% opacity white)
  static const Color buttonDefault = Color(0xFFFFFFFF);

  /// Number button - hover state (75% opacity white)
  static const Color buttonHover = Color(0xBFFFFFFF);

  /// Number button - pressed state (50% opacity white)
  static const Color buttonPressed = Color(0x80FFFFFF);

  /// Number button - disabled state (12.5% opacity white)
  static const Color buttonDisabled = Color(0x20FFFFFF);

  // ============================================================================
  // Calculator Button Colors - Alt (Operator/Function Buttons)
  // ============================================================================

  /// Operator button - default state (50% opacity white)
  static const Color buttonAltDefault = Color(0x80FFFFFF);

  /// Operator button - hover state (25% opacity white)
  static const Color buttonAltHover = Color(0x40FFFFFF);

  /// Operator button - pressed state (12.5% opacity white)
  static const Color buttonAltPressed = Color(0x20FFFFFF);

  /// Operator button - disabled state (12.5% opacity white)
  static const Color buttonAltDisabled = Color(0x20FFFFFF);

  // ============================================================================
  // Calculator Button Colors - Subtle (Memory, Trig, Func Buttons)
  // ============================================================================

  /// Subtle button - default state (transparent)
  static const Color buttonSubtleDefault = Color(0x00FFFFFF);

  /// Subtle button - hover state (subtle fill secondary)
  static const Color buttonSubtleHover = Color(0x09000000);

  /// Subtle button - pressed state (subtle fill tertiary)
  static const Color buttonSubtlePressed = Color(0x05000000);

  /// Subtle button - disabled state (12.5% opacity white)
  static const Color buttonSubtleDisabled = Color(0x20FFFFFF);

  // ============================================================================
  // Text Colors
  // ============================================================================

  /// Primary text color
  static const Color textPrimary = Color(0xFF000000);

  /// Secondary text color
  static const Color textSecondary = Color(0xB3000000); // ~70% black

  /// Disabled text color
  static const Color textDisabled = Color(0x4D000000); // ~30% black

  /// Error text color
  static const Color textError = Color(0xFFFF0000);

  // ============================================================================
  // Accent Colors
  // ============================================================================

  /// System accent color
  static const Color accent = Color(0xFF0078D4);

  /// Accent with 40% opacity
  static const Color accentHighlight = Color(0x660078D4);

  /// Accent with 70% opacity for hover
  static const Color accentHover = Color(0xB30078D4);

  // ============================================================================
  // Control/Subtle Fill Colors
  // ============================================================================

  /// Hover button face (17% black)
  static const Color hoverButtonFace = Color(0x2B000000);

  /// Pressed button face (30% black)
  static const Color pressedButtonFace = Color(0x4D000000);

  /// Subtle fill secondary
  static const Color subtleFillSecondary = Color(0x09000000);

  /// Subtle fill tertiary
  static const Color subtleFillTertiary = Color(0x05000000);

  // ============================================================================
  // Divider/Border Colors
  // ============================================================================

  /// Divider stroke color
  static const Color dividerStroke = Color(0x14000000);

  /// Operator panel scroll button background
  static const Color operatorScrollButton = Color(0xFF858585);

  // ============================================================================
  // Equation Colors (for graphing calculator)
  // ============================================================================

  static const List<Color> equationColors = [
    Color(0xFF0063B1), // Blue
    Color(0xFF00B7C3), // Cyan
    Color(0xFF6600CC), // Purple
    Color(0xFF107C10), // Green
    Color(0xFF00CC6A), // Light Green
    Color(0xFF008055), // Teal
    Color(0xFF58595B), // Gray
    Color(0xFFE81123), // Red
    Color(0xFFE3008C), // Pink
    Color(0xFFB31564), // Rose
    Color(0xFFFFB900), // Yellow
    Color(0xFFF7630C), // Orange
    Color(0xFF8E562E), // Brown
    Color(0xFF000000), // Black
  ];
}

/// Font sizes used in the calculator
class CalculatorFontSizes {
  CalculatorFontSizes._();

  // ============================================================================
  // General Font Sizes
  // ============================================================================

  static const double caption = 12.0;
  static const double body = 14.0;
  static const double bodyStrong = 14.0;
  static const double title = 24.0;

  // ============================================================================
  // Button Font Sizes
  // ============================================================================

  /// Standard button caption size
  static const double buttonCaption = 34.0;

  /// Button with text icon
  static const double buttonTextIcon = 38.0;

  /// Standard operator caption (extra large)
  static const double operatorCaptionExtraLarge = 48.0;

  /// Standard operator caption (large)
  static const double operatorCaptionLarge = 24.0;

  /// Standard operator caption (normal)
  static const double operatorCaption = 20.0;

  /// Standard operator caption (small)
  static const double operatorCaptionSmall = 15.0;

  /// Standard operator caption (tiny)
  static const double operatorCaptionTiny = 12.0;

  /// Operator button caption
  static const double operatorButtonCaption = 14.0;

  /// Operator button caption (small)
  static const double operatorButtonCaptionSmall = 12.0;

  // ============================================================================
  // Numeric Button Sizes by Style
  // ============================================================================

  static const double numeric10 = 10.0;
  static const double numeric12 = 12.0;
  static const double numeric14 = 14.0;
  static const double numeric16 = 16.0;
  static const double numeric18 = 18.0;
  static const double numeric24 = 24.0;
  static const double numeric28 = 28.0;
  static const double numeric34 = 34.0;
  static const double numeric38 = 38.0;
  static const double numeric46 = 46.0;
  static const double numeric48 = 48.0;

  // ============================================================================
  // Operator Panel Font Sizes
  // ============================================================================

  /// Operator panel - Large
  static const double operatorPanelLarge = 24.0;
  static const double operatorPanelGlyphLarge = 24.0;
  static const double operatorPanelChevronLarge = 16.0;

  /// Operator panel - Medium
  static const double operatorPanelMedium = 16.0;
  static const double operatorPanelGlyphMedium = 20.0;
  static const double operatorPanelChevronMedium = 10.0;

  /// Operator panel - Small
  static const double operatorPanelSmall = 12.0;
  static const double operatorPanelGlyphSmall = 16.0;
  static const double operatorPanelChevronSmall = 12.0;
}

/// Layout dimensions
class CalculatorDimensions {
  CalculatorDimensions._();

  /// Minimum window height
  static const double minWindowHeight = 500.0;

  /// Minimum window width
  static const double minWindowWidth = 320.0;

  /// Split view open pane length
  static const double splitViewPaneLength = 256.0;

  /// Hamburger button height
  static const double hamburgerHeight = 48.0;

  /// Icon-only button size
  static const double iconOnlyButtonSize = 32.0;

  /// Operator panel button row height - Large
  static const double operatorPanelRowLarge = 70.0;

  /// Operator panel button row height - Medium
  static const double operatorPanelRowMedium = 70.0;

  /// Operator panel button row height - Small
  static const double operatorPanelRowSmall = 44.0;

  /// Button margin
  static const double buttonMargin = 1.0;

  /// Button minimum width
  static const double buttonMinWidth = 24.0;

  /// Button minimum height
  static const double buttonMinHeight = 12.0;

  /// Control corner radius
  static const double controlCornerRadius = 4.0;
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

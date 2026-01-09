import 'package:flutter/material.dart';

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

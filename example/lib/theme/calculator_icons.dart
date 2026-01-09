import 'package:flutter/widgets.dart';

/// Calculator icon font family
class CalculatorIcons {
  CalculatorIcons._();

  static const String _fontFamily = 'CalculatorIcons';

  // ============================================================================
  // Standard Calculator Icons (from CalculatorIcons.ttf)
  // ============================================================================

  /// Percent (%)
  static const IconData percent = IconData(0xE94C, fontFamily: _fontFamily);

  /// Backspace (⌫)
  static const IconData backspace = IconData(0xE94F, fontFamily: _fontFamily);

  /// Reciprocal (1/x)
  static const IconData reciprocal = IconData(0xF7C9, fontFamily: _fontFamily);

  /// Square (x²)
  static const IconData square = IconData(0xF7C8, fontFamily: _fontFamily);

  /// Square root (√x)
  static const IconData squareRoot = IconData(0xF899, fontFamily: _fontFamily);

  /// Divide (÷)
  static const IconData divide = IconData(0xE94A, fontFamily: _fontFamily);

  /// Multiply (×)
  static const IconData multiply = IconData(0xE947, fontFamily: _fontFamily);

  /// Minus (−)
  static const IconData minus = IconData(0xE949, fontFamily: _fontFamily);

  /// Plus (+)
  static const IconData plus = IconData(0xE948, fontFamily: _fontFamily);

  /// Equals (=)
  static const IconData equals = IconData(0xE94E, fontFamily: _fontFamily);

  /// Negate (+/−)
  static const IconData negate = IconData(0xF898, fontFamily: _fontFamily);

  // ============================================================================
  // Scientific Calculator Icons (from CalculatorIcons.ttf)
  // ============================================================================

  /// Cube (x³)
  static const IconData cube = IconData(0xF7CB, fontFamily: _fontFamily);

  /// Cube root (∛x)
  static const IconData cubeRoot = IconData(0xF881, fontFamily: _fontFamily);

  /// Power (xʸ)
  static const IconData power = IconData(0xF7CA, fontFamily: _fontFamily);

  /// Y root (ʸ√x)
  static const IconData yRoot = IconData(0xF7CD, fontFamily: _fontFamily);

  /// Power of 10 (10ˣ)
  static const IconData powerOf10 = IconData(0xF7CC, fontFamily: _fontFamily);

  /// Power of 2 (2ˣ)
  static const IconData powerOf2 = IconData(0xF882, fontFamily: _fontFamily);

  /// Power of e (eˣ)
  static const IconData powerOfE = IconData(0xF7CE, fontFamily: _fontFamily);

  /// Log base Y (logᵧx)
  static const IconData logBaseY = IconData(0xF883, fontFamily: _fontFamily);

  /// Factorial (n!)
  static const IconData factorial = IconData(0xF887, fontFamily: _fontFamily);

  /// Absolute value (|x|)
  static const IconData absoluteValue = IconData(
    0xF884,
    fontFamily: _fontFamily,
  );

  /// Modulo (mod)
  static const IconData modulo = IconData(0xE96F, fontFamily: _fontFamily);

  /// Pi (π)
  static const IconData pi = IconData(0xF7CF, fontFamily: _fontFamily);

  /// Euler's number (e)
  static const IconData euler = IconData(0xF7D0, fontFamily: _fontFamily);

  /// Floor
  static const IconData floor = IconData(0xF885, fontFamily: _fontFamily);

  /// Ceiling
  static const IconData ceiling = IconData(0xF886, fontFamily: _fontFamily);

  /// DMS (Degrees-Minutes-Seconds)
  static const IconData dms = IconData(0xF890, fontFamily: _fontFamily);

  /// Degrees
  static const IconData degrees = IconData(0xF891, fontFamily: _fontFamily);

  /// Shift/2nd function toggle
  static const IconData shift = IconData(0xF897, fontFamily: _fontFamily);

  /// Trig button icon
  static const IconData trigButton = IconData(0xF892, fontFamily: _fontFamily);

  /// Func button icon
  static const IconData funcButton = IconData(0xF893, fontFamily: _fontFamily);

  // ============================================================================
  // Memory Icons
  // ============================================================================

  /// Memory clear (MC)
  static const IconData memoryClear = IconData(0xF754, fontFamily: _fontFamily);

  /// Memory recall (MR)
  static const IconData memoryRecall = IconData(
    0xF753,
    fontFamily: _fontFamily,
  );

  /// Memory add (M+)
  static const IconData memoryAdd = IconData(0xF757, fontFamily: _fontFamily);

  /// Memory subtract (M-)
  static const IconData memorySubtract = IconData(
    0xF758,
    fontFamily: _fontFamily,
  );

  /// Memory store (MS)
  static const IconData memoryStore = IconData(0xF756, fontFamily: _fontFamily);

  // ============================================================================
  // Navigation Menu Icons
  // ============================================================================

  /// Standard calculator
  static const IconData standardCalculator = IconData(
    0xE8EF,
    fontFamily: _fontFamily,
  );

  /// Scientific calculator
  static const IconData scientificCalculator = IconData(
    0xF196,
    fontFamily: _fontFamily,
  );

  /// Programmer calculator
  static const IconData programmerCalculator = IconData(
    0xECC5,
    fontFamily: _fontFamily,
  );

  /// Date calculation
  static const IconData dateCalculation = IconData(
    0xE787,
    fontFamily: _fontFamily,
  );

  /// Currency converter
  static const IconData currency = IconData(0xEB0D, fontFamily: _fontFamily);

  /// Volume converter
  static const IconData volume = IconData(0xE72B, fontFamily: _fontFamily);

  /// Length converter
  static const IconData length = IconData(0xECC6, fontFamily: _fontFamily);

  /// Weight and mass converter
  static const IconData weight = IconData(0xE713, fontFamily: _fontFamily);

  /// Temperature converter
  static const IconData temperature = IconData(0xE7A3, fontFamily: _fontFamily);

  /// Energy converter
  static const IconData energy = IconData(0xECAD, fontFamily: _fontFamily);

  /// Area converter
  static const IconData area = IconData(0xE809, fontFamily: _fontFamily);

  /// Speed converter
  static const IconData speed = IconData(0xE8B7, fontFamily: _fontFamily);

  /// Time converter
  static const IconData time = IconData(0xE823, fontFamily: _fontFamily);

  /// Power converter
  static const IconData powerConverter = IconData(
    0xE945,
    fontFamily: _fontFamily,
  );

  /// Data converter
  static const IconData data = IconData(0xE72C, fontFamily: _fontFamily);

  /// Pressure converter
  static const IconData pressure = IconData(0xEC4A, fontFamily: _fontFamily);

  /// Angle converter
  static const IconData angle = IconData(0xF20F, fontFamily: _fontFamily);

  /// History
  static const IconData history = IconData(0xE81C, fontFamily: _fontFamily);

  /// Memory
  static const IconData memory = IconData(0xE790, fontFamily: _fontFamily);

  /// Settings
  static const IconData settings = IconData(0xE71B, fontFamily: _fontFamily);

  /// Random
  static const IconData random = IconData(0xE970, fontFamily: _fontFamily);
}

/// Extension to create Text widget from IconData using calculator font
extension CalculatorIconText on IconData {
  /// Create a Text widget with this icon
  Text toText({double? size, Color? color}) {
    return Text(
      String.fromCharCode(codePoint),
      style: TextStyle(fontFamily: fontFamily, fontSize: size, color: color),
    );
  }
}

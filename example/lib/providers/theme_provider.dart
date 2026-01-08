import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/calculator_theme.dart';

/// Theme mode (light, dark, system)
enum ThemeMode { light, dark, system }

/// Theme state
class ThemeState {
  final ThemeMode mode;
  final CalculatorTheme theme;

  const ThemeState({
    this.mode = ThemeMode.dark,
    this.theme = CalculatorTheme.dark,
  });

  ThemeState copyWith({ThemeMode? mode, CalculatorTheme? theme}) {
    return ThemeState(mode: mode ?? this.mode, theme: theme ?? this.theme);
  }
}

/// Theme notifier
class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return const ThemeState();
  }

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    CalculatorTheme theme;
    switch (mode) {
      case ThemeMode.light:
        theme = CalculatorTheme.light;
      case ThemeMode.dark:
        theme = CalculatorTheme.dark;
      case ThemeMode.system:
        // For now, default to dark
        theme = CalculatorTheme.dark;
    }
    state = ThemeState(mode: mode, theme: theme);
  }

  /// Toggle between light and dark
  void toggleTheme() {
    if (state.mode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

/// Theme provider
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

/// Convenience provider for just the calculator theme
final calculatorThemeProvider = Provider<CalculatorTheme>((ref) {
  return ref.watch(themeProvider).theme;
});

/// Convenience provider for Flutter's Brightness
final brightnessProvider = Provider<Brightness>((ref) {
  return ref.watch(themeProvider).theme.brightness;
});

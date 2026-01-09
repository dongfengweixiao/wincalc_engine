import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Angle type enum
enum AngleType {
  degree(0, 'DEG'),
  radian(1, 'RAD'),
  gradian(2, 'GRAD');

  final int value;
  final String label;

  const AngleType(this.value, this.label);

  /// Legacy enum values for compatibility
  static const degrees = AngleType.degree;
  static const radians = AngleType.radian;
  static const gradians = AngleType.gradian;
}

/// Trig mode enum
enum TrigMode { normal, hyperbolic }

/// Scientific calculator mode state
class ScientificModeState {
  final AngleType angleType;
  final bool isFEChecked;

  const ScientificModeState({
    this.angleType = AngleType.degree,
    this.isFEChecked = false,
  });

  ScientificModeState copyWith({AngleType? angleType, bool? isFEChecked}) {
    return ScientificModeState(
      angleType: angleType ?? this.angleType,
      isFEChecked: isFEChecked ?? this.isFEChecked,
    );
  }
}

/// Scientific mode state notifier
class ScientificModeNotifier extends Notifier<ScientificModeState> {
  @override
  ScientificModeState build() => const ScientificModeState();

  /// Toggle angle type (DEG -> RAD -> GRAD -> DEG)
  void toggleAngleType() {
    final current = state.angleType;
    final next =
        AngleType.values[(current.value + 1) % AngleType.values.length];
    state = state.copyWith(angleType: next);
  }

  /// Set angle type directly
  void setAngleType(AngleType type) {
    state = state.copyWith(angleType: type);
  }

  /// Toggle F-E (scientific notation) mode
  void toggleFE() {
    state = state.copyWith(isFEChecked: !state.isFEChecked);
  }

  /// Reset F-E mode (typically when clearing)
  void resetFE() {
    state = state.copyWith(isFEChecked: false);
  }
}

/// Provider for scientific mode state
final scientificModeProvider =
    NotifierProvider<ScientificModeNotifier, ScientificModeState>(() {
  return ScientificModeNotifier();
});

/// Scientific calculator shift state provider
final scientificShiftProvider = NotifierProvider<ScientificShiftNotifier, bool>(
  () {
    return ScientificShiftNotifier();
  },
);

/// Notifier for scientific shift state
class ScientificShiftNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void setShift(bool value) {
    state = value;
  }
}

/// Angle type provider (DEG, RAD, GRAD)
final angleTypeProvider = NotifierProvider<AngleTypeNotifier, AngleType>(() {
  return AngleTypeNotifier();
});

/// Notifier for angle type state
class AngleTypeNotifier extends Notifier<AngleType> {
  @override
  AngleType build() => AngleType.degrees;

  void setAngleType(AngleType type) {
    state = type;
  }
}

/// Trigonometric mode provider (normal, hyperbolic)
final trigModeProvider = NotifierProvider<TrigModeNotifier, TrigMode>(() {
  return TrigModeNotifier();
});

/// Notifier for trigonometric mode state
class TrigModeNotifier extends Notifier<TrigMode> {
  @override
  TrigMode build() => TrigMode.normal;

  void setTrigMode(TrigMode mode) {
    state = mode;
  }
}

/// Trig shift (inverse) provider
final trigShiftProvider = NotifierProvider<TrigShiftNotifier, bool>(() {
  return TrigShiftNotifier();
});

/// Notifier for trig shift state
class TrigShiftNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void setShift(bool value) {
    state = value;
  }
}

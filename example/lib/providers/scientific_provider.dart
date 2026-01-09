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

/// Unified scientific calculator state
/// Combines all scientific mode settings into a single state object
class ScientificState {
  final AngleType angleType;
  final bool isFEChecked;
  final bool isShifted;
  final TrigMode trigMode;
  final bool isTrigShifted;

  const ScientificState({
    this.angleType = AngleType.degree,
    this.isFEChecked = false,
    this.isShifted = false,
    this.trigMode = TrigMode.normal,
    this.isTrigShifted = false,
  });

  ScientificState copyWith({
    AngleType? angleType,
    bool? isFEChecked,
    bool? isShifted,
    TrigMode? trigMode,
    bool? isTrigShifted,
  }) {
    return ScientificState(
      angleType: angleType ?? this.angleType,
      isFEChecked: isFEChecked ?? this.isFEChecked,
      isShifted: isShifted ?? this.isShifted,
      trigMode: trigMode ?? this.trigMode,
      isTrigShifted: isTrigShifted ?? this.isTrigShifted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScientificState &&
          other.angleType == angleType &&
          other.isFEChecked == isFEChecked &&
          other.isShifted == isShifted &&
          other.trigMode == trigMode &&
          other.isTrigShifted == isTrigShifted;

  @override
  int get hashCode =>
      angleType.hashCode ^
      isFEChecked.hashCode ^
      isShifted.hashCode ^
      trigMode.hashCode ^
      isTrigShifted.hashCode;
}

/// Unified scientific calculator state notifier
/// Manages all scientific calculator settings in one place
class ScientificNotifier extends Notifier<ScientificState> {
  @override
  ScientificState build() => const ScientificState();

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

  /// Toggle scientific shift (2nd function)
  void toggleShift() {
    state = state.copyWith(isShifted: !state.isShifted);
  }

  /// Set scientific shift state
  void setShift(bool value) {
    state = state.copyWith(isShifted: value);
  }

  /// Toggle trigonometric mode (normal/hyperbolic)
  void toggleTrigMode() {
    final newMode = state.trigMode == TrigMode.normal
        ? TrigMode.hyperbolic
        : TrigMode.normal;
    state = state.copyWith(trigMode: newMode);
  }

  /// Set trigonometric mode
  void setTrigMode(TrigMode mode) {
    state = state.copyWith(trigMode: mode);
  }

  /// Toggle trig shift (inverse)
  void toggleTrigShift() {
    state = state.copyWith(isTrigShifted: !state.isTrigShifted);
  }

  /// Set trig shift state
  void setTrigShift(bool value) {
    state = state.copyWith(isTrigShifted: value);
  }
}

/// Unified scientific calculator state provider
/// Uses autoDispose to automatically dispose when not in use
final scientificProvider =
    NotifierProvider.autoDispose<ScientificNotifier, ScientificState>(
      ScientificNotifier.new,
    );

/// Convenience providers for backward compatibility
/// These delegate to the main scientificProvider but maintain the old API

/// Angle type provider
final angleTypeProvider =
    NotifierProvider.autoDispose<AngleTypeNotifier, AngleType>(
      AngleTypeNotifier.new,
    );

/// Notifier for angle type state
class AngleTypeNotifier extends Notifier<AngleType> {
  @override
  AngleType build() => AngleType.degrees;

  void setAngleType(AngleType type) {
    state = type;
  }
}

/// F-E mode provider
final feModeProvider = NotifierProvider.autoDispose<FEModeNotifier, bool>(
  FEModeNotifier.new,
);

/// Notifier for F-E mode state
class FEModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void reset() {
    state = false;
  }
}

/// Scientific shift provider
final scientificShiftProvider =
    NotifierProvider.autoDispose<ScientificShiftNotifier, bool>(
      ScientificShiftNotifier.new,
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

/// Trig mode provider
final trigModeProvider =
    NotifierProvider.autoDispose<TrigModeNotifier, TrigMode>(
      TrigModeNotifier.new,
    );

/// Notifier for trigonometric mode state
class TrigModeNotifier extends Notifier<TrigMode> {
  @override
  TrigMode build() => TrigMode.normal;

  void setTrigMode(TrigMode mode) {
    state = mode;
  }
}

/// Trig shift provider
final trigShiftProvider = NotifierProvider.autoDispose<TrigShiftNotifier, bool>(
  TrigShiftNotifier.new,
);

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

/// Legacy scientific mode state provider for backward compatibility
@Deprecated('Use scientificProvider instead')
final scientificModeProvider =
    NotifierProvider.autoDispose<ScientificModeNotifier, ScientificState>(
      ScientificModeNotifier.new,
    );

/// Legacy scientific mode state notifier
@Deprecated('Use scientificProvider instead')
class ScientificModeNotifier extends Notifier<ScientificState> {
  @override
  ScientificState build() => const ScientificState();

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

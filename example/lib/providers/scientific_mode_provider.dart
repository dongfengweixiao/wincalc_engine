import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Angle type enum
enum AngleType {
  degree(0, 'DEG'),
  radian(1, 'RAD'),
  gradian(2, 'GRAD');

  final int value;
  final String label;

  const AngleType(this.value, this.label);
}

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

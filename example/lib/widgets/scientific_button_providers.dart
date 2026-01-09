import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Angle type enum
enum AngleType { degrees, radians, gradians }

/// Trig mode enum
enum TrigMode { normal, hyperbolic }

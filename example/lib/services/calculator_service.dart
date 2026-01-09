import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:calc_manager/calc_manager_wrapper.dart';

/// Calculator mode
enum CalculatorMode { standard, scientific, programmer }

/// Convert CalculatorMode to CalcMode (for FFI calls)
CalcMode _toCalcMode(CalculatorMode mode) {
  switch (mode) {
    case CalculatorMode.standard:
      return CalcMode.CALC_MODE_STANDARD;
    case CalculatorMode.scientific:
      return CalcMode.CALC_MODE_SCIENTIFIC;
    case CalculatorMode.programmer:
      return CalcMode.CALC_MODE_PROGRAMMER;
  }
}

/// Calculator service that manages the native calculator instance
class CalculatorService {
  Pointer<CalculatorInstance>? _calculator;
  bool _isInitialized = false;

  /// Whether the calculator is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the calculator
  void initialize() {
    if (_isInitialized) return;
    _calculator = calculator_create();
    calculator_set_standard_mode(_calculator!);
    _isInitialized = true;
  }

  /// Dispose the calculator
  void dispose() {
    if (_isInitialized && _calculator != null) {
      calculator_destroy(_calculator!);
      _calculator = null;
      _isInitialized = false;
    }
  }

  /// Set calculator mode
  void setMode(CalculatorMode mode) {
    if (!_isInitialized) return;
    switch (mode) {
      case CalculatorMode.standard:
        calculator_set_standard_mode(_calculator!);
      case CalculatorMode.scientific:
        calculator_set_scientific_mode(_calculator!);
      case CalculatorMode.programmer:
        calculator_set_programmer_mode(_calculator!);
    }
  }

  /// Send a command to the calculator
  void sendCommand(int command) {
    if (!_isInitialized) return;
    calculator_send_command(_calculator!, command);
  }

  /// Get the primary display text
  String getPrimaryDisplay() {
    if (!_isInitialized) return '0';
    final buffer = calloc<Char>(1024);
    try {
      final length = calculator_get_primary_display(_calculator!, buffer, 1024);
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return '0';
    } finally {
      calloc.free(buffer);
    }
  }

  /// Get the expression display text
  String getExpression() {
    if (!_isInitialized) return '';
    final buffer = calloc<Char>(2048);
    try {
      final length = calculator_get_expression(_calculator!, buffer, 2048);
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return '';
    } finally {
      calloc.free(buffer);
    }
  }

  /// Check if the calculator has an error
  bool hasError() {
    if (!_isInitialized) return false;
    return calculator_has_error(_calculator!) != 0;
  }

  /// Reset the calculator
  void reset({bool clearMemory = true}) {
    if (!_isInitialized) return;
    calculator_reset(_calculator!, clearMemory ? 1 : 0);
  }

  /// Check if input is empty
  bool isInputEmpty() {
    if (!_isInitialized) return true;
    return calculator_is_input_empty(_calculator!) != 0;
  }

  // ============================================================================
  // Memory Functions
  // ============================================================================

  /// Store current value to memory
  void memoryStore() {
    if (!_isInitialized) return;
    calculator_memory_store(_calculator!);
  }

  /// Recall value from memory
  void memoryRecall() {
    if (!_isInitialized) return;
    calculator_memory_recall(_calculator!);
  }

  /// Add current value to memory
  void memoryAdd() {
    if (!_isInitialized) return;
    calculator_memory_add(_calculator!);
  }

  /// Subtract current value from memory
  void memorySubtract() {
    if (!_isInitialized) return;
    calculator_memory_subtract(_calculator!);
  }

  /// Clear all memory
  void memoryClear() {
    if (!_isInitialized) return;
    calculator_memory_clear(_calculator!);
  }

  /// Get memory count
  int getMemoryCount() {
    if (!_isInitialized) return 0;
    return calculator_memory_get_count(_calculator!);
  }

  /// Get memory value at index
  String? getMemoryAt(int index) {
    if (!_isInitialized) return null;
    final buffer = calloc<Char>(1024);
    try {
      final length = calculator_memory_get_at(
        _calculator!,
        index,
        buffer,
        1024,
      );
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return null;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Load memory value at index into display
  void memoryRecallAt(int index) {
    if (!_isInitialized) return;
    calculator_memory_load_at(_calculator!, index);
  }

  /// Clear memory at index
  void memoryClearAt(int index) {
    if (!_isInitialized) return;
    calculator_memory_clear_at(_calculator!, index);
  }

  /// Add current value to memory at index
  void memoryAddAt(int index) {
    if (!_isInitialized) return;
    calculator_memory_add_at(_calculator!, index);
  }

  /// Subtract current value from memory at index
  void memorySubtractAt(int index) {
    if (!_isInitialized) return;
    calculator_memory_subtract_at(_calculator!, index);
  }

  // ============================================================================
  // History Functions
  // ============================================================================

  /// Get history count
  int getHistoryCount() {
    if (!_isInitialized) return 0;
    return calculator_history_get_count(_calculator!);
  }

  /// Get history expression at index
  String? getHistoryExpressionAt(int index) {
    if (!_isInitialized) return null;
    final buffer = calloc<Char>(2048);
    try {
      final length = calculator_history_get_expression_at(
        _calculator!,
        index,
        buffer,
        2048,
      );
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return null;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Get history result at index
  String? getHistoryResultAt(int index) {
    if (!_isInitialized) return null;
    final buffer = calloc<Char>(1024);
    try {
      final length = calculator_history_get_result_at(
        _calculator!,
        index,
        buffer,
        1024,
      );
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return null;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Load history result at index into display
  void loadHistoryAt(int index) {
    if (!_isInitialized) return;
    calculator_history_load_at(_calculator!, index);
  }

  /// Clear history
  void clearHistory() {
    if (!_isInitialized) return;
    calculator_history_clear(_calculator!);
  }

  // ============================================================================
  // Per-Mode History Functions (NEW)
  // ============================================================================

  /// Get history count for a specific mode
  int getHistoryCountForMode(CalculatorMode mode) {
    if (!_isInitialized) return 0;
    return calculator_history_get_count_for_mode(
      _calculator!,
      _toCalcMode(mode),
    );
  }

  /// Get history expression at index for a specific mode
  String? getHistoryExpressionAtForMode(CalculatorMode mode, int index) {
    if (!_isInitialized) return null;
    final buffer = calloc<Char>(2048);
    try {
      final length = calculator_history_get_expression_at_for_mode(
        _calculator!,
        _toCalcMode(mode),
        index,
        buffer,
        2048,
      );
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return null;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Get history result at index for a specific mode
  String? getHistoryResultAtForMode(CalculatorMode mode, int index) {
    if (!_isInitialized) return null;
    final buffer = calloc<Char>(1024);
    try {
      final length = calculator_history_get_result_at_for_mode(
        _calculator!,
        _toCalcMode(mode),
        index,
        buffer,
        1024,
      );
      if (length > 0) {
        return buffer.cast<Utf8>().toDartString(length: length);
      }
      return null;
    } finally {
      calloc.free(buffer);
    }
  }

  /// Clear history for a specific mode
  void clearHistoryForMode(CalculatorMode mode) {
    if (!_isInitialized) return;
    calculator_history_clear_for_mode(_calculator!, _toCalcMode(mode));
  }

  // ============================================================================
  // Parenthesis
  // ============================================================================

  /// Get open parenthesis count
  int getParenthesisCount() {
    if (!_isInitialized) return 0;
    return calculator_get_parenthesis_count(_calculator!);
  }
}

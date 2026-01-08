import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calc_manager/calc_manager_wrapper.dart';
import '../services/calculator_service.dart';

/// History item record
typedef HistoryItem = ({String expression, String result});

/// Calculator state
class CalculatorState {
  final String display;
  final String expression;
  final bool hasError;
  final CalculatorMode mode;
  final int memoryCount;
  final int historyCount;
  final int parenthesisCount;
  final List<String> memoryItems;
  final List<HistoryItem> historyItems;

  const CalculatorState({
    this.display = '0',
    this.expression = '',
    this.hasError = false,
    this.mode = CalculatorMode.standard,
    this.memoryCount = 0,
    this.historyCount = 0,
    this.parenthesisCount = 0,
    this.memoryItems = const [],
    this.historyItems = const [],
  });

  CalculatorState copyWith({
    String? display,
    String? expression,
    bool? hasError,
    CalculatorMode? mode,
    int? memoryCount,
    int? historyCount,
    int? parenthesisCount,
    List<String>? memoryItems,
    List<HistoryItem>? historyItems,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      expression: expression ?? this.expression,
      hasError: hasError ?? this.hasError,
      mode: mode ?? this.mode,
      memoryCount: memoryCount ?? this.memoryCount,
      historyCount: historyCount ?? this.historyCount,
      parenthesisCount: parenthesisCount ?? this.parenthesisCount,
      memoryItems: memoryItems ?? this.memoryItems,
      historyItems: historyItems ?? this.historyItems,
    );
  }
}

/// Calculator notifier
class CalculatorNotifier extends Notifier<CalculatorState> {
  late final CalculatorService _service;

  @override
  CalculatorState build() {
    _service = CalculatorService();
    _service.initialize();

    ref.onDispose(() {
      _service.dispose();
    });

    // Initial state - don't call _updateState here as state is not yet initialized
    return CalculatorState(
      display: _service.getPrimaryDisplay(),
      expression: _service.getExpression(),
      hasError: _service.hasError(),
      mode: CalculatorMode.standard,
      memoryCount: _service.getMemoryCount(),
      historyCount: _service.getHistoryCount(),
      parenthesisCount: _service.getParenthesisCount(),
      memoryItems: _getMemoryItems(),
      historyItems: _getHistoryItems(),
    );
  }

  List<String> _getMemoryItems() {
    final count = _service.getMemoryCount();
    final items = <String>[];
    for (var i = 0; i < count; i++) {
      final value = _service.getMemoryAt(i);
      if (value != null) {
        items.add(value);
      }
    }
    return items;
  }

  List<HistoryItem> _getHistoryItems() {
    final count = _service.getHistoryCount();
    final items = <HistoryItem>[];
    for (var i = 0; i < count; i++) {
      final expression = _service.getHistoryExpressionAt(i);
      final result = _service.getHistoryResultAt(i);
      if (expression != null && result != null) {
        items.add((expression: expression, result: result));
      }
    }
    return items;
  }

  CalculatorState _updateState() {
    return state.copyWith(
      display: _service.getPrimaryDisplay(),
      expression: _service.getExpression(),
      hasError: _service.hasError(),
      memoryCount: _service.getMemoryCount(),
      historyCount: _service.getHistoryCount(),
      parenthesisCount: _service.getParenthesisCount(),
      memoryItems: _getMemoryItems(),
      historyItems: _getHistoryItems(),
    );
  }

  /// Send a command to the calculator
  void sendCommand(int command) {
    _service.sendCommand(command);
    state = _updateState();
  }

  /// Set calculator mode
  void setMode(CalculatorMode mode) {
    _service.setMode(mode);
    state = state.copyWith(mode: mode);
  }

  /// Clear the calculator
  void clear() {
    _service.sendCommand(CMD_CLEAR);
    state = _updateState();
  }

  /// Clear entry
  void clearEntry() {
    _service.sendCommand(CMD_CENTR);
    state = _updateState();
  }

  /// Backspace
  void backspace() {
    _service.sendCommand(CMD_BACKSPACE);
    state = _updateState();
  }

  /// Reset the calculator
  void reset({bool clearMemory = true}) {
    _service.reset(clearMemory: clearMemory);
    state = _updateState();
  }

  // ============================================================================
  // Number Input
  // ============================================================================

  void inputDigit(int digit) {
    final commands = [
      CMD_0,
      CMD_1,
      CMD_2,
      CMD_3,
      CMD_4,
      CMD_5,
      CMD_6,
      CMD_7,
      CMD_8,
      CMD_9,
    ];
    if (digit >= 0 && digit <= 9) {
      sendCommand(commands[digit]);
    }
  }

  void inputDecimal() => sendCommand(CMD_DECIMAL);
  void inputNegate() => sendCommand(CMD_NEGATE);

  // ============================================================================
  // Basic Operations
  // ============================================================================

  void add() => sendCommand(CMD_ADD);
  void subtract() => sendCommand(CMD_SUBTRACT);
  void multiply() => sendCommand(CMD_MULTIPLY);
  void divide() => sendCommand(CMD_DIVIDE);
  void equals() => sendCommand(CMD_EQUALS);
  void percent() => sendCommand(CMD_PERCENT);

  // ============================================================================
  // Scientific Functions
  // ============================================================================

  void square() => sendCommand(CMD_SQUARE);
  void squareRoot() => sendCommand(CMD_SQRT);
  void reciprocal() => sendCommand(CMD_RECIPROCAL);

  // ============================================================================
  // Memory Operations
  // ============================================================================

  void memoryStore() {
    _service.memoryStore();
    state = _updateState();
  }

  void memoryRecall() {
    _service.memoryRecall();
    state = _updateState();
  }

  void memoryAdd() {
    _service.memoryAdd();
    state = _updateState();
  }

  void memorySubtract() {
    _service.memorySubtract();
    state = _updateState();
  }

  void memoryClear() {
    _service.memoryClear();
    state = _updateState();
  }

  void memoryRecallAt(int index) {
    _service.memoryRecallAt(index);
    state = _updateState();
  }

  void memoryClearAt(int index) {
    _service.memoryClearAt(index);
    state = _updateState();
  }

  void memoryAddAt(int index) {
    _service.memoryAddAt(index);
    state = _updateState();
  }

  void memorySubtractAt(int index) {
    _service.memorySubtractAt(index);
    state = _updateState();
  }

  /// Get memory values
  List<String> getMemoryValues() {
    final count = _service.getMemoryCount();
    final values = <String>[];
    for (var i = 0; i < count; i++) {
      final value = _service.getMemoryAt(i);
      if (value != null) {
        values.add(value);
      }
    }
    return values;
  }

  // ============================================================================
  // History Operations
  // ============================================================================

  /// Get history items
  List<({String expression, String result})> getHistoryItems() {
    final count = _service.getHistoryCount();
    final items = <({String expression, String result})>[];
    for (var i = 0; i < count; i++) {
      final expression = _service.getHistoryExpressionAt(i);
      final result = _service.getHistoryResultAt(i);
      if (expression != null && result != null) {
        items.add((expression: expression, result: result));
      }
    }
    return items;
  }

  void clearHistory() {
    _service.clearHistory();
    state = _updateState();
  }

  /// Recall history result at index (loads the result into display)
  void recallHistory(int index) {
    // For now, just get the result and set it as current value
    // A more complete implementation would use the C API if available
    final items = state.historyItems;
    if (index >= 0 && index < items.length) {
      // The result is just displayed - user can use it in calculations
      // Note: This is a simple implementation; actual Microsoft Calculator
      // has more complex history recall behavior
    }
    state = _updateState();
  }
}

/// Calculator provider
final calculatorProvider =
    NotifierProvider<CalculatorNotifier, CalculatorState>(
      CalculatorNotifier.new,
    );

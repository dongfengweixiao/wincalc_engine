import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/calculator_icons.dart';

/// Calculator view mode
enum ViewMode {
  standard,
  scientific,
  programmer,
  // Date calculation is not yet implemented
  // dateCalculation,
}

/// Navigation category for the sidebar
class NavCategory {
  final String name;
  final IconData icon;
  final ViewMode? viewMode;
  final bool isHeader;

  const NavCategory({
    required this.name,
    required this.icon,
    this.viewMode,
    this.isHeader = false,
  });
}

/// Navigation category group
class NavCategoryGroup {
  final String name;
  final List<NavCategory> categories;

  const NavCategoryGroup({required this.name, required this.categories});
}

/// All navigation categories
final navCategories = [
  const NavCategoryGroup(
    name: '计算器',
    categories: [
      NavCategory(
        name: '标准',
        icon: CalculatorIcons.standardCalculator,
        viewMode: ViewMode.standard,
      ),
      NavCategory(
        name: '科学',
        icon: CalculatorIcons.scientificCalculator,
        viewMode: ViewMode.scientific,
      ),
      NavCategory(
        name: '程序员',
        icon: CalculatorIcons.programmerCalculator,
        viewMode: ViewMode.programmer,
      ),
    ],
  ),
  // Converters will be added later
];

/// Navigation state
class NavigationState {
  final bool isDrawerOpen;
  final ViewMode currentMode;
  final bool showHistoryPanel;

  const NavigationState({
    this.isDrawerOpen = false,
    this.currentMode = ViewMode.standard,
    this.showHistoryPanel = false,
  });

  NavigationState copyWith({
    bool? isDrawerOpen,
    ViewMode? currentMode,
    bool? showHistoryPanel,
  }) {
    return NavigationState(
      isDrawerOpen: isDrawerOpen ?? this.isDrawerOpen,
      currentMode: currentMode ?? this.currentMode,
      showHistoryPanel: showHistoryPanel ?? this.showHistoryPanel,
    );
  }

  /// Get display name for current mode
  String get currentModeName {
    switch (currentMode) {
      case ViewMode.standard:
        return '标准';
      case ViewMode.scientific:
        return '科学';
      case ViewMode.programmer:
        return '程序员';
    }
  }
}

/// Navigation notifier
class NavigationNotifier extends Notifier<NavigationState> {
  @override
  NavigationState build() {
    return const NavigationState();
  }

  /// Toggle drawer open/close
  void toggleDrawer() {
    state = state.copyWith(isDrawerOpen: !state.isDrawerOpen);
  }

  /// Open drawer
  void openDrawer() {
    state = state.copyWith(isDrawerOpen: true);
  }

  /// Close drawer
  void closeDrawer() {
    state = state.copyWith(isDrawerOpen: false);
  }

  /// Set current mode
  void setMode(ViewMode mode) {
    state = state.copyWith(currentMode: mode, isDrawerOpen: false);
  }

  /// Toggle history panel visibility
  void toggleHistoryPanel() {
    state = state.copyWith(showHistoryPanel: !state.showHistoryPanel);
  }

  /// Set history panel visibility based on screen width
  void updateHistoryPanelVisibility(double width) {
    // Show history panel when width >= 640
    final shouldShow = width >= 640;
    if (state.showHistoryPanel != shouldShow) {
      state = state.copyWith(showHistoryPanel: shouldShow);
    }
  }
}

/// Navigation provider
final navigationProvider =
    NotifierProvider<NavigationNotifier, NavigationState>(
      NavigationNotifier.new,
    );

/// Current view mode provider
final currentModeProvider = Provider<ViewMode>((ref) {
  return ref.watch(navigationProvider).currentMode;
});

/// Show history panel provider
final showHistoryPanelProvider = Provider<bool>((ref) {
  return ref.watch(navigationProvider).showHistoryPanel;
});

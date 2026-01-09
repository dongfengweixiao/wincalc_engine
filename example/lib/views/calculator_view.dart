import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/calculator_provider.dart';
import '../services/calculator_service.dart';
import '../widgets/display_panel.dart';
import '../widgets/button_panel.dart';
import '../widgets/scientific/scientific_button_panel.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/history_panel.dart';
import '../widgets/bottom_history_sheet.dart';

/// Main calculator view with responsive layout
class CalculatorView extends ConsumerStatefulWidget {
  const CalculatorView({super.key});

  @override
  ConsumerState<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends ConsumerState<CalculatorView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final currentMode = ref.watch(currentModeProvider);

    // Sync calculator mode with navigation mode
    ref.listen(currentModeProvider, (previous, next) {
      if (previous != next) {
        final calcMode = _viewModeToCalculatorMode(next);
        ref.read(calculatorProvider.notifier).setMode(calcMode);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.background,
      drawer: const CalculatorNavigationDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Update history panel visibility based on width
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(navigationProvider.notifier)
                  .updateHistoryPanelVisibility(constraints.maxWidth);
            });

            final showHistoryPanel = constraints.maxWidth >= 640;

            return Row(
              children: [
                // Main calculator area
                Expanded(
                  child: _buildCalculatorBody(context, ref, theme, currentMode),
                ),

                // History panel (when width >= 640)
                if (showHistoryPanel) const HistoryMemoryPanel(),
              ],
            );
          },
        ),
      ),
    );
  }

  CalculatorMode _viewModeToCalculatorMode(ViewMode mode) {
    switch (mode) {
      case ViewMode.standard:
        return CalculatorMode.standard;
      case ViewMode.scientific:
        return CalculatorMode.scientific;
      case ViewMode.programmer:
        return CalculatorMode.programmer;
    }
  }

  void _showBottomHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const BottomHistorySheet(),
    );
  }

  Widget _buildCalculatorBody(
    BuildContext context,
    WidgetRef ref,
    calculatorTheme,
    ViewMode currentMode,
  ) {
    return Column(
      children: [
        // Header with hamburger button, mode name, and theme toggle
        _buildHeader(context, ref, calculatorTheme),

        // Display area
        const Expanded(flex: 2, child: DisplayPanel()),

        // Divider
        Divider(height: 1, color: calculatorTheme.divider),

        // Button panel based on mode
        Expanded(
          flex: currentMode == ViewMode.scientific ? 7 : 5,
          child: _buildButtonPanel(currentMode),
        ),
      ],
    );
  }

  Widget _buildButtonPanel(ViewMode mode) {
    switch (mode) {
      case ViewMode.standard:
        return const StandardButtonPanel();
      case ViewMode.scientific:
        return const ScientificButtonPanel();
      case ViewMode.programmer:
        // TODO: Implement programmer panel
        return const StandardButtonPanel();
    }
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, calculatorTheme) {
    final showHistoryPanel = ref.watch(showHistoryPanelProvider);

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Hamburger button and mode name
          _buildHamburgerButton(ref, calculatorTheme),

          const Spacer(),

          // History button (only when panel is hidden)
          if (!showHistoryPanel)
            _HeaderButton(
              icon: Icons.history,
              theme: calculatorTheme,
              onPressed: () {
                _showBottomHistorySheet(context);
              },
            ),

          // Theme toggle button
          _HeaderButton(
            icon: calculatorTheme.brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            theme: calculatorTheme,
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHamburgerButton(WidgetRef ref, calculatorTheme) {
    final navState = ref.watch(navigationProvider);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Container(
          height: 48,
          padding: const EdgeInsets.only(left: 8, right: 16),
          color: calculatorTheme.background,
          child: Row(
            children: [
              // Hamburger button
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Icon(
                  Icons.menu,
                  color: calculatorTheme.textPrimary,
                  size: 20,
                ),
              ),

              // Mode name
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  navState.currentModeName,
                  style: TextStyle(
                    color: calculatorTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header button widget
class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final dynamic theme;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_HeaderButton> createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<_HeaderButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.textPrimary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(widget.icon, color: widget.theme.textSecondary, size: 18),
        ),
      ),
    );
  }
}

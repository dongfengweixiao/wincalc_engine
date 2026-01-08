import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/calculator_provider.dart';
import '../services/calculator_service.dart';
import '../widgets/display_panel.dart';
import '../widgets/button_panel.dart';
import '../widgets/scientific_button_panel.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/history_panel.dart';

/// Main calculator view with responsive layout
class CalculatorView extends ConsumerWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      backgroundColor: theme.background,
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
                // Navigation sidebar
                const CalculatorNavigationDrawer(),

                // Main calculator area
                Expanded(child: _buildCalculatorBody(ref, theme, currentMode)),

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

  Widget _buildCalculatorBody(
    WidgetRef ref,
    calculatorTheme,
    ViewMode currentMode,
  ) {
    return Column(
      children: [
        // Header with history button and theme toggle
        _buildHeader(ref, calculatorTheme),

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

  Widget _buildHeader(WidgetRef ref, calculatorTheme) {
    final showHistoryPanel = ref.watch(showHistoryPanelProvider);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const Spacer(),

          // History button (only when panel is hidden)
          if (!showHistoryPanel)
            _HeaderButton(
              icon: Icons.history,
              theme: calculatorTheme,
              onPressed: () {
                // Could show a dialog/bottom sheet for history
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

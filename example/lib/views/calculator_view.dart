import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../widgets/display_panel.dart';
import '../widgets/button_panel.dart';

/// Main calculator view
class CalculatorView extends ConsumerWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        title: Text(
          '计算器',
          style: TextStyle(
            color: theme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              color: theme.textPrimary,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            tooltip: '切换主题',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display area - takes up flexible space
            const Expanded(flex: 2, child: DisplayPanel()),

            // Divider
            Divider(height: 1, color: theme.divider),

            // Button panel
            const Expanded(flex: 5, child: StandardButtonPanel()),
          ],
        ),
      ),
    );
  }
}

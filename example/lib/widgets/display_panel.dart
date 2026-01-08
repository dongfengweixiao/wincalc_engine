import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';

/// Calculator display panel
class DisplayPanel extends ConsumerWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculatorState = ref.watch(calculatorProvider);
    final theme = ref.watch(calculatorThemeProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expression display
          if (calculatorState.expression.isNotEmpty)
            Text(
              calculatorState.expression,
              style: TextStyle(
                fontSize: CalculatorFontSizes.numeric16,
                color: theme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),

          const SizedBox(height: 4),

          // Main result display
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              calculatorState.display,
              style: TextStyle(
                fontSize: CalculatorFontSizes.operatorCaptionExtraLarge,
                fontWeight: FontWeight.w300,
                color: calculatorState.hasError
                    ? CalculatorDarkColors.textError
                    : theme.textPrimary,
              ),
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'providers/theme_provider.dart';
import 'views/calculator_view.dart';

void main() async {
  // Initialize window manager
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Set window options
  WindowOptions windowOptions = WindowOptions(
    minimumSize: const Size(320, 500),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const ProviderScope(child: CalculatorApp()));
}

class CalculatorApp extends ConsumerWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: '计算器',
      debugShowCheckedModeBanner: false,
      theme: themeState.theme.toThemeData(),
      home: const CalculatorView(),
    );
  }
}

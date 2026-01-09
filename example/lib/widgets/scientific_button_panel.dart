import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'scientific_button_panel_layout.dart';

/// Scientific calculator button panel
/// This is the main entry point that exports the ScientificButtonPanelLayout
/// to maintain backward compatibility with existing code
class ScientificButtonPanel extends ConsumerWidget {
  const ScientificButtonPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ScientificButtonPanelLayout();
  }
}

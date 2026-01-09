import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_icons.dart';

/// History and memory panel tabs
enum HistoryPanelTab { history, memory }

/// History panel state provider
final historyPanelTabProvider =
    NotifierProvider<HistoryPanelNotifier, HistoryPanelTab>(() {
      return HistoryPanelNotifier();
    });

/// Notifier for history panel tab state
class HistoryPanelNotifier extends Notifier<HistoryPanelTab> {
  @override
  HistoryPanelTab build() => HistoryPanelTab.history;

  void setTab(HistoryPanelTab tab) {
    state = tab;
  }
}

/// History and memory panel widget
class HistoryMemoryPanel extends ConsumerWidget {
  const HistoryMemoryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final currentTab = ref.watch(historyPanelTabProvider);

    return Container(
      width: 320,
      color: theme.background,
      child: Column(
        children: [
          // Tab bar
          _buildTabBar(ref, theme, currentTab),

          // Tab content
          Expanded(
            child: currentTab == HistoryPanelTab.history
                ? const _HistoryList()
                : const _MemoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(
    WidgetRef ref,
    CalculatorTheme theme,
    HistoryPanelTab currentTab,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          _TabButton(
            icon: CalculatorIcons.history,
            label: '历史记录',
            isSelected: currentTab == HistoryPanelTab.history,
            theme: theme,
            onPressed: () => ref
                .read(historyPanelTabProvider.notifier)
                .setTab(HistoryPanelTab.history),
          ),
          const SizedBox(width: 8),
          _TabButton(
            icon: CalculatorIcons.memory,
            label: '内存',
            isSelected: currentTab == HistoryPanelTab.memory,
            theme: theme,
            onPressed: () => ref
                .read(historyPanelTabProvider.notifier)
                .setTab(HistoryPanelTab.memory),
          ),
          const Spacer(),
          // Delete button
          _IconButton(
            icon: Icons.delete_outline,
            theme: theme,
            onPressed: () {
              if (currentTab == HistoryPanelTab.history) {
                ref.read(calculatorProvider.notifier).clearHistory();
              } else {
                ref.read(calculatorProvider.notifier).memoryClear();
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Tab button for history/memory selection
class _TabButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered && !widget.isSelected
                ? widget.theme.textPrimary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border(
                    bottom: BorderSide(
                      color: widget.theme.accentColor,
                      width: 2,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Text(
                String.fromCharCode(widget.icon.codePoint),
                style: TextStyle(
                  fontFamily: widget.icon.fontFamily,
                  fontSize: 16,
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.isSelected
                      ? widget.theme.accentColor
                      : widget.theme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon button for actions
class _IconButton extends StatefulWidget {
  final IconData icon;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _IconButton({
    required this.icon,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_IconButton> createState() => _IconButtonState();
}

class _IconButtonState extends State<_IconButton> {
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
          child: Icon(widget.icon, color: widget.theme.textSecondary, size: 20),
        ),
      ),
    );
  }
}

/// History list widget
class _HistoryList extends ConsumerWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final historyItems = ref.watch(calculatorProvider).historyItems;

    if (historyItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: theme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '还没有历史记录',
              style: TextStyle(color: theme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: historyItems.length,
      itemBuilder: (context, index) {
        final item = historyItems[historyItems.length - 1 - index];
        return _HistoryItem(
          expression: item.expression,
          result: item.result,
          theme: theme,
          onTap: () {
            ref
                .read(calculatorProvider.notifier)
                .recallHistory(historyItems.length - 1 - index);
          },
        );
      },
    );
  }
}

/// Single history item widget
class _HistoryItem extends StatefulWidget {
  final String expression;
  final String result;
  final CalculatorTheme theme;
  final VoidCallback onTap;

  const _HistoryItem({
    required this.expression,
    required this.result,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<_HistoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.textPrimary.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.expression,
                style: TextStyle(
                  color: widget.theme.textSecondary,
                  fontSize: 13,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              Text(
                widget.result,
                style: TextStyle(
                  color: widget.theme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Memory list widget
class _MemoryList extends ConsumerWidget {
  const _MemoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final memoryItems = ref.watch(calculatorProvider).memoryItems;

    if (memoryItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_outlined,
              size: 48,
              color: theme.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '内存中没有数据',
              style: TextStyle(color: theme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '使用内存按钮存储数字',
              style: TextStyle(
                color: theme.textSecondary.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: memoryItems.length,
      itemBuilder: (context, index) {
        return _MemoryItem(
          value: memoryItems[index],
          theme: theme,
          onTap: () {
            ref.read(calculatorProvider.notifier).memoryRecallAt(index);
          },
          onClear: () {
            ref.read(calculatorProvider.notifier).memoryClearAt(index);
          },
          onAdd: () {
            ref.read(calculatorProvider.notifier).memoryAddAt(index);
          },
          onSubtract: () {
            ref.read(calculatorProvider.notifier).memorySubtractAt(index);
          },
        );
      },
    );
  }
}

/// Single memory item widget
class _MemoryItem extends StatefulWidget {
  final String value;
  final CalculatorTheme theme;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  const _MemoryItem({
    required this.value,
    required this.theme,
    required this.onTap,
    required this.onClear,
    required this.onAdd,
    required this.onSubtract,
  });

  @override
  State<_MemoryItem> createState() => _MemoryItemState();
}

class _MemoryItemState extends State<_MemoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.theme.textPrimary.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: widget.onTap,
              child: Text(
                widget.value,
                style: TextStyle(
                  color: widget.theme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            if (_isHovered) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _MemoryAction(
                    label: 'MC',
                    theme: widget.theme,
                    onPressed: widget.onClear,
                  ),
                  const SizedBox(width: 4),
                  _MemoryAction(
                    label: 'M+',
                    theme: widget.theme,
                    onPressed: widget.onAdd,
                  ),
                  const SizedBox(width: 4),
                  _MemoryAction(
                    label: 'M-',
                    theme: widget.theme,
                    onPressed: widget.onSubtract,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Memory action button
class _MemoryAction extends StatefulWidget {
  final String label;
  final CalculatorTheme theme;
  final VoidCallback onPressed;

  const _MemoryAction({
    required this.label,
    required this.theme,
    required this.onPressed,
  });

  @override
  State<_MemoryAction> createState() => _MemoryActionState();
}

class _MemoryActionState extends State<_MemoryAction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.theme.textPrimary.withValues(alpha: 0.1)
                : widget.theme.textPrimary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            widget.label,
            style: TextStyle(color: widget.theme.textSecondary, fontSize: 11),
          ),
        ),
      ),
    );
  }
}

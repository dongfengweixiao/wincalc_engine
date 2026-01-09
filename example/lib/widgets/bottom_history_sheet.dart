import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';
import '../theme/calculator_icons.dart';

/// Bottom history sheet widget
class BottomHistorySheet extends ConsumerStatefulWidget {
  const BottomHistorySheet({super.key});

  @override
  ConsumerState<BottomHistorySheet> createState() => _BottomHistorySheetState();
}

class _BottomHistorySheetState extends ConsumerState<BottomHistorySheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isHistoryTab = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(calculatorThemeProvider);
    final historyItems = ref.watch(calculatorProvider).historyItems;
    final memoryItems = ref.watch(calculatorProvider).memoryItems;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(0, 1 - _animation.value),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.textSecondary.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Tab bar
                _buildTabBar(theme),

                // Content area
                Expanded(
                  child: _isHistoryTab
                      ? _buildHistoryList(historyItems, theme)
                      : _buildMemoryList(memoryItems, theme),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar(CalculatorTheme theme) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // History tab
          _TabButton(
            icon: CalculatorIcons.history,
            label: '历史记录',
            isSelected: _isHistoryTab,
            theme: theme,
            onPressed: () => setState(() => _isHistoryTab = true),
          ),
          const SizedBox(width: 8),
          // Memory tab
          _TabButton(
            icon: CalculatorIcons.memory,
            label: '内存',
            isSelected: !_isHistoryTab,
            theme: theme,
            onPressed: () => setState(() => _isHistoryTab = false),
          ),
          const Spacer(),
          // Close button
          _IconButton(
            icon: Icons.close,
            theme: theme,
            onPressed: () => _closeSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List historyItems, CalculatorTheme theme) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            _closeSheet();
          },
        );
      },
    );
  }

  Widget _buildMemoryList(List memoryItems, CalculatorTheme theme) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: memoryItems.length,
      itemBuilder: (context, index) {
        return _MemoryItem(
          value: memoryItems[index],
          theme: theme,
          onTap: () {
            ref.read(calculatorProvider.notifier).memoryRecallAt(index);
            _closeSheet();
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

  void _closeSheet() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
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

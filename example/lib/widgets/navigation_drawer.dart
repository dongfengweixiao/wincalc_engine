import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/calculator_theme.dart';

/// Navigation drawer for calculator mode selection
class CalculatorNavigationDrawer extends ConsumerWidget {
  const CalculatorNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(calculatorThemeProvider);
    final navState = ref.watch(navigationProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: navState.isDrawerOpen ? 280 : 48,
      color: theme.navPaneBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hamburger button and title
          _buildHeader(ref, theme, navState.isDrawerOpen),

          // Navigation categories
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final group in navCategories)
                    _buildCategoryGroup(ref, theme, group, navState),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref, CalculatorTheme theme, bool isOpen) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // Hamburger button
          _NavigationButton(
            icon: Icons.menu,
            onPressed: () =>
                ref.read(navigationProvider.notifier).toggleDrawer(),
            theme: theme,
          ),
          // Title (only when open)
          if (isOpen)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  ref.watch(navigationProvider).currentModeName,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryGroup(
    WidgetRef ref,
    CalculatorTheme theme,
    NavCategoryGroup group,
    NavigationState navState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header (only when drawer is open)
        if (navState.isDrawerOpen)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              group.name,
              style: TextStyle(
                color: theme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        // Category items
        for (final category in group.categories)
          _buildCategoryItem(ref, theme, category, navState),
      ],
    );
  }

  Widget _buildCategoryItem(
    WidgetRef ref,
    CalculatorTheme theme,
    NavCategory category,
    NavigationState navState,
  ) {
    final isSelected = category.viewMode == navState.currentMode;

    return _NavigationItem(
      icon: category.icon,
      label: category.name,
      isSelected: isSelected,
      isExpanded: navState.isDrawerOpen,
      theme: theme,
      onPressed: category.viewMode != null
          ? () => ref
                .read(navigationProvider.notifier)
                .setMode(category.viewMode!)
          : null,
    );
  }
}

/// Navigation button (hamburger menu)
class _NavigationButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final CalculatorTheme theme;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
    required this.theme,
  });

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 48,
          height: 48,
          color: _isHovered
              ? widget.theme.textPrimary.withValues(alpha: 0.1)
              : Colors.transparent,
          child: Icon(widget.icon, color: widget.theme.textPrimary, size: 20),
        ),
      ),
    );
  }
}

/// Navigation item (mode selector)
class _NavigationItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final CalculatorTheme theme;
  final VoidCallback? onPressed;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.theme,
    this.onPressed,
  });

  @override
  State<_NavigationItem> createState() => _NavigationItemState();
}

class _NavigationItemState extends State<_NavigationItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = widget.theme.accentColor.withValues(alpha: 0.15);
    } else if (_isHovered) {
      backgroundColor = widget.theme.textPrimary.withValues(alpha: 0.08);
    } else {
      backgroundColor = Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          height: 40,
          margin: EdgeInsets.symmetric(
            horizontal: widget.isExpanded ? 4 : 2,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: widget.isSelected
                ? Border(
                    left: BorderSide(color: widget.theme.accentColor, width: 3),
                  )
                : null,
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              // Icon
              SizedBox(
                width: widget.isExpanded ? 40 : 36,
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.isSelected
                        ? widget.theme.accentColor
                        : widget.theme.textPrimary,
                    size: 18,
                  ),
                ),
              ),
              // Label (only when expanded)
              if (widget.isExpanded)
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isSelected
                          ? widget.theme.accentColor
                          : widget.theme.textPrimary,
                      fontSize: 14,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class CustomNavigationRail extends StatefulWidget {
  final FocusNode focusNode;
  final PageController pageController;
  final bool isSidebarExpanded;
  final Function(bool) onSidebarExpandedChanged;

  const CustomNavigationRail({
    super.key,
    required this.focusNode,
    required this.pageController,
    required this.isSidebarExpanded,
    required this.onSidebarExpandedChanged,
  });

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  static const double minWidth = 70.0;
  static const double expandedWidth = 250.0;

  int _focusedIndex = 0;

  final List<NavigationItem> _navItems = [
    NavigationItem(title: 'Home', icon: Iconsax.home),
    NavigationItem(title: 'Movies', icon: Iconsax.video),
    NavigationItem(title: 'Series', icon: Iconsax.play_circle),
    NavigationItem(title: 'My List', icon: Iconsax.bookmark),
    NavigationItem(title: 'Settings', icon: Iconsax.setting_2),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      focusNode: widget.focusNode,
      canRequestFocus: true,
      onFocusChange: (hasFocus) {
        setState(() {
          widget.onSidebarExpandedChanged(hasFocus); // Handle expansion
        });
      },
      onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          _moveFocus(-1);
          return KeyEventResult.handled;
        }
        if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          _moveFocus(1);
          return KeyEventResult.handled;
        }
        if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          _navigateToPage(_focusedIndex);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isSidebarExpanded ? expandedWidth : minWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.secondary.withOpacity(0.6),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: _navItems.length,
          itemBuilder: (context, index) {
            final item = _navItems[index];
            final isSelected = _focusedIndex == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.secondary.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    color: isSelected
                        ? theme.colorScheme.secondary
                        : Colors.white,
                  ),
                  const SizedBox(width: 12.0),
                  if (widget.isSidebarExpanded)
                    Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.secondary
                            : Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _moveFocus(int direction) {
    setState(() {
      _focusedIndex = (_focusedIndex + direction).clamp(0, _navItems.length - 1);
    });
    widget.pageController.jumpToPage(_focusedIndex);
  }

  void _navigateToPage(int index) {
    widget.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class NavigationItem{
  final String title;
  final IconData icon;

  NavigationItem({required this.title, required this.icon});
}
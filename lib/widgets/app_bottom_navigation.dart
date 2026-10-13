import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// AppBottomNavigation renders a clean, modern bottom navigation bar.
/// Demonstrates:
/// - Custom navigation bar component with 4 destinations
/// - Clear selected state in primary accent color
/// - Responsive icon/label transitions
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final destinations = [
      const _NavDestination(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
        label: 'Home',
      ),
      const _NavDestination(
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment_rounded,
        label: 'Tasks',
      ),
      const _NavDestination(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_month_rounded,
        label: 'Timetable',
      ),
      const _NavDestination(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181A28) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF292C42)
                : const Color(0xFFEBEFF7),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(destinations.length, (index) {
              final item = destinations[index];
              final isSelected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(index),
                  borderRadius: BorderRadius.circular(16),
                  splashColor: AppTheme.primaryAccent.withOpacity(0.1),
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                    ? AppTheme.primaryDarkAccent.withOpacity(0.2)
                                    : AppTheme.paleLavender)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 22,
                            color: isSelected
                                ? (isDark
                                    ? AppTheme.primaryDarkAccent
                                    : AppTheme.primaryAccent)
                                : (isDark
                                    ? const Color(0xFF888DA3)
                                    : const Color(0xFF8E93A6)),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? (isDark
                                    ? AppTheme.primaryDarkAccent
                                    : AppTheme.primaryAccent)
                                : (isDark
                                    ? const Color(0xFF888DA3)
                                    : const Color(0xFF8E93A6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

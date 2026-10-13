import 'package:flutter/material.dart';

/// StatCard displays a compact metric card on the Home Dashboard.
/// Demonstrates:
/// - Reusable custom widget composition
/// - Clean typography hierarchy
/// - Color containers with subtle pastel accents
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF292C42)
                  : const Color(0xFFE8EAF2).withOpacity(0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : const Color(0xFF1E2038).withOpacity(0.03),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Colored Icon Bubble
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(isDark ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 12),
              // Value (Count)
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF22243A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              // Subtitle
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF969AB0)
                      : const Color(0xFF85899B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// EmptyStateWidget displays a clean, friendly placeholder when no data exists.
/// Demonstrates:
/// - Handling empty lists cleanly in mobile UX
/// - Centered layouts with custom icon containers
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent.withOpacity(isDark ? 0.2 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 34,
                color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 16),
                label: Text(actionLabel!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                  side: BorderSide(
                    color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

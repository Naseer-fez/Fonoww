import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';
import '../theme/app_theme.dart';

/// AssignmentCard renders a polished card for an individual assignment.
/// Demonstrates:
/// - Custom widget composition and layout (Row, Column, AnimatedContainer)
/// - Date formatting with the `intl` package
/// - Interactive state toggle with animation
/// - Visual hierarchy with badges and status colors
/// - Dismiss/delete confirmation dialogs
class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final ValueChanged<bool>? onToggleCompletion;
  final VoidCallback? onDelete;
  final bool showDeleteButton;

  const AssignmentCard({
    super.key,
    required this.assignment,
    this.onToggleCompletion,
    this.onDelete,
    this.showDeleteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateFormatter = DateFormat('EEE, MMM d');

    // Determine Status Badge properties
    final Color badgeBg;
    final Color badgeText;
    final String badgeLabel;

    if (assignment.completed) {
      badgeBg = AppTheme.successMint.withOpacity(isDark ? 0.2 : 0.12);
      badgeText = AppTheme.successMint;
      badgeLabel = 'Completed';
    } else if (assignment.isOverdue) {
      badgeBg = AppTheme.softCoral.withOpacity(isDark ? 0.22 : 0.12);
      badgeText = AppTheme.softCoral;
      badgeLabel = 'Overdue';
    } else if (assignment.isDueToday) {
      badgeBg = AppTheme.gentlePeach.withOpacity(isDark ? 0.25 : 0.18);
      badgeText = const Color(0xFFE65100);
      badgeLabel = 'Due Today';
    } else {
      badgeBg = isDark ? const Color(0xFF282B3F) : const Color(0xFFEEF0F8);
      badgeText = isDark ? const Color(0xFFA5AABF) : const Color(0xFF6B7280);
      badgeLabel = 'Upcoming';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: assignment.isOverdue && !assignment.completed
              ? AppTheme.softCoral.withOpacity(0.4)
              : (isDark
                  ? const Color(0xFF292C42)
                  : const Color(0xFFE8EAF2).withOpacity(0.8)),
          width: assignment.isOverdue && !assignment.completed ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : const Color(0xFF1E2038).withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Interactive Checkbox
            GestureDetector(
              onTap: onToggleCompletion != null
                  ? () => onToggleCompletion!(!assignment.completed)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOut,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: assignment.completed
                      ? AppTheme.successMint
                      : Colors.transparent,
                  border: Border.all(
                    color: assignment.completed
                        ? AppTheme.successMint
                        : (isDark ? const Color(0xFF5A5F7D) : const Color(0xFFBDC2D5)),
                    width: 2,
                  ),
                ),
                child: assignment.completed
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            // Center details (Title, Subject, Due Date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    assignment.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: assignment.completed
                          ? (isDark ? const Color(0xFF757A92) : const Color(0xFF9CA3AF))
                          : (isDark ? Colors.white : const Color(0xFF22243A)),
                      decoration: assignment.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Subject label
                  Text(
                    assignment.subject,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Bottom info: Date & Status Badge
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: isDark ? const Color(0xFF888DA3) : const Color(0xFF85899B),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        dateFormatter.format(assignment.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xFF888DA3) : const Color(0xFF85899B),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: badgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Optional Delete Button
            if (showDeleteButton && onDelete != null)
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: isDark ? const Color(0xFF7E849E) : const Color(0xFFA0A5BA),
                ),
                splashRadius: 20,
                onPressed: () => _confirmDelete(context),
              ),
          ],
        ),
      ),
    );
  }

  /// Show delete confirmation dialog before deleting an assignment
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment.title}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onDelete != null) onDelete!();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.softCoral,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../theme/app_theme.dart';
import '../widgets/assignment_card.dart';
import '../widgets/empty_state_widget.dart';
import 'add_assignment_screen.dart';

enum AssignmentFilter { all, pending, completed }

/// AssignmentsScreen manages the student's tasks.
/// Demonstrates:
/// - State management using setState
/// - List filtering and transformation
/// - Navigator.push / Navigator.pop pattern
/// - Interactive SQLite CRUD operations
/// - AnimatedContainer for filter chips
/// - SnackBar feedback and empty states
class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;
  final Future<void> Function() onRefreshData;
  final Future<void> Function(Assignment) onToggleAssignment;
  final Future<void> Function(int) onDeleteAssignment;
  final Future<void> Function(Assignment) onAddAssignment;

  const AssignmentsScreen({
    super.key,
    required this.assignments,
    required this.onRefreshData,
    required this.onToggleAssignment,
    required this.onDeleteAssignment,
    required this.onAddAssignment,
  });

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  AssignmentFilter _currentFilter = AssignmentFilter.all;

  /// Open Add Assignment screen and persist result if created
  Future<void> _navigateToAddAssignment() async {
    final newAssignment = await Navigator.of(context).push<Assignment>(
      MaterialPageRoute(
        builder: (context) => const AddAssignmentScreen(),
      ),
    );

    if (newAssignment != null) {
      await widget.onAddAssignment(newAssignment);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${newAssignment.title}" successfully!'),
            backgroundColor: AppTheme.successMint,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Filter assignments according to selected chip
  List<Assignment> _getFilteredAssignments() {
    switch (_currentFilter) {
      case AssignmentFilter.all:
        return widget.assignments;
      case AssignmentFilter.pending:
        return widget.assignments.where((a) => !a.completed).toList();
      case AssignmentFilter.completed:
        return widget.assignments.where((a) => a.completed).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final pendingCount = widget.assignments.where((a) => !a.completed).length;
    final filteredList = _getFilteredAssignments();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Screen Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Assignments',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF22243A),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pendingCount == 0
                            ? 'All tasks completed — Great job!'
                            : '$pendingCount ${pendingCount == 1 ? 'task' : 'tasks'} pending attention',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                        ),
                      ),
                    ],
                  ),
                  // Add Button
                  ElevatedButton.icon(
                    onPressed: _navigateToAddAssignment,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: const Size(80, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Filter Chips Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _buildFilterChip('All', AssignmentFilter.all, isDark, widget.assignments.length),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', AssignmentFilter.pending, isDark, pendingCount),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Completed',
                    AssignmentFilter.completed,
                    isDark,
                    widget.assignments.length - pendingCount,
                  ),
                ],
              ),
            ),

            // 3. Filtered List or Empty State
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final assignment = filteredList[index];
                        return AssignmentCard(
                          key: ValueKey(assignment.id ?? index),
                          assignment: assignment,
                          showDeleteButton: true,
                          onToggleCompletion: (_) async {
                            await widget.onToggleAssignment(assignment);
                          },
                          onDelete: () async {
                            if (assignment.id != null) {
                              await widget.onDeleteAssignment(assignment.id!);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Deleted "${assignment.title}"'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom Animated Filter Chip Widget
  Widget _buildFilterChip(
    String label,
    AssignmentFilter filter,
    bool isDark,
    int count,
  ) {
    final isSelected = _currentFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent)
              : (isDark ? const Color(0xFF1E2030) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent)
                : (isDark ? const Color(0xFF292C42) : const Color(0xFFE2E5EE)),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFADB2C6) : const Color(0xFF5D6175)),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.24)
                    : (isDark ? const Color(0xFF292C42) : const Color(0xFFECEFF6)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFF969AB0) : const Color(0xFF6A6E82)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty State for the current filter
  Widget _buildEmptyState() {
    switch (_currentFilter) {
      case AssignmentFilter.all:
        return EmptyStateWidget(
          icon: Icons.assignment_turned_in_outlined,
          title: 'No Assignments Yet',
          message: 'Stay ahead of your coursework by adding your first assignment.',
          actionLabel: 'Add Assignment',
          onAction: _navigateToAddAssignment,
        );
      case AssignmentFilter.pending:
        return const EmptyStateWidget(
          icon: Icons.sentiment_very_satisfied_outlined,
          title: 'All Tasks Finished!',
          message: 'You have no pending assignments right now. Enjoy your break!',
        );
      case AssignmentFilter.completed:
        return const EmptyStateWidget(
          icon: Icons.checklist_outlined,
          title: 'No Completed Tasks',
          message: 'Tasks you mark as done will show up here.',
        );
    }
  }
}

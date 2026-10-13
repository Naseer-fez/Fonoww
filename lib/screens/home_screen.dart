import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';
import '../models/class_session.dart';
import '../theme/app_theme.dart';
import '../widgets/assignment_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/stat_card.dart';

/// HomeScreen renders the main dashboard for Campus Buddy.
/// Demonstrates:
/// - Composite dashboard screen layout
/// - Dynamic calculations (percentage, pending counts) based on live SQLite data
/// - Animated progress indicators using TweenAnimationBuilder
/// - Rich widget composition (Header, Quote, Progress, Stats, Classes, Upcoming)
/// - Responsive scrolling layout without overflow
class HomeScreen extends StatelessWidget {
  final List<Assignment> assignments;
  final Function(int tabIndex) onNavigateToTab;
  final ValueChanged<Assignment> onToggleAssignment;

  const HomeScreen({
    super.key,
    required this.assignments,
    required this.onNavigateToTab,
    required this.onToggleAssignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, MMM d').format(now);

    // Compute live metrics from actual SQLite assignment data
    final totalCount = assignments.length;
    final completedCount = assignments.where((a) => a.completed).length;
    final pendingCount = totalCount - completedCount;
    final double completionRatio = totalCount == 0 ? 0.0 : (completedCount / totalCount);
    final int percentage = (completionRatio * 100).round();

    // Get today's classes from static schedule
    final todaysClasses = ClassSession.getClassesForDay(now.weekday);

    // Get 2-3 upcoming non-completed assignments
    final upcomingAssignments = assignments
        .where((a) => !a.completed)
        .take(3)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Greeting, Heading, Date, Avatar, Notification)
              _buildHeader(context, isDark, dateFormatted),
              const SizedBox(height: 20),

              // 2. Quote of the Day (Live REST API Integration)
              const QuoteCard(),
              const SizedBox(height: 20),

              // 3. Progress Overview Card
              _buildProgressCard(context, isDark, completedCount, totalCount, completionRatio, percentage),
              const SizedBox(height: 20),

              // 4. Quick Statistics Row (Pending, Completed, Classes)
              _buildQuickStats(context, pendingCount, completedCount, todaysClasses.length),
              const SizedBox(height: 28),

              // 5. Today's Classes Section
              _buildClassesSection(context, isDark, todaysClasses),
              const SizedBox(height: 28),

              // 6. Upcoming Assignments Section
              _buildUpcomingAssignmentsSection(context, isDark, upcomingAssignments),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// 1. Header with Avatar, Greeting, and Notification Bell
  Widget _buildHeader(BuildContext context, bool isDark, String dateFormatted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormatted,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Ready for today, ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF22243A),
                    letterSpacing: -0.4,
                  ),
                ),
                Text(
                  'Naseer?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            // Notification Bell with indicator
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2030) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2),
                ),
              ),
              child: IconButton(
                icon: const Stack(
                  children: [
                    Icon(Icons.notifications_outlined, size: 22),
                    PositionDirectional(
                      top: 0,
                      end: 0,
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: AppTheme.softCoral,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All caught up! No new notifications.'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            // Profile Avatar with Initials "SN"
            InkWell(
              onTap: () => onNavigateToTab(3), // Navigate to Profile tab
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7567E8), Color(0xFF9083F8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 2. Progress Overview Card with Animated Progress Bar
  Widget _buildProgressCard(
    BuildContext context,
    bool isDark,
    int completed,
    int total,
    double ratio,
    int percentage,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF292C42)
              : const Color(0xFFE8EAF2).withOpacity(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : const Color(0xFF1E2038).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Assignments Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF22243A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryAccent.withOpacity(isDark ? 0.25 : 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            total == 0
                ? 'No assignments added yet'
                : '$completed of $total tasks completed so far',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
            ),
          ),
          const SizedBox(height: 16),

          // Animated rounded progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0.0, end: ratio),
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: isDark
                      ? const Color(0xFF2B2E46)
                      : const Color(0xFFEDE9FE).withOpacity(0.7),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Quick Statistics Row (Pending, Completed, Classes)
  Widget _buildQuickStats(BuildContext context, int pending, int completed, int classesCount) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Pending',
            value: '$pending',
            icon: Icons.hourglass_bottom_rounded,
            accentColor: AppTheme.gentlePeach,
            onTap: () => onNavigateToTab(1), // Go to Tasks
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Completed',
            value: '$completed',
            icon: Icons.check_circle_outline_rounded,
            accentColor: AppTheme.successMint,
            onTap: () => onNavigateToTab(1), // Go to Tasks
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: "Today's Classes",
            value: '$classesCount',
            icon: Icons.school_outlined,
            accentColor: AppTheme.softSkyBlue,
            onTap: () => onNavigateToTab(2), // Go to Timetable
          ),
        ),
      ],
    );
  }

  /// 4. Today's Classes List
  Widget _buildClassesSection(BuildContext context, bool isDark, List<ClassSession> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Classes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            TextButton(
              onPressed: () => onNavigateToTab(2), // Timetable tab
              child: const Text('Full Timetable'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (classes.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2030) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.weekend_outlined,
                  size: 28,
                  color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'No classes scheduled today. Enjoy your self-study time!',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: classes.take(3).map((session) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2030) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: session.accentColor.withOpacity(isDark ? 0.25 : 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(session.icon, color: session.accentColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.subject,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF22243A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${session.startTime} - ${session.endTime} • ${session.room}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  /// 5. Upcoming Assignments Section
  Widget _buildUpcomingAssignmentsSection(
    BuildContext context,
    bool isDark,
    List<Assignment> upcoming,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Assignments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            TextButton(
              onPressed: () => onNavigateToTab(1), // Tasks tab
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (upcoming.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2030) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.task_alt_rounded,
                  size: 28,
                  color: AppTheme.successMint,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'All caught up! No upcoming assignments due.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: upcoming.map((item) {
              return AssignmentCard(
                assignment: item,
                showDeleteButton: false,
                onToggleCompletion: (_) => onToggleAssignment(item),
              );
            }).toList(),
          ),
      ],
    );
  }
}

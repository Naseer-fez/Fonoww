import 'package:flutter/material.dart';
import '../models/class_session.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state_widget.dart';

/// TimetableScreen displays the weekly class schedule.
/// Demonstrates:
/// - Static Dart data usage
/// - Interactive day selector using AnimatedContainer
/// - Dynamic list filtering based on selected weekday
/// - Custom class card UI with subject icons and classroom badges
/// - Friendly empty state for class-free days
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  // Days of week metadata (1 = Mon to 7 = Sun)
  final List<Map<String, dynamic>> _weekdays = const [
    {'name': 'Mon', 'day': DateTime.monday, 'full': 'Monday'},
    {'name': 'Tue', 'day': DateTime.tuesday, 'full': 'Tuesday'},
    {'name': 'Wed', 'day': DateTime.wednesday, 'full': 'Wednesday'},
    {'name': 'Thu', 'day': DateTime.thursday, 'full': 'Thursday'},
    {'name': 'Fri', 'day': DateTime.friday, 'full': 'Friday'},
    {'name': 'Sat', 'day': DateTime.saturday, 'full': 'Saturday'},
    {'name': 'Sun', 'day': DateTime.sunday, 'full': 'Sunday'},
  ];

  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    // Default to current day of week (or Monday if Sunday)
    final today = DateTime.now().weekday;
    _selectedDay = today;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedDayMeta = _weekdays.firstWhere(
      (w) => w['day'] == _selectedDay,
      orElse: () => _weekdays.first,
    );
    final classesForSelectedDay = ClassSession.getClassesForDay(_selectedDay);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class Timetable',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF22243A),
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${selectedDayMeta['full']} • ${classesForSelectedDay.length} ${classesForSelectedDay.length == 1 ? 'lecture' : 'lectures'}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Weekday Selector Strip
            SizedBox(
              height: 64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _weekdays.length,
                itemBuilder: (context, index) {
                  final dayMeta = _weekdays[index];
                  final dayNum = dayMeta['day'] as int;
                  final isSelected = _selectedDay == dayNum;
                  final isToday = DateTime.now().weekday == dayNum;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = dayNum;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutQuad,
                      width: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent)
                            : (isDark ? const Color(0xFF1E2030) : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? (isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent)
                              : (isDark ? const Color(0xFF292C42) : const Color(0xFFE5E7F0)),
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryAccent.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayMeta['name'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? const Color(0xFFADB2C6) : const Color(0xFF5A5E73)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Small dot indicating "today"
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.white
                                  : (isToday ? AppTheme.primaryAccent : Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // 3. Classes Schedule List
            Expanded(
              child: classesForSelectedDay.isEmpty
                  ? EmptyStateWidget(
                      icon: Icons.coffee_outlined,
                      title: 'No Classes Today',
                      message: 'Enjoy your free day or use it to work on assignments!',
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      itemCount: classesForSelectedDay.length,
                      itemBuilder: (context, index) {
                        final session = classesForSelectedDay[index];
                        return _buildClassCard(context, session, isDark);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Class Session Card
  Widget _buildClassCard(BuildContext context, ClassSession session, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2).withOpacity(0.8),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Colored Icon Box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: session.accentColor.withOpacity(isDark ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                session.icon,
                color: session.accentColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Right Info Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Code badge & Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: session.accentColor.withOpacity(isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          session.code,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: session.accentColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${session.startTime} - ${session.endTime}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Subject Title
                  Text(
                    session.subject,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF22243A),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Location and Instructor
                  Row(
                    children: [
                      Icon(
                        Icons.room_outlined,
                        size: 14,
                        color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        session.room,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          session.instructor,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

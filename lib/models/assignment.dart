/// Assignment Model Class
/// Demonstrates:
/// - Dart OOP, Encapsulation, and Model Classes
/// - Data types (int, String, DateTime, bool)
/// - Named constructors, JSON/Map serialization for SQLite
/// - Computed properties (isOverdue, isDueToday)
class Assignment {
  final int? id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final bool completed;

  Assignment({
    this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.completed = false,
  });

  /// Check if the assignment is overdue (past due date and not completed)
  bool get isOverdue {
    if (completed) return false;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final dueDayStart = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return dueDayStart.isBefore(todayStart);
  }

  /// Check if the assignment is due today
  bool get isDueToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  /// Convert model instance to a Map for SQLite insertion/updates
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'subject': subject,
      'dueDate': dueDate.toIso8601String(),
      'completed': completed ? 1 : 0,
    };
  }

  /// Create an Assignment instance from an SQLite record Map
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] as int?,
      title: map['title'] as String,
      subject: map['subject'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      completed: (map['completed'] as int) == 1,
    );
  }

  /// CopyWith pattern for immutable updates
  Assignment copyWith({
    int? id,
    String? title,
    String? subject,
    DateTime? dueDate,
    bool? completed,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() {
    return 'Assignment(id: $id, title: "$title", subject: "$subject", due: $dueDate, completed: $completed)';
  }
}

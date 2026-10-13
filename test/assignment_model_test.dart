import 'package:flutter_test/flutter_test.dart';
import 'package:campus_buddy/models/assignment.dart';
import 'package:campus_buddy/models/class_session.dart';
import 'package:campus_buddy/models/quote.dart';

void main() {
  group('Assignment Model Tests', () {
    test('Assignment toMap and fromMap serialization', () {
      final dueDate = DateTime(2026, 10, 20, 14, 0);
      final assignment = Assignment(
        id: 42,
        title: 'Flutter UI Design',
        subject: 'Mobile App Development',
        dueDate: dueDate,
        completed: true,
      );

      final map = assignment.toMap();
      expect(map['id'], 42);
      expect(map['title'], 'Flutter UI Design');
      expect(map['subject'], 'Mobile App Development');
      expect(map['dueDate'], dueDate.toIso8601String());
      expect(map['completed'], 1);

      final fromMapAssignment = Assignment.fromMap(map);
      expect(fromMapAssignment.id, 42);
      expect(fromMapAssignment.title, 'Flutter UI Design');
      expect(fromMapAssignment.subject, 'Mobile App Development');
      expect(fromMapAssignment.dueDate, dueDate);
      expect(fromMapAssignment.completed, true);
    });

    test('isOverdue returns true for uncompleted past assignment', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 3));
      final overdueAssignment = Assignment(
        title: 'Past Task',
        subject: 'Algorithms',
        dueDate: pastDate,
        completed: false,
      );

      expect(overdueAssignment.isOverdue, isTrue);

      // Completed assignment is not overdue
      final completedPastAssignment = overdueAssignment.copyWith(completed: true);
      expect(completedPastAssignment.isOverdue, isFalse);
    });

    test('isDueToday correctly identifies tasks due today', () {
      final now = DateTime.now();
      final todayAssignment = Assignment(
        title: 'Due Today Task',
        subject: 'Networks',
        dueDate: now,
        completed: false,
      );

      expect(todayAssignment.isDueToday, isTrue);
    });

    test('copyWith properly updates specific fields', () {
      final original = Assignment(
        id: 1,
        title: 'Original Title',
        subject: 'Math',
        dueDate: DateTime.now(),
        completed: false,
      );

      final updated = original.copyWith(completed: true, title: 'Updated Title');
      expect(updated.id, 1);
      expect(updated.title, 'Updated Title');
      expect(updated.subject, 'Math');
      expect(updated.completed, true);
    });
  });

  group('Quote Model Tests', () {
    test('Quote fromJson parsing', () {
      final json = {
        'id': 10,
        'quote': 'Keep striving.',
        'author': 'Alan Turing',
      };

      final quote = Quote.fromJson(json);
      expect(quote.id, 10);
      expect(quote.quote, 'Keep striving.');
      expect(quote.author, 'Alan Turing');
    });

    test('Quote fallback values when json fields missing', () {
      final quote = Quote.fromJson({});
      expect(quote.quote, isNotEmpty);
      expect(quote.author, isNotEmpty);
    });
  });

  group('ClassSession Model Tests', () {
    test('getClassesForDay returns scheduled classes for Monday', () {
      final mondayClasses = ClassSession.getClassesForDay(DateTime.monday);
      expect(mondayClasses, isNotEmpty);
      expect(mondayClasses.every((c) => c.dayOfWeek == DateTime.monday), isTrue);
    });

    test('getClassesForDay returns empty list for Sunday', () {
      final sundayClasses = ClassSession.getClassesForDay(DateTime.sunday);
      expect(sundayClasses, isEmpty);
    });
  });
}

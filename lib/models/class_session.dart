import 'package:flutter/material.dart';

/// ClassSession Model Class
/// Demonstrates:
/// - Static Dart data structures and Lists
/// - Modeling college schedule items with times, classrooms, and subject metadata
class ClassSession {
  final String id;
  final int dayOfWeek; // 1 = Mon, 2 = Tue, 3 = Wed, 4 = Thu, 5 = Fri, 6 = Sat, 7 = Sun
  final String subject;
  final String code;
  final String startTime;
  final String endTime;
  final String room;
  final String instructor;
  final Color accentColor;
  final IconData icon;

  const ClassSession({
    required this.id,
    required this.dayOfWeek,
    required this.subject,
    required this.code,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.instructor,
    required this.accentColor,
    required this.icon,
  });

  /// Realistic college sample timetable data
  static const List<ClassSession> sampleSchedule = [
    // Monday
    ClassSession(
      id: 'm1',
      dayOfWeek: DateTime.monday,
      subject: 'Mobile App Development',
      code: 'CS-401',
      startTime: '09:00 AM',
      endTime: '10:30 AM',
      room: 'Room 304 (Lab A)',
      instructor: 'Dr. Sarah Jenkins',
      accentColor: Color(0xFF7567E8),
      icon: Icons.flutter_dash,
    ),
    ClassSession(
      id: 'm2',
      dayOfWeek: DateTime.monday,
      subject: 'Data Structures & Algorithms',
      code: 'CS-302',
      startTime: '11:00 AM',
      endTime: '12:30 PM',
      room: 'Auditorium 2',
      instructor: 'Prof. Alan Turing',
      accentColor: Color(0xFF4EBA87),
      icon: Icons.account_tree_outlined,
    ),
    ClassSession(
      id: 'm3',
      dayOfWeek: DateTime.monday,
      subject: 'Operating Systems',
      code: 'CS-305',
      startTime: '02:00 PM',
      endTime: '03:30 PM',
      room: 'Room 208',
      instructor: 'Dr. Linus Vance',
      accentColor: Color(0xFFFFB088),
      icon: Icons.memory_outlined,
    ),

    // Tuesday
    ClassSession(
      id: 't1',
      dayOfWeek: DateTime.tuesday,
      subject: 'Database Management Systems',
      code: 'CS-304',
      startTime: '09:30 AM',
      endTime: '11:00 AM',
      room: 'Room 105',
      instructor: 'Dr. Edgar Codd',
      accentColor: Color(0xFF64B5F6),
      icon: Icons.storage_outlined,
    ),
    ClassSession(
      id: 't2',
      dayOfWeek: DateTime.tuesday,
      subject: 'Computer Networks',
      code: 'CS-308',
      startTime: '11:30 AM',
      endTime: '01:00 PM',
      room: 'Room 402',
      instructor: 'Prof. Radia Perlman',
      accentColor: Color(0xFFBA68C8),
      icon: Icons.hub_outlined,
    ),
    ClassSession(
      id: 't3',
      dayOfWeek: DateTime.tuesday,
      subject: 'Software Engineering Workshop',
      code: 'CS-410',
      startTime: '02:30 PM',
      endTime: '04:30 PM',
      room: 'Innovation Hub 1',
      instructor: 'Prof. Martin Fowler',
      accentColor: Color(0xFF7567E8),
      icon: Icons.code_rounded,
    ),

    // Wednesday
    ClassSession(
      id: 'w1',
      dayOfWeek: DateTime.wednesday,
      subject: 'Mobile App Development',
      code: 'CS-401',
      startTime: '09:00 AM',
      endTime: '11:00 AM',
      room: 'Room 304 (Lab A)',
      instructor: 'Dr. Sarah Jenkins',
      accentColor: Color(0xFF7567E8),
      icon: Icons.flutter_dash,
    ),
    ClassSession(
      id: 'w2',
      dayOfWeek: DateTime.wednesday,
      subject: 'Web Technologies',
      code: 'CS-312',
      startTime: '11:30 AM',
      endTime: '01:00 PM',
      room: 'Room 201',
      instructor: 'Prof. Tim Lee',
      accentColor: Color(0xFFFFB088),
      icon: Icons.language_outlined,
    ),
    ClassSession(
      id: 'w3',
      dayOfWeek: DateTime.wednesday,
      subject: 'Discrete Mathematics',
      code: 'MA-205',
      startTime: '02:00 PM',
      endTime: '03:30 PM',
      room: 'Lecture Hall B',
      instructor: 'Dr. John Venn',
      accentColor: Color(0xFF4EBA87),
      icon: Icons.calculate_outlined,
    ),

    // Thursday
    ClassSession(
      id: 'th1',
      dayOfWeek: DateTime.thursday,
      subject: 'Data Structures Lab',
      code: 'CS-302L',
      startTime: '10:00 AM',
      endTime: '12:30 PM',
      room: 'Lab Center 3',
      instructor: 'Prof. Alan Turing',
      accentColor: Color(0xFF4EBA87),
      icon: Icons.terminal_outlined,
    ),
    ClassSession(
      id: 'th2',
      dayOfWeek: DateTime.thursday,
      subject: 'Computer Networks',
      code: 'CS-308',
      startTime: '01:30 PM',
      endTime: '03:00 PM',
      room: 'Room 402',
      instructor: 'Prof. Radia Perlman',
      accentColor: Color(0xFFBA68C8),
      icon: Icons.hub_outlined,
    ),

    // Friday
    ClassSession(
      id: 'f1',
      dayOfWeek: DateTime.friday,
      subject: 'Database Systems Lab',
      code: 'CS-304L',
      startTime: '09:00 AM',
      endTime: '11:00 AM',
      room: 'Database Lab B',
      instructor: 'Dr. Edgar Codd',
      accentColor: Color(0xFF64B5F6),
      icon: Icons.dns_outlined,
    ),
    ClassSession(
      id: 'f2',
      dayOfWeek: DateTime.friday,
      subject: 'Artificial Intelligence Intro',
      code: 'CS-420',
      startTime: '11:30 AM',
      endTime: '01:00 PM',
      room: 'Auditorium 1',
      instructor: 'Dr. Andrew Ng',
      accentColor: Color(0xFFFF8A65),
      icon: Icons.psychology_outlined,
    ),
    ClassSession(
      id: 'f3',
      dayOfWeek: DateTime.friday,
      subject: 'Campus Tech Club Seminar',
      code: 'SEM-10',
      startTime: '03:00 PM',
      endTime: '04:30 PM',
      room: 'Student Union Hall',
      instructor: 'Student Council',
      accentColor: Color(0xFF7567E8),
      icon: Icons.groups_outlined,
    ),

    // Saturday
    ClassSession(
      id: 's1',
      dayOfWeek: DateTime.saturday,
      subject: 'Open Source Flutter Project',
      code: 'CAP-490',
      startTime: '10:00 AM',
      endTime: '01:00 PM',
      room: 'Maker Studio 4',
      instructor: 'Self-Directed / Mentor Guided',
      accentColor: Color(0xFF7567E8),
      icon: Icons.auto_awesome_outlined,
    ),
  ];

  /// Get classes for a specific day of week
  static List<ClassSession> getClassesForDay(int dayOfWeek) {
    return sampleSchedule.where((s) => s.dayOfWeek == dayOfWeek).toList();
  }
}

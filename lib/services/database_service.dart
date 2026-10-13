import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/assignment.dart';

/// DatabaseService handles SQLite local persistence for Assignments.
/// Demonstrates:
/// - SQLite database initialization and versioning
/// - Table creation with standard schema
/// - One-time database seeding for first launch
/// - Asynchronous CRUD operations (Create, Read, Update, Delete)
/// - Separation of persistence logic from UI widgets
class DatabaseService {
  // Singleton pattern for centralized database access
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  static const String _tableName = 'assignments';

  /// Getter for the database instance with lazy initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize SQLite database file on device storage
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'campus_buddy.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create table schema and seed initial sample data on first launch
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        subject TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Seed realistic sample college assignments on first install
    await _seedInitialData(db);
  }

  /// Insert initial sample assignments for first-run demonstration
  Future<void> _seedInitialData(Database db) async {
    final now = DateTime.now();

    final sampleAssignments = [
      Assignment(
        title: 'Flutter UI Layout Prototype',
        subject: 'Mobile App Development',
        dueDate: now.add(const Duration(days: 1)),
        completed: false,
      ),
      Assignment(
        title: 'Binary Search Tree Balancing',
        subject: 'Data Structures & Algorithms',
        dueDate: now.add(const Duration(days: 3)),
        completed: false,
      ),
      Assignment(
        title: 'SQL Normalization Lab Report',
        subject: 'Database Systems',
        dueDate: now.subtract(const Duration(days: 1)), // Overdue demo
        completed: false,
      ),
      Assignment(
        title: 'TCP/IP Packet Sniffer Analysis',
        subject: 'Computer Networks',
        dueDate: now.add(const Duration(days: 5)),
        completed: true,
      ),
      Assignment(
        title: 'Process Scheduling Algorithms',
        subject: 'Operating Systems',
        dueDate: now.add(const Duration(days: 7)),
        completed: false,
      ),
    ];

    final batch = db.batch();
    for (final assignment in sampleAssignments) {
      batch.insert(_tableName, assignment.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Query all assignments ordered by completion status and due date
  Future<List<Assignment>> getAllAssignments() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        orderBy: 'completed ASC, dueDate ASC',
      );

      return maps.map((map) => Assignment.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching assignments: $e');
      return [];
    }
  }

  /// Insert a new assignment into the database
  Future<int> insertAssignment(Assignment assignment) async {
    try {
      final db = await database;
      return await db.insert(
        _tableName,
        assignment.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting assignment: $e');
      return -1;
    }
  }

  /// Update an existing assignment record
  Future<int> updateAssignment(Assignment assignment) async {
    if (assignment.id == null) return -1;
    try {
      final db = await database;
      return await db.update(
        _tableName,
        assignment.toMap(),
        where: 'id = ?',
        whereArgs: [assignment.id],
      );
    } catch (e) {
      print('Error updating assignment: $e');
      return -1;
    }
  }

  /// Toggle completion state for a given assignment ID
  Future<int> toggleAssignmentCompletion(int id, bool completed) async {
    try {
      final db = await database;
      return await db.update(
        _tableName,
        {'completed': completed ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error toggling assignment: $e');
      return -1;
    }
  }

  /// Delete an assignment from the database
  Future<int> deleteAssignment(int id) async {
    try {
      final db = await database;
      return await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Error deleting assignment: $e');
      return -1;
    }
  }

  /// Reset database back to sample data (useful for demonstration purposes)
  Future<void> resetToSampleData() async {
    try {
      final db = await database;
      await db.delete(_tableName);
      await _seedInitialData(db);
    } catch (e) {
      print('Error resetting database: $e');
    }
  }
}

import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../services/database_service.dart';
import '../widgets/app_bottom_navigation.dart';
import 'assignments_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'timetable_screen.dart';

/// MainNavigationShell provides the persistent bottom navigation shell.
/// Demonstrates:
/// - IndexedStack for preserving screen state across tab changes
/// - Centralized local SQLite state management using setState
/// - Coordinating child screens (Home, Tasks, Timetable, Profile)
/// - Seamless propagation of database mutations to dashboard metrics
class MainNavigationShell extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;

  const MainNavigationShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  final DatabaseService _dbService = DatabaseService();

  List<Assignment> _assignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  /// Fetch assignments from SQLite database and update state
  Future<void> _loadAssignments() async {
    final list = await _dbService.getAllAssignments();
    if (mounted) {
      setState(() {
        _assignments = list;
        _isLoading = false;
      });
    }
  }

  /// Toggle assignment completion status in SQLite and refresh UI
  Future<void> _handleToggleAssignment(Assignment assignment) async {
    if (assignment.id == null) return;
    final newStatus = !assignment.completed;
    await _dbService.toggleAssignmentCompletion(assignment.id!, newStatus);
    await _loadAssignments();
  }

  /// Add new assignment to SQLite and refresh UI
  Future<void> _handleAddAssignment(Assignment newAssignment) async {
    await _dbService.insertAssignment(newAssignment);
    await _loadAssignments();
  }

  /// Delete assignment from SQLite and refresh UI
  Future<void> _handleDeleteAssignment(int id) async {
    await _dbService.deleteAssignment(id);
    await _loadAssignments();
  }

  /// Reset database back to sample data
  Future<void> _handleResetDatabase() async {
    await _dbService.resetToSampleData();
    await _loadAssignments();
  }

  /// Select navigation tab
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // 0. Home Dashboard Screen
          HomeScreen(
            assignments: _assignments,
            onNavigateToTab: _onTabSelected,
            onToggleAssignment: _handleToggleAssignment,
          ),

          // 1. Assignments Screen
          AssignmentsScreen(
            assignments: _assignments,
            onRefreshData: _loadAssignments,
            onToggleAssignment: _handleToggleAssignment,
            onDeleteAssignment: _handleDeleteAssignment,
            onAddAssignment: _handleAddAssignment,
          ),

          // 2. Class Timetable Screen
          const TimetableScreen(),

          // 3. Profile & Settings Screen
          ProfileScreen(
            isDarkMode: widget.isDarkMode,
            onToggleTheme: widget.onToggleTheme,
            notificationsEnabled: widget.notificationsEnabled,
            onToggleNotifications: widget.onToggleNotifications,
            onResetDatabase: _handleResetDatabase,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

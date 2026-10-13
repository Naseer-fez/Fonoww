import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// ProfileScreen provides student credentials, preferences, and app info.
/// Demonstrates:
/// - Profile UI layout with custom badges and info cards
/// - Real-time Dark Mode switching persisted via shared_preferences
/// - Local settings toggle for notifications
/// - Database reset helper for demonstration purposes
/// - Material 3 ListTiles, Switches, and Dialogs
class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;
  final VoidCallback onResetDatabase;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onResetDatabase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              Text(
                'Student Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF22243A),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 20),

              // 1. Profile Hero Card (Avatar, Name, Program)
              _buildProfileCard(context, isDark),
              const SizedBox(height: 24),

              // 2. Academic Info Card
              _buildAcademicInfoCard(context, isDark),
              const SizedBox(height: 24),

              // 3. Settings & Preferences Section
              Text(
                'PREFERENCES & SETTINGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                ),
              ),
              const SizedBox(height: 10),
              _buildSettingsCard(context, isDark),
              const SizedBox(height: 24),

              // 4. About Campus Buddy & Reset
              Text(
                'APPLICATION INFO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
                ),
              ),
              const SizedBox(height: 10),
              _buildAboutCard(context, isDark),
              const SizedBox(height: 30),

              // Footer Version Text
              Center(
                child: Text(
                  'Campus Buddy • v1.0.0 (Build 1)\nBuilt with Flutter & Material 3',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF757A92) : const Color(0xFFA0A5BA),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Profile Hero Card
  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2).withOpacity(0.8),
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
      child: Row(
        children: [
          // Circular Avatar with "SN"
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7567E8), Color(0xFF988BF9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryAccent.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'SN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          // Student details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Naseer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF22243A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Computer Science Student',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.successMint.withOpacity(isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Active • Fall 2026',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successMint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Academic Information Section
  Widget _buildAcademicInfoCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2).withOpacity(0.8),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow('Student ID', 'CS-2024-089', Icons.badge_outlined, isDark),
          const Divider(height: 20),
          _buildInfoRow('Semester', '5th Semester (Junior)', Icons.layers_outlined, isDark),
          const Divider(height: 20),
          _buildInfoRow('Department', 'Computer Science & Eng.', Icons.business_outlined, isDark),
          const Divider(height: 20),
          _buildInfoRow('Cumulative GPA', '3.85 / 4.00', Icons.stars_rounded, isDark, valueColor: AppTheme.successMint),
          const Divider(height: 20),
          _buildInfoRow('Attendance', '92% (Regular)', Icons.fact_check_outlined, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? const Color(0xFF8B90A5) : const Color(0xFF85899B),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? (isDark ? Colors.white : const Color(0xFF22243A)),
          ),
        ),
      ],
    );
  }

  /// Settings Card (Dark Mode & Notifications switches)
  Widget _buildSettingsCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2).withOpacity(0.8),
        ),
      ),
      child: Column(
        children: [
          // Dark Mode Switch
          SwitchListTile(
            value: isDarkMode,
            onChanged: onToggleTheme,
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isDarkMode ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent)
                    .withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                size: 20,
                color: isDarkMode ? AppTheme.primaryDarkAccent : AppTheme.primaryAccent,
              ),
            ),
            title: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            subtitle: Text(
              'Smooth theme change across the entire app',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
              ),
            ),
          ),
          const Divider(height: 1),

          // Notifications Switch
          SwitchListTile(
            value: notificationsEnabled,
            onChanged: onToggleNotifications,
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.gentlePeach.withOpacity(isDark ? 0.25 : 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                size: 20,
                color: Color(0xFFE65100),
              ),
            ),
            title: Text(
              'Class & Due Reminders',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            subtitle: Text(
              'Local reminder preference for demo',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// About and Reset Data Card
  Widget _buildAboutCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2030) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF292C42) : const Color(0xFFE8EAF2).withOpacity(0.8),
        ),
      ),
      child: Column(
        children: [
          // About Dialog tile
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.softSkyBlue.withOpacity(isDark ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: AppTheme.softSkyBlue,
              ),
            ),
            title: Text(
              'About Campus Buddy',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            subtitle: Text(
              'Purpose, architecture, and syllabus coverage',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),

          // Reset Database tile (convenient for classroom live demos)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.softCoral.withOpacity(isDark ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.restore_page_outlined,
                size: 20,
                color: AppTheme.softCoral,
              ),
            ),
            title: Text(
              'Reset Sample Data',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF22243A),
              ),
            ),
            subtitle: Text(
              'Restore initial assignments for classroom demo',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF969AB0) : const Color(0xFF85899B),
              ),
            ),
            onTap: () => _confirmReset(context),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Campus Buddy — Student Companion'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A college student productivity app designed to demonstrate core Flutter syllabus concepts in a clean, modern UI:',
                style: TextStyle(fontSize: 13, height: 1.4),
              ),
              SizedBox(height: 10),
              Text(
                '• Material 3 Light & Dark themes\n'
                '• SQLite persistent CRUD storage\n'
                '• Real REST API quote integration\n'
                '• Clean bottom navigation and routes\n'
                '• Form validation & date picking\n'
                '• Tween & AnimatedContainer animations\n'
                '• Shared preferences for settings',
                style: TextStyle(fontSize: 12, height: 1.5, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Sample Data'),
        content: const Text(
          'This will reset your SQLite assignments database back to the original classroom demonstration sample records.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onResetDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Database reset to initial sample data!'),
                  backgroundColor: AppTheme.primaryAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Reset Now'),
          ),
        ],
      ),
    );
  }
}

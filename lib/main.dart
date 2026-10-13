import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_navigation_shell.dart';
import 'services/preferences_service.dart';
import 'theme/app_theme.dart';

/// Entry point of the Campus Buddy application.
/// Demonstrates:
/// - WidgetsFlutterBinding initialization for async startup
/// - Locking orientation to portrait using SystemChrome
/// - Loading initial preferences from SharedPreferences
/// - Dynamic ThemeMode switching (Light & Dark) across the entire app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Target Android phones in portrait orientation as required
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load persisted theme and notification preferences
  final prefsService = PreferencesService();
  final isDarkMode = await prefsService.isDarkMode();
  final notificationsEnabled = await prefsService.isNotificationsEnabled();

  runApp(CampusBuddyApp(
    initialDarkMode: isDarkMode,
    initialNotifications: notificationsEnabled,
  ));
}

/// Root widget of the application
class CampusBuddyApp extends StatefulWidget {
  final bool initialDarkMode;
  final bool initialNotifications;

  const CampusBuddyApp({
    super.key,
    required this.initialDarkMode,
    required this.initialNotifications,
  });

  @override
  State<CampusBuddyApp> createState() => _CampusBuddyAppState();
}

class _CampusBuddyAppState extends State<CampusBuddyApp> {
  late bool _isDarkMode;
  late bool _notificationsEnabled;
  final PreferencesService _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
    _notificationsEnabled = widget.initialNotifications;
  }

  /// Toggle dark mode and persist preference
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _prefsService.setDarkMode(value);
  }

  /// Toggle notifications and persist preference
  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    _prefsService.setNotificationsEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainNavigationShell(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
        notificationsEnabled: _notificationsEnabled,
        onToggleNotifications: _toggleNotifications,
      ),
    );
  }
}

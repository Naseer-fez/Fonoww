import 'package:shared_preferences/shared_preferences.dart';

/// PreferencesService manages persistent user preferences using shared_preferences.
/// Demonstrates:
/// - Key-value pair local storage in Flutter
/// - Asynchronous getter and setter methods
/// - Managing application settings (Dark Mode and Notifications)
class PreferencesService {
  static const String _keyDarkMode = 'is_dark_mode';
  static const String _keyNotifications = 'notifications_enabled';

  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  /// Retrieve the saved dark mode preference (defaults to false / light mode)
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  /// Persist the dark mode preference
  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  /// Retrieve the saved notifications toggle (defaults to true)
  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? true;
  }

  /// Persist the notifications toggle
  Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
  }
}

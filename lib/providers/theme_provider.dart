import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_pomodoro_app/themes/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeProvider({bool isDarkMode = false})
      : _isDarkMode = isDarkMode,
        _themeData = isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();

    // Save theme preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Load theme preference
  Future<void> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }
}

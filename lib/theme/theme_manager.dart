import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _KEY_IS_DARK = "is_dark";

  final SharedPreferences _prefs;

  ThemeManager(this._prefs);

  bool get isDarkThemeSelected => _prefs.getBool(_KEY_IS_DARK) ?? false;

  Future<bool> onNewThemeSelected(bool isDark) => _prefs.setBool(_KEY_IS_DARK, isDark);
}

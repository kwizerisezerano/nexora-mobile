import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_strings.dart';

/// Holds the active theme mode and locale, seeded from the system preferences
/// (device theme + device language) and overridable from the app bar — the same
/// behaviour as the website's colour-mode + language switchers. Theme and locale
/// choices are persisted so they survive relaunches.
class AppSettings extends ChangeNotifier {
  AppSettings({ThemeMode? themeMode, Locale? locale, SharedPreferences? prefs})
      : _themeMode = themeMode ?? ThemeMode.system,
        _locale = locale ?? AppStrings.detectDeviceLocale(),
        _prefs = prefs;

  static const _themeKey = 'settings.theme_mode';
  static const _localeKey = 'settings.locale';

  final SharedPreferences? _prefs;
  ThemeMode _themeMode;
  Locale _locale;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  /// Restores persisted preferences, falling back to the system defaults for
  /// any value that was never set.
  static Future<AppSettings> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLocale = prefs.getString(_localeKey);
    final locale = storedLocale != null &&
            AppStrings.supportedLocales
                .any((l) => l.languageCode == storedLocale)
        ? Locale(storedLocale)
        : AppStrings.detectDeviceLocale();
    return AppSettings(
      themeMode: _themeFromName(prefs.getString(_themeKey)),
      locale: locale,
      prefs: prefs,
    );
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    _prefs?.setString(_themeKey, mode.name);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
    _prefs?.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  /// Flips between light and dark, resolving `system` against the platform
  /// brightness so the toggled value matches what the user currently sees.
  void toggleTheme(Brightness platformBrightness) {
    final isDarkNow = _themeMode == ThemeMode.dark ||
        (_themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);
    setThemeMode(isDarkNow ? ThemeMode.light : ThemeMode.dark);
  }

  static ThemeMode _themeFromName(String? name) => switch (name) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
}

class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings super.notifier,
    required super.child,
  });

  static AppSettings of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in context');
    return scope!.notifier!;
  }
}

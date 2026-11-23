import 'package:flutter/material.dart';

import 'l10n/app_strings.dart';

/// Holds the active theme mode and locale, seeded from the system preferences
/// (device theme + device language) and overridable from the app bar — the same
/// behaviour as the website's colour-mode + language switchers.
class AppSettings extends ChangeNotifier {
  AppSettings({ThemeMode? themeMode, Locale? locale})
      : _themeMode = themeMode ?? ThemeMode.system,
        _locale = locale ?? AppStrings.detectDeviceLocale();

  ThemeMode _themeMode;
  Locale _locale;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
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

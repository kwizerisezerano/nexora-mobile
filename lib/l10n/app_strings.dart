import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Loads the website's i18n locale files (English, French, Swahili) from
/// assets and resolves dotted keys such as `hero.badge`.
class AppStrings {
  AppStrings._(this.locale, this._data);

  final Locale locale;
  final Map<String, dynamic> _data;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('sw'),
  ];

  /// Human-readable names shown in the language switcher.
  static const Map<String, String> localeNames = {
    'en': 'English',
    'fr': 'Français',
    'sw': 'Kiswahili',
  };

  /// Country codes used to fetch flags from flagcdn.com (matches the website).
  static const Map<String, String> localeFlags = {
    'en': 'us',
    'fr': 'fr',
    'sw': 'tz',
  };

  static final Map<String, AppStrings> _cache = {};

  /// Loads all supported locales once at app start.
  static Future<void> load() async {
    for (final locale in supportedLocales) {
      final code = locale.languageCode;
      final raw = await rootBundle.loadString('assets/i18n/$code.json');
      _cache[code] = AppStrings._(
        locale,
        json.decode(raw) as Map<String, dynamic>,
      );
    }
  }

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  static AppStrings forLocale(Locale locale) =>
      _cache[locale.languageCode] ?? _cache['en']!;

  /// Resolves a dotted key to a string.
  String t(String path) {
    final value = _resolve(path);
    return value is String ? _unescape(value) : path;
  }

  /// Resolves a dotted key to a list of strings (e.g. `services.capabilities`).
  List<String> tList(String path) {
    final value = _resolve(path);
    if (value is List) {
      return value.map((e) => _unescape(e.toString())).toList();
    }
    return const [];
  }

  /// Resolves a dotted key to a list of objects (e.g. `portfolio.projects`).
  List<Map<String, dynamic>> tObjects(String path) {
    final value = _resolve(path);
    if (value is List) {
      return value
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return const [];
  }

  dynamic _resolve(String path) {
    dynamic current = _data;
    for (final segment in path.split('.')) {
      if (current is Map && current.containsKey(segment)) {
        current = current[segment];
      } else {
        return null;
      }
    }
    return current;
  }

  /// `vue-i18n` escapes the `@` symbol in locale files; revert it.
  static String _unescape(String value) => value.replaceAll("{'@'}", '@');

  /// Picks a supported locale from the device languages, defaulting to English.
  static Locale detectDeviceLocale() {
    final deviceLocales = WidgetsBinding.instance.platformDispatcher.locales;
    for (final device in deviceLocales) {
      for (final supported in supportedLocales) {
        if (supported.languageCode == device.languageCode) return supported;
      }
    }
    return const Locale('en');
  }
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async =>
      AppStrings.forLocale(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppStrings> old) => false;
}

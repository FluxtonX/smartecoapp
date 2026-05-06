import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  static const String _localeKey = 'selected_locale';

  Locale? get locale => _locale;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('rw'),
    Locale('fr'),
  ];

  LocaleProvider() {
    _loadStoredLocale();
  }

  Future<void> _loadStoredLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_localeKey);

    if (languageCode != null) {
      _locale = Locale(languageCode);
    } else {
      // Default logic: if system language matches supported, use it. Otherwise English.
      final String systemLocale = Platform.localeName.split('_')[0];
      if (supportedLocales.any((l) => l.languageCode == systemLocale)) {
        _locale = Locale(systemLocale);
      } else {
        _locale = const Locale('en');
      }
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}

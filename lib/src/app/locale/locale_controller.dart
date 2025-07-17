import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('pt')) {
    _loadSavedLocale();
  }

  static const String _localeKey = 'selected_locale';
  final _prefs = SharedPreferences.getInstance();

  Future<void> _loadSavedLocale() async {
    final prefs = await _prefs;
    final savedLanguageCode = prefs.getString(_localeKey);
    if (savedLanguageCode != null) {
      state = Locale(savedLanguageCode);
    }
  }

  Future<void> changeLocale(Locale locale) async {
    if (state != locale) {
      state = locale;

      final prefs = await _prefs;
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }
}

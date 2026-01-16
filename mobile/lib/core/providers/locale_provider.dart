import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const supportedLocales = <Locale>[
  Locale('en'),
  Locale('fr'),
  Locale('es'),
  Locale('de'),
  Locale('it'),
  Locale('pl'),
  Locale('hu'),
  Locale('ro'),
];

final appLocaleProvider =
    StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
  return AppLocaleNotifier();
});

class AppLocaleNotifier extends StateNotifier<Locale> {
  AppLocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  static const _storageKey = 'ui_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    if (code == null || code.isEmpty) {
      state = const Locale('en');
      return;
    }
    state = _localeFromCode(code);
  }

  Future<void> setLocaleCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null || code.isEmpty) {
      await prefs.remove(_storageKey);
      state = const Locale('en');
      return;
    }
    await prefs.setString(_storageKey, code);
    state = _localeFromCode(code);
  }

  Future<void> setLocaleFromUserIfUnset(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_storageKey);
    if (existing != null && existing.isNotEmpty) {
      return;
    }
    await setLocaleCode(code?.toLowerCase());
  }

  Locale? _localeFromCode(String code) {
    final normalized = code.toLowerCase();
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == normalized,
      orElse: () => const Locale('en'),
    );
  }
}

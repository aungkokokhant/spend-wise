import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import 'shared_preferences_provider.dart';

class AppSettingsService {
  AppSettingsService(this._preferences);

  final SharedPreferences _preferences;

  ThemeMode getThemeMode() {
    final value = _preferences.getString(StorageKeys.themeMode);
    return switch (value) {
      'dark' => ThemeMode.dark,
      _ => ThemeMode.light,
    };
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    return _preferences
        .setString(
          StorageKeys.themeMode,
          themeMode == ThemeMode.dark ? 'dark' : 'light',
        )
        .then((_) {});
  }

  Locale getLocale() {
    final localeCode = _preferences.getString(StorageKeys.localeCode) ?? 'en';
    return Locale(localeCode);
  }

  Future<void> setLocale(Locale locale) {
    return _preferences
        .setString(StorageKeys.localeCode, locale.languageCode)
        .then((_) {});
  }
}

final appSettingsServiceProvider = Provider<AppSettingsService>(
  (ref) => AppSettingsService(ref.watch(sharedPreferencesProvider)),
);

class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.watch(appSettingsServiceProvider).getThemeMode();

  Future<void> updateTheme(bool useDarkMode) async {
    final nextTheme = useDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = nextTheme;
    await ref.watch(appSettingsServiceProvider).setThemeMode(nextTheme);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => ref.watch(appSettingsServiceProvider).getLocale();

  Future<void> updateLocale(Locale locale) async {
    state = locale;
    await ref.watch(appSettingsServiceProvider).setLocale(locale);
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);

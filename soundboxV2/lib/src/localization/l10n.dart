import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sound_box/src/localization/gen/app_localizations.dart';

abstract class L10n {
  factory L10n.of(BuildContext context) {
    return _L10n(app: AppLocalizations.of(context));
  }

  AppLocalizations get app;

  /// A list of localizations delegates.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  /// A list of supported locales.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('kn')
  ];

  static List<AppLanguage> supportedLanguages = [
    AppLanguage(name: 'English', locale: supportedLocales[0]),
    AppLanguage(name: 'Hindi - हिन्दी', locale: supportedLocales[1]),
    AppLanguage(name: 'Kannada - ಕನ್ನಡ', locale: supportedLocales[2]),
  ];
}

class AppLanguage {
  AppLanguage({
    required this.name,
    required this.locale,
    this.isAvailable,
  });

  final String name;
  final Locale locale;
  bool? isAvailable;

  set available(bool value) {
    isAvailable = value;
  }
}

class _L10n implements L10n {
  _L10n({required this.app});

  @override
  final AppLocalizations app;
}

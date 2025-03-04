import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/notification_service/message_announcement.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/data/data.dart';
import 'preference_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The PreferenceController
/// uses the PreferenceService to store and retrieve user settings.
@lazySingleton
class PreferenceController with ChangeNotifier {
  PreferenceController(this._preferenceService);

  // Make PreferenceService a private variable so it is not used directly.
  final PreferenceService _preferenceService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the PreferenceService.
  late ThemeAppearanceType _themeMode;
  late Locale _locale;
  late bool _mute;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeAppearanceType get themeMode => _themeMode;

  Locale get locale => _locale;

  bool get mute => _mute;

  /// Load the user's settings from the PreferenceService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = _preferenceService.themeMode();
    _locale = _preferenceService.locale();
    _mute = _preferenceService.mute();

    ThemeManager.setupTypography(_preferenceService.dip());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  Future<String?> setupSettingWithServerData({
    ThemeAppearanceType? newThemeMode,
    required String localeString,
    required bool mute,
  }) async {
    _themeMode = newThemeMode ?? _preferenceService.themeMode();


    await MessageAnnouncement().setMute(mute);
    final voiceLocale = await MessageAnnouncement().setLocale(localeString);

    _locale = Locale(voiceLocale);

    _mute = mute;

    notifyListeners();

    return voiceLocale;
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeAppearanceType? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // PreferenceService.
    await _preferenceService.updateThemeMode(newThemeMode);
  }

  Future<Preferences?> changeAppLocale(Locale locale) async {
   try {
     // Do not perform any work if new and old Locale are identical
     if (locale == _locale) return null;

     // Otherwise, store the new Locale in memory

     Preferences? preferences =
     await _preferenceService.changeLocaleAndMute(locale, _mute);

     if (preferences != null) {
       _locale = locale;

       String voiceLocale = await MessageAnnouncement().setLocale(_locale.toString());

       preferences = preferences.copyWith(voiceLocale: voiceLocale);

       // Inform listeners a change has occurred.
       notifyListeners();
     }

     return preferences;
     // Persist the changes to a local database or the internet using the
     // PreferenceService.
   } catch (e) {

   }
  }

  Future<Preferences?> changeMuteAnnouncement(bool mute) async {
    try {
      // Do not perform any work if new and old Locale are identical
      if (mute == _mute) return null;

      // Otherwise, store the new Locale in memory

      Preferences? preferences =
      await _preferenceService.changeLocaleAndMute(_locale, mute);

      if (preferences != null) {
        _mute = mute;

        await MessageAnnouncement().setMute(_mute);
        // Inform listeners a change has occurred.
        notifyListeners();
      }

      return preferences;
      // Persist the changes to a local database or the internet using the
      // PreferenceService.
    } catch (e) {
    }
  }
}

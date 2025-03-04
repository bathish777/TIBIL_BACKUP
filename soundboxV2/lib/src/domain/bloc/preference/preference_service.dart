import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/config/config.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/theme/theme.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
@lazySingleton
class PreferenceService {
  PreferenceService({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  ThemeAppearanceType themeMode() => Config.defaultTheme;

  Locale locale() => Config.defaultLocale;

  Dip dip() => Config.defaultDip;

  bool mute() => Config.defaultAnnouncementMuteState;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeAppearanceType theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  Future<Preferences?> changeLocaleAndMute(Locale locale, bool mute) async {
    return await _userRepository.updatePreferences(locale.languageCode, mute);
  }
}

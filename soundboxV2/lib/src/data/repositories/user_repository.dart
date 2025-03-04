import 'dart:async';

import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/preferences/preferences_remote_source.dart';
import 'package:sound_box/src/data/data_sources/upi/upi_local_source.dart';
import 'package:sound_box/src/data/data_sources/user/user_sources.dart';

class UserRepository {
  UserRepository(this._localSource, this._preferencesRemoteSource, this._localUpiSource);

  final UserLocalSource _localSource;
  final PreferencesRemoteSource _preferencesRemoteSource;
  final UpiLocalSource _localUpiSource;

  static void register() {
    getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(
        getIt<UserLocalSource>(),
        getIt<PreferencesRemoteSource>(),
        getIt<UpiLocalSource>()
      ),
    );
  }

  saveUserSecrets(UserSecrets userSecrets) async {
    await _localSource.save(userSecrets);
  }

  Future<UserSecrets?> getUserSecrets() async {
    UserSecrets? userSecrets = await _localSource.get();
    return userSecrets;
  }

  Future<void> clearUserSecrets() async {
    await _localSource.clear();
  }

  saveUpi(Upi upi) async {
    await _localUpiSource.save(upi);
  }

  Future<Upi?> getUpi() async {
    Upi? upi = await _localUpiSource.get();
    return upi;
  }

  Future<void> clearUpi() async {
    await _localUpiSource.clear();
  }

  Future<Preferences?> updatePreferences(String? language, bool? mute) async {
    final UserSecrets? userSecrets = await _localSource.get();
    final Preferences? oldPreference = userSecrets?.defaultPreferences;

    language = language != null && oldPreference?.language != language
        ? language
        : oldPreference?.language;

    mute = mute ?? oldPreference?.mute;

    final Preferences? preferences =
        await _preferencesRemoteSource.update(language!, mute!);

    UserSecrets? updateUser = userSecrets?.copyWith(defaultPreferences: preferences);

    await _localSource.save(updateUser!);

    return preferences;
  }


  Future<Preferences?> getPreference()  async {
    final UserSecrets? userSecrets = await _localSource.get();
    return userSecrets?.defaultPreferences;
  }
}

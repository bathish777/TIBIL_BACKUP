import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/models/models.dart';
import 'package:sound_box/src/data/models/user_secrets.dart';

import '../../../hive_type_ids.dart';
import '../user_local_source.dart';

@LazySingleton(as: UserLocalSource)
class UserHiveSource implements UserLocalSource {
  UserHiveSource() : _boxName = 'users';

  final String _boxName;

  Box<UserSecrets>? _box;

  @override
  String get boxName => _boxName;

  /// Ensures this is initialized.
  Future<void> _ensureInitialized() async {
    if (_box == null || _box!.isOpen) {
      if (!Hive.isAdapterRegistered(HiveTypeIds.userSecrets)) {
        Hive.registerAdapter<UserSecrets>(UserSecretsAdapter());
      }

      if (!Hive.isAdapterRegistered(HiveTypeIds.preferences)) {
        Hive.registerAdapter<Preferences>(PreferencesAdapter());
      }

      _box = await Hive.openBox<UserSecrets>(boxName);
    }
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    await _box!.clear();
  }

  @override
  Future<void> delete(UserSecrets user) async {
    await _ensureInitialized();
    return _box!.delete(user.uuid);
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _box?.close();
  }

  @override
  Future<UserSecrets?> get() async {
    await _ensureInitialized();

  _box!.values.isNotEmpty;

    return _box!.values.first;


  }

  @override
  Future<void> save(UserSecrets user) async {
    await _ensureInitialized();

    if(_box!.isNotEmpty) {
      await _box!.clear();
    }

    return _box!.put(user.uuid, user);
  }
}

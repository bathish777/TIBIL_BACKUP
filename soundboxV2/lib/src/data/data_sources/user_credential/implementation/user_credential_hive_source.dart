import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data_sources/user_credential/user_credential_local_source.dart';
import 'package:sound_box/src/data/models/user_credential.dart';

import '../../../hive_type_ids.dart';

@LazySingleton(as: UserCredentialLocalSource)
class UserCredentialHiveSource extends UserCredentialLocalSource {

  UserCredentialHiveSource() : _boxName = 'userCredentials';

  final String _key = 'userCredential-1';

  final String _boxName;

  Box<UserCredential>? _box;

  String get boxName => _boxName;

  /// Ensures this is initialized.
  Future<void> _ensureInitialized() async {
    if (_box == null || _box!.isOpen) {
      if (!Hive.isAdapterRegistered(HiveTypeIds.userCredential)) {
        Hive.registerAdapter<UserCredential>(UserCredentialAdapter());
      }

      _box = await Hive.openBox<UserCredential>(boxName);
    }
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    await _box!.clear();
  }

  @override
  Future<void> delete() async {
    await _ensureInitialized();
    return _box!.delete(_key);
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _box?.close();
  }

  @override
  Future<UserCredential?> get() async {
    await _ensureInitialized();

    return _box!.get(_key);
  }

  @override
  Future<void> save(UserCredential userCredential) async  {
    await _ensureInitialized();

    if(_box!.isNotEmpty) {
      await _box!.clear();
    }

    return _box!.put(_key, userCredential);
  }
}
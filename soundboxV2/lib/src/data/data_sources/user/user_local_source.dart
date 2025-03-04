import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/local_source.dart';

abstract class UserLocalSource extends LocalSource {
  Future<void> save(UserSecrets userSecrets);
  Future<UserSecrets?> get();
  Future<void> delete(UserSecrets userSecrets);
  Future<void> clear();
  Future<void> dispose();
}
import 'package:sound_box/src/data/data.dart';

abstract class UserCredentialLocalSource {
  Future<void> save(UserCredential userCredential);
  Future<UserCredential?> get();
  Future<void> delete();
  Future<void> clear();
  Future<void> dispose();
}
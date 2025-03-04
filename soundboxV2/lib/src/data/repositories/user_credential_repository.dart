import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/user_credential/user_credential_sources.dart';

class UserCredentialRepository {
  UserCredentialRepository(this._localSource);

  final UserCredentialLocalSource _localSource;

  static void register() {
    getIt.registerLazySingleton<UserCredentialRepository>(
      () => UserCredentialRepository(getIt<UserCredentialLocalSource>()),
    );
  }

  Future<UserCredential?> save(String deviceId, String mobileNumber, String mpin) async {
   await _localSource.save(
      UserCredential(
        deviceId: deviceId,
        mobileNumber: mobileNumber,
        mpin: mpin
      ),
    );

   return await get();
  }

  Future<void> clear() async {
    await _localSource.clear();
  }

  Future<UserCredential?> get() async {
    UserCredential? userCredential = await _localSource.get();
    return userCredential;
  }
}

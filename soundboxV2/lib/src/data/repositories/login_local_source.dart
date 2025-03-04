import 'package:hive/hive.dart';

class LoginLocalSource {
  static LoginLocalSource? _instance;

  LoginLocalSource._();

  String localeBox = 'loginAttemptBox';
  String endTime = 'endTime';
  String attemptCount = 'attemptCount';

  factory LoginLocalSource() {
    _instance ??= LoginLocalSource._();
    return _instance!;
  }

  saveLastEndTime(int value) async {
    await storeIntoHive(endTime, value);
  }

  saveLastAttemptCount(int value) async {
    await storeIntoHive(attemptCount, value);
  }

  getLastEndTime() async {
    return await getFromHive(endTime);
  }

  getLastAttemptCount() async {
    return await getFromHive(attemptCount);
  }

  storeIntoHive(String key, dynamic value) async {
    var box = await Hive.openBox(localeBox);
    await box.delete(key);
    await box.put(key, value);
    await box.close();
  }

  clearBox() async {
    var box = await Hive.openBox(localeBox);
    box.clear();
  }

  dynamic getFromHive(String key) async {
    var box = await Hive.openBox(localeBox);
    dynamic value = await box.get(key);
    await box.close();
    return value;
  }
}

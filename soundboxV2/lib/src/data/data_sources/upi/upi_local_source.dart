import 'package:sound_box/src/data/data.dart';

abstract class UpiLocalSource {
  Future<void> save(Upi upi);
  Future<Upi?> get();
  Future<void> delete();
  Future<void> clear();
  Future<void> dispose();
}
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../data.dart';
import '../../../hive_type_ids.dart';
import '../upi_local_source.dart';

@LazySingleton(as: UpiLocalSource)
class UpiHiveSource extends UpiLocalSource {

  UpiHiveSource() : _boxName = 'upi';

  final String _key = 'upi-1';

  final String _boxName;

  Box<Upi>? _box;

  String get boxName => _boxName;

  /// Ensures this is initialized.
  Future<void> _ensureInitialized() async {
    if (_box == null || _box!.isOpen) {
      if (!Hive.isAdapterRegistered(HiveTypeIds.upi)) {
        Hive.registerAdapter<Upi>(UpiAdapter());
      }

      _box = await Hive.openBox<Upi>(boxName);
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
  Future<Upi?> get() async {
    await _ensureInitialized();

    return _box!.get(_key);
  }

  @override
  Future<void> save(Upi upi) async  {
    await _ensureInitialized();

    if(_box!.isNotEmpty) {
      await _box!.clear();
    }

    return _box!.put(_key, upi);
  }
}
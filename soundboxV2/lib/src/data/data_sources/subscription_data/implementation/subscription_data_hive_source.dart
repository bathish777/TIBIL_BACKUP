import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data_sources/subscription_data/subscription_data_local_source.dart';
import 'package:sound_box/src/data/models/subscription_data.dart';

import '../../../hive_type_ids.dart';

@LazySingleton(as: SubscriptionDataLocalSource)
class SubscriptionDataHiveSource extends SubscriptionDataLocalSource {
  SubscriptionDataHiveSource() : _boxName = 'subscriptionData';

  final String _boxName;

  Box<SubscriptionData>? _box;

  String get boxName => _boxName;

  /// Ensures this is initialized.
  Future<void> _ensureInitialized() async {
    if (_box == null || _box!.isOpen) {
      if (!Hive.isAdapterRegistered(HiveTypeIds.subscriptionData)) {
        Hive.registerAdapter<SubscriptionData>(SubscriptionDataAdapter());
      }

      _box = await Hive.openBox<SubscriptionData>(boxName);
    }
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    await _box!.clear();
  }

  @override
  Future<void> delete(SubscriptionData subscriptionData) async {
    await _ensureInitialized();
    return _box!.delete(subscriptionData.simSlot);
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _box?.close();
  }

  @override
  Future<SubscriptionData?> get() async {
    await _ensureInitialized();

    if (_box!.values.isNotEmpty) {
      return _box!.values.first;
    }
    return null;
  }

  @override
  Future<void> save(SubscriptionData subscriptionData) async {
    await _ensureInitialized();

    if (_box!.isNotEmpty) {
      await _box!.clear();
    }

    return _box!.put(subscriptionData.simSlot, subscriptionData);
  }
}

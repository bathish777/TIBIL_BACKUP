import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_local_source.dart';
import 'package:sound_box/src/data/models/payment_summary.dart';

import '../../../hive_type_ids.dart';

@LazySingleton(as: PaymentSummaryLocalSource)
class PaymentSummaryHiveSource extends PaymentSummaryLocalSource {
  PaymentSummaryHiveSource() : _boxName = 'paymentSummaries';

  final String _key = 'payment-summary-1';
  final String _notificationSummaryKey = 'notification-summary-1';

  final String _boxName;

  Box<PaymentSummary>? _box;

  @override
  String get boxName => _boxName;

  /// Ensures this is initialized.
  Future<void> _ensureInitialized() async {
    if (_box == null || _box!.isOpen) {
      if (!Hive.isAdapterRegistered(HiveTypeIds.paymentSummary)) {
        Hive.registerAdapter<PaymentSummary>(PaymentSummaryAdapter());
      }

      _box = await Hive.openBox<PaymentSummary>(boxName);
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

  @override
  Future<void> deleteNotificationSummary() async {
    await _ensureInitialized();
    return _box!.delete(_notificationSummaryKey);
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _box?.close();
  }

  @override
  Future<PaymentSummary?> get() async {
    await _ensureInitialized();

    return _box!.get(_key);
  }

  @override
  Future<PaymentSummary?> getNotificationSummary() async {
    await _ensureInitialized();

    return _box!.get(_notificationSummaryKey);
  }

  @override
  Future<void> save(PaymentSummary paymentSummary) async {
    await _ensureInitialized();
    await delete();
    return _box!.put(_key, paymentSummary);
  }

  @override
  Future<void> saveNotificationSummary(PaymentSummary paymentSummary) async {
    await _ensureInitialized();
    await deleteNotificationSummary();
    return _box!.put(_notificationSummaryKey, paymentSummary);
  }
}

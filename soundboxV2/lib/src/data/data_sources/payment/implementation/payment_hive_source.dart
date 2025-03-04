import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/payment/payment_local_source.dart';
import 'package:sound_box/src/data/data_sources/payment/payment_sources.dart';

import 'package:sound_box/src/data/hive_type_ids.dart';

@LazySingleton(as: PaymentLocalSource)
class PaymentHiveSource extends PaymentLocalSource {
  PaymentHiveSource() : _boxName = 'payments';

  final String _boxName;

  Box<Payment>? _box;

  @override
  String get boxName => _boxName;

  /// Ensures this is initialized.
  Future<void> _ensureInitialized() async {
    if (_box == null || _box!.isOpen) {
      if (!Hive.isAdapterRegistered(HiveTypeIds.payment)) {
        Hive.registerAdapter<Payment>(PaymentAdapter());
      }

      if (!Hive.isAdapterRegistered(HiveTypeIds.paymentDetails)) {
        Hive.registerAdapter<Details>(DetailsAdapter());
      }

      _box = await Hive.openBox<Payment>(boxName);
    }
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    await _box!.clear();
  }

  @override
  Future<void> delete(Payment payment) async {
    await _ensureInitialized();
    return _box!.delete(payment.pid);
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    await _box?.close();
  }

  @override
  Future<List<Payment>> getAll() async {
    await _ensureInitialized();

    return _box!.values.toList();
  }

  @override
  Future<Payment?> getById(String id) async {
    await _ensureInitialized();

    return _box!.get(id);
  }

  @override
  Future<void> save(Payment payment) async {
    await _ensureInitialized();

    return _box!.put(payment.pid, payment);
  }

  @override
  Future<void> saveAll(List<Payment> payments) async {
    await _ensureInitialized();

    return _box!.putAll({for (final payment in payments) payment.pid: payment});
  }
}

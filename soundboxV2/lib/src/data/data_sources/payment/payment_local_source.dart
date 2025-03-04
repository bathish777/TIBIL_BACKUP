import 'package:sound_box/src/data/data_sources/local_source.dart';
import 'package:sound_box/src/data/data.dart';

abstract class PaymentLocalSource extends LocalSource {
  /// Gets all [Payment]s.
  Future<List<Payment>> getAll();

  /// Gets a single [Payment] by its [Payment.id].
  Future<Payment?> getById(String id);

  /// Saves a [Payment].
  Future<void> save(Payment payment);

  /// Saves multiple [Payment]s.
  Future<void> saveAll(List<Payment> payments);

  /// Deletes a [Payment].
  Future<void> delete(Payment payment);

  /// Deletes all [Payment]s.
  Future<void> clear();

  /// Will dispose stuff kept in memory, e.g. streams, handles.
  Future<void> dispose();
}
import 'package:sound_box/src/data/data_sources/local_source.dart';

import 'package:sound_box/src/data/data.dart';

abstract class PaymentSummaryLocalSource extends LocalSource {
  Future<void> save(PaymentSummary paymentSummary);
  Future<void> saveNotificationSummary(PaymentSummary paymentSummary);

  Future<PaymentSummary?> get();
  Future<PaymentSummary?> getNotificationSummary();


  /// Deletes a [PaymentSummary].
  Future<void> delete();
  Future<void> deleteNotificationSummary();

  /// Deletes all [PaymentSummary]s.
  Future<void> clear();

  /// Will dispose stuff kept in memory, e.g. streams, handles.
  Future<void> dispose();
}
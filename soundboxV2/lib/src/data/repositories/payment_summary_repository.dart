import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_sources.dart';

import '../data.dart';

@lazySingleton
class PaymentSummaryRepository {
  const PaymentSummaryRepository({
    required PaymentSummaryRemoteSource remoteSource,
    required PaymentSummaryLocalSource localSource,
  })  : _remoteSource = remoteSource,
        _localSource = localSource;

  final PaymentSummaryRemoteSource _remoteSource;
  final PaymentSummaryLocalSource _localSource;


  Future<PaymentSummary?> fetch() async {
    PaymentSummary? paymentSummary = await _remoteSource.get();
    return paymentSummary;
  }

  Future<void> saveLocal(PaymentSummary paymentSummary) async {
   await _localSource.save(paymentSummary);
  }

  Future<PaymentSummary?> getLocal() async {
    return await _localSource.get();
  }

  Future<PaymentSummary?> getNotificationSummary() async {
    return await _localSource.getNotificationSummary();
  }

  Future<void> saveNotificationSummary(PaymentSummary paymentSummary) async {
    await _localSource.saveNotificationSummary(paymentSummary);
  }

  Future<PaymentSummary?> fetchAndSaveLocal({bool refresh=false}) async {
    PaymentSummary? paymentSummary = refresh ? null : await _localSource.get();

    if (paymentSummary == null) {
      paymentSummary = await _remoteSource.get();

      if (paymentSummary != null) {
        await _localSource.save(paymentSummary);

        // [TODO] Need to verify the first notification announcement.
        // if(await _localSource.getNotificationSummary() == null) {
        //   await _localSource.saveNotificationSummary(paymentSummary);
        // }

      }
    }

    return paymentSummary;
  }

  Future<void>  clear() async {
    await _localSource.clear();
  }
}

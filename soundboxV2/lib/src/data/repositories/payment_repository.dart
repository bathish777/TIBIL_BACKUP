import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/payment/payment_sources.dart';

@lazySingleton
class PaymentRepository {
  PaymentRepository({
    required PaymentLocalSource localSource,
    required PaymentRemoteSource remoteSource,
  })  : _localSource = localSource,
        _remoteSource = remoteSource {
    _messagingSource = MessagingSource();
    _messageSubscription = _messagingSource.messages.listen(_messageHandler);
  }

  final PaymentRemoteSource _remoteSource;
  final PaymentLocalSource _localSource;
  late MessagingSource _messagingSource;
  late final StreamSubscription<Message> _messageSubscription;

  final StreamController<dynamic> _controller =
  StreamController.broadcast();

  @override
  Stream<dynamic> get events => _controller.stream;

  void _messageHandler(Message remoteMessage) async {
    _controller.add(remoteMessage);
  }

  Future<List<Payment>> getAll({bool refresh = false, int? offset, int? limit}) async {
    List<Payment> transactions = refresh ? [] : await _localSource.getAll();

    if (transactions.isEmpty) {
      transactions = await _remoteSource.getAll(offset: offset, limit: limit);

      if (transactions.isNotEmpty) {
        //  await clear();
        //  await _localSource.saveAll(transactions);
      }
    }

    return transactions;
  }

  Future<List<Payment>?> getAllLocal() async {
    return await _localSource.getAll();
  }

  Future<Payment?> getById(String id) async {
    Payment? trans = await _localSource.getById(id);
    return trans;
  }

  Future<List<Payment>?> getNotificationPayments({String? fromDateTime, String? toDateTime, int? lastPid}) async {
    List<Payment>? payments = await _remoteSource.getAll(fromDateTime: fromDateTime, toDateTime: toDateTime);
    return payments;
  }

  Future<void>  clear() async {
    await _localSource.clear();
  }

  /// Used to dispose of this.
  @disposeMethod
  void dispose() {
    _messageSubscription.cancel();
    _controller.close();
  }
}

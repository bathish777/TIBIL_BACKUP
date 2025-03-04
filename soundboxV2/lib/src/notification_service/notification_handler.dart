import 'dart:async';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:sound_box/src/config/message_announce_config.dart';
import 'dart:collection';
import 'package:sound_box/src/data/api_mixin.dart';
import 'package:sound_box/src/data/repositories/payment_repository.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../config/config.dart';
import '../data/data.dart';
import '../data/repositories/payment_summary_repository.dart';
import 'message_announcement.dart';
import 'app_notification.dart';

@lazySingleton
class NotificationHandler with ApiMixin {
  NotificationHandler(this._paymentRepository, this._paymentSummaryRepository) {
    _messageSource = MessagingSource();
    MessageAnnouncement().onComplete = _onComplete;
    _initHiveBox();
  }

  _storeIntoHive(dynamic value) async {
    var box = await Hive.openBox(_localBox);
    await box.delete(_pidKey);
    await box.put(_pidKey, value);
    await box.close();
  }

  _initHiveBox() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  dynamic _getFromHive() async {
    var box = await Hive.openBox(_localBox);
    dynamic value = await box.get(_pidKey);
    await box.close();
    return value;
  }

  final String _localBox = 'lastPidBox';
  final String _pidKey = 'pidKey';

  final PaymentRepository _paymentRepository;
  final PaymentSummaryRepository _paymentSummaryRepository;
  late final MessagingSource _messageSource;

  final Queue<String> _messageQueue = Queue();

  bool _isInProgress = false;

  Timer? _timer;

  startNotificationHandler() {
    if (_timer != null) return;

    try {
      _timer = Timer.periodic(
          Duration(seconds: MessageAnnounceConfig.pollIntervalDurationSecs),
          (timer) async {
        final List<Payment>? payments = await _checkLastUpdatePaymentSummary();

        if (payments != null && payments.isNotEmpty) {
          payments.forEach((element) async {
            final amount = element.details.amount;
            addMessage(amount.toString());
          });
        }
      });
    } catch (e) {}
  }

  void _onComplete() {
    _isInProgress = false;
    _announceNextMessage();
  }

  _announceNextMessage() async {
    if (_isInProgress || _messageQueue.isEmpty) return;

    final amount = _messageQueue.removeFirst();

    _isInProgress = true;
    if (!getIt<PreferenceController>().mute) {
      MessageAnnouncement().announceMessage(amount);
    } else {
      // Call On complete for announce-notify the next message.
      Future.delayed(const Duration(seconds: 1), () {
        _onComplete();
      });
    }

    await getIt<AppNotification>().showNotification(double.parse(amount));
  }

  addMessage(String amount) {
    _messageQueue.add(amount);
    _announceNextMessage();
  }

  void stopNotificationHandler() {
    _timer?.cancel();
    _timer = null;
  }

  Future<List<Payment>?> _checkLastUpdatePaymentSummary() async {
    List<Payment>? latestPayments = [];

    // Fetch old and new payment summaries
    PaymentSummary? oldPaymentSummary =
        await _paymentSummaryRepository.getNotificationSummary();
    PaymentSummary? newPaymentSummary = await _paymentSummaryRepository.fetch();

    if (newPaymentSummary == null) return latestPayments;

    // Parse the updated time of new payment summary
    DateTime? paymentSummaryDateTime = newPaymentSummary.updatedAt != null
        ? DateFormat('dd-MM-yyyy HH:mm')
            .parseUtc(newPaymentSummary.updatedAt!) // Ensure it's parsed as UTC
        : null;

    // Create a DateTime object for 3 minutes ago in UTC
    DateTime pastFewMinuteDateTime = DateTime.now().toUtc().subtract(
          Duration(minutes: MessageAnnounceConfig.bgNotifyTimeLimit),
        ); // Make sure to get UTC

    if (paymentSummaryDateTime == null ||
        paymentSummaryDateTime.isBefore(pastFewMinuteDateTime)) {
      return latestPayments; // Return early if it's not updated in the last 3 minutes
    }

    // Determine old date and count
    DateTime? fromDateTime = oldPaymentSummary?.updatedAt != null
        ? DateFormat('dd-MM-yyyy HH:mm').parseUtc(oldPaymentSummary!.updatedAt!)
        : paymentSummaryDateTime;

    double oldCount = oldPaymentSummary?.count ?? 0;

    // Check if there's an actual change in payment summary data
    if (fromDateTime == newPaymentSummary.updatedAt &&
        oldCount >= newPaymentSummary.count) {
      return latestPayments;
    }

    // Set the date range for fetching new payments
    DateTime? toDateTime = paymentSummaryDateTime;
    if (fromDateTime.isAtSameMomentAs(toDateTime)) {
      DateTime dateTime = toDateTime;
      toDateTime = dateTime.add(const Duration(minutes: 1));
    }

    if (fromDateTime.isBefore(pastFewMinuteDateTime)) {
      fromDateTime = pastFewMinuteDateTime;
    }

    // Get the last processed payment PID from Hive
    final int? lastPaymentPid = await _getFromHive();

    print('from and to : ${fromDateTime} : ${toDateTime} : $lastPaymentPid');

    // Fetch the new payments within the given date range
    List<Payment>? paymentsForAnnouncement =
        await _paymentRepository.getNotificationPayments(
      fromDateTime: DateFormat('dd-MM-yyyy HH:mm').format(fromDateTime),
      toDateTime: DateFormat('dd-MM-yyyy HH:mm').format(toDateTime),
      lastPid: lastPaymentPid,
    );

    print('Payments : $paymentsForAnnouncement');
    print('lpi $lastPaymentPid');

    // Update payment summary in the repository
    await _paymentSummaryRepository.saveNotificationSummary(newPaymentSummary);

    // Filter payments based on the last payment PID
    if (lastPaymentPid != null) {
      latestPayments = paymentsForAnnouncement
          ?.where((element) => element.pid! > lastPaymentPid)
          .toList();
    } else {
      latestPayments = paymentsForAnnouncement;
    }

    // Store the first payment PID for future checks
    if (latestPayments?.isNotEmpty ?? false) {
      await _storeIntoHive(latestPayments!.first.pid);
    }

    // Emit an event to update the payment summary and list view
    _messageSource.addMessage(Message(newPaymentSummary));

    return latestPayments?.reversed.toList();
  }
}

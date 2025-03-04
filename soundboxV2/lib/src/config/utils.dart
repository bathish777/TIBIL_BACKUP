import 'dart:convert';

import 'package:intl/intl.dart';

import 'config.dart';
import 'device_config.dart';

class Utils {
  static String getFormattedAmount({
    required double amount,
    showCurrencySymbol = true,
  }) {
    return NumberFormat.currency(
      name: '',
      // By Default the formatted amount will be with Currency name - 'INR124.40'.
      // We don't use in Currency name
      locale: Config.currencyLocale,
      decimalDigits: Config.numberOfDecimalPoints,
      symbol: showCurrencySymbol ? Config.currencySymbol : null,
    ).format(amount);
  }

  static String encodedMessage(String? message) {
  final String encMessage = base64.encode(
    utf8.encode('${DeviceConfig.id},${DateTime.now().millisecondsSinceEpoch}'),
  );

  if (message != null && message.isNotEmpty) {
    return message.replaceAll('<message>', ' $encMessage');
  } else {
    return encMessage;
  }
}
}

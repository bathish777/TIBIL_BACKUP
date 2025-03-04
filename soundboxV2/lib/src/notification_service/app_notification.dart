import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/config/config.dart';

import '../config/utils.dart';

@lazySingleton
class AppNotification {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  final Random rondom = Random.secure();

  initialize() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'launcher_icon'); // Ensure this matches the icon name in res/mipmap
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin?.initialize(initializationSettings);
  }

  Future<void> showNotification(double amount) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Channel-id1',
      'Channel-1',
      channelDescription: 'For Testing Channel',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'launcher_icon'
    ); // Ensure this matches the icon in res/mipmap
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final randomId = rondom.nextInt(Config.transactionNotificationRandomIdIntRange);
    
    await flutterLocalNotificationsPlugin?.show(
      randomId,
      'Amount Received', // [TODO] : Need to update the original message announcement text.
      'The received amount is ${Utils.getFormattedAmount(amount: amount.toDouble())}',
      platformChannelSpecifics,
      payload: 'Hello',
    );
  }
}

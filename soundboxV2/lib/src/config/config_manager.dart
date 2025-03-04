import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'server_config.dart';

class ConfigManager {
  static ConfigManager? _instance;

  ConfigManager._();

  factory ConfigManager() {
    _instance ??= ConfigManager._();
    return _instance!;
  }

  static String get envFileName => '.env';

  Future<void> init() async {
    if (dotenv.env['PROTOCOL']!.isNotEmpty) {
      ServerConfig.protocol = dotenv.env['PROTOCOL']!;
    }

    if (dotenv.env['SERVER_ADDRESS'] != null && dotenv.env['SERVER_ADDRESS']!.isNotEmpty) {
      ServerConfig.serverAddress = dotenv.env['SERVER_ADDRESS'] ?? '';
    }

    if (dotenv.env['TOKEN'] != null && dotenv.env['TOKEN']!.isNotEmpty) {
      ServerConfig.token = dotenv.env['TOKEN'] ?? '';
    }

    if (dotenv.env['RM_SMS_VMN'] != null && dotenv.env['RM_SMS_VMN']!.isNotEmpty) {
      ServerConfig.vmn = dotenv.env['RM_SMS_VMN'] ?? '';
    }

    //ServerConfig.serverAddress = const String.fromEnvironment('SERVER_ADDRESS');

   /* if (dotenv.env['API_ROUTE']!.isNotEmpty) {
      ServerConfig.apiRoute = dotenv.env['API_ROUTE']!;
    }

    if (dotenv.env['USER_PORT']!.isNotEmpty) {
      ServerConfig.userPort = dotenv.env['USER_PORT']!;
    }

    if (dotenv.env['PAYMENT_PORT']!.isNotEmpty) {
      ServerConfig.paymentPort = dotenv.env['PAYMENT_PORT']!;
    }
    */
  }
}

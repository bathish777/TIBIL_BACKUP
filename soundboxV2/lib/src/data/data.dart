import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

export 'data_sources/authorization/authorization_memory_source.dart';
export 'data_sources/messaging/messaging_source.dart';
export 'models/models.dart';
export 'app_dependency_injection.dart';
export 'repositories/repositories.dart';

abstract class Data {
  Data._();

  /// Hive Initialization
  static Future<void> initHive() async {
    if (!kIsWeb) {
      // Skip the set file path in Web mode.
      final Directory directory =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(directory.path);
    }
  }
}

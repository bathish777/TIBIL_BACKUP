import 'package:flutter/cupertino.dart';

import '../../widgets/dialog_box.dart';

class AppDialogService {
  static AppDialogService? _instance;

  AppDialogService._();

  factory AppDialogService() {
    _instance ??= AppDialogService._();
    return _instance!;
  }

}
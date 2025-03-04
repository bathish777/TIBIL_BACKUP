import 'package:flutter/material.dart';

import '../../widgets/dialog_box.dart';
import 'app_dialog_service.dart';

class AppDialogNavigatorObserver extends NavigatorObserver {
  static AppDialogNavigatorObserver? _instance;

  AppDialogNavigatorObserver._();

  factory AppDialogNavigatorObserver() {
    _instance ??= AppDialogNavigatorObserver._();
    return _instance!;
  }

  VoidCallback? _callback;

  void registerCallbackForOnDismiss(VoidCallback callback) {
    _callback = callback;
  }

  final List<GlobalKey<AppDialogBoxState>> _appDialogBoxKeys = [];

  void registerDialog(GlobalKey<AppDialogBoxState> key) {
    _appDialogBoxKeys.add(key);
  }

  void removeDialog() {
    if(_appDialogBoxKeys.isNotEmpty) {
      _appDialogBoxKeys.removeLast();
    }
  }

  popUpDialogBox() {
      _appDialogBoxKeys.last.currentState?.closeDialog();
  }

  popUpAllDialogBox() {
    if(_appDialogBoxKeys.isNotEmpty) {
      for(int i = 0; i < _appDialogBoxKeys.length; i++) {
        popUpDialogBox();
      }
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if(route.settings.name == 'app_dialog') {
      removeDialog();
    }

    if (route.settings.name == 'app_dialog' && _callback != null) {
      _callback!();
      _callback = null;
    }
  }
}

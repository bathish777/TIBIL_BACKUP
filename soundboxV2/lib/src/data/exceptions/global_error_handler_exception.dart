import 'package:flutter/material.dart';

class GlobalErrorHandlerException {
  const GlobalErrorHandlerException();

  /// Handles a flutter error.
  static void onFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);

    // [TODO] : Need to implement Error handler
    //print(details);
  }

  /// Handles a general error.
  static Future<void> onError(
    Object error,
    StackTrace? stack, {
    String? report,
    bool fatal = false,
  }) async {
    // [TODO] : Need to implement Error handler
    //print(error);
  }
}

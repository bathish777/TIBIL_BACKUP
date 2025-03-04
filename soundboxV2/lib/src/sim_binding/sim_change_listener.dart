import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimChangeListener with ChangeNotifier {
  static const MethodChannel _channel =
      MethodChannel('com.janabank.soundbox/sim_change');
  final StreamController<bool> _controller = StreamController.broadcast();
  Stream<bool> get simEvents => _controller.stream;

  void init() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'simStateChange') {
        // Handle the SIM change event here

        // Call the sim Change Event
        _controller.add(true);
      }
    });
  }

  void dispose() {
    _controller.close();
  }
}

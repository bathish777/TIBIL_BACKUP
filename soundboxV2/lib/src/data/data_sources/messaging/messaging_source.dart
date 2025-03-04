import 'dart:async';
import 'package:sound_box/src/data/data.dart';

class MessagingSource {
  static final MessagingSource _instance = MessagingSource._internal();

  factory MessagingSource() {
    return _instance;
  }

  MessagingSource._internal();

  final StreamController<Message> _controller = StreamController.broadcast();

  Stream<Message> get messages => _controller.stream;

  void addMessage(Message message) {
    _controller.add(message);
  }

  void dispose() {
    _controller.close();
  }
}

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:sound_box/src/data/data.dart';

class Message extends Model {
  const Message(this.paymentSummary);

  final PaymentSummary paymentSummary;

  @override
  List<Object?> get props => [paymentSummary];
}

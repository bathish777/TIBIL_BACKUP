import 'package:flutter/services.dart';
import 'package:sound_box/src/config/utils.dart';
import 'package:sound_box/src/data/data.dart';

import '../config/device_config.dart';

class SmsHandler {
  static const platform = MethodChannel('sb.sms.sim/smschannel');

  // static Future<MessageResult?> sendMessage(
  //   int? simSlot,
  //   List<VmnData?>? vmnNumbers,
  // ) async {
  //   if (vmnNumbers != null && vmnNumbers.isNotEmpty) {
  //     String? encodedMsg = Utils.encodedMessage('');
  //     String? subscriptionId = null;
  //     final List<MessageStatus> msgStatus = [];
  //     for (int i = 0; i < vmnNumbers.length; i++) {
  //       final number = vmnNumbers[i];

  //       final result = await sendMsgToVmn(
  //         number!,
  //         simSlot!,
  //         encodedMsg,
  //       );

  //       msgStatus.add(
  //         MessageStatus(number, result['send_status'], result['error']),
  //       );

  //       subscriptionId = result['subscription_id'].toString();
  //     }
  //     return MessageResult(encodedMsg, msgStatus, subscriptionId);
  //   }
  //   return null;
  // }

  static Future<MessageResult?> sendMessage(
    int? simSlot,
    List<VmnData?>? vmnNumbers,
  ) async {
    if (vmnNumbers != null && vmnNumbers.isNotEmpty) {
      final List<MessageStatus> msgStatus = [];
      String? subscriptionId = null;

      // Encode message once before the loop if there's a valid message//
      String? encodedMsg = vmnNumbers.first?.message != null
          ? Utils.encodedMessage(vmnNumbers.first!.message)
          : null;
      // String? encodedMsg = 'ivaniiuat\nU1AxQS4yMTA4MTIuMDE2LDE3MzcwODg4MTQ1ODU=';

      for (int i = 0; i < vmnNumbers.length; i++) {
        final vmnData = vmnNumbers[i];
        if (vmnData == null) continue;

        final result = await sendMsgToVmn(vmnData.vmnNumber, simSlot!,
            encodedMsg! // Use the same encoded message for all iterations
            );

        msgStatus.add(
          MessageStatus(
              vmnData.vmnNumber, result['send_status'], result['error']),
        );

        subscriptionId = result['subscription_id'].toString();
      }

      return MessageResult(encodedMsg, msgStatus, subscriptionId);
    }
    return null;
  }

  static sendMsgToVmn(
    String vmnNumber,
    int simSlot,
    String encodedMsg,
  ) async {
    try {
      final result = await platform.invokeMethod<dynamic>('sendSMS', {
        'device_id': DeviceConfig.id,
        'rm_vmn': vmnNumber,
        'simSlot': simSlot,
        'msg': encodedMsg
      });

      return result;
    } on PlatformException catch (e) {
      return {
        "send_status": false,
        "subscription_id": null,
        "error": e,
        "encoded_msg": null
      };
    }
  }
}

class MessageResult {
  String? encodedMsg;
  List<MessageStatus>? msgStatus;
  String? subscriptionId;

  MessageResult(this.encodedMsg, this.msgStatus, this.subscriptionId);

  get isSmsSendSuccess => msgStatus?.fold(
      false, (bool pre, e) => (pre | (e.isSuccess != null && e.isSuccess!)));
}

class MessageStatus {
  String? number;
  bool? isSuccess;
  dynamic error;

  MessageStatus(this.number, this.isSuccess, this.error);
}

import 'package:flutter/services.dart';

class SimInfoHandler {
  static const platform = MethodChannel('sb.sms.sim/smschannel');

  static Future<SimInfoResult?> getSimDetails(
    int? simSlot,
  ) async {
    String? subscriptionId;
    final result = await getSimSubscriptionInfo(
      simSlot!,
    );

    subscriptionId = result['subscription_id']?.toString();
    SimInfoResult simInfoData = SimInfoResult(
        simSlot.toString(), subscriptionId, result['status'], result['error']);

    return simInfoData;
  }

  static getSimSubscriptionInfo(
    int simSlot,
  ) async {
    try {
      final result = await platform
          .invokeMethod<dynamic>('getSimInfo', {'simSlot': simSlot});

      return result;
    } on PlatformException catch (e) {
      return {"status": false, "error": e, "subscription_id": null};
    }
  }
}

class SimInfoResult {
  String? simSlot;
  String? subscriptionId;
  bool? isSuccess;
  dynamic error;

  SimInfoResult(this.simSlot, this.subscriptionId, this.isSuccess, this.error);
}

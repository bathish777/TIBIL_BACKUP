import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class SimBinding {
  final MethodChannel _channel = const MethodChannel('sim_card_info');

  List<SimCard>? _simCards;

  Future<void> initialize() async {
    if (await Permission.phone.request().isGranted &&
        await _channel.invokeMethod('requestPermission')) {
      final dynamic result = await _channel.invokeMethod('getSimCardInfo');

      if (result is List) {
        _simCards = result.map((e) {
          if (e is Map) {
            return SimCard.fromJson(Map<String, dynamic>.from(e));
          }
          return SimCard();
        }).toList();
      }
    }
  }

  List<SimCard>? get simCards => _simCards;
}

class SimCard {
  SimCard({
    this.subscriptionId,
    this.slotIndex,
    this.carrierName,
    this.displayName,
    this.countryIso,
    this.iccId,
    this.deviceVersion,
    this.mobileNumber,
    this.error,
  });

  final String? subscriptionId;
  final String? slotIndex;
  final String? carrierName;
  final String? displayName;
  final String? countryIso;
  final String? iccId;
  final String? deviceVersion;
  final String? mobileNumber;
  final String? error;

  factory SimCard.fromJson(Map<String, dynamic> data) {
    return SimCard(
      subscriptionId: data["subscriptionId"] as String?,
      slotIndex: data['slotIndex'] as String?,
      carrierName: data['carrierName'] as String?,
      displayName: data['displayName'] as String?,
      countryIso: data['countryIso'] as String?,
      iccId: data['iccId'] as String?,
      deviceVersion: data['version'] as String?,
      mobileNumber: data['number'] as String?,
      error: data['error'] as String?,
    );
  }
}
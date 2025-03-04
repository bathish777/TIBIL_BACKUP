import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/subscription_data/subscription_data_sources.dart';

@lazySingleton
class SubscriptionDataRepository {
  SubscriptionDataRepository(this._localSource);

  final SubscriptionDataLocalSource _localSource;

  Future<SubscriptionData?> save(String? slotId, String? subscriptionId) async {
    await _localSource.save(
      SubscriptionData(simSlot: slotId, subscriptionId: subscriptionId),
    );

    return await get();
  }

  Future<void> clear() async {
    await _localSource.clear();
  }

  Future<SubscriptionData?> get() async {
    SubscriptionData? subscriptionData = await _localSource.get();
    return subscriptionData;
  }
}

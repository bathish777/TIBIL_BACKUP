import 'package:hive/hive.dart';
import 'package:sound_box/src/data/hive_type_ids.dart';

import '../data.dart';

part 'subscription_data.g.dart';

@HiveType(typeId: HiveTypeIds.subscriptionData)
class SubscriptionData extends Model {
  const SubscriptionData({
    this.simSlot,
    this.subscriptionId,
  });

  @HiveField(0)
  final String? simSlot;

  @HiveField(1)
  final String? subscriptionId;

  @override
  List<Object?> get props => [simSlot, subscriptionId];
}

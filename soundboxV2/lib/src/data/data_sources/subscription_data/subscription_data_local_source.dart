import 'package:sound_box/src/data/data.dart';

abstract class SubscriptionDataLocalSource {
  Future<void> save(SubscriptionData subscriptionData);
  Future<SubscriptionData?> get();
  Future<void> delete(SubscriptionData subscriptionData);
  Future<void> clear();
  Future<void> dispose();
}

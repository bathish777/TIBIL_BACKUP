import 'package:hive/hive.dart';

import '../data.dart';
import '../hive_type_ids.dart';

part 'user_credential.g.dart';

@HiveType(typeId: HiveTypeIds.userCredential)
class UserCredential extends Model {
  const UserCredential({
    required this.deviceId,
    required this.mobileNumber,
    required this.mpin
  });

  @HiveField(0)
  final String deviceId;
  
  @HiveField(1)
  final String mobileNumber;

  @HiveField(2)
  final String mpin;

  @override
  List<Object?> get props => [deviceId, mobileNumber, mpin];
}

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/hive_type_ids.dart';

part 'user_secrets.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: HiveTypeIds.userSecrets)
class UserSecrets extends Model {
  const UserSecrets({
    required this.uuid,
    required this.accessToken,
    required this.refreshToken,
    required this.defaultPreferences,
  });

  @HiveField(0)
  final String uuid;

  @HiveField(1)
  final String accessToken;

  @HiveField(2)
  final String refreshToken;

  @HiveField(3)
  final Preferences defaultPreferences;

  @override
  List<Object?> get props => [
        uuid,
        accessToken,
        refreshToken,
        defaultPreferences,
      ];

  /// Creates this from a JSON [Map].
  factory UserSecrets.fromJson(Map<String, dynamic> json) => _$UserSecretsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSecretsToJson(this);

  UserSecrets copyWith({
    String? uuid,
    String? base64qrcode,
    String? customerName,
    String? customerVpa,
    String? mobileNumber,
    String? accessToken,
    String? refreshToken,
    Preferences? defaultPreferences,
  }) =>
      UserSecrets(
        uuid: uuid ?? this.uuid,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        defaultPreferences: defaultPreferences ?? this.defaultPreferences,
      );
}

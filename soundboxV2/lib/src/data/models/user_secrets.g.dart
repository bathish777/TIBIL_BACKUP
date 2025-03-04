// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_secrets.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSecretsAdapter extends TypeAdapter<UserSecrets> {
  @override
  final int typeId = 1;

  @override
  UserSecrets read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSecrets(
      uuid: fields[0] as String,
      accessToken: fields[1] as String,
      refreshToken: fields[2] as String,
      defaultPreferences: fields[3] as Preferences,
    );
  }

  @override
  void write(BinaryWriter writer, UserSecrets obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.accessToken)
      ..writeByte(2)
      ..write(obj.refreshToken)
      ..writeByte(3)
      ..write(obj.defaultPreferences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSecretsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSecrets _$UserSecretsFromJson(Map<String, dynamic> json) => UserSecrets(
      uuid: json['uuid'] as String,
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      defaultPreferences: Preferences.fromJson(
          json['default_preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserSecretsToJson(UserSecrets instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'default_preferences': instance.defaultPreferences,
    };

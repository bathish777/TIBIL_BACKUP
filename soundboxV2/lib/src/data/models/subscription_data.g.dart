// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionDataAdapter extends TypeAdapter<SubscriptionData> {
  @override
  final int typeId = 9;

  @override
  SubscriptionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionData(
      simSlot: fields[0] as String?,
      subscriptionId: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.simSlot)
      ..writeByte(1)
      ..write(obj.subscriptionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

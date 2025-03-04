// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UpiAdapter extends TypeAdapter<Upi> {
  @override
  final int typeId = 8;

  @override
  Upi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Upi(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Upi obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.base64qrcode)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.customerVpa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Upi _$UpiFromJson(Map<String, dynamic> json) => Upi(
      json['base64qrcode'] as String?,
      json['customername'] as String?,
      json['customervpa'] as String?,
    );

Map<String, dynamic> _$UpiToJson(Upi instance) => <String, dynamic>{
      'base64qrcode': instance.base64qrcode,
      'customername': instance.customerName,
      'customervpa': instance.customerVpa,
    };

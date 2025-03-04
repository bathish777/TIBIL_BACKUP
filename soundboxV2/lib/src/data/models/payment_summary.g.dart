// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentSummaryAdapter extends TypeAdapter<PaymentSummary> {
  @override
  final int typeId = 5;

  @override
  PaymentSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentSummary(
      amount: fields[0] as double,
      count: fields[1] as double,
      currentDate: fields[2] as String?,
      updatedAt: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentSummary obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.currentDate)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummary _$PaymentSummaryFromJson(Map<String, dynamic> json) =>
    PaymentSummary(
      amount: (json['amount'] as num).toDouble(),
      count: (json['count'] as num).toDouble(),
      currentDate: json['current_date'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$PaymentSummaryToJson(PaymentSummary instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'count': instance.count,
      'current_date': instance.currentDate,
      'updated_at': instance.updatedAt,
    };

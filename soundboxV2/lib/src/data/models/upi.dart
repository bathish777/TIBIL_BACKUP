import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data.dart';
import '../hive_type_ids.dart';

part 'upi.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeIds.upi)
class Upi extends Model {
  const Upi(this.base64qrcode, this.customerName, this.customerVpa);

  @JsonKey(name: 'base64qrcode')
  @HiveField(0)
  final String? base64qrcode;

  @JsonKey(name: 'customername')
  @HiveField(1)
  final String? customerName;

  @JsonKey(name: 'customervpa')
  @HiveField(2)
  final String? customerVpa;

  factory Upi.fromJson(Map<String, dynamic> json) =>
      _$UpiFromJson(json);

  Map<String, dynamic> toJson() => _$UpiToJson(this);

  @override
  List<Object?> get props => [base64qrcode, customerName, customerVpa];
}

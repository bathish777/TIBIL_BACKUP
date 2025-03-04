import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data.dart';
import '../hive_type_ids.dart';

part 'payment_summary.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: HiveTypeIds.paymentSummary)
class PaymentSummary extends Model {
  const PaymentSummary({
    required this.amount,
    required this.count,
    required this.currentDate,
    required this.updatedAt,
  });

  @HiveField(0)
  final double amount;

  @HiveField(1)
  final double count;

  @HiveField(2)
  final String? currentDate;

  @HiveField(3)
  final String? updatedAt;

  factory PaymentSummary.fromJson(Map<String, dynamic> json) =>
      _$PaymentSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSummaryToJson(this);

  @override
  List<Object?> get props => [
        amount,
        count,
        currentDate,
        updatedAt,
      ];
}

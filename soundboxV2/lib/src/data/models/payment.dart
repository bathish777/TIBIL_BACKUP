import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sound_box/src/data/hive_type_ids.dart';

import '../data.dart';

part 'payment.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: HiveTypeIds.payment)
class Payment extends Model {
  const Payment(this.pid, this.details);

  @HiveField(0)
  final int? pid;

  @HiveField(1)
  final Details details;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  @override
  List<Object?> get props => [pid, details];
}

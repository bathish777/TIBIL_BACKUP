import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data.dart';
import '../hive_type_ids.dart';

part 'details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: HiveTypeIds.paymentDetails)
class Details extends Model {
  const Details(
    this.payerName,
    this.datetime,
    this.amount,
    this.payerVpa,
    this.payeeVpa,
  );

  @HiveField(0)
  final String? payerName;

  @HiveField(1)
  final String? datetime;

  @HiveField(2)
  @JsonKey(fromJson: _formattedDataType)
  final String? amount;

  @HiveField(3)
  final String? payerVpa;

  @HiveField(4)
  final String? payeeVpa;

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);

  static _formattedDataType(dynamic value) {
    return value.toString();
  }

  @override
  List<Object?> get props => [
        payerName,
        datetime,
        payerVpa,
        payeeVpa,
        amount,
      ];
}

import 'package:json_annotation/json_annotation.dart';

import '../data.dart';

part 'account.g.dart';

@JsonSerializable()
class Account extends Model {
  const Account({
    this.customerId,
    this.customerReferenceNumber,
    this.customerFullName,
    this.mobileNumber,
    this.accountId,
    this.accountType,
    this.accountStatus,
    this.IFSCCode,
    this.aeba,
  });

  @JsonKey(name: 'customerId')
  final String? customerId;

  @JsonKey(name: 'customerReferenceNumber')
  final String? customerReferenceNumber;

  @JsonKey(name: 'customerFullName')
  final String? customerFullName;

  @JsonKey(name: 'mobileNumber')
  final String? mobileNumber;

  @JsonKey(name: 'accountId')
  final String? accountId;

  @JsonKey(name: 'accountType')
  final String? accountType;

  @JsonKey(name: 'accountStatus')
  final String? accountStatus;

  @JsonKey(name: 'IFSCCode')
  final String? IFSCCode;

  @JsonKey(name: 'aeba')
  final String? aeba;

   factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  List<Object?> get props => [
        customerId,
        customerReferenceNumber,
        customerFullName,
        mobileNumber,
        accountId,
        accountType,
        accountStatus,
        IFSCCode,
        aeba,
      ];
}

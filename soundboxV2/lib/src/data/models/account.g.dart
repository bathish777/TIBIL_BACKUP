// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      customerId: json['customerId'] as String?,
      customerReferenceNumber: json['customerReferenceNumber'] as String?,
      customerFullName: json['customerFullName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      accountId: json['accountId'] as String?,
      accountType: json['accountType'] as String?,
      accountStatus: json['accountStatus'] as String?,
      IFSCCode: json['IFSCCode'] as String?,
      aeba: json['aeba'] as String?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'customerId': instance.customerId,
      'customerReferenceNumber': instance.customerReferenceNumber,
      'customerFullName': instance.customerFullName,
      'mobileNumber': instance.mobileNumber,
      'accountId': instance.accountId,
      'accountType': instance.accountType,
      'accountStatus': instance.accountStatus,
      'IFSCCode': instance.IFSCCode,
      'aeba': instance.aeba,
    };

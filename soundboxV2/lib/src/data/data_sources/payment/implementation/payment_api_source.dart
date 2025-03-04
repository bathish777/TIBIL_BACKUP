import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:sound_box/src/config/config.dart';

import 'package:sound_box/src/data/api_mixin.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';
import '../../../exceptions/error_codes.dart';
import '../payment_remote_source.dart';

@LazySingleton(as: PaymentRemoteSource)
class PaymentApiSource with ApiMixin implements PaymentRemoteSource {
  PaymentApiSource(this._auth);

  final AuthorizationMemorySource _auth;

  @override
  String get routeName => '$paymentRouteName/get';

  @override
  Future<List<Payment>> getAll({
    String? fromDateTime,
    String? toDateTime,
    int? offset,
    int? limit,
    int? lastPid,
  }) async {
    String paymentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final String bearerToken = await _auth.bearerToken;

    // Debug: Print the tokens and API call details
    print('Bearer Token: $bearerToken');
    print('Registered User UUID: ${_auth.registeredUserUUID}');
    print('Registered User VPA: ${_auth.registeredUserUpi?.customerVpa ?? ''}');
    print('Payment Date: $paymentDate');
    print('API Endpoint: ${createPaymentUri(routeName)}');
    print('Request Body: ${jsonEncode({
      'date': paymentDate,
      'uuid': _auth.registeredUserUUID,
      'vpa': _auth.registeredUserUpi?.customerVpa ?? '',
      if (fromDateTime != null) 'from': fromDateTime,
      if (toDateTime != null) 'to': toDateTime,
      if (offset != null) 'offset': offset,
      'limit': limit ?? Config.transactionLimitation,
      if (lastPid != null) 'payment_pid': lastPid,
    })}');

    final Response response = await post(
      createPaymentUri(routeName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: bearerToken,
      },
      body: jsonEncode(<String, dynamic>{
        'date': paymentDate,
        'uuid': _auth.registeredUserUUID,
        'vpa': _auth.registeredUserUpi?.customerVpa ?? '',
        if (fromDateTime != null) 'from': fromDateTime,
        if (toDateTime != null) 'to': toDateTime,
        if (offset != null) 'offset': offset,
        'limit': limit ?? Config.transactionLimitation,
        if (lastPid != null) 'payment_pid': lastPid,
      }),
    );

    // Debug: Print response details
    print('Response Status Code: ${response.statusCode}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      print('Response Code: $code');

      if (code == 2000) {
        final data = responseJson['data'];
        final list = data['payments'];
        print('Payments Data: $list');

        List<Payment> payments =
            list.map<Payment>((json) => Payment.fromJson(json)).toList();
        return payments;
      } else if (code == 1000) {
        final message = (responseJson['message'] as String).toLowerCase();
        print('Response Message: $message');

        if (message == 'no records') {
          return [];
        } else {
          throw const UnexpectedServerResponseException(
            statusCode: ErrorCodes.unableToFetchPayments,
          );
        }
      }

      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    throw UnexpectedServerResponseException(
      statusCode: response.statusCode,
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:sound_box/src/data/api_mixin.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_remote_source.dart';
import 'package:sound_box/src/data/data_sources/payment_summary/payment_summary_sources.dart';
import 'package:sound_box/src/data/exceptions/error_codes.dart';

import '../../../exceptions/unexpected_server_response_exception.dart';

@LazySingleton(as: PaymentSummaryRemoteSource)
class PaymentSummaryApiSource
    with ApiMixin
    implements PaymentSummaryRemoteSource {
  PaymentSummaryApiSource(this._auth);

  final AuthorizationMemorySource _auth;

  @override
  String get routeName => '$paymentRouteName/summary/get';

  @override
  Future<PaymentSummary?> get() async {

    String paymentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final Response response = await post(
      createPaymentUri(routeName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: await _auth.bearerToken
      },
      body: jsonEncode(<String, dynamic>{
        'date': paymentDate,
        'uuid': _auth.registeredUserUUID,
        'vpa': _auth.registeredUserUpi?.customerVpa ?? '',
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        PaymentSummary paymentSummary =
            PaymentSummary.fromJson(responseJson['data']);
        return paymentSummary;
      } else if (code == 1000) {
        if ((responseJson['message'] as String).toLowerCase() ==
            'no record found') {
          return null;
        } else {
          throw const UnexpectedServerResponseException(
            statusCode: ErrorCodes.unableToFetchPaymentSummary,
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

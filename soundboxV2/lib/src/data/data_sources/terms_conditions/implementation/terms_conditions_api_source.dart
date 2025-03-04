import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';

import 'package:sound_box/src/data/api_mixin.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';

import '../../../data.dart';
import '../../../exceptions/error_codes.dart';
import '../terms_conditions_remote_source.dart';

@LazySingleton(as: TermsConditionsRemoteSource)
class TermsConditionsApiSource
    with ApiMixin
    implements TermsConditionsRemoteSource {
  TermsConditionsApiSource(this._auth);

  final AuthorizationMemorySource _auth;

  @override
  String get routeName => '$userRouteName/tnc/get';

  @override
  Future<String?> get() async {

    final Response response = await post(
      createUri(routeName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: await _auth.guestToken ?? ''
      },
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['code'] == 2000) {

          return responseData['message'] as String?;

        } else if(responseData['code'] == 1000) {
          throw const UnexpectedServerResponseException(statusCode: ErrorCodes.unableToFetchTC);
        }
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.invalidResponseError,
        );
    }

    throw UnexpectedServerResponseException(statusCode: response.statusCode);
  }
}

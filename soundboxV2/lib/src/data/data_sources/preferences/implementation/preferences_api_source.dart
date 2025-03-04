import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/preferences/preferences_remote_source.dart';

import 'package:sound_box/src/data/api_mixin.dart';
import 'package:sound_box/src/data/exceptions/error_codes.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';

@LazySingleton(as: PreferencesRemoteSource)
class PreferencesApiSource with ApiMixin implements PreferencesRemoteSource {
  PreferencesApiSource(this._auth);

  final AuthorizationMemorySource _auth;

  @override
  String get routeName => '$userRouteName/preferences';

  @override
  Future<Preferences?> update(String language, bool mute) async {

    print(_auth.registeredUserUUID);

    final Response response = await put(
      createUri(routeName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: await _auth.bearerToken
      },
      body: jsonEncode(<String, dynamic>{
        'uuid': _auth.registeredUserUUID,
        'preferences': {
          'language': language,
          'mute': mute ? '1' : '0',
        }
      }),
    );

    print('Preference:');
    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final code = json['code'];
      if (code == 2000) {
        return Preferences(language: language, mute: mute);
      } else if (code == 1000) {
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.unableToUpdatePreference,
        );
      }
      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }
    throw UnexpectedServerResponseException(statusCode: response.statusCode);
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_box/src/config/device_config.dart';
import 'package:sound_box/src/data/data_sources/authentication/authentication_remote_source.dart';
import 'package:sound_box/src/data/data_sources/authentication/authentication_source.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';

import 'package:sound_box/src/data/api_mixin.dart';
import 'package:sound_box/src/data/server_responses/mobile_number_response.dart';
import 'package:sound_box/src/data/server_responses/sign_in_server_response.dart';
import 'package:sound_box/src/data/server_responses/request_otp_server_response.dart';
import 'package:sound_box/src/data/server_responses/verify_otp_server_response.dart';

import '../../../data.dart';
import '../../../exceptions/error_codes.dart';

class AuthenticationApiSource
    with ApiMixin
    implements AuthenticationRemoteSource {
  AuthenticationApiSource(this._auth);

  final AuthorizationMemorySource _auth;

  @override
  String get routeName => userRouteName;

  String get otpRouteName => '$routeName/otp';

  String get userSecretsRouteName => '$routeName/secrets';

  String get accountsRouteName => '$routeName/accounts/get';

  String get upiRouteName => '$routeName/account/upi/get';

  String get sbRouteName => '$routeName/account/sb';

  String get guestTokenConfigRouteName => '$routeName/init/get';

  String get mobileNumberRouteName => '$routeName/devices/get';

  

  @override
  Future<RequestMobileNumberResponse> requestMobileNumber(
      String vmnCode) async {
    // Log the request details
    print('Requesting mobile number with VMN Code: $vmnCode');

    final Response response = await post(
      createUri(mobileNumberRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: await _auth.guestToken ?? '',
      },
      body: jsonEncode(<String, dynamic>{
        'vmn_code': vmnCode,
      }),
    );

    // Log the raw response
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);

      // Log parsed response details
      print('Parsed Response JSON: $responseJson');

      if (responseJson['code'] == 2000) {
        print(
            'Request successful, mobile number: ${responseJson['mobile_number']}');
        return RequestMobileNumberResponse(
          responseJson['code'],
          responseJson['mobile_number'],
        );
      } else if (responseJson['code'] == 3000) {
        print('Error: VMN Code does not exist.');
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.vmnCodeNotExists,
        );
      } else if (responseJson['code'] == 1000) {
        print('Error: Server error while requesting mobile number.');
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.requestMobileNumberServerError,
        );
      }

      print('Error: Invalid response code.');
      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    // Log non-200 status code error
    print('Error: Unexpected status code ${response.statusCode}');
    throw UnexpectedServerResponseException(statusCode: response.statusCode);
  }

  @override
  Future<RequestOtpServerResponse> requestOtp({String? mobileNumber}) async {
    final Response response = await post(
      createUri(otpRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: await _auth.guestToken ?? ''
      },
      body: jsonEncode(<String, dynamic>{'mobile_number': mobileNumber}),
    );

    print('Request OTP : ${response.body}');

    // throw const UnexpectedServerResponseException(
    //   statusCode: ErrorCodes.requestOtpError,
    // );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['code'] == 2000) {
        return RequestOtpServerResponse(
          responseJson['code'],
          responseJson['data']['identification'].toString(),
          responseJson['data']['mobile_number'],
        );
      } else if (responseJson['code'] == 3000) {
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.maxAttemptedToRequestOtp,
        );
      } else if (responseJson['code'] == 1000) {
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.requestOtpError,
        );
      }
      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    throw UnexpectedServerResponseException(statusCode: response.statusCode);
  }

  @override
  Future<VerifyOtpServerResponse> verifyOtp(String otp, String mobileNumber,
      String deviceId, String identification) async {
    final Response response = await patch(
      createUri(otpRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: await _auth.guestToken ?? ''
      },
      body: jsonEncode(<String, dynamic>{
        'otp': int.parse(otp),
        'mobile_number': mobileNumber,
        'device_id': deviceId,
        'identification': identification
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        return VerifyOtpServerResponse(
          responseJson['code'],
          responseJson['message'],
        );
      } else if (code == 1000) {
        throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.invalidOtpError,
        );
      }
      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    throw UnexpectedServerResponseException(statusCode: response.statusCode);
  }

  @override
  Future<UserSecrets> getUserSecrets(String mobileNumber, String mPin) async {
    final Response response = await post(
      createUri(userSecretsRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: await _auth.guestToken ?? ''
      },
      body: jsonEncode(<String, dynamic>{
        'mobile_number': mobileNumber,
        'mpin': int.parse(mPin)
      }),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        return UserSecrets.fromJson(responseJson['data']);
      } else if (code == 1000) {
        throw UnexpectedServerResponseException(
          statusCode: ErrorCodes.unableToFetchUserSecretsError,
          value: mobileNumber,
        );
      }

      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    throw UnexpectedServerResponseException(statusCode: response.statusCode);
  }

  @override
  Future<List<Account>> getAccounts(String mobileNumber) async {
    final Response response = await post(
      createUri(accountsRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: await _auth.guestToken
      },
      body: jsonEncode(
        <String, dynamic>{
          'mobile': mobileNumber,
        },
      ),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        List accountList = responseJson['data']['accounts'];
        final preparedAccounts =
            accountList.map((e) => Account.fromJson(e)).toList();

        return preparedAccounts;
      } else if (code == 3000) {
        print(response.body);
        return [];
      } else if (code == 1000) {
        // [TODO] : Need to update Specific Error Code for Unregister Mobile Number Error
        // Now, Error Code 1000 with Error Message - USER NOT EXISTS
        final message = responseJson['messgae'];
        if (message.toString().toLowerCase() == 'user not exists') {
          throw UnexpectedServerResponseException(
            statusCode: ErrorCodes.unregisterMobileNumberError,
            value: mobileNumber,
          );
        } else {
          throw UnexpectedServerResponseException(
            statusCode: ErrorCodes.unableToFetchAccountsError,
            value: mobileNumber,
          );
        }
      }

      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    throw UnexpectedServerResponseException(
      statusCode: response.statusCode,
      value: mobileNumber,
    );
  }

  @override
  Future<List<Upi>> getUpis(
      {required String mobileNumber, String? accountId}) async {
    final Response response = await post(
      createUri(upiRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: await _auth.guestToken
      },
      body: jsonEncode(
        <String, dynamic>{
          'mobile_number': mobileNumber,
          if (accountId != null && accountId != '') 'account_number': accountId
        },
      ),
    );

    print('UPI response');
    print(response.body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        final List<dynamic> list = responseJson['data'];

        return list.map((e) => Upi.fromJson(e)).toList();
      } else if (code == 1000) {
        throw UnexpectedServerResponseException(
          statusCode: ErrorCodes.unableToFetchUpisError,
          value: mobileNumber,
        );
      } else if (code == 3000) {
        throw UnexpectedServerResponseException(
          statusCode: ErrorCodes.unregisterMobileNumberError,
          value: mobileNumber,
        );
      }
      throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.invalidResponseError,
      );
    }

    throw UnexpectedServerResponseException(
      statusCode: response.statusCode,
      value: mobileNumber,
    );
  }

  @override
  Future<GuestTokenConfig> getGuestTokenConfig() async {
    final Response response = await post(
      createUri(guestTokenConfigRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: _auth.envToken ?? ''
      },
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        final data = responseJson['data'];
        final vmnList = (data['vmn_list'] as List).map((e) {
          return Vmn(e['vmn_number'], e['is_primary'],e['message'] );
        }).toList();

        List<dynamic> announcementTexts = data['announcement_text'];

        Map<String, String> announcementTextMap = {};

        for (var element in announcementTexts) {
          announcementTextMap[element.keys.first] = element.values.first;
        }

        print(announcementTextMap['en']);

        return GuestTokenConfig(
            vmnList: vmnList,
            guestToken: data['guest_token'],
            announcementText: announcementTextMap,
            pollIntervalSecs: data['notification_time'],
            bgNotificationTimeLimit: data['bg_notification_time_limit']);
      } else if (code == 1000) {
        throw const UnexpectedServerResponseException(
          statusCode: 1000,
          message: 'Failed fetch Api config',
          value: null,
        );
      }
    }

    throw UnexpectedServerResponseException(
      statusCode: response.statusCode,
      message: 'Failed fetch Api config',
      value: null,
    );
  }

  @override
  Future<bool?> sendSbVpa(Upi upi) async {
    final Response response = await post(
      createUri(sbRouteName),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.authorizationHeader: await _auth.guestToken
      },
      body: jsonEncode(
        <String, dynamic>{
          'mobile_number': _auth.registeredUserMobileNumber,
          'customer_name': upi.customerName,
          'vpa': upi.customerVpa
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      final code = responseJson['code'];
      if (code == 2000) {
        return true;
      } else if (code == 1000) {
        throw const UnexpectedServerResponseException(
          statusCode: 1000,
          message: 'Unable to update the vpa',
          value: null,
        );
      }
    }

    throw UnexpectedServerResponseException(
      statusCode: response.statusCode,
      message: 'Unable to update the vpa',
      value: null,
    );
  }
}

import 'package:flutter_secure_token_manager/flutter_secure_token_manager.dart';
import 'package:flutter_secure_token_manager/token.dart';

import '../../../config/server_config.dart';
import '../../data.dart';

class AuthorizationMemorySource {
  String? _userUUID;
  String? _userMPIN;
  String? _userMobileNumber;

  Account? _userAccount;
  Upi? _userUpi;

  GuestTokenConfig? _guestTokenConfig;

  SubscriptionData? _subscriptionData;

  clear() {
    _userUUID = null;
    _userUpi = null;
    _userAccount = null;
    _userMPIN = null;
    _userMobileNumber = null;
    _subscriptionData = null;
  }

  final FlutterSecureTokenManager _accessTokenManager =
      FlutterSecureTokenManager();

  final FlutterSecureTokenManager _guestTokenManager =
      FlutterSecureTokenManager();

  set onAccessTokenExpired(
      Future<Token> Function(String refreshToken)? onExpired) {
    _accessTokenManager.onTokenExpired = onExpired;
  }

  set onGuestTokenExpired(
      Future<Token> Function(String refreshToken)? onExpired) {
    _guestTokenManager.onTokenExpired = onExpired;
  }

  // Get Registered User Mobile Number.
  String? get registeredUserMobileNumber => _userMobileNumber;

  // Store User Mobile Number
  set registerUserMobileNumber(String mobileNumber) =>
      _userMobileNumber = mobileNumber;

  // Store User Mpin
  set registerUserMPin(String mPin) => _userMPIN = mPin;

  // Get User MPIN.
  String? get registeredUserMPin => _userMPIN;

  // Store User Upi
  set registerUserUpi(Upi upi) => _userUpi = upi;

  // Get User Upi
  Upi? get registeredUserUpi => _userUpi;

  // Get User UUID
  String? get registeredUserUUID => _userUUID;

  // Store Account Id
  set registerUserAccount(Account? account) => _userAccount = account;

  // Get Account Id
  Account? get userAccount => _userAccount;

  setAccessAndRefreshToken(
    String? uuid,
    String accessToken,
    String refreshToken,
  ) async {
    _userUUID = uuid;

    await _accessTokenManager.setToken(
      token: Token(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  Future<String> get bearerToken async =>
      await _accessTokenManager.getAccessToken();

  setGuestTokenAndVmnList(GuestTokenConfig guestTokenConfig) async {
    _guestTokenConfig = guestTokenConfig;

    await _guestTokenManager.setToken(
      token: Token(
        accessToken: guestTokenConfig.guestToken!,
        refreshToken: '',
      ),
    );
  }

  get guestToken async => await _guestTokenManager.getAccessToken();

  setSimSubscriptionData(SubscriptionData subscriptionData) {
    _subscriptionData = subscriptionData;
  }

  get envToken => ServerConfig.token;

  get guestTokenConfig => _guestTokenConfig;

  get vmNumbers => _guestTokenConfig?.vmnList;

  SubscriptionData? get subscriptionData => _subscriptionData;

}

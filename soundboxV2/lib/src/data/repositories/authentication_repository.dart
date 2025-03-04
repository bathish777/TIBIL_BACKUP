import 'package:flutter_secure_token_manager/token.dart';
import 'package:sound_box/src/config/device_config.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/data_sources/authentication/authentication_source.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';
import 'package:sound_box/src/data/exceptions/user_credential_exception.dart';
import 'package:sound_box/src/data/repositories/payment_repository.dart';
import 'package:sound_box/src/data/repositories/payment_summary_repository.dart';
import 'package:sound_box/src/data/server_responses/mobile_number_response.dart';
import 'package:sound_box/src/data/server_responses/request_otp_server_response.dart';
import 'package:sound_box/src/data/server_responses/verify_otp_server_response.dart';

import '../../sim_binding/sms_handler.dart';
import '../../sim_binding/sim_info_handler.dart';

import '../exceptions/error_codes.dart';

class VmnData {
  final String vmnNumber;
  final String message;

  VmnData(this.vmnNumber, this.message);
}

class AuthenticationRepository {
  final AuthenticationRemoteSource _authenticationRemoteSource;
  final AuthorizationMemorySource _authorizationMemorySource;
  final UserRepository _userRepository;
  final UserCredentialRepository _userCredentialRepository;
  final PaymentSummaryRepository _paymentSummaryRepository;
  final PaymentRepository _paymentRepository;
  final SubscriptionDataRepository _subscriptionDataRepository;

  AuthenticationRepository(
      this._authenticationRemoteSource,
      this._authorizationMemorySource,
      this._userRepository,
      this._userCredentialRepository,
      this._paymentSummaryRepository,
      this._paymentRepository,
      this._subscriptionDataRepository) {}

  static void register() {
    UserRepository.register();
    UserCredentialRepository.register();

    getIt
      ..registerSingleton<AuthorizationMemorySource>(
        AuthorizationMemorySource(),
      )
      ..registerFactory<AuthenticationRemoteSource>(
        () => AuthenticationApiSource(
          getIt<AuthorizationMemorySource>(),
        ),
      )
      ..registerLazySingleton(
        () => AuthenticationRepository(
            getIt<AuthenticationRemoteSource>(),
            getIt<AuthorizationMemorySource>(),
            getIt<UserRepository>(),
            getIt<UserCredentialRepository>(),
            getIt<PaymentSummaryRepository>(),
            getIt<PaymentRepository>(),
            getIt<SubscriptionDataRepository>()),
      );
  }

  setupGuestTokenExpire() {
    _authorizationMemorySource.onGuestTokenExpired = _refreshGuestToken;
  }

  setupAccessTokenExpire() {
    _authorizationMemorySource.onAccessTokenExpired = _refreshAccessToken;
  }

  Future<MessageResult?> sendSms(int? simSlot) async {
    final vmnNumberList = _getActiveVmnNumbers();

    // List<Vmn> vmnList = _authorizationMemorySource.vmNumbers ?? [];
    // print('vn number in api_config file <<<<<<<<***************>>>>>>>>>  $vmnNumberList');
    return await SmsHandler.sendMessage(simSlot, vmnNumberList);
  }

  // Get the sim subscription details with the slot from the sim
  Future<SimInfoResult?> getSimSubscriptionDetails(int? simSlot) async {
    return await SimInfoHandler.getSimDetails(simSlot);
  }

  // List<String?> _getActiveVmnNumbers() {
  //   final List<Vmn> vmnList = _authorizationMemorySource.vmNumbers ?? [];

  //   // If primary field is set, then pick those.
  //   final primaryVmnNumbers = vmnList
  //       .where((vmn) => vmn.isPrimary == true)
  //       .map((vmn) => vmn.vmnNumber)
  //       .toList();

  //   // Otherwise will pick all
  //   return primaryVmnNumbers.isNotEmpty
  //       ? primaryVmnNumbers
  //       : vmnList.map((vmn) => vmn.vmnNumber).toList();

  // }

  List<VmnData> _getActiveVmnNumbers() {
    final List<Vmn> vmnList = _authorizationMemorySource.vmNumbers ?? [];

    // If primary field is set, then pick those.
    final primaryVmns = vmnList
        .where((vmn) => vmn.isPrimary == true)
        .map((vmn) => VmnData(vmn.vmnNumber, vmn.message))
        .toList();

    // Otherwise will pick all
    return primaryVmns.isNotEmpty
        ? primaryVmns
        : vmnList.map((vmn) => VmnData(vmn.vmnNumber, vmn.message)).toList();
  }

  set registerMobileNumber(String mn) =>
      _authorizationMemorySource.registerUserMobileNumber = mn;

  String? get mobileNumber =>
      _authorizationMemorySource.registeredUserMobileNumber;

  set registerUserMPin(String mPin) =>
      _authorizationMemorySource.registerUserMPin = mPin;

  String? get mPin => _authorizationMemorySource.registeredUserMPin;

  set registerUserUpi(Upi upi) =>
      _authorizationMemorySource.registerUserUpi = upi;

  set registerUserAccount(Account? account) =>
      _authorizationMemorySource.registerUserAccount = account;

  Account? get userAccount => _authorizationMemorySource.userAccount;

  Upi? get userUpi => _authorizationMemorySource.registeredUserUpi;

  Future<UserCredential?> checkUserCredential() async {
    UserCredential? userCredential = await _userCredentialRepository.get();

    return userCredential;
  }

  Future<UserSecrets?> get storedUserSecrets async =>
      await _userRepository.getUserSecrets();

  Future<void> clearUserSecrets() async {
    await _userRepository.clearUserSecrets();
  }

  // Set the subscription data for the slot selected
  void setupSimSubscriptionData(String? slotId, String? subscriptionId) {
    SubscriptionData subscriptionData =
        SubscriptionData(simSlot: slotId, subscriptionId: subscriptionId);

    _authorizationMemorySource.setSimSubscriptionData(subscriptionData);
  }

  SubscriptionData? get subscriptionData =>
      _authorizationMemorySource.subscriptionData;

  // Get sim subscription details
  Future<SubscriptionData?> registerSubscriptionData(
      String? simSlot, String? subscriptionId) async {
    return await _subscriptionDataRepository.save(simSlot!, subscriptionId!);
  }

  Future<SubscriptionData?> getSubscriptionDetails() async {
    SubscriptionData? subscriptionData =
        await _subscriptionDataRepository.get();

    return subscriptionData;
  }

  Future<void> storeUserUpi(Upi upi) async {
    await _userRepository.clearUpi();
    await _userRepository.saveUpi(upi);
    return;
  }

  Future<void> clearUserUpi() async {
    await _userRepository.clearUpi();
  }

  Future<Upi?> get storedUpi async => await _userRepository.getUpi();

  Future<UserCredential?> storeUserCredential({
    required String userMPin,
    required String mobileNumber,
    required String deviceId,
    required Upi userUpi,
  }) async {
    await _userCredentialRepository.clear();

    UserCredential? userCredential = await _userCredentialRepository.save(
      deviceId,
      mobileNumber,
      userMPin,
    );

    return userCredential;
  }

  Future<UserCredential?> get storedUserCredential async =>
      await _userCredentialRepository.get();

  Future<void> clearUserCredential() async {
    await _userCredentialRepository.clear();
  }

  Future<void> clearPaymentData() async {
    await _paymentSummaryRepository.clear();
    await _paymentRepository.clear();
  }

  void clearAuth() {
    _authorizationMemorySource.clear();
  }

  Future<void> clearSubscriptionData() async {
    await _subscriptionDataRepository.clear();
  }

  Future<UserCredential> verifyUserCredential(String mpin) async {
    UserCredential? userCredential = await _userCredentialRepository.get();

    if (userCredential != null) {
      if (mpin != userCredential.mpin) {
        throw const UserCredentialException(
          type: UserCredentialExceptionType.invalidMPin,
        );
      }
    } else {
      throw const UserCredentialException(
        type: UserCredentialExceptionType.notFound,
      );
    }

    return userCredential;
  }

  // Remote API function call.
  Future<RequestOtpServerResponse> requestOtp({String? mobileNumber}) async {
    RequestOtpServerResponse response = await _authenticationRemoteSource
        .requestOtp(mobileNumber: mobileNumber);

    return response;
  }

  Future<RequestMobileNumberResponse> requestMobileNumber(
    String vmnCode,
  ) async {
    return await _authenticationRemoteSource.requestMobileNumber(vmnCode);
  }

  Future<VerifyOtpServerResponse> verifyOtp(
    String otp,
    String mobileNumber,
    String deviceId,
    String identification,
  ) async {
    VerifyOtpServerResponse verifyOtpServerResponse =
        await _authenticationRemoteSource.verifyOtp(
      otp,
      mobileNumber,
      deviceId,
      identification,
    );

    return verifyOtpServerResponse;
  }

  Future<UserSecrets> getAndStoreUserSecrets(
    String mobileNumber,
    String mpin,
  ) async {
    await _userRepository.clearUserSecrets();
    UserSecrets? userSecrets = await _authenticationRemoteSource.getUserSecrets(
      mobileNumber,
      mpin,
    );
    await _userRepository.saveUserSecrets(userSecrets);
    return userSecrets;
  }

  Future<List<Account>> getAccounts(String mobileNumber) async {
    List<Account> accounts =
        await _authenticationRemoteSource.getAccounts(mobileNumber);
    return accounts;
  }

  Future<List<Upi>> getUpis({
    required String mobileNumber,
    String? accountId,
  }) async {
    List<Upi> upis = await _authenticationRemoteSource.getUpis(
      mobileNumber: mobileNumber,
      accountId: accountId,
    );
    return upis;
  }

  Future<bool?> sendSb(Upi upi) async {
    return await _authenticationRemoteSource.sendSbVpa(upi);
  }

  Future<GuestTokenConfig> getGuestTokenConfig() async {
    return await _authenticationRemoteSource.getGuestTokenConfig();
  }

  // Token Setup Functions implementation.
  void setupAccessToken(UserSecrets userSecrets) {
    _authorizationMemorySource.setAccessAndRefreshToken(
      userSecrets.uuid,
      userSecrets.accessToken,
      userSecrets.refreshToken,
    );

    setupAccessTokenExpire();
  }

  Future<void> setupGuestTokenConfig(GuestTokenConfig guestTokenConfig) async {
    await _authorizationMemorySource.setGuestTokenAndVmnList(guestTokenConfig);
    setupGuestTokenExpire();
  }

  GuestTokenConfig? get guestTokenConfig =>
      _authorizationMemorySource.guestTokenConfig;

  Future<Token> _refreshAccessToken(String refreshToken) async {
    UserCredential? userCredential = await checkUserCredential();
    try {
      if (userCredential != null) {
        UserSecrets? userSecrets = await getAndStoreUserSecrets(
          userCredential.mobileNumber,
          userCredential.mpin,
        );
        return Token(
          accessToken: userSecrets.accessToken,
          refreshToken: userSecrets.refreshToken,
        );
      }
    } catch (e) {
      throw const UnexpectedServerResponseException(
          statusCode: ErrorCodes.unauthorizedError);
    }
    throw const UnexpectedServerResponseException(
        statusCode: ErrorCodes.unauthorizedError);
  }

  Future<Token> _refreshGuestToken(String _) async {
    try {
      GuestTokenConfig guestTokenConfig = await getGuestTokenConfig();

      if (guestTokenConfig.guestToken != null) {
        return Token(
            accessToken: guestTokenConfig.guestToken!, refreshToken: '');
      }
    } catch (e) {
      throw const UnexpectedServerResponseException(statusCode: 401);
    }
    throw const UnexpectedServerResponseException(
      statusCode: 401,
    );
  }
}

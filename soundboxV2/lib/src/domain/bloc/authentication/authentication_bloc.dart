import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:sound_box/src/config/device_config.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';
import 'package:sound_box/src/data/exceptions/user_credential_exception.dart';
import 'package:sound_box/src/data/server_responses/mobile_number_response.dart';
import 'package:sound_box/src/data/server_responses/request_otp_server_response.dart';

import 'package:sound_box/src/sim_binding/sms_handler.dart';

import 'package:sound_box/src/notification_service/notification_handler.dart';

import '../../../config/config.dart';
import '../../../data/exceptions/error_codes.dart';
import '../../../sim_binding/sim_info_handler.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._authenticationRepository)
      : super(const AuthenticationInitial()) {
    // Check the User Registered Already Or Not - For Sign up or Login MPIN/
    on<AuthenticationCheckUserCredentialEvent>(_mapCheckUserCredentialState);

    // Request For User Mobile Number.
    on<AuthenticationRequestMobileNumberEvent>(_mapRequestMobileNumberState);

    // Fetch User Account List
    on<AuthenticationLoadAccountEvent>(_mapLoadAccountsState);

    // Fetch User VPA List
    on<AuthenticationLoadVpaEvent>(_mapLoadVpaState);

    // After selected VPA - call SB VPA call Initiate Request OTP
    on<AuthenticationSelectedVpaEvent>(_mapSelectedVpaState);

    // Request OTP
    on<AuthenticationRequestOtpEvent>(_mapRequestOtpState);

    // Verify OTP
    on<AuthenticationVerifyOtpEvent>(_mapVerifyOtpState);

    // Get Back to the VPA
    on<AuthenticationGetBackToVAPEvent>(_mapGetBackToVPAState);

    // Get Back to the Account
    on<AuthenticationGetBackToAccountEvent>(_mapGetBackToAccountState);

    // Storing The User Credential Data.
    on<AuthenticationRegisterUserCredentialEvent>(
      _mapRegisterUserCredentialState,
    );

    on<AuthenticationVerifyUserCredentialEvent>(_mapVerifyUserCredentialState);

    on<AuthenticationResetMPinEvent>(_mapResetMPinState);

    on<AuthenticationLogout>(_mapLogoutState);

    on<AuthenticationLoginLastAttemptFailure>(_mapLoginLastAttemptFailure);

    on<AuthenticationTokenExpiredFailure>(_mapTokenFailure);

    on<AuthenticationCheckSimChange>(_mapCheckSimChangeState);
  }

  final AuthenticationRepository _authenticationRepository;

  static void register() {
    AuthenticationRepository.register();

    getIt.registerLazySingleton(
      () => AuthenticationBloc(getIt<AuthenticationRepository>()),
      dispose: (instance) => instance.close(),
    );
  }

  Future<void> _mapCheckUserCredentialState(
      AuthenticationCheckUserCredentialEvent event,
      Emitter<AuthenticationState> emit) async {
    try {
      final UserCredential? userCredential =
          await _authenticationRepository.checkUserCredential();

      if (userCredential == null) {
        try {
          // Check if permission is granted
          bool permissionGranted = await MobileNumber.hasPhonePermission;

          if (permissionGranted) {
            // Get SIM cards information
            List<SimCard>? simCards = await MobileNumber.getSimCards;

            DeviceConfig.simListData = simCards!
                .map(
                  (element) => SimLocalData(
                    number: element.slotIndex.toString(),
                    carrier: element.carrierName,
                  ),
                )
                .toList();
          } else {
            DeviceConfig.simListData = [];
          }
        } catch (e) {
          DeviceConfig.simListData = [];
        }

        emit(AuthenticationUserCredentialInitial(userCredential));

        final guestTokenConfig =
            await _authenticationRepository.getGuestTokenConfig();
        await _authenticationRepository.setupGuestTokenConfig(guestTokenConfig);
      } else {
        emit(AuthenticationUserCredentialInitial(userCredential));
      }
    } catch (e) {
      print(e);
      emit(const AuthenticationUnexpectedFailure(ErrorCodes.unknownError));
    }
  }



Future<dynamic> _mapRequestMobileNumberState(
  AuthenticationRequestMobileNumberEvent event,
  Emitter<AuthenticationState> emit,
) async {
  print('Starting _mapRequestMobileNumberState...');
  emit(AuthenticationRequestMobileNumberInProgress());

  try {
    final simNumber = event.selectedSimData.number;
    print('Selected SIM number: $simNumber');

    // Check if SIM subscription data is available
    final SubscriptionData? subscriptionData =
        await _authenticationRepository.getSubscriptionDetails();
    print('Retrieved Subscription Data: $subscriptionData');

    // If exists, then check with the SIM match
    if (subscriptionData != null) {
      // Get the subscription id for the selected SIM to match
      final SimInfoResult? simInfoResult = await _authenticationRepository
          .getSimSubscriptionDetails(int.tryParse(simNumber!));
      print('SIM Info Result: $simInfoResult');

      // Check if the selected SIM and registered SIM are the same
      if (simInfoResult != null) {
        if (simInfoResult.subscriptionId != null &&
            subscriptionData.subscriptionId !=
                simInfoResult.subscriptionId.toString()) {
          print(
              'SIM change detected! Registered subscription ID: ${subscriptionData.subscriptionId}, Selected SIM subscription ID: ${simInfoResult.subscriptionId}');
          emit(
            const AuthenticationSignInFailure(
              ErrorCodes.simChangeDetectionError,
            ),
          );
          return;
        }
      }
    }

    if (simNumber != null && simNumber != '') {
      print('Sending SMS to SIM number: $simNumber');
      final MessageResult? msgResult =
          await _authenticationRepository.sendSms(int.tryParse(simNumber));
      print('Message Result: $msgResult');

      if (msgResult != null && msgResult.isSmsSendSuccess) {
        String vmnCode = msgResult.encodedMsg ?? '';
        print('VMN Code received: $vmnCode');

        for (int retryCount = 0;
            retryCount < Config.maxAttemptsOfRequestMobileNumber;
            retryCount++) {
          print('Attempt $retryCount to request mobile number...');
          await Future.delayed(
            Duration(seconds: Config.timeDelayForRequestMobileNumber),
          );

          try {
            RequestMobileNumberResponse response =
                await _authenticationRepository.requestMobileNumber(vmnCode);
            print('Request Mobile Number Response: $response');

            final mobileNumber = response.mobileNumber;
            print('Mobile number retrieved: $mobileNumber');

            // Store User Mobile Number in Authorization Memory
            _authenticationRepository.registerMobileNumber = mobileNumber;

            // Set the slot and subscription id for SIM validation
            _authenticationRepository.setupSimSubscriptionData(
                simNumber, msgResult.subscriptionId!.toString());
            print('Setup SIM subscription data completed.');

            add(const AuthenticationLoadAccountEvent());
            return;
          } on UnexpectedServerResponseException catch (e) {
            print(
                'UnexpectedServerResponseException caught with status code: ${e.statusCode}');
            if (e.statusCode == ErrorCodes.vmnCodeNotExists) {
              if (retryCount < Config.maxAttemptsOfRequestMobileNumber) {
                print('Retrying due to VMN Code Not Exists...');
                continue;
              }
            } else {
              emit(const AuthenticationRequestMobileNumberFailure(
                  ErrorCodes.requestMobileNumberServerError));
              return;
            }
          }
        }
        print('Max retry attempts reached. Request failed.');
        emit(const AuthenticationRequestMobileNumberFailure(
            ErrorCodes.requestMobileNumberMaxAttemptFailure));
        return;
      } else {
        print('Unable to send SMS.');
        emit(const AuthenticationRequestMobileNumberFailure(
            ErrorCodes.unableToSendSms));
        return;
      }
    } else {
      print('Invalid SIM number.');
      emit(const AuthenticationRequestMobileNumberFailure(
          ErrorCodes.invalidSimNumber));
      return;
    }
  } catch (e) {
    print('Unexpected error occurred: $e');
    emit(const AuthenticationUnexpectedFailure(ErrorCodes.unknownError));
  }
}

  // Handle The Load User Account
  Future<void> _mapLoadAccountsState(
    AuthenticationLoadAccountEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationLoadAccountInProgress());

    final mobNo = _authenticationRepository.mobileNumber;

    if (mobNo != null) {
      try {
        final accounts = await _authenticationRepository.getAccounts(mobNo);

        if (accounts.isNotEmpty) {
          emit(AuthenticationLoadAccountSuccess(accounts));
        } else {
          add(const AuthenticationLoadVpaEvent(null));
        }
      } on UnexpectedServerResponseException catch (e) {
        if (e.statusCode == ErrorCodes.unregisterMobileNumberError) {
          emit(AuthenticationUnRegisteredMobileNumberError());
        } else {
          emit(AuthenticationLoadAccountFailure(e.statusCode));
        }
      } catch (e) {
        emit(const AuthenticationUnexpectedFailure(ErrorCodes.unknownError));
      }
    } else {
      emit(
        const AuthenticationUnexpectedFailure(ErrorCodes.invalidMobileNumber),
      );
    }
  }

  Future<void> _mapLoadVpaState(
    AuthenticationLoadVpaEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoadVpaInProgress());

    final mobileNumber = _authenticationRepository.mobileNumber;

    if (mobileNumber != null) {
      try {
        // Store Selected Account in Auth Memory
        _authenticationRepository.registerUserAccount = event.account;

        List<Upi> upis = await _authenticationRepository.getUpis(
          mobileNumber: mobileNumber,
          accountId: event.account?.accountId,
        );

        print('VPAs $upis');

        if (upis.isNotEmpty) {
          emit(AuthenticationLoadVpaSuccess(upis));
        } else {
          emit(const AuthenticationLoadVpaFailure(ErrorCodes.noUpisFound));
        }
      } on UnexpectedServerResponseException catch (e) {
        if (e.statusCode == ErrorCodes.unregisterMobileNumberError) {
          emit(AuthenticationUnRegisteredMobileNumberError());
        } else {
          emit(const AuthenticationLoadVpaFailure(
              ErrorCodes.unableToFetchUpisError));
        }
      } catch (e) {
        emit(
          const AuthenticationUnexpectedFailure(ErrorCodes.unknownError),
        );
      }
    } else {
      emit(
        const AuthenticationUnexpectedFailure(ErrorCodes.invalidMobileNumber),
      );
    }
  }

  Future<void> _mapGetBackToVPAState(
    AuthenticationGetBackToVAPEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final userAccount = _authenticationRepository.userAccount;

    print('Previous Selected Account $userAccount');

    add(AuthenticationLoadVpaEvent(userAccount));
  }

  Future<void> _mapGetBackToAccountState(
    AuthenticationGetBackToAccountEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final account = _authenticationRepository.userAccount;

    if(account != null) {
      add(const AuthenticationLoadAccountEvent());
    } else {
      add(AuthenticationCheckUserCredentialEvent());
    }
  }

  Future<void> _mapSelectedVpaState(
    AuthenticationSelectedVpaEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationSendVpaAndRequestOtpInProgress());

    final mobileNumber = _authenticationRepository.mobileNumber;

    if (mobileNumber != null) {
      try {
        Upi selectedUpi = event.upi;

        // Send selected User VPA details to server
        await _authenticationRepository.sendSb(selectedUpi);

        // Register selected User VPA in Auth Memory Source
        _authenticationRepository.registerUserUpi = selectedUpi;

        // Initiate First Request OTP call
        RequestOtpServerResponse? response = await _authenticationRepository
            .requestOtp(mobileNumber: mobileNumber);

        emit(AuthenticationOtpInitial(response.identification!));
      } on UnexpectedServerResponseException catch (e) {
        print('Error On Select VPA $e');
        emit(AuthenticationSendVpaAndRequestOtpFailure(e.statusCode));
      } catch (e) {
        emit(
          const AuthenticationUnexpectedFailure(ErrorCodes.unknownError),
        );
      }
    } else {
      emit(
        const AuthenticationUnexpectedFailure(ErrorCodes.invalidMobileNumber),
      );
    }
  }

  Future<void> _mapRequestOtpState(
    AuthenticationRequestOtpEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    final mobileNumber = _authenticationRepository.mobileNumber;

    print(mobileNumber);

    if (mobileNumber != null) {
      try {
        RequestOtpServerResponse response = await _authenticationRepository
            .requestOtp(mobileNumber: mobileNumber);

        emit(
          AuthenticationOtpInitial(
            response.identification!,
            isResetMode: event.isResetMode,
          ),
        );
      } on UnexpectedServerResponseException catch (e) {
        print(e);
        emit(
          AuthenticationOtpFailure(
            e.statusCode,
            isResetMode: event.isResetMode,
          ),
        );
      } catch (e) {
        print(e);
        emit(const AuthenticationUnexpectedFailure(ErrorCodes.unknownError));
      }
    } else {
      emit(
        const AuthenticationUnexpectedFailure(ErrorCodes.invalidMobileNumber),
      );
    }
  }

  Future<void> _mapVerifyOtpState(
    AuthenticationVerifyOtpEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationOtpVerifyInProgress());

    final mobileNumber = _authenticationRepository.mobileNumber;

    if (mobileNumber != null) {
      try {
        await _authenticationRepository.verifyOtp(
          event.otp,
          mobileNumber,
          DeviceConfig.id,
          event.identification,
        );

        emit(AuthenticationOtpVerified(isResetMode: event.isResetMode));
      } on UnexpectedServerResponseException catch (e) {
        if (e.statusCode == ErrorCodes.invalidOtpError) {
          emit(
            AuthenticationOtpInvalid(
              event.identification,
              isResetMode: event.isResetMode,
            ),
          );
        } else {
          emit(
            AuthenticationOtpFailure(
              e.statusCode,
              isResetMode: event.isResetMode,
            ),
          );
        }
      } catch (e) {
        emit(const AuthenticationUnexpectedFailure(ErrorCodes.unknownError));
      }
    } else {
      emit(
        const AuthenticationUnexpectedFailure(ErrorCodes.invalidMobileNumber),
      );
    }
  }

  Future<void> _mapRegisterUserCredentialState(
    AuthenticationRegisterUserCredentialEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationUserCredentialRegisterInProgress());

    final mobileNumber = _authenticationRepository.mobileNumber;

    final userUpi = _authenticationRepository.userUpi;

    print(userUpi);

    final userMPin = event.userMPin;

    if (userUpi != null && mobileNumber != null) {
      try {
        // Fetching User Secret from server and Store Locally
        await _authenticationRepository.getAndStoreUserSecrets(
          mobileNumber,
          userMPin,
        );

        // Store User UPI in local
        await _authenticationRepository.storeUserUpi(userUpi);

        // Store User Credential in local
        await _authenticationRepository.storeUserCredential(
          userMPin: userMPin,
          mobileNumber: mobileNumber,
          deviceId: DeviceConfig.id,
          userUpi: userUpi,
        );

        // Local Subscription data in Authorization Memory Source
        final subscriptionData = _authenticationRepository.subscriptionData;

        //Clear the subscription data before to save the latest entry
        await _authenticationRepository.clearSubscriptionData();

        await _authenticationRepository.registerSubscriptionData(
          subscriptionData?.simSlot!,
          subscriptionData?.subscriptionId!,
        );

        // Add Event for check User Credential and Load MPin Login View
        add(AuthenticationCheckUserCredentialEvent());
      } on UnexpectedServerResponseException catch (e) {
        print(e);

        await _clearStoredUserInfo();
        // [TODO] : For future purpose - emit(AuthenticationUserCredentialRegisterFailure(e.statusCode));
        emit(AuthenticationUnexpectedFailure(e.statusCode));
      } catch (e) {
        print(e);
        await _clearStoredUserInfo();
        emit(const AuthenticationUnexpectedFailure(ErrorCodes.unknownError));
      }
    }
  }

  _clearStoredUserInfo() async {
    await _authenticationRepository.clearUserCredential();
    await _authenticationRepository.clearUserSecrets();
    await _authenticationRepository.clearUserUpi();
  }

  _mapVerifyUserCredentialState(
    AuthenticationVerifyUserCredentialEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationUserCredentialRegisterInProgress());

    final userMPin = event.userMPin;

    try {
      UserCredential userCredential =
          await _authenticationRepository.verifyUserCredential(userMPin);

      UserSecrets? userSecrets =
          await _authenticationRepository.storedUserSecrets;

      Upi? userUpi = await _authenticationRepository.storedUpi;

      if (userSecrets != null && userUpi != null) {
        // Register Mobile Number and User Upi in Auth Memory source.
        _authenticationRepository.registerMobileNumber =
            userCredential.mobileNumber;

        _authenticationRepository.registerUserUpi = userUpi;

        // setup User Token
        _authenticationRepository.setupAccessToken(userSecrets);

        emit(AuthenticationSuccess(userCredential, userSecrets, userUpi));
      } else {
        emit(
          const AuthenticationUserCredentialVerifyFailure(
            ErrorCodes.unableToFetchUserSecretsError,
          ),
        );
      }
    } on UnexpectedServerResponseException catch (e) {
      emit(AuthenticationUserCredentialVerifyFailure(e.statusCode));
    } on UserCredentialException catch (e) {
      if (e.type == UserCredentialExceptionType.invalidMPin) {
        emit(AuthenticationLoginFailure(e.type));
      } else {
        emit(
          const AuthenticationUnexpectedFailure(
            ErrorCodes.localUserCredentialError,
          ),
        );
      }
    } catch (e) {
      emit(
        const AuthenticationUnexpectedFailure(
          ErrorCodes.localUserCredentialError,
        ),
      );
    }
  }

  _mapResetMPinState(
    AuthenticationResetMPinEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationOtpInitial('', isResetMode: true));

    print('Called Reset Mpin Event');
    UserCredential? userCredential =
        await _authenticationRepository.storedUserCredential;

    Upi? upi = await _authenticationRepository.storedUpi;

    final mobileNumber = userCredential?.mobileNumber;

    print('Mobile nUmber of User credential $mobileNumber');

    if (mobileNumber != null && upi != null) {
      // Get Mobile Number of Register User Credential and Call Reset MPIN flow.
      _authenticationRepository.registerMobileNumber = mobileNumber;

      // Register UPI in Authorization memory source
      _authenticationRepository.registerUserUpi = upi;

      final guestTokenConfig =
          await _authenticationRepository.getGuestTokenConfig();
      await _authenticationRepository.setupGuestTokenConfig(guestTokenConfig);

      add(const AuthenticationRequestOtpEvent(isResetMode: true));
    } else {
      emit(
        const AuthenticationUnexpectedFailure(
          ErrorCodes.invalidMobileNumber,
        ),
      );
    }
  }

  _mapLogoutState(
    AuthenticationLogout event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _clearStoredUserInfo();
    _authenticationRepository.clearAuth();
    getIt<NotificationHandler>().stopNotificationHandler();
    emit(const AuthenticationInitial());
  }

  _mapLoginLastAttemptFailure(AuthenticationLoginLastAttemptFailure event,
      Emitter<AuthenticationState> emit) {
    emit(AuthenticationLoginLastAttemptFailureState());
  }

  _mapTokenFailure(AuthenticationTokenExpiredFailure event,
      Emitter<AuthenticationState> emit) {
    emit(const AuthenticationUnexpectedFailure(ErrorCodes.unauthorizedError));
  }

  _mapCheckSimChangeState(AuthenticationCheckSimChange event,
      Emitter<AuthenticationState> emit) async {
    // Check if sim subscription data is available
    final SubscriptionData? subscriptionData =
        await _authenticationRepository.getSubscriptionDetails();

    // If exists then check with the sim match
    if (subscriptionData != null) {
      // Get the subscription id for the selected sim to match
      final SimInfoResult? simInfoResult = await _authenticationRepository
          .getSimSubscriptionDetails(int.tryParse(subscriptionData.simSlot!));

      // Check if the sim that is selected is the same that is registered earlier
      if (simInfoResult != null) {
        // If the selected sim and registered sim are not same then show error for sim change
        if (subscriptionData.subscriptionId != simInfoResult.subscriptionId) {
          emit(
            const AuthenticationUnexpectedFailure(
              ErrorCodes.simChangeDetectionError,
            ),
          );
          return;
        }
      }
    } else {
      emit(
        const AuthenticationUnexpectedFailure(
          ErrorCodes.simChangeDetectionError,
        ),
      );
    }
  }
}

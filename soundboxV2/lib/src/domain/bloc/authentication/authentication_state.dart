part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();

  @override
  List<Object?> get props => [];
}

// User Signed up state.
class AuthenticationUserCredentialInitial extends AuthenticationState {
  const AuthenticationUserCredentialInitial(this.userCredential);

  final UserCredential? userCredential;

  @override
  List<Object?> get props => [userCredential];
}

// Request Mobile States
class AuthenticationRequestMobileNumberInProgress extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationRequestMobileNumberSuccess extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationRequestMobileNumberFailure extends AuthenticationState {
  const AuthenticationRequestMobileNumberFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [errorCode];
}

// Account States
class AuthenticationLoadAccountInProgress extends AuthenticationState {
  const AuthenticationLoadAccountInProgress();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoadAccountSuccess extends AuthenticationState {
  const AuthenticationLoadAccountSuccess(this.accounts);

  final List<Account>? accounts;

  @override
  List<Object?> get props => [accounts];
}

class AuthenticationLoadAccountFailure extends AuthenticationState {
  const AuthenticationLoadAccountFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [errorCode];
}

// VPA States
class AuthenticationLoadVpaInProgress extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationLoadVpaSuccess extends AuthenticationState {
  const AuthenticationLoadVpaSuccess(this.upis);

  final List<Upi> upis;

  @override
  List<Object?> get props => [upis];
}

class AuthenticationLoadVpaFailure extends AuthenticationState {
  const AuthenticationLoadVpaFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [errorCode];
}

// Send VPA and Init Request OTP
class AuthenticationSendVpaAndRequestOtpInProgress extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSendVpaAndRequestOtpFailure extends AuthenticationState {
  const AuthenticationSendVpaAndRequestOtpFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [errorCode];
}

// Request, Verify OTP states.
class AuthenticationOtpInitial extends AuthenticationState {
  const AuthenticationOtpInitial(this.identificationCode, {this.isResetMode});

  final String identificationCode;
  final bool? isResetMode;

  @override
  List<Object?> get props => [identificationCode, isResetMode];
}

class AuthenticationOtpVerifyInProgress extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationOtpVerified extends AuthenticationState {

  const AuthenticationOtpVerified({this.isResetMode});

  final bool? isResetMode;

  @override
  List<Object?> get props => [isResetMode];
}

class AuthenticationOtpFailure extends AuthenticationState {
  const AuthenticationOtpFailure(this.errorCode, {this.isResetMode});

  final int errorCode;
  final bool? isResetMode;

  @override
  List<Object?> get props => [errorCode, isResetMode];
}

class AuthenticationOtpInvalid extends AuthenticationState {
  const AuthenticationOtpInvalid(this.identificationCode, {this.isResetMode});

  final String identificationCode;
  final bool? isResetMode;

  @override
  List<Object?> get props => [identificationCode, isResetMode];
}

// Unregister Mobile Number Error State
class AuthenticationUnRegisteredMobileNumberError extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

// Stores User Credential States
class AuthenticationUserCredentialRegisterInProgress
    extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationUserCredentialRegisterFailure extends AuthenticationState {
  const AuthenticationUserCredentialRegisterFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [];
}

// App level Authentication failure state
class AuthenticationUnexpectedFailure extends AuthenticationState {
  const AuthenticationUnexpectedFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [];
}

// User Credential Verify for mpin login.

class AuthenticationUserCredentialVerifyInProgress extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationUserCredentialVerifyFailure extends AuthenticationState {
  const AuthenticationUserCredentialVerifyFailure(this.errorCode);

  final int errorCode;

  @override
  List<Object?> get props => [errorCode];
}

class AuthenticationCheckDeviceConfigSetupFailure extends AuthenticationState {
  const AuthenticationCheckDeviceConfigSetupFailure();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoginInitial extends AuthenticationState {
  const AuthenticationLoginInitial();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoginFailure extends AuthenticationState {
  const AuthenticationLoginFailure(this.type);

  final UserCredentialExceptionType type;

  @override
  List<Object?> get props => [];
}

class AuthenticationLoginLastAttemptFailureState extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSignInInitial extends AuthenticationState {
  const AuthenticationSignInInitial();

  @override
  List<Object?> get props => [];
}

class AuthenticationSignInLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSignInFailure extends AuthenticationState {
  const AuthenticationSignInFailure(this.errorCode);

  final int? errorCode;

  @override
  List<Object?> get props => [errorCode];
}

class AuthenticationLoginLoading extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  const AuthenticationSuccess(
    this.userCredential,
    this.userSecrets,
    this.upi,
  );

  final UserCredential userCredential;
  final UserSecrets? userSecrets;
  final Upi? upi;

  @override
  List<Object?> get props => [];
}

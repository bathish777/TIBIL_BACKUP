part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AuthenticationRequestMobileNumberEvent extends AuthenticationEvent {
  const AuthenticationRequestMobileNumberEvent(this.selectedSimData);

  final SimLocalData selectedSimData;

  @override
  List<Object?> get props => [selectedSimData];
}

class AuthenticationLoadAccountEvent extends AuthenticationEvent {
  const AuthenticationLoadAccountEvent();

  @override
  List<Object?> get props => [];
}


class AuthenticationLoadVpaEvent extends AuthenticationEvent {
  const AuthenticationLoadVpaEvent(this.account);

  final Account? account;

  @override
  List<Object?> get props => [account];
}

class AuthenticationSelectedVpaEvent extends AuthenticationEvent {
  const AuthenticationSelectedVpaEvent(this.upi);

  final Upi upi;

  @override
  List<Object?> get props => [upi];
}

class AuthenticationGetBackToVAPEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationGetBackToAccountEvent extends AuthenticationEvent {

  @override
  List<Object?> get props => [];
}

class AuthenticationCheckUserCredentialEvent extends AuthenticationEvent {


  @override
  List<Object?> get props => [];
}

class AuthenticationRegisterUserCredentialEvent extends AuthenticationEvent {
  const AuthenticationRegisterUserCredentialEvent(this.userMPin);

  final String userMPin;

  @override
  List<Object?> get props => [userMPin];
}

class AuthenticationVerifyUserCredentialEvent extends AuthenticationEvent {
  const AuthenticationVerifyUserCredentialEvent(this.userMPin);

  final String userMPin;

  @override
  List<Object?> get props => [userMPin];
}

class AuthenticationLogin extends AuthenticationEvent {
  const AuthenticationLogin(this.userCredential);

  final UserCredential? userCredential;

  @override
  List<Object?> get props => [];
}

class AuthenticationLoginLastAttemptFailure extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationVerifyOtpEvent extends AuthenticationEvent {
  const AuthenticationVerifyOtpEvent(this.otp, this.identification,
      {this.isResetMode});

  final String otp;
  final String identification;
  final bool? isResetMode;

  @override
  List<Object?> get props => [otp, identification, isResetMode];
}

class AuthenticationRequestOtpEvent extends AuthenticationEvent {
  const AuthenticationRequestOtpEvent({this.isResetMode});

  final bool? isResetMode;

  @override
  List<Object?> get props => [];
}

class AuthenticationResetMPinEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationNavigateBackToSignIn extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationNavigateBackToVerifyOtp extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationLogout extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationCheckDeviceConfigSetup extends AuthenticationEvent {
  const AuthenticationCheckDeviceConfigSetup(this.mobileNumber);

  final String mobileNumber;

  @override
  List<Object?> get props => [];
}

class AuthenticationTokenExpiredFailure extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class AuthenticationCheckSimChange extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

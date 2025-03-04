class SignInServerResponse {
  SignInServerResponse(
    this.code,
    this.mobileNumber,
    this.identification,
  );

  final int code;
  final String mobileNumber;
  final String identification;
}

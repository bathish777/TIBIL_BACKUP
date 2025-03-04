class RequestOtpServerResponse {
  RequestOtpServerResponse(this.code, this.identification, this.mobileNumber);

  final int code;
  final String? identification;
  final String? mobileNumber;
}

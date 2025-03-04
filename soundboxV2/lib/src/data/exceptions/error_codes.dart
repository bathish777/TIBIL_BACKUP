abstract class ErrorCodes {
  static const int internalServerError = 500;
  static const int badGatewayError = 502;
  static const int serverUnavailableError = 503;
  static const int forbiddenError = 403;
  static const int unauthorizedError = 401;

  static const int unknownError = 3000;

  static const int unregisterMobileNumberError = 3001;
  static const int invalidOtpError = 3002;
  static const int unableToFetchAccountsError = 3003;
  static const int unableToFetchUserSecretsError = 3004;
  static const int unableToFetchUpisError = 3005;

  static const int noRecordFoundError = 3006;
  static const int requestOtpError = 3007;
  static const int noAccountsFoundError = 3008;
  static const int unableToFetchPaymentSummary = 3009;
  static const int unableToFetchPayments = 3010;

  static const int invalidResponseError = 3011;

  static const int unableToUpdatePreference = 3012;
  static const int unableToFetchTC = 3013;

  static const int localUserCredentialError = 3014;

  static const int unableToVerifyMobileNumber = 3015;

  static const int vmnCodeNotExists = 3016;

  static const int unableToGetApiTokenConfig = 3017;

  static const int requestMobileNumberMaxAttemptFailure = 3018;
  static const int requestMobileNumberServerError = 3019;

  static const int invalidSimNumber = 3020;
  static const int unableToSendSms = 3021;
  
  static const int invalidMobileNumber = 3022;

  static const int noUpisFound = 3023;

  // If the selected sim is not the same as registered earlier
  static const int simChangeDetectionError = 3017;

  static const int maxAttemptedToRequestOtp = 3018;
}


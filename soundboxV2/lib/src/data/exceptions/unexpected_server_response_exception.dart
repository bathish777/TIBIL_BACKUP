import 'package:sound_box/src/data/exceptions/error_codes.dart';

import '../../localization/l10n.dart';

class UnexpectedServerResponseException implements Exception {
  const UnexpectedServerResponseException(
      {required this.statusCode, this.value, this.message});

  final int statusCode;
  final String? value;
  final String? message;


  static getErrorMsg(L10n l10n, int statusCode) {
    return switch (statusCode) {
      ErrorCodes.internalServerError => l10n.app.unable_to_reach_server,
      ErrorCodes.badGatewayError => l10n.app.unable_to_reach_server,
      ErrorCodes.serverUnavailableError => l10n.app.unable_to_reach_server,
      ErrorCodes.forbiddenError => l10n.app.unable_to_authorized,
      ErrorCodes.unauthorizedError => l10n.app.authorization_failed,
      ErrorCodes.unregisterMobileNumberError =>
        l10n.app.use_registered_number_text,
      // ErrorCodes.invalidOtpError => '',
      ErrorCodes.unableToFetchAccountsError =>
        l10n.app.unable_to_fetch_accounts,
      ErrorCodes.unableToFetchUserSecretsError =>
        l10n.app.unable_to_load_required_info,
      ErrorCodes.unableToFetchUpisError =>
        l10n.app.unable_to_fetch_account_details,
      ErrorCodes.noUpisFound => l10n.app.no_vpa_text,

      ErrorCodes.noRecordFoundError => l10n.app.no_records_found,
      ErrorCodes.requestOtpError => l10n.app.resend_otp_failed_text,
      ErrorCodes.noAccountsFoundError => l10n.app.no_accounts_text,
      ErrorCodes.unableToFetchPaymentSummary =>
        l10n.app.unable_fetch_payment_detail_text,
      ErrorCodes.unableToFetchPayments =>
        l10n.app.unable_fetch_payment_list_text,
      ErrorCodes.invalidResponseError => l10n.app.invalid_response,
      ErrorCodes.localUserCredentialError =>
        l10n.app.unable_to_get_user_credential,
      ErrorCodes.unableToVerifyMobileNumber => l10n.app.unable_to_reach_server,
      ErrorCodes.simChangeDetectionError => l10n.app.sim_change_detected,
      ErrorCodes.maxAttemptedToRequestOtp => l10n.app.max_attempted_request_otp,

      // [TODO] :  Need to Handle Unknown error'${l10n.app.unexpected_error}: $message',
      ErrorCodes.unknownError || _ => l10n.app.unable_to_reach_server
    };
  }

  getErrorMessage(L10n l10n) {
    return getErrorMsg(l10n, statusCode);
  }
}

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sign_in => 'Sign In';

  @override
  String get enter_phone_no => 'Enter your mobile number here';

  @override
  String get agree_with => 'I agree with the';

  @override
  String get term_condition => 'Terms and Conditions';

  @override
  String get next => 'Next';

  @override
  String get verification_code => 'Verification Code';

  @override
  String get enter_otp => 'Please enter the OTP sent to your device';

  @override
  String get resend_otp_in => 'Resend OTP in';

  @override
  String get resend_otp => 'Resend OTP';

  @override
  String get enter_mpin => 'Enter mPin';

  @override
  String enter_no_of_pin(int   number) {
    return 'Enter a $number digit mPin';
  }

  @override
  String get verify_mpin => 'Verify mPin';

  @override
  String re_enter_no_of_pin(int   number) {
    return 'Re-enter your $number digit mPin';
  }

  @override
  String get hello_text => 'Hello';

  @override
  String get your_qr_code => 'This is your QR Code';

  @override
  String get upi_id => 'UPI ID';

  @override
  String get go_to_dashboard => 'Go to Dashboard';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get total_transaction => 'Total Transactions';

  @override
  String get total_amount => 'Total Amount';

  @override
  String get transaction => 'Transactions';

  @override
  String get my_profile => 'My Profile';

  @override
  String get name_text => 'Name';

  @override
  String get business_name => 'Business Name';

  @override
  String get mobile_no_text => 'Mobile Number';

  @override
  String get my_qr_code_text => 'My QR Code';

  @override
  String get share_qr_code => 'Share QR Code';

  @override
  String get settings_text => 'Settings';

  @override
  String get announcements_text => 'Announcements';

  @override
  String get mute_text => 'Mute';

  @override
  String get unmute_text => 'Unmute';

  @override
  String get language_preference => 'Language Preference';

  @override
  String get change_my_mpin => 'Change my mPIN';

  @override
  String get sign_out => 'Sign Out';

  @override
  String get today_text => 'Today';

  @override
  String get my_qr_text => 'My QR';

  @override
  String get wait_for_verify_text => 'Please wait we are verifying your\nmobile number';

  @override
  String get mobile_no_not_found => 'Unable to fetch further information!';

  @override
  String get use_registered_number_text => 'It could be an issue with selected mobile number or account number.';

  @override
  String get has_register_number_text => 'Please make sure you are attempting\nto sign in with a device that has the\nSIM for your registered mobile\nnumber!';

  @override
  String get voice_announcements_mute => 'Voice announcements are muted!';

  @override
  String get voice_announcements_un_mute => 'Voice announcements are unmuted!';

  @override
  String get un_mute_announcement_setting_text => 'You can unmute the voice announcements\nin the \\bSettings\\b screen';

  @override
  String get select_preferred_language_text => 'You can select your preferred language by going\nto the \\bLanguage Preference\\b option in the\n\\bSettings\\b screen';

  @override
  String get sign_out_confirmation_text => 'Are you sure you want to sign out?';

  @override
  String get clear_all_data_sign_text => 'This will clear all your local data and \nyou will have to sign in using your mobile number again';

  @override
  String get yes_text => 'YES';

  @override
  String get no_text => 'NO';

  @override
  String get reset_mpin_title_text => 'You will no longer be able to use your previous mPIN for signing in';

  @override
  String get want_change_mpin_text => 'Are you sure you want to reset your mPIN ?';

  @override
  String get forgot_mpin_text => 'Forgot mPin?';

  @override
  String get login_text => 'SIGN IN';

  @override
  String get display_24hrs_text => 'The application shows only today\'s transactions';

  @override
  String get as_of_text => 'As of';

  @override
  String get otp_invalid_text => 'OTP invalid!';

  @override
  String transaction_announcement_text(Object amount) {
    return 'Amount credited to your Jana Small Finance Bank account is $amount Rupees.';
  }

  @override
  String get unexpected_error_text => 'Unexpected Error';

  @override
  String get ok_text => 'Ok';

  @override
  String get sim_config_setup_error => 'Unable to get and verify the SIM number, do you want to continue?';

  @override
  String failed_sign_in_text(Object mobileNumber) {
    return 'Failed to sign in with $mobileNumber';
  }

  @override
  String get resend_otp_failed_text => 'Failed to resend OTP';

  @override
  String verify_otp_failed_text(Object otp) {
    return 'Failed to verify OTP $otp';
  }

  @override
  String login_failed_text(Object mobileNumber) {
    return 'Failed to sign in with mobile number: $mobileNumber';
  }

  @override
  String get unable_fetch_payment_detail_text => 'Unable to load payment details';

  @override
  String get unable_fetch_payment_list_text => 'Unable to load payments';

  @override
  String get continue_text => 'Continue';

  @override
  String get terms_conditions_error_text => 'Unable to load Terms and Conditions';

  @override
  String get create_mpin_text => 'Create mPin';

  @override
  String get mpin_not_match => 'mPIN does not match!';

  @override
  String invalid_mpin_text(Object attempts) {
    return 'Please enter the correct mPIN!\n($attempts attempts remaining)';
  }

  @override
  String get try_again_after_minutes_text => 'Incorrect mPIN!\nYou’ve exhausted all your sign in attempts,\nplease try again after 5 minutes!';

  @override
  String get language_not_support_text => 'This language is not supported by\nyour device.';

  @override
  String get enable_language_text => 'Find out how to enable the language here:';

  @override
  String get want_to_exit => 'Are you sure you want to exit?';

  @override
  String get login_with_mpin_again => ' You will have to login with your mPIN again';

  @override
  String get login_again_text => 'You will have to login again';

  @override
  String get no_accounts_text => 'No accounts';

  @override
  String get select_account_text => 'Select an account to\nconnect to iVanii';

  @override
  String get account_type => 'Account type:';

  @override
  String get ifsc_code => 'IFSC Code:';

  @override
  String get unable_to_reach_server => 'Unable to reach Server';

  @override
  String get unable_to_authorized => 'Unable to authorize. Please Try Again';

  @override
  String get authorization_failed => 'Authorization failed. Please try again';

  @override
  String get unable_to_fetch_accounts => 'Unable to fetch Accounts';

  @override
  String get unable_to_load_required_info => 'Unable to load required information';

  @override
  String get unable_to_fetch_account_details => 'Unable to fetch VPA list';

  @override
  String get invalid_response => 'Invalid Response';

  @override
  String get unable_to_get_user_credential => 'Unable to get User Credential';

  @override
  String get unexpected_error => 'Unexpected error';

  @override
  String get vpa_list_title_text => 'Select a VPA ID';

  @override
  String get sim_change_detected => 'Unable to find registered SIM! Please sign in again to proceed.';

  @override
  String get no_records_found => 'No Records found';

  @override
  String get no_vpa_text => 'No VPAs';

  @override
  String get max_attempted_request_otp => 'Too many attempts made! Please try after some time.';
}

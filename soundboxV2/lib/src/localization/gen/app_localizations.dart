import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn')
  ];

  /// Sign in label
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// Enter your mobile number here label
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number here'**
  String get enter_phone_no;

  /// I agree with Terms and Conditions label
  ///
  /// In en, this message translates to:
  /// **'I agree with the'**
  String get agree_with;

  /// Terms and Conditions label
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get term_condition;

  /// Next button label
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Verification Code label
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verification_code;

  /// Please enter the OTP sent to your device label
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP sent to your device'**
  String get enter_otp;

  /// Resend OTP in label
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in'**
  String get resend_otp_in;

  /// No description provided for @resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resend_otp;

  /// Enter mPin label
  ///
  /// In en, this message translates to:
  /// **'Enter mPin'**
  String get enter_mpin;

  /// Enter a 4 digit mPin label
  ///
  /// In en, this message translates to:
  /// **'Enter a {number} digit mPin'**
  String enter_no_of_pin(int   number);

  /// Verify mPin label
  ///
  /// In en, this message translates to:
  /// **'Verify mPin'**
  String get verify_mpin;

  /// Re-enter a 4 digit mPin label
  ///
  /// In en, this message translates to:
  /// **'Re-enter your {number} digit mPin'**
  String re_enter_no_of_pin(int   number);

  /// Hello label
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello_text;

  /// This is your QR Code label
  ///
  /// In en, this message translates to:
  /// **'This is your QR Code'**
  String get your_qr_code;

  /// UPI ID label
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upi_id;

  /// Go to Dashboard label
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get go_to_dashboard;

  /// Dashboard label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Total Transactions label
  ///
  /// In en, this message translates to:
  /// **'Total Transactions'**
  String get total_transaction;

  /// Total Amount label
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get total_amount;

  /// Transactions label
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transaction;

  /// My Profile label
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// Name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_text;

  /// Business Name label
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get business_name;

  /// Mobile Number label
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile_no_text;

  /// My QR Code label
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get my_qr_code_text;

  /// Share QR Code label
  ///
  /// In en, this message translates to:
  /// **'Share QR Code'**
  String get share_qr_code;

  /// Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_text;

  /// Announcements label
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements_text;

  /// Mute label
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute_text;

  /// Unmute label
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute_text;

  /// Language Preference label
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get language_preference;

  /// Change my mPIN label
  ///
  /// In en, this message translates to:
  /// **'Change my mPIN'**
  String get change_my_mpin;

  /// Sign Out label
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today_text;

  /// My QR label
  ///
  /// In en, this message translates to:
  /// **'My QR'**
  String get my_qr_text;

  /// Please wait we are verifying your mobile number label
  ///
  /// In en, this message translates to:
  /// **'Please wait we are verifying your\nmobile number'**
  String get wait_for_verify_text;

  /// Unable to fetch further information! label
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch further information!'**
  String get mobile_no_not_found;

  /// Please use registered mobile number to sign in error text label
  ///
  /// In en, this message translates to:
  /// **'It could be an issue with selected mobile number or account number.'**
  String get use_registered_number_text;

  /// Please make sure you are attempting to sign in with a device that has the SIM for your registered mobile number! error text label
  ///
  /// In en, this message translates to:
  /// **'Please make sure you are attempting\nto sign in with a device that has the\nSIM for your registered mobile\nnumber!'**
  String get has_register_number_text;

  /// Voice announcements are muted! label
  ///
  /// In en, this message translates to:
  /// **'Voice announcements are muted!'**
  String get voice_announcements_mute;

  /// Voice announcements are unmuted! label
  ///
  /// In en, this message translates to:
  /// **'Voice announcements are unmuted!'**
  String get voice_announcements_un_mute;

  /// You can unmute the voice announcements in the Settings screen label
  ///
  /// In en, this message translates to:
  /// **'You can unmute the voice announcements\nin the \\bSettings\\b screen'**
  String get un_mute_announcement_setting_text;

  /// You can select your preferred language by going to the Language Preference option in the Settings screen label
  ///
  /// In en, this message translates to:
  /// **'You can select your preferred language by going\nto the \\bLanguage Preference\\b option in the\n\\bSettings\\b screen'**
  String get select_preferred_language_text;

  /// Are you sure you want to sign out? label
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get sign_out_confirmation_text;

  /// This will clear all your local data and you will have to sign in using your mobile number again label
  ///
  /// In en, this message translates to:
  /// **'This will clear all your local data and \nyou will have to sign in using your mobile number again'**
  String get clear_all_data_sign_text;

  /// Yes button label
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes_text;

  /// No button label
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no_text;

  /// You will no longer be able to use your previous mPIN for signing in label
  ///
  /// In en, this message translates to:
  /// **'You will no longer be able to use your previous mPIN for signing in'**
  String get reset_mpin_title_text;

  /// Are you sure you want to reset your mPIN ? label
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your mPIN ?'**
  String get want_change_mpin_text;

  /// Forgot mPin? label
  ///
  /// In en, this message translates to:
  /// **'Forgot mPin?'**
  String get forgot_mpin_text;

  /// SIGN IN label
  ///
  /// In en, this message translates to:
  /// **'SIGN IN'**
  String get login_text;

  /// The application displays transactions from the last 24hrs label
  ///
  /// In en, this message translates to:
  /// **'The application shows only today\'s transactions'**
  String get display_24hrs_text;

  /// As of label
  ///
  /// In en, this message translates to:
  /// **'As of'**
  String get as_of_text;

  /// OTP invalid! label
  ///
  /// In en, this message translates to:
  /// **'OTP invalid!'**
  String get otp_invalid_text;

  /// Amount credited in your account is amount(100) Rupees text
  ///
  /// In en, this message translates to:
  /// **'Amount credited to your Jana Small Finance Bank account is {amount} Rupees.'**
  String transaction_announcement_text(Object amount);

  /// Unexpected Error label
  ///
  /// In en, this message translates to:
  /// **'Unexpected Error'**
  String get unexpected_error_text;

  /// Ok label
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok_text;

  /// Unable to get and verify the sim number, do you want to continue label
  ///
  /// In en, this message translates to:
  /// **'Unable to get and verify the SIM number, do you want to continue?'**
  String get sim_config_setup_error;

  /// Failed to sign in with mobileNumber label
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with {mobileNumber}'**
  String failed_sign_in_text(Object mobileNumber);

  /// Failed to resend OTP label
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP'**
  String get resend_otp_failed_text;

  /// Failed to verify OTP otp label
  ///
  /// In en, this message translates to:
  /// **'Failed to verify OTP {otp}'**
  String verify_otp_failed_text(Object otp);

  /// Failed to sign in with mobile number:mobileNumber label
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with mobile number: {mobileNumber}'**
  String login_failed_text(Object mobileNumber);

  /// Unable to load payment details label
  ///
  /// In en, this message translates to:
  /// **'Unable to load payment details'**
  String get unable_fetch_payment_detail_text;

  /// Unable to load payments label
  ///
  /// In en, this message translates to:
  /// **'Unable to load payments'**
  String get unable_fetch_payment_list_text;

  /// Continue label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_text;

  /// Unable to load Terms and Conditions label
  ///
  /// In en, this message translates to:
  /// **'Unable to load Terms and Conditions'**
  String get terms_conditions_error_text;

  /// Create mPin label
  ///
  /// In en, this message translates to:
  /// **'Create mPin'**
  String get create_mpin_text;

  /// mPIN does not match label
  ///
  /// In en, this message translates to:
  /// **'mPIN does not match!'**
  String get mpin_not_match;

  /// Please enter the correct mPIN 2 attempts remaining label
  ///
  /// In en, this message translates to:
  /// **'Please enter the correct mPIN!\n({attempts} attempts remaining)'**
  String invalid_mpin_text(Object attempts);

  /// Incorrect mPIN You've exhausted all your sign in attempts please try again after 5 minutes label
  ///
  /// In en, this message translates to:
  /// **'Incorrect mPIN!\nYou’ve exhausted all your sign in attempts,\nplease try again after 5 minutes!'**
  String get try_again_after_minutes_text;

  /// This language is not supported by your device label
  ///
  /// In en, this message translates to:
  /// **'This language is not supported by\nyour device.'**
  String get language_not_support_text;

  /// Find out how to enable the language here label
  ///
  /// In en, this message translates to:
  /// **'Find out how to enable the language here:'**
  String get enable_language_text;

  /// Are you sure you want to exit label
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get want_to_exit;

  ///  You will have to login with your mPIN again label
  ///
  /// In en, this message translates to:
  /// **' You will have to login with your mPIN again'**
  String get login_with_mpin_again;

  /// You will have to login again label
  ///
  /// In en, this message translates to:
  /// **'You will have to login again'**
  String get login_again_text;

  /// No accounts label
  ///
  /// In en, this message translates to:
  /// **'No accounts'**
  String get no_accounts_text;

  /// Select an account to connect to iVanii label
  ///
  /// In en, this message translates to:
  /// **'Select an account to\nconnect to iVanii'**
  String get select_account_text;

  /// Account type label
  ///
  /// In en, this message translates to:
  /// **'Account type:'**
  String get account_type;

  /// IFSC Code label
  ///
  /// In en, this message translates to:
  /// **'IFSC Code:'**
  String get ifsc_code;

  /// Unable to reach server label
  ///
  /// In en, this message translates to:
  /// **'Unable to reach Server'**
  String get unable_to_reach_server;

  /// Unable to authorize please try again label
  ///
  /// In en, this message translates to:
  /// **'Unable to authorize. Please Try Again'**
  String get unable_to_authorized;

  /// Authorization failed. Please try again label
  ///
  /// In en, this message translates to:
  /// **'Authorization failed. Please try again'**
  String get authorization_failed;

  /// Unable to fetch Accounts label
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch Accounts'**
  String get unable_to_fetch_accounts;

  /// Unable to load required information
  ///
  /// In en, this message translates to:
  /// **'Unable to load required information'**
  String get unable_to_load_required_info;

  /// Unable to fetch account details label
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch VPA list'**
  String get unable_to_fetch_account_details;

  /// Invalid Response label
  ///
  /// In en, this message translates to:
  /// **'Invalid Response'**
  String get invalid_response;

  /// Unable to get User Credential label
  ///
  /// In en, this message translates to:
  /// **'Unable to get User Credential'**
  String get unable_to_get_user_credential;

  /// Unexpected error label
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpected_error;

  /// Select a VPA ID label
  ///
  /// In en, this message translates to:
  /// **'Select a VPA ID'**
  String get vpa_list_title_text;

  /// Selected Sim was not used with the registration
  ///
  /// In en, this message translates to:
  /// **'Unable to find registered SIM! Please sign in again to proceed.'**
  String get sim_change_detected;

  /// No Records found label
  ///
  /// In en, this message translates to:
  /// **'No Records found'**
  String get no_records_found;

  /// No VPAs label
  ///
  /// In en, this message translates to:
  /// **'No VPAs'**
  String get no_vpa_text;

  /// Too many attempts made! Please try after some time label.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts made! Please try after some time.'**
  String get max_attempted_request_otp;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'kn': return AppLocalizationsKn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

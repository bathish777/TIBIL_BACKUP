import 'app_localizations.dart';

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get sign_in => 'साइन इन';

  @override
  String get enter_phone_no => 'अपना मोबाइल नंबर यहां दर्ज करें';

  @override
  String get agree_with => 'मैं इससे सहमत हूं';

  @override
  String get term_condition => 'नियम और शर्तें';

  @override
  String get next => 'अगला';

  @override
  String get verification_code => 'सत्यापन कोड';

  @override
  String get enter_otp => 'कृपया अपने उपकरण पर भेजे गए ओटीपी को दर्ज करें';

  @override
  String get resend_otp_in => 'ओटीपी पुनः भेजें';

  @override
  String get resend_otp => 'ओटीपी पुनः भेजें ';

  @override
  String get enter_mpin => 'एमपिन दर्ज करें';

  @override
  String enter_no_of_pin(int   number) {
    return '$number अंक वाला एमपिन दर्ज करें';
  }

  @override
  String get verify_mpin => 'एमपिन सत्यापित करें';

  @override
  String re_enter_no_of_pin(int   number) {
    return 'अपना $number अंक वाला एमपिन पुनः दर्ज करें';
  }

  @override
  String get hello_text => 'नमस्ते';

  @override
  String get your_qr_code => 'यह आपका क्यू आर कोड है';

  @override
  String get upi_id => 'यूपीआई आईडी';

  @override
  String get go_to_dashboard => 'डैशबोर्ड पर जाएँ';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get total_transaction => 'कुल लेनदेन';

  @override
  String get total_amount => 'कुल राशि';

  @override
  String get transaction => 'लेनदेन';

  @override
  String get my_profile => 'मेरी प्रोफाइल';

  @override
  String get name_text => 'नाम';

  @override
  String get business_name => 'व्यवसाय का नाम';

  @override
  String get mobile_no_text => 'मोबाइल नंबर';

  @override
  String get my_qr_code_text => 'मेरा क्यू आर कोड';

  @override
  String get share_qr_code => 'क्यू आर कोड साझा करें';

  @override
  String get settings_text => 'समायोजन';

  @override
  String get announcements_text => 'घोषणाएं';

  @override
  String get mute_text => 'म्यूट';

  @override
  String get unmute_text => 'अनम्यूट';

  @override
  String get language_preference => 'भाषा प्राथमिकता';

  @override
  String get change_my_mpin => 'मेरा एमपिन बदलें';

  @override
  String get sign_out => 'साइन आउट';

  @override
  String get today_text => 'आज';

  @override
  String get my_qr_text => 'मेरा क्यू आर';

  @override
  String get wait_for_verify_text => 'कृपया प्रतीक्षा करें हम आपका मोबाइल नंबर सत्यापित कर रहे हैं';

  @override
  String get mobile_no_not_found => 'अधिक जानकारी लाने में असमर्थ! ';

  @override
  String get use_registered_number_text => 'यह चयनित मोबाइल नंबर या खाता संख्या से संबंधित समस्या हो सकती है।';

  @override
  String get has_register_number_text => 'कृपया सुनिश्चित करें कि आप अपने पंजीकृत\nमोबाइल नंबर के लिए सिम वाले उपकरण\nके साथ साइन इन करने का प्रयास कर रहे हैं!';

  @override
  String get voice_announcements_mute => 'ध्वनि घोषणाएँ मौन हैं!';

  @override
  String get voice_announcements_un_mute => 'ध्वनि घोषणाएँ अनम्यूट हैं!';

  @override
  String get un_mute_announcement_setting_text => 'आप \\bसमायोजन\\b स्क्रीन में ध्वनि घोषणाओं\nको अनम्यूट कर सकते हैं';

  @override
  String get select_preferred_language_text => 'आप \\bसेटिंग\\b स्क्रीन में \\bभाषा प्राथमिकता\\b विकल्प पर\nजाकर अपनी पसंदीदा भाषा चुन सकते हैं';

  @override
  String get sign_out_confirmation_text => 'क्या आप वाकई साइन आउट करना चाहते हैं?';

  @override
  String get clear_all_data_sign_text => 'इससे आपका सारा स्थानीय डेटा साफ़ हो जाएगा और \n आपको अपने मोबाइल नंबर का उपयोग करके फिर से साइन इन करना होगा';

  @override
  String get yes_text => 'हाँ';

  @override
  String get no_text => 'नहीं';

  @override
  String get reset_mpin_title_text => 'अब आप साइन इन करने के लिए अपने पिछले एमपिन का उपयोग नहीं कर पाएंगे';

  @override
  String get want_change_mpin_text => 'क्या आप वाकई अपना एमपिन रीसेट करना चाहते हैं?';

  @override
  String get forgot_mpin_text => 'एमपिन भूल गए?';

  @override
  String get login_text => 'साइन इन करें';

  @override
  String get display_24hrs_text => 'एप्लिकेशन केवल आज के लेनदेन दिखाता है।';

  @override
  String get as_of_text => 'तारीख';

  @override
  String get otp_invalid_text => 'ओटीपी अमान्य है!';

  @override
  String transaction_announcement_text(Object amount) {
    return 'आपके जाना स्मॉल फाइनेंस बैंक खाते में $amount रुपये जमा किए गए हैं।';
  }

  @override
  String get unexpected_error_text => '\nअप्रत्याशित त्रुटि';

  @override
  String get ok_text => 'ठीक है';

  @override
  String get sim_config_setup_error => 'सिम नंबर पाने और सत्यापित करने में असमर्थ, क्या आप जारी रखना चाहते हैं?';

  @override
  String failed_sign_in_text(Object mobileNumber) {
    return '$mobileNumber से साइन इन करने में विफल';
  }

  @override
  String get resend_otp_failed_text => 'ओटीपी फिर से भेजने में विफल';

  @override
  String verify_otp_failed_text(Object otp) {
    return 'ओटीपी सत्यापित करने में विफल $otp';
  }

  @override
  String login_failed_text(Object mobileNumber) {
    return 'मोबाइल नंबर के साथ साइन इन करने में विफलः $mobileNumber';
  }

  @override
  String get unable_fetch_payment_detail_text => 'भुगतान विवरण लोड करने में असमर्थ';

  @override
  String get unable_fetch_payment_list_text => 'भुगतान लोड करने में असमर्थ';

  @override
  String get continue_text => 'जारी रखें';

  @override
  String get terms_conditions_error_text => 'नियम एवं शर्तें लोड करने में असमर्थ';

  @override
  String get create_mpin_text => 'एमपिन बनाएं';

  @override
  String get mpin_not_match => 'एमपिन मेल नहीं खाता!';

  @override
  String invalid_mpin_text(Object attempts) {
    return 'कृपया सही एमपिन दर्ज करें!\n($attempts कोशिशें बाकी)';
  }

  @override
  String get try_again_after_minutes_text => 'गलत एमपिन!\nआपने अपने सभी साइन-इन प्रयासों को समाप्त कर दिया है,\nकृपया 5 मिनट के बाद फिर कोशिश करें!';

  @override
  String get language_not_support_text => 'आपका डिवाइस इस भाषा का समर्थन नहीं करता';

  @override
  String get enable_language_text => 'भाषा को कैसे सक्षम करें:';

  @override
  String get want_to_exit => 'क्या आप वाक़ई  ऐप को बंद करना  चाहते हैं?';

  @override
  String get login_with_mpin_again => 'आपको फिर से अपने mpin के साथ लॉगिन करना होगा';

  @override
  String get login_again_text => 'आपको फिर से लॉगिन करना होगा';

  @override
  String get no_accounts_text => 'कोई खाता नहीं हैं';

  @override
  String get select_account_text => 'iVanii से जुड़ने के लिए एक खाता चुनें';

  @override
  String get account_type => 'खाते का प्रकार:';

  @override
  String get ifsc_code => 'IFSC कोड:';

  @override
  String get unable_to_reach_server => 'सर्वर तक पहुंचने में असमर्थ';

  @override
  String get unable_to_authorized => 'अधिकृत करने में असमर्थ. कृपया पुन: प्रयास करें';

  @override
  String get authorization_failed => 'प्रमाणीकरण विफल। कृपया पुन: प्रयास करें';

  @override
  String get unable_to_fetch_accounts => 'खाते लाने में असमर्थ';

  @override
  String get unable_to_load_required_info => 'आवश्यक जानकारी लोड करने में असमर्थ\n';

  @override
  String get unable_to_fetch_account_details => 'VPA सूची लाने में असमर्थ';

  @override
  String get invalid_response => 'अवैध प्रतिक्रिया';

  @override
  String get unable_to_get_user_credential => 'उपयोगकर्ता क्रेडेंशियल प्राप्त करने में असमर्थ';

  @override
  String get unexpected_error => 'अप्रत्याशित त्रुटि';

  @override
  String get vpa_list_title_text => 'VPA ID  चुनें';

  @override
  String get sim_change_detected => 'पंजीकृत सिम नहीं मिल रहा है! कृपया आगे बढ़ने के लिए फिर से साइन इन करें।';

  @override
  String get no_records_found => ' कोई जानकारी नहीं मिली।';

  @override
  String get no_vpa_text => 'VPAs नहीं ';

  @override
  String get max_attempted_request_otp => 'आपके द्वारा अत्यधिक प्रयास किए गए हैं। कृपया कुछ समय के बाद पुनः प्रयास करें।';
}

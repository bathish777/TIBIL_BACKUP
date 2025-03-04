import 'dart:ui';

import 'package:sound_box/src/theme/theme.dart';

abstract class Config {
  static Locale defaultLocale = const Locale('en');
  static ThemeAppearanceType defaultTheme = ThemeAppearanceType.light;
  static String defaultDateFormat = 'EEEE, dd MMM yyyy';
  static Dip defaultDip = const Dip(designWidth: 360, designHeight: 800);
  static double designHeight = 800;
  static String hashSymbol = '#';
  static String countryCode = '+91';
  static bool defaultAnnouncementMuteState = false;

  // Currency Configuration details
  static String currencySymbol = '₹';
  static String currencyName = "INR";
  static String currencyLocale = 'en_IN';
  static int numberOfDecimalPoints = 2;

  static int defaultOtpTimerSeconds = 60; // 60 seconds

  static double defaultVolume = 1.0;
  static double defaultPitch = 1.0;
  static double defaultRate = 0.5;

  static int appBackgroundInactiveTimeoutMinutes = 5;
  static int appForegroundInactiveTimeoutMinutes = 3;
  static int loginFailureCycleTimeInSeconds = 300; // 300secs - 5 minutes.
  static int loginFailureCycleMaxAttemptCount = 3;

  static String languageInstallUri = 'https://support.google.com/accessibility/android/answer/6006983?hl=en';

  static int otpNumberCount = 6;
  static int notificationTimerMinutes = 1;

  static int transactionLimitation = 10;
  static int transactionOffset = 0;
  static int transactionNotificationRandomIdIntRange = 1000;
  static String obscureTextChar = '•';

  static int maxAttemptsOfRequestMobileNumber = 3;
  static int timeDelayForRequestMobileNumber = 3;  // 3 - Seconds.
}

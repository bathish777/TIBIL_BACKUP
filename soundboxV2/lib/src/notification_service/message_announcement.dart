import 'dart:async';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:sound_box/src/config/config.dart';
import 'package:sound_box/src/localization/l10n.dart';

import '../config/message_announce_config.dart';

class MessageAnnouncement {
  static MessageAnnouncement? _instance;

  MessageAnnouncement._();

  factory MessageAnnouncement() {
    _instance ??= MessageAnnouncement._();
    return _instance!;
  }

  double volume = Config.defaultVolume;
  double pitch = Config.defaultPitch;
  double rate = Config.defaultRate;

  String currentLocale = Config.defaultLocale.toString();
  bool isMuted = Config.defaultAnnouncementMuteState;
  String defaultLocale = Config.defaultLocale.toString();

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  final FlutterTts _flutterTts = FlutterTts();

  String localeBox = 'localeBox';

  void Function()? _onComplete;

  Map<String, String>? _announcementTexts;

  initSetup() async {
    await _flutterTts.awaitSpeakCompletion(true);
    await getDefaultEngineAndVoice();
    await setupWithDefaultVolumePitchRate();
    L10n.supportedLanguages.forEach((appLanguage) async {
      appLanguage.available =
          await _flutterTts.isLanguageAvailable(appLanguage.locale.toString());
    });

    _announcementTexts = MessageAnnounceConfig.announcementTexts;
  }

  set onComplete(void Function() callback) {
    _onComplete = callback;
    _flutterTts.setCompletionHandler(_onComplete!);
  }

  Future<void> getDefaultEngineAndVoice() async {
    await _flutterTts.getDefaultEngine;
    await _flutterTts.getDefaultVoice;
  }

  Future<void> setupWithDefaultVolumePitchRate() async {
    await _flutterTts.setVolume(volume);
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.setPitch(pitch);
  }

  Future<void> setMute(bool mute) async {
    isMuted = mute;
    await storeIntoHive('mute', isMuted);
  }

  Future<String> setLocale(String language) async {
    language = await checkLanguageAvailability(language)
        ? language
        : defaultLocale.toString();

    await _flutterTts.setLanguage(language);

    currentLocale = language;

    await storeIntoHive('locale', currentLocale);

    return currentLocale;
  }

  checkLanguageAvailability(String language) async =>
      await _flutterTts.isLanguageAvailable(language);

  storeIntoHive(String key, dynamic value) async {
    var box = await Hive.openBox(localeBox);
    await box.delete(key);
    await box.put(key, value);
    await box.close();
  }

  initHiveBox() async {
    final Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  }

  dynamic getFromHive(String key) async {
    var box = await Hive.openBox(localeBox);
    dynamic value = await box.get(key);
    await box.close();
    return value;
  }

  Future<void> announceMessage(String amount) async {
    await initHiveBox();

    String localeValue = await getFromHive('locale');
    bool muteValue = await getFromHive('mute');

    if (!muteValue) {
      String amountText = _getAnnouncementAmountText(amount, localeValue);
      await _flutterTts.speak(amountText);
    }
  }

  _getAnnouncementAmountText(String amount, String? localeValue) {
    final currentText = _announcementTexts?[localeValue];
    return currentText?.replaceAll('#amount#', amount);
  }

  void dispose() {
    _flutterTts.stop();
  }
}

class MessageAnnounceConfig {
  static Map<String, String> _announcementTexts = {};
  static int _pollIntervalDurationSecs = 30;
  static int _bgNotifyTimeLimit = 3 ;

  static init(Map<String, String> announcementTexts, int interval, int timeLimit) {
    _announcementTexts = announcementTexts;
    _pollIntervalDurationSecs = interval;
    _bgNotifyTimeLimit = timeLimit;
  }

  static get announcementTexts => _announcementTexts;

  static get pollIntervalDurationSecs => _pollIntervalDurationSecs;

  static get bgNotifyTimeLimit => _bgNotifyTimeLimit;
}

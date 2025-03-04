import '../data.dart';

class GuestTokenConfig extends Model {
  final List<Vmn>? vmnList;
  final String? guestToken;
  final Map<String, String>? announcementText;
  final int? pollIntervalSecs;
  final int? bgNotificationTimeLimit;

  const GuestTokenConfig({
    this.vmnList,
    this.guestToken,
    this.announcementText,
    this.pollIntervalSecs,
    this.bgNotificationTimeLimit,
  });

  @override
  List<Object?> get props => [
        vmnList,
        guestToken,
        announcementText,
        pollIntervalSecs,
        bgNotificationTimeLimit
      ];
}

class Vmn {
  final String vmnNumber;
  final bool isPrimary;
  final String message;

  Vmn(this.vmnNumber, this.isPrimary, this.message);
}

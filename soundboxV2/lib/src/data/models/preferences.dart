import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/data/hive_type_ids.dart';

part 'preferences.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@HiveType(typeId: HiveTypeIds.preferences)
class Preferences extends Model {
  Preferences({
    required this.language,
    required this.mute,
    this.voiceLocale,
  });

  @HiveField(0)
  final String language;

  @HiveField(1)
  @JsonKey(
    fromJson: _muteTypeConvert,
    name: 'mute',
  )
  final bool mute;

  @HiveField(3)
  String? voiceLocale;

  @override
  List<Object?> get props => [language, mute, voiceLocale];

  Preferences copyWith({String? language, bool? mute, String? voiceLocale}) =>
      Preferences(
        language: language ?? this.language,
        mute: mute ?? this.mute,
        voiceLocale: voiceLocale ?? this.voiceLocale,
      );

  set currentVoiceLocale(String locale) {
    voiceLocale = locale;
  }

  /// Creates this from a JSON [Map].
  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  // [TODO] : Added for convert mute string type to bool
  static bool _muteTypeConvert(String? mute) {
    return mute == '1';
  }
}

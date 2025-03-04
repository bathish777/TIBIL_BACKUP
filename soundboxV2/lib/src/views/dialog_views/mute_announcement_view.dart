import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

class MuteAnnouncementView extends StatelessWidget {
  const MuteAnnouncementView({super.key, required this.isMuted});

  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final themeTextStyle = appTypography.themeTextStyle;

    final texts = l10n.app.select_preferred_language_text.split(RegExp(r'\\b'));

    return Padding(
      padding: EdgeInsets.symmetric(vertical: dip(30), horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            isMuted
                ? l10n.app.voice_announcements_un_mute
                : l10n.app.voice_announcements_mute,
            style: themeTextStyle.primaryFontWeight700Style(
              color: appColors.primaryTextColor,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(25),
            ),
            child: isMuted
                ? addBoldStyle(l10n.app.select_preferred_language_text)
                : addBoldStyle( l10n.app.un_mute_announcement_setting_text),
          ),
        ],
      ),
    );
  }

  Text addBoldStyle(String text, {bool isFirstTextBoldSwap = false}) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        children: text.split(RegExp(r'\\b')).map((value) {
          final textSpan = TextSpan(
            text: value,
            style: isFirstTextBoldSwap
                ? appTypography.themeTextStyle.primaryFontWeight700Style(
                    color: appColors.primaryTextColor,
                    fontSize: 12,
                  )
                : appTypography.themeTextStyle.primaryFontWeight400Style(
                    color: appColors.primaryTextColor,
                    fontSize: 12,
                  ),
          );
          isFirstTextBoldSwap = !isFirstTextBoldSwap;
          return textSpan;
        }).toList(),
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../config/config.dart';

class LanguageMessageView extends StatelessWidget {
  const LanguageMessageView({super.key});

  @override
  Widget build(BuildContext context) {

    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: dip(15), horizontal: dip(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            appImages.warning,
            width: dip(50),
            height: dip(50),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: dip(10)),
            child: Text(
              l10n.app.language_not_support_text,
              textAlign: TextAlign.center,
              style: appTypography.themeTextStyle
                  .primaryFontWeight400Style(
                    color: appColors.primaryTextColor,
                    fontSize: 16,
                  )
                  .copyWith(height: dip(1.5)),
            ),
          ),
          Text(
            l10n.app.enable_language_text,
            style: appTypography.themeTextStyle.primaryFontWeight400Style(
              color: appColors.primaryTextColor,
              fontSize: 14,
            ),
          ),
          Text.rich(
            softWrap: true,
            textAlign: TextAlign.center,
            TextSpan(
              style: appTypography.themeTextStyle
                  .primaryFontWeight400Style(
                    color: appColors.celestialBlue,
                    fontSize: 14,
                  )
                  .copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: appColors.celestialBlue,
                  ),
              text: Config.languageInstallUri,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrlString(Config.languageInstallUri);
                },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/config/config.dart';
import 'package:sound_box/src/localization/l10n.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = appTypography.themeTextStyle;
    final l10n = L10n.of(context);

    final String today =
        DateFormat(Config.defaultDateFormat).format(DateTime.now()).toString();

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: dip(15),
          bottom: dip(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: dip(7),
              ),
              child: Text(
                '${l10n.app.as_of_text}',
                style: themeTextStyle.primaryFontWeight400Style(
                    color: appColors.primaryColor, fontSize: 14),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: appColors.primaryColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(dip(12.5))),
              ),
              padding: EdgeInsets.symmetric(horizontal: dip(10), vertical: 0),
              height: dip(25),
              child: Center(
                child: Text(
                  today,
                  style: themeTextStyle.primaryFontWeight700Style(
                    color: appColors.primaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: dip(5),
              ),
              child: Text(
                '(${l10n.app.today_text})',
                style: themeTextStyle.primaryFontWeight400Style(
                    color: appColors.primaryColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

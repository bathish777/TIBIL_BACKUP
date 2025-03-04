import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

class ConfigSetupErrorView extends StatelessWidget {
  const ConfigSetupErrorView({
    super.key,
    required this.errorMessage,
    required this.onPressed,
  });

  final String errorMessage;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: dip(38),
        bottom: dip(33),
        right: dip(10),
        left: dip(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            appImages.warning,
            width: dip(50),
            height: dip(50),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(35),
            ),
            child: Text(
              textAlign: TextAlign.center,
              errorMessage,
              style: appTypography.themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: dip(20)),
            child: IntrinsicWidth(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: dip(9)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(dip(4)),
                    ),
                  ),
                ),
                onPressed: onPressed,
                child: Center(
                  child: Text(
                    L10n.of(context).app.continue_text,
                    style:
                        appTypography.themeTextStyle.primaryFontWeight600Style(
                      color: appColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

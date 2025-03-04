import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

class MobileNumberErrorView extends StatelessWidget {
  const MobileNumberErrorView({
    super.key,
    required this.errorType,
  });

  final MobileNumberErrorType errorType;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final themeTextStyle = appTypography.themeTextStyle;

    final isUnRegisterNumberErrorType =
        errorType == MobileNumberErrorType.unRegisterNumberError;

    return Container(
      padding: EdgeInsets.only(
        top: isUnRegisterNumberErrorType ? dip(38) : dip(27),
        bottom: isUnRegisterNumberErrorType ? dip(33) : dip(38),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            appImages.warning,
            width: dip(50),
            height: dip(50),
          ),
          if (isUnRegisterNumberErrorType)
            Padding(
              padding: EdgeInsets.only(
                top: dip(25),
              ),
              child: Text(
                textAlign: TextAlign.center,
                l10n.app.mobile_no_not_found,
                style: themeTextStyle.primaryFontWeight700Style(
                  color: appColors.primaryTextColor,
                  fontSize: 18,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(35),
            ),
            child: Text(
              textAlign: TextAlign.center,
              isUnRegisterNumberErrorType
                  ? l10n.app.use_registered_number_text
                  : l10n.app.has_register_number_text,
              style: themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MobileNumberErrorType { simBindingError, unRegisterNumberError }
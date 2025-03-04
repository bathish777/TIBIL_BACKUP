import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

class DialogConfirmationButtons extends StatelessWidget {
  const DialogConfirmationButtons({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  final void Function()? onCancel;
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final themeTextStyle = appTypography.themeTextStyle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          child: IntrinsicWidth(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: dip(21),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(dip(4)),
                  ),
                  side: BorderSide(
                    color: appColors.primaryColor,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              onPressed: onCancel,
              child: Center(
                child: Text(
                  l10n.app.no_text,
                  style: themeTextStyle.primaryFontWeight600Style(
                    color: appColors.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: dip(20),
          ),
          child: FittedBox(
            child: IntrinsicWidth(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: dip(19), vertical: dip(0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(dip(4)),
                    ),
                  ),
                ),
                onPressed: onConfirm,
                child: Center(
                  child: Text(
                    l10n.app.yes_text,
                    style: themeTextStyle
                        .primaryFontWeight600Style(
                          color: appColors.white,
                          fontSize: 14,
                        )
                        .copyWith(height: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/dialog_views/language_message_view.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';
import 'package:sound_box/src/widgets/primary_radio.dart';

import 'package:sound_box/src/localization/l10n.dart';

class LanguageRadioButton extends StatelessWidget {
  const LanguageRadioButton({
    required this.language,
    required this.isLast,
    required this.onChange,
    required this.value,
    super.key,
  });

  final AppLanguage language;
  final Locale value;
  final bool isLast;
  final void Function(Locale locale) onChange;

  @override
  Widget build(BuildContext context) {

    final isLanguageAvailable =
        language.isAvailable != null && language.isAvailable!;

    return InkWell(
      onTap: () {
        if (isLanguageAvailable) {
          onChange(language.locale);
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: dip(45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.name,
                  style: appTypography.themeTextStyle.primaryFontWeight400Style(
                    color: isLanguageAvailable
                        ? appColors.primaryTextColor
                        : appColors.starDust,
                    fontSize: 14,
                  ),
                ),
                isLanguageAvailable
                    ? PrimaryRadio<Locale>(
                        size: dip(15),
                        value: language.locale,
                        groupValue: value,
                        onChanged: (value) {
                          onChange(value!);
                        },
                      )
                    : InkWell(
                        onTap: () {
                          AppDialogBox.show(
                            context,
                            const LanguageMessageView(),
                            barrierDismissible: true,
                            willPop: true,
                          );
                        },
                        child: SizedBox.square(
                          dimension: dip(20),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: appColors.sun,
                            size: dip(15),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Divider(
            thickness: dip(1),
            color: appColors.wildSand,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

class SettingListTile extends StatelessWidget {
  const SettingListTile({
    required this.title,
    required this.onPressed,
    required this.trailing,
    super.key,
  });

  final void Function()? onPressed;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: dip(48),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: appTypography.themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 12,
              ),
            ),
            trailing
          ],
        ),
      ),
    );
  }
}

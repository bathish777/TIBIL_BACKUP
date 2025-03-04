import 'package:flutter/material.dart';
import 'package:sound_box/src/theme/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    required this.title,
    this.width,
    this.height,
    this.enabled = true,
    this.showLoader = false,
  });

  final String title;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final bool enabled;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = appTypography.themeTextStyle;

    return SizedBox(
      width: width ?? dip(315),
      height: height ?? dip(40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.primaryColor,
          disabledBackgroundColor: appColors.primaryColor.withOpacity(0.2),
          foregroundColor: appColors.white,
          disabledForegroundColor: appColors.white.withOpacity(0.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(dip(4)))),
        ),
        onPressed: enabled && !showLoader ? onPressed : null,
        child: Center(
          child: showLoader ? const CircularProgressIndicator() : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: themeTextStyle.primaryFontWeight700Style(
                    color: appColors.white, fontSize: 16),
              ),
              Padding(
                padding: EdgeInsets.only(left: dip(10)),
                child: Icon(
                  Icons.arrow_forward,
                  size: dip(20),
                  color: appColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

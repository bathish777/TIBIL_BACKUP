import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class PinTextField extends StatelessWidget {
  const PinTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.androidSmsAutofillMethod = AndroidSmsAutofillMethod.none,
    this.listenForSMSOnIOS = false,
    this.length = 4,
    this.width = 50,
    this.height = 40,
    this.obscureEnabled = false,
  });

  final AndroidSmsAutofillMethod androidSmsAutofillMethod;
  final TextEditingController controller;
  final bool listenForSMSOnIOS;
  final void Function(String value)? onChanged;
  final int length;
  final double width;
  final double height;
  final bool obscureEnabled;

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = appTypography.themeTextStyle;

    final defaultPinTheme = PinTheme(
      width: dip(width),
      height: dip(height),
      textStyle: themeTextStyle.primaryFontWeight400Style(
        color: appColors.primaryTextColor,
        fontSize: 16,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: appColors.starDust),
        borderRadius: BorderRadius.circular(dip(4)),
        color: appColors.white,
      ),
    );

    return Pinput(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        NoPasteTextInputFormatter()
      ],
      onChanged: onChanged,
      controller: controller,
      length: length,
      defaultPinTheme: defaultPinTheme,
      androidSmsAutofillMethod: androidSmsAutofillMethod,
      listenForMultipleSmsOnAndroid: listenForSMSOnIOS,
      obscureText: obscureEnabled,
      obscuringCharacter: Config.obscureTextChar,
      contextMenuBuilder: (context, editableTextState) {
        return Container(); // Disable context menu (copy/paste)
      },
    );
  }
}

class NoPasteTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > oldValue.text.length + 1) {
      return oldValue;
    }
    return newValue;
  }
}

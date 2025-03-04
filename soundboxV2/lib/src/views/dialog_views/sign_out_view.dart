import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/dialog_confirmation_buttons.dart';

import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/localization/l10n.dart';

class SignOutView extends StatelessWidget {
  const SignOutView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final themeTextStyle = appTypography.themeTextStyle;

    return Padding(
      padding: EdgeInsets.only(
          top: dip(30), bottom: dip(32), left: dip(5), right: dip(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            softWrap: true,
            maxLines: 3,
            textAlign: TextAlign.center,
            l10n.app.sign_out_confirmation_text,
            style: themeTextStyle.primaryFontWeight700Style(
              color: appColors.primaryTextColor,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: dip(26)),
            child: Text(
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.center,
              l10n.app.clear_all_data_sign_text,
              style: themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(31),
            ),
            child: DialogConfirmationButtons(
              onCancel: () {
                Navigator.pop(context);
              },
              onConfirm: () {
                Navigator.pop(context);
                context.read<AuthenticationBloc>().add(AuthenticationLogout());
              },
            ),
          ),
        ],
      ),
    );
  }
}

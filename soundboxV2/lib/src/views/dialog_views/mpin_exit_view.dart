import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/dialog_confirmation_buttons.dart';

import 'package:sound_box/src/localization/l10n.dart';

class MPinExitView extends StatelessWidget {
  const MPinExitView({super.key});

  @override
  Widget build(BuildContext context) {

    final l10n = L10n.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: dip(31),
        horizontal: dip(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            softWrap: true,
            maxLines: 3,
            textAlign: TextAlign.center,
            l10n.app.want_to_exit,
            style: appTypography.themeTextStyle.primaryFontWeight400Style(
              color: appColors.primaryTextColor,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(20),
            ),
            child: Text(
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.center,
              l10n.app.login_again_text,
              style: appTypography.themeTextStyle.primaryFontWeight400Style(
                color: appColors.starDust,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(20),
            ),
            child: DialogConfirmationButtons(
              onConfirm: () {
                Navigator.pop(context);
                context.read<AuthenticationBloc>().add(AuthenticationCheckUserCredentialEvent());
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/dialog_confirmation_buttons.dart';

import 'package:sound_box/src/localization/l10n.dart';

class MPinConfirmationView extends StatelessWidget {
  const MPinConfirmationView({super.key, this.showLoggedOutText = false});

  final bool showLoggedOutText;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final themeTextStyle = appTypography.themeTextStyle;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: dip(31),
        horizontal: dip(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: dip(35),
            ),
            child: Text(
              softWrap: true,
              maxLines: 3,
              textAlign: TextAlign.center,
              l10n.app.reset_mpin_title_text,
              style: themeTextStyle.primaryFontWeight400Style(
                color: appColors.primaryTextColor,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            softWrap: true,
            maxLines: 3,
            textAlign: TextAlign.center,
            l10n.app.want_change_mpin_text,
            style: themeTextStyle.primaryFontWeight700Style(
              color: appColors.primaryTextColor,
              fontSize: 12,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: dip(31),
            ),
            child: DialogConfirmationButtons(
              onConfirm: () {
                Navigator.pop(context);
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationResetMPinEvent());
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

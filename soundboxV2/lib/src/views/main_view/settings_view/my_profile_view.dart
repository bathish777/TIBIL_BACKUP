import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/localization/l10n.dart';

import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationSuccess) {
        final Upi? upi = state.upi;

        return BaseContainer(
          title: l10n.app.my_profile,
          child: Container(
            padding: EdgeInsets.all(dip(20)),
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(dip(4)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldText(l10n.app.name_text),
                fieldValueText(upi?.customerName ?? ''),
                // [TODO] Name Data String
                //SizedBox(height: dip(30)),
                //fieldText(l10n.app.business_name),
                // fieldValueText('The best store'),
                // [TODO] Store name String data
                SizedBox(height: dip(30)),
                fieldText(l10n.app.mobile_no_text),
                fieldValueText(state.userCredential.mobileNumber ?? ''),
                // [TODO] Store name String data
              ],
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  fieldText(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: dip(10)),
      child: Text(
        title,
        style: appTypography.themeTextStyle
            .primaryFontWeight500Style(
              color: appColors.starDust,
              fontSize: 10,
            )
            .copyWith(height: 1),
      ),
    );
  }

  fieldValueText(String value) {
    return Text(
      value,
      style: appTypography.themeTextStyle
          .primaryFontWeight400Style(
            color: appColors.primaryTextColor,
            fontSize: 12,
          )
          .copyWith(height: 1),
    );
  }
}

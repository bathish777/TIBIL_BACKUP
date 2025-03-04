import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/dialog_views/mpin_confirmation_view.dart';
import 'package:sound_box/src/views/dialog_views/sign_out_view.dart';
import 'package:sound_box/src/views/main_view/tab_view_config.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/domain/domain.dart';

class SettingButtonListView extends StatelessWidget {
  const SettingButtonListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final settingTabCubit = BlocProvider.of<SettingTabCubit>(context);

    final arrowIcon = Icon(
      Icons.arrow_forward_ios_rounded,
      color: appColors.primaryTextColor,
      size: dip(10),
    );

    final divider = Divider(
      height: 1,
      thickness: 1,
      color: appColors.wildSand,
    );

    final signOutIcon = SvgPicture.asset(
      appImages.signOut,
      width: dip(15),
      height: dip(15),
      colorFilter: ColorFilter.mode(
        appColors.primaryColor,
        BlendMode.srcIn,
      ),
    );

    final muteAndUnmuteTextStyle =
        appTypography.themeTextStyle.primaryFontWeight400Style(
      color: appColors.friarGray,
      fontSize: 8,
    );

    return BaseContainer(
      title: l10n.app.settings_text,
      willPopUp: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: dip(10)),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(dip(4)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SettingListTile(
              title: l10n.app.my_profile,
              trailing: arrowIcon,
              onPressed: () => settingTabCubit.setTabIndex(
                TabViewConfig.myProfileViewIndex,
              ),
            ),
            divider,
            SettingListTile(
              title: l10n.app.my_qr_code_text,
              trailing: arrowIcon,
              onPressed: () => settingTabCubit.setTabIndex(
                TabViewConfig.myQRCodeViewIndex,
              ),
            ),
            divider,
            SettingListTile(
              title: l10n.app.announcements_text,
              trailing: Row(
                children: [
                  Text(l10n.app.mute_text, style: muteAndUnmuteTextStyle),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: dip(5)),
                    child: const MuteSwitch(onChange: null),
                  ),
                  Text(l10n.app.unmute_text, style: muteAndUnmuteTextStyle),
                ],
              ),
              onPressed: () => {},
            ),
            divider,
            SettingListTile(
              title: l10n.app.language_preference,
              trailing: arrowIcon,
              onPressed: () => settingTabCubit.setTabIndex(
                TabViewConfig.languagePreferenceViewIndex,
              ),
            ),
            divider,
            SettingListTile(
              title: l10n.app.change_my_mpin,
              trailing: arrowIcon,
              onPressed: () => {
                AppDialogBox.show(
                  context,
                  const MPinConfirmationView(
                    showLoggedOutText: true,
                  ),
                ),
              },
            ),
            divider,
            SettingListTile(
              title: l10n.app.sign_out,
              trailing: signOutIcon,
              onPressed: () {
                AppDialogBox.show(
                  context,
                  const SignOutView(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

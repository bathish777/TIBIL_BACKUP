import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/main_view/tab_view_config.dart';

import 'language_preference_view.dart';
import 'my_profile_view.dart';
import 'my_qr_code_view.dart';
import 'setting_button_list_view.dart';

class SettingView extends StatelessWidget {
  static const routeName = '/setting';

  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> settingTabView = [
      const SettingButtonListView(),
      const MyProfileView(),
      MyQrCodeView(),
      const LanguagePreferenceView(),
    ];

    return Container(
      color: appColors.tutu,
      child: BlocBuilder<SettingTabCubit, SettingTabState>(
        buildWhen: (_, state) =>
            (state as SettingActiveTabState).activeTabIndex ==
            TabViewConfig.settingViewIndex,
        builder: (BuildContext context, state) {
          return settingTabView[(state as SettingActiveTabState).tabIndex];
        },
      ),
    );
  }
}

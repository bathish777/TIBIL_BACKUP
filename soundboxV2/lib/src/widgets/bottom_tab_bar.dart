import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/domain/bloc/blocs.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({super.key, required this.tabs});

  final List<TabData> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appColors.white,
      height: dip(50),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dip(25), vertical: 0),
        child: BlocBuilder<SettingTabCubit, SettingTabState>(
          builder: (context, tabState) {
            final activeIndex =
                (tabState as SettingActiveTabState).activeTabIndex;

            List<Widget> tabCards = [];
            for (int index = 0; index < tabs.length; index++) {
              final isActiveTab = activeIndex == index;
              final tabColor =
                  isActiveTab ? appColors.primaryColor : appColors.doveGray;
              tabCards.add(
                GestureDetector(
                  onTap: () {
                    if (!isActiveTab) {
                      BlocProvider.of<SettingTabCubit>(context)
                          .setActiveTabIndex(index);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        tabs[index].icon,
                        width: dip(25),
                        height: dip(25),
                        colorFilter: ColorFilter.mode(
                          tabColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        tabs[index].name,
                        style: appTypography.themeTextStyle
                            .primaryFontWeight400Style(
                          color: tabColor,
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: tabCards,
            );
          },
        ),
      ),
    );
  }
}

class TabData {
  TabData({required this.name, required this.icon});

  final String name;
  final String icon;
}

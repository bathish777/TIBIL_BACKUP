import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return BlocBuilder<HeaderTextCubit, bool>(builder: (context, visible) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: visible ? dip(25) : 0,
        color: appColors.doublePearlLusta,
        padding: EdgeInsets.symmetric(horizontal: dip(10)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                l10n.app.display_24hrs_text,
                style: appTypography.themeTextStyle.primaryFontWeight400Style(
                  color: appColors.primaryTextColor,
                  fontSize: 10,
                ),
              ),
              InkWell(
                onTap: () {
                  BlocProvider.of<HeaderTextCubit>(context).closeHeaderText();
                },
                child: SvgPicture.asset(
                  appImages.close,
                  width: dip(12),
                  height: dip(12),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

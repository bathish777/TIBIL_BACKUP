import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/views/main_view/tab_view_config.dart';

class Header extends StatefulWidget {
  const Header({
    super.key,
    required this.title,
    this.hideQRCode = false,
    this.rootTabIndex,
    this.willPopUp = false,
  });

  final String title;
  final bool hideQRCode;
  final int? rootTabIndex;
  final bool willPopUp;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final GlobalKey _textKey = GlobalKey();

  double _containerWidth = 0;
  double _textWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _setUpArrowPosition();
  }

  _setUpArrowPosition() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderObject? textBox = _textKey.currentContext?.findRenderObject();

      if (textBox != null) {
        setState(() {
          _textWidth = (textBox as RenderBox).size.width;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _setUpArrowPosition();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = widget.appTypography.themeTextStyle;
    final l10n = L10n.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      _containerWidth = constraints.maxWidth;

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: widget.dip(45),
            color: widget.appColors.primaryColor,
            padding:
                EdgeInsets.only(left: widget.dip(10), right: widget.dip(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: widget.appImages.dashboardJanaLogo,
                  height: widget.dip(30),
                ),
                (!widget.hideQRCode && widget.rootTabIndex != null)
                    ? GestureDetector(
                        onTap: () {
                          BlocProvider.of<SettingTabCubit>(context)
                              .jumpFromRootTab(
                            widget.rootTabIndex!,
                            TabViewConfig.settingViewIndex,
                            TabViewConfig.myQRCodeViewIndex,
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              widget.appImages.smallQr,
                              width: widget.dip(23),
                              height: widget.dip(23),
                            ),
                            Text(
                              l10n.app.my_qr_text,
                              style: themeTextStyle.primaryFontWeight500Style(
                                  color: widget.appColors.white, fontSize: 8),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(width: widget.dip(23))
              ],
            ),
          ),
          if (widget.willPopUp)
            Positioned(
              left: (_containerWidth / 2 - _textWidth / 2) - widget.dip(30),
              child: InkWell(
                onTap: () {
                  BlocProvider.of<SettingTabCubit>(context).getBackRootTab();
                },
                child: Container(
                  padding: EdgeInsets.all(widget.dip(5)),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: widget.appColors.white,
                    size: widget.dip(15),
                  ),
                ),
              ),
            ),
          Text(
            key: _textKey,
            widget.title,
            style: themeTextStyle.secondaryFontWeight700Style(
              color: widget.appColors.white,
              fontSize: 16,
            ),
          ),
        ],
      );
    });
  }
}

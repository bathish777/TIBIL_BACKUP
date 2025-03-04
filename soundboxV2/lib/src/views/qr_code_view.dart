import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/widgets/app_view.dart';
import 'package:sound_box/src/widgets/primary_button.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:no_screenshot/no_screenshot.dart'; // Add the package

import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'main_view/main_view.dart';

class QRCodeView extends StatefulWidget {
  static const routeName = '/qrcode';

  const QRCodeView({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  _QRCodeViewState createState() => _QRCodeViewState();
}

class _QRCodeViewState extends State<QRCodeView> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    _enableScreenshots(); // Enable screenshots when this view is active
  }

  @override
  void dispose() {
    _disableScreenshots(); // Disable screenshots when leaving the view
    super.dispose();
  }

  Future<void> _disableScreenshots() async {
    await _noScreenshot.screenshotOff();
  }

  Future<void> _enableScreenshots() async {
    await _noScreenshot.screenshotOn();
  }

  @override
  Widget build(BuildContext context) {
    return AppView(
      resizeToAvoidBottomInset: false,
      child: SizedBox.expand(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationSuccess) {
                Upi? upi = state.upi;
                return _QRCodeImage(
                  base64String: upi?.base64qrcode,
                  navigatorKey: widget.navigatorKey,
                );
              }
              return const SizedBox.shrink();
            }),
      ),
    );
  }
}

class _QRCodeImage extends StatelessWidget {
  const _QRCodeImage({required this.base64String, required this.navigatorKey});

  final String? base64String;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return base64String != null
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(dip(15)),
          child: GestureDetector(
            onTap: () {
              _navigateToDashboard();
            },
            child: SvgPicture.asset(
              appImages.close,
              width: dip(25),
              height: dip(25),
            ),
          ),
        ),
        Center(
          child: Image.memory(
            base64Decode(base64String!),
            fit: BoxFit.cover,
          ),
        ),
      ],
    )
        : const SizedBox.shrink();
  }

  _navigateToDashboard() {
    navigatorKey.currentState?.pushReplacementNamed(MainView.routeName);
  }
}

class _QRCode extends StatelessWidget {
  const _QRCode({
    required this.upi,
    required this.navigatorKey,
    super.key,
  });

  final Upi? upi;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = appTypography.themeTextStyle;
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: dip(45), horizontal: dip(10)),
      color: appColors.tutu,
      child: Container(
        color: appColors.white,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: dip(35), bottom: dip(37)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${l10n.app.hello_text}, ',
                            style: themeTextStyle.secondaryFontWeight800Style(
                              color: appColors.primaryColor,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            upi?.customerName ?? '',
                            style: themeTextStyle.secondaryFontWeight800Style(
                              color: appColors.mulberryWood,
                              fontSize: 35,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: dip(45)),
                            child: Text(
                              l10n.app.your_qr_code,
                              style: themeTextStyle.primaryFontWeight400Style(
                                  color: appColors.primaryTextColor,
                                  fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: dip(10),
                            ),
                            child: QrImageView(
                              data: upi?.base64qrcode ?? '',
                              version: 40,
                              size: dip(225),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PrimaryButton(
                      onPressed: () {
                        _navigateToDashboard();
                      },
                      title: l10n.app.go_to_dashboard,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: dip(20),
              right: dip(20),
              child: GestureDetector(
                onTap: () {
                  _navigateToDashboard();
                },
                child: SvgPicture.asset(
                  appImages.close,
                  width: dip(25),
                  height: dip(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _navigateToDashboard() {
    navigatorKey.currentState?.pushReplacementNamed(MainView.routeName);
  }
}
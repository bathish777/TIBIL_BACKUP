import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_screenshot/no_screenshot.dart'; // Import the package
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/data/data.dart';

class MyQrCodeView extends StatefulWidget {
  const MyQrCodeView({super.key});

  @override
  _MyQrCodeViewState createState() => _MyQrCodeViewState();
}

class _MyQrCodeViewState extends State<MyQrCodeView> {
  final NoScreenshot _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    _enableScreenshots();
  }

  @override
  void dispose() {
    _disableScreenshots();
    super.dispose();
  }

  Future<void> _enableScreenshots() async {
    await _noScreenshot.screenshotOn();
  }

  Future<void> _disableScreenshots() async {
    await _noScreenshot.screenshotOff();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final Upi? upi =
        (context.read<AuthenticationBloc>().state as AuthenticationSuccess).upi;

    return BaseContainer(
      title: l10n.app.my_qr_code_text,
      child: _QRCodeImage(
        base64String: upi?.base64qrcode,
      ),
    );
  }
}

class _QRCodeImage extends StatelessWidget {
  const _QRCodeImage({required this.base64String});

  final String? base64String;

  @override
  Widget build(BuildContext context) {
    return base64String != null
        ? Stack(
      children: [
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
}
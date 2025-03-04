import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/startup/startup_cubit.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/app_view.dart';
import 'package:sound_box/src/widgets/sound_box_splash.dart';

import 'package:sound_box/src/config/config.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeManager.buildThemeData(ThemeAppearanceType.light),
      home: const Scaffold(
        body: SafeArea(
          child: _SoundBoxSplashSetup(),
        ),
      ),
    );
  }
}

class _SoundBoxSplashSetup extends StatefulWidget {
  const _SoundBoxSplashSetup({super.key});

  @override
  State<_SoundBoxSplashSetup> createState() => _SoundBoxSplashSetupState();
}

class _SoundBoxSplashSetupState extends State<_SoundBoxSplashSetup> {
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    ThemeManager.setupTypography(Config.defaultDip);

    return BlocListener<StartupCubit, StartupState>(

      listener: (context, state) {
        if (state.hasErrors && !_isDialogShowing) {
          _showErrorDialog(context, state.errors.last);
        }
      },
      child: const SoundBoxSplash(),
    );
  }

  void _showErrorDialog(BuildContext context, String errorCode) {
    setState(() {
      _isDialogShowing = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Error',
              style:
                  widget.appTypography.themeTextStyle.primaryFontWeight700Style(
                color: widget.appColors.primaryTextColor,
                fontSize: 18,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: IntrinsicHeight(
            child: Center(
              child: Text(
                'Unable to reach Server',
                style: widget.appTypography.themeTextStyle.primaryFontWeight400Style(
                  color: widget.appColors.primaryTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isDialogShowing = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {
        _isDialogShowing = false;
      });
    });
  }
}

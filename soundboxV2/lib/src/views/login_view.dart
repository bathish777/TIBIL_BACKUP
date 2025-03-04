import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:sound_box/src/data/exceptions/user_credential_exception.dart';
import 'package:sound_box/src/data/repositories/login_local_source.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/notification_service/app_notification.dart';
import 'package:sound_box/src/views/dialog_views/mobile_number_error_view.dart';
import 'package:sound_box/src/views/dialog_views/mpin_confirmation_view.dart';
import 'package:sound_box/src/widgets/app_view.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';
import 'package:sound_box/src/widgets/pin_text_field.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/widgets/title_container.dart';
import 'package:sound_box/src/widgets/primary_button.dart';

import '../config/config.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return AppView(
      child: _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController _pinController = TextEditingController();

  final LoginLocalSource _localSource = LoginLocalSource();

  int _maxAttempts = Config.loginFailureCycleMaxAttemptCount;
  int _duration = Config.loginFailureCycleTimeInSeconds;

  bool isTimerInProgress = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initializeTimerAndLastAttemptCount();
    });

    // Check sim change
    context.read<AuthenticationBloc>().add(AuthenticationCheckSimChange());
  }

  Future<void> _initializeTimerAndLastAttemptCount() async {
    final lastEndTime = await _localSource.getLastEndTime();
    final lastAttemptCount = await _localSource.getLastAttemptCount();

    if (lastEndTime != null ||
        (lastAttemptCount != null && lastAttemptCount != 0)) {
      BlocProvider.of<AuthenticationBloc>(context)
          .add(AuthenticationLoginLastAttemptFailure());
    }

    if (lastEndTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final timeRemaining = (lastEndTime - currentTime) ~/ 1000;
      if (timeRemaining > 0) {
        _duration = timeRemaining;
        _maxAttempts = 0;
        startTimer();
      } else {
        _localSource.clearBox();
        _maxAttempts = Config.loginFailureCycleMaxAttemptCount;
        isTimerInProgress = false;
      }
    } else if (lastAttemptCount != null &&
        lastAttemptCount < 3 &&
        lastAttemptCount != 0) {
      setState(() {
        _maxAttempts = lastAttemptCount;
      });
    }
  }

  void startTimer() async {
    setTimerInProgress();
    final endTimeValue =
        DateTime.now().millisecondsSinceEpoch + (_duration * 1000);
    await _localSource.saveLastEndTime(endTimeValue);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_duration == 0) {
        _timer.cancel();
        setState(() {
          _maxAttempts = Config.loginFailureCycleMaxAttemptCount;
          isTimerInProgress = false;
        });
        await _localSource.clearBox();
      } else {
        _duration--;
        setTimerInProgress();
      }
    });
  }

  setTimerInProgress() {
    setState(() {
      isTimerInProgress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = widget.appTypography.themeTextStyle;

    final l10n = L10n.of(context);

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (_, AuthenticationState state) async {
        if (state is AuthenticationLoginFailure &&
            state.type == UserCredentialExceptionType.invalidMPin) {
          _pinController.clear();

          if (_maxAttempts > 0) {
            _maxAttempts--;
            await _localSource.saveLastAttemptCount(_maxAttempts);
          }

          if (!isTimerInProgress && _maxAttempts <= 0) {
            _duration = Config.loginFailureCycleTimeInSeconds;
            startTimer();
          }
        }

        if (state is AuthenticationSuccess) {
          _localSource.clearBox();
        }
      },
      child: Column(
        children: [
          TitleContainer(title: l10n.app.enter_mpin),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  top: widget.dip(20),
                  left: widget.dip(23),
                  right: widget.dip(23),
                  bottom: widget.dip(38)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.app.enter_no_of_pin(4),
                          style: themeTextStyle.primaryFontWeight400Style(
                              color: widget.appColors.primaryTextColor,
                              fontSize: 14),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: widget.dip(20)),
                          child: PinTextField(
                            obscureEnabled: true,
                            controller: _pinController,
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                          if ((state is AuthenticationLoginFailure &&
                                  state.type ==
                                      UserCredentialExceptionType
                                          .invalidMPin) ||
                              state
                                  is AuthenticationLoginLastAttemptFailureState) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: widget.dip(10),
                              ),
                              child: Text(
                                textAlign: TextAlign.center,
                                isTimerInProgress
                                    ? l10n.app.try_again_after_minutes_text
                                    : l10n.app.invalid_mpin_text(_maxAttempts),
                                style: themeTextStyle.primaryFontWeight400Style(
                                  color: widget.appColors.invalidErrorTextColor,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        Padding(
                          padding: EdgeInsets.only(
                            top: widget.dip(25),
                          ),
                          child: InkWell(
                            onTap: () {
                              _localSource.clearBox();

                              AppDialogBox.show(
                                context,
                                const MPinConfirmationView(),
                              );
                            },
                            child: Text(
                              l10n.app.forgot_mpin_text,
                              style: themeTextStyle
                                  .primaryFontWeight700Style(
                                    color: widget.appColors.primaryColor,
                                    fontSize: 14,
                                  )
                                  .copyWith(
                                    decorationColor:
                                        widget.appColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  PrimaryButton(
                    enabled: !isTimerInProgress && isValid,
                    title: l10n.app.login_text,
                    onPressed: () => _doValidateAndLogin(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool get isValid =>
      _pinController.text.isNotEmpty && _pinController.text.length == 4;

  _doValidateAndLogin() {
    final enteredMpin = _pinController.text;

    if (enteredMpin.isNotEmpty && enteredMpin.length == 4) {
      BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationVerifyUserCredentialEvent(enteredMpin),
      );
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import 'package:sound_box/src/config/config.dart';
import 'package:sound_box/src/localization/l10n.dart';

import '../../data/exceptions/error_codes.dart';
import '../../widgets/dialog_box.dart';
import '../dialog_views/app_exit_confirmation_view.dart';
import '../dialog_views/error_dialog.dart';

part 'verify_otp_form_view.dart';

part 'verify_otp_loading_wrapper.dart';

class VerifyOtpView extends StatelessWidget {
  VerifyOtpView({
    required this.navigatorKey,
    required this.routeObserver,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final RouteObserver<ModalRoute<void>> routeObserver;

  static const routeName = '/verify_otp';

  final GlobalKey<_VerifyOTPLoadingWrapperState> _verifyLoadingWrapperKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppView(
      canPop: false,
      willPopCallback: (_) {
        print('ON POP UP OTP');

        final authBloc =
            navigatorKey.currentState?.context.read<AuthenticationBloc>();

        final currentState = authBloc?.state;

        print(currentState);

        if ((currentState is AuthenticationOtpInvalid ||
            currentState is AuthenticationOtpInitial)) {
          bool? isResetMode;

          if (currentState is AuthenticationOtpInitial) {
            isResetMode = currentState.isResetMode;
          } else {
            isResetMode =
                (currentState as AuthenticationOtpInvalid).isResetMode;
          }

          if (isResetMode != null && isResetMode == true) {
            print('Is Reset Mode $isResetMode');



            _verifyLoadingWrapperKey.currentState
                ?.showAppExitConfirmation();
          } else if (isResetMode == null) {
            authBloc?.add(AuthenticationGetBackToVAPEvent());
          }
        }
      },
      child: _VerifyOTPLoadingWrapper(
        key: _verifyLoadingWrapperKey,
        navigatorKey: navigatorKey,
        routeObserver: routeObserver,
      ),
    );
  }
}

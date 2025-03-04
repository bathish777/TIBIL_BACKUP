import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';

import '../config/config.dart';

class InactiveTimeout extends StatefulWidget {
  const InactiveTimeout({required this.child, super.key});

  final Widget child;

  @override
  State<InactiveTimeout> createState() => _InactiveTimeoutState();
}

class _InactiveTimeoutState extends State<InactiveTimeout> {
  final sessionConfig = SessionConfig(
    // App is in background more than 5 minute.
    invalidateSessionForAppLostFocus: Duration(
      minutes: Config.appBackgroundInactiveTimeoutMinutes,
    ),
    // App is in foreground, no user interaction more than 3 minutes.
    invalidateSessionForUserInactivity: Duration(
      minutes: Config.appForegroundInactiveTimeoutMinutes,
    ),
  );

  @override
  void initState() {
    super.initState();
    sessionConfig.stream.listen(
      (event) {
        if (event == SessionTimeoutState.userInactivityTimeout ||
            event == SessionTimeoutState.appFocusTimeout) {

          context
              .read<AuthenticationBloc>()
              .add(AuthenticationCheckUserCredentialEvent());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: widget.child,
    );
  }
}

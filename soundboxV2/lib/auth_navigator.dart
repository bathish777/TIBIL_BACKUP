import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/data/data.dart';
import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/views/login_view.dart';
import 'package:sound_box/src/views/views.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({
    required this.navigatorKey,
    required this.child,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) async {
        if (state is AuthenticationUserCredentialInitial) {
          if (state.userCredential != null) {
            // If there is Register user credential data in local
            // It consider as the user already registered and navigate to mpin Login view.
            _navigateToRootAndPush( LoginView.routeName);
          } else {
            _navigateToRootAndPush( SignInView.routeName);
          }
        } else if (state is AuthenticationOtpInitial) {
          _navigateToRootAndPush( VerifyOtpView.routeName);
        } else if (state is AuthenticationOtpVerified) {
          _navigateToRootAndPush( CreateMPinView.routeName);
        } else if (state is AuthenticationLoadAccountSuccess) {
          _navigateToRootAndPush( AccountsView.routeName);
        } else if (state is AuthenticationLoadVpaSuccess) {
          _navigateToRootAndPush( VpaListView.routeName);
        } else if (state is AuthenticationSuccess) {
          Preferences? preferences = state.userSecrets?.defaultPreferences;

          if (preferences != null) {
            final voiceLocale =
                await getIt<PreferenceController>().setupSettingWithServerData(
              localeString: preferences.language,
              mute: preferences.mute,
            );
            preferences.voiceLocale = voiceLocale;
          }

          _navigateToRootAndPush(QRCodeView.routeName);
        } else if (state is AuthenticationInitial) {
          context
              .read<AuthenticationBloc>()
              .add(AuthenticationCheckUserCredentialEvent());
        }
      },
      child: child,
    );
  }

  _navigateToRootAndPush(String routeName) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
}

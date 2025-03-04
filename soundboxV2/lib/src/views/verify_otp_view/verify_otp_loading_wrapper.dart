part of 'verify_otp_view.dart';

class _VerifyOTPLoadingWrapper extends StatefulWidget {
  const _VerifyOTPLoadingWrapper({
    required this.navigatorKey,
    required this.routeObserver,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final RouteObserver<ModalRoute<void>> routeObserver;

  @override
  State<_VerifyOTPLoadingWrapper> createState() => _VerifyOTPLoadingWrapperState();
}

class _VerifyOTPLoadingWrapperState extends State<_VerifyOTPLoadingWrapper> {
  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Column(
              children: [
                TitleContainer(title: l10n.app.verification_code),
                Expanded(
                  child: VerifyOTPFormView(
                    navigatorKey: widget.navigatorKey,
                    routeObserver: widget.routeObserver,
                  ),
                )
              ],
            ),
            if (state is AuthenticationOtpVerifyInProgress)
              const LoaderMask(title: 'Please wait we are verifying the OTP')
          ],
        );
      },
    );
  }

  showAppExitConfirmation() {
    AppDialogBox.show(context, const AppExitConfirmationView());
  }
}

part of 'sign_in_view.dart';

class _SignLoadingWrapper extends StatelessWidget {
  const _SignLoadingWrapper({required this.routeObserver});

  final RouteObserver<ModalRoute<void>> routeObserver;

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
                TitleContainer(title: l10n.app.sign_in),
                Expanded(
                  child: _SignInForm(routeObserver: routeObserver),
                )
              ],
            ),
            // Overlay and loading view
            if (state is AuthenticationRequestMobileNumberInProgress ||
                state is AuthenticationLoadAccountInProgress ||
                state is AuthenticationLoadVpaInProgress)
              LoaderMask(title: l10n.app.wait_for_verify_text)
          ],
        );
      },
    );
  }
}

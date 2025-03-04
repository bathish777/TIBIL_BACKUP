import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/dialog_views/mpin_exit_view.dart';
import 'package:sound_box/src/views/verify_mpin_view.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/localization/l10n.dart';

class CreateMPinView extends StatefulWidget {
  const CreateMPinView({
    required this.navigatorKey,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  static const routeName = '/enter_mpin';

  @override
  State<CreateMPinView> createState() => _CreateMPinViewState();
}

class _CreateMPinViewState extends State<CreateMPinView> {
  final GlobalKey<_MPinViewState> _mpinView = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppView(
      canPop: false,
      willPopCallback: (value) {
        final authBloc = widget.navigatorKey.currentState?.context
            .read<AuthenticationBloc>();

        final state = authBloc?.state;

        if (state is AuthenticationOtpVerified) {
          if (state.isResetMode != null && state.isResetMode == true) {
            _mpinView.currentState?.showExitDialog();
          } else if (state.isResetMode == null) {
            authBloc?.add(AuthenticationGetBackToVAPEvent());
          }
        }
      },
      child: _MPinView(
        key: _mpinView,
        navigatorKey: widget.navigatorKey,
      ),
    );
  }

}

class _MPinView extends StatefulWidget {
  const _MPinView({super.key, required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<_MPinView> createState() => _MPinViewState();
}

class _MPinViewState extends State<_MPinView> {
  final TextEditingController _pinController = TextEditingController();

  bool emptyInput = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = widget.appTypography.themeTextStyle;

    final l10n = L10n.of(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Column(
          children: [
            TitleContainer(title: l10n.app.create_mpin_text),
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
                        ],
                      ),
                    ),
                    PrimaryButton(
                      showLoader: state is AuthenticationLoadVpaInProgress,
                      enabled: isValid,
                      title: l10n.app.next,
                      onPressed: () {
                        _doValidateAndVerifyMpin();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }

  showExitDialog() {
    AppDialogBox.show(context, const MPinExitView());
  }

  bool get isValid =>
      _pinController.text.isNotEmpty && _pinController.text.length == 4;

  void _doValidateAndVerifyMpin() {
    if (isValid) {
      widget.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => VerifyMPinView(
            mpin: _pinController.text,
            navigatorKey: widget.navigatorKey,
          ),
        ),
      );
    }
  }
}

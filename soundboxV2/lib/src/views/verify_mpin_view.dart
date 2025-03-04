import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import 'package:sound_box/src/localization/l10n.dart';

import '../data/exceptions/unexpected_server_response_exception.dart';
import 'dialog_views/error_dialog.dart';

class VerifyMPinView extends StatefulWidget {
  const VerifyMPinView({
    super.key,
    required this.mpin,
    this.navigatorKey,
  });

  final String mpin;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<VerifyMPinView> createState() => _VerifyMPinViewState();
}

class _VerifyMPinViewState extends State<VerifyMPinView> {
  final TextEditingController _pinController = TextEditingController();

  bool _firstPressed = false;

  bool _validMpin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = widget.appTypography.themeTextStyle;
    final l10n = L10n.of(context);

    return AppView(
      canPop: true,
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if(state is AuthenticationUserCredentialRegisterFailure) {
            _handleErrorState(state);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              TitleContainer(title: l10n.app.verify_mpin),
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
                              l10n.app.re_enter_no_of_pin(4),
                              style: themeTextStyle.primaryFontWeight400Style(
                                  color: widget.appColors.primaryTextColor,
                                  fontSize: 14),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: widget.dip(20)),
                              child: PinTextField(
                                onChanged: (value) {
                                  setState(() {
                                    if (_firstPressed) {
                                      _validMpin = checkMpin;
                                    }
                                  });
                                },
                                obscureEnabled: true,
                                controller: _pinController,
                              ),
                            ),
                            if (!_validMpin)
                              Padding(
                                padding: EdgeInsets.only(top: widget.dip(20)),
                                child: Text(
                                  l10n.app.mpin_not_match,
                                  style: themeTextStyle.primaryFontWeight400Style(
                                    color: widget.appColors.invalidErrorTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      PrimaryButton(
                        showLoader: showLoadingMask(state),
                        enabled: isPinTextNotEmpty,
                        title: l10n.app.next,
                        onPressed: () => _doValidationAndAuthenticate(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }
      ),
    );
  }

  _handleErrorState(state) {
    ErrorDialog.show(
      context: context,
      errorText: UnexpectedServerResponseException.getErrorMsg(
        L10n.of(context),
        state.errorCode,
      ),
    );
  }

  showLoadingMask(state) =>
      state is AuthenticationUserCredentialRegisterInProgress;

  bool get checkMpin => isPinTextNotEmpty && _pinController.text == widget.mpin;

  bool get isPinTextNotEmpty =>
      _pinController.text.isNotEmpty && _pinController.text.length == 4;

  _doValidationAndAuthenticate() {
    if (!_firstPressed) {
      _firstPressed = true;
    }

    if (checkMpin) {
      setState(() {
        _validMpin = true;
      });

      context
          .read<AuthenticationBloc>()
          .add(AuthenticationRegisterUserCredentialEvent(_pinController.text));
    } else {
      setState(() {
        _validMpin = false;
      });
    }
  }
}

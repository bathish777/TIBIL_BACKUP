import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/config/device_config.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/localization/l10n.dart';

import '../data/data.dart';
import '../data/exceptions/error_codes.dart';
import '../data/exceptions/unexpected_server_response_exception.dart';
import '../widgets/dialog_box.dart';
import 'dialog_views/error_dialog.dart';
import 'dialog_views/mobile_number_error_view.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  static const routeName = '/accounts';

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppView(
      // On Click of back button - navigate to sign up view
      willPopCallback: (_) => context
          .read<AuthenticationBloc>()
          .add(AuthenticationCheckUserCredentialEvent()),
      child: const _AccountViewWrapper(),
    );
  }
}

class _AccountViewWrapper extends StatefulWidget {
  const _AccountViewWrapper({super.key});

  @override
  State<_AccountViewWrapper> createState() => _AccountViewWrapperState();
}

class _AccountViewWrapperState extends State<_AccountViewWrapper> {
  Account? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      children: [
        TitleContainer(
          title: l10n.app.select_account_text,
          titleSize: 28,
        ),
        Expanded(
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
            _handleErrorState(state);
          }, builder: (context, state) {
            List<Account>? accounts =
                state is AuthenticationLoadAccountSuccess ? state.accounts : [];

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.dip(20),
                vertical: widget.dip(25),
              ),
              child: Column(
                children: [
                  Expanded(
                      child: AccountList(
                    accounts: accounts,
                    onSelected: (Account account) {
                      setState(() {
                        _selectedAccount = account;
                      });
                    },
                  )),
                  Padding(
                    padding: EdgeInsets.only(top: widget.dip(50)),
                    child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                      return PrimaryButton(
                        showLoader: state is AuthenticationLoadVpaInProgress,
                        enabled: _selectedAccount != null,
                        title: l10n.app.next,
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationLoadVpaEvent(_selectedAccount!),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }

  _handleErrorState(state) {
    // Handling View Specific Errors, Right Redirect to the app level Error handler
    if (state is AuthenticationLoadAccountFailure) {
      _showErrorDialog(state);
    } else if (state is AuthenticationLoadVpaFailure) {
      _showErrorDialog(
        state,
        closeEvent: !(state.errorCode == ErrorCodes.noUpisFound ||
            state.errorCode == ErrorCodes.maxAttemptedToRequestOtp),
      );
    } else if (state is AuthenticationUnRegisteredMobileNumberError) {
      AppDialogBox.show(
        barrierDismissible: true,
        context,
        const MobileNumberErrorView(
          errorType: MobileNumberErrorType.unRegisterNumberError,
        ),
      );
    }
  }

  _showErrorDialog(state, {closeEvent = true}) {
    ErrorDialog.show(
      closeEvent: closeEvent,
      context: context,
      errorText: UnexpectedServerResponseException.getErrorMsg(
        L10n.of(context),
        state.errorCode,
      ),
    );
  }
}

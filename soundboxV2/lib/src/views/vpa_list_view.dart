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
import 'dialog_views/error_dialog.dart';

class VpaListView extends StatefulWidget {
  const VpaListView({super.key});

  static const routeName = '/vpa';

  @override
  State<VpaListView> createState() => _VpaListViewState();
}

class _VpaListViewState extends State<VpaListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AppView(
      willPopCallback: (value) {
        BlocProvider.of<AuthenticationBloc>(context)
            .add(AuthenticationGetBackToAccountEvent());
      },
      child: Column(
        children: [
          TitleContainer(
            title: l10n.app.vpa_list_title_text,
            titleSize: 28,
          ),
          const Expanded(
            child: _VpaListViewWrapper(),
          )
        ],
      ),
    );
  }
}

class _VpaListViewWrapper extends StatefulWidget {
  const _VpaListViewWrapper({super.key});

  @override
  State<_VpaListViewWrapper> createState() => _VpaListViewWrapperState();
}

class _VpaListViewWrapperState extends State<_VpaListViewWrapper> {
  Upi? _selectedUpi;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
      _handleErrorState(state);
    }, builder: (context, state) {
      List<Upi>? upis = state is AuthenticationLoadVpaSuccess ? state.upis : [];

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.dip(20),
          vertical: widget.dip(25),
        ),
        child: Column(
          children: [
            Expanded(
                child: VpaList(
              upis: upis,
              onSelected: (Upi upi) {
                setState(() {
                  _selectedUpi = upi;
                });
              },
            )),
            Padding(
              padding: EdgeInsets.only(top: widget.dip(50)),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                return PrimaryButton(
                  showLoader: showLoader(state),
                  enabled: _selectedUpi != null,
                  title: l10n.app.next,
                  onPressed: () {
                    // To be updated
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      AuthenticationSelectedVpaEvent(
                        _selectedUpi!,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  showLoader(state) =>
      state is AuthenticationSendVpaAndRequestOtpInProgress ||
      state is AuthenticationLoadAccountInProgress;

  _handleErrorState(state) {
    if (state is AuthenticationSendVpaAndRequestOtpFailure ||
        state is AuthenticationLoadVpaFailure) {
      _showErrorDialog(state);
    }
  }

  _showErrorDialog(state) {
    ErrorDialog.show(
      closeEvent: !(state.errorCode == ErrorCodes.maxAttemptedToRequestOtp),
      context: context,
      errorText: UnexpectedServerResponseException.getErrorMsg(
        L10n.of(context),
        state.errorCode,
      ),
    );
  }
}

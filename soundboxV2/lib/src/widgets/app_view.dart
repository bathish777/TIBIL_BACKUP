import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';

import '../data/exceptions/unexpected_server_response_exception.dart';
import '../domain/bloc/authentication/authentication_bloc.dart';
import '../localization/l10n.dart';
import '../views/dialog_views/error_dialog.dart';

class AppView extends StatefulWidget {
  const AppView({
    required this.child,
    this.willPopCallback,
    this.onInit,
    this.onDispose,
    this.resizeToAvoidBottomInset,
    this.canPop = false,
    this.contextPopCallback,
    super.key,
  });

  final Widget child;
  final PopInvokedCallback? willPopCallback;
  final VoidCallback? onInit;
  final VoidCallback? onDispose;
  final bool? resizeToAvoidBottomInset;
  final bool canPop;

  final void Function()? contextPopCallback;

  @override
  State<StatefulWidget> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> with WidgetsBindingObserver {
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.onInit != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onInit!();
        setState(() {
          initialized = true;
        });
      });
    } else {
      initialized = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.contextPopCallback != null) {
      widget.contextPopCallback!();
    }
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return Container();
    }

    return PopScope(
      canPop: widget.canPop,
      onPopInvoked: widget.willPopCallback,
      child: Scaffold(
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        body: AppLevelErrorHandler(
          child: SafeArea(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class AppLevelErrorHandler extends StatelessWidget {
  const AppLevelErrorHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationUnexpectedFailure) {
          print('Called App Level Error Dialog');
          showErrorDialog(state, context);
        }
      },
      child: child,
    );
  }

  showErrorDialog(state, context) {
    ErrorDialog.show(
      context: context,
      errorText: UnexpectedServerResponseException.getErrorMsg(
        L10n.of(context),
        state.errorCode,
      ),
    );
  }
}

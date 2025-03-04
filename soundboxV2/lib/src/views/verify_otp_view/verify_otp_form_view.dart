part of 'verify_otp_view.dart';

class VerifyOTPFormView extends StatefulWidget {
  const VerifyOTPFormView({
    required this.navigatorKey,
    required this.routeObserver,
    super.key,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final RouteObserver<ModalRoute<void>> routeObserver;

  @override
  State<VerifyOTPFormView> createState() => _VerifyOTPFormViewState();
}

class _VerifyOTPFormViewState extends State<VerifyOTPFormView> with RouteAware {
  late Timer _timer;
  int _start = Config.defaultOtpTimerSeconds;
  bool _isResendAllowed = false;

  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _pinController.clear();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _isResendAllowed = false;
    });
    _start = Config.defaultOtpTimerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendAllowed = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = widget.appTypography.themeTextStyle;

    final l10n = L10n.of(context);
    final appColors = widget.appColors;

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationOtpInvalid) {
          _pinController.clear();
          _start = 0;
        } else if (state is AuthenticationOtpFailure) {
          _handleErrorState(state);
        }
      },
      builder: (context, state) {
        Text resendOtpOrInvalidText;

        resendOtpOrInvalidText = (state is AuthenticationOtpInvalid)
            ? Text(
          l10n.app.otp_invalid_text,
          style: themeTextStyle.primaryFontWeight400Style(
              color: appColors.errorTextColor, fontSize: 12),
        )
            : Text(
          '${l10n.app.resend_otp_in} $timerText',
          style: themeTextStyle.primaryFontWeight400Style(
              color: appColors.silver, fontSize: 14),
        );

        return Padding(
          padding: EdgeInsets.only(
              top: widget.dip(20),
              left: widget.dip(23),
              right: widget.dip(23),
              bottom: widget.dip(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.app.enter_otp,
                      style: themeTextStyle.primaryFontWeight400Style(
                          color: widget.appColors.primaryTextColor,
                          fontSize: 14),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: widget.dip(15)),
                      child: PinTextField(
                        length: Config.otpNumberCount,
                        width: 40,
                        height: 40,
                        controller: _pinController,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: widget.dip(15)),
                      child: resendOtpOrInvalidText,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: widget.dip(10)),
                      child: GestureDetector(
                        onTap: () {
                          if (_isResendAllowed) {
                            context.read<AuthenticationBloc>().add(
                              AuthenticationRequestOtpEvent(),
                            );

                            startTimer();

                            _pinController.clear();
                          }
                        },
                        child: Text(
                          l10n.app.resend_otp,
                          style: themeTextStyle
                              .primaryFontWeight700Style(
                              color: _isResendAllowed
                                  ? appColors.primaryColor
                                  : appColors.silver,
                              fontSize: 14)
                              .copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: _isResendAllowed
                                ? appColors.primaryColor
                                : appColors.silver,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              PrimaryButton(
                showLoader: showLoadingMask(state),
                enabled: isValid,
                title: l10n.app.next,
                onPressed: () => _doValidationAndVerifyOtp(state),
              )
            ],
          ),
        );
      },
    );
  }

  showLoadingMask(state) =>
      state is AuthenticationLoadVpaInProgress;

  _handleErrorState(state) {
    ErrorDialog.show(
      closeEvent: !(state.errorCode == ErrorCodes.maxAttemptedToRequestOtp),
      context: context,
      errorText: UnexpectedServerResponseException.getErrorMsg(
        L10n.of(context),
        state.errorCode,
      ),
    );
  }

  bool get isValid =>
      _pinController.text.isNotEmpty &&
          _pinController.text.length == Config.otpNumberCount;

  _doValidationAndVerifyOtp(state) {
    print(state);

    if (state is AuthenticationOtpInitial ||
        state is AuthenticationOtpInvalid) {
      if (isValid) {
        print('Verify');

        BlocProvider.of<AuthenticationBloc>(context).add(
          AuthenticationVerifyOtpEvent(
            _pinController.text,
            state.identificationCode,
          ),
        );
      }
    }
  }
}

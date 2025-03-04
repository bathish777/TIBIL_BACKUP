part of 'sign_in_view.dart';

class _SignInForm extends StatefulWidget {
  const _SignInForm({required this.routeObserver});

  final RouteObserver<ModalRoute<void>> routeObserver;

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> with RouteAware {
  late bool _isTermsChecked = false;

  List<SimLocalData> simListData = [];

  bool isError = false;

  SimLocalData? _selectedSimData;

  @override
  void initState() {
    super.initState();
    simListData = DeviceConfig.simListData;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeTextStyle = widget.appTypography.themeTextStyle;
    final l10n = L10n.of(context);

    if (DeviceConfig.simListData.isEmpty) {
      _selectedSimData = null;
    }

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (_, state) async {
        _handleErrorState(state);
      },
      builder: (_, authState) {
        return Padding(
          padding: EdgeInsets.only(
            top: widget.dip(50),
            left: widget.dip(23),
            right: widget.dip(23),
            bottom: widget.dip(38),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: widget.dip(315),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: SimList(
                        onSelected: (data) {
                          setState(() {
                            _selectedSimData = data;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: widget.dip(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: widget.dip(18),
                            height: widget.dip(18),
                            child: PrimaryCheckBox(
                              value: _isTermsChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isTermsChecked = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: widget.dip(1),
                                left: widget.dip(5),
                              ),
                              child: Text.rich(
                                softWrap: true,
                                maxLines: 2,
                                TextSpan(
                                  text: '${l10n.app.agree_with} ',
                                  style:
                                      themeTextStyle.primaryFontWeight400Style(
                                    color: widget.appColors.friarGray,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          showTermAndCondition();
                                        },
                                      text: l10n.app.term_condition,
                                      style: themeTextStyle
                                          .primaryFontWeight400Style(
                                            color: widget.appColors.friarGray,
                                            fontSize: 14,
                                          )
                                          .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                widget.appColors.friarGray,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              PrimaryButton(
                enabled: (_selectedSimData != null && _isTermsChecked),
                title: l10n.app.next,
                onPressed: () async {
                  context.read<AuthenticationBloc>().add(
                        AuthenticationRequestMobileNumberEvent(
                          _selectedSimData!,
                        ),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _handleErrorState(AuthenticationState state) {
    print(state);

    // Handling View Specific Errors, Right Redirect to the app level Error handler
    if (state is AuthenticationRequestMobileNumberFailure ||
        state is AuthenticationLoadAccountFailure) {
      showErrorDialog(state);
    } else if (state is AuthenticationLoadVpaFailure) {
      showErrorDialog(
        state,
        closeEvent: !(state.errorCode == ErrorCodes.noUpisFound),
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

  showErrorDialog(state, {closeEvent = true}) {
    ErrorDialog.show(
      closeEvent: closeEvent,
      context: context,
      errorText: UnexpectedServerResponseException.getErrorMsg(
        L10n.of(context),
        state.errorCode,
      ),
    );
  }

  showTermAndCondition() {
    AppDialogBox.show(
      context,
      const TermsAndConditionsView(),
      willPop: true,
      closeButtonPosition: CloseButtonPosition(widget.dip(27), widget.dip(21)),
      closeButtonSize: Size(widget.dip(15), widget.dip(15)),
    );
  }
}

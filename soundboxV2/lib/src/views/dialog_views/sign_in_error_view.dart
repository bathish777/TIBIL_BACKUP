import 'package:flutter/material.dart';

import 'mobile_number_error_view.dart';

class SignInErrorView extends StatelessWidget {
  const SignInErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MobileNumberErrorView(
      errorType: MobileNumberErrorType.unRegisterNumberError,
    );
  }
}

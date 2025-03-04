import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/data/exceptions/unexpected_server_response_exception.dart';
import 'package:sound_box/src/data/models/models.dart';

import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/views/dialog_views/error_dialog.dart';
import 'package:sound_box/src/views/dialog_views/mobile_number_error_view.dart';
import 'package:sound_box/src/widgets/app_view.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';
import 'package:sound_box/src/widgets/primary_button.dart';
import 'package:sound_box/src/theme/theme.dart';

import 'package:sound_box/src/widgets/loader_mask.dart';
import 'package:sound_box/src/widgets/primary_check_box.dart';

import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/widgets/title_container.dart';

import 'package:sound_box/src/config/device_config.dart';

import '../../data/exceptions/error_codes.dart';
import '../../domain/navigator_observer/app_navigator_observer.dart';
import '../../widgets/sim_list.dart';
import '../dialog_views/terms_and_conditions_view.dart';

part 'sign_in_form.dart';

part 'sign_loading_wrapper.dart';

class SignInView extends StatelessWidget {
  static const routeName = '/signin';

  const SignInView({super.key, required this.routeObserver});

  final RouteObserver<ModalRoute<void>> routeObserver;

  @override
  Widget build(BuildContext context) {
    return AppView(
      canPop: true,
      child: _SignLoadingWrapper(routeObserver: routeObserver),
    );
  }
}

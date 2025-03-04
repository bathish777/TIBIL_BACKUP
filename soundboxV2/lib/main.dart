import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/src/data/exceptions/global_error_handler_exception.dart';
import 'package:sound_box/src/domain/bloc/authentication/authentication_bloc.dart';
import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/startup/startup_cubit.dart';
import 'package:sound_box/src/startup/startup_screen.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'src/sound_box.dart';
import 'src/data/data.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize the no_screenshot package
      final NoScreenshot noScreenshot = NoScreenshot.instance;

      // Disable screenshots globally
      await noScreenshot.screenshotOff();

      // Handle all uncaught flutter errors here
      FlutterError.onError = GlobalErrorHandlerException.onFlutterError;

      final StartupCubit startupCubit = StartupCubit();

      runApp(
        BlocProvider<StartupCubit>.value(
          value: startupCubit,
          child: const StartupScreen(),
        ),
      );

      startupCubit.init();
      await startupCubit.stream.firstWhere((state) => state.isReady);

      runApp(
        BlocProvider(
          create: (_) => getIt<AuthenticationBloc>(),
          child: const SoundBox(),
        ),
      );
    },
    (error, stack) async {
      await GlobalErrorHandlerException.onError(error, stack);
    },
  );
}

import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_box/src/config/device_config.dart';
import 'package:sound_box/src/config/message_announce_config.dart';
import 'package:sound_box/src/notification_service/app_notification.dart';
import 'package:sound_box/src/notification_service/message_announcement.dart';
import 'package:mobile_number/mobile_number.dart';

import '../config/config_manager.dart';
import '../data/data.dart';
import '../domain/bloc/blocs.dart';

class StartupCubit extends Cubit<StartupState> {
  StartupCubit() : super(const StartupState());

  void init() async {
    emit(state.withMessage('Warming up...'));
    await Future.delayed(const Duration(seconds: 3));

    emit(state.withMessage('configuring service locator'));
    try {
      configureDependencies();
    } on Error catch (e) {
      emit(state.withError(
        'Failed to configure service locator:\n$e\n${e.stackTrace}',
      ));
    } catch (e) {
      emit(state.withError('Failed to configure service locator:\n$e'));
    }

    emit(state.withMessage('Get Device and Sim configuration information'));
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Store Device id
      DeviceConfig.id = androidInfo.id;

      var status = await [Permission.phone, Permission.sms].request();

      if (!(status[Permission.phone]!.isGranted &&
          status[Permission.sms]!.isGranted)) {
        emit(state.withError(
          'Failed to get Device and Sim configuration information',
        ));
      }
    } on Error catch (e) {
      emit(state.withError(
        'Failed to get Device and Sim configuration information:\n$e\n${e.stackTrace}',
      ));
    } catch (e) {
      emit(state.withError(
          'Failed to get Device and Sim configuration information:\n$e'));
    }

    emit(state.withMessage('initializing Hive'));
    try {
      await Data.initHive();
    } on Error catch (e) {
      emit(state.withError('Failed to initialize Hive:\n$e\n${e.stackTrace}'));
    } catch (e) {
      emit(state.withError(e.toString()));
    }

    emit(state.withMessage('registering authentication BLoC'));
    try {
      // Initialize Authentication Bloc
      AuthenticationBloc.register();
    } on Error catch (e) {
      emit(state.withError(
        'Failed to register authentication BLoC:\n$e\n${e.stackTrace}',
      ));
    } catch (e) {
      emit(state.withError('Failed to register authentication BLoC:\n$e'));
    }

    emit(state.withMessage('initializing Preferences'));
    try {
      // Set up the PreferenceController, which will glue user settings to multiple
      // Flutter Widgets.
      final preferenceController = getIt<PreferenceController>();

      // Load the user's preferred theme while the splash screen is displayed.
      // This prevents a sudden theme change when the app is first displayed.
      await preferenceController.loadSettings();

      // Run the app and pass in the PreferenceController. The app listens to the
      // PreferenceController for changes, then passes it further down to the
      // SettingsView.
    } catch (e) {
      emit(state.withError(e.toString()));
    }

    /* emit(state.withMessage('initializing Firebase Messaging'));
    try {
      final firebaseCloudMessaging = FirebaseCloudMessaging();
      await firebaseCloudMessaging.initSetup();
      ServerConfig.fcmToken = firebaseCloudMessaging.token;
    } on Error catch (e) {
      emit(state.withError(
          'Failed to initialize Firebase Messaging:\n$e\n${e.stackTrace}'));
    } catch (e) {
      emit(state.withError(e.toString()));
    }*/

    emit(state.withMessage('initializing Flutter Notification'));
    try {
      var status = await [Permission.notification].request();

      if (status[Permission.notification]!.isGranted) {
        final appNotification = getIt<AppNotification>();
        appNotification.initialize();
      } else {
        emit(
          state.withError(
            'Failed to initialize flutter notification',
          ),
        );
      }
    } on Error catch (e) {
      emit(
        state.withError(
          'Failed to initialize flutter notification:\n$e\n${e.stackTrace}',
        ),
      );
    } catch (e) {
      emit(state.withError(e.toString()));
    }

    emit(state.withMessage('Init environment variables'));
    await Future<dynamic>.delayed(const Duration(microseconds: 500));
    try {
      await dotenv.load(fileName: ConfigManager.envFileName);
      ConfigManager().init();
    } catch (e) {
      emit(state.withError('environment variable init Failure:\n$e'));
    }

    emit(state.withMessage('Checking device languages availability'));
    await Future<dynamic>.delayed(const Duration(microseconds: 500));
    try {
      final authenticationRepository = getIt<AuthenticationRepository>();

      final guestTokenConfig =
          await authenticationRepository.getGuestTokenConfig();

      MessageAnnounceConfig.init(
        guestTokenConfig.announcementText!,
        guestTokenConfig.pollIntervalSecs!,
        guestTokenConfig.bgNotificationTimeLimit!,
      );

      await MessageAnnouncement().initSetup();
    } catch (e) {
      emit(state
          .withError('checking device languages availability failure:\n$e'));
    }

    emit(state.finished());

    if (!state.hasErrors) {
      emit(state.ready());
    }
  }
}

class StartupState extends Equatable {
  const StartupState({
    this.messages = const [],
    this.errors = const [],
    this.isFinished = false,
    this.isReady = false,
  });

  StartupState withMessage(String message) => StartupState(
        messages: [...messages, message],
        errors: errors,
        isFinished: isFinished,
        isReady: isReady,
      );

  StartupState withError(String error) => StartupState(
        messages: messages,
        errors: [...errors, error],
        isFinished: isFinished,
        isReady: isReady,
      );

  StartupState finished() => StartupState(
        messages: messages,
        errors: errors,
        isFinished: true,
        isReady: isReady,
      );

  StartupState ready() => StartupState(
        messages: messages,
        errors: errors,
        isFinished: isFinished,
        isReady: true,
      );

  final List<String> messages;
  final List<String> errors;
  final bool isFinished;
  final bool isReady;

  bool get hasErrors => errors.isNotEmpty;

  @override
  List<Object> get props => [messages, errors, isFinished, isReady];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_box/auth_navigator.dart';
import 'package:sound_box/src/data/app_dependency_injection.dart';
import 'package:sound_box/src/domain/navigator_observer/app_navigator_observer.dart';
import 'package:sound_box/src/notification_service/notification_handler.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/login_view.dart';
import 'package:sound_box/src/domain/domain.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/views/views.dart';
import 'package:sound_box/src/widgets/widgets.dart';
import 'package:sound_box/src/sim_binding/sim_change_listener.dart';

class SoundBox extends StatefulWidget {
  const SoundBox({super.key});

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static final AppNavigatorObserver _navigatorObserver = AppNavigatorObserver();
  static final RouteObserver<ModalRoute<void>> _routeObserver = RouteObserver();

  @override
  State<SoundBox> createState() => _SoundBoxState();
}

class _SoundBoxState extends State<SoundBox> with WidgetsBindingObserver {
  SimChangeListener simChangeListener = SimChangeListener();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    simChangeListener.init();
    simChangeListener.simEvents.listen((value) {
      context.read<AuthenticationBloc>().add(AuthenticationCheckSimChange());
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      getIt<NotificationHandler>().stopNotificationHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferenceController preferenceController = getIt<PreferenceController>();

    return InactiveTimeout(
      child: ListenableBuilder(
        listenable: preferenceController,
        builder: (context, child) {
          return AuthNavigator(
            navigatorKey: SoundBox._navigatorKey,
            child: MaterialApp(
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',
              debugShowCheckedModeBanner: false,
              localizationsDelegates: L10n.localizationsDelegates,
              supportedLocales: L10n.supportedLocales,
              locale: preferenceController.locale,
              theme:
                  ThemeManager.buildThemeData(preferenceController.themeMode),
              navigatorObservers: [
                AppDialogNavigatorObserver(),
                SoundBox._navigatorObserver,
                SoundBox._routeObserver
              ],
              navigatorKey: SoundBox._navigatorKey,
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                '/': (_) => const _InitialScreen(),
                LoginView.routeName: (_) => const LoginView(),
                SignInView.routeName: (_) =>
                    SignInView(routeObserver: SoundBox._routeObserver),
                QRCodeView.routeName: (_) =>
                    QRCodeView(navigatorKey: SoundBox._navigatorKey),
                MainView.routeName: (_) => const MainView(),
                VerifyOtpView.routeName: (_) => VerifyOtpView(
                      navigatorKey: SoundBox._navigatorKey,
                      routeObserver: SoundBox._routeObserver,
                    ),
                CreateMPinView.routeName: (_) => CreateMPinView(
                      navigatorKey: SoundBox._navigatorKey,
                    ),
                AccountsView.routeName: (_) => const AccountsView(),
                VpaListView.routeName: (_) => const VpaListView(),
              },
            ),
          );
        },
      ),
    );
  }
}

class _InitialScreen extends StatefulWidget {
  const _InitialScreen();

  @override
  State<_InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<_InitialScreen> {
  @override
  void initState() {
    context
        .read<AuthenticationBloc>()
        .add(AuthenticationCheckUserCredentialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AppView(child: SoundBoxSplash());
  }
}

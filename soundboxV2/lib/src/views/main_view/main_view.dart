import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sound_box/src/domain/bloc/blocs.dart';
import 'package:sound_box/src/localization/l10n.dart';
import 'package:sound_box/src/theme/theme.dart';
import 'package:sound_box/src/views/dialog_views/app_exit_confirmation_view.dart';
import 'package:sound_box/src/views/main_view/tab_view_config.dart';
import 'package:sound_box/src/widgets/dialog_box.dart';
import 'package:sound_box/src/widgets/widgets.dart';

import 'package:sound_box/src/data/app_dependency_injection.dart';
import 'package:sound_box/src/data/repositories/payment_repository.dart';
import 'package:sound_box/src/data/repositories/payment_summary_repository.dart';
import 'settings_view/setting_view.dart';
import 'dashboard_view/dash_board_view.dart';
import 'transaction_view/transaction_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  static const routeName = '/main_view';

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _BackNavigator(),
    );
  }
}

class _BackNavigator extends StatefulWidget {
  const _BackNavigator({super.key});

  @override
  State<_BackNavigator> createState() => _BackNavigatorState();
}

class _BackNavigatorState extends State<_BackNavigator> {

  final GlobalKey<_AppExitViewState> _appExitView = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppView(
      willPopCallback: (_) {

        final state = BlocProvider.of<SettingTabCubit>(context).state
            as SettingActiveTabState;

        if (state.activeTabIndex == TabViewConfig.settingViewIndex &&
            state.tabIndex > TabViewConfig.settingListViewIndex) {
          BlocProvider.of<SettingTabCubit>(context).getBackRootTab();
        } else {
          _appExitView.currentState?.showAppExitConfirmation();
        }
      },
      child: _AppExitView(
        key: _appExitView,
      ),
    );
  }
}

class _AppExitView extends StatefulWidget {
  const _AppExitView({super.key});

  @override
  State<_AppExitView> createState() => _AppExitViewState();
}

class _AppExitViewState extends State<_AppExitView> {
  @override
  Widget build(BuildContext context) {

    final l10n = L10n.of(context);

    final List<Widget> tabViews = [
      const DashBoardView(),
      const TransactionView(),
      const SettingView(),
    ];

    List<TabData> tabs = [
      TabData(
        name: l10n.app.dashboard,
        icon: widget.appImages.dashboard,
      ),
      TabData(
        name: l10n.app.transaction,
        icon: widget.appImages.transaction,
      ),
      TabData(
        name: l10n.app.settings_text,
        icon: widget.appImages.setting,
      ),
    ];

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (_, state) {
        if (state is AuthenticationTokenFailure) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationTokenExpiredFailure(),
          );
        }
      },
      child: Container(
        color: widget.appColors.tutu,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<SettingTabCubit, SettingTabState>(
                builder: (BuildContext context, tabState) {
                  return tabViews[
                  (tabState as SettingActiveTabState).activeTabIndex];
                },
              ),
            ),
            BottomTabBar(tabs: tabs)
          ],
        ),
      ),
    );
  }
  showAppExitConfirmation() {
    AppDialogBox.show(context, const AppExitConfirmationView());
  }
}


class _BlocProvider extends StatelessWidget {
  const _BlocProvider({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingTabCubit()),
        BlocProvider(create: (_) => HeaderTextCubit()),
        BlocProvider(
          create: (_) => PaymentBloc(
            paymentSummaryRepository: getIt<PaymentSummaryRepository>(),
            paymentRepository: getIt<PaymentRepository>(),
          ),
        )
      ],
      child: child,
    );
  }
}

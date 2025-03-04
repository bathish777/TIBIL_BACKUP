import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SettingTabState extends Equatable {
  const SettingTabState();

  @override
  List<Object?> get props => [];
}

class SettingActiveTabState extends SettingTabState {
  const SettingActiveTabState({
    required this.rootTabIndex,
    required this.activeTabIndex,
    required this.tabIndex,
  });

  final int rootTabIndex;
  final int activeTabIndex;
  final int tabIndex;

  @override
  List<Object?> get props => [rootTabIndex, activeTabIndex, tabIndex];
}

class SettingTabCubit extends Cubit<SettingTabState> {
  SettingTabCubit({SettingActiveTabState? initialState})
      : super(initialState ??
            const SettingActiveTabState(
              rootTabIndex: 0,
              activeTabIndex: 0,
              tabIndex: 0,
            ));

  setActiveTabIndex(int activeTabIndex) =>
      emit(SettingActiveTabState(
        rootTabIndex: activeTabIndex,
        activeTabIndex: activeTabIndex,
        tabIndex: 0,
      ));

  setTabIndex(int tabIndex) => emit(SettingActiveTabState(
        rootTabIndex: (state as SettingActiveTabState).activeTabIndex,
        activeTabIndex: (state as SettingActiveTabState).activeTabIndex,
        tabIndex: tabIndex,
      ));

  jumpFromRootTab(int rootTabIndex, int activeTabIndex, int tabIndex) =>
      emit(SettingActiveTabState(
        rootTabIndex: rootTabIndex,
        activeTabIndex: activeTabIndex,
        tabIndex: tabIndex,
      ));

  getBackRootTab() => emit(SettingActiveTabState(
        rootTabIndex: (state as SettingActiveTabState).rootTabIndex,
        activeTabIndex: (state as SettingActiveTabState).rootTabIndex,
        tabIndex: 0,
      ));
}

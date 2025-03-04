// Main view handled by a 2-dimensional tab bar method.
// One for handling the Dashboard, Transaction, and Settings tabs.
// One for handling Setting SubViews: SettingButtonListView, MyProfileView, MyQrCodeView, LanguagePreferenceView.

abstract class TabViewConfig {
  // These indices correspond to the order in which the views are declared in MainView and SettingView.

  static const dashboardViewIndex = 0;
  static const transactionViewIndex = 1;
  static const settingViewIndex = 2;


  static const settingListViewIndex = 0;
  static const myProfileViewIndex = 1;
  static const myQRCodeViewIndex = 2; // The index of MyQrCodeView in the Setting sub views list. Used for jumping to Setting-MyQRCodeView from the Dashboard and Transaction views.
  static const languagePreferenceViewIndex = 3;

}

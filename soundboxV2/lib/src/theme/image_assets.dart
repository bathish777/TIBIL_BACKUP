import 'package:flutter/material.dart';

abstract class ImageAssets {
  static String get pathPrefix => 'assets/images';

  String get shop;
  String get close;
  String get smallQr;
  String get dashboard;
  String get transaction;
  String get setting;
  String get signOut;
  String get share;
  String get loading;
  String get warning;
  AssetImage get dashboardJanaLogo;
  AssetImage get loginJanaLogo;
  AssetImage get startupLogo;
  AssetImage get splashlogo;
}


class DarkImageAssets implements ImageAssets {
  DarkImageAssets() : _pathPrefix = '${ImageAssets.pathPrefix}/dark';
  final String _pathPrefix;

  @override
  String get shop => '$_pathPrefix/shop.svg';

  @override
  String get close => '$_pathPrefix/close.svg';

  @override
  String get smallQr => '$_pathPrefix/smallQr.svg';

  @override
  String get dashboard => '$_pathPrefix/dashboard.svg';

  @override
  String get transaction => '$_pathPrefix/transaction.svg';

  @override
  String get setting => '$_pathPrefix/setting.svg';

  @override
  String get signOut => '$_pathPrefix/sign_out.svg';

  @override
  String get share => '$_pathPrefix/share.svg';

  @override
  String get loading => '$_pathPrefix/loading.svg';

  @override
  String get warning => '$_pathPrefix/warning.svg';

  @override
  AssetImage get dashboardJanaLogo => AssetImage('$_pathPrefix/dashboard_jana_logo.png');

  @override
  AssetImage get loginJanaLogo  => AssetImage('$_pathPrefix/login_jana_logo.png');

  @override
  AssetImage get startupLogo  => AssetImage('$_pathPrefix/startup_logo.png');

  @override
  AssetImage get splashlogo => AssetImage('$_pathPrefix/splash-logo.png');
}

class LightImageAssets implements ImageAssets {
  LightImageAssets() : _pathPrefix = '${ImageAssets.pathPrefix}/light';
  final String _pathPrefix;

  @override
  String get shop => '$_pathPrefix/shop.svg';

  @override
  String get close =>'$_pathPrefix/close.svg';

  @override
  String get smallQr => '$_pathPrefix/smallQr.svg';

  @override
  String get dashboard => '$_pathPrefix/dashboard.svg';

  @override
  String get transaction => '$_pathPrefix/transaction.svg';

  @override
  String get setting => '$_pathPrefix/setting.svg';

  @override
  String get signOut => '$_pathPrefix/sign_out.svg';

  @override
  String get share => '$_pathPrefix/share.svg';

  @override
  String get loading => '$_pathPrefix/loading.svg';

  @override
  String get warning => '$_pathPrefix/warning.svg';

  @override
  AssetImage get dashboardJanaLogo => AssetImage('$_pathPrefix/dashboard_jana_logo.png');

  @override
  AssetImage get loginJanaLogo  => AssetImage('$_pathPrefix/login_jana_logo.png');

  @override
  AssetImage get startupLogo  => AssetImage('$_pathPrefix/startup_logo.png');


  @override
  AssetImage get splashlogo => AssetImage('$_pathPrefix/splash-logo.png');
}
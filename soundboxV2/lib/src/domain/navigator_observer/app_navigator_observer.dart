import 'package:flutter/material.dart';

class AppNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  String? currentRouteName;
  String? previousRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {

    if (route is PageRoute && previousRoute is PageRoute) {
      currentRouteName = route.settings.name;
      previousRouteName = previousRoute.settings.name;
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {

    if (previousRoute is PageRoute) {
      currentRouteName = previousRoute.settings.name;
      previousRouteName = route.settings.name;
    }
    super.didPop(route, previousRoute);
  }
}
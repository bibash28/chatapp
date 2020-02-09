import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToAndBack(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToAndClearAll(String routeTo) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeTo, (Route<dynamic> route) => false);
  }


  static goBack() {
    return navigatorKey.currentState.pop();
  }
}

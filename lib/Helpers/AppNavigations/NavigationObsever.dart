import 'package:flutter/material.dart';

class NavigationObserver extends NavigatorObserver {
  static final NavigationObserver _instance = NavigationObserver._internal();

  factory NavigationObserver() {
    return _instance;
  }

  NavigationObserver._internal();

  // Map to store route names and their corresponding callbacks
  static final Map<String, VoidCallback> _callbacks = {};

  // Method to add a callback for a specific route
  static void addCallback(String routeName, VoidCallback callback) {
    _callbacks[routeName] = callback;
  }

  // Method to remove a callback for a specific route
  static void removeCallback(String routeName) {
    _callbacks.remove(routeName);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print(">${previousRoute?.settings.name}< $route");
    print(_callbacks.entries.toString());
    if (_callbacks.containsKey(previousRoute!.settings.name)) {
      _callbacks[previousRoute.settings.name]?.call();
    }
  }
}

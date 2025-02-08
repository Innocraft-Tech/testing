import 'package:flutter/material.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    ResponsiveUI.baseWidth = 402;
    ResponsiveUI.baseHeight = 874;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute:
          AppRoute(initialPage: Pages.splashScreenConfig, initialPageData: [])
              .onGenerateRoute,
    );
  }
}

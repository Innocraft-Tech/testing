// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: constant_identifier_names, file_names, non_constant_identifier_names, library_private_types_in_public_api
import 'dart:core';

import 'package:flutter/material.dart';
import '../Utilities/Utilities.dart';
import 'package:mobx/mobx.dart';

import 'NavigationConfig.dart';

part 'NavigationHelperMixin.dart';

final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

class PageConfig<T> {
  Routes route;
  dynamic data;
  Widget Function(BuildContext) build;
  BottomNavigationConfig? bottomNavigationConfig;

  PageConfig(
      {required this.route,
      required this.build,
      this.data,
      this.bottomNavigationConfig});
}

class BottomNavigationConfig extends _BottomNavConfigMobxBase
    with _$BottomNavigationConfig {
  BottomNavigationConfig({
    required super.subTabUIConfigs,
    required super.subTabConfigs,
    super.selectedItemColor,
    super.unselectedItemColor,
    super.currentIndex,
    super.onTap,
    super.key,
    super.elevation,
    super.type,
    super.fixedColor,
    super.backgroundColor,
    super.iconSize,
    super.selectedIconTheme,
    super.unselectedIconTheme,
    super.selectedFontSize,
    super.unselectedFontSize,
    super.selectedLabelStyle,
    super.unselectedLabelStyle,
    super.showSelectedLabels,
    super.showUnselectedLabels,
    super.mouseCursor,
    super.enableFeedback,
    super.landscapeLayout,
    super.useLegacyColorScheme,
  });
}

abstract class _BottomNavConfigMobxBase with Store {
  final List<BottomNavigationBarItem> subTabUIConfigs;
  final List<Navigator> subTabConfigs;

  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  @observable
  int currentIndex = 0;

  final PageController pageController = PageController();

  final void Function(int value)? onTap;

  Key? key;
  double? elevation;
  BottomNavigationBarType? type;
  Color? fixedColor;
  Color? backgroundColor;
  double iconSize = 24.0;
  IconThemeData? selectedIconTheme;
  IconThemeData? unselectedIconTheme;
  double selectedFontSize = 14.0;
  double unselectedFontSize = 12.0;
  TextStyle? selectedLabelStyle;
  TextStyle? unselectedLabelStyle;
  bool? showSelectedLabels;
  bool? showUnselectedLabels;
  MouseCursor? mouseCursor;
  bool? enableFeedback;
  BottomNavigationBarLandscapeLayout? landscapeLayout;
  bool useLegacyColorScheme = true;

  BottomNavigationBar generateBottomNavigationConfig() {
    return BottomNavigationBar(
      items: subTabUIConfigs,
      currentIndex: currentIndex,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      onTap: onTap ?? bottomNavOntap,
      backgroundColor: backgroundColor,
      elevation: elevation,
      enableFeedback: enableFeedback,
      fixedColor: fixedColor,
      iconSize: iconSize,
      key: key,
      landscapeLayout: landscapeLayout,
      mouseCursor: mouseCursor,
      selectedFontSize: selectedFontSize,
      selectedIconTheme: selectedIconTheme,
      selectedLabelStyle: selectedLabelStyle,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      type: type,
      unselectedFontSize: unselectedFontSize,
      unselectedIconTheme: unselectedIconTheme,
      unselectedLabelStyle: unselectedLabelStyle,
      useLegacyColorScheme: useLegacyColorScheme,
    );
  }

  void bottomNavOntap(event) {
    if (pageController.hasClients) {
      pageController.jumpToPage(event);
      currentIndex = event;
    }
  }

  _BottomNavConfigMobxBase({
    required this.subTabUIConfigs,
    required this.subTabConfigs,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.currentIndex = 0,
    this.onTap,
    this.key,
    this.elevation,
    this.type,
    this.fixedColor,
    this.backgroundColor,
    this.iconSize = 24.0,
    this.selectedIconTheme,
    this.unselectedIconTheme,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showSelectedLabels,
    this.showUnselectedLabels,
    this.mouseCursor,
    this.enableFeedback,
    this.landscapeLayout,
    this.useLegacyColorScheme = true,
  });
}

class CustomRouteSettings<T> {
  final PageConfig pageConfig;
  final T? data;

  const CustomRouteSettings({required this.pageConfig, this.data});
}

MaterialPageRoute builder<T>(CustomRouteSettings<T> sharedData) {
  sharedData.pageConfig.data = sharedData.data;
  return MaterialPageRoute(
      builder: sharedData.pageConfig.build,
      settings: RouteSettings(name: resolveRoute(sharedData.pageConfig.route)));
}

String resolveRoute<T>(T route) =>
    "/${route.toString().split('.').last.toLowerCase()}";

extension Navigations on BuildContext {
  void push({required PageConfig pageConfig, data, bool checkMounted = false}) {
    debugPrint(resolveRoute(pageConfig.route));
    if (checkMounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          Navigator.pushNamed(this, resolveRoute(pageConfig.route),
              arguments:
                  CustomRouteSettings(pageConfig: pageConfig, data: data));
        }
      });
    } else {
      Navigator.pushNamed(this, resolveRoute(pageConfig.route),
          arguments: CustomRouteSettings(pageConfig: pageConfig, data: data));
    }
  }

  void pushReplace(
      {required PageConfig pageConfig, data, bool checkMounted = false}) {
    debugPrint(resolveRoute(pageConfig.route));
    if (checkMounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          Navigator.pushReplacementNamed(this, resolveRoute(pageConfig.route),
              arguments:
                  CustomRouteSettings(pageConfig: pageConfig, data: data));
        }
      });
    } else {
      Navigator.pushReplacementNamed(this, resolveRoute(pageConfig.route),
          arguments: CustomRouteSettings(pageConfig: pageConfig, data: data));
    }
  }

  void popAndPush(
      {required PageConfig pageConfig, data, bool checkMounted = false}) {
    debugPrint(resolveRoute(pageConfig.route));
    if (checkMounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          Navigator.popAndPushNamed(this, resolveRoute(pageConfig.route),
              arguments:
                  CustomRouteSettings(pageConfig: pageConfig, data: data));
        }
      });
    } else {
      Navigator.popAndPushNamed(this, resolveRoute(pageConfig.route),
          arguments: CustomRouteSettings(pageConfig: pageConfig, data: data));
    }
  }

  void pop({data, bool checkMounted = false}) {
    if (checkMounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          Navigator.pop(this, data);
        }
      });
    } else {
      Navigator.pop(this, data);
    }
  }

  void pushAndRemoveUntil(
      {required PageConfig pageConfig,
      data,
      bool checkMounted = false,
      required PageConfig removeUntilpageConfig}) {
    debugPrint(resolveRoute(pageConfig.route));
    if (checkMounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              this,
              resolveRoute(pageConfig.route),
              ModalRoute.withName(resolveRoute(removeUntilpageConfig.route)),
              arguments:
                  CustomRouteSettings(pageConfig: pageConfig, data: data));
        }
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(this, resolveRoute(pageConfig.route),
          ModalRoute.withName(resolveRoute(removeUntilpageConfig.route)),
          arguments: CustomRouteSettings(pageConfig: pageConfig, data: data));
    }
  }
}

class AppRoute {
  late PageConfig initialPage;
  late Object? initialPageData;

  AppRoute({required this.initialPage, required this.initialPageData});

  Route onGenerateRoute(RouteSettings settings) {
    debugPrint("Setings name :${settings.name}");
    try {
      var customSettings = settings.arguments as CustomRouteSettings;
      return builder(
        CustomRouteSettings(
          pageConfig: customSettings.pageConfig,
          data: customSettings.data,
        ),
      );
    } on TypeError {
      return builder(
        CustomRouteSettings(
          pageConfig: initialPage,
          data: initialPageData,
        ),
      );
    } catch (error) {
      error.logExceptionData();
      return builder(
        CustomRouteSettings(
          pageConfig: Pages.splashScreenConfig,
          data: "",
        ),
      );
    }
  }
}

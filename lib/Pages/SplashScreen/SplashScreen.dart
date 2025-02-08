import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/SplashScreen/SplashscreenVM.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashScreenVM _splashScreenVM;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashScreenVM = SplashScreenVM();
    // Future.delayed(Duration(seconds: 2), () {
    //   _splashScreenVM.navigateToLoginScreen();
    // });
    _splashScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPushReplace) {
        context.pushReplace(pageConfig: event.pageConfig, data: event.data);
      } else if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUI.w(40, context)),
        child: Center(
          child: SvgPicture.asset(
            AppConstants.appLogo,
            width: ResponsiveUI.w(211, context),
            height: ResponsiveUI.h(89, context),
          ),
        ),
      ),
    );
  }
}

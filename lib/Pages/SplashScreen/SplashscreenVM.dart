import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/SplashScreen/SplashScreenModel.dart';

class SplashScreenVM extends SplashScreenModel {
  SplashScreenVM() {
    checkIsUserLoggedIn();
  }
  void navigateToLoginScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPushReplace(
              pageConfig: Pages.loginScreenConfig, data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void checkIsUserLoggedIn() async {
    try {
      ServiceResult<String?> isLoggedIn =
          await secureStorageService.retrieveData(key: "isLoggedIn");
      if (isLoggedIn.content != null) {
        if (isLoggedIn.content == "true") {
          ServiceResult<String?> isProfileCompleted = await secureStorageService
              .retrieveData(key: "isProfileCompleted");
          if (isProfileCompleted.content == "true") {
            addNavigationToStream(
                navigate: NavigatorPopAndPush(
                    pageConfig: Pages.homeScreenConfig, data: []));
          } else {
            addNavigationToStream(
                navigate: NavigatorPopAndPush(
                    pageConfig: Pages.nameScreenConfig, data: []));
          }
        } else {
          addNavigationToStream(
              navigate: NavigatorPopAndPush(
                  pageConfig: Pages.loginScreenConfig, data: []));
        }
      } else {
        addNavigationToStream(
            navigate: NavigatorPopAndPush(
                pageConfig: Pages.loginScreenConfig, data: []));
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

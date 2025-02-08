import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/PopupMixinConfig.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/NameScreen/NameScreenModel.dart';
import 'package:zappy/Pages/SplashScreen/SplashScreenModel.dart';

class NameScreenVM extends NameScreenModel {
  void navigateToHomeScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPushReplace(
              pageConfig: Pages.homeScreenConfig, data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void submitDetails(String name) async {
    try {
      ServiceResult<String?> mobileNumber =
          await secureStorageService.retrieveData(key: "mobile_number");
      final currentToken = await FirebaseMessaging.instance.getToken();
      await secureStorageService.saveData(
          key: "fcm_token", value: currentToken);
      UserBO user = UserBO(
          fullName: name,
          phoneNumber: mobileNumber.content!,
          fcmToken: currentToken!);
      ServiceResult<bool> isUpdated =
          await userServices.createCapitanAccount(user);
      if (isUpdated.statusCode == ServiceStatusCode.OK) {
        await secureStorageService.saveData(
            key: "isProfileCompleted", value: "true");
        navigateToHomeScreen();
      } else {
        setPopUpEvent(
            event: ShowPopupWithSingleAction(
          type: PopupType.error,
          buttonText: "Try again",
          popUpName: "Failed while create an account",
          description: "We are look into this issue",
          iconUrl: "lib/Helpers/Resources/Images/tickIcon.svg",
          function: () {
            addNavigationToStream(navigate: NavigatorPop());
          },
        ));
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

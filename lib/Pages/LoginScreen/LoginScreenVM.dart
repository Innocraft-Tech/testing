import 'dart:io';

import 'package:flutter/material.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/PopupMixinConfig.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/LoginScreen/LoginScreenModel.dart';
import 'package:zappy/Pages/SplashScreen/SplashScreenModel.dart';

class LoginScreenVM extends LoginScreenModel {
  final Otpless _otplessFlutterPlugin = Otpless();
  void onHeadlessResult(dynamic result) {
    if (result['statusCode'] == 200) {
      switch (result['responseType'] as String) {
        case 'INITIATE':
          {
            // notify that headless authentication has been initiated
            navigateOTPScreen(mobileNumber);
          }
          break;
        case 'VERIFY':
          {
            // notify that verification is completed
            // and this is notified just before "ONETAP" final response
          }
          break;
        case 'OTP_AUTO_READ':
          {
            if (Platform.isAndroid) {
              var otp = result['response']['otp'] as String;
            }
            navigateOTPScreen(mobileNumber);
          }
          break;
        case 'ONETAP':
          {
            final token = result["response"]["token"];
            navigateToHomeScreen();
          }
          break;
      }
    } else {
      //todo
    }
  }

  void navigateOTPScreen(String mobileNumber) {
    print(mobileNumber);
    try {
      addNavigationToStream(
          navigate: NavigatorPush(
              pageConfig: Pages.otpScreenConfig, data: [mobileNumber]));
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<void> getOTP(String mobileNumber) async {
    try {
      setIsLoading(true);
      await secureStorageService.saveData(
          key: "mobile_number", value: mobileNumber);
      setMobileNumber(mobileNumber);
      Map<String, dynamic> arg = {
        "phone": mobileNumber,
        "countryCode": "+91",
      };
      await _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
      setIsLoading(false);
    } catch (error) {
      setIsLoading(true);
      setIsLoading(false);
      error.logExceptionData();
    }
  }

  void navigateToHomeScreen() async {
    try {
      secureStorageService.saveData(key: "isLoggedIn", value: "true");
      ServiceResult<String?> isProfileCompleted =
          await secureStorageService.retrieveData(key: "isProfileCompleted");
      if (isProfileCompleted.content == "true") {
        addNavigationToStream(
            navigate: NavigatorPushReplace(
                pageConfig: Pages.homeScreenConfig, data: ""));
      } else {
        checkUserIsAvailable(mobileNumber);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<void> checkUserIsAvailable(String mobileNumber) async {
    try {
      ServiceResult<bool> isUserIsAvailable =
          await userServices.checkUserIsAvailable(mobileNumber);
      if (isUserIsAvailable.statusCode == ServiceStatusCode.OK &&
          isUserIsAvailable.content!) {
        await secureStorageService.saveData(key: "isLoggedIn", value: "true");
        ServiceResult<String?> isProfileCompleted =
            await secureStorageService.retrieveData(key: "isProfileCompleted");
        setPopUpEvent(
            event: ShowPopupWithSingleAction(
          type: PopupType.success,
          buttonText: "Continue",
          popUpName: "Login verified",
          description: "Your login is verified successfully",
          iconUrl: "lib/Helpers/Resources/Images/tickIcon.svg",
          function: () {
            addNavigationToStream(
                navigate: NavigatorPopAndRemoveUntil(
                    pageConfig: isProfileCompleted.content == "true"
                        ? Pages.homeScreenConfig
                        : Pages.nameScreenConfig,
                    removeUntilpageConfig: Pages.splashScreenConfig,
                    data: []));
          },
        ));
      } else if (isUserIsAvailable.statusCode == ServiceStatusCode.OK &&
          isUserIsAvailable.content! == false) {
        addNavigationToStream(
            navigate: NavigatorPopAndPush(
                pageConfig: Pages.nameScreenConfig, data: []));
      } else if ((isUserIsAvailable.statusCode ==
                  ServiceStatusCode.InternalServerError &&
              !isUserIsAvailable.content!) ||
          (isUserIsAvailable.statusCode ==
                  ServiceStatusCode.ServiceUnavailable &&
              !isUserIsAvailable.content!)) {
        await secureStorageService.saveData(key: "isLoggedIn", value: "false");
        setPopUpEvent(
            event: ShowPopupWithSingleAction(
          type: PopupType.error,
          buttonText: "Try again",
          popUpName: "OTP varification Failed",
          description: "Something went wrong, please try again",
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

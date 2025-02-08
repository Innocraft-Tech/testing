import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:telephony/telephony.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/PopupMixinConfig.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/OTPScreen/OTPScreenModel.dart';

class OTPScreenVM extends OTPScreenModel {
  final Otpless _otplessFlutterPlugin = Otpless();
  String phoneNumber = "";

  /// Handles headless result for various OTP states.
  void onHeadlessResult(dynamic result) async {
    if (result['statusCode'] == 200) {
      final String responseType = result['responseType'] as String;
      switch (responseType) {
        case 'INITIATE':
          {
            // Notify that headless authentication has been initiated
            // Add your logic here for initiation
          }
          break;
        case 'VERIFY':
          {
            // Notify that verification is completed
            // Add your logic here for verification completion
            checkUserIsAvailable(mobileNumber);
          }
          break;
        case 'OTP_AUTO_READ':
          {
            if (Platform.isAndroid) {
              final String otp = result['response']['otp'] as String;
              // Use the auto-read OTP for further processing
            }
          }
          break;
        case 'ONETAP':
          {
            final String token = result['response']['token'] as String;
            // Use the token for authentication
          }
          break;
        default:
          {
            // Handle any other unexpected response types
          }
      }
    } else {
      // Handle errors appropriately
      final int errorCode = result['statusCode'];
      setPopUpEvent(
          event: ShowPopupWithSingleAction(
              type: PopupType.error,
              popUpName: "Verification failed",
              buttonText: "Try again",
              iconUrl: "lib/Helpers/Resources/Images/tickIcon.svg",
              description: "Your OTP is not verified",
              function: () {
                addNavigationToStream(navigate: NavigatorPop());
              }));
      final String errorMessage = result['message'] ?? "Unknown Error";
      errorMessage.logExceptionData(); // Log the error for debugging
    }
  }

  OTPScreenVM() {}
  void navigateToNameScreen() {
    try {
      addNavigationToStream(navigate: NavigatorPop());
      addNavigationToStream(
          navigate: NavigatorPopAndRemoveUntil(
              pageConfig: Pages.nameScreenConfig,
              removeUntilpageConfig: Pages.splashScreenConfig,
              data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void verifyOTP(String mobileNumber, String otp) async {
    try {
      Map<String, dynamic> arg = {
        "phone": mobileNumber,
        "otp": otp,
        "countryCode": "+91",
      };
      setMobileNumber(mobileNumber);
      await _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
    } catch (error) {
      error.logExceptionData();
    }
  }

  void readOTP() {
    try {
      Telephony _telephony = Telephony.instance;
      _telephony.listenIncomingSms(
          onNewMessage: (SmsMessage message) {
            // print(message.body);
            if (message.body!.contains("zappy-a2e25")) {
              setOtp(message.body!.substring(1, 6));
            }
          },
          listenInBackground: true);
    } catch (error) {
      error.logExceptionData();
    }
  }

  void resendOTP(String mobileNumer) async {
    try {
      ServiceResult<bool> isResent =
          await otpLessOTPService.resendOTP(mobileNumer);
      if (isResent.content!) {
        print("resended");
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

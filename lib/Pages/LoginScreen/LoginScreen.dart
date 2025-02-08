import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/PopupMixinConfig.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/HomeScreen/HomeScreen.dart';
import 'package:zappy/Pages/LoginScreen/LoginScreenVM.dart';
import 'package:zappy/Pages/OTPScreen/OTPScreen.dart';
import 'package:zappy/Reusables/Popup/Popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginScreenVM _loginScreenVM = LoginScreenVM();
  TextEditingController _phoneNumberController = TextEditingController();
  FocusNode _phoneNumberFocusNode = FocusNode();
  final _otplessFlutterPlugin = Otpless();
  bool isInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeOtpless();
    _loginScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPush) {
        context.push(pageConfig: event.pageConfig, data: event.data);
      } else if (event is NavigatorPop) {
        context.pop();
      } else if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      } else if (event is NavigatorPopAndRemoveUntil) {
        context.pushAndRemoveUntil(
            pageConfig: event.pageConfig,
            removeUntilpageConfig: event.removeUntilpageConfig,
            data: event.data);
      }
    });
    _loginScreenVM.popUpController.stream.listen((event) {
      if (event is ShowPopupWithSingleAction) {
        showPopupWithSingleAction(context, event);
      }
    });
  }

  void _initializeOtpless() async {
    try {
      print("Starting Otpless initialization...");
      await _otplessFlutterPlugin.initHeadless("x9kjvr0xyxkksn4gobua");
      _otplessFlutterPlugin.setHeadlessCallback(_handleOtplessResult);
      isInitialized = true;
      print("Otpless initialization successful");
    } catch (e) {
      print("Otpless initialization error: $e");
      isInitialized = false;
    }
  }

  void _handleOtplessResult(dynamic result) {
    print("Otpless result received: $result");

    if (result == null) {
      print("Null result received");
      return;
    }

    try {
      if (result['statusCode'] == 200) {
        final responseType = result['responseType'] as String?;
        print("Processing response type: $responseType");

        switch (responseType) {
          case 'INITIATE':
            print("INITIATE received, navigating to OTP screen");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  mobileNumber: [_phoneNumberController.text],
                ),
              ),
            );
            break;

          case 'OTP_AUTO_READ':
            if (Platform.isAndroid) {
              final otp = result['response']?['otp'] as String?;
              print("OTP auto read: $otp");
              if (otp != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTPScreen(
                      mobileNumber: [_phoneNumberController.text],
                    ),
                  ),
                );
              }
            }
            break;

          case 'ONETAP':
            print("ONETAP received, navigating to home screen");
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => HomeScreen(),
            //   ),
            // );
            _loginScreenVM.checkUserIsAvailable(_loginScreenVM.mobileNumber);
            break;
        }
      } else if (result['statusCode'] == 429) {
        _loginScreenVM.setPopUpEvent(
            event: ShowSingleActionPopup(
                type: PopupType.error,
                popUpName: "Authentication failed. Please try again.",
                buttonText: "Try again",
                iconUrl: "lib/Helpers/Resources/Images/tickIcon.svg",
                description: "Your OTP is not verified",
                function: () {
                  _loginScreenVM.addNavigationToStream(
                      navigate: NavigatorPop());
                }));
      } else {
        print("Error status code: ${result['statusCode']}");
        print("Authentication failed. Please try again.");
      }
    } catch (e) {
      print("Error in _handleOtplessResult: $e");
      print("An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Styles.backgroundWhite,
        body: Padding(
          padding: EdgeInsets.only(top: ResponsiveUI.h(69, context)),
          child: SizedBox(
            height: ResponsiveUI.h(373, context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: ResponsiveUI.w(314, context)),
                  child: SizedBox(
                    width: ResponsiveUI.w(60, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          AppConstants.helpIcon,
                          color: Styles.primaryColor,
                          width: ResponsiveUI.w(24, context),
                          height: ResponsiveUI.h(24, context),
                        ),
                        Text(
                          "Help",
                          style: TextStyle(
                            fontFamily: "MontserratRegular",
                            fontSize: ResponsiveUI.sp(14, context),
                            fontWeight: FontWeight.w400,
                            color: Styles.primaryColor,
                            height: 17 / 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(
                  AppConstants.appIconDark,
                  width: ResponsiveUI.w(139, context),
                  height: ResponsiveUI.h(59, context),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUI.w(16, context)),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    focusNode: _phoneNumberFocusNode,
                    onTapOutside: (event) => _phoneNumberFocusNode.unfocus(),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      color: Styles.backgroundTertiary,
                      fontFamily: "MontserratRegular",
                      fontSize: ResponsiveUI.sp(14, context),
                      fontWeight: FontWeight.w400,
                      height: 17 / 14,
                    ),
                    // onChanged: (value) {
                    //   _phoneNumberController.text = value;
                    // },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUI.w(12, context),
                        ),
                        child: Text(
                          "+91",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: ResponsiveUI.sp(14, context),
                            fontWeight: FontWeight.w400,
                            color: Styles.primaryColor,
                            height: 17 / 14,
                          ),
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: ResponsiveUI.w(
                            30, context), // Adjust size as needed
                      ),
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(
                        fontFamily: "MontserratRegular",
                        fontSize: ResponsiveUI.sp(14, context),
                        fontWeight: FontWeight.w400,
                        color: Styles.textSecondary,
                        height: 17 / 14,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: ResponsiveUI.h(15, context),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Styles.backgroundTertiary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Styles.backgroundTertiary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUI.r(10, context),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUI.w(251, context),
                  child: RichText(
                    text: TextSpan(
                        text: "By continuing, you agree to our",
                        style: TextStyle(
                          fontFamily: "MontserratRegular",
                          fontSize: ResponsiveUI.sp(14, context),
                          fontWeight: FontWeight.w400,
                          color: Styles.backgroundTertiary,
                          height: 20 / 14,
                        ),
                        children: [
                          TextSpan(
                            text: " Terms of Service & Privacy Policy",
                            style: TextStyle(
                              fontFamily: "MontserratRegular",
                              fontSize: ResponsiveUI.sp(14, context),
                              fontWeight: FontWeight.w900,
                              color: Styles.backgroundTertiary,
                              height: 20 / 14,
                            ),
                          ),
                        ]),
                  ),
                ),
                Observer(builder: (context) {
                  return SizedBox(
                    width: ResponsiveUI.w(370, context), // Custom width
                    height: ResponsiveUI.h(48, context), // Custom height
                    child: FilledButton(
                      onPressed: () {
                        print(_phoneNumberController.text);
                        _loginScreenVM.getOTP(_phoneNumberController.text);
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveUI.r(10, context)))),
                        backgroundColor: WidgetStatePropertyAll(Styles
                            .primaryColor), // Fixed typo: WidgetStatePropertyAll -> MaterialStatePropertyAll
                      ),
                      child: _loginScreenVM.isLoading
                          ? SizedBox(
                              height: ResponsiveUI.h(30, context),
                              width: ResponsiveUI.w(30, context),
                              child: CircularProgressIndicator(
                                color: Styles.backgroundPrimary,
                                strokeWidth: 3,
                                strokeCap: StrokeCap.round,
                              ),
                            )
                          : Text(
                              "Continue",
                              style: TextStyle(
                                fontFamily: "MontserratBold",
                                fontSize: ResponsiveUI.sp(14, context),
                                fontWeight: FontWeight.w400,
                                color: Styles.backgroundPrimary,
                                height: 17 / 14,
                              ),
                            ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
      );
    });
  }
}

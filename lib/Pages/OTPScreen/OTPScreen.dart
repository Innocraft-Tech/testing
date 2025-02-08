import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:telephony/telephony.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/OTPScreen/OTPScreenVM.dart';
import 'package:zappy/Reusables/Popup/Popup.dart';
import 'dart:async';

class OTPScreen extends StatefulWidget {
  late List mobileNumber;
  OTPScreen({super.key, required this.mobileNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  late final OTPScreenVM _otpScreenVM;
  int _timerValue = 0;
  Timer? _timer;
  String mobileNum = "";
  String? _retrievedSmsCode;
  String? _appSignature;
  bool _isListening = false;

  void readOTP() {
    try {
      Telephony _telephony = Telephony.instance;
      print("Listening to sms.");
      _telephony.listenIncomingSms(
          onNewMessage: (SmsMessage message) {
            print("sms received : ${message.body}");

            if (message.body!.contains("OTPLESS: Your OTP is")) {
              // Extract OTP using a regular expression
              final RegExp otpRegExp =
                  RegExp(r'\b\d{4,6}\b'); // Matches 4 to 6 digit numbers
              final match = otpRegExp.firstMatch(message.body ?? '');
              if (match != null) {
                final otp = match.group(0); // Extract the OTP
                print("Extracted OTP: $otp");

                // Assuming _otpControllers[0].setText is part of your logic
                _otpControllers[0].setText(otp!); // Use the extracted OTP
              } else {
                print("No OTP found in the message.");
              }
            }
          },
          listenInBackground: false);
    } catch (error) {
      error.logExceptionData();
    }
  }

  backgrounMessageHandler(SmsMessage message) async {
    //Handle background message
  }

  void listenToIncomingSMS() {
    print("Listening to sms.");
    Telephony.instance.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
          print("sms received : ${message.body}");
          // verify if we are reading the correct sms or not

          if (message.body!.contains("zappy-a2e25")) {
            String otpCode = message.body!.substring(0, 6);
            setState(() {
              _otpControllers[0].text = otpCode;
              // wait for 1 sec and then press handle submit
            });
          }
        },
        listenInBackground: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _otpScreenVM = OTPScreenVM();
    readOTP();
    mobileNum = widget.mobileNumber[0];
    _otpScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPushReplace) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      } else if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      } else if (event is NavigatorPop) {
        context.pop();
      } else if (event is NavigatorPopAndRemoveUntil) {
        context.pushAndRemoveUntil(
            pageConfig: event.pageConfig,
            removeUntilpageConfig: event.removeUntilpageConfig,
            data: event.data);
      }
    });
    _otpScreenVM.popUpController.stream.listen((event) {
      if (event is ShowPopupWithSingleAction) {
        showPopupWithSingleAction(context, event);
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers, focus nodes, and cancel the timer
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel(); // Cancel the timer if it's running
    super.dispose();
  }

  void _onOtpFieldChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to the next field
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      // If the field is cleared, move focus to the previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  // Function to start the countdown timer
  void _startTimer() {
    setState(() {
      _timerValue = 30; // Reset timer to 30 seconds
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timerValue > 0) {
        setState(() {
          _timerValue--;
        });
      } else {
        timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundWhite,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUI.w(16, context),
            vertical: ResponsiveUI.h(20, context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ResponsiveUI.h(50, context)),
              SvgPicture.asset(
                AppConstants.appIconDark,
                width: ResponsiveUI.w(139, context),
                height: ResponsiveUI.h(59, context),
              ),
              SizedBox(height: ResponsiveUI.h(20, context)),
              Text(
                "Verify Details",
                style: TextStyle(
                  fontFamily: "MontserratMedium",
                  fontSize: ResponsiveUI.sp(16, context),
                  fontWeight: FontWeight.w500,
                  color: Styles.blackPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUI.h(10, context)),
              Text(
                "OTP sent to (+91 ${mobileNum})",
                style: TextStyle(
                  color: const Color(0xFFB9B9B9),
                  fontSize: ResponsiveUI.sp(14, context),
                  fontFamily: 'Montserrat',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUI.h(20, context)),
              Pinput(
                  length: 4,
                  controller: _otpControllers[0],
                  focusNode: _focusNodes[0],
                  onCompleted: (pin) {
                    Future.delayed(Duration(seconds: 1), () {
                      _otpScreenVM.verifyOTP(widget.mobileNumber[0], pin);
                    });
                  },
                  onChanged: (value) {
                    _onOtpFieldChanged(value, 0);
                  },
                  onTapOutside: (event) => _focusNodes[0].unfocus(),
                  defaultPinTheme: PinTheme(
                      width: ResponsiveUI.w(44, context),
                      height: ResponsiveUI.h(53, context),
                      textStyle: TextStyle(
                        color: Styles.blackPrimary,
                        fontFamily: "MontserratRegular",
                        fontSize: ResponsiveUI.sp(16, context),
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Styles.secondaryColor),
                          borderRadius: BorderRadius.circular(
                              ResponsiveUI.r(10, context))))),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: List.generate(
              //     6,
              //     (index) => SizedBox(
              //       width: ResponsiveUI.w(60, context),
              //       child: TextFormField(
              //         style: TextStyle(
              //           color: Styles.backgroundPrimary,
              //           fontFamily: "MontserratRegular",
              //           fontSize: ResponsiveUI.sp(14, context),
              //           fontWeight: FontWeight.w400,
              //           height: 17 / 14,
              //         ),
              //         controller: _otpControllers[index],
              //         focusNode: _focusNodes[index],
              //         onTapOutside: (event) => _focusNodes[index].unfocus(),
              //         textAlign: TextAlign.center,
              //         maxLength: 1,
              //         keyboardType: TextInputType.number,
              //         onChanged: (value) => _onOtpFieldChanged(value, index),
              //         decoration: InputDecoration(
              //           counterText: "", // Hides the character count
              //           contentPadding: EdgeInsets.symmetric(
              //             vertical: ResponsiveUI.h(15, context),
              //           ),
              //           enabledBorder: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: Styles.backgroundPrimary,
              //               width: 1,
              //             ),
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           focusedBorder: OutlineInputBorder(
              //             borderSide: BorderSide(
              //               color: Styles.backgroundPrimary,
              //               width: 1,
              //             ),
              //             borderRadius: BorderRadius.circular(
              //               ResponsiveUI.r(10, context),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: ResponsiveUI.h(30, context)),
              SizedBox(
                width: ResponsiveUI.w(370, context),
                height: ResponsiveUI.h(48, context),
                child: ElevatedButton(
                  onPressed: () {
                    // Combine the OTP values
                    String otp = _otpControllers
                        .map((controller) => controller.text)
                        .join();
                    print("Entered OTP: $otp");
                    _otpScreenVM.verifyOTP(widget.mobileNumber[0], otp);
                  },
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUI.r(10, context),
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Styles.primaryColor,
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: ResponsiveUI.sp(14, context),
                      fontWeight: FontWeight.w400,
                      color: Styles.backgroundPrimary,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUI.h(18, context)),
              GestureDetector(
                onTap: () {
                  print("object");
                  if (_timerValue == 0) {
                    _startTimer(); // Start timer if it's 0
                    _otpScreenVM.resendOTP(widget.mobileNumber[0]);
                  }
                },
                child: Text(
                  _timerValue == 0
                      ? "Resend OTP"
                      : "Resend OTP ($_timerValue)", // Show countdown
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: ResponsiveUI.sp(14, context),
                    fontWeight: FontWeight.w500,
                    color: Styles.primaryColor,
                    height: 18 / 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

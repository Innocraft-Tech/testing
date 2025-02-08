import 'dart:io';
import 'package:otpless_flutter/otpless_flutter.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Services/SDKServices/OTPLessServices/IOTPService.dart';

class OTPService extends IOTPService {
  final Otpless _otplessFlutterPlugin = Otpless();

  /// Handles headless result for various OTP states.
  void onHeadlessResult(dynamic result) {
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
      final String errorMessage = result['message'] ?? "Unknown Error";
      errorMessage.logExceptionData(); // Log the error for debugging
    }
  }

  @override
  Future<ServiceResult<bool>> resendOTP(String mobileNumber) async {
    try {
      Map<String, dynamic> arg = {
        "phone": mobileNumber,
        "countryCode": "+91",
      };

      _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.InternalServerError, content: false);
    }
  }

  @override
  Future<ServiceResult<bool>> sendOTP(String mobileNumber) async {
    try {
      Map<String, dynamic> arg = {
        "phone": mobileNumber,
        "countryCode": "+91",
      };
      await _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.InternalServerError, content: false);
    }
  }

  @override
  Future<ServiceResult<bool>> verifyOTP(String mobileNumber, String otp) async {
    try {
      Map<String, dynamic> arg = {
        "phone": mobileNumber,
        "otp": otp,
        "countryCode": "+91",
      };

      await _otplessFlutterPlugin.startHeadless(onHeadlessResult, arg);
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.InternalServerError, content: false);
    }
  }
}

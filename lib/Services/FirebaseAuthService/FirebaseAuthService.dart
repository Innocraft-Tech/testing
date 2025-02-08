import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Services/FirebaseAuthService/IFirebaseAuthService.dart';

class FirebaseAuthService implements IFirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  @override
  Future<ServiceResult<String>> getOTP({required String phoneNumber}) async {
    try {
      if (phoneNumber.isEmpty) {
        return ServiceResult(
          statusCode: ServiceStatusCode.BadRequest,
          content: '',
          message: 'Phone number is required',
        );
      }

      final completer = Completer<ServiceResult<String>>();

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if possible
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(ServiceResult(
            statusCode: ServiceStatusCode.BadRequest,
            content: '',
            message: e.message ?? 'Verification failed',
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          completer.complete(ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: verificationId,
            message: 'OTP sent successfully',
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );

      return completer.future;
    } catch (e) {
      return ServiceResult(
        statusCode: ServiceStatusCode.ServiceUnavailable,
        content: '',
        message: 'Failed to send OTP: ${e.toString()}',
      );
    }
  }

  @override
  Future<ServiceResult<bool>> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      if (otp.isEmpty) {
        return ServiceResult(
          statusCode: ServiceStatusCode.BadRequest,
          content: false,
          message: 'OTP is required',
        );
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return ServiceResult(
        statusCode: ServiceStatusCode.OK,
        content: userCredential.user != null,
        message: userCredential.user != null
            ? 'OTP verified successfully'
            : 'Verification failed',
      );
    } on FirebaseAuthException catch (e) {
      return ServiceResult(
        statusCode: ServiceStatusCode.BadRequest,
        content: false,
        message: e.message ?? 'Invalid OTP',
      );
    } catch (e) {
      return ServiceResult(
        statusCode: ServiceStatusCode.ServiceUnavailable,
        content: false,
        message: 'Verification failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ServiceResult<String>> resendOTP({required String phoneNumber}) async {
    try {
      if (_resendToken == null) {
        return ServiceResult(
          statusCode: ServiceStatusCode.BadRequest,
          content: '',
          message: 'Cannot resend OTP at this time',
        );
      }

      return getOTP(phoneNumber: phoneNumber);
    } catch (e) {
      return ServiceResult(
        statusCode: ServiceStatusCode.ServiceUnavailable,
        content: '',
        message: 'Failed to resend OTP: ${e.toString()}',
      );
    }
  }
}

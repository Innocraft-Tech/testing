import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IFirebaseAuthService {
  Future<ServiceResult<String>> getOTP({required String phoneNumber});
  Future<ServiceResult<bool>> verifyOTP(
      {required String verificationId, required String otp});
  Future<ServiceResult<String>> resendOTP({required String phoneNumber});
}

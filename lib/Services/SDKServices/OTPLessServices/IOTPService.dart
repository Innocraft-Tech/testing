import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IOTPService {
  Future<ServiceResult<bool>> sendOTP(String mobileNumber);
  Future<ServiceResult<bool>> verifyOTP(String mobileNumber, String otp);
  Future<ServiceResult<bool>> resendOTP(String mobileNumber);
}

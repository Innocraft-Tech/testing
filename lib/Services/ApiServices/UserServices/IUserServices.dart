import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IUserServices {
  Future<ServiceResult<String>> uploadDocuments(FormData data);
  Future<ServiceResult<bool>> createCapitanAccount(UserBO user);
  Future<ServiceResult<bool>> updatePilotProfile(
      Map<String, dynamic> user, String accessToken);
  Future<ServiceResult<bool>> checkUserIsAvailable(String mobileNumber);
  Future<ServiceResult<UserBO>> getPilotProfile(String accessToken);
  Future<ServiceResult<UserBO>> getUserProfile(String mobileNumber);
  Future<ServiceResult<UserBO>> updateUserProfile(Map<String, dynamic> user);
}

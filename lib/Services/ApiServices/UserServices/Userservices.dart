import 'package:dio/dio.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Services/ApiServices/UserServices/IUserServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/PlatformSecureStorageService.dart';

class UserServices extends IUserServices {
  final String baseURL = "http://65.2.70.82:8000";
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://65.2.70.82:8000"));
  @override
  Future<ServiceResult<String>> uploadDocuments(FormData data) async {
    try {
      var response =
          await _dio.post("/api/users/upload-profile-picture", data: data);
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK, content: response.data["url"]);
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK, content: response.data["error"]);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          content: "Something went wrong");
    }
  }

  @override
  Future<ServiceResult<bool>> createCapitanAccount(UserBO user) async {
    try {
      var response = await _dio.post("/api/users", data: user.toJson());
      if (response.statusCode == 201) {
        PlatformSecureStorageService platformSecureStorageService =
            PlatformSecureStorageService();
        await platformSecureStorageService.saveData(
            key: "accessToken",
            value: response.data["data"]["tokens"]["accessToken"]);
        await platformSecureStorageService.saveData(
            key: "refreshToken",
            value: response.data["data"]["tokens"]["refreshToken"]);
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
      } else if (response.statusCode == 502) {
        return ServiceResult(
            statusCode: ServiceStatusCode.InternalServerError, content: false);
      } else {
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: false);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable, content: false);
    }
  }

  @override
  Future<ServiceResult<bool>> updatePilotProfile(
      Map<String, dynamic> user, String accessToken) async {
    try {
      var response = await _dio.patch("/api/captains/profile",
          data: user,
          options: Options(
            headers: {
              "Authorization": "Bearer $accessToken",
            },
          ));
      if (response.statusCode == 200) {
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
      } else {
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: false);
      }
    } catch (error) {
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: false);
    }
  }

  @override
  Future<ServiceResult<bool>> checkUserIsAvailable(String mobileNumber) async {
    try {
      PlatformSecureStorageService platformSecureStorageService =
          PlatformSecureStorageService();
      var response = await _dio.post("/api/users/check-user-present",
          data: {"mobileNumber": mobileNumber});
      if (response.statusCode == 200) {
        await platformSecureStorageService.saveData(
            key: "accessToken", value: response.data["tokens"]["accessToken"]);
        await platformSecureStorageService.saveData(
            key: "refreshToken",
            value: response.data["tokens"]["refreshToken"]);
        await platformSecureStorageService.saveData(
            key: "isProfileCompleted",
            value: response.data["data"]["isProfileCompleted"]);
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: response.data["data"]["value"]);
      } else if (response.statusCode == 404) {
        return ServiceResult(
            statusCode: ServiceStatusCode.NotFound, content: false);
      } else if (response.statusCode == 502) {
        return ServiceResult(
            statusCode: ServiceStatusCode.InternalServerError, content: false);
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.ServiceUnavailable, content: false);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable, content: false);
    }
  }

  @override
  Future<ServiceResult<UserBO>> getPilotProfile(String accessToken) async {
    try {
      var response = await _dio.get("/api/captains/",
          options: Options(
            headers: {
              "Authorization": "Bearer $accessToken",
            },
          ));
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: UserBO.fromJson(response.data["data"]));
      } else {
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: null);
      }
    } catch (error) {
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: null);
    }
  }

  @override
  Future<ServiceResult<UserBO>> getUserProfile(String mobileNumber) async {
    try {
      var response = await _dio
          .post("/api/users/refreshtoken", data: {"phonenumber": mobileNumber});
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: UserBO.fromJson(response.data["data"]["user"]));
      } else {
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: null);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: null);
    }
  }

  @override
  Future<ServiceResult<UserBO>> updateUserProfile(
      Map<String, dynamic> user) async {
    try {
      var response =
          await _dio.post("/api/users/update-user-profile", data: user);
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: UserBO.fromJson(response.data["data"]));
      } else {
        return ServiceResult(statusCode: ServiceStatusCode.OK, content: null);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: null);
    }
  }
}

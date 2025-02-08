import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';

/* Create a PlatformSecureStorageService that extends the interface */
class PlatformSecureStorageService extends IPlatformSecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  @override
  /* Create a method saveData() to store the data in secure storage and pass the key and value as parameter */
  Future<ServiceResult<bool>> saveData<String>(
      {required String key, required String value}) async {
    try {
      if (key == null && key == "" && value == null && value == "") {
        return ServiceResult(
            statusCode: ServiceStatusCode.BadRequest,
            content: false,
            message: "Failed");
      }

      await _secureStorage.write(key: key.toString(), value: value.toString());
      return ServiceResult(
          statusCode: ServiceStatusCode.OK, content: true, message: "Success");
    } catch (e) {
      // Invoke writeExceptionData()
      e.toString();

      return ServiceResult(
          statusCode: ServiceStatusCode.NotFound,
          content: false,
          message: "Exception");
    }
  }

  @override

  /* Create a method retrieveData() to retrieve the data and pass the key as parameter*/
  Future<ServiceResult<String?>> retrieveData<T>({required String key}) async {
    try {
      // Retrieve the data by passing key to read() and store the result in retrievedData
      String? retrievedData = await _secureStorage.read(key: key);

      if (retrievedData == null) {
        return ServiceResult(
            statusCode: ServiceStatusCode.NotFound,
            content: null,
            message: "Failed");
      }

      return ServiceResult(
          statusCode: ServiceStatusCode.OK,
          content: retrievedData,
          message: "Success");
    } catch (e) {
      // Invoke writeExceptionData()
      e.toString();

      // Return null.
      return ServiceResult(
          statusCode: ServiceStatusCode.NotFound,
          content: null,
          message: "Exception");
    }
  }

  @override

  /* Create a method deleteData() to delete the data and pass the key as parameter*/
  Future<ServiceResult<bool>> deleteData({required String key}) async {
    try {
      // Delete the data by passing key to delete()
      await _secureStorage.delete(key: key);

      return ServiceResult(
          statusCode: ServiceStatusCode.OK, content: true, message: "Success");
    } catch (e) {
      // Invoke writeExceptionData()
      e.logExceptionData();

      // Return false
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          content: false,
          message: "Exception");
    }
  }

  @override
  /* Create a method deleteAllData() to delete all the data in secure storage*/
  Future<ServiceResult<bool>> deleteAllData() async {
    try {
      // Delete all the data by invoking to delete()
      await _secureStorage.deleteAll();

      return ServiceResult(
          statusCode: ServiceStatusCode.OK, content: true, message: "Success");
    } catch (e) {
      // Invoke writeExceptionData()
      e.logExceptionData();

      // Return false
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          content: false,
          message: "Exception");
    }
  }
}

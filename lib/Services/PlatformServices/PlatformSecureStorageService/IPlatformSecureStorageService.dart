/* Create a IPlatformSecureStorageService as abstract class */

import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IPlatformSecureStorageService {
  // Create a method to save data in secure storage
  Future<ServiceResult<bool>> saveData<String>(
      {required String key, required String value});

  // Create a method to retrieve the data from secure storage
  Future<ServiceResult<String?>> retrieveData<T>({required String key});

  // Create a method to delete the data in secure storage
  Future<ServiceResult<bool>> deleteData({required String key});

  // Create a method to delete all the data in secure Storage
  Future<ServiceResult<bool>> deleteAllData();
}

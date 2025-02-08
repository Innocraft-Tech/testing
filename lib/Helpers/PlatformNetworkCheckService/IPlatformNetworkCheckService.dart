import '../../../Helpers/ServiceResult.dart';

abstract class IPlatformNetworkCheckService {
  Future<ServiceResult<bool>> checkInternetConnectivity();
}

import 'package:zappy/Helpers/BOs/AddressBO/AddressBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IAddressApiServices {
  Future<ServiceResult<List<AddressBO>>> getAllAddresses(String mobileNumber);
  Future<ServiceResult<AddressBO>> addAddress(
      AddressBO addressBO, String mobileNumber);
}

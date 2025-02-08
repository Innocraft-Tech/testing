import 'package:dio/dio.dart';
import 'package:zappy/Helpers/BOs/AddressBO/AddressBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Services/ApiServices/AdressApiServices/IAddressApiServices.dart';

class AddressApiServices extends IAddressApiServices {
  final String baseURL = "http://65.2.70.82:8000";
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://65.2.70.82:8000",
    validateStatus: (status) {
      return true;
    },
  ));
  @override
  Future<ServiceResult<AddressBO>> addAddress(
      AddressBO addressBO, String mobileNumber) async {
    try {
      var response = await _dio.post("/api/address/create-address", data: {
        "address": addressBO.address,
        "addressName": addressBO.addressName,
        "addresstype": addressBO.addressType,
        "addressLatlng":
            '${addressBO.addressLatlng.latitude},${addressBO.addressLatlng.longitude}',
        "mobileNumber": mobileNumber
      });
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: AddressBO.fromJson(response.data["data"]));
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: null,
            message: "not found");
      }
    } catch (error) {
      return ServiceResult(
          statusCode: ServiceStatusCode.InternalServerError,
          content: null,
          message: error.toString());
    }
  }

  @override
  Future<ServiceResult<List<AddressBO>>> getAllAddresses(
      String mobileNumber) async {
    try {
      var response = await _dio.post("/api/address/get-address",
          data: {"mobileNumber": mobileNumber});
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: (response.data["data"] as List)
                .map((e) => AddressBO.fromJson(e))
                .toList());
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: null,
            message: "not found");
      }
    } catch (error) {
      return ServiceResult(
          statusCode: ServiceStatusCode.InternalServerError,
          content: null,
          message: error.toString());
    }
  }
}

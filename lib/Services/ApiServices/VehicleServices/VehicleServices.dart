import 'package:dio/dio.dart';
import 'package:zappy/Helpers/BOs/VechileBO/VechileBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Services/ApiServices/VehicleServices/IVehicleServices.dart';

class VehicleServices extends IVehicleServices {
  final String baseURL = "http://65.2.70.82:8000";
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://65.2.70.82:8000"));
  @override
  Future<ServiceResult<List<VechileBO>>> getVehicleList() async {
    try {
      var response = await _dio.get("/api/vehicles");
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: response.data["data"]
                .map<VechileBO>((e) => VechileBO.toJson(e))
                .toList(),
            message: "Vehicle List Fetched Successfully");
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.InternalServerError,
            content: [],
            message: "Vehicle List Fetching failed");
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          content: [],
          message: "Vehicle List Fetching failed");
    }
  }
}

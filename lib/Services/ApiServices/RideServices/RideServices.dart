import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/BOs/VehicleDetailsBO/VehicleDetailsBO.dart';
import 'package:zappy/Helpers/BOs/VehicleInfoBO/VehicleInfoBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';

class RideServices extends IRideServices {
  final String baseURL = "http://65.2.70.82:8000";
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://65.2.70.82:8000",
    validateStatus: (status) {
      return true;
    },
  ));
  @override
  Future<ServiceResult<RideBO>> requestRide(
      String mobileNumber,
      LatLng sourceLocation,
      LatLng destinationLocation,
      String fromLocation,
      String toLocation,
      String fare,
      String duration,
      String distance) async {
    try {
      var response = await _dio.post("/api/rides/request-ride", data: {
        "mobileNumber": mobileNumber,
        "pickupLocation": fromLocation,
        "dropoffLocation": toLocation,
        "pickupLatLng":
            "${sourceLocation.latitude},${sourceLocation.longitude}",
        "dropoffLatLng":
            "${destinationLocation.latitude},${destinationLocation.longitude}",
        "distance": distance,
        "fare": fare,
        "duration": duration,
      });
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: RideBO.fromJson(response.data["data"]),
            message: response.data["data"]["id"]);
      } else if (response.statusCode == 404) {
        return ServiceResult(
            statusCode: ServiceStatusCode.NotFound, content: null);
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.InternalServerError, content: null);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable, content: null);
    }
  }

  @override
  Future<ServiceResult<Map<String, dynamic>>> getVehicleInfo(
      mobileNumber) async {
    try {
      var response = await _dio.post("/api/rides/get-vehicle-details", data: {
        "mobileNumber": mobileNumber,
      });
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: {
              "vehicleInfo":
                  VehicleInfoBO.fromJson(response.data["data"]["vehicle_info"]),
              "vehicleDetails": VehicleDetailsBO.fromJson(
                  response.data["data"]["vehicle_details"])
            },
            message: response.data["data"]["status"]);
      } else if (response.statusCode == 404) {
        return ServiceResult(
            statusCode: ServiceStatusCode.NotFound, content: null);
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.InternalServerError, content: null);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable, content: null);
    }
  }

  @override
  Future<ServiceResult<RideBO>> getRideById(String rideId) async {
    try {
      var response = await _dio.post("/api/rides/get-ride", data: {
        "rideId": rideId,
      });
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: RideBO.fromJson(response.data["data"]),
            message: response.data["data"]["id"]);
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.InternalServerError,
            content: null,
            message: "ride not found");
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.InternalServerError,
          content: null,
          message: "ride not found");
    }
  }

  @override
  Future<ServiceResult<List<RideBO>>> getRidesByUser(
      String mobileNumber) async {
    try {
      var response = await _dio.post("/api/rides/get-rides-by-user", data: {
        "mobileNumber": mobileNumber,
      });
      if (response.statusCode == 200) {
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: response.data["data"]
                .map<RideBO>((e) => RideBO.fromJson(e))
                .toList());
      } else {
        return ServiceResult(
            statusCode: ServiceStatusCode.ServiceUnavailable, content: null);
      }
    } catch (error) {
      error.logExceptionData();
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable, content: null);
    }
  }
}

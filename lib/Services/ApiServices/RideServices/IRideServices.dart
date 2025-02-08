import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IRideServices {
  Future<ServiceResult<RideBO>> requestRide(
      String mobileNumber,
      LatLng sourceLocation,
      LatLng destinationLocation,
      String fromLocation,
      String toLocation,
      String fare,
      String duration,
      String distance);
  Future<ServiceResult<Map<String, dynamic>>> getVehicleInfo(
      String mobileNumber);
  Future<ServiceResult<RideBO>> getRideById(String rideId);
  Future<ServiceResult<List<RideBO>>> getRidesByUser(String mobileNumber);
}

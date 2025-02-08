import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IRealTimeServices {
  Future<ServiceResult<bool>> updateUserLocationRealTime(
      double lat, double lng, String mobileNumber);
  Stream<List<Map<String, dynamic>>> subscribeToRide(String rideId);
  Future<ServiceResult<bool>> updateRideData(
      Map<String, dynamic> data, String rideId);
}

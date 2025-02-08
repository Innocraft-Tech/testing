import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:supabase/supabase.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Services/SDKServices/SupabaseServices/RealTimeServices/IRealTimeServices.dart';

class RealTimeServices extends IRealTimeServices {
  final SupabaseClient supabase;
  Stream<List<Map<String, dynamic>>>? _userStream;
  RealTimeServices({required this.supabase});
  @override
  Future<ServiceResult<bool>> updateUserLocationRealTime(
      double lat, double lng, String mobileNumber) async {
    try {
      await supabase.from("Pilot").update({"current_location": '$lat,$lng'}).eq(
          "phonenumber", mobileNumber);
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
    } catch (error) {
      return ServiceResult(
          statusCode: ServiceStatusCode.NotFound, content: false);
    }
  }

  Stream<List<Map<String, dynamic>>> subscribeToRide(String rideId) {
    _userStream ??=
        supabase.from('Ride').stream(primaryKey: ['id']).eq('id', rideId);

    return _userStream!;
  }
  @override
  Future<ServiceResult<bool>> updateRideData(
      Map<String, dynamic> data, String rideId) async {
    try {
      await supabase.from("Ride").update(data).eq("id", rideId);
      return ServiceResult(statusCode: ServiceStatusCode.OK, content: true);
    } catch (error) {
      return ServiceResult(
          statusCode: ServiceStatusCode.NotFound, content: false);
    }
  }
}

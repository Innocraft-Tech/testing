import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideBO {
  String? rideId;
  String pickupName;
  String pickupAddress;
  String pickupCity;
  LatLng pickupLocation;
  String dropName;
  String dropAddress;
  String dropCity;
  LatLng dropLocation;
  double fare;
  String requestedUserId;
  String requestedUserName;
  DateTime date;
  String status;
  double? duration;
  String userContactNumber;
  String pilotContactNumber;
  String? userImageUrl;
  String? pilotRatings;
  String? pilotImageUrl;
  String? distance;
  String rideOTP;
  double? speed;
  String? vehicleName;
  String? pilotName;
  RideBO(
      {this.rideId,
      required this.pickupName,
      required this.pickupAddress,
      required this.pickupCity,
      required this.pickupLocation,
      required this.dropName,
      required this.dropAddress,
      required this.dropCity,
      required this.dropLocation,
      required this.fare,
      required this.requestedUserId,
      required this.requestedUserName,
      required this.date,
      required this.status,
      this.duration,
      this.distance,
      required this.userContactNumber,
      required this.pilotContactNumber,
      this.pilotImageUrl,
      this.userImageUrl,
      this.pilotRatings,
      required this.rideOTP,
      this.speed,
      this.vehicleName,
      this.pilotName});

  /// Create a `RideBO` object from a `Map` (e.g., parsed JSON).
  factory RideBO.fromJson(Map<String, dynamic> json) {
    return RideBO(
      rideId: json["id"] ?? "",
      pickupAddress: json["from_location"] ?? "",
      pickupName: "",
      pickupCity: "",
      pickupLocation: LatLng(
        double.parse(json["from_location_latlng"].split(",")[0]),
        double.parse(json["from_location_latlng"].split(",")[1]),
      ),
      dropAddress: json["to_location"] ?? "",
      dropName: "",
      dropCity: "",
      dropLocation: LatLng(
        double.parse(json["to_location_latlng"].split(",")[0]),
        double.parse(json["to_location_latlng"].split(",")[1]),
      ),
      fare: double.parse(json["fare"].toString() ?? "0.0"),
      requestedUserId: json["user_id"] ?? "",
      requestedUserName: json["user_name"] ?? "",
      date: DateTime.parse(json["created_at"]),
      status: json["status"] ?? "",
      duration: double.parse(json["duration"] ?? "0.0"),
      userContactNumber: json["user_contact_number"] ?? "",
      pilotContactNumber: json["piloat_contact_number"] ?? "",
      userImageUrl: json["user_image_url"] ?? "",
      pilotRatings: json["pilot_ratings"] ?? "",
      pilotImageUrl: json["pilot_image_url"] ?? "",
      rideOTP: json["ride_otp"] ?? "",
      speed: double.parse(json["speed"] ?? "0.0"),
      distance: json["distance"].toString() ?? "",
      vehicleName: json["vehicle_name"] ?? "",
      pilotName: json["pilot_name"] ?? "",
    );
  }
}

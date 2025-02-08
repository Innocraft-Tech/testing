import 'package:flutter/foundation.dart';

@immutable
class Location {
  final String placeId;
  final String address;
  final double latitude;
  final double longitude;

  const Location({
    required this.placeId,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry']['location'];
    return Location(
      placeId: json['place_id'],
      address: json['formatted_address'],
      latitude: geometry['lat'],
      longitude: geometry['lng'],
    );
  }
}

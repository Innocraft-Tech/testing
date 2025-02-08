import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressBO {
  String address;
  String addressName;
  LatLng addressLatlng;
  String addressType;
  AddressBO(
      {required this.address,
      required this.addressName,
      required this.addressLatlng,
      required this.addressType});
  toJson() {
    return {
      "address": address,
      "address_name": addressName,
      "address_latlng": addressLatlng,
      "address_type": addressType
    };
  }

  factory AddressBO.fromJson(Map<String, dynamic> json) {
    return AddressBO(
      address: json["address"],
      addressName: json["address_name"],
      addressLatlng: LatLng(double.parse(json["address_lat_lng"].split(",")[0]),
          double.parse(json["address_lat_lng"].split(",")[0])),
      addressType: json["address_type"],
    );
  }
}

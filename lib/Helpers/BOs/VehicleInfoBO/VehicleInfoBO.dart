class VehicleInfoBO {
  String id;
  String vehicleName;
  List<String>? models;
  String vehicleImageUrl;
  double perKmValueForInStation;
  double perKmValueForOutStation;
  int capacity;
  int speed;
  VehicleInfoBO(
      {required this.id,
      required this.vehicleName,
      this.models,
      required this.vehicleImageUrl,
      required this.perKmValueForInStation,
      required this.perKmValueForOutStation,
      required this.capacity,
      required this.speed});
  // Factory constructor to create an object from a JSON map
  // Factory constructor to create an object from a JSON map
  factory VehicleInfoBO.fromJson(Map<String, dynamic> json) {
    return VehicleInfoBO(
      id: json['id'],
      vehicleName: json['vehicle_name'],
      models: List<String>.from(json['vehicle_models']),
      vehicleImageUrl: json['vehicle_image_url'],
      perKmValueForInStation: json['per_km_value_for_instation'].toDouble(),
      perKmValueForOutStation: json['per_km_value_for_outstation'].toDouble(),
      capacity: json['capacity'],
      speed: json['average_speed'],
    );
  }
}

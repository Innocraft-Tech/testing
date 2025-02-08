class VehicleDetailsBO {
  String? id;
  String vehicleNumber;
  String dlNumber;
  String vehicleFuelType;
  String vehicleModel;
  String vehicleColor;
  String vehicleInfoId;
  String? rtoNumber;
  VehicleDetailsBO(
      {this.id,
      required this.vehicleNumber,
      required this.dlNumber,
      required this.vehicleFuelType,
      required this.vehicleModel,
      required this.vehicleColor,
      required this.vehicleInfoId,
      this.rtoNumber});
  factory VehicleDetailsBO.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsBO(
      id: json['id'],
      vehicleNumber: json['vehicle_number'],
      dlNumber: json['dl_number'],
      vehicleFuelType: json['vehicle_fuel_type'],
      vehicleModel: json['vehicle_model'],
      vehicleColor: json['vehicle_color'],
      vehicleInfoId: json['vehicle_info_id'],
      rtoNumber: json['rto_number'],
    );
  }
  toJson(VehicleDetailsBO vehicleDetailsBO) {
    return {
      "id": vehicleDetailsBO.id,
      "vehicle_number": vehicleDetailsBO.vehicleNumber,
      "dl_number": vehicleDetailsBO.dlNumber,
      "vehicle_fuel_type": vehicleDetailsBO.vehicleFuelType,
      "vehicle_model": vehicleDetailsBO.vehicleModel,
      "vehicle_color": vehicleDetailsBO.vehicleColor,
      "vehicle_info_id": vehicleDetailsBO.vehicleInfoId,
      "rto_number": vehicleDetailsBO.rtoNumber,
    };
  }
}

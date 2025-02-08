class VechileBO {
  String name;
  String image;
  String price;
  String capacity;
  String speed;
  VechileBO(
      {required this.name,
      required this.image,
      required this.price,
      required this.capacity,
      required this.speed});
  factory VechileBO.toJson(Map<String, dynamic> json) {
    return VechileBO(
        name: json['vehicle_name'],
        image: json['vehicle_image_url'],
        price: json['per_km_value_for_instation'].toString(),
        capacity: json['capacity'].toString(),
        speed: json['average_speed'].toString());
  }
}

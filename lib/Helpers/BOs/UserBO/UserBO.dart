import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class UserBO {
  String fullName;
  String? email;
  String phoneNumber;
  String? profileImageURL;
  String fcmToken;
  String? gender;
  String? dateOfBith;
  UserBO(
      {required this.fullName,
      this.email,
      required this.phoneNumber,
      required this.fcmToken,
      this.profileImageURL,
      this.gender,
      this.dateOfBith});
  toJson() {
    return {
      "fullname": fullName,
      "email": email,
      "phonenumber": phoneNumber,
      "gender": gender,
      "profile_image_url": profileImageURL,
      "fcm_token": fcmToken
    };
  }

  // Factory constructor to create an object from JSON
  factory UserBO.fromJson(Map<String, dynamic> json) {
    return UserBO(
      fullName: json["fullname"] ?? "",
      email: json["email"],
      phoneNumber: json["phonenumber"] ?? "",
      profileImageURL: json["profile_image_url"],
      fcmToken: json["fcm_token"] ?? "",
      gender: json["gender"] ?? "",
      dateOfBith: json["date_of_birth"] ?? "",
    );
  }
}

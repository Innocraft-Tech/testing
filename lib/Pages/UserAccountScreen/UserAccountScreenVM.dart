import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/UserAccountScreen/UserAccountScreenModel.dart';

class UserAccountScreenVM extends UserAccountScreenModel {
  UserAccountScreenVM() {
    setUser(UserBO(fullName: "", phoneNumber: "", fcmToken: ""));
    setLoading(true);
    getUserData();
  }
  Future<bool> requestLocationPermission() async {
    setLoading(true);
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setSourceLocation(newLocation);
      setLoading(false);
      return true;
    } else if (status.isDenied || status.isLimited) {
      status = await Permission.location.request();

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        LatLng newLocation = LatLng(position.latitude, position.longitude);
        setSourceLocation(newLocation);
        setLoading(false);
      } else {
        setLoading(false);
      }
      setLoading(false);
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      setLoading(false);
    }
    setLoading(false);
    return false;
  }

  void navigateToMyRidesScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPush(
              pageConfig: Pages.ridesScreenScreenConfig, data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void getUserData() async {
    try {
      setLoading(true);
      ServiceResult<String?> mobileNumber =
          await secureStorageService.retrieveData(key: "mobile_number");
      ServiceResult<UserBO> user =
          await userServices.getUserProfile(mobileNumber.content!);
      if (user.statusCode == ServiceStatusCode.OK) {
        setUser(user.content!);
        setLoading(false);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> user) async {
    try {
      ServiceResult<UserBO> userProfileData =
          await userServices.updateUserProfile(user);
      if (userProfileData.statusCode == ServiceStatusCode.OK) {
        setUser(userProfileData.content!);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

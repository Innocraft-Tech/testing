import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/AddressBO/AddressBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/ProfileScreen/ProfileScreenModel.dart';
import 'package:zappy/Pages/SavedAddressScreen/SavedAddressScreenModel.dart';

class SavedAddressScreenVM extends SavedAddressScreenModel {
  SavedAddressScreenVM() {
    setLoading(true);
    getAddress();
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

  void navigateToLocaitonPicker() {
    try {
      addNavigationToStream(
          navigate: NavigatorPush(
              pageConfig: Pages.locationPikerScreenScreenConfig, data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void getAddress() async {
    try {
      setLoading(true);

      ServiceResult<String?> mobileNumber =
          await secureStorageService.retrieveData(key: "mobile_number");
      ServiceResult<List<AddressBO>> address =
          await addressApiServices.getAllAddresses(mobileNumber.content!);
      if (address.statusCode == ServiceStatusCode.OK) {
        setAddress(address.content!);
        setLoading(false);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

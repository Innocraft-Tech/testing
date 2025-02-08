import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/AddressBO/AddressBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/LocationPickerScreen/LocationPickerScreenModel.dart';

class LocationPickerScreenVM extends LocationPickerScreenModel {
  LocationPickerScreenVM() {
    setLoading(true);
    getCurrentLocation();
    setAddressType("Personal");
  }
  void getCurrentLocation() async {
    setLoading(true);
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    LatLng newLocation = LatLng(position.latitude, position.longitude);
    setCurrentLocation(newLocation);
    setLoading(false);
  }

  void updateCurrentLocation(LatLng newLocation) {
    setCurrentLocation(newLocation);
  }

  void updateAddressName(String addressName) {
    try {
      setAddressName(addressName);
    } catch (error) {
      error.logExceptionData();
    }
  }

  void updateAddressDetails(String addressDetails) {
    try {
      setAddress(addressDetails);
    } catch (error) {
      error.logExceptionData();
    }
  }

  void submitAddressDetails() async {
    try {
      AddressBO payload = AddressBO(
          address: address,
          addressName: addressName,
          addressLatlng: currentLocation,
          addressType: addressType);
      ServiceResult<String?> mobileNumber =
          await secureStorageService.retrieveData(key: "mobile_number");
      ServiceResult<AddressBO> addressData =
          await addressapiservices.addAddress(payload, mobileNumber.content!);
      if (addressData.statusCode == ServiceStatusCode.OK) {
        addNavigationToStream(navigate: NavigatorPop());
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

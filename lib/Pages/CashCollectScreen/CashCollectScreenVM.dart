import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/CashCollectScreen/CashCollectScreenModel.dart';

class CashCollectScreenVM extends CashCollectScreenModel {
  CashCollectScreenVM(RideBO currentRide) {
    setLoading(true);
    setCurrentRideRequest(currentRide);
    setCurrentLocation(LatLng(0.0, 0.0));
    getCurrentLocation();
    getRideData();
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

  void collecteCash() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndRemoveUntil(
              pageConfig: Pages.homeScreenConfig,
              removeUntilpageConfig: Pages.splashScreenConfig,
              data: [""]));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void navigateToRideRatingsScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndPush(
              pageConfig: Pages.rideRatingsScreenScreenConfig,
              data: currentRideRequest));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void navigateToPilotRatingsScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndPush(
              pageConfig: Pages.pilotRatingsScreenScreenConfig,
              data: currentRideRequest));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void getRideData() async {
    try {
      ServiceResult<RideBO> currentRide =
          await rideServices.getRideById(currentRideRequest.rideId!);
      if (currentRide.statusCode == ServiceStatusCode.OK) {
        setCurrentRideRequest(currentRide.content!);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

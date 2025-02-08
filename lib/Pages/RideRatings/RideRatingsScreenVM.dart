import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/RideRatings/RideRatingsScreenModel.dart';

class RideRatingsScreenVM extends RideRatingsScreenModel {
  RideRatingsScreenVM(RideBO currentRide) {
    setLoading(true);
    setCurrentRideRequest(currentRide);
    setCurrentLocation(LatLng(0.0, 0.0));
    getCurrentLocation();
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

  void updateMoodIndex(int index) {
    try {
      setMoodIndex(index);
    } catch (error) {
      error.logExceptionData();
    }
  }

  void navigateToHomeScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndRemoveUntil(
              pageConfig: Pages.homeScreenConfig,
              removeUntilpageConfig: Pages.homeScreenConfig,
              data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }
}

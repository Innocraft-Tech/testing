import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/BOs/VechileBO/VechileBO.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/PopupMixinConfig.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/HomeScreen/HomeScreenModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zappy/Pages/RideBookingScreen/RideBookingScreenModel.dart';

class RideBookingScreenVM extends RideBookingScreenModel {
  Function(LatLng)? onLocationUpdate;
  StreamSubscription? _capitansSubscription;
  StreamSubscription? _capitansOnlineSubscription;

  RideBookingScreenVM(List extraData) {
    // checkLocationStatus();
    getVehicleList();
    setSourceLocation(extraData[0]);
    setDestinationLocation(extraData[1]);
    setFromLocation(extraData[2]);
    setToLocation(extraData[3]);
    getPolyPoints();
  }

  void setLocationUpdateCallback(Function(LatLng) callback) {
    onLocationUpdate = callback;
  }

  void navigateToSearchScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPush(
              pageConfig: Pages.locationSearchScreenConfig,
              data: [
            scourceLocation,
            destinationLocation,
            updateSourceLocation,
            updateDestinationLocation,
            notify
          ]));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void updateSourceLocation(LatLng source) {
    try {
      setSourceLocation(source);
      onLocationUpdate?.call(source);
      notifyListeners();
    } catch (error) {
      error.logExceptionData();
    }
  }

  void updateDestinationLocation(LatLng destination) {
    try {
      setDestinationLocation(destination);
      getPolyPoints();
    } catch (error) {
      error.logExceptionData();
    }
  }

  void notify() {
    notifyListeners();
  }

  void getPolyPoints() async {
    try {
      setIsLoading(true);
      PolylinePoints polylinePoints = PolylinePoints();
      PointLatLng origin =
          PointLatLng(scourceLocation.latitude, scourceLocation.longitude);
      PointLatLng destination = PointLatLng(
          destinationLocation.latitude, destinationLocation.longitude);

      PolylineRequest request = PolylineRequest(
        origin: origin,
        destination: destination,
        mode: TravelMode.driving,
      );

      if (destination.latitude == 0.0) {
        return;
      }

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: "AIzaSyCejrgwc8YOfUgiyIav3acGZHifa1MY9wE",
          request: request);

      if (result.points.isNotEmpty) {
        List<LatLng> points = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        setPolyPoints(points);
        double distance = calculateRouteDistance(polypoints);
        setDistance(distance);
        setIsLoading(false);
        notifyListeners();
      }
    } catch (error) {
      setIsLoading(false);
      error.logExceptionData();
    }
  }

  Future<bool> requestLocationPermission() async {
    setIsLoading(true);
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      platformSecureStorageService.saveData(
          key: "isLocationEnabled", value: "true");
      setIsLoading(false);
      return true;
    } else if (status.isDenied || status.isLimited) {
      status = await Permission.location.request();

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        LatLng newLocation = LatLng(position.latitude, position.longitude);
        updateSourceLocation(newLocation);
        setLocationEnabled(true);
        platformSecureStorageService.saveData(
            key: "isLocationEnabled", value: "true");
        setIsLoading(false);
      } else {
        platformSecureStorageService.saveData(
            key: "isLocationEnabled", value: "false");
        setIsLoading(false);
      }
      setIsLoading(false);
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      setIsLoading(false);
    }
    setIsLoading(false);
    return false;
  }

  void checkLocationStatus() async {
    try {
      setIsLoading(true);
      ServiceResult<String?> isLocationEnabled =
          await platformSecureStorageService.retrieveData(
              key: "isLocationEnabled");
      if (isLocationEnabled.content != null &&
          isLocationEnabled.content == "true") {
        setLocationEnabled(true);
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        LatLng newLocation = LatLng(position.latitude, position.longitude);
        updateSourceLocation(newLocation);
        setIsLoading(false);
      } else {
        requestLocationPermission();
        setIsLoading(false);
      }
    } catch (error) {
      setIsLoading(false);
      error.logExceptionData();
    }
  }

  void discoverCapitans() {
    try {
      final DatabaseReference capitansRef =
          FirebaseDatabase.instance.ref('capitansLocations');

      // Cancel any existing subscriptions
      _capitansSubscription?.cancel();
      _capitansOnlineSubscription?.cancel();

      // Listen for online capitans
      _capitansOnlineSubscription = capitansRef
          .orderByChild('is_online')
          .equalTo(true)
          .onChildAdded
          .listen((DatabaseEvent event) {
        if (event.snapshot.value == null) return;

        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final lat = data['lat'];
        final lng = data['lng'];
        final isOnline = data['is_online'];

        if (isOnline == true && lat != null && lng != null) {
          final location = LatLng(
              double.parse(lat.toString()), double.parse(lng.toString()));

          // Check if the location is not already in the list
          if (!capitansAreLive.any((existing) =>
              existing.latitude == location.latitude &&
              existing.longitude == location.longitude)) {
            addCapitanLocation(location);
          }
        }
      });

      // Listen for location updates of online capitans
      _capitansSubscription = capitansRef
          .orderByChild('is_online')
          .equalTo(true)
          .onChildChanged
          .listen((DatabaseEvent event) {
        if (event.snapshot.value == null) return;

        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final lat = data['lat'];
        final lng = data['lng'];
        final isOnline = data['is_online'];

        // If capitan goes offline, remove from list
        if (isOnline == false) {
          final location = LatLng(
              double.parse(lat.toString()), double.parse(lng.toString()));

          // Remove the location from capitansAreLive list
          capitansAreLive.removeWhere((existing) =>
              existing.latitude == location.latitude &&
              existing.longitude == location.longitude);

          notifyListeners();
          return;
        }

        // Update location if capitan is online
        if (lat != null && lng != null) {
          final newLocation = LatLng(
              double.parse(lat.toString()), double.parse(lng.toString()));

          // Find and update existing location
          for (int i = 0; i < capitansAreLive.length; i++) {
            if (capitansAreLive[i].latitude == newLocation.latitude &&
                capitansAreLive[i].longitude == newLocation.longitude) {
              capitansAreLive[i] = newLocation;
              break;
            }
          }

          notifyListeners();
        }
      });

      // Listen for capitans going offline
      _capitansOnlineSubscription = capitansRef
          .orderByChild('is_online')
          .equalTo(false)
          .onChildAdded
          .listen((DatabaseEvent event) {
        if (event.snapshot.value == null) return;

        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final lat = data['lat'];
        final lng = data['lng'];

        if (lat != null && lng != null) {
          final location = LatLng(
              double.parse(lat.toString()), double.parse(lng.toString()));

          // Remove the location from capitansAreLive list
          capitansAreLive.removeWhere((existing) =>
              existing.latitude == location.latitude &&
              existing.longitude == location.longitude);

          notifyListeners();
        }
      });
    } catch (error) {
      print('Error in discoverCapitans: $error');
      error.logExceptionData();
    }
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadiusKm = 6371.0; // Earth's radius in kilometers

    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double calculateRouteDistance(List<LatLng> polypoints) {
    double totalDistance = 0.0;

    for (int i = 0; i < polypoints.length - 1; i++) {
      totalDistance += calculateDistance(polypoints[i], polypoints[i + 1]);
    }

    return totalDistance;
  }

  Future<void> resetRideSelection() async {
    distance = 0.0;
    destinationLocation = const LatLng(0, 0);
    polypoints.clear();

    // Add a small delay to ensure UI updates properly
    await Future.delayed(const Duration(milliseconds: 100));

    notifyListeners();
  }

  @override
  void dispose() {
    _capitansSubscription?.cancel();
    _capitansOnlineSubscription?.cancel();
    super.dispose();
  }

  void getVehicleList() async {
    try {
      setIsLoading(true);
      ServiceResult<List<VechileBO>> vehicleListResult =
          await vehicleServices.getVehicleList();
      if (vehicleListResult.statusCode == ServiceStatusCode.OK) {
        setVehicleList(vehicleListResult.content!);
        setIsLoading(false);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  void requestRide(VechileBO vehicle, String userFare) async {
    try {
      String duration =
          Utilities.calculateDropTime('${vehicle.name} Cab', distance)
              .split(" ")[0];
      String fare = userFare.isEmpty
          ? Utilities.calculatePrice(vehicle.name, distance).toStringAsFixed(0)
          : userFare;
      ServiceResult<String?> mobileNumber =
          await platformSecureStorageService.retrieveData(key: "mobile_number");
      ServiceResult<RideBO> isRideRequestSuccess =
          await rideServices.requestRide(
              mobileNumber.content!,
              scourceLocation,
              destinationLocation,
              fromLocation,
              toLocation,
              fare,
              duration,
              distance.toString());
      if (isRideRequestSuccess.statusCode == ServiceStatusCode.OK) {
        setCurrentRide(isRideRequestSuccess.content!);
        setRideId(isRideRequestSuccess.message!);
        setPopUpEvent(
            event: ShowPopupWithSingleAction(
                type: PopupType.success,
                popUpName: "Ride requested successfully",
                description: "Your ride request has been sent to nearby riders",
                buttonText: "Continue",
                function: () {
                  addNavigationToStream(
                      navigate: NavigatorPopAndPush(
                          pageConfig: Pages.pilotFindingScreenConfig,
                          data: [
                        scourceLocation,
                        destinationLocation,
                        rideId,
                        fare,
                        currentRide
                      ]));
                }));
      } else if (isRideRequestSuccess.statusCode ==
          ServiceStatusCode.NotFound) {
        setPopUpEvent(
            event: ShowPopupWithSingleAction(
                type: PopupType.success,
                popUpName: "Ride requested Failed",
                description: "No riders found nearby",
                buttonText: "Continue",
                function: () {
                  addNavigationToStream(navigate: NavigatorPop());
                }));
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

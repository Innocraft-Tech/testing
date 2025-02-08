import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/HomeScreen/HomeScreenModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zappy/Services/ApiServices/UserServices/Userservices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/PlatformSecureStorageService.dart';

class HomeScreenVM extends HomeScreenModel {
  Function(LatLng)? onLocationUpdate;
  StreamSubscription? _capitansSubscription;
  StreamSubscription? _capitansOnlineSubscription;

  HomeScreenVM() {
    requestLocationPermission();
    initFCM();
  }
  void updateFCMToken() async {
    try {
      final currentToken = await FirebaseMessaging.instance.getToken();
      final platformSecureStorageService = PlatformSecureStorageService();
      final UserServices userServices = UserServices();
      ServiceResult<String?> accessToken =
          await platformSecureStorageService.retrieveData(key: "accessToken");
      ServiceResult<String?> refreshToken = await platformSecureStorageService
          .retrieveData(key: "isProfileComplted");
      if (accessToken.content != null) {
        if (currentToken != null) {
          ServiceResult<String?> newToken =
              await platformSecureStorageService.retrieveData(
            key: "fcm_token",
          );
          if (newToken.content == currentToken) {
            return;
          } else {
            ServiceResult<bool> isUpdated = await userServices
                .updatePilotProfile(
                    {"fcm_token": currentToken}, accessToken.content!);
            if (isUpdated.content!) {
              print("object");
              await platformSecureStorageService.saveData(
                key: "fcm_token",
                value: currentToken,
              );
            }
          }
        }
      } else {
        await platformSecureStorageService.deleteAllData();
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<void> initFCM() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    final UserServices userServices = UserServices();
    ServiceResult<String?> accessToken =
        await platformSecureStorageService.retrieveData(key: "accessToken");
    ServiceResult<String?> refreshToken =
        await platformSecureStorageService.retrieveData(key: "refreshToken");
    // Get the initial FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Save or send the token to your server
    ServiceResult<String?> mobileNumber =
        await platformSecureStorageService.retrieveData(key: "mobile_number");
    ServiceResult<UserBO> isUpdated = await userServices.updateUserProfile(
        {"fcm_token": token, "phonenumber": mobileNumber.content!});
    if (isUpdated.statusCode == ServiceStatusCode.OK) {
      print("object");
      await platformSecureStorageService.saveData(
        key: "fcm_token",
        value: token,
      );
    }

    // Listen for token changes
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('FCM Token updated: $newToken');

      // Handle the token change (e.g., update it on your server)
      ServiceResult<bool> isUpdated = await userServices
          .updatePilotProfile({"fcm_token": token}, accessToken.content!);
      if (isUpdated.content!) {
        print("object");
        await platformSecureStorageService.saveData(
          key: "fcm_token",
          value: token,
        );
      }
    });
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

  void listActivePilots() {
    try {
      Supabase.instance.client.from("Pilot").stream(primaryKey: ['id'])
          // .eq("is_active", true) // Only listen to active pilots
          .listen((List<Map<String, dynamic>> data) {
        capitansAreLive.clear(); // Clear existing locations
        capitansAreLiveForAuto.clear();

        for (var pilot in data) {
          try {
            if (pilot["is_active"] == true) {
// Parse location string into LatLng
              final locationParts = pilot["current_location"].split(",");
              final vehicleName = pilot["vehicle_name"];
              if (vehicleName == "Auto") {
                if (locationParts.length == 2) {
                  final latitude = double.parse(locationParts[0]);
                  final longitude = double.parse(locationParts[1]);
                  capitansAreLiveForAuto.add(LatLng(latitude, longitude));
                }
              } else {
                if (locationParts.length == 2) {
                  final latitude = double.parse(locationParts[0]);
                  final longitude = double.parse(locationParts[1]);
                  capitansAreLive.add(LatLng(latitude, longitude));
                }
              }
            } else {
              final locationParts = pilot["current_location"].split(",");
              final vehicleName = pilot["vehicle_name"];
              if (vehicleName == "Auto") {
                if (locationParts.length == 2) {
                  final latitude = double.parse(locationParts[0]);
                  final longitude = double.parse(locationParts[1]);
                  capitansAreLiveForAuto.remove(LatLng(latitude, longitude));
                }
              } else {
                if (locationParts.length == 2) {
                  final latitude = double.parse(locationParts[0]);
                  final longitude = double.parse(locationParts[1]);
                  capitansAreLive.remove(LatLng(latitude, longitude));
                }
              }
            }
          } catch (e) {
            print("Error parsing location for pilot: ${pilot['id']} - $e");
          }
        }
        // notifyListeners();
      });
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
      // getPolyPoints();
    } catch (error) {
      error.logExceptionData();
    }
  }

  void notify() {
    notifyListeners();
  }

  void getPolyPoints() async {
    try {
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
        // notifyListeners();
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<bool> requestLocationPermission() async {
    setIsLoading(true);
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      platformSecureStorageService.saveData(
          key: "isLocationEnabled", value: "true");
      setLocationEnabled(true);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      updateSourceLocation(newLocation);
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
}

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/RideTrackingScreen/RideTrackingScreenModel.dart';

class RideTrackingScreenVM extends RideTrackingScreenModel {
  StreamSubscription<RemoteMessage>? _notificationSubscription;
  Function(RemoteMessage)? onNotificationReceived;
  RideTrackingScreenVM(RideBO currentRide) {
    setCurrentRideRequest(currentRide);
    requestLocationPermission().then((data) => getVehicleDetails());
    _initializeNotificationListener();
    getRideData();
  }
  Future<bool> requestLocationPermission() async {
    setIsLoading(true);
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng newLocation = LatLng(position.latitude, position.longitude);
      setCurrentLocation(newLocation);
      setIsLoading(false);
      return true;
    } else if (status.isDenied || status.isLimited) {
      status = await Permission.location.request();

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        LatLng newLocation = LatLng(position.latitude, position.longitude);
        setCurrentLocation(newLocation);
        setIsLoading(false);
      } else {
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

  void getPolyPoints() async {
    try {
      setIsLoading(true);
      PolylinePoints polylinePoints = PolylinePoints();
      PointLatLng origin = PointLatLng(
          currentRideRequest.pickupLocation.latitude,
          currentRideRequest.pickupLocation.longitude);
      PointLatLng destination = PointLatLng(
          currentRideRequest.dropLocation.latitude,
          currentRideRequest.dropLocation.longitude);

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
      }
      setIsLoading(false);
    } catch (error) {
      error.logExceptionData();
    }
  }

  void getVehicleDetails() async {
    try {
      setIsLoading(true);
      ServiceResult<String?> mobileNumber =
          await secureStorageService.retrieveData(key: "mobile_number");
      ServiceResult<Map<String, dynamic>> data =
          await rideServices.getVehicleInfo(mobileNumber.content!);
      if (data.statusCode == ServiceStatusCode.OK) {
        setVehicleDetails(data.content!["vehicleDetails"]);
        setVehicleInfo(data.content!["vehicleInfo"]);
        setIsLoading(false);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<void> launchDialer(String mobileNumber) async {
    String phoneNumber = '+91$mobileNumber'; // Replace with your number
    try {
      if (Platform.isAndroid) {
        final Uri intent = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(intent)) {
          await launchUrl(intent);
        }
      } else {
        // For iOS
        final Uri url = Uri.parse('tel://$phoneNumber');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      }
    } catch (e) {
      debugPrint('Error launching dialer: $e');
    }
  }

  void _handleNotification(RemoteMessage message) {
    try {
      // Call the callback if set
      onNotificationReceived?.call(message);

      // Handle specific notification types
      if (message.data.containsKey('type')) {
        switch (message.data['type']) {
          case 'ride_completed':
            navigateToCashCollectionScreen();
            break;
          case "pilot_arrived":
            setIsArrivedToPickupLocation(true);
            drawPolypoints(pilotLocation, currentRideRequest.dropLocation);
            notifyListeners();
            break;
        }
      }

      // Notify listeners to update UI

      notifyListeners();
    } catch (error) {
      error.logExceptionData();
    }
  }

  void navigateToCashCollectionScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndPush(
              pageConfig: Pages.cashCollectionScreenConfig,
              data: currentRideRequest));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void _initializeNotificationListener() {
    // Listen for foreground messages
    _notificationSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the notification data
      _handleNotification(message);
    });
  }

  void getRideData() async {
    try {
      setIsLoading(true);
      ServiceResult<RideBO> currentRide =
          await rideServices.getRideById(currentRideRequest.rideId!);
      if (currentRide.statusCode == ServiceStatusCode.OK) {
        setCurrentRideRequest(currentRide.content!);
        listUserDb(currentRide.content!.pilotContactNumber);
        setIsLoading(true);
        notifyListeners();
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  void listUserDb(String mobileNumber) {
    try {
      Supabase.instance.client
          .from("Pilot")
          .stream(primaryKey: ['id'])
          .eq("phonenumber", mobileNumber)
          .listen((List<Map<String, dynamic>> data) {
            print("my ${data}");
            setPilotLocation(LatLng(
                double.parse(data[0]["current_location"].split(",")[0]),
                double.parse(data[0]["current_location"].split(",")[1])));
            drawPolypoints(
                isArrivedToPickupLocation ? pilotLocation : currentLocation,
                isArrivedToPickupLocation
                    ? currentRideRequest.dropLocation
                    : pilotLocation);
            notifyListeners();
          });
    } catch (error) {
      error.logExceptionData();
    }
  }

  void drawPolypoints(LatLng source, LatLng destinationLoc) async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();
      PointLatLng origin = PointLatLng(source.latitude, source.longitude);
      PointLatLng destination =
          PointLatLng(destinationLoc.latitude, destinationLoc.longitude);

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
        notifyListeners();
      }
      setIsLoading(false);
    } catch (error) {
      error.logExceptionData();
    }
  }
}

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/PilotRequestBO/PilotRequestBO.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/PilotFindingScreen/PilotFindingScreenModel.dart';
import 'package:zappy/Services/PlatformServices/NotificationServices/NotificationSound.dart';

class PilotFindingScreenVM extends PilotFindingScreenModel {
  StreamSubscription<RemoteMessage>? _notificationSubscription;
  Function(RemoteMessage)? onNotificationReceived;
  PilotFindingScreenVM(LatLng sourceLocation, LatLng destinationLocation,
      String rideId, String fare, RideBO currentRideRequest) {
    setSourceLocation(sourceLocation);
    setDestinationLocation(destinationLocation);
    setRideId(rideId);
    setPrice(fare);
    setCurrentRide(currentRideRequest);
    getPolyPoints();
    _initializeNotificationListener();
  }
  void setNotificationCallback(Function(RemoteMessage) callback) {
    onNotificationReceived = callback;
  }

  void _initializeNotificationListener() {
    // Listen for foreground messages
    _notificationSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the notification data
      _handleNotification(message);
    });
  }

  void _handleNotification(RemoteMessage message) {
    try {
      // Call the callback if set
      onNotificationReceived?.call(message);

      // Handle specific notification types
      if (message.data.containsKey('type')) {
        switch (message.data['type']) {
          case 'pilot_request':
            PilotRequestBO currentRequest = PilotRequestBO(
                fare: message.data['fare'],
                pilotName: message.data['pilotName'],
                pilotImageUrl: message.data['pilotImageUrl'],
                pilotMobileNumber: message.data['pilotMobileNumber'],
                pilotRatings: message.data['pilotRatings'],
                vehicle: message.data['vehicle']);
            List<PilotRequestBO> previousRequests = pilots;
            pilots.add(currentRequest);
            // print(pilots);
            // previousRequests.add(currentRequest);
            // setPilots(previousRequests);
            // print(pilots);

            break;
          case 'ride_accepted':
            navigateToRideTrackingScreen();
            break;
        }
      }

      // Notify listeners to update UI
      print(pilots);

      notifyListeners();
    } catch (error) {
      error.logExceptionData();
    }
  }

  void getPolyPoints() async {
    try {
      setIsLoading(true);
      PolylinePoints polylinePoints = PolylinePoints();
      PointLatLng origin =
          PointLatLng(sourceLocation.latitude, sourceLocation.longitude);
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
        // double distance = calculateRouteDistance(polypoints);
        // setDistance(distance);
        setIsLoading(false);
        notifyListeners();
      }
    } catch (error) {
      setIsLoading(false);
      error.logExceptionData();
    }
  }

  Future<void> updateRadeFare(double fare) async {
    try {
      setIsFareLoading(true);
      Map<String, double> payloadData = {"fare": fare};
      ServiceResult<bool> isUpdated =
          await realTimeServices.updateRideData(payloadData, rideId);
      if (isUpdated.content!) {
        setIsLoading(false);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<void> acceptRide(PilotRequestBO pilotRequestBO) async {
    try {
      Map<String, dynamic> payloadData = {
        "fare": double.parse(pilotRequestBO.fare.toString()),
        "pilot_image_url": pilotRequestBO.pilotImageUrl,
        "pilot_name": pilotRequestBO.pilotName,
        "piloat_contact_number": pilotRequestBO.pilotMobileNumber,
        "status": "ACCEPTED",
        "vehicle_name": pilotRequestBO.vehicle
      };
      ServiceResult<bool> isUpdated =
          await realTimeServices.updateRideData(payloadData, rideId);
      if (isUpdated.content!) {
        setIsLoading(false);
        navigateToRideTrackingScreen();
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  void declineFare(PilotRequestBO pilotRequestBO) {
    try {
      pilots.remove(pilotRequestBO);
      NotificationSound.stopSound();
    } catch (error) {
      error.logExceptionData();
    }
  }

  void navigateToRideTrackingScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndPush(
              pageConfig: Pages.rideTrackingScreenConfig, data: currentRide));
    } catch (error) {
      error.logExceptionData();
    }
  }
}

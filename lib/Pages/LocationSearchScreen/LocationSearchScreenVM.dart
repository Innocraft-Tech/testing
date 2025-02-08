import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/LocationSearchScreen/LocationSearchScreenModel.dart';

class LocationSearchScreenVM extends LocationSearchScreenModel {
  void navigateToHomeScreen() {
    try {
      addNavigationToStream(navigate: NavigatorPop());
    } catch (error) {
      error.logExceptionData();
    }
  }

  Future<List<LatLng>> getPolyPoints(
      LatLng scourceLocation, LatLng destinationLocation) async {
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
        return [];
      }

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleApiKey: "AIzaSyCejrgwc8YOfUgiyIav3acGZHifa1MY9wE",
          request: request);

      if (result.points.isNotEmpty) {
        List<LatLng> points = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        // notifyListeners();
        return points;
      }
      return [];
    } catch (error) {
      error.logExceptionData();
      return [];
    }
  }

  void updateSourceLocation(LatLng sourceLocation) {
    setSourceLocation(sourceLocation);
  }

  void updateDestinationLocation(LatLng destinationLocation) {
    setDestinationLocation(destinationLocation);
  }

  void navigateToRideBookingScreen(
      String fromLocatin, String toLocation) async {
    List<LatLng> points =
        await getPolyPoints(scourceLocation, destinationLocation);
    setPolyPoints(points);
    addNavigationToStream(
        navigate: NavigatorPopAndPush(
            pageConfig: Pages.rideBookingScreenConfig,
            data: [
          scourceLocation,
          destinationLocation,
          fromLocatin,
          toLocation
        ]));
  }
}

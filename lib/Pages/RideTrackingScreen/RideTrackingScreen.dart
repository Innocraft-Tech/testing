import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/CancellationReasonScreen/cancellationReasonScreen.dart';
import 'package:zappy/Pages/RideTrackingScreen/RideTrackingScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class RideTrackingScreen extends StatefulWidget {
  final RideBO currentRide;
  RideTrackingScreen({super.key, required this.currentRide});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  late RideTrackingScreenVM _rideTrackingScreenVM;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor pilotLocation;
  GoogleMapController? mapController;
  TextEditingController pinController = TextEditingController();
  bool _isMapReady = false;
  double mapHeightFraction = 0.7;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.setMapStyle(AppConstants.mapStyle);
    setState(() {
      _isMapReady = true;
    });
    // Delay the initial bounds fitting to ensure map is properly initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      fitMapToBounds();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomMarker();
    _rideTrackingScreenVM = RideTrackingScreenVM(widget.currentRide);
    pinController.text = _rideTrackingScreenVM.currentRideRequest.rideOTP;
    _rideTrackingScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      }
    });
  }

  void setCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, AppConstants.sourceIcon)
        .then((icon) {
      sourceIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, AppConstants.destinationIcon)
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, AppConstants.liveCar)
        .then((icon) {
      pilotLocation = icon;
    });
  }

  void fitMapToBounds() {
    if (!_isMapReady || mapController == null) return;

    if (_rideTrackingScreenVM.polypoints.isEmpty) {
      _updateCameraPosition(_rideTrackingScreenVM.currentLocation);
      return;
    }

    // Initialize bounds with first point
    double southLat = _rideTrackingScreenVM.polypoints[0].latitude;
    double westLng = _rideTrackingScreenVM.polypoints[0].longitude;
    double northLat = _rideTrackingScreenVM.polypoints[0].latitude;
    double eastLng = _rideTrackingScreenVM.polypoints[0].longitude;

    // Include all polyline points
    for (LatLng point in _rideTrackingScreenVM.polypoints) {
      southLat = min(southLat, point.latitude);
      westLng = min(westLng, point.longitude);
      northLat = max(northLat, point.latitude);
      eastLng = max(eastLng, point.longitude);
    }

    // Add current location to bounds
    final currentLoc = _rideTrackingScreenVM.currentLocation;
    if (currentLoc != const LatLng(0, 0)) {
      southLat = min(southLat, currentLoc.latitude);
      westLng = min(westLng, currentLoc.longitude);
      northLat = max(northLat, currentLoc.latitude);
      eastLng = max(eastLng, currentLoc.longitude);
    }

    // Add pickup and drop locations to bounds
    final pickupLoc = _rideTrackingScreenVM.currentRideRequest.pickupLocation;
    if (pickupLoc != const LatLng(0, 0)) {
      southLat = min(southLat, pickupLoc.latitude);
      westLng = min(westLng, pickupLoc.longitude);
      northLat = max(northLat, pickupLoc.latitude);
      eastLng = max(eastLng, pickupLoc.longitude);
    }

    // Calculate padding (increased for better visibility)
    final latPadding = (northLat - southLat) * 0.5; // Increased padding
    final lngPadding = (eastLng - westLng) * 0.5;

    final bounds = LatLngBounds(
      southwest: LatLng(southLat - latPadding, westLng - lngPadding),
      northeast: LatLng(northLat + latPadding, eastLng + lngPadding),
    );

    // Animate camera with increased padding
    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // Increased padding
    );
  }

  void _updateCameraPosition([LatLng? newLocation]) {
    if (mapController == null) return;

    if (newLocation != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newLocation,
            zoom: 15,
          ),
        ),
      );
      return;
    }

    // Handle polyline points
    if (_rideTrackingScreenVM.polypoints.isNotEmpty) {
      double southLat = _rideTrackingScreenVM.polypoints.first.latitude;
      double westLng = _rideTrackingScreenVM.polypoints.first.longitude;
      double northLat = _rideTrackingScreenVM.polypoints.first.latitude;
      double eastLng = _rideTrackingScreenVM.polypoints.first.longitude;

      // Find the bounds of all points
      for (LatLng point in _rideTrackingScreenVM.polypoints) {
        if (point.latitude < southLat) southLat = point.latitude;
        if (point.latitude > northLat) northLat = point.latitude;
        if (point.longitude < westLng) westLng = point.longitude;
        if (point.longitude > eastLng) eastLng = point.longitude;
      }

      // Include current location and pickup/drop locations in bounds
      final currentLoc = _rideTrackingScreenVM.currentLocation;
      final pickupLoc = _rideTrackingScreenVM.currentRideRequest.pickupLocation;
      final dropLoc = _rideTrackingScreenVM.currentRideRequest.dropLocation;

      if (currentLoc != const LatLng(0, 0)) {
        if (currentLoc.latitude < southLat) southLat = currentLoc.latitude;
        if (currentLoc.latitude > northLat) northLat = currentLoc.latitude;
        if (currentLoc.longitude < westLng) westLng = currentLoc.longitude;
        if (currentLoc.longitude > eastLng) eastLng = currentLoc.longitude;
      }

      if (pickupLoc != const LatLng(0, 0)) {
        if (pickupLoc.latitude < southLat) southLat = pickupLoc.latitude;
        if (pickupLoc.latitude > northLat) northLat = pickupLoc.latitude;
        if (pickupLoc.longitude < westLng) westLng = pickupLoc.longitude;
        if (pickupLoc.longitude > eastLng) eastLng = pickupLoc.longitude;
      }

      if (dropLoc != const LatLng(0, 0)) {
        if (dropLoc.latitude < southLat) southLat = dropLoc.latitude;
        if (dropLoc.latitude > northLat) northLat = dropLoc.latitude;
        if (dropLoc.longitude < westLng) westLng = dropLoc.longitude;
        if (dropLoc.longitude > eastLng) eastLng = dropLoc.longitude;
      }

      // Add padding to the bounds
      final latPadding = (northLat - southLat) * 0.1;
      final lngPadding = (eastLng - westLng) * 0.1;

      final bounds = LatLngBounds(
        southwest: LatLng(southLat - latPadding, westLng - lngPadding),
        northeast: LatLng(northLat + latPadding, eastLng + lngPadding),
      );

      // First fit bounds
      mapController
          ?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      )
          .then((_) {
        // Then slightly adjust the zoom for better view
        Future.delayed(const Duration(milliseconds: 300), () {
          mapController?.animateCamera(
            CameraUpdate.zoomBy(-0.3),
          );
        });
      });
    } else {
      // Fallback to current location if no polyline
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _rideTrackingScreenVM.currentLocation,
            zoom: 15,
          ),
        ),
      );
    }
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('current_location'),
        position: _rideTrackingScreenVM.currentLocation,
        icon: sourceIcon,
        // Ensure smooth rotation by using the bearing from LocationService
        rotation: _rideTrackingScreenVM.currentDirection,
        flat: true, // Makes the marker rotate smoothly
        anchor: const Offset(0.5, 0.5), // Centers the marker icon
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _rideTrackingScreenVM.currentRideRequest.dropLocation,
        icon: destinationIcon,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    };
  }

  Set<Polyline> _buildPolylines() {
    return {
      Polyline(
        polylineId: const PolylineId("route"),
        points: _rideTrackingScreenVM.polypoints,
        color: Styles.primaryColor,
        width: 3,
      )
    };
  }

  Widget _buildCustomerDetails(BuildContext context) {
    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUI.h(16, context),
          horizontal: ResponsiveUI.w(16, context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Customer Image
            ClipOval(
              child: Image.network(
                _rideTrackingScreenVM.currentRideRequest.pilotImageUrl!,
                width: ResponsiveUI.w(54, context),
                height: ResponsiveUI.h(54, context),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: ResponsiveUI.w(54, context),
                    height: ResponsiveUI.h(54, context),
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                  );
                },
              ),
            ),
            // Customer Details
            SizedBox(width: ResponsiveUI.w(8, context)), // Added for spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _rideTrackingScreenVM.currentRideRequest.pilotName??"",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ResponsiveUI.w(16, context),
                      fontFamily: "MontserratBold",
                    ),
                  ),
                  SizedBox(height: ResponsiveUI.h(4, context)),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppConstants.ratingsIcon,
                        width: ResponsiveUI.w(24, context),
                        height: ResponsiveUI.h(24, context),
                      ),
                      SizedBox(
                          width: ResponsiveUI.w(4, context)), // Added spacing
                      Text(
                        _rideTrackingScreenVM.currentRideRequest.pilotRatings!,
                        style: TextStyle(
                          color: Styles.primaryColor,
                          fontSize: ResponsiveUI.w(17, context),
                          fontFamily: "MontserratRegular",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Call Icon
            GestureDetector(
              onTap: () {
                _rideTrackingScreenVM.launchDialer(
                  _rideTrackingScreenVM.currentRideRequest.pilotContactNumber,
                );
              },
              child: SvgPicture.asset(
                AppConstants.phoneIcon,
                width: ResponsiveUI.w(36, context),
                height: ResponsiveUI.h(36, context),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOTPContainer(BuildContext context) {
    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: ResponsiveUI.h(30, context)),
        child: Container(
          width: ResponsiveUI.w(402, context),
          height: ResponsiveUI.h(95, context),
          color: Color.fromRGBO(0, 0, 0, 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Styles.blackPrimary,
                    fontSize: ResponsiveUI.sp(16, context),
                    fontFamily: "MontserratBold"),
              ),
              Pinput(
                  readOnly: true,
                  length: 4,
                  controller: pinController,
                  onChanged: (value) {},
                  defaultPinTheme: PinTheme(
                      width: ResponsiveUI.w(44, context),
                      height: ResponsiveUI.h(53, context),
                      textStyle: TextStyle(
                        color: Styles.backgroundWhite,
                        fontFamily: "MontserratBold",
                        fontSize: ResponsiveUI.sp(24, context),
                      ),
                      decoration: BoxDecoration(
                          color: Styles.blackPrimary,
                          border: Border.all(color: Styles.secondaryColor),
                          borderRadius: BorderRadius.circular(
                              ResponsiveUI.r(10, context))))),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _rideTrackingScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
                children: [
                  Container(
                    height:
                        MediaQuery.of(context).size.height * mapHeightFraction,
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        _onMapCreated(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: _rideTrackingScreenVM.currentLocation,
                        bearing: _rideTrackingScreenVM.currentDirection,
                        zoom: 13.5,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('current_location'),
                          position: _rideTrackingScreenVM.currentLocation,
                          icon: sourceIcon,
                          // Ensure smooth rotation by using the bearing from LocationService
                          rotation: _rideTrackingScreenVM.currentDirection,
                          flat: true, // Makes the marker rotate smoothly
                          anchor:
                              const Offset(0.5, 0.5), // Centers the marker icon
                          infoWindow:
                              const InfoWindow(title: 'Current Location'),
                        ),
                        Marker(
                          markerId: const MarkerId('destination'),
                          position: _rideTrackingScreenVM
                              .currentRideRequest.dropLocation,
                          icon: destinationIcon,
                          anchor: const Offset(0.5, 0.5),
                          infoWindow: const InfoWindow(title: 'Destination'),
                        ),
                        if (_rideTrackingScreenVM.pilotLocation.latitude != 0.0)
                          Marker(
                            markerId: const MarkerId('pilotlocaion'),
                            position: _rideTrackingScreenVM.pilotLocation,
                            icon: pilotLocation,
                            anchor: const Offset(0.5, 0.5),
                            infoWindow:
                                const InfoWindow(title: 'PilotLocation'),
                          ),
                      },
                      polylines: _buildPolylines(),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.45,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10)
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: ResponsiveUI.h(40, context),
                                    bottom: ResponsiveUI.h(10, context)),
                                child: Text(
                                  "Pilots is heading to your locations",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(20, context),
                                      fontFamily: "MontserratSemiBold"),
                                ),
                              ),
                              Text(
                                "Pilot arriving in ${_rideTrackingScreenVM.duration}",
                                style: TextStyle(
                                    color: Color.fromRGBO(30, 30, 30, 1),
                                    fontSize: ResponsiveUI.sp(13, context),
                                    fontFamily: "MontserratRegular"),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveUI.h(10, context)),
                                child: Text(
                                  '${_rideTrackingScreenVM.vehicleInfo.vehicleName} ${_rideTrackingScreenVM.vehicleDetails.vehicleModel}',
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(13, context),
                                      fontFamily: "MontserratSemiBold"),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              _buildCustomerDetails(context),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveUI.h(10, context)),
                                  child: _buildOTPContainer(context)),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(16, context),
                                    vertical: ResponsiveUI.h(15, context)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(15, context),
                                    vertical: ResponsiveUI.h(15, context)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ride",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        ),
                                        Text(
                                          "Zappy Auto",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: ResponsiveUI.h(17, context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Payment",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        ),
                                        Text(
                                          "Online",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(16, context)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(15, context),
                                    vertical: ResponsiveUI.h(15, context)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Trip Fare",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        ),
                                        Text(
                                          '₹ ${_rideTrackingScreenVM.currentRideRequest.fare.toString()}',
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(16, context),
                                              fontFamily: "MontserratSemiBold"),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: ResponsiveUI.h(17, context),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Discount",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        ),
                                        Text(
                                          "₹ 0.00",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(16, context),
                                              fontFamily: "MontserratSemiBold"),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Paid",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratRegular"),
                                        ),
                                        Text(
                                          "₹ ${_rideTrackingScreenVM.currentRideRequest.fare.toString()}",
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(16, context),
                                              fontFamily: "MontserratSemiBold"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveUI.h(20, context)),
                                child: FilledButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Color.fromRGBO(46, 46, 46, 1)),
                                      fixedSize: WidgetStatePropertyAll(Size(
                                          ResponsiveUI.w(367, context),
                                          ResponsiveUI.h(60, context))),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              ResponsiveUI.r(10, context)),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CancellationReasonScreen()));
                                    },
                                    child: Text(
                                      "Cancel Ride",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              ResponsiveUI.sp(14, context),
                                          fontFamily: "MontserratSemiBold"),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
    });
  }
}

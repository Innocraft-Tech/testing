import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/CashCollectScreen/CashCollectScreenVM.dart';
import 'package:zappy/Pages/CashCollectScreen/DependentViews/RideCard.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class CashCollectScreen extends StatefulWidget {
  final extraData;
  CashCollectScreen({super.key, required this.extraData});

  @override
  State<CashCollectScreen> createState() => _CashCollectScreenState();
}

class _CashCollectScreenState extends State<CashCollectScreen> {
  GoogleMapController? mapController;
  bool _isMapReady = false;
  late CashCollectScreenVM _cashCollectScreenVM;
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cashCollectScreenVM = CashCollectScreenVM(widget.extraData);
    _loadMapData();
    _cashCollectScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPopAndRemoveUntil) {
        context.pushAndRemoveUntil(
            pageConfig: event.pageConfig,
            removeUntilpageConfig: event.removeUntilpageConfig,
            data: event.data);
      } else if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      }
    });
  }

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

  void fitMapToBounds() {
    if (!_isMapReady || mapController == null) return;

    // Calculate bounds including all relevant points
    double southLat = double.infinity;
    double westLng = double.infinity;
    double northLat = -double.infinity;
    double eastLng = -double.infinity;

    // Include current location
    final currentLoc = _cashCollectScreenVM.currentLocation;
    if (currentLoc != const LatLng(0, 0)) {
      southLat = min(southLat, currentLoc.latitude);
      westLng = min(westLng, currentLoc.longitude);
      northLat = max(northLat, currentLoc.latitude);
      eastLng = max(eastLng, currentLoc.longitude);
    }

    // Add padding
    final latPadding = (northLat - southLat) * 0.2;
    final lngPadding = (eastLng - westLng) * 0.2;

    final bounds = LatLngBounds(
      southwest: LatLng(southLat - latPadding, westLng - lngPadding),
      northeast: LatLng(northLat + latPadding, eastLng + lngPadding),
    );

    // Animate camera with bounds
    mapController
        ?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 25),
    )
        .then((_) {
      // Optional: Slightly adjust zoom for better view
      Future.delayed(const Duration(milliseconds: 300), () {
        mapController?.animateCamera(
          CameraUpdate.zoomBy(-0.1),
        );
      });
    });
  }

  Future<void> _loadMapData() async {
    try {
      sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 20)),
        AppConstants.sourceIcon,
      );
      destinationIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(20, 20)),
          AppConstants.destinationIcon);
    } catch (e) {
      debugPrint('Error loading map data: $e');
    }
  }

  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: const MarkerId('source'),
        position: _cashCollectScreenVM.currentLocation,
        icon: sourceIcon,
        // Ensure smooth rotation by using the bearing from LocationService
        flat: true, // Makes the marker rotate smoothly
        anchor: const Offset(0.5, 0.5), // Centers the marker icon
        infoWindow: const InfoWindow(title: 'Source'),
      ),
      if (_cashCollectScreenVM.currentRideRequest.pickupLocation !=
          const LatLng(0, 0))
        Marker(
          markerId: const MarkerId('destination'),
          position: _cashCollectScreenVM.currentRideRequest.pickupLocation,
          icon: destinationIcon,
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _cashCollectScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _onMapCreated(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _cashCollectScreenVM.currentLocation,
                    zoom: 13.5,
                  ),
                  markers: _buildMarkers(),
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.75,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppConstants.cashCollection,
                            width: ResponsiveUI.w(96, context),
                            height: ResponsiveUI.h(96, context),
                          ),
                          Text(
                            '₹ ${_cashCollectScreenVM.currentRideRequest.fare}'
                                .toString(),
                            style: TextStyle(
                                color: Styles.blackPrimary,
                                fontSize: ResponsiveUI.sp(36, context),
                                fontFamily: "MontserratBold"),
                          ),
                          Text(
                            'Pay Driver using Cash / UPI'.toString(),
                            style: TextStyle(
                                color: Color.fromRGBO(30, 30, 30, 1),
                                fontSize: ResponsiveUI.sp(13, context),
                                fontFamily: "MontserratRegular"),
                          ),
                          RideCard(
                              ride: _cashCollectScreenVM.currentRideRequest),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    _cashCollectScreenVM
                                        .navigateToRideRatingsScreen();
                                  },
                                  style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(
                                        ResponsiveUI.w(97, context),
                                        ResponsiveUI.h(60, context))),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                ResponsiveUI.r(10, context)))),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color.fromRGBO(134, 132, 144,
                                            1)), // Fixed typo: WidgetStatePropertyAll -> MaterialStatePropertyAll
                                  ),
                                  child: Text(
                                    "Skip",
                                    style: TextStyle(
                                      fontFamily: "MontserratBold",
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontWeight: FontWeight.w400,
                                      color: Styles.backgroundPrimary,
                                      height: 17 / 14,
                                    ),
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    _cashCollectScreenVM
                                        .navigateToPilotRatingsScreen();
                                  },
                                  style: ButtonStyle(
                                    fixedSize: WidgetStatePropertyAll(Size(
                                        ResponsiveUI.w(262, context),
                                        ResponsiveUI.h(60, context))),
                                    shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                ResponsiveUI.r(10, context)))),
                                    backgroundColor: WidgetStatePropertyAll(Styles
                                        .primaryColor), // Fixed typo: WidgetStatePropertyAll -> MaterialStatePropertyAll
                                  ),
                                  child: Text(
                                    "Rate your Pilot",
                                    style: TextStyle(
                                      fontFamily: "MontserratBold",
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontWeight: FontWeight.w400,
                                      color: Styles.backgroundPrimary,
                                      height: 17 / 14,
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ));
    });
  }
}

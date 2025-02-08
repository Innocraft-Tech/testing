import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/PilotFindingScreen/DependentViews/BookingActions.dart';
import 'package:zappy/Pages/PilotFindingScreen/DependentViews/PriceSelector.dart';
import 'package:zappy/Pages/PilotFindingScreen/PilotFindingScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class PilotFindingScreen extends StatefulWidget {
  final extraData;
  PilotFindingScreen({super.key, required this.extraData});

  @override
  State<PilotFindingScreen> createState() => _PilotFindingScreenState();
}

class _PilotFindingScreenState extends State<PilotFindingScreen> {
  late PilotFindingScreenVM _pilotFindingScreenVM;
  double mapHeightFraction = 0.7;
  GoogleMapController? mapController;
  bool _isMapReady = false;
  BitmapDescriptor? sourceIcon; // Remove 'late'
  BitmapDescriptor? destinationIcon; // Remove 'late'
  bool _areIconsLoaded = false;
  TextEditingController ownFareController = TextEditingController();

  Future<void> _loadMapData() async {
    try {
      sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(20, 20)),
        AppConstants.sourceIcon,
      );
      destinationIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(20, 20)),
          AppConstants.destinationIcon);
      setState(() {
        _areIconsLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading map data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pilotFindingScreenVM = PilotFindingScreenVM(widget.extraData[0],
        widget.extraData[1], widget.extraData[2], widget.extraData[3],widget.extraData[4]);
    _loadMapData();
    _pilotFindingScreenVM.addListener(() {
      fitMapToBounds();
    });
    _pilotFindingScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      }
    });
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
    if (_pilotFindingScreenVM.polypoints.isNotEmpty) {
      double southLat = _pilotFindingScreenVM.polypoints.first.latitude;
      double westLng = _pilotFindingScreenVM.polypoints.first.longitude;
      double northLat = _pilotFindingScreenVM.polypoints.first.latitude;
      double eastLng = _pilotFindingScreenVM.polypoints.first.longitude;

      // Find the bounds of all points
      for (LatLng point in _pilotFindingScreenVM.polypoints) {
        if (point.latitude < southLat) southLat = point.latitude;
        if (point.latitude > northLat) northLat = point.latitude;
        if (point.longitude < westLng) westLng = point.longitude;
        if (point.longitude > eastLng) eastLng = point.longitude;
      }

      // Include current location and pickup/drop locations in bounds
      final currentLoc = _pilotFindingScreenVM.sourceLocation;
      final pickupLoc = _pilotFindingScreenVM.currentRide.pickupLocation;
      final dropLoc = _pilotFindingScreenVM.currentRide.dropLocation;

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
            target: _pilotFindingScreenVM.sourceLocation,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void fitMapToBounds() {
    if (!_isMapReady || mapController == null) return;

    if (_pilotFindingScreenVM.polypoints.isEmpty) {
      _updateCameraPosition(_pilotFindingScreenVM.sourceLocation);
      return;
    }

    // Initialize bounds with first point
    double southLat = _pilotFindingScreenVM.polypoints[0].latitude;
    double westLng = _pilotFindingScreenVM.polypoints[0].longitude;
    double northLat = _pilotFindingScreenVM.polypoints[0].latitude;
    double eastLng = _pilotFindingScreenVM.polypoints[0].longitude;

    // Include all polyline points
    for (LatLng point in _pilotFindingScreenVM.polypoints) {
      southLat = min(southLat, point.latitude);
      westLng = min(westLng, point.longitude);
      northLat = max(northLat, point.latitude);
      eastLng = max(eastLng, point.longitude);
    }

    // Add current location to bounds
    final currentLoc = _pilotFindingScreenVM.sourceLocation;
    if (currentLoc != const LatLng(0, 0)) {
      southLat = min(southLat, currentLoc.latitude);
      westLng = min(westLng, currentLoc.longitude);
      northLat = max(northLat, currentLoc.latitude);
      eastLng = max(eastLng, currentLoc.longitude);
    }

    // Add pickup and drop locations to bounds
    final pickupLoc = _pilotFindingScreenVM.currentRide.pickupLocation;
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

  Set<Marker> _buildMarkers() {
    if (!_areIconsLoaded) return {};
    return {
      Marker(
        markerId: const MarkerId('source'),
        position: _pilotFindingScreenVM.sourceLocation,
        icon: sourceIcon!,
        // Ensure smooth rotation by using the bearing from LocationService
        // rotation: _pilotFindingScreenVM.currentDirection,
        flat: true, // Makes the marker rotate smoothly
        anchor: const Offset(0.5, 0.5), // Centers the marker icon
        infoWindow: const InfoWindow(title: 'Source'),
      ),
      Marker(
        markerId: const MarkerId('destination'),
        position: _pilotFindingScreenVM.destinationLocation,
        icon: destinationIcon!,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Destination'),
      ),
    };
  }

  Set<Polyline> _buildPolylines() {
    return {
      Polyline(
        polylineId: const PolylineId("route"),
        points: _pilotFindingScreenVM.polypoints,
        color: Styles.primaryColor,
        width: 3,
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _pilotFindingScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
              children: [
                Container(
                  height:
                      MediaQuery.of(context).size.height * mapHeightFraction,
                  child: Observer(builder: (context) {
                    return GoogleMap(
                      onMapCreated: (controller) {
                        _onMapCreated(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: _pilotFindingScreenVM.sourceLocation,
                        zoom: 13.5,
                      ),
                      markers: _buildMarkers(),
                      polylines: _buildPolylines(),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    );
                  }),
                ),
                // _buildPilotsList(),

                Observer(builder: (context) {
                  if (_pilotFindingScreenVM.pilots.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return Positioned(
                      top: ResponsiveUI.h(65, context),
                      left: ResponsiveUI.w(20, context),
                      right:
                          ResponsiveUI.w(20, context), // Added right constraint
                      child: SizedBox(
                        height: ResponsiveUI.h(480, context),
                        child: ListView.builder(
                          itemCount: _pilotFindingScreenVM.pilots.length,
                          itemBuilder: (context, index) {
                            return _pilotFindingScreenVM.pilots[index].timer !=
                                    0
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: ResponsiveUI.h(5, context)),
                                    child: Container(
                                      // height: ResponsiveUI.h(187, context),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize
                                            .min, // Added to prevent vertical expansion
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "₹ ${_pilotFindingScreenVM.pilots[index].fare}",
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(25, context),
                                              fontFamily: "MontserratBold",
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  ResponsiveUI.h(5, context)),
                                          ConstrainedBox(
                                            // Added constraints for the Row
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  ResponsiveUI.w(40, context),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize
                                                  .min, // Added to prevent horizontal expansion
                                              children: [
                                                ClipOval(
                                                  child: Image.network(
                                                    _pilotFindingScreenVM
                                                            .pilots[index]
                                                            .pilotImageUrl ??
                                                        '',
                                                    width: ResponsiveUI.w(
                                                        30, context),
                                                    height: ResponsiveUI.h(
                                                        30, context),
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Container(
                                                        width: ResponsiveUI.w(
                                                            30, context),
                                                        height: ResponsiveUI.h(
                                                            30, context),
                                                        color: Colors.grey[300],
                                                        child: Icon(
                                                            Icons.person,
                                                            color: Colors
                                                                .grey[600]),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: ResponsiveUI.w(
                                                        10, context)),
                                                Flexible(
                                                  // Replaced Expanded with Flexible
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _pilotFindingScreenVM
                                                              .pilots[index]
                                                              .pilotName,
                                                          style: TextStyle(
                                                            fontSize:
                                                                ResponsiveUI.sp(
                                                                    14,
                                                                    context),
                                                            fontFamily:
                                                                "MontserratBold",
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // Added overflow handling
                                                        ),
                                                        Text(
                                                          _pilotFindingScreenVM
                                                              .pilots[index]
                                                              .vehicle,
                                                          style: TextStyle(
                                                            fontSize:
                                                                ResponsiveUI.sp(
                                                                    14,
                                                                    context),
                                                            fontFamily:
                                                                "MontserratRegular",
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis, // Added overflow handling
                                                        ),
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  ResponsiveUI.h(10, context)),
                                          SizedBox(
                                            // Added constraints for BookingActions
                                            width: double.infinity,
                                            child: Observer(builder: (context) {
                                              return BookingActions(
                                                extraData: [
                                                  _pilotFindingScreenVM
                                                      .pilots[index].timer,
                                                  () => _pilotFindingScreenVM
                                                      .acceptRide(
                                                          _pilotFindingScreenVM
                                                              .pilots[index]),
                                                  () => _pilotFindingScreenVM
                                                      .declineFare(
                                                          _pilotFindingScreenVM
                                                              .pilots[index])
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                      ));
                }),
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      mapHeightFraction = 1.0 - notification.extent;
                    });
                    fitMapToBounds();
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.38,
                    minChildSize: 0.38,
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
                          child: Container(
                            child: PriceSelector(
                              isFareLoading:
                                  _pilotFindingScreenVM.isFareLoading,
                              minPrice:
                                  double.parse(_pilotFindingScreenVM.price),
                              maxPrice: 10000,
                              onPriceChanged: (p0) {},
                              onSubmit: (p0) {
                                _pilotFindingScreenVM.updateRadeFare(p0);
                              },
                              initialPrice:
                                  double.parse(_pilotFindingScreenVM.price),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ));
    });
  }

  Widget _buildPilotsList() {
    return Observer(
      builder: (context) {
        if (_pilotFindingScreenVM.pilots.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ResponsiveUI.w(20, context),
            vertical: ResponsiveUI.h(10, context),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _pilotFindingScreenVM.pilots.length,
            itemBuilder: (context, index) {
              final pilot = _pilotFindingScreenVM.pilots[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveUI.h(10, context),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹ ${pilot.fare}",
                        style: TextStyle(
                          fontSize: ResponsiveUI.sp(35, context),
                          fontFamily: "MontserratBold",
                        ),
                      ),
                      SizedBox(height: ResponsiveUI.h(10, context)),
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              pilot.pilotImageUrl ?? '',
                              width: ResponsiveUI.w(40, context),
                              height: ResponsiveUI.h(40, context),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: ResponsiveUI.w(40, context),
                                  height: ResponsiveUI.h(40, context),
                                  color: Colors.grey[300],
                                  child: Icon(Icons.person,
                                      color: Colors.grey[600]),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: ResponsiveUI.w(10, context)),
                          Expanded(
                            child: Text(
                              pilot.pilotName,
                              style: TextStyle(
                                fontSize: ResponsiveUI.sp(18, context),
                                fontFamily: "MontserratBold",
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveUI.h(10, context)),
                      BookingActions(
                        extraData: [
                          _pilotFindingScreenVM.rideId,
                          _pilotFindingScreenVM.acceptRide(pilot),
                          _pilotFindingScreenVM.declineFare
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

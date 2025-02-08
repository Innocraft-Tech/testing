import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/BOs/VechileBO/VechileBO.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/HomeScreen/HomeScreenVM.dart';
import 'package:zappy/Pages/ProfileScreen/ProfileScreen.dart';
import 'package:zappy/Pages/RideRatings/RideRatingsScreen.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor capitanIcon = BitmapDescriptor.defaultMarker;
  late final HomeScreenVM _homeScreenVM;
  List<VechileBO> vechicles = [
    VechileBO(
        name: "Auto",
        image: AppConstants.autoIcon,
        price: "50",
        capacity: "3",
        speed: "30"),
    VechileBO(
        name: "Cab",
        image: AppConstants.autoIcon,
        price: "100",
        capacity: "4",
        speed: "60"),
    VechileBO(
        name: "Cab Economy - AC",
        image: AppConstants.autoIcon,
        price: "100",
        capacity: "4",
        speed: "60"),
    VechileBO(
        name: "Cab XUV",
        image: AppConstants.autoIcon,
        price: "100",
        capacity: "4",
        speed: "60"),
    VechileBO(
        name: "Bike",
        image: "assets/images/bike.png",
        price: "10",
        capacity: "1",
        speed: "40"),
  ];

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
      capitanIcon = icon;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.setMapStyle(AppConstants.mapStyle);
    _updateCameraPosition();
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

    if (_homeScreenVM.destinationLocation.latitude != 0) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _homeScreenVM.scourceLocation.latitude <
                  _homeScreenVM.destinationLocation.latitude
              ? _homeScreenVM.scourceLocation.latitude
              : _homeScreenVM.destinationLocation.latitude,
          _homeScreenVM.scourceLocation.longitude <
                  _homeScreenVM.destinationLocation.longitude
              ? _homeScreenVM.scourceLocation.longitude
              : _homeScreenVM.destinationLocation.longitude,
        ),
        northeast: LatLng(
          _homeScreenVM.scourceLocation.latitude >
                  _homeScreenVM.destinationLocation.latitude
              ? _homeScreenVM.scourceLocation.latitude
              : _homeScreenVM.destinationLocation.latitude,
          _homeScreenVM.scourceLocation.longitude >
                  _homeScreenVM.destinationLocation.longitude
              ? _homeScreenVM.scourceLocation.longitude
              : _homeScreenVM.destinationLocation.longitude,
        ),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _homeScreenVM.scourceLocation,
            zoom: 15,
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_homeScreenVM.distance != 0.0) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Cancel Ride Selection?',
            style: TextStyle(
              fontFamily: "MontserratBold",
              fontSize: ResponsiveUI.sp(18, context),
            ),
          ),
          content: Text(
            'Are you sure you want to cancel your ride selection?',
            style: TextStyle(
              fontFamily: "MontserratRegular",
              fontSize: ResponsiveUI.sp(14, context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No',
                style: TextStyle(
                  color: Styles.primaryColor,
                  fontFamily: "MontserratSemiBold",
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // First pop the dialog
                Navigator.pop(context, true);
                // Reset the ride selection
                await _homeScreenVM.resetRideSelection();
                // Update camera position to focus on source location
                if (mounted) {
                  _updateCameraPosition(_homeScreenVM.scourceLocation);
                }
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: "MontserratSemiBold",
                ),
              ),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _homeScreenVM = HomeScreenVM();
    setCustomMarker();
    _homeScreenVM.listActivePilots();
    // Set up location update callback
    _homeScreenVM.setLocationUpdateCallback((newLocation) {
      if (mapController != null) {
        _updateCameraPosition(newLocation);
      }
    });
    _homeScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPush) {
        context.push(pageConfig: event.pageConfig, data: event.data);
      }
    });

    // Listen to location changes
    _homeScreenVM.addListener(() {
      _updateCameraPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _homeScreenVM.isLoading
          ? Loader()
          : Scaffold(
              appBar: null,
              body: Stack(
                children: [
                  Observer(
                    builder: (context) => GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _homeScreenVM.scourceLocation,
                        zoom: 13.5,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('source'),
                          position: _homeScreenVM.scourceLocation,
                          icon: sourceIcon,
                          infoWindow: const InfoWindow(title: 'Source'),
                        ),
                        if (_homeScreenVM.destinationLocation.latitude != 0)
                          Marker(
                            markerId: const MarkerId('destination'),
                            position: _homeScreenVM.destinationLocation,
                            icon: destinationIcon,
                            infoWindow: const InfoWindow(title: 'Destination'),
                          ),
                        ..._homeScreenVM.capitansAreLive.asMap().entries.map(
                              (entry) => Marker(
                                markerId: MarkerId('capitan_${entry.key}'),
                                position: entry.value,
                                icon: capitanIcon,
                                infoWindow: const InfoWindow(title: 'Capitan'),
                              ),
                            ),
                        ..._homeScreenVM.capitansAreLiveForAuto
                            .asMap()
                            .entries
                            .map(
                              (entry) => Marker(
                                markerId: MarkerId('capitan_${entry.key}'),
                                position: entry.value,
                                icon: capitanIcon,
                                infoWindow: const InfoWindow(title: 'Capitan'),
                              ),
                            ),
                      },
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId("route"),
                          points: _homeScreenVM.polypoints,
                          color: Styles.primaryColor,
                          width: 3,
                        )
                      },
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                  ),

                  // Rest of your UI components remain exactly the same...
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUI.w(16, context),
                          vertical: ResponsiveUI.h(10, context),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              AppConstants.menuIcon,
                              width: ResponsiveUI.w(24, context),
                              height: ResponsiveUI.h(24, context),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return ProfileScreen();
                                  },
                                ));
                              },
                              child: SvgPicture.asset(
                                AppConstants.profileIcon,
                                width: ResponsiveUI.w(24, context),
                                height: ResponsiveUI.h(24, context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: ResponsiveUI.h(290, context),
                      right: ResponsiveUI.w(16, context),
                      child: Image.asset(
                        AppConstants.sosAlarm,
                        width: ResponsiveUI.w(38, context),
                        height: ResponsiveUI.h(38, context),
                      )),

                  DraggableScrollableSheet(
                    initialChildSize:
                        _homeScreenVM.distance != 0.0 ? 0.53 : 0.4,
                    minChildSize: 0.2,
                    maxChildSize: 0.8,
                    snap: true,
                    snapSizes: [0.4, 0.8],
                    builder: (context, scrollController) {
                      return Observer(builder: (context) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(16, context),
                          ),
                          decoration: BoxDecoration(
                            color: _homeScreenVM.distance != 0.0
                                ? Styles.textTertiary
                                : Styles.primaryColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(ResponsiveUI.r(20, context)),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: !_homeScreenVM.isLocationEnabled
                              ? Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: ResponsiveUI.w(370, context),
                                          child: Text(
                                            "Looks like your location permission is required",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(20, context),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "MontserratBold",
                                              height: 24.38 / 15,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "This help us accurately pinpoint your pickup so you can get to booking faster",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(16, context),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "MontserratRegular"),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            _homeScreenVM
                                                .requestLocationPermission();
                                          },
                                          child: Text(
                                            "Give Permission",
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontFamily: "MontserratSemiBold",
                                            ),
                                          ),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Styles.primaryColor),
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                Size(
                                                    ResponsiveUI.w(
                                                        370, context),
                                                    ResponsiveUI.h(
                                                        48, context)),
                                              ),
                                              shape: WidgetStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              ResponsiveUI.r(10,
                                                                  context))))),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : ListView(
                                  padding: EdgeInsets.only(
                                      top: ResponsiveUI.h(12, context)),
                                  controller: scrollController,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: ResponsiveUI.w(60, context),
                                        height: ResponsiveUI.h(10, context),
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: const Color(0xff72727263),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("Called");
                                        _homeScreenVM.navigateToSearchScreen();
                                      },
                                      child: AbsorbPointer(
                                        absorbing:
                                            true, // Prevent the TextFormField from handling taps
                                        child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            focusColor: Styles.secondaryColor,
                                            prefixIcon: SvgPicture.asset(
                                              AppConstants.searchIcon,
                                              width:
                                                  ResponsiveUI.w(20, context),
                                              height:
                                                  ResponsiveUI.h(20, context),
                                            ),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minWidth:
                                                  ResponsiveUI.w(55, context),
                                              minHeight:
                                                  ResponsiveUI.h(20, context),
                                            ),
                                            hintText: "Where are you going to?",
                                            hintStyle: TextStyle(
                                              color: Styles.backgroundWhite,
                                              fontFamily: "MontserratRegular",
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Styles.backgroundPrimary,
                                                width:
                                                    ResponsiveUI.w(1, context),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Styles.backgroundPrimary,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ResponsiveUI.r(10, context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: ResponsiveUI.h(42, context)),
                                    SvgPicture.asset(
                                      AppConstants.appLogo,
                                      width: ResponsiveUI.w(126, context),
                                      height: ResponsiveUI.h(53, context),
                                    ),
                                    SizedBox(
                                        height: ResponsiveUI.h(19, context)),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUI.w(65, context),
                                      ),
                                      width: ResponsiveUI.w(272, context),
                                      height: ResponsiveUI.h(60, context),
                                      child: Text(
                                        "Instant Bookings, Zappy Convenience.",
                                        style: TextStyle(
                                          fontFamily: "MontserratBold",
                                          fontSize:
                                              ResponsiveUI.sp(20, context),
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          height: 30 / 25,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                        height: ResponsiveUI.h(28, context)),
                                    Container(
                                      height: ResponsiveUI.h(40, context),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ResponsiveUI.w(100, context),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Made in India",
                                            style: TextStyle(
                                              fontFamily: "MontserratRegular",
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontWeight: FontWeight.w500,
                                              color: Styles.backgroundPrimary,
                                              height: 17 / 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "Crafted by #Vellore",
                                            style: TextStyle(
                                              fontFamily: "MontserratRegular",
                                              fontSize:
                                                  ResponsiveUI.sp(14, context),
                                              fontWeight: FontWeight.w500,
                                              color: Styles.backgroundPrimary,
                                              height: 17 / 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      });
                    },
                  ),
                ],
              ),
            );
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}

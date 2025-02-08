import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/RideRatings/RideRatingsScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class RideRatingsScreen extends StatefulWidget {
  final extraData;
  const RideRatingsScreen({super.key, required this.extraData});

  @override
  State<RideRatingsScreen> createState() => _RideRatingsScreenState();
}

class _RideRatingsScreenState extends State<RideRatingsScreen> {
  late RideRatingsScreenVM _rideRatingsScreenVM;
  GoogleMapController? mapController;
  bool _isMapReady = false;
  int? selectedMood;

  // You'll need to get these values from your VM
  final String destination = "Voorhees College";
  final String address =
      "27, Officer line Road, Near Darling Electronics, Vellore- 632 001";
  final String duration = "3 Mins";
  final String distance = "2.8 Km";
  final String speed = "22 km/h";

  @override
  void initState() {
    super.initState();
    _rideRatingsScreenVM = RideRatingsScreenVM(widget.extraData);
    _loadMapData();
    _rideRatingsScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPopAndRemoveUntil) {
        context.pushAndRemoveUntil(
            pageConfig: event.pageConfig,
            removeUntilpageConfig: event.removeUntilpageConfig,
            data: event.data);
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isMapReady = true;
    });
  }

  Future<void> _loadMapData() async {
    // Implement your map data loading logic here
  }

  Widget _buildTripInfo() {
    return Container(
      margin: EdgeInsets.only(
          left: ResponsiveUI.w(16, context),
          right: ResponsiveUI.w(16, context),
          top: ResponsiveUI.h(27, context),
          bottom: ResponsiveUI.h(11, context)),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUI.w(15, context),
          vertical: ResponsiveUI.h(20, context)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(
              Utilities.convertMinutesToHours(int.parse(_rideRatingsScreenVM
                  .currentRideRequest.duration!
                  .toStringAsFixed(0))),
              "Duration"),
          _buildInfoItem(
              _rideRatingsScreenVM.currentRideRequest.distance!.split('.')[0],
              "Distance"),
          _buildInfoItem(
              _rideRatingsScreenVM.currentRideRequest.speed!.toStringAsFixed(0),
              "Avg. Speed"),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildInfoItem(String value, String label) {
    return Column(
      children: [
        if (label.toLowerCase() == "duration")
          SvgPicture.asset(
            AppConstants.clockIcon,
            width: ResponsiveUI.w(24, context),
            height: ResponsiveUI.h(24, context),
          ),
        if (label.toLowerCase() == "distance")
          SvgPicture.asset(
            AppConstants.distanceIcon,
            width: ResponsiveUI.w(24, context),
            height: ResponsiveUI.h(24, context),
          ),
        if (label.toLowerCase() == "avg. speed")
          SvgPicture.asset(
            AppConstants.speedIcon,
            width: ResponsiveUI.w(24, context),
            height: ResponsiveUI.h(24, context),
          ),
        const SizedBox(height: 4),
        Text(
          '${value} ${label.toLowerCase() == "distance" ? "km" : label.toLowerCase() == "duration" ? "" : "Km/h"}',
          style: TextStyle(
            fontSize: ResponsiveUI.sp(14, context),
            fontFamily: "MontserratSemiBold",
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
              fontSize: ResponsiveUI.sp(12, context),
              color: Colors.grey[600],
              fontFamily: "MontserratRegular"),
        ),
      ],
    );
  }

  Widget _buildMoodRating() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUI.h(15, context)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "How was your mood during the trip?",
            style: TextStyle(
              fontSize: ResponsiveUI.sp(16, context),
              fontFamily: "MontserratSemiBold",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () => _rideRatingsScreenVM.updateMoodIndex(index),
                child: Observer(builder: (context) {
                  return SvgPicture.asset(
                    index == 0
                        ? AppConstants.veryBod
                        : index == 1
                            ? AppConstants.bad
                            : index == 2
                                ? AppConstants.ok
                                : index == 3
                                    ? AppConstants.good
                                    : AppConstants.veryGood,
                    color: _rideRatingsScreenVM.moodIndex == index
                        ? Styles.primaryColor
                        : Colors.grey,
                    width: ResponsiveUI.w(36, context),
                    height: ResponsiveUI.h(36, context),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _rideRatingsScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _rideRatingsScreenVM
                          .currentLocation, // Vellore coordinates
                      zoom: 15,
                    ),
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.57,
                    minChildSize: 0.3,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 10)
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  const SizedBox(height: 16),
                                  Text(
                                    "You have arrived!",
                                    style: TextStyle(
                                      fontSize: ResponsiveUI.sp(20, context),
                                      fontFamily: "MontserratBold",
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Text(
                                      _rideRatingsScreenVM
                                          .currentRideRequest.dropAddress,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: ResponsiveUI.sp(13, context),
                                        fontFamily: "MontserratRegular",
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  _buildTripInfo(),
                                  _buildMoodRating(),
                                  const SizedBox(height: 32),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _rideRatingsScreenVM
                                            .navigateToHomeScreen();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Styles.primaryColor,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Finish",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -50,
                              left: 100,
                              right: 100,
                              child: SvgPicture.asset(
                                AppConstants.locationMarker,
                                width: ResponsiveUI.w(75, context),
                                height: ResponsiveUI.h(75, context),
                              ),
                            ),
                          ],
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

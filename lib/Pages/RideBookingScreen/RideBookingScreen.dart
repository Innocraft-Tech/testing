import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/VechileBO/VechileBO.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/RideBookingScreen/DependentViews/CustomRupeeController.dart';
import 'package:zappy/Pages/RideBookingScreen/DependentViews/OfferInfo.dart';
import 'package:zappy/Pages/RideBookingScreen/RideBookingSceenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';
import 'package:zappy/Reusables/Popup/Popup.dart';

class RideBookingScreen extends StatefulWidget {
  List extraData;
  RideBookingScreen({super.key, required this.extraData});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  GoogleMapController? mapController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor capitanIcon = BitmapDescriptor.defaultMarker;
  late final RideBookingScreenVM _rideBookingScreenVM;
  ScrollController _scrollController = ScrollController();
  TextEditingController fareController = TextEditingController();
  FocusNode fareFocusNode = FocusNode();
  // List<VechileBO> vechicles = [
  //   VechileBO(
  //       name: "Auto",
  //       image: AppConstants.autoIcon,
  //       price: "50",
  //       capacity: "3",
  //       speed: "30"),
  //   VechileBO(
  //       name: "Cab",
  //       image: AppConstants.autoIcon,
  //       price: "100",
  //       capacity: "4",
  //       speed: "60"),
  //   VechileBO(
  //       name: "Cab Economy - AC",
  //       image: AppConstants.autoIcon,
  //       price: "100",
  //       capacity: "4",
  //       speed: "60"),
  //   VechileBO(
  //       name: "Cab XUV",
  //       image: AppConstants.autoIcon,
  //       price: "100",
  //       capacity: "4",
  //       speed: "60"),
  //   VechileBO(
  //       name: "Bike",
  //       image: "assets/images/bike.png",
  //       price: "10",
  //       capacity: "1",
  //       speed: "40"),
  // ];

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: ResponsiveUI.h(0, context)),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: ResponsiveUI.h(8, context)),
          child: Container(
            height: ResponsiveUI.h(80, context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(ResponsiveUI.r(5, context)),
              ),
            ),
          ),
        );
      },
    );
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
            ImageConfiguration.empty, AppConstants.capitanIcon)
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

    if (_rideBookingScreenVM.destinationLocation.latitude != 0) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _rideBookingScreenVM.scourceLocation.latitude <
                  _rideBookingScreenVM.destinationLocation.latitude
              ? _rideBookingScreenVM.scourceLocation.latitude
              : _rideBookingScreenVM.destinationLocation.latitude,
          _rideBookingScreenVM.scourceLocation.longitude <
                  _rideBookingScreenVM.destinationLocation.longitude
              ? _rideBookingScreenVM.scourceLocation.longitude
              : _rideBookingScreenVM.destinationLocation.longitude,
        ),
        northeast: LatLng(
          _rideBookingScreenVM.scourceLocation.latitude >
                  _rideBookingScreenVM.destinationLocation.latitude
              ? _rideBookingScreenVM.scourceLocation.latitude
              : _rideBookingScreenVM.destinationLocation.latitude,
          _rideBookingScreenVM.scourceLocation.longitude >
                  _rideBookingScreenVM.destinationLocation.longitude
              ? _rideBookingScreenVM.scourceLocation.longitude
              : _rideBookingScreenVM.destinationLocation.longitude,
        ),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _rideBookingScreenVM.scourceLocation,
            zoom: 15,
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_rideBookingScreenVM.distance != 0.0) {
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
                await _rideBookingScreenVM.resetRideSelection();
                // Update camera position to focus on source location
                if (mounted) {
                  _updateCameraPosition(_rideBookingScreenVM.scourceLocation);
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
    fareController = CustomRupeeController();
    _rideBookingScreenVM = RideBookingScreenVM(widget.extraData);
    setCustomMarker();
    _rideBookingScreenVM.discoverCapitans();
    // Set up location update callback
    _rideBookingScreenVM.setLocationUpdateCallback((newLocation) {
      if (mapController != null) {
        _updateCameraPosition(newLocation);
      }
    });
    _rideBookingScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPush) {
        context.push(pageConfig: event.pageConfig, data: event.data);
      } else if (event is NavigatorPop) {
        context.pop();
      } else if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      }
    });
    _rideBookingScreenVM.popUpController.stream.listen((event) {
      if (event is ShowPopupWithSingleAction) {
        showPopupWithSingleAction(context, event);
      }
    });

    // Listen to location changes
    _rideBookingScreenVM.addListener(() {
      _updateCameraPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: null,
        body: SafeArea(
          child: Stack(
            children: [
              Observer(builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUI.w(16, context),
                  ),
                  decoration: BoxDecoration(
                    color: Styles.backgroundWhite,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ResponsiveUI.r(20, context)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Styles.textTertiary.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ResponsiveUI.h(14, context),
                      bottom: ResponsiveUI.h(14, context),
                    ),
                    child: Container(
                      color: Styles.backgroundWhite,
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: ResponsiveUI.w(60, context),
                              height: ResponsiveUI.h(10, context),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: const Color(0xff72727263),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Text(
                            "Choose your trip and swipe more",
                            style: TextStyle(
                              color: Styles.textTertiary,
                              fontSize: ResponsiveUI.sp(20, context),
                              fontFamily: "MontserratBold",
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveUI.h(19, context),
                              horizontal: ResponsiveUI.w(16, context),
                            ),
                            child: Divider(
                              color: Styles.textLightGrey,
                              thickness: 0.5,
                            ),
                          ),
                          Expanded(
                            child: _rideBookingScreenVM.isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: _buildShimmerList(),
                                  )
                                : ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveUI.h(0, context),
                                    ),
                                    itemCount:
                                        _rideBookingScreenVM.vehicleList.length,
                                    itemBuilder: (context, index) {
                                      return Observer(builder: (context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: index ==
                                                    _rideBookingScreenVM
                                                        .selectedVehicleIndex
                                                ? Styles.selectedVehicleColor
                                                : Colors.transparent,
                                            border: Border.all(
                                                width:
                                                    ResponsiveUI.w(2, context),
                                                color: index ==
                                                        _rideBookingScreenVM
                                                            .selectedVehicleIndex
                                                    ? Styles.blueBorderColor
                                                    : Styles.transparent),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                ResponsiveUI.r(5, context),
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  _rideBookingScreenVM
                                                      .setSelectedVehicleIndex(
                                                          index);
                                                  _rideBookingScreenVM
                                                      .setIsOwnFare(false);
                                                },
                                                selected: index ==
                                                        _rideBookingScreenVM
                                                            .selectedVehicleIndex
                                                    ? true
                                                    : false,
                                                selectedColor:
                                                    Styles.textLightGrey,
                                                leading: SvgPicture.network(
                                                  _rideBookingScreenVM
                                                      .vehicleList[index].image,
                                                  width: ResponsiveUI.w(
                                                      48, context),
                                                  height: ResponsiveUI.h(
                                                      48, context),
                                                ),
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      _rideBookingScreenVM
                                                          .vehicleList[index]
                                                          .name,
                                                      style: TextStyle(
                                                          color: Styles
                                                              .blackPrimary,
                                                          fontSize:
                                                              ResponsiveUI.sp(
                                                                  14, context),
                                                          fontFamily:
                                                              "MontserratBold"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  ResponsiveUI.w(
                                                                      4,
                                                                      context),
                                                              vertical:
                                                                  ResponsiveUI.h(
                                                                      4,
                                                                      context)),
                                                      child: SvgPicture.asset(
                                                        AppConstants.userCount,
                                                        color:
                                                            Styles.blackPrimary,
                                                        width: ResponsiveUI.w(
                                                            10, context),
                                                        height: ResponsiveUI.h(
                                                            10, context),
                                                      ),
                                                    ),
                                                    Text(
                                                      _rideBookingScreenVM
                                                          .vehicleList[index]
                                                          .capacity,
                                                      style: TextStyle(
                                                          color: Styles
                                                              .textTertiary,
                                                          fontSize:
                                                              ResponsiveUI.sp(
                                                                  10, context),
                                                          fontFamily:
                                                              "MontserratSemiBold"),
                                                    )
                                                  ],
                                                ),
                                                subtitle: Text(
                                                  "${Utilities.calculateDropTime('${_rideBookingScreenVM.vehicleList[index].name} Cab', _rideBookingScreenVM.distance)}",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                      fontSize: ResponsiveUI.sp(
                                                          12, context),
                                                      fontFamily:
                                                          "MontserratRegular"),
                                                ),
                                                trailing: Text(
                                                  "₹ ${(Utilities.calculatePrice(_rideBookingScreenVM.vehicleList[index].name, _rideBookingScreenVM.distance)).toStringAsFixed(0)}",
                                                  style: TextStyle(
                                                      color:
                                                          Styles.blackPrimary,
                                                      fontSize: ResponsiveUI.sp(
                                                          16, context),
                                                      fontFamily:
                                                          "MontserratBold"),
                                                ),
                                              ),
                                              if (_rideBookingScreenVM
                                                          .selectedVehicleIndex ==
                                                      index &&
                                                  _rideBookingScreenVM
                                                      .isOwnFare)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          ResponsiveUI.w(
                                                              20, context)),
                                                  child: TextFormField(
                                                    onChanged: (value) {},
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    controller: fareController,
                                                    focusNode: fareFocusNode,
                                                    onTapOutside: (event) =>
                                                        fareFocusNode.unfocus(),
                                                    style: TextStyle(
                                                      fontSize: ResponsiveUI.sp(
                                                          30, context),
                                                      fontFamily:
                                                          "MontserratBold",
                                                      color:
                                                          Styles.blackPrimary,
                                                    ),
                                                    decoration: InputDecoration(
                                                        focusColor:
                                                            Colors.black,
                                                        fillColor: Colors.black,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey))),
                                                  ),
                                                )
                                              else if (_rideBookingScreenVM
                                                      .selectedVehicleIndex ==
                                                  index)
                                                FilledButton(
                                                  onPressed: () {
                                                    _rideBookingScreenVM
                                                        .setIsOwnFare(true);
                                                  },
                                                  style: ButtonStyle(
                                                    fixedSize:
                                                        WidgetStatePropertyAll(
                                                            Size(
                                                                ResponsiveUI.w(
                                                                    330,
                                                                    context),
                                                                ResponsiveUI.h(
                                                                    50,
                                                                    context))),
                                                    shape:
                                                        WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          ResponsiveUI.r(
                                                              10, context),
                                                        ),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        WidgetStatePropertyAll(
                                                      Styles.greenButtonColor,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "Offer your Fare",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "MontserratBold",
                                                      fontSize: ResponsiveUI.sp(
                                                          14, context),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Styles
                                                          .backgroundPrimary,
                                                      height: 17 / 14,
                                                    ),
                                                  ),
                                                ),
                                              if (_rideBookingScreenVM
                                                      .selectedVehicleIndex ==
                                                  index)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          ResponsiveUI.w(
                                                              20, context),
                                                      vertical: ResponsiveUI.h(
                                                          18, context)),
                                                  child: buildInfoBox(
                                                      context,
                                                      (Utilities.calculatePrice(
                                                              _rideBookingScreenVM
                                                                  .vehicleList[
                                                                      index]
                                                                  .name,
                                                              _rideBookingScreenVM
                                                                  .distance))
                                                          .toStringAsFixed(0),
                                                      Utilities.calculateDropTime(
                                                              '${_rideBookingScreenVM.vehicleList[index].name} Cab',
                                                              _rideBookingScreenVM
                                                                  .distance)
                                                          .split(".")[0]
                                                          .toString()),
                                                )
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  ),
                          ),
                          GestureDetector(
                            onTap: () => _scrollToBottom(),
                            child: SvgPicture.asset(
                              AppConstants.downArrow,
                              width: ResponsiveUI.w(24, context),
                              height: ResponsiveUI.h(24, context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveUI.h(16, context),
                              horizontal: ResponsiveUI.w(16, context),
                            ),
                            child: Divider(
                              color: Styles.textLightGrey,
                              thickness: 0.5,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUI.w(16, context),
                            ),
                            child: SizedBox(
                              width: ResponsiveUI.w(370, context),
                              height: ResponsiveUI.h(48, context),
                              child: FilledButton(
                                onPressed: () {
                                  _rideBookingScreenVM.requestRide(
                                      _rideBookingScreenVM.vehicleList[
                                          _rideBookingScreenVM
                                              .selectedVehicleIndex],
                                      fareController.text.split(" ")[1]);
                                },
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUI.r(10, context),
                                      ),
                                    ),
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Styles.primaryColor,
                                  ),
                                ),
                                child: _rideBookingScreenVM.isBottomIsLoading
                                    ? SizedBox(
                                        height: ResponsiveUI.h(30, context),
                                        width: ResponsiveUI.w(30, context),
                                        child: CircularProgressIndicator(
                                          color: Styles.backgroundPrimary,
                                          strokeWidth: 3,
                                          strokeCap: StrokeCap.round,
                                        ),
                                      )
                                    : Text(
                                        "Find a Driver",
                                        style: TextStyle(
                                          fontFamily: "MontserratBold",
                                          fontSize:
                                              ResponsiveUI.sp(14, context),
                                          fontWeight: FontWeight.w400,
                                          color: Styles.backgroundPrimary,
                                          height: 17 / 14,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Rest of your UI components remain exactly the same...
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   child: SafeArea(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: ResponsiveUI.w(16, context),
              //         vertical: ResponsiveUI.h(10, context),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           GestureDetector(
              //             onTap: () => Navigator.pop(context),
              //             child: SvgPicture.asset(
              //               AppConstants.backOptionIcon,
              //               width: ResponsiveUI.w(24, context),
              //               height: ResponsiveUI.h(24, context),
              //             ),
              //           ),
              //           SvgPicture.asset(
              //             AppConstants.profileIcon,
              //             width: ResponsiveUI.w(24, context),
              //             height: ResponsiveUI.h(24, context),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              // DraggableScrollableSheet(
              //   initialChildSize: 0.9,
              //   minChildSize: 0.8,
              //   maxChildSize: 0.9,
              //   snap: true,
              //   snapSizes: [0.4, 0.9],
              //   builder: (context, scrollController) {
              //     return Observer(builder: (context) {
              //       return Container(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: ResponsiveUI.w(16, context),
              //         ),
              //         decoration: BoxDecoration(
              //           color: Styles.backgroundWhite,
              //           borderRadius: BorderRadius.vertical(
              //             top: Radius.circular(ResponsiveUI.r(20, context)),
              //           ),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Styles.textTertiary.withOpacity(0.1),
              //               blurRadius: 4,
              //             ),
              //           ],
              //         ),
              //         child: Padding(
              //           padding: EdgeInsets.only(
              //             top: ResponsiveUI.h(14, context),
              //             bottom: ResponsiveUI.h(14, context),
              //           ),
              //           child: Container(
              //             color: Styles.backgroundWhite,
              //             child: Column(
              //               children: [
              //                 Center(
              //                   child: Container(
              //                     width: ResponsiveUI.w(60, context),
              //                     height: ResponsiveUI.h(10, context),
              //                     margin: const EdgeInsets.only(bottom: 15),
              //                     decoration: BoxDecoration(
              //                       color: const Color(0xff72727263),
              //                       borderRadius: BorderRadius.circular(10),
              //                     ),
              //                   ),
              //                 ),
              //                 Text(
              //                   "Choose your trip and swipe more",
              //                   style: TextStyle(
              //                     color: Styles.textTertiary,
              //                     fontSize: ResponsiveUI.sp(20, context),
              //                     fontFamily: "MontserratBold",
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: EdgeInsets.symmetric(
              //                     vertical: ResponsiveUI.h(19, context),
              //                     horizontal: ResponsiveUI.w(16, context),
              //                   ),
              //                   child: Divider(
              //                     color: Styles.textLightGrey,
              //                     thickness: 0.5,
              //                   ),
              //                 ),
              //                 Expanded(
              //                   child: _rideBookingScreenVM.isLoading
              //                       ? Shimmer.fromColors(
              //                           baseColor: Colors.grey[300]!,
              //                           highlightColor: Colors.grey[100]!,
              //                           child: _buildShimmerList(),
              //                         )
              //                       : ListView.builder(
              //                           controller: _scrollController,
              //                           padding: EdgeInsets.symmetric(
              //                             vertical: ResponsiveUI.h(0, context),
              //                           ),
              //                           itemCount: _rideBookingScreenVM
              //                               .vehicleList.length,
              //                           itemBuilder: (context, index) {
              //                             return Observer(builder: (context) {
              //                               return Container(
              //                                 decoration: BoxDecoration(
              //                                   color: index ==
              //                                           _rideBookingScreenVM
              //                                               .selectedVehicleIndex
              //                                       ? Styles.selectedVehicleColor
              //                                       : Colors.transparent,
              //                                   border: Border.all(
              //                                       width: ResponsiveUI.w(
              //                                           2, context),
              //                                       color: index ==
              //                                               _rideBookingScreenVM
              //                                                   .selectedVehicleIndex
              //                                           ? Styles.blueBorderColor
              //                                           : Styles.transparent),
              //                                   borderRadius: BorderRadius.all(
              //                                     Radius.circular(
              //                                       ResponsiveUI.r(5, context),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 child: Column(
              //                                   children: [
              //                                     ListTile(
              //                                       onTap: () {
              //                                         _rideBookingScreenVM
              //                                             .setSelectedVehicleIndex(
              //                                                 index);
              //                                         _rideBookingScreenVM
              //                                             .setIsOwnFare(false);
              //                                       },
              //                                       selected: index ==
              //                                               _rideBookingScreenVM
              //                                                   .selectedVehicleIndex
              //                                           ? true
              //                                           : false,
              //                                       selectedColor:
              //                                           Styles.textLightGrey,
              //                                       leading: SvgPicture.network(
              //                                         _rideBookingScreenVM
              //                                             .vehicleList[index]
              //                                             .image,
              //                                         width: ResponsiveUI.w(
              //                                             48, context),
              //                                         height: ResponsiveUI.h(
              //                                             48, context),
              //                                       ),
              //                                       title: Row(
              //                                         children: [
              //                                           Text(
              //                                             _rideBookingScreenVM
              //                                                 .vehicleList[index]
              //                                                 .name,
              //                                             style: TextStyle(
              //                                                 color: Styles
              //                                                     .blackPrimary,
              //                                                 fontSize:
              //                                                     ResponsiveUI.sp(
              //                                                         14,
              //                                                         context),
              //                                                 fontFamily:
              //                                                     "MontserratBold"),
              //                                           ),
              //                                           Padding(
              //                                             padding: EdgeInsets.symmetric(
              //                                                 horizontal:
              //                                                     ResponsiveUI.w(
              //                                                         4, context),
              //                                                 vertical:
              //                                                     ResponsiveUI.h(
              //                                                         4,
              //                                                         context)),
              //                                             child: SvgPicture.asset(
              //                                               AppConstants
              //                                                   .userCount,
              //                                               color: Styles
              //                                                   .blackPrimary,
              //                                               width: ResponsiveUI.w(
              //                                                   10, context),
              //                                               height:
              //                                                   ResponsiveUI.h(
              //                                                       10, context),
              //                                             ),
              //                                           ),
              //                                           Text(
              //                                             _rideBookingScreenVM
              //                                                 .vehicleList[index]
              //                                                 .capacity,
              //                                             style: TextStyle(
              //                                                 color: Styles
              //                                                     .textTertiary,
              //                                                 fontSize:
              //                                                     ResponsiveUI.sp(
              //                                                         10,
              //                                                         context),
              //                                                 fontFamily:
              //                                                     "MontserratSemiBold"),
              //                                           )
              //                                         ],
              //                                       ),
              //                                       subtitle: Text(
              //                                         "${Utilities.calculateDropTime('${_rideBookingScreenVM.vehicleList[index].name} Cab', _rideBookingScreenVM.distance)}",
              //                                         style: TextStyle(
              //                                             color: Color.fromRGBO(
              //                                                 0, 0, 0, 1),
              //                                             fontSize:
              //                                                 ResponsiveUI.sp(
              //                                                     12, context),
              //                                             fontFamily:
              //                                                 "MontserratRegular"),
              //                                       ),
              //                                       trailing: Text(
              //                                         "₹ ${(Utilities.calculatePrice(_rideBookingScreenVM.vehicleList[index].name, _rideBookingScreenVM.distance)).toStringAsFixed(0)}",
              //                                         style: TextStyle(
              //                                             color:
              //                                                 Styles.blackPrimary,
              //                                             fontSize:
              //                                                 ResponsiveUI.sp(
              //                                                     16, context),
              //                                             fontFamily:
              //                                                 "MontserratBold"),
              //                                       ),
              //                                     ),
              //                                     if (_rideBookingScreenVM
              //                                                 .selectedVehicleIndex ==
              //                                             index &&
              //                                         _rideBookingScreenVM
              //                                             .isOwnFare)
              //                                       Padding(
              //                                         padding:
              //                                             EdgeInsets.symmetric(
              //                                                 horizontal:
              //                                                     ResponsiveUI.w(
              //                                                         20,
              //                                                         context)),
              //                                         child: TextFormField(
              //                                           onChanged: (value) {},
              //                                           keyboardType:
              //                                               TextInputType.number,
              //                                           textAlign:
              //                                               TextAlign.center,
              //                                           controller:
              //                                               fareController,
              //                                           focusNode: fareFocusNode,
              //                                           onTapOutside: (event) =>
              //                                               fareFocusNode
              //                                                   .unfocus(),
              //                                           style: TextStyle(
              //                                             fontSize:
              //                                                 ResponsiveUI.sp(
              //                                                     30, context),
              //                                             fontFamily:
              //                                                 "MontserratBold",
              //                                             color:
              //                                                 Styles.blackPrimary,
              //                                           ),
              //                                           decoration: InputDecoration(
              //                                               focusColor:
              //                                                   Colors.black,
              //                                               fillColor:
              //                                                   Colors.black,
              //                                               errorBorder:
              //                                                   InputBorder.none,
              //                                               disabledBorder:
              //                                                   InputBorder.none,
              //                                               contentPadding:
              //                                                   EdgeInsets.zero,
              //                                               focusedBorder:
              //                                                   UnderlineInputBorder(
              //                                                       borderSide:
              //                                                           BorderSide(
              //                                                               color:
              //                                                                   Colors.grey))),
              //                                         ),
              //                                       )
              //                                     else if (_rideBookingScreenVM
              //                                             .selectedVehicleIndex ==
              //                                         index)
              //                                       FilledButton(
              //                                         onPressed: () {
              //                                           _rideBookingScreenVM
              //                                               .setIsOwnFare(true);
              //                                         },
              //                                         style: ButtonStyle(
              //                                           fixedSize:
              //                                               WidgetStatePropertyAll(
              //                                                   Size(
              //                                                       ResponsiveUI.w(
              //                                                           330,
              //                                                           context),
              //                                                       ResponsiveUI.h(
              //                                                           50,
              //                                                           context))),
              //                                           shape:
              //                                               WidgetStatePropertyAll(
              //                                             RoundedRectangleBorder(
              //                                               borderRadius:
              //                                                   BorderRadius
              //                                                       .circular(
              //                                                 ResponsiveUI.r(
              //                                                     10, context),
              //                                               ),
              //                                             ),
              //                                           ),
              //                                           backgroundColor:
              //                                               WidgetStatePropertyAll(
              //                                             Styles.greenButtonColor,
              //                                           ),
              //                                         ),
              //                                         child: Text(
              //                                           "Offer your Fare",
              //                                           style: TextStyle(
              //                                             fontFamily:
              //                                                 "MontserratBold",
              //                                             fontSize:
              //                                                 ResponsiveUI.sp(
              //                                                     14, context),
              //                                             fontWeight:
              //                                                 FontWeight.w400,
              //                                             color: Styles
              //                                                 .backgroundPrimary,
              //                                             height: 17 / 14,
              //                                           ),
              //                                         ),
              //                                       ),
              //                                     if (_rideBookingScreenVM
              //                                             .selectedVehicleIndex ==
              //                                         index)
              //                                       Padding(
              //                                         padding:
              //                                             EdgeInsets.symmetric(
              //                                                 horizontal:
              //                                                     ResponsiveUI.w(
              //                                                         20,
              //                                                         context),
              //                                                 vertical:
              //                                                     ResponsiveUI.h(
              //                                                         18,
              //                                                         context)),
              //                                         child: buildInfoBox(
              //                                             context,
              //                                             (Utilities.calculatePrice(
              //                                                     _rideBookingScreenVM
              //                                                         .vehicleList[
              //                                                             index]
              //                                                         .name,
              //                                                     _rideBookingScreenVM
              //                                                         .distance))
              //                                                 .toStringAsFixed(0),
              //                                             Utilities.calculateDropTime(
              //                                                     '${_rideBookingScreenVM.vehicleList[index].name} Cab',
              //                                                     _rideBookingScreenVM
              //                                                         .distance)
              //                                                 .split(".")[0]
              //                                                 .toString()),
              //                                       )
              //                                   ],
              //                                 ),
              //                               );
              //                             });
              //                           },
              //                         ),
              //                 ),
              //                 GestureDetector(
              //                   onTap: () => _scrollToBottom(),
              //                   child: SvgPicture.asset(
              //                     AppConstants.downArrow,
              //                     width: ResponsiveUI.w(24, context),
              //                     height: ResponsiveUI.h(24, context),
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: EdgeInsets.symmetric(
              //                     vertical: ResponsiveUI.h(16, context),
              //                     horizontal: ResponsiveUI.w(16, context),
              //                   ),
              //                   child: Divider(
              //                     color: Styles.textLightGrey,
              //                     thickness: 0.5,
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: EdgeInsets.symmetric(
              //                     horizontal: ResponsiveUI.w(16, context),
              //                   ),
              //                   child: SizedBox(
              //                     width: ResponsiveUI.w(370, context),
              //                     height: ResponsiveUI.h(48, context),
              //                     child: FilledButton(
              //                       onPressed: () {
              //                         _rideBookingScreenVM.requestRide(
              //                             _rideBookingScreenVM.vehicleList[
              //                                 _rideBookingScreenVM
              //                                     .selectedVehicleIndex],
              //                             fareController.text.split(" ")[1]);
              //                       },
              //                       style: ButtonStyle(
              //                         shape: WidgetStatePropertyAll(
              //                           RoundedRectangleBorder(
              //                             borderRadius: BorderRadius.circular(
              //                               ResponsiveUI.r(10, context),
              //                             ),
              //                           ),
              //                         ),
              //                         backgroundColor: WidgetStatePropertyAll(
              //                           Styles.primaryColor,
              //                         ),
              //                       ),
              //                       child: _rideBookingScreenVM.isBottomIsLoading
              //                           ? SizedBox(
              //                               height: ResponsiveUI.h(30, context),
              //                               width: ResponsiveUI.w(30, context),
              //                               child: CircularProgressIndicator(
              //                                 color: Styles.backgroundPrimary,
              //                                 strokeWidth: 3,
              //                                 strokeCap: StrokeCap.round,
              //                               ),
              //                             )
              //                           : Text(
              //                               "Find a Driver",
              //                               style: TextStyle(
              //                                 fontFamily: "MontserratBold",
              //                                 fontSize:
              //                                     ResponsiveUI.sp(14, context),
              //                                 fontWeight: FontWeight.w400,
              //                                 color: Styles.backgroundPrimary,
              //                                 height: 17 / 14,
              //                               ),
              //                             ),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     });
              //   },
              // ),
            ],
          ),
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

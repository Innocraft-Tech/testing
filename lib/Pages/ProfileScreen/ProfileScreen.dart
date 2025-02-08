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
import 'package:zappy/Pages/ProfileScreen/ProfileScreenVM.dart';
import 'package:zappy/Pages/SavedAddressScreen/SavedAddressScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileScreenVM _profileScreenVM;
  GoogleMapController? mapController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor capitanIcon = BitmapDescriptor.defaultMarker;
  int selectedIndex = 0;

  List<Map<String, String>> profileItems = [
    {"title": "My Ride", "icon": AppConstants.ridesIcon},
    {"title": "Saved", "icon": AppConstants.savedAdressIcon},
    {"title": "Manage Account", "icon": AppConstants.accountIcon},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileScreenVM = ProfileScreenVM();
    _profileScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPush) {
        context.push(pageConfig: event.pageConfig, data: event.data);
      }
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

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _profileScreenVM.scourceLocation,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Observer(
            builder: (context) => GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _profileScreenVM.scourceLocation,
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('source'),
                  position: _profileScreenVM.scourceLocation,
                  icon: sourceIcon,
                  infoWindow: const InfoWindow(title: 'Source'),
                ),
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.73,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            snap: true,
            snapSizes: [0.4, 0.8],
            builder: (context, scrollController) {
              return Observer(builder: (context) {
                return Container(
                    decoration: BoxDecoration(
                      color: Styles.textTertiary,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: ResponsiveUI.h(20, context),
                        ),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ResponsiveUI.w(10, context)),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppConstants.left,
                                  width: ResponsiveUI.w(24, context),
                                  height: ResponsiveUI.h(24, context),
                                ),
                                Text(
                                  'Back',
                                  style: TextStyle(
                                      color: Styles.backgroundWhite,
                                      fontSize: ResponsiveUI.w(12, context)),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUI.w(20, context),
                              vertical: ResponsiveUI.h(32, context)),
                          child: Text(
                            'Account',
                            style: TextStyle(
                                color: Styles.backgroundWhite,
                                fontSize: ResponsiveUI.w(25, context),
                                fontFamily: "MontserratBold"),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: profileItems.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                if (index == 1) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return SavedAddressScreen();
                                    },
                                  ));
                                } else if (index == 0) {
                                  _profileScreenVM.navigateToMyRidesScreen();
                                } else if (index == 2) {
                                  _profileScreenVM.navigateToAccountScreen();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? Styles.primaryColor
                                        : Styles.transparent,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color.fromRGBO(
                                                114, 114, 114, 0.39),
                                            width: 1))),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(20, context),
                                    vertical: ResponsiveUI.h(18, context)),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      profileItems[index]["icon"]!,
                                      width: ResponsiveUI.w(24, context),
                                      height: ResponsiveUI.h(24, context),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: ResponsiveUI.w(20, context),
                                      ),
                                      child: Text(
                                        profileItems[index]["title"]!,
                                        style: TextStyle(
                                            color: Styles.backgroundWhite,
                                            fontSize:
                                                ResponsiveUI.w(16, context),
                                            fontFamily: "MontserratRegular"),
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(
                                      AppConstants.right,
                                      width: ResponsiveUI.w(24, context),
                                      height: ResponsiveUI.h(24, context),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                      ],
                    ));
              });
            },
          ),
        ],
      ),
    );
  }
}

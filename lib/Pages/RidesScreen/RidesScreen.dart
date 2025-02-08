import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/RidesScreen/DependentViews/RideCardItem.dart';
import 'package:zappy/Pages/RidesScreen/RidesScreenVM.dart';

class RidesScreen extends StatefulWidget {
  const RidesScreen({super.key});

  @override
  State<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  late RidesScreenVM _ridesScreenVM;
  GoogleMapController? mapController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor capitanIcon = BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ridesScreenVM = RidesScreenVM();
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
          target: _ridesScreenVM.scourceLocation,
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
                target: _ridesScreenVM.scourceLocation,
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('source'),
                  position: _ridesScreenVM.scourceLocation,
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                            'Rides',
                            style: TextStyle(
                                color: Styles.backgroundWhite,
                                fontSize: ResponsiveUI.w(25, context),
                                fontFamily: "MontserratBold"),
                          ),
                        ),
                        Container(
                          child: Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                  top: ResponsiveUI.w(21, context)),
                              itemCount: _ridesScreenVM.rides.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: ResponsiveUI.h(10, context),
                                      left: ResponsiveUI.w(16, context),
                                      right: ResponsiveUI.w(16, context)),
                                  child: RideCardItem(
                                      ride: _ridesScreenVM.rides[index]),
                                );
                              },
                            ),
                          ),
                        )
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

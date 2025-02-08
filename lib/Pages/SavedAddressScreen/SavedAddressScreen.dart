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
import 'package:zappy/Pages/SavedAddressScreen/BusinessAddress.dart';
import 'package:zappy/Pages/SavedAddressScreen/PersonalAddress.dart';
import 'package:zappy/Pages/SavedAddressScreen/SavedAddressScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class SavedAddressScreen extends StatefulWidget {
  const SavedAddressScreen({super.key});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late SavedAddressScreenVM _SavedAddressScreenVM;
  GoogleMapController? mapController;
  TabController? tabController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor capitanIcon = BitmapDescriptor.defaultMarker;
  final PageController _pageController = PageController();

  int selectedIndex = 0;

  List<Map<String, String>> profileItems = [
    {"title": "My Ride", "icon": AppConstants.ridesIcon},
    {"title": "Saved", "icon": AppConstants.savedAdressIcon},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _SavedAddressScreenVM = SavedAddressScreenVM();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) {
        _pageController.animateToPage(
          tabController!.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    _SavedAddressScreenVM.navigationStream.stream.listen((event) {
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
          target: _SavedAddressScreenVM.scourceLocation,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _SavedAddressScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
                children: [
                  Observer(
                    builder: (context) => GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _SavedAddressScreenVM.scourceLocation,
                        zoom: 13.5,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('source'),
                          position: _SavedAddressScreenVM.scourceLocation,
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
                                top: Radius.circular(
                                    ResponsiveUI.r(20, context)),
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
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveUI.w(10, context)),
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
                                            fontSize:
                                                ResponsiveUI.w(12, context)),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _SavedAddressScreenVM
                                              .navigateToLocaitonPicker();
                                        },
                                        child: Text(
                                          'Add New',
                                          style: TextStyle(
                                            color: Styles.greenButtonColor,
                                            fontSize:
                                                ResponsiveUI.w(14, context),
                                          ),
                                        ),
                                      )
                                    ],
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
                                TabBar(
                                    padding: EdgeInsets.zero,
                                    indicatorColor: Styles.primaryColor,
                                    controller: tabController,
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding: EdgeInsets.zero,
                                    tabs: [
                                      Tab(
                                        iconMargin: EdgeInsets.zero,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              AppConstants.personal,
                                              width:
                                                  ResponsiveUI.w(24, context),
                                              height:
                                                  ResponsiveUI.h(24, context),
                                            ),
                                            Text(
                                              "Personal",
                                              style: TextStyle(
                                                  color: Styles.backgroundWhite,
                                                  fontSize: ResponsiveUI.w(
                                                      14, context),
                                                  fontFamily: "MontserratBold"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Tab(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SvgPicture.asset(
                                              AppConstants.business,
                                              width:
                                                  ResponsiveUI.w(24, context),
                                              height:
                                                  ResponsiveUI.h(24, context),
                                            ),
                                            Text(
                                              "Business",
                                              style: TextStyle(
                                                  color: Styles.backgroundWhite,
                                                  fontSize: ResponsiveUI.w(
                                                      14, context),
                                                  fontFamily: "MontserratBold"),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                                Expanded(
                                  child: PageView.builder(
                                      controller: _pageController,
                                      onPageChanged: (index) {
                                        tabController!.animateTo(index);
                                      },
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? PersonalAddress(
                                                addressList:
                                                    _SavedAddressScreenVM
                                                        .address,
                                              )
                                            : BusinessAddress(
                                                addressList:
                                                    _SavedAddressScreenVM
                                                        .address,
                                              );
                                      }),
                                ),
                              ],
                            ));
                      });
                    },
                  ),
                ],
              ),
            );
    });
  }
}

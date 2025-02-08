import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/LocationPickerScreen/LocationpickerScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart'; // For reverse geocoding

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? mapController;
  LatLng _center = const LatLng(12.9165, 79.1325); // Default center
  String? _address;
  String? _placeName;
  TextEditingController addressNameController = TextEditingController();
  FocusNode _addressNameFocusNode = FocusNode();
  String selectedAddressType = 'Personal';
  Marker? _marker;
  late LocationPickerScreenVM _locationPickerScreenVM;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarker(_center);
  }

  void _addMarker(LatLng position) {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, AppConstants.sourceIcon)
        .then((icon) {
      sourceIcon = icon;
    });
    // setState(() {
    //   _marker = Marker(
    //     markerId: const MarkerId('selected_location'),
    //     position: position,
    //     draggable: true, // Make the marker draggable
    //     icon: sourceIcon, // Use the custom marker icon
    //     onDragEnd: (LatLng newPosition) {
    //       _getAddressFromLatLng(newPosition); // Fetch address on drag end
    //     },
    //   );
    // });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      // Use the geocoding package to fetch the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      _locationPickerScreenVM.updateCurrentLocation(position);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
          _placeName = place.name ?? 'Unknown Place';
          _center = position;
          _locationPickerScreenVM.updateAddressDetails(_address!);
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _locationPickerScreenVM = LocationPickerScreenVM();
    _locationPickerScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPop) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _locationPickerScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: ResponsiveUI.h(200, context)),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _locationPickerScreenVM.currentLocation,
                        zoom: 15.0,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected_location'),
                          position: _locationPickerScreenVM.currentLocation,
                          draggable: true, // Make the marker draggable
                          icon: sourceIcon, // Use the custom marker icon
                          onDragEnd: (LatLng newPosition) {
                            _getAddressFromLatLng(
                                newPosition); // Fetch address on drag end
                          },
                        )
                      }, // Only one marker
                      onCameraMove: (CameraPosition position) {
                        setState(() {
                          _center = position.target;
                        });
                      },
                      onCameraIdle: () {
                        _getAddressFromLatLng(_center);
                      },
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.3,
                    maxChildSize: 0.6,
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
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: ResponsiveUI.h(37, context),
                                left: ResponsiveUI.w(16, context),
                                right: ResponsiveUI.w(16, context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add New Address',
                                  style: TextStyle(
                                    fontSize: ResponsiveUI.sp(20, context),
                                    fontFamily: "MontserratBold",
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppConstants.locationIconSmall,
                                        width: ResponsiveUI.w(24, context),
                                        height: ResponsiveUI.h(24, context),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _placeName ?? 'Selected Location',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _address ?? 'Loading address...',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: addressNameController,
                                  focusNode: _addressNameFocusNode,
                                  onChanged: (value) {
                                    _locationPickerScreenVM
                                        .updateAddressName(value);
                                  },
                                  onTapOutside: (event) =>
                                      _addressNameFocusNode.unfocus(),
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(
                                          ResponsiveUI.w(16, context), context),
                                      fontFamily: "MontserratSemiBold"),
                                  decoration: InputDecoration(
                                    labelText: 'Address name',
                                    hintText:
                                        'E.g. School Name, Grandma\'s House',
                                    labelStyle: TextStyle(
                                        fontSize: ResponsiveUI.sp(
                                            ResponsiveUI.w(16, context),
                                            context),
                                        fontFamily: "MontserratSemiBold"),
                                    focusColor: Styles.primaryColor,
                                    fillColor: Styles.primaryColor,
                                    hoverColor: Styles.primaryColor,
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Styles.primaryColor)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Address Type',
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(16, context),
                                      fontFamily: "MontserratSemiBold"),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildAddressTypeButton(
                                      'Personal',
                                      AppConstants.personlIcon,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildAddressTypeButton(
                                      'Business',
                                      AppConstants.businessIcon,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildAddressTypeButton(
                                      'Others',
                                      AppConstants.locationIconSecondary,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _locationPickerScreenVM
                                          .submitAddressDetails();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          addressNameController.text.isEmpty
                                              ? Colors.grey[300]
                                              : Styles.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color:
                                              addressNameController.text.isEmpty
                                                  ? Colors.black
                                                  : Styles.backgroundWhite,
                                          fontSize:
                                              ResponsiveUI.sp(16, context),
                                          fontFamily: "MontserratSemiBold"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildAddressTypeButton(String type, String icon) {
    final isSelected = selectedAddressType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedAddressType = type;
          });
          _locationPickerScreenVM.setAddressType(type);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromRGBO(73, 69, 255, 0.23).withOpacity(0.23)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected ? Styles.primaryColor : Colors.grey[300]!,
                width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: ResponsiveUI.w(24, context),
                height: ResponsiveUI.h(24, context),
                color: isSelected
                    ? Styles.primaryColor.withOpacity(1)
                    : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  color: isSelected ? Styles.blackPrimary : Colors.grey[600],
                  fontSize: ResponsiveUI.sp(14, context),
                  fontFamily: "MontserratSemiBold",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

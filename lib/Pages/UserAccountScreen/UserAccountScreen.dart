import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Pages/UserAccountScreen/UserAccountScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  UserAccountScreenVM _userAccountScreenVM = UserAccountScreenVM();

  GoogleMapController? mapController;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor capitanIcon = BitmapDescriptor.defaultMarker;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String _selectedDate = "";
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
          target: _userAccountScreenVM.scourceLocation,
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _userAccountScreenVM.isLoading
          ? Loader()
          : Scaffold(
              body: Stack(
                children: [
                  Observer(
                    builder: (context) => GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _userAccountScreenVM.scourceLocation,
                        zoom: 13.5,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('source'),
                          position: _userAccountScreenVM.scourceLocation,
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
                    // Replace the DraggableScrollableSheet builder content with this:

                    builder: (context, scrollController) {
                      return Observer(builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Styles.backgroundWhite,
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
                          child: ListView(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            children: [
                              // Drag Handle
                              SizedBox(height: ResponsiveUI.h(13, context)),
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

                              // Back Button and Title
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
                                        AppConstants.backOption,
                                        width: ResponsiveUI.w(24, context),
                                        height: ResponsiveUI.h(24, context),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveUI.w(20, context),
                                          vertical: ResponsiveUI.h(32, context),
                                        ),
                                        child: Text(
                                          'Profile',
                                          style: TextStyle(
                                            color: Styles.blackPrimary,
                                            fontSize:
                                                ResponsiveUI.w(25, context),
                                            fontFamily: "MontserratBold",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Profile Avatar
                              Center(
                                child: Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Styles.primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveUI.h(32, context)),

                              // Profile Details
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(16, context)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Column(
                                    children: [
                                      _buildProfileItem(
                                        'Full Name',
                                        _userAccountScreenVM.user.fullName,
                                        onTap: () =>
                                            _showUpdateFieldBottomSheet(
                                                'Full Name',
                                                _userAccountScreenVM
                                                    .user.fullName),
                                      ),
                                      Divider(
                                          height: 1, color: Colors.grey[200]),
                                      _buildProfileItem(
                                        'Email',
                                        _userAccountScreenVM.user.email ?? "",
                                        onTap: () =>
                                            _showUpdateFieldBottomSheet(
                                                'Email',
                                                _userAccountScreenVM
                                                        .user.email ??
                                                    ""),
                                      ),
                                      Divider(
                                          height: 1, color: Colors.grey[200]),
                                      _buildProfileItem(
                                        'Gender',
                                        _userAccountScreenVM.user.gender ?? "",
                                        onTap: () =>
                                            _showGenderPickerBottomSheet(),
                                      ),
                                      Divider(
                                          height: 1, color: Colors.grey[200]),
                                      _buildProfileItem(
                                        'Date of Birth',
                                        _userAccountScreenVM
                                                .user.dateOfBith!.isEmpty
                                            ? 'XX/XX/XXXX'
                                            : _userAccountScreenVM
                                                .user.dateOfBith!
                                                .split(" ")[0],
                                        onTap: () =>
                                            _showDatePickerBottomSheet(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Spacing before buttons
                              SizedBox(height: ResponsiveUI.h(32, context)),

                              // Action Buttons
                              Padding(
                                padding:
                                    EdgeInsets.all(ResponsiveUI.w(16, context)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          // Implement logout logic
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(
                                              ResponsiveUI.w(16, context)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: Colors.grey[200]!),
                                          ),
                                        ),
                                        child: Text(
                                          'Log Out',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize:
                                                ResponsiveUI.sp(16, context),
                                            fontFamily: "MontserratMedium",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: ResponsiveUI.h(16, context)),
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          // Implement delete account logic
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(
                                              ResponsiveUI.w(16, context)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: Colors.grey[200]!),
                                          ),
                                        ),
                                        child: Text(
                                          'Delete Account',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize:
                                                ResponsiveUI.sp(16, context),
                                            fontFamily: "MontserratMedium",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Bottom padding to ensure content doesn't get cut off
                              SizedBox(height: ResponsiveUI.h(16, context)),
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

  Widget _buildProfileItem(String label, String value, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUI.sp(16, context),
                fontFamily: "MontserratBold",
                color: Styles.blackPrimary,
              ),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUI.sp(16, context),
                fontFamily: "MontserratRegular",
                color: Styles.blackPrimary,
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateFieldBottomSheet(String field, String currentValue) {
    final controller = TextEditingController(text: currentValue);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update $field',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Enter your $field',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Styles.primaryColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              ServiceResult<String?> mobileNumer =
                                  await _userAccountScreenVM
                                      .secureStorageService
                                      .retrieveData(key: "mobile_number");
                              _userAccountScreenVM.updateUserProfile({
                                field == "Full Name" ? "fullname" : "email":
                                    controller.text,
                                "phonenumber": mobileNumer.content
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Styles.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select Date of Birth',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  onDateChanged: (DateTime date) {
                    print(date);
                    setState(() {
                      _selectedDate = date.toString();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          ServiceResult<String?> mobileNumer =
                              await _userAccountScreenVM.secureStorageService
                                  .retrieveData(key: "mobile_number");
                          _userAccountScreenVM.updateUserProfile({
                            "date_of_birth": _selectedDate,
                            "phonenumber": mobileNumer.content
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Styles.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGenderPickerBottomSheet() {
    String selectedGender = 'Male';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Select Gender',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildGenderOption(
                          'Male',
                          selectedGender,
                          (value) => setState(() => selectedGender = value!),
                        ),
                        Divider(height: 1, color: Colors.grey[300]),
                        _buildGenderOption(
                          'Female',
                          selectedGender,
                          (value) => setState(() => selectedGender = value!),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              ServiceResult<String?> mobileNumer =
                                  await _userAccountScreenVM
                                      .secureStorageService
                                      .retrieveData(key: "mobile_number");
                              _userAccountScreenVM.updateUserProfile({
                                "gender": selectedGender,
                                "phonenumber": mobileNumer.content
                              });
                              // Update gender logic here
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Styles.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGenderOption(
    String value,
    String groupValue,
    void Function(String?) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Styles.primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

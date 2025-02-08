import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Pages/LocationSearchScreen/AppColors.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/CustomSearchBar.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/LocationResultTile.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/PasangerSelector.dart';
import 'package:zappy/Pages/LocationSearchScreen/LocationSearchScreenVM.dart';
import 'package:zappy/Pages/LocationSearchScreen/PlacePrediction.dart';
import 'package:zappy/Services/GoogleMapService/PlaceServices.dart';

class LocationSearchScreen extends StatefulWidget {
  List locations;
  LocationSearchScreen({super.key, required this.locations});

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  LocationSearchScreenVM _locationSearchScreenVM = LocationSearchScreenVM();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  TextEditingController _commentsController = TextEditingController();
  FocusNode _commentsFocusNode = FocusNode();
  final PlacesService _placesService = PlacesService();
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropFocusNode = FocusNode();
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  bool _isPickupActive = true;
  TabController? tabController;
  final List<String> tabNames = ["Local", "Outstation"];
  final PageController _pageController = PageController();
  DateTime departureDate = DateTime.now();
  bool isDateSelected = false;

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    _pickupFocusNode.dispose();
    _dropFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String query, bool isPickup) async {
    setState(() {});
    setState(() {
      _isPickupActive = isPickup;
      if (query.isEmpty) {
        _predictions = [];
        return;
      }
      _isLoading = true;
    });

    try {
      final predictions = await _placesService.getPlacePredictions(query);
      setState(() => _predictions = predictions);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onLocationSelected(String location) async {
    String placeId = "";
    _predictions.forEach((place) {
      place.mainText == location.split(',')[0] ? placeId = place.placeId : null;
    });

    if (_isPickupActive) {
      _pickupController.text = location;
      Map<String, String> currentLocation =
          await _placesService.getPlaceDetails(placeId);
      // widget.locations[0] = LatLng(double.parse(currentLocation["lat"]!),
      //     double.parse(currentLocation["lng"]!));
      // widget.locations[2](LatLng(double.parse(currentLocation["lat"]!),
      //     double.parse(currentLocation["lng"]!)));
      _locationSearchScreenVM.updateSourceLocation(LatLng(
          double.parse(currentLocation["lat"]!),
          double.parse(currentLocation["lng"]!)));
    } else {
      _dropController.text = location;
      Map<String, String> currentLocation =
          await _placesService.getPlaceDetails(placeId);
      // widget.locations[1] = LatLng(double.parse(currentLocation["lat"]!),
      //     double.parse(currentLocation["lng"]!));
      // widget.locations[3](LatLng(double.parse(currentLocation["lat"]!),
      //     double.parse(currentLocation["lng"]!)));
      _locationSearchScreenVM.updateDestinationLocation(LatLng(
          double.parse(currentLocation["lat"]!),
          double.parse(currentLocation["lng"]!)));

      // Unfocus the text field
      _dropFocusNode.unfocus();
      if (!_locationSearchScreenVM.isOutStation) {
        _locationSearchScreenVM.navigateToRideBookingScreen(
            _pickupController.text, _dropController.text);
      }
    }
    setState(() => _predictions = []);
  }

  Future<void> getSourceLocationName() async {
    PlacesService placesService = PlacesService();
    _locationSearchScreenVM.updateSourceLocation(
        LatLng(widget.locations[0].latitude, widget.locations[0].longitude));
    String sourceName = await placesService.getLocationName(
        widget.locations[0].latitude, widget.locations[0].longitude);
    _pickupController.text = sourceName;
  }

  List<DateTime> _generateTimeSlots() {
    final now = DateTime.now();
    // Round up to the next 15 minutes
    final currentMinute = now.minute;
    final remainder = currentMinute % 15;
    final minutesToAdd = remainder == 0 ? 0 : (15 - remainder);

    DateTime startTime = now.add(Duration(
      minutes: minutesToAdd,
      seconds: -now.second,
      milliseconds: -now.millisecond,
      microseconds: -now.microsecond,
    ));

    List<DateTime> slots = [];
    for (int i = 0; i < 8; i++) {
      // Generate next 2 hours of slots
      slots.add(startTime.add(Duration(minutes: 15 * i)));
    }
    return slots;
  }

  List<DateTime> _generateTimeSlotsForNextDay() {
    final now = DateTime.now();

    // Round up to the next 15 minutes
    final currentMinute = now.minute;
    final remainder = currentMinute % 30;
    final minutesToAdd = remainder == 0 ? 0 : (30 - remainder);

    DateTime startTime = now.add(Duration(
      minutes: minutesToAdd,
      seconds: -now.second,
      milliseconds: -now.millisecond,
      microseconds: -now.microsecond,
    ));

    List<DateTime> slots = [];

    // Generate slots for the next 24 hours
    for (int i = 0; i < (24 * 4); i++) {
      // 24 hours * 4 slots per hour
      slots.add(startTime.add(Duration(minutes: 30 * i)));
    }

    return slots;
  }

  @override
  void initState() {
    super.initState();
    getSourceLocationName();
    tabController = TabController(length: tabNames.length, vsync: this);
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) {
        _locationSearchScreenVM
            .setIsOutStation(!_locationSearchScreenVM.isOutStation);
        _pageController.animateToPage(
          tabController!.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    _locationSearchScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPop) {
        context.pop();
        setState(() {});
      } else if (event is NavigatorPopAndPush) {
        context.popAndPush(pageConfig: event.pageConfig, data: event.data);
      }
    });
    _locationSearchScreenVM.setSelectedTime(
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}");
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();
    return Observer(builder: (context) {
      return Scaffold(
        backgroundColor: Styles.backgroundWhite,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppConstants.roundedBackArrow,
                            width: ResponsiveUI.w(24, context),
                            height: ResponsiveUI.h(24, context),
                          ),
                          SizedBox(width: ResponsiveUI.w(10, context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: ResponsiveUI.h(10, context)),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: ResponsiveUI.w(370, context),
                    height: ResponsiveUI.h(56, context),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(ResponsiveUI.r(10, context)),
                      color: Styles.primaryColor,
                    ),
                    child: TabBar(
                      controller: tabController,
                      overlayColor: WidgetStatePropertyAll(Styles.transparent),
                      indicatorColor: Styles.transparent,
                      dividerColor: Styles.transparent,
                      labelPadding: EdgeInsets.zero,
                      indicator: const BoxDecoration(),
                      indicatorWeight: 0,
                      tabs: List.generate(tabNames.length, (index) {
                        return Tab(
                          child: AnimatedBuilder(
                            animation: tabController!.animation!,
                            builder: (context, child) {
                              final isSelected = tabController!.index == index;
                              return Container(
                                alignment: Alignment.center,
                                width: ResponsiveUI.w(168, context),
                                height: ResponsiveUI.h(42, context),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Styles.yellowTabBarColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveUI.r(10, context)),
                                ),
                                child: Text(
                                  tabNames[index],
                                  style: Styles.h4(context).merge(
                                    TextStyle(
                                      fontFamily: "MontserratSemiBold",
                                      color: isSelected
                                          ? Styles.blackPrimary
                                          : Styles.backgroundWhite,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      tabController!.animateTo(index);
                    },
                    itemCount: tabNames.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveUI.w(16, context),
                                vertical: ResponsiveUI.h(32, context),
                              ),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _pickupFocusNode.requestFocus();
                                    },
                                    child: CustomSearchBar(
                                      LeadingText: "Pickup",
                                      hint: 'Your Current Location',
                                      dotColor: Styles.primaryColor,
                                      controller: _pickupController,
                                      focusNode: _pickupFocusNode,
                                      onFocus: () => setState(
                                          () => _isPickupActive = true),
                                      onChanged: (query) =>
                                          _onSearchChanged(query, true),
                                      onLocationSelected: _onLocationSelected,
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveUI.h(16, context)),
                                  GestureDetector(
                                    onTap: () {
                                      _dropFocusNode.requestFocus();
                                    },
                                    child: CustomSearchBar(
                                      LeadingText: "Drop",
                                      hint: 'Search for a destination',
                                      dotColor: Color.fromRGBO(236, 38, 38, 1),
                                      controller: _dropController,
                                      focusNode: _dropFocusNode,
                                      onFocus: () => setState(
                                          () => _isPickupActive = false),
                                      onChanged: (query) =>
                                          _onSearchChanged(query, false),
                                      onLocationSelected: _onLocationSelected,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_predictions.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(16, context)),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Search Results',
                                    style: TextStyle(
                                      color: Styles.primaryColor,
                                      fontFamily: "MontserratBold",
                                      fontSize: ResponsiveUI.sp(14, context),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveUI.h(14, context)),
                              Divider(color: AppColors.divider, height: 1),
                              SizedBox(height: ResponsiveUI.h(21, context)),
                              Expanded(
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : ListView.builder(
                                        itemCount: _predictions.length,
                                        itemBuilder: (context, index) {
                                          final prediction =
                                              _predictions[index];
                                          return LocationResultTile(
                                            index: _predictions
                                                .indexOf(prediction),
                                            name: prediction.mainText,
                                            address: prediction.secondaryText,
                                            onTap: () {
                                              final location =
                                                  '${prediction.mainText}, ${prediction.secondaryText}';
                                              _onLocationSelected(location);
                                            },
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ],
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUI.w(16, context)),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // From Location
                                SizedBox(
                                  height: ResponsiveUI.h(40, context),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showFromLocationBottomSheet(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveUI.w(11, context),
                                          vertical:
                                              ResponsiveUI.h(16, context)),
                                      width: ResponsiveUI.w(370, context),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'From',
                                                style: TextStyle(
                                                    fontSize: ResponsiveUI.sp(
                                                        14, context),
                                                    fontFamily:
                                                        "MontserratRegular"),
                                              ),
                                              _pickupController.text.length != 0
                                                  ? SizedBox(
                                                      width: ResponsiveUI.w(
                                                          300, context),
                                                      child: Text(
                                                        _pickupController.text,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontSize:
                                                                ResponsiveUI.sp(
                                                                    16,
                                                                    context),
                                                            fontFamily:
                                                                "MontserratSemiBold"),
                                                      ),
                                                    )
                                                  : SizedBox.shrink()
                                            ],
                                          ),
                                          Icon(Icons.chevron_right)
                                        ],
                                      )),
                                ),
                                SizedBox(height: 12),

                                // To Location
                                GestureDetector(
                                  onTap: () {
                                    _showToLocationBottomSheet(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveUI.w(11, context),
                                          vertical:
                                              ResponsiveUI.h(16, context)),
                                      width: ResponsiveUI.w(370, context),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'TO',
                                                style: TextStyle(
                                                    fontSize: ResponsiveUI.sp(
                                                        14, context),
                                                    fontFamily:
                                                        "MontserratRegular"),
                                              ),
                                              SizedBox(
                                                width: ResponsiveUI.w(
                                                    300, context),
                                                child: Text(
                                                  _dropController.text.length !=
                                                          0
                                                      ? _dropController.text
                                                      : "Select your destination",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: ResponsiveUI.sp(
                                                          16, context),
                                                      fontFamily:
                                                          "MontserratSemiBold"),
                                                ),
                                              )
                                            ],
                                          ),
                                          Icon(Icons.chevron_right)
                                        ],
                                      )),
                                ),
                                SizedBox(height: 12),

                                // When
                                GestureDetector(
                                  onTap: () {
                                    _showDateBottomSheet(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveUI.w(11, context),
                                          vertical:
                                              ResponsiveUI.h(16, context)),
                                      width: ResponsiveUI.w(370, context),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'When',
                                                style: TextStyle(
                                                    fontSize: ResponsiveUI.sp(
                                                        14, context),
                                                    fontFamily:
                                                        "MontserratRegular"),
                                              ),
                                              Observer(builder: (context) {
                                                return Text(
                                                  '${_locationSearchScreenVM.selectedDateText}, ${_locationSearchScreenVM.selectedTime}',
                                                  style: TextStyle(
                                                      fontSize: ResponsiveUI.sp(
                                                          16, context),
                                                      fontFamily:
                                                          "MontserratSemiBold"),
                                                );
                                              })
                                            ],
                                          ),
                                          Icon(Icons.chevron_right)
                                        ],
                                      )),
                                ),
                                SizedBox(height: 12),

                                // Number of Passengers
                                GestureDetector(
                                  onTap: () {
                                    _showPasangerCountBottomSheet(context);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveUI.w(11, context),
                                          vertical:
                                              ResponsiveUI.h(16, context)),
                                      width: ResponsiveUI.w(370, context),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Number of Passangers',
                                                style: TextStyle(
                                                    fontSize: ResponsiveUI.sp(
                                                        14, context),
                                                    fontFamily:
                                                        "MontserratRegular"),
                                              ),
                                              Text(
                                                _locationSearchScreenVM
                                                    .numberOfPassangers
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: ResponsiveUI.sp(
                                                        16, context),
                                                    fontFamily:
                                                        "MontserratSemiBold"),
                                              )
                                            ],
                                          ),
                                          Icon(Icons.chevron_right)
                                        ],
                                      )),
                                ),
                                SizedBox(height: 12),

                                // Comments
                                Container(
                                    // height: ResponsiveUI.h(
                                    //     _locationSearchScreenVM.comments.length ==
                                    //             0
                                    //         ? 60
                                    //         : 0,
                                    // context),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUI.w(11, context),
                                        vertical: ResponsiveUI.h(16, context)),
                                    width: ResponsiveUI.w(370, context),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: ResponsiveUI.w(300, context),
                                          child: TextFormField(
                                            maxLines: 2,
                                            onChanged: (value) {},
                                            keyboardType: TextInputType.text,
                                            textAlign: TextAlign.start,
                                            controller: _commentsController,
                                            focusNode: _commentsFocusNode,
                                            onTapOutside: (event) =>
                                                _commentsFocusNode.unfocus(),
                                            style: TextStyle(
                                              fontSize:
                                                  ResponsiveUI.sp(16, context),
                                              fontFamily: "MontserratBold",
                                              color: Styles.blackPrimary,
                                            ),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: ResponsiveUI.sp(
                                                    16, context),
                                                fontFamily: "MontserratBold",
                                              ),
                                              hintText: "Comments",
                                              focusColor: Colors.black,
                                              fillColor: Colors.black,
                                              errorBorder: InputBorder.none,
                                              disabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ),
                                        Icon(Icons.chevron_right)
                                      ],
                                    )),
                                SizedBox(height: ResponsiveUI.h(24, context)),

                                // Find a Driver Button
                                SizedBox(
                                  width: double.infinity,
                                  child: FilledButton(
                                    onPressed: () {
                                      // Navigator.pop(context, timeSlots[0]);
                                      _locationSearchScreenVM
                                          .navigateToRideBookingScreen(
                                              _pickupController.text,
                                              _dropController.text);
                                    },
                                    style: ButtonStyle(
                                      fixedSize: WidgetStatePropertyAll(Size(
                                          ResponsiveUI.w(370, context),
                                          ResponsiveUI.h(60, context))),
                                      minimumSize: WidgetStatePropertyAll(Size(
                                          ResponsiveUI.w(370, context),
                                          ResponsiveUI.h(60, context))),
                                      maximumSize: WidgetStatePropertyAll(Size(
                                          ResponsiveUI.w(370, context),
                                          ResponsiveUI.h(60, context))),
                                      shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ResponsiveUI.r(
                                                          10, context)))),
                                      backgroundColor: WidgetStatePropertyAll(Styles
                                          .primaryColor), // Fixed typo: WidgetStatePropertyAll -> MaterialStatePropertyAll
                                    ),
                                    child: Text(
                                      "Find a Driver",
                                      style: TextStyle(
                                        fontFamily: "MontserratBold",
                                        fontSize: ResponsiveUI.sp(14, context),
                                        fontWeight: FontWeight.w400,
                                        color: Styles.backgroundPrimary,
                                        height: 17 / 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDateBottomSheet(BuildContext context) {
    final timeSlots = _locationSearchScreenVM.selectedDateText == "Tomorrow"
        ? _generateTimeSlotsForNextDay()
        : _generateTimeSlots();
    String _getMonthName(int month) {
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return months[month - 1];
    }

    String _getDayName(int weekday) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[weekday - 1];
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Observer(builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUI.w(18, context),
            ),
            decoration: BoxDecoration(
                color: Styles.backgroundWhite,
                borderRadius:
                    BorderRadius.circular(ResponsiveUI.r(20, context))),
            child: _locationSearchScreenVM.isTripDateSelected == true
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: ResponsiveUI.h(27, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Departure Date',
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(20, context),
                                fontFamily: "MontserratBold"),
                          ),
                          GestureDetector(
                            onTap: () {
                              _locationSearchScreenVM.addNavigationToStream(
                                  navigate: NavigatorPop());
                            },
                            child: SvgPicture.asset(
                              AppConstants.grayCloseIcon,
                              width: ResponsiveUI.w(28, context),
                              height: ResponsiveUI.h(25, context),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ResponsiveUI.h(18, context),
                      ),
                      const Divider(
                        color: Color.fromRGBO(185, 185, 185, 1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ResponsiveUI.w(16, context),
                            right: ResponsiveUI.w(16, context),
                            top: ResponsiveUI.h(19, context)),
                        child: Text(
                          '${_getDayName(_locationSearchScreenVM.selectedDate.weekday)}, ${_locationSearchScreenVM.selectedDate.day} ${_getMonthName(_locationSearchScreenVM.selectedDate.month)}',
                          style: TextStyle(
                              fontSize: ResponsiveUI.sp(16, context),
                              fontFamily: "MontserratBold"),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: ResponsiveUI.h(0, context),
                              bottom: ResponsiveUI.h(10, context)),
                          itemCount: timeSlots.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _locationSearchScreenVM.setSelectedTime(
                                    "${timeSlots[index].hour.toString().padLeft(2, '0')}:${timeSlots[index].minute.toString().padLeft(2, '0')}");
                                _locationSearchScreenVM.addNavigationToStream(
                                    navigate: NavigatorPop());
                                _locationSearchScreenVM
                                    .setIsTripDateSelected(false);
                              },
                              child: Container(
                                color: _locationSearchScreenVM.selectedTime ==
                                        "${timeSlots[index].hour.toString().padLeft(2, '0')}:${timeSlots[index].minute.toString().padLeft(2, '0')}"
                                    ? const Color.fromRGBO(225, 225, 225, 0.39)
                                    : Colors.transparent,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveUI.h(15, context),
                                    horizontal: ResponsiveUI.w(10, context)),
                                child: Text(
                                  '${timeSlots[index].hour.toString().padLeft(2, '0')}:${timeSlots[index].minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(20, context),
                                      fontFamily: "MontserratBold"),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: ResponsiveUI.w(370, context), // Custom width
                          height: ResponsiveUI.h(48, context), // Custom height
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context, timeSlots[0]);
                            },
                            style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size(
                                  ResponsiveUI.w(370, context),
                                  ResponsiveUI.h(60, context))),
                              minimumSize: WidgetStatePropertyAll(Size(
                                  ResponsiveUI.w(370, context),
                                  ResponsiveUI.h(60, context))),
                              maximumSize: WidgetStatePropertyAll(Size(
                                  ResponsiveUI.w(370, context),
                                  ResponsiveUI.h(60, context))),
                              shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveUI.r(10, context)))),
                              backgroundColor: WidgetStatePropertyAll(Styles
                                  .primaryColor), // Fixed typo: WidgetStatePropertyAll -> MaterialStatePropertyAll
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                fontFamily: "MontserratBold",
                                fontSize: ResponsiveUI.sp(14, context),
                                fontWeight: FontWeight.w400,
                                color: Styles.backgroundPrimary,
                                height: 17 / 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: ResponsiveUI.h(27, context),
                            bottom: ResponsiveUI.h(18, context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Departure Date',
                              style: TextStyle(
                                  fontSize: ResponsiveUI.sp(20, context),
                                  fontFamily: "MontserratBold"),
                            ),
                            GestureDetector(
                              onTap: () {
                                _locationSearchScreenVM.addNavigationToStream(
                                    navigate: NavigatorPop());
                              },
                              child: SvgPicture.asset(
                                AppConstants.grayCloseIcon,
                                width: ResponsiveUI.w(28, context),
                                height: ResponsiveUI.h(25, context),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Color.fromRGBO(185, 185, 185, 1),
                      ),
                      SizedBox(
                        height: ResponsiveUI.h(18, context),
                      ),
                      GestureDetector(
                        onTap: () {
                          departureDate = DateTime.now();
                          Navigator.pop(context, 'Now');
                          _locationSearchScreenVM.setIsTripDateSelected(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ResponsiveUI.w(370, context),
                          height: ResponsiveUI.h(54, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ResponsiveUI.r(5, context)),
                            color: _locationSearchScreenVM.selectedDateText ==
                                    "Now"
                                ? Color.fromRGBO(225, 225, 225, 0.39)
                                : Colors.transparent,
                          ),
                          child: Text(
                            'Now',
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(20, context),
                                fontFamily: "MontserratBold"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUI.h(6, context),
                      ),
                      GestureDetector(
                        onTap: () {
                          _locationSearchScreenVM
                              .setSelectedDate(DateTime.now());
                          _locationSearchScreenVM.setSelectedDateText("Today");
                          Navigator.pop(context, 'Today');
                          _showDateBottomSheet(context);
                          _locationSearchScreenVM.setIsTripDateSelected(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ResponsiveUI.w(370, context),
                          height: ResponsiveUI.h(54, context),
                          decoration: BoxDecoration(
                            color: _locationSearchScreenVM.selectedDateText ==
                                    "Today"
                                ? Color.fromRGBO(225, 225, 225, 0.39)
                                : Colors.transparent,
                          ),
                          child: Text(
                            'Today',
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(20, context),
                                fontFamily: "MontserratBold"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUI.h(6, context),
                      ),
                      GestureDetector(
                        onTap: () {
                          _locationSearchScreenVM.setSelectedDate(
                              DateTime.now().add(const Duration(days: 1)));
                          _locationSearchScreenVM
                              .setSelectedDateText("Tomorrow");
                          Navigator.pop(context);
                          _showDateBottomSheet(context);
                          _locationSearchScreenVM.setIsTripDateSelected(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: ResponsiveUI.w(370, context),
                          height: ResponsiveUI.h(54, context),
                          decoration: BoxDecoration(
                            color: _locationSearchScreenVM.selectedDateText ==
                                    "Tomorrow"
                                ? Color.fromRGBO(225, 225, 225, 0.39)
                                : Colors.transparent,
                          ),
                          child: Text(
                            'Tomorrow',
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(20, context),
                                fontFamily: "MontserratBold"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUI.h(6, context),
                      ),
                    ],
                  ),
          );
        });
      },
    );
  }

  _showPasangerCountBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: ResponsiveUI.h(342, context),
          child: PasangerSelector(
              onPriceChanged: (p0) {},
              onSubmit: (p0) {
                _locationSearchScreenVM.setNumbserOfPassangers(p0.toInt());
                _locationSearchScreenVM.addNavigationToStream(
                    navigate: NavigatorPop());
              },
              minPrice: _locationSearchScreenVM.numberOfPassangers.toDouble(),
              maxPrice: 7),
        );
      },
    );
  }

  void _showFromLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Styles.backgroundWhite,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(29, context),
                            vertical: ResponsiveUI.h(27, context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: SvgPicture.asset(
                                    AppConstants.grayCloseIcon,
                                    width: ResponsiveUI.w(28, context),
                                    height: ResponsiveUI.h(25, context),
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveUI.h(40, context)),
                              Text(
                                'Specific City and Address',
                                style: TextStyle(
                                  fontSize: ResponsiveUI.sp(25, context),
                                  fontFamily: "MontserratBold",
                                ),
                              ),
                              SizedBox(height: ResponsiveUI.h(22, context)),
                              GestureDetector(
                                onTap: () {
                                  _pickupFocusNode.requestFocus();
                                },
                                child: CustomSearchBar(
                                  LeadingText: "Pickup",
                                  hint: 'Your Current Location',
                                  dotColor: Styles.primaryColor,
                                  controller: _pickupController,
                                  focusNode: _pickupFocusNode,
                                  onFocus: () => setBottomSheetState(
                                      () => _isPickupActive = true),
                                  onChanged: (query) async {
                                    await _onSearchChanged(query, true);
                                    setBottomSheetState(
                                        () {}); // Update bottom sheet state
                                  },
                                  onLocationSelected: _onLocationSelected,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Predictions list
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_predictions.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: _predictions.length,
                              itemBuilder: (context, index) {
                                final prediction = _predictions[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUI.w(29, context),
                                  ),
                                  child: LocationResultTile(
                                      index: index,
                                      name: prediction.mainText,
                                      address: prediction.secondaryText,
                                      onTap: () {
                                        _onLocationSelected(
                                            '${prediction.mainText}, ${prediction.secondaryText}');
                                        _locationSearchScreenVM
                                            .addNavigationToStream(
                                                navigate: NavigatorPop());
                                      }),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showToLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: DraggableScrollableSheet(
                initialChildSize: 0.9,
                minChildSize: 0.5,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Styles.backgroundWhite,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(29, context),
                            vertical: ResponsiveUI.h(27, context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: SvgPicture.asset(
                                    AppConstants.grayCloseIcon,
                                    width: ResponsiveUI.w(28, context),
                                    height: ResponsiveUI.h(25, context),
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveUI.h(40, context)),
                              Text(
                                'Specific City and Address',
                                style: TextStyle(
                                  fontSize: ResponsiveUI.sp(25, context),
                                  fontFamily: "MontserratBold",
                                ),
                              ),
                              SizedBox(height: ResponsiveUI.h(22, context)),
                              GestureDetector(
                                onTap: () {
                                  _dropFocusNode.requestFocus();
                                },
                                child: CustomSearchBar(
                                  LeadingText: "Drop",
                                  hint: 'Your Drop Location',
                                  dotColor: Color.fromRGBO(236, 38, 38, 1),
                                  controller: _dropController,
                                  focusNode: _dropFocusNode,
                                  onFocus: () => setBottomSheetState(
                                      () => _isPickupActive = false),
                                  onChanged: (query) async {
                                    await _onSearchChanged(query, false);
                                    setBottomSheetState(
                                        () {}); // Update bottom sheet state
                                  },
                                  onLocationSelected: _onLocationSelected,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Predictions list
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (_predictions.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: _predictions.length,
                              itemBuilder: (context, index) {
                                final prediction = _predictions[index];
                                return LocationResultTile(
                                    index: index,
                                    name: prediction.mainText,
                                    address: prediction.secondaryText,
                                    onTap: () {
                                      _onLocationSelected(
                                          '${prediction.mainText}, ${prediction.secondaryText}');
                                      _locationSearchScreenVM
                                          .addNavigationToStream(
                                              navigate: NavigatorPop());
                                    });
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  _showCommentsBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [],
        );
      },
    );
  }
}

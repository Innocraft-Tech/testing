import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationHelpers.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/PilotRatingsScreen/PilotRatingsScreenVM.dart';
import 'package:zappy/Reusables/Loader/Loader.dart';

class PilotRatingsScreen extends StatefulWidget {
  final extraData;
  const PilotRatingsScreen({super.key, required this.extraData});

  @override
  State<PilotRatingsScreen> createState() => _PilotRatingsScreenState();
}

class _PilotRatingsScreenState extends State<PilotRatingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PilotRatingsScreenVM _pilotRatingsScreenVM;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _pilotRatingsScreenVM = PilotRatingsScreenVM(widget.extraData);
    _pilotRatingsScreenVM.navigationStream.stream.listen((event) {
      if (event is NavigatorPopAndRemoveUntil) {
        context.pushAndRemoveUntil(
            pageConfig: event.pageConfig,
            removeUntilpageConfig: event.removeUntilpageConfig,
            data: event.data);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return _pilotRatingsScreenVM.isLoading
          ? Loader()
          : Scaffold(
              backgroundColor: Styles.backgroundWhite,
              body: SafeArea(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClipOval(
                        child: Image.network(
                          _pilotRatingsScreenVM
                                  .currentRideRequest.pilotImageUrl ??
                              '',
                          width: ResponsiveUI.w(110, context),
                          height: ResponsiveUI.h(110, context),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: ResponsiveUI.w(110, context),
                              height: ResponsiveUI.h(110, context),
                              color: Colors.grey[400],
                              child:
                                  Icon(Icons.person, color: Colors.grey[700]),
                            );
                          },
                        ),
                      ),
                      Text(
                        "How was the Pilot?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ResponsiveUI.sp(20, context),
                            fontFamily: "MontserratBold"),
                      ),
                      Text(
                        "Help ZappyRide do better by rating this trip",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ResponsiveUI.sp(13, context),
                            fontFamily: "MontserratRegular"),
                      ),
                      Divider(
                        color: Styles.dividerColor,
                        thickness: 1,
                      ),
                      RatingBar(
                        initialRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Container(
                            child: SvgPicture.asset(
                              fit: BoxFit.fill,
                              AppConstants.filledRatingsStar,
                              color: Styles.primaryColor,
                            ),
                          ),
                          half: SvgPicture.asset(AppConstants.ratingsStar),
                          empty: SvgPicture.asset(AppConstants.ratingsStar),
                        ),
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      Divider(
                        color: Styles.dividerColor,
                        thickness: 1,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(16, context),
                            vertical: ResponsiveUI.h(15, context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(15, context),
                            vertical: ResponsiveUI.h(15, context)),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ride",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                ),
                                Text(
                                  "Zappy Auto",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                )
                              ],
                            ),
                            SizedBox(
                              height: ResponsiveUI.h(17, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payment",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                ),
                                Text(
                                  "Online",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(16, context)),
                        padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUI.w(15, context),
                            vertical: ResponsiveUI.h(15, context)),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trip Fare",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                ),
                                Text(
                                  '₹ ${_pilotRatingsScreenVM.currentRideRequest.fare.toString()}',
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(16, context),
                                      fontFamily: "MontserratSemiBold"),
                                )
                              ],
                            ),
                            SizedBox(
                              height: ResponsiveUI.h(17, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Discount",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                ),
                                Text(
                                  "₹ 0.00",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(16, context),
                                      fontFamily: "MontserratSemiBold"),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Paid",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(14, context),
                                      fontFamily: "MontserratRegular"),
                                ),
                                Text(
                                  "₹ ${_pilotRatingsScreenVM.currentRideRequest.fare.toString()}",
                                  style: TextStyle(
                                      fontSize: ResponsiveUI.sp(16, context),
                                      fontFamily: "MontserratSemiBold"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUI.h(85, context),
                      ),
                      FilledButton(
                          onPressed: () {
                            _pilotRatingsScreenVM.navigateToHomeScreen();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Styles.primaryColor),
                              fixedSize: WidgetStatePropertyAll(Size(
                                  ResponsiveUI.w(367, context),
                                  ResponsiveUI.h(60, context))),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ResponsiveUI.r(10, context))),
                              )),
                          child: Text(
                            "Give Ratings",
                            style: TextStyle(
                                fontSize: ResponsiveUI.sp(14, context),
                                fontFamily: "MontserratBold"),
                          ))
                    ],
                  ),
                ),
              ),
            );
    });
  }
}

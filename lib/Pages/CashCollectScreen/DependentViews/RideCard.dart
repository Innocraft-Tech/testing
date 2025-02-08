import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Pages/CashCollectScreen/DependentViews/RideLocationInfo.dart';

class RideCard extends StatefulWidget {
  RideBO ride;
  RideCard({super.key, required this.ride});

  @override
  State<RideCard> createState() => _RideCardState();
}

class _RideCardState extends State<RideCard> {
  // Method to add ordinal suffix to the day
  String getFormattedDate(DateTime date) {
    final day = DateFormat('d').format(date);
    final suffix = _getDaySuffix(int.parse(day));
    final formattedDate = DateFormat('EEEE, d MMMM yyyy').format(date);
    return formattedDate.replaceFirst(day, '$day$suffix');
  }

  // Helper method to determine the suffix
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUI.r(5, context)),
        border: Border.all(color: const Color.fromRGBO(236, 236, 236, 1)),
      ),
      padding: EdgeInsets.only(
        left: ResponsiveUI.w(20, context),
        right: ResponsiveUI.w(11, context),
        top: ResponsiveUI.h(10, context),
        bottom: ResponsiveUI.h(11, context),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              getFormattedDate(widget.ride.date),
              style: TextStyle(
                fontSize: ResponsiveUI.w(12, context),
                fontFamily: "MontserratsemiBold",
                color: Styles.blackPrimary,
              ),
            ),
          ),
          SizedBox(
            height: ResponsiveUI.h(8, context),
          ),
          Row(
            children: [
              Image.asset(
                AppConstants.cashAuto, // Replace with your actual image path
                width: ResponsiveUI.w(48, context),
                height: ResponsiveUI.h(48, context),
              ),
              SizedBox(width: ResponsiveUI.w(30, context)),
              SizedBox(
                width: ResponsiveUI.w(157, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto ',
                      style: TextStyle(
                        fontSize: ResponsiveUI.w(14, context),
                        fontFamily: "MontserratSemiBold",
                        color: Styles.blackPrimary,
                      ),
                    ),
                    SizedBox(height: ResponsiveUI.h(2, context)),
                    Text(
                      widget.ride.status,
                      style: TextStyle(
                        fontSize: ResponsiveUI.sp(12, context),
                        fontFamily: "Montserrat",
                        color: Styles.greemTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveUI.w(30, context)),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '₹ ${widget.ride.fare}',
                  style: TextStyle(
                    fontSize: ResponsiveUI.sp(16, context),
                    fontFamily: "MontserratBold",
                  ),
                ),
              ),
              SizedBox(
                width: ResponsiveUI.w(20, context),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUI.h(22, context)),
            child: RideLocationInfo(currentRide: widget.ride),
          ),
        ],
      ),
    );
  }
}

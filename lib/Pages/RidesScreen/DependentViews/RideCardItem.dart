import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:intl/intl.dart';
import 'package:zappy/Pages/RidesScreen/DependentViews/RideLocationInfo.dart';

class RideCardItem extends StatefulWidget {
  RideBO ride;
  RideCardItem({super.key, required this.ride});

  @override
  State<RideCardItem> createState() => _RideCardItemState();
}

class _RideCardItemState extends State<RideCardItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(114, 114, 114, 0.39),
          borderRadius: BorderRadius.circular(ResponsiveUI.r(5, context))),
      padding: EdgeInsets.only(
          left: ResponsiveUI.w(20, context),
          right: ResponsiveUI.w(11, context),
          top: ResponsiveUI.h(10, context),
          bottom: ResponsiveUI.h(11, context)),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                widget.ride.vehicleName == "Auto"
                    ? AppConstants.cashAuto
                    : AppConstants.cashCollection,
                width: ResponsiveUI.w(48, context),
                height: ResponsiveUI.h(48, context),
              ),
              SizedBox(
                width: ResponsiveUI.w(30, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          text: '${widget.ride.vehicleName} ',
                          style: TextStyle(
                              fontSize: ResponsiveUI.w(14, context),
                              fontFamily: "MontserratSemiBold",
                              color: Color.fromRGBO(255, 255, 255, 1)),
                          children: [
                        TextSpan(
                            text: DateFormat('dd/mm/yyyy • hh:mm a')
                                .format(widget.ride.date),
                            style: TextStyle(
                                fontSize: ResponsiveUI.w(10, context),
                                fontFamily: "MontserratRegular",
                                color: Styles.lightGrayText))
                      ])),
                  SizedBox(
                    height: ResponsiveUI.h(2, context),
                  ),
                  Text(
                    widget.ride.status,
                    style: TextStyle(
                        fontSize: ResponsiveUI.sp(12, context),
                        fontFamily: "Montserrat",
                        color: Styles.greemTextColor),
                  )
                ],
              ),
              SizedBox(
                width: ResponsiveUI.w(30, context),
              ),
              Text('₹ ${widget.ride.fare}',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: ResponsiveUI.sp(16, context),
                      fontFamily: "MontserratBold"))
            ],
          ),
          Divider(
            color: Styles.grayText,
          ),
          Padding(
            padding: EdgeInsets.only(top: ResponsiveUI.h(15, context)),
            child: RideLocationInfo(currentRide: widget.ride),
          )
        ],
      ),
    );
  }
}

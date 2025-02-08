import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

Widget buildInfoBox(BuildContext context, String fare, String duration) {
  return Padding(
    padding: EdgeInsets.only(top: ResponsiveUI.h(8, context)),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUI.w(10, context),
        vertical: ResponsiveUI.h(10, context),
      ),
      decoration: BoxDecoration(
        color: Styles.lightWhiteContainer,
        borderRadius: BorderRadius.circular(ResponsiveUI.r(20, context)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppConstants.infoIcon,
            width: ResponsiveUI.w(24, context),
            height: ResponsiveUI.h(24, context),
          ),
          SizedBox(width: ResponsiveUI.w(12, context)),
          Text(
            "Recommended price ₹ ${fare}. \nTravel time: ~${duration ?? 0} mins",
            style: TextStyle(
              fontSize: ResponsiveUI.sp(14, context),
            ),
          )
        ],
      ),
    ),
  );
}

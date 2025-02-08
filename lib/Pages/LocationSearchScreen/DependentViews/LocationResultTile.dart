import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/LocationSearchScreen/AppColors.dart';

class LocationResultTile extends StatelessWidget {
  final String name;
  final String address;
  final VoidCallback onTap;
  final int index;

  const LocationResultTile({
    super.key,
    required this.name,
    required this.address,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: ResponsiveUI.h(21, context),
            left: ResponsiveUI.w(16, context),
            right: ResponsiveUI.w(16, context)),
        child: Row(
          children: [
            SvgPicture.asset(
              AppConstants.locationIcon,
              color: Styles.textColor,
              width: ResponsiveUI.w(24, context),
              height: ResponsiveUI.h(24, context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Styles.textColor,
                      fontFamily: "MontserratSemiBold",
                      fontSize: ResponsiveUI.sp(14, context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveUI.h(6, context)),
                  Text(
                    address,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: "MontserratRegular",
                      fontSize: ResponsiveUI.sp(14, context),
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppConstants.locationIndicator,
              width: ResponsiveUI.w(24, context),
              height: ResponsiveUI.h(24, context),
              color: Styles.textColor,
            ),
          ],
        ),
      ),
    );
  }
}

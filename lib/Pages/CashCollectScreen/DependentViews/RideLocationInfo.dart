import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/CashCollectScreen/DependentViews/Dashed_line_pointer.dart';
import 'package:zappy/Pages/CashCollectScreen/DependentViews/Location.dart';

class RideLocationInfo extends StatelessWidget {
  final RideBO currentRide;

  const RideLocationInfo({
    super.key,
    required this.currentRide,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Stack(
        children: [
          // Dashed line
          Positioned(
            left: ResponsiveUI.w(7, context),
            top: ResponsiveUI.h(10, context),
            bottom: ResponsiveUI.h(10, context),
            child: CustomPaint(
              painter: DashedLinePainter(),
              child: Container(width: ResponsiveUI.w(2, context)),
            ),
          ),
          // Location details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LocationItem(
                location: Location(
                  address: currentRide.pickupAddress,
                ),
                icon: Container(
                  width: ResponsiveUI.w(12, context),
                  height: ResponsiveUI.h(12, context),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUI.h(16, context)),
              _LocationItem(
                location: Location(
                  address: currentRide.dropAddress,
                ),
                icon: Container(
                  width: ResponsiveUI.w(12, context),
                  height: ResponsiveUI.h(12, context),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _LocationItem extends StatelessWidget {
  final Location location;
  final Widget icon;

  const _LocationItem({
    required this.location,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: ResponsiveUI.w(14, context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.address,
                  style: TextStyle(
                    fontFamily: "MontserratRegular",
                    color: Styles.grayText,
                    fontSize: ResponsiveUI.sp(12, context),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/AnimatedloadingContainer.dart';

class PasangerSelector extends StatefulWidget {
  final double initialPrice;
  final Function(double) onPriceChanged;
  final Function(double) onSubmit;
  final double minPrice;
  final double maxPrice;

  const PasangerSelector({
    Key? key,
    this.initialPrice = 1,
    required this.onPriceChanged,
    required this.onSubmit,
    required this.minPrice,
    required this.maxPrice,
  }) : super(key: key);

  @override
  _PriceSelectorState createState() => _PriceSelectorState();
}

class _PriceSelectorState extends State<PasangerSelector> {
  late double currentPrice;
  bool autoAccept = false;

  @override
  void initState() {
    super.initState();
    currentPrice = widget.minPrice;
  }

  void _adjustPrice(double amount) {
    setState(() {
      currentPrice =
          (currentPrice + amount).clamp(widget.minPrice, widget.maxPrice);
      if (currentPrice <= widget.maxPrice) {
        widget.onPriceChanged(currentPrice);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUI.w(18, context),
          vertical: ResponsiveUI.h(26, context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUI.r(12, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How many of you will go?',
                style: TextStyle(
                    fontSize: ResponsiveUI.sp(20, context),
                    fontFamily: "MontserratBold"),
              ),
              SvgPicture.asset(
                AppConstants.grayCloseIcon,
                width: ResponsiveUI.w(28, context),
                height: ResponsiveUI.h(25, context),
              )
            ],
          ),
          SizedBox(height: ResponsiveUI.h(43, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAdjustButton(
                onPressed: () => _adjustPrice(-1),
                source: AppConstants.minusIcon,
                isDecrease: currentPrice > widget.initialPrice,
              ),
              Text(
                '${currentPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: ResponsiveUI.sp(35, context),
                  fontFamily: "MontserratBold",
                ),
              ),
              _buildAdjustButton(
                onPressed: () => _adjustPrice(1),
                source: AppConstants.plusIcon,
                isDecrease: currentPrice >= widget.initialPrice,
              ),
            ],
          ),
          SizedBox(height: ResponsiveUI.h(56, context)),
          ElevatedButton(
            onPressed: () {
              // Handle raising fare
              widget.onSubmit(currentPrice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildAdjustButton({
    required VoidCallback onPressed,
    required String source,
    required bool isDecrease,
  }) {
    return Container(
      alignment: Alignment.center,
      width: ResponsiveUI.w(69, context),
      height: ResponsiveUI.h(69, context),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(ResponsiveUI.r(10, context)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUI.w(16, context),
                  vertical: ResponsiveUI.h(8, context)),
              child: SvgPicture.asset(
                source,
                color: isDecrease ? Styles.blackPrimary : Styles.blackPrimary,
                width: ResponsiveUI.w(28, context),
                height: ResponsiveUI.h(28, context),
              )),
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/AnimatedloadingContainer.dart';

class PriceSelector extends StatefulWidget {
  final double initialPrice;
  final Function(double) onPriceChanged;
  final Function(double) onSubmit;
  final double minPrice;
  final double maxPrice;
  final isFareLoading;

  const PriceSelector({
    Key? key,
    this.initialPrice = 370,
    required this.onPriceChanged,
    required this.onSubmit,
    required this.minPrice,
    required this.maxPrice,
    required this.isFareLoading,
  }) : super(key: key);

  @override
  _PriceSelectorState createState() => _PriceSelectorState();
}

class _PriceSelectorState extends State<PriceSelector> {
  late double currentPrice;
  bool autoAccept = false;

  @override
  void initState() {
    super.initState();
    currentPrice = widget.initialPrice;
  }

  void _adjustPrice(double amount) {
    setState(() {
      currentPrice =
          (currentPrice + amount).clamp(widget.minPrice, widget.maxPrice);
      widget.onPriceChanged(currentPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'Offering Your Prices',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveUI.sp(20, context),
              fontFamily: "MontserratBold",
            ),
          ),
          SizedBox(height: ResponsiveUI.h(19, context)),
          const AnimatedPriceProgress(),
          SizedBox(height: ResponsiveUI.h(38, context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAdjustButton(
                onPressed: () => _adjustPrice(-10),
                label: '-10',
                isDecrease: currentPrice > widget.initialPrice,
              ),
              Text(
                '₹${currentPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildAdjustButton(
                onPressed: () => _adjustPrice(10),
                label: '+10',
                isDecrease: currentPrice >= widget.initialPrice,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Your Offer',
              style: TextStyle(
                  color: Styles.lightGrayTextSecondary,
                  fontSize: ResponsiveUI.sp(16, context),
                  fontFamily: "MontserratBold"),
            ),
          ),
          const SizedBox(height: 16),
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
            child: widget.isFareLoading
                ? CircularProgressIndicator(
                    color: Styles.backgroundWhite,
                  )
                : Text(
                    'Raise Your Fare',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAdjustButton({
    required VoidCallback onPressed,
    required String label,
    required bool isDecrease,
  }) {
    return Container(
      alignment: Alignment.center,
      width: ResponsiveUI.w(69, context),
      height: ResponsiveUI.h(69, context),
      decoration: BoxDecoration(
        color: isDecrease ? Styles.primaryColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(ResponsiveUI.r(10, context)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUI.w(16, context),
                vertical: ResponsiveUI.h(8, context)),
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUI.sp(18, context),
                fontFamily: "MontserratBold",
                color: isDecrease ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

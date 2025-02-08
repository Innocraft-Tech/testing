import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zappy/Helpers/AppConstants/AppConstants.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class CancellationReasonScreen extends StatefulWidget {
  const CancellationReasonScreen({super.key});

  @override
  State<CancellationReasonScreen> createState() =>
      _CancellationReasonScreenState();
}

class _CancellationReasonScreenState extends State<CancellationReasonScreen> {
  String? selectedReason;

  final List<String> cancellationReasons = [
    'Change Plans',
    'Waiting for a long time',
    'Unable to contact driver',
    'Driver denied to go to destination',
    'Driver denied to pickup location',
    'Wrong address shown',
    'The price is not a reasonable',
    'Emergency situation',
    'Booking mistake',
    'Poor weather condition',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ResponsiveUI.w(348, context),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        AppConstants.backOption,
                        width: ResponsiveUI.w(24, context),
                        height: ResponsiveUI.h(24, context),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: ResponsiveUI.w(100, context)),
                      child: Text(
                        'Cancel Ride',
                        style: TextStyle(
                          fontSize: ResponsiveUI.sp(20, context),
                          fontFamily: "MontserratBold",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: ResponsiveUI.h(26, context)),
              Text(
                'Why are you cancelling?',
                style: TextStyle(
                  fontSize: ResponsiveUI.sp(18, context),
                  fontFamily: "MontserratBold",
                ),
              ),
              SizedBox(height: ResponsiveUI.h(20, context)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: cancellationReasons.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ResponsiveUI.h(5, context)),
                      child: RadioListTile<String>(
                        title: Text(
                          cancellationReasons[index],
                          style: TextStyle(
                            fontSize: ResponsiveUI.sp(14, context),
                            fontFamily: "MontserratSemiBold",
                          ),
                        ),
                        value: cancellationReasons[index],
                        groupValue: selectedReason,
                        activeColor: const Color(
                            0xFF4B39EF), // Purple color from the image
                        onChanged: (value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: selectedReason != null
                      ? () {
                          // Handle confirmation here
                          print('Selected reason: $selectedReason');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B39EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor:
                        const Color(0xFF4B39EF).withOpacity(0.5),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

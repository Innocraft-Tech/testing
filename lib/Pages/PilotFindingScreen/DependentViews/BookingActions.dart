import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:async';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';
import 'package:zappy/Helpers/ResponsiveUI.dart';

class BookingActions extends StatefulWidget {
  late List<dynamic> extraData;
  BookingActions({super.key, required this.extraData});

  @override
  State<BookingActions> createState() => _BookingActionsState();
}

class _BookingActionsState extends State<BookingActions> {
  late Timer _timer;
  late int _timeLeft;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.extraData[0] as int;
    loading = false;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          // Update the extraData to reflect the new time
          widget.extraData[0] = _timeLeft;
        } else {
          _timer.cancel();
          // Call the decline function when timer reaches 0
          widget.extraData[2]();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  backgroundColor: Color.fromRGBO(217, 217, 217, 1)),
              onPressed: () {
                widget.extraData[2]();
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  fontFamily: "MontserratBold",
                  color: Colors.black,
                  fontSize: ResponsiveUI.sp(16, context),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveUI.w(45, context)),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.extraData[1]();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _timeLeft == 0 ? Styles.carouselRed : Styles.blueContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Accept',
                    style: TextStyle(
                      fontFamily: "MontserratBold",
                      fontSize: ResponsiveUI.sp(16, context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: ResponsiveUI.w(20, context)),
                  Container(
                    width: ResponsiveUI.w(30, context),
                    height: ResponsiveUI.h(30, context),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.5,
                          color: Styles.blueContainer),
                    ),
                    child: Observer(builder: (context) {
                      return Text(
                        !loading ? _timeLeft.toString() : 0.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "MontserratSemiBold",
                          fontSize: ResponsiveUI.sp(12, context),
                          color: Colors.black,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

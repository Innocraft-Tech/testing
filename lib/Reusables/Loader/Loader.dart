import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zappy/Helpers/Resources/Styles/Styles.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Styles.primaryColor,
        ),
      ),
    );
  }
}

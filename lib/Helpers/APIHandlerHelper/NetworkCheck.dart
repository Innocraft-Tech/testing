// ignore_for_file: file_names

import 'dart:async';
import '../Utilities/Utilities.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkCheck {
  /* Create a checkInternetConnectivity method to check the device's internet connection */
  static Future<bool> checkInternetConnectivity() async {
    try {
      // Invoke InternetConnectionChecker().hasConnection to observer the connection and store it in result.
      bool result = await InternetConnectionChecker().hasConnection;

      // Check, if result is true return true
      // Else, return false.
      return (result == true) ? true : false;
    } catch (e) {
      e.logExceptionData();
      return false;
    }
  }

  static Stream<InternetConnectionStatus> checkInternetConnectivityStream() {
    try {
      return InternetConnectionChecker().onStatusChange;
    } catch (e) {
      e.logExceptionData();
      rethrow;
    }
  }
}

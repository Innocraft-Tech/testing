// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:intl/intl.dart';

extension ExceptionalHandling on Object {
  void logExceptionData() {
    try {
      // print the catched exception
      debugPrint("* --_-- Exception --_-- *");

      debugPrint(this.toString());

      debugPrint("* --_-- --_-- *");
    } catch (error) {
      debugPrint("* --_-- Exception --_-- *");

      // prints the exception caught while printing the exception
      debugPrint(error.toString());

      debugPrint("* --_-- --_-- *");
    }
  }
}

extension StringExtension on String {
  String pascalCase() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

/// Creates an instance of the [PlatformWrapper] class to provide access to platform-specific functionalities.
///
/// Example usage:
/// ```dart
/// PlatformWrapper platformWrapper = PlatformWrapper();
/// bool isWindows = platformWrapper.isWindows;
/// print('Is Windows? $isWindows');
/// ```
class PlatformWrapper {
  /// Returns a boolean value indicating whether the current platform is Windows.
  ///
  /// Returns `true` if the current platform is Windows, and `false` otherwise.
  bool get isWindows => Platform.isWindows;
}

class Utilities {
  static Map<String, double> calculateDuration(double distance) {
    // Average speeds in km/h
    const double bikeSpeed = 40.0; // km/h
    const double cabSpeed = 60.0; // km/h
    const double autoSpeed = 30.0; // km/h

    // Calculate time in hours
    double bikeTime = distance / bikeSpeed;
    double cabTime = distance / cabSpeed;
    double autoTime = distance / autoSpeed;

    // Convert time to minutes
    bikeTime *= 60;
    cabTime *= 60;
    autoTime *= 60;

    return {
      "Bike": bikeTime,
      "Cab": cabTime,
      "Auto": autoTime,
    };
  }

  static String calculateDropTime(String vehicleName, double distance) {
    // Calculate duration based on vehicle type
    double duration = vehicleName == "Auto"
        ? Utilities.calculateDuration(distance)["Auto"] ?? 0
        : vehicleName == "Bike"
            ? Utilities.calculateDuration(distance)["Bike"] ?? 0
            : vehicleName.contains("Cab")
                ? Utilities.calculateDuration(distance)["Cab"] ?? 0
                : 0;

    // Calculate drop time
    DateTime dropTime = DateTime.now().add(Duration(minutes: duration.toInt()));

    // Format time with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(dropTime);

    return "${duration.toStringAsFixed(0)} min. Drop $formattedTime";
  }

  static double calculatePrice(String vehicleType, double distance) {
    double price = 0;
    int firstKm = 4; // Base distance
    double firstKmPrice = 0;
    double extraKmPrice = 0;

    // Assign rates based on vehicle type
    switch (vehicleType) {
      case "Sedan":
        firstKmPrice = 100;
        extraKmPrice = 20;
        break;
      case "Mini":
        firstKmPrice = 100;
        extraKmPrice = 22;
        break;
      case "XUV":
        firstKmPrice = 150;
        extraKmPrice = 25;
        break;
      case "Auto":
        firstKmPrice = 80;
        extraKmPrice = 15;
        break;
      case "Car Model X":
        firstKmPrice = 50;
        extraKmPrice = 8;
        break;
      default:
        throw Exception("Invalid vehicle type");
    }

    // Calculate price
    if (distance <= firstKm) {
      price = firstKmPrice;
    } else {
      price = firstKmPrice + ((distance - firstKm) * extraKmPrice);
    }

    return price;
  }

  static String convertMinutesToHours(int minutes) {
    int hours = minutes ~/ 60; // Get the whole hours
    int remainingMinutes = minutes % 60; // Get the remaining minutes
    return '$hours H $remainingMinutes Mins';
  }
}

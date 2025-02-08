// Create a Class named ResponsiveUI
import 'package:flutter/material.dart';

class ResponsiveUI {
  // Set the base width according to the figma design
  static num? baseWidth;
  // Set the base height according to the figma design
  static num? baseHeight;

// Create a method for responsive width
  static w(double width, BuildContext context) {
    // Create an variable named **percentage** of type double
    // Calculate (width * 100) / baseWidth
    Orientation orientation = MediaQuery.of(context).orientation;
    double deviceWidth = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    double percentage = (width * 100) / baseWidth!;
    // Return ((MediaQuery.of(context).size.width) * (percentage)) / 100
    return (deviceWidth * (percentage)) / 100;
  }

// Create a method for responsive height
  static h(double height, BuildContext context) {
    // Create an variable named **percentage** of type double
    // Calculate (height * 100) / baseHeight
    Orientation orientation = MediaQuery.of(context).orientation;
    double deviceHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double percentage = (height * 100) / baseHeight!;
    // Return ((MediaQuery.of(context).size.height) * (percentage)) / 100
    return (deviceHeight * (percentage)) / 100;
  }

// Create a method for responsive fonts
  static sp(double size, BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double screenHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double screenWidth = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    // Initialize a variable **widthScaleFactor** with **screenWidth / baseWidth** as value
    double widthScaleFactor = screenWidth / baseWidth!;
    // Initialize a variable **heightScaleFactor** with **screenWidth / baseHeight** as value
    double heightScaleFactor = screenHeight / baseHeight!;
    // Initialize a variable **scaleFactor** with **(widthScaleFactor + heightScaleFactor) / 2.0** as value
    double scaleFactor = (widthScaleFactor + heightScaleFactor) / 2.0;

// Return size * scaleFactor
    return size * scaleFactor;
  }

// Create a variable for responsive radius
  static r(double radius, BuildContext context) {
    // Create a variable named *screenWidth** with MediaQuery.of(context).size.width as value
    double screenWidth = MediaQuery.of(context).size.width;
    // Create a variable named *screenHeight** with MediaQuery.of(context).size.height as value
    double screenHeight = MediaQuery.of(context).size.height;

    // Initialize a variable **widthScaleFactor** with **screenWidth / baseWidth** as value
    double widthScaleFactor = screenWidth / baseWidth!;
    // Initialize a variable **heightScaleFactor** with **screenWidth / baseHeight** as value
    double heightScaleFactor = screenHeight / baseHeight!;
    // Initialize a variable **scaleFactor** with **(widthScaleFactor + heightScaleFactor) / 2.0** as value
    double scaleFactor = (widthScaleFactor + heightScaleFactor) / 2.0;

// Return radius * scaleFactor
    return radius * scaleFactor;
  }

// Create a variable for responsive line Height
  static th(double height, double fontSize, BuildContext context) {
    // Create a variable named *screenHeight** with MediaQuery.of(context).size.height as value
    double screenHeight = MediaQuery.of(context).size.height;
    // Initialize a variable **heightScaleFactor** with **screenWidth / baseHeight** as value
    double heightScaleFactor = screenHeight / baseHeight!;
    // Intialize a variable **responsiveFontSize** with **fontSize * heightScaleFactor** as value
    double responsiveFontSize = fontSize * heightScaleFactor;
    // Intialize a variable **responsiveLineHeight** with **height * heightScaleFactor** as value
    double responsiveLineHeight = height * heightScaleFactor;
    // Intialize a variable **responsiveLineHeightMultiplier** with **responsiveLineHeight / responsiveFontSize** as value
    double responsiveLineHeightMultiplier =
        responsiveLineHeight / responsiveFontSize;
    // return responsiveLineHeightMultiplier
    return responsiveLineHeightMultiplier;
  }

  // Create a method named circleRadius for circle Radius
  static circleRadius(BuildContext context, double height, double width) {
    // Initialize a variable **heightScaleFactor** with **h(height, context);** as value
    double heightScaleFactor = h(height, context);
    // Initialize a variable **widthScaleFactor** with **w(width, context)** as value
    double widthScaleFactor = w(width, context);
    // Initialize a variable **radius** with **widthScaleFactor < heightScaleFactor ? widthScaleFactor : heightScaleFactor** as value
    double radius = widthScaleFactor < heightScaleFactor
        ? widthScaleFactor
        : heightScaleFactor;
    // Return radius
    return radius;
  }

  static ch(BuildContext context, double padding) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double deviceHeight = orientation == Orientation.landscape
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;

    double height = deviceHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        padding;
    return height;
  }

  static csh(BuildContext context, double padding) {
    double height = padding -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        padding;
    return height;
  }
}

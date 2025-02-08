import 'package:zappy/Pages/CashCollectScreen/CashCollectScreen.dart';
import 'package:zappy/Pages/HomeScreen/HomeScreen.dart';
import 'package:zappy/Pages/LocationPickerScreen/LocationPickerScreen.dart';
import 'package:zappy/Pages/LocationSearchScreen/DependentViews/LocationSearchBar.dart';
import 'package:zappy/Pages/LocationSearchScreen/LocationSearchScreen.dart';
import 'package:zappy/Pages/NameScreen/NameScreen.dart';
import 'package:zappy/Pages/OTPScreen/OTPScreen.dart';
import 'package:zappy/Pages/LoginScreen/LoginScreen.dart';
import 'package:zappy/Pages/PilotFindingScreen/PilotFindingScreen.dart';
import 'package:zappy/Pages/PilotRatingsScreen/PilotRatingsScreen.dart';
import 'package:zappy/Pages/ProfileScreen/ProfileScreen.dart';
import 'package:zappy/Pages/RideBookingScreen/RideBookingScreen.dart';
import 'package:zappy/Pages/RideRatings/RideRatingsScreen.dart';
import 'package:zappy/Pages/RideTrackingScreen/RideTrackingScreen.dart';
import 'package:zappy/Pages/RidesScreen/RidesScreen.dart';
import 'package:zappy/Pages/SavedAddressScreen/SavedAddressScreen.dart';
import 'package:zappy/Pages/SplashScreen/SplashScreen.dart';
import 'package:zappy/Pages/UserAccountScreen/UserAccountScreen.dart';

import 'NavigationHelpers.dart';

enum Routes {
  SplashScreen,
  Loginscreen,
  OTPScreen,
  HomeScreen,
  LocationSearchScreen,
  NameScreen,
  RideBookingScreen,
  PilotFindingScreen,
  ProfileScreen,
  SavedAddressScreen,
  RideTrackingScreen,
  CashCollectionScreen,
  RideRatingsScreen,
  pilotRatingsScreen,
  LocationPickerScreen,
  RidesScreenConfig,
  UserAccountScreen
}

class Pages {
  //! Data for Bottom Nav Config
  Object? data;

  //! Screen Config
  static final PageConfig splashScreenConfig = PageConfig(
    route: Routes.SplashScreen,
    build: (_) => SplashScreen(),
  );
  static final PageConfig loginScreenConfig = PageConfig(
    route: Routes.Loginscreen,
    build: (_) => LoginScreen(),
  );
  static final PageConfig otpScreenConfig = PageConfig(
    route: Routes.OTPScreen,
    build: (_) => OTPScreen(
      mobileNumber: otpScreenConfig.data,
    ),
  );

  static final PageConfig homeScreenConfig = PageConfig(
    route: Routes.HomeScreen,
    build: (_) => HomeScreen(),
  );

  static final PageConfig locationSearchScreenConfig = PageConfig(
    route: Routes.LocationSearchScreen,
    build: (_) => LocationSearchScreen(
      locations: locationSearchScreenConfig.data,
    ),
  );
  static final PageConfig nameScreenConfig = PageConfig(
    route: Routes.NameScreen,
    build: (_) => NameScreen(),
  );
  static final PageConfig rideBookingScreenConfig = PageConfig(
    route: Routes.RideBookingScreen,
    build: (_) => RideBookingScreen(
      extraData: rideBookingScreenConfig.data,
    ),
  );
  static final PageConfig pilotFindingScreenConfig = PageConfig(
    route: Routes.PilotFindingScreen,
    build: (_) => PilotFindingScreen(extraData: pilotFindingScreenConfig.data),
  );
  static final PageConfig profileScreenConfig = PageConfig(
    route: Routes.ProfileScreen,
    build: (_) => ProfileScreen(),
  );
  static final PageConfig savedAddressScreenConfig = PageConfig(
    route: Routes.SavedAddressScreen,
    build: (_) => SavedAddressScreen(),
  );
  static final PageConfig rideTrackingScreenConfig = PageConfig(
    route: Routes.RideTrackingScreen,
    build: (_) => RideTrackingScreen(
      currentRide: rideTrackingScreenConfig.data,
    ),
  );
  static final PageConfig cashCollectionScreenConfig = PageConfig(
    route: Routes.CashCollectionScreen,
    build: (_) => CashCollectScreen(
      extraData: rideTrackingScreenConfig.data,
    ),
  );
  static final PageConfig rideRatingsScreenScreenConfig = PageConfig(
    route: Routes.RideRatingsScreen,
    build: (_) => RideRatingsScreen(
      extraData: rideTrackingScreenConfig.data,
    ),
  );
  static final PageConfig pilotRatingsScreenScreenConfig = PageConfig(
    route: Routes.pilotRatingsScreen,
    build: (_) => PilotRatingsScreen(
      extraData: rideTrackingScreenConfig.data,
    ),
  );
  static final PageConfig locationPikerScreenScreenConfig = PageConfig(
    route: Routes.LocationPickerScreen,
    build: (_) => LocationPickerScreen(),
  );
  static final PageConfig ridesScreenScreenConfig = PageConfig(
    route: Routes.RidesScreenConfig,
    build: (_) => RidesScreen(),
  );
  static final PageConfig userAccountScreenScreenConfig = PageConfig(
      route: Routes.UserAccountScreen, build: (_) => UserAccountScreen());
}

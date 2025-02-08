import 'package:zappy/Helpers/AppNavigations/NavigationConfig.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/PilotRatingsScreen/PilotRatingsScreenModel.dart';

class PilotRatingsScreenVM extends PilotRatingsScreenModel {
  PilotRatingsScreenVM(RideBO currentRide) {
    setIsLoading(true);
    setCurrentRideRequest(currentRide);
    setIsLoading(false);
    getRideData();
  }
  void navigateToHomeScreen() {
    try {
      addNavigationToStream(
          navigate: NavigatorPopAndRemoveUntil(
              pageConfig: Pages.homeScreenConfig,
              removeUntilpageConfig: Pages.homeScreenConfig,
              data: ""));
    } catch (error) {
      error.logExceptionData();
    }
  }

  void getRideData() async {
    try {
      ServiceResult<RideBO> currentRide =
          await rideServices.getRideById(currentRideRequest.rideId!);
      if (currentRide.statusCode == ServiceStatusCode.OK) {
        setCurrentRideRequest(currentRide.content!);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }
}

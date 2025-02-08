import 'package:flutter/rendering.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Pages/RidesScreen/RidesScreenModel.dart';

class RidesScreenVM extends RidesScreenModel {
  RidesScreenVM() {
    //init();
    setIsLoading(true);
    setDate(DateTime.now());
    getRidesData();
  }

  void getRidesData() async {
    try {
      setIsLoading(true);
      ServiceResult<String?> mobileNumber =
          await secureStorageService.retrieveData(key: "mobile_number");
      ServiceResult<List<RideBO>> rides =
          await rideApiServices.getRidesByUser(mobileNumber.content!);
      if (rides.statusCode == ServiceStatusCode.OK) {
        setRides(rides.content!);
        setIsLoading(false);
      }
    } catch (error) {
      error.logExceptionData();
    }
  }

  void filterRides() {
    try {
      List<RideBO> completedRides =
          rides.where((ride) => ride.status == "COMPLETED").toList();
      setCompletedRides(completedRides);
      List<RideBO> pendingRides =
          rides.where((ride) => ride.status == "SCHEDULED").toList();
      setScheduledRides(pendingRides);
      List<RideBO> canceledRides =
          rides.where((ride) => ride.status == "CANCELLED").toList();
      setCanceledRides(canceledRides);
    } catch (error) {}
  }
}

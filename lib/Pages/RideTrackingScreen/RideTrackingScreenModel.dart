import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/BOs/VehicleDetailsBO/VehicleDetailsBO.dart';
import 'package:zappy/Helpers/BOs/VehicleInfoBO/VehicleInfoBO.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'RideTrackingScreenModel.g.dart';

class RideTrackingScreenModel = RideTrackingScreenModelBase
    with _$RideTrackingScreenModel, NavigationMixin;

abstract class RideTrackingScreenModelBase with Store, ChangeNotifier {
  IRideServices rideServices = GetIt.instance.get<IRideServices>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance.get<IPlatformSecureStorageService>();
  @observable
  bool isLoading = false;
  @action
  void setIsLoading(bool isLoading) {
    this.isLoading = isLoading;
  }

  @observable
  late LatLng currentLocation;

  @action
  void setCurrentLocation(LatLng location) {
    currentLocation = location;
  }

  @observable
  late RideBO currentRideRequest;
  @action
  void setCurrentRideRequest(RideBO rideBO) {
    currentRideRequest = rideBO;
  }

  @observable
  List<LatLng> polypoints = [];

  @action
  void setPolyPoints(List<LatLng> points) {
    polypoints = points;
  }

  @observable
  bool isArrivedToPickupLocation = false;
  @action
  void setIsArrivedToPickupLocation(bool isArrivedToPickupLocation) {
    this.isArrivedToPickupLocation = isArrivedToPickupLocation;
  }

  @observable
  bool isArrivedToDropLocation = false;
  @action
  void setIsArrivedToDropLocation(bool isArrivedToDropLocation) {
    this.isArrivedToDropLocation = isArrivedToDropLocation;
  }

  @observable
  double currentDirection = 0.0;
  @action
  void setCurrentDirection(double value) {
    currentDirection = value;
  }

  @observable
  String rideStatus = "";
  @action
  void setRideStatus(String status) {
    rideStatus = status;
  }

  @observable
  double duration = 0.0;
  @action
  void setDuration(double value) {
    duration = value;
  }

  @observable
  late VehicleDetailsBO vehicleDetails;
  @action
  void setVehicleDetails(VehicleDetailsBO vehicleDetails) {
    this.vehicleDetails = vehicleDetails;
  }

  @observable
  late VehicleInfoBO vehicleInfo;
  @action
  void setVehicleInfo(VehicleInfoBO vehicleInfo) {
    this.vehicleInfo = vehicleInfo;
  }

  @observable
  LatLng pilotLocation = LatLng(0.0, 0.0);
  @action
  void setPilotLocation(LatLng location) {
    pilotLocation = location;
  }
}

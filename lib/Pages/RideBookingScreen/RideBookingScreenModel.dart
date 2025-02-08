import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/BOs/VechileBO/VechileBO.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';
import 'package:zappy/Services/ApiServices/VehicleServices/IVehicleServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'RideBookingScreenModel.g.dart';

class RideBookingScreenModel = _RideBookingScreenModelBase
    with _$RideBookingScreenModel, NavigationMixin, PopUpMixin, ChangeNotifier;

abstract class _RideBookingScreenModelBase with Store {
  IPlatformSecureStorageService platformSecureStorageService =
      GetIt.instance<IPlatformSecureStorageService>();
  IVehicleServices vehicleServices = GetIt.instance<IVehicleServices>();
  IRideServices rideServices = GetIt.instance<IRideServices>();
  @observable
  late LatLng scourceLocation = LatLng(0, 0);

  @action
  void setSourceLocation(LatLng location) {
    scourceLocation = location;
  }

  @observable
  late LatLng destinationLocation = LatLng(0, 0);

  @action
  void setDestinationLocation(LatLng location) {
    destinationLocation = location;
  }

  @observable
  List<LatLng> polypoints = [];

  @action
  void setPolyPoints(List<LatLng> points) {
    polypoints = points;
  }

  @observable
  bool isLocationEnabled = false;

  @action
  void setLocationEnabled(bool value) {
    isLocationEnabled = value;
  }

  @observable
  ObservableList<LatLng> capitansAreLive = ObservableList<LatLng>();

  @action
  void addCapitanLocation(LatLng location) {
    capitansAreLive.add(location);
  }

  @action
  void clearCapitanLocations() {
    capitansAreLive.clear();
  }

  @observable
  double distance = 0.0;

  @action
  void setDistance(double value) {
    distance = value;
  }

  @observable
  bool isLoading = false;

  @action
  void setIsLoading(bool value) {
    isLoading = value;
  }

  @observable
  bool isBottomIsLoading = false;
  @action
  void setIsBottomLoading(bool value) {
    isBottomIsLoading = value;
  }

  @observable
  List<VechileBO> vehicleList = [];
  @action
  void setVehicleList(List<VechileBO> value) {
    vehicleList = value;
  }

  @observable
  int selectedVehicleIndex = 0;
  @action
  void setSelectedVehicleIndex(int value) {
    selectedVehicleIndex = value;
  }

  @observable
  bool isOwnFare = false;
  @action
  void setIsOwnFare(bool value) {
    isOwnFare = value;
  }

  @observable
  String rideId = "";
  @action
  void setRideId(String value) {
    rideId = value;
  }

  @observable
  String fromLocation = "";
  @action
  void setFromLocation(String value) {
    fromLocation = value;
  }

  @observable
  String toLocation = "";
  @action
  void setToLocation(String value) {
    toLocation = value;
  }

  @observable
  late RideBO currentRide;
  @action
  void setCurrentRide(RideBO value) {
    currentRide = value;
  }
}

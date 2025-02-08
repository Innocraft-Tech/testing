import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/PilotRequestBO/PilotRequestBO.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Services/SDKServices/SupabaseServices/RealTimeServices/IRealTimeServices.dart';
part 'PilotFindingScreenModel.g.dart';

class PilotFindingScreenModel = PilotFindingScreenModelBase
    with _$PilotFindingScreenModel, NavigationMixin, ChangeNotifier;

abstract class PilotFindingScreenModelBase with Store {
  IRealTimeServices realTimeServices = GetIt.instance.get<IRealTimeServices>();
  @observable
  late LatLng sourceLocation;
  @action
  void setSourceLocation(LatLng location) {
    sourceLocation = location;
  }

  @observable
  late LatLng destinationLocation;
  @action
  void setDestinationLocation(LatLng location) {
    destinationLocation = location;
  }

  @observable
  late RideBO currentRide;
  @action
  void setCurrentRide(RideBO ride) {
    currentRide = ride;
  }

  @observable
  String rideId = "";
  @action
  void setRideId(String id) {
    rideId = id;
  }

  @observable
  List<LatLng> polypoints = [];

  @action
  void setPolyPoints(List<LatLng> points) {
    polypoints = points;
  }

  @observable
  bool isLoading = false;
  @action
  void setIsLoading(bool value) {
    isLoading = value;
  }

  @observable
  String price = "";
  @action
  void setPrice(String value) {
    price = value;
  }

  @observable
  bool isFareLoading = false;
  @action
  void setIsFareLoading(bool value) {
    isFareLoading = value;
  }

  @observable
  ObservableList<PilotRequestBO> pilots = ObservableList<PilotRequestBO>();

  @action
  void setPilots(List<PilotRequestBO> value) {
    pilots.clear(); // Clear existing items
    pilots.addAll(value);
  }
}

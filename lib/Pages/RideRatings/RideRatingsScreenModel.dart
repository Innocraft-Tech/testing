import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/ToastMixin.dart';
part 'RideRatingsScreenModel.g.dart';

class RideRatingsScreenModel = RideRatingsScreenModelBase
    with _$RideRatingsScreenModel, NavigationMixin, PopUpMixin, ToastMixin;

abstract class RideRatingsScreenModelBase with Store {
  @observable
  bool isLoading = false;
  @action
  void setLoading(bool value) {
    isLoading = value;
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
  int moodIndex = 0;
  @action
  void setMoodIndex(int index) {
    moodIndex = index;
  }
}

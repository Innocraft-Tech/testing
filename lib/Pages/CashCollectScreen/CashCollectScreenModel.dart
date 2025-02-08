import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Helpers/Mixins/ToastMixin.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';
part 'CashCollectScreenModel.g.dart';

class CashCollectScreenModel = CashCollectScreenModelBase
    with _$CashCollectScreenModel, NavigationMixin, PopUpMixin, ToastMixin;

abstract class CashCollectScreenModelBase with Store {
  IRideServices rideServices = GetIt.instance<IRideServices>();
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
}

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';
part 'PilotRatingsScreenModel.g.dart';

class PilotRatingsScreenModel = PilotRatingsScreenModelBase
    with _$PilotRatingsScreenModel, NavigationMixin;

abstract class PilotRatingsScreenModelBase with Store {
  IRideServices rideServices = GetIt.instance<IRideServices>();
  @observable
  late RideBO currentRideRequest;
  @action
  void setCurrentRideRequest(RideBO ride) {
    currentRideRequest = ride;
  }

  @observable
  bool isLoading = false;
  @action
  void setIsLoading(bool value) {
    isLoading = value;
  }
}

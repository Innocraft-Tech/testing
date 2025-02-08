import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/BOs/RideBO/RideBO.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'RidesScreenModel.g.dart';

class RidesScreenModel = RidesScreenModelBase with _$RidesScreenModel;

abstract class RidesScreenModelBase with Store {
  IRideServices rideApiServices = GetIt.instance.get<IRideServices>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance.get<IPlatformSecureStorageService>();
  @observable
  List<RideBO> rides = [];
  @action
  void setRides(List<RideBO> rides) {
    this.rides = rides;
  }

  @observable
  List<RideBO> filteredRides = [];
  @action
  void setFilteredRides(List<RideBO> rides) {
    filteredRides = rides;
  }

  @observable
  bool isLoading = false;
  @action
  void setIsLoading(bool isLoading) {
    this.isLoading = isLoading;
  }

  @observable
  late DateTime date;
  @action
  void setDate(DateTime date) {
    this.date = date;
  }

  @observable
  List<RideBO> completedRides = [];
  @action
  void setCompletedRides(List<RideBO> completedRides) {
    this.completedRides = completedRides;
  }

  @observable
  List<RideBO> scheduledRides = [];
  @action
  void setScheduledRides(List<RideBO> scheduledRides) {
    this.scheduledRides = scheduledRides;
  }

  @observable
  List<RideBO> canceledRides = [];
  @action
  void setCanceledRides(List<RideBO> canceledRides) {
    this.canceledRides = canceledRides;
  }

  @observable
  late LatLng scourceLocation = LatLng(0, 0);

  @action
  void setSourceLocation(LatLng location) {
    scourceLocation = location;
  }
}

import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'HomeScreenModel.g.dart';

class HomeScreenModel = _HomeScreenModelBase
    with _$HomeScreenModel, NavigationMixin, PopUpMixin, ChangeNotifier;

abstract class _HomeScreenModelBase with Store {
  IPlatformSecureStorageService platformSecureStorageService =
      GetIt.instance<IPlatformSecureStorageService>();
  @observable
  late LatLng scourceLocation = LatLng(0, 0);

  @action
  void setSourceLocation(LatLng location) {
    scourceLocation = location;
  }

  @observable
  bool isSourceLocationSet = false;

  @action
  void setIsSourceLocationSet(bool value) {
    isSourceLocationSet = value;
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
  ObservableList<LatLng> capitansAreLiveForAuto = ObservableList<LatLng>();

  @action
  void addCapitanLocationForAuto(LatLng location) {
    capitansAreLive.add(location);
  }

  @action
  void clearCapitanLocationsForAuto() {
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
}

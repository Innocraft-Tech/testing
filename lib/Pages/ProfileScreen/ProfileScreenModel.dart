import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
part 'ProfileScreenModel.g.dart';

class ProfileScreenModel = ProfileScreenModelBase with _$ProfileScreenModel, NavigationMixin;

abstract class ProfileScreenModelBase with Store {
  @observable
  late LatLng scourceLocation = LatLng(0, 0);

  @action
  void setSourceLocation(LatLng location) {
    scourceLocation = location;
  }

  @observable
  bool isLoading = false;

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }
}

import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Services/ApiServices/AdressApiServices/IAddressApiServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'LocationPickerScreenModel.g.dart';

class LocationPickerScreenModel = LocationPickerScreenModelBase
    with _$LocationPickerScreenModel, NavigationMixin;

abstract class LocationPickerScreenModelBase with Store {
  IAddressApiServices addressapiservices =
      GetIt.instance.get<IAddressApiServices>();

  IPlatformSecureStorageService secureStorageService =
      GetIt.instance.get<IPlatformSecureStorageService>();
  @observable
  LatLng currentLocation = LatLng(0, 0);

  @action
  void setCurrentLocation(LatLng location) {
    currentLocation = location;
  }

  @observable
  String addressName = "";

  @action
  void setAddressName(String address) {
    addressName = address;
  }

  @observable
  bool isLoading = false;

  @action
  void setLoading(bool loading) {
    isLoading = loading;
  }

  @observable
  String address = "";

  @action
  void setAddress(String address) {
    this.address = address;
  }

  @observable
  String addressType = "";

  @action
  void setAddressType(String addressType) {
    this.addressType = addressType;
  }
}

import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/AddressBO/AddressBO.dart';
import 'package:zappy/Services/ApiServices/AdressApiServices/IAddressApiServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'SavedAddressScreenModel.g.dart';

class SavedAddressScreenModel = SavedAddressScreenModelBase
    with _$SavedAddressScreenModel, NavigationMixin;

abstract class SavedAddressScreenModelBase with Store {
  IAddressApiServices addressApiServices =
      GetIt.instance<IAddressApiServices>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance<IPlatformSecureStorageService>();
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

  @observable
  List<AddressBO> address = [];
  @action
  void setAddress(List<AddressBO> address) {
    this.address = address;
  }
}

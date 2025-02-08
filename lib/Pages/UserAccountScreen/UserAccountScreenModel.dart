import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Services/ApiServices/UserServices/IUserServices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'UserAccountScreenModel.g.dart';

class UserAccountScreenModel = UserAccountScreenModelBase
    with _$UserAccountScreenModel, NavigationMixin;

abstract class UserAccountScreenModelBase with Store {
  IUserServices userServices = GetIt.instance.get<IUserServices>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance.get<IPlatformSecureStorageService>();
  @observable
  late UserBO user;
  @action
  void setUser(UserBO user) {
    this.user = user;
  }

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

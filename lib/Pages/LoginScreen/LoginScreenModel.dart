import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Services/ApiServices/UserServices/IUserServices.dart';
import 'package:zappy/Services/FirebaseAuthService/IFirebaseAuthService.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
part 'LoginScreenModel.g.dart';

class LoginScreenModel = LoginScreenModelBase with NavigationMixin, PopUpMixin;

abstract class LoginScreenModelBase with Store {
  IFirebaseAuthService firebaseAuthService =
      GetIt.instance.get<IFirebaseAuthService>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance.get<IPlatformSecureStorageService>();
  IUserServices userServices = GetIt.instance.get<IUserServices>();
  @observable
  bool isLoading = false;
  @action
  void setIsLoading(bool loading) {
    isLoading = loading;
  }

  @observable
  String mobileNumber = "";
  @action
  void setMobileNumber(String number) {
    mobileNumber = number;
  }
}

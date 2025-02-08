import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Services/ApiServices/UserServices/IUserServices.dart';
import 'package:zappy/Services/ApiServices/UserServices/Userservices.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
// part 'NameScreenModel.g.dart';

class NameScreenModel = NameScreenModelBase with NavigationMixin, PopUpMixin;

abstract class NameScreenModelBase with Store {
  IUserServices userServices = GetIt.instance<IUserServices>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance<IPlatformSecureStorageService>();
}

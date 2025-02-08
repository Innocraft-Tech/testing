import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
// part 'SplashScreenModel.g.dart';

class SplashScreenModel = SplashScreenModelBase
    with NavigationMixin, PopUpMixin;

abstract class SplashScreenModelBase with Store {
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance.get<IPlatformSecureStorageService>();
}

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:zappy/Helpers/AppNavigations/NavigationMixin.dart';
import 'package:zappy/Helpers/Mixins/PopUpMixin.dart';
import 'package:zappy/Services/ApiServices/UserServices/IUserServices.dart';
import 'package:zappy/Services/FirebaseAuthService/FirebaseAuthService.dart';
import 'package:zappy/Services/FirebaseAuthService/IFirebaseAuthService.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
import 'package:zappy/Services/SDKServices/OTPLessServices/IOTPService.dart';
part 'OTPScreenModel.g.dart';

class OTPScreenModel = OTPScreenModelBase with NavigationMixin, PopUpMixin;

abstract class OTPScreenModelBase with Store {
  IFirebaseAuthService firebaseAuthService =
      GetIt.instance<IFirebaseAuthService>();
  IPlatformSecureStorageService secureStorageService =
      GetIt.instance<IPlatformSecureStorageService>();
  IOTPService otpLessOTPService = GetIt.instance<IOTPService>();
  IUserServices userServices = GetIt.instance<IUserServices>();
  @observable
  String verificationID = "";
  @action
  void setVerificationID(String id) {
    verificationID = id;
  }

  @observable
  String otp = "";
  @action
  void setOtp(String id) {
    otp = id;
  }

  @observable
  String mobileNumber = "";
  @action
  void setMobileNumber(String number) {
    mobileNumber = number;
  }
}

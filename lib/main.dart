import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zappy/App.dart';
import 'package:zappy/Helpers/ServiceResult.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';
import 'package:zappy/Services/ApiServices/AdressApiServices/AddressApiServices.dart';
import 'package:zappy/Services/ApiServices/AdressApiServices/IAddressApiServices.dart';
import 'package:zappy/Services/ApiServices/RideServices/IRideServices.dart';
import 'package:zappy/Services/ApiServices/RideServices/RideServices.dart';
import 'package:zappy/Services/ApiServices/UserServices/IUserServices.dart';
import 'package:zappy/Services/ApiServices/UserServices/Userservices.dart';
import 'package:zappy/Services/ApiServices/VehicleServices/IVehicleServices.dart';
import 'package:zappy/Services/ApiServices/VehicleServices/VehicleServices.dart';
import 'package:zappy/Services/FirebaseAuthService/FirebaseAuthService.dart';
import 'package:zappy/Services/FirebaseAuthService/IFirebaseAuthService.dart';
import 'package:zappy/Services/PlatformServices/NotificationServices/NotificationServices.dart';
import 'package:zappy/Services/PlatformServices/NotificationServices/NotificationSound.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/IPlatformSecureStorageService.dart';
import 'package:zappy/Services/PlatformServices/PlatformSecureStorageService/PlatformSecureStorageService.dart';
import 'package:zappy/Services/SDKServices/OTPLessServices/IOTPService.dart';
import 'package:zappy/Services/SDKServices/OTPLessServices/OTPService.dart';
import 'package:zappy/Services/SDKServices/SupabaseServices/RealTimeServices/IRealTimeServices.dart';
import 'package:zappy/Services/SDKServices/SupabaseServices/RealTimeServices/RealTimeServices.dart';
import 'package:zappy/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Initialize notification service for background messages
  await NotificationService.initialize();

  await NotificationService.showNotification(
    title: message.notification?.title ?? 'New Booking Request',
    body: message.notification?.body ?? 'You have a new booking request',
    payload: message.data.toString(),
  );
  await NotificationSound.playSound();
}

void main() async {
  // Ensure Flutter bindings are initialized first
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://mtzeimqbsdjxdqweivtf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im10emVpbXFic2RqeGRxd2VpdnRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyMjAwMTksImV4cCI6MjA0OTc5NjAxOX0.AXl1LomaIAKqcYrK-z3BPVpmys83tN3_ECby42QdXj0',
  );

  // Initialize Firebase before anything else
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Request notification permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Configure iOS notification settings
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // Set up message handlers
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage
      .listen(NotificationService.handleForegroundMessage);

  // Register dependencies after Firebase is initialized
  await registerDependencies();
  // updateFCMToken();

  // Run the app
  runApp(App());
}

Future<void> registerDependencies() async {
  final getIt = GetIt.instance;
  final supabase = Supabase.instance.client;

  // Register secure storage service
  getIt.registerSingleton<IPlatformSecureStorageService>(
    PlatformSecureStorageService(),
  );

  // Register Firebase auth service after Firebase is initialized
  getIt.registerSingleton<IFirebaseAuthService>(
    FirebaseAuthService(),
  );
  getIt.registerSingleton<IUserServices>(
    UserServices(),
  );
  getIt.registerSingleton<IOTPService>(
    OTPService(),
  );
  getIt.registerSingleton<IVehicleServices>(
    VehicleServices(),
  );
  getIt.registerSingleton<IRideServices>(RideServices());
  getIt.registerSingleton<IRealTimeServices>(
      RealTimeServices(supabase: supabase));
  getIt.registerSingleton<IAddressApiServices>(AddressApiServices());
}

void updateFCMToken() async {
  try {
    final currentTOken = await FirebaseMessaging.instance.getToken();
    final platformSecureStorageService = PlatformSecureStorageService();
    final UserServices userServices = UserServices();
    ServiceResult<String?> accessToken =
        await platformSecureStorageService.retrieveData(key: "accessToken");
    ServiceResult<String?> refreshToken = await platformSecureStorageService
        .retrieveData(key: "isProfileComplted");
    if (accessToken.content != null) {
      if (currentTOken != null) {
        ServiceResult<String?> newToken =
            await platformSecureStorageService.retrieveData(
          key: "fcm_token",
        );
        if (newToken.content == currentTOken) {
          return;
        } else {
          print("object");
          await platformSecureStorageService.saveData(
            key: "fcm_token",
            value: currentTOken,
          );
          userServices.updatePilotProfile(
              {"fcm_token": currentTOken}, accessToken.content!);
        }
      }
    } else {
      await platformSecureStorageService.deleteAllData();
    }
  } catch (error) {
    error.logExceptionData();
  }
}

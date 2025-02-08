import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zappy/Helpers/BOs/UserBO/UserBO.dart';
import 'package:zappy/Helpers/BOs/VechileBO/VechileBO.dart';
import 'package:zappy/Helpers/ServiceResult.dart';

abstract class IVehicleServices {
  Future<ServiceResult<List<VechileBO>>> getVehicleList();
}

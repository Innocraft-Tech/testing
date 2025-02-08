import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:zappy/Helpers/Utilities/Utilities.dart';

import '../../../Helpers/ServiceResult.dart';
import 'IPlatformNetworkCheckService.dart';

class PlatformNetworkCheckService implements IPlatformNetworkCheckService {
  @override
  Future<ServiceResult<bool>> checkInternetConnectivity() async {
    try {
      // CHECK internet Connection using InternetConnectionChecker().hasConnection
      // ASSIGN the response to variable **result** to validate the internet connection
      bool result = await InternetConnectionChecker().hasConnection;

      // **(IF result == true)**
      if (result == true) {
        // RETURN ServiceResult and assign the statuscode as **Ok** and message as **"Success"** and content as **result**
        return ServiceResult(
            statusCode: ServiceStatusCode.OK,
            content: result,
            message: "Success");
      }
      // ELSE
      else {
        // RETURN ServiceResult and assign the statuscode as **ServiceException** and message as **"Failed"** and content as **result**
        return ServiceResult(
            statusCode: ServiceStatusCode.SystemException,
            content: result,
            message: "Failed");
      }
    }
    // **ON FORMATEXCEPTION**
    on FormatException {
      // RETURNS ServiceResult and assign the  **statuscode as UnprocessableEntity** and **message as "The type of data got is incorrect!"**
      return ServiceResult(
          statusCode: ServiceStatusCode.UnprocessableEntity,
          content: null,
          message: "The type of data got is incorrect!");
    }
    // **ON SOCKETEXCEPTION**
    on SocketException {
      // RETURNS ServiceResult and assign the **statuscode as NetworkFailure** and **message as "There is not internet connection!"** and **content as empty**
      return ServiceResult(
          statusCode: ServiceStatusCode.NetworkFailure,
          content: null,
          message: "Socket Exception");
    } catch (ex) {
      //  **INVOKE** **writeExceptionData()** on the exception object **ex**
      ex.logExceptionData();

      // RETURNS ServiceResult and assign the statuscode **SystemException** and message as **exception**
      return ServiceResult(
          statusCode: ServiceStatusCode.SystemException,
          content: null,
          message: ex.toString());
    }
  }
}

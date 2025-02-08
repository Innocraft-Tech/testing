// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'Utilities/Utilities.dart';

class ServiceResult<T> {
  final ServiceStatusCode statusCode;
  final String? message;
  final T? content;
  ServiceResult(
      {required this.statusCode, this.message, required this.content});
}

ServiceStatusCode resolveStatusCode(int statusCode) {
  try {
    return ServiceStatusCode.values
        .firstWhere((e) => StatusCode[e] == statusCode);
  } catch (error) {
    error.logExceptionData();
    return ServiceStatusCode.SystemException;
  }
}

/* Create an extension class on Response */
extension ServiceResultExtension on Response {
  /* Create method to decode the response and return serviceResult.*/
  ServiceResult<T> getAPIServiceResult<T>(Response response) {
    try {
      // Initialize variables for message and content of var type
      var message, content;

      try {
        print(response.data);
        // Decode the responseBody and assign to content.
        content = JsonMapper.deserialize<T>(response.data["existingUser"]);

        try {
          // Assign the message as message
          message = content["message"];
        } catch (exception) {
          // If there is an exception, assign the message as ""
          message = "";
        }
      } catch (error) {
        error.logExceptionData();

        // return the ServiceResult with the content , message and the statusCode
        return ServiceResult(
            statusCode: resolveStatusCode(response.statusCode!),
            message: error.toString(),
            content: content);
      }

      // return the ServiceResult with the content , message and the statusCode
      return ServiceResult(
          statusCode: resolveStatusCode(response.statusCode!),
          message: message,
          content: content);
    } catch (exception) {
      exception.logExceptionData();
      // If there is an execption, return the ServiceResult statusCode as
      // SystemException , message as exception  and content as null
      return ServiceResult(
          statusCode: ServiceStatusCode.SystemException,
          message: exception.toString(),
          content: null);
    }
  }

  // ServiceResult<T> getAPIServiceResultLocation<T>(Response response) {
  //   try {
  //     // Initialize variables for message and content of var type
  //     var message, content;

  //     try {
  //       print(response.data);
  //       // Decode the responseBody and assign to content.
  //       content = JsonMapper.deserialize<T>(response.data);

  //       try {
  //         // Assign the message as message
  //         message = content["message"];
  //       } catch (exception) {
  //         // If there is an exception, assign the message as ""
  //         message = "";
  //       }
  //     } catch (error) {
  //       error.logExceptionData();

  //       // return the ServiceResult with the content , message and the statusCode
  //       return ServiceResult(
  //           statusCode: resolveStatusCode(response.statusCode!),
  //           message: error.toString(),
  //           content: content);
  //     }

  //     // return the ServiceResult with the content , message and the statusCode
  //     return ServiceResult(
  //         statusCode: resolveStatusCode(response.statusCode!),
  //         message: message,
  //         content: content);
  //   } catch (exception) {
  //     exception.logExceptionData();
  //     // If there is an execption, return the ServiceResult statusCode as
  //     // SystemException , message as exception  and content as null
  //     return ServiceResult(
  //         statusCode: ServiceStatusCode.SystemException,
  //         message: exception.toString(),
  //         content: null);
  //   }
  // }

  ServiceResult<List<T>> getAPIServiceResultForList<T>(Response response) {
    print("agdhfajdgsfjagshdkfhakjdfdshflka");
    try {
      // Initialize variables for message and content of var type
      var message, content;

      try {
        // If the key "data" is not present in the response data

        //COMMENTED NEXT 3 LINES
        // if (!response.data.containsKey('data')) {
        //   // Create the response.data against the key "data" and assign the Map structure to a variable response.data
        //   response.data = {"data": response.data};
        // }

        // Deserialize the response's data['data'] and assign the reponse to a variable content
        List<T> deserializeResult = [];

        for (var item in response.data) {
          print(item);
          deserializeResult.add(JsonMapper.deserialize<T>(item) as T);
        }

        content = deserializeResult;

        try {
          // Assign the message as message
          message = response.data['message'];
        } catch (exception) {
          // If there is an exception, assign the message as ""
          message = "";
        }
      } catch (error) {
        // Write Log Exceptions using the exception object error
        error.logExceptionData();

        // return the ServiceResult with the content , message and the statusCode
        return ServiceResult(
            statusCode: resolveStatusCode(response.statusCode!),
            message: error.toString(),
            content: content);
      }

      // return the ServiceResult with the content , message and the statusCode
      return ServiceResult(
          statusCode: resolveStatusCode(response.statusCode!),
          message: message,
          content: content);
    } catch (ex) {
      // Write Log Exceptions using the exception object ex
      ex.logExceptionData();

      // If there is an execption, return the ServiceResult statusCode as
      // SystemException , message as exception  and content as null
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          message: ex.toString(),
          content: null);
    }
  }

  ServiceResult<List<T>> getAPIServiceResultForListusers<T>(Response response) {
    print("agdhfajdgsfjagshdkfhakjdfdshflka");
    try {
      // Initialize variables for message and content of var type
      var message, content;

      try {
        // If the key "data" is not present in the response data

        //COMMENTED NEXT 3 LINES
        // if (!response.data.containsKey('data')) {
        //   // Create the response.data against the key "data" and assign the Map structure to a variable response.data
        //   response.data = {"data": response.data};
        // }

        // Deserialize the response's data['data'] and assign the reponse to a variable content
        List<T> deserializeResult = [];

        for (var item in response.data) {
          print(item);
          deserializeResult.add(JsonMapper.deserialize<T>(item) as T);
        }

        content = deserializeResult;

        try {
          // Assign the message as message
          message = response.data['message'];
        } catch (exception) {
          // If there is an exception, assign the message as ""
          message = "";
        }
      } catch (error) {
        // Write Log Exceptions using the exception object error
        error.logExceptionData();

        // return the ServiceResult with the content , message and the statusCode
        return ServiceResult(
            statusCode: resolveStatusCode(response.statusCode!),
            message: error.toString(),
            content: content);
      }

      // return the ServiceResult with the content , message and the statusCode
      return ServiceResult(
          statusCode: resolveStatusCode(response.statusCode!),
          message: message,
          content: content);
    } catch (ex) {
      // Write Log Exceptions using the exception object ex
      ex.logExceptionData();

      // If there is an execption, return the ServiceResult statusCode as
      // SystemException , message as exception  and content as null
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          message: ex.toString(),
          content: null);
    }
  }

  ServiceResult<List<T>> getAPIServiceResultForListLocation<T>(
      Response response) {
    try {
      // Initialize variables for message and content of var type
      var message, content;

      try {
        // Deserialize the response's data and assign the reponse to a variable content
        List<T> deserializeResult = [];

        for (var item in response.data) {
          print(item);
          deserializeResult.add(JsonMapper.deserialize<T>(item) as T);
        }

        content = deserializeResult;

        try {
          // Assign the message as message
          message = response.data['message'];
        } catch (exception) {
          // If there is an exception, assign the message as ""
          message = "";
        }
      } catch (error) {
        // Write Log Exceptions using the exception object error
        error.logExceptionData();

        // return the ServiceResult with the content , message and the statusCode
        return ServiceResult(
            statusCode: resolveStatusCode(response.statusCode!),
            message: error.toString(),
            content: content);
      }

      // return the ServiceResult with the content , message and the statusCode
      return ServiceResult(
          statusCode: resolveStatusCode(response.statusCode!),
          message: message,
          content: content);
    } catch (ex) {
      // Write Log Exceptions using the exception object ex
      ex.logExceptionData();

      // If there is an execption, return the ServiceResult statusCode as
      // SystemException , message as exception  and content as null
      return ServiceResult(
          statusCode: ServiceStatusCode.ServiceUnavailable,
          message: ex.toString(),
          content: null);
    }
  }

  ServiceResult<Map<String, dynamic>> getAPIServiceResultForUser(
      Response response) {
    try {
      // Initialize variables for message and content of var type
      var message;
      Map<String, dynamic>? content;

      try {
        print(response.data);
        // Deserialize the responseBody and assign to content.
        content = JsonMapper.deserialize<Map<String, dynamic>>(
            response.data["existingUser"]);
        if (content == null) {
          throw Exception("Failed to deserialize content");
        }

        try {
          // Assign the message as message
          message = response.data["message"] ?? "";
        } catch (exception) {
          // If there is an exception, assign the message as ""
          message = "";
        }
      } catch (error) {
        error.logExceptionData();

        // return the ServiceResult with the content, message, and the statusCode
        return ServiceResult(
            statusCode: resolveStatusCode(response.statusCode!),
            message: error.toString(),
            content: content);
      }

      // return the ServiceResult with the content, message, and the statusCode
      return ServiceResult(
          statusCode: resolveStatusCode(response.statusCode!),
          message: message,
          content: {'userData': content, 'isValid': response.data["message"]});
    } catch (exception) {
      exception.logExceptionData();
      // If there is an exception, return the ServiceResult statusCode as
      // SystemException, message as exception, and content as null
      return ServiceResult(
          statusCode: ServiceStatusCode.SystemException,
          message: exception.toString(),
          content: null);
    }
  }
}

enum ServiceStatusCode {
  /// This status code indicates that the server has received the initial part of a request, and the client should continue to send the remaining parts.
  Continue,

  /// The server is switching to a different protocol version, such as from HTTP/1.1 to HTTP/2.
  SwitchingProtocols,

  /// The server is performing some processing on the request and will send a response as soon as possible.
  Processing,

  /// Indicates to the client that the server is likely to send a final response with the header fields included in the informational response.
  EarlyHints,

  /// The request has succeeded.
  OK,

  /// The request has been fulfilled, resulting in the creation of a new resource.
  Created,

  /// The request has been accepted for processing, but the processing has not been completed.
  Accepted,

  /// The server is a transforming proxy that received a 200 OK from its origin, but is returning a modified version of the origin's response.
  NonAuthoritativeInformation,

  /// The server successfully processed the request and is not returning any content.
  NoContent,

  /// The server successfully processed the request, but is not returning any content.
  ResetContent,

  /// The server is delivering only part of the resource due to a range header sent by the client.
  PartialContent,

  /// Multiple status codes are being returned by the server.
  MultiStatus,

  /// The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again.
  AlreadyReported,

  /// The server has completed the request for the resource, and the response is intentionally blank.
  IMUsed,

  /// The server has multiple choices for the resource requested.
  MultipleChoices,

  /// The requested resource is ambiguous and requires further information to determine how to satisfy the request.
  Ambiguous,

  /// The requested resource has been permanently moved to a new URI, and any future references to this resource should use one of the returned URIs.
  MovedPermanently,

  /// The requested resource has been moved to a new URI, and any future references to this resource should use one of the returned URIs.
  Moved,

  /// The requested resource has been found, but the client should continue to use the same URI.
  Found,

  /// The response to the request can be found under another URI using the GET method.
  Redirect,

  /// The response to the request can be found under another URI using the specified method.
  SeeOther,

  /// Indicates that the client should use the proxy server specified in the Location header to access the requested resource.
  UseProxy,

  /// This status code is no longer used and has been removed from the HTTP/1.1 specification.
  Unused,

  /// The requested resource has been temporarily moved to a new URI, and any future references to this resource should use one of the returned URIs.
  TemporaryRedirect,

  /// The response to the request can be found under another URI using the same method as the original request.
  RedirectKeepVerb,

  /// The requested resource has been permanently moved to a new URI, and any future references to this resource should use one of the returned URIs.
  PermanentRedirect,

  /// The server cannot or will not process the request due to an apparent client error.
  BadRequest,

  /// The client must authenticate itself to get the requested response.
  Unauthorized,

  /// This status code is reserved for future use.
  PaymentRequired,

  /// The client does not have access rights to the content, so the server is refusing to give the requested resource.
  Forbidden,

  /// The server cannot find the requested resource.
  NotFound,

  /// The method specified in the request is not allowed for the resource
  MethodNotAllowed,

  /// The resource identified by the request is not capable of generating a response that can be accepted by the client.
  NotAcceptable,

  /// The client must first authenticate itself with the proxy before making a request to the requested resource.
  ProxyAuthenticationRequired,

  /// The server timed out waiting for the request from the client.
  RequestTimeout,

  /// The request could not be completed due to a conflict with the current state of the target resource.
  Conflict,

  /// The requested resource is no longer available and no forwarding address is known.
  Gone,

  /// The server requires the request to be a certain length, which is not specified by the client.
  LengthRequired,

  /// The precondition given in one or more of the request-header fields evaluated to false when it was tested on the server.
  PreconditionFailed,

  /// The server is refusing to process a request because the request entity is larger than the server is willing or able to process.
  RequestEntityTooLarge,

  /// The server is refusing to service the request because the request-URI is longer than the server is willing to interpret.
  RequestUriTooLong,

  /// The server is refusing to service the request because the entity of the request is in a format not supported by the requested resource for the requested method.
  UnsupportedMediaType,

  /// The server cannot provide the requested ranges for the resource.
  RequestedRangeNotSatisfiable,

  /// The expectation given in the request's Expect header field could not be met by the server.
  ExpectationFailed,

  /// The request was directed at a server that is not able to produce a response.
  MisdirectedRequest,

  /// The server understands the content type of the request entity, and the syntax of the request entity is correct, but it was unable to process the contained instructions.
  UnprocessableEntity,

  /// The resource that is being accessed is locked.
  Locked,

  /// The method could not be performed on the resource because the requested action depended on another action and that action failed.
  FailedDependency,

  /// The server requires the client to upgrade to a different protocol version.
  UpgradeRequired,

  /// The origin server requires the request to be conditional.
  PreconditionRequired,

  /// The user has sent too many requests in a given amount of time.
  TooManyRequests,

  /// The server is unwilling to process the request because its header fields are too large.
  RequestHeaderFieldsTooLarge,

  /// The server is denying access to the resource as a consequence of a legal demand.
  UnavailableForLegalReasons,

  /// The server encountered an internal error and was unable to complete the request.
  InternalServerError,

  /// The server does not support the functionality required to fulfill the request.
  NotImplemented,

  /// The server, while acting as a gateway or proxy, received an invalid response from the upstream server it accessed in attempting to fulfill the request.
  BadGateway,

  /// The server is currently unable to handle the request due to a temporary overload or maintenance of the server.
  ServiceUnavailable,

  /// The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server it accessed in attempting to complete the request.
  GatewayTimeout,

  /// The server does not support the HTTP protocol version used in the request.
  HttpVersionNotSupported,

  /// Transparent content negotiation for the request results in a circular reference.
  VariantAlsoNegotiates,

  /// The server is unable to store the representation needed to complete the request.
  InsufficientStorage,

  /// The server detected an infinite loop while processing the request.
  LoopDetected,

  /// Further extensions to the request are required for the server to fulfill it.
  NotExtended,

  /// The client must authenticate to get the requested response.
  NetworkAuthenticationRequired,

  /// This is a system exception that denotes an unrecognized error has occurred and the operation cannot be performed on the client side.
  SystemException,

  /// This is a network exception that denotes an error has occurred due to no internet connection, and the operation cannot be performed.
  NetworkFailure,

  ///  This indicates that the requested resource requires the use of a different HTTP method.
  RedirectMethod,

  /// This status code denotes that the requested resource has not been modified since the last time it was accessed.
  NotModified
}

final StatusCode = {
  ServiceStatusCode.Continue: 100,
  ServiceStatusCode.SwitchingProtocols: 101,
  ServiceStatusCode.Processing: 102,
  ServiceStatusCode.EarlyHints: 103,
  ServiceStatusCode.OK: 200,
  ServiceStatusCode.Created: 201,
  ServiceStatusCode.Accepted: 202,
  ServiceStatusCode.NonAuthoritativeInformation: 203,
  ServiceStatusCode.NoContent: 204,
  ServiceStatusCode.ResetContent: 205,
  ServiceStatusCode.PartialContent: 206,
  ServiceStatusCode.MultiStatus: 207,
  ServiceStatusCode.AlreadyReported: 208,
  ServiceStatusCode.IMUsed: 226,
  ServiceStatusCode.MultipleChoices: 300,
  ServiceStatusCode.Ambiguous: 300,
  ServiceStatusCode.MovedPermanently: 301,
  ServiceStatusCode.Moved: 301,
  ServiceStatusCode.Found: 302,
  ServiceStatusCode.Redirect: 302,
  ServiceStatusCode.SeeOther: 303,
  ServiceStatusCode.RedirectMethod: 303,
  ServiceStatusCode.NotModified: 304,
  ServiceStatusCode.UseProxy: 305,
  ServiceStatusCode.Unused: 306,
  ServiceStatusCode.TemporaryRedirect: 307,
  ServiceStatusCode.RedirectKeepVerb: 307,
  ServiceStatusCode.PermanentRedirect: 308,
  ServiceStatusCode.BadRequest: 400,
  ServiceStatusCode.Unauthorized: 401,
  ServiceStatusCode.PaymentRequired: 402,
  ServiceStatusCode.Forbidden: 403,
  ServiceStatusCode.NotFound: 404,
  ServiceStatusCode.MethodNotAllowed: 405,
  ServiceStatusCode.NotAcceptable: 406,
  ServiceStatusCode.ProxyAuthenticationRequired: 407,
  ServiceStatusCode.RequestTimeout: 408,
  ServiceStatusCode.Conflict: 409,
  ServiceStatusCode.Gone: 410,
  ServiceStatusCode.LengthRequired: 411,
  ServiceStatusCode.PreconditionFailed: 412,
  ServiceStatusCode.RequestEntityTooLarge: 413,
  ServiceStatusCode.RequestUriTooLong: 414,
  ServiceStatusCode.UnsupportedMediaType: 415,
  ServiceStatusCode.RequestedRangeNotSatisfiable: 416,
  ServiceStatusCode.ExpectationFailed: 417,
  ServiceStatusCode.MisdirectedRequest: 421,
  ServiceStatusCode.UnprocessableEntity: 422,
  ServiceStatusCode.Locked: 423,
  ServiceStatusCode.FailedDependency: 424,
  ServiceStatusCode.UpgradeRequired: 426,
  ServiceStatusCode.PreconditionRequired: 428,
  ServiceStatusCode.TooManyRequests: 429,
  ServiceStatusCode.RequestHeaderFieldsTooLarge: 431,
  ServiceStatusCode.UnavailableForLegalReasons: 451,
  ServiceStatusCode.InternalServerError: 500,
  ServiceStatusCode.NotImplemented: 501,
  ServiceStatusCode.BadGateway: 502,
  ServiceStatusCode.ServiceUnavailable: 503,
  ServiceStatusCode.GatewayTimeout: 504,
  ServiceStatusCode.HttpVersionNotSupported: 505,
  ServiceStatusCode.VariantAlsoNegotiates: 506,
  ServiceStatusCode.InsufficientStorage: 507,
  ServiceStatusCode.LoopDetected: 508,
  ServiceStatusCode.NotExtended: 510,
  ServiceStatusCode.NetworkAuthenticationRequired: 0x1FF,
  ServiceStatusCode.NetworkFailure: 500,
  ServiceStatusCode.SystemException: 999
};

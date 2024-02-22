import 'package:dio/dio.dart';

Map<String, dynamic> handleError(dynamic error) {
  print('Error $error');
  Map<String, dynamic> resp = {'statusCode': 0, 'message': ''};
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionError:
        resp['statusCode'] = 503;
        resp['message'] = 'Service Unavailable';
        break;
      case DioExceptionType.badResponse:
        resp['statusCode'] = 400;
        resp['message'] =
            'Bad Request. Please check your input and connectivity';
        break;
      case DioExceptionType.connectionTimeout:
        resp['statusCode'] = 408;
        resp['message'] =
            'Connection Timeout. Please check your internet connection and try again.';
        break;
      case DioExceptionType.receiveTimeout:
        resp['statusCode'] = 408;
        resp['message'] = 'Receive Timeout. Please try again later.';
        break;
      case DioExceptionType.sendTimeout:
        resp['statusCode'] = 408;
        resp['message'] = 'Send Timeout. Please try again later.';
        break;
      case DioExceptionType.badCertificate:
        resp['statusCode'] = 495;
        resp['message'] =
            'SSL Certificate Error. Please check your network settings.';
        break;
      case DioExceptionType.cancel:
        resp['statusCode'] = 499;
        resp['message'] = 'Request Cancelled';
        break;
      default:
        resp['statusCode'] = 500;
        resp['message'] = 'Unknown Dio Error';
    }
    return resp;
  }
  resp['statusCode'] = 500;
  resp['message'] = 'Something Went Wrong';
  return resp;
}

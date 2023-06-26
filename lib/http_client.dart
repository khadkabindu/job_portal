import 'package:dio/dio.dart';

class HttpClient {
  static Dio? _dio;

  HttpClient._();

  static const baseUrl =
      "https://storage.googleapis.com/programiz-static/hiring/software/";

  static Dio? getInstance() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(baseUrl: baseUrl),
      );
    }
    return _dio;
  }
}

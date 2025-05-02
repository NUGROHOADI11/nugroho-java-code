import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/services/hive_service.dart';
import '../../shared/controllers/global_controllers/global_controller.dart';

class DioService extends GetxService {
  DioService._();
  static final DioService dioService = DioService._();

  factory DioService() => dioService;

  static const Duration timeoutInMiliSeconds = Duration(seconds: 20);

  static dio.Dio _createDio({String? token, String? authorization}) {
    final dioInstance = dio.Dio(
      dio.BaseOptions(
        headers: _buildHeaders(token: token, authorization: authorization),
        baseUrl: GlobalController.to.baseUrl,
        connectTimeout: timeoutInMiliSeconds,
        receiveTimeout: timeoutInMiliSeconds,
        contentType: "application/json",
        responseType: dio.ResponseType.json,
      ),
    );

    dioInstance.interceptors.add(_authInterceptor());
    return dioInstance;
  }

  static Map<String, String> _buildHeaders(
      {String? token, String? authorization}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) headers['token'] = token;
    if (authorization != null) headers['Authorization'] = authorization;

    return headers;
  }

  static dio.Interceptor _authInterceptor() {
    return dio.QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = LocalStorageService.getToken();
        if (token != null && !options.headers.containsKey('token')) {
          options.headers['token'] = token;
        }

        log('[REQUEST] ${options.method} ${options.uri}');
        log('[HEADERS] ${options.headers}');
        log('[BODY] ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('[RESPONSE] ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        log('[ERROR] ${error.message}');
        log('[RESPONSE] ${error.response}');
        return handler.next(error);
      },
    );
  }

  static Future<Map<String, dynamic>?> req(
    String endpoint, {
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      final dioInstance = _createDio(token: token);
      final response = await dioInstance.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: dio.Options(method: method),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return response.data;
      } else {
        throw dio.DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Request failed with status ${response.statusCode}',
        );
      }
    } on dio.DioException catch (e) {
      log('[DIO ERROR] ${e.message}');
      rethrow;
    } catch (e) {
      log('[UNEXPECTED ERROR] $e');
      rethrow;
    }
  }
}

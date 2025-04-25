import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:nugroho_javacode/utils/services/hive_service.dart';
import '../../features/home/models/user_detail_model.dart';
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

  // Login method
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await req(
      "/auth/login",
      method: "POST",
      data: {
        'email': email.trim(),
        'password': password.trim(),
      },
    );

    if (response == null) {
      throw Exception('Login failed: empty response');
    }

    return response;
  }

  // get user detail
  static Future<UserDetail> getUserDetail(int userId) async {
    final token = LocalStorageService.getToken();
    final response = await req(
      "user/detail/$userId",
      method: "GET",
      token: token,
    );

    return UserDetail.fromJson(response!);
  }

  // get menu
  static Future<Map<String, dynamic>?> getMenu({String? category}) async {
    String? token = LocalStorageService.getToken();
    String endpoint = "/menu/all";
    if (category != null) {
      endpoint = "/menu/kategori/$category";
    }
    return await req(endpoint, method: "GET", token: token);
  }

  // get detail menu by id
  static Future<Map<String, dynamic>?> getMenuById(int id) async {
    String? token = LocalStorageService.getToken();
    return await req("/menu/detail/$id", method: "GET", token: token);
  }

  // get promo
  static Future<Map<String, dynamic>?> getPromos({String? type}) async {
    String? token = LocalStorageService.getToken();
    String endpoint = "/promo/all";
    if (type != null) {
      endpoint = "/promo/type/$type";
    }
    return await req(endpoint, method: "GET", token: token);
  }

  // get promo by id
  static Future<Map<String, dynamic>?> getPromoById(int id) async {
    String? token = LocalStorageService.getToken();
    return await req("/promo/detail/$id", method: "GET", token: token);
  }

  // get order by user id
  static Future<Map<String, dynamic>?> getOrderByUserId(int userId) async {
    String? token = LocalStorageService.getToken();
    return await req(
      "/order/user/$userId",
      method: "GET",
      token: token,
    );
  }

  // get order detail
  static Future<Map<String, dynamic>?> getOrderDetail(int orderId) async {
    String? token = LocalStorageService.getToken();
    return await req("/order/detail/$orderId", method: "GET", token: token);
  }

  // Get User Orders by Status
  static Future<Map<String, dynamic>?> getUserOrdersByStatus(
      int userId, String status) async {
    String? token = LocalStorageService.getToken();
    return await req("/order/user/$userId/status/$status",
        method: "GET", token: token);
  }

  // create order
  static Future<Map<String, dynamic>?> createOrder(
      Map<String, dynamic> data) async {
    String? token = LocalStorageService.getToken();
    return await req("/order/add", method: "POST", data: data, token: token);
  }

  // delete order
  static Future<Map<String, dynamic>?> deleteOrder(int orderId) async {
    String? token = LocalStorageService.getToken();
    return await req("/order/delete/$orderId", method: "DELETE", token: token);
  }
}

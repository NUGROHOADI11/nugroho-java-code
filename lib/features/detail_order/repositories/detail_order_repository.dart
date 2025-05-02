import 'dart:developer';

import '../../../utils/services/dio_service.dart';
import '../../../utils/services/hive_service.dart';
import '../constants/detail_order_api_constant.dart';

class DetailOrderRepository {
  DetailOrderRepository._();

  var apiConstant = DetailOrderApiConstant();

  static Future<Map<String, dynamic>?> getOrderByUserId(int userId) async {
    String? token = LocalStorageService.getToken();
    return await DioService.req(
      "/order/user/$userId",
      method: "GET",
      token: token,
    );
  }

  static Future<Map<String, dynamic>?> getOrderDetail(int orderId) async {
    String? token = LocalStorageService.getToken();
    return await DioService.req("/order/detail/$orderId",
        method: "GET", token: token);
  }

  static Future<Map<String, dynamic>?> getUserOrdersByStatus(
      int userId, String status) async {
    String? token = LocalStorageService.getToken();
    return await DioService.req("/order/user/$userId/status/$status",
        method: "GET", token: token);
  }

  static Future<Map<String, dynamic>?> createOrder(
      Map<String, dynamic> data) async {
    try {
      String? token = LocalStorageService.getToken();
      final response = await DioService.req("/order/add",
          method: "POST", data: data, token: token);

      if (response != null && response['status_code'] == 200) {
        return response['data'];
      } else {
        throw Exception(response?['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      log('Order creation error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> deleteOrder(int orderId) async {
    String? token = LocalStorageService.getToken();
    return await DioService.req("/order/delete/$orderId",
        method: "DELETE", token: token);
  }
}

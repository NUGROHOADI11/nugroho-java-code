import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nugroho_javacode/utils/services/hive_service.dart';

import '../../features/detail_menu/models/detail_menu_model.dart';
import '../../features/home/models/order_model.dart';
// import '../../shared/models/user_model.dart';

@Deprecated("no longer used")
class HttpService {
  HttpService._();
  static final HttpService httpService = HttpService._();

  factory HttpService() {
    return httpService;
  }

  static const Duration timeoutInMiliSeconds = Duration(seconds: 20);

  final String _baseUrl = 'https://trainee.landa.id/javacode/';
  final String? _token = LocalStorageService.getToken();
  final String? idUser =
      LocalStorageService.getUserData()["id_user"].toString();

  // Future<UserModel> getUserById() async {
  //   if (kDebugMode) {
  //     print("check ID USER: $idUser");
  //   }
  //   if (kDebugMode) {
  //     print("check token: $_token");
  //   }
  //   String url = '$_baseUrl/user/detail/$idUser';

  //   var headers = {
  //     'token': _token,
  //   }..removeWhere((key, value) => value == null);

  //   var response = await http
  //       .get(Uri.parse(url), headers: headers.cast<String, String>())
  //       .timeout(timeoutInMiliSeconds);

  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body)['data'];
  //     return UserModel.fromJson(data);
  //   } else {
  //     throw Exception('Failed to fetch user');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getAllMenu(
      {String category = 'semua'}) async {
    String url = '$_baseUrl/menu/all';
    if (category != 'semua') {
      url = '$_baseUrl/menu/kategori/$category';
    }

    var headers = {
      'token': _token,
    }..removeWhere((key, value) => value == null);

    var response = await http
        .get(Uri.parse(url), headers: headers.cast<String, String>())
        .timeout(timeoutInMiliSeconds);

    if (response.statusCode == 200) {
      var responseData = response.body;
      var data = json.decode(responseData);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Future<void> deleteItem(int id) async {}

  Future<List<Map<String, dynamic>>> getPromos() async {
    String url = '$_baseUrl/promo/all';

    var headers = {
      'token': _token,
    }..removeWhere((key, value) => value == null);

    var response = await http
        .get(Uri.parse(url), headers: headers.cast<String, String>())
        .timeout(timeoutInMiliSeconds);

    if (response.statusCode == 200) {
      var responseData = response.body;
      var data = json.decode(responseData);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load promos');
    }
  }

  Future<MenuDetailModel> getMenuDetail(int id) async {
    String url = '$_baseUrl/menu/detail/$id';

    var headers = {
      'token': _token,
    }..removeWhere((key, value) => value == null);

    var response = await http
        .get(Uri.parse(url), headers: headers.cast<String, String>())
        .timeout(timeoutInMiliSeconds);

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      var data = body['data'];
      return MenuDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load menu detail');
    }
  }

  Future<List<Order>> getOrders() async {
    String url = 'https://trainee.landa.id/javacode/order/user/$idUser';

    var response = await http.get(Uri.parse(url), headers: {
      'token': _token!,
    }).timeout(timeoutInMiliSeconds);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var data = jsonData['data'];
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  }
}

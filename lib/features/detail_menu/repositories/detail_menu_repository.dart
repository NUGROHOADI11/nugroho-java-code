import '../../../utils/services/dio_service.dart';
import '../../../utils/services/hive_service.dart';
import '../constants/detail_menu_api_constant.dart';

class DetailMenuRepository {
  DetailMenuRepository._();

  var apiConstant = DetailMenuApiConstant();
  static Future<Map<String, dynamic>?> getMenu({String? category}) async {
    String? token = LocalStorageService.getToken();
    String endpoint = "/menu/all";
    if (category != null) {
      endpoint = "/menu/kategori/$category";
    }
    return await DioService.req(endpoint, method: "GET", token: token);
  }

  static Future<Map<String, dynamic>?> getMenuById(int id) async {
    String? token = LocalStorageService.getToken();
    return await DioService.req("/menu/detail/$id",
        method: "GET", token: token);
  }
}

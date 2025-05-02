import '../../../utils/services/dio_service.dart';
import '../../../utils/services/hive_service.dart';
import '../constants/detail_promo_api_constant.dart';

class DetailPromoRepository {
  DetailPromoRepository._();

  var apiConstant = DetailPromoApiConstant();

  static Future<Map<String, dynamic>?> getPromos({String? type}) async {
    String? token = LocalStorageService.getToken();
    String endpoint = "/promo/all";
    if (type != null) {
      endpoint = "/promo/type/$type";
    }
    return await DioService.req(endpoint, method: "GET", token: token);
  }
static Future<Map<String, dynamic>?> getPromoById(int id) async {
    String? token = LocalStorageService.getToken();
    return await DioService.req("/promo/detail/$id", method: "GET", token: token);
  }
}

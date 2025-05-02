import '../../../utils/services/dio_service.dart';
import '../../../utils/services/hive_service.dart';
import '../constants/home_api_constant.dart';
import '../models/user_detail_model.dart';

class HomeRepository {
  HomeRepository._();

  var apiConstant = HomeApiConstant();

   static Future<UserDetail> getUserDetail(int userId) async {
    final token = LocalStorageService.getToken();
    final response = await DioService.req(
      "user/detail/$userId",
      method: "GET",
      token: token,
    );

    return UserDetail.fromJson(response!);
  }
}

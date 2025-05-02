import '../../../utils/services/dio_service.dart';
import '../constants/sign_in_api_constant.dart';

class SignInRepository {
  SignInRepository._();

  var apiConstant = SignInApiConstant();

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await DioService.req(
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
}

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService extends GetxService {
  static late Box box;

  Future<LocalStorageService> init() async {
    box = await Hive.openBox("venturo");
    return this;
  }

  static Future<void> setAuth({
    required int idUser,
    required String email,
    required String nama,
    required String foto,
    required String roles,
    required Map<String, dynamic> akses,
    required String token,
  }) async {
    await box.put("id_user", idUser);
    await box.put("email", email);
    await box.put("nama", nama);
    await box.put("foto", foto);
    await box.put("roles", roles);
    await box.put("akses", akses);
    await box.put("token", token);
    await box.put("isLogin", true);
  }

  static Future<void> saveLanguagePreference(String languageCode) async {
    await box.put("language_code", languageCode);
  }

  static Future<void> deleteAuth() async {
    box.clear();

    // if (box.get("isRememberMe") == false) {
    //   box.clear();
    // } else {
    //   box.put("isLogin", false);
    //   box.delete("token");
    // }
  }

  static String? getToken() {
    final token = box.get("token");
    return token;
  }

  static Map<String, dynamic> getUserData() {
    final userData = {
      "id_user": box.get("id_user", defaultValue: 0),
      "email": box.get("email", defaultValue: "Tidak ada email"),
      "nama": box.get("nama", defaultValue: "Guest"),
      "foto": box.get("foto", defaultValue: ""),
    };
    return userData;
  }

  static String getLanguagePreference() {
    return box.get("language_code", defaultValue: 'en');
  }
}

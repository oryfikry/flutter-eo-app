import 'package:dio/dio.dart';

class AuthService {
  static String? authToken;
  static Object? authData;
  Future<bool> login({required String email, required String password}) async {
    try {
      var response = await Dio().post(
        "https://uat-api.globaltix.com/api/auth/login",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "username": email,
          "password": password,
        },
      );
      Map res = response.data;
      authToken = res['data']['access_token'];
      authData = res['data'];
      print(res);
      return true;
    } on Exception catch (err) {
      print(err);
      return false;
    }
  }
}

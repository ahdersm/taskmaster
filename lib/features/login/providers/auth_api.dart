import 'package:taskmaster/shared/providers/api/api_client.dart';

class AuthApi {
  final ApiClient api;

  AuthApi(this.api);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await api.dio.post("/api/account/login", data: {
      "email": email,
      "password": password,
    });
    print("Response: ${response.data["accessToken"]}");
    return response.data;
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final response = await api.dio.post("/api/account/refreshtoken", data: {
      "refresh_token": refreshToken,
    });

    return response.data;
  }
}
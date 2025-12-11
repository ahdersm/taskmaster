import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskmaster/features/login/providers/auth_api.dart';

class AuthRepository {
  final AuthApi api;
  final storage = FlutterSecureStorage();

  AuthRepository(this.api);

  Future<bool> login(String email, String password) async {
    final data = await api.login(email, password);

    await storage.write(key: "access_token", value: data["access_token"]);
    await storage.write(key: "refresh_token", value: data["refresh_token"]);

    return true;
  }
}
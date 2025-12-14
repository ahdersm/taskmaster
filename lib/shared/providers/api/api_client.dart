import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  ApiClient() {
    dio.options.baseUrl = "https://10.0.2.2:8081";
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await storage.read(key: "access_token");
        if (access != null) {
          options.headers["Authorization"] = "Bearer $access";
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Check for 401 Unauthorized
        if (error.response?.statusCode == 401) {
          final refresh = await storage.read(key: "refresh_token");
          
          if (refresh != null) {
            try {
              final newTokens = await _refreshToken(refresh);

              await storage.write(key: "access_token", value: newTokens["access"]);
              await storage.write(key: "refresh_token", value: newTokens["refresh"]);

              // Retry the original request
              error.requestOptions.headers["Authorization"] = 
                "Bearer ${newTokens['access']}";
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);

            } catch (_) {
              // Refresh failed → force logout
              await storage.deleteAll();
            }
          }
        }

        return handler.next(error);
      },
    ));
  }

  Future<Map<String, String>> _refreshToken(String refresh) async {
    final response = await dio.post("/api/Account/RefreshToken", data: {
      "refresh_token": refresh
    });

    return {
      "access": response.data["accessToken"],
      "refresh": response.data["refreshToken"],
    };
  }
}
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();
  final String baseUrl = "https://10.0.2.2:8081";

  ApiClient() {
    dio.options.baseUrl = baseUrl;
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
              final tokenRefreshDio = Dio()..options.baseUrl = baseUrl;
              final tokenRefreshResponse = await tokenRefreshDio.post("/api/Account/RefreshToken", data: {"refresh_token": refresh});
              tokenRefreshDio.close();

              await storage.write(key: "access_token", value: tokenRefreshResponse.data["access"]);
              await storage.write(key: "refresh_token", value: tokenRefreshResponse.data["refresh"]);

              // Retry the original request
              error.requestOptions.headers["Authorization"] = 
                "Bearer ${tokenRefreshResponse.data["access"]}";
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


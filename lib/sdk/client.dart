import 'package:app_anansi_mobile/constants/constants.dart';
import 'package:app_anansi_mobile/services/route_service.dart';
import 'package:dio/dio.dart';
import "package:app_anansi_mobile/services/secure_storage_service.dart";

class DioConfig {
  static BaseOptions options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    contentType: 'application/json',
  );
}

class PublicDioClient {
  static final PublicDioClient _instance = PublicDioClient._internal();
  factory PublicDioClient() => _instance;

  late Dio dio;

  PublicDioClient._internal() {
    dio = Dio(DioConfig.options);
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}

class SecureDioClient {
  static final SecureDioClient _instance = SecureDioClient._internal();
  factory SecureDioClient() => _instance;

  late Dio dio;

  SecureDioClient._internal() {
    dio = Dio(DioConfig.options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService().read("accessToken");
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            await SecureStorageService().deleteAll();
            NavigationService.navigateToLogin();
          }
          return handler.next(e);
        },
      ),
    );
  }
}

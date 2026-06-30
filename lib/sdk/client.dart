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

class AuditConfig {
  static BaseOptions options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    contentType: 'application/json',
  );
}

/// Configuration derived from the React/Axios loanClient setup
class LoanConfig {
  static BaseOptions options = BaseOptions(
    baseUrl: loanBaseUrl, // Make sure to add this to constants.dart
    connectTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: 'application/json',
    headers: {
      'X-API-Key': loanApiKey, // Make sure to add this to constants.dart
    },
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

class AuditDioClient {
  static final AuditDioClient _instance = AuditDioClient._internal();
  factory AuditDioClient() => _instance;

  late Dio dio;

  AuditDioClient._internal() {
    dio = Dio(AuditConfig.options);
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}

class SecureDioClient {
  static final SecureDioClient _instance = SecureDioClient._internal();
  factory SecureDioClient() => _instance;

  late Dio dio;

  SecureDioClient._internal() {
    dio = Dio(DioConfig.options);
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

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

class LoanDioClient {
  static final LoanDioClient _instance = LoanDioClient._internal();
  factory LoanDioClient() => _instance;

  late Dio dio;

  LoanDioClient._internal() {
    dio = Dio(LoanConfig.options);
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          // Captures the 401 error handler routine matching your Axios layout
          if (e.response?.statusCode == 401) {
            // Replicates localStorage.removeItem("auth")
            await SecureStorageService().delete("auth");
            // Replicates window.location.href redirection
            NavigationService.navigateToLogin();
          }
          return handler.next(e);
        },
      ),
    );
  }
}

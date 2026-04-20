import 'package:dio/dio.dart';

class ApiException {
  List<String> getExceptionMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return [
          "Connection Timed Out",
          "It's taking a bit longer than usual to reach our servers. Please check your signal and try again.",
        ];

      case DioExceptionType.connectionError:
        return [
          "Network Unavailable",
          "We couldn't connect to the internet. Please check your data or Wi-Fi connection.",
        ];

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);

      case DioExceptionType.cancel:
        return [
          "Request Cancelled",
          "The transaction was cancelled before it could finish.",
        ];

      case DioExceptionType.badCertificate:
        return [
          "Security Warning",
          "We couldn't verify the secure connection. For your safety, this action was blocked.",
        ];

      default:
        return [
          "Something Went Wrong",
          "We encountered an unexpected error. Don't worry, your funds are safe. Please try again shortly.",
        ];
    }
  }

  List<String> _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;

    // Fintech specific: Try to get the "reason" from your NestJS backend
    String? serverMessage;
    if (responseData is Map<String, dynamic>) {
      // Common NestJS/Express error formats
      serverMessage =
          responseData['message']?.toString() ??
          responseData['error']?.toString();
    }

    switch (statusCode) {
      case 400:
        return [
          "Invalid Details",
          serverMessage ??
              "Some information provided is incorrect. Please review your entries and try again.",
        ];
      case 401:
        return [
          "Session Expired",
          "For your security, you've been signed out. Please log in again to continue.",
        ];
      case 403:
        return [
          "Access Denied",
          serverMessage ?? "You don't have permission to perform this action.",
        ];
      case 404:
        return [
          "Not Found",
          "The resource you're looking for doesn't seem to exist.",
        ];
      case 429: // Common in Fintech
        return [
          "Too Many Requests",
          "You're moving a bit fast! Please wait a moment before trying again.",
        ];
      case 500:
      case 502:
      case 503:
        return [
          "Service Maintenance",
          "Our servers are currently undergoing a quick update. Please try again in a few minutes.",
        ];
      default:
        return [
          "Service Error",
          serverMessage ??
              "We're having trouble reaching our services. Please contact support if this persists.",
        ];
    }
  }
}

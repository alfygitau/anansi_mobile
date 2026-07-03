import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class NotificationService {
  final Dio _secureClient = SecureDioClient().dio;
  final Dio _loanClient = LoanDioClient().dio;

  Future<(Response?, List<String>?)> notifications() async {
    try {
      final response = await _secureClient.get('/notification');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> loanNotifications({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/notifications/in-app',
        queryParameters: {"org_code": "BA208", "customer_id": customerId},
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> readLoanNotification({
    required String notificationId,
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.patch(
        '/notifications/in-app/$notificationId/read',
        queryParameters: {"customer_id": customerId},
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> readNotification({
    required String id,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/notification/$id',
        data: {"is_read": true},
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }
}

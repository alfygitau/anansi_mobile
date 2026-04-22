import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class RecoveryService {
  final Dio _publicClient = PublicDioClient().dio;

  Future<(Response?, List<String>?)> forgetEmail({
    required String email,
  }) async {
    try {
      final response = await _publicClient.post(
        '/customer/forgot-password',
        data: {"email": email, "isEmail": true},
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

  Future<(Response?, List<String>?)> forgetMobileNumber({
    required String mobileno,
  }) async {
    try {
      final response = await _publicClient.post(
        '/otp/by-mobile',
        data: {"mobileno": mobileno},
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

  Future<(Response?, List<String>?)> verifyEmailAddress({
    required String otp,
    required String email,
  }) async {
    try {
      final response = await _publicClient.post(
        '/otp/verify-otp',
        data: {"otp": otp, "isEmail": true, "email": email},
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

  Future<(Response?, List<String>?)> verifyMobileNumber({
    required String otp,
    required String mobileno,
  }) async {
    try {
      final response = await _publicClient.post(
        '/otp/verify-otp',
        data: {"otp": otp, "isEmail": false, "mobileno": mobileno},
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

  Future<(Response?, List<String>?)> setNewPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _publicClient.post(
        '/customer/reset-password-web',
        data: {'email': email, 'password': password},
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

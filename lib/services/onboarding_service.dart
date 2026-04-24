import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class OnboardingService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> createProfile({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final response = await _secureClient.post(
        '/customer',
        data: {
          "mobileno": phoneNumber,
          "email": email,
          "username": username,
          "password": password,
          "onboarding_stage": "registration",
        },
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

  Future<(Response?, List<String>?)> resendEmailOtp({
    required String userId,
  }) async {
    try {
      final response = await _secureClient.post(
        '/otp',
        data: {"userId": userId, "isEmail": true},
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

  Future<(Response?, List<String>?)> sendMobileOtp({
    required String userId,
  }) async {
    try {
      final response = await _secureClient.post(
        '/otp',
        data: {"userId": userId, "isEmail": false},
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
    required String mobile,
  }) async {
    try {
      final response = await _secureClient.post(
        '/otp/verify-otp',
        data: {"otp": otp, "isEmail": false, "phoneNumber": mobile},
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

  Future<(Response?, List<String>?)> updateCustomerVerification({
    required String id,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          "phoneVerified": true,
          "emailVerified": true,
          "onboarding_stage": "account-success",
        },
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

  Future<(Response?, List<String>?)> getCustomer({required String id}) async {
    try {
      final response = await _secureClient.get('/customer/$id');
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

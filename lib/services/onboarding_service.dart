import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/helpers/iso_date.dart';
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

  Future<(Response?, List<String>?)> updateIdentity({
    required String id,
    required String firstName,
    required String middleName,
    required String lastName,
    required String idNumber,
    required String gender,
    required String birthDate,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          'firstname': firstName,
          if (middleName.length > 1) 'middlename': middleName,
          'lastname': lastName,
          'identification': idNumber,
          'gender': gender,
          if (birthDate.isNotEmpty) 'dob': convertToISODate(birthDate),
          'onboarding_stage': "facial-identity",
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

  Future<(Response?, List<String>?)> updateIdType({
    required String id,
    required String idType,
    required String citizenship,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          "identification_type": idType,
          'onboarding_stage': 'review-identity',
          "citizenship": citizenship,
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

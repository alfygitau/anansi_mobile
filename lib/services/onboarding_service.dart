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
}

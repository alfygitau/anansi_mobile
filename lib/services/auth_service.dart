import 'package:app_anansi_mobile/helpers/device_info.dart';
import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _publicClient = PublicDioClient().dio;

  Future<(Response?, List<String>?)> login({
    required String email,
    required String password,
  }) async {
    final deviceId = await getDeviceId();
    final userAgent = await getUserAgent();
    try {
      final response = await _publicClient.post(
        '/customer/login',
        data: {
          'email': email,
          'password': password,
          "platform": "Mobile",
          "userAgent": userAgent,
          "deviceId": deviceId,
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

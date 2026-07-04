import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class StatementService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> getStatements({
    String? year,
    String? accountId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (year != null) queryParams['year'] = year;
      if (accountId != null) queryParams['account_id'] = accountId;
      final response = await _secureClient.get(
        '/statement',
        queryParameters: queryParams,
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

  Future<(Response?, List<String>?)> generateStatement({
    String? duration,
    String? accountId,
  }) async {
    try {
      final response = await _secureClient.post(
        '/statement',
        data: {"account_id": accountId, "duration": duration},
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

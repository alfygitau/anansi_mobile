import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class LoanApplicationService {
  final Dio _loanClient = LoanDioClient().dio;

  Future<(Response?, List<String>?)> listLoanApplications({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loan-applications',
        queryParameters: {'customer_id': customerId, 'loan_org_code': "BA208"},
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

  Future<(Response?, List<String>?)> listActiveLoanApplications({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loan-applications/my',
        queryParameters: {'customer_id': customerId, 'loan_org_code': "BA208"},
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

  Future<(Response?, List<String>?)> listLoanApplication({
    required String appId,
  }) async {
    try {
      final response = await _loanClient.get('/loan-applications/$appId');
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

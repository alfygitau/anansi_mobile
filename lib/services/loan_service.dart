import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class LoanService {
  final Dio _loanClient = LoanDioClient().dio;

  Future<(Response?, List<String>?)> listLoans({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loans',
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

  Future<(Response?, List<String>?)> getLoan({required String loanId}) async {
    try {
      final response = await _loanClient.get('/loans/$loanId');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> getLoanTransactions({
    required String loanId,
  }) async {
    try {
      final response = await _loanClient.get('/loans/$loanId/repayments');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> listActiveLoans({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loans/my',
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
}

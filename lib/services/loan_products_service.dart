import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class LoanProductsService {
  final Dio _loanClient = LoanDioClient().dio;

  Future<(Response?, List<String>?)> listLoanProducts() async {
    try {
      final response = await _loanClient.get(
        '/loan-products',
        queryParameters: {'loan_org_code': "BA208"},
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

  Future<(Response?, List<String>?)> listLoanProduct({
    required String productId,
  }) async {
    try {
      final response = await _loanClient.get('/loan-products/$productId');
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

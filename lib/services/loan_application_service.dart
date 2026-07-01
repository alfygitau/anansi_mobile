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

  Future<(Response?, List<String>?)> checkEligibility({
    required String productId,
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.post(
        '/loan-applications/check-eligibility',
        data: {"customer_id": customerId, "loan_product_id": productId},
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

  Future<(Response?, List<String>?)> createApplication({
    required String productId,
    required String customerId,
    required String amount,
    required String duration,
    required String applicantName,
    required String applicantMobile,
    required String purpose,
  }) async {
    try {
      final response = await _loanClient.post(
        '/loan-applications',
        data: {
          'customer_id': customerId,
          'applicant_name': applicantName,
          'applicant_mobile': applicantMobile,
          'loan_product_id': productId,
          'applied_amount': amount,
          'loan_period': duration,
          'loan_channel': "WEB",
          'loan_org_code': "BA208",
          'loan_purpose': purpose,
          'currency': "KES",
        },
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Application Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> acceptTermsConditions({
    required String applicationId,
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.patch(
        '/loan-applications/$applicationId/accept-terms',
        data: {"customer_id": customerId},
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Application Error!", "An unknown error occurred."]);
    }
  }
}

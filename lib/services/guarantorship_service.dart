import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class GuarantorshipService {
  final Dio _loanClient = LoanDioClient().dio;

  Future<(Response?, List<String>?)> guarantorRequests({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loan-applications/guarantor-requests',
        queryParameters: {"customer_id": customerId},
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

  Future<(Response?, List<String>?)> guarantorshipSummary({
    required String customerId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loan-applications/guarantorship/eligibility',
        queryParameters: {"customer_id": customerId},
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

  Future<(Response?, List<String>?)> respondToGuarantor({
    required String customerId,
    required String requestor,
    required String decision,
    required String amount,
    required String reason,
  }) async {
    try {
      final response = await _loanClient.patch(
        '/loan-applications/guarantor-requests/$requestor/respond',
        queryParameters: {"customer_id": customerId},
        data: {
          "decision": decision,
          "amount_guaranteed": amount,
          "reason": reason,
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

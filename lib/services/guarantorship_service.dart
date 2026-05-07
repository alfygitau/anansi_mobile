import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class GuarantorshipService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> guarantorRequests() async {
    try {
      final response = await _secureClient.get(
        '/guarantors/guarantor-requests',
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

  Future<(Response?, List<String>?)> guarantorshipSummary() async {
    try {
      final response = await _secureClient.get('/guarantors/eligibility');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> respondToGuarantor(
    {
    required String guarantor,
    required String requestor,
    required bool isAccepted,
    required String status,
    required String amount,
    required String reason,
  }
  ) async {
    try {
      final response = await _secureClient.post(
        '/guarantors/$guarantor/respond/$requestor',
        data: {
          "isAccepted": isAccepted,
          "status": status,
          "amountGuaranteed": amount,
          "responseReason": reason,
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

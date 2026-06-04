import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:app_anansi_mobile/services/biometric_service.dart';
import 'package:dio/dio.dart';

class AuditService {
  final Dio _auditClient = AuditDioClient().dio;

  Future<(Response?, List<String>?)> addAuditAction({
    required String category,
    required String actionCode,
    required String description,
    required String page,
    required String tab,
    required String section,
    required String memberId,
  }) async {
    final user = await BiometricService().getUser();
    try {
      final response = await _auditClient.post(
        '/audit/business',
        data: {
          "category": category,
          "actionCode": actionCode,
          "description": description,
          "username": user?['username'] ?? "Guest",
          "page": page,
          "tab": tab,
          "section": section,
          "memberId": user?['public_id'] ?? "",
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

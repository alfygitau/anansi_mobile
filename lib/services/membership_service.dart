import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class MembershipService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> payMembership({
    required String reference,
    required String id,
    required double shares,
    required double savings,
    required String mobile,
  }) async {
    try {
      final response = await _secureClient.post(
        '/transaction/register-shares-save',
        data: {
          "category": "credit",
          "type": "membership",
          "amount": 0,
          "ref_number": reference,
          "note": "Membership registration fees",
          "customer_id": id,
          "membershipAmount": 1000,
          "sharesAmount": shares,
          "savingsAmount": savings,
          "phone_number": mobile,
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

  Future<(Response?, List<String>?)> confirmMembership() async {
    try {
      final response = await _secureClient.get(
        '/transaction/has-completed-membership',
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

import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class AccountService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> customerDetails() async {
    try {
      final response = await _secureClient.get('/customer/details');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> accounts({
    required String accountId,
  }) async {
    try {
      final response = await _secureClient.get('/account/$accountId');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> transactions({
    required String accountNumber,
  }) async {
    try {
      final response = await _secureClient.get(
        '/transaction/account/$accountNumber',
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

  Future<(Response?, List<String>?)> sharesSummary({
    required String publicId,
  }) async {
    try {
      final response = await _secureClient.get(
        '/shares/member/$publicId/summary',
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

  Future<(Response?, List<String>?)> buyShares({
    required String amount,
    required String reference,
    required String accountId,
    required String mobileNumber,
  }) async {
    try {
      final response = await _secureClient.post(
        '/transaction/deposit',
        data: {
          "amount": double.parse(amount),
          "ref_number": reference,
          "account_id": accountId,
          "mpesa_msisdn": mobileNumber,
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

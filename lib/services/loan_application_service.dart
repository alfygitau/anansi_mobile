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

  Future<(Response?, List<String>?)> addGuarantor({
    required String applicationId,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _loanClient.post(
        '/loan-applications/$applicationId/guarantors',
        data: {"phone": phone, "name": name},
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

  Future<(Response?, List<String>?)> commitGuarantor({
    required String applicationId,
  }) async {
    try {
      final response = await _loanClient.patch(
        '/loan-applications/$applicationId/guarantors/commit',
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

  Future<(Response?, List<String>?)> fetchGuarantors({
    required String applicationId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loan-applications/$applicationId/guarantors',
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

  Future<(Response?, List<String>?)> removeGuarantors({
    required String applicationId,
    required String guarantorId,
  }) async {
    try {
      final response = await _loanClient.delete(
        '/loan-applications/$applicationId/guarantors/$guarantorId',
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

  Future<(Response?, List<String>?)> addChattel({
    required String applicationId,
    required String assetName,
    required String assetValue,
    required String assetCategory,
    required List<String> imagePaths,
    required List<String> docPaths,
  }) async {
    try {
      final List<MultipartFile> imageMultipartFiles = await Future.wait(
        imagePaths.map((path) async {
          return await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          );
        }),
      );

      final List<MultipartFile> docMultipartFiles = await Future.wait(
        docPaths.map((path) async {
          return await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          );
        }),
      );
      // 2. Attach the lists directly to your FormData payload keys
      final FormData formData = FormData.fromMap({
        "asset_name": assetName,
        "asset_category": assetCategory,
        "estimated_value": assetValue,
        "images": imageMultipartFiles, // Sends as a multi-part array
        "documents": docMultipartFiles, // Sends as a multi-part array
      });

      // 3. Fire the request
      final response = await _loanClient.post(
        '/loan-applications/$applicationId/chattels',
        data: formData,
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

  Future<(Response?, List<String>?)> removeChattel({
    required String applicationId,
    required String chattelId,
  }) async {
    try {
      final response = await _loanClient.delete(
        '/loan-applications/$applicationId/chattels/$chattelId',
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

  Future<(Response?, List<String>?)> fetchChattels({
    required String applicationId,
  }) async {
    try {
      final response = await _loanClient.get(
        '/loan-applications/$applicationId/chattels',
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

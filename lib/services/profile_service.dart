import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> profileInformation() async {
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

  Future<(Response?, List<String>?)> updateAddress({
    required String id,
    required String county,
    required String physicalAddress,
    required String subcounty,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/address/$id',
        data: {
          "physical_address": physicalAddress,
          "county": county,
          "subcounty": subcounty,
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

  Future<(Response?, List<String>?)> updateFinancials({
    required String id,
    required String employmentType,
    required String kra,
    required String jobTitle,
    required String income,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          "employment_type": employmentType,
          "kraPin": kra,
          "occupation": jobTitle,
          "income_range": income,
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

  Future<(Response?, List<String>?)> updateKin({
    required String id,
    required String fullName,
    required String birthDate,
    required String relationship,
    required String phone,
    required String location,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/next-of-kin/$id',
        data: {
          "name": fullName,
          "dateOfBirth": birthDate,
          "relationship": relationship,
          "phoneNumber": phone,
          "location": location,
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

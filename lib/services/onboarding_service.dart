import 'dart:io';

import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/helpers/iso_date.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class OnboardingService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> createProfile({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final response = await _secureClient.post(
        '/customer',
        data: {
          "mobileno": phoneNumber,
          "email": email,
          "username": username,
          "password": password,
          "onboarding_stage": "registration",
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

  Future<(Response?, List<String>?)> resendEmailOtp({
    required String userId,
  }) async {
    try {
      final response = await _secureClient.post(
        '/otp',
        data: {"userId": userId, "isEmail": true},
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

  Future<(Response?, List<String>?)> sendMobileOtp({
    required String userId,
  }) async {
    try {
      final response = await _secureClient.post(
        '/otp',
        data: {"userId": userId, "isEmail": false},
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

  Future<(Response?, List<String>?)> verifyMobileNumber({
    required String otp,
    required String mobile,
  }) async {
    try {
      final response = await _secureClient.post(
        '/otp/verify-otp',
        data: {"otp": otp, "isEmail": false, "phoneNumber": mobile},
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

  Future<(Response?, List<String>?)> updateCustomerVerification({
    required String id,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          "phoneVerified": true,
          "emailVerified": true,
          "onboarding_stage": "account-success",
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

  Future<(Response?, List<String>?)> updateIdentity({
    required String id,
    required String firstName,
    required String middleName,
    required String lastName,
    required String idNumber,
    required String gender,
    required String birthDate,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          'firstname': firstName,
          if (middleName.length > 1) 'middlename': middleName,
          'lastname': lastName,
          'identification': idNumber,
          'gender': gender,
          if (birthDate.isNotEmpty) 'dob': convertToISODate(birthDate),
          'onboarding_stage': "facial-identity",
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

  Future<(Response?, List<String>?)> updateIdType({
    required String id,
    required String idType,
    required String citizenship,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          "identification_type": idType,
          'onboarding_stage': 'review-identity',
          "citizenship": citizenship,
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

  Future<(Response?, List<String>?)> updateSelfie({
    required String id,
    required String url,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {'selfie_image': url, 'onboarding_stage': "personal-information"},
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

  Future<(Response?, List<String>?)> updateIdImages({
    required String id,
    required File frontImage,
    required File backImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'id_front_image': await MultipartFile.fromFile(
          frontImage.path,
          filename: 'id_front_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'id_back_image': await MultipartFile.fromFile(
          backImage.path,
          filename: 'id_back_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
        'onboarding_stage': "id-verification",
      });
      final response = await _secureClient.patch(
        '/customer/$id/id-images',
        data: formData,
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (
        null,
        ["File Upload Error!", "Could not send ID images to the server."],
      );
    }
  }

  Future<(Response?, List<String>?)> updateCustomerStatuses({
    required String id,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {"onboarding_stage": "completed", "status": "Active"},
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
    required String countryOfResidence,
    required String employmentType,
    required String kra,
    required String jobTitle,
    required String income,
  }) async {
    try {
      final response = await _secureClient.patch(
        '/customer/$id',
        data: {
          "onboarding_stage": "nextOfKin",
          "country_of_residence": countryOfResidence,
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

  Future<(Response?, List<String>?)> addKin({
    required String id,
    required String fullName,
    required String birthDate,
    required String relationship,
    required String phone,
    required String location,
  }) async {
    try {
      final response = await _secureClient.post(
        '/customer/$id/next-of-kin',
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

  String _clean(dynamic value) {
    if (value == null) return "";
    final String str = value.toString().trim();
    return (str.isEmpty || str.toLowerCase().startsWith('select')) ? "" : str;
  }

  Future<(Response?, List<String>?)> createAddress({
    required String id,
    String? physicalAddress,
    String? county,
    String? subcounty,
    String? postalAddress,
    String? city,
    String? state,
    String? street,
    String? zipcode,
  }) async {
    try {
      final response = await _secureClient.post(
        '/address',
        data: {
          "postal_address": _clean(postalAddress),
          "physical_address": _clean(physicalAddress),
          "city": _clean(city),
          "state": _clean(state),
          "land_mark": "",
          "street": _clean(street),
          "zip_code": _clean(zipcode),
          "customer_id": id,
          "county": _clean(county),
          "subcounty": _clean(subcounty),
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

  Future<(Response?, List<String>?)> getCustomer({required String id}) async {
    try {
      final response = await _secureClient.get('/customer/$id');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> getCounties() async {
    try {
      final response = await _secureClient.get('/county');
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Authentication Error!", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> getStates() async {
    try {
      final response = await _secureClient.get('/us-states');
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

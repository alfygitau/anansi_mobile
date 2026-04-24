import 'dart:io';
import 'package:app_anansi_mobile/helpers/errors.dart';
import 'package:app_anansi_mobile/sdk/client.dart';
import 'package:dio/dio.dart';

class OcrService {
  final Dio _secureClient = SecureDioClient().dio;

  Future<(Response?, List<String>?)> extractFrontIdDetails({
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.path,
          filename: "front_id_file",
        ),
      });

      final response = await _secureClient.post(
        '/kyc-validation/kenya-id',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Unexpected Error", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> extractBackIdDetails({
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.path,
          filename: "back_id_file",
        ),
      });

      final response = await _secureClient.post(
        '/kyc-validation/kenya-id/back',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Unexpected Error", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> uploadSelfie({
    required File file,
    required String id,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: "selfie_file",
        ),
      });
      final response = await _secureClient.post(
        '/customer/$id/selfie-image',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Unexpected Error", "An unknown error occurred."]);
    }
  }

  Future<(Response?, List<String>?)> uploadSingleFile({
    required File file,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: "upload_file",
        ),
      });
      final response = await _secureClient.post(
        '/file-upload',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return (response, null);
    } on DioException catch (e) {
      final apiException = ApiException();
      final errorMessages = apiException.getExceptionMessage(e);
      return (null, errorMessages);
    } catch (e) {
      return (null, ["Unexpected Error", "An unknown error occurred."]);
    }
  }
}

import 'package:dio/dio.dart';
import 'package:mobile_test/env/Env.dart';
import 'package:mobile_test/models/allCharacters.dart';

class CharacterController {
  static final Dio _dio = Dio();

  Future<AllCharacters> getAllCharacters({String? next}) async {
    try {
      late var response;
      if (next == null) {
        response = await _dio.get('${baseURL}/character');
      } else {
        response = await _dio.get(next);
      }

      return AllCharacters.fromJson(response.data);
    } on DioError {
      rethrow;
    }
  }

  Future<AllCharacters> getFilterCharacters(
      {required String type, required String value}) async {
    try {
      late var response;
      if (value.isEmpty) {
        response = await _dio.get('${baseURL}/character');
      } else {
        response = await _dio.get('${baseURL}/character/?${type}=${value}');
      }

      return AllCharacters.fromJson(response.data);
    } on DioError {
      rethrow;
    }
  }
}

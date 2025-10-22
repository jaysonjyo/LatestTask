import 'package:dio/dio.dart';
import '../models/auth_model.dart';


abstract class AuthRemoteDataSource {
  Future<AuthModel> signIn({required String countryCode, required String phone});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final String baseUrl;
  AuthRemoteDataSourceImpl(this.dio, {required this.baseUrl});

  @override
  Future<AuthModel> signIn({required String countryCode, required String phone}) async {
    final url = '$baseUrl/otp_verified'; // ✅ correct endpoint
    try {
      final response = await dio.post(
        url,
        data: {
          'country_code': countryCode,
          'phone': phone,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 202 || response.statusCode == 200) {
        return AuthModel.fromJson(response.data);
      } else {
        print("response.statusCode${response.statusCode}");
        throw Exception('Failed: ${response.statusCode}');

      }
    } catch (e) {
      print('❌ AuthRemoteDataSourceImpl.signIn error: $e');
      rethrow;
    }
  }
}

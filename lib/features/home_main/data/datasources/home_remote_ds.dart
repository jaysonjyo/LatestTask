import 'package:dio/dio.dart';

import '../../../../demo.dart';
import '../models/home_model.dart';

class HomeRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  HomeRemoteDataSource(this.dio, {required this.baseUrl});

  Future<HomeModel> fetchHomeData(String token) async {
    final response = await dio.get(
        '$baseUrl/v1/home',
     // '$baseUrl/home',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return HomeModel.fromJson(response.data);
  }
}

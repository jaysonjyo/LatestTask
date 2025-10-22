import 'package:dio/dio.dart';
import '../models/my_feed_model.dart';

class MyFeedRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  MyFeedRemoteDataSource(this.dio, {required this.baseUrl});

  Future<MyFeedModelClass> fetchMyFeeds(String token) async {
    final response = await dio.get(
      '$baseUrl/my_feed',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return MyFeedModelClass.fromJson(response.data);
  }
}

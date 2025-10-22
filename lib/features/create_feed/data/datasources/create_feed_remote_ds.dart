import 'dart:io';
import 'package:dio/dio.dart';
import '../models/create_feed_model.dart';

abstract class CreateFeedRemoteDataSource {
  Future<CreateFeedModel> createFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required String accessToken,
  });
}

class CreateFeedRemoteDataSourceImpl implements CreateFeedRemoteDataSource {
  final Dio dio;

  CreateFeedRemoteDataSourceImpl({required this.dio});

  @override
  Future<CreateFeedModel> createFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required String accessToken,
  }) async {
    final formData = FormData.fromMap({
      "video": await MultipartFile.fromFile(video.path),
      "image": await MultipartFile.fromFile(image.path),
      "desc": desc,
      "category": category.toString(),
    });

    final response = await dio.post(
      "https://frijo.noviindus.in/api/my_feed",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return CreateFeedModel.fromJson(response.data);
  }
}

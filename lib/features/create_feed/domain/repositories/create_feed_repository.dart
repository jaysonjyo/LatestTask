import 'dart:io';
import '../../data/datasources/create_feed_remote_ds.dart';
import '../../data/repositories/create_feed_repository_impl.dart';
import '../../domain/entities/feed_entity.dart';


class CreateFeedRepositoryImpl implements CreateFeedRepository {
  final CreateFeedRemoteDataSource remoteDataSource;

  CreateFeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FeedEntity> createFeed({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required String accessToken,
  }) {
    return remoteDataSource.createFeed(
      video: video,
      image: image,
      desc: desc,
      category: category,
      accessToken: accessToken,
    );
  }
}

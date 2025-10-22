import 'dart:io';
import '../../data/repositories/create_feed_repository_impl.dart';
import '../entities/feed_entity.dart';
import '../repositories/create_feed_repository.dart';

class CreateFeed {
  final CreateFeedRepository repository;

  CreateFeed(this.repository);

  Future<FeedEntity> call({
    required File video,
    required File image,
    required String desc,
    required List<int> category,
    required String accessToken,
  }) {
    return repository.createFeed(
      video: video,
      image: image,
      desc: desc,
      category: category,
      accessToken: accessToken,
    );
  }
}
